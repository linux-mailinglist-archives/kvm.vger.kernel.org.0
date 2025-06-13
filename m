Return-Path: <kvm+bounces-49359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E0E0AD8109
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 04:37:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B1761E036F
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9350424677D;
	Fri, 13 Jun 2025 02:37:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A911E2441A7;
	Fri, 13 Jun 2025 02:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749782222; cv=none; b=BGwOVcs16y1GFsDYrhUbJd4sguG+f4/Hs2pL3Y17Y45xv3nEn9qx84ewSWmyXXjWt70T5J5XzuJhIffsKF/c7+6ABrhFPX9YdTvfO1xbYs1GeY+ncppfzBgovKINtS2BGXunoFxs5/S9sztSNg/l0DyEwGSYIUOLZTvIvbYcfpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749782222; c=relaxed/simple;
	bh=q7LOhcfTuYgJ/eGhLYV8ZFBmjD4NrhGuifa8CK45lVY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GSPpNFomWomUqVVWAVbGMD+r9/urd4w6J15fYOwJlKFg8toaNhzc21XfN8qoG+VKJQXiCFxu6BzYzqQfS5r8cohtdcm4lDmaWVRYo6eRUAFSThQdEAcQsDb5WtB8vpQfbJyH8WXzt2SgqJgSZbPRiMLrXylEKBrl7rbVSA5HB5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F123D1D6F;
	Thu, 12 Jun 2025 19:36:38 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 90B003F673;
	Thu, 12 Jun 2025 19:36:55 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH V5 1/2] arm64/debug: Drop redundant DBG_MDSCR_* macros
Date: Fri, 13 Jun 2025 08:06:45 +0530
Message-Id: <20250613023646.1215700-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250613023646.1215700-1-anshuman.khandual@arm.com>
References: <20250613023646.1215700-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

MDSCR_EL1 has already been defined in tools sysreg format and hence can be
used in all debug monitor related call paths. But using generated sysreg
definitions causes build warnings because there is a mismatch between mdscr
variable (u32) and GENMASK() based masks (long unsigned int). Convert all
variables handling MDSCR_EL1 register as u64 which also reflects its true
width as well.

--------------------------------------------------------------------------
arch/arm64/kernel/debug-monitors.c: In function ‘disable_debug_monitors’:
arch/arm64/kernel/debug-monitors.c:108:13: warning: conversion from ‘long
unsigned int’ to ‘u32’ {aka ‘unsigned int’} changes value from
‘18446744073709518847’ to ‘4294934527’ [-Woverflow]
  108 |   disable = ~MDSCR_EL1_MDE;
      |             ^
--------------------------------------------------------------------------

While here, replace an open encoding with MDSCR_EL1_TDCC in __cpu_setup().

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/assembler.h      |  4 ++--
 arch/arm64/include/asm/debug-monitors.h |  6 ------
 arch/arm64/kernel/debug-monitors.c      | 22 +++++++++++-----------
 arch/arm64/kernel/entry-common.c        |  4 ++--
 arch/arm64/mm/proc.S                    |  2 +-
 5 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index ad63457a05c5..f229d96616e5 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -53,7 +53,7 @@
 	.macro	disable_step_tsk, flgs, tmp
 	tbz	\flgs, #TIF_SINGLESTEP, 9990f
 	mrs	\tmp, mdscr_el1
-	bic	\tmp, \tmp, #DBG_MDSCR_SS
+	bic	\tmp, \tmp, #MDSCR_EL1_SS
 	msr	mdscr_el1, \tmp
 	isb	// Take effect before a subsequent clear of DAIF.D
 9990:
@@ -63,7 +63,7 @@
 	.macro	enable_step_tsk, flgs, tmp
 	tbz	\flgs, #TIF_SINGLESTEP, 9990f
 	mrs	\tmp, mdscr_el1
-	orr	\tmp, \tmp, #DBG_MDSCR_SS
+	orr	\tmp, \tmp, #MDSCR_EL1_SS
 	msr	mdscr_el1, \tmp
 9990:
 	.endm
diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
index 8f6ba31b8658..1f37dd01482b 100644
--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -13,14 +13,8 @@
 #include <asm/ptrace.h>
 
 /* Low-level stepping controls. */
-#define DBG_MDSCR_SS		(1 << 0)
 #define DBG_SPSR_SS		(1 << 21)
 
-/* MDSCR_EL1 enabling bits */
-#define DBG_MDSCR_KDE		(1 << 13)
-#define DBG_MDSCR_MDE		(1 << 15)
-#define DBG_MDSCR_MASK		~(DBG_MDSCR_KDE | DBG_MDSCR_MDE)
-
 #define	DBG_ESR_EVT(x)		(((x) >> 27) & 0x7)
 
 /* AArch64 */
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 58f047de3e1c..08f1d02507cd 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -34,7 +34,7 @@ u8 debug_monitors_arch(void)
 /*
  * MDSCR access routines.
  */
