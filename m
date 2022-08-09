Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1CE58D62F
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbiHIJQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237910AbiHIJPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:47 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A97F822B3E
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:15:41 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15353143D;
        Tue,  9 Aug 2022 02:15:42 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 12E4B3F67D;
        Tue,  9 Aug 2022 02:15:39 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 10/19] arm/arm64: Enable the MMU early
Date:   Tue,  9 Aug 2022 10:15:49 +0100
Message-Id: <20220809091558.14379-11-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable the MMU immediately after the physical allocator is initialized,
to make reasoning about what cache maintenance operations are needed a
lot easier.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/mmu-api.h   |  1 +
 lib/arm/asm/pgtable.h   | 42 ++++++++++++++++++++++++++++---
 lib/arm/mmu.c           | 46 +++++++++++++++++++---------------
 lib/arm/processor.c     |  5 ++++
 lib/arm/setup.c         |  4 +++
 lib/arm/smp.c           |  4 +--
 lib/arm64/asm/pgtable.h | 55 ++++++++++++++++++++++++++++++++++++++---
 lib/arm64/processor.c   |  4 +++
 8 files changed, 131 insertions(+), 30 deletions(-)

diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index 3d77cbfd8b24..456c8bc626d7 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -10,6 +10,7 @@ extern void mmu_mark_enabled(int cpu);
 extern void mmu_mark_disabled(int cpu);
 extern void mmu_enable(pgd_t *pgtable);
 extern void mmu_disable(void);
+extern void mmu_setup_early(phys_addr_t unused0, void *unused1);
 
 extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 			       phys_addr_t phys_start, phys_addr_t phys_end,
diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index a35f42965df9..1911e35bb091 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -41,10 +41,21 @@
 #define pgd_offset(pgtable, addr) ((pgtable) + pgd_index(addr))
 
 #define pgd_free(pgd) free(pgd)
+static inline pgd_t *pgd_alloc_early(void)
+{
+	pgd_t *pgd = memalign(PAGE_SIZE, PAGE_SIZE);
+	memset(pgd, 0, PAGE_SIZE);
+	return pgd;
+}
 static inline pgd_t *pgd_alloc(void)
 {
+	pgd_t *pgd;
+
 	assert(PTRS_PER_PGD * sizeof(pgd_t) <= PAGE_SIZE);
-	pgd_t *pgd = alloc_page();
+	if (page_alloc_initialized())
+		pgd = alloc_page();
+	else
+		pgd = pgd_alloc_early();
 	return pgd;
 }
 
@@ -71,11 +82,23 @@ static inline pmd_t *pmd_alloc_one(void)
 	pmd_t *pmd = alloc_page();
 	return pmd;
 }
+static inline pmd_t *pmd_alloc_one_early(void)
+{
+	assert(PTRS_PER_PMD * sizeof(pmd_t) == PAGE_SIZE);
+	pmd_t *pmd = memalign(PAGE_SIZE, PAGE_SIZE);
+	memset(pmd, 0, PAGE_SIZE);
+	return pmd;
+}
 static inline pmd_t *pmd_alloc(pgd_t *pgd, unsigned long addr)
 {
 	if (pgd_none(*pgd)) {
 		pgd_t entry;
-		pgd_val(entry) = pgtable_pa(pmd_alloc_one()) | PMD_TYPE_TABLE;
+		pmd_t *pmd;
+		if (page_alloc_initialized())
+			pmd = pmd_alloc_one();
+		else
+			pmd = pmd_alloc_one_early();
+		pgd_val(entry) = pgtable_pa(pmd) | PMD_TYPE_TABLE;
 		WRITE_ONCE(*pgd, entry);
 	}
 	return pmd_offset(pgd, addr);
@@ -98,12 +121,25 @@ static inline pte_t *pte_alloc_one(void)
 	pte_t *pte = alloc_page();
 	return pte;
 }
+static inline pte_t *pte_alloc_one_early(void)
+{
+	assert(PTRS_PER_PTE * sizeof(pte_t) == PAGE_SIZE);
+	pte_t *pte = memalign(PAGE_SIZE, PAGE_SIZE);
+	memset(pte, 0, PAGE_SIZE);
+	return pte;
+}
 static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
 {
 	if (pmd_none(*pmd)) {
 		pmd_t entry;
-		pmd_val(entry) = pgtable_pa(pte_alloc_one()) | PMD_TYPE_TABLE;
+		pte_t *pte;
+		if (page_alloc_initialized())
+			pte = pte_alloc_one();
+		else
+			pte = pte_alloc_one_early();
+		pmd_val(entry) = pgtable_pa(pte) | PMD_TYPE_TABLE;
 		WRITE_ONCE(*pmd, entry);
+
 	}
 	return pte_offset(pmd, addr);
 }
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 2b7405d0274f..7765d47dc27a 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -12,11 +12,10 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/io.h>
+#include <asm/pgtable.h>
+#include <asm/pgtable-hwdef.h>
 
