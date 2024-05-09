Return-Path: <kvm+bounces-17132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45F888C148A
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 20:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B94C61F22F91
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 18:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F3B770FF;
	Thu,  9 May 2024 18:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qd759BU6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AF310979
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 18:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715278258; cv=none; b=kjvpQZd85Csy7oltXA6oDfyYLd44pVFE8EVTIrw4Omffjro5WDSAgTa5KGfrLXvRqAkfWJx0e+PcfP0U9eeokJaAqoME2tjE7JLi0CmqBrpMkx5GX1Lx11rfYrEphOjMVxIHMQwoM/dVvaGhUxSKnARvFIqqahdx1NWA60LZCw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715278258; c=relaxed/simple;
	bh=MxI4qQxe0VL9WNMds1UiW5qeYv265qFtPm6TQGD7BBA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jIf2prBc7NrMJ4ZSP/Z7uVyrtmSP//BTmfdDtmWzVrlnbRQXFV1QqRG2y4S51YJiwysrImJvdZ6E2EEjeLxyChJcBEh9ZTW1XSxFbbYk0jP1LXQawumFyxhjhiGpSJQsED0/ie/sDxQQn+X2oSq4OHo9ma5nwFJWXsJrhH9Wzhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qd759BU6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715278255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h65yWKO/ry6sqYxOhe3bSv8GsPhhn8KMelqRxO4JGZo=;
	b=Qd759BU6UJduVJ1FVxbbhcQx79UTHJhnmOoatxHz+5qg6Ix+hxrscvK92kvgFOeiRlw300
	jazbpFSqPl6s1Orz8WoNl7Jj1YPJJ3KEfXJVYdbnbg17ITifzPbTN0eZmiW2kghIZZtmYL
	k3zVV/esxB1hnN9JVLT4MgLMSNvFDtw=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-iQat4o0SPgat8pL8ypb09w-1; Thu, 09 May 2024 14:10:54 -0400
X-MC-Unique: iQat4o0SPgat8pL8ypb09w-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7dece1fa472so105116639f.0
        for <kvm@vger.kernel.org>; Thu, 09 May 2024 11:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715278253; x=1715883053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h65yWKO/ry6sqYxOhe3bSv8GsPhhn8KMelqRxO4JGZo=;
        b=CHBhDx9IZZBS7E70iZJtjYxweKsOYLTyR4ccrBb7lFqdYUu3YNSrZENaUSUNA/Ng9a
         u0KXAHh6sGMd3zKPkCU4+FGz18h7WtTOPXd87GnPvRQljP4ZrcKilZ8lZFWT4uTfXGAv
         f7pNScZfuhUbOg/ngRtJBO6DCoaLV2csjTYeTn+ok7x0zB3Y9fek/B9vAGO0WO/eZrMF
         GPqOKZWapF2szFah+6zIpeFAnsSSegFZGgd2oVxxJbqc0aLq1yy9wb1Gec3mk+W1RXHj
         KM80nOtQGvLZBgYR7J6VjVBlOnh1yjF0B35Lf3QtxbsqUyPMSTyFtlRc3607HdKZ82Dm
         pPvg==
X-Gm-Message-State: AOJu0YzK0mU75DdQPs7yZqrnjhmWD99o3FttC5Cq4cDfQj2o7NVvw93b
	hIAhtP+85IgC1MorFyikuHj8WY86imzFV9xhYokroVty/ZR4BZmUFYF96WACkXKwglq+cLoTx4s
	G/oy5jDGXqakUSuv2odu8FJA8YQQRMX3g4BslhQ8cPldd+bckSw==
X-Received: by 2002:a6b:7207:0:b0:7de:acfe:5b70 with SMTP id ca18e2360f4ac-7e1b51a5750mr63387639f.2.1715278253168;
        Thu, 09 May 2024 11:10:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH21pvejjLfvtxVLM26Y6OM/e7JIoGUwbvaMxtHJUUPICUvkfRYfrZ1PyuAPjbXjHTC0DxrYg==
X-Received: by 2002:a6b:7207:0:b0:7de:acfe:5b70 with SMTP id ca18e2360f4ac-7e1b51a5750mr63385039f.2.1715278252811;
        Thu, 09 May 2024 11:10:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-489375c136esm486218173.88.2024.05.09.11.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 11:10:52 -0700 (PDT)
Date: Thu, 9 May 2024 12:10:49 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 jgg@nvidia.com, kevin.tian@intel.com, iommu@lists.linux.dev,
 pbonzini@redhat.com, seanjc@google.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, hpa@zytor.com, corbet@lwn.net,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 baolu.lu@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240509121049.58238a6f.alex.williamson@redhat.com>
