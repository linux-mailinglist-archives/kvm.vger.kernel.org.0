Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F45A037A
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 15:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfH1NjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 09:39:12 -0400
Received: from foss.arm.com ([217.140.110.172]:59670 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfH1NjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 09:39:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2244D1570;
        Wed, 28 Aug 2019 06:39:09 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 042AD3F246;
        Wed, 28 Aug 2019 06:39:07 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH 14/16] lib: arm64: Add support for disabling and re-enabling VHE
Date:   Wed, 28 Aug 2019 14:38:29 +0100
Message-Id: <1566999511-24916-15-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a function to disable VHE and another one to re-enable VHE. Both
functions work under the assumption that the CPU had VHE mode enabled at
boot.

Minimal support to run with VHE has been added to the TLB invalidate
functions and to the exception handling code.

Since we're touch the assembly enable/disable MMU code, let's take this
opportunity to replace a magic number with the proper define.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/processor.h       |   8 ++
 lib/arm64/asm/mmu.h           |  11 ++-
 lib/arm64/asm/pgtable-hwdef.h |  53 +++++++++---
 lib/arm64/asm/processor.h     |  44 +++++++++-
 lib/arm/processor.c           |  11 +++
 lib/arm/setup.c               |   2 +
 lib/arm64/processor.c         |  67 ++++++++++++++-
 arm/cstart64.S                | 186 +++++++++++++++++++++++++++++++++++++++++-
 8 files changed, 364 insertions(+), 18 deletions(-)

diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index a8c4628da818..d5df869b2e6f 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -9,6 +9,11 @@
 #include <asm/sysreg.h>
 #include <asm/barrier.h>
 
