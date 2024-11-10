Return-Path: <kvm+bounces-31383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 38B789C32FC
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 16:03:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E47ED1F21278
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 15:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CECD6EB7C;
	Sun, 10 Nov 2024 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TVwmLxWU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420A510A3E;
	Sun, 10 Nov 2024 15:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731250982; cv=none; b=o9xXswtvsqJ3pMKWyGeHs/YLrUrPjoIDgh0Gy/qwoU4U340OKRPT0VKKZNUb/9R8oFbFtfsaHU3y0Rrl+16zSsmO0FdNkx0mrbratrVZyYS0BCBt1Y70p0e6ZbXsYNY+ri7rzAWx4VhzpIMsSVKlysypWZWEwJAT1P+HJfpZjbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731250982; c=relaxed/simple;
	bh=H99CbGRSaGSXRVVV52m+AMob/IL4Q3/JGWfnpSNKENA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qYNkIGHC7tL5b0abw/xdTn7xIEyoLqzG2dsyNxuqxOFOQYC/ZA1tYn3sDOuC7mlAsip2D4w7Dtss2hB76KrSsu3IJL7bIbtwpHUcNH1c7vVt4TWwFRtZc1mZwYlsDOV4oj9Tk6obm0aOeMcqAKQdTxYQNjEGwLf7M6E+lUZTcq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TVwmLxWU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3832C4CECD;
	Sun, 10 Nov 2024 15:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731250981;
	bh=H99CbGRSaGSXRVVV52m+AMob/IL4Q3/JGWfnpSNKENA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TVwmLxWUT7636wtSIn/3F7AHWh+dZu3txdkZkItxm0unJgeW4KtiXZiL58gs803AM
	 cTpgx0WCmXHbvyxIBCXr9DzDU8JA5n8/NOqsyMf5XRKN9MrEZC2eZCOvpczcv9ACHK
	 v7ZXQN5CjinJIlrQeu407CMxIv4Jwpdh7jkYYY9OFwo/6QpZFHmzzoIZf8RnJccdNf
	 NsWv7ffb0rNdugoOgO3buFkBdpsGyVD3In32RFY7yDdnQdNmmNQN/FpOXboCyQtddN
	 XvDtXEENeXdPZpCAoONbZK5EEPQYRj2pbnVHWqVbQ1EghtJIyvMAcCNVr1Iw+r0JLN
	 5lMdfUvidgOnQ==
Date: Sun, 10 Nov 2024 17:02:55 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
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
Message-ID: <20241110150255.GC50588@unreal>
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
> Changelog:
> v3:

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
>   dma-mapping: Add check if IOVA can be used
>   dma: Provide an interface to allow allocate IOVA
>   dma-mapping: Implement link/unlink ranges API
>   mm/hmm: let users to tag specific PFN with DMA mapped bit
>   mm/hmm: provide generic DMA managing logic

This patch detached from thread and can be found here.
https://lore.kernel.org/all/a42f5a1ede10d4181c5cab3c88ed43a04be79565.1731245995.git.leon@kernel.org

Thanks

>   RDMA/umem: Store ODP access mask information in PFN
>   RDMA/core: Convert UMEM ODP DMA mapping to caching IOVA and page
>     linkage
>   RDMA/umem: Separate implicit ODP initialization from explicit ODP
>   vfio/mlx5: Explicitly use number of pages instead of allocated length
>   vfio/mlx5: Rewrite create mkey flow to allow better code reuse
>   vfio/mlx5: Enable the DMA link API

