Return-Path: <kvm+bounces-44082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 026E9A9A318
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 09:16:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AE06194742A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 07:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB3951F1908;
	Thu, 24 Apr 2025 07:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aBTgU71u"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24A4CA52;
	Thu, 24 Apr 2025 07:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745478952; cv=none; b=FI24Nzb+mhsuzug8076nMp2QNckg//CvQoVQcBZh+4/EvpVxky1v3j+It1Vjc9qokbAIPf5MZ2sjnQ/rL5tUVbchDjNFdoKywslJpRpAp2nt4szoVqh/bE7KcjOOz+xclykMGshC2vpZzHYz/BogMMICj6meOq5rpm2ZZpbdCRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745478952; c=relaxed/simple;
	bh=pTkF/OxNxP3a5nhNTZxPZtH9LiokbdzIPY4lcClh0Q0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LkL6ZRu6rZ1q2KFRUROFPShUq/68RaF++pKn22XR0HrQZdXhA8ee0sA0NHs0scmQHpCkmqaI63RdnDV8f3h03CdqO4fD+7Vvn2A8Ht1kAB3WbpTQeSvLGmjWk62GEqr2iO+vHu0ojDnZjxr4k8PNpOQAPCzgxBIame0w5jEciTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aBTgU71u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8E3C4CEE3;
	Thu, 24 Apr 2025 07:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745478951;
	bh=pTkF/OxNxP3a5nhNTZxPZtH9LiokbdzIPY4lcClh0Q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aBTgU71uDQ76gGQRWfJMAVuYX3A0QbPaLJvEVuFRBRrxPSIlRhqbBqclL9MgN42Mz
	 mOyKpbfujbO9d4jcdRZl8T1Go5m+UqQxIRaX0tVYAWP8gY0N23/sDzG80Ns8/xrjOx
	 yRFGVRmXxsj5fmUE6A3mSSt4ikS5jl7uqbR1Q9jdp7zW3uELJvckJZvlrjbWQLAFMI
	 rlKfp1i/mcS2aG+fPOR4bIoU7h9FpaLggeY2LHT/xOyqKlGS/6YJVHuNgwdRNVVRsH
	 wu0LFFiidEyDynwIeD0OFcSLI8I/quvZGtTqBj02iqPtvdHAUsLiUcS2TnnGA7c1LM
	 7VSAaFBMPFnUw==
Date: Thu, 24 Apr 2025 10:15:45 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Zhu Yanjun <zyjzyj2000@gmail.com>,
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
Subject: Re: [PATCH v9 11/24] mm/hmm: provide generic DMA managing logic
Message-ID: <20250424071545.GM48485@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <3abc42885831f841dd5dfe78d7c4e56c620670ea.1745394536.git.leon@kernel.org>
 <20250423172856.GM1213339@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423172856.GM1213339@ziepe.ca>

On Wed, Apr 23, 2025 at 02:28:56PM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 23, 2025 at 11:13:02AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > HMM callers use PFN list to populate range while calling
> > to hmm_range_fault(), the conversion from PFN to DMA address
> > is done by the callers with help of another DMA list. However,
> > it is wasteful on any modern platform and by doing the right
> > logic, that DMA list can be avoided.
> > 
> > Provide generic logic to manage these lists and gave an interface
> > to map/unmap PFNs to DMA addresses, without requiring from the callers
> > to be an experts in DMA core API.
> > 
> > Tested-by: Jens Axboe <axboe@kernel.dk>
> 
> I don't think Jens tested the RDMA and hmm parts :)

I know, but he posted his Tested-by tag on cover letter and b4 picked it
for whole series. I decided to keep it as is.

> 
> > +	/*
> > +	 * The HMM API violates our normal DMA buffer ownership rules and can't
> > +	 * transfer buffer ownership.  The dma_addressing_limited() check is a
> > +	 * best approximation to ensure no swiotlb buffering happens.
> > +	 */
> 
> This is a bit unclear, HMM inherently can't do cache flushing or
> swiotlb bounce buffering because its entire purpose is to DMA directly
> and coherently to a mm_struct's page tables. There are no sensible
> points we could put the required flushing that wouldn't break the
> entire model.
> 
> FWIW I view that fact that we now fail back to userspace in these
> cases instead of quietly malfunction to be a big improvement.
> 
> > +bool hmm_dma_unmap_pfn(struct device *dev, struct hmm_dma_map *map, size_t idx)
> > +{
> > +	struct dma_iova_state *state = &map->state;
> > +	dma_addr_t *dma_addrs = map->dma_list;
> > +	unsigned long *pfns = map->pfn_list;
> > +	unsigned long attrs = 0;
> > +
> > +#define HMM_PFN_VALID_DMA (HMM_PFN_VALID | HMM_PFN_DMA_MAPPED)
> > +	if ((pfns[idx] & HMM_PFN_VALID_DMA) != HMM_PFN_VALID_DMA)
> > +		return false;
> > +#undef HMM_PFN_VALID_DMA
> 
> If a v10 comes I'd put this in a const function level variable:
> 
>           const unsigned int HMM_PFN_VALID_DMA = HMM_PFN_VALID | HMM_PFN_DMA_MAPPED;
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

I have no idea if v10 is needed. DMA API is stable for a long time and
only DMA part should go in shared branch. Everything else will need to
go through relevant subsystems anyway.

Thanks

> 
> Jason

