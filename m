Return-Path: <kvm+bounces-49465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A817AD93D7
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BBBD1BC2966
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42720227E95;
	Fri, 13 Jun 2025 17:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jOv/eGhu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF1622068B
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749836307; cv=none; b=RlaMmVjdYHI5b5A7EIjhleZv1k/xKCelbPTiZOddWDZjmhFu8hcTE7zoeSNMdh7pjdsVm4UO7r4rlHDpQTaNz6nrSfHShK8XLHCW8w02fTe+4ucpQwJAPF2rJ/nLdxUEW3nsEgFGyVxiQw4n0h9ZaL87ULGCYbZCjf+tUZa7sZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749836307; c=relaxed/simple;
	bh=GCsZBLLMeFDWpwrjFxnJA4jeQPHtN7xz5n0A14nqUpo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJ1z33iljBB3uJZoaEbLXLiCkWdC2lfFfkQqlZpdxV+XfRig1QeUTiwZj9D1csCJvGQXs25fep7y7fSbStNs8XC8GFzB76KW4rQa6N1AMpjLy1fiy+J7x0Ha3Q8SLjPB2fGZfOhBeG2MwfU9uDl7eX0rd9VYa2QqJbCnO/jXzNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jOv/eGhu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749836304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gd00oNRhCZA9bl4FEuwlqWv3NB9O4qFOmwNNS6VXqoc=;
	b=jOv/eGhuYlRuhzy9c9HYfh8XDwbOliM3FFzSV+gC5yw9rpDp+5VR2B2hEYF3/ap1yOlXM6
	8SXWNGnC9brOeAZNo6cnihgMW21hvuPp8G5i0nc6iW1NnfM72YdUG+XNg0VrJq70M7IH4k
	gUai9cGYg3/fxXzXHOYriusEQL+2VFA=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-EQalP3DXMfi1avHMC6RtHg-1; Fri, 13 Jun 2025 13:38:22 -0400
X-MC-Unique: EQalP3DXMfi1avHMC6RtHg-1
X-Mimecast-MFC-AGG-ID: EQalP3DXMfi1avHMC6RtHg_1749836301
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-87373f99cd5so18904939f.3
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 10:38:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749836301; x=1750441101;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gd00oNRhCZA9bl4FEuwlqWv3NB9O4qFOmwNNS6VXqoc=;
        b=xULjOBN2a+33+Ur5w5mHisHhCWjQfkVo2G0/FnSbQnxpVbr/c0GDGAF/e/u4gh5wWb
         YtOtBMEwBk3Or2pGIx/eZ+h0RqV36lObaZhH5G5mXm3zCFVmZGZfPZY+HgBQnvX1CL8Q
         OOaGhrsu+iWSgHuStejildWmqTtVhD3C/qnFxm8Mjqib/Bqx1rQr7pXbQ+dq3weF9RF4
         6vgYRnVf50Ga4tlL1q2nt0z7QE1X8Ws1Mzub5K4gr8DQ7KRTB3dL3Y4HmeIRUOzTaoqq
         ViYzmJ7z4jQfyRY9x/Ei+eKA+htZ65yblVMBOZaSeTzxuZ5ARj9ghARTUBYtO9EMvZss
         xp7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUj26G/BhGOzzXuIq798idYNLbgU6TGD69VYlVlWiVjvKpaQGPOpEIZ2+Qix/2nlXSwcxQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKfXwsw+qBxlDmYHhPPJmV2OaGe28ZTp2raN8D+Sh/OdpZzO8w
	BgV303mT/mgxJ8I2J3x8b7o3m/jRba3+83ROGdnrsP3EB14jjHpMNQMLymD4giX4f56i5m0LrZQ
	7PCk3RYkhk8Sv2Cvw9snS5Opx5pddNepOulNYWhxN+ulwQ9OhDlCYtQ==
