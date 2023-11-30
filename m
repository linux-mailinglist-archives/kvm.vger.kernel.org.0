Return-Path: <kvm+bounces-2878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 974807FEB80
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:09:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C4D8282362
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CFE73C697;
	Thu, 30 Nov 2023 09:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wn9OFz6r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C867910F1
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2c7018BXqcGEjZjD4X/x+XHma+yk1idz2obOd3uUdWs=;
	b=Wn9OFz6rHD+m11CYIqKlpKZSsyQpuW91N21gg5Ikl9tZoZRCd5Fs3aceNXHGMQ3r2JXSt2
	u9wW5Q4ibPltVfsU/VbMxkbjqMIMiW8oLWtILwiJd5nGdk3lRBVQ8LD58xZ1jO2bS9VfFT
	mDiUqG+ZuhoLGxoebEwMerR69C/h6nU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-yN7fN3VxPumRB8VPBn4tMw-1; Thu, 30 Nov 2023 04:07:58 -0500
X-MC-Unique: yN7fN3VxPumRB8VPBn4tMw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10C37811E91;
	Thu, 30 Nov 2023 09:07:58 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 034331C060AE;
	Thu, 30 Nov 2023 09:07:58 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 15/18] arm/arm64: Enable the MMU early
Date: Thu, 30 Nov 2023 04:07:17 -0500
Message-Id: <20231130090722.2897974-16-shahuang@redhat.com>
In-Reply-To: <20231130090722.2897974-1-shahuang@redhat.com>
References: <20231130090722.2897974-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Alexandru Elisei <alexandru.elisei@arm.com>

Enable the MMU immediately after the physical allocator is initialized,
to make reasoning about what cache maintenance operations are needed a
lot easier.

The translation tables are created with the MMU disabled. Use memalign(),
which resolves to memalign_early(), for creating them, because the physical
allocator has everything in place to perform dcache maintenance on the data
structures it maintains.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 lib/arm/asm/mmu-api.h   |  1 +
 lib/arm/asm/pgtable.h   | 25 ++++++++++++++++++++++---
 lib/arm/mmu.c           | 28 ++++++++++++++++++++--------
 lib/arm/setup.c         |  7 +++++++
 lib/arm64/asm/pgtable.h | 32 ++++++++++++++++++++++++++++----
 5 files changed, 78 insertions(+), 15 deletions(-)

diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index 6c1136d9..4cb03fcb 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -10,6 +10,7 @@ extern void mmu_mark_enabled(int cpu);
 extern void mmu_mark_disabled(int cpu);
 extern void mmu_enable(pgd_t *pgtable);
 extern void mmu_disable(void);
+extern void mmu_setup_early(phys_addr_t phys_end);
 
 extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 			       phys_addr_t phys_start, phys_addr_t phys_end,
diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index a35f4296..49c74e19 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -41,10 +41,16 @@
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
 	assert(PTRS_PER_PGD * sizeof(pgd_t) <= PAGE_SIZE);
-	pgd_t *pgd = alloc_page();
+	pgd_t *pgd = page_alloc_initialized() ? alloc_page() : pgd_alloc_early();
 	return pgd;
 }
 
@@ -65,10 +71,16 @@ static inline pmd_t *pgd_page_vaddr(pgd_t pgd)
 	(pgd_page_vaddr(*(pgd)) + pmd_index(addr))
 
 #define pmd_free(pmd) free_page(pmd)
+static inline pmd_t *pmd_alloc_one_early(void)
+{
+	pmd_t *pmd = memalign(PAGE_SIZE, PAGE_SIZE);
+	memset(pmd, 0, PAGE_SIZE);
+	return pmd;
+}
 static inline pmd_t *pmd_alloc_one(void)
 {
 	assert(PTRS_PER_PMD * sizeof(pmd_t) == PAGE_SIZE);
-	pmd_t *pmd = alloc_page();
+	pmd_t *pmd = page_alloc_initialized() ? alloc_page() : pmd_alloc_one_early();
 	return pmd;
 }
 static inline pmd_t *pmd_alloc(pgd_t *pgd, unsigned long addr)
@@ -92,10 +104,16 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 	(pmd_page_vaddr(*(pmd)) + pte_index(addr))
 
 #define pte_free(pte) free_page(pte)
+static inline pte_t *pte_alloc_one_early(void)
+{
+	pte_t *pte = memalign(PAGE_SIZE, PAGE_SIZE);
+	memset(pte, 0, PAGE_SIZE);
+	return pte;
+}
 static inline pte_t *pte_alloc_one(void)
 {
 	assert(PTRS_PER_PTE * sizeof(pte_t) == PAGE_SIZE);
-	pte_t *pte = alloc_page();
+	pte_t *pte = page_alloc_initialized() ? alloc_page() : pte_alloc_one_early();
 	return pte;
 }
 static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
@@ -104,6 +122,7 @@ static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
 		pmd_t entry;
 		pmd_val(entry) = pgtable_pa(pte_alloc_one()) | PMD_TYPE_TABLE;
 		WRITE_ONCE(*pmd, entry);
+
 	}
 	return pte_offset(pmd, addr);
 }
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 70c5333c..d23a12e8 100644
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
 
@@ -201,7 +200,7 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 	}
 }
 
