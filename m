Return-Path: <kvm+bounces-41480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65155A686D4
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 09:31:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B142817B6F5
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 08:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49AA2517A1;
	Wed, 19 Mar 2025 08:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/ZmCalc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C994D20F091;
	Wed, 19 Mar 2025 08:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742373064; cv=none; b=RzdkwKfac6Rf+c9N9OBTOIuZiLPR4sBUmgcHPxk72VnU/5NutxShNmzge43QSrV3vvdEktIhE2ri81Y1nbdvTBZpSyjNW/vgS8PL/A9NYTrhpae/kgu7+eLemU5GkIzWddUQ6uEGjQwu8DZS/C+H1UotPz6s931hb8TuF5CFDdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742373064; c=relaxed/simple;
	bh=w3JmB7o8CKormT/Akok+UN9U+U8VYEVmbKd3okiCYoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WcgP+Rt+xPObIsmt1BqHd3kuIvYuVeA+JzlrwHBTJngo8cyeE61nA38kDLiV+xG6gNN1eG/sT+YCRh7/yn+BKu2pG3h0MnAqWDOD0mSfrL+Lt8Sa7Al9oLz1f8aVVDhO2E1wUo4FW4mnQhyivBvyDGOtJB972JsS+wlirjcumWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/ZmCalc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DF5C4CEE9;
	Wed, 19 Mar 2025 08:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742373063;
	bh=w3JmB7o8CKormT/Akok+UN9U+U8VYEVmbKd3okiCYoE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k/ZmCalc1dPOZG6tOAhA+Vbavt7ywew9AlCIx2pzmLHVBTMjREfKHqE2Yum/A2k90
	 Mgo+utD6esZ3GSzapnLqbyG8yVsrTWUf4LItvlOCrYiiwuNO3yR2hQSEZpAOU6nnCo
	 ZQRiEYn2mZ5bFSK8HEji2pCWj4CLMwBv5PoBA514qIBaTnW4NxRHmPJsRxHz6F9LM6
	 DEj4Vkpkiz3HR+9d8OInlfDxTa9WdUELXV90gpobKxd8KKBd5UGsQL7y13D0qR11Xw
	 1V/5hXHr1Z4zSHswxS63wOUI6bDFZ2FK5D8dKbOltHWG9ThPOmE1f0m3YkoTz1ruoI
	 rs/FbXe+RBpfw==
Date: Wed, 19 Mar 2025 10:30:58 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v7 00/17] Provide a new two step DMA mapping API
Message-ID: <20250319083058.GG1322339@unreal>
References: <cover.1738765879.git.leonro@nvidia.com>
 <20250220124827.GR53094@unreal>
 <CGME20250228195423eucas1p221736d964e9aeb1b055d3ee93a4d2648@eucas1p2.samsung.com>
 <1166a5f5-23cc-4cce-ba40-5e10ad2606de@arm.com>
 <d408b1c7-eabf-4a1e-861c-b2ddf8bf9f0e@samsung.com>
 <20250312193249.GI1322339@unreal>
 <adb63b87-d8f2-4ae6-90c4-125bde41dc29@samsung.com>
 <20250314184911.GR1322339@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250314184911.GR1322339@unreal>

