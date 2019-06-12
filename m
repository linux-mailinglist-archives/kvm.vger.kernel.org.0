Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B3042D1E
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 19:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409002AbfFLRLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 13:11:20 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:41139 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406140AbfFLRLU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 13:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560359479; x=1591895479;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ao+6+ybAOyd/41QkzFZKGeI5GKaYYHvHpMzftf308bY=;
  b=D86NXbePvig4zqCsWHpPh2FXGmmNw/DWihqZVQZH9ec53iGzoXOPfIP6
   9sfLb7Ga6mENhULAKorGZj8Z6m0CafygaLya+6n7oXjKM3MXUFNHN0+20
   7x8uCpYc1CwWNtvDjrbXIZAd/V2cc7TSCHob37KBbeh+plT8KwJBskEF8
   Y=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="805048692"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 12 Jun 2019 17:11:16 +0000
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (pdx2-ws-svc-lb17-vlan2.amazon.com [10.247.140.66])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id F339EA1956;
        Wed, 12 Jun 2019 17:11:15 +0000 (UTC)
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (ua08cfdeba6fe59dc80a8.ant.amazon.com [127.0.0.1])
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x5CHBDtZ018049;
        Wed, 12 Jun 2019 19:11:13 +0200
Received: (from mhillenb@localhost)
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Submit) id x5CHBDRf018047;
        Wed, 12 Jun 2019 19:11:13 +0200
From:   Marius Hillenbrand <mhillenb@amazon.de>
To:     kvm@vger.kernel.org
Cc:     Marius Hillenbrand <mhillenb@amazon.de>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: [RFC 05/10] mm: allocate/release physical pages for process-local memory
Date:   Wed, 12 Jun 2019 19:08:34 +0200
Message-Id: <20190612170834.14855-6-mhillenb@amazon.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612170834.14855-1-mhillenb@amazon.de>
References: <20190612170834.14855-1-mhillenb@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement second half of kmalloc and kfree for process-local memory,
which allocates physical pages, maps them into the kernel virtual
address space of the current process, and removes them from the kernel's
shared direct physical mapping. On kfree, the code performs that
sequence in reverse, after scrubbing the pages' contents.

Note that both the allocation and free path require TLB flushes, to
flush remaining mappings in the direct physical mappings (on allocation)
and in the process-local memory (on release). Aim to keep the impact of
these flushes minimal by flushing only necessary address ranges.

The allocation only handles the smallest page size (i.e., 4 KiB), no
huge pages, because in our use case, the size of individual allocations
is in the order of 4 KiB.

Signed-off-by: Marius Hillenbrand <mhillenb@amazon.de>
Cc: Alexander Graf <graf@amazon.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
---
 mm/proclocal.c | 167 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 165 insertions(+), 2 deletions(-)

diff --git a/mm/proclocal.c b/mm/proclocal.c
index 7a6217faf765..26bc1f3f68a2 100644
--- a/mm/proclocal.c
+++ b/mm/proclocal.c
@@ -56,6 +56,70 @@ static struct page *proclocal_find_first_page(struct mm_struct *mm, const void *
 	return pfn_to_page(pte_pfn(*ptep));
 }
 
+/*
+ * Lookup PTE for a given virtual address. Allocate page table structures, if
+ * they are not present yet.
+ */
+static pte_t *pte_lookup_alloc_map(struct mm_struct *mm, unsigned long kvaddr)
+{
+	pgd_t *pgd = pgd_offset(mm, kvaddr);
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	p4d = p4d_alloc(mm, pgd, kvaddr);
+	if (IS_ERR_OR_NULL(p4d))
+		return (pte_t *)p4d;
+
+	pud = pud_alloc(mm, p4d, kvaddr);
+	if (IS_ERR_OR_NULL(pud))
+		return (pte_t *)pud;
+
+	pmd = pmd_alloc(mm, pud, kvaddr);
+	if (IS_ERR_OR_NULL(pmd))
+		return (pte_t *)pmd;
+
+	return pte_alloc_map(mm, pmd, kvaddr);
+}
+
+static int proclocal_map_notlbflush(struct mm_struct *mm, struct page *page, void *kvaddr)
+{
+	int rc;
+	pte_t *ptep = pte_lookup_alloc_map(mm, (unsigned long)kvaddr);
+
+	if (IS_ERR_OR_NULL(ptep)) {
+		pr_err("failed to pte_lookup_alloc_map, ptep=0x%lx\n",
+		       (unsigned long)ptep);
+		return ptep ? PTR_ERR(ptep) : -ENOMEM;
+	}
+
+	set_pte(ptep, mk_pte(page, kmap_prot));
+	rc = set_direct_map_invalid_noflush(page);
+	if (rc)
+		pte_clear(mm, (unsigned long)kvaddr, ptep);
+	else
+		pr_debug("map pfn %lx at %p for mm %p pgd %p\n", page_to_pfn(page), kvaddr, mm, mm->pgd);
+	return rc;
+}
+
+static void proclocal_unmap_page_notlbflush(struct mm_struct *mm, void *vaddr)
+{
+	pte_t *ptep = pte_lookup_map(mm, (unsigned long)vaddr);
+	pte_t pte;
+	struct page *page;
+
+	BUG_ON(IS_ERR_OR_NULL(ptep));
+	BUG_ON(!pte_present(*ptep)); // already cleared?!
+
+	/* scrub page contents */
+	memset(vaddr, 0, PAGE_SIZE);
+
+	pte = ptep_get_and_clear(mm, (unsigned long)vaddr, ptep);
+	page = pfn_to_page(pte_pfn(pte));
+
+	BUG_ON(set_direct_map_default_noflush(page)); /* should never fail for mapped 4K-pages */
+}
+
 void proclocal_release_pages(struct list_head *pages)
 {
 	struct page *pos, *n;
@@ -65,6 +129,76 @@ void proclocal_release_pages(struct list_head *pages)
 	}
 }
 
