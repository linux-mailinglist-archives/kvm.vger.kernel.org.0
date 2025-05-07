Return-Path: <kvm+bounces-45731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 36820AAE438
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:15:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DB851C08791
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F1F28A41F;
	Wed,  7 May 2025 15:14:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6A828A400;
	Wed,  7 May 2025 15:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630848; cv=none; b=rL9su5hT7fNYqltT4mCEhH/VfO3krvZ4FD/5j7q1Kp1XGodrk7Jqf+K+o/TNT7uK7oJsHnAmzZHKMgXoT/5OdnAsfwJiIDC5Val77zURfEPltCJ+9nSAda37haL4+DUf9wUsdjDHCHdb5LUnjEtvS5RKvEw35/dFDwQQ5MG+mc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630848; c=relaxed/simple;
	bh=Zj23gZMaxKY5AsuxPmjCz9OSZnsxH+HGceHVD9HXH1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5MIt38JZwwzlMaE0C2V2SN2ka9zhctE87ZHlsWEq/m7isX0Z14V6rRocUjJO9TsRelt9+HPTjyRABkrOsi5/l0V2DTiTYNdHkkVrKa6omrTGhu2tjCojh4v5ybjKqqJG+SmAUdbr1tmstVyMPtiq7EminbXGMzZOo3ae92t9C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79B4522EE;
	Wed,  7 May 2025 08:13:56 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56BAE3F58B;
	Wed,  7 May 2025 08:14:03 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v3 15/16] scripts: Add 'disabled_if' test definition parameter for kvmtool to use
Date: Wed,  7 May 2025 16:12:55 +0100
Message-ID: <20250507151256.167769-16-alexandru.elisei@arm.com>
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

The pci-test is qemu specific. Other tests perform migration, which
isn't supported by kvmtool. In general, kvmtool is not as feature-rich
as qemu, so add a new unittest parameter, 'disabled_if', that causes a
test to be skipped if the condition evaluates to true.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

This is what Drew said about the patch in the previous iteration [1]:

'I like disabled_if because I like the lambda-like thing it's doing, but I
wonder if it wouldn't be better to make TARGET a first class citizen by
adding a 'targets' unittest parameter which allows listing all targets the
test can run on [..]

If targets isn't present then the default is only qemu.'

Like I've said on the cover letter, I think making qemu the default (if
'targets' isn't specified in the test definition) will mean that new tests
will not run with kvmtool. I was thinking something along the lines
'excluded_targets', with the default (when left unspecified) being that the
tests run with all the vmms that the architecture support (or, to put it
another way, no vmms are excluded).

Or we could go with 'targets' and say that when left empty it means 'all
the vmms that the architecture supports' - though in my opinion this
semantic is somewhat better conveyed with the name 'excluded_targets'.

[1] https://lore.kernel.org/all/20250123-3eda2c10fdce584bdfb14971@orel/

 arm/unittests.cfg    |  7 +++++++
 docs/unittests.txt   | 13 +++++++++++++
 scripts/common.bash  |  6 +++++-
 scripts/runtime.bash |  6 ++++++
 4 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index f3c773e56933..8f9434aad865 100644
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
index ee0ae71948c2..8557d60461ba 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -39,6 +39,7 @@ function for_each_unittest()
 	local check
 	local accel
 	local timeout
+	local disabled_cond
 	local rematch
 
 	exec {fd}<"$unittests"
@@ -47,7 +48,7 @@ function for_each_unittest()
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
 			rematch=${BASH_REMATCH[1]}
 			if [ -n "${testname}" ]; then
-				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$test_args" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
+				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$test_args" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout" "$disabled_cond"
 			fi
 			testname=$rematch
 			smp="${vmm_opts[$TARGET:nr_cpus]} 1"
@@ -63,6 +64,7 @@ function for_each_unittest()
 			check=""
 			accel=""
 			timeout=""
+			disabled_cond=""
 		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
 			kernel=$TEST_DIR/${BASH_REMATCH[1]}
 		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
@@ -85,6 +87,8 @@ function for_each_unittest()
 			machine=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^check\ *=\ *(.*)$ ]]; then
 			check=${BASH_REMATCH[1]}
+		elif [[ $line =~ ^disabled_if\ *=\ *(.*)$ ]]; then
+			disabled_cond=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^accel\ *=\ *(.*)$ ]]; then
 			accel=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^timeout\ *=\ *(.*)$ ]]; then
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index a802686c511d..8755927dbc49 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -85,6 +85,7 @@ function run()
     local check="${CHECK:-$9}"
     local accel="${10}"
     local timeout="${11:-$TIMEOUT}" # unittests.cfg overrides the default
+    local disabled_cond="${12}"
 
     if [ "${CONFIG_EFI}" == "y" ]; then
         kernel=${kernel/%.flat/.efi}
@@ -132,6 +133,11 @@ function run()
         accel="$ACCEL"
     fi
 
+    if [[ "$disabled_cond" ]] && (eval $disabled_cond); then
+        print_result "SKIP" $testname "" "disabled because: $disabled_cond"
+	return 2
+    fi
+
     # check a file for a particular value before running a test
     # the check line can contain multiple files to check separated by a space
     # but each check parameter needs to be of the form <path>=<value>
-- 
2.49.0


