Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F268624430E
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 04:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgHNCh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 22:37:57 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48414 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726564AbgHNCh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 22:37:56 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 57CBFB3BDEE95E867C78;
        Fri, 14 Aug 2020 10:37:50 +0800 (CST)
Received: from localhost (10.174.151.124) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Fri, 14 Aug 2020
 10:37:44 +0800
From:   Ming Mao <maoming.maoming@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <jianjay.zhou@huawei.com>,
        <weidong.huang@huawei.com>, <peterx@redhat.com>,
        <aarcange@redhat.com>, "Ming Mao" <maoming.maoming@huawei.com>
Subject: [PATCH V2] vfio dma_map/unmap: optimized for hugetlbfs pages
Date:   Fri, 14 Aug 2020 10:37:29 +0800
Message-ID: <20200814023729.2270-1-maoming.maoming@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.151.124]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the original process of pinning/unpinning pages for VFIO-devices,
to make sure the pages are contiguous, we have to check them one by one.
As a result, dma_map/unmap could spend a long time.
Using the hugetlb pages, we can avoid this problem.
All pages in hugetlb pages are contiguous.And the hugetlb
page should not be split.So we can delete the for loops and use
some operations(such as atomic_add,page_ref_add) instead.

Signed-off-by: Ming Mao <maoming.maoming@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 233 +++++++++++++++++++++++++++++++-
 1 file changed, 230 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5e556ac91..8957013c1 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -415,6 +415,46 @@ static int put_pfn(unsigned long pfn, int prot)
 	return 0;
 }
 
+/*
+ * put pfns for a hugetlb page
+ * @start:the PAGE_SIZE-page we start to put,can be any page in this hugetlb page
+ * @npage:the number of PAGE_SIZE-pages need to put
+ * @prot:IOMMU_READ/WRITE
+ */
+static int hugetlb_put_pfn(unsigned long start, unsigned int npage, int prot)
+{
+	struct page *page;
+	struct page *head;
+
+	if (!npage || !pfn_valid(start))
+		return 0;
+
+	page = pfn_to_page(start);
+	if (!page || !PageHuge(page))
+		return 0;
+	head = compound_head(page);
+	/*
+	 * The last page should be in this hugetlb page.
+	 * The number of putting pages should be equal to the number
+	 * of getting pages.So the hugepage pinned refcount and the normal
+	 * page refcount can not be smaller than npage.
+	 */
+	if ((head != compound_head(pfn_to_page(start + npage - 1)))
+	    || (page_ref_count(head) < npage)
+	    || (compound_pincount(page) < npage))
+		return 0;
+
+	if ((prot & IOMMU_WRITE) && !PageDirty(page))
+		set_page_dirty_lock(page);
+
+	atomic_sub(npage, compound_pincount_ptr(head));
+	if (page_ref_sub_and_test(head, npage))
+		__put_page(head);
+
+	mod_node_page_state(page_pgdat(head), NR_FOLL_PIN_RELEASED, npage);
+	return 1;
+}
+
 static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 			    unsigned long vaddr, unsigned long *pfn,
 			    bool write_fault)
@@ -479,6 +519,105 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 	return ret;
 }
 
