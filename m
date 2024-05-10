Return-Path: <kvm+bounces-17199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE2548C28FC
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 18:57:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED8781C22137
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 16:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 481E317BA3;
	Fri, 10 May 2024 16:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bhL5awIf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D62415AC4
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715360265; cv=none; b=o6Qg/ezlfBv/zjcAhjFO0KaersIhch4QGY7QtGfiIqrumdSAlqKDrNbrgNMdg2pb8C6bcJ55i5MJyXYi5j0S3sApyfS1kiVODuTcdhynyoZ31jGXcQ3AbYVXWrXBNECvj00qRkgQ6WEP8T99eyAb5iy/YNsCx6KSFs0SaOwjB+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715360265; c=relaxed/simple;
	bh=hwePChklJEl36IhwVADIHL8Cj67wO7qs0V1bQB+udz8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c9wf6WuwcJKmE/ah7aVF8dnw9AW5XHmltOvEqUFOeuvFGjM769XJFjP78Pufjf+ZnSow4OBSorTIcmOM+iy0gtx/j7jfp7USiVIdMo9GvfxSMW/q0w+F8ulJXda1pgO/zvyYLy6Yy60hhslZzJXsfiTDV+bJNboSHmjHOJfUfeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bhL5awIf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715360260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fVKx385pzhtCTZ1An9PUMKGEfU4EWzsKCOtQMS5AmwM=;
	b=bhL5awIfD8Ctv+x+xJ8vDnb7Q3wbqc8OYUsnqKqjQKa4hCiQYIpwbKATX9iCD7hDG3TiQh
	2NtxhCfvwib3Ydu/arqCEQSXQo8GNDe/Omnk++QSYYYZLhKMgaV8htOzftSWtSJ/fpAKnj
	wSryNwdGznOkgU/MEhuX8L177dlFPw4=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-47cJYQucONW032pAfqmMEw-1; Fri, 10 May 2024 12:57:34 -0400
X-MC-Unique: 47cJYQucONW032pAfqmMEw-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7ddf08e17e4so167376939f.0
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 09:57:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715360253; x=1715965053;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fVKx385pzhtCTZ1An9PUMKGEfU4EWzsKCOtQMS5AmwM=;
        b=cKCm5CxP2l+ekVUrZuI4ZclIgU32gEsKWO7OxBXJvnDXBSvaEqxHJ5MJCbClrIWtAu
         LUk6FC80lmJHgv1f1Q3v+/Oum8i+XnPYk52htAdYor8CNkMiBg8HQ8sUUHiDOc9BEh/S
         oahq3GwkIhnqGdxzXNenCSG+uIeRkJtCFY7i5yMxIrw6Y+TlbFz8Azgaa+/Ekj0vQSUA
         Db9Ynin6gX0S02c+gOTRYDwkQpkCGj13FqAK3FXbu8vfAXFaEHNyS+pdQJ9MxLCBQHbA
         rYTOZql6DWPrafzFLDU4nP2Rde9Bj+GGDihJNgQMLDii3wEjTsFWXPZ3GOp8MU8X+i/c
         Uvdg==
X-Gm-Message-State: AOJu0YxH85Q2wUnBBNS/+foxekyyxhk0gnLdQm/Si1o0ykprXhEc3ypa
	LG1G0X4z2v5A6FoZp3n0cKk10vxHwz8CGT9bU4/qN0WVei5N2TVoJHyYBqM0YL090FmxdIRTvgJ
	KNHyt3c5nwu9zb0nC2CZnK0ab+5Yz5VX413BFoNotiXYQMQEA9A==
X-Received: by 2002:a6b:d90d:0:b0:7e1:c17d:d3c0 with SMTP id ca18e2360f4ac-7e1c17dd436mr89013939f.8.1715360253147;
        Fri, 10 May 2024 09:57:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGMon+t3cyHeP+eOa5osZa69R66FFmhi5XyHknEh0/6queVz7q5jBAl/wrhAprTc/1U4wxEw==
X-Received: by 2002:a6b:d90d:0:b0:7e1:c17d:d3c0 with SMTP id ca18e2360f4ac-7e1c17dd436mr89011239f.8.1715360252730;
        Fri, 10 May 2024 09:57:32 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e1ba9bf8c7sm36315439f.20.2024.05.10.09.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 09:57:32 -0700 (PDT)
