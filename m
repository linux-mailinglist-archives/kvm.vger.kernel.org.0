Return-Path: <kvm+bounces-38688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 484C3A3DA65
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:49:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52AB93B2FA6
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7BE81F63FE;
	Thu, 20 Feb 2025 12:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XhH3Rxw/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BF32862BD;
	Thu, 20 Feb 2025 12:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740055712; cv=none; b=gHk0N0/PJMM6Spb1pJwQ7y1LwGYRrKf//nAZdpZHfV4L5iELf5L7wd8lsUKOWnU4D6MmlkH54pxE7oFSBCye7t2kBjGrodl/oO1IwPBfKFIhaO7px2rMIX7bCm6r1Sx+sCVmxQwaX2+Yd/u7Tp9GSxmSca/b87PFOs0H8nPiTT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740055712; c=relaxed/simple;
	bh=1Iv3ATubl6AG/lSG1TPOh5GEc+mnunYnUNognONLHrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fDbvlA/Jhqg/b8gRMEoTrL3oTYbgsRjfMZE/YO3nb8CejGVbFWT4h8ifkPTH+/CJ1KaVQMEceDysCs09nXK6TgevjGpCh8SqgHjJcE0DWUTZJNaiDwzYrEjp3IVUh6t96GSc9Mgoglod+QzPOUyfWY8/63rebM00fN/e1Iyz8Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XhH3Rxw/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C882DC4CED1;
	Thu, 20 Feb 2025 12:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740055711;
	bh=1Iv3ATubl6AG/lSG1TPOh5GEc+mnunYnUNognONLHrM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XhH3Rxw/fU4NMM8JUKPDYre9d9LQaru2HtlbuSSUNzkHB8eWhqMM23vtegnTWn+BS
	 9+H0GOfdzn1LNx9IHcWfvcpB8EXNSp57Achx+q1U7ozbfXzho3FO9ENmdtK+fnEJTx
	 1mX2B9KcxOTwRBNfDJoEWHPpCPDk48cyZC7xwNx3D4HZ/eDzhk1UYs1ByD6cWBCggg
	 PbJi1s5B2/FkYeMMfisRgyehbN8fd3in3TvHNeTh17NIjIy8rndGPwyK8hEYOJ4woC
	 z5Pq6b+6BoM66BA9VpnFOLzal49GAHK/nFhBZx9kerNsCt2/b4psBlXL8nvsynNOoP
	 upH4tKmvy4K+A==
Date: Thu, 20 Feb 2025 14:48:27 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
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
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v7 00/17] Provide a new two step DMA mapping API
Message-ID: <20250220124827.GR53094@unreal>
References: <cover.1738765879.git.leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1738765879.git.leonro@nvidia.com>

On Wed, Feb 05, 2025 at 04:40:20PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v7:
>  * Rebased to v6.14-rc1

<...>

> Christoph Hellwig (6):
>   PCI/P2PDMA: Refactor the p2pdma mapping helpers
>   dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
>   iommu: generalize the batched sync after map interface
>   iommu/dma: Factor out a iommu_dma_map_swiotlb helper
>   dma-mapping: add a dma_need_unmap helper
>   docs: core-api: document the IOVA-based API
> 
> Leon Romanovsky (11):
>   iommu: add kernel-doc for iommu_unmap and iommu_unmap_fast
>   dma-mapping: Provide an interface to allow allocate IOVA
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
> 
>  Documentation/core-api/dma-api.rst   |  70 ++++
>  drivers/infiniband/core/umem_odp.c   | 250 +++++---------
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +-
>  drivers/infiniband/hw/mlx5/odp.c     |  65 ++--
>  drivers/infiniband/hw/mlx5/umr.c     |  12 +-
>  drivers/iommu/dma-iommu.c            | 468 +++++++++++++++++++++++----
>  drivers/iommu/iommu.c                |  84 ++---
>  drivers/pci/p2pdma.c                 |  38 +--
>  drivers/vfio/pci/mlx5/cmd.c          | 375 +++++++++++----------
>  drivers/vfio/pci/mlx5/cmd.h          |  35 +-
>  drivers/vfio/pci/mlx5/main.c         |  87 +++--
>  include/linux/dma-map-ops.h          |  54 ----
>  include/linux/dma-mapping.h          |  85 +++++
>  include/linux/hmm-dma.h              |  33 ++
>  include/linux/hmm.h                  |  21 ++
>  include/linux/iommu.h                |   4 +
>  include/linux/pci-p2pdma.h           |  84 +++++
>  include/rdma/ib_umem_odp.h           |  25 +-
>  kernel/dma/direct.c                  |  44 +--
>  kernel/dma/mapping.c                 |  18 ++
>  mm/hmm.c                             | 264 +++++++++++++--
>  21 files changed, 1435 insertions(+), 693 deletions(-)
>  create mode 100644 include/linux/hmm-dma.h

Kind reminder.

Thanks

> 
> -- 
> 2.48.1
> 
> 

