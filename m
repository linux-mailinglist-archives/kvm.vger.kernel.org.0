Return-Path: <kvm+bounces-44683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A47DDAA021B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:53:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 069681B63099
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6FFE2741C8;
	Tue, 29 Apr 2025 05:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LnQWizAg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F076D14EC5B;
	Tue, 29 Apr 2025 05:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745906024; cv=none; b=GopeIUL1vYteb7X+mgD9/zGmD5ebkP3mPX/e1EsETkjEvOowMjisM53SKV00XvCuxJ1djuXhfFJEmKn7UQzsjTySPbJPhUmm60dBwDJrpce+0ogu6atawh+QvdnZpFSGWbDnbVMtVYT9Ihraa+sKcVUTXjJzbliWDVu8HGxPx7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745906024; c=relaxed/simple;
	bh=pjWT2YEBoo+aeNNdF/9OjGUMU99E00/qEdiP7XvrLnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fHqHpQbV5E8ZBwBfcWKmGC2Cduc6WLObbbFjZ7LsO98hKr4wqrEkEX+aYRaa1Am1bH1khl6sK5rmkwmV9klXyrAcLwlEwBfQeb40v8skVJkM4S1+P4XIyXceV4Og2FrD9fdoWVyAwlEm1ACYDwwAaDD/rF5ly+Xy9uQlFo2Cy9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LnQWizAg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A3BC4CEE3;
	Tue, 29 Apr 2025 05:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745906023;
	bh=pjWT2YEBoo+aeNNdF/9OjGUMU99E00/qEdiP7XvrLnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LnQWizAgROC7A8WUupkgx/RjNgOeZhcQXFHDDnOFmpAkDfulmJPJ3Ysno5xdYwaxf
	 34rmjPLe1vQWdYLvjawf4pTZa0H329xNF11gy9kInf5XYGloOwQ6Nhwg6LBxuy3nES
	 KXqpLcb5VXB1GXH03JwKI/YNp+C1ImMo97JAl1Kez1aO2YW1ovR1CZuGNH7JMEuOQ7
	 TR8B7CAv5HFPojVJP6F7jIDFFZst/yBljgdskoR27X0imt251RZVpEhOkBuV8L1dUJ
	 V7FHK2Owwv/FzLv2VB5DPC4mrBKKSM5BPaRsC+i3rNieRLL1uGuULFNX/S1RJ6aILC
	 1N3zXS+iMsY5A==
Date: Tue, 29 Apr 2025 08:53:39 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v10 06/24] iommu/dma: Factor out a iommu_dma_map_swiotlb
 helper
Message-ID: <20250429055339.GJ5848@unreal>
References: <cover.1745831017.git.leon@kernel.org>
 <f9a6a7874760a2919bea1f255bb3c81c6369ed1c.1745831017.git.leon@kernel.org>
 <8416e94f-171e-4956-b8fe-246ed12a2314@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8416e94f-171e-4956-b8fe-246ed12a2314@linux.intel.com>

