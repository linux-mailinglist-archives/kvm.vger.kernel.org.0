Return-Path: <kvm+bounces-31068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B9729BFFFD
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 09:33:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5AC528361C
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 08:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A83181DA61E;
	Thu,  7 Nov 2024 08:33:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317DA130A7D;
	Thu,  7 Nov 2024 08:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730968385; cv=none; b=HElfQ84nRhXuslRwtQ80dN3vwGW/yR8TiOaVsNNfk+1dfnh5UJ+d+QuF1VYUTESEHPI5/uYlg22YG3BUDtVW9zIW8CYXXhg5ojlFXaMEJdcIQL43KJrJ9gNTeG7X1UrsRgZT6Ck5Xf0ux1iRtgD1JNn5diryuUUsPw6WT5I2s/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730968385; c=relaxed/simple;
	bh=Q5vqlG4GRkS0wGm8P5LN2aEevhS4iCH3ohyd5g2YAZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BxsFN4AlmqpgW7qfSm6yAFa9SNsqzb2Qxvii4yaBuagLaexsO62UYmY7FOt5y9+oddLAErAxi11AUAnPS+xwmB1tPiiUk5sEoefLd/AH7onuT7+n+9JNUH5jZUqX3sah6TDhQl6gkq39r9vpOHWsZPKeEz1BNISstfataG18nDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B5FAE68AA6; Thu,  7 Nov 2024 09:32:56 +0100 (CET)
Date: Thu, 7 Nov 2024 09:32:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>,
	Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
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
Message-ID: <20241107083256.GA9071@lst.de>
References: <cover.1730298502.git.leon@kernel.org> <3567312e-5942-4037-93dc-587f25f0778c@arm.com> <20241104095831.GA28751@lst.de> <20241105195357.GI35848@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105195357.GI35848@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 05, 2024 at 03:53:57PM -0400, Jason Gunthorpe wrote:
> > Yeah, I don't really get the struct page argument.  In fact if we look
> > at the nitty-gritty details of dma_map_page it doesn't really need a
> > page at all. 
> 
> Today, if you want to map a P2P address you must have a struct page,
> because page->pgmap is the only source of information on the P2P
> topology.
> 
> So the logic is, to get P2P without struct page we need a way to have
> all the features of dma_map_sg() but without a mandatory scatterlist
> because we cannot remove struct page from scatterlist.

Well, that is true but also not the point.  The hard part is to
find the P2P routing information without the page.  After that
any physical address based interface will work, including a trivial
dma_map_phys.

> > At least for the block code we have a nice little core wrapper that is
> > very easy to use, and provides a great reduction of memory use and
> > allocations.  The HMM use case I'll let others talk about.
> 
> I saw the Intel XE team make a complicated integration with the DMA
> API that wasn't so good. They were looking at an earlier version of
> this and I think the feedback was positive. It should make a big
> difference, but we will need to see what they come up and possibly
> tweak things.

Not even sure what XE is, but do you have a pointer to it?  It would
really be great if people having DMA problems talked to the dma-mapping
and iommu maintaines / list..


