Return-Path: <kvm+bounces-60559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95FDABF27ED
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 18:45:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DA99189B61A
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 16:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7193F32C955;
	Mon, 20 Oct 2025 16:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwACY+gA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BC732BF23;
	Mon, 20 Oct 2025 16:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760978703; cv=none; b=tiAQ6XtVfZYryw5ZkAufp6kGMEWkJUeKxJgIJxqtvWmJk3OKtbUNFCrL96EwHhRSrCDgj8moTv2KfnV+lNguwLUmvOpuabPIKkWpP8uxW4wCB/74qHXV+1z6YcVW6Qo08mLPo4x3pZC0RZrKIFEIs5gj+UEICc5XHNwvuR55U/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760978703; c=relaxed/simple;
	bh=TIx5NRTP5K3pYgUiu6kQ2tFh50oiXo0JG1oS7oaLLgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GjWs1HCY3QC+rFgzPjLcxGMMnAWf+VVjMEEbqHBy1rW4R0zuGnT7vHm5HSlqE3PlRUezcdt9k+UWX/iYn8cEguvZxx55yiSTLRML+0nvZTuhzeynjBzlVsp7rnvXTKF+c443Y968+hHe7o7W+GCCsh/4AUgKI7F4kZbISJfHQmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwACY+gA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E34C116B1;
	Mon, 20 Oct 2025 16:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760978703;
	bh=TIx5NRTP5K3pYgUiu6kQ2tFh50oiXo0JG1oS7oaLLgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uwACY+gAAHVeDRNLQa9LhoH9lcVFnZPzXatywkYG646bVhvuqsRPN14g1g/VNKLes
	 WYNJREIXrJtYT7QbloBWC3KAb3tT4a4woiFgInEG+Q1ETN0Ps+qgi6JaeRCyXnfGma
	 5sgxwKokkXII1oj9idvsCFH+xzxFf+ctHebO0Crf8NoevzUCnORlmsx2c38BzGnEu/
	 s3EFcu5YRpFtIlMTjRKfKi1EEzzIFI6u24tuPRov6TF1nceX6GqjYmDq7yRyORhFLg
	 hFkabH/anV7vAMpIABZ7pHq33jQbOvDbCcvoCX9x7Rpe/xWcFSBpnYpbbJKwrjEhRF
	 yB30+vyIw7ITg==
Date: Mon, 20 Oct 2025 19:44:57 +0300
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
Message-ID: <20251020164457.GQ6199@unreal>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <20251017130249.GA309181@nvidia.com>
 <20251017161358.GC6199@unreal>
 <20251020161516.GU316284@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020161516.GU316284@nvidia.com>

On Mon, Oct 20, 2025 at 01:15:16PM -0300, Jason Gunthorpe wrote:
> On Fri, Oct 17, 2025 at 07:13:58PM +0300, Leon Romanovsky wrote:
> > > static int dma_ranges_to_p2p_phys(struct vfio_pci_dma_buf *priv,
> > > 				  struct vfio_device_feature_dma_buf *dma_buf,
> > > 				  struct vfio_region_dma_range *dma_ranges,
> > > 				  struct p2pdma_provider *provider)
> > > {
> > > 	struct pci_dev *pdev = priv->vdev->pdev;
> > > 	phys_addr_t len = pci_resource_len(pdev, dma_buf->region_index);
> > > 	phys_addr_t pci_start;
> > > 	phys_addr_t pci_last;
> > > 	u32 i;
> > > 
> > > 	if (!len)
> > > 		return -EINVAL;
> > > 	pci_start = pci_resource_start(pdev, dma_buf->region_index);
> > > 	pci_last = pci_start + len - 1;
> > > 	for (i = 0; i < dma_buf->nr_ranges; i++) {
> > > 		phys_addr_t last;
> > > 
> > > 		if (!dma_ranges[i].length)
> > > 			return -EINVAL;
> > > 
> > > 		if (check_add_overflow(pci_start, dma_ranges[i].offset,
> > > 				       &priv->phys_vec[i].paddr) ||
> > > 		    check_add_overflow(priv->phys_vec[i].paddr,
> > > 				       dma_ranges[i].length - 1, &last))
> > > 			return -EOVERFLOW;
> > > 		if (last > pci_last)
> > > 			return -EINVAL;
> > > 
> > > 		priv->phys_vec[i].len = dma_ranges[i].length;
> > > 		priv->size += priv->phys_vec[i].len;
> > > 	}
> > > 	priv->nr_ranges = dma_buf->nr_ranges;
> > > 	priv->provider = provider;
> > > 	return 0;
> > > }
> > 
> > I have these checks in validate_dmabuf_input(). 
> > Do you think that I need to add extra checks?
> 
> I think they work better in this function, so I'd move them here.

The main idea for validate_dmabuf_input() is to perform as much as
possible checks before allocating kernel memory.

Thanks

> 
> Jason