On Tue, Apr 29, 2025 at 12:58:18PM +0800, Baolu Lu wrote:
> On 4/28/25 17:22, Leon Romanovsky wrote:
> > From: Christoph Hellwig<hch@lst.de>
> > 
> > Split the iommu logic from iommu_dma_map_page into a separate helper.
> > This not only keeps the code neatly separated, but will also allow for
> > reuse in another caller.
> > 
> > Signed-off-by: Christoph Hellwig<hch@lst.de>
> > Tested-by: Jens Axboe<axboe@kernel.dk>
> > Reviewed-by: Luis Chamberlain<mcgrof@kernel.org>
> > Signed-off-by: Leon Romanovsky<leonro@nvidia.com>
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> 
> with a nit below ...
> 
> > ---
> >   drivers/iommu/dma-iommu.c | 73 ++++++++++++++++++++++-----------------
> >   1 file changed, 41 insertions(+), 32 deletions(-)
> > 
> > diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> > index d3211a8d755e..d7684024c439 100644
> > --- a/drivers/iommu/dma-iommu.c
> > +++ b/drivers/iommu/dma-iommu.c
> > @@ -1138,6 +1138,43 @@ void iommu_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sgl,
> >   			arch_sync_dma_for_device(sg_phys(sg), sg->length, dir);
> >   }
> > +static phys_addr_t iommu_dma_map_swiotlb(struct device *dev, phys_addr_t phys,
> > +		size_t size, enum dma_data_direction dir, unsigned long attrs)
> > +{
> > +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> > +	struct iova_domain *iovad = &domain->iova_cookie->iovad;
> > +
> > +	if (!is_swiotlb_active(dev)) {
> > +		dev_warn_once(dev, "DMA bounce buffers are inactive, unable to map unaligned transaction.\n");
> > +		return (phys_addr_t)DMA_MAPPING_ERROR;
> > +	}
> > +
> > +	trace_swiotlb_bounced(dev, phys, size);
> > +
> > +	phys = swiotlb_tbl_map_single(dev, phys, size, iova_mask(iovad), dir,
> > +			attrs);
> > +
> > +	/*
> > +	 * Untrusted devices should not see padding areas with random leftover
> > +	 * kernel data, so zero the pre- and post-padding.
> > +	 * swiotlb_tbl_map_single() has initialized the bounce buffer proper to
> > +	 * the contents of the original memory buffer.
> > +	 */
> > +	if (phys != (phys_addr_t)DMA_MAPPING_ERROR && dev_is_untrusted(dev)) {
> > +		size_t start, virt = (size_t)phys_to_virt(phys);
> > +
> > +		/* Pre-padding */
> > +		start = iova_align_down(iovad, virt);
> > +		memset((void *)start, 0, virt - start);
> > +
> > +		/* Post-padding */
> > +		start = virt + size;
> > +		memset((void *)start, 0, iova_align(iovad, start) - start);
> > +	}
> > +
> > +	return phys;
> > +}
> > +
> >   dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
> >   	      unsigned long offset, size_t size, enum dma_data_direction dir,
> >   	      unsigned long attrs)
> > @@ -1151,42 +1188,14 @@ dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
> >   	dma_addr_t iova, dma_mask = dma_get_mask(dev);
> >   	/*
> > -	 * If both the physical buffer start address and size are
> > -	 * page aligned, we don't need to use a bounce page.
> > +	 * If both the physical buffer start address and size are page aligned,
> > +	 * we don't need to use a bounce page.
> >   	 */
> >   	if (dev_use_swiotlb(dev, size, dir) &&
> >   	    iova_offset(iovad, phys | size)) {
> > -		if (!is_swiotlb_active(dev)) {
> 
> ... Is it better to move this check into the helper? Simply no-op if a
> bounce page is not needed:
> 
> 	if (!dev_use_swiotlb(dev, size, dir) ||
> 	    !iova_offset(iovad, phys | size))
> 		return phys;

Am I missing something? iommu_dma_map_page() has more code after this
check, so it is not correct to return immediately:

  1189 dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
  1190               unsigned long offset, size_t size, enum dma_data_direction dir,
  1191               unsigned long attrs)
  1192 {

<...>

  1201         /*
  1202          * If both the physical buffer start address and size are page aligned,
  1203          * we don't need to use a bounce page.
  1204          */
  1205         if (dev_use_swiotlb(dev, size, dir) &&
  1206             iova_unaligned(iovad, phys, size)) {
  1207                 phys = iommu_dma_map_swiotlb(dev, phys, size, dir, attrs);
  1208                 if (phys == (phys_addr_t)DMA_MAPPING_ERROR)
  1209                         return DMA_MAPPING_ERROR;
  1210         }
  1211
  1212         if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
  1213                 arch_sync_dma_for_device(phys, size, dir);
  1214
  1215         iova = __iommu_dma_map(dev, phys, size, prot, dma_mask);
  1216         if (iova == DMA_MAPPING_ERROR)
  1217                 swiotlb_tbl_unmap_single(dev, phys, size, dir, attrs);
  1218         return iova;
  1219 }


> 
> Thanks,
> baolu
> 