X-Gm-Gg: ASbGnctir/cnrZUI1A9PNM4SZleP+gJFDzuhf8GPeGHp65FCPDic5bBdgO49jTP9xIx
	UZbKRgMmOIorwEc5LUTQOpVjvrPr84BLINSXhtrJZ/vXso28yS67UCVtlV30XmbqWCYdI1vRWKY
	KyjecSTgicUF1szEEqoXdLVYc8V6SvJwckE4lgTc5JvlvLMVO5irZTOl/BxJC2sPwxxl2iAaI8V
	M5dppOKKyZ8DcbzLH4oXMpj+T7P7xCe0iusTHo9twm1e8eFBPRP+227t+yTP3SxYZgKvXw5rBik
	LCLAb73qLbBmGzKT8RJ0MU5A8w==
X-Received: by 2002:a05:6e02:1c25:b0:3db:72f7:d7c3 with SMTP id e9e14a558f8ab-3de07da97f8mr1669425ab.3.1749836301291;
        Fri, 13 Jun 2025 10:38:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBOmEPkV4fSOvfJCBdCCdGSMnxwXbYmdpRxCmhRxQRYrTknNFKXlc/k+8Iqa3cISRD+98o9Q==
X-Received: by 2002:a05:6e02:1c25:b0:3db:72f7:d7c3 with SMTP id e9e14a558f8ab-3de07da97f8mr1669265ab.3.1749836300739;
        Fri, 13 Jun 2025 10:38:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3de01a45455sm4340865ab.45.2025.06.13.10.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 10:38:20 -0700 (PDT)
Date: Fri, 13 Jun 2025 11:38:18 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: david@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 peterx@redhat.com
Subject: Re: [RFC v2] vfio/type1: optimize vfio_unpin_pages_remote() for
 large folio
Message-ID: <20250613113818.584bec0a.alex.williamson@redhat.com>
In-Reply-To: <20250613062920.68801-1-lizhe.67@bytedance.com>
References: <20250612163239.5e45afc6.alex.williamson@redhat.com>
	<20250613062920.68801-1-lizhe.67@bytedance.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 13 Jun 2025 14:29:20 +0800
lizhe.67@bytedance.com wrote:

