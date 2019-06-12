Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF5ED42D1C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 19:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405198AbfFLRLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 13:11:06 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:59968 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405298AbfFLRLF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 13:11:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560359464; x=1591895464;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0sTYNypMH60bWy7mpyTtzOSWmLkHItIqbVNN5O//Yh4=;
  b=MBgrCVd8jCI4l1yaw0sMHNDBjU5mm9Ebt7iuhz3JWBMyZCcE+oBHcksX
   f+UfS6SbbfIRlhR3qnbPL8WTVS9WeouoI7sS69+1wNNWoQWUCp+WJT+0F
   DfMXlSqX2h/838hVw+BHUvRnd5ldag1i75kYxYlYtBvItJi0kkIEu82r+
   k=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="810038987"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 12 Jun 2019 17:11:03 +0000
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (pdx2-ws-svc-lb17-vlan3.amazon.com [10.247.140.70])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id 4CB18A228E;
        Wed, 12 Jun 2019 17:11:02 +0000 (UTC)
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (ua08cfdeba6fe59dc80a8.ant.amazon.com [127.0.0.1])
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x5CHB090017869;
        Wed, 12 Jun 2019 19:11:00 +0200
Received: (from mhillenb@localhost)
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Submit) id x5CHAxh5017849;
        Wed, 12 Jun 2019 19:10:59 +0200
From:   Marius Hillenbrand <mhillenb@amazon.de>
To:     kvm@vger.kernel.org
Cc:     Marius Hillenbrand <mhillenb@amazon.de>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: [RFC 04/10] mm: allocate virtual space for process-local memory
Date:   Wed, 12 Jun 2019 19:08:32 +0200
Message-Id: <20190612170834.14855-5-mhillenb@amazon.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612170834.14855-1-mhillenb@amazon.de>
References: <20190612170834.14855-1-mhillenb@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement first half of kmalloc and kfree for process-local memory,
which deals with allocating virtual address ranges in the process-local
memory area.

While the process-local mappings will be visible only in a
single address space, the address of each allocation is still unique to
aid in debugging (e.g., to see page faults instead of silent invalid
accesses). For that purpose, use a global allocator for virtual address
ranges of process-local mappings. Note that the single centralized lock
is good enough for our use case.

Signed-off-by: Marius Hillenbrand <mhillenb@amazon.de>
Cc: Alexander Graf <graf@amazon.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/mm/proclocal.c   |   7 +-
 include/linux/mm_types.h  |   4 +
 include/linux/proclocal.h |  19 +++++
 mm/proclocal.c            | 150 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 179 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/proclocal.c b/arch/x86/mm/proclocal.c
index c64a8ea6360d..dd641995cc9f 100644
--- a/arch/x86/mm/proclocal.c
+++ b/arch/x86/mm/proclocal.c
@@ -10,6 +10,8 @@
 #include <linux/set_memory.h>
 #include <asm/tlb.h>
 
