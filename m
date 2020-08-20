Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C408024C5B5
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 20:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgHTSiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 14:38:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53993 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726701AbgHTSiR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 14:38:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597948694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hwDTQto2EJFjavZgAL+q7WDXNOyGUc1xSFD1wpx2kLM=;
        b=BU4zao03S9BVMmHfVDRNUoMiRmlqAH1DsrKSo6/PNWHWAspu0KBLkXF3wKXkQgi6L5TWTa
        /VctUXvAHeBsnpapBAGhAzDHD617K5i42fnnFwd1nK+Hx5UjWwxxsC7+siCJkrNWLtbeH4
        Ec77EU7PrW+7BlGkLkZhXUscIv20TiQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-H15DHBhXN3C346x-puNliA-1; Thu, 20 Aug 2020 14:38:08 -0400
X-MC-Unique: H15DHBhXN3C346x-puNliA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 904C210082E6;
        Thu, 20 Aug 2020 18:38:06 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 744E019D7D;
        Thu, 20 Aug 2020 18:38:02 +0000 (UTC)
Date:   Thu, 20 Aug 2020 12:38:02 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Ming Mao <maoming.maoming@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <cohuck@redhat.com>, <jianjay.zhou@huawei.com>,
        <weidong.huang@huawei.com>, <peterx@redhat.com>,
        <aarcange@redhat.com>
Subject: Re: [PATCH V2] vfio dma_map/unmap: optimized for hugetlbfs pages
Message-ID: <20200820123802.724afd4a@x1.home>
In-Reply-To: <20200814023729.2270-1-maoming.maoming@huawei.com>
References: <20200814023729.2270-1-maoming.maoming@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Aug 2020 10:37:29 +0800
Ming Mao <maoming.maoming@huawei.com> wrote:

