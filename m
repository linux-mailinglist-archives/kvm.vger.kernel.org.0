Return-Path: <kvm+bounces-50726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E86DAE88B0
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:49:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51C9C7B6208
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 462C82BD590;
	Wed, 25 Jun 2025 15:49:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421632BD01A;
	Wed, 25 Jun 2025 15:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750866565; cv=none; b=DThCXZfp/WlPI6AOnJuNCa/KWQJXeJpkze0k+gk5GOgIWe3wh/e2B/pv9xhYDvyPuKQov8ugkKG7X67o2o6IR4Gq4UpD4HGrkokUHd8AHdG+VRBzZijXE3WCfNoaXRrq8uTMOJwTuCsDbbhSGKjomOdX7KALkjjdAvjbnVl2rbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750866565; c=relaxed/simple;
	bh=OKPAblN3n1xIjKW5gBIHl2122SU8nWgJgpmNDh28l98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWTuZc7uB7bHJ+X5C6BjnABeLSV1akl7Rr1raH943UG/qgG1M2Ai7IeKLAYA0h/nxeAK37zg+fwGBcN7miQPF6waJauHuimDFQ37WOnNmXnI5U8wbW1A7OBJUtbPRRbOVCg9I26J0mIe6Pd45uCG0aW5BMxdfp8LicX6q/47eKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BB352681;
	Wed, 25 Jun 2025 08:49:05 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67E833F58B;
	Wed, 25 Jun 2025 08:49:19 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v4 12/13] scripts: Add 'disabled_if' test definition parameter for kvmtool to use
Date: Wed, 25 Jun 2025 16:48:12 +0100
Message-ID: <20250625154813.27254-13-alexandru.elisei@arm.com>
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

The pci-test is qemu specific. Other tests perform migration, which
isn't supported by kvmtool. In general, kvmtool is not as feature-rich
as qemu, so add a new unittest parameter, 'disabled_if', that causes a
test to be skipped if the condition evaluates to true.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/unittests.cfg    |  7 +++++++
 docs/unittests.txt   | 13 +++++++++++++
 scripts/common.bash  |  6 +++++-
 scripts/runtime.bash |  6 ++++++
 4 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 343c14567f27..12fc4468d0fd 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -43,6 +43,7 @@ groups = selftest
 [pci-test]
 file = pci-test.flat
 groups = pci
+disabled_if = [[ "$TARGET" != qemu ]]
 
 # Test PMU support
 [pmu-cycle-counter]
@@ -219,6 +220,7 @@ test_args = its-migration
 qemu_params = -machine gic-version=3
 kvmtool_params = --irqchip=gicv3
 groups = its migration
+disabled_if = [[ "$TARGET" != qemu ]]
 arch = arm64
 
 [its-pending-migration]
@@ -228,6 +230,7 @@ test_args = its-pending-migration
 qemu_params = -machine gic-version=3
 kvmtool_params = --irqchip=gicv3
 groups = its migration
+disabled_if = [[ "$TARGET" != qemu ]]
 arch = arm64
 
 [its-migrate-unmapped-collection]
@@ -237,6 +240,7 @@ test_args = its-migrate-unmapped-collection
 qemu_params = -machine gic-version=3
 kvmtool_params = --irqchip=gicv3
 groups = its migration
+disabled_if = [[ "$TARGET" != qemu ]]
 arch = arm64
 
 # Test PSCI emulation
@@ -278,6 +282,7 @@ file = debug.flat
 arch = arm64
 test_args = bp-migration
 groups = debug migration
+disabled_if = [[ "$TARGET" != qemu ]]
 
 [debug-wp]
 file = debug.flat
@@ -290,6 +295,7 @@ file = debug.flat
 arch = arm64
 test_args = wp-migration
 groups = debug migration
+disabled_if = [[ "$TARGET" != qemu ]]
 
 [debug-sstep]
 file = debug.flat
@@ -302,6 +308,7 @@ file = debug.flat
 arch = arm64
 test_args = ss-migration
 groups = debug migration
+disabled_if = [[ "$TARGET" != qemu ]]
 
 # FPU/SIMD test
 [fpu-context]
diff --git a/docs/unittests.txt b/docs/unittests.txt
index a9164bccc24c..921318a6d85a 100644
--- a/docs/unittests.txt
+++ b/docs/unittests.txt
@@ -124,3 +124,16 @@ parameter needs to be of the form <path>=<value>
 The path and value cannot contain space, =, or shell wildcard characters.
 
 Can be overwritten with the CHECK environment variable with the same syntax.
+
+disabled_if
+-----------
+disabled_if = <condition>
+
+Do not run the test if <condition> is met. <condition> will be fed unmodified
+to a bash 'if' statement and follows the same syntax.
+
+This can be used to prevent running a test when kvm-unit-tests is configured a
+certain way. For example, it can be used to skip a qemu specific test when
+using another VMM and using UEFI:
+
+disabled_if = [[ "$TARGET" != qemu ]] && [[ "$CONFIG_EFI" = y ]]
diff --git a/scripts/common.bash b/scripts/common.bash
index d5d3101c8089..283fb30f5533 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -16,6 +16,7 @@ function for_each_unittest()
 	local check
 	local accel
 	local timeout
+	local disabled_if
 	local rematch
 
 	# shellcheck disable=SC2155
@@ -27,7 +28,7 @@ function for_each_unittest()
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
 			rematch=${BASH_REMATCH[1]}
 			if [ -n "${testname}" ]; then
-				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$test_args" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
+				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$test_args" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout" "$disabled_if"
 			fi
 			testname=$rematch
 			smp="$(vmm_optname_nr_cpus) 1"
@@ -44,6 +45,7 @@ function for_each_unittest()
 			check=""
 			accel=""
 			timeout=""
+			disabled_if=""
 		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
 			kernel=$TEST_DIR/${BASH_REMATCH[1]}
 		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
@@ -76,6 +78,8 @@ function for_each_unittest()
 			machine=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^check\ *=\ *(.*)$ ]]; then
 			check=${BASH_REMATCH[1]}
+		elif [[ $line =~ ^disabled_if\ *=\ *(.*)$ ]]; then
+			disabled_if=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^accel\ *=\ *(.*)$ ]]; then
 			accel=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^timeout\ *=\ *(.*)$ ]]; then
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 766d1d28fb75..0ff8ad08bf1d 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -83,6 +83,7 @@ function run()
     local check="${CHECK:-$9}"
     local accel="${10}"
     local timeout="${11:-$TIMEOUT}" # unittests.cfg overrides the default
+    local disabled_if="${12}"
 
     if [ "${CONFIG_EFI}" == "y" ]; then
         kernel=${kernel/%.flat/.efi}
@@ -130,6 +131,11 @@ function run()
         accel="$ACCEL"
     fi
 
+    if [[ "$disabled_if" ]] && (eval $disabled_if); then
+        print_result "SKIP" $testname "" "disabled because: $disabled_if"
+	return 2
+    fi
+
     # check a file for a particular value before running a test
     # the check line can contain multiple files to check separated by a space
     # but each check parameter needs to be of the form <path>=<value>
-- 
2.50.0


