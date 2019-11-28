Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF3410CE3E
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 19:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfK1SEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 13:04:37 -0500
Received: from foss.arm.com ([217.140.110.172]:39332 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbfK1SEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 13:04:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3887D1FB;
        Thu, 28 Nov 2019 10:04:36 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1ECA33F6C4;
        Thu, 28 Nov 2019 10:04:35 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v2 04/18] lib: arm/arm64: Use WRITE_ONCE to update the translation tables
Date:   Thu, 28 Nov 2019 18:04:04 +0000
Message-Id: <20191128180418.6938-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191128180418.6938-1-alexandru.elisei@arm.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use WRITE_ONCE to prevent store tearing when updating an entry in the
translation tables. Without WRITE_ONCE, the compiler, even though it is
unlikely, can emit several stores when changing the table, and we might
end up with bogus TLB entries.

It's worth noting that the existing code is mostly fine without any
changes because the translation tables are updated in one of the
following situations:

- When the tables are being created with the MMU off, which means no TLB
  caching is being performed.

- When new page table entries are added as a result of vmalloc'ing a
  stack for a secondary CPU, which doesn't happen very often.

- When clearing the PTE_USER bit for the cache test, and store tearing
  has no effect on the table walker because there are no intermediate
  values between bit values 0 and 1. We still use WRITE_ONCE in this case
  for consistency.

However, the functions are global and there is nothing preventing someone
from writing a test that uses them in a different scenario. Let's make
sure that when that happens, there will be no breakage once in a blue
moon.

Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/pgtable.h   | 12 ++++++++----
 lib/arm64/asm/pgtable.h |  7 +++++--
 lib/arm/mmu.c           | 19 +++++++++++++------
 3 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index 241dff69b38a..794514b8c927 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -19,6 +19,8 @@
  * because we always allocate their pages with alloc_page(), and
  * alloc_page() always returns identity mapped pages.
  */
+#include <linux/compiler.h>
+
 #define pgtable_va(x)		((void *)(unsigned long)(x))
 #define pgtable_pa(x)		((unsigned long)(x))
 
@@ -58,8 +60,9 @@ static inline pmd_t *pmd_alloc_one(void)
 static inline pmd_t *pmd_alloc(pgd_t *pgd, unsigned long addr)
 {
 	if (pgd_none(*pgd)) {
-		pmd_t *pmd = pmd_alloc_one();
-		pgd_val(*pgd) = pgtable_pa(pmd) | PMD_TYPE_TABLE;
+		pgd_t entry;
+		pgd_val(entry) = pgtable_pa(pmd_alloc_one()) | PMD_TYPE_TABLE;
+		WRITE_ONCE(*pgd, entry);
 	}
 	return pmd_offset(pgd, addr);
 }
@@ -84,8 +87,9 @@ static inline pte_t *pte_alloc_one(void)
 static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
 {
 	if (pmd_none(*pmd)) {
-		pte_t *pte = pte_alloc_one();
-		pmd_val(*pmd) = pgtable_pa(pte) | PMD_TYPE_TABLE;
+		pmd_t entry;
+		pmd_val(entry) = pgtable_pa(pte_alloc_one()) | PMD_TYPE_TABLE;
+		WRITE_ONCE(*pmd, entry);
 	}
 	return pte_offset(pmd, addr);
 }
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index ee0a2c88cc18..dbf9e7253b71 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -18,6 +18,8 @@
 #include <asm/page.h>
 #include <asm/pgtable-hwdef.h>
 
+#include <linux/compiler.h>
+
 /*
  * We can convert va <=> pa page table addresses with simple casts
  * because we always allocate their pages with alloc_page(), and
@@ -66,8 +68,9 @@ static inline pte_t *pte_alloc_one(void)
 static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
 {
 	if (pmd_none(*pmd)) {
-		pte_t *pte = pte_alloc_one();
-		pmd_val(*pmd) = pgtable_pa(pte) | PMD_TYPE_TABLE;
+		pmd_t entry;
+		pmd_val(entry) = pgtable_pa(pte_alloc_one()) | PMD_TYPE_TABLE;
+		WRITE_ONCE(*pmd, entry);
 	}
 	return pte_offset(pmd, addr);
 }
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 72043c333b55..cc03b25aa77e 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -17,6 +17,8 @@
 #include <asm/pgtable-hwdef.h>
 #include <asm/pgtable.h>
 
+#include <linux/compiler.h>
+
 extern unsigned long etext;
 
 pgd_t *mmu_idmap;
@@ -86,7 +88,7 @@ static pteval_t *install_pte(pgd_t *pgtable, uintptr_t vaddr, pteval_t pte)
 {
 	pteval_t *p_pte = get_pte(pgtable, vaddr);
 
-	*p_pte = pte;
+	WRITE_ONCE(*p_pte, pte);
 	dsb(ishst);
 	flush_tlb_page(vaddr);
 
@@ -133,12 +135,15 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 	phys_addr_t paddr = phys_start & PGDIR_MASK;
 	uintptr_t vaddr = virt_offset & PGDIR_MASK;
 	uintptr_t virt_end = phys_end - paddr + vaddr;
+	pgd_t *pgd;
+	pgd_t entry;
 
 	for (; vaddr < virt_end; vaddr += PGDIR_SIZE, paddr += PGDIR_SIZE) {
-		pgd_t *pgd = pgd_offset(pgtable, vaddr);
-		pgd_val(*pgd) = paddr;
-		pgd_val(*pgd) |= PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S;
-		pgd_val(*pgd) |= pgprot_val(prot);
+		pgd_val(entry) = paddr;
+		pgd_val(entry) |= PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S;
+		pgd_val(entry) |= pgprot_val(prot);
+		pgd = pgd_offset(pgtable, vaddr);
+		WRITE_ONCE(*pgd, entry);
 		dsb(ishst);
 		flush_tlb_page(vaddr);
 	}
@@ -213,6 +218,7 @@ void mmu_clear_user(unsigned long vaddr)
 {
 	pgd_t *pgtable;
 	pteval_t *pte;
+	pteval_t entry;
 
 	if (!mmu_enabled())
 		return;
@@ -220,7 +226,8 @@ void mmu_clear_user(unsigned long vaddr)
 	pgtable = current_thread_info()->pgtable;
 	pte = get_pte(pgtable, vaddr);
 
-	*pte &= ~PTE_USER;
+	entry = *pte & ~PTE_USER;
+	WRITE_ONCE(*pte, entry);
 	dsb(ishst);
 	flush_tlb_page(vaddr);
 }
-- 
2.20.1

