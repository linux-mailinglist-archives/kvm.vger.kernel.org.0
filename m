Return-Path: <kvm+bounces-53636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1225B14D1D
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 13:40:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED11B3AA6AF
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 11:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF6F28F51B;
	Tue, 29 Jul 2025 11:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qpcxA/u9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8921F27A928;
	Tue, 29 Jul 2025 11:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753789188; cv=none; b=REyPMDrYAfCzMH8JBLFVbW3/OaTgCp1iFP2cux76SSoUabz+s7svF/IvOG7iO7wmk5WLRsTasKhjIps4bibmSE19oEhCM7JjH3e1bmlOPzNUjf7UDPSjRp1UbqoLiruYF+xo2hU7sDVWYkbE/Vd2EGmgd8ej0Y+nTeTZGCIWla4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753789188; c=relaxed/simple;
	bh=RPpvSK/8qiFnebjIGVvl4LqDX43VTor4nmtafMFjlfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D71Cb7roQo8oPuo9QhHH6f3i3kaECT8TgXgQaX78z9qerhPfAbq553xlTanJDVkxrV0+YgqxmwvY6JbAM5xpNlulZcEH/1+b49q0su57/VlNUZMQ4mlJc/y0amcti3eWR86ClNMCH8JrEsdn2qHOYTpbCpYr2LReBr1nk9S0CRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qpcxA/u9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D158C4CEEF;
	Tue, 29 Jul 2025 11:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753789188;
	bh=RPpvSK/8qiFnebjIGVvl4LqDX43VTor4nmtafMFjlfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qpcxA/u9Tznj7llG4bq8FgGR6n8loB2QOxor+6SdCBhDOlGqqCbPcbo6ut4+3zXzL
	 O5B+31lN4CYNt7zw8YTEfSBOXxZFWo+0AsNmp1TdE0XL16apisn11dsrtPqTtYAHln
	 VCS+YdU5DPkiycpCq/fSNmsqkqr8kFs7KFT5s5fsNGA/S8X9xcFgGaDoBgAo4DoPRF
	 aMN7RJsq0IlBv4/1hktW6Ljb6F9jYory7s2E+kTM/3t3aXsuUFLKZRJBPZxHTdv1oc
	 KuceSjXps91R6vKXxveoKFcrxBdr11X2quBjbA9AraUBemCTyZvSzA7Y7ok9Ir4LiX
	 qadsSroZsSBiw==
Date: Tue, 29 Jul 2025 14:39:43 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
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
Subject: Re: [PATCH 02/10] PCI/P2PDMA: Introduce p2pdma_provider structure
 for cleaner abstraction
Message-ID: <20250729113943.GJ402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com>
 <20250724075145.GB30590@lst.de>
 <20250724075533.GR402218@unreal>
 <20250724075922.GD30590@lst.de>
 <20250727185158.GE7551@nvidia.com>
 <20250729075209.GA23823@lst.de>
 <20250729085336.GG402218@unreal>
 <20250729104100.GA29053@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729104100.GA29053@lst.de>

On Tue, Jul 29, 2025 at 12:41:00PM +0200, Christoph Hellwig wrote:
> On Tue, Jul 29, 2025 at 11:53:36AM +0300, Leon Romanovsky wrote:
> > > Because the struct page is the only thing that:
> > > 
> > >  a) dma-mapping works on
> > >  b) is the only place we can discover the routing information, but also
> > >     more importantly ensure that the underlying page is still present
> > >     and the device is not hot unplugged, or in a very theoretical worst
> > >     case replaced by something else.
> > 
> > It is correct in general case, but here we are talking about MMIO
> > memory, which is "connected" to device X and routing information is
> > stable.
> 
> MMIO is literally the only thing we support to P2P to/from as that is
> how PCIe P2P is defined.  And not, it's not stable - devices can be
> unplugged, and BARs can be reenumerated.

I have a feeling that we are drifting from the current patchset to more
general discussion.

The whole idea of new DMA API is to provide flexibility to the callers
(subsystems) who are perfectly aware of their data and limitations to
implement direct addressing natively.

In this series, device is controlled by VFIO and DMABUF. It is not
possible to unplug it without VFIO notices it. In such case, p2pdma_provider
and related routing information (DMABUF) will be reevaluated.

So for VFIO + DMABUF, the pointer is very stable.

For other cases (general case), the flow is not changed.
Users  will continue to call to old and well-known pci_p2pdma_state()
to calculate p2p type.

Thanks

> 