> In the original process of pinning/unpinning pages for VFIO-devices,
> to make sure the pages are contiguous, we have to check them one by one.
> As a result, dma_map/unmap could spend a long time.
> Using the hugetlb pages, we can avoid this problem.
> All pages in hugetlb pages are contiguous.And the hugetlb
> page should not be split.So we can delete the for loops and use
> some operations(such as atomic_add,page_ref_add) instead.
> 
> Signed-off-by: Ming Mao <maoming.maoming@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 233 +++++++++++++++++++++++++++++++-
>  1 file changed, 230 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 5e556ac91..8957013c1 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -415,6 +415,46 @@ static int put_pfn(unsigned long pfn, int prot)
>  	return 0;
>  }
>  
> +/*
> + * put pfns for a hugetlb page
> + * @start:the PAGE_SIZE-page we start to put,can be any page in this hugetlb page
> + * @npage:the number of PAGE_SIZE-pages need to put
> + * @prot:IOMMU_READ/WRITE
> + */
> +static int hugetlb_put_pfn(unsigned long start, unsigned int npage, int prot)
> +{
> +	struct page *page;
> +	struct page *head;
> +
> +	if (!npage || !pfn_valid(start))
> +		return 0;
> +
> +	page = pfn_to_page(start);
> +	if (!page || !PageHuge(page))
> +		return 0;
> +	head = compound_head(page);
> +	/*
> +	 * The last page should be in this hugetlb page.
> +	 * The number of putting pages should be equal to the number
> +	 * of getting pages.So the hugepage pinned refcount and the normal
> +	 * page refcount can not be smaller than npage.
> +	 */
> +	if ((head != compound_head(pfn_to_page(start + npage - 1)))
> +	    || (page_ref_count(head) < npage)
> +	    || (compound_pincount(page) < npage))
> +		return 0;
> +
> +	if ((prot & IOMMU_WRITE) && !PageDirty(page))
> +		set_page_dirty_lock(page);
> +
> +	atomic_sub(npage, compound_pincount_ptr(head));
> +	if (page_ref_sub_and_test(head, npage))
> +		__put_page(head);
> +
> +	mod_node_page_state(page_pgdat(head), NR_FOLL_PIN_RELEASED, npage);
> +	return 1;
> +}
> +
>  static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
>  			    unsigned long vaddr, unsigned long *pfn,
>  			    bool write_fault)
> @@ -479,6 +519,105 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>  	return ret;
>  }
>  
> +static bool is_hugetlbpage(unsigned long pfn)
> +{
> +	struct page *page;
> +
> +	if (!pfn_valid(pfn))
> +		return false;
> +
> +	page = pfn_to_page(pfn);
> +	/* only check for hugetlb pages */
> +	if (!page || !PageHuge(page))
> +		return false;
> +
> +	return true;


return page && PageHuge(page);


> +}
> +
> +/*
> + * get the number of residual PAGE_SIZE-pages in a hugetlb page
> + * (including the page which pointed by this address)
> + * @address: we count residual pages from this address to the end of
> + * a hugetlb page
> + * @order: the order of the same hugetlb page
> + */
> +static long
> +hugetlb_get_residual_pages(unsigned long address, unsigned int order)
> +{
> +	unsigned long hugetlb_npage;
> +	unsigned long hugetlb_mask;
> +
> +	if (!order)
> +		return -1;

Use a real errno please.

> +
> +	hugetlb_npage = _AC(1, UL) << order;

This doesn't seem an appropriate use of _AC(), 1UL << order should be
fine.

> +	hugetlb_mask = (hugetlb_npage << PAGE_SHIFT) - 1;
> +	address = ALIGN_DOWN(address, PAGE_SIZE);

hugetlb_mask doesn't need to be in bytes, it could be in pages
(hugetlb_npage - 1), then we could simply convert address to pfn
(address >> PAGE_SHIFT), then we avoid the shift below:

return hugetlb_npage - ((address >> PAGE_SHIFT) & (hugetlb_npage - 1));

> +
> +	/*
> +	 * Since we count the page pointed by this address, the number of
> +	 * residual PAGE_SIZE-pages is greater than or equal to 1.
> +	 */
> +	return hugetlb_npage - ((address & hugetlb_mask) >> PAGE_SHIFT);
> +}
> +
> +static unsigned int
> +hugetlb_page_get_externally_pinned_num(struct vfio_dma *dma,
> +				unsigned long start,
> +				unsigned long npage)
> +{
> +	struct vfio_pfn *vpfn;
> +	struct rb_node *node;
> +	unsigned long end = start + npage - 1;
> +	unsigned int num = 0;
> +
> +	if (!dma || !npage)
> +		return 0;
> +
> +	/* If we find a page in dma->pfn_list, this page has been pinned externally */
> +	for (node = rb_first(&dma->pfn_list); node; node = rb_next(node)) {
> +		vpfn = rb_entry(node, struct vfio_pfn, node);
> +		if ((vpfn->pfn >= start) && (vpfn->pfn <= end))
> +			num++;
> +	}
> +
> +	return num;
> +}
> +
> +static long hugetlb_page_vaddr_get_pfn(unsigned long vaddr, long npage,
> +						unsigned long pfn)
> +{
> +	long hugetlb_residual_npage;
> +	long contiguous_npage;
> +	struct page *head = compound_head(pfn_to_page(pfn));
> +
> +	/*
> +	 * If pfn is valid,
> +	 * hugetlb_residual_npage is greater than or equal to 1.
> +	 */
> +	hugetlb_residual_npage = hugetlb_get_residual_pages(vaddr,
> +						compound_order(head));
> +	if (hugetlb_residual_npage < 0)
> +		return -1;

Forward the errno

> +
> +	/* The page of vaddr has been gotten by vaddr_get_pfn */
> +	contiguous_npage = min_t(long, (hugetlb_residual_npage - 1), npage);
> +	if (!contiguous_npage)
> +		return 0;
> +	/*
> +	 * Unlike THP, the splitting should not happen for hugetlb pages.
> +	 * Since PG_reserved is not relevant for compound pages, and the pfn of
> +	 * PAGE_SIZE page which in hugetlb pages is valid,
> +	 * it is not necessary to check rsvd for hugetlb pages.
> +	 * We do not need to alloc pages because of vaddr and we can finish all
> +	 * work by a single operation to the head page.
> +	 */
> +	atomic_add(contiguous_npage, compound_pincount_ptr(head));
> +	page_ref_add(head, contiguous_npage);
> +	mod_node_page_state(page_pgdat(head), NR_FOLL_PIN_ACQUIRED, contiguous_npage);
> +
> +	return contiguous_npage;
> +}
>  /*
>   * Attempt to pin pages.  We really don't want to track all the pfns and
>   * the iommu can only map chunks of consecutive pfns anyway, so get the
> @@ -492,6 +631,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  	long ret, pinned = 0, lock_acct = 0;
>  	bool rsvd;
>  	dma_addr_t iova = vaddr - dma->vaddr + dma->iova;
> +	long contiguous_npage;
>  
>  	/* This code path is only user initiated */
>  	if (!current->mm)
> @@ -523,7 +663,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  
>  	/* Lock all the consecutive pages from pfn_base */
>  	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
> -	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
> +	     pinned += contiguous_npage, vaddr += contiguous_npage * PAGE_SIZE,
> +	     iova += contiguous_npage * PAGE_SIZE) {
>  		ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, &pfn);
>  		if (ret)
>  			break;
> @@ -545,6 +686,54 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  			}
>  			lock_acct++;
>  		}
> +
> +		contiguous_npage = 0;
> +		/*
> +		 * It is not necessary to get pages one by one for hugetlb pages.
> +		 * All PAGE_SIZE-pages in hugetlb pages are contiguous.
> +		 * If npage - pinned is 1, all pages are pinned.
> +		 */

