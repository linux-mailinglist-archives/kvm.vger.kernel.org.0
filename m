Return-Path: <kvm+bounces-45729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E046AAE43A
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:15:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DC4C9A7F4D
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C67B28AB01;
	Wed,  7 May 2025 15:14:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C91228A1E5;
	Wed,  7 May 2025 15:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630841; cv=none; b=U4olEnjVWjc+wgO3qL3B3W+enH/DTo2w4m7FAxI9QS3buwDu19TIkUhMV9BDQ7cwqv5stzIqmmu3mP8O5ultqwIrWyp6rtSocB4qmmpIsgii2BucDoRnZfl073tUsCHJXrJ1H2oucL9W6TBQF4injHytSPqNOK+m2ZgyGuLiLr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630841; c=relaxed/simple;
	bh=ZWWHAOACSMz0Bdl84misEjF1wMPZhb/vJvNZvP0dZak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePyitspQ24HqCFtat03zGgA7p1LqHQDo7U+DTqRtEAcO1aF25hUnoS4sV3tIme1LhbZts3WNMnc9O7NQO0nwkF3kNCLZz+ttaNZG6fB7Hj6cvqihtj8HRNUo2XyFGVFlrsGUEuZBGtxo1rvJGt/NUkHr7FwjAzLUvP2kgzdp7LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71CED22E6;
	Wed,  7 May 2025 08:13:49 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 544FE3F58B;
	Wed,  7 May 2025 08:13:56 -0700 (PDT)
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
	andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH v3 13/16] scripts: Do not probe for maximum number of VCPUs when using kvmtool
Date: Wed,  7 May 2025 16:12:53 +0100
Message-ID: <20250507151256.167769-14-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507151256.167769-1-alexandru.elisei@arm.com>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
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

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 run_tests.sh         |  3 ++-
 scripts/runtime.bash | 16 ----------------
 scripts/vmm.bash     | 24 ++++++++++++++++++++++++
 3 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index 150a06a91064..a69c3665b7a4 100755
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
+            ${vmm_opts[$TARGET:probe_maxsmp]}
             ;;
         --)
             ;;
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 01ec8eae2bba..a802686c511d 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -209,19 +209,3 @@ function run()
 
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
index a1d50ed51981..ef9819f4132c 100644
--- a/scripts/vmm.bash
+++ b/scripts/vmm.bash
@@ -105,6 +105,22 @@ function qemu_parse_premature_failure()
 	return 0
 }
 
+#
+# Probe for MAX_SMP, in case it's less than the number of host cpus.
+#
+function qemu_probe_maxsmp()
+{
+	local smp
+
+	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'SMP CPUs'); then
+		smp=${smp##* }
+		smp=${smp/\(}
+		smp=${smp/\)}
+		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
+		MAX_SMP=$smp
+	fi
+}
+
 function kvmtool_parse_premature_failure()
 {
 	local log="$@"
@@ -114,6 +130,12 @@ function kvmtool_parse_premature_failure()
 	return 0
 }
 
+function kvmtool_probe_maxsmp()
+{
+	echo "kvmtool automatically limits the number of VCPUs to maximum supported"
+	echo "The 'smp' test parameter won't be modified"
+}
+
 declare -A vmm_opts=(
 	[qemu:nr_cpus]='-smp'
 	[qemu:kernel]='-kernel'
@@ -122,6 +144,7 @@ declare -A vmm_opts=(
 	[qemu:default_opts]=''
 	[qemu:fixup_return_code]=qemu_fixup_return_code
 	[qemu:parse_premature_failure]=qemu_parse_premature_failure
+	[qemu:probe_maxsmp]=qemu_probe_maxsmp
 
 	[kvmtool:nr_cpus]='--cpus'
 	[kvmtool:kernel]='--kernel'
@@ -130,6 +153,7 @@ declare -A vmm_opts=(
 	[kvmtool:default_opts]="$KVMTOOL_DEFAULT_OPTS"
 	[kvmtool:fixup_return_code]=kvmtool_fixup_return_code
 	[kvmtool:parse_premature_failure]=kvmtool_parse_premature_failure
+	[kvmtool:probe_maxsmp]=kvmtool_probe_maxsmp
 )
 
 function check_vmm_supported()
-- 
2.49.0


