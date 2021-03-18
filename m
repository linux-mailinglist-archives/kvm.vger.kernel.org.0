Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C113405F6
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 13:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhCRMpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 08:45:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231512AbhCRMpT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 08:45:19 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ICYAGk095009
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 08:45:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SBqdw5XC3T0wnXNeIFrQHk05XeSvq6gOUYFOgGAukR4=;
 b=hK2s6hMJ8x/E6N+jCHSzK9nvcCtDAwy/4+jvjt7sg2vQJX5cZ/q7SlouDxqG3B9HPvQj
 f/pRbs/lZ6VtQy6kX4EkOEfvrdzQNMS6VHx5oP3vpxEFncTAw9pllzJFyPyKsGFrwc+B
 E7vLzVKR0VKBa/vDRJIObxG02NoSwdsNLO0m+t6Jg2pcoFZlZ76cXqutTNnvPtGDEea/
 PzyH1QMBsJppox//jh0WsGcXURV/WtrL9TJQNbup1vPMVQwL6yA3A3PjYQ3Gz2kVIHt0
 JT4wl9WpaxikBdqp0YtBtEyRCYBlEPT40xgTCwN8WKvTdmy3rPm8sd8AfKhEmEOpZun+ 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37by165p75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 08:45:18 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12ICYEpM095532
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 08:45:18 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37by165p6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 08:45:18 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12ICRliB004910;
        Thu, 18 Mar 2021 12:45:16 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 378n18ms7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 12:45:16 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12ICjESv36831716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 12:45:14 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DB2142049;
        Thu, 18 Mar 2021 12:45:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E64E742052;
        Thu, 18 Mar 2021 12:45:12 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.24.61])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 12:45:12 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     lvivier@redhat.com, thuth@redhat.com, david@redhat.com,
        drjones@redhat.com, pbonzini@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests RFC 2/2] scripts: Set ACCEL in run_tests.sh if empty
Date:   Thu, 18 Mar 2021 12:45:00 +0000
Message-Id: <20210318124500.45447-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318124500.45447-1-frankja@linux.ibm.com>
References: <20210318124500.45447-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current checks compare the env ACCEL to the unittests.conf
provided accel. That's all fine as long as the user always specifies
the ACCEL env variable.

If that's not the case and KVM is not available or if a test specifies
tcg and we start a qemu with the kvm acceleration as it's the default
we'll run into problems.

So let's fetch the accelerator before calling the arch/run script and
check it against the test's specified accel. Yes, we now do that
twice, once in the run_tests.sh and one in arch/run, but I don't think
there's a good way around it since you can execute arch/run
without run_tests.sh.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 run_tests.sh          |  6 ++++
 s390x/run             |  6 +++-
 scripts/accel.bash    | 63 +++++++++++++++++++++++++++++++++++++++++
 scripts/arch-run.bash | 66 ++-----------------------------------------
 scripts/runtime.bash  |  2 +-
 5 files changed, 77 insertions(+), 66 deletions(-)
 create mode 100644 scripts/accel.bash

diff --git a/run_tests.sh b/run_tests.sh
index 65108e73..9ccb97bd 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -10,6 +10,7 @@ if [ ! -f config.mak ]; then
 fi
 source config.mak
 source scripts/common.bash
