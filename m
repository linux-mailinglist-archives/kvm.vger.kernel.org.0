Return-Path: <kvm+bounces-44080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A399FA9A2AD
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:55:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BE851945C58
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 06:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD1891EEA4A;
	Thu, 24 Apr 2025 06:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JBMG74Uf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E280D84FAD;
	Thu, 24 Apr 2025 06:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745477718; cv=none; b=Cahe5lCyUTmA8xhd5zNt1JeNf0V32o4SFDOWvdfXw03N6HdaPASevNCkwAl7tnkt+m9d3polvbhE2VGeFpV0Dfj7LJEgetXss6LBabVIbxNz+ju7uxrdV4r0rNTOBE4OOlUGKTqojHm+gyj0lONLhawLBesQPE23Ntm7w+U+zZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745477718; c=relaxed/simple;
	bh=O2NhhAxby4h2wdAG9lotXu0r8Mq+CnbUeKJ51V9RGiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B7bKa4MgWy8nnA6slFa2MAFA9CV2ZUhWO4Uh4kZuTcii5MbyTHnx6tbhzWVcJY+DGNMclihNzuATN0sy7NMkBWLiUHD7tJHVgMQUgj9Ac3/GTyCy/egdRHu1XBkx3OHyRW41a8hEW6K9t3iLTBCoWU9DwVNNGnVAHHcAaShh1pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JBMG74Uf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A31C4CEE3;
	Thu, 24 Apr 2025 06:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745477717;
	bh=O2NhhAxby4h2wdAG9lotXu0r8Mq+CnbUeKJ51V9RGiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JBMG74Uf2ayBsAyXOsGDu/Pky6ixNS1c4BDJHd4lwbNECLO5LrTPDLt1r0eNUPLy0
	 ynut6BgnWakwJKSAx+8FK+EGFCkITnvLnelLONPxIjuG0tdC90cdj3pniHXtHm9Fxa
	 wl45/ZTtb8BKv0iNv76Ij9tfHUWh6rTMYx7CAUO3rppkqiaLH7xleBCQXesauRPbp2
	 FUUzSE+hvgKs3WwAsv1qWr/zBPK1T2EbndRkbynGnImy0ZnvZycZXxoAzu4XEX+teR
	 a2VWk0rzolhjEPmNfygA5hJqIMt43/HcuEsUyDD2XFjdC06yV7sioUDVdESF6SAvcW
	 F+H5S2kqGr5vg==
Date: Thu, 24 Apr 2025 09:55:11 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v9 03/24] iommu: generalize the batched sync after map
 interface
Message-ID: <20250424065511.GL48485@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <2ce6a74ddf5e13a7fdb731984aa781a15f17749d.1745394536.git.leon@kernel.org>
 <20250423171537.GJ1213339@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423171537.GJ1213339@ziepe.ca>

On Wed, Apr 23, 2025 at 02:15:37PM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 23, 2025 at 11:12:54AM +0300, Leon Romanovsky wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > For the upcoming IOVA-based DMA API we want to use the interface batch the
> > sync after mapping multiple entries from dma-iommu without having a
> > scatterlist.
> 
> Grammer:
> 
>  For the upcoming IOVA-based DMA API we want to batch the
>  ops->iotlb_sync_map() call after mapping multiple IOVAs from
>  dma-iommu without having a scatterlist. Improve the API.
> 
>  Add a wrapper for the map_sync as iommu_sync_map() so that callers don't
>  need to poke into the methods directly.
> 
>  Formalize __iommu_map() into iommu_map_nosync() which requires the
>  caller to call iommu_sync_map() after all maps are completed.
> 
>  Refactor the existing sanity checks from all the different layers
>  into iommu_map_nosync().
> 
> >  drivers/iommu/iommu.c | 65 +++++++++++++++++++------------------------
> >  include/linux/iommu.h |  4 +++
> >  2 files changed, 33 insertions(+), 36 deletions(-)
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> > +	/* Discourage passing strange GFP flags */
> > +	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
> > +				__GFP_HIGHMEM)))
> > +		return -EINVAL;
> 
> There is some kind of overlap with the new iommu_alloc_pages_node()
> here that does a similar check, nothing that can be addressed in this
> series but maybe a TBD for later..

This series is based on pure -rc1 to allow creation of shared branch,
while you removed iommu_alloc_pages_node() in IOMMU tree. So we must
merge it first and tidy the code after that.

Thanks

> 
> Jason
> 

