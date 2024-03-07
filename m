Return-Path: <kvm+bounces-11310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B04628752B4
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 16:05:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB4931C24C58
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 15:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF2312F365;
	Thu,  7 Mar 2024 15:05:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2174E1DFC1;
	Thu,  7 Mar 2024 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709823918; cv=none; b=khZJ6v26ze6x/gyHQAtE9UYmuGAl4KlEHZmskMe44EHiAtEVnoChtuZiC/6DypaEEtt3e8a3aO+B7j4DUJNMfLdEtkVK+LF/Zs8VbZ2ruhltY00wnGTv1p6lsquI3QKMBSs4YTLmrWtbSHXX5357JQsozqNpTJt21YpY2DE5r20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709823918; c=relaxed/simple;
	bh=KcbjcoK0enYuZVWxTVuA3A7m2RX5v0vJJmwup26L1hs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m/rkZhNRVb1YBGtGjoMLGPnUT1c0Rj+JaQ5tUtYIilNOa7HeuU+hbxeWrUtSpmDd3PIpcHp/vEdcjIbiBRcQihPddW1qIBT6IEuz6VjZY09hX8kgm7Kua6fwUJ5wr/HmofeSyNnjP6jcDksuUNqh6T1e8h0cHA1Veojxx3vEd6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6CF2168CFE; Thu,  7 Mar 2024 16:05:05 +0100 (CET)
Date: Thu, 7 Mar 2024 16:05:05 +0100
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
Message-ID: <20240307150505.GA28978@lst.de>
References: <cover.1709635535.git.leon@kernel.org> <47afacda-3023-4eb7-b227-5f725c3187c2@arm.com> <20240305122935.GB36868@unreal> <20240306144416.GB19711@lst.de> <20240306154328.GM9225@ziepe.ca> <20240306162022.GB28427@lst.de> <20240306174456.GO9225@ziepe.ca> <20240306221400.GA8663@lst.de> <20240307000036.GP9225@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307000036.GP9225@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 06, 2024 at 08:00:36PM -0400, Jason Gunthorpe wrote:
> > 
> > I don't think you can do without dma_addr_t storage.  In most cases
> > your can just store the dma_addr_t in the LE/BE encoded hardware
> > SGL, so no extra storage should be needed though.
> 
> RDMA (and often DRM too) generally doesn't work like that, the driver
> copies the page table into the device and then the only reason to have
> a dma_addr_t storage is to pass that to the dma unmap API. Optionally
> eliminating long term dma_addr_t storage would be a worthwhile memory
> savings for large long lived user space memory registrations.

It's just kinda hard to do.  For aligned IOMMU mapping you'd only
have one dma_addr_t mappings (or maybe a few if P2P regions are
involved), so this probably doesn't matter.  For direct mappings
you'd have a few, but maybe the better answer is to use THP
more aggressively and reduce the number of segments.

> I wrote the list as from a single IO operation perspective, so all but
> 5 need to store a single IOVA range that could be stored in some
> simple non-dynamic memory along with whatever HW SGLs/etc are needed.
> 
> The point of 5 being different is because the driver has to provide a
> dynamically sized list of dma_addr_t's as storage until unmap. 5 is
> the only case that requires that full list.

No, all cases need to store one or more ranges.

> > > So are you thinking something more like a driver flow of:
> > > 
> > >   .. extent IO and get # aligned pages and know if there is P2P ..
> > >   dma_init_io(state, num_pages, p2p_flag)
> > >   if (dma_io_single_range(state)) {
> > >        // #2, #4
> > >        for each io()
> > > 	    dma_link_aligned_pages(state, io range)
> > >        hw_sgl = (state->iova, state->len)
> > >   } else {
> > 
> > I think what you have a dma_io_single_range should become before
> > the dma_init_io.  If we know we can't coalesce it really just is a
> > dma_map_{single,page,bvec} loop, no need for any extra state.
> 
> I imagine dma_io_single_range() to just check a flag in state.
> 
> I still want to call dma_init_io() for the non-coalescing cases
> because all the flows, regardless of composition, should be about as
> fast as dma_map_sg is today.

If all flows includes multiple non-coalesced regions that just makes
things very complicated, and that's exactly what I'd want to avoid.

> That means we need to always pre-allocate the IOVA in any case where
> the IOMMU might be active - even on a non-coalescing flow.
> 
> IOW, dma_init_io() always pre-allocates IOVA if the iommu is going to
> be used and we can't just call today's dma_map_page() in a loop on the
> non-coalescing side and pay the overhead of Nx IOVA allocations.
> 
> In large part this is for RDMA, were a single P2P page in a large
> multi-gigabyte user memory registration shouldn't drastically harm the
> registration performance by falling down to doing dma_map_page, and an
> IOVA allocation, on a 4k page by page basis.

But that P2P page needs to be handled very differently, as with it
we can't actually use a single iova range.  So I'm not sure how that
is even supposed to work.  If you have

 +-------+-----+-------+
 | local | P2P | local |
 +-------+-----+-------+

you need at least 3 hw SGL entries, as the IOVA won't be contigous.

> The other thing that got hand waved here is how does dma_init_io()
> know which of the 6 states we are looking at? I imagine we probably
> want to do something like:
> 
>    struct dma_io_summarize summary = {};
>    for each io()
>         dma_io_summarize_range(&summary, io range)
>    dma_init_io(dev, &state, &summary);
>    if (state->single_range) {
>    } else {
>    }
>    dma_io_done_mapping(&state); <-- flush IOTLB once

That's why I really just want 2 cases.  If the caller guarantees the
range is coalescable and there is an IOMMU use the iommu-API like
API, else just iter over map_single/page.

> Enhancing the single sgl case is not a big change, I think. It does
> seem simplifying for the driver to not have to coalesce SGLs to detect
> the single-SGL fast-path.
> 
> > > This is not quite what you said, we split the driver flow based on
> > > needing 1 HW SGL vs need many HW SGL.
> > 
> > That's at least what I intended to say, and I'm a little curious as what
> > it came across.
> 
> Ok, I was reading the discussion more about as alignment than single
> HW SGL, I think you ment alignment as implying coalescing behavior
> implying single HW SGL..

Yes.

