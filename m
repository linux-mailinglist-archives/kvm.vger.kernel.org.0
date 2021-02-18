Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EFE31EFD7
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 20:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhBRT31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 14:29:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45878 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232834AbhBRTDc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 14:03:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613674924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yu9X6Fkg1PRktBt1patt1k0yU5OsbbRblVF5fVIJPaA=;
        b=fGbWisqK86YtyDTJhC/KYrm0l5C6vdvDvzKWPIX2srqNUQzcA0pQxMFNXDg4cm6b1CpEGf
        +jsS48mxJQN+kbur8cHoV7fnGqTlPAykEvDZHJZRgMXBB/lnxlXbrdCGdpDwyLemO0sFuS
        gc5SLYYmYly3teTNKfgKMl/2q12G1nI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-ZJzca2bkOi67pdXXutphJA-1; Thu, 18 Feb 2021 14:01:58 -0500
X-MC-Unique: ZJzca2bkOi67pdXXutphJA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48D71100CCC0;
        Thu, 18 Feb 2021 19:01:57 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA38160BF3;
        Thu, 18 Feb 2021 19:01:53 +0000 (UTC)
Date:   Thu, 18 Feb 2021 12:01:53 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] vfio/type1: batch page pinning
Message-ID: <20210218120153.4023ae85@omen.home.shazbot.org>
In-Reply-To: <20210203204756.125734-4-daniel.m.jordan@oracle.com>
References: <20210203204756.125734-1-daniel.m.jordan@oracle.com>
        <20210203204756.125734-4-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  3 Feb 2021 15:47:56 -0500
Daniel Jordan <daniel.m.jordan@oracle.com> wrote:

> Pinning one 4K page at a time is inefficient, so do it in batches of 512
> instead.  This is just an optimization with no functional change
> intended, and in particular the driver still calls iommu_map() with the
> largest physically contiguous range possible.
> 
> Add two fields in vfio_batch to remember where to start between calls to
> vfio_pin_pages_remote(), and use vfio_batch_unpin() to handle remaining
> pages in the batch in case of error.
> 
> qemu pins pages for guests around 8% faster on my test system, a
> two-node Broadwell server with 128G memory per node.  The qemu process
> was bound to one node with its allocations constrained there as well.
> 
>                              base               test
>           guest              ----------------   ----------------
>        mem (GB)   speedup    avg sec    (std)   avg sec    (std)
>               1      7.4%       0.61   (0.00)      0.56   (0.00)
>               2      8.3%       0.93   (0.00)      0.85   (0.00)
>               4      8.4%       1.46   (0.00)      1.34   (0.00)
>               8      8.6%       2.54   (0.01)      2.32   (0.00)
>              16      8.3%       4.66   (0.00)      4.27   (0.01)
>              32      8.3%       8.94   (0.01)      8.20   (0.01)
>              64      8.2%      17.47   (0.01)     16.04   (0.03)
>             120      8.5%      32.45   (0.13)     29.69   (0.01)
> 
> perf diff confirms less time spent in pup.  Here are the top ten
> functions:
> 
>              Baseline  Delta Abs  Symbol
> 
>                78.63%     +6.64%  clear_page_erms
>                 1.50%     -1.50%  __gup_longterm_locked
>                 1.27%     -0.78%  __get_user_pages
>                           +0.76%  kvm_zap_rmapp.constprop.0
>                 0.54%     -0.53%  vmacache_find
>                 0.55%     -0.51%  get_pfnblock_flags_mask
>                 0.48%     -0.48%  __get_user_pages_remote
>                           +0.39%  slot_rmap_walk_next
>                           +0.32%  vfio_pin_map_dma
>                           +0.26%  kvm_handle_hva_range
>                 ...
> 
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 133 +++++++++++++++++++++-----------
>  1 file changed, 88 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index c26c1a4697e5..ac59bfc4e332 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -101,6 +101,8 @@ struct vfio_batch {
>  	struct page		**pages;	/* for pin_user_pages_remote */
>  	struct page		*fallback_page; /* if pages alloc fails */
>  	int			capacity;	/* length of pages array */
> +	int			size;		/* of batch currently */
> +	int			offset;		/* of next entry in pages */
>  };
>  
>  struct vfio_group {
> @@ -425,6 +427,9 @@ static int put_pfn(unsigned long pfn, int prot)
>  
>  static void vfio_batch_init(struct vfio_batch *batch)
>  {
> +	batch->size = 0;
> +	batch->offset = 0;
> +
>  	if (unlikely(disable_hugepages))
>  		goto fallback;
>  
> @@ -440,6 +445,17 @@ static void vfio_batch_init(struct vfio_batch *batch)
>  	batch->capacity = 1;
>  }
>  
> +static void vfio_batch_unpin(struct vfio_batch *batch, struct vfio_dma *dma)
> +{
> +	while (batch->size) {
> +		unsigned long pfn = page_to_pfn(batch->pages[batch->offset]);
> +
> +		put_pfn(pfn, dma->prot);
> +		batch->offset++;
> +		batch->size--;
> +	}
> +}
> +
>  static void vfio_batch_fini(struct vfio_batch *batch)
>  {
>  	if (batch->capacity == VFIO_BATCH_MAX_CAPACITY)
> @@ -526,65 +542,88 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  				  long npage, unsigned long *pfn_base,
>  				  unsigned long limit, struct vfio_batch *batch)
>  {
> -	unsigned long pfn = 0;
> +	unsigned long pfn;
> +	struct mm_struct *mm = current->mm;
>  	long ret, pinned = 0, lock_acct = 0;
>  	bool rsvd;
>  	dma_addr_t iova = vaddr - dma->vaddr + dma->iova;
>  
>  	/* This code path is only user initiated */
> -	if (!current->mm)
> +	if (!mm)
>  		return -ENODEV;
>  
> -	ret = vaddr_get_pfns(current->mm, vaddr, 1, dma->prot, pfn_base,
> -			     batch->pages);
> -	if (ret < 0)
> -		return ret;
> -
> -	pinned++;
> -	rsvd = is_invalid_reserved_pfn(*pfn_base);
> -
> -	/*
> -	 * Reserved pages aren't counted against the user, externally pinned
> -	 * pages are already counted against the user.
> -	 */
> -	if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> -		if (!dma->lock_cap && current->mm->locked_vm + 1 > limit) {
> -			put_pfn(*pfn_base, dma->prot);
> -			pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n", __func__,
> -					limit << PAGE_SHIFT);
> -			return -ENOMEM;
> -		}
> -		lock_acct++;
> +	if (batch->size) {
> +		/* Leftover pages in batch from an earlier call. */
> +		*pfn_base = page_to_pfn(batch->pages[batch->offset]);
> +		pfn = *pfn_base;
> +		rsvd = is_invalid_reserved_pfn(*pfn_base);
> +	} else {
> +		*pfn_base = 0;
>  	}
>  
> -	if (unlikely(disable_hugepages))
> -		goto out;
> +	while (npage) {
> +		if (!batch->size) {
> +			/* Empty batch, so refill it. */
> +			long req_pages = min_t(long, npage, batch->capacity);
>  
> -	/* Lock all the consecutive pages from pfn_base */
> -	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
> -	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
> -		ret = vaddr_get_pfns(current->mm, vaddr, 1, dma->prot, &pfn,
> -				     batch->pages);
> -		if (ret < 0)
> -			break;
> +			ret = vaddr_get_pfns(mm, vaddr, req_pages, dma->prot,
> +					     &pfn, batch->pages);
> +			if (ret < 0)
> +				return ret;


This might not be the first batch we fill, I think this needs to unwind
rather than direct return.  Series looks good otherwise.  Thanks,

Alex 


>  
> -		if (pfn != *pfn_base + pinned ||
> -		    rsvd != is_invalid_reserved_pfn(pfn)) {
> -			put_pfn(pfn, dma->prot);
> -			break;
> +			batch->size = ret;
> +			batch->offset = 0;
> +
> +			if (!*pfn_base) {
> +				*pfn_base = pfn;
> +				rsvd = is_invalid_reserved_pfn(*pfn_base);
> +			}
>  		}
>  
> -		if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> -			if (!dma->lock_cap &&
> -			    current->mm->locked_vm + lock_acct + 1 > limit) {
> -				put_pfn(pfn, dma->prot);
> -				pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> -					__func__, limit << PAGE_SHIFT);
> -				ret = -ENOMEM;
> -				goto unpin_out;
> +		/*
> +		 * pfn is preset for the first iteration of this inner loop and
> +		 * updated at the end to handle a VM_PFNMAP pfn.  In that case,
> +		 * batch->pages isn't valid (there's no struct page), so allow
> +		 * batch->pages to be touched only when there's more than one
> +		 * pfn to check, which guarantees the pfns are from a
> +		 * !VM_PFNMAP vma.
> +		 */
> +		while (true) {
> +			if (pfn != *pfn_base + pinned ||
> +			    rsvd != is_invalid_reserved_pfn(pfn))
> +				goto out;
> +
> +			/*
> +			 * Reserved pages aren't counted against the user,
> +			 * externally pinned pages are already counted against
> +			 * the user.
> +			 */
> +			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> +				if (!dma->lock_cap &&
> +				    mm->locked_vm + lock_acct + 1 > limit) {
> +					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> +						__func__, limit << PAGE_SHIFT);
> +					ret = -ENOMEM;
> +					goto unpin_out;
> +				}
> +				lock_acct++;
>  			}
> -			lock_acct++;
> +
> +			pinned++;
> +			npage--;
> +			vaddr += PAGE_SIZE;
> +			iova += PAGE_SIZE;
> +			batch->offset++;
> +			batch->size--;
> +
> +			if (!batch->size)
> +				break;
> +
> +			pfn = page_to_pfn(batch->pages[batch->offset]);
>  		}
> +
> +		if (unlikely(disable_hugepages))
> +			break;
>  	}
>  
>  out:
> @@ -596,6 +635,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  			for (pfn = *pfn_base ; pinned ; pfn++, pinned--)
>  				put_pfn(pfn, dma->prot);
>  		}
> +		vfio_batch_unpin(batch, dma);
>  
>  		return ret;
>  	}
> @@ -1305,6 +1345,7 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  		if (ret) {
>  			vfio_unpin_pages_remote(dma, iova + dma->size, pfn,
>  						npage, true);
> +			vfio_batch_unpin(&batch, dma);
>  			break;
>  		}
>  
> @@ -1546,11 +1587,13 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>  			ret = iommu_map(domain->domain, iova, phys,
>  					size, dma->prot | domain->prot);
>  			if (ret) {
> -				if (!dma->iommu_mapped)
> +				if (!dma->iommu_mapped) {
>  					vfio_unpin_pages_remote(dma, iova,
>  							phys >> PAGE_SHIFT,
>  							size >> PAGE_SHIFT,
>  							true);
> +					vfio_batch_unpin(&batch, dma);
> +				}
>  				goto unwind;
>  			}
>  

