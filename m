Return-Path: <kvm+bounces-47592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90C2FAC25B3
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 16:57:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1D9BA47587
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 14:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F77D297A62;
	Fri, 23 May 2025 14:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YyYHhZkI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6058E296149
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 14:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748012064; cv=none; b=Hy8yB7GzNusy0t7Y32O0Rx/AbG54aF5bcGWHSdYIlbQoRtV6AntRkj/0z+kS4XUO5GVx8Rk3U63xBbFGP8jrIUEtnZF9/jJ5ba7gsMaxPk+KYcEhqNr5wzkKw4Rki3/wtwbjZnRUgOtuFqV6kpNp5TvuntoGiSoa6ZFHn0KxlOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748012064; c=relaxed/simple;
	bh=rFtwkMunMcBHKQZm8B8dG3UJUD52y3dVjuicztqe+HA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iJ3mO5RvCuuobgwRvGUIhztSg7Kku7Vk1RopIaK/NiXSAySTk0Z8xBZHQZZ95gxkRg8qozud6JMhuYzRmTnYwdohiaS0tNNjM0zWv1l7hMvjkrkdGUGgDpJnzjmCbic57nMLQ7X/Q8wDghiiOsP6/c2h0dgT4xujmoR/mgc3YqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YyYHhZkI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748012061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4WNoy5VROWa8mUUKqIWUmhgx92gy7/Y2SXxhoTdbkKI=;
	b=YyYHhZkIuuYesme4EF3O+pnoOvY0BFyiQd2gpQVG8bM+UuB0+N8NxQiNGtUJNF+KARCLAq
	kRiBh1g8+D3Vo+OPlWSvWfE7Eld9iHVr7nt9gMnoN8t8Msng4bs2/dfXs2Ei5iF82A0FYT
	B1KfhYGjYmGpyVN6I6GaKk4VZzQHF5k=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-N0k7J5FlOpCAbwUKPaPhqQ-1; Fri, 23 May 2025 10:54:20 -0400
X-MC-Unique: N0k7J5FlOpCAbwUKPaPhqQ-1
X-Mimecast-MFC-AGG-ID: N0k7J5FlOpCAbwUKPaPhqQ_1748012059
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-8649babc826so160213239f.3
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 07:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748012058; x=1748616858;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4WNoy5VROWa8mUUKqIWUmhgx92gy7/Y2SXxhoTdbkKI=;
        b=UCuksdtfS+50Wbkhd38oPVU3vuPVXqa+qi8ZDSNQZMkghKvX820JYcIeBUTV7xBtLg
         uvL0k6kvy/J2znq8iAEE6ApRPIQJFjn4wJzPH89H8jOA09dmmodpzT23V/XRspjl7W1w
         CvkurNonIrOLnhxE2w6K2OFUwW3t+Yrn4pMR2Mojsfcq4teJoUiFtU3THbm7SKFhl4Vt
         1GhbRiGRccdu9yb8mypZcHkTN0QlgLlxz5HF/ivdQErajNc8yH4J1E09bu6Twe+ZaVWt
         OsmkF2KGuruxxlNFZG7OVc0qoL+Pi3DGfRwi+2uCqo/XTfGQE347y3L2j1O8wqlrhIYm
         Nvdg==
X-Forwarded-Encrypted: i=1; AJvYcCXeZ6Vx640IpL9659guivqxeLLtMhJgSv5YMynKCDE0xcCbt5Z+g7jC/SssAWORP+LrcuQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxXGvTup1jdFk+xZxbty1IDweKVaIBHrJ95b96YUrothSqG+6v
	Px78X1X/wJDoh5YWDompEemvbpZh0Pcz6wasNLV8G4pNkfS28JgOnzJflYL3BJALzPEpSaKJxHf
	oL+i7SDMOayXMn+E1jPhi2NkkOpoTmP/buzCY+e+tx9V/Vtxf9Sr0rvoq4zUnkw==
X-Gm-Gg: ASbGncurVVqpicmu/WZ6+xwgGzrSImo2ryykudjKgvrcUc6UcSUfbZY9uhW4gq6VQaH
	LiLKz0BtD8R4IhJFz/6uXwSBjgnJbYY7hfAaYDT8IG/TOdGuBqOTA5coyAfM0mUr58dtdtztxIj
	opzgQFmDHvsWoWM4rqRKK2zcy4l+WxK7LVnfpOXbf8lkQqvgd0icPMjdWCFK71mkKwGULNPmVpB
	oJCqxDBl+HPEn0aZSlfFjil6MnbFRdluJtF+PcmZRxgHB47QZ2hFa0ziTA4FaGhN0jzjTlb1d2y
	rwCWwmqN8o/pOSI=
