Return-Path: <kvm+bounces-17555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F1A78C7DD7
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 22:50:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 867D4B21DD0
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 20:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6036E1581E9;
	Thu, 16 May 2024 20:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c2/z5HvE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28EA15CB
	for <kvm@vger.kernel.org>; Thu, 16 May 2024 20:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715892616; cv=none; b=OQ27/C8cYFh2cJfdUkOOJsSJ9pcPNU1CWexn/RlkNMhEd4LdKg9KKokaT2gjmFv/CxUWQwg47udH9ISrs43+NZpzuCm2rluFG3mNHupmwvGezu0FUzea77PjkXJUD9IM3RtustCSIq1mokX2BFhvLqwAA8j7V0Ts2DC09QcBOu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715892616; c=relaxed/simple;
	bh=jlXZv3qP8SJGyzwaITAAmc594iMe2iOqE24weI7m6oo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DfeKSzwIy8xztyXnkP2FpjB6koue6d1Pb319XUV/N2VnyZsRVipEKf6M2hHCzs5AGrSn0KVuIzFYSECQIEliafVZ81OIC4ziUvGf6L1yLmYLLrnVFL8GxTCb1kTibm7iuQfSpGxWjfZxe1LWGbhQ7RVct9B0FUkTelyB2kdbgQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c2/z5HvE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715892613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DgfeXMkmseJgwm40V0OoBOyXRqsK7UUQX8yHhq3rw+s=;
	b=c2/z5HvERQZnQZps5Vz6yRG8EvYw9f6cff4bjHJGGFR8mRTKD8il7IG369cGhbV62IBv1p
	ylDPtBQ58hFnLQuJPZRc0UK89Tv1SNxCFrnkipfmpDtZt5JQ0u1I6DW+dMofAHfW0d0ALj
	Aikk0CJQA8obV76gnhVodiaAlrv6CKA=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-48-QmlTp6gwN6CQn6xZfsAa2A-1; Thu, 16 May 2024 16:50:12 -0400
X-MC-Unique: QmlTp6gwN6CQn6xZfsAa2A-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7e1b97c1b19so823459739f.3
        for <kvm@vger.kernel.org>; Thu, 16 May 2024 13:50:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715892611; x=1716497411;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DgfeXMkmseJgwm40V0OoBOyXRqsK7UUQX8yHhq3rw+s=;
        b=Sc1Ws20zHsYa1lkw6sXaCgJakpJCf6l0yZP1XJlzAUsEnunpVQ0N9NnzkfFsCtRylC
         /79I9syBWNJy0hR5Bf5MSKjJMIFo+IhwGzJn4Jl7uPK2xTyzUdrDTfBZiV8drF0Y38nQ
         4HrfzLC0RiwZvFA7RfRL4ZWzr1ykpfCS1d2F8YOjemyQwXg3bAOMxKkApURm0vVJzuCd
         qPRLV7XGmmB6GgccZ/5oHRRAutY1Wvzz7vgEfugHAUg7g7ZrngiVPOlx/NvuG6qsGnVp
         ZdubWTw/VYXFAxlUTDCGrkOVohPluuXYIDQ12Cjt7CQ/BuQ2CRsPRCvr9qQzlGvYKpKj
         8s3Q==
X-Gm-Message-State: AOJu0YyvVV1Ut07Q5Nr84SL94r/7xMf0XjjBtliNmzdicUW0bTuOLuwe
	fPJo5CuOkrlZRe2Y0Uxwk+HfuToQkCiCun4t3U73D0vxK3Lqwenkqqge6P1C8oT0jKynf50g0pj
	M9X6U4H+7tAfz2i1wkwwfJK2cjQQTebuEYeD8AIunCSHBKi/tEg==
X-Received: by 2002:a05:6602:1d53:b0:7e2:181:a054 with SMTP id ca18e2360f4ac-7e20181a1abmr821471939f.5.1715892611559;
        Thu, 16 May 2024 13:50:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwRkXStIyZ5cr/BlvlET+DTEZcFSPsEWkGox9hOLQu2DM9ciDgxpqD5jYjyjYUSdbcJwJc+g==
X-Received: by 2002:a05:6602:1d53:b0:7e2:181:a054 with SMTP id ca18e2360f4ac-7e20181a1abmr821469839f.5.1715892611202;
        Thu, 16 May 2024 13:50:11 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e1d2a5a276sm285683339f.17.2024.05.16.13.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 May 2024 13:50:10 -0700 (PDT)