On Fri, Mar 14, 2025 at 08:49:11PM +0200, Leon Romanovsky wrote:
> On Fri, Mar 14, 2025 at 11:52:58AM +0100, Marek Szyprowski wrote:
> > On 12.03.2025 20:32, Leon Romanovsky wrote:
> > > On Wed, Mar 12, 2025 at 10:28:32AM +0100, Marek Szyprowski wrote:
> > >> Hi Robin
> > >>
> > >> On 28.02.2025 20:54, Robin Murphy wrote:
> > >>> On 20/02/2025 12:48 pm, Leon Romanovsky wrote:
> > >>>> On Wed, Feb 05, 2025 at 04:40:20PM +0200, Leon Romanovsky wrote:
> > >>>>> From: Leon Romanovsky <leonro@nvidia.com>
> > >>>>>
> > >>>>> Changelog:
> > >>>>> v7:
> > >>>>>    * Rebased to v6.14-rc1
> > >>>> <...>
> > >>>>
> > >>>>> Christoph Hellwig (6):
> > >>>>>     PCI/P2PDMA: Refactor the p2pdma mapping helpers
> > >>>>>     dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
> > >>>>>     iommu: generalize the batched sync after map interface
> > >>>>>     iommu/dma: Factor out a iommu_dma_map_swiotlb helper
> > >>>>>     dma-mapping: add a dma_need_unmap helper
> > >>>>>     docs: core-api: document the IOVA-based API
> > >>>>>
> > >>>>> Leon Romanovsky (11):
> > >>>>>     iommu: add kernel-doc for iommu_unmap and iommu_unmap_fast
> > >>>>>     dma-mapping: Provide an interface to allow allocate IOVA
> > >>>>>     dma-mapping: Implement link/unlink ranges API
> > >>>>>     mm/hmm: let users to tag specific PFN with DMA mapped bit
> > >>>>>     mm/hmm: provide generic DMA managing logic
> > >>>>>     RDMA/umem: Store ODP access mask information in PFN
> > >>>>>     RDMA/core: Convert UMEM ODP DMA mapping to caching IOVA and page
> > >>>>>       linkage
> > >>>>>     RDMA/umem: Separate implicit ODP initialization from explicit ODP
> > >>>>>     vfio/mlx5: Explicitly use number of pages instead of allocated
> > >>>>> length
> > >>>>>     vfio/mlx5: Rewrite create mkey flow to allow better code reuse
> > >>>>>     vfio/mlx5: Enable the DMA link API
> > >>>>>
> > >>>>>    Documentation/core-api/dma-api.rst   |  70 ++++
> > >>>>    drivers/infiniband/core/umem_odp.c   | 250 +++++---------
> > >>>>>    drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +-
> > >>>>>    drivers/infiniband/hw/mlx5/odp.c     |  65 ++--
> > >>>>>    drivers/infiniband/hw/mlx5/umr.c     |  12 +-
> > >>>>>    drivers/iommu/dma-iommu.c            | 468
> > >>>>> +++++++++++++++++++++++----
> > >>>>>    drivers/iommu/iommu.c                |  84 ++---
> > >>>>>    drivers/pci/p2pdma.c                 |  38 +--
> > >>>>>    drivers/vfio/pci/mlx5/cmd.c          | 375 +++++++++++----------
> > >>>>>    drivers/vfio/pci/mlx5/cmd.h          |  35 +-
> > >>>>>    drivers/vfio/pci/mlx5/main.c         |  87 +++--
> > >>>>>    include/linux/dma-map-ops.h          |  54 ----
> > >>>>>    include/linux/dma-mapping.h          |  85 +++++
> > >>>>>    include/linux/hmm-dma.h              |  33 ++
> > >>>>>    include/linux/hmm.h                  |  21 ++
> > >>>>>    include/linux/iommu.h                |   4 +
> > >>>>>    include/linux/pci-p2pdma.h           |  84 +++++
> > >>>>>    include/rdma/ib_umem_odp.h           |  25 +-
> > >>>>>    kernel/dma/direct.c                  |  44 +--
> > >>>>>    kernel/dma/mapping.c                 |  18 ++
> > >>>>>    mm/hmm.c                             | 264 +++++++++++++--
> > >>>>>    21 files changed, 1435 insertions(+), 693 deletions(-)
> > >>>>>    create mode 100644 include/linux/hmm-dma.h
> > >>>> Kind reminder.
> > > <...>
> > >
> > >> Removing the need for scatterlists was advertised as the main goal of
> > >> this new API, but it looks that similar effects can be achieved with
> > >> just iterating over the pages and calling page-based DMA API directly.
> > > Such iteration can't be enough because P2P pages don't have struct pages,
> > > so you can't use reliably and efficiently dma_map_page_attrs() call.
> > >
> > > The only way to do so is to use dma_map_sg_attrs(), which relies on SG
> > > (the one that we want to remove) to map P2P pages.
> > 
> > That's something I don't get yet. How P2P pages can be used with 
> > dma_map_sg_attrs(), but not with dma_map_page_attrs()? Both operate 
> > internally on struct page pointer.
> 
> Yes, and no.
> See users of is_pci_p2pdma_page(...) function. In dma_*_sg() APIs, there
> is a real check and support for p2p. In dma_map_page_attrs() variants,
> this support is missing (ignored, or error is returned).
> 
> > 
> > >> Maybe I missed something. I still see some advantages in this DMA API
> > >> extension, but I would also like to see the clear benefits from
> > >> introducing it, like perf logs or other benchmark summary.
> > > We didn't focus yet on performance, however Christoph mentioned in his
> > > block RFC [1] that even simple conversion should improve performance as
> > > we are performing one P2P lookup per-bio and not per-SG entry as was
> > > before [2]. In addition it decreases memory [3] too.
> > >
> > > [1] https://lore.kernel.org/all/cover.1730037261.git.leon@kernel.org/
> > > [2] https://lore.kernel.org/all/34d44537a65aba6ede215a8ad882aeee028b423a.1730037261.git.leon@kernel.org/
> > > [3] https://lore.kernel.org/all/383557d0fa1aa393dbab4e1daec94b6cced384ab.1730037261.git.leon@kernel.org/
> > >
> > > So clear benefits are:
> > > 1. Ability to use native for subsystem structure, e.g. bio for block,
> > > umem for RDMA, dmabuf for DRM, e.t.c. It removes current wasteful
> > > conversions from and to SG in order to work with DMA API.
> > > 2. Batched request and iotlb sync optimizations (perform only once).
> > > 3. Avoid very expensive call to pgmap pointer.
> > > 4. Expose MMIO over VFIO without hacks (PCI BAR doesn't have struct pages).
> > > See this series for such a hack
> > > https://lore.kernel.org/all/20250307052248.405803-1-vivek.kasireddy@intel.com/
> > 
> > I see those benefits and I admit that for typical DMA-with-IOMMU case it 
> > would improve some things. I think that main concern from Robin was how 
> > to handle it for the cases without an IOMMU.
> 
> In such case, we fallback to non-IOMMU flow (old, well-established one).
> See this HMM patch as an example https://lore.kernel.org/all/a796da065fa8a9cb35d591ce6930400619572dcc.1738765879.git.leonro@nvidia.com/
> +dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
> +			   size_t idx,
> +			   struct pci_p2pdma_map_state *p2pdma_state)
> ...
> +	if (dma_use_iova(state)) {
> ...
> +	} else {
> ...
> +		dma_addr = dma_map_page(dev, page, 0, map->dma_entry_size,
> +					DMA_BIDIRECTIONAL);
> 
> Thanks

Marek,

Did it answer your concerns?

How can we progress here? As you can see, the chances to get meaningful
response to your review request and my questions are not high.

Thanks

> 
> > 
> > Best regards
> > -- 
> > Marek Szyprowski, PhD
> > Samsung R&D Institute Poland
> > 
> 

