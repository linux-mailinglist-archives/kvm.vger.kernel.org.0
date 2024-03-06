Return-Path: <kvm+bounces-11203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C199B87428C
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 775271F23036
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 22:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41F11BF5C;
	Wed,  6 Mar 2024 22:14:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397D61BDED;
	Wed,  6 Mar 2024 22:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709763249; cv=none; b=mC+aEtdKRir+ZDMz1hq3oZCbUBtXUvtTxfI8MUwzI7oXsiNMi5ppyZujBv5+2gFzDwkYG4rtUvKbvRRU2jMxWfyrLXHtKAOfRefN0sSvkP3MpuzGM6o2lGewIyuxg3Z+g/1NjjgcNyR/qYJCTVHy9Nuug1N0XSPyYdpd6P5MLYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709763249; c=relaxed/simple;
	bh=ZRvTmNRqpxW4X0oWSN8HCjjORJ85EhOCc8pC07Wc42M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XtvzMfmGPb582tq6+GSaAy0xjP92NKZXNl33U7hyI+RJtj/r15n1IYIjx3rgnSG5loT7ditnPUtSQJDsaYG+khEAMb1iFmOcxXPeM6Km2uWvytakyFx3QUv72mZMYlo9RXqrTxwektPvOmzsQl6Q/kb5N/gj9lwODhSdFJoiCPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B087E68C4E; Wed,  6 Mar 2024 23:14:00 +0100 (CET)
Date: Wed, 6 Mar 2024 23:14:00 +0100
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
Message-ID: <20240306221400.GA8663@lst.de>
References: <cover.1709635535.git.leon@kernel.org> <47afacda-3023-4eb7-b227-5f725c3187c2@arm.com> <20240305122935.GB36868@unreal> <20240306144416.GB19711@lst.de> <20240306154328.GM9225@ziepe.ca> <20240306162022.GB28427@lst.de> <20240306174456.GO9225@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306174456.GO9225@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 06, 2024 at 01:44:56PM -0400, Jason Gunthorpe wrote:
> There is a list of interesting cases this has to cover:
> 
>  1. Direct map. No dma_addr_t at unmap, multiple HW SGLs
>  2. IOMMU aligned map, no P2P. Only IOVA range at unmap, single HW SGLs
>  3. IOMMU aligned map, P2P. Only IOVA range at unmap, multiple HW SGLs
>  4. swiotlb single range. Only IOVA range at unmap, single HW SGL
>  5. swiotlb multi-range. All dma_addr_t's at unmap, multiple HW SGLs.
>  6. Unaligned IOMMU. Only IOVA range at unmap, multiple HW SGLs
> 
> I think we agree that 1 and 2 should be optimized highly as they are
> the common case. That mainly means no dma_addr_t storage in either

I don't think you can do without dma_addr_t storage.  In most cases
your can just store the dma_addr_t in the LE/BE encoded hardware
SGL, so no extra storage should be needed though.

> 3 is quite similar to 1, but it has the IOVA range at unmap.

Can you explain what P2P case you mean?  The switch one with the
bus address is indeed basically the same, just with potentioally a
different offset, while the through host bridge case is the same
as a normal iommu map.

> 
> 4 is basically the same as 2 from the driver's viewpoint

I'd actually treat it the same as one.

> 5 is the slowest and has the most overhead.

and 5 could be broken into multiple 4s at least for now.  Or do you
have a different dfinition of range here?

> So are you thinking something more like a driver flow of:
> 
>   .. extent IO and get # aligned pages and know if there is P2P ..
>   dma_init_io(state, num_pages, p2p_flag)
>   if (dma_io_single_range(state)) {
>        // #2, #4
>        for each io()
> 	    dma_link_aligned_pages(state, io range)
>        hw_sgl = (state->iova, state->len)
>   } else {

I think what you have a dma_io_single_range should become before
the dma_init_io.  If we know we can't coalesce it really just is a
dma_map_{single,page,bvec} loop, no need for any extra state.

And we're back to roughly the proposal I sent out years ago.

> This is not quite what you said, we split the driver flow based on
> needing 1 HW SGL vs need many HW SGL.

That's at least what I intended to say, and I'm a little curious as what
it came across.


