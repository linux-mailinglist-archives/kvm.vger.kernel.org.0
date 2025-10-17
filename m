Return-Path: <kvm+bounces-60346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 779A2BEAB36
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 18:28:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 570635A3A3B
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA7D284663;
	Fri, 17 Oct 2025 16:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jTCLpLij"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAADD137923;
	Fri, 17 Oct 2025 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760717643; cv=none; b=lz36GyM0YAyipewhfiqZkzzWFCUG5HWF7yw5fl0Tr6ltmyctSJQe9f2EHdJWsZ3ZCw6c2dlVaFaylxHt4RPjgGHXG+CDyPpcogDcXIdUc70cpjvaCDpixJIlreEFgicGcFwjsWzjSOkidjwSJnh19P607Tz1Q/6AttO6l7wyZnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760717643; c=relaxed/simple;
	bh=CFcYtcEk7uP8GckKeqhWU4+P+5/c+ra0lxow6L4SUMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLI6bkp7lceRb9LLEScfPsVWhNWoKxpF/W9RfySAsFKj1l/3A2BakFgoI542UQOTgwi9jVkS0yLnqvw5T0FwNA/l6FZk91P6xCGXJVKxct68F1EyOXDQ4WNkgOo0pBwfObfE448MYoNiB2jgKtJQFrcPa7lRpuVoq+eqcw+p7rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jTCLpLij; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A6CC4CEE7;
	Fri, 17 Oct 2025 16:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760717643;
	bh=CFcYtcEk7uP8GckKeqhWU4+P+5/c+ra0lxow6L4SUMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jTCLpLij/ghgEicXuXTN+FZWe2vozg4SlZDHShFYvfPIUqub9PEm0BZPbrfwhk5Y5
	 kHa3fBtd0I8PMX+AkKdag0U4BIzd+49ChSgph58nyWLMOvvlEkwLSjIU2QA34zc5nd
	 BpBoDkebgbg0pPisYn/W4PGMd45z0hbP0jVSgkM4MgKyCqfaMb/c3ml+HtbaZZruJK
	 9IAS1YwF8RfmI7S0ETdhisl70QdOy43W8iOfuHMtQEZdTi632zsoLdFP1Hd/l02tPB
	 yhqVnuCW1LoEbFlWHwImXvx1hZKb3X24VRl34jQQI9Hw9D2yq1wpOpB62Ntmkc5Aj7
	 qEnbZ7Op0le6g==
Date: Fri, 17 Oct 2025 19:13:58 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251017161358.GC6199@unreal>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <20251017130249.GA309181@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017130249.GA309181@nvidia.com>

On Fri, Oct 17, 2025 at 10:02:49AM -0300, Jason Gunthorpe wrote:
> On Mon, Oct 13, 2025 at 06:26:11PM +0300, Leon Romanovsky wrote:
> > +static void dma_ranges_to_p2p_phys(struct vfio_pci_dma_buf *priv,
> > +				   struct vfio_device_feature_dma_buf *dma_buf,
> > +				   struct vfio_region_dma_range *dma_ranges,
> > +				   struct p2pdma_provider *provider)
> > +{
> > +	struct pci_dev *pdev = priv->vdev->pdev;
> > +	phys_addr_t pci_start;
> > +	u32 i;
> > +
> > +	pci_start = pci_resource_start(pdev, dma_buf->region_index);
> > +	for (i = 0; i < dma_buf->nr_ranges; i++) {
> > +		priv->phys_vec[i].len = dma_ranges[i].length;
> > +		priv->phys_vec[i].paddr = pci_start + dma_ranges[i].offset;
> > +		priv->size += priv->phys_vec[i].len;
> > +	}
> 
> This is missing validation, the userspace can pass in any
> length/offset but the resource is of limited size. Like this:
> 
> static int dma_ranges_to_p2p_phys(struct vfio_pci_dma_buf *priv,
> 				  struct vfio_device_feature_dma_buf *dma_buf,
> 				  struct vfio_region_dma_range *dma_ranges,
> 				  struct p2pdma_provider *provider)
> {
> 	struct pci_dev *pdev = priv->vdev->pdev;
> 	phys_addr_t len = pci_resource_len(pdev, dma_buf->region_index);
> 	phys_addr_t pci_start;
> 	phys_addr_t pci_last;
> 	u32 i;
> 
> 	if (!len)
> 		return -EINVAL;
> 	pci_start = pci_resource_start(pdev, dma_buf->region_index);
> 	pci_last = pci_start + len - 1;
> 	for (i = 0; i < dma_buf->nr_ranges; i++) {
> 		phys_addr_t last;
> 
> 		if (!dma_ranges[i].length)
> 			return -EINVAL;
> 
> 		if (check_add_overflow(pci_start, dma_ranges[i].offset,
> 				       &priv->phys_vec[i].paddr) ||
> 		    check_add_overflow(priv->phys_vec[i].paddr,
> 				       dma_ranges[i].length - 1, &last))
> 			return -EOVERFLOW;
> 		if (last > pci_last)
> 			return -EINVAL;
> 
> 		priv->phys_vec[i].len = dma_ranges[i].length;
> 		priv->size += priv->phys_vec[i].len;
> 	}
> 	priv->nr_ranges = dma_buf->nr_ranges;
> 	priv->provider = provider;
> 	return 0;
> }

I have these checks in validate_dmabuf_input(). Do you think that I need
to add extra checks?

Thanks

> 
> Jason

