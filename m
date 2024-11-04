Return-Path: <kvm+bounces-30483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 961969BB06F
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:58:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B80F2823EC
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94FA71B0F04;
	Mon,  4 Nov 2024 09:58:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0431F1AC43A;
	Mon,  4 Nov 2024 09:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730714322; cv=none; b=V73v9GV5bllLdY5Tsdl4wamL1QtjxwKIqfd7qzOdplSj3vOD7Uut4XkdT2N3PCwvj4ymQ4no3NdDY1TQPpdKhshBVroo76t3unchcHXORlJjMu4jS4avEzigsUeZvzux9p4bryI0iOOK5Ek4nlToL1f7nYiZjUloHxeMyPhTk+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730714322; c=relaxed/simple;
	bh=cGc3p1RFcABDoSgLbkrGYjJv7Mesj0EoAuHiRfKkhAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r5JeEGzYWMvq9KMV6l6lu6ywy5BptCkhHy+dSFPzflj+VtaNNrSN2tm398mpI1d4fC9/aDsPFa5MLrFx5VBjMegLZo2Ug45+5l30KCx6YNhcyv0tSLZOmsSPoUkYuhBaCJy0fUuVqSTuW9ZgVJjWayxo17Zi/DwVocIIKaQF1gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EF664227AAD; Mon,  4 Nov 2024 10:58:31 +0100 (CET)
Date: Mon, 4 Nov 2024 10:58:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 00/17] Provide a new two step DMA mapping API
Message-ID: <20241104095831.GA28751@lst.de>
References: <cover.1730298502.git.leon@kernel.org> <3567312e-5942-4037-93dc-587f25f0778c@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3567312e-5942-4037-93dc-587f25f0778c@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 31, 2024 at 09:17:45PM +0000, Robin Murphy wrote:
> The hilarious amount of work that iommu_dma_map_sg() does is pretty much 
> entirely for the benefit of v4l2 and dma-buf importers who *depend* on 
> being able to linearise a scatterlist in DMA address space. TBH I doubt 
> there are many actual scatter-gather-capable devices with significant 
> enough limitations to meaningfully benefit from DMA segment combining these 
> days - I've often thought that by now it might be a good idea to turn that 
> behaviour off by default and add an attribute for callers to explicitly 
> request it.

Even when devices are not limited they often perform significantly better
when IOVA space is not completely fragmented.  While the dma_map_sg code
is a bit gross due to the fact that it has to deal with unaligned segments,
the coalescing itself often is a big win.

Note that dma_map_sg also has two other very useful features:  batching
of the iotlb flushing, and support for P2P, which to be efficient also
requires batching the lookups.

>> This uniqueness has been a long standing pain point as the scatterlist API
>> is mandatory, but expensive to use.
>
> Huh? When and where has anything ever called it mandatory? Nobody's getting 
> sent to DMA jail for open-coding:

You don't get sent to jail.  But you do not get batched iotlb sync, you
don't get properly working P2P, and you don't get IOVA coalescing.

>> Several approaches have been explored to expand the DMA API with additional
>> scatterlist-like structures (BIO, rlist), instead split up the DMA API
>> to allow callers to bring their own data structure.
>
> And this line of reasoning is still "2 + 2 = Thursday" - what is to say 
> those two notions in any way related? We literally already have one generic 
> DMA operation which doesn't operate on struct page, yet needed nothing 
> "split up" to be possible.

Yeah, I don't really get the struct page argument.  In fact if we look
at the nitty-gritty details of dma_map_page it doesn't really need a
page at all.  I've been looking at cleaning some of this up and providing
a dma_map_phys/paddr which would be quite handy in a few places.  Note
because we don't have a struct page for the memory, but because converting
to/from it all the time is not very efficient.

>>   2. VFIO PCI live migration code is building a very large "page list"
>>      for the device. Instead of allocating a scatter list entry per allocated
>>      page it can just allocate an array of 'struct page *', saving a large
>>      amount of memory.
>
> VFIO already assumes a coherent device with (realistically) an IOMMU which 
> it explicitly manages - why is it even pretending to need a generic DMA 
> API?

AFAIK that does isn't really vfio as we know it but the control device
for live migration.  But Leon or Jason might fill in more.

The point is that quite a few devices have these page list based APIs
(RDMA where mlx5 comes from, NVMe with PRPs, AHCI, GPUs).

>
>>   3. NVMe PCI demonstrates how a BIO can be converted to a HW scatter
>>      list without having to allocate then populate an intermediate SG table.
>
> As above, given that a bio_vec still deals in struct pages, that could 
> seemingly already be done by just mapping the pages, so how is it proving 
> any benefit of a fragile new interface?

Because we only need to preallocate the tiny constant sized dma_iova_state
as part of the request instead of an additional scatterlist that requires
sizeof(struct page *) + sizeof(dma_addr_t) + 3 * sizeof(unsigned int)
per segment, including a memory allocation per I/O for that.

> My big concern here is that a thin and vaguely-defined wrapper around the 
> IOMMU API is itself a step which smells strongly of "abuse and design 
> mistake", given that the basic notion of allocating DMA addresses in 
> advance clearly cannot generalise. Thus it really demands some considered 
> justification beyond "We must do something; This is something; Therefore we 
> must do this." to be convincing.

At least for the block code we have a nice little core wrapper that is
very easy to use, and provides a great reduction of memory use and
allocations.  The HMM use case I'll let others talk about.