-static void mdscr_write(u32 mdscr)
+static void mdscr_write(u64 mdscr)
 {
 	unsigned long flags;
 	flags = local_daif_save();
@@ -43,7 +43,7 @@ static void mdscr_write(u32 mdscr)
 }
 NOKPROBE_SYMBOL(mdscr_write);
 
-static u32 mdscr_read(void)
+static u64 mdscr_read(void)
 {
 	return read_sysreg(mdscr_el1);
 }
@@ -79,16 +79,16 @@ static DEFINE_PER_CPU(int, kde_ref_count);
 
 void enable_debug_monitors(enum dbg_active_el el)
 {
-	u32 mdscr, enable = 0;
+	u64 mdscr, enable = 0;
 
 	WARN_ON(preemptible());
 
 	if (this_cpu_inc_return(mde_ref_count) == 1)
-		enable = DBG_MDSCR_MDE;
+		enable = MDSCR_EL1_MDE;
 
 	if (el == DBG_ACTIVE_EL1 &&
 	    this_cpu_inc_return(kde_ref_count) == 1)
-		enable |= DBG_MDSCR_KDE;
+		enable |= MDSCR_EL1_KDE;
 
 	if (enable && debug_enabled) {
 		mdscr = mdscr_read();
@@ -100,16 +100,16 @@ NOKPROBE_SYMBOL(enable_debug_monitors);
 
 void disable_debug_monitors(enum dbg_active_el el)
 {
-	u32 mdscr, disable = 0;
+	u64 mdscr, disable = 0;
 
 	WARN_ON(preemptible());
 
 	if (this_cpu_dec_return(mde_ref_count) == 0)
-		disable = ~DBG_MDSCR_MDE;
+		disable = ~MDSCR_EL1_MDE;
 
 	if (el == DBG_ACTIVE_EL1 &&
 	    this_cpu_dec_return(kde_ref_count) == 0)
-		disable &= ~DBG_MDSCR_KDE;
+		disable &= ~MDSCR_EL1_KDE;
 
 	if (disable) {
 		mdscr = mdscr_read();
@@ -415,7 +415,7 @@ void kernel_enable_single_step(struct pt_regs *regs)
 {
 	WARN_ON(!irqs_disabled());
 	set_regs_spsr_ss(regs);
-	mdscr_write(mdscr_read() | DBG_MDSCR_SS);
+	mdscr_write(mdscr_read() | MDSCR_EL1_SS);
 	enable_debug_monitors(DBG_ACTIVE_EL1);
 }
 NOKPROBE_SYMBOL(kernel_enable_single_step);
@@ -423,7 +423,7 @@ NOKPROBE_SYMBOL(kernel_enable_single_step);
 void kernel_disable_single_step(void)
 {
 	WARN_ON(!irqs_disabled());
-	mdscr_write(mdscr_read() & ~DBG_MDSCR_SS);
+	mdscr_write(mdscr_read() & ~MDSCR_EL1_SS);
 	disable_debug_monitors(DBG_ACTIVE_EL1);
 }
 NOKPROBE_SYMBOL(kernel_disable_single_step);
@@ -431,7 +431,7 @@ NOKPROBE_SYMBOL(kernel_disable_single_step);
 int kernel_active_single_step(void)
 {
 	WARN_ON(!irqs_disabled());
-	return mdscr_read() & DBG_MDSCR_SS;
+	return mdscr_read() & MDSCR_EL1_SS;
 }
 NOKPROBE_SYMBOL(kernel_active_single_step);
 
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 7c1970b341b8..171f93f2494b 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -344,7 +344,7 @@ static DEFINE_PER_CPU(int, __in_cortex_a76_erratum_1463225_wa);
 
 static void cortex_a76_erratum_1463225_svc_handler(void)
 {
-	u32 reg, val;
+	u64 reg, val;
 
 	if (!unlikely(test_thread_flag(TIF_SINGLESTEP)))
 		return;
@@ -354,7 +354,7 @@ static void cortex_a76_erratum_1463225_svc_handler(void)
 
 	__this_cpu_write(__in_cortex_a76_erratum_1463225_wa, 1);
 	reg = read_sysreg(mdscr_el1);
-	val = reg | DBG_MDSCR_SS | DBG_MDSCR_KDE;
+	val = reg | MDSCR_EL1_SS | MDSCR_EL1_KDE;
 	write_sysreg(val, mdscr_el1);
 	asm volatile("msr daifclr, #8");
 	isb();
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 80d470aa469d..eabf97c71dbf 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -454,7 +454,7 @@ SYM_FUNC_START(__cpu_setup)
 	dsb	nsh
 
 	msr	cpacr_el1, xzr			// Reset cpacr_el1
-	mov	x1, #1 << 12			// Reset mdscr_el1 and disable
+	mov	x1, MDSCR_EL1_TDCC		// Reset mdscr_el1 and disable
 	msr	mdscr_el1, x1			// access to the DCC from EL0
 	reset_pmuserenr_el0 x1			// Disable PMU access from EL0
 	reset_amuserenr_el0 x1			// Disable AMU access from EL0
-- 
2.25.1


