Return-Path: <kvm+bounces-30505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A789BB520
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:53:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9531D1F21617
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 12:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0051BC065;
	Mon,  4 Nov 2024 12:53:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FE61B6CFE;
	Mon,  4 Nov 2024 12:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730724790; cv=none; b=HOgOno/aW5CWwM/BAE++lrkckLWkqhV9grMwgiJWLAXc8LFQmwcVaAtKPTUXog4Mtj2W6z2TkrbYV2In51QMsRctfRTtNDGvkEevhCnKwUNQ1Nb1BbvfuqbWjO+UakumaRAhZii6H1EawnZGgKe1Pr37cPR6yW7JmysLQzeNF9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730724790; c=relaxed/simple;
	bh=gilSNoWQMNdGklRFQgFhfjvxiTNJuGwF0N1Xv7U5/Pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SVAD3oY3o9ipAH3rJQBtTVcfId0cXaA/jPjkxudLZOXFYCdVgUgMOjC1dZs0E0+DymwTN0TzkhV13Wl8UgFqHRpoj6tJDZvnC2gx3FyVS1gek+v3GxM5uyN2VFl4hufUSBfjeyrfBxywiFj+tHiSDxMfp6lhJo/u5ImFJUhNzv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D6983227AAF; Mon,  4 Nov 2024 13:53:02 +0100 (CET)
Date: Mon, 4 Nov 2024 13:53:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>,
	Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Leon Romanovsky <leonro@nvidia.com>,
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
Subject: Re: [PATCH v1 07/17] dma-mapping: Implement link/unlink ranges API
Message-ID: <20241104125302.GA11168@lst.de>
References: <cover.1730298502.git.leon@kernel.org> <f8c7f160c9ae97fef4ccd355f9979727552c7374.1730298502.git.leon@kernel.org> <51c5a5d5-6f90-4c42-b0ef-b87791e00f20@arm.com> <20241104091048.GA25041@lst.de> <20241104121924.GC35848@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104121924.GC35848@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 04, 2024 at 08:19:24AM -0400, Jason Gunthorpe wrote:
> > That's a good point.  Only mapped through host bridge P2P can even
> > end up here, so the address is a perfectly valid physical address
> > in the host.  But I'm not sure if all arch_sync_dma_for_device
> > implementations handle IOMMU memory fine.
> 
> I was told on x86 if you do a cache flush operation on MMIO there is a
> chance it will MCE. Recently had some similar discussions about ARM
> where it was asserted some platforms may have similar.

On x86 we never flush caches for DMA operations anyway, so x86 isn't
really the concern here, but architectures that do cache incoherent DMA
to PCIe devices.  Which isn't a whole lot as most SOCs try to avoid that
for PCIe even if they lack DMA coherent for lesser peripherals, but I bet
there are some on arm/arm64 and maybe riscv or mips.

> It would be safest to only call arch flushing calls on memory that is
> mapped cachable. We can assume that a P2P target is never CPU
> mapped cachable, regardless of how the DMA is routed.

Yes.  I.e. force DMA_ATTR_SKIP_CPU_SYNC for P2P.


