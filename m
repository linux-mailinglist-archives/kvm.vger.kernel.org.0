Return-Path: <kvm+bounces-58933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2088BA6ABB
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 10:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FEBC1797E6
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 08:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4AE02BEC43;
	Sun, 28 Sep 2025 08:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KMtmLekY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAE11D8A10;
	Sun, 28 Sep 2025 08:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759047317; cv=none; b=dFk6be9dL8e0O2Ppb5kL9QLtxa0geMyzqGN0aBl1exmR4j6Wrv4eVrwFL0wQE2JlCgjjLsOsPcbCjv+bFIaNMIFozqoFjvnjeVnV10xUxC06ui4Q95PdShkEZsqRKEqxPkFWvf4mfUfGuvQIRjA16jQpDhxUu84UGxrAPtueb28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759047317; c=relaxed/simple;
	bh=de9qzleZA+R2N/Kmiw9QQMnYG50hXtyYa8gfYsMACWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NnwNpZnbMcT99uc/0dJTGiDZyFcS1kImFebtn6n2DZ6YV31y/XFUEqpRyKkuZlJR7aAZWKf8rMDKf1b4XurCoRmtFBlq9c4+ExLqCgp0eaBgd0zpR9c5bw6LE7L1hPTRgLu49FJMlvK6vw7PyQLqZeNVTZiGoVs6ZSJcIiogtys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KMtmLekY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846E1C4CEF0;
	Sun, 28 Sep 2025 08:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759047317;
	bh=de9qzleZA+R2N/Kmiw9QQMnYG50hXtyYa8gfYsMACWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KMtmLekYVZUE7aRFSU9mkhSkk4d2ntkHA9S03kyf74bsqgqfKRQVhafqnCSWyOedv
	 j3ALK52bH8Ib0Qcjq73RywxOiTyDmFQWvZrSLzgQu7h6BfCe96um8PU6yXa3j1+99V
	 FGKhJMG48c569FGlH//UPB1ED5dl4Ifq6JGVIKZvrAca3dREYBHHST1Q5so4+z4eaY
	 ccYycjRt92s6L0ewEIaOyQRQPsYgpAgUNUX7hHBLNc2rys8+IT/z1BVurmh2ZP0TbU
	 V0pJks/SLiWWs/cl5dVESCI2dRN+y9HXnOHfSrklek/YOtBiMhW81kGRirOKn9C5ba
	 xbPCNcierbgCQ==
Date: Sun, 28 Sep 2025 11:15:12 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250928081512.GD12165@unreal>
References: <20250922150032.3e3da410.alex.williamson@redhat.com>
 <20250923150414.GA2608121@nvidia.com>
 <20250923113041.38bee711.alex.williamson@redhat.com>
 <20250923174333.GE2608121@nvidia.com>
 <20250923120932.47df57b2.alex.williamson@redhat.com>
 <20250925070314.GA12165@unreal>
 <20250925115308.GT2617119@nvidia.com>
 <20250925163131.22a2c09b.alex.williamson@redhat.com>
 <20250925230236.GB2617119@nvidia.com>
 <20250926081350.16bb66c8.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926081350.16bb66c8.alex.williamson@redhat.com>

On Fri, Sep 26, 2025 at 08:13:50AM -0600, Alex Williamson wrote:
> On Thu, 25 Sep 2025 20:02:36 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Thu, Sep 25, 2025 at 04:31:31PM -0600, Alex Williamson wrote:
> > > On Thu, 25 Sep 2025 08:53:08 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >   
> > > > On Thu, Sep 25, 2025 at 10:03:14AM +0300, Leon Romanovsky wrote:
> > > >   
> > > > > > It would at least make sense to me then to store the provider on the
> > > > > > vfio_pci_dma_buf object at the time of the get feature call rather than
> > > > > > vfio_pci_core_init_dev() though.  That would eliminate patch 08/ and
> > > > > > the inline #ifdefs.    
> > > > > 
> > > > > I'll change it now. If "enable" function goes to be "get" function, we
> > > > > won't need to store anything in vfio_pci_dma_buf too. At the end, we
> > > > > have exactly two lines "provider = priv->vdev->provider[priv->bar];",
> > > > > which can easily be changed to be "provider = pcim_p2pdma_provider(priv->vdev->pdev, priv->bar)"    
> > > > 
> > > > Not without some kind of locking change. I'd keep the
> > > > priv->vdev->provider[priv->bar] because setup during probe doesn't
> > > > need special locking.  
> > > 
> > > Why do we need to store the provider on the vfio_pci_core_device at
> > > probe though, we can get it later via pcim_p2pdma_provider().   
> > 
> > Because you'd need some new locking to prevent races.
> 
> The race is avoided if we simply call pcim_p2pdma_provider() during
> probe.  We don't need to save the returned provider.  That's where it
> seems like pulling the setup out to a separate function would eliminate
> this annoying BAR# arg.
>  
> > Besides, the model here should be to call the function once during
> > probe and get back the allocated provider. The fact internally it is
> > kind of nutzo still shouldn't leak out as a property of the ABI.
> > 
> > I would like to remove this weird behavior where it caches things
> > inside the struct device. That's not normal for an API to do that, it
> > is only done for the genalloc path that this doesn't use.
> 
> My goal in caching the provider on the vfio p2pdma object was to avoid
> caching it on the vfio_pci_core_device, but now we're storing it on the
> struct device, the vfio_pci_core_device, AND the vfio p2pdma object.
> Given the current state that it's stored on the struct device, I think
> we only need a setup call during probe (that could be stubbed out
> rather than #ifdef'd), then cache the provider on the vfio p2pdma
> object when a dmabuf is configured.  Thanks,

I can do it.

Thanks

> 
> Alex
> 

