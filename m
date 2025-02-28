Return-Path: <kvm+bounces-39765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2878A4A32D
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 20:55:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46ADC3BCF3B
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 19:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DED6927FE75;
	Fri, 28 Feb 2025 19:54:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF2A27CCE4;
	Fri, 28 Feb 2025 19:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740772460; cv=none; b=bTh0z0Us2A43lhUHFqOb8gmOd/umFsk/1qK8giDQkAE41HecBz7jt290zVaw2LVHO6BhWFxsFOfdIDb9eL0KYfumIuNwPC/9MEKmTqPM1zqR1C7wsSjgFolg+Zi4XqJZUpl9IdFZczfdDvz4eCidVOSMIVokV99Z4xB8sAo67o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740772460; c=relaxed/simple;
	bh=4GkfnwNsKbq/mr/Mi22ZRxvnkRGN0lE29AmS6GLzr1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CYkmiscU+rREnarNSDMsqQ/T2WS9+lBP/0A5XHgNuMyv4UZrorpRqTRpsHyZa3kABXgKOEpomrHXyhhU0RoiwmUFfA7lI8Zl/DDcOIcvfyaFnunZFlVlWz+h+UXoCNExg4brBPpnaJn/qpxE5GGR2Z4/1YEe/VDhKHHE9b8smP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DD0F150C;
	Fri, 28 Feb 2025 11:54:32 -0800 (PST)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 53B2F3F7D8;
	Fri, 28 Feb 2025 11:54:13 -0800 (PST)
Message-ID: <1166a5f5-23cc-4cce-ba40-5e10ad2606de@arm.com>
Date: Fri, 28 Feb 2025 19:54:11 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/17] Provide a new two step DMA mapping API
To: Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Keith Busch <kbusch@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
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
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
 Randy Dunlap <rdunlap@infradead.org>
References: <cover.1738765879.git.leonro@nvidia.com>
 <20250220124827.GR53094@unreal>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20250220124827.GR53094@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/02/2025 12:48 pm, Leon Romanovsky wrote:
> On Wed, Feb 05, 2025 at 04:40:20PM +0200, Leon Romanovsky wrote:
>> From: Leon Romanovsky <leonro@nvidia.com>
>>
>> Changelog:
>> v7:
>>   * Rebased to v6.14-rc1
> 
> <...>
> 
>> Christoph Hellwig (6):
>>    PCI/P2PDMA: Refactor the p2pdma mapping helpers
>>    dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
>>    iommu: generalize the batched sync after map interface
>>    iommu/dma: Factor out a iommu_dma_map_swiotlb helper
>>    dma-mapping: add a dma_need_unmap helper
>>    docs: core-api: document the IOVA-based API
>>
>> Leon Romanovsky (11):
>>    iommu: add kernel-doc for iommu_unmap and iommu_unmap_fast
>>    dma-mapping: Provide an interface to allow allocate IOVA
>>    dma-mapping: Implement link/unlink ranges API
>>    mm/hmm: let users to tag specific PFN with DMA mapped bit
>>    mm/hmm: provide generic DMA managing logic
>>    RDMA/umem: Store ODP access mask information in PFN
>>    RDMA/core: Convert UMEM ODP DMA mapping to caching IOVA and page
>>      linkage
>>    RDMA/umem: Separate implicit ODP initialization from explicit ODP
>>    vfio/mlx5: Explicitly use number of pages instead of allocated length
>>    vfio/mlx5: Rewrite create mkey flow to allow better code reuse
>>    vfio/mlx5: Enable the DMA link API
>>
>>   Documentation/core-api/dma-api.rst   |  70 ++++
>   drivers/infiniband/core/umem_odp.c   | 250 +++++---------
>>   drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +-
>>   drivers/infiniband/hw/mlx5/odp.c     |  65 ++--
>>   drivers/infiniband/hw/mlx5/umr.c     |  12 +-
>>   drivers/iommu/dma-iommu.c            | 468 +++++++++++++++++++++++----
>>   drivers/iommu/iommu.c                |  84 ++---
>>   drivers/pci/p2pdma.c                 |  38 +--
>>   drivers/vfio/pci/mlx5/cmd.c          | 375 +++++++++++----------
>>   drivers/vfio/pci/mlx5/cmd.h          |  35 +-
>>   drivers/vfio/pci/mlx5/main.c         |  87 +++--
>>   include/linux/dma-map-ops.h          |  54 ----
>>   include/linux/dma-mapping.h          |  85 +++++
>>   include/linux/hmm-dma.h              |  33 ++
>>   include/linux/hmm.h                  |  21 ++
>>   include/linux/iommu.h                |   4 +
>>   include/linux/pci-p2pdma.h           |  84 +++++
>>   include/rdma/ib_umem_odp.h           |  25 +-
>>   kernel/dma/direct.c                  |  44 +--
>>   kernel/dma/mapping.c                 |  18 ++
>>   mm/hmm.c                             | 264 +++++++++++++--
>>   21 files changed, 1435 insertions(+), 693 deletions(-)
>>   create mode 100644 include/linux/hmm-dma.h
> 
> Kind reminder.

...that you've simply reposted the same thing again? Without doing 
anything to address the bugs, inconsistencies, fundamental design flaws 
in claiming to be something it cannot possibly be, the egregious abuse 
of DMA_ATTR_SKIP_CPU_SYNC proudly highlighting how unfit-for-purpose the 
most basic part of the whole idea is, nor *still* the complete lack of 
any demonstrable justification of how callers who supposedly can't use 
the IOMMU API actually benefit from adding all the complexity of using 
the IOMMU API in a hat but also still the streaming DMA API as well?

Yeah, consider me reminded.



In case I need to make it any more explicit, NAK to this not-generic 
not-DMA-mapping API, until you can come up with either something which 
*can* actually work in any kind of vaguely generic manner as claimed, or 
instead settle on a reasonable special-case solution for justifiable 
special cases. Bikeshedding and rebasing through half a dozen versions, 
while ignoring fundamental issues I've been pointing out from the very 
beginning, has not somehow magically made this series mature and 
acceptable to merge.

Honestly, given certain other scenarios we may also end up having to 
deal with, if by the time everything broken is taken away, it were to 
end up stripped all the way back to something well-reasoned like:

"Some drivers want more control of their DMA buffer layout than the 
general-purpose IOVA allocator is able to provide though the DMA mapping 
APIs, but also would rather not have to deal with managing an entire 
IOMMU domain and address space, making MSIs work, etc. Expose 
iommu_dma_alloc_iova() and some trivial IOMMU API wrappers to allow 
drivers of coherent devices to claim regions of the default domain 
wherein they can manage their own mappings directly."

...I wouldn't necessarily disagree.

Thanks,
Robin.

