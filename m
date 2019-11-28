Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23A2610CE43
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 19:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfK1SEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 13:04:44 -0500
Received: from foss.arm.com ([217.140.110.172]:39378 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfK1SEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 13:04:43 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED72F31B;
        Thu, 28 Nov 2019 10:04:42 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D1AF63F6C4;
        Thu, 28 Nov 2019 10:04:41 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v2 09/18] lib: arm/arm64: Teach mmu_clear_user about block mappings
Date:   Thu, 28 Nov 2019 18:04:09 +0000
Message-Id: <20191128180418.6938-10-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191128180418.6938-1-alexandru.elisei@arm.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm-unit-tests uses block mappings, so let's expand the mmu_clear_user
function to handle those as well.

Now that the function knows about block mappings, we cannot simply
assume that if an address isn't mapped we can map it as a regular page.
Change the semantics of the function to fail quite loudly if the address
isn't mapped, and shift the burden on the caller to map the address as a
page or block mapping before calling mmu_clear_user.

Also make mmu_clear_user more flexible by adding a pgtable parameter,
instead of assuming that the change always applies to the current
translation tables.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/mmu-api.h         |  2 +-
 lib/arm/asm/pgtable-hwdef.h   |  3 +++
 lib/arm/asm/pgtable.h         |  7 +++++++
 lib/arm64/asm/pgtable-hwdef.h |  3 +++
 lib/arm64/asm/pgtable.h       |  7 +++++++
 lib/arm/mmu.c                 | 26 +++++++++++++++++++-------
 arm/cache.c                   |  3 ++-
 7 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index 8fe85ba31ec9..2bbe1faea900 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -22,5 +22,5 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 			       phys_addr_t phys_start, phys_addr_t phys_end,
 			       pgprot_t prot);
-extern void mmu_clear_user(unsigned long vaddr);
+extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
 #endif
diff --git a/lib/arm/asm/pgtable-hwdef.h b/lib/arm/asm/pgtable-hwdef.h
index 4f24c78ee011..4107e188014a 100644
--- a/lib/arm/asm/pgtable-hwdef.h
+++ b/lib/arm/asm/pgtable-hwdef.h
@@ -14,6 +14,8 @@
 #define PGDIR_SIZE		(_AC(1,UL) << PGDIR_SHIFT)
 #define PGDIR_MASK		(~((1 << PGDIR_SHIFT) - 1))
 
+#define PGD_VALID		(_AT(pgdval_t, 1) << 0)
+
 #define PTRS_PER_PTE		512
 #define PTRS_PER_PMD		512
 
@@ -54,6 +56,7 @@
 #define PMD_TYPE_FAULT		(_AT(pmdval_t, 0) << 0)
 #define PMD_TYPE_TABLE		(_AT(pmdval_t, 3) << 0)
 #define PMD_TYPE_SECT		(_AT(pmdval_t, 1) << 0)
+#define PMD_SECT_VALID		(_AT(pmdval_t, 1) << 0)
 #define PMD_TABLE_BIT		(_AT(pmdval_t, 1) << 1)
 #define PMD_BIT4		(_AT(pmdval_t, 0))
 #define PMD_DOMAIN(x)		(_AT(pmdval_t, 0))
diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index e7f967071980..078dd16fa799 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -29,6 +29,13 @@
 #define pmd_none(pmd)		(!pmd_val(pmd))
 #define pte_none(pte)		(!pte_val(pte))
 