X-Received: by 2002:a05:6602:1513:b0:85d:9799:8476 with SMTP id ca18e2360f4ac-86cb05ff861mr84637639f.1.1748012058326;
        Fri, 23 May 2025 07:54:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZ/B9g89+VDvpeHeLYQeDXh5HxGKep5dMwsFYNRNVhpTBlzcImCm9eLa3dV9y0GRvELMb4hA==
X-Received: by 2002:a05:6602:1513:b0:85d:9799:8476 with SMTP id ca18e2360f4ac-86cb05ff861mr84636439f.1.1748012057841;
        Fri, 23 May 2025 07:54:17 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1c9esm3575243173.38.2025.05.23.07.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 07:54:17 -0700 (PDT)
Date: Fri, 23 May 2025 08:54:15 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: david@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev, peterx@redhat.com
Subject: Re: [PATCH v4] vfio/type1: optimize vfio_pin_pages_remote() for
 large folio
Message-ID: <20250523085415.6f316c84.alex.williamson@redhat.com>
In-Reply-To: <20250523034238.35879-1-lizhe.67@bytedance.com>
References: <20250522145207.01734386.alex.williamson@redhat.com>
	<20250523034238.35879-1-lizhe.67@bytedance.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 23 May 2025 11:42:38 +0800
lizhe.67@bytedance.com wrote:

> On Thu, 22 May 2025 14:52:07 -0600, alex.williamson@redhat.com wrote: 
> 
> > On Thu, 22 May 2025 16:25:24 +0800
> > lizhe.67@bytedance.com wrote:
> >   
> > > On Thu, 22 May 2025 09:22:50 +0200, david@redhat.com wrote:
> > >   
> > > >On 22.05.25 05:49, lizhe.67@bytedance.com wrote:    
> > > >> On Wed, 21 May 2025 13:17:11 -0600, alex.williamson@redhat.com wrote:
> > > >>     
> > > >>>> From: Li Zhe <lizhe.67@bytedance.com>
> > > >>>>
> > > >>>> When vfio_pin_pages_remote() is called with a range of addresses that
> > > >>>> includes large folios, the function currently performs individual
> > > >>>> statistics counting operations for each page. This can lead to significant
> > > >>>> performance overheads, especially when dealing with large ranges of pages.
> > > >>>>
> > > >>>> This patch optimize this process by batching the statistics counting
> > > >>>> operations.
> > > >>>>
> > > >>>> The performance test results for completing the 8G VFIO IOMMU DMA mapping,
> > > >>>> obtained through trace-cmd, are as follows. In this case, the 8G virtual
> > > >>>> address space has been mapped to physical memory using hugetlbfs with
> > > >>>> pagesize=2M.
> > > >>>>
> > > >>>> Before this patch:
> > > >>>> funcgraph_entry:      # 33813.703 us |  vfio_pin_map_dma();
> > > >>>>
> > > >>>> After this patch:
> > > >>>> funcgraph_entry:      # 16071.378 us |  vfio_pin_map_dma();
> > > >>>>
> > > >>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > >>>> Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
> > > >>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > >>>> ---    
> > > >>>
> > > >>> Given the discussion on v3, this is currently a Nak.  Follow-up in that
> > > >>> thread if there are further ideas how to salvage this.  Thanks,    
> > > >> 
> > > >> How about considering the solution David mentioned to check whether the
> > > >> pages or PFNs are actually consecutive?
> > > >> 
> > > >> I have conducted a preliminary attempt, and the performance testing
> > > >> revealed that the time consumption is approximately 18,000 microseconds.
> > > >> Compared to the previous 33,000 microseconds, this also represents a
> > > >> significant improvement.
> > > >> 
> > > >> The modification is quite straightforward. The code below reflects the
> > > >> changes I have made based on this patch.
> > > >> 
> > > >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > >> index bd46ed9361fe..1cc1f76d4020 100644
> > > >> --- a/drivers/vfio/vfio_iommu_type1.c
> > > >> +++ b/drivers/vfio/vfio_iommu_type1.c
> > > >> @@ -627,6 +627,19 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
> > > >>          return ret;
> > > >>   }
> > > >>   
> > > >> +static inline long continuous_page_num(struct vfio_batch *batch, long npage)
> > > >> +{
> > > >> +       long i;
> > > >> +       unsigned long next_pfn = page_to_pfn(batch->pages[batch->offset]) + 1;
> > > >> +
> > > >> +       for (i = 1; i < npage; ++i) {
> > > >> +               if (page_to_pfn(batch->pages[batch->offset + i]) != next_pfn)
> > > >> +                       break;
> > > >> +               next_pfn++;
> > > >> +       }
> > > >> +       return i;
> > > >> +}    
> > > >
> > > >
> > > >What might be faster is obtaining the folio, and then calculating the 
> > > >next expected page pointer, comparing whether the page pointers match.
> > > >
> > > >Essentially, using folio_page() to calculate the expected next page.
> > > >
> > > >nth_page() is a simple pointer arithmetic with CONFIG_SPARSEMEM_VMEMMAP, 
> > > >so that might be rather fast.
> > > >
> > > >
> > > >So we'd obtain
> > > >
> > > >start_idx = folio_idx(folio, batch->pages[batch->offset]);    
> > > 
> > > Do you mean using folio_page_idx()?
> > >   
> > > >and then check for
> > > >
> > > >batch->pages[batch->offset + i] == folio_page(folio, start_idx + i)    
> > > 
> > > Thank you for your reminder. This is indeed a better solution.
> > > The updated code might look like this:
> > > 
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > index bd46ed9361fe..f9a11b1d8433 100644
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -627,6 +627,20 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
> > >         return ret;
> > >  }
> > >  
> > > +static inline long continuous_pages_num(struct folio *folio,
> > > +               struct vfio_batch *batch, long npage)  
> > 
> > Note this becomes long enough that we should just let the compiler
> > decide whether to inline or not.  
> 
> Thank you! The 'inline' here indeed needs to be removed.
> 
> > > +{
> > > +       long i;
> > > +       unsigned long start_idx =
> > > +                       folio_page_idx(folio, batch->pages[batch->offset]);
> > > +
> > > +       for (i = 1; i < npage; ++i)
> > > +               if (batch->pages[batch->offset + i] !=
> > > +                               folio_page(folio, start_idx + i))
> > > +                       break;
> > > +       return i;
> > > +}
> > > +
> > >  /*
> > >   * Attempt to pin pages.  We really don't want to track all the pfns and
> > >   * the iommu can only map chunks of consecutive pfns anyway, so get the
> > > @@ -708,8 +722,12 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> > >                          */
> > >                         nr_pages = min_t(long, batch->size, folio_nr_pages(folio) -
> > >                                                 folio_page_idx(folio, batch->pages[batch->offset]));
> > > -                       if (nr_pages > 1 && vfio_find_vpfn_range(dma, iova, nr_pages))
> > > -                               nr_pages = 1;
> > > +                       if (nr_pages > 1) {
> > > +                               if (vfio_find_vpfn_range(dma, iova, nr_pages))
> > > +                                       nr_pages = 1;
> > > +                               else
> > > +                                       nr_pages = continuous_pages_num(folio, batch, nr_pages);
> > > +                       }  
> > 
> > 
> > I think we can refactor this a bit better and maybe if we're going to
> > the trouble of comparing pages we can be a bit more resilient to pages
> > already accounted as vpfns.  I took a shot at it, compile tested only,
> > is there still a worthwhile gain?
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 0ac56072af9f..e8bba32148f7 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -319,7 +319,13 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
> >  /*
> >   * Helper Functions for host iova-pfn list
> >   */
> > -static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> > +
> > +/*
> > + * Find the first vfio_pfn that overlapping the range
> > + * [iova_start, iova_end) in rb tree.
> > + */
> > +static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> > +		dma_addr_t iova_start, dma_addr_t iova_end)
> >  {
> >  	struct vfio_pfn *vpfn;
> >  	struct rb_node *node = dma->pfn_list.rb_node;
> > @@ -327,9 +333,9 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> >  	while (node) {
> >  		vpfn = rb_entry(node, struct vfio_pfn, node);
> >  
> > -		if (iova < vpfn->iova)
> > +		if (iova_end <= vpfn->iova)
> >  			node = node->rb_left;
> > -		else if (iova > vpfn->iova)
> > +		else if (iova_start > vpfn->iova)
> >  			node = node->rb_right;
> >  		else
> >  			return vpfn;
> > @@ -337,6 +343,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> >  	return NULL;
> >  }
> >  
> > +static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> > +{
> > +	return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
> > +}
> > +
> >  static void vfio_link_pfn(struct vfio_dma *dma,
> >  			  struct vfio_pfn *new)
> >  {
> > @@ -615,6 +626,43 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
> >  	return ret;
> >  }
> >  
> > +static long contig_pages(struct vfio_dma *dma,
> > +			 struct vfio_batch *batch, dma_addr_t iova)
> > +{
> > +	struct page *page = batch->pages[batch->offset];
> > +	struct folio *folio = page_folio(page);
> > +	long idx = folio_page_idx(folio, page);
> > +	long max = min_t(long, batch->size, folio_nr_pages(folio) - idx);
> > +	long nr_pages;
> > +
> > +	for (nr_pages = 1; nr_pages < max; nr_pages++) {
> > +		if (batch->pages[batch->offset + nr_pages] !=
> > +		    folio_page(folio, idx + nr_pages))
> > +			break;
> > +	}
> > +
> > +	return nr_pages;
> > +}
> > +
> > +static long vpfn_pages(struct vfio_dma *dma,
> > +		       dma_addr_t iova_start, long nr_pages)
> > +{
> > +	dma_addr_t iova_end = iova_start + (nr_pages << PAGE_SHIFT);
> > +	struct vfio_pfn *vpfn;
> > +	long count = 0;
> > +
> > +	do {
> > +		vpfn = vfio_find_vpfn_range(dma, iova_start, iova_end);  
> 
> I am somehow confused here. Function vfio_find_vpfn_range()is designed
> to find, through the rbtree, the node that is closest to the root node
> and satisfies the condition within the range [iova_start, iova_end),
> rather than the node closest to iova_start? Or perhaps I have
> misunderstood something?

Sorry, that's an oversight on my part.  We might forego the _range
version and just do an inline walk of the tree counting the number of
already accounted pfns within the range.  Thanks,

Alex

> > +		if (likely(!vpfn))
> > +			break;
> > +
> > +		count++;
> > +		iova_start = vpfn->iova + PAGE_SIZE;
> > +	} while (iova_start < iova_end);
> > +
> > +	return count;
> > +}
> > +
> >  /*
> >   * Attempt to pin pages.  We really don't want to track all the pfns and
> >   * the iommu can only map chunks of consecutive pfns anyway, so get the
> > @@ -681,32 +729,40 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> >  		 * and rsvd here, and therefore continues to use the batch.
> >  		 */
> >  		while (true) {
> > +			long nr_pages, acct_pages = 0;
> > +
> >  			if (pfn != *pfn_base + pinned ||
> >  			    rsvd != is_invalid_reserved_pfn(pfn))
> >  				goto out;
> >  
> > +			nr_pages = contig_pages(dma, batch, iova);
> > +			if (!rsvd) {
> > +				acct_pages = nr_pages;
> > +				acct_pages -= vpfn_pages(dma, iova, nr_pages);
> > +			}
> > +
> >  			/*
> >  			 * Reserved pages aren't counted against the user,
> >  			 * externally pinned pages are already counted against
> >  			 * the user.
> >  			 */
> > -			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> > +			if (acct_pages) {
> >  				if (!dma->lock_cap &&
> > -				    mm->locked_vm + lock_acct + 1 > limit) {
> > +				    mm->locked_vm + lock_acct + acct_pages > limit) {
> >  					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> >  						__func__, limit << PAGE_SHIFT);
> >  					ret = -ENOMEM;
> >  					goto unpin_out;
> >  				}
> > -				lock_acct++;
> > +				lock_acct += acct_pages;
> >  			}
> >  
> > -			pinned++;
> > -			npage--;
> > -			vaddr += PAGE_SIZE;
> > -			iova += PAGE_SIZE;
> > -			batch->offset++;
> > -			batch->size--;
> > +			pinned += nr_pages;
> > +			npage -= nr_pages;
> > +			vaddr += PAGE_SIZE * nr_pages;
> > +			iova += PAGE_SIZE * nr_pages;
> > +			batch->offset += nr_pages;
> > +			batch->size -= nr_pages;
> >  
> >  			if (!batch->size)
> >  				break;  
> 
> Thanks,
> Zhe
> 


