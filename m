Return-Path: <kvm+bounces-31850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D979C8BD8
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 14:30:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B0C0281FFA
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 13:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B87A1CAB8;
	Thu, 14 Nov 2024 13:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrph4l+r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869518F62;
	Thu, 14 Nov 2024 13:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731591021; cv=none; b=tdaOEieY9S2AEUkDVe4S2ZBkXzZlIDUWohT8pCYD7uWaW3szyt9HJxb1t68SL+/ASYYsoVE7tetrwnqZuvBZXMdVIjNNYPLGwtsGwz2j+JRfSL7/cegUWH/4nLlMg070DUEdRTNYAKIvZT3URhMpr8f1/BEan4HPqUjMY5ntdoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731591021; c=relaxed/simple;
	bh=9WziBDbWuCJavDfebCiGijovNr2dEkFb5dOslEqLDxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=igL1OHI8dEBaKhskqo37kH25c3yEKTWH9Bcsb/7O/owj1gNPiTxqADyB7J0gyv48Q4Sraa+R2+2eiSliAYG2zGAU6mvwS3u8jDhnTrdbAXrZ89cDLzgwNEPwjZDiEbvjGIdJK9DgZuNLTXfKWbL+5RDxBc50qjlwF73bVydKVus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrph4l+r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3201DC4CED4;
	Thu, 14 Nov 2024 13:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731591020;
	bh=9WziBDbWuCJavDfebCiGijovNr2dEkFb5dOslEqLDxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lrph4l+r9SSW6Ri0yQO/ArvA5mrKpwgqxbiicodwQYX0FHUkW5FS5KI2v/78sx87r
	 p73mV8BzATegMAtr83CJrFyMrRrUdKqASvhJn+r/yI9rHIO/4m6KxV76EsYSPZym8j
	 VCUAgoN110ZQL9l00tP/BN7Gz6BdDwpinKAfJ5LBDL4OFafqxyWJ/CbeoUse2vhBTY
	 7r9HCx2mL1JQWljOWXFrKyW5/bkepvwmWx/DOITJk+lWy0E+U9MdlrCzr5QlTRbtNH
	 cX9+7de7U+/FfUqKiffWcA7DkZOnNhx55wm/AhHYvudtAa9MVpYv9xmRDGbaVy8rhH
	 0cpO1PSEk8NLA==
Date: Thu, 14 Nov 2024 15:30:11 +0200
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
Message-ID: <20241114133011.GA606631@unreal>
References: <cover.1731244445.git.leon@kernel.org>
 <20241112072040.GG71181@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112072040.GG71181@unreal>

On Tue, Nov 12, 2024 at 09:20:40AM +0200, Leon Romanovsky wrote:
> On Sun, Nov 10, 2024 at 03:46:47PM +0200, Leon Romanovsky wrote:
> 
> <...>
> 
> > ----------------------------------------------------------------------------
> > The code can be downloaded from:
> > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tag:dma-split-nov-09
> 
> <...>
> 
> > 
> > Christoph Hellwig (6):
> >   PCI/P2PDMA: Refactor the p2pdma mapping helpers
> >   dma-mapping: move the PCI P2PDMA mapping helpers to pci-p2pdma.h
> >   iommu: generalize the batched sync after map interface
> >   iommu/dma: Factor out a iommu_dma_map_swiotlb helper
> >   dma-mapping: add a dma_need_unmap helper
> >   docs: core-api: document the IOVA-based API
> > 
> > Leon Romanovsky (11):
> >   dma-mapping: Add check if IOVA can be used
> >   dma: Provide an interface to allow allocate IOVA
> >   dma-mapping: Implement link/unlink ranges API
> >   mm/hmm: let users to tag specific PFN with DMA mapped bit
> >   mm/hmm: provide generic DMA managing logic
> >   RDMA/umem: Store ODP access mask information in PFN
> >   RDMA/core: Convert UMEM ODP DMA mapping to caching IOVA and page
> >     linkage
> >   RDMA/umem: Separate implicit ODP initialization from explicit ODP
> >   vfio/mlx5: Explicitly use number of pages instead of allocated length
> >   vfio/mlx5: Rewrite create mkey flow to allow better code reuse
> >   vfio/mlx5: Enable the DMA link API
> 
> Robin,
> 
> All technical concerns were handled and this series is ready to be merged.
> 
> Robin, can you please Ack the dma-iommu patches?

I don't see any response, so my assumption is that this series is ready
to be merged. Let's do it this cycle and save from us the burden of
having dependencies between subsystems.

Thanks

> 
> Thanks
> 