I really don't like this result of trying to squeeze hugepages into the
end of the existing algorithm.  We currently pin the first page, then
pin each next page until we find one that is not contiguous or we hit
our desired length or limit.  As I understand the modified algorithm,
for each next page, after we've pinned it, we test if it's a hugetlbfs
page, then pin the remainder of the pages via a different mechanism, up
to the desired length or limit, continuing by again pinning the next
individual page and repeating the hugetlbfs test.  This means we're
typically starting from the second page and mixing pages pinned
individually vs via the hugepage.

Would it be cleaner to move hugetlbfs handling to the start of the
loop?  In the single page case, we pin the next page in order to
determine if it's contiugous, unpinning if it's not.  In the hugetlbfs
case, we can determine from the initial page the extent of the
contiguous range.

Moving to the head of the loop might not be sufficient to achieve the
simplification I'm looking for, but I think we need to cleanup the
various off-by-one or off-by-two corrections that occur in this
implementation, they're hard to follow.


> +		if ((npage - pinned > 1) && is_hugetlbpage(pfn)) {
> +			/*
> +			 * We must use the vaddr to get the contiguous pages.
> +			 * Because it is possible that the page of vaddr
> +			 * is the last PAGE_SIZE-page. In this case, vaddr + PAGE_SIZE
> +			 * is in another hugetlb page.
> +			 * And the left pages is npage - pinned - 1(vaddr).
> +			 */
> +			contiguous_npage = hugetlb_page_vaddr_get_pfn(vaddr,
> +							npage - pinned - 1, pfn);
> +			if (contiguous_npage < 0) {
> +				put_pfn(pfn, dma->prot);
> +				ret = -EINVAL;

This should return the errno from hugetlb_page_vaddr_get_pfn() rather
than inventing one.

> +				goto unpin_out;
> +			}
> +			/*
> +			 * If contiguous_npage is 0, the vaddr is the last PAGE_SIZE-page
> +			 * of a hugetlb page.
> +			 * We should continue and find the next one.
> +			 */
> +			if (!contiguous_npage) {
> +				/* set 1 for the vaddr */
> +				contiguous_npage = 1;
> +				continue;
> +			}
> +			lock_acct += contiguous_npage - hugetlb_page_get_externally_pinned_num(dma,
> +					pfn, contiguous_npage);
> +
> +			if (!dma->lock_cap &&
> +			    current->mm->locked_vm + lock_acct > limit) {
> +				for (; contiguous_npage; pfn++, contiguous_npage--)
> +					put_pfn(pfn, dma->prot);

This seems really asymmetric to the pinning, where we've used hugetlbfs
mechanisms to make the pinned pages, but we're releasing them
individually.  Ideally we should use the same mechanism per page.

> +				pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> +					__func__, limit << PAGE_SHIFT);
> +				ret = -ENOMEM;
> +				goto unpin_out;
> +			}
> +		}
> +
> +		/* add for the vaddr */
> +		contiguous_npage++;
>  	}
>  
>  out:
> @@ -569,13 +758,38 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>  {
>  	long unlocked = 0, locked = 0;
>  	long i;
> +	long hugetlb_residual_npage;
> +	long contiguous_npage;
> +	struct page *head;
>  
> -	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
> +	for (i = 0; i < npage; i += contiguous_npage, iova += contiguous_npage * PAGE_SIZE) {
> +		if (is_hugetlbpage(pfn)) {
> +			/*
> +			 * Since pfn is valid,
> +			 * hugetlb_residual_npage is greater than or equal to 1.
> +			 */
> +			head = compound_head(pfn_to_page(pfn));
> +			hugetlb_residual_npage = hugetlb_get_residual_pages(iova,
> +									compound_order(head));
> +			contiguous_npage = min_t(long, hugetlb_residual_npage, (npage - i));
> +
> +			/* try the slow path if failed */
> +			if (!hugetlb_put_pfn(pfn, contiguous_npage, dma->prot))
> +				goto slow_path;
> +
> +			pfn += contiguous_npage;
> +			unlocked += contiguous_npage;
> +			locked += hugetlb_page_get_externally_pinned_num(dma, pfn,
> +									contiguous_npage);
> +			continue;
> +		}
> +slow_path:
>  		if (put_pfn(pfn++, dma->prot)) {
>  			unlocked++;
>  			if (vfio_find_vpfn(dma, iova))
>  				locked++;
>  		}
> +		contiguous_npage = 1;
>  	}
>  
>  	if (do_accounting)
> @@ -893,6 +1107,9 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  	while (iova < end) {
>  		size_t unmapped, len;
>  		phys_addr_t phys, next;
> +		long hugetlb_residual_npage;
> +		long contiguous_npage;
> +		struct page *head;
>  
>  		phys = iommu_iova_to_phys(domain->domain, iova);
>  		if (WARN_ON(!phys)) {
> @@ -906,10 +1123,20 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  		 * largest contiguous physical memory chunk to unmap.
>  		 */
>  		for (len = PAGE_SIZE;
> -		     !domain->fgsp && iova + len < end; len += PAGE_SIZE) {
> +		    !domain->fgsp && iova + len < end; len += PAGE_SIZE * contiguous_npage) {
>  			next = iommu_iova_to_phys(domain->domain, iova + len);
>  			if (next != phys + len)
>  				break;
> +
> +			if (((dma->size - len) >> PAGE_SHIFT)
> +				&& is_hugetlbpage(next >> PAGE_SHIFT)) {
> +				head = compound_head(pfn_to_page(next >> PAGE_SHIFT));
> +				hugetlb_residual_npage = hugetlb_get_residual_pages(iova + len,
> +									compound_order(head));
> +				contiguous_npage = min_t(long, ((dma->size - len) >> PAGE_SHIFT),
> +								hugetlb_residual_npage);

Same idea here as above, we're again starting from the 2nd page to
determine hugetlbfs pages, it feels very ad hoc.  Thanks,

Alex

> +			} else
> +				contiguous_npage = 1;
>  		}
>  
>  		/*

