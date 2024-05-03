Return-Path: <kvm+bounces-16500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D39FC8BABF9
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 13:57:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00AFB1C21B88
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 11:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930871534EA;
	Fri,  3 May 2024 11:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qyB1ISae"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FF6152DE8
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 11:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714737430; cv=none; b=jqcg7le2ubZE4k5Lira6Sj5WIC3WT4fGxfYxnkD34s6GvcLVLsmd7MWZC9sHYiTEWpnzxB5Gosm96jUo8bR+4/1Xor5a6Iyofrdwl704M6BWFJDu6bWcKgw76ITZZKxhtU3SkYqcnnmBZYI1w9P724Y0ZR2pgN8NUYt286s0GSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714737430; c=relaxed/simple;
	bh=N1UR76ibJXT6KSmjP9DwgMJEalcANwTRYffmZX8HUPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=illM0FUO26oEuE5ZoA3O+YLZ1P27E8rWI8o8/aXroOElIjh+T7ZA1liMVBE5jcJCEGMBfrQDg1DcwpjwPshUXBJ99pnLjW3EUPxFuseCrNfeN1b45qs3JmE36s1Y95Y+mcNwVjT2MeIWbhQiE6huObBZy42M4iups2BMGJ4ujp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qyB1ISae; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <dcbd4df7-328e-4d28-8098-dca3e8c4f004@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714737425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QBEy7QkEaMvis9qjHZ5cOY4POeQ4rKqY2XsSXuPCu4U=;
	b=qyB1ISae7I/P6hByROK73LSERbiL7NzoQZuWyVzVYXd5DEKcWqZ+01n4/u2G94uRlwKdZg
	pgnNepE8R4vEhrgw3+TI+jbCs12NmD0KobYhO09ypdlc17huPvRqS1WfGm3a/IDhhV2Unp
	wPw01DbGYiFsnIgrK1nDyTpIy9Rx9YU=
Date: Fri, 3 May 2024 13:57:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
To: "Zeng, Oak" <oak.zeng@intel.com>, "leon@kernel.org" <leon@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 "Brost, Matthew" <matthew.brost@intel.com>,
 "Hellstrom, Thomas" <thomas.hellstrom@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 "Tian, Kevin" <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 Bart Van Assche <bvanassche@acm.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Amir Goldstein <amir73il@gmail.com>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "Williams, Dan J" <dan.j.williams@intel.com>, "jack@suse.com"
 <jack@suse.com>, Leon Romanovsky <leonro@nvidia.com>
References: <cover.1709635535.git.leon@kernel.org>
 <SA1PR11MB6991CB2B1398948F4241E51992182@SA1PR11MB6991.namprd11.prod.outlook.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <SA1PR11MB6991CB2B1398948F4241E51992182@SA1PR11MB6991.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 03.05.24 01:32, Zeng, Oak wrote:
> Hi Leon, Jason
>
>> -----Original Message-----
>> From: Leon Romanovsky <leon@kernel.org>
>> Sent: Tuesday, March 5, 2024 6:19 AM
>> To: Christoph Hellwig <hch@lst.de>; Robin Murphy
>> <robin.murphy@arm.com>; Marek Szyprowski
>> <m.szyprowski@samsung.com>; Joerg Roedel <joro@8bytes.org>; Will
>> Deacon <will@kernel.org>; Jason Gunthorpe <jgg@ziepe.ca>; Chaitanya
>> Kulkarni <chaitanyak@nvidia.com>
>> Cc: Jonathan Corbet <corbet@lwn.net>; Jens Axboe <axboe@kernel.dk>;
>> Keith Busch <kbusch@kernel.org>; Sagi Grimberg <sagi@grimberg.me>;
>> Yishai Hadas <yishaih@nvidia.com>; Shameer Kolothum
>> <shameerali.kolothum.thodi@huawei.com>; Kevin Tian
>> <kevin.tian@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
>> Jérôme Glisse <jglisse@redhat.com>; Andrew Morton <akpm@linux-
>> foundation.org>; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linux-block@vger.kernel.org; linux-rdma@vger.kernel.org;
>> iommu@lists.linux.dev; linux-nvme@lists.infradead.org;
>> kvm@vger.kernel.org; linux-mm@kvack.org; Bart Van Assche
>> <bvanassche@acm.org>; Damien Le Moal
>> <damien.lemoal@opensource.wdc.com>; Amir Goldstein
>> <amir73il@gmail.com>; josef@toxicpanda.com; Martin K. Petersen
>> <martin.petersen@oracle.com>; daniel@iogearbox.net; Dan Williams
>> <dan.j.williams@intel.com>; jack@suse.com; Leon Romanovsky
>> <leonro@nvidia.com>; Zhu Yanjun <zyjzyj2000@gmail.com>
>> Subject: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two
>> steps
>>
>> This is complimentary part to the proposed LSF/MM topic.
>> https://lore.kernel.org/linux-rdma/22df55f8-cf64-4aa8-8c0b-
>> b556c867b926@linux.dev/T/#m85672c860539fdbbc8fe0f5ccabdc05b40269057
>>
>> This is posted as RFC to get a feedback on proposed split, but RDMA, VFIO
>> and
>> DMA patches are ready for review and inclusion, the NVMe patches are still
>> in
>> progress as they require agreement on API first.
>>
>> Thanks
>>
>> -------------------------------------------------------------------------------
>> The DMA mapping operation performs two steps at one same time: allocates
>> IOVA space and actually maps DMA pages to that space. This one shot
>> operation works perfectly for non-complex scenarios, where callers use
>> that DMA API in control path when they setup hardware.
>>
>> However in more complex scenarios, when DMA mapping is needed in data
>> path and especially when some sort of specific datatype is involved,
>> such one shot approach has its drawbacks.
>>
>> That approach pushes developers to introduce new DMA APIs for specific
>> datatype. For example existing scatter-gather mapping functions, or
>> latest Chuck's RFC series to add biovec related DMA mapping [1] and
>> probably struct folio will need it too.
>>
>> These advanced DMA mapping APIs are needed to calculate IOVA size to
>> allocate it as one chunk and some sort of offset calculations to know
>> which part of IOVA to map.
>>
>> Instead of teaching DMA to know these specific datatypes, let's separate
>> existing DMA mapping routine to two steps and give an option to advanced
>> callers (subsystems) perform all calculations internally in advance and
>> map pages later when it is needed.
> I looked into how this scheme can be applied to DRM subsystem and GPU drivers.
>
> I figured RDMA can apply this scheme because RDMA can calculate the iova size. Per my limited knowledge of rdma, user can register a memory region (the reg_user_mr vfunc) and memory region's sized is used to pre-allocate iova space. And in the RDMA use case, it seems the user registered region can be very big, e.g., 512MiB or even GiB
>
> In GPU driver, we have a few use cases where we need dma-mapping. Just name two:
>
> 1) userptr: it is user malloc'ed/mmap'ed memory and registers to gpu (in Intel's driver it is through a vm_bind api, similar to mmap). A userptr can be of any random size, depending on user malloc size. Today we use dma-map-sg for this use case. The down side of our approach is, during userptr invalidation, even if user only munmap partially of an userptr, we invalidate the whole userptr from gpu page table, because there is no way for us to partially dma-unmap the whole sg list. I think we can try your new API in this case. The main benefit of the new approach is the partial munmap case.
>
> We will have to pre-allocate iova for each userptr, and we have many userptrs of random size... So we might be not as efficient as RDMA case where I assume user register a few big memory regions.
>
> 2) system allocator: it is malloc'ed/mmap'ed memory be used for GPU program directly, without any other extra driver API call. We call this use case system allocator.
>
> For system allocator, driver have no knowledge of which virtual address range is valid in advance. So when GPU access a malloc'ed/mmap'ed address, we have a page fault. We then look up a CPU vma which contains the fault address. I guess we can use the CPU vma size to allocate the iova space of the same size?
>
> But there will be a true difficulty to apply your scheme to this use case. It is related to the STICKY flag. As I understand it, the sticky flag is designed for driver to mark "this page/pfn has been populated, no need to re-populate again", roughly...Unlike userptr and RDMA use cases where the backing store of a buffer is always in system memory, in the system allocator use case, the backing store can be changing b/t system memory and GPU's device private memory. Even worse, we have to assume the data migration b/t system and GPU is dynamic. When data is migrated to GPU, we don't need dma-map. And when migration happens to a pfn with STICKY flag, we still need to repopulate this pfn. So you can see, it is not easy to apply this scheme to this use case. At least I can't see an obvious way.

