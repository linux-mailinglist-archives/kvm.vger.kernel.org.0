Return-Path: <kvm+bounces-50727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AD8EAE88C0
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1DF74A6311
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DAD72BD5A2;
	Wed, 25 Jun 2025 15:49:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A4013A3F7;
	Wed, 25 Jun 2025 15:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750866570; cv=none; b=NF9vnxKHg+v8Gg/7Q75TCH+XDDjk5qSyUM6IoaEU809Xef/y5LSeCrOth5DwE8DI0/e3kcnWHesvlrxP+kGX47gt6bdy40RavRuJ4uSg94a7TNU/eb1JoTdJXTMDYYlSPgGeIbcMUIsBUcxyLq99NQ3fS2Y08i3nMBd+kK41+yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750866570; c=relaxed/simple;
	bh=UcaF+RM74HELqD9NzI9ZD/mxs5OFIx7qV6Hu9KL8iHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nn8bXDbV8cRt8qh41I/hHbq+lVYuGPUHD6uo25y80ubbD9VXWNOCx/OjU7vq3Bm37qyrDC+vM5wZ4AlauBntQw9O8NJHuF6wTzgHpWQ+p8XXsIc4duBOSzt1VXEp60bfbaK7ogy1y9piEJN66419JkuiWUHROMJk5Vow2K/cawo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 698912682;
	Wed, 25 Jun 2025 08:49:10 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3571D3F58B;
	Wed, 25 Jun 2025 08:49:24 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v4 13/13] scripts: Enable kvmtool
Date: Wed, 25 Jun 2025 16:48:13 +0100
Message-ID: <20250625154813.27254-14-alexandru.elisei@arm.com>
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

Everything is in place to run the tests using kvmtool:

$ ./configure --target=kvmtool
$ make clean && make
$ KVMTOOL=<path/to/kvmtool> ./run_tests.sh

so enable it, and remove ERRATA_FORCE=y when configuring for kvmtool,
because the runner will generate and pass the correct environment to
kvmtool.

Support for EFI tests is missing. That's because distros don't ship a
EDK2 binary compiled for kvmtool, and on top of that kvm-unit-tests as
an EFI app hasn't been tested to work with kvmtool.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 README.md        | 18 +++++++++++++++++-
 arm/efi/run      |  5 +++++
 configure        |  1 -
 scripts/vmm.bash |  2 +-
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/README.md b/README.md
index be07dc28a094..723ce04cd978 100644
--- a/README.md
+++ b/README.md
@@ -65,6 +65,9 @@ or:
 
 to run them all.
 
+All tests can be run using QEMU. On arm and arm64, tests can also be run using
+kvmtool.
+
 By default the runner script searches for a suitable QEMU binary in the system.
 To select a specific QEMU binary though, specify the QEMU=path/to/binary
 environment variable:
@@ -78,12 +81,25 @@ ACCEL=name environment variable:
 
 For running tests that involve migration from one QEMU instance to another
 you also need to have the "ncat" binary (from the nmap.org project) installed,
-otherwise the related tests will be skipped.
+otherwise the related tests will be skipped. kvmtool does not support migration.
+
+As for running a test with kvmtool, please configure kvm-unit-tests accordingly
+first:
+
+   ./configure --arch=arm64 --target=kvmtool
+
+then run the test(s) like with QEMU above.
+
+To select a kvmtool binary, specify the KVMTOOL=path/to/binary environment
+variable. kvmtool supports only kvm as the accelerator.
 
 ## Running the tests with UEFI
 
 Check [x86/efi/README.md](./x86/efi/README.md).
 
+On arm and arm64, this is only supported with QEMU; kvmtool cannot run the
+tests under UEFI.
+
 # Tests configuration file
 
 The test case may need specific runtime configurations, for
diff --git a/arm/efi/run b/arm/efi/run
index 38800e8bfa13..12d7a4186230 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -15,6 +15,11 @@ source scripts/vmm.bash
 
 vmm_check_supported
 
+if [[ $(vmm_get_target) == "kvmtool" ]]; then
+	echo "kvmtool does not support EFI tests."
+	exit 2
+fi
+
 if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
 	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
 elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
diff --git a/configure b/configure
index 20bf5042cb9e..470f9d7cdb3b 100755
--- a/configure
+++ b/configure
@@ -378,7 +378,6 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
         : "${uart_early_addr:=0x9000000}"
     elif [ "$target" = "kvmtool" ]; then
         : "${uart_early_addr:=0x1000000}"
-        errata_force=1
     else
         echo "--target must be one of 'qemu' or 'kvmtool'!"
         usage
diff --git a/scripts/vmm.bash b/scripts/vmm.bash
index 724c96f9e665..f2c987d92405 100644
--- a/scripts/vmm.bash
+++ b/scripts/vmm.bash
@@ -204,7 +204,7 @@ function vmm_check_supported()
 	local target=$(vmm_get_target)
 
 	case "$target" in
-	qemu)
+	qemu | kvmtool)
 		return 0
 		;;
 	*)
-- 
2.50.0