-void *setup_mmu(phys_addr_t phys_end, void *unused)
+void mmu_setup_early(phys_addr_t phys_end)
 {
 	struct mem_region *r;
 
@@ -216,9 +215,7 @@ void *setup_mmu(phys_addr_t phys_end, void *unused)
 			"Unsupported translation granule %ld\n", PAGE_SIZE);
 #endif
 
-	if (!mmu_idmap)
-		mmu_idmap = pgd_alloc();
-
+	mmu_idmap = pgd_alloc();
 	for (r = mem_regions; r->end; ++r) {
 		if (r->flags & MR_F_IO) {
 			continue;
@@ -236,7 +233,22 @@ void *setup_mmu(phys_addr_t phys_end, void *unused)
 		}
 	}
 
-	mmu_enable(mmu_idmap);
+	/*
+	 * Open-code part of mmu_enabled(), because at this point thread_info
+	 * hasn't been initialized. mmu_mark_enabled() cannot be called here
+	 * because the cpumask operations can only be called later, after
+	 * nr_cpus is initialized in cpu_init().
+	 */
+	asm_mmu_enable((phys_addr_t)(unsigned long)mmu_idmap);
+	current_thread_info()->pgtable = mmu_idmap;
+}
+
+void *setup_mmu(phys_addr_t phys_end, void *unused1)
+{
+	assert(mmu_idmap);
+
+	mmu_mark_enabled(0);
+
 	return mmu_idmap;
 }
 
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index b6fc453e..4b9423e5 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -26,6 +26,7 @@
 #include <asm/smp.h>
 #include <asm/timer.h>
 #include <asm/psci.h>
+#include <asm/mmu.h>
 
 #include "io.h"
 
@@ -226,6 +227,9 @@ static void mem_init(phys_addr_t freemem_start)
 	phys_alloc_init(freemem_start, freemem->end - freemem_start);
 	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
 
+	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
+		mmu_setup_early(freemem->end);
+
 	phys_alloc_get_unused(&base, &top);
 	base = PAGE_ALIGN(base);
 	top = top & PAGE_MASK;
@@ -417,6 +421,9 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 	phys_alloc_init(free_mem_start, free_mem_pages << EFI_PAGE_SHIFT);
 	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
 
+	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
+		mmu_setup_early(free_mem_start + (free_mem_pages << EFI_PAGE_SHIFT));
+
 	phys_alloc_get_unused(&base, &top);
 	base = PAGE_ALIGN(base);
 	top = top & PAGE_MASK;
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index 06357920..cc6a1bb5 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -47,10 +47,16 @@
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
 	assert(PTRS_PER_PGD * sizeof(pgd_t) <= PAGE_SIZE);
-	pgd_t *pgd = alloc_page();
+	pgd_t *pgd = page_alloc_initialized() ? alloc_page() : pgd_alloc_early();
 	return pgd;
 }
 
@@ -75,10 +81,16 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 #define pmd_offset(pud, addr)						\
 	(pud_page_vaddr(*(pud)) + pmd_index(addr))
 #define pmd_free(pmd)	free_page(pmd)
+static inline pmd_t *pmd_alloc_one_early(void)
+{
+	pmd_t *pmd = memalign(PAGE_SIZE, PAGE_SIZE);
+	memset(pmd, 0, PAGE_SIZE);
+	return pmd;
+}
 static inline pmd_t *pmd_alloc_one(void)
 {
 	assert(PTRS_PER_PMD * sizeof(pmd_t) == PAGE_SIZE);
-	pmd_t *pmd = alloc_page();
+	pmd_t *pmd = page_alloc_initialized() ? alloc_page() : pmd_alloc_one_early();
 	return pmd;
 }
 static inline pmd_t *pmd_alloc(pud_t *pud, unsigned long addr)
@@ -102,10 +114,16 @@ static inline pmd_t *pmd_alloc(pud_t *pud, unsigned long addr)
 #define pud_offset(pgd, addr)                           \
 	(pgd_page_vaddr(*(pgd)) + pud_index(addr))
 #define pud_free(pud) free_page(pud)
+static inline pud_t *pud_alloc_one_early(void)
+{
+	pud_t *pud = memalign(PAGE_SIZE, PAGE_SIZE);
+	memset(pud, 0, PAGE_SIZE);
+	return pud;
+}
 static inline pud_t *pud_alloc_one(void)
 {
 	assert(PTRS_PER_PUD * sizeof(pud_t) == PAGE_SIZE);
-	pud_t *pud = alloc_page();
+	pud_t *pud = page_alloc_initialized() ? alloc_page() : pud_alloc_one_early();
 	return pud;
 }
 static inline pud_t *pud_alloc(pgd_t *pgd, unsigned long addr)
@@ -129,10 +147,16 @@ static inline pud_t *pud_alloc(pgd_t *pgd, unsigned long addr)
 	(pmd_page_vaddr(*(pmd)) + pte_index(addr))
 
 #define pte_free(pte) free_page(pte)
+static inline pte_t *pte_alloc_one_early(void)
+{
+	pte_t *pte = memalign(PAGE_SIZE, PAGE_SIZE);
+	memset(pte, 0, PAGE_SIZE);
+	return pte;
+}
 static inline pte_t *pte_alloc_one(void)
 {
 	assert(PTRS_PER_PTE * sizeof(pte_t) == PAGE_SIZE);
-	pte_t *pte = alloc_page();
+	pte_t *pte = page_alloc_initialized() ? alloc_page() : pte_alloc_one_early();
 	return pte;
 }
 static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
-- 
2.40.1


