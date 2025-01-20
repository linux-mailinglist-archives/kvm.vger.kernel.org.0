Return-Path: <kvm+bounces-36050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D4F4A1708D
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:45:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FF3416AEE4
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D7B91EF094;
	Mon, 20 Jan 2025 16:44:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF1B1EB9FA;
	Mon, 20 Jan 2025 16:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391473; cv=none; b=JrL+yq6pX3q7DMnPB1avKzRwNB0pkjEIZGk4GtktOEs82W0Yp1pWqMI9VrxA5uiGpAOymxPtkoRLOJiJ2VW3lMsyn7cn0wP8VN6XKxvdzI38UV8fnM0PX1tqqbMEypHa1LahtPMRKFDNvzlY3M1/veR8m3eXd43l9vk26nH23W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391473; c=relaxed/simple;
	bh=Am2z1FqWMNd8WV/ZFvPyfxDhjdXYhvIZKJHgaKv6XPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTbvg0UJT9K8Ni4CcvYtzyqOUep+LA5fN211WMKjY0MakbhAdeDhbljUDPt4yqeBdNZmnOGpVdSkWK6RXs91cBDRpaEPgqvofrWW3Im2etb+kyGcwKgxndC9KDGJuJCjXXCwExWT8diDi9AFZJZuCxfXjhSKCba4x4SR9pwBAUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F4FC1D34;
	Mon, 20 Jan 2025 08:45:00 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 849DA3F5A1;
	Mon, 20 Jan 2025 08:44:28 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v2 17/18] unittest: Add disabled_if parameter and use it for kvmtool
Date: Mon, 20 Jan 2025 16:43:15 +0000
Message-ID: <20250120164316.31473-18-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250120164316.31473-1-alexandru.elisei@arm.com>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pci-test is qemu specific. Other tests perform migration, which
isn't supported by kvmtool. In general, kvmtool is not as feature-rich
as qemu, so add a new unittest parameter, disabled_if, that causes a
test to be skipped if the condition evaluates to true.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/unittests.cfg    |  7 +++++++
 docs/unittests.txt   | 13 +++++++++++++
 scripts/common.bash  |  8 ++++++--
 scripts/runtime.bash |  6 ++++++
 4 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 974a5a9e4113..9b1df5e02a58 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -44,6 +44,7 @@ groups = selftest
 # Test PCI emulation
 [pci-test]
 file = pci-test.flat
+disabled_if = [[ "$TARGET" != qemu ]]
 groups = pci
 
 # Test PMU support
@@ -208,6 +209,7 @@ file = gic.flat
 smp = $MAX_SMP
 extra_params = -machine gic-version=3 -append 'its-migration'
 groups = its migration
+disabled_if = [[ "$TARGET" != qemu ]]
 arch = arm64
 
 [its-pending-migration]
@@ -215,6 +217,7 @@ file = gic.flat
 smp = $MAX_SMP
 extra_params = -machine gic-version=3 -append 'its-pending-migration'
 groups = its migration
+disabled_if = [[ "$TARGET" != qemu ]]
 arch = arm64
 
 [its-migrate-unmapped-collection]
@@ -222,6 +225,7 @@ file = gic.flat
 smp = $MAX_SMP
 extra_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection'
 groups = its migration
+disabled_if = [[ "$TARGET" != qemu ]]
 arch = arm64
 
 # Test PSCI emulation
@@ -263,6 +267,7 @@ groups = debug
 file = debug.flat
 arch = arm64
 extra_params = -append 'bp-migration'
+disabled_if = [[ "$TARGET" != qemu ]]
 groups = debug migration
 
 [debug-wp]
@@ -276,6 +281,7 @@ groups = debug
 file = debug.flat
 arch = arm64
 extra_params = -append 'wp-migration'
+disabled_if = [[ "$TARGET" != qemu ]]
 groups = debug migration
 
 [debug-sstep]
@@ -289,6 +295,7 @@ groups = debug
 file = debug.flat
 arch = arm64
 extra_params = -append 'ss-migration'
+disabled_if = [[ "$TARGET" != qemu ]]
 groups = debug migration
 
 # FPU/SIMD test
diff --git a/docs/unittests.txt b/docs/unittests.txt
index ebb6994cab77..58d1a29146a3 100644
--- a/docs/unittests.txt
+++ b/docs/unittests.txt
@@ -115,3 +115,16 @@ parameter needs to be of the form <path>=<value>
 The path and value cannot contain space, =, or shell wildcard characters.
 
 Can be overwritten with the CHECK environment variable with the same syntax.
+
+disabled_if
+------
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
index f54ffbd7a87b..c0ea2eabeda6 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -38,6 +38,7 @@ function for_each_unittest()
 	local accel
 	local timeout
 	local kvmtool_opts
+	local disabled_cond
 	local rematch
 
 	exec {fd}<"$unittests"
@@ -46,7 +47,7 @@ function for_each_unittest()
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
 			rematch=${BASH_REMATCH[1]}
 			if [ -n "${testname}" ]; then
-				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout" "$kvmtool_opts"
+				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout" "$kvmtool_opts" "$disabled_cond"
 			fi
 			testname=$rematch
 			smp=1
@@ -59,6 +60,7 @@ function for_each_unittest()
 			accel=""
 			timeout=""
 			kvmtool_opts=""
+			disabled_cond=""
 		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
 			kernel=$TEST_DIR/${BASH_REMATCH[1]}
 		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
@@ -79,6 +81,8 @@ function for_each_unittest()
 			machine=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^check\ *=\ *(.*)$ ]]; then
 			check=${BASH_REMATCH[1]}
+		elif [[ $line =~ ^disabled_if\ *=\ *(.*)$ ]]; then
+			disabled_cond=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^accel\ *=\ *(.*)$ ]]; then
 			accel=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^timeout\ *=\ *(.*)$ ]]; then
@@ -86,7 +90,7 @@ function for_each_unittest()
 		fi
 	done
 	if [ -n "${testname}" ]; then
-		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout" "$kvmtool_opts"
+		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$qemu_opts" "$arch" "$machine" "$check" "$accel" "$timeout" "$kvmtool_opts" "$disabled_cond"
 	fi
 	exec {fd}<&-
 }
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index abfd1e67b2ef..002bd2744d6b 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -108,6 +108,7 @@ function run()
     local accel="$9"
     local timeout="${10:-$TIMEOUT}" # unittests.cfg overrides the default
     local kvmtool_opts="${11}"
+    local disabled_cond="${12}"
 
     case "$TARGET" in
     qemu)
@@ -186,6 +187,11 @@ function run()
         done
     fi
 
+    if [[ "$disabled_cond" ]] && (eval $disabled_cond); then
+		print_result "SKIP" $testname "" "disabled because: $disabled_cond"
+		return 2
+	fi
+
     log=$(premature_failure) && {
         skip=true
         if [ "${CONFIG_EFI}" == "y" ]; then
-- 
2.47.1