> On Thu, 12 Jun 2025 16:32:39 -0600, alex.williamson@redhat.com wrote:
> 
> > >  drivers/vfio/vfio_iommu_type1.c | 53 +++++++++++++++++++++++++--------
> > >  1 file changed, 41 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > index 28ee4b8d39ae..2f6c0074d7b3 100644
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -469,17 +469,28 @@ static bool is_invalid_reserved_pfn(unsigned long pfn)
> > >  	return true;
> > >  }
> > >  
> > > -static int put_pfn(unsigned long pfn, int prot)
> > > +static inline void _put_pfns(struct page *page, int npages, int prot)
> > >  {
> > > -	if (!is_invalid_reserved_pfn(pfn)) {
> > > -		struct page *page = pfn_to_page(pfn);
> > > +	unpin_user_page_range_dirty_lock(page, npages, prot & IOMMU_WRITE);
> > > +}
> > >  
> > > -		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
> > > -		return 1;
> > > +/*
> > > + * The caller must ensure that these npages PFNs belong to the same folio.
> > > + */
> > > +static inline int put_pfns(unsigned long pfn, int npages, int prot)
> > > +{
> > > +	if (!is_invalid_reserved_pfn(pfn)) {
> > > +		_put_pfns(pfn_to_page(pfn), npages, prot);
> > > +		return npages;
> > >  	}
> > >  	return 0;
> > >  }
> > >  
> > > +static inline int put_pfn(unsigned long pfn, int prot)
> > > +{
> > > +	return put_pfns(pfn, 1, prot);
> > > +}
> > > +
> > >  #define VFIO_BATCH_MAX_CAPACITY (PAGE_SIZE / sizeof(struct page *))
> > >  
> > >  static void __vfio_batch_init(struct vfio_batch *batch, bool single)
> > > @@ -805,15 +816,33 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
> > >  				    unsigned long pfn, unsigned long npage,
> > >  				    bool do_accounting)
> > >  {
> > > -	long unlocked = 0, locked = 0;
> > > -	long i;
> > > +	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
> > >  
> > > -	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
> > > -		if (put_pfn(pfn++, dma->prot)) {
> > > -			unlocked++;
> > > -			if (vfio_find_vpfn(dma, iova))
> > > -				locked++;
> > > +	while (npage) {
> > > +		struct folio *folio;
> > > +		struct page *page;
> > > +		long step = 1;
> > > +
> > > +		if (is_invalid_reserved_pfn(pfn))
> > > +			goto next;
> > > +
> > > +		page = pfn_to_page(pfn);
> > > +		folio = page_folio(page);
> > > +
> > > +		if (!folio_test_large(folio)) {
> > > +			_put_pfns(page, 1, dma->prot);
> > > +		} else {
> > > +			step = min_t(long, npage,
> > > +				folio_nr_pages(folio) -
> > > +				folio_page_idx(folio, page));
> > > +			_put_pfns(page, step, dma->prot);
> > >  		}
> > > +
> > > +		unlocked += step;
> > > +next:  
> > 
> > Usage of @step is inconsistent, goto isn't really necessary either, how
> > about:
> > 
> > 	while (npage) {
> > 		unsigned long step = 1;
> > 
> > 		if (!is_invalid_reserved_pfn(pfn)) {
> > 			struct page *page = pfn_to_page(pfn);
> > 			struct folio *folio = page_folio(page);
> > 			long nr_pages = folio_nr_pages(folio);
> > 
> > 			if (nr_pages > 1)
> > 				step = min_t(long, npage,
> > 					nr_pages -
> > 					folio_page_idx(folio, page));
> > 
> > 			_put_pfns(page, step, dma->prot);
> > 			unlocked += step;
> > 		}
> >   
> 
> That's great. This implementation is much better.
> 
> I'm a bit uncertain about the best type to use for the 'step'
> variable here. I've been trying to keep things consistent with the
> put_pfn() function, so I set the type of the second parameter in
> _put_pfns() to 'int'(we pass 'step' as the second argument to
> _put_pfns()).
> 
> Using unsigned long for 'step' should definitely work here, as the
> number of pages in a large folio currently falls within the range
> that can be represented by an int. However, there is still a
> potential risk of truncation that we need to be mindful of.
> 
> > > +		pfn += step;
> > > +		iova += PAGE_SIZE * step;
> > > +		npage -= step;
> > >  	}
> > >  
> > >  	if (do_accounting)  
> > 
> > AIUI, the idea is that we know we have npage contiguous pfns and we
> > currently test invalid/reserved, call pfn_to_page(), call
> > unpin_user_pages_dirty_lock(), and test vpfn for each individually.
> >
> > This instead wants to batch the vpfn accounted pfns using the range
> > helper added for the mapping patch,  
> 
> Yes. We use vpfn_pages() just to track the locked pages.
> 
> > infer that continuous pfns have the
> > same invalid/reserved state, the pages are sequential, and that we can
> > use the end of the folio to mark any inflections in those assumptions
> > otherwise.  Do I have that correct?  
> 
> Yes. I think we're definitely on the same page here.
> 
> > I think this could be split into two patches, one simply batching the
> > vpfn accounting and the next introducing the folio dependency.  The
> > contributions of each to the overall performance improvement would be
> > interesting.  
> 
> I've made an initial attempt, and here are the two patches after
> splitting them up.
> 
> 1. batch-vpfn-accounting-patch:
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 28ee4b8d39ae..c8ddcee5aa68 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -805,16 +805,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>  				    unsigned long pfn, unsigned long npage,
>  				    bool do_accounting)
>  {
> -	long unlocked = 0, locked = 0;
> +	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
>  	long i;
>  
> -	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
> -		if (put_pfn(pfn++, dma->prot)) {
> +	for (i = 0; i < npage; i++, iova += PAGE_SIZE)
> +		if (put_pfn(pfn++, dma->prot))
>  			unlocked++;
> -			if (vfio_find_vpfn(dma, iova))
> -				locked++;
> -		}
> -	}
>  
>  	if (do_accounting)
>  		vfio_lock_acct(dma, locked - unlocked, true);
> -----------------
> 
> 2. large-folio-optimization-patch:
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index c8ddcee5aa68..48c2ba4ba4eb 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -469,17 +469,28 @@ static bool is_invalid_reserved_pfn(unsigned long pfn)
>  	return true;
>  }
>  
> -static int put_pfn(unsigned long pfn, int prot)
> +static inline void _put_pfns(struct page *page, int npages, int prot)
>  {
> -	if (!is_invalid_reserved_pfn(pfn)) {
> -		struct page *page = pfn_to_page(pfn);
> +	unpin_user_page_range_dirty_lock(page, npages, prot & IOMMU_WRITE);
> +}
>  
> -		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
> -		return 1;
> +/*
> + * The caller must ensure that these npages PFNs belong to the same folio.
> + */
> +static inline int put_pfns(unsigned long pfn, int npages, int prot)
> +{
> +	if (!is_invalid_reserved_pfn(pfn)) {
> +		_put_pfns(pfn_to_page(pfn), npages, prot);
> +		return npages;
>  	}
>  	return 0;
>  }
>  
> +static inline int put_pfn(unsigned long pfn, int prot)
> +{
> +	return put_pfns(pfn, 1, prot);
> +}
> +
>  #define VFIO_BATCH_MAX_CAPACITY (PAGE_SIZE / sizeof(struct page *))
>  
>  static void __vfio_batch_init(struct vfio_batch *batch, bool single)
> @@ -806,11 +817,28 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>  				    bool do_accounting)
>  {
>  	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
> -	long i;
>  
> -	for (i = 0; i < npage; i++, iova += PAGE_SIZE)
> -		if (put_pfn(pfn++, dma->prot))
> -			unlocked++;
> +	while (npage) {
> +		long step = 1;
> +
> +		if (!is_invalid_reserved_pfn(pfn)) {
> +			struct page *page = pfn_to_page(pfn);
> +			struct folio *folio = page_folio(page);
> +			long nr_pages = folio_nr_pages(folio);
> +
> +			if (nr_pages > 1)
> +				step = min_t(long, npage,
> +					nr_pages -
> +					folio_page_idx(folio, page));
> +
> +			_put_pfns(page, step, dma->prot);
> +			unlocked += step;
> +		}
> +
> +		pfn += step;
> +		iova += PAGE_SIZE * step;
> +		npage -= step;
> +	}
>  
>  	if (do_accounting)
>  		vfio_lock_acct(dma, locked - unlocked, true);
> -----------------
> 
> Here are the results of the performance tests.
> 
> Base(v6.15):
> ./vfio-pci-mem-dma-map 0000:03:00.0 16
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.048 s (333.5 GB/s)
> VFIO UNMAP DMA in 0.139 s (115.1 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.273 s (58.6 GB/s)
> VFIO UNMAP DMA in 0.302 s (52.9 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.052 s (305.3 GB/s)
> VFIO UNMAP DMA in 0.141 s (113.8 GB/s)
> 
> Base + Map + batch-vpfn-accounting-patch:
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.027 s (591.1 GB/s)
> VFIO UNMAP DMA in 0.138 s (115.7 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.292 s (54.8 GB/s)
> VFIO UNMAP DMA in 0.308 s (52.0 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.032 s (505.5 GB/s)
> VFIO UNMAP DMA in 0.140 s (114.1 GB/s)
> 
> Base + Map + batch-vpfn-accounting-patch + large-folio-optimization-patch:
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.027 s (591.2 GB/s)
> VFIO UNMAP DMA in 0.049 s (327.6 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.291 s (55.0 GB/s)
> VFIO UNMAP DMA in 0.306 s (52.3 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.032 s (498.3 GB/s)
> VFIO UNMAP DMA in 0.049 s (326.2 GB/s)
> 
> It seems that batching the vpfn accounting doesn't seem to have much
> of an impact in my environment. Perhaps this is because the rbtree
> for vfpn is empty, allowing vfio_find_vpfn to execute quickly?

Right, the rbtree is generally empty, but I thought it might still have
some benefit.  It might, but it's probably below the noise threshold of
the test.  I think it still makes sense to split the patches, the first
change is logically separate and the second patch builds on it.

long seems fine for the type of step.  Do note though that the previous
patch on the mapping side used nr_pages as the increment size, it might
make sense to be consistent and use something different for the folio
nr_pages and replace "step" with "nr_pages".

Also please add a comment explaining the use of the folio as a basis
for inferring that we won't have an inflection in invalid/reserved
state for the remaining extent of the folio and that the folio has
sequential pages and therefore reflects the contiguous pfn range.
Thanks,

Alex


