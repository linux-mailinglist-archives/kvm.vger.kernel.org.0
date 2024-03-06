Return-Path: <kvm+bounces-11146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7F9873987
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 15:44:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9048C1F22027
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 14:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4296134738;
	Wed,  6 Mar 2024 14:44:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC6712FB31;
	Wed,  6 Mar 2024 14:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709736268; cv=none; b=LopTb/fKh34Npc6RH+aVljXKQu9LKnQxIKOKMWoJbAU09CeBdkWJC7Q8EE3Ah8ZNrZ0zg8v7blR49lzR0EeNi9IZz0vIFniPstE1OEOiqcpBaS1oSrTOE1c7DWdjdbES98Ql6S8yqpFs8/ldkd50uJR7LWElMOXdb1KXA5EKAAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709736268; c=relaxed/simple;
	bh=Cg+/N+/d48kp+Bii6xwPc6Sv3b/fJs9pKZfyKHqumHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ihvgbR0V/c/+G46kcT7Bcac8cuquZlRMadzCs1boqg+FblI1xFMXQnUOPOsjafPpPmu6fpSU/pgk80tmbucADUtbKT9gGPTp5fEwgKEw1CJaIz7PFpE6BXodGmpYwH5/ijMc+EDLE10issr+RjDPsHwhU8cfrbNF+/WouN1+KzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6727E68C4E; Wed,  6 Mar 2024 15:44:17 +0100 (CET)
Date: Wed, 6 Mar 2024 15:44:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
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
Message-ID: <20240306144416.GB19711@lst.de>
References: <cover.1709635535.git.leon@kernel.org> <47afacda-3023-4eb7-b227-5f725c3187c2@arm.com> <20240305122935.GB36868@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305122935.GB36868@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 05, 2024 at 02:29:35PM +0200, Leon Romanovsky wrote:
> > > These advanced DMA mapping APIs are needed to calculate IOVA size to
> > > allocate it as one chunk and some sort of offset calculations to know
> > > which part of IOVA to map.
> > 
> > I don't follow this part at all - at *some* point, something must know a
> > range of memory addresses involved in a DMA transfer, so that's where it
> > should map that range for DMA. 
> 
> In all presented cases in this series, the overall DMA size is known in
> advance. In RDMA case, it is known when user registers the memory, in
> VFIO, when live migration is happening and in NVMe, when BIO is created.
> 
> So once we allocated IOVA, we will need to link ranges, which si the
> same as map but without IOVA allocation.

But above you say:

"These advanced DMA mapping APIs are needed to calculate IOVA size to
allocate it as one chunk and some sort of offset calculations to know
which part of IOVA to map."

this suggests you need helpers to calculate the len and offset.  I
can't see where that would ever make sense.  The total transfer
size should just be passed in by the callers and be known, and
there should be no offset.

> > > Instead of teaching DMA to know these specific datatypes, let's separate
> > > existing DMA mapping routine to two steps and give an option to advanced
> > > callers (subsystems) perform all calculations internally in advance and
> > > map pages later when it is needed.
> > 
> > From a brief look, this is clearly an awkward reinvention of the IOMMU API.
> > If IOMMU-aware drivers/subsystems want to explicitly manage IOMMU address
> > spaces then they can and should use the IOMMU API. Perhaps there's room for
> > some quality-of-life additions to the IOMMU API to help with common usage
> > patterns, but the generic DMA mapping API is absolutely not the place for
> > it.
> 
> DMA mapping gives nice abstraction from IOMMU, and allows us to have
> same flow for IOMMU and non-IOMMU flows without duplicating code, while
> you suggest to teach almost every part in the kernel to know about IOMMU.

Except that the flows are fundamentally different for the "can coalesce"
vs "can't coalesce" case.  In the former we have one dma_addr_t range,
and in the latter as many as there are input vectors (this is ignoring
the weird iommu merging case where we we coalesce some but not all
segments, but I'd rather not have that in a new API).

So if we want to efficiently be able to handle these cases we need
two APIs in the driver and a good framework to switch between them.
Robins makes a point here that the iommu API handles the can coalesce
case and he has a point as that's exactly how the IOMMU API works.
I'd still prefer to wrap it with dma callers to handle things like
swiotlb and maybe Xen grant tables and to avoid the type confusion
between dma_addr_t and then untyped iova in the iommu layer, but
having this layer or not is probably worth a discussion.

> 
> In this series, we changed RDMA, VFIO and NVMe, and in all cases we
> removed more code than added. From what I saw, VDPA and virito-blk will
> benefit from proposed API too.
> 
> Even in this RFC, where Chaitanya did partial job and didn't convert
> whole driver, the gain is pretty obvious:
> https://lore.kernel.org/linux-rdma/016fc02cbfa9be3c156a6f74df38def1e09c08f1.1709635535.git.leon@kernel.org/T/#u
> 

I have no idea how that nvme patch is even supposed to work.  It removes
the PRP path in nvme-pci, which not only is the most common I/O path
but actually required for the admin queue as NVMe doesn't support
SGLs for the admin queue.


