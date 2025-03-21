Return-Path: <kvm+bounces-41659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE0DAA6BC0E
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 14:52:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 431884623C1
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 13:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 686EB80C02;
	Fri, 21 Mar 2025 13:52:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AA0417741;
	Fri, 21 Mar 2025 13:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742565127; cv=none; b=PG4HyjrhZj/EmMxfVb1k1V+G5Rdx4R6PF+ZI95Z+mRmulQr3Hf3y2RpNWlTjYmZ52uY1eZoq8V6wdjAHPtI+59RVs79qC5sOXYMjOn1qjUybvyS26AvGfbu9xcumZLa4xhypC9KlO9f/Dokh2StI75XAoFI1o6a/+3f9D+JgEa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742565127; c=relaxed/simple;
	bh=pkg+CNKx3vciyRK561CUgBnHgYjht9lrfmsH7bML4JY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ms4fmmnOJ4viL3+cTqRa//ZQmeHy69odu3dIWZMVfXwm7RcKMEWskzCQ2lySxOupNbAJvx6gf+C3IRQprlqQg7BNpeWjrYjlIDKiVg+PrgB1huuDZbA2O49N+fUJ5Y3Wd60EAOcZjwR0Njj3f1t9Dp14OzN9BKgzac67st3NP8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BAF99113E;
	Fri, 21 Mar 2025 06:52:12 -0700 (PDT)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3328E3F673;
	Fri, 21 Mar 2025 06:52:02 -0700 (PDT)
Message-ID: <d64a40d9-0c5b-45b6-a95c-d428a4dd9640@arm.com>
Date: Fri, 21 Mar 2025 13:52:00 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/17] Provide a new two step DMA mapping API
To: Marek Szyprowski <m.szyprowski@samsung.com>,
 Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Keith Busch <kbusch@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
 iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
 Randy Dunlap <rdunlap@infradead.org>
References: <cover.1738765879.git.leonro@nvidia.com>
 <20250220124827.GR53094@unreal>
 <CGME20250228195423eucas1p221736d964e9aeb1b055d3ee93a4d2648@eucas1p2.samsung.com>
 <1166a5f5-23cc-4cce-ba40-5e10ad2606de@arm.com>
 <d408b1c7-eabf-4a1e-861c-b2ddf8bf9f0e@samsung.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <d408b1c7-eabf-4a1e-861c-b2ddf8bf9f0e@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/03/2025 9:28 am, Marek Szyprowski wrote:
> Hi Robin
> 
> On 28.02.2025 20:54, Robin Murphy wrote:
>> On 20/02/2025 12:48 pm, Leon Romanovsky wrote:
>>> On Wed, Feb 05, 2025 at 04:40:20PM +0200, Leon Romanovsky wrote:
>>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>>
>>>> Changelog:
>>>> v7:
>>>>    * Rebased to v6.14-rc1
>>>
>>> <...>
>>>
>>>> Christoph Hellwig (6):
>>>>     PCI/P2PDMA: Refactor the p2pdma mapping helpers
>>>>     dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
>>>>     iommu: generalize the batched sync after map interface
>>>>     iommu/dma: Factor out a iommu_dma_map_swiotlb helper
>>>>     dma-mapping: add a dma_need_unmap helper
>>>>     docs: core-api: document the IOVA-based API
>>>>
>>>> Leon Romanovsky (11):
>>>>     iommu: add kernel-doc for iommu_unmap and iommu_unmap_fast
>>>>     dma-mapping: Provide an interface to allow allocate IOVA
>>>>     dma-mapping: Implement link/unlink ranges API
>>>>     mm/hmm: let users to tag specific PFN with DMA mapped bit
>>>>     mm/hmm: provide generic DMA managing logic
>>>>     RDMA/umem: Store ODP access mask information in PFN
>>>>     RDMA/core: Convert UMEM ODP DMA mapping to caching IOVA and page
>>>>       linkage
>>>>     RDMA/umem: Separate implicit ODP initialization from explicit ODP
>>>>     vfio/mlx5: Explicitly use number of pages instead of allocated
>>>> length
>>>>     vfio/mlx5: Rewrite create mkey flow to allow better code reuse
>>>>     vfio/mlx5: Enable the DMA link API
>>>>
>>>>    Documentation/core-api/dma-api.rst   |  70 ++++
>>>    drivers/infiniband/core/umem_odp.c   | 250 +++++---------
>>>>    drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +-
>>>>    drivers/infiniband/hw/mlx5/odp.c     |  65 ++--
>>>>    drivers/infiniband/hw/mlx5/umr.c     |  12 +-
>>>>    drivers/iommu/dma-iommu.c            | 468
>>>> +++++++++++++++++++++++----
>>>>    drivers/iommu/iommu.c                |  84 ++---
>>>>    drivers/pci/p2pdma.c                 |  38 +--
>>>>    drivers/vfio/pci/mlx5/cmd.c          | 375 +++++++++++----------
>>>>    drivers/vfio/pci/mlx5/cmd.h          |  35 +-
>>>>    drivers/vfio/pci/mlx5/main.c         |  87 +++--
>>>>    include/linux/dma-map-ops.h          |  54 ----
>>>>    include/linux/dma-mapping.h          |  85 +++++
>>>>    include/linux/hmm-dma.h              |  33 ++
>>>>    include/linux/hmm.h                  |  21 ++
>>>>    include/linux/iommu.h                |   4 +
>>>>    include/linux/pci-p2pdma.h           |  84 +++++
>>>>    include/rdma/ib_umem_odp.h           |  25 +-
>>>>    kernel/dma/direct.c                  |  44 +--
>>>>    kernel/dma/mapping.c                 |  18 ++
>>>>    mm/hmm.c                             | 264 +++++++++++++--
>>>>    21 files changed, 1435 insertions(+), 693 deletions(-)
>>>>    create mode 100644 include/linux/hmm-dma.h
>>>
>>> Kind reminder.
>>
>> ...that you've simply reposted the same thing again? Without doing
>> anything to address the bugs, inconsistencies, fundamental design
>> flaws in claiming to be something it cannot possibly be, the egregious
>> abuse of DMA_ATTR_SKIP_CPU_SYNC proudly highlighting how
>> unfit-for-purpose the most basic part of the whole idea is, nor
>> *still* the complete lack of any demonstrable justification of how
>> callers who supposedly can't use the IOMMU API actually benefit from
>> adding all the complexity of using the IOMMU API in a hat but also
>> still the streaming DMA API as well?
>>
>> Yeah, consider me reminded.
>>
>>
>>
>> In case I need to make it any more explicit, NAK to this not-generic
>> not-DMA-mapping API, until you can come up with either something which
>> *can* actually work in any kind of vaguely generic manner as claimed,
>> or instead settle on a reasonable special-case solution for
>> justifiable special cases. Bikeshedding and rebasing through half a
>> dozen versions, while ignoring fundamental issues I've been pointing
>> out from the very beginning, has not somehow magically made this
>> series mature and acceptable to merge.
>>
>> Honestly, given certain other scenarios we may also end up having to
>> deal with, if by the time everything broken is taken away, it were to
>> end up stripped all the way back to something well-reasoned like:
>>
>> "Some drivers want more control of their DMA buffer layout than the
>> general-purpose IOVA allocator is able to provide though the DMA
>> mapping APIs, but also would rather not have to deal with managing an
>> entire IOMMU domain and address space, making MSIs work, etc. Expose
>> iommu_dma_alloc_iova() and some trivial IOMMU API wrappers to allow
>> drivers of coherent devices to claim regions of the default domain
>> wherein they can manage their own mappings directly."
>>
>> ...I wouldn't necessarily disagree.
> 
> 
> Well, this is definitely not a review I've expected. I admit that I
> wasn't involved in this proposal nor the discussion about it and I
> wasn't able to devote enough time for keeping myself up to date. Now
> I've tried to read all the required backlog and I must admit that this
> was quite demanding.
> 
> If You didn't like this design from the beginning, then please state
> that early instead of pointing random minor issues in the code. There
> have been plenty of time to discuss the overall approach if You think it
> was wrong.

You mean like if a year ago I'd said "this is clearly an awkward 
reinvention of the IOMMU API" of the very first RFC, and then continued 
to point out specific and general concerns with both the design and 
implementation on the v1 posting in October, and then again on 
subsequent versions? Oh yeah right that's exactly what I did do...

The fact that the issues summarised above are *still* present in v7 is 
not for lack of me pointing them out. And there is no obligation for 
maintainers to accept code with obvious significant issues just because 
they don't have the time or inclination to personally engage in trying 
to fix said issues.

Thanks,
Robin.