+static bool is_hugetlbpage(unsigned long pfn)
+{
+	struct page *page;
+
+	if (!pfn_valid(pfn))
+		return false;
+
+	page = pfn_to_page(pfn);
+	/* only check for hugetlb pages */
+	if (!page || !PageHuge(page))
+		return false;
+
+	return true;
+}
+
+/*
+ * get the number of residual PAGE_SIZE-pages in a hugetlb page
+ * (including the page which pointed by this address)
+ * @address: we count residual pages from this address to the end of
+ * a hugetlb page
+ * @order: the order of the same hugetlb page
+ */
+static long
+hugetlb_get_residual_pages(unsigned long address, unsigned int order)
+{
+	unsigned long hugetlb_npage;
+	unsigned long hugetlb_mask;
+
+	if (!order)
+		return -1;
+
+	hugetlb_npage = _AC(1, UL) << order;
+	hugetlb_mask = (hugetlb_npage << PAGE_SHIFT) - 1;
+	address = ALIGN_DOWN(address, PAGE_SIZE);
+
+	/*
+	 * Since we count the page pointed by this address, the number of
+	 * residual PAGE_SIZE-pages is greater than or equal to 1.
+	 */
+	return hugetlb_npage - ((address & hugetlb_mask) >> PAGE_SHIFT);
+}
+
+static unsigned int
+hugetlb_page_get_externally_pinned_num(struct vfio_dma *dma,
+				unsigned long start,
+				unsigned long npage)
+{
+	struct vfio_pfn *vpfn;
+	struct rb_node *node;
+	unsigned long end = start + npage - 1;
+	unsigned int num = 0;
+
+	if (!dma || !npage)
+		return 0;
+
+	/* If we find a page in dma->pfn_list, this page has been pinned externally */
+	for (node = rb_first(&dma->pfn_list); node; node = rb_next(node)) {
+		vpfn = rb_entry(node, struct vfio_pfn, node);
+		if ((vpfn->pfn >= start) && (vpfn->pfn <= end))
+			num++;
+	}
+
+	return num;
+}
+
+static long hugetlb_page_vaddr_get_pfn(unsigned long vaddr, long npage,
+						unsigned long pfn)
+{
+	long hugetlb_residual_npage;
+	long contiguous_npage;
+	struct page *head = compound_head(pfn_to_page(pfn));
+
+	/*
+	 * If pfn is valid,
+	 * hugetlb_residual_npage is greater than or equal to 1.
+	 */
+	hugetlb_residual_npage = hugetlb_get_residual_pages(vaddr,
+						compound_order(head));
+	if (hugetlb_residual_npage < 0)
+		return -1;
+
+	/* The page of vaddr has been gotten by vaddr_get_pfn */
+	contiguous_npage = min_t(long, (hugetlb_residual_npage - 1), npage);
+	if (!contiguous_npage)
+		return 0;
+	/*
+	 * Unlike THP, the splitting should not happen for hugetlb pages.
+	 * Since PG_reserved is not relevant for compound pages, and the pfn of
+	 * PAGE_SIZE page which in hugetlb pages is valid,
+	 * it is not necessary to check rsvd for hugetlb pages.
+	 * We do not need to alloc pages because of vaddr and we can finish all
+	 * work by a single operation to the head page.
+	 */
+	atomic_add(contiguous_npage, compound_pincount_ptr(head));
+	page_ref_add(head, contiguous_npage);
+	mod_node_page_state(page_pgdat(head), NR_FOLL_PIN_ACQUIRED, contiguous_npage);
+
+	return contiguous_npage;
+}
 /*
  * Attempt to pin pages.  We really don't want to track all the pfns and
  * the iommu can only map chunks of consecutive pfns anyway, so get the
@@ -492,6 +631,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	long ret, pinned = 0, lock_acct = 0;
 	bool rsvd;
 	dma_addr_t iova = vaddr - dma->vaddr + dma->iova;
+	long contiguous_npage;
 
 	/* This code path is only user initiated */
 	if (!current->mm)
@@ -523,7 +663,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 
 	/* Lock all the consecutive pages from pfn_base */
 	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
-	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
+	     pinned += contiguous_npage, vaddr += contiguous_npage * PAGE_SIZE,
+	     iova += contiguous_npage * PAGE_SIZE) {
 		ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, &pfn);
 		if (ret)
 			break;
@@ -545,6 +686,54 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 			}
 			lock_acct++;
 		}