+source scripts/accel.bash
 
 function usage()
 {
@@ -164,6 +165,11 @@ if [[ $tap_output == "yes" ]]; then
     echo "TAP version 13"
 fi
 
+qemu=$(search_qemu_binary)
+if [ -z "$ACCEL" ]; then
+    ACCEL=$(get_qemu_accelerator)
+fi
+
 trap "wait; exit 130" SIGINT
 
 (
diff --git a/s390x/run b/s390x/run
index 2ec6da70..df7ef5ca 100755
--- a/s390x/run
+++ b/s390x/run
@@ -12,8 +12,12 @@ fi
 qemu=$(search_qemu_binary) ||
 	exit $?
 
-ACCEL=$(get_qemu_accelerator) ||
+if [ -z "$DEF_ACCEL "]; then
+    ACCEL=$(get_qemu_accelerator) ||
 	exit $?
+else
+    ACCEL=$DEF_ACCEL
+fi
 
 M='-machine s390-ccw-virtio'
 M+=",accel=$ACCEL"
diff --git a/scripts/accel.bash b/scripts/accel.bash
new file mode 100644
index 00000000..ea12412a
--- /dev/null
+++ b/scripts/accel.bash
@@ -0,0 +1,63 @@
+search_qemu_binary ()
+{
+	local save_path=$PATH
+	local qemucmd qemu
+
+	export PATH=$PATH:/usr/libexec
+	for qemucmd in ${QEMU:-qemu-system-$ARCH_NAME qemu-kvm}; do
+		if $qemucmd --help 2>/dev/null | grep -q 'QEMU'; then
+			qemu="$qemucmd"
+			break
+		fi
+	done
+
+	if [ -z "$qemu" ]; then
+		echo "A QEMU binary was not found." >&2
+		echo "You can set a custom location by using the QEMU=<path> environment variable." >&2
+		return 2
+	fi
+	command -v $qemu
+	export PATH=$save_path
+}
+
+kvm_available ()
+{
+	if $($qemu -accel kvm 2> /dev/null); then
+		return 0;
+	else
+		return 1;
+	fi
+
+	[ "$HOST" = "$ARCH_NAME" ] ||
+		( [ "$HOST" = aarch64 ] && [ "$ARCH" = arm ] ) ||
+		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
+}
+
+hvf_available ()
+{
+	[ "$(sysctl -n kern.hv_support 2>/dev/null)" = "1" ] || return 1
+	[ "$HOST" = "$ARCH_NAME" ] ||
+		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
+}
+
+get_qemu_accelerator ()
+{
+	if [ "$ACCEL" = "kvm" ] && ! kvm_available; then
+		echo "KVM is needed, but not available on this host" >&2
+		return 2
+	fi
+	if [ "$ACCEL" = "hvf" ] && ! hvf_available; then
+		echo "HVF is needed, but not available on this host" >&2
+		return 2
+	fi
+
+	if [ "$ACCEL" ]; then
+		echo $ACCEL
+	elif kvm_available; then
+		echo kvm
+	elif hvf_available; then
+		echo hvf
+	else
+		echo tcg
+	fi
+}
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 8cc9a61e..85c07792 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -24,6 +24,8 @@
 # 1..127 - FAILURE (could be QEMU, a run script, or the unittest)
 # >= 128 - Signal (signum = status - 128)
 ##############################################################################
+source scripts/accel.bash
+
 run_qemu ()
 {
 	local stdout errors ret sig
@@ -171,28 +173,6 @@ migration_cmd ()
 	fi
 }
 
-search_qemu_binary ()
-{
-	local save_path=$PATH
-	local qemucmd qemu
-
-	export PATH=$PATH:/usr/libexec
-	for qemucmd in ${QEMU:-qemu-system-$ARCH_NAME qemu-kvm}; do
-		if $qemucmd --help 2>/dev/null | grep -q 'QEMU'; then
-			qemu="$qemucmd"
-			break
-		fi
-	done
-
-	if [ -z "$qemu" ]; then
-		echo "A QEMU binary was not found." >&2
-		echo "You can set a custom location by using the QEMU=<path> environment variable." >&2
-		return 2
-	fi
-	command -v $qemu
-	export PATH=$save_path
-}
-
 initrd_create ()
 {
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
@@ -339,45 +319,3 @@ trap_exit_push ()
 	local old_exit=$(trap -p EXIT | sed "s/^[^']*'//;s/'[^']*$//")
 	trap -- "$1; $old_exit" EXIT
 }
-
-kvm_available ()
-{
-	if $($qemu -accel kvm 2> /dev/null); then
-		return 0;
-	else
-		return 1;
-	fi
-
-	[ "$HOST" = "$ARCH_NAME" ] ||
-		( [ "$HOST" = aarch64 ] && [ "$ARCH" = arm ] ) ||
-		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
-}
-
-hvf_available ()
-{
-	[ "$(sysctl -n kern.hv_support 2>/dev/null)" = "1" ] || return 1
-	[ "$HOST" = "$ARCH_NAME" ] ||
-		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
-}
-
-get_qemu_accelerator ()
-{
-	if [ "$ACCEL" = "kvm" ] && ! kvm_available; then
-		echo "KVM is needed, but not available on this host" >&2
-		return 2
-	fi
-	if [ "$ACCEL" = "hvf" ] && ! hvf_available; then
-		echo "HVF is needed, but not available on this host" >&2
-		return 2
-	fi
-
-	if [ "$ACCEL" ]; then
-		echo $ACCEL
-	elif kvm_available; then
-		echo kvm
-	elif hvf_available; then
-		echo hvf
-	else
-		echo tcg
-	fi
-}
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 132389c7..5d444db4 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -30,7 +30,7 @@ premature_failure()
 get_cmdline()
 {
     local kernel=$1
-    echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
+    echo "TESTNAME=$testname TIMEOUT=$timeout DEF_ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
 }
 
 skip_nodefault()
-- 
2.27.0

