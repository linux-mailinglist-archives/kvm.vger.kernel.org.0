Return-Path: <kvm+bounces-30253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F58B9B852C
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 22:19:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B16731C21422
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 21:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B87C01CEEB0;
	Thu, 31 Oct 2024 21:18:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B82221B95B;
	Thu, 31 Oct 2024 21:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730409530; cv=none; b=CXH2mRRwXU4wNodljRDIX3MetPYWidbibuU4fLqKwLL4jfFsleNDJ2pcdn6CmJATNUIiZ0F57kYH3xBSKdaOF11QvfihoHBnP5tq7T1Q3talz9KyPor6I1nGPlAhmbYVCwJ9T+U1iTCAnPfQ0k+K5Rzr/8A5848T7u8BppVIj/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730409530; c=relaxed/simple;
	bh=cpF4AAIzOXZkhcxxrsLBIFg7A1MuiEGbI4VYVNmRk2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fXWydcTckPwAkrENjwo9kxOzW6qUXDA6oe73dDomPtcinqiaTcpbbconc0jeDRz/wewdwp0fneIXmrIlw+hPi2llObKDKN80ioNPt8PeZdq3aQOxXSSdjk7jJfQU05QxUe/Uktpo8UvWK1d3hA+q0/k1h1EGjLZB19CtjS5T3DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6EFD153B;
	Thu, 31 Oct 2024 14:19:11 -0700 (PDT)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 334AF3F73B;
	Thu, 31 Oct 2024 14:18:30 -0700 (PDT)
Message-ID: <7e362d8b-c02a-4327-9c5d-af1c4725ddc7@arm.com>
Date: Thu, 31 Oct 2024 21:18:11 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 08/17] dma-mapping: add a dma_need_unmap helper
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
 <00385b3557fa074865d37b0ac613d2cb28bcb741.1730298502.git.leon@kernel.org>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <00385b3557fa074865d37b0ac613d2cb28bcb741.1730298502.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30/10/2024 3:12 pm, Leon Romanovsky wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Add helper that allows a driver to skip calling dma_unmap_*
> if the DMA layer can guarantee that they are no-nops.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   include/linux/dma-mapping.h |  5 +++++
>   kernel/dma/mapping.c        | 20 ++++++++++++++++++++
>   2 files changed, 25 insertions(+)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 8074a3b5c807..6906edde505d 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -410,6 +410,7 @@ static inline bool dma_need_sync(struct device *dev, dma_addr_t dma_addr)
>   {
>   	return dma_dev_need_sync(dev) ? __dma_need_sync(dev, dma_addr) : false;
>   }
> +bool dma_need_unmap(struct device *dev);
>   #else /* !CONFIG_HAS_DMA || !CONFIG_DMA_NEED_SYNC */
>   static inline bool dma_dev_need_sync(const struct device *dev)
>   {
> @@ -435,6 +436,10 @@ static inline bool dma_need_sync(struct device *dev, dma_addr_t dma_addr)
>   {
>   	return false;
>   }
> +static inline bool dma_need_unmap(struct device *dev)
> +{
> +	return false;
> +}
>   #endif /* !CONFIG_HAS_DMA || !CONFIG_DMA_NEED_SYNC */
>   
>   struct page *dma_alloc_pages(struct device *dev, size_t size,
> diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> index 864a1121bf08..daa97a650778 100644
> --- a/kernel/dma/mapping.c
> +++ b/kernel/dma/mapping.c
> @@ -442,6 +442,26 @@ bool __dma_need_sync(struct device *dev, dma_addr_t dma_addr)
>   }
>   EXPORT_SYMBOL_GPL(__dma_need_sync);
>   
> +/**
> + * dma_need_unmap - does this device need dma_unmap_* operations
> + * @dev: device to check
> + *
> + * If this function returns %false, drivers can skip calling dma_unmap_* after
> + * finishing an I/O.  This function must be called after all mappings that might
> + * need to be unmapped have been performed.

In terms of the unmap call itself, why don't we just use dma_skip_sync 
to short-cut dma_direct_unmap_*() and make sure it's as cheap as possible?

In terms of not having to unmap implying not having to store addresses 
at all, it doesn't seem super-useful when you still have to store them 
for long enough to find out that you don't :/

Thanks,
Robin.

> + */
> +bool dma_need_unmap(struct device *dev)
> +{
> +	if (!dma_map_direct(dev, get_dma_ops(dev)))
> +		return true;
> +#ifdef CONFIG_DMA_NEED_SYNC
> +	if (!dev->dma_skip_sync)
> +		return true;
> +#endif
> +	return IS_ENABLED(CONFIG_DMA_API_DEBUG);
> +}
> +EXPORT_SYMBOL_GPL(dma_need_unmap);
> +
>   static void dma_setup_need_sync(struct device *dev)
>   {
>   	const struct dma_map_ops *ops = get_dma_ops(dev);

