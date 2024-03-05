Return-Path: <kvm+bounces-10978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B44B871F38
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:30:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EC2D1C2534E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 12:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF9F65B21C;
	Tue,  5 Mar 2024 12:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edE9W4ex"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ABA5A4C0;
	Tue,  5 Mar 2024 12:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709641780; cv=none; b=hfYNNUReNlZMXRZxX7n+9ff5ePUYIFOeRNJ8GMdEs3H9zzy+kyaZ3isQJxiQMRtBUHfCrhvUjQEX/uLDEdb0tMg8UJdHEWs0sKGCEOnAnFdjRJz2/EjNtMYAOt50jNj8GPDKNIne5VPU/POin1oodQSoLmnx7XedopnZKt6fwbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709641780; c=relaxed/simple;
	bh=P93hlccw+xdxdbFmx+6Lr6WNHOyANq8FCYqtCUP40hE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZrRZobJVkqLI6tkAw6zoFQ1Er+LgswJYKbECr2TeydSJK4T3yADjX+fOdGgUbgsUGWQpIKoOocd9PCW9Moq+d8RRtt9DkjIRMU5vLZzfoulBJmm5/p4OF7U1ECFXd6RaWwlP1qdVefOxy6qb4zEexBOJzjkF+9dukApA8zwXY4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=edE9W4ex; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE6CC43394;
	Tue,  5 Mar 2024 12:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709641780;
	bh=P93hlccw+xdxdbFmx+6Lr6WNHOyANq8FCYqtCUP40hE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=edE9W4exQ/mLyQoFZ0ecW6HlLDr9Z099WMeUuaFujQg2FZTZLAQnGDjK498JWa0ni
	 hqFMO5hIGroOgoA/TTNGplduxItE+LvgFwOBWjD33xVKfmTFkJ5U+9CtOOpdfL7udr
	 qhAc/itUetIkKuPj6Jv0+bNurWlOja/yk+vF05wSc8ytz4RcHmc2Kw2jU+9t5qdqtK
	 2MmLJphfTq56uO+Iq2YwNgSXMY5Hs5aBypVWlDYoEFPocQlvJgPL/m9HUD+GamQVTE
	 DFv6scJ4w1oMC0aHDm5eYXuKeZW4m+eUbOnkHeJ/XxbIduCTrPWiF//VLFhaMH4KXv
	 NmAjytaBBw2hw==
Date: Tue, 5 Mar 2024 14:29:35 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"jack@suse.com" <jack@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
Message-ID: <20240305122935.GB36868@unreal>
References: <cover.1709635535.git.leon@kernel.org>
 <47afacda-3023-4eb7-b227-5f725c3187c2@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47afacda-3023-4eb7-b227-5f725c3187c2@arm.com>

On Tue, Mar 05, 2024 at 12:05:23PM +0000, Robin Murphy wrote:
> On 2024-03-05 11:18 am, Leon Romanovsky wrote:
> > This is complimentary part to the proposed LSF/MM topic.
> > https://lore.kernel.org/linux-rdma/22df55f8-cf64-4aa8-8c0b-b556c867b926@linux.dev/T/#m85672c860539fdbbc8fe0f5ccabdc05b40269057
> > 
> > This is posted as RFC to get a feedback on proposed split, but RDMA, VFIO and
> > DMA patches are ready for review and inclusion, the NVMe patches are still in
> > progress as they require agreement on API first.
> > 
> > Thanks
> > 
> > -------------------------------------------------------------------------------
> > The DMA mapping operation performs two steps at one same time: allocates
> > IOVA space and actually maps DMA pages to that space. This one shot
> > operation works perfectly for non-complex scenarios, where callers use
> > that DMA API in control path when they setup hardware.
> > 
> > However in more complex scenarios, when DMA mapping is needed in data
> > path and especially when some sort of specific datatype is involved,
> > such one shot approach has its drawbacks.
> > 
> > That approach pushes developers to introduce new DMA APIs for specific
> > datatype. For example existing scatter-gather mapping functions, or
> > latest Chuck's RFC series to add biovec related DMA mapping [1] and
> > probably struct folio will need it too.
> > 
> > These advanced DMA mapping APIs are needed to calculate IOVA size to
> > allocate it as one chunk and some sort of offset calculations to know
> > which part of IOVA to map.
> 
> I don't follow this part at all - at *some* point, something must know a
> range of memory addresses involved in a DMA transfer, so that's where it
> should map that range for DMA. 

In all presented cases in this series, the overall DMA size is known in
advance. In RDMA case, it is known when user registers the memory, in
VFIO, when live migration is happening and in NVMe, when BIO is created.

So once we allocated IOVA, we will need to link ranges, which si the
same as map but without IOVA allocation.

> Even in a badly-designed system where the
> point it's most practical to make the mapping is further out and only knows
> that DMA will touch some subset of a buffer, but doesn't know exactly what
> subset yet, you'd usually just map the whole buffer. I don't see why the DMA
> API would ever need to know about anything other than pages/PFNs and
> dma_addr_ts (yes, it does also accept them being wrapped together in
> scatterlists; yes, scatterlists are awful and it would be nice to replace
> them with a better general DMA descriptor; that is a whole other subject of
> its own).

