Return-Path: <kvm+bounces-11158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E54F873C04
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:20:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B75031F25DF8
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 16:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D12C137924;
	Wed,  6 Mar 2024 16:20:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE00C136647;
	Wed,  6 Mar 2024 16:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709742034; cv=none; b=kn8egoL1TkF4asYij3SHwO4imn9T1hblygN58jSpay77nx25uPXGIV/UIW4gO9pTjzmY2YpgbJOupOsJ0SUO4enPv49NC39pbm+qg5DY5qBfO+pQ689Mez2cHioObzHnPL1dkoYzVyXkjYf5zHYMLbC7Bat42NdaKU+2tO2BC3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709742034; c=relaxed/simple;
	bh=aPt/CEGkasNVIZ01RHfKkPFD8TFNenT7o5dBwNYWmn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pL8nFcWVvojoAf+JIiLhmqdpcHQpifWNEGR5nth820OsnZcL4YF5rsXJl1X7tIa8OYgUu/k0GMsQHIHYLu7z0qLPEX0dl/Nzi/CEGkMP0hOGdALEmwT3uu4Xa3gaww1jm7noVidCc8rOVZPwXcvcFH9Oltn83VREmF4+ddHOGfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1908468CFE; Wed,  6 Mar 2024 17:20:23 +0100 (CET)
Date: Wed, 6 Mar 2024 17:20:22 +0100
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
Message-ID: <20240306162022.GB28427@lst.de>
References: <cover.1709635535.git.leon@kernel.org> <47afacda-3023-4eb7-b227-5f725c3187c2@arm.com> <20240305122935.GB36868@unreal> <20240306144416.GB19711@lst.de> <20240306154328.GM9225@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306154328.GM9225@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 06, 2024 at 11:43:28AM -0400, Jason Gunthorpe wrote:
> I don't think they are so fundamentally different, at least in our
> past conversations I never came out with the idea we should burden the
> driver with two different flows based on what kind of alignment the
> transfer happens to have.

Then we talked past each other..

> At least the RDMA drivers could productively use just a page aligned
> interface. But I didn't think this would make BIO users happy so never
> even thought about it..

page aligned is generally the right thing for the block layer.  NVMe
for example already requires that anyway due to PRPs.

> > The total transfer size should just be passed in by the callers and
> > be known, and there should be no offset.
> 
> The API needs the caller to figure out the total number of IOVA pages
> it needs, rounding up the CPU ranges to full aligned pages. That
> becomes the IOVA allocation.

Yes, it's a basic align up to the granularity asuming we don't bother
with non-aligned transfers.

> 
> > So if we want to efficiently be able to handle these cases we need
> > two APIs in the driver and a good framework to switch between them.
> 
> But, what does the non-page-aligned version look like? Doesn't it
> still look basically like this?

I'd just rather have the non-aligned case for those who really need
it be the loop over map single region that is needed for the direct
mapping anyway.

> 
> And what is the actual difference if the input is aligned? The caller
> can assume it doesn't need to provide a per-range dma_addr_t during
> unmap.

A per-range dma_addr_t doesn't really make sense for the aligned and
coalesced case.

> It still can't assume the HW programming will be linear due to the P2P
> !ACS support.
> 
> And it still has to call an API per-cpu range to actually program the
> IOMMU.
> 
> So are they really so different to want different APIs? That strikes
> me as a big driver cost.

To not have to store a dma_address range per CPU range that doesn't
actually get used at all.

