Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEDD227278
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 00:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgGTWqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 18:46:18 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51888 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726691AbgGTWqQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jul 2020 18:46:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595285174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EWKmrTrQETuKElSLNIbgIEKqM+kupAvxE6/XwMWPhHQ=;
        b=EXeu2nvC+DNnSy7KBdvOtjOMYvyvcUm4F54p8Z7wxoKArPCDvaJmiknqr87yN+J5VQ4FdP
        kitFs8WmoakCXwXiBn3B9vo9nyDgrEi96GrExGOs9ORfDBXdxW7tcVR3s2GF9Uq4Egm9yQ
        oVJohpjOsuXhL6WNHTHByhGdaP1VXZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-of_UzjfBNV2CpdiAvkNy-g-1; Mon, 20 Jul 2020 18:46:10 -0400
X-MC-Unique: of_UzjfBNV2CpdiAvkNy-g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79ED618A1DFB;
        Mon, 20 Jul 2020 22:46:08 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81EB92DE6B;
        Mon, 20 Jul 2020 22:46:04 +0000 (UTC)
Date:   Mon, 20 Jul 2020 16:46:03 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jay Zhou <jianjay.zhou@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <cohuck@redhat.com>, <maoming.maoming@huawei.com>,
        <weidong.huang@huawei.com>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] vfio dma_map/unmap: optimized for hugetlbfs pages
Message-ID: <20200720164603.3a622548@x1.home>
In-Reply-To: <20200720082947.1770-1-jianjay.zhou@huawei.com>
References: <20200720082947.1770-1-jianjay.zhou@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Jul 2020 16:29:47 +0800
Jay Zhou <jianjay.zhou@huawei.com> wrote:

> From: Ming Mao <maoming.maoming@huawei.com>
> 
> Hi all,
> I'm working on starting lots of big size
> Virtual Machines(memory: >128GB) with VFIO-devices. And I
> encounter a problem that is the waiting time of starting
> all Virtual Machines is too long. I analyze the startup log
> and find that the time of pinning/unpinning pages could be reduced.
> 
> In the original process, to make sure the pages are contiguous,
> we have to check all pages one by one. I think maybe we can use
> hugetlbfs pages which can skip this step.
> So I create a patch to do this.
> According to my test, the result of this patch is pretty well.
> 
> Virtual Machine: 50G memory, 32 CPU, 1 VFIO-device, 1G hugetlbfs page
>         original   after optimization
> pin time   700ms          0.1ms
> 
> I Suppose that:
> 1)the hugetlbfs page should not be split
> 2)PG_reserved is not relevant for hugetlbfs pages
> 3)we can delete the for loops and use some operations
> (such as atomic_add,page_ref_add) instead
> 
> please correct me if I am wrong.
> 
> Thanks.
> 
> Signed-off-by: Ming Mao <maoming.maoming@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 236 ++++++++++++++++++++++++++++++--
>  include/linux/vfio.h            |  20 +++
>  2 files changed, 246 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 5e556ac91..42e25752e 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -415,6 +415,46 @@ static int put_pfn(unsigned long pfn, int prot)
>  	return 0;
>  }
>  
> +/*
> + * put pfns for a hugetlbfs page
> + * @start:the 4KB-page we start to put,can be any page in this hugetlbfs page
> + * @npage:the number of 4KB-pages need to put

This code supports systems where PAGE_SIZE is not 4KB.

> + * @prot:IOMMU_READ/WRITE
> + */
> +static int hugetlb_put_pfn(unsigned long start, unsigned int npage, int prot)
> +{
> +	struct page *page = NULL;
> +	struct page *head = NULL;

Unnecessary initialization.

> +
> +	if (!npage || !pfn_valid(start))
> +		return 0;
> +
> +	page = pfn_to_page(start);
> +	if (!page || !PageHuge(page))
> +		return 0;
> +	head = compound_head(page);
> +	/*
> +	 * The last page should be in this hugetlbfs page.
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
> @@ -479,6 +519,90 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>  	return ret;
>  }
>  
> +struct vfio_hupetlbpage_info vfio_hugetlbpage_info[HUGE_MAX_HSTATE] = {
> +	{vfio_hugetlbpage_2M, PMD_SIZE, ~((1ULL << HPAGE_PMD_SHIFT) - 1)},
> +	{vfio_hugetlbpage_1G, PUD_SIZE, ~((1ULL << HPAGE_PUD_SHIFT) - 1)},

Other architectures support more huge page sizes, also 0-day identified
these #defines don't exist when THP is not configured.  But why
couldn't we figure out all of these form the compound_order()?  order
== shift, size = PAGE_SIZE << order.

> +};
> +
> +static bool is_hugetlbpage(unsigned long pfn, enum vfio_hugetlbpage_type *type)
> +{
> +	struct page *page = NULL;

Unnecessary initialization.

> +
> +	if (!pfn_valid(pfn) || !type)
> +		return false;
> +
> +	page = pfn_to_page(pfn);
> +	/* only check for hugetlbfs pages */
> +	if (!page || !PageHuge(page))
> +		return false;
> +
> +	switch (compound_order(compound_head(page))) {
> +	case PMD_ORDER:
> +		*type = vfio_hugetlbpage_2M;
> +		break;
> +	case PUD_ORDER:
> +		*type = vfio_hugetlbpage_1G;
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +/* Is the addr in the last page in hugetlbfs pages? */
> +static bool hugetlb_is_last_page(unsigned long addr, enum vfio_hugetlbpage_type type)
> +{
> +	unsigned int num = 0;

Unnecessary initialization, and in fact unnecessary variable altogether.
ie.

	return hugetlb_get_resdual_pages(addr & ~(PAGE_SIZE - 1), type) == 1;


> +
> +	num = hugetlb_get_resdual_pages(addr & ~(PAGE_SIZE - 1), type);

residual?

> +
> +	if (num == 1)
> +		return true;
> +	else
> +		return false;
> +}
> +
> +static bool hugetlb_page_is_pinned(struct vfio_dma *dma,
> +				unsigned long start,
> +				unsigned long npages)
> +{
> +	struct vfio_pfn *vpfn = NULL;

Unnecessary initialization.

> +	struct rb_node *node = rb_first(&dma->pfn_list);
> +	unsigned long end = start + npages - 1;
> +
> +	for (; node; node = rb_next(node)) {
> +		vpfn = rb_entry(node, struct vfio_pfn, node);
> +
> +		if ((vpfn->pfn >= start) && (vpfn->pfn <= end))
> +			return true;

This function could be named better, it suggests the hugetlbfs page is
pinned, but really we're only looking for any pfn_list pinnings
overlapping the pfn range.

> +	}
> +
> +	return false;
> +}
> +
> +static unsigned int hugetlb_get_contiguous_pages_num(struct vfio_dma *dma,
> +						unsigned long pfn,
> +						unsigned long resdual_npage,
> +						unsigned long max_npage)
> +{
> +	unsigned int num = 0;

Unnecessary initialization

> +
> +	if (!dma)
> +		return 0;
> +
> +	num = resdual_npage < max_npage ? resdual_npage : max_npage;

min(resdual_npage, max_npage)


> +	/*
> +	 * If there is only one page, it is no need to optimize them.

s/no need/not necessary/

> +	 * Maybe some pages have been pinned and inserted into dma->pfn_list by others.
> +	 * In this case, we just goto the slow path simply.
> +	 */
> +	if ((num < 2) || hugetlb_page_is_pinned(dma, pfn, num))
> +		return 0;

Why does having pinnings in the pfn_list disqualify it from hugetlbfs pinning?

Testing for the last page here is redundant to the pinning path, should
it only be done here?  Can num be zero?  

Maybe better to return -errno for this and above zero conditions rather
than return a value that doesn't reflect the purpose of the function?

> +
> +	return num;
> +}
> +
>  /*
>   * Attempt to pin pages.  We really don't want to track all the pfns and
>   * the iommu can only map chunks of consecutive pfns anyway, so get the
> @@ -492,6 +616,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  	long ret, pinned = 0, lock_acct = 0;
>  	bool rsvd;
>  	dma_addr_t iova = vaddr - dma->vaddr + dma->iova;
> +	enum vfio_hugetlbpage_type type;
>  
>  	/* This code path is only user initiated */
>  	if (!current->mm)
> @@ -521,6 +646,55 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  	if (unlikely(disable_hugepages))
>  		goto out;
>  
> +	/*
> +	 * It is no need to get pages one by one for hugetlbfs pages.

s/no need/not necessary/

> +	 * 4KB-pages in hugetlbfs pages are contiguous.
> +	 * But if the vaddr is in the last 4KB-page, we just goto the slow path.


s/4KB-/PAGE_SIZE /

Please explain the significance of vaddr being in the last PAGE_SIZE
page of a hugetlbfs page.  Is it simply that we should take the slow
path for mapping a single page before the end of the hugetlbfs page?
Is this optimization worthwhile?  Isn't it more consistent to handle
all mappings over hugetlbfs pages the same?  Should we be operating on
vaddr here for the hugetlbfs page alignment or base_pfn?

> +	 */
> +	if (is_hugetlbpage(*pfn_base, &type) && !hugetlb_is_last_page(vaddr, type)) {
> +		unsigned long hugetlb_resdual_npage = 0;
> +		unsigned long contiguous_npage = 0;
> +		struct page *head = NULL;
> +
> +		hugetlb_resdual_npage =
> +			hugetlb_get_resdual_pages((vaddr + PAGE_SIZE) & ~(PAGE_SIZE - 1), type);

~(PAGE_SIZE - 1) is PAGE_MASK, but that whole operation looks like a
PAGE_ALIGN(vaddr)

This is trying to get the number of pages after this page to the end of
the hugetlbfs page, right?  Rather than the hugetlb_is_last_page()
above, shouldn't we have recorded the number of pages there and used
math to get this value?

> +		/*
> +		 * Maybe the hugetlb_resdual_npage is invalid.
> +		 * For example, hugetlb_resdual_npage > (npage - 1) or
> +		 * some pages of this hugetlbfs page have been pinned.
> +		 */
> +		contiguous_npage = hugetlb_get_contiguous_pages_num(dma, *pfn_base + 1,
> +						hugetlb_resdual_npage, npage - 1);
> +		if (!contiguous_npage)
> +			goto slow_path;
> +
> +		/*
> +		 * Unlike THP, the splitting should not happen for hugetlbfs pages.
> +		 * Since PG_reserved is not relevant for compound pages, and the pfn of
> +		 * 4KB-page which in hugetlbfs pages is valid,

s/4KB/PAGE_SIZE/

> +		 * it is no need to check rsvd for hugetlbfs pages.

s/no need/not necessary/

> +		 */
> +		if (!dma->lock_cap &&
> +		    current->mm->locked_vm + lock_acct + contiguous_npage > limit) {
> +			pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> +				 __func__, limit << PAGE_SHIFT);
> +			ret = -ENOMEM;
> +			goto unpin_out;
> +		}
> +		/*
> +		 * We got a hugetlbfs page using vaddr_get_pfn alreadly.
> +		 * In this case,we do not need to alloc pages and we can finish all
> +		 * work by a single operation to the head page.
> +		 */
> +		lock_acct += contiguous_npage;
> +		head = compound_head(pfn_to_page(*pfn_base));
> +		atomic_add(contiguous_npage, compound_pincount_ptr(head));
> +		page_ref_add(head, contiguous_npage);
> +		mod_node_page_state(page_pgdat(head), NR_FOLL_PIN_ACQUIRED, contiguous_npage);
> +		pinned += contiguous_npage;
> +		goto out;

I'm hoping Peter or Andrea understand this, but I think we still have
pfn_base pinned separately and I don't see that we've done an unpin
anywhere, so are we leaking the pin of the first page??

> +	}
> +slow_path:
>  	/* Lock all the consecutive pages from pfn_base */
>  	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
>  	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
> @@ -569,7 +743,30 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>  {
>  	long unlocked = 0, locked = 0;
>  	long i;
> +	enum vfio_hugetlbpage_type type;
> +
> +	if (is_hugetlbpage(pfn, &type)) {
> +		unsigned long hugetlb_resdual_npage = 0;
> +		unsigned long contiguous_npage = 0;

Unnecessary initialization...

>  
> +		hugetlb_resdual_npage = hugetlb_get_resdual_pages(iova & ~(PAGE_SIZE - 1), type);

PAGE_MASK

Like above, is it pfn or iova that we should be using when looking at
hugetlbfs alignment?

> +		contiguous_npage = hugetlb_get_contiguous_pages_num(dma, pfn,
> +						hugetlb_resdual_npage, npage);
> +		/*
> +		 * There is not enough contiguous pages or this hugetlbfs page
> +		 * has been pinned.
> +		 * Let's try the slow path.
> +		 */
> +		if (!contiguous_npage)
> +			goto slow_path;
> +
> +		/* try the slow path if failed */
> +		if (hugetlb_put_pfn(pfn, contiguous_npage, dma->prot)) {
> +			unlocked = contiguous_npage;
> +			goto out;
> +		}

Should probably break the pin path into a separate get_pfn function for symmetry.


> +	}
> +slow_path:
>  	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
>  		if (put_pfn(pfn++, dma->prot)) {
>  			unlocked++;
> @@ -578,6 +775,7 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>  		}
>  	}
>  
> +out:
>  	if (do_accounting)
>  		vfio_lock_acct(dma, locked - unlocked, true);
>  
> @@ -867,6 +1065,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  	struct iommu_iotlb_gather iotlb_gather;
>  	int unmapped_region_cnt = 0;
>  	long unlocked = 0;
> +	enum vfio_hugetlbpage_type type;
>  
>  	if (!dma->size)
>  		return 0;
> @@ -900,16 +1099,33 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  			continue;
>  		}
>  
> -		/*
> -		 * To optimize for fewer iommu_unmap() calls, each of which
> -		 * may require hardware cache flushing, try to find the
> -		 * largest contiguous physical memory chunk to unmap.
> -		 */
> -		for (len = PAGE_SIZE;
> -		     !domain->fgsp && iova + len < end; len += PAGE_SIZE) {
> -			next = iommu_iova_to_phys(domain->domain, iova + len);
> -			if (next != phys + len)
> -				break;
> +		if (is_hugetlbpage((phys >> PAGE_SHIFT), &type)
> +		    && (!domain->fgsp)) {

Reverse the order of these tests.

> +			unsigned long hugetlb_resdual_npage = 0;
> +			unsigned long contiguous_npage = 0;


Unnecessary...

> +			hugetlb_resdual_npage =
> +				hugetlb_get_resdual_pages(iova & ~(PAGE_SIZE - 1), type);

PAGE_MASK

> +			/*
> +			 * The number of contiguous page can not be larger than dma->size
> +			 * which is the number of pages pinned.
> +			 */
> +			contiguous_npage = ((dma->size >> PAGE_SHIFT) > hugetlb_resdual_npage) ?
> +				hugetlb_resdual_npage : (dma->size >> PAGE_SHIFT);

min()

> +
> +			len = contiguous_npage * PAGE_SIZE;
> +		} else {
> +			/*
> +			 * To optimize for fewer iommu_unmap() calls, each of which
> +			 * may require hardware cache flushing, try to find the
> +			 * largest contiguous physical memory chunk to unmap.
> +			 */
> +			for (len = PAGE_SIZE;
> +			     !domain->fgsp && iova + len < end; len += PAGE_SIZE) {
> +				next = iommu_iova_to_phys(domain->domain, iova + len);
> +				if (next != phys + len)
> +					break;
> +			}
>  		}
>  
>  		/*
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 38d3c6a8d..91ef2058f 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -214,4 +214,24 @@ extern int vfio_virqfd_enable(void *opaque,
>  			      void *data, struct virqfd **pvirqfd, int fd);
>  extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
>  
> +enum vfio_hugetlbpage_type {
> +	vfio_hugetlbpage_2M,
> +	vfio_hugetlbpage_1G,
> +};
> +
> +struct vfio_hupetlbpage_info {
> +	enum vfio_hugetlbpage_type type;

The enum within the structure serves no purpose.

> +	unsigned long size;
> +	unsigned long mask;
> +};
> +
> +#define PMD_ORDER 9
> +#define PUD_ORDER 18

Architecture specific.

> +/*
> + * get the number of resdual 4KB-pages in a hugetlbfs page
> + * (including the page which pointed by this address)

s/4KB/PAGE_SIZE/

> + */
> +#define hugetlb_get_resdual_pages(address, type)				\
> +		((vfio_hugetlbpage_info[type].size				\
> +		- (address & ~vfio_hugetlbpage_info[type].mask)) >> PAGE_SHIFT)
>  #endif /* VFIO_H */