Date: Fri, 10 May 2024 10:57:28 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
 <jgg@nvidia.com>, <kevin.tian@intel.com>, <iommu@lists.linux.dev>,
 <pbonzini@redhat.com>, <seanjc@google.com>, <dave.hansen@linux.intel.com>,
 <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
 <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>, <corbet@lwn.net>,
 <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
 <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240510105728.76d97bbb.alex.williamson@redhat.com>
In-Reply-To: <Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
	<20240507062138.20465-1-yan.y.zhao@intel.com>
	<20240509121049.58238a6f.alex.williamson@redhat.com>
	<Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 May 2024 18:31:13 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Thu, May 09, 2024 at 12:10:49PM -0600, Alex Williamson wrote:
> > On Tue,  7 May 2024 14:21:38 +0800
> > Yan Zhao <yan.y.zhao@intel.com> wrote:  
> ... 
> > >  drivers/vfio/vfio_iommu_type1.c | 51 +++++++++++++++++++++++++++++++++
> > >  1 file changed, 51 insertions(+)
> > > 
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > index b5c15fe8f9fc..ce873f4220bf 100644
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -74,6 +74,7 @@ struct vfio_iommu {
> > >  	bool			v2;
> > >  	bool			nesting;
> > >  	bool			dirty_page_tracking;
> > > +	bool			has_noncoherent_domain;
> > >  	struct list_head	emulated_iommu_groups;
> > >  };
> > >  
> > > @@ -99,6 +100,7 @@ struct vfio_dma {
> > >  	unsigned long		*bitmap;
> > >  	struct mm_struct	*mm;
> > >  	size_t			locked_vm;
> > > +	bool			cache_flush_required; /* For noncoherent domain */  
> > 
> > Poor packing, minimally this should be grouped with the other bools in
> > the structure, longer term they should likely all be converted to
> > bit fields.  
> Yes. Will do!
> 
> >   
> > >  };
> > >  
> > >  struct vfio_batch {
> > > @@ -716,6 +718,9 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
> > >  	long unlocked = 0, locked = 0;
> > >  	long i;
> > >  
> > > +	if (dma->cache_flush_required)
> > > +		arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT, npage << PAGE_SHIFT);
> > > +
> > >  	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
> > >  		if (put_pfn(pfn++, dma->prot)) {
> > >  			unlocked++;
> > > @@ -1099,6 +1104,8 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
> > >  					    &iotlb_gather);
> > >  	}
> > >  
> > > +	dma->cache_flush_required = false;
> > > +
> > >  	if (do_accounting) {
> > >  		vfio_lock_acct(dma, -unlocked, true);
> > >  		return 0;
> > > @@ -1120,6 +1127,21 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
> > >  	iommu->dma_avail++;
> > >  }
> > >  
> > > +static void vfio_update_noncoherent_domain_state(struct vfio_iommu *iommu)
> > > +{
> > > +	struct vfio_domain *domain;
> > > +	bool has_noncoherent = false;
> > > +
> > > +	list_for_each_entry(domain, &iommu->domain_list, next) {
> > > +		if (domain->enforce_cache_coherency)
> > > +			continue;
> > > +
> > > +		has_noncoherent = true;
> > > +		break;
> > > +	}
> > > +	iommu->has_noncoherent_domain = has_noncoherent;
> > > +}  
> > 
> > This should be merged with vfio_domains_have_enforce_cache_coherency()
> > and the VFIO_DMA_CC_IOMMU extension (if we keep it, see below).  
> Will convert it to a counter and do the merge.
> Thanks for pointing it out!
> 
> >   
> > > +
> > >  static void vfio_update_pgsize_bitmap(struct vfio_iommu *iommu)
> > >  {
> > >  	struct vfio_domain *domain;
> > > @@ -1455,6 +1477,12 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
> > >  
> > >  	vfio_batch_init(&batch);
> > >  
> > > +	/*
> > > +	 * Record necessity to flush CPU cache to make sure CPU cache is flushed
> > > +	 * for both pin & map and unmap & unpin (for unwind) paths.
> > > +	 */
> > > +	dma->cache_flush_required = iommu->has_noncoherent_domain;
> > > +
> > >  	while (size) {
> > >  		/* Pin a contiguous chunk of memory */
> > >  		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
> > > @@ -1466,6 +1494,10 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
> > >  			break;
> > >  		}
> > >  
> > > +		if (dma->cache_flush_required)
> > > +			arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT,
> > > +						npage << PAGE_SHIFT);
> > > +
> > >  		/* Map it! */
> > >  		ret = vfio_iommu_map(iommu, iova + dma->size, pfn, npage,
> > >  				     dma->prot);
> > > @@ -1683,9 +1715,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> > >  	for (; n; n = rb_next(n)) {
> > >  		struct vfio_dma *dma;
> > >  		dma_addr_t iova;
> > > +		bool cache_flush_required;
> > >  
> > >  		dma = rb_entry(n, struct vfio_dma, node);
> > >  		iova = dma->iova;
> > > +		cache_flush_required = !domain->enforce_cache_coherency &&
> > > +				       !dma->cache_flush_required;
> > > +		if (cache_flush_required)
> > > +			dma->cache_flush_required = true;  
> > 
> > The variable name here isn't accurate and the logic is confusing.  If
> > the domain does not enforce coherency and the mapping is not tagged as
> > requiring a cache flush, then we need to mark the mapping as requiring
> > a cache flush.  So the variable state is something more akin to
> > set_cache_flush_required.  But all we're saving with this is a
> > redundant set if the mapping is already tagged as requiring a cache
> > flush, so it could really be simplified to:
> > 
> > 		dma->cache_flush_required = !domain->enforce_cache_coherency;  
> Sorry about the confusion.
> 
> If dma->cache_flush_required is set to true by a domain not enforcing cache
> coherency, we hope it will not be reset to false by a later attaching to domain 
> enforcing cache coherency due to the lazily flushing design.

Right, ok, the vfio_dma objects are shared between domains so we never
want to set 'dma->cache_flush_required = false' due to the addition of a
'domain->enforce_cache_coherent == true'.  So this could be:

	if (!dma->cache_flush_required)
		dma->cache_flush_required = !domain->enforce_cache_coherency;

> > It might add more clarity to just name the mapping flag
> > dma->mapped_noncoherent.  
> 
> The dma->cache_flush_required is to mark whether pages in a vfio_dma requires
> cache flush in the subsequence mapping into the first non-coherent domain
> and page unpinning.

How do we arrive at a sequence where we have dma->cache_flush_required
that isn't the result of being mapped into a domain with
!domain->enforce_cache_coherency?

It seems to me that we only get 'dma->cache_flush_required == true' as
a result of being mapped into a 'domain->enforce_cache_coherency ==
false' domain.  In that case the flush-on-map is handled at the time
we're setting dma->cache_flush_required and what we're actually
tracking with the flag is that the dma object has been mapped into a
noncoherent domain.

> So, mapped_noncoherent may not be accurate.
> Do you think it's better to put a comment for explanation? 
> 
> struct vfio_dma {
>         ...    
>         bool                    iommu_mapped;
>         bool                    lock_cap;       /* capable(CAP_IPC_LOCK) */
>         bool                    vaddr_invalid;
>         /*
>          *  Mark whether it is required to flush CPU caches when mapping pages
>          *  of the vfio_dma to the first non-coherent domain and when unpinning
>          *  pages of the vfio_dma
>          */
>         bool                    cache_flush_required;
>         ...    
> };
> >   
> > >  
> > >  		while (iova < dma->iova + dma->size) {
> > >  			phys_addr_t phys;
> > > @@ -1737,6 +1774,9 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> > >  				size = npage << PAGE_SHIFT;
> > >  			}
> > >  
> > > +			if (cache_flush_required)
> > > +				arch_clean_nonsnoop_dma(phys, size);
> > > +  
> > 
> > I agree with others as well that this arch callback should be named
> > something relative to the cache-flush/write-back operation that it
> > actually performs instead of the overall reason for us requiring it.
> >  
> Ok. If there are no objections, I'll rename it to arch_flush_cache_phys() as
> suggested by Kevin.

Yes, better.

> > >  			ret = iommu_map(domain->domain, iova, phys, size,
> > >  					dma->prot | IOMMU_CACHE,
> > >  					GFP_KERNEL_ACCOUNT);
> > > @@ -1801,6 +1841,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> > >  			vfio_unpin_pages_remote(dma, iova, phys >> PAGE_SHIFT,
> > >  						size >> PAGE_SHIFT, true);
> > >  		}
> > > +		dma->cache_flush_required = false;
> > >  	}
> > >  
> > >  	vfio_batch_fini(&batch);
> > > @@ -1828,6 +1869,9 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *
> > >  	if (!pages)
> > >  		return;
> > >  
> > > +	if (!domain->enforce_cache_coherency)
> > > +		arch_clean_nonsnoop_dma(page_to_phys(pages), PAGE_SIZE * 2);
> > > +
> > >  	list_for_each_entry(region, regions, list) {
> > >  		start = ALIGN(region->start, PAGE_SIZE * 2);
> > >  		if (start >= region->end || (region->end - start < PAGE_SIZE * 2))
> > > @@ -1847,6 +1891,9 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *
> > >  		break;
> > >  	}
> > >  
> > > +	if (!domain->enforce_cache_coherency)
> > > +		arch_clean_nonsnoop_dma(page_to_phys(pages), PAGE_SIZE * 2);
> > > +  
> > 
> > Seems like this use case isn't subject to the unmap aspect since these
> > are kernel allocated and freed pages rather than userspace pages.
> > There's not an "ongoing use of the page" concern.
> > 
> > The window of opportunity for a device to discover and exploit the
> > mapping side issue appears almost impossibly small.
> >  
> The concern is for a malicious device attempting DMAs automatically.
> Do you think this concern is valid?
> As there're only extra flushes for 4 pages, what about keeping it for safety?

