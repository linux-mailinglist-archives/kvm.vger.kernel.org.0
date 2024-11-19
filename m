Return-Path: <kvm+bounces-32055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD3DE9D277E
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 14:58:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66EE01F230E7
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 13:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E7921CDFD1;
	Tue, 19 Nov 2024 13:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NTVyHgZ4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B631CCECF;
	Tue, 19 Nov 2024 13:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732024669; cv=none; b=AH27tVkqeJ1VAerJWPQywZfx32Fwlh9kAAqOP7jIXw9J8lW97hPQGrw6qBsTrDR0QyGx4IGIKNMTep507GQdiamVT8DqW1QhctEcC5r9mUIlTP06XbxJhjiaTef+EuqL0/bJJipgB2NzBgsqqfP+o4B61nlZYfn13FVomvdHViA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732024669; c=relaxed/simple;
	bh=LfF6XQBNPDMNIzDjgyfdmHqe1KOsZVJ/usNbXi+DM20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INCnUhOoeJGP8VRSqannAiyoWA2PxWwAyXZ+qJRhu5PP77YbyTXdE1fB5yYNBBcdsKVkPKSzd28MgA3mkbD22n8X8+nxXNsg2kxSL70Ri7XMOS5IAEmvf8n9/IBNP1SGG6p4EREv6vXtUnI74PfZq28eiufN2YVp93YQeS1ZOrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NTVyHgZ4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395C1C4CECF;
	Tue, 19 Nov 2024 13:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732024669;
	bh=LfF6XQBNPDMNIzDjgyfdmHqe1KOsZVJ/usNbXi+DM20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NTVyHgZ4ej/NoJRr2JYj7UKyQlfR6XGQRr9FmbaNFpYfeUFtD11fXLEeAHp2m4iJL
	 TNBAN5sK8DRrQUrWgPkGrR7fMZ604apkzfT0Ic36gzChdKeAZmYnGvkEl8XWKptUmb
	 cLNb9TKDfRrzmWFzzONZlNZr6dNP6NYg1CTXXFug9/xBgWGnhtkEiSLfQ+groFJnlH
	 IRXJu2sO9iXH53SOKFBbAfQm1E6weEIh2HjM5VaJai843ASOTzrBAJDXWvm4Uzu+Xr
	 v5J5aK66FsIFRyYUnNEIC8pzYfvUFR8Dga4EbAxrFRpgLvgeBvpo3V834wCS/2Gb/X
	 XeQoV828mjx1w==
Date: Tue, 19 Nov 2024 15:57:43 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
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
Subject: Re: [PATCH v3 07/17] dma-mapping: Implement link/unlink ranges API
Message-ID: <20241119135743.GB26101@unreal>
References: <cover.1731244445.git.leon@kernel.org>
 <f8c7f160c9ae97fef4ccd355f9979727552c7374.1731244445.git.leon@kernel.org>
 <20241118145929.GB27795@willie-the-truck>
 <20241118185533.GA24154@unreal>
 <20241119090507.GB28466@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119090507.GB28466@willie-the-truck>

On Tue, Nov 19, 2024 at 09:05:08AM +0000, Will Deacon wrote:
> On Mon, Nov 18, 2024 at 08:55:33PM +0200, Leon Romanovsky wrote:
> > On Mon, Nov 18, 2024 at 02:59:30PM +0000, Will Deacon wrote:
> > > On Sun, Nov 10, 2024 at 03:46:54PM +0200, Leon Romanovsky wrote:
> > > > +static void __iommu_dma_iova_unlink(struct device *dev,
> > > > +		struct dma_iova_state *state, size_t offset, size_t size,
> > > > +		enum dma_data_direction dir, unsigned long attrs,
> > > > +		bool free_iova)
> > > > +{
> > > > +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> > > > +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> > > > +	struct iova_domain *iovad = &cookie->iovad;
> > > > +	dma_addr_t addr = state->addr + offset;
> > > > +	size_t iova_start_pad = iova_offset(iovad, addr);
> > > > +	struct iommu_iotlb_gather iotlb_gather;
> > > > +	size_t unmapped;
> > > > +
> > > > +	if ((state->__size & DMA_IOVA_USE_SWIOTLB) ||
> > > > +	    (!dev_is_dma_coherent(dev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC)))
> > > > +		iommu_dma_iova_unlink_range_slow(dev, addr, size, dir, attrs);
> > > > +
> > > > +	iommu_iotlb_gather_init(&iotlb_gather);
> > > > +	iotlb_gather.queued = free_iova && READ_ONCE(cookie->fq_domain);
> > > > +
> > > > +	size = iova_align(iovad, size + iova_start_pad);
> > > > +	addr -= iova_start_pad;
> > > > +	unmapped = iommu_unmap_fast(domain, addr, size, &iotlb_gather);
> > > > +	WARN_ON(unmapped != size);
> > > 
> > > Does the new API require that the 'size' passed to dma_iova_unlink()
> > > exactly match the 'size' passed to the corresponding call to
> > > dma_iova_link()? I ask because the IOMMU page-table code is built around
> > > the assumption that partial unmap() operations never occur (i.e.
> > > operations which could require splitting a huge mapping). We just
> > > removed [1] that code from the Arm IO page-table implementations, so it
> > > would be good to avoid adding it back for this.
> > 
> > dma_iova_link/dma_iova_unlink() don't have any assumptions in addition
> > to already existing for dma_map_sg/dma_unmap_sg(). In reality, it means
> > that all calls to unlink will have same size as for link.
> 
> Ok, great. Any chance you could call that out in the documentation patch,
> please?

Can you suggest what should I add there, as it is not specific to new
API, but general note applicable to all __iommu_unmap() callers?

Thanks

