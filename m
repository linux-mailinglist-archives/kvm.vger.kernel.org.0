Return-Path: <kvm+bounces-11156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADE6A873BD4
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:15:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 699FF285530
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 16:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 965CA137763;
	Wed,  6 Mar 2024 16:14:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A37134733;
	Wed,  6 Mar 2024 16:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709741688; cv=none; b=L7TJNPk3lEIESSUKTD6LPna9mehxaQxAm2Mkt1oMhTdfS20ojxx3t4EfYuLzUzIk3lBz2W3Zp5NtDhhLUMEa+ONyTnwJxFBx2YZw27WZuWEdV+E/A4xDj7cK2f3iK0OPP2Bye/gpHx3pOIkV5lWpf0y0evkFhqjnrRXEu4cftqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709741688; c=relaxed/simple;
	bh=ph4wOA/W80emziteg+Lwe4Qh5uu+xg9ATnw4VSdVs0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cKgaNcSvYN4Sks/GOTe7Vrb+MaJub+wA+xUk8qxDetNO5/H688N8Bqf8noezxhPSl63a5ved1axvwJPDxO6vcXalf/5inTckEZ8yRNkkQw1bHdj9/J8/JIpPQBuZFt8mqL25ZarhZLI/SgZqq6YOBrQyq2DxG4PFsN6d9uk0Ktw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 339E968C4E; Wed,  6 Mar 2024 17:14:39 +0100 (CET)
Date: Wed, 6 Mar 2024 17:14:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>, Yishai Hadas <yishaih@nvidia.com>,
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
	"jack@suse.com" <jack@suse.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [RFC RESEND 16/16] nvme-pci: use blk_rq_dma_map() for NVMe SGL
Message-ID: <20240306161438.GA28427@lst.de>
References: <cover.1709635535.git.leon@kernel.org> <016fc02cbfa9be3c156a6f74df38def1e09c08f1.1709635535.git.leon@kernel.org> <Zec_nAQn1Ft_ZTHH@kbusch-mbp.dhcp.thefacebook.com> <20240306143321.GA19711@lst.de> <20240306150518.GL9225@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306150518.GL9225@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 06, 2024 at 11:05:18AM -0400, Jason Gunthorpe wrote:
> > Yes.  And this whole proposal also seems clearly confused (not just
> > because of the gazillion reposts) but because it mixes up the case
> > where we can coalesce CPU regions into a single dma_addr_t range
> > (iommu and maybe in the future swiotlb) and one where we need a
> 
> I had the broad expectation that the DMA API user would already be
> providing a place to store the dma_addr_t as it has to feed that into
> the HW. That memory should simply last up until we do dma unmap and
> the cases that need dma_addr_t during unmap can go get it from there.

Well.  The dma_addr_t needs to be fed into the hardware somehow
obviously.  But for a the coalesced case we only need one such
field, not Nranges.

> We can't do much on the map side as single range doesn't imply
> contiguous range, P2P and alignment create discontinuities in the
> dma_addr_t that still have to be delt with.

For alignment the right answer is almost always to require the
upper layers to align to the iommu granularity.  We've been a bit
lax about that due to the way scatterlists are designed, but
requiring the proper alignment actually benefits everyone.

