Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE0C12DA14
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2019 17:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfLaQKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Dec 2019 11:10:12 -0500
Received: from foss.arm.com ([217.140.110.172]:35450 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727081AbfLaQKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Dec 2019 11:10:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7067F1007;
        Tue, 31 Dec 2019 08:10:11 -0800 (PST)
Received: from e121566-lin.arm.com,emea.arm.com,asiapac.arm.com,usa.arm.com (unknown [10.37.8.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 472E13F68F;
        Tue, 31 Dec 2019 08:10:09 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v3 01/18] lib: arm/arm64: Remove unnecessary dcache maintenance operations
Date:   Tue, 31 Dec 2019 16:09:32 +0000
Message-Id: <1577808589-31892-2-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On ARMv7 with multiprocessing extensions (which are mandated by the
virtualization extensions [1]), and on ARMv8, translation table walks are
coherent [2, 3], which means that no dcache maintenance operations are
required when changing the tables. Remove the maintenance operations so
that we do only the minimum required to ensure correctness.

Translation table walks are coherent if the memory where the tables
themselves reside have the same shareability and cacheability attributes
as the translation table walks. For ARMv8, this is already the case, and
it is only a matter of removing the cache operations.

However, for ARMv7, translation table walks were being configured as
Non-shareable (TTBCR.SH0 = 0b00) and Non-cacheable
(TTBCR.{I,O}RGN0 = 0b00). Fix that by marking them as Inner Shareable,
Normal memory, Inner and Outer Write-Back Write-Allocate Cacheable.

Because translation table walks are now coherent on arm, replace the
TLBIMVAA operation with TLBIMVAAIS in flush_tlb_page, which acts on the
Inner Shareable domain instead of being private to the PE.

The functions that update the translation table are called when the MMU
is off, or to modify permissions, in the case of the cache test, so
break-before-make is not necessary.

[1] ARM DDI 0406C.d, section B1.7
[2] ARM DDI 0406C.d, section B3.3.1
[3] ARM DDI 0487E.a, section D13.2.72
[4] ARM DDI 0487E.a, section K11.5.3

Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/mmu.h           |  4 ++--
 lib/arm/asm/pgtable-hwdef.h |  8 ++++++++
 lib/arm/mmu.c               | 14 +-------------
 arm/cstart.S                |  7 +++++--
 4 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
index 915c2b07dead..361f3cdcc3d5 100644
--- a/lib/arm/asm/mmu.h
+++ b/lib/arm/asm/mmu.h
@@ -31,8 +31,8 @@ static inline void flush_tlb_all(void)
 
 static inline void flush_tlb_page(unsigned long vaddr)
 {
-	/* TLBIMVAA */
-	asm volatile("mcr p15, 0, %0, c8, c7, 3" :: "r" (vaddr));
+	/* TLBIMVAAIS */
+	asm volatile("mcr p15, 0, %0, c8, c3, 3" :: "r" (vaddr));
 	dsb();
 	isb();
 }
diff --git a/lib/arm/asm/pgtable-hwdef.h b/lib/arm/asm/pgtable-hwdef.h
index c08e6e2c01b4..4f24c78ee011 100644
--- a/lib/arm/asm/pgtable-hwdef.h
+++ b/lib/arm/asm/pgtable-hwdef.h
@@ -108,4 +108,12 @@
 #define PHYS_MASK_SHIFT		(40)
 #define PHYS_MASK		((_AC(1, ULL) << PHYS_MASK_SHIFT) - 1)
 
+#define TTBCR_IRGN0_WBWA	(_AC(1, UL) << 8)
+#define TTBCR_ORGN0_WBWA	(_AC(1, UL) << 10)
+#define TTBCR_SH0_SHARED	(_AC(3, UL) << 12)
+#define TTBCR_IRGN1_WBWA	(_AC(1, UL) << 24)
+#define TTBCR_ORGN1_WBWA	(_AC(1, UL) << 26)
+#define TTBCR_SH1_SHARED	(_AC(3, UL) << 28)
+#define TTBCR_EAE		(_AC(1, UL) << 31)
+
 #endif /* _ASMARM_PGTABLE_HWDEF_H_ */
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 78db22e6af14..5c31c00ccb31 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -73,17 +73,6 @@ void mmu_disable(void)
 	asm_mmu_disable();
 }
 
-static void flush_entry(pgd_t *pgtable, uintptr_t vaddr)
-{
-	pgd_t *pgd = pgd_offset(pgtable, vaddr);
-	pmd_t *pmd = pmd_offset(pgd, vaddr);
-
-	flush_dcache_addr((ulong)pgd);
-	flush_dcache_addr((ulong)pmd);
-	flush_dcache_addr((ulong)pte_offset(pmd, vaddr));
-	flush_tlb_page(vaddr);
-}
-
 static pteval_t *get_pte(pgd_t *pgtable, uintptr_t vaddr)
 {
 	pgd_t *pgd = pgd_offset(pgtable, vaddr);
@@ -98,7 +87,7 @@ static pteval_t *install_pte(pgd_t *pgtable, uintptr_t vaddr, pteval_t pte)
 	pteval_t *p_pte = get_pte(pgtable, vaddr);
 
 	*p_pte = pte;
-	flush_entry(pgtable, vaddr);
+	flush_tlb_page(vaddr);
 	return p_pte;
 }
 
@@ -148,7 +137,6 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 		pgd_val(*pgd) = paddr;
 		pgd_val(*pgd) |= PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S;
 		pgd_val(*pgd) |= pgprot_val(prot);
-		flush_dcache_addr((ulong)pgd);
 		flush_tlb_page(vaddr);
 	}
 }
diff --git a/arm/cstart.S b/arm/cstart.S
index 114726feab82..2c81d39a666b 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -9,6 +9,7 @@
 #include <auxinfo.h>
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
+#include <asm/pgtable-hwdef.h>
 #include <asm/ptrace.h>
 #include <asm/sysreg.h>
 
@@ -154,9 +155,11 @@ halt:
 .globl asm_mmu_enable
 asm_mmu_enable:
 	/* TTBCR */
-	mrc	p15, 0, r2, c2, c0, 2
-	orr	r2, #(1 << 31)		@ TTB_EAE
+	ldr	r2, =(TTBCR_EAE | 				\
+		      TTBCR_SH0_SHARED | 			\
+		      TTBCR_IRGN0_WBWA | TTBCR_ORGN0_WBWA)
 	mcr	p15, 0, r2, c2, c0, 2
+	isb
 
 	/* MAIR */
 	ldr	r2, =PRRR
-- 
2.7.4