+static void proclocal_release_pages_incl_head(struct list_head *pages)
+{
+	proclocal_release_pages(pages);
+	/* the list_head itself is embedded in a struct page we want to release. */
+	__free_page(list_entry(pages, struct page, proclocal_next));
+}
+
+struct physmap_tlb_flush {
+	unsigned long start;
+	unsigned long end;
+};
+
+static inline void track_page_to_flush(struct physmap_tlb_flush *flush, struct page *page)
+{
+	const unsigned long page_start = (unsigned long)page_to_virt(page);
+	const unsigned long page_end = page_start + PAGE_SIZE;
+
+	if (page_start < flush->start)
+		flush->start = page_start;
+	if (page_end > flush->end)
+		flush->end = page_end;
+}
+
+static int alloc_and_map_proclocal_pages(struct mm_struct *mm, void *kvaddr, size_t nr_pages)
+{
+	int rc;
+	size_t i, j;
+	struct page *page;
+	struct list_head *pages_list = NULL;
+	struct physmap_tlb_flush flush = { -1, 0 };
+
+	for (i = 0; i < nr_pages; i++) {
+		page = alloc_page(GFP_KERNEL);
+
+		if (!page) {
+			rc = -ENOMEM;
+			goto unmap_release;
+		}
+
+		rc = proclocal_map_notlbflush(mm, page, kvaddr + i * PAGE_SIZE);
+		if (rc) {
+			__free_page(page);
+			goto unmap_release;
+		}
+
+		track_page_to_flush(&flush, page);
+		INIT_LIST_HEAD(&page->proclocal_next);
+		/* track allocation in first struct page */
+		if (!pages_list) {
+			pages_list = &page->proclocal_next;
+			page->proclocal_nr_pages = nr_pages;
+		} else {
+			list_add_tail(&page->proclocal_next, pages_list);
+			page->proclocal_nr_pages = 0;
+		}
+	}
+
+	/* flush direct mappings of allocated pages from TLBs. */
+	flush_tlb_kernel_range(flush.start, flush.end);
+	return 0;
+
+unmap_release:
+	for (j = 0; j < i; j++)
+		proclocal_unmap_page_notlbflush(mm, kvaddr + j * PAGE_SIZE);
+
+	if (pages_list)
+		proclocal_release_pages_incl_head(pages_list);
+	return rc;
+}
+
 static DEFINE_SPINLOCK(proclocal_lock);
 static struct gen_pool *allocator;
 
@@ -106,9 +240,11 @@ static void free_virtual(const void *kvaddr, size_t nr_pages)
 
 void *kmalloc_proclocal(size_t size)
 {
+	int rc;
 	void *kvaddr = NULL;
 	size_t nr_pages = round_up(size, PAGE_SIZE) / PAGE_SIZE;
 	size_t nr_pages_virtual = nr_pages + 1; /* + guard page */
+	struct mm_struct *mm;
 
 	BUG_ON(!current);
 	if (!size)
@@ -120,7 +256,18 @@ void *kmalloc_proclocal(size_t size)
 	if (IS_ERR_OR_NULL(kvaddr))
 		return kvaddr;
 
-	/* tbd: subsequent patch will allocate and map physical pages */
+	mm = current->mm;
+	down_write(&mm->mmap_sem);
+	rc = alloc_and_map_proclocal_pages(mm, kvaddr, nr_pages);
+	if (!rc)
+		mm->proclocal_nr_pages += nr_pages;
+	up_write(&mm->mmap_sem);
+
+	if (unlikely(rc))
+		kvaddr = ERR_PTR(rc);
+
+	pr_debug("allocated %zd bytes at %p (current %p mm %p)\n", size, kvaddr,
+		 current, current ? current->mm : 0);
 
 	return kvaddr;
 }
@@ -138,6 +285,7 @@ EXPORT_SYMBOL(kzalloc_proclocal);
 
 void kfree_proclocal(void *kvaddr)
 {
+	int i;
 	struct page *first_page;
 	int nr_pages;
 	struct mm_struct *mm;
@@ -152,8 +300,10 @@ void kfree_proclocal(void *kvaddr)
 	BUG_ON((unsigned long)kvaddr >= (PROCLOCAL_START + PROCLOCAL_SIZE));
 	BUG_ON(!current);
 
+	might_sleep();
 	mm = current->mm;
 	down_write(&mm->mmap_sem);
+
 	first_page = proclocal_find_first_page(mm, kvaddr);
 	if (IS_ERR_OR_NULL(first_page)) {
 		pr_err("double-free?!\n");
@@ -162,9 +312,22 @@ void kfree_proclocal(void *kvaddr)
 	nr_pages = first_page->proclocal_nr_pages;
 	BUG_ON(!nr_pages);
 	mm->proclocal_nr_pages -= nr_pages;
-	/* subsequent patch will unmap and release physical pages */
+
+	for (i = 0; i < nr_pages; i++)
+		proclocal_unmap_page_notlbflush(mm, kvaddr + i * PAGE_SIZE);
+
 	up_write(&mm->mmap_sem);
 
+	/*
+	 * Flush process-local mappings from TLBs so that we can release the
+	 * pages afterwards.
+	 */
+	flush_tlb_mm_range(mm, (unsigned long)kvaddr,
+			   (unsigned long)kvaddr + nr_pages * PAGE_SIZE,
+			   PAGE_SHIFT, false);
+
+	proclocal_release_pages_incl_head(&first_page->proclocal_next);
+
 	free_virtual(kvaddr, nr_pages + 1);
 }
 EXPORT_SYMBOL(kfree_proclocal);
-- 
2.21.0

