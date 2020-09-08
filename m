Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E92261788
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 19:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731741AbgIHRg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 13:36:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:35804 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731778AbgIHRgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 13:36:41 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D444FBCC89A828FA0E43;
        Tue,  8 Sep 2020 21:32:26 +0800 (CST)
Received: from localhost (10.174.151.129) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Tue, 8 Sep 2020
 21:32:16 +0800
From:   Ming Mao <maoming.maoming@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-mm@kvack.org>, <alex.williamson@redhat.com>,
        <akpm@linux-foundation.org>
CC:     <cohuck@redhat.com>, <jianjay.zhou@huawei.com>,
        <weidong.huang@huawei.com>, <peterx@redhat.com>,
        <aarcange@redhat.com>, <wangyunjian@huawei.com>,
        Ming Mao <maoming.maoming@huawei.com>
Subject: [PATCH V4 2/2] vfio: optimized for unpinning pages
Date:   Tue, 8 Sep 2020 21:32:04 +0800
Message-ID: <20200908133204.1338-3-maoming.maoming@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200908133204.1338-1-maoming.maoming@huawei.com>
References: <20200908133204.1338-1-maoming.maoming@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.151.129]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pages are unpinned one by one in unpin_user_pages_dirty_lock().
We add a new API unpin_user_hugetlb_pages_dirty_lock() which deletes
the for loop to optimize this.
If we want to unpin the hugetlb pages, all work can be done by a single
operation to the head page in this API.

Signed-off-by: Ming Mao <maoming.maoming@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 90 +++++++++++++++++++++++++++-----
 include/linux/mm.h              |  3 ++
 mm/gup.c                        | 91 +++++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 8c1dc5136..44fc5f16c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -609,6 +609,26 @@ static long hugetlb_page_vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr
 	return ret;
 }
 
+/*
+ * put pfns for a hugetlb page
+ * @start: the PAGE_SIZE-page we start to put,can be any page in this hugetlb page
+ * @npages: the number of PAGE_SIZE-pages to put
+ * @prot: IOMMU_READ/WRITE
+ */
+static int hugetlb_put_pfn(unsigned long start, unsigned long npages, int prot)
+{
+	struct page *page;
+
+	if (!pfn_valid(start))
+		return -EFAULT;
+
+	page = pfn_to_page(start);
+	if (!page || !PageHuge(page))
+		return -EINVAL;
+
+	return unpin_user_hugetlb_pages_dirty_lock(page, npages, prot & IOMMU_WRITE);
+}
+
 static long vfio_pin_hugetlb_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 				  long npage, unsigned long *pfn_base,
 				  unsigned long limit)
@@ -616,7 +636,7 @@ static long vfio_pin_hugetlb_pages_remote(struct vfio_dma *dma, unsigned long va
 	unsigned long pfn = 0;
 	long ret, pinned = 0, lock_acct = 0;
 	dma_addr_t iova = vaddr - dma->vaddr + dma->iova;
-	long pinned_loop, i;
+	long pinned_loop;
 
 	/* This code path is only user initiated */
 	if (!current->mm)
@@ -674,8 +694,7 @@ static long vfio_pin_hugetlb_pages_remote(struct vfio_dma *dma, unsigned long va
 
 		if (!dma->lock_cap &&
 		    current->mm->locked_vm + lock_acct > limit) {
-			for (i = 0; i < pinned_loop; i++)
-				put_pfn(pfn++, dma->prot);
+			hugetlb_put_pfn(pfn, pinned_loop, dma->prot);
 			pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
 				__func__, limit << PAGE_SHIFT);
 			ret = -ENOMEM;
@@ -695,6 +714,40 @@ static long vfio_pin_hugetlb_pages_remote(struct vfio_dma *dma, unsigned long va
 	return pinned;
 }
 
+static long vfio_unpin_hugetlb_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
+					    unsigned long pfn, long npage,
+					    bool do_accounting)
+{
+	long unlocked = 0, locked = 0;
+	long i, unpinned;
+
+	for (i = 0; i < npage; i += unpinned, iova += unpinned * PAGE_SIZE) {
+		if (!is_hugetlb_page(pfn))
+			goto slow_path;
+
+		unpinned = hugetlb_put_pfn(pfn, npage - i, dma->prot);
+		if (unpinned > 0) {
+			pfn += unpinned;
+			unlocked += unpinned;
+			locked += hugetlb_page_get_externally_pinned_num(dma, pfn, unpinned);
+		} else
+			goto slow_path;
+	}
+slow_path:
+	for (; i < npage; i++, iova += PAGE_SIZE) {
+		if (put_pfn(pfn++, dma->prot)) {
+			unlocked++;
+			if (vfio_find_vpfn(dma, iova))
+				locked++;
+		}
+	}
+
+	if (do_accounting)
+		vfio_lock_acct(dma, locked - unlocked, true);
+
+	return unlocked;
+}
+
 /*
  * Attempt to pin pages.  We really don't want to track all the pfns and
  * the iommu can only map chunks of consecutive pfns anyway, so get the
@@ -993,11 +1046,18 @@ static long vfio_sync_unpin(struct vfio_dma *dma, struct vfio_domain *domain,
 	iommu_tlb_sync(domain->domain, iotlb_gather);
 
 	list_for_each_entry_safe(entry, next, regions, list) {
-		unlocked += vfio_unpin_pages_remote(dma,
-						    entry->iova,
-						    entry->phys >> PAGE_SHIFT,
-						    entry->len >> PAGE_SHIFT,
-						    false);
+		if (is_hugetlb_page(entry->phys >> PAGE_SHIFT))
+			unlocked += vfio_unpin_hugetlb_pages_remote(dma,
+								    entry->iova,
+								    entry->phys >> PAGE_SHIFT,
+								    entry->len >> PAGE_SHIFT,
+								    false);
+		else
+			unlocked += vfio_unpin_pages_remote(dma,
+							    entry->iova,
+							    entry->phys >> PAGE_SHIFT,
+							    entry->len >> PAGE_SHIFT,
+							    false);
 		list_del(&entry->list);
 		kfree(entry);
 	}
@@ -1064,10 +1124,16 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
 	size_t unmapped = iommu_unmap(domain->domain, *iova, len);
 
 	if (unmapped) {
-		*unlocked += vfio_unpin_pages_remote(dma, *iova,
-						     phys >> PAGE_SHIFT,
-						     unmapped >> PAGE_SHIFT,
-						     false);
+		if (is_hugetlb_page(phys >> PAGE_SHIFT))
+			*unlocked += vfio_unpin_hugetlb_pages_remote(dma, *iova,
+								     phys >> PAGE_SHIFT,
+								     unmapped >> PAGE_SHIFT,
+								     false);
+		else
+			*unlocked += vfio_unpin_pages_remote(dma, *iova,
+							     phys >> PAGE_SHIFT,
+							     unmapped >> PAGE_SHIFT,
+							     false);
 		*iova += unmapped;
 		cond_resched();
 	}
diff --git a/include/linux/mm.h b/include/linux/mm.h
index dc7b87310..a425135d0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1202,8 +1202,11 @@ static inline void put_page(struct page *page)
 #define GUP_PIN_COUNTING_BIAS (1U << 10)
 
 void unpin_user_page(struct page *page);
+int unpin_user_hugetlb_page(struct page *page, unsigned long npages);
 void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages,
 				 bool make_dirty);
+int unpin_user_hugetlb_pages_dirty_lock(struct page *pages, unsigned long npages,
+					bool make_dirty);
 void unpin_user_pages(struct page **pages, unsigned long npages);
 
 /**
diff --git a/mm/gup.c b/mm/gup.c
index 6f47697f8..14ee321eb 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -205,11 +205,42 @@ static bool __unpin_devmap_managed_user_page(struct page *page)
 
 	return true;
 }
+
+static bool __unpin_devmap_managed_user_hugetlb_page(struct page *page, unsigned long npages)
+{
+	int count;
+	struct page *head = compound_head(page);
+
+	if (!page_is_devmap_managed(head))
+		return false;
+
+	hpage_pincount_sub(head, npages);
+
+	count = page_ref_sub_return(head, npages);
+
+	mod_node_page_state(page_pgdat(head), NR_FOLL_PIN_RELEASED, npages);
+	/*
+	 * devmap page refcounts are 1-based, rather than 0-based: if
+	 * refcount is 1, then the page is free and the refcount is
+	 * stable because nobody holds a reference on the page.
+	 */
+	if (count == 1)
+		free_devmap_managed_page(head);
+	else if (!count)
+		__put_page(head);
+
+	return true;
+}
 #else
 static bool __unpin_devmap_managed_user_page(struct page *page)
 {
 	return false;
 }
