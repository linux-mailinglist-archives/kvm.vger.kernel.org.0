Return-Path: <kvm+bounces-30299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A5129B8FF7
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 12:06:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ED6928278F
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 11:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA6101990A8;
	Fri,  1 Nov 2024 11:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CTwdqT2l"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7F115A84E;
	Fri,  1 Nov 2024 11:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730459188; cv=none; b=TJL1dCvv5mkQcVDVU/Ow/OAd0tupPSR7lBhD9BpEHAHbv5QFFUyVguv0JrcHLUfLbnfa6q+YCb9LwkcbxkRsx+em3OgG2L8wIFgeHECdHs/hL0ljrW8qGDd57oaOsHKL2h+3ZWr1zkUZfdVitaUpsgTI2sQ7PI09JlncflS8c1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730459188; c=relaxed/simple;
	bh=4cdN8oppOPWY/v1yFlCvkKvAwOHnBpBM0oBxJMPVYLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bd1upij3ZOVN/YpuqY1CHtCZs1lx2H0ISbiSPaUPS+zpR0eh/vsqe8Bz+Jf+uinhjqCaq7tbk4UFWRD5wrrRiQwQuvGqzcj4Vh+G3uYInw6oY6ZGCVFY7b++Jh9f+DAjRKKHNFOMOYfxVqDPwYZHDI/jSZFzG9j454vCdn/APdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CTwdqT2l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C58C4CECD;
	Fri,  1 Nov 2024 11:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730459188;
	bh=4cdN8oppOPWY/v1yFlCvkKvAwOHnBpBM0oBxJMPVYLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CTwdqT2l5uk5gwpVRS10I7uPpizsb/hBcBKWekYNb0/1/xyMQmvvfagsufSNIp0+H
	 St+9WxVL8pwKleCrfHfZOuVkWSULd6MySOeEWfvsCSV0bHUjeaV4Ap2L+3O8raqwIS
	 p8YZpzpRR2xY/A6EMSIL/RHlUwRsD/PxD5D4If7Zj2eoCfoQV5qXib+WWg4KhvHw2Z
	 saicJOq/ogsv1rxc7raI5JADLpXusjkRSrgZdWf1j6772wyPuX/i0FTrFjRY3w286B
	 PjBi7Ma3lUD9gnl/JBiWlvccuEDx1UcX9zpXWH1OJeH3wNcgUidQmhlFlXz687wucc
	 p44pH3kVnbTcg==
Date: Fri, 1 Nov 2024 13:06:22 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
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
Subject: Re: [PATCH v1 08/17] dma-mapping: add a dma_need_unmap helper
Message-ID: <20241101110622.GD88858@unreal>
References: <cover.1730298502.git.leon@kernel.org>
 <00385b3557fa074865d37b0ac613d2cb28bcb741.1730298502.git.leon@kernel.org>
 <7e362d8b-c02a-4327-9c5d-af1c4725ddc7@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e362d8b-c02a-4327-9c5d-af1c4725ddc7@arm.com>

On Thu, Oct 31, 2024 at 09:18:11PM +0000, Robin Murphy wrote:
> On 30/10/2024 3:12 pm, Leon Romanovsky wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Add helper that allows a driver to skip calling dma_unmap_*
> > if the DMA layer can guarantee that they are no-nops.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >   include/linux/dma-mapping.h |  5 +++++
> >   kernel/dma/mapping.c        | 20 ++++++++++++++++++++
> >   2 files changed, 25 insertions(+)
> > 
> > diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> > index 8074a3b5c807..6906edde505d 100644
> > --- a/include/linux/dma-mapping.h
> > +++ b/include/linux/dma-mapping.h
> > @@ -410,6 +410,7 @@ static inline bool dma_need_sync(struct device *dev, dma_addr_t dma_addr)
> >   {
> >   	return dma_dev_need_sync(dev) ? __dma_need_sync(dev, dma_addr) : false;
> >   }
> > +bool dma_need_unmap(struct device *dev);
> >   #else /* !CONFIG_HAS_DMA || !CONFIG_DMA_NEED_SYNC */
> >   static inline bool dma_dev_need_sync(const struct device *dev)
> >   {
> > @@ -435,6 +436,10 @@ static inline bool dma_need_sync(struct device *dev, dma_addr_t dma_addr)
> >   {
> >   	return false;
> >   }
> > +static inline bool dma_need_unmap(struct device *dev)
> > +{
> > +	return false;
> > +}
> >   #endif /* !CONFIG_HAS_DMA || !CONFIG_DMA_NEED_SYNC */
> >   struct page *dma_alloc_pages(struct device *dev, size_t size,
> > diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> > index 864a1121bf08..daa97a650778 100644
> > --- a/kernel/dma/mapping.c
> > +++ b/kernel/dma/mapping.c
> > @@ -442,6 +442,26 @@ bool __dma_need_sync(struct device *dev, dma_addr_t dma_addr)
> >   }
> >   EXPORT_SYMBOL_GPL(__dma_need_sync);
> > +/**
> > + * dma_need_unmap - does this device need dma_unmap_* operations
> > + * @dev: device to check
> > + *
> > + * If this function returns %false, drivers can skip calling dma_unmap_* after
> > + * finishing an I/O.  This function must be called after all mappings that might
> > + * need to be unmapped have been performed.
> 
> In terms of the unmap call itself, why don't we just use dma_skip_sync to
> short-cut dma_direct_unmap_*() and make sure it's as cheap as possible?

From what I see dma_skip_sync is not available when kernel is built
without CONFIG_DMA_NEED_SYNC.

> 
> In terms of not having to unmap implying not having to store addresses at
> all, it doesn't seem super-useful when you still have to store them for long
> enough to find out that you don't :/

Why? The decision if DMA addresses are needed is taken when allocating
relevant arrays, before we have any DMA address to store. If we know
that we don't need to unmap, we can skip allocation of the array for
free. So what and when "you still have to store them"?

Thanks

> 
> Thanks,
> Robin.
> 
> > + */
> > +bool dma_need_unmap(struct device *dev)
> > +{
> > +	if (!dma_map_direct(dev, get_dma_ops(dev)))
> > +		return true;
> > +#ifdef CONFIG_DMA_NEED_SYNC
> > +	if (!dev->dma_skip_sync)
> > +		return true;
> > +#endif
> > +	return IS_ENABLED(CONFIG_DMA_API_DEBUG);
> > +}
> > +EXPORT_SYMBOL_GPL(dma_need_unmap);
> > +
> >   static void dma_setup_need_sync(struct device *dev)
> >   {
> >   	const struct dma_map_ops *ops = get_dma_ops(dev);
> 

