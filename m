Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FCE2573FD
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 08:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgHaGyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 02:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgHaGyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 02:54:35 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E304C061573
        for <kvm@vger.kernel.org>; Sun, 30 Aug 2020 23:54:35 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id 185so128537oie.11
        for <kvm@vger.kernel.org>; Sun, 30 Aug 2020 23:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=Ab9XhQYUYbeJZJX9HU3fytbWghiFvOPEC728Oub8U28=;
        b=RheOEc7lVnoePbAPn+s+QnS4JcyyIpp+RNfGP80KRmIedXpergtJHVV03XiwGT+Tef
         8VXldHxP+0zmywWj6Lrm00s+NtAjFLtCMFFe0Q9XK88n2soR/WHr6z8fxuNVZTx2CId2
         roN9o4AJVtSG2DGkGAZ/F84TQUf4l1buexa+c2w4JarDv2k+trAIv3hY5qH+zD3c+hls
         URmdLI9TZJgJcccTViNZj8lG56/SpYnNTk/UijDk3DdrezrT29T3R4fus1Dm+WwZ/6t1
         8jEdG2bar8eIJ4NNSPxwvVvmuLpYHl7xWchHUpAe/Vt9IcjXTKxIALBGVKbT7wl/GLE2
         k5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=Ab9XhQYUYbeJZJX9HU3fytbWghiFvOPEC728Oub8U28=;
        b=AWG8OV4Kr6bpH8J9LQ7+joCjhWWc0xptSMhB9ksD4/7P1MTdkVPux2+BR8O28rmEYC
         LqS/PfeqtNWlDmFa0a5SyzAkhIwqzew4+jy6Y7FBCIrhCyOv2pL9UaxknykxiRzt6wVd
         VowyCvKqYyNMfYJFZE/6bSh/sfPWrrsFT373wLxbmkzLlsG4dUN52euStimSZMC667L3
         0IFiTU79D5x0V2t5CauZpHu1gXqGDUa8ts5KxJIkAPdz9yUvCdu5nTEPEBJbDLsqO5+E
         i9LJscDa0hMMEn73RRe3bc9Al1ON2HfCsW1K2gHZZ5LQN8FFjRJGMxgPx8cs/udmAaFR
         6LJQ==
X-Gm-Message-State: AOAM530qewfNM5JMWe1NVQ6+1TmW72ovW3AoYls+oMDnX96zQ7lD21Jp
        LJKu4PDEn7m3eqbKyjLG4mkT/w==
X-Google-Smtp-Source: ABdhPJxHvqbM1ZLBb24EGvldhYw8ZBvNtE7j0tU4aton9KRS//U0zHIpHqRBhmr5R1DFylakeFkpjQ==
X-Received: by 2002:aca:ed42:: with SMTP id l63mr70587oih.178.1598856874274;
        Sun, 30 Aug 2020 23:54:34 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id i6sm688362oib.17.2020.08.30.23.54.32
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sun, 30 Aug 2020 23:54:33 -0700 (PDT)
Date:   Sun, 30 Aug 2020 23:54:19 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Ming Mao <maoming.maoming@huawei.com>
cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
        jianjay.zhou@huawei.com, weidong.huang@huawei.com,
        peterx@redhat.com, aarcange@redhat.com, wangyunjian@huawei.com
Subject: Re: [PATCH V3] vfio dma_map/unmap: optimized for hugetlbfs pages
In-Reply-To: <20200828092649.853-1-maoming.maoming@huawei.com>
Message-ID: <alpine.LSU.2.11.2008302332330.2382@eggly.anvils>
References: <20200828092649.853-1-maoming.maoming@huawei.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 Aug 2020, Ming Mao wrote:

> In the original process of dma_map/unmap pages for VFIO-devices,
> to make sure the pages are contiguous, we have to check them one by one.
> As a result, dma_map/unmap could spend a long time.
> Using the hugetlb pages, we can avoid this problem.
> All pages in hugetlb pages are contiguous.And the hugetlb
> page should not be split.So we can delete the for loops.