In-Reply-To: <20240507062138.20465-1-yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
	<20240507062138.20465-1-yan.y.zhao@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  7 May 2024 14:21:38 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> Flush CPU cache on DMA pages before mapping them into the first
> non-coherent domain (domain that does not enforce cache coherency, i.e. CPU
> caches are not force-snooped) and after unmapping them from the last
> domain.
> 
> Devices attached to non-coherent domains can execute non-coherent DMAs
> (DMAs that lack CPU cache snooping) to access physical memory with CPU
> caches bypassed.
> 
> Such a scenario could be exploited by a malicious guest, allowing them to
> access stale host data in memory rather than the data initialized by the
> host (e.g., zeros) in the cache, thus posing a risk of information leakage
> attack.
> 
> Furthermore, the host kernel (e.g. a ksm thread) might encounter
> inconsistent data between the CPU cache and memory (left by a malicious
> guest) after a page is unpinned for DMA but before it's recycled.
> 
> Therefore, it is required to flush the CPU cache before a page is
> accessible to non-coherent DMAs and after the page is inaccessible to
> non-coherent DMAs.
> 
> However, the CPU cache is not flushed immediately when the page is unmapped
> from the last non-coherent domain. Instead, the flushing is performed
> lazily, right before the page is unpinned.
> Take the following example to illustrate the process. The CPU cache is
> flushed right before step 2 and step 5.
> 1. A page is mapped into a coherent domain.
> 2. The page is mapped into a non-coherent domain.
> 3. The page is unmapped from the non-coherent domain e.g.due to hot-unplug.
> 4. The page is unmapped from the coherent domain.
> 5. The page is unpinned.
> 
> Reasons for adopting this lazily flushing design include:
> - There're several unmap paths and only one unpin path. Lazily flush before
>   unpin wipes out the inconsistency between cache and physical memory
>   before a page is globally visible and produces code that is simpler, more
>   maintainable and easier to backport.
> - Avoid dividing a large unmap range into several smaller ones or
>   allocating additional memory to hold IOVA to HPA relationship.
> 
> Reported-by: Jason Gunthorpe <jgg@nvidia.com>
> Closes: https://lore.kernel.org/lkml/20240109002220.GA439767@nvidia.com
> Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 51 +++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index b5c15fe8f9fc..ce873f4220bf 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -74,6 +74,7 @@ struct vfio_iommu {
>  	bool			v2;
>  	bool			nesting;
>  	bool			dirty_page_tracking;
> +	bool			has_noncoherent_domain;
>  	struct list_head	emulated_iommu_groups;
>  };
>  
> @@ -99,6 +100,7 @@ struct vfio_dma {
>  	unsigned long		*bitmap;
>  	struct mm_struct	*mm;
>  	size_t			locked_vm;
> +	bool			cache_flush_required; /* For noncoherent domain */

Poor packing, minimally this should be grouped with the other bools in
the structure, longer term they should likely all be converted to
bit fields.

>  };
>  
>  struct vfio_batch {
> @@ -716,6 +718,9 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
>  	long unlocked = 0, locked = 0;
>  	long i;
>  
> +	if (dma->cache_flush_required)
> +		arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT, npage << PAGE_SHIFT);
> +
>  	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
>  		if (put_pfn(pfn++, dma->prot)) {
>  			unlocked++;
> @@ -1099,6 +1104,8 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  					    &iotlb_gather);
>  	}
>  
> +	dma->cache_flush_required = false;
> +
>  	if (do_accounting) {
>  		vfio_lock_acct(dma, -unlocked, true);
>  		return 0;
> @@ -1120,6 +1127,21 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>  	iommu->dma_avail++;
>  }
>  
> +static void vfio_update_noncoherent_domain_state(struct vfio_iommu *iommu)
> +{
> +	struct vfio_domain *domain;
> +	bool has_noncoherent = false;
> +
> +	list_for_each_entry(domain, &iommu->domain_list, next) {
> +		if (domain->enforce_cache_coherency)
> +			continue;
> +
> +		has_noncoherent = true;
> +		break;
> +	}
> +	iommu->has_noncoherent_domain = has_noncoherent;
> +}

This should be merged with vfio_domains_have_enforce_cache_coherency()
and the VFIO_DMA_CC_IOMMU extension (if we keep it, see below).