+#define pgd_valid(pgd)		(pgd_val(pgd) & PGD_VALID)
+#define pmd_valid(pmd)		(pmd_val(pmd) & PMD_SECT_VALID)
+#define pte_valid(pte)		(pte_val(pte) & L_PTE_VALID)
+
+#define pmd_huge(pmd)	\
+	((pmd_val(pmd) & PMD_TYPE_MASK) == PMD_TYPE_SECT)
+
 #define pgd_index(addr) \
 	(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
 #define pgd_offset(pgtable, addr) ((pgtable) + pgd_index(addr))
diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
index 045a3ce12645..33524899e5fa 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -22,6 +22,8 @@
 #define PGDIR_MASK		(~(PGDIR_SIZE-1))
 #define PTRS_PER_PGD		(1 << (VA_BITS - PGDIR_SHIFT))
 
+#define PGD_VALID		(_AT(pgdval_t, 1) << 0)
+
 /* From include/asm-generic/pgtable-nopmd.h */
 #define PMD_SHIFT		PGDIR_SHIFT
 #define PTRS_PER_PMD		1
@@ -71,6 +73,7 @@
 #define PTE_TYPE_MASK		(_AT(pteval_t, 3) << 0)
 #define PTE_TYPE_FAULT		(_AT(pteval_t, 0) << 0)
 #define PTE_TYPE_PAGE		(_AT(pteval_t, 3) << 0)
+#define PTE_VALID		(_AT(pteval_t, 1) << 0)
 #define PTE_TABLE_BIT		(_AT(pteval_t, 1) << 1)
 #define PTE_USER		(_AT(pteval_t, 1) << 6)		/* AP[1] */
 #define PTE_RDONLY		(_AT(pteval_t, 1) << 7)		/* AP[2] */
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index 6412d67759e4..e577d9cf304e 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -33,6 +33,13 @@
 #define pmd_none(pmd)		(!pmd_val(pmd))
 #define pte_none(pte)		(!pte_val(pte))
 
+#define pgd_valid(pgd)		(pgd_val(pgd) & PGD_VALID)
+#define pmd_valid(pmd)		(pmd_val(pmd) & PMD_SECT_VALID)
+#define pte_valid(pte)		(pte_val(pte) & PTE_VALID)
+
+#define pmd_huge(pmd)	\
+	((pmd_val(pmd) & PMD_TYPE_MASK) == PMD_TYPE_SECT)
+
 #define pgd_index(addr) \
 	(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
 #define pgd_offset(pgtable, addr) ((pgtable) + pgd_index(addr))
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index cc03b25aa77e..ed5411c157bb 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -214,20 +214,32 @@ unsigned long __phys_to_virt(phys_addr_t addr)
 	return addr;
 }
 
-void mmu_clear_user(unsigned long vaddr)
+void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 {
-	pgd_t *pgtable;
-	pteval_t *pte;
-	pteval_t entry;
+	pgd_t *pgd;
+	pmd_t *pmd;
+	pte_t *pte;
 
 	if (!mmu_enabled())
 		return;
 
-	pgtable = current_thread_info()->pgtable;
-	pte = get_pte(pgtable, vaddr);
+	pgd = pgd_offset(pgtable, vaddr);
+	assert(pgd_valid(*pgd));
+	pmd = pmd_offset(pgd, vaddr);
+	assert(pmd_valid(*pmd));
+
+	if (pmd_huge(*pmd)) {
+		pmd_t entry = __pmd(pmd_val(*pmd) & ~PMD_SECT_USER);
+		WRITE_ONCE(*pmd, entry);
+		goto out_flush_tlb;
+	}
 
-	entry = *pte & ~PTE_USER;
+	pte = pte_offset(pmd, vaddr);
+	assert(pte_valid(*pte));
+	pte_t entry = __pte(pte_val(*pte) & ~PTE_USER);
 	WRITE_ONCE(*pte, entry);
+
+out_flush_tlb:
 	dsb(ishst);
 	flush_tlb_page(vaddr);
 }
diff --git a/arm/cache.c b/arm/cache.c
index 2939b85a8c9a..5db558325316 100644
--- a/arm/cache.c
+++ b/arm/cache.c
@@ -2,6 +2,7 @@
 #include <alloc_page.h>
 #include <asm/mmu.h>
 #include <asm/processor.h>
+#include <asm/thread_info.h>
 
 #define NTIMES			(1 << 16)
 
@@ -47,7 +48,7 @@ static void check_code_generation(bool dcache_clean, bool icache_inval)
 	bool success;
 
 	/* Make sure we can execute from a writable page */
-	mmu_clear_user((unsigned long)code);
+	mmu_clear_user(current_thread_info()->pgtable, (unsigned long)code);
 
 	sctlr = read_sysreg(sctlr_el1);
 	if (sctlr & SCTLR_EL1_WXN) {
-- 
2.20.1

