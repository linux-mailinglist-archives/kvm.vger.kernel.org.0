Return-Path: <kvm+bounces-33520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C6569ED986
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:20:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE1C4188457B
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 22:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C37A1F2392;
	Wed, 11 Dec 2024 22:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBNirnu6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CD81C304A;
	Wed, 11 Dec 2024 22:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733955609; cv=none; b=hLhP/vjTndfso2Xf3efgEI4kZFPcEV7MM467tRizoEbkaenisa9GdQgmvQyq0IORFqes/8ee/UAejThLiX4h2rhw4SShHtcjuEPd/NkWw/CFfgWTnYHt/J5/Q9w1tS/j46eYOXCe2oy93+eyCSkCV5iCw6KMwEAOV/FJiiZuHt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733955609; c=relaxed/simple;
	bh=VLhIlSr54TL2QmDP8JRM72GWULbrO+1dbQF3pJw1ea8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=elv6m3HdSOdEICY/3aSSgbWXYNWERWVQvLHMz7jD+zQ5MPv52a+Ojl5HhSdtYC77lVZ9iESwHsvGc+MKnEAWdKjTCT3pPr5ThpQjkSNRYcPKX0UZGQkU0aRg9bEt5blGlf5OPECdYn7Ax1f0iOCkpbnZ9VWavFsACWBFOPOEfhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBNirnu6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4576FC4CED2;
	Wed, 11 Dec 2024 22:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733955609;
	bh=VLhIlSr54TL2QmDP8JRM72GWULbrO+1dbQF3pJw1ea8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kBNirnu6kCr1d7gsDMgZrNuAXLYpD8uzILmzzbrNO1Mnk09f4n481Cndxfrau3+jJ
	 FpLkwRUeISCmz/SpemPgohhlQ3XgJzMdmIoVZ+IhBa91qhgYo51NaglvZU5BDtIZwB
	 //WGIgbYueq/MY8+Vmm6UVkGftTY+5cuZd/vROmxV6NP1K5rtWTWqMiA7gXfNGL2rJ
	 x8QxUc2OB1rxoUChWT6mPdO+zhCO+RaRL8TgtaiQ2BKywx4s0f0kj5Ngw6pkMs+dfE
	 zgxHiHxwQbMNfdTxhMs7Xm5RVvG80KHa9zyTwAQzCJbyWkRaNGRYrBbAH41l/rU6DO
	 Lf0Zf/ATio7bQ==
Date: Wed, 11 Dec 2024 22:20:00 +0000
From: Will Deacon <will@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Leon Romanovsky <leonro@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v4 04/18] iommu: add kernel-doc for iommu_unmap and
 iommu_unmap_fast
Message-ID: <20241211222000.GH17486@willie-the-truck>
References: <cover.1733398913.git.leon@kernel.org>
 <da4827fda833e69dbe487ef404a9333c51d8ed2e.1733398913.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da4827fda833e69dbe487ef404a9333c51d8ed2e.1733398913.git.leon@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Dec 05, 2024 at 03:21:03PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Add kernel-doc section for iommu_unmap and iommu_unmap_fast to document
> existing limitation of underlying functions which can't split individual
> ranges.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/iommu/iommu.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index ec75d14497bf..9eb7c7d7aa70 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2590,6 +2590,24 @@ size_t iommu_unmap(struct iommu_domain *domain,
>  }
>  EXPORT_SYMBOL_GPL(iommu_unmap);
>  
> +/**
> + * iommu_unmap_fast() - Remove mappings from a range of IOVA without IOTLB sync
> + * @domain: Domain to manipulate
> + * @iova: IO virtual address to start
> + * @size: Length of the range starting from @iova
> + * @iotlb_gather: range information for a pending IOTLB flush
> + *
> + * iommu_unmap_fast() will remove a translation created by iommu_map(). It cannot
> + * subdivide a mapping created by iommu_map(), so it should be called with IOVA
> + * ranges that match what was passed to iommu_map(). The range can aggregate
> + * contiguous iommu_map() calls so long as no individual range is split.
> + *
> + * Basicly iommu_unmap_fast() as the same as iommu_unmap() but for callers

Typo: s/Basicly/Basically/
Typo: s/as the same/is the same/

> + * which manage IOTLB flush range externaly to perform batched sync.

Grammar: s/manage IOTLB flush range/manage the IOTLB flushing/
Typo: s/externaly/externally/
Grammar: s/to perform batched sync/to perform a batched sync/

With those:

Acked-by: Will Deacon <will@kernel.org>

Thank you for doing this!

Will