I know nothing about VFIO, but I'm surprised that you're paying such
attention to PageHuge hugetlbfs pages, rather than to PageCompound
pages: which would also include Transparent Huge Pages, of the
traditional anonymous kind, or the huge tmpfs kind, or the more
general (not necessarily pmd-sized) kind that Matthew Wilcox is
currently working on.

It's true that hugetlbfs is peculiar enough that whatever you write
for it may need some tweaks to cover the THP case too, or vice versa;
but wouldn't your patch be a lot better for covering all cases?

You mention above that "the hugetlb page should not be split":
perhaps you have been worried that a THP could be split beneath you?
That used to be a possibility some years ago, but nowadays a THP
cannot be split while anyone is pinning it with an extra reference.

Hugh

> 
> Signed-off-by: Ming Mao <maoming.maoming@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 393 +++++++++++++++++++++++++++++++-
>  1 file changed, 382 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 5e556ac91..a689b9698 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -479,6 +479,303 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>  	return ret;
>  }
>  
> +static bool is_hugetlb_page(unsigned long pfn)
> +{
> +	struct page *page;
> +
> +	if (!pfn_valid(pfn))
> +		return false;
> +
> +	page = pfn_to_page(pfn);
> +	/* only check for hugetlb pages */
> +	return page && PageHuge(page);
> +}
> +
> +static bool vaddr_is_hugetlb_page(unsigned long vaddr, int prot)
> +{
> +	unsigned long pfn;
> +	int ret;
> +	bool result;
> +
> +	if (!current->mm)
> +		return false;
> +
> +	ret = vaddr_get_pfn(current->mm, vaddr, prot, &pfn);
> +	if (ret)
> +		return false;
> +
> +	result = is_hugetlb_page(pfn);
> +
> +	put_pfn(pfn, prot);
> +
> +	return result;
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
> +		return -EINVAL;
> +
> +	hugetlb_npage = 1UL << order;
> +	hugetlb_mask = hugetlb_npage - 1;
> +	address = address >> PAGE_SHIFT;
> +
> +	/*
> +	 * Since we count the page pointed by this address, the number of
> +	 * residual PAGE_SIZE-pages is greater than or equal to 1.
> +	 */
> +	return hugetlb_npage - (address & hugetlb_mask);
> +}
> +
> +static unsigned int
> +hugetlb_page_get_externally_pinned_num(struct vfio_dma *dma,
> +				unsigned long start,
> +				unsigned long npage)
> +{
> +	struct vfio_pfn *vpfn;
> +	struct rb_node *node;
> +	unsigned long end;
> +	unsigned int num = 0;
> +
> +	if (!dma || !npage)
> +		return 0;
> +
> +	end = start + npage - 1;
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
> +static long hugetlb_page_vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
> +					int prot, long npage, unsigned long pfn)
> +{
> +	long hugetlb_residual_npage;
> +	struct page *head;
> +	int ret = 0;
> +	unsigned int contiguous_npage;
> +	struct page **pages = NULL;
> +	unsigned int flags = 0;
> +
> +	if ((npage < 0) || !pfn_valid(pfn))
> +		return -EINVAL;
> +
> +	/* all pages are done? */
> +	if (!npage)
> +		goto out;
> +	/*
> +	 * Since pfn is valid,
> +	 * hugetlb_residual_npage is greater than or equal to 1.
> +	 */
> +	head = compound_head(pfn_to_page(pfn));
> +	hugetlb_residual_npage = hugetlb_get_residual_pages(vaddr,
> +						compound_order(head));
> +	/* The page of vaddr has been gotten by vaddr_get_pfn */
> +	contiguous_npage = min_t(long, (hugetlb_residual_npage - 1), npage);
> +	/* There is on page left in this hugetlb page. */
> +	if (!contiguous_npage)
> +		goto out;
> +
> +	pages = kvmalloc_array(contiguous_npage, sizeof(struct page *), GFP_KERNEL);
> +	if (!pages)
> +		return -ENOMEM;
> +
> +	if (prot & IOMMU_WRITE)
> +		flags |= FOLL_WRITE;
> +
> +	mmap_read_lock(mm);
> +	/* The number of pages pinned may be less than contiguous_npage */
> +	ret = pin_user_pages_remote(NULL, mm, vaddr + PAGE_SIZE, contiguous_npage,
> +				flags | FOLL_LONGTERM, pages, NULL, NULL);
> +	mmap_read_unlock(mm);
> +out:
> +	if (pages)
> +		kvfree(pages);
> +	return ret;
> +}
> +
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
> +		|| (page_ref_count(head) < npage)
> +		|| (compound_pincount(page) < npage))
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
> +static long vfio_pin_hugetlb_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> +				  long npage, unsigned long *pfn_base,
> +				  unsigned long limit)
> +{
> +	unsigned long pfn = 0;
> +	long ret, pinned = 0, lock_acct = 0;
> +	dma_addr_t iova = vaddr - dma->vaddr + dma->iova;
> +	long pinned_loop;
> +
> +	/* This code path is only user initiated */
> +	if (!current->mm)
> +		return -ENODEV;
> +
> +	ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, pfn_base);
> +	if (ret)
> +		return ret;
> +
> +	pinned++;
> +	/*
> +	 * Since PG_reserved is not relevant for compound pages
> +	 * and the pfn of PAGE_SIZE-page which in hugetlb pages is valid,
> +	 * it is not necessary to check rsvd for hugetlb pages.
> +	 */
> +	if (!vfio_find_vpfn(dma, iova)) {
> +		if (!dma->lock_cap && current->mm->locked_vm + 1 > limit) {
> +			put_pfn(*pfn_base, dma->prot);
> +			pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n", __func__,
> +				limit << PAGE_SHIFT);
> +			return -ENOMEM;
> +		}
> +		lock_acct++;
> +	}
> +
> +	/* Lock all the consecutive pages from pfn_base */
> +	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
> +	     pinned += pinned_loop, vaddr += pinned_loop * PAGE_SIZE,
> +	     iova += pinned_loop * PAGE_SIZE) {
> +		ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, &pfn);
> +		if (ret)
> +			break;
> +
> +		if (pfn != *pfn_base + pinned ||
> +		    !is_hugetlb_page(pfn)) {
> +			put_pfn(pfn, dma->prot);
> +			break;
> +		}
> +
> +		pinned_loop = 1;
> +		/*
> +		 * It is possible that the page of vaddr is the last PAGE_SIZE-page.
> +		 * In this case, vaddr + PAGE_SIZE might be another hugetlb page.
> +		 */
> +		ret = hugetlb_page_vaddr_get_pfn(current->mm, vaddr, dma->prot,
> +						npage - pinned - pinned_loop, pfn);
> +		if (ret < 0) {
> +			put_pfn(pfn, dma->prot);
> +			break;
> +		}
> +
> +		pinned_loop += ret;
> +		lock_acct += pinned_loop - hugetlb_page_get_externally_pinned_num(dma,
> +			pfn, pinned_loop);
> +
> +		if (!dma->lock_cap &&
> +		    current->mm->locked_vm + lock_acct > limit) {
> +			hugetlb_put_pfn(pfn, pinned_loop, dma->prot);
> +			pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> +				__func__, limit << PAGE_SHIFT);
> +			ret = -ENOMEM;
> +			goto unpin_out;
> +		}
> +	}
> +
> +	ret = vfio_lock_acct(dma, lock_acct, false);
> +
> +unpin_out:
> +	if (ret) {
> +		for (pfn = *pfn_base ; pinned ; pfn++, pinned--)
> +			put_pfn(pfn, dma->prot);
> +		return ret;
> +	}
> +
> +	return pinned;
> +}
> +
> +static long vfio_unpin_hugetlb_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
> +					unsigned long pfn, long npage,
> +					bool do_accounting)
> +{
> +	long unlocked = 0, locked = 0;
> +	long i;
> +	long hugetlb_residual_npage;
> +	long contiguous_npage;
> +	struct page *head;
> +
> +	for (i = 0; i < npage;
> +	     i += contiguous_npage, iova += contiguous_npage * PAGE_SIZE) {
> +		if (!is_hugetlb_page(pfn))
> +			goto slow_path;
> +
> +		head = compound_head(pfn_to_page(pfn));
> +		hugetlb_residual_npage = hugetlb_get_residual_pages(iova,
> +								compound_order(head));
> +		contiguous_npage = min_t(long, hugetlb_residual_npage, (npage - i));
> +
> +		if (hugetlb_put_pfn(pfn, contiguous_npage, dma->prot)) {
> +			pfn += contiguous_npage;
> +			unlocked += contiguous_npage;
> +			locked += hugetlb_page_get_externally_pinned_num(dma, pfn,
> +									contiguous_npage);
> +		}
> +	}
> +slow_path:
> +	for (; i < npage; i++, iova += PAGE_SIZE) {
> +		if (put_pfn(pfn++, dma->prot)) {
> +			unlocked++;
> +			if (vfio_find_vpfn(dma, iova))
> +				locked++;
> +		}
> +	}
> +
> +	if (do_accounting)
> +		vfio_lock_acct(dma, locked - unlocked, true);
> +
> +	return unlocked;
> +}
> +
>  /*
>   * Attempt to pin pages.  We really don't want to track all the pfns and
>   * the iommu can only map chunks of consecutive pfns anyway, so get the
> @@ -777,7 +1074,14 @@ static long vfio_sync_unpin(struct vfio_dma *dma, struct vfio_domain *domain,
>  	iommu_tlb_sync(domain->domain, iotlb_gather);
>  
>  	list_for_each_entry_safe(entry, next, regions, list) {
> -		unlocked += vfio_unpin_pages_remote(dma,
> +		if (is_hugetlb_page(entry->phys >> PAGE_SHIFT))
> +			unlocked += vfio_unpin_hugetlb_pages_remote(dma,
> +						    entry->iova,
> +						    entry->phys >> PAGE_SHIFT,
> +						    entry->len >> PAGE_SHIFT,
> +						    false);
> +		else
> +			unlocked += vfio_unpin_pages_remote(dma,
>  						    entry->iova,
>  						    entry->phys >> PAGE_SHIFT,
>  						    entry->len >> PAGE_SHIFT,
> @@ -848,7 +1152,13 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
>  	size_t unmapped = iommu_unmap(domain->domain, *iova, len);
>  
>  	if (unmapped) {
> -		*unlocked += vfio_unpin_pages_remote(dma, *iova,
> +		if (is_hugetlb_page(phys >> PAGE_SHIFT))
> +			*unlocked += vfio_unpin_hugetlb_pages_remote(dma, *iova,
> +						     phys >> PAGE_SHIFT,
> +						     unmapped >> PAGE_SHIFT,
> +						     false);
> +		else
> +			*unlocked += vfio_unpin_pages_remote(dma, *iova,
>  						     phys >> PAGE_SHIFT,
>  						     unmapped >> PAGE_SHIFT,
>  						     false);
> @@ -858,6 +1168,57 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
>  	return unmapped;
>  }
>  
> +static size_t get_contiguous_pages(struct vfio_domain *domain, dma_addr_t start,
> +				dma_addr_t end, phys_addr_t phys_base)
> +{
> +	size_t len;
> +	phys_addr_t next;
> +
> +	if (!domain)
> +		return 0;
> +
> +	for (len = PAGE_SIZE;
> +	     !domain->fgsp && start + len < end; len += PAGE_SIZE) {
> +		next = iommu_iova_to_phys(domain->domain, start + len);
> +		if (next != phys_base + len)
> +			break;
> +	}
> +
> +	return len;
> +}
> +
> +static size_t hugetlb_get_contiguous_pages(struct vfio_domain *domain, dma_addr_t start,
> +				dma_addr_t end, phys_addr_t phys_base)
> +{
> +	size_t len;
> +	phys_addr_t next;
> +	unsigned long contiguous_npage;
> +	dma_addr_t max_len;
> +	unsigned long hugetlb_residual_npage;
> +	struct page *head;
> +	unsigned long limit;
> +
> +	if (!domain)
> +		return 0;
> +
> +	max_len = end - start;
> +	for (len = PAGE_SIZE;
> +	     !domain->fgsp && start + len < end; len += contiguous_npage * PAGE_SIZE) {
> +		next = iommu_iova_to_phys(domain->domain, start + len);
> +		if ((next != phys_base + len) ||
> +		    !is_hugetlb_page(next >> PAGE_SHIFT))
> +			break;
> +
> +		head = compound_head(pfn_to_page(next >> PAGE_SHIFT));
> +		hugetlb_residual_npage = hugetlb_get_residual_pages(start + len,
> +								compound_order(head));
> +		limit = ALIGN((max_len - len), PAGE_SIZE) >> PAGE_SHIFT;
> +		contiguous_npage = min_t(unsigned long, hugetlb_residual_npage, limit);
> +	}
> +
> +	return len;
> +}
> +
>  static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  			     bool do_accounting)
>  {
> @@ -892,7 +1253,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  	iommu_iotlb_gather_init(&iotlb_gather);
>  	while (iova < end) {
>  		size_t unmapped, len;
> -		phys_addr_t phys, next;
> +		phys_addr_t phys;
>  
>  		phys = iommu_iova_to_phys(domain->domain, iova);
>  		if (WARN_ON(!phys)) {
> @@ -905,12 +1266,10 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  		 * may require hardware cache flushing, try to find the
>  		 * largest contiguous physical memory chunk to unmap.
>  		 */
> -		for (len = PAGE_SIZE;
> -		     !domain->fgsp && iova + len < end; len += PAGE_SIZE) {
> -			next = iommu_iova_to_phys(domain->domain, iova + len);
> -			if (next != phys + len)
> -				break;
> -		}
> +		if (is_hugetlb_page(phys >> PAGE_SHIFT))
> +			len = hugetlb_get_contiguous_pages(domain, iova, end, phys);
> +		else
> +			len = get_contiguous_pages(domain, iova, end, phys);
>  
>  		/*
>  		 * First, try to use fast unmap/unpin. In case of failure,
> @@ -1243,7 +1602,15 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  
>  	while (size) {
>  		/* Pin a contiguous chunk of memory */
> -		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
> +		if (vaddr_is_hugetlb_page(vaddr + dma->size, dma->prot)) {
> +			npage = vfio_pin_hugetlb_pages_remote(dma, vaddr + dma->size,
> +					      size >> PAGE_SHIFT, &pfn, limit);
> +			/* try the normal page if failed */
> +			if (npage <= 0)
> +				npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
> +					      size >> PAGE_SHIFT, &pfn, limit);
> +		} else
> +			npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
>  					      size >> PAGE_SHIFT, &pfn, limit);
>  		if (npage <= 0) {
>  			WARN_ON(!npage);
> @@ -1255,7 +1622,11 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  		ret = vfio_iommu_map(iommu, iova + dma->size, pfn, npage,
>  				     dma->prot);
>  		if (ret) {
> -			vfio_unpin_pages_remote(dma, iova + dma->size, pfn,
> +			if (is_hugetlb_page(pfn))
> +				vfio_unpin_hugetlb_pages_remote(dma, iova + dma->size, pfn,
> +						npage, true);
> +			else
> +				vfio_unpin_pages_remote(dma, iova + dma->size, pfn,
>  						npage, true);
>  			break;
>  		}
> -- 
> 2.23.0
> 
> 
> 