> +
>  static void vfio_update_pgsize_bitmap(struct vfio_iommu *iommu)
>  {
>  	struct vfio_domain *domain;
> @@ -1455,6 +1477,12 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  
>  	vfio_batch_init(&batch);
>  
> +	/*
> +	 * Record necessity to flush CPU cache to make sure CPU cache is flushed
> +	 * for both pin & map and unmap & unpin (for unwind) paths.
> +	 */
> +	dma->cache_flush_required = iommu->has_noncoherent_domain;
> +
>  	while (size) {
>  		/* Pin a contiguous chunk of memory */
>  		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
> @@ -1466,6 +1494,10 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  			break;
>  		}
>  
> +		if (dma->cache_flush_required)
> +			arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT,
> +						npage << PAGE_SHIFT);
> +
>  		/* Map it! */
>  		ret = vfio_iommu_map(iommu, iova + dma->size, pfn, npage,
>  				     dma->prot);
> @@ -1683,9 +1715,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>  	for (; n; n = rb_next(n)) {
>  		struct vfio_dma *dma;
>  		dma_addr_t iova;
> +		bool cache_flush_required;
>  
>  		dma = rb_entry(n, struct vfio_dma, node);
>  		iova = dma->iova;
> +		cache_flush_required = !domain->enforce_cache_coherency &&
> +				       !dma->cache_flush_required;
> +		if (cache_flush_required)
> +			dma->cache_flush_required = true;

The variable name here isn't accurate and the logic is confusing.  If
the domain does not enforce coherency and the mapping is not tagged as
requiring a cache flush, then we need to mark the mapping as requiring
a cache flush.  So the variable state is something more akin to
set_cache_flush_required.  But all we're saving with this is a
redundant set if the mapping is already tagged as requiring a cache
flush, so it could really be simplified to:

		dma->cache_flush_required = !domain->enforce_cache_coherency;

It might add more clarity to just name the mapping flag
dma->mapped_noncoherent.

>  
>  		while (iova < dma->iova + dma->size) {
>  			phys_addr_t phys;
> @@ -1737,6 +1774,9 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>  				size = npage << PAGE_SHIFT;
>  			}
>  
> +			if (cache_flush_required)
> +				arch_clean_nonsnoop_dma(phys, size);
> +

I agree with others as well that this arch callback should be named
something relative to the cache-flush/write-back operation that it
actually performs instead of the overall reason for us requiring it.

>  			ret = iommu_map(domain->domain, iova, phys, size,
>  					dma->prot | IOMMU_CACHE,
>  					GFP_KERNEL_ACCOUNT);
> @@ -1801,6 +1841,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>  			vfio_unpin_pages_remote(dma, iova, phys >> PAGE_SHIFT,
>  						size >> PAGE_SHIFT, true);
>  		}
> +		dma->cache_flush_required = false;
>  	}
>  
>  	vfio_batch_fini(&batch);
> @@ -1828,6 +1869,9 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *
>  	if (!pages)
>  		return;
>  
> +	if (!domain->enforce_cache_coherency)
> +		arch_clean_nonsnoop_dma(page_to_phys(pages), PAGE_SIZE * 2);
> +
>  	list_for_each_entry(region, regions, list) {
>  		start = ALIGN(region->start, PAGE_SIZE * 2);
>  		if (start >= region->end || (region->end - start < PAGE_SIZE * 2))
> @@ -1847,6 +1891,9 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *
>  		break;
>  	}
>  
> +	if (!domain->enforce_cache_coherency)
> +		arch_clean_nonsnoop_dma(page_to_phys(pages), PAGE_SIZE * 2);
> +

Seems like this use case isn't subject to the unmap aspect since these
are kernel allocated and freed pages rather than userspace pages.
There's not an "ongoing use of the page" concern.

The window of opportunity for a device to discover and exploit the
mapping side issue appears almost impossibly small.

>  	__free_pages(pages, order);
>  }
>  
> @@ -2308,6 +2355,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  
>  	list_add(&domain->next, &iommu->domain_list);
>  	vfio_update_pgsize_bitmap(iommu);
> +	if (!domain->enforce_cache_coherency)
> +		vfio_update_noncoherent_domain_state(iommu);

Why isn't this simply:

	if (!domain->enforce_cache_coherency)
		iommu->has_noncoherent_domain = true;

Or maybe:

	if (!domain->enforce_cache_coherency)
		iommu->noncoherent_domains++;

>  done:
>  	/* Delete the old one and insert new iova list */
>  	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
> @@ -2508,6 +2557,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  			}
>  			iommu_domain_free(domain->domain);
>  			list_del(&domain->next);
> +			if (!domain->enforce_cache_coherency)
> +				vfio_update_noncoherent_domain_state(iommu);

If we were to just track the number of noncoherent domains, this could
simply be iommu->noncoherent_domains-- and VFIO_DMA_CC_DMA could be:

	return iommu->noncoherent_domains ? 1 : 0;

Maybe there should be wrappers for list_add() and list_del() relative
to the iommu domain list to make it just be a counter.  Thanks,

Alex

>  			kfree(domain);
>  			vfio_iommu_aper_expand(iommu, &iova_copy);
>  			vfio_update_pgsize_bitmap(iommu);


