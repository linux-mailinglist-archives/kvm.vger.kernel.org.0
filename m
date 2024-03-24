Return-Path: <kvm+bounces-12553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 362318894F6
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 09:14:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF3561F2FA69
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 08:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD524173344;
	Mon, 25 Mar 2024 03:10:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC35924A899;
	Sun, 24 Mar 2024 23:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711322547; cv=none; b=Agsj4QlORW1UWFl/bSqBJXKOcGM49TeKqTsbvn5zg3jzx6j6YE0+fz+vUyi+WziMBkdoGFKts+mNUCbxInhkW4rF2MNs8aRxVgkfmuOGAKiBKEakH2pP7qRKXlOyaKWbcbNpSvtPTObZclvXeyIG7pcjP/8V1AoyPKwbRXeUgms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711322547; c=relaxed/simple;
	bh=QD2J7s+PbQMl/4TLX0Q9/+FJg4j9efgCpQRUHwRCQyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ysn1E/vkAvIpQQdhL/buj0v+IHKqkpgM6yHYp1jGB5CPiljkxWOEFqZT8cv6LIXCuc1R8xyUwEq7TxJo9Xgq9Yx882MCZLashOUeInZZHj/4F8SdUmK33jqUKxbkyjE2SbbE6SbQ9qXDIHPRSJbf655mYinhN+SfSHsvwKo6fa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 08B4F68D0F; Mon, 25 Mar 2024 00:22:16 +0100 (CET)
Date: Mon, 25 Mar 2024 00:22:15 +0100
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
Message-ID: <20240324232215.GC20765@lst.de>
References: <20240306221400.GA8663@lst.de> <20240307000036.GP9225@ziepe.ca> <20240307150505.GA28978@lst.de> <20240307210116.GQ9225@ziepe.ca> <20240308164920.GA17991@lst.de> <20240308202342.GZ9225@ziepe.ca> <20240309161418.GA27113@lst.de> <20240319153620.GB66976@ziepe.ca> <20240321223910.GA22663@lst.de> <20240322184330.GL66976@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240322184330.GL66976@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 22, 2024 at 03:43:30PM -0300, Jason Gunthorpe wrote:
> If we are going to make caller provided uniformity a requirement, lets
> imagine a formal memory type idea to help keep this a little
> abstracted?
> 
>  DMA_MEMORY_TYPE_NORMAL
>  DMA_MEMORY_TYPE_P2P_NOT_ACS
>  DMA_MEMORY_TYPE_ENCRYPTED
>  DMA_MEMORY_TYPE_BOUNCE_BUFFER  // ??
> 
> Then maybe the driver flow looks like:
> 
> 	if (transaction.memory_type == DMA_MEMORY_TYPE_NORMAL && dma_api_has_iommu(dev)) {

Add a nice helper to make this somewhat readable, but yes.

> 	} else if (transaction.memory_type == DMA_MEMORY_TYPE_P2P_NOT_ACS) {
> 		num_hwsgls = transcation.num_sgls;
> 		for_each_range(transaction, range) {
> 			hwsgl[i].addr = dma_api_p2p_not_acs_map(range.start_physical, range.length, p2p_memory_provider);
> 			hwsgl[i].len = range.size;
> 		}
> 	} else {
> 		/* Must be DMA_MEMORY_TYPE_NORMAL, DMA_MEMORY_TYPE_ENCRYPTED, DMA_MEMORY_TYPE_BOUNCE_BUFFER? */
> 		num_hwsgls = transcation.num_sgls;
> 		for_each_range(transaction, range) {
> 			hwsgl[i].addr = dma_api_map_cpu_page(range.start_page, range.length);
> 			hwsgl[i].len = range.size;
> 		}
>

And these two are really the same except that we call a different map
helper underneath.  So I think as far as the driver is concerned
they should be the same, the DMA API just needs to key off the
memory tap.

> And the hmm_range_fault case is sort of like:
> 
> 		struct dma_api_iommu_state state;
> 		dma_api_iommu_start(&state, mr.num_pages);
> 
> 		[..]
> 		hmm_range_fault(...)
> 		if (present)
> 			dma_link_page(&state, faulting_address_offset, page);
> 		else
> 			dma_unlink_page(&state, faulting_address_offset, page);
> 
> Is this looking closer?

Yes.

> > > So I take it as a requirement that RDMA MUST make single MR's out of a
> > > hodgepodge of page types. RDMA MRs cannot be split. Multiple MR's are
> > > not a functional replacement for a single MR.
> > 
> > But MRs consolidate multiple dma addresses anyway.
> 
> I'm not sure I understand this?

The RDMA MRs take a a list of PFNish address, (or SGLs with the
enhanced MRs from Mellanox) and give you back a single rkey/lkey.

> To go back to my main thesis - I would like a high performance low
> level DMA API that is capable enough that it could implement
> scatterlist dma_map_sg() and thus also implement any future
> scatterlist_v2, bio, hmm_range_fault or any other thing we come up
> with on top of it. This is broadly what I thought we agreed to at LSF
> last year.

I think the biggest underlying problem of the scatterlist based
DMA implementation for IOMMUs is that it's trying to handle to much,
that is magic coalescing even if the segments boundaries don't align
with the IOMMU page size.  If we can get rid of that misfeature I
think we'd greatly simply the API and implementation.

