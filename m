Return-Path: <kvm+bounces-41231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A10BCA6518D
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 14:45:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C0773A7D74
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 13:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B54023F417;
	Mon, 17 Mar 2025 13:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ILjGPW3O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364618F5E;
	Mon, 17 Mar 2025 13:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742219084; cv=none; b=Ict+NBx8MfG2IOxsg9gxld0xhoxSEnRuwujxxkj59ctSMP2ykcOr+RL+oM37/NEDl0JoKSJ39x7Sd4zXeNvTx2ATXOXCb2Hp+bV4zBDK8TapgGR4e3kzbU9MvQVgW07PlIdnM3SjK9eNan8uASqCfHxkBrdhiZ7KUDu6oGom0/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742219084; c=relaxed/simple;
	bh=Nivyt0eviFTvQGhEOEf8ZZpxVSrnlmwhnY5tRfaE3Wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kAAzZwriSWF2xspYOIdgiKAIl8KIw/qPbtnxUo4iNFnC5QUvVUu582nm2/bigPaoHY/gnqbSloez+a63ieHD1aFaoEUdEGbbQplflBmFS5FNaXaldcXIMXc4EEzZ7p0Wws3yiaKWKXNg0sUesReEMg1b7uDvn3hJnj+E8j8+ybQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ILjGPW3O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2E6C4CEE3;
	Mon, 17 Mar 2025 13:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742219083;
	bh=Nivyt0eviFTvQGhEOEf8ZZpxVSrnlmwhnY5tRfaE3Wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ILjGPW3OLQcmOrkMv5AH8aq1hrAnpRAPMTAQgLR7RHFsJF2bLoRw3BTOgmHBq56Li
	 RCNNwy/ccowtgdxyVVPCv0ACNvWo78Z/Cvu5jcsLgefi4PUDEch8eU1Oviz3EuYzg5
	 XUIEGSx2UA3cLHJWgIltL+b6l4V15ww+2bB6RDXFXhGG+65hftuhRbA0B/Wi3ffTrq
	 1vQsHc29chbUvptRWKtzZwyE1x1581v27MnBNJCKTXUw8791ZidkW0v3U8o4LXMJS3
	 W5yBnsLldEWaxyxVsmdLLyDaZrnHRHhHavJ+TGx31Iv9mQtnnuwHaY0Ofdxp9EFxBU
	 dA3ZPdJHhLs9A==
Date: Mon, 17 Mar 2025 15:44:39 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Jens Axboe <axboe@kernel.dk>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v7 03/17] iommu: generalize the batched sync after map
 interface
Message-ID: <20250317134439.GX1322339@unreal>
References: <cover.1738765879.git.leonro@nvidia.com>
 <ad8b0dc927ea21238457a47537d39cd746751f4b.1738765879.git.leonro@nvidia.com>
 <d83afae060351f49fe0ba661f69c1d0b00538a35.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d83afae060351f49fe0ba661f69c1d0b00538a35.camel@linux.ibm.com>

On Mon, Mar 17, 2025 at 10:52:11AM +0100, Niklas Schnelle wrote:
> On Wed, 2025-02-05 at 16:40 +0200, Leon Romanovsky wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > For the upcoming IOVA-based DMA API we want to use the interface batch the
> > sync after mapping multiple entries from dma-iommu without having a
> > scatterlist.
> > 
> > For that move more sanity checks from the callers into __iommu_map and
> > make that function available outside of iommu.c as iommu_map_nosync.
> > 
> > Add a wrapper for the map_sync as iommu_sync_map so that callers don't
> > need to poke into the methods directly.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Acked-by: Will Deacon <will@kernel.org>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/iommu/iommu.c | 65 +++++++++++++++++++------------------------
> >  include/linux/iommu.h |  4 +++
> >  2 files changed, 33 insertions(+), 36 deletions(-)
> > 
> > 
> --- snip ---
> > +
> >  	return mapped;
> >  
> >  out_err:
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > index 38c65e92ecd0..7ae9aa3a1894 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -857,6 +857,10 @@ extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
> >  extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
> >  extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
> >  		     phys_addr_t paddr, size_t size, int prot, gfp_t gfp);
> > +int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
> > +		phys_addr_t paddr, size_t size, int prot, gfp_t gfp);
> > +int iommu_sync_map(struct iommu_domain *domain, unsigned long iova,
> > +		size_t size);
> 
> There are two different word orders in the function names.
> iommu_sync_map() vs iommu_map_nosync(). I'd prefer to be consistent
> with e.g. iommu_map_sync() vs iommu_map_nosync().

The naming came from refactoring different functions, one was simple *_map() and
another was iotlb_*_sync(), but yes we can name it consistently.

Thanks

> 
> >  extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
> >  			  size_t size);
> >  extern size_t iommu_unmap_fast(struct iommu_domain *domain,
> 

