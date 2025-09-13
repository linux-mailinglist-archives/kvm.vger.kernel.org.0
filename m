Return-Path: <kvm+bounces-57509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B0EFB56FD9
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 07:49:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C0853B641C
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 05:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B41022797A4;
	Mon, 15 Sep 2025 05:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nHe7Ty6+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2C626F2AB;
	Mon, 15 Sep 2025 05:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757915310; cv=none; b=jBC9Sa18I1JnUSQojO5FPucKvWHEvzQlSSuamCNg+FoWMzXIigqxM6NtOKkENADFcSzeFrvEKEn6WidQ2OyNjNlXAfB/JX/Opmalkv6OU0G6OPb8LkM8QWnRe+ByQQWlW39roJLyIc+SBlfIbhPRdL+CDBM9R8tKhkT8omRt0ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757915310; c=relaxed/simple;
	bh=pNhpXvcF7LKn5UVncvyxPjpBkffgzOi8e5YEIYnOU1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WQO1WxIcjcXexOBbXkXYd/q/9ClYEreE6eR77lKTJArsRAbzdwHjzwAtfiw8Kubd0qRX+CbnN2lfL1al7aw8/yXwNgmS+yi+2q0WA0yDHz9e6MqvzP2hMCuO5JcJosbRk87voRU1vxX4iwCdBfRoHc3C5tAN0hwfxiClHwna1wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nHe7Ty6+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9696EC4CEF1;
	Mon, 15 Sep 2025 05:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757915310;
	bh=pNhpXvcF7LKn5UVncvyxPjpBkffgzOi8e5YEIYnOU1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nHe7Ty6+c/JGvDY+UydwDMZNts0Mvoe5CmZXEM3wRbXlJQZsiKQbiHX1dqED8BM6L
	 jhMyqCWP4HV33158JPyukMw9azmtNrGpkymRgEWzH8txAsk0rOblpfGqGH9ecTIJff
	 SsLxSOkvzP5SEsR+y+RlPv8/wUQ9v3p6CHq91exxQSTUKjsxYQ6lnV1GyfIF3fLnn7
	 aD6U1ucW6cOBHuGB2utJFKkQvvAjc/DWH2//axsYKrHMDRKhgk/Ut1ZqFbNUGkItPt
	 mky2sisAv2UghibJpCApHoRxj04wcBuUhqn0dWEmz2sHkq/6x1znCKDKs3Y1Qa1pZc
	 pNH0C9osgWH6A==
Date: Sat, 13 Sep 2025 13:19:33 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: Re: [PATCH v1 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20250913101933.GW341237@unreal>
References: <cover.1754311439.git.leon@kernel.org>
 <5e043d8b95627441db6156e7f15e6e1658e9d537.1754311439.git.leon@kernel.org>
 <aMRsoUx/NH/Dspm9@devgpu015.cco6.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMRsoUx/NH/Dspm9@devgpu015.cco6.facebook.com>

On Fri, Sep 12, 2025 at 11:55:29AM -0700, Alex Mastro wrote:
> On Mon, Aug 04, 2025 at 04:00:45PM +0300, Leon Romanovsky wrote:
> > +static void dma_ranges_to_p2p_phys(struct vfio_pci_dma_buf *priv,
> > +				   struct vfio_device_feature_dma_buf *dma_buf,
> > +				   struct vfio_region_dma_range *dma_ranges)
> > +{
> > +	struct pci_dev *pdev = priv->vdev->pdev;
> > +	phys_addr_t pci_start;
> > +	int i;
> > +
> > +	pci_start = pci_resource_start(pdev, dma_buf->region_index);
> > +	for (i = 0; i < dma_buf->nr_ranges; i++) {
> > +		priv->phys_vec[i].len = dma_ranges[i].length;
> > +		priv->phys_vec[i].paddr += pci_start + dma_ranges[i].offset;
> 
> Is the intent really to += paddr? I would have expected a plain assignment.

In this specific case, there is no difference, because phys_vec is
initialized to 0, but It needs to be "=" and not "+=".

> 
> > +		priv->size += priv->phys_vec[i].len;
> > +	}
> > +	priv->nr_ranges = dma_buf->nr_ranges;
> > +}
> 
> ...
> 
> > +	priv->phys_vec = kcalloc(get_dma_buf.nr_ranges, sizeof(*priv->phys_vec),
> > +				 GFP_KERNEL);
> > +	if (!priv->phys_vec) {
> > +		ret = -ENOMEM;
> > +		goto err_free_priv;
> > +	}
> > +
> > +	priv->vdev = vdev;
> > +	dma_ranges_to_p2p_phys(priv, &get_dma_buf, dma_ranges);
> 