+extern void handle_proclocal_page(struct mm_struct *mm, struct page *page,
+				  unsigned long addr);
 
 static void unmap_leftover_pages_pte(struct mm_struct *mm, pmd_t *pmd,
 				     unsigned long addr, unsigned long end,
@@ -27,6 +29,8 @@ static void unmap_leftover_pages_pte(struct mm_struct *mm, pmd_t *pmd,
 		pte_clear(mm, addr, pte);
 		set_direct_map_default_noflush(page);
 
+		/* callback to non-arch allocator */
+		handle_proclocal_page(mm, page, addr);
 		/*
 		 * scrub page contents. since mm teardown happens from a
 		 * different mm, we cannot just use the process-local virtual
@@ -126,6 +130,7 @@ static void arch_proclocal_teardown_pt(struct mm_struct *mm)
 
 void arch_proclocal_teardown_pages_and_pt(struct mm_struct *mm)
 {
-	unmap_free_leftover_proclocal_pages(mm);
+	if (mm->proclocal_nr_pages)
+		unmap_free_leftover_proclocal_pages(mm);
 	arch_proclocal_teardown_pt(mm);
 }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1cb9243dd299..4bd8737cc7a6 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -510,6 +510,10 @@ struct mm_struct {
 		/* HMM needs to track a few things per mm */
 		struct hmm *hmm;
 #endif
+
+#ifdef CONFIG_PROCLOCAL
+		size_t proclocal_nr_pages;
+#endif
 	} __randomize_layout;
 
 	/*
diff --git a/include/linux/proclocal.h b/include/linux/proclocal.h
index 9dae140c0796..c408e0d1104c 100644
--- a/include/linux/proclocal.h
+++ b/include/linux/proclocal.h
@@ -8,8 +8,27 @@
 
 struct mm_struct;
 
+void *kmalloc_proclocal(size_t size);
+void *kzalloc_proclocal(size_t size);
+void kfree_proclocal(void *vaddr);
+
 void proclocal_mm_exit(struct mm_struct *mm);
 #else  /* !CONFIG_PROCLOCAL */
+static inline void *kmalloc_proclocal(size_t size)
+{
+	return kmalloc(size, GFP_KERNEL);
+}
+
+static inline void * kzalloc_proclocal(size_t size)
+{
+	return kzalloc(size, GFP_KERNEL);
+}
+
+static inline void kfree_proclocal(void *vaddr)
+{
+	kfree(vaddr);
+}
+
 static inline void proclocal_mm_exit(struct mm_struct *mm) { }
 #endif
 
diff --git a/mm/proclocal.c b/mm/proclocal.c
index 72c485c450bf..7a6217faf765 100644
--- a/mm/proclocal.c
+++ b/mm/proclocal.c
@@ -8,6 +8,7 @@
  *
  * Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
  */
+#include <linux/genalloc.h>
 #include <linux/mm.h>
 #include <linux/proclocal.h>
 #include <linux/set_memory.h>
@@ -18,6 +19,43 @@
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
 
+static pte_t *pte_lookup_map(struct mm_struct *mm, unsigned long kvaddr)
+{
+	pgd_t *pgd = pgd_offset(mm, kvaddr);
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	if (IS_ERR_OR_NULL(pgd) || !pgd_present(*pgd))
+		return ERR_PTR(-1);
+
+	p4d = p4d_offset(pgd, kvaddr);
+	if (IS_ERR_OR_NULL(p4d) || !p4d_present(*p4d))
+		return ERR_PTR(-1);
+
+	pud = pud_offset(p4d, kvaddr);
+	if (IS_ERR_OR_NULL(pud) || !pud_present(*pud))
+		return ERR_PTR(-1);
+
+	pmd = pmd_offset(pud, kvaddr);
+	if (IS_ERR_OR_NULL(pmd) || !pmd_present(*pmd))
+		return ERR_PTR(-1);
+
+	return pte_offset_map(pmd, kvaddr);
+}
+
+static struct page *proclocal_find_first_page(struct mm_struct *mm, const void *kvaddr)
+{
+	pte_t *ptep = pte_lookup_map(mm, (unsigned long) kvaddr);
+
+	if(IS_ERR_OR_NULL(ptep))
+		return NULL;
+	if (!pte_present(*ptep))
+		return NULL;
+
+	return pfn_to_page(pte_pfn(*ptep));
+}
+
 void proclocal_release_pages(struct list_head *pages)
 {
 	struct page *pos, *n;
@@ -27,9 +65,121 @@ void proclocal_release_pages(struct list_head *pages)
 	}
 }
 
