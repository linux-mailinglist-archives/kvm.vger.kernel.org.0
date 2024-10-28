Return-Path: <kvm+bounces-29818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BB899B263D
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 07:38:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61520282303
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E232318F2C4;
	Mon, 28 Oct 2024 06:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GwfQjiZK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A0E15B10D;
	Mon, 28 Oct 2024 06:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097465; cv=none; b=irOYvAaVXpT8rEvpcHgPesnNwEuloq5pe3Y0cDCnq2+08czVYvdhi7I2dQmKiJ5k6krBQNA/9nKdixuHuVO0I4tHTo6FP0NYJZMmPlK7491RYP7h9hjRXWHamYFiUoFvgY0k3pOUprtp7niABYLeH1o8R1bAv2DmxsF/9Ux3ibo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097465; c=relaxed/simple;
	bh=JSMPxlj7Xh+b8j9DlJV8uewuubV9Tsu6U0l5WWqgJPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+455ocv4enWemhSOHuGPBWK7dxUy2uJc5eSCWpYTP5k+g/1hVH4iekkMNYIabud/YOTBF/kt7HFXBQsbLDc3A6CmNn34t2inzwpMS9ni0/7Nb//MWRdo/u+9kUsOSnZaJRwnUKePhdu2+02TD5DrOlj36uolsB2cfBFHGGAQcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GwfQjiZK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88BBC4CECD;
	Mon, 28 Oct 2024 06:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730097464;
	bh=JSMPxlj7Xh+b8j9DlJV8uewuubV9Tsu6U0l5WWqgJPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GwfQjiZKs0yrCxRr/DuLwVj0Hx2O01TJqsx4cOgi4xDB5heJMzcMFklB+BmqVt/Cv
	 4gTLkD3T4pLeplq55h8kscjuwFaQBaQQl3jJ+S6HDuMUb8Uo4nfwXKbBH4ZpNsFwWc
	 DtTbV7qiK3wP+pOJjE92kpgpVG2/Rp3yxPce9N57yNgHPfhuWe+jA+txqxeG7J3/WR
	 lg7fC+BqgPGzEhchM2jYymbqRn4haIlJdsIa0VzlUlQRhnfBkwl7wj8kV+Z4AwHkx2
	 BqCjnbHjv5nHEhthh0L9SPFTB5k9zIXGi2bQT8jtQ/tbnPfE55BhKbIxD3tfcRScfY
	 kTj4HSZy9GalA==
Date: Mon, 28 Oct 2024 08:37:40 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/18] dma: Provide an interface to allow allocate IOVA
Message-ID: <20241028063740.GD1615717@unreal>
References: <cover.1730037276.git.leon@kernel.org>
 <844f3dcf9c341b8178bfbc90909ef13d11dd2193.1730037276.git.leon@kernel.org>
 <25c32551-32e2-4a44-b0ae-30ad08e06799@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25c32551-32e2-4a44-b0ae-30ad08e06799@linux.intel.com>

On Mon, Oct 28, 2024 at 09:24:08AM +0800, Baolu Lu wrote:
> On 2024/10/27 22:21, Leon Romanovsky wrote:
> > From: Leon Romanovsky<leonro@nvidia.com>
> > 
> > The existing .map_page() callback provides both allocating of IOVA
> > and linking DMA pages. That combination works great for most of the
> > callers who use it in control paths, but is less effective in fast
> > paths where there may be multiple calls to map_page().
> > 
> > These advanced callers already manage their data in some sort of
> > database and can perform IOVA allocation in advance, leaving range
> > linkage operation to be in fast path.
> > 
> > Provide an interface to allocate/deallocate IOVA and next patch
> > link/unlink DMA ranges to that specific IOVA.
> > 
> > The API is exported from dma-iommu as it is the only implementation
> > supported, the namespace is clearly different from iommu_* functions
> > which are not allowed to be used. This code layout allows us to save
> > function call per API call used in datapath as well as a lot of boilerplate
> > code.
> > 
> > Signed-off-by: Leon Romanovsky<leonro@nvidia.com>
> > ---
> >   drivers/iommu/dma-iommu.c   | 79 +++++++++++++++++++++++++++++++++++++
> >   include/linux/dma-mapping.h | 15 +++++++
> >   2 files changed, 94 insertions(+)
> > 
> > diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> > index c422e36c0d66..0644152c5aad 100644
> > --- a/drivers/iommu/dma-iommu.c
> > +++ b/drivers/iommu/dma-iommu.c
> > @@ -1745,6 +1745,85 @@ size_t iommu_dma_max_mapping_size(struct device *dev)
> >   	return SIZE_MAX;
> >   }
> > +static bool iommu_dma_iova_alloc(struct device *dev,
> > +		struct dma_iova_state *state, phys_addr_t phys, size_t size)
> > +{
> > +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> > +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> > +	struct iova_domain *iovad = &cookie->iovad;
> > +	size_t iova_off = iova_offset(iovad, phys);
> > +	dma_addr_t addr;
> > +
> > +	if (WARN_ON_ONCE(!size))
> > +		return false;
> > +	if (WARN_ON_ONCE(size & DMA_IOVA_USE_SWIOTLB))
> > +		return false;
> > +
> > +	addr = iommu_dma_alloc_iova(domain,
> > +			iova_align(iovad, size + iova_off),
> > +			dma_get_mask(dev), dev);
> > +	if (!addr)
> > +		return false;
> > +
> > +	state->addr = addr + iova_off;
> > +	state->__size = size;
> > +	return true;
> > +}
> > +
> > +/**
> > + * dma_iova_try_alloc - Try to allocate an IOVA space
> > + * @dev: Device to allocate the IOVA space for
> > + * @state: IOVA state
> > + * @phys: physical address
> I'm curious to know why a physical address is necessary for IOVA space
> allocation. Could you please elaborate?

The proposed API is not only splitted to allow batching of DMA
operations without need of scatter-gather, but also allowed to
users without "struct *page" to use it. 

In IOMMU and DMA layers all operations are performed on physical
addresses and the API "request" to provide "struct *page" in
dma_map_sg/dma_map_page is not truly needed.

In this specific case, the physical address is used to calculate
IOVA offset, see "size_t iova_off = iova_offset(iovad, phys);" line,
which is needed for NVMe PCI/block layer, as they can have first
address to be unaligned and IOVA allocation will need an offset to
properly calculate size.

HMM and VFIO operate on page granularity and in simple case
they don't need alignment. In more advance scenarios, they will
benefit from this offset anyway as it will cause to reduce of IOVA
space.

Thanks

