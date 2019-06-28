Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1824C59773
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 11:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfF1J1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 05:27:22 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:6495 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfF1J1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 05:27:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1561714037; x=1593250037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=C/tK+eqyZfG3DvgrHIxJojkuSm1mtm+8YcEFaCfljVI=;
  b=cPvbsvWja2/24yNlu/GXN6j/rMdJ4FrrXk5jTSuo2lOGlvAAvLF+ZW0/
   Fjah368Wa1fxUQbKUS7lX9RU1ng5Vydbkw5zgMy2D7clK8buW9VOiesBO
   LdgEEcWvtI52uy2xka1yEENy2Z1JwZiiYZPtqoIzk9n0aLlCL6NznUEdc
   Q=;
X-IronPort-AV: E=Sophos;i="5.62,427,1554768000"; 
   d="scan'208";a="772444188"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 28 Jun 2019 09:27:15 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 1E467A0565;
        Fri, 28 Jun 2019 09:27:11 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 09:26:54 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 09:26:53 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Fri, 28 Jun 2019 09:26:49 +0000
From:   Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sam Caccavale <samcacc@amazon.de>
Subject: [PATCH v4 5/5] Development scripts for crash triage and deploy
Date:   Fri, 28 Jun 2019 11:26:21 +0200
Message-ID: <20190628092621.17823-6-samcacc@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628092621.17823-1-samcacc@amazon.de>
References: <20190628092621.17823-1-samcacc@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Not meant for upstream consumption.

---

v2 -> v3:
 - Introduced this patch as a place for non-essential dev scripts

v3 -> v4:
 - Made deploy_remote.sh use a 1d timeout
 - Removed core dump setup from install_afl.sh
 - Added core dump setup into deploy_remote.sh

Signed-off-by: Sam Caccavale <samcacc@amazon.de>
---
 tools/fuzz/x86ie/scripts/bin.sh               | 49 +++++++++++++++++++
 tools/fuzz/x86ie/scripts/coalesce.sh          |  5 ++
 tools/fuzz/x86ie/scripts/deploy.sh            |  9 ++++
 tools/fuzz/x86ie/scripts/deploy_remote.sh     | 10 ++++
 tools/fuzz/x86ie/scripts/gen_output.sh        | 11 +++++
 tools/fuzz/x86ie/scripts/install_afl.sh       |  2 -
 .../fuzz/x86ie/scripts/install_deps_ubuntu.sh |  5 ++
 tools/fuzz/x86ie/scripts/rebuild.sh           |  6 +++
 tools/fuzz/x86ie/scripts/summarize.sh         |  9 ++++
 9 files changed, 104 insertions(+), 2 deletions(-)
 create mode 100755 tools/fuzz/x86ie/scripts/bin.sh
 create mode 100755 tools/fuzz/x86ie/scripts/coalesce.sh
 create mode 100644 tools/fuzz/x86ie/scripts/deploy.sh
 create mode 100755 tools/fuzz/x86ie/scripts/deploy_remote.sh
 create mode 100755 tools/fuzz/x86ie/scripts/gen_output.sh
 create mode 100755 tools/fuzz/x86ie/scripts/install_deps_ubuntu.sh
 create mode 100755 tools/fuzz/x86ie/scripts/rebuild.sh
 create mode 100755 tools/fuzz/x86ie/scripts/summarize.sh

