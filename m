Return-Path: <kvm+bounces-36044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55AF8A1707A
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:44:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D24F7188232E
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EF2E1EE036;
	Mon, 20 Jan 2025 16:44:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AAAD1EE024;
	Mon, 20 Jan 2025 16:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391452; cv=none; b=ebyEisn+KsrDdiQKBLGyNuGYRYt8wTQTAEii/0LPse0Sx9kfD8+nf1kBA7yeQqt2pCOikE3pICU+iSurx3Frbwby2YFuOfmbFPz0Ltx331btiI5AL1prk33MrXpn40rRXHcwxyPiU6bb46n+693kw00Qbz0KQYztveL46x8AcwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391452; c=relaxed/simple;
	bh=LQRDkRD17AHx/7dGR1PQPz1U+TQtVIHPhH0+e0jOdqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LnXmpvqUJp5hFbo2eba5JAII7PvlEWLe3byU6rF5yxMbPx2O5Tld53pSni8NZBqgI7wVWBfvgw2UMbkgCNSHtQEpJy42E2/zt4dXY0HLlIsCGt6/gs6bvAYywoy0mO+Cddxelr2eeE26rG+gIJtMDuWED5eoLsTCiYXSV+SUJqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18899FEC;
	Mon, 20 Jan 2025 08:44:39 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7170E3F5A1;
	Mon, 20 Jan 2025 08:44:07 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v2 11/18] arm/run: Add support for kvmtool
Date: Mon, 20 Jan 2025 16:43:09 +0000
Message-ID: <20250120164316.31473-12-alexandru.elisei@arm.com>
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

Teach the arm runner to use kvmtool when kvm-unit-tests has been configured
appropriately.

The test is ran using run_test_status() because kvmtool does not have a
testdev device to return the test exit code, so kvm-unit-tests must always
parse the "EXIT: STATUS" line for the exit code.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/run | 183 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 110 insertions(+), 73 deletions(-)

diff --git a/arm/run b/arm/run
index 9b11feafffdd..880d5afae86d 100755
--- a/arm/run
+++ b/arm/run
@@ -17,77 +17,114 @@ qemu)
    exit 3
 esac
 
-processor="$PROCESSOR"
+arch_run_qemu()
+{
+    processor="$PROCESSOR"
+
+    if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
+       [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
+       [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
+        ACCEL="tcg"
+    fi
+
+    set_qemu_accelerator || exit $?
+    if [ "$ACCEL" = "kvm" ]; then
+        QEMU_ARCH=$HOST
+    fi
+
+    qemu=$(search_qemu_binary) ||
+        exit $?
+
+    if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
+        echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
+        exit 2
+    fi
+
+    M='-machine virt'
+
+    if [ "$ACCEL" = "kvm" ]; then
+        if $qemu $M,\? | grep -q gic-version; then
+            M+=',gic-version=host'
+        fi
+    fi
+
+    if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
+        if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
+            processor="host"
+            if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
+                processor+=",aarch64=off"
+            fi
+        fi
+    fi
+
+    if [ "$ARCH" = "arm" ]; then
+        M+=",highmem=off"
+    fi
+
+    if ! $qemu $M -device '?' | grep -q virtconsole; then
+        echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
+        exit 2
+    fi
+
+    if ! $qemu $M -chardev '?' | grep -q testdev; then
+        echo "$qemu doesn't support chr-testdev. Exiting."
+        exit 2
+    fi
+
+    if [ "$UEFI_SHELL_RUN" != "y" ] && [ "$EFI_USE_ACPI" != "y" ]; then
+        chr_testdev='-device virtio-serial-device'
+        chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
+    fi
+
+    pci_testdev=
+    if $qemu $M -device '?' | grep -q pci-testdev; then
+        pci_testdev="-device pci-testdev"
+    fi
+
+    A="-accel $ACCEL$ACCEL_PROPS"
+    command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
+    command+=" -display none -serial stdio"
+    command="$(migration_cmd) $(timeout_cmd) $command"
+
+    if [ "$UEFI_SHELL_RUN" = "y" ]; then
+        ENVIRON_DEFAULT=n run_test_status $command "$@"
+    elif [ "$EFI_USE_ACPI" = "y" ]; then
+        run_test_status $command -kernel "$@"
+    else
+        run_qemu $command -kernel "$@"
+    fi
+}
+
+arch_run_kvmtool()
+{
+    local command
+
+    kvmtool=$(search_kvmtool_binary) ||
+        exit $?
+
+    if [ "$ACCEL" ] && [ "$ACCEL" != "kvm" ]; then
+        echo "kvmtool does not support $ACCEL" >&2
+        exit 2
+    fi
+
+    if ! kvm_available; then
+        echo "KVM required by kvmtool but not available on the host" >&2
+        exit 2
+    fi
+
+    command="$(timeout_cmd) $kvmtool run"
+    if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
+	    run_test_status $command --kernel "$@" --aarch32
+    else
+	    run_test_status $command --kernel "$@"
+    fi
+}
 
-if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
-   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
-   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
-	ACCEL="tcg"
-fi
-
-set_qemu_accelerator || exit $?
-if [ "$ACCEL" = "kvm" ]; then
-	QEMU_ARCH=$HOST
-fi
-
-qemu=$(search_qemu_binary) ||
-	exit $?
-
-if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
-	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
-	exit 2
-fi
-
-M='-machine virt'
-
-if [ "$ACCEL" = "kvm" ]; then
-	if $qemu $M,\? | grep -q gic-version; then
-		M+=',gic-version=host'
-	fi
-fi
-
-if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
-	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
-		processor="host"
-		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
-			processor+=",aarch64=off"
-		fi
-	fi
-fi
-
-if [ "$ARCH" = "arm" ]; then
-	M+=",highmem=off"
-fi
-
-if ! $qemu $M -device '?' | grep -q virtconsole; then
-	echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
-	exit 2
-fi
-
-if ! $qemu $M -chardev '?' | grep -q testdev; then
-	echo "$qemu doesn't support chr-testdev. Exiting."
-	exit 2
-fi
-
-if [ "$UEFI_SHELL_RUN" != "y" ] && [ "$EFI_USE_ACPI" != "y" ]; then
-	chr_testdev='-device virtio-serial-device'
-	chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
-fi
-
-pci_testdev=
-if $qemu $M -device '?' | grep -q pci-testdev; then
-	pci_testdev="-device pci-testdev"
-fi
-
-A="-accel $ACCEL$ACCEL_PROPS"
-command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
-command+=" -display none -serial stdio"
-command="$(migration_cmd) $(timeout_cmd) $command"
-
-if [ "$UEFI_SHELL_RUN" = "y" ]; then
-	ENVIRON_DEFAULT=n run_test_status $command "$@"
-elif [ "$EFI_USE_ACPI" = "y" ]; then
-	run_test_status $command -kernel "$@"
-else
-	run_qemu $command -kernel "$@"
-fi
+case "$TARGET" in
+qemu)
+    arch_run_qemu "$@"
+    ;;
+kvmtool)
+    arch_run_kvmtool "$@"
+    ;;
+esac
-- 
2.47.1


