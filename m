Return-Path: <kvm+bounces-20964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78194927BC8
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 19:16:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EF3328B8B6
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 17:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1967D3BBCC;
	Thu,  4 Jul 2024 17:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CaAwoQJr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5EDA20;
	Thu,  4 Jul 2024 17:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720113368; cv=none; b=p+6vB3T7+FYdSI83BE/iskMHeukX6UcZzT0dzn9jfj3v2C5PRxfAvhzaSysVSQiDn8yjDJPFJDK8mAhUwJfs9lhAHT9mpqBWEC89vgWTFHrVQYhFnN6twsyaN9DmR99vd8/J82X4sYrWeHgi55h4onmYlk63dyVMTOvpDxt4TIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720113368; c=relaxed/simple;
	bh=pNA8/Q/+goKs7oTKt+a3Cw9yHcXIncdaNs7gbU3axuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fBUia8SHkmAOliNqojRLTQThukET53mIvX5tr+DV+G7FISNT7JUNypgOOPLSq1TonrE71ArH83tmNzOhPO6FxSMzJJ7q9uPcspqbIyNZ8PvdSOR2ahICWPgTj4KpPIY3+fGsxb6fmSceueM7vpUce2qLjt4TP8fiPyq/z/S1MQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CaAwoQJr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CBDC3277B;
	Thu,  4 Jul 2024 17:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720113368;
	bh=pNA8/Q/+goKs7oTKt+a3Cw9yHcXIncdaNs7gbU3axuo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CaAwoQJrZLArTEOfKusmY+hI3dr6PuiWIDAGemB23zwQ/bD7VJTzy3rb1U9K40ZyB
	 /otipiTe+bwUNsaC6ZuVc/FviZm+4xAk2xQacK3lQNi9b9C6Rc7h/wCI7BS0VScrsf
	 4tpxSoBJ33RZtNcI49felKJ65GDyJxoFFc0vfS3DWE0TZBsc0CA7zajLlHMMZq2nJ1
	 BWwTxUhNOiJTR9T9zELEmujZkVJUUwVvWzO3p2r1Bum7+UJPdGxvl/n/B2MHdq+XCm
	 MP6AVd9901F70GjDlGUnmWKECr+ExRRv6xOr2s0RZ4V/pVSadlxpSNJHRlLbIQ94pP
	 b/fDR1hY0KIrA==
Date: Thu, 4 Jul 2024 20:16:02 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	"Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 18/18] nvme-pci: use new dma API
Message-ID: <20240704171602.GE95824@unreal>
References: <cover.1719909395.git.leon@kernel.org>
 <47eb0510b0a6aa52d9f5665d75fa7093dd6af53f.1719909395.git.leon@kernel.org>
 <249ec228-4ffd-4121-bd51-f4a19275fee1@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <249ec228-4ffd-4121-bd51-f4a19275fee1@arm.com>

On Thu, Jul 04, 2024 at 04:23:47PM +0100, Robin Murphy wrote:
> On 02/07/2024 10:09 am, Leon Romanovsky wrote:
> [...]
> > +static inline dma_addr_t nvme_dma_link_page(struct page *page,
> > +					   unsigned int poffset,
> > +					   unsigned int len,
> > +					   struct nvme_iod *iod)
> >   {
> > -	int i;
> > -	struct scatterlist *sg;
> > +	struct dma_iova_attrs *iova = &iod->dma_map->iova;
> > +	struct dma_iova_state *state = &iod->dma_map->state;
> > +	dma_addr_t dma_addr;
> > +	int ret;
> > +
> > +	if (iod->dma_map->use_iova) {
> > +		phys_addr_t phys = page_to_phys(page) + poffset;
> 
> Yeah, there's no way this can possibly work. You can't do the
> dev_use_swiotlb() check up-front based on some overall DMA operation size,
> but then build that operation out of arbitrarily small fragments of
> different physical pages that *could* individually need bouncing to not
> break coherency.

This is exactly how dma_map_sg() works. It checks in advance all SG and
proceeds with bounce buffer if needed. In our case all checks which
exists in dev_use_sg_swiotlb() will give "false". In v0, Christoph said
that NVMe guarantees alignment, which is only one "dynamic" check in
that function.

   600 static bool dev_use_sg_swiotlb(struct device *dev, struct scatterlist *sg,
   601                                int nents, enum dma_data_direction dir)
   602 {
   603         struct scatterlist *s;
   604         int i;
   605
   606         if (!IS_ENABLED(CONFIG_SWIOTLB))
   607                 return false;
   608
   609         if (dev_is_untrusted(dev))
   610                 return true;
   611
   612         /*
   613          * If kmalloc() buffers are not DMA-safe for this device and
   614          * direction, check the individual lengths in the sg list. If any
   615          * element is deemed unsafe, use the swiotlb for bouncing.
   616          */
   617         if (!dma_kmalloc_safe(dev, dir)) {
   618                 for_each_sg(sg, s, nents, i)
   619                         if (!dma_kmalloc_size_aligned(s->length))
   620                                 return true;
   621         }
   622
   623         return false;
   624 }

   ...
  1338 static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
  1339                 int nents, enum dma_data_direction dir, unsigned long attrs)
  ...
  1360         if (dev_use_sg_swiotlb(dev, sg, nents, dir))                          
  1361                 return iommu_dma_map_sg_swiotlb(dev, sg, nents, dir, attrs);   

Thanks

> 
> Thanks,
> Robin.
> 
> > +
> > +		dma_addr = state->iova->addr + state->range_size;
> > +		ret = dma_link_range(&iod->dma_map->state, phys, len);
> > +		if (ret)
> > +			return DMA_MAPPING_ERROR;
> > +	} else {
> > +		dma_addr = dma_map_page_attrs(iova->dev, page, poffset, len,
> > +					      iova->dir, iova->attrs);
> > +	}
> > +	return dma_addr;
> > +}
> 