+
+static bool __unpin_devmap_managed_user_hugetlb_page(struct page *page, unsigned long npages)
+{
+	return false;
+}
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
 
 /**
@@ -248,6 +279,66 @@ void unpin_user_page(struct page *page)
 }
 EXPORT_SYMBOL(unpin_user_page);
 
+int unpin_user_hugetlb_page(struct page *page, unsigned long npages)
+{
+	struct page *head;
+	long page_offset, unpinned, hugetlb_npages;
+
+	if (!page || !PageHuge(page))
+		return -EINVAL;
+
+	if (!npages)
+		return 0;
+
+	head = compound_head(page);
+	hugetlb_npages = 1UL << compound_order(head);
+	/* the offset of this subpage in the hugetlb page */
+	page_offset = page_to_pfn(page) & (hugetlb_npages - 1);
+	/* unpinned > 0, because page_offset is always less than hugetlb_npages */
+	unpinned = min_t(long, npages, (hugetlb_npages - page_offset));
+
+	if (__unpin_devmap_managed_user_hugetlb_page(page, unpinned))
+		return unpinned;
+
+	hpage_pincount_sub(head, unpinned);
+
+	if (page_ref_sub_and_test(head, unpinned))
+		__put_page(head);
+	mod_node_page_state(page_pgdat(head), NR_FOLL_PIN_RELEASED, unpinned);
+
+	return unpinned;
+}
+EXPORT_SYMBOL(unpin_user_hugetlb_page);
+
+/*
+ * @page:the first subpage to unpin in a hugetlb page
+ * @npages: number of pages to unpin
+ * @make_dirty: whether to mark the pages dirty
+ *
+ * Nearly the same as unpin_user_pages_dirty_lock
+ * If npages is 0, returns 0.
+ * If npages is >0, returns the number of
+ * pages unpinned. And this may be less than npages.
+ */
+int unpin_user_hugetlb_pages_dirty_lock(struct page *page, unsigned long npages,
+					bool make_dirty)
+{
+	struct page *head;
+
+	if (!page || !PageHuge(page))
+		return -EINVAL;
+
+	if (!npages)
+		return 0;
+
+	head = compound_head(page);
+	if (make_dirty && !PageDirty(head))
+		set_page_dirty_lock(head);
+
+	return unpin_user_hugetlb_page(page, npages);
+}
+EXPORT_SYMBOL(unpin_user_hugetlb_pages_dirty_lock);
+
 /**
  * unpin_user_pages_dirty_lock() - release and optionally dirty gup-pinned pages
  * @pages:  array of pages to be maybe marked dirty, and definitely released.
-- 
2.23.0


