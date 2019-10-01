Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA58AC3144
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 12:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbfJAKYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 06:24:04 -0400
Received: from foss.arm.com ([217.140.110.172]:46050 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730583AbfJAKYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 06:24:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25CC915A2;
        Tue,  1 Oct 2019 03:24:03 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DD3BD3F739;
        Tue,  1 Oct 2019 03:24:01 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests RFC PATCH v2 17/19] lib: arm64: Add support for disabling and re-enabling VHE
Date:   Tue,  1 Oct 2019 11:23:21 +0100
Message-Id: <20191001102323.27628-18-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Changes:
* Removed the stack pointer swapping before disabling/re-enabling VHE.

 lib/arm64/asm/mmu.h           |  11 +-
 lib/arm64/asm/pgtable-hwdef.h |  53 +++++++---
 lib/arm64/asm/processor.h     |  19 +++-
 lib/arm/setup.c               |   1 +
 lib/arm64/processor.c         |  41 +++++++-
 arm/cstart64.S                | 193 ++++++++++++++++++++++++++++++++--
 6 files changed, 294 insertions(+), 24 deletions(-)

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
index f183b48dec5d..019e84216983 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -93,18 +93,42 @@
 /*
  * TCR flags.
  */
-#define TCR_TxSZ(x)		(((_UL(64) - (x)) << 16) | ((_UL(64) - (x)) << 0))
-#define TCR_IRGN_NC		((_UL(0) << 8) | (_UL(0) << 24))
-#define TCR_IRGN_WBWA		((_UL(1) << 8) | (_UL(1) << 24))
-#define TCR_IRGN_WT		((_UL(2) << 8) | (_UL(2) << 24))
-#define TCR_IRGN_WBnWA		((_UL(3) << 8) | (_UL(3) << 24))
-#define TCR_IRGN_MASK		((_UL(3) << 8) | (_UL(3) << 24))
-#define TCR_ORGN_NC		((_UL(0) << 10) | (_UL(0) << 26))
-#define TCR_ORGN_WBWA		((_UL(1) << 10) | (_UL(1) << 26))
-#define TCR_ORGN_WT		((_UL(2) << 10) | (_UL(2) << 26))
-#define TCR_ORGN_WBnWA		((_UL(3) << 10) | (_UL(3) << 26))
-#define TCR_ORGN_MASK		((_UL(3) << 10) | (_UL(3) << 26))
-#define TCR_SHARED		((_UL(3) << 12) | (_UL(3) << 28))
+#define TCR_T0SZ(x)		((_UL(64) - (x)) << 0)
+#define TCR_T1SZ(x)		((_UL(64) - (x)) << 16)
+#define TCR_TxSZ(x)		(TCR_T0SZ(x) | TCR_T1SZ(x))
+#define TCR_IRGN0_NC		(_UL(0) << 8)
+#define TCR_IRGN1_NC		(_UL(0) << 24)
+#define TCR_IRGN_NC		(TCR_IRGN0_NC | TCR_IRGN1_NC)
+#define TCR_IRGN0_WBWA		(_UL(1) << 8)
+#define TCR_IRGN1_WBWA		(_UL(1) << 24)
+#define TCR_IRGN_WBWA		(TCR_IRGN0_WBWA | TCR_IRGN1_WBWA)
+#define TCR_IRGN0_WT		(_UL(2) << 8)
+#define TCR_IRGN1_WT		(_UL(2) << 24)
+#define TCR_IRGN_WT		(TCR_IRGN0_WT | TCR_IRGN1_WT)
+#define TCR_IRGN0_WBnWA		(_UL(3) << 8)
+#define TCR_IRGN1_WBnWA		(_UL(3) << 24)
+#define TCR_IRGN_WBnWA		(TCR_IRGN0_WBnWA | TCR_IRGN1_WBnWA)
+#define TCR_IRGN0_MASK		(_UL(3) << 8)
+#define TCR_IRGN1_MASK		(_UL(3) << 24)
+#define TCR_IRGN_MASK		(TCR_IRGN0_MASK | TCR_IRGN1_MASK)
+#define TCR_ORGN0_NC		(_UL(0) << 10)
+#define TCR_ORGN1_NC		(_UL(0) << 26)
+#define TCR_ORGN_NC		(TCR_ORGN0_NC | TCR_ORGN1_NC)
+#define TCR_ORGN0_WBWA		(_UL(1) << 10)
+#define TCR_ORGN1_WBWA		(_UL(1) << 26)
+#define TCR_ORGN_WBWA		(TCR_ORGN0_WBWA | TCR_ORGN1_WBWA)
+#define TCR_ORGN0_WT		(_UL(2) << 10)
+#define TCR_ORGN1_WT		(_UL(2) << 26)
+#define TCR_ORGN_WT		(TCR_ORGN0_WT | TCR_ORGN1_WT)
+#define TCR_ORGN0_WBnWA		(_UL(3) << 8)
+#define TCR_ORGN1_WBnWA		(_UL(3) << 24)
+#define TCR_ORGN_WBnWA		(TCR_ORGN0_WBnWA | TCR_ORGN1_WBnWA)
+#define TCR_ORGN0_MASK		(_UL(3) << 10)
+#define TCR_ORGN1_MASK		(_UL(3) << 26)
+#define TCR_ORGN_MASK		(TCR_ORGN0_MASK | TCR_ORGN1_MASK)
+#define TCR_SH0_IS		(_UL(3) << 12)
+#define TCR_SH1_IS		(_UL(3) << 28)
+#define TCR_SHARED		(TCR_SH0_IS | TCR_SH1_IS)
 #define TCR_TG0_4K		(_UL(0) << 14)
 #define TCR_TG0_64K		(_UL(1) << 14)
 #define TCR_TG0_16K		(_UL(2) << 14)
