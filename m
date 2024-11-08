Return-Path: <kvm+bounces-31324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B55D9C2611
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 21:04:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA1C0B22066
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 20:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A1C61D0B81;
	Fri,  8 Nov 2024 20:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMRxE4R5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5087A17A5BE;
	Fri,  8 Nov 2024 20:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731096243; cv=none; b=ClMP36uP3rnC9GFQM2Kw7H6Ado9S/cBupkhQbEp3kgqSJZgh71gh/qTHMXV9+reRjWMFFhQlFYx1I690jy/9QjSWHJwfky33CmUzwXX/nCPYvM/oeNlRweDU7SMqrYHNPL6guKB2CogQibxTJzEU3OBt4Gd8PyC9rpbews8M6ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731096243; c=relaxed/simple;
	bh=j8/ZMD+Bu1h+adtk4kPnyTobfWGqg8JYd1SKbmkjXD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZIo3l6yvA5D7syKNvAwORPbFe580gcxQN/aAKxRmXVHhUtCL4thCTJS3+22B+wFEfWYgCATvLhSRSyqfraCPjqEu1hntqTRJFb7vYGHA7V7Cx7V0Lo3Evx3tpHG+lEE6oBkMX4Sb56hBrxPZd7SlZIA1QSHch6yL9AfmYaW8VeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMRxE4R5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88D7C4CECD;
	Fri,  8 Nov 2024 20:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731096242;
	bh=j8/ZMD+Bu1h+adtk4kPnyTobfWGqg8JYd1SKbmkjXD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MMRxE4R5dWVG/OvIS2VimVBlKeyDxFEF2K9D6swzKr75NtaOQPu3u1HzWpTwu+lSo
	 85SYMuWjDivh9mgJoWRmt7qwMovoZY3cNUlErSjiFU7xfzhO3L0mkCgYRIYpsXvOde
	 6bLpgXaPXrxvzY26yN0MVKUAc8tmb6/1to+m2Nu5CHHjLY2bKaY0s9yo80iAgyhCBS
	 kpsv+ejCFSu6JJBaNiBYzlklGoRr29zyiIOS6p6yBFIJGxlp5B+VEhP9FbUdyO7D/F
	 /3dZB82/joZZJZEPux6XkULpk+j2C6IsM2ZaXvYGa+K33lGdnm6E5zYBcY73gUMPBa
	 AdQERFF7Kq6pg==
Date: Fri, 8 Nov 2024 22:03:55 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
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
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 09/17] docs: core-api: document the IOVA-based API
Message-ID: <20241108200355.GC189042@unreal>
References: <cover.1730298502.git.leon@kernel.org>
 <881ef0bcf9aa971e995fbdd00776c5140a7b5b3d.1730298502.git.leon@kernel.org>
 <87ttchwmde.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ttchwmde.fsf@trenco.lwn.net>

On Fri, Nov 08, 2024 at 12:34:21PM -0700, Jonathan Corbet wrote:
> Leon Romanovsky <leon@kernel.org> writes:
> 
> > From: Christoph Hellwig <hch@lst.de>
> >
> > Add an explanation of the newly added IOVA-based mapping API.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  Documentation/core-api/dma-api.rst | 70 ++++++++++++++++++++++++++++++
> >  1 file changed, 70 insertions(+)
> >
> > diff --git a/Documentation/core-api/dma-api.rst b/Documentation/core-api/dma-api.rst
> > index 8e3cce3d0a23..6095696a65a7 100644
> > --- a/Documentation/core-api/dma-api.rst
> > +++ b/Documentation/core-api/dma-api.rst
> > @@ -530,6 +530,76 @@ routines, e.g.:::
> >  		....
> >  	}
> >  
> > +Part Ie - IOVA-based DMA mappings
> > +---------------------------------
> > +
> > +These APIs allow a very efficient mapping when using an IOMMU.  They are an
> > +optional path that requires extra code and are only recommended for drivers
> > +where DMA mapping performance, or the space usage for storing the DMA addresses
> > +matter.  All the consideration from the previous section apply here as well.
> > +
> > +::
> > +
> > +    bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
> > +		phys_addr_t phys, size_t size);
> > +
> > +Is used to try to allocate IOVA space for mapping operation.  If it returns
> > +false this API can't be used for the given device and the normal streaming
> > +DMA mapping API should be used.  The ``struct dma_iova_state`` is allocated
> > +by the driver and must be kept around until unmap time.
> 
> So, I see that you have nice kernel-doc comments for these; why not just
> pull them in here with a kernel-doc directive rather than duplicating
> the information?

Can I you please point me to commit/lore link/documentation with example
of such directive and I will do it?

Thanks

> 
> Thanks,
> 
> jon

