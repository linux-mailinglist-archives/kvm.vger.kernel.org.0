Return-Path: <kvm+bounces-31115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 778B69C0815
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 14:51:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F992B22B7A
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 13:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC5F9212D1B;
	Thu,  7 Nov 2024 13:50:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5A3212630;
	Thu,  7 Nov 2024 13:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730987436; cv=none; b=Q/S/ZMD1m0iubazk22sMU3LGYFJHPFpBpVCt9Y0A0Pp9NC6GdJpfO4LxENHGnItsHes9CPVMuit5x5NhXCL0ISdY6ZcurdzUuVcD+n2Bjx+wkoC34U2FxHeZTRGjUbN3eus3PiIkJ17pBN2UNKc9xhKEaIxUKYkf8Bp+Ht3jdLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730987436; c=relaxed/simple;
	bh=fgn4sel1p5t88qRO7ExDxdwas+YGL5pgazTpkpcAbsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XcpimXPVJD83fYXhJFY+17l/p+NaV6tC+Z2cqNF9OVbYx6B61qgYsWRbahep1NQCupPVFr152ApssVBReAs6J7qodQvhf6AqjSa17VVB6yF0uES4V4i2xxkpYfH+eq/yKDoEM1hQcUQAhTWPw9Dglcxs8tJgEbuQ6PygakgDQXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A292468C4E; Thu,  7 Nov 2024 14:50:25 +0100 (CET)
Date: Thu, 7 Nov 2024 14:50:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>,
	Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
	Thomas.Hellstrom@linux.intel.com, brian.welty@intel.com,
	himal.prasad.ghimiray@intel.com, krishnaiah.bommu@intel.com,
	niranjana.vishwanathapura@intel.com
Subject: Re: [PATCH v1 00/17] Provide a new two step DMA mapping API
Message-ID: <20241107135025.GA14996@lst.de>
References: <cover.1730298502.git.leon@kernel.org> <3567312e-5942-4037-93dc-587f25f0778c@arm.com> <20241104095831.GA28751@lst.de> <20241105195357.GI35848@ziepe.ca> <20241107083256.GA9071@lst.de> <20241107132808.GK35848@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107132808.GK35848@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 07, 2024 at 09:28:08AM -0400, Jason Gunthorpe wrote:
> Once we are freed from scatterlist we can explore a design that would
> pass the P2P routing information directly. For instance imagine
> something like:
> 
>    dma_map_p2p(dev, phys, p2p_provider);
> 
> Then dma_map_page(dev, page) could be something like
> 
>    if (is_pci_p2pdma_page(page))
>       dev_map_p2p(dev, page_to_phys(page), page->pgmap->p2p_provider)

One thing that this series does is to move the P2P mapping decisions out
of the low-level dma mapping helpers and into the caller (again) for
the non-sg callers and moves the special switch based bus mapping into
a routine that can be called directly.

Take a look at blk_rq_dma_map_iter_start, which now literally uses
dma_map_page for the no-iommu, no-switch P2P case.  It also is a good
use case for the proposed dma_map_phys.

> GPU driver
> 
> https://lore.kernel.org/dri-devel/20240117221223.18540-7-oak.zeng@intel.com/

Eww, that's horrible.  Converting this to Leon's new hmm helpers
would be really nice (and how that they are useful for more than
mlx5).


