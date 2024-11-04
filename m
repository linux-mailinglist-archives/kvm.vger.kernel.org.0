Return-Path: <kvm+bounces-30500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 130809BB3A3
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 12:39:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE6481F23144
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 11:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C73F1B21BC;
	Mon,  4 Nov 2024 11:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCNZl80y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC3C185B4D;
	Mon,  4 Nov 2024 11:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730720369; cv=none; b=IfXP4NHpuW3B2eJ8lYZxrEY/8SzRa3zN2jfDv3NV5EdzB52FMbbfKFGNZpEaRqTIpG5Y3BpEL+q0GUrFDjGjSwAF8xxhC1Z8wayKx2J7akm4FRT1EJ6ljZ3kk05q0b2Z9nSGrWkjrB7cL/QoOlVXMIPGp3NryKVAO1tY2qkSiRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730720369; c=relaxed/simple;
	bh=NEDVbMitndD/iK6JWHs2o1S6pn7h57zEQ83wRjOGbwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T4X21Z2//bEFcE/Mnm7SRAEbSe2Hv30g+1ieVBA2BegoCMvZRAoZOdSYFpbC4l5dWo/3l6/XioIhCYr0byPK6IIo/c0GUEkwnb/QtZ52vhrykbqbJ639Y5Z0Py3PptiFz59LSlKcCL2rXk+pa2DGBNiLTqUUqvjENG+VpJVB3hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCNZl80y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E43EC4CECE;
	Mon,  4 Nov 2024 11:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730720366;
	bh=NEDVbMitndD/iK6JWHs2o1S6pn7h57zEQ83wRjOGbwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FCNZl80yEk5l8SaYaoCBd/ngvAnMVCC2ZjSDbwZfQ8mrGoQAQHq0KZ0YySad2w6iD
	 bhKUdk2VJPuLxk2n0zNkeYqVTjWimCe0KY+EoWT4fqvV1+YLhQUvABpjnzxQEgdqFM
	 2BpPxg0LwBCTYbhkxkUYZgp3KkOsOZRDo+BKC3lH3JeAsOEk2fzj8ARLQQ14RhFnrX
	 uXWBkNGPfoaMl6N4kDz6OiMk0Mf/BwrYcYvvPP+t71xWn1ZjQA3Q6lgcGNVObYG5Gq
	 GbS2qup3wwHfcN9yIP+AIN4pioJI5Luew6aYTY7gCJ1DnGQC9xzlf55e02PVxyG0ae
	 QwBznLzmgrROQ==
Date: Mon, 4 Nov 2024 13:39:20 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Robin Murphy <robin.murphy@arm.com>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
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
Message-ID: <20241104113920.GD99170@unreal>
References: <cover.1730298502.git.leon@kernel.org>
 <3567312e-5942-4037-93dc-587f25f0778c@arm.com>
 <20241104095831.GA28751@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104095831.GA28751@lst.de>

On Mon, Nov 04, 2024 at 10:58:31AM +0100, Christoph Hellwig wrote:
> On Thu, Oct 31, 2024 at 09:17:45PM +0000, Robin Murphy wrote:

<...>

> >>   2. VFIO PCI live migration code is building a very large "page list"
> >>      for the device. Instead of allocating a scatter list entry per allocated
> >>      page it can just allocate an array of 'struct page *', saving a large
> >>      amount of memory.
> >
> > VFIO already assumes a coherent device with (realistically) an IOMMU which 
> > it explicitly manages - why is it even pretending to need a generic DMA 
> > API?
> 
> AFAIK that does isn't really vfio as we know it but the control device
> for live migration.  But Leon or Jason might fill in more.

Yes, you are right, as it is written above "VFIO PCI live migration ...".
That piece of code directly connected to the underlying real HW device
and uses DMA API to provide live migration functionality to/from that
device.

> 
> The point is that quite a few devices have these page list based APIs
> (RDMA where mlx5 comes from, NVMe with PRPs, AHCI, GPUs).
> 
> >
> >>   3. NVMe PCI demonstrates how a BIO can be converted to a HW scatter
> >>      list without having to allocate then populate an intermediate SG table.
> >
> > As above, given that a bio_vec still deals in struct pages, that could 
> > seemingly already be done by just mapping the pages, so how is it proving 
> > any benefit of a fragile new interface?
> 
> Because we only need to preallocate the tiny constant sized dma_iova_state
> as part of the request instead of an additional scatterlist that requires
> sizeof(struct page *) + sizeof(dma_addr_t) + 3 * sizeof(unsigned int)
> per segment, including a memory allocation per I/O for that.
> 
> > My big concern here is that a thin and vaguely-defined wrapper around the 
> > IOMMU API is itself a step which smells strongly of "abuse and design 
> > mistake", given that the basic notion of allocating DMA addresses in 
> > advance clearly cannot generalise. Thus it really demands some considered 
> > justification beyond "We must do something; This is something; Therefore we 
> > must do this." to be convincing.
> 
> At least for the block code we have a nice little core wrapper that is
> very easy to use, and provides a great reduction of memory use and
> allocations.  The HMM use case I'll let others talk about.

I'm not sure about which wrappers Robin talks, but if we are talking
about HMM wrappers, they gave us perfect combination of usability,
performance and maintenance. All HMM users use same pattern, same
structures and don't need to worry about internal DMA/IOMMU details.

Thanks

