Return-Path: <kvm+bounces-43936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 177C2A98B84
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D103445E3E
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 13:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6E761AAA2C;
	Wed, 23 Apr 2025 13:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C7fbCECK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34531A3175;
	Wed, 23 Apr 2025 13:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745415585; cv=none; b=EEgUuU4E5+uQ4vAKsAATs/sIANITyjjSnm4LGVsTbUNti5FUGMffWB1+QoP6vTTcuQWWXsQPs94WztVIWVKYmJhsHS/4dz/IFDkfyVxdmajuEM7A0NvRhyQLzFNnaBvxoikX62Xd7vi41suWaybsxW4tDzj3Fv7ftLohNwOEXbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745415585; c=relaxed/simple;
	bh=S0WcvfERookrfqdsNf09r0AEV1z7UbVgPAAe8PW/qEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=svUGOp3UMuKmUxhtRhqDDM6n37b+BEmqtaOuQoxeppfSPy/5xXQfD1aB7pJLx+wHZhOMvMslAww+DieqEslmdgBI3bCBEUKlK84sgcyjGthGkLs5kxK+F838OMkup1qjXq1Zx8vcMSqVT0oBywOYj7OaQQTBUTGj6xgBEcCfbYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C7fbCECK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C338C4CEE2;
	Wed, 23 Apr 2025 13:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745415584;
	bh=S0WcvfERookrfqdsNf09r0AEV1z7UbVgPAAe8PW/qEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C7fbCECKz3kHNJ+jo+OIrSy4DZWF6VfP/zMT2YhsyEeG8iSKLjTEeP4BGX7t1v67F
	 p+smI3psobdO3tCjGOBUD38dcg+HJceGigztEe+RqIFgjXeSmBqGusz82SrUq7Iqhr
	 6YBAvgVdMKqIXI9geSfRtO4adJnuAwKrlMzGN0FoYiFnp8djUeWrTDRnjGiNRjdms1
	 lVhbJbHhBl3bRbYk7Z4X83FROH2nhn6Tw5OSDGilthlPt/WSsdwmadbLXjVpawj9FS
	 VkdfwLWiAYzGPR8yiCx1MEJV3iIN1dHQZZLErOM+ocSreR4LOhSFYEGHNzjW661Mct
	 C0lSied3DnKWA==
Date: Wed, 23 Apr 2025 16:39:39 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>,
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
Subject: Re: [PATCH v9 22/24] nvme-pci: use a better encoding for small prp
 pool allocations
Message-ID: <20250423133939.GJ48485@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <973ed41249e12766383b3cedac799692f9bda3b8.1745394536.git.leon@kernel.org>
 <20250423090552.GA381@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423090552.GA381@lst.de>

On Wed, Apr 23, 2025 at 11:05:52AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 23, 2025 at 11:13:13AM +0300, Leon Romanovsky wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > There is plenty of unused space in the iod next to nr_descriptors.
> > Add a separate flag to encode that the transfer is using the full
> > page sized pool, and use a normal 0..n count for the number of
> > descriptors.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Tested-by: Jens Axboe <axboe@kernel.dk>
> > [ Leon: changed original bool variable to be flag as was proposed by Kanchan ]
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/nvme/host/pci.c | 93 ++++++++++++++++++++---------------------
> >  1 file changed, 46 insertions(+), 47 deletions(-)
> > 
> > diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> > index 638e759b29ad..7e93536d01cb 100644
> > --- a/drivers/nvme/host/pci.c
> > +++ b/drivers/nvme/host/pci.c
> > @@ -44,6 +44,7 @@
> >  #define NVME_MAX_SEGS	128
> >  #define NVME_MAX_META_SEGS 15
> >  #define NVME_MAX_NR_DESCRIPTORS	5
> > +#define NVME_SMALL_DESCRIPTOR_SIZE 256
> >  
> >  static int use_threaded_interrupts;
> >  module_param(use_threaded_interrupts, int, 0444);
> > @@ -219,6 +220,10 @@ struct nvme_queue {
> >  	struct completion delete_done;
> >  };
> >  
> > +enum {
> > +	IOD_LARGE_DESCRIPTORS = 1, /* uses the full page sized descriptor pool */
> 
> This is used as a ORable flag, I'd make that explicit:
> 
> 	/* uses the full page sized descriptor pool */
> 	IOD_LARGE_DESCRIPTORS		= 1U << 0,
> 
> and similar for the next flag added in the next patch.
> 
> >  	struct nvme_request req;
> >  	struct nvme_command cmd;
> >  	bool aborted;
> > -	/* # of PRP/SGL descriptors: (0 for small pool) */
> > -	s8 nr_descriptors;
> > +	u8 nr_descriptors;	/* # of PRP/SGL descriptors */
> > +	unsigned int flags;
> 
> And this should be limited to a u16 to not bloat the structure.

I'll limit it to u8.

Thanks

> 