-#include "alloc_page.h"
 #include "vmalloc.h"
-#include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
 
 #include <linux/compiler.h>
 
@@ -153,19 +152,18 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 	}
 }
 
-void *setup_mmu(phys_addr_t unused0, void *unused1)
+void mmu_setup_early(phys_addr_t unused0, void *unused1)
 {
 	struct mem_region *r;
 
-#ifdef __aarch64__
-	init_alloc_vpage((void*)(4ul << 30));
+	assert(!mmu_enabled() && !page_alloc_initialized());
 
+#ifdef __aarch64__
 	assert_msg(system_supports_granule(PAGE_SIZE),
 			"Unsupported translation granule %ld\n", PAGE_SIZE);
 #endif
 
-	if (!mmu_idmap)
-		mmu_idmap = pgd_alloc();
+	mmu_idmap = pgd_alloc();
 
 	for (r = mem_regions; r->end; ++r) {
 		if (r->flags & MR_F_IO) {
@@ -180,7 +178,21 @@ void *setup_mmu(phys_addr_t unused0, void *unused1)
 		}
 	}
 
-	mmu_enable(mmu_idmap);
+	asm_mmu_enable((phys_addr_t)(unsigned long)mmu_idmap);
+}
+
+void *setup_mmu(phys_addr_t unused0, void *unused1)
+{
+	struct thread_info *info = current_thread_info();
+
+	assert(mmu_idmap);
+
+#ifdef __aarch64__
+	init_alloc_vpage((void*)(4ul << 30));
+#endif
+
+	mmu_mark_enabled(info->cpu);
+
 	return mmu_idmap;
 }
 
@@ -189,17 +201,10 @@ void __iomem *__ioremap(phys_addr_t phys_addr, size_t size)
 	phys_addr_t paddr_aligned = phys_addr & PAGE_MASK;
 	phys_addr_t paddr_end = PAGE_ALIGN(phys_addr + size);
 	pgprot_t prot = __pgprot(PTE_UNCACHED | PTE_USER | PTE_UXN | PTE_PXN);
-	pgd_t *pgtable;
+	pgd_t *pgtable = current_thread_info()->pgtable;
 
 	assert(sizeof(long) == 8 || !(phys_addr >> 32));
-
-	if (mmu_enabled()) {
-		pgtable = current_thread_info()->pgtable;
-	} else {
-		if (!mmu_idmap)
-			mmu_idmap = pgd_alloc();
-		pgtable = mmu_idmap;
-	}
+	assert(pgtable);
 
 	mmu_set_range_ptes(pgtable, paddr_aligned, paddr_aligned,
 			   paddr_end, prot);
