Return-Path: <kvm+bounces-45723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE0F4AAE41A
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:14:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B9B416ED6F
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 017B528A71C;
	Wed,  7 May 2025 15:13:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E466328A400;
	Wed,  7 May 2025 15:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630820; cv=none; b=lVEUXnBd15PGxxIDa7bDrKjHSQDUSgAbHLCp+4L1uDA7sc/e7dGwmPDVRw135LwADZH1DLMnBWttfwRaHUT/ux+omKfASBilI2rOWNmhM3CuLOiU//RBEcPy9F/GD0TmeqibnZ/RjpX6Am2MP/dgFC5HOFLWJMv2Vg9bnlsr2EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630820; c=relaxed/simple;
	bh=roePqBVpf3rmSFaeUjOxh0aREh8cL23daWXy8GmiwBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwiQZMNPvN4TMOQFzOv8JOZzdU/QO+IOmQ8WA6hWsp0IWUfm0mUxTpYymSOXmkIFmwq1iSIMgORqzDxa8OgSXsAO+tTJzz316RQxyRzus6ybOiAWxpLe2DPGDamTe/4vbIJQDhnUDYViXxaLBshzIUq9uOgbBw45cKzSWplGx9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 625B42247;
	Wed,  7 May 2025 08:13:28 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E4293F58B;
	Wed,  7 May 2025 08:13:35 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v3 07/16] scripts: Use an associative array for qemu argument names
Date: Wed,  7 May 2025 16:12:47 +0100
Message-ID: <20250507151256.167769-8-alexandru.elisei@arm.com>
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

Move away from hardcoded qemu arguments and use instead an associative
array to get the needed arguments. This paves the way for adding kvmtool
support to the scripts, which has a different syntax for the same VM
configuration parameters.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 scripts/common.bash  | 10 +++++++---
 scripts/runtime.bash |  7 +------
 scripts/vmm.bash     |  7 +++++++
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index 9deb87d4050d..649f1c737617 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -1,4 +1,5 @@
 source config.mak
+source scripts/vmm.bash
 
 function for_each_unittest()
 {
@@ -26,8 +27,11 @@ function for_each_unittest()
 				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$test_args" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
 			fi
 			testname=$rematch
-			smp=1
+			smp="${vmm_opts[$TARGET:nr_cpus]} 1"
 			kernel=""
+			# Intentionally don't use -append if test_args is empty
+			# because qemu interprets the first argument after
+			# -append as a kernel parameter.
 			test_args=""
 			opts=""
 			groups=""
@@ -39,9 +43,9 @@ function for_each_unittest()
 		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
 			kernel=$TEST_DIR/${BASH_REMATCH[1]}
 		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
-			smp=${BASH_REMATCH[1]}
+			smp="${vmm_opts[$TARGET:nr_cpus]} ${BASH_REMATCH[1]}"
 		elif [[ $line =~ ^test_args\ *=\ *(.*)$ ]]; then
-			test_args=${BASH_REMATCH[1]}
+			test_args="${vmm_opts[$TARGET:args]} ${BASH_REMATCH[1]}"
 		elif [[ $line =~ ^(extra_params|qemu_params)\ *=\ *'"""'(.*)$ ]]; then
 			opts=${BASH_REMATCH[2]}$'\n'
 			while read -r -u $fd; do
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 06cc58e79b69..86d8a2cd8528 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -34,7 +34,7 @@ premature_failure()
 get_cmdline()
 {
     local kernel=$1
-    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
+    echo "TESTNAME=$testname TIMEOUT=$timeout MACHINE=$machine ACCEL=$accel $RUNTIME_arch_run $kernel $smp $test_args $opts"
 }
 
 skip_nodefault()
@@ -88,11 +88,6 @@ function run()
     local accel="${10}"
     local timeout="${11:-$TIMEOUT}" # unittests.cfg overrides the default
 
-    # If $test_args is empty, qemu will interpret the first option after -append
-    # as a kernel parameter instead of a qemu option, so make sure the -append
-    # option is used only if $test_args is not empy.
-    [ -n "$test_args" ] && opts="-append $test_args $opts"
-
     if [ "${CONFIG_EFI}" == "y" ]; then
         kernel=${kernel/%.flat/.efi}
     fi
diff --git a/scripts/vmm.bash b/scripts/vmm.bash
index 39325858c6b3..b02055a5c0b6 100644
--- a/scripts/vmm.bash
+++ b/scripts/vmm.bash
@@ -1,5 +1,12 @@
 source config.mak
 
+declare -A vmm_opts=(
+	[qemu:nr_cpus]='-smp'
+	[qemu:kernel]='-kernel'
+	[qemu:args]='-append'
+	[qemu:initrd]='-initrd'
+)
+
 function check_vmm_supported()
 {
 	case "$TARGET" in
-- 
2.49.0


