Return-Path: <kvm+bounces-44492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4F4CA9E09C
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 09:53:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A67F15A6514
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 07:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62802472AC;
	Sun, 27 Apr 2025 07:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OmokyrrK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F15366;
	Sun, 27 Apr 2025 07:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745740419; cv=none; b=elYloxKKYcJTFLHSV2dhHFmM81zgBck3trN45/AftiF4lU3uZY0oqBBgRiixf8/v4vkWxgdzjIAJzDTvfIFxgkFpVOcAnoWq9Bok+kvTOsXLVhgKHRk+wx3FuMFIla4QgdiBVSL43tU5XqdRSt9xUmZ3bKFdlpOT7iXpmxP7QSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745740419; c=relaxed/simple;
	bh=iKyTQwydNmAM/0HcUlde1DtC+bZbAuPZo0BeWV99Sn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sQy/zUSDFekwZcMyPogIZATaX87cJP1y0nFyl7mRGyrL28dhfs7E7ij1vsLZprnlRzmSh+Qhh0Y559CCwNyuAmzpU1qaUyPg+48fzdkzSmaVlNVhguBVk/O9NqxnGF2BD1dxqwup0NF4kHIssTXEQ2lfj/6xma9Bt+5XFpsP0w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OmokyrrK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CD1C4CEE3;
	Sun, 27 Apr 2025 07:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745740418;
	bh=iKyTQwydNmAM/0HcUlde1DtC+bZbAuPZo0BeWV99Sn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OmokyrrKogcvAy75PZnoqbf/SV/3tN6a/jr9gHE56cV2aAUja1b1vR87w7sFYp9SM
	 2MTW/5zl9jZEDztFGGMRMoytnKxQ/fH3Nx6Llyyms85hrYsAaXPnI47FYKgA+tncyk
	 mkQJNR/IXAW+albRz+ErujsbIoPBM+w7flk409Lh3ddIk6MNaLOs5tByMzgIIbhf5K
	 jRQYMV0yr7lWDCaipx7Aq5g43zt2+567TjgKvYuKc8lxRSBlEQo2Qk0Kj38yk4NdCj
	 I1x37331Ys/wwpuT1EUyEcmT/tN7FXyY29DcKZ5RlQ/ztukgb7skj9uPZ3RY+pbnTx
	 CTtopc3JapJnQ==
Date: Sun, 27 Apr 2025 10:53:32 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
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
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v9 02/24] dma-mapping: move the PCI P2PDMA mapping
 helpers to pci-p2pdma.h
Message-ID: <20250427075332.GC5848@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <493a6ab31fdd73e84e16662578858f194e9f87b9.1745394536.git.leon@kernel.org>
 <aAwqBvLP3kaZsEdZ@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAwqBvLP3kaZsEdZ@bombadil.infradead.org>

On Fri, Apr 25, 2025 at 05:34:14PM -0700, Luis Chamberlain wrote:
> On Wed, Apr 23, 2025 at 11:12:53AM +0300, Leon Romanovsky wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > +enum pci_p2pdma_map_type {
> > +	/*
> > +	 * PCI_P2PDMA_MAP_UNKNOWN: Used internally for indicating the mapping
> > +	 * type hasn't been calculated yet. Functions that return this enum
> > +	 * never return this value.
> > +	 */
> 
> This last sentence is confusing. How about:
> 
> * PCI_P2PDMA_MAP_UNKNOWN: Used internally as an initial state before
> * the mapping type has been calculated. Exported routines for the API
> * will never return this value.

This patch moved code as is, but sure, let's update the comments.

> 
> > +	PCI_P2PDMA_MAP_UNKNOWN = 0,
> > +
> > +	/*
> > +	 * Not a PCI P2PDMA transfer.
> > +	 */
> > +	PCI_P2PDMA_MAP_NONE,
> > +
> > +	/*
> > +	 * PCI_P2PDMA_MAP_NOT_SUPPORTED: Indicates the transaction will
> > +	 * traverse the host bridge and the host bridge is not in the
> > +	 * allowlist. DMA Mapping routines should return an error when
> > +	 * this is returned.
> > +	 */
> > +	PCI_P2PDMA_MAP_NOT_SUPPORTED,
> > +
> > +	/*
> > +	 * PCI_P2PDMA_BUS_ADDR: Indicates that two devices can talk to
> 
> You mean   PCI_P2PDMA_MAP_BUS_ADDR

done

> 
> > + * pci_p2pdma_bus_addr_map - map a PCI_P2PDMA_MAP_BUS_ADDR P2P transfer
> 
> Hrm, maybe with a bit more clarity:
> 
> Translate a physical address to a bus address for a  PCI_P2PDMA_MAP_BUS_ADDR
> transfer.
> 
> 
> Other than that.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

Thanks

> 
>   Luis
> 