@@ -209,8 +214,9 @@ void __iomem *__ioremap(phys_addr_t phys_addr, size_t size)
 
 phys_addr_t __virt_to_phys(unsigned long addr)
 {
-	if (mmu_enabled()) {
-		pgd_t *pgtable = current_thread_info()->pgtable;
+	pgd_t *pgtable = current_thread_info()->pgtable;
+
+	if (mmu_enabled() && pgtable) {
 		return virt_to_pte_phys(pgtable, (void *)addr);
 	}
 	return addr;
diff --git a/lib/arm/processor.c b/lib/arm/processor.c
index ceff1c0a1bd2..91ef2824ac6c 100644
--- a/lib/arm/processor.c
+++ b/lib/arm/processor.c
@@ -5,7 +5,10 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
+#include <auxinfo.h>
 #include <libcflat.h>
+
+#include <asm/mmu.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
@@ -119,6 +122,8 @@ void thread_info_init(struct thread_info *ti, unsigned int flags)
 {
 	ti->cpu = mpidr_to_cpu(get_mpidr());
 	ti->flags = flags;
+	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
+		ti->pgtable = mmu_idmap;
 }
 
 void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr)
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index bcdf0d78c2e2..73f7c22c6828 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -26,6 +26,7 @@
 #include <asm/smp.h>
 #include <asm/timer.h>
 #include <asm/psci.h>
+#include <asm/mmu.h>
 
 #include "io.h"
 
@@ -189,6 +190,9 @@ static void mem_init(phys_addr_t freemem_start)
 	phys_alloc_init(freemem_start, freemem->end - freemem_start);
 	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
 
+	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
+		mmu_setup_early(0, NULL);
+
 	phys_alloc_get_unused(&base, &top);
 	base = PAGE_ALIGN(base);
 	top = top & PAGE_MASK;
diff --git a/lib/arm/smp.c b/lib/arm/smp.c
index 98a5054e039b..89e44a172c15 100644
--- a/lib/arm/smp.c
+++ b/lib/arm/smp.c
@@ -38,10 +38,8 @@ secondary_entry_fn secondary_cinit(void)
 
 	thread_info_init(ti, 0);
 
-	if (!(auxinfo.flags & AUXINFO_MMU_OFF)) {
-		ti->pgtable = mmu_idmap;
+	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
 		mmu_mark_enabled(ti->cpu);
-	}
 
 	/*
 	 * Save secondary_data.entry locally to avoid opening a race
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index 06357920aa74..98d51c89b7c0 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -47,10 +47,21 @@
 #define pgd_offset(pgtable, addr) ((pgtable) + pgd_index(addr))
 
 #define pgd_free(pgd) free(pgd)
+static inline pgd_t *pgd_alloc_early(void)
+{
+	pgd_t *pgd = memalign(PAGE_SIZE, PAGE_SIZE);
+	memset(pgd, 0, PAGE_SIZE);
+	return pgd;
+}
 static inline pgd_t *pgd_alloc(void)
 {
+	pgd_t *pgd;
+
 	assert(PTRS_PER_PGD * sizeof(pgd_t) <= PAGE_SIZE);
-	pgd_t *pgd = alloc_page();
+	if (page_alloc_initialized())
+		pgd = alloc_page();
+	else
+		pgd = pgd_alloc_early();
 	return pgd;
 }
 
@@ -81,11 +92,23 @@ static inline pmd_t *pmd_alloc_one(void)
 	pmd_t *pmd = alloc_page();
 	return pmd;
 }
+static inline pmd_t *pmd_alloc_one_early(void)
+{
+	assert(PTRS_PER_PMD * sizeof(pmd_t) == PAGE_SIZE);
+	pmd_t *pmd = memalign(PAGE_SIZE, PAGE_SIZE);
+	memset(pmd, 0, PAGE_SIZE);
+	return pmd;
+}
 static inline pmd_t *pmd_alloc(pud_t *pud, unsigned long addr)
 {
 	if (pud_none(*pud)) {
 		pud_t entry;
-		pud_val(entry) = pgtable_pa(pmd_alloc_one()) | PMD_TYPE_TABLE;
+		pmd_t *pmd;
+		if (page_alloc_initialized())
+			pmd = pmd_alloc_one();
+		else
+			pmd = pmd_alloc_one_early();
+		pud_val(entry) = pgtable_pa(pmd) | PMD_TYPE_TABLE;
 		WRITE_ONCE(*pud, entry);
 	}
 	return pmd_offset(pud, addr);
@@ -108,11 +131,23 @@ static inline pud_t *pud_alloc_one(void)
 	pud_t *pud = alloc_page();
 	return pud;
 }
+static inline pud_t *pud_alloc_one_early(void)
+{
+	assert(PTRS_PER_PUD * sizeof(pud_t) == PAGE_SIZE);
+	pud_t *pud = memalign(PAGE_SIZE, PAGE_SIZE);
+	memset(pud, 0, PAGE_SIZE);
+	return pud;
+}
 static inline pud_t *pud_alloc(pgd_t *pgd, unsigned long addr)
 {
 	if (pgd_none(*pgd)) {
 		pgd_t entry;
-		pgd_val(entry) = pgtable_pa(pud_alloc_one()) | PMD_TYPE_TABLE;
+		pud_t *pud;
+		if (page_alloc_initialized())
+			pud = pud_alloc_one();
+		else
+			pud = pud_alloc_one_early();
+		pgd_val(entry) = pgtable_pa(pud) | PMD_TYPE_TABLE;
 		WRITE_ONCE(*pgd, entry);
 	}
 	return pud_offset(pgd, addr);
@@ -135,11 +170,23 @@ static inline pte_t *pte_alloc_one(void)
 	pte_t *pte = alloc_page();
 	return pte;
 }
+static inline pte_t *pte_alloc_one_early(void)
+{
+	assert(PTRS_PER_PTE * sizeof(pte_t) == PAGE_SIZE);
+	pte_t *pte = memalign(PAGE_SIZE, PAGE_SIZE);
+	memset(pte, 0, PAGE_SIZE);
+	return pte;
+}
 static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
 {
 	if (pmd_none(*pmd)) {
 		pmd_t entry;
-		pmd_val(entry) = pgtable_pa(pte_alloc_one()) | PMD_TYPE_TABLE;
+		pte_t *pte;
+		if (page_alloc_initialized())
+			pte = pte_alloc_one();
+		else
+			pte = pte_alloc_one_early();
+		pmd_val(entry) = pgtable_pa(pte) | PMD_TYPE_TABLE;
 		WRITE_ONCE(*pmd, entry);
 	}
 	return pte_offset(pmd, addr);
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 268b2858f0be..c435fb96e373 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -5,7 +5,9 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
+#include <auxinfo.h>
 #include <libcflat.h>
+#include <asm/mmu.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
@@ -234,6 +236,8 @@ static void __thread_info_init(struct thread_info *ti, unsigned int flags)
 {
 	ti->cpu = mpidr_to_cpu(get_mpidr());
 	ti->flags = flags;
+	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
+		ti->pgtable = mmu_idmap;
 }
 
 void thread_info_init(struct thread_info *ti, unsigned int flags)
-- 
2.37.1

