Return-Path: <kvm+bounces-21038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FAAC92822F
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 08:39:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FAEA1C23B25
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 06:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57F7D1448E3;
	Fri,  5 Jul 2024 06:39:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF32C13791C;
	Fri,  5 Jul 2024 06:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720161557; cv=none; b=ABh8i86aJtHTijSQSj91XdEEvKWUwI0dDjH0aWOOlOcSwXWHsMl85iVJBkr+U7CmSlzxyQ8xdECbj1c7v/0PEohZpa64Hv17A78gpp3KldyHKWBPMtrJJOq2YZ8xUhYAh1cIuoZ1N8iTTDhWWlASn9tWdslZnxNqKt5FMRL8ejo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720161557; c=relaxed/simple;
	bh=GzgqHGbWqTLMocgiuSblg7y8irfEU3WvGTYpGyhPPWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GrqUOpyyIlIXX8T88q2xmA/nftGM1+DTonvUQ56S4NobD0ZNAtQSBm6KpA4vOZE0WboEM1uQ0ct81Dd+QH+dPYqXoXky6zBd1iDU8RhBByZFaCH5eI9YItBiH/eQV10SYtAlxrsAmzAuAuxzpaENgCGxM83egta2F6PcBDr4pvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B3F8468AA6; Fri,  5 Jul 2024 08:39:10 +0200 (CEST)
Date: Fri, 5 Jul 2024 08:39:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, "Zeng, Oak" <oak.zeng@intel.com>,
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
Message-ID: <20240705063910.GA12337@lst.de>
References: <cover.1719909395.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1719909395.git.leon@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Review from the NVMe driver consumer perspective.  I think if all these
were implement we'd probably end up with less code than before the
conversion.

The split between dma_iova_attrs, dma_memory_type and dma_iova_state is
odd.  I would have expected them to just be just a single object.  While
talking about this I think the domain field in dma_iova_state should
probably be a private pointer instead of being tied to the iommu.

Also do we need the attrs member in the iova_attrs structure?  The
"attrs" really are flags passed to the mapping routines that are
per-operation and not persistent, so I'd expect them to be passed
per-call and not stored in a structure.

I'd also expect that the use_iova field to be in the mapping state
and not separately provided by the driver.

For nvme specific data structures I would have expected a dma_add/
len pair in struct iod_dma_map, maybe even using a common type.

Also the data structure split seems odd - I'd expect the actual
mapping state and a small number (at least one) dma_addr/len pair
to be inside the nvme_iod structure, and then only do the dynamic
allocation if we need more of them because there are more segments
and we are not using the iommu.

If we had a common data structure for the dma_addr/len pairs
dma_unlink_range could just take care of the unmap for the non-iommu
case as well, which would be neat.  I'd also expect that
dma_free_iova would be covered by it.

I would have expected dma_link_range to return the dma_addr_t instead
of poking into the iova structure in the callers.

In __nvme_rq_dma_map the <= PAGE_SIZE case is pointless.  In the
existing code the reason for it is to avoid allocating and mapping the
sg_table, but that code is still left before we even get to this code.

My suggestion above to only allocate the dma_addr/len pairs when there
is more than 1 or a few of it would allow to trivially implement that
suggestion using the normal API without having to keep that special
case and the dma_len parameter around.

If this addes a version of dma_map_page_atttrs that directly took
the physical address as a prep patch the callers would not have to
bother with page pointer manipulations and just work on physical
addresses for both the iommu and no-iommu cases.  It would also help
a little bit with the eventualy switch to store the physical address
instead of page+offset in the bio_vec.  Talking about that, I've
been wanting to add a bvec_phys helper for to convert the
page_phys(bv.bv_page) + bv.bv_offset calculations.  This is becoming
more urgent with more callers needing to that, I'll try to get it out
to Jens ASAP so that it can make the 6.11 merge window.

Can we make dma_start_range / dma_end_range simple no-ops for the
non-iommu code to avoid boilerplate code in the callers to avoid
boilerplate code in the callers to deal with the two cases?

