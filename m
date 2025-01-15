Return-Path: <kvm+bounces-35511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EFD3A11AE1
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 08:27:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A38D3188A4E9
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 07:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F08C1DB14F;
	Wed, 15 Jan 2025 07:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PlEsLImC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558B71DB129;
	Wed, 15 Jan 2025 07:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736926043; cv=none; b=qfg/HrWswn8z+gwYG8u+x2u06Wn9/uJIAH4TgeziIWuje2zTnoyA10DaA7pK7iapOU87n9UrofIkYRZgbaL5UgHAe/vW1fkARDyBi40FCg+yFjrXs9o8NRzc2wjViFRyS0+hZVkE3/bdizN3pBKU+1u8+XW9q7RS6o4nDPxFH8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736926043; c=relaxed/simple;
	bh=W+JWGoU6jLFwbe+ZoYGQcxjcZ17AGd0C8/odV+o/TLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JKo+3Ns97yGfbdOqQZHBJ3K/FwdYDIVHsDPLOUDC13VFPinxDJhg/Gd9HsMlVMhennS/Jj+/x1wtRL294LkmlfFyTSEUBoTSg9rdwsph/A3h0BLaI6d+yQ1wqZ75r5ZBtvICnvPU5SviPAUgijr2xObsKEo89DtiyxYGYRZfsaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PlEsLImC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD41C4CEDF;
	Wed, 15 Jan 2025 07:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736926042;
	bh=W+JWGoU6jLFwbe+ZoYGQcxjcZ17AGd0C8/odV+o/TLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PlEsLImCwnYqAoqms0P20DW62uLfIgjKyzptCpjG5UVIUXYCrzVmwk7m0oi/eJDWg
	 i7D1HOkxJZnKKnh0C+5xD+1X+uFQNGWJ1iZOiw1yU9Qcb7+5dh8ogtNN/k0QCZgCZJ
	 TyKE1gNFh1Eh9kiL7Z6WnV63cZKl9hwNUc02tBxWp3qPFnFGIDvADP4ssiUBQEzGog
	 BSgaFn4z3ohejNw+thnAgwWyLPajfW6rH21UYgVzsz5O38cma/CfLRJS2ZPPOsw53e
	 j7/TVSSizkDLGNS26gONx2q0vAi+LG3NkSnHwl81L1TUxhDeOkKbBvsH1CHdaPabMt
	 mR77nKXe/gODQ==
Date: Wed, 15 Jan 2025 09:27:18 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Robin Murphy <robin.murphy@arm.com>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v5 07/17] dma-mapping: Implement link/unlink ranges API
Message-ID: <20250115072718.GJ3146852@unreal>
References: <cover.1734436840.git.leon@kernel.org>
 <fa43307222f263e65ae0a84c303150def15e2c77.1734436840.git.leon@kernel.org>
 <ad2312e0-10d5-467a-be5e-75e80805b311@arm.com>
 <20250115062628.GA29782@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115062628.GA29782@lst.de>

On Wed, Jan 15, 2025 at 07:26:28AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 14, 2025 at 08:50:35PM +0000, Robin Murphy wrote:

<...>

> >> +	if (dev_use_swiotlb(dev, size, dir) && iova_offset(iovad, phys | size))
> >
> > Again, why are we supporting non-granule-aligned mappings in the middle of 
> > a range when the documentation explicitly says not to?
> 
> It's not trying to support that, but checking that this is guaranteed
> to be the last one is harder than handling it like this.  If you have
> a suggestion for better checks that would be very welcome.
> 
> >> +		if (!dev_is_dma_coherent(dev) &&
> >> +		    !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
> >> +			arch_sync_dma_for_cpu(phys, len, dir);
> >
> > Hmm, how do attrs even work for a bulk unlink/destroy when the individual 
> > mappings could have been linked with different values?
> 
> They shouldn't.  Just like randomly mixing flags doesn't work for the
> existing APIs.
> 
> > (So no, irrespective of how conceptually horrid it is, clearly it's not 
> > even functionally viable to open-code abuse of DMA_ATTR_SKIP_CPU_SYNC in 
> > callers to attempt to work around P2P mappings...)
> 
> What do you mean with "work around"?  I guess Leon added it to the hmm
> code based on previous feedback, but I still don't think any of our P2P
> infrastructure works reliably with non-coherent devices as
> iommu_dma_map_sg gets this wrong.  So despite the earlier comments I
> suspect this should stick to the state of the art even if that is broken.

Right, I was asked to set DMA_ATTR_SKIP_CPU_SYNC for PCI_P2PDMA_MAP_THRU_HOST_BRIDGE case.
...
  752         case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
  753                 attrs |= DMA_ATTR_SKIP_CPU_SYNC;
  754                 pfns[idx] |= HMM_PFN_P2PDMA;
  755                 break;

At this stage, we didn't change DMA/IOMMU previous behaviour and if it
was broken for certain flows, it stays to be broken after this series
too.

Thanks