+static DEFINE_SPINLOCK(proclocal_lock);
+static struct gen_pool *allocator;
+
+static int proclocal_allocator_init(void)
+{
+	int rc;
+
+	allocator = gen_pool_create(PAGE_SHIFT, -1);
+	if (unlikely(IS_ERR(allocator)))
+		return PTR_ERR(allocator);
+	if (!allocator)
+		return -1;
+
+	rc = gen_pool_add(allocator, PROCLOCAL_START, PROCLOCAL_SIZE, -1);
+
+	if (rc)
+		gen_pool_destroy(allocator);
+
+	return rc;
+}
+late_initcall(proclocal_allocator_init);
+
+static void *alloc_virtual(size_t nr_pages)
+{
+	void *kvaddr;
+	spin_lock(&proclocal_lock);
+	kvaddr = (void *)gen_pool_alloc(allocator, nr_pages * PAGE_SIZE);
+	spin_unlock(&proclocal_lock);
+	return kvaddr;
+}
+
+static void free_virtual(const void *kvaddr, size_t nr_pages)
+{
+	spin_lock(&proclocal_lock);
+	gen_pool_free(allocator, (unsigned long)kvaddr,
+			     nr_pages * PAGE_SIZE);
+	spin_unlock(&proclocal_lock);
+}
+
+void *kmalloc_proclocal(size_t size)
+{
+	void *kvaddr = NULL;
+	size_t nr_pages = round_up(size, PAGE_SIZE) / PAGE_SIZE;
+	size_t nr_pages_virtual = nr_pages + 1; /* + guard page */
+
+	BUG_ON(!current);
+	if (!size)
+		return ZERO_SIZE_PTR;
+	might_sleep();
+
+	kvaddr = alloc_virtual(nr_pages_virtual);
+
+	if (IS_ERR_OR_NULL(kvaddr))
+		return kvaddr;
+
+	/* tbd: subsequent patch will allocate and map physical pages */
+
+	return kvaddr;
+}
+EXPORT_SYMBOL(kmalloc_proclocal);
+
+void * kzalloc_proclocal(size_t size)
+{
+	void * kvaddr = kmalloc_proclocal(size);
+
+	if (!IS_ERR_OR_NULL(kvaddr))
+		memset(kvaddr, 0, size);
+	return kvaddr;
+}
+EXPORT_SYMBOL(kzalloc_proclocal);
+
+void kfree_proclocal(void *kvaddr)
+{
+	struct page *first_page;
+	int nr_pages;
+	struct mm_struct *mm;
+
+	if (!kvaddr || kvaddr == ZERO_SIZE_PTR)
+		return;
+
+	pr_debug("kfree for %p (current %p mm %p)\n", kvaddr,
+		 current, current ? current->mm : 0);
+
+	BUG_ON((unsigned long)kvaddr < PROCLOCAL_START);
+	BUG_ON((unsigned long)kvaddr >= (PROCLOCAL_START + PROCLOCAL_SIZE));
+	BUG_ON(!current);
+
+	mm = current->mm;
+	down_write(&mm->mmap_sem);
+	first_page = proclocal_find_first_page(mm, kvaddr);
+	if (IS_ERR_OR_NULL(first_page)) {
+		pr_err("double-free?!\n");
+		BUG();
+	} /* double-free? */
+	nr_pages = first_page->proclocal_nr_pages;
+	BUG_ON(!nr_pages);
+	mm->proclocal_nr_pages -= nr_pages;
+	/* subsequent patch will unmap and release physical pages */
+	up_write(&mm->mmap_sem);
+
+	free_virtual(kvaddr, nr_pages + 1);
+}
+EXPORT_SYMBOL(kfree_proclocal);
+
 void proclocal_mm_exit(struct mm_struct *mm)
 {
 	pr_debug("proclocal_mm_exit for mm %p pgd %p (current is %p)\n", mm, mm->pgd, current);
 
 	arch_proclocal_teardown_pages_and_pt(mm);
 }
+
+void handle_proclocal_page(struct mm_struct *mm, struct page *page,
+				  unsigned long addr)
+{
+	if (page->proclocal_nr_pages) {
+		free_virtual((void *)addr, page->proclocal_nr_pages + 1);
+	}
+}
-- 
2.21.0