+
+		contiguous_npage = 0;
+		/*
+		 * It is not necessary to get pages one by one for hugetlb pages.
+		 * All PAGE_SIZE-pages in hugetlb pages are contiguous.
+		 * If npage - pinned is 1, all pages are pinned.
+		 */
+		if ((npage - pinned > 1) && is_hugetlbpage(pfn)) {
+			/*
+			 * We must use the vaddr to get the contiguous pages.
+			 * Because it is possible that the page of vaddr
+			 * is the last PAGE_SIZE-page. In this case, vaddr + PAGE_SIZE
+			 * is in another hugetlb page.
+			 * And the left pages is npage - pinned - 1(vaddr).
+			 */
+			contiguous_npage = hugetlb_page_vaddr_get_pfn(vaddr,
+							npage - pinned - 1, pfn);
+			if (contiguous_npage < 0) {
+				put_pfn(pfn, dma->prot);
+				ret = -EINVAL;
+				goto unpin_out;
+			}
+			/*
+			 * If contiguous_npage is 0, the vaddr is the last PAGE_SIZE-page
+			 * of a hugetlb page.
+			 * We should continue and find the next one.
+			 */
+			if (!contiguous_npage) {
+				/* set 1 for the vaddr */
+				contiguous_npage = 1;
+				continue;
+			}
+			lock_acct += contiguous_npage - hugetlb_page_get_externally_pinned_num(dma,
+					pfn, contiguous_npage);
+
+			if (!dma->lock_cap &&
+			    current->mm->locked_vm + lock_acct > limit) {
+				for (; contiguous_npage; pfn++, contiguous_npage--)
+					put_pfn(pfn, dma->prot);
+				pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
+					__func__, limit << PAGE_SHIFT);
+				ret = -ENOMEM;
+				goto unpin_out;
+			}
+		}
+
+		/* add for the vaddr */
+		contiguous_npage++;
 	}
 
 out:
@@ -569,13 +758,38 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 {
 	long unlocked = 0, locked = 0;
 	long i;
+	long hugetlb_residual_npage;
+	long contiguous_npage;
+	struct page *head;
 
-	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
+	for (i = 0; i < npage; i += contiguous_npage, iova += contiguous_npage * PAGE_SIZE) {
+		if (is_hugetlbpage(pfn)) {
+			/*
+			 * Since pfn is valid,
+			 * hugetlb_residual_npage is greater than or equal to 1.
+			 */
+			head = compound_head(pfn_to_page(pfn));
+			hugetlb_residual_npage = hugetlb_get_residual_pages(iova,
+									compound_order(head));
+			contiguous_npage = min_t(long, hugetlb_residual_npage, (npage - i));
+
+			/* try the slow path if failed */
+			if (!hugetlb_put_pfn(pfn, contiguous_npage, dma->prot))
+				goto slow_path;
+
+			pfn += contiguous_npage;
+			unlocked += contiguous_npage;
+			locked += hugetlb_page_get_externally_pinned_num(dma, pfn,
+									contiguous_npage);
+			continue;
+		}
+slow_path:
 		if (put_pfn(pfn++, dma->prot)) {
 			unlocked++;
 			if (vfio_find_vpfn(dma, iova))
 				locked++;
 		}
+		contiguous_npage = 1;
 	}
 
 	if (do_accounting)
@@ -893,6 +1107,9 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	while (iova < end) {
 		size_t unmapped, len;
 		phys_addr_t phys, next;
+		long hugetlb_residual_npage;
+		long contiguous_npage;
+		struct page *head;
 
 		phys = iommu_iova_to_phys(domain->domain, iova);
 		if (WARN_ON(!phys)) {
@@ -906,10 +1123,20 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		 * largest contiguous physical memory chunk to unmap.
 		 */
 		for (len = PAGE_SIZE;
-		     !domain->fgsp && iova + len < end; len += PAGE_SIZE) {
+		    !domain->fgsp && iova + len < end; len += PAGE_SIZE * contiguous_npage) {
 			next = iommu_iova_to_phys(domain->domain, iova + len);
 			if (next != phys + len)
 				break;
+
+			if (((dma->size - len) >> PAGE_SHIFT)
+				&& is_hugetlbpage(next >> PAGE_SHIFT)) {
+				head = compound_head(pfn_to_page(next >> PAGE_SHIFT));
+				hugetlb_residual_npage = hugetlb_get_residual_pages(iova + len,
+									compound_order(head));
+				contiguous_npage = min_t(long, ((dma->size - len) >> PAGE_SHIFT),
+								hugetlb_residual_npage);
+			} else
+				contiguous_npage = 1;
 		}
 
 		/*
-- 
2.23.0