@@ -114,6 +138,11 @@
 #define TCR_ASID16		(_UL(1) << 36)
 #define TCR_TBI0		(_UL(1) << 37)
 
+#define TCR_EL1_IPS_SHIFT	32
+
+#define TCR_EL2_RES1		((_UL(1) << 31) | (_UL(1) << 23))
+#define TCR_EL2_PS_SHIFT	16
+
 /*
  * Memory types available.
  */
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 4bbd82d9bfde..70a5261dfe97 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -18,8 +18,15 @@
 #define SCTLR_EL1_A	(1 << 1)
 #define SCTLR_EL1_M	(1 << 0)
 
-#define HCR_EL2_TGE	(1 << 27)
-#define HCR_EL2_E2H	(_UL(1) << 34)
+#define HCR_EL2_TGE		(1 << 27)
+#define HCR_EL2_E2H_SHIFT	34
+#define HCR_EL2_E2H		(_UL(1) << 34)
+
+#define SCTLR_EL2_RES1		(3 << 28 | 3 << 22 | 1 << 18 |	\
+				 1 << 16 | 1 << 11 | 3 << 4)
+#define SCTLR_EL2_I		SCTLR_EL1_I
+#define SCTLR_EL2_C		SCTLR_EL1_C
+#define SCTLR_EL2_M		SCTLR_EL1_M
 
 #define CTR_EL0_DMINLINE_SHIFT	16
 #define CTR_EL0_DMINLINE_MASK	(0xf << 16)
@@ -72,6 +79,9 @@ extern void show_regs(struct pt_regs *regs);
 extern bool get_far(unsigned int esr, unsigned long *far);
 extern void init_dcache_line_size(void);
 
+extern void disable_vhe(void);
+extern void enable_vhe(void);
+
 static inline unsigned long current_level(void)
 {
 	unsigned long el;
@@ -122,5 +132,10 @@ static inline bool vhe_enabled(void)
 	return (hcr & HCR_EL2_E2H) && (hcr & HCR_EL2_TGE);
 }
 
+static inline bool cpu_el2_e2h_is_set(void)
+{
+	return read_sysreg(hcr_el2) & HCR_EL2_E2H;
+}
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 2f23cb07f4fc..4544bf863d9a 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -23,6 +23,7 @@
 #include <asm/processor.h>
 #include <asm/psci.h>
 #include <asm/smp.h>
