Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 323604E9EA
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 15:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfFUNvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 09:51:09 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:10953 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfFUNvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 09:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561125068; x=1592661068;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=C+sXxE5wltRCqQPtfL6EgnUHxc+zHyOsxU31yV7v5MQ=;
  b=XSA2oUZFPJvS98aAfBdqdQzHe+5F/yVrl/5SOM9UreVnPzYrPt50ljK9
   /AgQqBzPhjBC/0qCpBCKZjGcSzAPkVS1HvnVYFxFMpOWjquw5PNxrwCo5
   JndRY7X4SDoQ8B1PE14gbZOchezKNE6t8xgzJNPvE2o+K0ZosGo8flSGQ
   I=;
X-IronPort-AV: E=Sophos;i="5.62,400,1554768000"; 
   d="scan'208";a="738550787"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 21 Jun 2019 13:51:07 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 48FA0A298F;
        Fri, 21 Jun 2019 13:51:02 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Jun 2019 13:51:01 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.8) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Jun 2019 13:50:57 +0000
Subject: Re: [v2, 4/4] Added scripts for filtering, building, deploying
To:     Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <karahmed@amazon.de>, <andrew.cooper3@citrix.com>,
        <JBeulich@suse.com>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <paullangton4@gmail.com>,
        <anirudhkaushik@google.com>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20190612153600.13073-1-samcacc@amazon.de>
 <20190612153600.13073-5-samcacc@amazon.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <74357ba4-c0d9-4b31-ec93-b8ec8c332c8d@amazon.com>
Date:   Fri, 21 Jun 2019 15:50:54 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190612153600.13073-5-samcacc@amazon.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.8]
X-ClientProxiedBy: EX13P01UWA001.ant.amazon.com (10.43.160.213) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12.06.19 17:36, Sam Caccavale wrote:
> bin.sh produces output which diagnoses whether the crash was expected.
> coalesce.sh, gen_output.sh, and summarize.sh are useful for parsing
> the large crash directories that afl produces.
> deploy_remote.sh does all of the setup to launch a fuzz run via
> install_deps_ubuntu.sh, install_afl.sh, build.sh, and run.sh.
> rebuild.sh cleans the directories and executes build.sh
> ---
>   tools/fuzz/x86ie/scripts/afl-many             |  6 +--
>   tools/fuzz/x86ie/scripts/bin.sh               | 49 +++++++++++++++++++
>   tools/fuzz/x86ie/scripts/build.sh             | 32 ++++++++++++
>   tools/fuzz/x86ie/scripts/coalesce.sh          |  6 +++
>   tools/fuzz/x86ie/scripts/deploy.sh            |  9 ++++
>   tools/fuzz/x86ie/scripts/deploy_remote.sh     |  9 ++++
>   tools/fuzz/x86ie/scripts/gen_output.sh        | 11 +++++
>   tools/fuzz/x86ie/scripts/install_afl.sh       | 14 ++++++
>   .../fuzz/x86ie/scripts/install_deps_ubuntu.sh |  5 ++
>   tools/fuzz/x86ie/scripts/rebuild.sh           |  6 +++
>   tools/fuzz/x86ie/scripts/run.sh               | 10 ++++
>   tools/fuzz/x86ie/scripts/summarize.sh         |  9 ++++
>   12 files changed, 163 insertions(+), 3 deletions(-)
>   create mode 100755 tools/fuzz/x86ie/scripts/bin.sh
>   create mode 100755 tools/fuzz/x86ie/scripts/build.sh
>   create mode 100755 tools/fuzz/x86ie/scripts/coalesce.sh
>   create mode 100644 tools/fuzz/x86ie/scripts/deploy.sh
>   create mode 100755 tools/fuzz/x86ie/scripts/deploy_remote.sh
>   create mode 100755 tools/fuzz/x86ie/scripts/gen_output.sh
>   create mode 100755 tools/fuzz/x86ie/scripts/install_afl.sh
>   create mode 100755 tools/fuzz/x86ie/scripts/install_deps_ubuntu.sh
>   create mode 100755 tools/fuzz/x86ie/scripts/rebuild.sh
>   create mode 100755 tools/fuzz/x86ie/scripts/run.sh
>   create mode 100755 tools/fuzz/x86ie/scripts/summarize.sh
> 
> diff --git a/tools/fuzz/x86ie/scripts/afl-many b/tools/fuzz/x86ie/scripts/afl-many
> index ab15258573a2..3fe6423309a6 100755
> --- a/tools/fuzz/x86ie/scripts/afl-many
> +++ b/tools/fuzz/x86ie/scripts/afl-many
> @@ -19,10 +19,10 @@ while [ -z "$sync_dir" ]; do
>   done
> 
>   for i in $(seq 1 $(( ${NPROC:-$(nproc)} - 1)) ); do
> -    taskset -c "$i" ./afl-fuzz -S "slave$i" $@ >/dev/null 2>&1 &
> +    taskset -c "$i" $AFLPATH/afl-fuzz -S "slave$i" $@ >/dev/null 2>&1 &
>   done
> -taskset -c 0 ./afl-fuzz -M master $@ >/dev/null 2>&1 &
> +taskset -c 0 $AFLPATH/afl-fuzz -M master $@ >/dev/null 2>&1 &
> 
>   sleep 5
> -watch -n1 "echo \"Executing './afl-fuzz $@' on ${NPROC:-$(nproc)} cores.\" && ./afl-whatsup -s ${sync_dir}"
> +watch -n1 "echo \"Executing 'AFLPATH/afl-fuzz $@' on ${NPROC:-$(nproc)} cores.\" && $AFLPATH/afl-whatsup -s 