diff --git a/tools/fuzz/x86ie/scripts/bin.sh b/tools/fuzz/x86ie/scripts/bin.sh
new file mode 100755
index 000000000000..6383a883ff33
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/bin.sh
@@ -0,0 +1,49 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+if [ "$#" -lt 3 ]; then
+  echo "Usage: './bin path/to/afl-harness path/to/afl_crash [path/to/linux/src/root]'"
+  exit
+fi
+
+export AFL_HARNESS="$1"
+export LINUX_SRC="$3"
+
+diagnose_segfault() {
+  SOURCE=$(gdb -batch -ex r -ex 'bt 2' --args $@ 2>&1 | grep -Po '#1.* \K([^ ]+:[0-9]+)');
+  IFS=: read FILE LINE <<< "$SOURCE"
+
+  OP="$(sed -n "${LINE}p" "$LINUX_SRC/$FILE" 2>/dev/null)"
+  if [ $? -ne 0 ]; then
+    OP="$(sed -n "${LINE}p" "$LINUX_SRC/tools/fuzz/x86_instruction_emulation/$FILE" 2>/dev/null)"
+  fi
+
+  OP="$(echo $OP | grep -Po 'ops->\K([^(]+)')"
+  if [ -z "$OP" ]; then
+    echo "SEGV: unknown, in $FILE:$LINE"
+  else
+    echo "Expected: segfaulting on emulator->$OP"
+  fi
+}
+export -f diagnose_segfault
+
+bin() {
+  OUTPUT=$(bash -c "timeout 1s $AFL_HARNESS $1 2>&1" 2>&1)
+  RETVAL=$?
+
+  echo "$OUTPUT"
+  if [ $RETVAL -eq 0 ]; then
+    echo "Terminated successfully"
+  elif [ $RETVAL -eq 124 ]; then
+    echo "Unknown: killed due to timeout.  Loop likely."
+  elif echo "$OUTPUT" | grep -q "SEGV"; then
+    echo "$(diagnose_segfault $AFL_HARNESS $1)"
+  elif echo "$OUTPUT" | grep -q "FPE"; then
+    echo "Expected: floating point exception."
+  else
+    echo "Unknown cause of crash."
+  fi
+}
+export -f bin
+
+echo "$(bin $2 2>&1)"
diff --git a/tools/fuzz/x86ie/scripts/coalesce.sh b/tools/fuzz/x86ie/scripts/coalesce.sh
new file mode 100755
index 000000000000..b15d583c2c32
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/coalesce.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+
+mkdir -p all
+rm -rf all/*
+find . -type f -wholename '*crashes/id*' | parallel 'cp {} ./all/$(basename $(dirname {//})):{/}'
diff --git a/tools/fuzz/x86ie/scripts/deploy.sh b/tools/fuzz/x86ie/scripts/deploy.sh
new file mode 100644
index 000000000000..f95c3aa2b5b5
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/deploy.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+REMOTE=$1
+DSTDIR=/dev/shm
+
+rsync -av $(pwd) $REMOTE:$DSTDIR
+
+ssh $REMOTE "cd $DSTDIR/$(basename $(pwd)); bash -s tools/fuzz/x86_instruction_emulation/scripts/deploy_remote.sh"
diff --git a/tools/fuzz/x86ie/scripts/deploy_remote.sh b/tools/fuzz/x86ie/scripts/deploy_remote.sh
new file mode 100755
index 000000000000..a903294e145a
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/deploy_remote.sh
@@ -0,0 +1,10 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+SCRIPTDIR=$(pwd)/tools/fuzz/x86ie/scripts
+
+$SCRIPTDIR/install_deps_ubuntu.sh
+source $SCRIPTDIR/install_afl.sh
+CC=$AFLPATH/afl-gcc $SCRIPTDIR/build.sh
+sudo bash -c "echo core >/proc/sys/kernel/core_pattern"
+TIMEOUT="${TIMEOUT:-1d}" FUZZDIR="${FUZZDIR:-$(pwd)/fuzz}" $SCRIPTDIR/run.sh
diff --git a/tools/fuzz/x86ie/scripts/gen_output.sh b/tools/fuzz/x86ie/scripts/gen_output.sh
new file mode 100755
index 000000000000..6c0707eb6d08
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/gen_output.sh
@@ -0,0 +1,11 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+if [ "$#" -lt 3 ]; then
+  echo "Usage: '$0 path/to/afl-harness path/to/afl_crash_dir path/to/linux/src/root'"
+  exit
+fi
+
+mkdir -p output
+rm -rf output/*
+find $2 -type f | parallel ./bin.sh $1 {} $3 '>' ./output/{/}.out
diff --git a/tools/fuzz/x86ie/scripts/install_afl.sh b/tools/fuzz/x86ie/scripts/install_afl.sh
index 3bdbdf2a040b..e05e9942cc19 100755
--- a/tools/fuzz/x86ie/scripts/install_afl.sh
+++ b/tools/fuzz/x86ie/scripts/install_afl.sh
@@ -13,5 +13,3 @@ set AFL_USE_ASAN
 make clean all
 export AFLPATH="$(pwd)"
 popd
-
-sudo bash -c "echo core >/proc/sys/kernel/core_pattern"
diff --git a/tools/fuzz/x86ie/scripts/install_deps_ubuntu.sh b/tools/fuzz/x86ie/scripts/install_deps_ubuntu.sh
new file mode 100755
index 000000000000..5525bc8b659c
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/install_deps_ubuntu.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+sudo apt update
+sudo apt install -y make gcc wget screen build-essential libssh-dev flex bison libelf-dev bc
diff --git a/tools/fuzz/x86ie/scripts/rebuild.sh b/tools/fuzz/x86ie/scripts/rebuild.sh
new file mode 100755
index 000000000000..809a4551cb0c
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/rebuild.sh
@@ -0,0 +1,6 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+make clean
+make tools/fuzz_clean
+FUZZDIR="./fuzz" ./tools/fuzz/x86ie/scripts/build.sh
diff --git a/tools/fuzz/x86ie/scripts/summarize.sh b/tools/fuzz/x86ie/scripts/summarize.sh
new file mode 100755
index 000000000000..27761f283ee3
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/summarize.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+if [ "$#" -lt 1 ]; then
+  echo "Usage: '$0 path/to/output/dir'"
+  exit
+fi
+
+time bash -c "find $1 -type f -exec tail -n 1 {} \; | sort | uniq -c | sort -rn"
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