+#include <asm/processor.h>
 
 #include "io.h"
 
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 2030a7a09107..ba55a0d57603 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -86,7 +86,10 @@ bool get_far(unsigned int esr, unsigned long *far)
 {
 	unsigned int ec = esr >> ESR_EL1_EC_SHIFT;
 
-	asm volatile("mrs %0, far_el1": "=r" (*far));
+	if (current_level() == CurrentEL_EL2 && !cpu_el2_e2h_is_set())
+		asm volatile("mrs %0, far_el2": "=r" (*far));
+	else
+		asm volatile("mrs %0, far_el1": "=r" (*far));
 
 	switch (ec) {
 	case ESR_EL1_EC_IABT_EL0:
@@ -270,3 +273,39 @@ void init_dcache_line_size(void)
 	/* DminLine is log2 of the number of words in the smallest cache line */
 	dcache_line_size = 1 << (CTR_EL0_DMINLINE(ctr) + 2);
 }
+
+extern void asm_disable_vhe(void);
+void disable_vhe(void)
+{
+	u64 daif;
+
+	assert(current_level() == CurrentEL_EL2 && vhe_enabled());
+
+	/*
+	 * Make sure we don't take any exceptions while we run with the MMU off.
+	 * On secondaries the stack is allocated from the vmalloc area, which
+	 * means it isn't identity mapped, and the exception handling code uses
+	 * it.
+	 */
+	asm volatile("mrs %0, daif" : "=r" (daif));
+	local_irq_disable();
+	isb();
+	asm_disable_vhe();
+	asm volatile("msr daif, %0" :: "r" (daif));
+	isb();
+}
+
+extern void asm_enable_vhe(void);
+void enable_vhe(void)
+{
+	u64 daif;
+
+	assert(current_level() == CurrentEL_EL2 && !vhe_enabled());
+
+	asm volatile("mrs %0, daif" : "=r" (daif));
+	local_irq_disable();
+	isb();
+	asm_enable_vhe();
+	asm volatile("msr daif, %0" :: "r" (daif));
+	isb();
+}
diff --git a/arm/cstart64.S b/arm/cstart64.S
index acf86eb6089e..cf5374a7bab3 100644
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
+	tlbi    alle2
+	dsb     nsh
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
 /* Taken with small changes from arch/arm64/incluse/asm/assembler.h */
 .macro dcache_by_line_op op, domain, start, end, tmp1, tmp2
 	adrp	\tmp1, dcache_line_size
@@ -243,21 +277,58 @@ asm_mmu_enable:
 	dsb	\domain
 .endm
 
+clean_inval_memory:
+	adrp	x0, __phys_offset
+	ldr	x0, [x0, :lo12:__phys_offset]
+	adrp	x1, __phys_end
+	ldr	x1, [x1, :lo12:__phys_end]
+	dcache_by_line_op civac, sy, x0, x1, x2, x3
+	isb
+	ret
+
 .globl asm_mmu_disable
 asm_mmu_disable:
 	mrs	x0, sctlr_el1
 	bic	x0, x0, SCTLR_EL1_M
 	msr	sctlr_el1, x0
 	isb
+	b	clean_inval_memory
 
-	/* Clean + invalidate the entire memory */
-	adrp	x0, __phys_offset
-	ldr	x0, [x0, :lo12:__phys_offset]
-	adrp	x1, __phys_end
-	ldr	x1, [x1, :lo12:__phys_end]
-	dcache_by_line_op civac, sy, x0, x1, x2, x3
+asm_mmu_disable_nvhe:
+	mrs	x0, sctlr_el2
+	bic	x0, x0, SCTLR_EL2_M
+	msr	sctlr_el2, x0
+	isb
+	b	clean_inval_memory
+
+.globl asm_disable_vhe
+asm_disable_vhe:
+	str	x30, [sp, #-16]!
+
+	bl	asm_mmu_disable
+	msr	hcr_el2, xzr
 	isb
+	bl	exceptions_init_nvhe
+	bl	asm_mmu_enable_nvhe
 
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
+	bl	exceptions_init
+	/* Make asm_mmu_enable happy by having TTBR0 value in x0 */
+	mrs	x0, ttbr0_el1
+	isb
+	bl	asm_mmu_enable
+
+	ldr	x30, [sp], #16
 	ret
 
 /*
@@ -350,6 +421,92 @@ vector_stub	el0_irq_32,   13
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
@@ -378,3 +535,25 @@ vector_table:
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
2.20.1