+#define CTR_DMINLINE_SHIFT	16
+#define CTR_DMINLINE_MASK	(0xf << 16)
+#define CTR_DMINLINE(x)	\
+	(((x) & CTR_DMINLINE_MASK) >> CTR_DMINLINE_SHIFT)
+
 enum vector {
 	EXCPTN_RST,
 	EXCPTN_UND,
@@ -26,6 +31,9 @@ extern void install_exception_handler(enum vector v, exception_fn fn);
 
 extern void show_regs(struct pt_regs *regs);
 
+extern unsigned int dcache_line_size;
+extern void set_dcache_line_size(void);
+
 static inline unsigned long current_cpsr(void)
 {
 	unsigned long cpsr;
diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
index fa554b0c20ae..6ce6c8958910 100644
--- a/lib/arm64/asm/mmu.h
+++ b/lib/arm64/asm/mmu.h
@@ -6,6 +6,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <asm/barrier.h>
+#include <asm/processor.h>
 
 #define PMD_SECT_UNCACHED	PMD_ATTRINDX(MT_DEVICE_nGnRE)
 #define PTE_WBWA		PTE_ATTRINDX(MT_NORMAL)
@@ -13,7 +14,10 @@
 static inline void flush_tlb_all(void)
 {
 	dsb(ishst);
-	asm("tlbi	vmalle1is");
+	if (current_level() == CurrentEL_EL2 && !cpu_el2_e2h_is_set())
+		asm("tlbi	alle2is");
+	else
+		asm("tlbi	vmalle1is");
 	dsb(ish);
 	isb();
 }
@@ -22,7 +26,10 @@ static inline void flush_tlb_page(unsigned long vaddr)
 {
 	unsigned long page = vaddr >> 12;
 	dsb(ishst);
-	asm("tlbi	vaae1is, %0" :: "r" (page));
+	if (current_level() == CurrentEL_EL2 && !cpu_el2_e2h_is_set())
+		asm("tlbi	vae2is, %0" :: "r" (page));
+	else
+		asm("tlbi	vaae1is, %0" :: "r" (page));
 	dsb(ish);
 }
 
diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
index e6f02fae4075..83364ccc28da 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -93,18 +93,42 @@
 /*
  * TCR flags.
  */
-#define TCR_TxSZ(x)		(((UL(64) - (x)) << 16) | ((UL(64) - (x)) << 0))
-#define TCR_IRGN_NC		((UL(0) << 8) | (UL(0) << 24))
-#define TCR_IRGN_WBWA		((UL(1) << 8) | (UL(1) << 24))
-#define TCR_IRGN_WT		((UL(2) << 8) | (UL(2) << 24))
-#define TCR_IRGN_WBnWA		((UL(3) << 8) | (UL(3) << 24))
-#define TCR_IRGN_MASK		((UL(3) << 8) | (UL(3) << 24))
-#define TCR_ORGN_NC		((UL(0) << 10) | (UL(0) << 26))
-#define TCR_ORGN_WBWA		((UL(1) << 10) | (UL(1) << 26))
-#define TCR_ORGN_WT		((UL(2) << 10) | (UL(2) << 26))
-#define TCR_ORGN_WBnWA		((UL(3) << 10) | (UL(3) << 26))
-#define TCR_ORGN_MASK		((UL(3) << 10) | (UL(3) << 26))
-#define TCR_SHARED		((UL(3) << 12) | (UL(3) << 28))
+#define TCR_T0SZ(x)		((UL(64) - (x)) << 0)
+#define TCR_T1SZ(x)		((UL(64) - (x)) << 16)
+#define TCR_TxSZ(x)		(TCR_T0SZ(x) | TCR_T1SZ(x))
+#define TCR_IRGN0_NC		(UL(0) << 8)
+#define TCR_IRGN1_NC		(UL(0) << 24)
+#define TCR_IRGN_NC		(TCR_IRGN0_NC | TCR_IRGN1_NC)
+#define TCR_IRGN0_WBWA		(UL(1) << 8)
+#define TCR_IRGN1_WBWA		(UL(1) << 24)
+#define TCR_IRGN_WBWA		(TCR_IRGN0_WBWA | TCR_IRGN1_WBWA)
+#define TCR_IRGN0_WT		(UL(2) << 8)
+#define TCR_IRGN1_WT		(UL(2) << 24)
+#define TCR_IRGN_WT		(TCR_IRGN0_WT | TCR_IRGN1_WT)
+#define TCR_IRGN0_WBnWA		(UL(3) << 8)
+#define TCR_IRGN1_WBnWA		(UL(3) << 24)
+#define TCR_IRGN_WBnWA		(TCR_IRGN0_WBnWA | TCR_IRGN1_WBnWA)
+#define TCR_IRGN0_MASK		(UL(3) << 8)
+#define TCR_IRGN1_MASK		(UL(3) << 24)
+#define TCR_IRGN_MASK		(TCR_IRGN0_MASK | TCR_IRGN1_MASK)
+#define TCR_ORGN0_NC		(UL(0) << 10)
+#define TCR_ORGN1_NC		(UL(0) << 26)
+#define TCR_ORGN_NC		(TCR_ORGN0_NC | TCR_ORGN1_NC)
+#define TCR_ORGN0_WBWA		(UL(1) << 10)
+#define TCR_ORGN1_WBWA		(UL(1) << 26)
+#define TCR_ORGN_WBWA		(TCR_ORGN0_WBWA | TCR_ORGN1_WBWA)
+#define TCR_ORGN0_WT		(UL(2) << 10)
+#define TCR_ORGN1_WT		(UL(2) << 26)
+#define TCR_ORGN_WT		(TCR_ORGN0_WT | TCR_ORGN1_WT)
+#define TCR_ORGN0_WBnWA		(UL(3) << 8)
+#define TCR_ORGN1_WBnWA		(UL(3) << 24)
+#define TCR_ORGN_WBnWA		(TCR_ORGN0_WBnWA | TCR_ORGN1_WBnWA)
+#define TCR_ORGN0_MASK		(UL(3) << 10)
+#define TCR_ORGN1_MASK		(UL(3) << 26)
+#define TCR_ORGN_MASK		(TCR_ORGN0_MASK | TCR_ORGN1_MASK)
+#define TCR_SH0_IS		(UL(3) << 12)
+#define TCR_SH1_IS		(UL(3) << 28)
+#define TCR_SHARED		(TCR_SH0_IS | TCR_SH1_IS)
 #define TCR_TG0_4K		(UL(0) << 14)
 #define TCR_TG0_64K		(UL(1) << 14)
 #define TCR_TG0_16K		(UL(2) << 14)
@@ -114,6 +138,11 @@
 #define TCR_ASID16		(UL(1) << 36)
 #define TCR_TBI0		(UL(1) << 37)
 
+#define TCR_EL1_IPS_SHIFT	32
+
+#define TCR_EL2_RES1		((UL(1) << 31) | (UL(1) << 23))
+#define TCR_EL2_PS_SHIFT	16
+
 /*
  * Memory types available.
  */
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index b9058f140039..4d12913ca01f 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -18,8 +18,20 @@
 #define SCTLR_EL1_A	(1 << 1)
 #define SCTLR_EL1_M	(1 << 0)
 
-#define HCR_EL2_TGE	(1 << 27)
-#define HCR_EL2_E2H	(UL(1) << 34)
+#define CTR_EL0_DMINLINE_SHIFT	16
+#define CTR_EL0_DMINLINE_MASK	(0xf << 16)
+#define CTR_EL0_DMINLINE(x)	\
+	(((x) & CTR_EL0_DMINLINE_MASK) >> CTR_EL0_DMINLINE_SHIFT)
+
+#define HCR_EL2_TGE		(1 << 27)
+#define HCR_EL2_E2H_SHIFT	34
+#define HCR_EL2_E2H		(UL(1) << 34)
+
+#define SCTLR_EL2_RES1		(3 << 28 | 3 << 22 | 1 << 18 |	\
+				 1 << 16 | 1 << 11 | 3 << 4)
+#define SCTLR_EL2_I		SCTLR_EL1_I
+#define SCTLR_EL2_C		SCTLR_EL1_C
+#define SCTLR_EL2_M		SCTLR_EL1_M
 
 #ifndef __ASSEMBLY__
 #include <asm/ptrace.h>
@@ -66,6 +78,12 @@ extern void vector_handlers_default_init(vector_fn *handlers);
 extern void show_regs(struct pt_regs *regs);
 extern bool get_far(unsigned int esr, unsigned long *far);
 
+extern unsigned int dcache_line_size;
+extern void set_dcache_line_size(void);
+
+extern void disable_vhe(void);
+extern void enable_vhe(void);
+
 static inline unsigned long current_level(void)
 {
 	unsigned long el;
@@ -116,5 +134,27 @@ static inline bool vhe_enabled(void)
 	return (hcr & HCR_EL2_E2H) && (hcr & HCR_EL2_TGE);
 }
 
+static inline bool cpu_el2_e2h_is_set(void)
+{
+	return read_sysreg(hcr_el2) & HCR_EL2_E2H;
+}
+
+#define dcache_by_line_op(op, start, end)	\
+	asm volatile(	"1:\n"			\
+			"dc	" #op ", %0\n"	\
+			"add	%0, %0, %2\n"	\
+			"cmp	%0, %1\n"	\
+			"b.lo	1b\n"		\
+			"dsb	ish\n"		\
+			:: "r" (start),		\
+			   "r" (end),		\
+			   "r" (dcache_line_size))
+
+#define dcache_inval_range(start, end)		\
+	dcache_by_line_op(ivac, start, end)
+
+#define dcache_clean_inval_range(start, end)	\
+	dcache_by_line_op(civac, start, end)
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */
diff --git a/lib/arm/processor.c b/lib/arm/processor.c
index 773337e6d3b7..927b77041e29 100644
--- a/lib/arm/processor.c
+++ b/lib/arm/processor.c
@@ -10,6 +10,8 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 
+unsigned int dcache_line_size;
+
 static const char *processor_modes[] = {
 	"USER_26", "FIQ_26" , "IRQ_26" , "SVC_26" ,
 	"UK4_26" , "UK5_26" , "UK6_26" , "UK7_26" ,
@@ -145,3 +147,12 @@ bool is_user(void)
 {
 	return current_thread_info()->flags & TIF_USER_MODE;
 }
+
+void set_dcache_line_size(void)
+{
+	u32 ctr;
+
+	asm volatile("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
+	/* DminLine is log2 of the number of words in the smallest cache line */
+	dcache_line_size = (1 << CTR_DMINLINE(ctr)) * 4;
+}
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 9253d2f886d9..1d4f35429740 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -22,6 +22,7 @@
 #include <asm/page.h>
 #include <asm/psci.h>
 #include <asm/smp.h>
+#include <asm/processor.h>
 
 #include "io.h"
 
@@ -64,6 +65,7 @@ static void cpu_init(void)
 	ret = dt_for_each_cpu_node(cpu_set, NULL);
 	assert(ret == 0);
 	set_cpu_online(0, true);
+	set_dcache_line_size();
 }
 
 static void mem_init(phys_addr_t freemem_start)
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 1ff997112314..d343798f7613 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -10,6 +10,8 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 
+unsigned int dcache_line_size;
+
 static const char *vector_names[] = {
 	"el1t_sync",
 	"el1t_irq",
@@ -84,7 +86,10 @@ bool get_far(unsigned int esr, unsigned long *far)
 {
 	unsigned int ec = esr >> ESR_EL1_EC_SHIFT;
 
-	asm volatile("mrs %0, far_el1": "=r" (*far));
+	if (current_level() == CurrentEL_EL2 && !cpu_el2_e2h_is_set())
+		asm volatile("mrs %0, far_el2": "=r" (*far));
+	else
+		asm volatile("mrs %0, far_el1": "=r" (*far));
 
 	switch (ec) {
 	case ESR_EL1_EC_IABT_EL0:
@@ -259,3 +264,63 @@ bool is_user(void)
 {
 	return current_thread_info()->flags & TIF_USER_MODE;
 }
+
+void set_dcache_line_size(void)
+{
+	u64 ctr;
+
+	ctr = read_sysreg(ctr_el0);
+	/* DminLine is log2 of the number of words in the smallest cache line */
+	dcache_line_size = (1 << CTR_EL0_DMINLINE(ctr)) * 4;
+}
+
+extern void asm_disable_vhe(void);
+void disable_vhe(void)
+{
+	u64 sp, sp_phys, sp_base, sp_base_phys;
+
+	assert(current_level() == CurrentEL_EL2 && vhe_enabled());
+
+	sp = current_stack_pointer;
+	sp_phys = __virt_to_phys(sp);
+	sp_base = sp & THREAD_MASK;
+	sp_base_phys = sp_phys & THREAD_MASK;
+
+	/*
+	 * We will disable, then enable the MMU, make sure the exception
+	 * handling code works during the small window of time when the MMU is
+	 * off.
+	 */
+	dcache_clean_inval_range(sp_base, sp_base + THREAD_SIZE);
+	dcache_inval_range(sp_base_phys, sp_base_phys + THREAD_SIZE);
+	asm volatile(	"mov	sp, %0\n" : :"r" (sp_phys));
+
+	asm_disable_vhe();
+
+	dcache_clean_inval_range(sp_base_phys, sp_base_phys + THREAD_SIZE);
+	dcache_inval_range(sp_base, sp_base + THREAD_SIZE);
+	asm volatile(	"mov	sp, %0\n" : :"r" (sp));
+}
+
+extern void asm_enable_vhe(void);
+void enable_vhe(void)
+{
+	u64 sp, sp_phys, sp_base, sp_base_phys;
+
+	assert(current_level() == CurrentEL_EL2 && !vhe_enabled());
+
+	sp = current_stack_pointer;
+	sp_phys = __virt_to_phys(sp);
+	sp_base = sp & THREAD_MASK;
+	sp_base_phys = sp_phys & THREAD_MASK;
+
+	dcache_clean_inval_range(sp_base, sp_base + THREAD_SIZE);
+	dcache_inval_range(sp_base_phys, sp_base_phys + THREAD_SIZE);
+	asm volatile(	"mov	sp, %0\n" : :"r" (sp_phys));
+
+	asm_enable_vhe();
+
+	dcache_clean_inval_range(sp_base_phys, sp_base_phys + THREAD_SIZE);
+	dcache_inval_range(sp_base, sp_base + THREAD_SIZE);
+	asm volatile(	"mov	sp, %0\n" : :"r" (sp));
+}
diff --git a/arm/cstart64.S b/arm/cstart64.S
index d4b20267a7a6..dc9e634e2307 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -104,6 +104,13 @@ exceptions_init:
 
 .text
 
+exceptions_init_nvhe:
+	adrp	x0, vector_table_nvhe
+	add	x0, x0, :lo12:vector_table_nvhe
+	msr	vbar_el2, x0
+	isb
+	ret
+
 .globl get_mmu_off
 get_mmu_off:
 	adrp	x0, auxinfo
@@ -204,7 +211,7 @@ asm_mmu_enable:
 		     TCR_IRGN_WBWA | TCR_ORGN_WBWA |	\
 		     TCR_SHARED
 	mrs	x2, id_aa64mmfr0_el1
-	bfi	x1, x2, #32, #3
+	bfi	x1, x2, #TCR_EL1_IPS_SHIFT, #3
 	msr	tcr_el1, x1
 
 	/* MAIR */
@@ -229,6 +236,33 @@ asm_mmu_enable:
 
 	ret
 
+asm_mmu_enable_nvhe:
+	ic      iallu
+	tlbi    alle2is
+	dsb     ish
+
+        /* TCR */
+	ldr	x1, =TCR_EL2_RES1 | 			\
+		     TCR_T0SZ(VA_BITS) |		\
+		     TCR_TG0_64K |                      \
+		     TCR_IRGN0_WBWA | TCR_ORGN0_WBWA |	\
+		     TCR_SH0_IS
+	mrs	x2, id_aa64mmfr0_el1
+	bfi	x1, x2, #TCR_EL2_PS_SHIFT, #3
+	msr	tcr_el2, x1
+
+	/* Same MAIR and TTBR0 as in VHE mode */
+
+	/* SCTLR */
+	ldr	x1, =SCTLR_EL2_RES1 |			\
+		     SCTLR_EL2_C | 			\
+		     SCTLR_EL2_I | 			\
+		     SCTLR_EL2_M
+	msr	sctlr_el2, x1
+	isb
+
+	ret
+
 .globl asm_mmu_disable
 asm_mmu_disable:
 	mrs	x0, sctlr_el1
@@ -237,6 +271,48 @@ asm_mmu_disable:
 	isb
 	ret
 
+asm_mmu_disable_nvhe:
+	mrs	x0, sctlr_el2
+	bic	x0, x0, SCTLR_EL2_M
+	msr	sctlr_el2, x0
+	isb
+	ret
+
+.globl asm_disable_vhe
+asm_disable_vhe:
+	str	x30, [sp, #-16]!
+
+	bl	asm_mmu_disable
+	/*
+	 * This goes *before* disabling VHE because using the _EL2 registers is
+	 * always correct, but using _EL1 registers is not when VHE is off.
+	 */
+	bl	exceptions_init_nvhe
+	msr	hcr_el2, xzr
+	isb
+	bl	asm_mmu_enable_nvhe
+
+	ldr	x30, [sp], #16
+	ret
+
+.globl asm_enable_vhe
+asm_enable_vhe:
+	str	x30, [sp, #-16]!
+
+	bl	asm_mmu_disable_nvhe
+	ldr	x0, =(HCR_EL2_E2H | HCR_EL2_TGE)
+	msr	hcr_el2, x0
+	isb
+	/* This goes *after* enabling VHE because it uses the _EL1 registers */
+	bl	exceptions_init
+	/* Make asm_mmu_enable happy by having TTBR0 value in x0 */
+	mrs	x0, ttbr0_el2
+	isb
+	bl	asm_mmu_enable
+
+	ldr	x30, [sp], #16
+	ret
+
 /*
  * Vectors
  * Adapted from arch/arm64/kernel/entry.S
@@ -327,6 +403,92 @@ vector_stub	el0_irq_32,   13
 vector_stub	el0_fiq_32,   14
 vector_stub	el0_error_32, 15
 
+.macro vector_stub_nvhe, name, vec
+\name:
+	stp	 x0,  x1, [sp, #-S_FRAME_SIZE]!
+	stp	 x2,  x3, [sp,  #16]
+	stp	 x4,  x5, [sp,  #32]
+	stp	 x6,  x7, [sp,  #48]
+	stp	 x8,  x9, [sp,  #64]
+	stp	x10, x11, [sp,  #80]
+	stp	x12, x13, [sp,  #96]
+	stp	x14, x15, [sp, #112]
+	stp	x16, x17, [sp, #128]
+	stp	x18, x19, [sp, #144]
+	stp	x20, x21, [sp, #160]
+	stp	x22, x23, [sp, #176]
+	stp	x24, x25, [sp, #192]
+	stp	x26, x27, [sp, #208]
+	stp	x28, x29, [sp, #224]
+
+	str	x30, [sp, #S_LR]
+
+	.if \vec >= 8
+	mrs	x1, sp_el1
+	.else
+	add	x1, sp, #S_FRAME_SIZE
+	.endif
+	str	x1, [sp, #S_SP]
+
+	mrs	x1, elr_el2
+	mrs	x2, spsr_el2
+	stp	x1, x2, [sp, #S_PC]
+
+	mov	x0, \vec
+	mov	x1, sp
+	mrs	x2, esr_el2
+	bl	do_handle_exception
+
+	ldp	x1, x2, [sp, #S_PC]
+	msr	spsr_el2, x2
+	msr	elr_el2, x1
+
+	.if \vec >= 8
+	ldr	x1, [sp, #S_SP]
+	msr	sp_el1, x1
+	.endif
+
+	ldr	x30, [sp, #S_LR]
+
+	ldp	x28, x29, [sp, #224]
+	ldp	x26, x27, [sp, #208]
+	ldp	x24, x25, [sp, #192]
+	ldp	x22, x23, [sp, #176]
+	ldp	x20, x21, [sp, #160]
+	ldp	x18, x19, [sp, #144]
+	ldp	x16, x17, [sp, #128]
+	ldp	x14, x15, [sp, #112]
+	ldp	x12, x13, [sp,  #96]
+	ldp	x10, x11, [sp,  #80]
+	ldp	 x8,  x9, [sp,  #64]
+	ldp	 x6,  x7, [sp,  #48]
+	ldp	 x4,  x5, [sp,  #32]
+	ldp	 x2,  x3, [sp,  #16]
+	ldp	 x0,  x1, [sp], #S_FRAME_SIZE
+
+	eret
+.endm
+
+vector_stub_nvhe	el2t_sync,     0
+vector_stub_nvhe	el2t_irq,      1
+vector_stub_nvhe	el2t_fiq,      2
+vector_stub_nvhe	el2t_error,    3
+
+vector_stub_nvhe	el2h_sync,     4
+vector_stub_nvhe	el2h_irq,      5
+vector_stub_nvhe	el2h_fiq,      6
+vector_stub_nvhe	el2h_error,    7
+
+vector_stub_nvhe	el1_sync_64,   8
+vector_stub_nvhe	el1_irq_64,    9
+vector_stub_nvhe	el1_fiq_64,   10
+vector_stub_nvhe	el1_error_64, 11
+
+vector_stub_nvhe	el1_sync_32,  12
+vector_stub_nvhe	el1_irq_32,   13
+vector_stub_nvhe	el1_fiq_32,   14
+vector_stub_nvhe	el1_error_32, 15
+
 .section .text.ex
 
 .macro ventry, label
@@ -355,3 +517,25 @@ vector_table:
 	ventry	el0_irq_32			// IRQ 32-bit EL0
 	ventry	el0_fiq_32			// FIQ 32-bit EL0
 	ventry	el0_error_32			// Error 32-bit EL0
+
+.align 11
+vector_table_nvhe:
+	ventry	el2t_sync			// Synchronous EL2t
+	ventry	el2t_irq			// IRQ EL2t
+	ventry	el2t_fiq			// FIQ EL2t
+	ventry	el2t_error			// Error EL2t
+
+	ventry	el2h_sync			// Synchronous EL2h
+	ventry	el2h_irq			// IRQ EL2h
+	ventry	el2h_fiq			// FIQ EL2h
+	ventry	el2h_error			// Error EL2h
+
+	ventry	el1_sync_64			// Synchronous 64-bit EL1
+	ventry	el1_irq_64			// IRQ 64-bit EL1
+	ventry	el1_fiq_64			// FIQ 64-bit EL1
+	ventry	el1_error_64			// Error 64-bit EL1
+
+	ventry	el1_sync_32			// Synchronous 32-bit EL1
+	ventry	el1_irq_32			// IRQ 32-bit EL1
+	ventry	el1_fiq_32			// FIQ 32-bit EL1
+	ventry	el1_error_32			// Error 32-bit EL1
-- 
2.7.4

