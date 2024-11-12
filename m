Return-Path: <kvm+bounces-31556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB9F19C4F51
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:21:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F3DD28356E
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8295B20B1ED;
	Tue, 12 Nov 2024 07:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVmzKoMM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D81A83A14;
	Tue, 12 Nov 2024 07:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731396047; cv=none; b=WMvQMHYDY+eko0GGrrCR9VcX3kl/M62cKGUTuLJt9E2vD541N+O3Lw9D4Vo65eGUlZylLaKGUy2gwfhiF+kybUbQ+idnZs8vyo4C5Kc4HPNInlpkLdRz/u9UJTiS/+CcvzCFDJQkN29eNOUg/3DZcdDB7hKfnv9UbZ/t+dyyllY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731396047; c=relaxed/simple;
	bh=iebmt1JJ4nc2KqO33nu0BylpM0uwrbfzxJxK70i+S/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DpEsODAwdz8M2xm+mUqQhNdBY8eiomYMqwm3lZKBREcg34xcePz9aF2KHH7CvZfrBu+01bWj0tFsFeHExaH4chAPrstMoq1OzQqBaCaboM0mPXpa5OEB4mwci/inrBQ5zj8f+fMk0LCcqzByHxH/h8IqsgmIYLHm6LrIEM+lSXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVmzKoMM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7FFC4CED6;
	Tue, 12 Nov 2024 07:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731396047;
	bh=iebmt1JJ4nc2KqO33nu0BylpM0uwrbfzxJxK70i+S/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dVmzKoMMLI1p5lld2AzbKA0OKhkaVTgahMbznY+ch5wqmWfYCEBoHJ5ZIQ8i4OEW7
	 y0SB4PSstnJw8hURXljSVh3nG8HHVe3dC7gqHVMQQXmgFoRfx3x8hsZ36yggo7YlVq
	 2q0lrQ8rdvyycCXVFgnX8tvivhS3iXRbVyFR1p3rkwOgGKPIQ2kftduBV0NwjkeMS6
	 +NoAmsvdHq/cRMRpCO7yQhqTp7kgXfnEETQD/OipD9b2Ni66FEyjDAneYRjzAw6sNL
	 U2vmfYx6TwAoyvedmOw9NUrF5kwpsNBTikX0r/vBN3EeyzUVC53eAjFgH0BRIJSoUB
	 HtyTui/+hEy9g==
Date: Tue, 12 Nov 2024 09:20:40 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>, ill Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
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
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 00/17] Provide a new two step DMA mapping API
Message-ID: <20241112072040.GG71181@unreal>
References: <cover.1731244445.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1731244445.git.leon@kernel.org>

On Sun, Nov 10, 2024 at 03:46:47PM +0200, Leon Romanovsky wrote:

<...>

> ----------------------------------------------------------------------------
> The code can be downloaded from:
> https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tag:dma-split-nov-09

<...>

> 
> Christoph Hellwig (6):
>   PCI/P2PDMA: Refactor the p2pdma mapping helpers
>   dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
>   iommu: generalize the batched sync after map interface
>   iommu/dma: Factor out a iommu_dma_map_swiotlb helper
>   dma-mapping: add a dma_need_unmap helper
>   docs: core-api: document the IOVA-based API
> 
> Leon Romanovsky (11):
>   dma-mapping: Add check if IOVA can be used
>   dma: Provide an interface to allow allocate IOVA
>   dma-mapping: Implement link/unlink ranges API
>   mm/hmm: let users to tag specific PFN with DMA mapped bit
>   mm/hmm: provide generic DMA managing logic
>   RDMA/umem: Store ODP access mask information in PFN
>   RDMA/core: Convert UMEM ODP DMA mapping to caching IOVA and page
>     linkage
>   RDMA/umem: Separate implicit ODP initialization from explicit ODP
>   vfio/mlx5: Explicitly use number of pages instead of allocated length
>   vfio/mlx5: Rewrite create mkey flow to allow better code reuse
>   vfio/mlx5: Enable the DMA link API

Robin,

All technical concerns were handled and this series is ready to be merged.

Robin, can you please Ack the dma-iommu patches?

Thanks

