Return-Path: <kvm+bounces-30251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 60B7D9B8520
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 22:18:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BECFEB2217A
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 21:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 290AA1CB50C;
	Thu, 31 Oct 2024 21:18:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C60481B95B;
	Thu, 31 Oct 2024 21:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730409494; cv=none; b=XZ/Ulwr4aWy0ff92M7t4di6Ov7cmKUXIWQNr5Qb8OEUx5nn7QVlDtNoP9n/9lKs3WvFgPnjhy4hwC2hhJ+UhfPKIRKjwOyeqI++1lfWU9ocHKHP2aZxTV/dJY0FxPdVDCeYlXGlYVvR1iDR26MdWjoQwB9zdepyGWSGy8awMV3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730409494; c=relaxed/simple;
	bh=5BATugqDwGVncVLZt4qNEQ9Icpc45cvvmhwogP9IPLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d2XCtyNfSkgUjmj6EuU5/CN7FSDAN9xuwhj3xAhZwkzCRm1Tm2IBBupgk7EQU+ZEsiwXUO15GOR6GCJrToDzK0Avsi+KbQusktY716O7iEU0zfYhLZs3LLktE4KxUEWcmzqVb1CeWx4MVdP8ljQyKx0LrwH9Sfdiy/evDjEQye4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 478E21063;
	Thu, 31 Oct 2024 14:18:35 -0700 (PDT)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 279FA3F73B;
	Thu, 31 Oct 2024 14:17:51 -0700 (PDT)
Message-ID: <3567312e-5942-4037-93dc-587f25f0778c@arm.com>
Date: Thu, 31 Oct 2024 21:17:45 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/17] Provide a new two step DMA mapping API
To: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
 iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
References: <cover.1730298502.git.leon@kernel.org>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <cover.1730298502.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30/10/2024 3:12 pm, Leon Romanovsky wrote:
> Changelog:
> v1:
>   * Squashed two VFIO patches into one
>   * Added Acked-by/Reviewed-by tags
>   * Fix docs spelling errors
>   * Simplified dma_iova_sync() API
>   * Added extra check in dma_iova_destroy() if mapped size to make code more clear
>   * Fixed checkpatch warnings in p2p patch
>   * Changed implementation of VFIO mlx5 mlx5vf_add_migration_pages() to
>     be more general
>   * Reduced the number of changes in VFIO patch
> v0: https://lore.kernel.org/all/cover.1730037276.git.leon@kernel.org
> 
> ----------------------------------------------------------------------------
> The code can be downloaded from:
> https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tag:dma-split-oct-30
> 
> ----------------------------------------------------------------------------
> Currently the only efficient way to map a complex memory description through
> the DMA API is by using the scatterlist APIs.

It's really not efficient... In most cases they're just wrappers for a 
bunch of dma_map_page() etc. calls for the convenience of callers who 
are using a scatterlist for their own reasons anyway. Even with 
iommu-dma, I expect that approach would likely perform better for most 
users as well, given that typical individual segment sizes are much more 
likely to be in scope of the IOVA caches.

The hilarious amount of work that iommu_dma_map_sg() does is pretty much 
entirely for the benefit of v4l2 and dma-buf importers who *depend* on 
being able to linearise a scatterlist in DMA address space. TBH I doubt 
there are many actual scatter-gather-capable devices with significant 
enough limitations to meaningfully benefit from DMA segment combining 
these days - I've often thought that by now it might be a good idea to 
turn that behaviour off by default and add an attribute for callers to 
explicitly request it.

> The SG APIs are unique in that
> they efficiently combine the two fundamental operations of sizing and allocating
> a large IOVA window from the IOMMU and processing all the per-address
> swiotlb/flushing/p2p/map details.

Except that's obviously not unique when the page APIs also combine the 
exact same operations? :/

> This uniqueness has been a long standing pain point as the scatterlist API
> is mandatory, but expensive to use.

Huh? When and where has anything ever called it mandatory? Nobody's 
getting sent to DMA jail for open-coding:

	for_each_sg(...)
		my_dma_addr = dma_map_page(..., sg_page());

if they do know the map_sg operation is unnecessarily expensive for 
their needs.

> It prevents any kind of optimization or
> feature improvement (such as avoiding struct page for P2P) due to the impossibility
> of improving the scatterlist.
> 
> Several approaches have been explored to expand the DMA API with additional
> scatterlist-like structures (BIO, rlist), instead split up the DMA API
> to allow callers to bring their own data structure.

And this line of reasoning is still "2 + 2 = Thursday" - what is to say 
those two notions in any way related? We literally already have one 
generic DMA operation which doesn't operate on struct page, yet needed 
nothing "split up" to be possible. Fair enough if callers want some 
alternative interfaces for mapping memory as well, but to be a common 
DMA API it has to be usable everywhere and cover all the DMA operations 
that the current page-based APIs provide, otherwise those callers 
obviously can't stop using struct pages. What precludes a 
straightforward dma_map_phys() etc. to parallel the existing API? What's 
the justification for an IOMMU-specific design when surely if anyone can 
benefit from more memory-efficient structures across drivers and 
subsystems it's the little embedded platforms, not the big servers 
already happy to spend tens to hundreds of megabytes on IOMMU pagetables?

> The API is split up into parts:
>   - Allocate IOVA space:
>      To do any pre-allocation required. This is done based on the caller
>      supplying some details about how much IOMMU address space it would need
>      in worst case.
>   - Map and unmap relevant structures to pre-allocated IOVA space:
>      Perform the actual mapping into the pre-allocated IOVA. This is very
>      similar to dma_map_page().
 >
