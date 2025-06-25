Return-Path: <kvm+bounces-50724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21266AE88B7
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 710064A61FF
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB142BD03F;
	Wed, 25 Jun 2025 15:49:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A32E713A3F7;
	Wed, 25 Jun 2025 15:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750866556; cv=none; b=Nf09touLO6HTBs8G7AhVJSV6qo1g340p2ayge0XY20dNNAnjvDFdhxD9W7p9hT7aV6EKfRGQ7DMeQQ5I8b4ZongjGTIa7GlDqMiAUwQA6BGBpAhsULGE6epriNIaPRRpsAV5yjW2HsIFzWqlmOl7aZyZvIpklbhNncSbWtrOUlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750866556; c=relaxed/simple;
	bh=bcQaTvOtcZh7GcMecpjcZf821VrF/hpyzVHC9Yz0q90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vopmgshf/qc28ZrQv4VwiDh4pJgrQ3g9qd+UTEsxWThV7/bEr/cMP7Qba69WALlGJ3//XHBD7vGb06bz8OyYCRafSgYG/I3NM6VAzbsHgCJYZx838pGpuqX2IdbVefBuBSbgZhx3Meby+Vr5NjN7ZdEY+Db1MjIapAPgCDF4h0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0FF2720E3;
	Wed, 25 Jun 2025 08:48:56 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D09AD3F58B;
	Wed, 25 Jun 2025 08:49:09 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev,
	eric.auger@redhat.com,
	lvivier@redhat.com,
	thuth@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	david@redhat.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	joey.gouly@arm.com,
	andre.przywara@arm.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v4 10/13] scripts: Do not probe for maximum number of VCPUs when using kvmtool
Date: Wed, 25 Jun 2025 16:48:10 +0100
Message-ID: <20250625154813.27254-11-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250625154813.27254-1-alexandru.elisei@arm.com>
References: <20250625154813.27254-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The --probe-maxsmp parameter updates MAX_SMP with the maximum number of
VCPUs that the host supports. Qemu will exit with an error when creating a
virtual machine if the number of VCPUs is exceeded.

kvmtool behaves differently: it will automatically limit the number of
VCPUs to the what KVM supports, which is exactly what --probe-maxsmp wants
to achieve. When doing --probe-maxsmp with kvmtool, print a message
explaining why it's redundant and don't do anything else.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Changes v3->v4:

* Use vmmm_probe_maxsmp() instead of indexing vmm_optname in run_tests.sh.

 run_tests.sh         |  3 ++-
 scripts/runtime.bash | 16 ----------------
 scripts/vmm.bash     | 30 ++++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index 150a06a91064..4cfc3cd9e4cf 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -10,6 +10,7 @@ if [ ! -f config.mak ]; then
 fi
 source config.mak
 source scripts/common.bash
+source scripts/vmm.bash
 
 function usage()
 {
@@ -90,7 +91,7 @@ while [ $# -gt 0 ]; do
             list_tests="yes"
             ;;
         --probe-maxsmp)
-            probe_maxsmp
+            vmm_probe_maxsmp $RUNTIME_arch_run
             ;;
         --)
             ;;
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 5839ca5ca665..766d1d28fb75 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -207,19 +207,3 @@ function run()
 
     return $ret
 }
-
-#
-# Probe for MAX_SMP, in case it's less than the number of host cpus.
-#
-function probe_maxsmp()
-{
-	local smp
-
-	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'SMP CPUs'); then
-		smp=${smp##* }
-		smp=${smp/\(}
-		smp=${smp/\)}
-		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
-		MAX_SMP=$smp
-	fi
-}
diff --git a/scripts/vmm.bash b/scripts/vmm.bash
index 44954a711cad..724c96f9e665 100644
--- a/scripts/vmm.bash
+++ b/scripts/vmm.bash
@@ -91,6 +91,23 @@ function qemu_parse_premature_failure()
 	return 0
 }
 
+#
+# Probe for MAX_SMP, in case it's less than the number of host cpus.
+#
+function qemu_probe_maxsmp()
+{
+	local runtime_arch_run="$1"
+	local smp
+
+	if smp=$($runtime_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'SMP CPUs'); then
+		smp=${smp##* }
+		smp=${smp/\(}
+		smp=${smp/\)}
+		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
+		MAX_SMP=$smp
+	fi
+}
+
 function kvmtool_fixup_return_code()
 {
 	local ret=$1
@@ -112,6 +129,12 @@ function kvmtool_parse_premature_failure()
 	return 0
 }
 
+function kvmtool_probe_maxsmp()
+{
+	echo "kvmtool automatically limits the number of VCPUs to maximum supported"
+	echo "The 'smp' test parameter won't be modified"
+}
+
 declare -A vmm_optname=(
 	[qemu,args]='-append'
 	[qemu,default_opts]=''
@@ -119,6 +142,7 @@ declare -A vmm_optname=(
 	[qemu,initrd]='-initrd'
 	[qemu,nr_cpus]='-smp'
 	[qemu,parse_premature_failure]=qemu_parse_premature_failure
+	[qemu,probe_maxsmp]=qemu_probe_maxsmp
 
 	[kvmtool,args]='--params'
 	[kvmtool,default_opts]="$KVMTOOL_DEFAULT_OPTS"
@@ -126,6 +150,7 @@ declare -A vmm_optname=(
 	[kvmtool,initrd]='--initrd'
 	[kvmtool,nr_cpus]='--cpus'
 	[kvmtool,parse_premature_failure]=kvmtool_parse_premature_failure
+	[kvmtool,probe_maxsmp]=kvmtool_probe_maxsmp
 )
 
 function vmm_optname_args()
@@ -158,6 +183,11 @@ function vmm_parse_premature_failure()
 	${vmm_optname[$(vmm_get_target),parse_premature_failure]} "$@"
 }
 
+function vmm_probe_maxsmp()
+{
+	${vmm_optname[$(vmm_get_target),probe_maxsmp]} "$1"
+}
+
 function vmm_get_target()
 {
 	if [[ -z "$TARGET" ]]; then
-- 
2.50.0


