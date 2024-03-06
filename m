Return-Path: <kvm+bounces-11145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B02BA87393D
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 15:34:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52DF21F241FE
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 14:34:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33CFD134CCA;
	Wed,  6 Mar 2024 14:33:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6BE7FBDC;
	Wed,  6 Mar 2024 14:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709735616; cv=none; b=q97PFBI6ReOmQlg6l1dU/FDzmqnqKhycsmwuV6/YxYRH7LW031r8c7Q6MXl7WfAn7yDwNu/GT6EiTbPyX4zr3XFWZ1hnys/agyAvXTRNpn7QOgY+rUH71BNQghdjnXjgwbbDRfVuP2ZUuisCk8ZnkjIe0jp75N32TRsVtNjEcv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709735616; c=relaxed/simple;
	bh=WWXYolFOYwBAJ/CdfPd6/jJ5gcZIPqiPh9G+qpwJ/Rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mmP20bLAEemw2jng5Dqo0A5A+tj6rOXTDNFhxtBV42PChWJzW3eh1WD6wHFjfPpm7FglW1gyDQCXDpCebvIERcDGfQHr2Rl/hNyXskQv+gRfy/GlBMaz51EZ+NStzLmSGmIUnd5htWymED6y6VIgmCjjns4UVxb8lOS/yim6MGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 378F068C4E; Wed,  6 Mar 2024 15:33:22 +0100 (CET)
Date: Wed, 6 Mar 2024 15:33:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
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
Message-ID: <20240306143321.GA19711@lst.de>
References: <cover.1709635535.git.leon@kernel.org> <016fc02cbfa9be3c156a6f74df38def1e09c08f1.1709635535.git.leon@kernel.org> <Zec_nAQn1Ft_ZTHH@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zec_nAQn1Ft_ZTHH@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 05, 2024 at 08:51:56AM -0700, Keith Busch wrote:
> On Tue, Mar 05, 2024 at 01:18:47PM +0200, Leon Romanovsky wrote:
> > @@ -236,7 +236,9 @@ struct nvme_iod {
> >  	unsigned int dma_len;	/* length of single DMA segment mapping */
> >  	dma_addr_t first_dma;
> >  	dma_addr_t meta_dma;
> > -	struct sg_table sgt;
> > +	struct dma_iova_attrs iova;
> > +	dma_addr_t dma_link_address[128];
> > +	u16 nr_dma_link_address;
> >  	union nvme_descriptor list[NVME_MAX_NR_ALLOCATIONS];
> >  };
> 
> That's quite a lot of space to add to the iod. We preallocate one for
> every request, and there could be millions of them. 

Yes.  And this whole proposal also seems clearly confused (not just
because of the gazillion reposts) but because it mixes up the case
where we can coalesce CPU regions into a single dma_addr_t range
(iommu and maybe in the future swiotlb) and one where we need a
dma_addr_t range per cpu range (direct misc cruft).