Not sure if GPU peer to peer dma mapping GPU memory for use can use this 
scheme or not. If I remember it correctly, Intel Gaudi GPU supports peer 
2 peer dma mapping in GPU Direct RDMA. Not sure if this scheme can be 
applied in that place or not.

Just my 2 cent suggestions.

Zhu Yanjun

>
>
> Oak
>
>
>> In this series, three users are converted and each of such conversion
>> presents different positive gain:
>> 1. RDMA simplifies and speeds up its pagefault handling for
>>     on-demand-paging (ODP) mode.
>> 2. VFIO PCI live migration code saves huge chunk of memory.
>> 3. NVMe PCI avoids intermediate SG table manipulation and operates
>>     directly on BIOs.
>>
>> Thanks
>>
>> [1]
>> https://lore.kernel.org/all/169772852492.5232.17148564580779995849.stgit@
>> klimt.1015granger.net
>>
>> Chaitanya Kulkarni (2):
>>    block: add dma_link_range() based API
>>    nvme-pci: use blk_rq_dma_map() for NVMe SGL
>>
>> Leon Romanovsky (14):
>>    mm/hmm: let users to tag specific PFNs
>>    dma-mapping: provide an interface to allocate IOVA
>>    dma-mapping: provide callbacks to link/unlink pages to specific IOVA
>>    iommu/dma: Provide an interface to allow preallocate IOVA
>>    iommu/dma: Prepare map/unmap page functions to receive IOVA
>>    iommu/dma: Implement link/unlink page callbacks
>>    RDMA/umem: Preallocate and cache IOVA for UMEM ODP
>>    RDMA/umem: Store ODP access mask information in PFN
>>    RDMA/core: Separate DMA mapping to caching IOVA and page linkage
>>    RDMA/umem: Prevent UMEM ODP creation with SWIOTLB
>>    vfio/mlx5: Explicitly use number of pages instead of allocated length
>>    vfio/mlx5: Rewrite create mkey flow to allow better code reuse
>>    vfio/mlx5: Explicitly store page list
>>    vfio/mlx5: Convert vfio to use DMA link API
>>
>>   Documentation/core-api/dma-attributes.rst |   7 +
>>   block/blk-merge.c                         | 156 ++++++++++++++
>>   drivers/infiniband/core/umem_odp.c        | 219 +++++++------------
>>   drivers/infiniband/hw/mlx5/mlx5_ib.h      |   1 +
>>   drivers/infiniband/hw/mlx5/odp.c          |  59 +++--
>>   drivers/iommu/dma-iommu.c                 | 129 ++++++++---
>>   drivers/nvme/host/pci.c                   | 220 +++++--------------
>>   drivers/vfio/pci/mlx5/cmd.c               | 252 ++++++++++++----------
>>   drivers/vfio/pci/mlx5/cmd.h               |  22 +-
>>   drivers/vfio/pci/mlx5/main.c              | 136 +++++-------
>>   include/linux/blk-mq.h                    |   9 +
>>   include/linux/dma-map-ops.h               |  13 ++
>>   include/linux/dma-mapping.h               |  39 ++++
>>   include/linux/hmm.h                       |   3 +
>>   include/rdma/ib_umem_odp.h                |  22 +-
>>   include/rdma/ib_verbs.h                   |  54 +++++
>>   kernel/dma/debug.h                        |   2 +
>>   kernel/dma/direct.h                       |   7 +-
>>   kernel/dma/mapping.c                      |  91 ++++++++
>>   mm/hmm.c                                  |  34 +--
>>   20 files changed, 870 insertions(+), 605 deletions(-)
>>
>> --
>> 2.44.0

-- 
Best Regards,
Yanjun.Zhu