This is exactly what was done here, we got rid of scatterlists.

> 
> > Instead of teaching DMA to know these specific datatypes, let's separate
> > existing DMA mapping routine to two steps and give an option to advanced
> > callers (subsystems) perform all calculations internally in advance and
> > map pages later when it is needed.
> 
> From a brief look, this is clearly an awkward reinvention of the IOMMU API.
> If IOMMU-aware drivers/subsystems want to explicitly manage IOMMU address
> spaces then they can and should use the IOMMU API. Perhaps there's room for
> some quality-of-life additions to the IOMMU API to help with common usage
> patterns, but the generic DMA mapping API is absolutely not the place for
> it.

DMA mapping gives nice abstraction from IOMMU, and allows us to have
same flow for IOMMU and non-IOMMU flows without duplicating code, while
you suggest to teach almost every part in the kernel to know about IOMMU.

In this series, we changed RDMA, VFIO and NVMe, and in all cases we
removed more code than added. From what I saw, VDPA and virito-blk will
benefit from proposed API too.

Even in this RFC, where Chaitanya did partial job and didn't convert
whole driver, the gain is pretty obvious:
https://lore.kernel.org/linux-rdma/016fc02cbfa9be3c156a6f74df38def1e09c08f1.1709635535.git.leon@kernel.org/T/#u

 drivers/nvme/host/pci.c | 220 ++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------------------------------------------------------------------------------------------
 1 file changed, 49 insertions(+), 171 deletions(-)


Thanks

> 
> Thanks,
> Robin.
> 
> > In this series, three users are converted and each of such conversion
> > presents different positive gain:
> > 1. RDMA simplifies and speeds up its pagefault handling for
> >     on-demand-paging (ODP) mode.
> > 2. VFIO PCI live migration code saves huge chunk of memory.
> > 3. NVMe PCI avoids intermediate SG table manipulation and operates
> >     directly on BIOs.
> > 
> > Thanks
> > 
> > [1] https://lore.kernel.org/all/169772852492.5232.17148564580779995849.stgit@klimt.1015granger.net
> > 
> > Chaitanya Kulkarni (2):
> >    block: add dma_link_range() based API
> >    nvme-pci: use blk_rq_dma_map() for NVMe SGL
> > 
> > Leon Romanovsky (14):
> >    mm/hmm: let users to tag specific PFNs
> >    dma-mapping: provide an interface to allocate IOVA
> >    dma-mapping: provide callbacks to link/unlink pages to specific IOVA
> >    iommu/dma: Provide an interface to allow preallocate IOVA
> >    iommu/dma: Prepare map/unmap page functions to receive IOVA
> >    iommu/dma: Implement link/unlink page callbacks
> >    RDMA/umem: Preallocate and cache IOVA for UMEM ODP
> >    RDMA/umem: Store ODP access mask information in PFN
> >    RDMA/core: Separate DMA mapping to caching IOVA and page linkage
> >    RDMA/umem: Prevent UMEM ODP creation with SWIOTLB
> >    vfio/mlx5: Explicitly use number of pages instead of allocated length
> >    vfio/mlx5: Rewrite create mkey flow to allow better code reuse
> >    vfio/mlx5: Explicitly store page list
> >    vfio/mlx5: Convert vfio to use DMA link API
> > 
> >   Documentation/core-api/dma-attributes.rst |   7 +
> >   block/blk-merge.c                         | 156 ++++++++++++++
> >   drivers/infiniband/core/umem_odp.c        | 219 +++++++------------
> >   drivers/infiniband/hw/mlx5/mlx5_ib.h      |   1 +
> >   drivers/infiniband/hw/mlx5/odp.c          |  59 +++--
> >   drivers/iommu/dma-iommu.c                 | 129 ++++++++---
> >   drivers/nvme/host/pci.c                   | 220 +++++--------------
> >   drivers/vfio/pci/mlx5/cmd.c               | 252 ++++++++++++----------
> >   drivers/vfio/pci/mlx5/cmd.h               |  22 +-
> >   drivers/vfio/pci/mlx5/main.c              | 136 +++++-------
> >   include/linux/blk-mq.h                    |   9 +
> >   include/linux/dma-map-ops.h               |  13 ++
> >   include/linux/dma-mapping.h               |  39 ++++
> >   include/linux/hmm.h                       |   3 +
> >   include/rdma/ib_umem_odp.h                |  22 +-
> >   include/rdma/ib_verbs.h                   |  54 +++++
> >   kernel/dma/debug.h                        |   2 +
> >   kernel/dma/direct.h                       |   7 +-
> >   kernel/dma/mapping.c                      |  91 ++++++++
> >   mm/hmm.c                                  |  34 +--
> >   20 files changed, 870 insertions(+), 605 deletions(-)
> > 

