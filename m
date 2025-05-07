Return-Path: <kvm+bounces-45722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A7F9AAE416
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:14:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8FCE5083BE
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB4928A3E4;
	Wed,  7 May 2025 15:13:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5689A15624D;
	Wed,  7 May 2025 15:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630816; cv=none; b=k6nIYI6ik/wlfIE3KYAnJGD3c1KvlGnvDGHkC5w5rAIn0THsyRNowWWtSJS6Nl4isTP/pmy1b9h6Q5Y7sbLDjn2cPMOw6TOSfiAnTFycK7akV3vsRoA0JU+aFnV8vrsbOU5C5iZmuNCljK4bw4gdQwAjU6+VBg4pj1U1RW4VqH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630816; c=relaxed/simple;
	bh=PQHpDjezf6GCJ1taDU3aK3/vDpfbQga8bXu5hpt8nzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iqs/IqZCn3+CW1nMjfA6Gou5Mr7mDj/GdLrSl+QCyEh4OPVCnYNosAkIzj2ZQNwOKkSkgZPxnxVqHMHWHRXsCjoo5kkboCrsq3QQW6XkZgsM4g1Qo1zn9dSzYiCV3cgva+jDGcV8Gp0APKLHuyPGMjEAB2GmJ6bsWpTmn1Cxzz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9A312103;
	Wed,  7 May 2025 08:13:24 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1FA03F58B;
	Wed,  7 May 2025 08:13:31 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v3 06/16] scripts: Refuse to run the tests if not configured for qemu
Date: Wed,  7 May 2025 16:12:46 +0100
Message-ID: <20250507151256.167769-7-alexandru.elisei@arm.com>
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

Arm and arm64 support running the tests under kvmtool. kvmtool has a
different command line syntax for configuring and running a virtual
machine, and the automated scripts know only how to use qemu.

One issue with that is even though the tests have been configured for
kvmtool (with ./configure --target=kvmtool), the scripts will use qemu to
run the tests, and without looking at the logs there is no indication that
the tests haven't been run with kvmtool, as configured.

Another issue is that kvmtool uses a different address for the UART and
when running the tests with qemu via the scripts, this warning is
displayed:

WARNING: early print support may not work. Found uart at 0x9000000, but early base is 0x1000000.

which might trip up an unsuspected user.

There are four different ways to run a test using the test infrastructure:
with run_tests.sh, by invoking arm/run or arm/efi/run with the correct
parameters (only the arm directory is mentioned here because the tests can
be configured for kvmtool only on arm and arm64), and by creating
standalone tests.

run_tests.sh ends up execuing either arm/run or arm/efi/run, so add a check
to these two scripts for the test target, and refuse to run the test if
kvm-unit-tests has been configured for kvmtool.

mkstandalone.sh also executes arm/run or arm/efi run, but the usual use
case for standalone tests is to compile them on one machine, and then to
run them on a different machine. This two step process can be time
consuming, so save the user time (and frustration!) and add a check
directly to mkstandalone.sh.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/efi/run             |  3 +++
 arm/run                 |  4 ++++
 scripts/mkstandalone.sh |  3 +++
 scripts/vmm.bash        | 14 ++++++++++++++
 4 files changed, 24 insertions(+)
 create mode 100644 scripts/vmm.bash

diff --git a/arm/efi/run b/arm/efi/run
index 8f41fc02df31..53d71297cc52 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -11,6 +11,9 @@ if [ ! -f config.mak ]; then
 fi
 source config.mak
 source scripts/arch-run.bash
+source scripts/vmm.bash
+
+check_vmm_supported
 
 if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
 	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
diff --git a/arm/run b/arm/run
index ef58558231b7..56562ed1628f 100755
--- a/arm/run
+++ b/arm/run
@@ -7,7 +7,11 @@ if [ -z "$KUT_STANDALONE" ]; then
 	fi
 	source config.mak
 	source scripts/arch-run.bash
+	source scripts/vmm.bash
 fi
+
+check_vmm_supported
+
 qemu_cpu="$TARGET_CPU"
 
 if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index c4ba81f18935..4f666cefe076 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -6,6 +6,9 @@ if [ ! -f config.mak ]; then
 fi
 source config.mak
 source scripts/common.bash
+source scripts/vmm.bash
+
+check_vmm_supported
 
 temp_file ()
 {
diff --git a/scripts/vmm.bash b/scripts/vmm.bash
new file mode 100644
index 000000000000..39325858c6b3
--- /dev/null
+++ b/scripts/vmm.bash
@@ -0,0 +1,14 @@
+source config.mak
+
+function check_vmm_supported()
+{
+	case "$TARGET" in
+	qemu)
+		return 0
+		;;
+	*)
+		echo "$0 does not support target '$TARGET'"
+		exit 2
+		;;
+	esac
+}
-- 
2.49.0