Userspace doesn't know anything about these mappings, so to exploit
them the device would somehow need to discover and interact with the
mapping in the split second that the mapping exists, without exposing
itself with mapping faults at the IOMMU.

I don't mind keeping the flush before map so that infinitesimal gap
where previous data in physical memory exposed to the device is closed,
but I have a much harder time seeing that the flush on unmap to
synchronize physical memory is required.

For example, the potential KSM use case doesn't exist since the pages
are not owned by the user.  Any subsequent use of the pages would be
subject to the same condition we assumed after allocation, where the
physical data may be inconsistent with the cached data.  It's easy to
flush 2 pages, but I think it obscures the function of the flush if we
can't articulate the value in this case.


> > >  	__free_pages(pages, order);
> > >  }
> > >  
> > > @@ -2308,6 +2355,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> > >  
> > >  	list_add(&domain->next, &iommu->domain_list);
> > >  	vfio_update_pgsize_bitmap(iommu);
> > > +	if (!domain->enforce_cache_coherency)
> > > +		vfio_update_noncoherent_domain_state(iommu);  
> > 
> > Why isn't this simply:
> > 
> > 	if (!domain->enforce_cache_coherency)
> > 		iommu->has_noncoherent_domain = true;  
> Yes, it's simpler during attach.
> 
> > Or maybe:
> > 
> > 	if (!domain->enforce_cache_coherency)
> > 		iommu->noncoherent_domains++;  
> Yes, this counter is better.
> I previously thought a bool can save some space.
> 
> > >  done:
> > >  	/* Delete the old one and insert new iova list */
> > >  	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
> > > @@ -2508,6 +2557,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
> > >  			}
> > >  			iommu_domain_free(domain->domain);
> > >  			list_del(&domain->next);
> > > +			if (!domain->enforce_cache_coherency)
> > > +				vfio_update_noncoherent_domain_state(iommu);  
> > 
> > If we were to just track the number of noncoherent domains, this could
> > simply be iommu->noncoherent_domains-- and VFIO_DMA_CC_DMA could be:
> > 
> > 	return iommu->noncoherent_domains ? 1 : 0;
> > 
> > Maybe there should be wrappers for list_add() and list_del() relative
> > to the iommu domain list to make it just be a counter.  Thanks,  
> 
> Do you think we can skip the "iommu->noncoherent_domains--" in
> vfio_iommu_type1_release() when iommu is about to be freed.
> 
> Asking that is also because it's hard for me to find a good name for the wrapper
> around list_del().  :)

vfio_iommu_link_domain(), vfio_iommu_unlink_domain()?

> 
> It follows vfio_release_domain() in vfio_iommu_type1_release(), but not in
> vfio_iommu_type1_detach_group().

I'm not sure I understand the concern here, detach_group is performed
under the iommu->lock where the value of iommu->noncohernet_domains is
only guaranteed while this lock is held.  In the release callback the
iommu->lock is not held, but we have no external users at this point.
It's not strictly required that we decrement each domain, but it's also
not a bad sanity test that iommu->noncoherent_domains should be zero
after unlinking the domains.  Thanks,

Alex
 
> > >  			kfree(domain);
> > >  			vfio_iommu_aper_expand(iommu,
> > > &iova_copy); vfio_update_pgsize_bitmap(iommu);  
> >   
> 