This is missing a $ sign.

${sync_dir}"
>   pkill afl-fuzz
> diff --git a/tools/fuzz/x86ie/scripts/bin.sh b/tools/fuzz/x86ie/scripts/bin.sh
> new file mode 100755
> index 000000000000..6383a883ff33
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/bin.sh
> @@ -0,0 +1,49 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +
> +if [ "$#" -lt 3 ]; then
> +  echo "Usage: './bin path/to/afl-harness path/to/afl_crash [path/to/linux/src/root]'"
> +  exit
> +fi
> +
> +export AFL_HARNESS="$1"
> +export LINUX_SRC="$3"
> +
> +diagnose_segfault() {
> +  SOURCE=$(gdb -batch -ex r -ex 'bt 2' --args $@ 2>&1 | grep -Po '#1.* \K([^ ]+:[0-9]+)');
> +  IFS=: read FILE LINE <<< "$SOURCE"
> +
> +  OP="$(sed -n "${LINE}p" "$LINUX_SRC/$FILE" 2>/dev/null)"
> +  if [ $? -ne 0 ]; then
> +    OP="$(sed -n "${LINE}p" "$LINUX_SRC/tools/fuzz/x86_instruction_emulation/$FILE" 2>/dev/null)"
> +  fi
> +
> +  OP="$(echo $OP | grep -Po 'ops->\K([^(]+)')"
> +  if [ -z "$OP" ]; then
> +    echo "SEGV: unknown, in $FILE:$LINE"
> +  else
> +    echo "Expected: segfaulting on emulator->$OP"
> +  fi
> +}
> +export -f diagnose_segfault
> +
> +bin() {
> +  OUTPUT=$(bash -c "timeout 1s $AFL_HARNESS $1 2>&1" 2>&1)
> +  RETVAL=$?
> +
> +  echo "$OUTPUT"
> +  if [ $RETVAL -eq 0 ]; then
> +    echo "Terminated successfully"
> +  elif [ $RETVAL -eq 124 ]; then
> +    echo "Unknown: killed due to timeout.  Loop likely."
> +  elif echo "$OUTPUT" | grep -q "SEGV"; then
> +    echo "$(diagnose_segfault $AFL_HARNESS $1)"
> +  elif echo "$OUTPUT" | grep -q "FPE"; then
> +    echo "Expected: floating point exception."
> +  else
> +    echo "Unknown cause of crash."
> +  fi
> +}
> +export -f bin
> +
> +echo "$(bin $2 2>&1)"
> diff --git a/tools/fuzz/x86ie/scripts/build.sh b/tools/fuzz/x86ie/scripts/build.sh
> new file mode 100755
> index 000000000000..74b893f222c1
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/build.sh
> @@ -0,0 +1,32 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +
> +kernel_objects="arch/x86/kvm/emulate.o arch/x86/lib/retpoline.o lib/find_bit.o"
> +
> +disable() { sed -i -r "/\b$1\b/c\# $1" .config; }
> +enable() { sed -i -r "/\b$1\b/c\\$1=y" .config; }
> +
> +make ${CC:+ "CC=$CC"} ${DEBUG:+ "DEBUG=1"} defconfig
> +
> +enable "CONFIG_DEBUG_INFO"
> +enable "CONFIG_STACKPROTECTOR"
> +
> +yes ' ' | make ${CC:+ "CC=$CC"} ${DEBUG:+ "DEBUG=1"} $kernel_objects
> +
> +omit_arg () { args=$(echo "$args" | sed "s/ $1//g"); }
> +add_arg () { args+=" $1"; }
> +
> +rebuild () {
> +  args="$(head -1 $(dirname $1)/.$(basename $1).cmd | sed -e 's/.*:= //g')"
> +  omit_arg "-mcmodel=kernel"
> +  omit_arg "-mpreferred-stack-boundary=3"
> +  add_arg "-fsanitize=address"
> +  echo -e "Rebuilding $1 with \n$args"
> +  eval "$args"
> +}
> +
> +for object in $kernel_objects; do
> +  rebuild $object
> +done
> +
> +make ${CC:+ "CC=$CC"} ${DEBUG:+ "DEBUG=1"} tools/fuzz
> diff --git a/tools/fuzz/x86ie/scripts/coalesce.sh b/tools/fuzz/x86ie/scripts/coalesce.sh
> new file mode 100755
> index 000000000000..18c2ca7f2767
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/coalesce.sh
> @@ -0,0 +1,6 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +
> +mkdir -p all
> +rm -rf all/*
> +find . -type f -wholename '*crashes/id*' | parallel cp {} ./all/$(basename $(dirname {//})):{/}
> diff --git a/tools/fuzz/x86ie/scripts/deploy.sh b/tools/fuzz/x86ie/scripts/deploy.sh
> new file mode 100644
> index 000000000000..f95c3aa2b5b5
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/deploy.sh
> @@ -0,0 +1,9 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +
> +REMOTE=$1
> +DSTDIR=/dev/shm
> +
> +rsync -av $(pwd) $REMOTE:$DSTDIR
> +
> +ssh $REMOTE "cd $DSTDIR/$(basename $(pwd)); bash -s tools/fuzz/x86_instruction_emulation/scripts/deploy_remote.sh"

Does this really belong in here?

> diff --git a/tools/fuzz/x86ie/scripts/deploy_remote.sh b/tools/fuzz/x86ie/scripts/deploy_remote.sh
> new file mode 100755
> index 000000000000..e002c5a932f5
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/deploy_remote.sh
> @@ -0,0 +1,9 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +
> +SCRIPTDIR=$(pwd)/tools/fuzz/x86_instruction_emulation/scripts
> +
> +$SCRIPTDIR/install_deps_ubuntu.sh
> +source $SCRIPTDIR/install_afl.sh
> +CC=$AFLPATH/afl-gcc $SCRIPTDIR/build.sh
> +FUZZDIR="${FUZZDIR:-$(pwd)/fuzz}" $SCRIPTDIR/run.sh
> diff --git a/tools/fuzz/x86ie/scripts/gen_output.sh b/tools/fuzz/x86ie/scripts/gen_output.sh
> new file mode 100755
> index 000000000000..6c0707eb6d08
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/gen_output.sh
> @@ -0,0 +1,11 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +
> +if [ "$#" -lt 3 ]; then
> +  echo "Usage: '$0 path/to/afl-harness path/to/afl_crash_dir path/to/linux/src/root'"
> +  exit
> +fi
> +
> +mkdir -p output
> +rm -rf output/*
> +find $2 -type f | parallel ./bin.sh $1 {} $3 '>' ./output/{/}.out
> diff --git a/tools/fuzz/x86ie/scripts/install_afl.sh b/tools/fuzz/x86ie/scripts/install_afl.sh
> new file mode 100755
> index 000000000000..b1c5612eca1c
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/install_afl.sh
> @@ -0,0 +1,14 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +
> +wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
> +mkdir -p afl
> +tar xzf afl-latest.tgz -C afl --strip-components 1
> +
> +pushd afl
> +set AFL_USE_ASAN
> +make clean all
> +export AFLPATH="$(pwd)"
> +popd
> +
> +sudo bash -c "echo core >/proc/sys/kernel/core_pattern"
> diff --git a/tools/fuzz/x86ie/scripts/install_deps_ubuntu.sh b/tools/fuzz/x86ie/scripts/install_deps_ubuntu.sh
> new file mode 100755
> index 000000000000..5525bc8b659c
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/install_deps_ubuntu.sh
> @@ -0,0 +1,5 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +
> +sudo apt update
> +sudo apt install -y make gcc wget screen build-essential libssh-dev flex bison libelf-dev bc

Same as this. This file could bitrot really quick. And it doesn't help 
any non-Ubuntu users.


I think most files in here are not strictly needed. Maybe split this 
patch into one that actually contains all changes necessary to easily 
start a test run and a separate one with all your convencience scripts?


Alex

> diff --git a/tools/fuzz/x86ie/scripts/rebuild.sh b/tools/fuzz/x86ie/scripts/rebuild.sh
> new file mode 100755
> index 000000000000..ecdc5aa52653
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/rebuild.sh
> @@ -0,0 +1,6 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +
> +make clean
> +make tools/fuzz_clean
> +FUZZDIR="./fuzz" ./tools/fuzz/x86_instruction_emulation/scripts/build.sh
> diff --git a/tools/fuzz/x86ie/scripts/run.sh b/tools/fuzz/x86ie/scripts/run.sh
> new file mode 100755
> index 000000000000..9b7d69e0f0f6
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/run.sh
> @@ -0,0 +1,10 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +
> +FUZZDIR="${FUZZDIR:-$(pwd)/fuzz}"
> +
> +mkdir -p $FUZZDIR/in
> +cp tools/fuzz/x86_instruction_emulation/rand_sample.bin $FUZZDIR/in
> +mkdir -p $FUZZDIR/out
> +
> +screen bash -c "ulimit -Sv $[21999999999 << 10]; ./tools/fuzz/x86_instruction_emulation/scripts/afl-many -m 22000000000 -i $FUZZDIR/in -o $FUZZDIR/out tools/fuzz/x86_instruction_emulation/afl-harness @@"
> diff --git a/tools/fuzz/x86ie/scripts/summarize.sh b/tools/fuzz/x86ie/scripts/summarize.sh
> new file mode 100755
> index 000000000000..27761f283ee3
> --- /dev/null
> +++ b/tools/fuzz/x86ie/scripts/summarize.sh
> @@ -0,0 +1,9 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +
> +if [ "$#" -lt 1 ]; then
> +  echo "Usage: '$0 path/to/output/dir'"
> +  exit
> +fi
> +
> +time bash -c "find $1 -type f -exec tail -n 1 {} \; | sort | uniq -c | sort -rn"
> --
> 2.17.1
> 
