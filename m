Return-Path: <kvm+bounces-68021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1039DD1E994
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 12:59:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EDD69304F672
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 11:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3D9C396B90;
	Wed, 14 Jan 2026 11:58:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDF48396B7B
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 11:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768391934; cv=none; b=S7ZC2mjoXxHL71e7B9GRDBHmpUQ3WFlGE+wlgCiJWYyYvxrWyFhlv+OOqxg/x0Cqy57+coRqnbdGGt0DEqDBj/L900W9CDzMke2KX79oRBpLGJY6tewrDA8gnocSSEUIaPjpWhZdst0lu8or7fSTgMrnIr/k3Z/I50pjlOSjI7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768391934; c=relaxed/simple;
	bh=lTAd+cSrAKQbphfN04cubMn5zwsIIrhwsicRsNkWGrY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hfGNgMSlmLzj/cB+wZfrNUCQMkn9WM2qFrUsRazlJ41Ilf1TvO0is/s6WTBTByEBEYRFyD3ytEDR7cbH4E7l4dKg06Yvezlk+82oIYVp75F2Qu29hduaLiF1eRjuK+zd/065ELFNSR6LTTFrcTxhkHOH/VqPCky/9oPH9p5Y86c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A4D81516;
	Wed, 14 Jan 2026 03:58:41 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 80CB63F632;
	Wed, 14 Jan 2026 03:58:46 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v5 02/11] arm64: drop to EL1 if booted at EL2
Date: Wed, 14 Jan 2026 11:56:54 +0000
Message-Id: <20260114115703.926685-3-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260114115703.926685-1-joey.gouly@arm.com>
References: <20260114115703.926685-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EL2 is not currently supported, drop to EL1 to conitnue booting.

This sets up a minimal EL2 environment. It is similar to el2_setup.h in Linux,
but since kvm-unit-tests does not currently use any of the features (stage2,
POE, PIE, BRBE, GCS, ...) covered by that file, only the Fine Grained Traps
registers are dealt with.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
---
 arm/cstart64.S         | 48 +++++++++++++++++++++++++++++++++++++++---
 lib/arm64/asm/sysreg.h | 14 ++++++++++++
 2 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index dcdd1516..2b93f234 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -15,6 +15,46 @@
 #include <asm/thread_info.h>
 #include <asm/sysreg.h>
 
+.macro init_el, tmp
+	mrs	\tmp, CurrentEL
+	cmp	\tmp, CurrentEL_EL2
+	b.ne	1f
+	/* EL2 setup */
+	mrs	\tmp, mpidr_el1
+	msr	vmpidr_el2, \tmp
+	mrs	\tmp, midr_el1
+	msr	vpidr_el2, \tmp
+	/* clear FGT registers if supported */
+	mrs	\tmp, id_aa64mmfr0_el1
+	ubfx	\tmp, \tmp, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
+	cbz	\tmp, .Lskip_fgt_\@
+	mov	\tmp, #0
+	msr_s	SYS_HFGRTR_EL2, \tmp
+	msr_s	SYS_HFGWTR_EL2, \tmp
+	msr_s	SYS_HFGITR_EL2, \tmp
+	mrs	\tmp, id_aa64mmfr0_el1
+	ubfx	\tmp, \tmp, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
+	cmp	\tmp, #ID_AA64MMFR0_EL1_FGT_FGT2
+	bne	.Lskip_fgt_\@
+	mov	\tmp, #0
+	msr_s	SYS_HFGRTR2_EL2, \tmp
+	msr_s	SYS_HFGWTR2_EL2, \tmp
+	msr_s	SYS_HFGITR2_EL2, \tmp
+.Lskip_fgt_\@:
+	mov	\tmp, #0
+	msr	cptr_el2, \tmp
+	ldr	\tmp, =(INIT_HCR_EL2_EL1_ONLY)
+	msr	hcr_el2, \tmp
+	mov	\tmp, PSR_MODE_EL1t
+	msr	spsr_el2, \tmp
+	adrp	\tmp, 1f
+	add	\tmp, \tmp, :lo12:1f
+	msr	elr_el2, \tmp
+	eret
+1:
+.endm
+
+
 #ifdef CONFIG_EFI
 #include "efi/crt0-efi-aarch64.S"
 #else
@@ -56,15 +96,15 @@ start:
 	add     x6, x6, :lo12:reloc_end
 1:
 	cmp	x5, x6
-	b.hs	1f
+	b.hs	reloc_done
 	ldr	x7, [x5]			// r_offset
 	ldr	x8, [x5, #16]			// r_addend
 	add	x8, x8, x4			// val = base + r_addend
 	str	x8, [x4, x7]			// base[r_offset] = val
 	add	x5, x5, #24
 	b	1b
-
-1:
+reloc_done:
+	init_el x4
 	/* zero BSS */
 	adrp	x4, bss
 	add	x4, x4, :lo12:bss
@@ -185,6 +225,8 @@ get_mmu_off:
 
 .globl secondary_entry
 secondary_entry:
+	init_el x0
+
 	/* set SCTLR_EL1 to a known value */
 	ldr	x0, =INIT_SCTLR_EL1_MMU_OFF
 	msr	sctlr_el1, x0
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index e537bb46..ed776716 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -77,6 +77,9 @@ asm(
 #define ID_AA64ISAR0_EL1_RNDR_SHIFT	60
 #define ID_AA64PFR1_EL1_MTE_SHIFT	8
 
+#define ID_AA64MMFR0_EL1_FGT_SHIFT	56
+#define ID_AA64MMFR0_EL1_FGT_FGT2	0x2
+
 #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
 #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
 #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
@@ -113,6 +116,17 @@ asm(
 #define SCTLR_EL1_TCF0_SHIFT	38
 #define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
 
+#define HCR_EL2_RW		_BITULL(31)
+
+#define INIT_HCR_EL2_EL1_ONLY	(HCR_EL2_RW)
+
+#define SYS_HFGRTR_EL2		sys_reg(3, 4, 1, 1, 4)
+#define SYS_HFGWTR_EL2		sys_reg(3, 4, 1, 1, 5)
+#define SYS_HFGITR_EL2		sys_reg(3, 4, 1, 1, 6)
+#define SYS_HFGRTR2_EL2		sys_reg(3, 4, 3, 1, 2)
+#define SYS_HFGWTR2_EL2		sys_reg(3, 4, 3, 1, 3)
+#define SYS_HFGITR2_EL2		sys_reg(3, 4, 3, 1, 7)
+
 #define INIT_SCTLR_EL1_MMU_OFF	\
 			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
 			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
-- 
2.25.1


