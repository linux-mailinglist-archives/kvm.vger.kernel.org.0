Return-Path: <kvm+bounces-20961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 448609279F6
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 17:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAA8D28A951
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 15:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17571B14EC;
	Thu,  4 Jul 2024 15:23:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 806C61B1409;
	Thu,  4 Jul 2024 15:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720106636; cv=none; b=gJWCq08qqBxyaweAahgO41WcC2flWgLR1nWx2Ft+D9GBTBaPjFjoCEiu78ydllVxlfzSEs8vlq2ZXUyDFGSB4P+S8f2nmZrTFb72nf7aYNd9RPNdCJlYKkKPYzAXn6TerOAEUTob5q9yaOFPxrVWI4UvRZPlcr+gcOy9cMVi/Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720106636; c=relaxed/simple;
	bh=1G7Ua2w5pwj1vzd80lgSEf5Gu1FS96EaOAuyyE4ofNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J6IT0jGM/TrwV3vr44Jcs8mGAefYpcKw+geHd7dJC5r01IARDkyxj18PlmP2I5BnLNP153GU7julaLZQbNY4dAOzgc39ETKLsQaXjczWq6ewIj4Nldl/edve6fkq3g7BK64rQGrUnl0U3PnGCXMqwKqJIMqkKnRHzhSq+Zd+kL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA206367;
	Thu,  4 Jul 2024 08:24:18 -0700 (PDT)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E2F73F766;
	Thu,  4 Jul 2024 08:23:50 -0700 (PDT)
Message-ID: <249ec228-4ffd-4121-bd51-f4a19275fee1@arm.com>
Date: Thu, 4 Jul 2024 16:23:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 18/18] nvme-pci: use new dma API
To: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, "Zeng, Oak" <oak.zeng@intel.com>,
 Chaitanya Kulkarni <kch@nvidia.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
References: <cover.1719909395.git.leon@kernel.org>
 <47eb0510b0a6aa52d9f5665d75fa7093dd6af53f.1719909395.git.leon@kernel.org>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <47eb0510b0a6aa52d9f5665d75fa7093dd6af53f.1719909395.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/07/2024 10:09 am, Leon Romanovsky wrote:
[...]
> +static inline dma_addr_t nvme_dma_link_page(struct page *page,
> +					   unsigned int poffset,
> +					   unsigned int len,
> +					   struct nvme_iod *iod)
>   {
> -	int i;
> -	struct scatterlist *sg;
> +	struct dma_iova_attrs *iova = &iod->dma_map->iova;
> +	struct dma_iova_state *state = &iod->dma_map->state;
> +	dma_addr_t dma_addr;
> +	int ret;
> +
> +	if (iod->dma_map->use_iova) {
> +		phys_addr_t phys = page_to_phys(page) + poffset;

Yeah, there's no way this can possibly work. You can't do the 
dev_use_swiotlb() check up-front based on some overall DMA operation 
size, but then build that operation out of arbitrarily small fragments 
of different physical pages that *could* individually need bouncing to 
not break coherency.

Thanks,
Robin.

> +
> +		dma_addr = state->iova->addr + state->range_size;
> +		ret = dma_link_range(&iod->dma_map->state, phys, len);
> +		if (ret)
> +			return DMA_MAPPING_ERROR;
> +	} else {
> +		dma_addr = dma_map_page_attrs(iova->dev, page, poffset, len,
> +					      iova->dir, iova->attrs);
> +	}
> +	return dma_addr;
> +}

