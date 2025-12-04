Return-Path: <kvm+bounces-65282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C2DCA3FF1
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 15:24:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D5A703010E5A
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 14:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4BB433ADB2;
	Thu,  4 Dec 2025 14:23:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5162FD667
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 14:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764858232; cv=none; b=WQyLMyGaqPc40o6rPJXyyVXhibm2Jz0DOX6D/O7xMkCwP9HY2Cqjnkf5XjpN9blBbiXt+j2hIGM1PO3fIQ6HXhlcojTSd86M/mL/5FcjNflH/+dH3QH9XZKWiQsxiWa9IUQtnPFguPgbzDwdQng4ftQlLXdQUTb0IHC3+lp6rxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764858232; c=relaxed/simple;
	bh=Jq9hTm+PWw3J7nwlRwF/nIpZ3RQ50hoxepqhSZ3LRYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Aq4ZnZf1QvxCQOr/jLTSYV/WqXa8+gtDtT54NdEiVANRM1g+1G+bSZFc4h77G0NyTGFjSFYUh3YzFKhPvkDKWedOjUp3had8jAWzjnY2zgatukVnhbLPSZuRdvLzFwftKiHLeykG0jUhBcGBXwKTN37v1PlX/kxD2Am3gL/Fr3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90B801764;
	Thu,  4 Dec 2025 06:23:43 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77BE33F73B;
	Thu,  4 Dec 2025 06:23:49 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v4 03/11] arm64: efi: initialise SCTLR_ELx fully
Date: Thu,  4 Dec 2025 14:23:30 +0000
Message-Id: <20251204142338.132483-4-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251204142338.132483-1-joey.gouly@arm.com>
References: <20251204142338.132483-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't rely on the value of SCTLR_ELx when booting via EFI.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
---
 lib/arm/asm/setup.h   |  6 ++++++
 lib/arm/setup.c       |  2 ++
 lib/arm64/processor.c | 14 ++++++++++++++
 3 files changed, 22 insertions(+)

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
index 67b5db07..49f5e0f6 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -349,6 +349,8 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
 
+	setup_efi_sctlr();
+
 	exceptions_init();
 
 	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index eb93fd7c..f9fea519 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
+#include <asm/setup.h>
 #include <asm/thread_info.h>
 
 static const char *vector_names[] = {
@@ -271,3 +272,16 @@ bool __mmu_enabled(void)
 {
 	return read_sysreg(sctlr_el1) & SCTLR_EL1_M;
 }
+
+#ifdef CONFIG_EFI
+
+void setup_efi_sctlr(void)
+{
+	/*
+	 * EFI exits boot services with SCTLR_ELx.M=1, so keep
+	 * the MMU enabled.
+	 */
+	write_sysreg(INIT_SCTLR_EL1_MMU_OFF | SCTLR_EL1_M, sctlr_el1);
+}
+
+#endif
-- 
2.25.1


