Return-Path: <kvm+bounces-44685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE957AA024B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC992188BF30
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A12F12749CA;
	Tue, 29 Apr 2025 06:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cs3CrsLt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F1126B080;
	Tue, 29 Apr 2025 06:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745906548; cv=none; b=cYY/L798EkIapnix4QJ2OB9X98jaI5HKFOGCuPaeTF64zKQrRQobQMDaP3LsqKrENOSEAqMFtRlYV5M9Q+Ki1sm2caqSbWqwOIAgdD+e6NXHkhCf0YrbEE0uIPetXqiYitLm/1Ze2UrPS1WbHsCMCKg06n9rJo2cdy/S2muwRe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745906548; c=relaxed/simple;
	bh=GGOZBkZPXbXcgYWtmEjaWNBSh9vK7IAgAJHtHjY5RGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZIdmHQr9b/kI9OHjJ0pCs5hUD4OPdUYJEtLx2cPVlva5vwnbzk8FqbkMrqfeb2eEz/GpbKwDCp90gKsYvO6TiKHu6POwytSobGj0JDbhLGdzj6ByPk3Yw+lAJbhwRwOri/i0ONrZcfVwTWh2RQfECnlFc/VPojFqjCfRh+rdLME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cs3CrsLt; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745906547; x=1777442547;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GGOZBkZPXbXcgYWtmEjaWNBSh9vK7IAgAJHtHjY5RGk=;
  b=cs3CrsLtcywzIDWhehr2+2I0xo1z0iAcY6R3d9NMyFBcaxisWpP/tOyM
   q2+TRmM0GZu2gcR5WRVsVZK30l2HpZo8rKmvE0QKaMINpSa6cVN97ACd6
   Gy2nSrVFPKouz1NWobSG2arMop28f3L/vqjARyA/WFTHa/mrpl3vv2bvU
   60Jn31frNVHAlYfGqyycmtiMteyUgDRuq5WkGQGX60hjRAU7GHeYbODR2
   dLtlcq+8CCUSWvQ7aZibQdHESYAHcSB50nOG0Tb9Q0QBaaQ/MPR0DOSwC
   kLgq3KKqP3o88egOFFxVkTaN+f24TCN3fypqlqFiUoARH2PP6FNaAB0+I
   A==;
X-CSE-ConnectionGUID: LnBFU2J7R/SrGJ9s8XNc4w==
X-CSE-MsgGUID: jiGU4zN9RNeS+6vBI00hpw==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="72891417"
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="72891417"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 23:02:25 -0700
X-CSE-ConnectionGUID: B6mYu5WYR6y4hHVzuSOAgA==
X-CSE-MsgGUID: KHRkdKHCSYO/GfkXnTeDdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="134708735"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 23:02:18 -0700
Message-ID: <9d1abdbc-4b21-47e2-bcaf-6bc8ca365b01@linux.intel.com>
Date: Tue, 29 Apr 2025 13:58:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/24] iommu/dma: Factor out a iommu_dma_map_swiotlb
 helper
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe
 <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
 Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
 Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
 Zhu Yanjun <zyjzyj2000@gmail.com>, Robin Murphy <robin.murphy@arm.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org,
 Niklas Schnelle <schnelle@linux.ibm.com>,
 Chuck Lever <chuck.lever@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Dan Williams
 <dan.j.williams@intel.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Chaitanya Kulkarni <kch@nvidia.com>
References: <cover.1745831017.git.leon@kernel.org>
 <f9a6a7874760a2919bea1f255bb3c81c6369ed1c.1745831017.git.leon@kernel.org>
 <8416e94f-171e-4956-b8fe-246ed12a2314@linux.intel.com>
 <20250429055339.GJ5848@unreal>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250429055339.GJ5848@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/25 13:53, Leon Romanovsky wrote:
> On Tue, Apr 29, 2025 at 12:58:18PM +0800, Baolu Lu wrote:
>> On 4/28/25 17:22, Leon Romanovsky wrote:
>>> From: Christoph Hellwig<hch@lst.de>
>>>
>>> Split the iommu logic from iommu_dma_map_page into a separate helper.
>>> This not only keeps the code neatly separated, but will also allow for
>>> reuse in another caller.
>>>
>>> Signed-off-by: Christoph Hellwig<hch@lst.de>
>>> Tested-by: Jens Axboe<axboe@kernel.dk>
>>> Reviewed-by: Luis Chamberlain<mcgrof@kernel.org>
>>> Signed-off-by: Leon Romanovsky<leonro@nvidia.com>
>>
>> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
>>
>> with a nit below ...
>>
>>> ---
>>>    drivers/iommu/dma-iommu.c | 73 ++++++++++++++++++++++-----------------
>>>    1 file changed, 41 insertions(+), 32 deletions(-)
>>>
>>> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
>>> index d3211a8d755e..d7684024c439 100644
>>> --- a/drivers/iommu/dma-iommu.c
>>> +++ b/drivers/iommu/dma-iommu.c
>>> @@ -1138,6 +1138,43 @@ void iommu_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sgl,
>>>    			arch_sync_dma_for_device(sg_phys(sg), sg->length, dir);
>>>    }
>>> +static phys_addr_t iommu_dma_map_swiotlb(struct device *dev, phys_addr_t phys,
>>> +		size_t size, enum dma_data_direction dir, unsigned long attrs)
>>> +{
>>> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
>>> +	struct iova_domain *iovad = &domain->iova_cookie->iovad;
>>> +
>>> +	if (!is_swiotlb_active(dev)) {
>>> +		dev_warn_once(dev, "DMA bounce buffers are inactive, unable to map unaligned transaction.\n");
>>> +		return (phys_addr_t)DMA_MAPPING_ERROR;
>>> +	}
>>> +
>>> +	trace_swiotlb_bounced(dev, phys, size);
>>> +
>>> +	phys = swiotlb_tbl_map_single(dev, phys, size, iova_mask(iovad), dir,
>>> +			attrs);
>>> +
>>> +	/*
>>> +	 * Untrusted devices should not see padding areas with random leftover
>>> +	 * kernel data, so zero the pre- and post-padding.
>>> +	 * swiotlb_tbl_map_single() has initialized the bounce buffer proper to
>>> +	 * the contents of the original memory buffer.
>>> +	 */
>>> +	if (phys != (phys_addr_t)DMA_MAPPING_ERROR && dev_is_untrusted(dev)) {
>>> +		size_t start, virt = (size_t)phys_to_virt(phys);
>>> +
>>> +		/* Pre-padding */
>>> +		start = iova_align_down(iovad, virt);
>>> +		memset((void *)start, 0, virt - start);
>>> +
>>> +		/* Post-padding */
>>> +		start = virt + size;
>>> +		memset((void *)start, 0, iova_align(iovad, start) - start);
>>> +	}
>>> +
>>> +	return phys;
>>> +}
>>> +
>>>    dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
>>>    	      unsigned long offset, size_t size, enum dma_data_direction dir,
>>>    	      unsigned long attrs)
>>> @@ -1151,42 +1188,14 @@ dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
>>>    	dma_addr_t iova, dma_mask = dma_get_mask(dev);
>>>    	/*
>>> -	 * If both the physical buffer start address and size are
>>> -	 * page aligned, we don't need to use a bounce page.
>>> +	 * If both the physical buffer start address and size are page aligned,
>>> +	 * we don't need to use a bounce page.
>>>    	 */
>>>    	if (dev_use_swiotlb(dev, size, dir) &&
>>>    	    iova_offset(iovad, phys | size)) {
>>> -		if (!is_swiotlb_active(dev)) {
>>
>> ... Is it better to move this check into the helper? Simply no-op if a
>> bounce page is not needed:
>>
>> 	if (!dev_use_swiotlb(dev, size, dir) ||
>> 	    !iova_offset(iovad, phys | size))
>> 		return phys;
> 
> Am I missing something? iommu_dma_map_page() has more code after this
> check, so it is not correct to return immediately:
> 
>    1189 dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
>    1190               unsigned long offset, size_t size, enum dma_data_direction dir,
>    1191               unsigned long attrs)
>    1192 {
> 
> <...>
> 
>    1201         /*
>    1202          * If both the physical buffer start address and size are page aligned,
>    1203          * we don't need to use a bounce page.
>    1204          */
>    1205         if (dev_use_swiotlb(dev, size, dir) &&
>    1206             iova_unaligned(iovad, phys, size)) {
>    1207                 phys = iommu_dma_map_swiotlb(dev, phys, size, dir, attrs);
>    1208                 if (phys == (phys_addr_t)DMA_MAPPING_ERROR)
>    1209                         return DMA_MAPPING_ERROR;
>    1210         }
>    1211
>    1212         if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
>    1213                 arch_sync_dma_for_device(phys, size, dir);
>    1214
>    1215         iova = __iommu_dma_map(dev, phys, size, prot, dma_mask);
>    1216         if (iova == DMA_MAPPING_ERROR)
>    1217                 swiotlb_tbl_unmap_single(dev, phys, size, dir, attrs);
>    1218         return iova;
>    1219 }

static phys_addr_t iommu_dma_map_swiotlb(struct device *dev, phys_addr_t 
phys,
		size_t size, enum dma_data_direction dir, unsigned long attrs)
{
<...>
	/*
	 * If both the physical buffer start address and size are page aligned,
	 * we don't need to use a bounce page.
	 */
	if (!dev_use_swiotlb(dev, size, dir) ||
	    !iova_offset(iovad, phys | size))
		return phys;
<...>
}

Then,

dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
	unsigned long offset, size_t size, enum dma_data_direction dir,
	unsigned long attrs)
{
<...>
	phys = iommu_dma_map_swiotlb(dev, phys, size, dir, attrs);
	if (phys == (phys_addr_t)DMA_MAPPING_ERROR)
		return DMA_MAPPING_ERROR;
<...>
}

Thanks,
baolu

