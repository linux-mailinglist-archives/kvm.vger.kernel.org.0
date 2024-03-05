Return-Path: <kvm+bounces-10976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37FBF871E8A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:05:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2BD71F251E6
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 12:05:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFD8C5A4CF;
	Tue,  5 Mar 2024 12:05:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E6C58ABA;
	Tue,  5 Mar 2024 12:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709640336; cv=none; b=X9FyCIb+218qnTcXxkOd4PuVScCiELc6MjB43ORIzUto+o3hHlXWCgs42Niq/JKqw6sqjAlR5Un7Pwqw8dnQbQ25mgjsvIXRtyGDNDvDhe1Q+aca1Mb+R9x/eJQAefhvu03vIX3z3RAO5XYSidxJNzUDOHm9uPuRwY/OnQOy6n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709640336; c=relaxed/simple;
	bh=x2n3LYJaF3CcKkOqy6N20V4juYYDI/bsFT9DQVqOTOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D+Nh44t8NJJBLBfoLiBVzRqhbTpPnXGf4anvYwOwUnqZ50ca4359/gUFyXsE/wme1mSeUCh4Bu4Ht1NHk1+c04u+lzXEjhzYpfDF4aceIvgUUMrOCuTLbDDjf0hqSGoDVMDsMY4djSUA3xFNzGp0BIwvBk5bZPO5mZkVZy796L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A49DE1FB;
	Tue,  5 Mar 2024 04:06:08 -0800 (PST)
Received: from [10.57.67.228] (unknown [10.57.67.228])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 25B763F73F;
	Tue,  5 Mar 2024 04:05:25 -0800 (PST)
Message-ID: <47afacda-3023-4eb7-b227-5f725c3187c2@arm.com>
Date: Tue, 5 Mar 2024 12:05:23 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
To: Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 linux-nvme@lists.infradead.org, kvm@vger.kernel.org, linux-mm@kvack.org,
 Bart Van Assche <bvanassche@acm.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Amir Goldstein <amir73il@gmail.com>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 Dan Williams <dan.j.williams@intel.com>, "jack@suse.com" <jack@suse.com>,
 Leon Romanovsky <leonro@nvidia.com>, Zhu Yanjun <zyjzyj2000@gmail.com>
References: <cover.1709635535.git.leon@kernel.org>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <cover.1709635535.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-03-05 11:18 am, Leon Romanovsky wrote:
> This is complimentary part to the proposed LSF/MM topic.
> https://lore.kernel.org/linux-rdma/22df55f8-cf64-4aa8-8c0b-b556c867b926@linux.dev/T/#m85672c860539fdbbc8fe0f5ccabdc05b40269057
> 
> This is posted as RFC to get a feedback on proposed split, but RDMA, VFIO and
> DMA patches are ready for review and inclusion, the NVMe patches are still in
> progress as they require agreement on API first.
> 
> Thanks
> 
> -------------------------------------------------------------------------------
> The DMA mapping operation performs two steps at one same time: allocates
> IOVA space and actually maps DMA pages to that space. This one shot
> operation works perfectly for non-complex scenarios, where callers use
> that DMA API in control path when they setup hardware.
> 
> However in more complex scenarios, when DMA mapping is needed in data
> path and especially when some sort of specific datatype is involved,
> such one shot approach has its drawbacks.
> 
> That approach pushes developers to introduce new DMA APIs for specific
> datatype. For example existing scatter-gather mapping functions, or
> latest Chuck's RFC series to add biovec related DMA mapping [1] and
> probably struct folio will need it too.
> 
> These advanced DMA mapping APIs are needed to calculate IOVA size to
> allocate it as one chunk and some sort of offset calculations to know
> which part of IOVA to map.

I don't follow this part at all - at *some* point, something must know a 
range of memory addresses involved in a DMA transfer, so that's where it 
should map that range for DMA. Even in a badly-designed system where the 
point it's most practical to make the mapping is further out and only 
knows that DMA will touch some subset of a buffer, but doesn't know 
exactly what subset yet, you'd usually just map the whole buffer. I 
don't see why the DMA API would ever need to know about anything other 
than pages/PFNs and dma_addr_ts (yes, it does also accept them being 
wrapped together in scatterlists; yes, scatterlists are awful and it 
would be nice to replace them with a better general DMA descriptor; that 
is a whole other subject of its own).

