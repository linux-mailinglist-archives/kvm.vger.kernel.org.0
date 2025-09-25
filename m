Return-Path: <kvm+bounces-58768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3C40B9FFE1
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 16:28:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 150E82A3948
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 14:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C4E2C236D;
	Thu, 25 Sep 2025 14:25:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F33E62C11E3
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 14:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758810312; cv=none; b=EOJ0kWv0wm2LOGU8xC/XQCrl8+II0RBpiFocygRV3vC2vjtq7+eJYrqnEg/Jha7Sar1yK4kddrPhJazl+poNYz7K215rlGC2himkVjZgji573d7qjVx6YZt1hzXBkx2OtWbhrgd70r8SXE+9cv0TaOUamnpxpyFs4xYJ+gDmZ2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758810312; c=relaxed/simple;
	bh=9pva0NYYVrVnVowafhPTeGnxCc1w7+eHzqtnl58q2PE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XJ6BfNuyuKzRbwKvVUSOCncSjWcuMfREPIgeY51dAOwY4Z5h9prLuVsavld7AGSF0QLb7/Nt1pVlvJQt9OpXgMwLWSrdnHEeznd21c1md9/7rDwtL2BYnWq8WKhFEOMcOpuVCpsX0+8EmQErlUv6XCzy464/SqQLCkE5rMBDb/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E6992936;
	Thu, 25 Sep 2025 07:25:02 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 228793F694;
	Thu, 25 Sep 2025 07:25:08 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v3 02/10] arm64: efi: initialise SCTLR_ELx fully
Date: Thu, 25 Sep 2025 15:19:50 +0100
Message-Id: <20250925141958.468311-3-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250925141958.468311-1-joey.gouly@arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't rely on the value of SCTLR_ELx when booting via EFI.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/arm/asm/setup.h   |  6 ++++++
 lib/arm/setup.c       |  3 +++
 lib/arm64/processor.c | 12 ++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
index 9f8ef82e..4e60d552 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -28,6 +28,12 @@ void setup(const void *fdt, phys_addr_t freemem_start);
 
 #include <efi.h>
 
+#ifdef __aarch64__
+void setup_efi_sctlr(void);
+#else
+static inline void setup_efi_sctlr(void) {}
+#endif
+
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
 
 #endif
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 67b5db07..0aaa1d3a 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -349,6 +349,9 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
 
+
+	setup_efi_sctlr();
+
 	exceptions_init();
 
 	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index eb93fd7c..edc0ad87 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
+#include <asm/setup.h>
 #include <asm/thread_info.h>
 
 static const char *vector_names[] = {
@@ -271,3 +272,14 @@ bool __mmu_enabled(void)
 {
 	return read_sysreg(sctlr_el1) & SCTLR_EL1_M;
 }
+
+#ifdef CONFIG_EFI
+
+void setup_efi_sctlr(void)
+{
+	// EFI exits boot services with SCTLR_ELx.M=1, so keep
+	// the MMU enabled.
+	write_sysreg(INIT_SCTLR_EL1_MMU_OFF | SCTLR_EL1_M, sctlr_el1);
+}
+
+#endif
-- 
2.25.1


