Return-Path: <kvm+bounces-31384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B2599C3302
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 16:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BE581C20A37
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 15:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E14E82C7E;
	Sun, 10 Nov 2024 15:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kwl2ylu4"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968144C3D0
	for <kvm@vger.kernel.org>; Sun, 10 Nov 2024 15:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731251370; cv=none; b=UJCQmVS6kqmfmMQjHkJzKzWXacO6jo4XbJaaCflYWZzEESn99XmFcJB9Y56r7jcvJXkdoyjn1kKQ0D5IDokroOF8shMGj75DGz+f8beudlE84F1RaQZXH/Sv89S6+V+P8X6y7KPWXIBDdJVWmlFfQnWJ8D6RwYmXsRDH84rzLAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731251370; c=relaxed/simple;
	bh=dszFf+vGscN42eEkPdCr9wzW118GrUwAh1ojWhXgZfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I0wFalc5oc6iwjDkhhXyxmvnnicwP5K6R70Tj9NKvdtAJYnHmI0HQjyTqVGqP7Iplgz0uiPYD7p653GSZRKb3b8JBWdeiVrwWmUa1RgL5f2sv3R7bfj2fDZ+44oETtIcnu1X4+cODIO7zdzJtQB+OsSoRNkOWcwyw2qveXq7lTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kwl2ylu4; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <5ea594b3-7451-4553-92c1-2590c8baef20@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731251359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PCo17FAGoI0N36z1xhgr+jZX1coQaBkOx2Lfp0sQCQA=;
	b=Kwl2ylu4VPdk87+OR+b1SUGCOqDGZ8sXihB72SCRVQi9i6kYT1ztmGzGjEKIgaTkzqz7O7
	gUdz5mo8gHkrYMkATcROHwm+OWPXtUwFXI2ChCzpDr7jZTQAnz47D+n7DFqKijh6+E8P9T
	rOxWb9K9BcpUIQd4Xi7vpR/Dwmt+txs=
Date: Sun, 10 Nov 2024 16:09:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v1 04/17] dma-mapping: Add check if IOVA can be used
To: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>
Cc: Leon Romanovsky <leonro@nvidia.com>, Keith Busch <kbusch@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>,
 Yishai Hadas <yishaih@nvidia.com>,
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
 <9515f330b9615de92a1864ab46acbd95e32634b6.1730298502.git.leon@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <9515f330b9615de92a1864ab46acbd95e32634b6.1730298502.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2024/10/30 16:12, Leon Romanovsky 写道:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> This patch adds a check if IOVA can be used for the specific
> transaction.
> 
> In the new API a DMA mapping transaction is identified by a
> struct dma_iova_state, which holds some recomputed information
> for the transaction which does not change for each page being
> mapped.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   include/linux/dma-mapping.h | 33 +++++++++++++++++++++++++++++++++
>   1 file changed, 33 insertions(+)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 1524da363734..6075e0708deb 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -76,6 +76,20 @@
>   
>   #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
>   
> +struct dma_iova_state {
> +	size_t __size;
> +};
> +
> +/*
> + * Use the high bit to mark if we used swiotlb for one or more ranges.
> + */
> +#define DMA_IOVA_USE_SWIOTLB		(1ULL << 63)

A trivial problem.
In the above macro, using BIT_ULL(63) is better?

Zhu Yanjun

> +
> +static inline size_t dma_iova_size(struct dma_iova_state *state)
> +{
> +	return state->__size & ~DMA_IOVA_USE_SWIOTLB;
> +}
> +
>   #ifdef CONFIG_DMA_API_DEBUG
>   void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
>   void debug_dma_map_single(struct device *dev, const void *addr,
> @@ -281,6 +295,25 @@ static inline int dma_mmap_noncontiguous(struct device *dev,
>   }
>   #endif /* CONFIG_HAS_DMA */
>   
> +#ifdef CONFIG_IOMMU_DMA
> +/**
> + * dma_use_iova - check if the IOVA API is used for this state
> + * @state: IOVA state
> + *
> + * Return %true if the DMA transfers uses the dma_iova_*() calls or %false if
> + * they can't be used.
> + */
> +static inline bool dma_use_iova(struct dma_iova_state *state)
> +{
> +	return state->__size != 0;
> +}
> +#else /* CONFIG_IOMMU_DMA */
> +static inline bool dma_use_iova(struct dma_iova_state *state)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_IOMMU_DMA */
> +
>   #if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
>   void __dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr, size_t size,
>   		enum dma_data_direction dir);