> Instead of teaching DMA to know these specific datatypes, let's separate
> existing DMA mapping routine to two steps and give an option to advanced
> callers (subsystems) perform all calculations internally in advance and
> map pages later when it is needed.

 From a brief look, this is clearly an awkward reinvention of the IOMMU 
API. If IOMMU-aware drivers/subsystems want to explicitly manage IOMMU 
address spaces then they can and should use the IOMMU API. Perhaps 
there's room for some quality-of-life additions to the IOMMU API to help 
with common usage patterns, but the generic DMA mapping API is 
absolutely not the place for it.

Thanks,
Robin.

> In this series, three users are converted and each of such conversion
> presents different positive gain:
> 1. RDMA simplifies and speeds up its pagefault handling for
>     on-demand-paging (ODP) mode.
> 2. VFIO PCI live migration code saves huge chunk of memory.
> 3. NVMe PCI avoids intermediate SG table manipulation and operates
>     directly on BIOs.
> 
> Thanks
> 
> [1] https://lore.kernel.org/all/169772852492.5232.17148564580779995849.stgit@klimt.1015granger.net
> 
> Chaitanya Kulkarni (2):
>    block: add dma_link_range() based API
>    nvme-pci: use blk_rq_dma_map() for NVMe SGL
> 
> Leon Romanovsky (14):
>    mm/hmm: let users to tag specific PFNs
>    dma-mapping: provide an interface to allocate IOVA
>    dma-mapping: provide callbacks to link/unlink pages to specific IOVA
>    iommu/dma: Provide an interface to allow preallocate IOVA
>    iommu/dma: Prepare map/unmap page functions to receive IOVA
>    iommu/dma: Implement link/unlink page callbacks
>    RDMA/umem: Preallocate and cache IOVA for UMEM ODP
>    RDMA/umem: Store ODP access mask information in PFN
>    RDMA/core: Separate DMA mapping to caching IOVA and page linkage
>    RDMA/umem: Prevent UMEM ODP creation with SWIOTLB
>    vfio/mlx5: Explicitly use number of pages instead of allocated length
>    vfio/mlx5: Rewrite create mkey flow to allow better code reuse
>    vfio/mlx5: Explicitly store page list
>    vfio/mlx5: Convert vfio to use DMA link API
> 
>   Documentation/core-api/dma-attributes.rst |   7 +
>   block/blk-merge.c                         | 156 ++++++++++++++
>   drivers/infiniband/core/umem_odp.c        | 219 +++++++------------
>   drivers/infiniband/hw/mlx5/mlx5_ib.h      |   1 +
>   drivers/infiniband/hw/mlx5/odp.c          |  59 +++--
>   drivers/iommu/dma-iommu.c                 | 129 ++++++++---
>   drivers/nvme/host/pci.c                   | 220 +++++--------------
>   drivers/vfio/pci/mlx5/cmd.c               | 252 ++++++++++++----------
>   drivers/vfio/pci/mlx5/cmd.h               |  22 +-
>   drivers/vfio/pci/mlx5/main.c              | 136 +++++-------
>   include/linux/blk-mq.h                    |   9 +
>   include/linux/dma-map-ops.h               |  13 ++
>   include/linux/dma-mapping.h               |  39 ++++
>   include/linux/hmm.h                       |   3 +
>   include/rdma/ib_umem_odp.h                |  22 +-
>   include/rdma/ib_verbs.h                   |  54 +++++
>   kernel/dma/debug.h                        |   2 +
>   kernel/dma/direct.h                       |   7 +-
>   kernel/dma/mapping.c                      |  91 ++++++++
>   mm/hmm.c                                  |  34 +--
>   20 files changed, 870 insertions(+), 605 deletions(-)
> 

