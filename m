Return-Path: <kvm+bounces-12447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F7B886361
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 23:39:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5049C1C2274A
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 22:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F5E46AAD;
	Thu, 21 Mar 2024 22:39:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD498F41;
	Thu, 21 Mar 2024 22:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711060765; cv=none; b=HW/jKfpcOAIwjGqwFBlCdQx0BsBs7/VFCA6mxzyeSMxYBlsNgRYE0v0jasIxqhTp92QCJLoZHdmt+MflhJNdr7dyUJJTmEYrTpySGSg4OBSam5INugG/nEBsvra6bxZLHVie6p+4zPbPTBpIO2mnF5xv6Ax8RmlOO+LhJ82GHF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711060765; c=relaxed/simple;
	bh=jl9wIcbi+M6xIcqdg2/AXtdvAbhe18vrLYJvJlJmxKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BqTDSMff75xPBCKjlj+IVhW5VSR7NWsmwYkDlNc8FJM647YMnXS+RMEYvbjPIRSvGDMo+I3lbpv/TtS76b9h1QpO90WP/tBRk8oiuND6VpG/HqUxlLznvRuKNCxyXztTU9cJEStVOjstpMWLSOCTKJx77FOugCHMaT8i6umNul0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 879B968BEB; Thu, 21 Mar 2024 23:39:11 +0100 (CET)
Date: Thu, 21 Mar 2024 23:39:10 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"jack@suse.com" <jack@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two
 steps
Message-ID: <20240321223910.GA22663@lst.de>
References: <20240306162022.GB28427@lst.de> <20240306174456.GO9225@ziepe.ca> <20240306221400.GA8663@lst.de> <20240307000036.GP9225@ziepe.ca> <20240307150505.GA28978@lst.de> <20240307210116.GQ9225@ziepe.ca> <20240308164920.GA17991@lst.de> <20240308202342.GZ9225@ziepe.ca> <20240309161418.GA27113@lst.de> <20240319153620.GB66976@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319153620.GB66976@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 19, 2024 at 12:36:20PM -0300, Jason Gunthorpe wrote:
> I kind of understand your thinking on the DMA side, but I don't see
> how this is good for users of the API beyond BIO.
> 
> How will this make RDMA better? We have one MR, the MR has pages, the
> HW doesn't care about the SW distinction of p2p, swiotlb, direct,
> encrypted, iommu, etc. It needs to create one HW page list for
> whatever user VA range was given.

Well, the hardware (as in the PCIe card) never cares.  But the setup
path for the IOMMU does, and something in the OS needs to know about
it.  So unless we want to stash away a 'is this P2P' flag in every
page / SG entry / bvec, or a do a lookup to find that out for each
of them we need to manage chunks at these boundaries.  And that's
what I'm proposing.

> Or worse, whatever thing is inside a DMABUF from a DRM
> driver. DMABUF's can have a (dynamic!) mixture of P2P and regular
> AFAIK based on the GPU's migration behavior.

And that's fine.  We just need to track it efficiently.

> 
> Or triple worse, ODP can dynamically change on a page by page basis
> the type depending on what hmm_range_fault() returns.

Same.  If this changes all the time you need to track it.  And we
should find a way to shared the code if we have multiple users for it.

But most DMA API consumers will never see P2P, and when they see it
it will be static.  So don't build the DMA API to automically do
the (not exactly super cheap) checks and add complexity for it.

> So I take it as a requirement that RDMA MUST make single MR's out of a
> hodgepodge of page types. RDMA MRs cannot be split. Multiple MR's are
> not a functional replacement for a single MR.

But MRs consolidate multiple dma addresses anyway.

> Go back to the start of what are we trying to do here:
>  1) Make a DMA API that can support hmm_range_fault() users in a
>     sensible and performant way
>  2) Make a DMA API that can support RDMA MR's backed by DMABUF's, and
>     user VA's without restriction
>  3) Allow to remove scatterlist from BIO paths
>  4) Provide a DMABUF API that is not scatterlist that can feed into
>     the new DMA API - again supporting DMABUF's hodgepodge of types.
> 
> I'd like to do all of these things. I know 3 is your highest priority,
> but it is my lowest :)

Well, 3 an 4.  And 3 is not just limited to bio, but all the other
pointless scatterlist uses.