> In this and the next series [1], examples of three different users are converted
> to the new API to show the benefits and its versatility. Each user has a unique
> flow:
>   1. RDMA ODP is an example of "SVA mirroring" using HMM that needs to
>      dynamically map/unmap large numbers of single pages. This becomes
>      significantly faster in the IOMMU case as the map/unmap is now just
>      a page table walk, the IOVA allocation is pre-computed once. Significant
>      amounts of memory are saved as there is no longer a need to store the
>      dma_addr_t of each page.

I particularly enjoy the comment in patch #11 calling out how this 
"unique flow" is fundamentally incompatible with the API it's supposed 
to show off and has to rely on a sketchy hack to abuse its 
"versatility". Great stuff.

>   2. VFIO PCI live migration code is building a very large "page list"
>      for the device. Instead of allocating a scatter list entry per allocated
>      page it can just allocate an array of 'struct page *', saving a large
>      amount of memory.

VFIO already assumes a coherent device with (realistically) an IOMMU 
which it explicitly manages - why is it even pretending to need a 
generic DMA API?

>   3. NVMe PCI demonstrates how a BIO can be converted to a HW scatter
>      list without having to allocate then populate an intermediate SG table.

As above, given that a bio_vec still deals in struct pages, that could 
seemingly already be done by just mapping the pages, so how is it 
proving any benefit of a fragile new interface?

Heck, not that I really want to encourage it, but we also already have 
network drivers who don't have the space to stash both a DMA address 
*and* a page address in their descriptors, and economise on shadow 
storage by instead grovelling into the default IOMMU domain with 
iova_to_phys(). I mean, I'd _kinda_ like to send them to DMA jail, but 
it's not an absolutely unreasonable trick to play... also DMA jail 
doesn't exist.

> To make the use of the new API easier, HMM and block subsystems are extended
> to hide the optimization details from the caller. Among these optimizations:
>   * Memory reduction as in most real use cases there is no need to store mapped
>     DMA addresses and unmap them.
>   * Reducing the function call overhead by removing the need to call function
>     pointers and use direct calls instead.
> 
> This step is first along a path to provide alternatives to scatterlist and
> solve some of the abuses and design mistakes, for instance in DMABUF's P2P
> support.

My big concern here is that a thin and vaguely-defined wrapper around 
the IOMMU API is itself a step which smells strongly of "abuse and 
design mistake", given that the basic notion of allocating DMA addresses 
in advance clearly cannot generalise. Thus it really demands some 
considered justification beyond "We must do something; This is 
something; Therefore we must do this." to be convincing.

Thanks,
Robin.

> 
> Thanks
> 
> [1] This still points to v0, as the change is just around handling dma_iova_sync():
> https://lore.kernel.org/all/cover.1730037261.git.leon@kernel.org
> 
> Christoph Hellwig (6):
>    PCI/P2PDMA: Refactor the p2pdma mapping helpers
>    dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
>    iommu: generalize the batched sync after map interface
>    iommu/dma: Factor out a iommu_dma_map_swiotlb helper
>    dma-mapping: add a dma_need_unmap helper
>    docs: core-api: document the IOVA-based API
> 
> Leon Romanovsky (11):
>    dma-mapping: Add check if IOVA can be used
>    dma: Provide an interface to allow allocate IOVA
>    dma-mapping: Implement link/unlink ranges API
>    mm/hmm: let users to tag specific PFN with DMA mapped bit
>    mm/hmm: provide generic DMA managing logic
>    RDMA/umem: Store ODP access mask information in PFN
>    RDMA/core: Convert UMEM ODP DMA mapping to caching IOVA and page
>      linkage
>    RDMA/umem: Separate implicit ODP initialization from explicit ODP
>    vfio/mlx5: Explicitly use number of pages instead of allocated length
>    vfio/mlx5: Rewrite create mkey flow to allow better code reuse
>    vfio/mlx5: Convert vfio to use DMA link API
> 
>   Documentation/core-api/dma-api.rst   |  70 ++++
>   drivers/infiniband/core/umem_odp.c   | 250 +++++----------
>   drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +-
>   drivers/infiniband/hw/mlx5/odp.c     |  65 ++--
>   drivers/infiniband/hw/mlx5/umr.c     |  12 +-
>   drivers/iommu/dma-iommu.c            | 459 +++++++++++++++++++++++----
>   drivers/iommu/iommu.c                |  65 ++--
>   drivers/pci/p2pdma.c                 |  38 +--
>   drivers/vfio/pci/mlx5/cmd.c          | 373 +++++++++++-----------
>   drivers/vfio/pci/mlx5/cmd.h          |  35 +-
>   drivers/vfio/pci/mlx5/main.c         |  87 +++--
>   include/linux/dma-map-ops.h          |  54 ----
>   include/linux/dma-mapping.h          |  85 +++++
>   include/linux/hmm-dma.h              |  32 ++
>   include/linux/hmm.h                  |  16 +
>   include/linux/iommu.h                |   4 +
>   include/linux/pci-p2pdma.h           |  84 +++++
>   include/rdma/ib_umem_odp.h           |  25 +-
>   kernel/dma/direct.c                  |  44 +--
>   kernel/dma/mapping.c                 |  20 ++
>   mm/hmm.c                             | 231 +++++++++++++-
>   21 files changed, 1377 insertions(+), 684 deletions(-)
>   create mode 100644 include/linux/hmm-dma.h
> 

