Return-Path: <kvm+bounces-11375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A5638768D6
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 17:49:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF993B223EB
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 16:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58A01F615;
	Fri,  8 Mar 2024 16:49:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72C01C295;
	Fri,  8 Mar 2024 16:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709916571; cv=none; b=GzBdn1IQXyzYqn6ErG7GRwTr+2VKV7HPJwYZgHM1g6llE4tjVuovQmya/5j7+ofYj1zMqje7vz4eiAWZEfUc0MpMSDbL1Ibhnj7NLTSPiXWO/tfmQK9K0QIIjPlEo8yxNzL4+frlqDWeJpeDOpEjh0Yl6srW0gOfsh6hOGqOX8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709916571; c=relaxed/simple;
	bh=KzdKUekyi9rBF/gDC5z7G4GjeHKa0pomXxJxjC5D0Xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dplyUU3oQ489ZG7EOUXb2fiNPGjdbyoe5PzKd8NYCCknNTHSWk6kYxj7XYZWVdGwpcUz55jWdkMBPWDwNbJHhposntsq9mj6JFIuvZ/VhYZsM/BOCqbKxcJXJk6HY0sSMUO2QEmwLUuOjUTrTUH1FIS4+BOhFOIXo8jNJHaSp1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E414168BEB; Fri,  8 Mar 2024 17:49:20 +0100 (CET)
Date: Fri, 8 Mar 2024 17:49:20 +0100
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
Message-ID: <20240308164920.GA17991@lst.de>
References: <47afacda-3023-4eb7-b227-5f725c3187c2@arm.com> <20240305122935.GB36868@unreal> <20240306144416.GB19711@lst.de> <20240306154328.GM9225@ziepe.ca> <20240306162022.GB28427@lst.de> <20240306174456.GO9225@ziepe.ca> <20240306221400.GA8663@lst.de> <20240307000036.GP9225@ziepe.ca> <20240307150505.GA28978@lst.de> <20240307210116.GQ9225@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307210116.GQ9225@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 07, 2024 at 05:01:16PM -0400, Jason Gunthorpe wrote:
> > 
> > It's just kinda hard to do.  For aligned IOMMU mapping you'd only
> > have one dma_addr_t mappings (or maybe a few if P2P regions are
> > involved), so this probably doesn't matter.  For direct mappings
> > you'd have a few, but maybe the better answer is to use THP
> > more aggressively and reduce the number of segments.
> 
> Right, those things have all been done. 100GB of huge pages is still
> using a fair amount of memory for storing dma_addr_t's.
> 
> It is hard to do perfectly, but I think it is not so bad if we focus
> on the direct only case and simple systems that can exclude swiotlb
> early on.

Even with direct mappings only we still need to take care of
cache synchronization.

> > If all flows includes multiple non-coalesced regions that just makes
> > things very complicated, and that's exactly what I'd want to avoid.
> 
> I don't see how to avoid it unless we say RDMA shouldn't use this API,
> which is kind of the whole point from my perspective..

The DMA API callers really need to know what is P2P or not for
various reasons.  And they should generally have that information
available, either from pin_user_pages that needs to special case
it or from the in-kernel I/O submitter that build it from P2P and
normal memory.

> Sure, 3 SGL entries is fine, that isn't what I'm pointing at
> 
> I'm saying that today if you give such a scatterlist to dma_map_sg()
> it scans it and computes the IOVA space need, allocates one IOVA
> space, then subdivides that single space up into the 3 HW SGLs you
> show.
> 
> If you don't preserve that then we are calling, 4k at a time, a
> dma_map_page() which is not anywhere close to the same outcome as what
> dma_map_sg did. I may not get contiguous IOVA, I may not get 3 SGLs,
> and we call into the IOVA allocator a huge number of times.

Again, your callers must know what is a P2P region and what is not.
I don't think it is a hard burdern to do mappings at that granularity,
and we can encapsulate this in nice helpes for say the block layer
and pin_user_pages callers to start.

> 
> It needs to work following the same basic structure of dma_map_sg,
> unfolding that logic into helpers so that the driver can provide
> the data structure:
> 
>  - Scan the io ranges and figure out how much IOVA needed
>    (dma_io_summarize_range)

That is in general a function of the upper layer and not the DMA code.

>  - Allocate the IOVA (dma_init_io)

And this step is only needed for the iommu case.

> > That's why I really just want 2 cases.  If the caller guarantees the
> > range is coalescable and there is an IOMMU use the iommu-API like
> > API, else just iter over map_single/page.
> 
> But how does the caller even know if it is coalescable? Other than the
> trivial case of a single CPU range, that is a complicated detail based
> on what pages are inside the range combined with the capability of the
> device doing DMA. I don't see a simple way for the caller to figure
> this out. You need to sweep every page and collect some information on
> it. The above is to abstract that detail.

dma_get_merge_boundary already provides this information in terms
of the device capabilities.  And given that the callers knows what
is P2P and what is not we have all the information that is needed.