Date: Thu, 16 May 2024 14:50:09 -0600
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
Message-ID: <20240516145009.3bcd3d0c.alex.williamson@redhat.com>
In-Reply-To: <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
	<20240507062138.20465-1-yan.y.zhao@intel.com>
	<20240509121049.58238a6f.alex.williamson@redhat.com>
	<Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
	<20240510105728.76d97bbb.alex.williamson@redhat.com>
	<ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 13 May 2024 15:11:28 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Fri, May 10, 2024 at 10:57:28AM -0600, Alex Williamson wrote:
> > On Fri, 10 May 2024 18:31:13 +0800
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > On Thu, May 09, 2024 at 12:10:49PM -0600, Alex Williamson wrote:  
> > > > On Tue,  7 May 2024 14:21:38 +0800
> > > > Yan Zhao <yan.y.zhao@intel.com> wrote:    
> > > ...   
> > > > >  drivers/vfio/vfio_iommu_type1.c | 51 +++++++++++++++++++++++++++++++++
> > > > >  1 file changed, 51 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > > > index b5c15fe8f9fc..ce873f4220bf 100644
> > > > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > > @@ -74,6 +74,7 @@ struct vfio_iommu {
> > > > >  	bool			v2;
> > > > >  	bool			nesting;
> > > > >  	bool			dirty_page_tracking;
> > > > > +	bool			has_noncoherent_domain;
> > > > >  	struct list_head	emulated_iommu_groups;
> > > > >  };
> > > > >  
> > > > > @@ -99,6 +100,7 @@ struct vfio_dma {
> > > > >  	unsigned long		*bitmap;
> > > > >  	struct mm_struct	*mm;
> > > > >  	size_t			locked_vm;
> > > > > +	bool			cache_flush_required; /* For noncoherent domain */    
> > > > 
> > > > Poor packing, minimally this should be grouped with the other bools in
> > > > the structure, longer term they should likely all be converted to
> > > > bit fields.    
> > > Yes. Will do!
> > >   
> > > >     
> > > > >  };
> > > > >  
> > > > >  struct vfio_batch {
> > > > > @@ -716,6 +718,9 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
> > > > >  	long unlocked = 0, locked = 0;
> > > > >  	long i;
> > > > >  
> > > > > +	if (dma->cache_flush_required)
> > > > > +		arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT, npage << PAGE_SHIFT);
> > > > > +
> > > > >  	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
> > > > >  		if (put_pfn(pfn++, dma->prot)) {
> > > > >  			unlocked++;
> > > > > @@ -1099,6 +1104,8 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
> > > > >  					    &iotlb_gather);
> > > > >  	}
> > > > >  
> > > > > +	dma->cache_flush_required = false;
> > > > > +
> > > > >  	if (do_accounting) {
> > > > >  		vfio_lock_acct(dma, -unlocked, true);
> > > > >  		return 0;
> > > > > @@ -1120,6 +1127,21 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
> > > > >  	iommu->dma_avail++;
> > > > >  }
> > > > >  
> > > > > +static void vfio_update_noncoherent_domain_state(struct vfio_iommu *iommu)
> > > > > +{
> > > > > +	struct vfio_domain *domain;
> > > > > +	bool has_noncoherent = false;
> > > > > +
> > > > > +	list_for_each_entry(domain, &iommu->domain_list, next) {
> > > > > +		if (domain->enforce_cache_coherency)
> > > > > +			continue;
> > > > > +
> > > > > +		has_noncoherent = true;
> > > > > +		break;
> > > > > +	}
> > > > > +	iommu->has_noncoherent_domain = has_noncoherent;
> > > > > +}    
> > > > 
> > > > This should be merged with vfio_domains_have_enforce_cache_coherency()
> > > > and the VFIO_DMA_CC_IOMMU extension (if we keep it, see below).    
> > > Will convert it to a counter and do the merge.
> > > Thanks for pointing it out!
> > >   
> > > >     
> > > > > +
> > > > >  static void vfio_update_pgsize_bitmap(struct vfio_iommu *iommu)
> > > > >  {
> > > > >  	struct vfio_domain *domain;
> > > > > @@ -1455,6 +1477,12 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
> > > > >  
> > > > >  	vfio_batch_init(&batch);
> > > > >  
> > > > > +	/*
> > > > > +	 * Record necessity to flush CPU cache to make sure CPU cache is flushed
> > > > > +	 * for both pin & map and unmap & unpin (for unwind) paths.
> > > > > +	 */
> > > > > +	dma->cache_flush_required = iommu->has_noncoherent_domain;
> > > > > +
> > > > >  	while (size) {
> > > > >  		/* Pin a contiguous chunk of memory */
> > > > >  		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
> > > > > @@ -1466,6 +1494,10 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
> > > > >  			break;
> > > > >  		}
> > > > >  
> > > > > +		if (dma->cache_flush_required)
> > > > > +			arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT,
> > > > > +						npage << PAGE_SHIFT);
> > > > > +
> > > > >  		/* Map it! */
> > > > >  		ret = vfio_iommu_map(iommu, iova + dma->size, pfn, npage,
> > > > >  				     dma->prot);
> > > > > @@ -1683,9 +1715,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> > > > >  	for (; n; n = rb_next(n)) {
> > > > >  		struct vfio_dma *dma;
> > > > >  		dma_addr_t iova;
> > > > > +		bool cache_flush_required;
> > > > >  
> > > > >  		dma = rb_entry(n, struct vfio_dma, node);
> > > > >  		iova = dma->iova;
> > > > > +		cache_flush_required = !domain->enforce_cache_coherency &&
> > > > > +				       !dma->cache_flush_required;
> > > > > +		if (cache_flush_required)
> > > > > +			dma->cache_flush_required = true;    
> > > > 
> > > > The variable name here isn't accurate and the logic is confusing.  If
> > > > the domain does not enforce coherency and the mapping is not tagged as
> > > > requiring a cache flush, then we need to mark the mapping as requiring
> > > > a cache flush.  So the variable state is something more akin to
> > > > set_cache_flush_required.  But all we're saving with this is a
> > > > redundant set if the mapping is already tagged as requiring a cache
> > > > flush, so it could really be simplified to:
> > > > 
> > > > 		dma->cache_flush_required = !domain->enforce_cache_coherency;    
> > > Sorry about the confusion.
> > > 
> > > If dma->cache_flush_required is set to true by a domain not enforcing cache
> > > coherency, we hope it will not be reset to false by a later attaching to domain 
> > > enforcing cache coherency due to the lazily flushing design.  
> > 
> > Right, ok, the vfio_dma objects are shared between domains so we never
> > want to set 'dma->cache_flush_required = false' due to the addition of a
> > 'domain->enforce_cache_coherent == true'.  So this could be:
> > 
> > 	if (!dma->cache_flush_required)
> > 		dma->cache_flush_required = !domain->enforce_cache_coherency;  
> 
> Though this code is easier for understanding, it leads to unnecessary setting of
> dma->cache_flush_required to false, given domain->enforce_cache_coherency is
> true at the most time.

I don't really see that as an issue, but the variable name originally
chosen above, cache_flush_required, also doesn't convey that it's only
attempting to set the value if it wasn't previously set and is now
required by a noncoherent domain.

> > > > It might add more clarity to just name the mapping flag
> > > > dma->mapped_noncoherent.    
> > > 
> > > The dma->cache_flush_required is to mark whether pages in a vfio_dma requires
> > > cache flush in the subsequence mapping into the first non-coherent domain
> > > and page unpinning.  
> > 
> > How do we arrive at a sequence where we have dma->cache_flush_required
> > that isn't the result of being mapped into a domain with
> > !domain->enforce_cache_coherency?  
> Hmm, dma->cache_flush_required IS the result of being mapped into a domain with
> !domain->enforce_cache_coherency.
> My concern only arrives from the actual code sequence, i.e.
> dma->cache_flush_required is set to true before the actual mapping.
> 
> If we rename it to dma->mapped_noncoherent and only set it to true after the
> actual successful mapping, it would lead to more code to handle flushing for the
> unwind case.
> Currently, flush for unwind is handled centrally in vfio_unpin_pages_remote()
> by checking dma->cache_flush_required, which is true even before a full
> successful mapping, so we won't miss flush on any pages that are mapped into a
> non-coherent domain in a short window.

I don't think we need to be so literal that "mapped_noncoherent" can
only be set after the vfio_dma is fully mapped to a noncoherent domain,
but also we can come up with other names for the flag.  Perhaps
"is_noncoherent".  My suggestion was more from the perspective of what
does the flag represent rather than what we intend to do as a result of
the flag being set.  Thanks,

Alex


