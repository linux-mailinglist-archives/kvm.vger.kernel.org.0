Return-Path: <kvm+bounces-36035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DFCDA17061
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:44:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32F7A3A539F
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746221EBFF5;
	Mon, 20 Jan 2025 16:43:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 864FB1E9B3F;
	Mon, 20 Jan 2025 16:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391425; cv=none; b=XHK6n+LvbKcexpLrxPj27xj3X1CuweiYq8vfbVO8M+vLacmPi32tcTLLU5ClHTAs2VtAC7sea8JihAN7CjO6kWrCe4UbATmuVTz9V1QPHsj8xsoM3VKxWxJdVMxc6aivSNudU5uK3iih/1g4JDJZ+z1A/GePgxKgzQvw5LIWo58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391425; c=relaxed/simple;
	bh=njIcaoieuawVSW7Wnwt14YqgJAcPuRLFfdXOhQmctqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UaIiUuCDHTIgs8HipunNc322maBH75iqH8YaVTrbZMFJ7dTQAMB+lm11qG5lDLN9PICbV9c0yVc2R3kFgP321dsQc67tp4vdW2fB/6s7n6CTkiJPS0J9QmhrB/No6aSlNh/fuWL7Ew0KsbP1ma9hv62M+RwmlaSTe4mZM1Ts0YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 402B1106F;
	Mon, 20 Jan 2025 08:44:11 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 990FB3F5A1;
	Mon, 20 Jan 2025 08:43:39 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v2 03/18] scripts: Refuse to run the tests if not configured for qemu
Date: Mon, 20 Jan 2025 16:43:01 +0000
Message-ID: <20250120164316.31473-4-alexandru.elisei@arm.com>
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

Arm and arm64 support running the tests under kvmtool. Unsurprisingly,
kvmtool and qemu have a different command line syntax for configuring and
running a virtual machine.

On top of that, when kvm-unit-tests has been configured to run under
kvmtool (via ./configure --target=kvmtool), the early UART address changes,
and if then the tests are run with qemu, this warning is displayed:

WARNING: early print support may not work. Found uart at 0x9000000, but early base is 0x1000000.

At the moment, the only way to run a test under kvmtool is manually, as no
script has any knowledge of how to invoke kvmtool. Also, unless one looks
at the logs, it's not obvious that the test runner is using qemu to run the
tests, and not kvmtool.

To avoid any confusion for unsuspecting users, refuse to run a test via the
testing scripts when kvm-unit-tests has been configured for kvmtool.

There are four different ways to run a test using the test infrastructure:
with run_tests.sh, by invoking arm/run or arm/efi/run with the correct
parameters (only the arm directory is mentioned here because the tests can
be configured for kvmtool only on arm and arm64), and by creating
standalone tests. Add a check in each of these locations for the supported
virtual machine manager.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/efi/run             | 8 ++++++++
 arm/run                 | 9 +++++++++
 run_tests.sh            | 8 ++++++++
 scripts/mkstandalone.sh | 8 ++++++++
 4 files changed, 33 insertions(+)

diff --git a/arm/efi/run b/arm/efi/run
index 8f41fc02df31..916f4c4deef6 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -12,6 +12,14 @@ fi
 source config.mak
 source scripts/arch-run.bash
 
+case "$TARGET" in
+qemu)
+    ;;
+*)
+    echo "$0 does not support '$TARGET'"
+    exit 2
+esac
+
 if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
 	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
 elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
diff --git a/arm/run b/arm/run
index efdd44ce86a7..6db32cf09c88 100755
--- a/arm/run
+++ b/arm/run
@@ -8,6 +8,15 @@ if [ -z "$KUT_STANDALONE" ]; then
 	source config.mak
 	source scripts/arch-run.bash
 fi
+
+case "$TARGET" in
+qemu)
+    ;;
+*)
+   echo "'$TARGET' not supported"
+   exit 3
+esac
+
 processor="$PROCESSOR"
 
 if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
diff --git a/run_tests.sh b/run_tests.sh
index 23d81b2caaa1..61480d0c05ed 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -100,6 +100,14 @@ while [ $# -gt 0 ]; do
     shift
 done
 
+case "$TARGET" in
+qemu)
+    ;;
+*)
+    echo "$0 does not support '$TARGET'"
+    exit 2
+esac
+
 # RUNTIME_log_file will be configured later
 if [[ $tap_output == "no" ]]; then
     process_test_output() { cat >> $RUNTIME_log_file; }
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 2318a85f0706..4de97056e641 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -7,6 +7,14 @@ fi
 source config.mak
 source scripts/common.bash
 
+case "$TARGET" in
+qemu)
+    ;;
+*)
+    echo "'$TARGET' not supported for standlone tests"
+    exit 2
+esac
+
 temp_file ()
 {
 	local var="$1"
-- 
2.47.1


