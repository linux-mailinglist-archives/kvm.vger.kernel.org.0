Return-Path: <kvm+bounces-20959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CEF7927706
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 15:19:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4011B235DD
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 13:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5511F1AED37;
	Thu,  4 Jul 2024 13:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/KR/8A6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC377E9;
	Thu,  4 Jul 2024 13:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720099125; cv=none; b=Cd3Oq5FROlN2cmWhNuf6CWLbi+G/3Yqp9irgCUD27yC2o+JDLUMzi99Lw5Sa7FFT6ABbO4J1dAgIDWA/o+rj6dx6pdyWHV9QUmAjNC9v3xs5MtIWSwWzVcPrWDhsdE7WGaZua8F5SQyP8AfhtwUoBzlehEfVRk7NosE7gVNkX28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720099125; c=relaxed/simple;
	bh=nkzC1R2Sn6KADvFNDPp0hrnIwln3xVG+eb9R42IPSdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VsSMcTzcsbyiGYoOpFqQH4/YM3fyL9SB7SHhF+aWCkS//437E/E9pPZWigixewpzn/P9N462CeAWLWNHpMXpz0Ti7r1V0dh3O9RBJYqMJuZ6382D0UR20xjJ6DPlYJaihfpiojqnqMvBV78Qk556H7FT+OIvxjUVFS78lQ8jDZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D/KR/8A6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0368AC3277B;
	Thu,  4 Jul 2024 13:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720099124;
	bh=nkzC1R2Sn6KADvFNDPp0hrnIwln3xVG+eb9R42IPSdQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D/KR/8A6xd5D4R/wyMmVXVBhTLC00uoxpBMQxG4XlqhIi5KAQVaC2WfSC/JKuTQBK
	 kEFxwYczrrp8jHD/rU7Io7O7FanCrAZSqBu/PdOnbPEDswb3D7N14ui//u++auZfNR
	 SUqz2Rl1HBcmgvgZwCQlOkR19edRQbzDh6tI/mypTJD/RTH4hYtagEvYh76WNN1/VY
	 UCe/SDCeqqwlLAKAvWNk+uJtnN8vjygt8Gaomlc3u7lhSQZuSImjGamtHE5l/qm9H/
	 l7cdU0pdx3G3PZZgD6CMT+HJGLLMzzhXBkWp2c6sJY4t+AJp3EHJFmV84AgiTky6jN
	 DmhQgo4POHvOw==
Date: Thu, 4 Jul 2024 16:18:39 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Keith Busch <kbusch@kernel.org>,
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
Subject: Re: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
Message-ID: <20240704131839.GD95824@unreal>
References: <cover.1719909395.git.leon@kernel.org>
 <20240703054238.GA25366@lst.de>
 <20240703105253.GA95824@unreal>
 <20240703143530.GA30857@lst.de>
 <20240703155114.GB95824@unreal>
 <20240704074855.GA26913@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240704074855.GA26913@lst.de>

On Thu, Jul 04, 2024 at 09:48:56AM +0200, Christoph Hellwig wrote:
> On Wed, Jul 03, 2024 at 06:51:14PM +0300, Leon Romanovsky wrote:
> > If we put aside this issue, do you think that the proposed API is the right one?
> 
> I haven't look at it in detail yet, but from a quick look there is a
> few things to note:
> 
> 
> 1) The amount of code needed in nvme worries me a bit.  Now NVMe a messy
> driver due to the stupid PRPs vs just using SGLs, but needing a fair
> amount of extra boilerplate code in drivers is a bit of a warning sign.
> I plan to look into this to see if I can help on improving it, but for
> that I need a working version first.

Chaitanya is working on this and I'll join him to help on next Sunday,
after I'll return to the office from my sick leave/

> 
> 
> 2) The amount of seemingly unrelated global headers pulled into other
> global headers.  Some of this might just be sloppiness, e.g. I can't
> see why dma-mapping.h would actually need iommu.h to start with,
> but pci.h in dma-map-ops.h is a no-go.

pci.h was pulled because I needed to call to pci_p2pdma_map_type()
in dma_can_use_iova().

> 
> 3) which brings me to real layering violations.  dev_is_untrusted and
> dev_use_swiotlb are DMA API internals, no way I'd ever want to expose
> them. dma-map-ops.h is a semi-internal header only for implementations
> of the dma ops (as very clearly documented at the top of that file),
> it must not be included by drivers.  Same for swiotlb.h.

These item shouldn't worry you and will be changed in the final version.
They are outcome of patch "RDMA/umem: Prevent UMEM ODP creation with SWIOTLB".
https://lore.kernel.org/all/d18c454636bf3cfdba9b66b7cc794d713eadc4a5.1719909395.git.leon@kernel.org/

All HMM users need such "prevention" so it will be moved to a common place.

> 
> Not quite as concerning, but doing an indirect call for each map
> through dma_map_ops in addition to the iommu ops is not every efficient.
> We've through for a while to allow direct calls to dma-iommu similar
> how we do direct calls to dma-direct from the core mapping.c code.
> This might be a good time to do that as a prep step for this work.

Sure, no problem, will start in parallel to work on this.

> 

