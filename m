Return-Path: <kvm+bounces-35358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23AD3A10238
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 09:39:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AE911647A7
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 08:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C3928EC63;
	Tue, 14 Jan 2025 08:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ssv9xXhO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6AC1CDA19;
	Tue, 14 Jan 2025 08:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736843935; cv=none; b=rGW0xy4ucJRNbPK8F2Q6NLC1o0vXaBjGi+8zLPfInfiphyUSYkohtEoGf5ZEreLPlqH/nSQaYFUyzF76LWwwVxrM7kmilqh1OewoZL17X7vr2Ll7wkzFIoP+EPrQu5+k9h1wnRC5pSVi7JpQstPGOPY/VY04m0XDr69JmnsVm/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736843935; c=relaxed/simple;
	bh=WCmlIJb/eJ3RtRwBL0vbXX0Y9UrynyAEdph0c+wowPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fL0Xr8X8zyI0a/u3GvEX/o7PP+kalNtm0XPaSBemICoiVh//aP7oDh2W5WYv0HRABVFLgIsdrZt9cUkeFUdE15u2yBvZZnN19mVpkfITi/+G5LM7yni7nopqQ5zLT9Y4ta4RCDplBBsMtshG982cQ9fk3SVe/7t3FTayZFff5fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ssv9xXhO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3272C4CEDD;
	Tue, 14 Jan 2025 08:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736843934;
	bh=WCmlIJb/eJ3RtRwBL0vbXX0Y9UrynyAEdph0c+wowPY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ssv9xXhOL7JbMMQrzlaq27YWcIfBrJoOCeudEXG9TZo+CTwB4dvd5GSjmpavw7e45
	 mnFmWBsl8OxWd53GB8Ai3qRopj9qNOYzrIKnjN918usYV953p8Z71j8T9h8bRRgd80
	 mbGV/Q9H0WnXVRuMYHxZFQGgigZ6wJf8UrCX5GqCfJBdnZINfpgPJQrTxLzhlJg07Y
	 BIQWvXINHA2mvOIkrZyZDtdpZqKLm7qpvrTk+kx7XKDDXEu0pCnY7dzHvA1pZbR8yv
	 o9iPi8YszEl9iejfRQW/qe5KSfvou9DSiPIxxOEteYKg009tI7JHlqlu+nZukZHN0U
	 oaCRxAZ2exYjA==
Date: Tue, 14 Jan 2025 10:38:47 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
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
Subject: Re: [PATCH v5 00/17] Provide a new two step DMA mapping API
Message-ID: <20250114083847.GE3146852@unreal>
References: <cover.1734436840.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1734436840.git.leon@kernel.org>

On Tue, Dec 17, 2024 at 03:00:18PM +0200, Leon Romanovsky wrote:
> Changelog:

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
>  Documentation/core-api/dma-api.rst   |  70 +++++
>  drivers/infiniband/core/umem_odp.c   | 250 +++++----------
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +-
>  drivers/infiniband/hw/mlx5/odp.c     |  65 ++--
>  drivers/infiniband/hw/mlx5/umr.c     |  12 +-
>  drivers/iommu/dma-iommu.c            | 454 +++++++++++++++++++++++----
>  drivers/iommu/iommu.c                |  84 ++---
>  drivers/pci/p2pdma.c                 |  38 +--
>  drivers/vfio/pci/mlx5/cmd.c          | 376 +++++++++++-----------
>  drivers/vfio/pci/mlx5/cmd.h          |  35 ++-
>  drivers/vfio/pci/mlx5/main.c         |  87 +++--
>  include/linux/dma-map-ops.h          |  54 ----
>  include/linux/dma-mapping.h          |  86 +++++
>  include/linux/hmm-dma.h              |  33 ++
>  include/linux/hmm.h                  |  21 ++
>  include/linux/iommu.h                |   4 +
>  include/linux/pci-p2pdma.h           |  84 +++++
>  include/rdma/ib_umem_odp.h           |  25 +-
>  kernel/dma/direct.c                  |  44 +--
>  kernel/dma/mapping.c                 |  18 ++
>  mm/hmm.c                             | 264 ++++++++++++++--
>  21 files changed, 1423 insertions(+), 693 deletions(-)
>  create mode 100644 include/linux/hmm-dma.h

Hi Robin,

Can you please Ack the dma-iommu changes?

Thanks

> 
> -- 
> 2.47.0
> 
> 

