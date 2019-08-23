#!/usr/bin/env bash

set -e
set -o pipefail
set -o verbose


cat << EOF >> ${HOME}/.bash_profile
export GOROOT=/opt/go
export GOPATH=${HOME}/go
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
export GO111MODULE=on

export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
EOF

source ${HOME}/.bash_profile && go version && go env

mkdir -p $HOME/.cargo && touch $HOME/.cargo/config

cat << EOF > $HOME/.cargo/config
[source.crates-io]
replace-with = 'ustc'

[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"

EOF

# rust env
curl https://sh.rustup.rs -sSf >> rustup-init.sh \
    && chmod +x rustup-init.sh \
    && ./rustup-init.sh -y --no-modify-path \
    && source $HOME/.cargo/env \
    && rustup show \
    && cargo version

# tool
cargo install fd-find bat hyperfine