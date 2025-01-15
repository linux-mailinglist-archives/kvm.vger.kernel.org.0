Return-Path: <kvm+bounces-35516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F418FA11C15
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 09:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 134DD1679DA
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 08:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2DBC1EEA2B;
	Wed, 15 Jan 2025 08:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCWDVkUq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCEB155A30;
	Wed, 15 Jan 2025 08:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736930028; cv=none; b=Ci4AKJ2mvPeFzISvnZg0jbrpFYPjhwoBlz07PofTf3GMTdoWl162ltrBiGpw13upMf+Kiu/8eIXZOWw6CggVnhO6J2A+fbT1DBSSEBUo+cR7cIb2hhF4RCPVHcn6MAqR40vX/y0Q1aoR2hJ8IvHHz3hoj1iLslAhREsWMCRIWFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736930028; c=relaxed/simple;
	bh=q//4PX+/kKs0NcRsMaK0IRFD8IgnEeYPZkHGethy6Xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tn0yaW4j8kX4iyFRYf/5dGgqhuZTLTjk0y72MAmWT25GUPotSTZ2la6ZC2qbxGEj9K+Desd8CdC+bVp/4eMYBpmfz7p/r5lWTOeJ0J+Au8h5bq/axFylcRUM5zHnoBkTn7xw+YmYOZMaz/GbhYCnFVRAfzp+UBYgZaMzAIAgPpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCWDVkUq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E083DC4CEE2;
	Wed, 15 Jan 2025 08:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736930028;
	bh=q//4PX+/kKs0NcRsMaK0IRFD8IgnEeYPZkHGethy6Xc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mCWDVkUqHQRGTYemu0OT2ih+ESCVIZ/aTGA9LOFnN2apzUXuQ6js3wGRvMvmPD0Q4
	 qPuVV2jFdCTf9DIs+hAcwNkgetPw+3PG1Lpnlw/6yRfq11aaFbmf0jL/DFWnEBrlVw
	 Ua5VHXN/Wk/lZkcpIs8HKqmwrhDVRgZOiJTe7WsPa5iJP6YN5+bhjqq5Jd10hVAZze
	 QrEQ79dFiDRigierP81hoV+aRHQMIswxIRHmBXxqXzkaq8aaF3N2iCj59qFjsa3k/F
	 66JPQhMe1Azzt9/n3bF5LnqLwPghqkXaMemOLirAJWtGi32tua3HSrRA0qNoLRzLR7
	 YnubzClMeJP7Q==
Date: Wed, 15 Jan 2025 10:33:40 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v5 07/17] dma-mapping: Implement link/unlink ranges API
Message-ID: <20250115083340.GL3146852@unreal>
References: <cover.1734436840.git.leon@kernel.org>
 <fa43307222f263e65ae0a84c303150def15e2c77.1734436840.git.leon@kernel.org>
 <ad2312e0-10d5-467a-be5e-75e80805b311@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad2312e0-10d5-467a-be5e-75e80805b311@arm.com>

On Tue, Jan 14, 2025 at 08:50:35PM +0000, Robin Murphy wrote:
> On 17/12/2024 1:00 pm, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Introduce new DMA APIs to perform DMA linkage of buffers
> > in layers higher than DMA.
> > 
> > In proposed API, the callers will perform the following steps.
> > In map path:
> > 	if (dma_can_use_iova(...))
> > 	    dma_iova_alloc()
> > 	    for (page in range)
> > 	       dma_iova_link_next(...)
> > 	    dma_iova_sync(...)
> > 	else
> > 	     /* Fallback to legacy map pages */
> >               for (all pages)
> > 	       dma_map_page(...)
> > 
> > In unmap path:
> > 	if (dma_can_use_iova(...))
> > 	     dma_iova_destroy()
> > 	else
> > 	     for (all pages)
> > 		dma_unmap_page(...)
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >   drivers/iommu/dma-iommu.c   | 259 ++++++++++++++++++++++++++++++++++++
> >   include/linux/dma-mapping.h |  32 +++++
> >   2 files changed, 291 insertions(+)

<...>

> > +static void iommu_dma_iova_unlink_range_slow(struct device *dev,
> > +		dma_addr_t addr, size_t size, enum dma_data_direction dir,
> > +		unsigned long attrs)
> > +{
> > +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> > +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> > +	struct iova_domain *iovad = &cookie->iovad;
> > +	size_t iova_start_pad = iova_offset(iovad, addr);
> > +	dma_addr_t end = addr + size;
> > +
> > +	do {
> > +		phys_addr_t phys;
> > +		size_t len;
> > +
> > +		phys = iommu_iova_to_phys(domain, addr);
> > +		if (WARN_ON(!phys))
> > +			continue;
> 
> Infinite WARN_ON loop, nice.

No problem, will change it to WARN_ON_ONCE.

> 
> > +		len = min_t(size_t,
> > +			end - addr, iovad->granule - iova_start_pad);

<...>

> > +
> > +		swiotlb_tbl_unmap_single(dev, phys, len, dir, attrs);
> 
> This is still dumb. For everything other than the first and last granule,
> either it's definitely not in SWIOTLB, or it is (per the unaligned size
> thing above) but then "len" is definitely wrong and SWIOTLB will complain.

Like Christoph said, we tested it with NVMe which uses SWIOTLB path and
despite having a lot of unaligned sizes, it worked without SWIOTLB
complains.

> 
> > +
> > +		addr += len;
> > +		iova_start_pad = 0;
> > +	} while (addr < end);
> > +}
> > +
> > +static void __iommu_dma_iova_unlink(struct device *dev,
> > +		struct dma_iova_state *state, size_t offset, size_t size,
> > +		enum dma_data_direction dir, unsigned long attrs,
> > +		bool free_iova)
> > +{
> > +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> > +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> > +	struct iova_domain *iovad = &cookie->iovad;
> > +	dma_addr_t addr = state->addr + offset;
> > +	size_t iova_start_pad = iova_offset(iovad, addr);
> > +	struct iommu_iotlb_gather iotlb_gather;
> > +	size_t unmapped;
> > +
> > +	if ((state->__size & DMA_IOVA_USE_SWIOTLB) ||
> > +	    (!dev_is_dma_coherent(dev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC)))
> > +		iommu_dma_iova_unlink_range_slow(dev, addr, size, dir, attrs);
> > +
> > +	iommu_iotlb_gather_init(&iotlb_gather);
> > +	iotlb_gather.queued = free_iova && READ_ONCE(cookie->fq_domain);
> 
> This makes things needlessly hard to follow, just keep the IOVA freeing
> separate. And by that I really mean just have unlink and free, since
> dma_iova_destroy() really doesn't seem worth the extra complexity to save
> one line in one caller...

In initial versions, I didn't implement dma_iova_destroy() and used
unlink->free calls directly. Both Jason and Christoph asked me to
provide dma_iova_destroy(), so we can reuse same iotlb_gather.

Almost all callers (except HMM-like) will use this API call.

Let's keep it.

Thanks

