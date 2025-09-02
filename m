Return-Path: <kvm+bounces-56558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFD0EB3FD52
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 13:07:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB7CC48849E
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 11:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 934942F744F;
	Tue,  2 Sep 2025 11:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="luXQtemq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BEB2E92C5;
	Tue,  2 Sep 2025 11:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756811217; cv=none; b=eDk0SJ9NglRtWAlWPjUwtEUFQqcupDCysSz+EyS3VbUDTWPjrL1+qkx7IIP35TZHwbs+7LWIUdqGFEznoNKS+TonOsiy5FADH96/LfuWtJLsw3FkOaxmJJPzLwTDpoVee9n8qKrb/1vqJQFrNKp4xUxeLH+hsUG9FE5+cqbnooM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756811217; c=relaxed/simple;
	bh=hCa1C3d5MBR18h+mVpk4RAM474rjo1/g4TQSzEy0Gzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Extkj077px/uWP8AStzNqcoYDBdI4QigYu/2389Wp9czN2sOFY7gBxnV8gXCjD/1Zy7iqTcp1u02J/zbETj0bbRgLrQlS8Sbw2m/93EPtR4DYngxC9KrVDurGh8VyYDwDDC7NYHXEbub+wvOkidabjEOKzyqJAJGlTs5MllBlCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=luXQtemq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D67BC4CEED;
	Tue,  2 Sep 2025 11:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756811217;
	bh=hCa1C3d5MBR18h+mVpk4RAM474rjo1/g4TQSzEy0Gzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=luXQtemqwauDCW1OGofW7KOn0Ed3TXz+7wSyh4Rq/4C4pBNfrCav73O7nhlQqKsu9
	 pJwS6fgD10XM5MWzc2V32cauwX2xcs5uKtg2Bn+xWgyC8SmOfVZ8jKdythn+ZO4vAa
	 0h7EOGiI+UMeKypfX8GCyk9wrCAP4tCX2z8kMskVDMEaLSOSdX6db0uWHaJchKjybu
	 MaLbWwVqK1itWBWz4FOiOlTEHChtIjiBEjBS0WHuFG4wArCchdxmDkRdChfk7RgGoF
	 PbQcn5XJw0e6Ezn8C5XZTAc61l/+qt/LvKdGUrn6ovVC7JKrzqR3GHSc85H+bG5dhG
	 nrqyYFGPfwuJg==
Date: Tue, 2 Sep 2025 14:06:51 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v1 01/10] PCI/P2PDMA: Remove redundant bus_offset from
 map state
Message-ID: <20250902110651.GF10073@unreal>
References: <cover.1754311439.git.leon@kernel.org>
 <c9b6237964b9606418af400bb6bec5178fcffff2.1754311439.git.leon@kernel.org>
 <20250806145825.2654ee59.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250806145825.2654ee59.alex.williamson@redhat.com>

On Wed, Aug 06, 2025 at 02:58:25PM -0600, Alex Williamson wrote:
> On Mon,  4 Aug 2025 16:00:36 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Remove the bus_off field from pci_p2pdma_map_state since it duplicates
> > information already available in the pgmap structure. The bus_offset
> > is only used in one location (pci_p2pdma_bus_addr_map) and is always
> > identical to pgmap->bus_offset.
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/pci/p2pdma.c       | 1 -
> >  include/linux/pci-p2pdma.h | 3 +--
> >  2 files changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> > index da5657a020074..274bb7bcc0bc5 100644
> > --- a/drivers/pci/p2pdma.c
> > +++ b/drivers/pci/p2pdma.c
> > @@ -1009,7 +1009,6 @@ void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
> >  {
> >  	state->pgmap = page_pgmap(page);
> >  	state->map = pci_p2pdma_map_type(state->pgmap, dev);
> > -	state->bus_off = to_p2p_pgmap(state->pgmap)->bus_offset;
> >  }
> >  
> >  /**
> > diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
> > index 075c20b161d98..b502fc8b49bf9 100644
> > --- a/include/linux/pci-p2pdma.h
> > +++ b/include/linux/pci-p2pdma.h
> > @@ -146,7 +146,6 @@ enum pci_p2pdma_map_type {
> >  struct pci_p2pdma_map_state {
> >  	struct dev_pagemap *pgmap;
> >  	enum pci_p2pdma_map_type map;
> > -	u64 bus_off;
> >  };
> >  
> >  /* helper for pci_p2pdma_state(), do not use directly */
> > @@ -186,7 +185,7 @@ static inline dma_addr_t
> >  pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t paddr)
> >  {
> >  	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
> > -	return paddr + state->bus_off;
> > +	return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
> >  }
> >  
> >  #endif /* _LINUX_PCI_P2P_H */

Sorry for long time to reply, I waited to see what is going on with DMA
phys_vec basic series and together with my summer vacation, it took a
while.

> 
> Looks like you're relying on this bogus code getting resolved in the
> next patch...
> 
> In file included from kernel/dma/direct.c:16:
> ./include/linux/pci-p2pdma.h: In function ‘pci_p2pdma_bus_addr_map’:
> ./include/linux/pci-p2pdma.h:188:24: error: implicit declaration of function ‘to_p2p_pgmap’ [-Wimplicit-function-declaration]
>   188 |         return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
>       |                        ^~~~~~~~~~~~
> ./include/linux/pci-p2pdma.h:188:50: error: invalid type argument of ‘->’ (have ‘int’)
>   188 |         return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
>       |                                                  ^~
> ./include/linux/pci-p2pdma.h:189:1: error: control reaches end of non-void function [-Werror=return-type]
>   189 | }
>       | ^
> 
> to_p2p_pgmap() is a static function and struct pci_p2pdma_pagemap
> doesn't have a bus_offsetf member.  Thanks,

You are right, probably the best way to fix the error is simply squash
this change into the next patch.

Thanks



> 
> Alex
> 

