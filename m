Return-Path: <kvm+bounces-59100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5504ABABEFA
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 09:58:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5E401926039
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 07:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D79C92D9EDA;
	Tue, 30 Sep 2025 07:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lKEnQkLh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BF67D07D;
	Tue, 30 Sep 2025 07:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759219074; cv=none; b=KvQ6NmYq+awl+IxbDe+G1D31Tix11F6CM/f/vLM/LuA+bvG26tvHs+wLWL49VI1qQWvz0B6ycusrdGM6r4XcJcI9Wyeu9cUt3AniuMSZG2MuRfoan2us11+M9WVgIa572BaYarYTfhyYRv27MH40w3ap/bVOJdJxN+8NaOKlQkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759219074; c=relaxed/simple;
	bh=i3BtTTr7nZIJz33RyVUpfLlfxu4epWOssHy+VLrcscQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNryZTMOREUpenBbTyZBZLuPwgBU+IJWtbAEVHEATQUGRgwQkm5CQrEouCeQvoXNkqTUCZH0zaLHzw22fwBq0MfenYPPn6iVjxfEnO80ddOZ/zm0PyAQhOzc1ni8lQIUQfnsiinHLc6r9RFaQtPlNLHUo2B1sbqD1fHrvnMcNzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lKEnQkLh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879DEC4CEF0;
	Tue, 30 Sep 2025 07:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759219073;
	bh=i3BtTTr7nZIJz33RyVUpfLlfxu4epWOssHy+VLrcscQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lKEnQkLh/7QlrpMJsb5yRxE5AbBpzJMJNRvLELIbdmZqsMudIfJkl5IIjVlvWd45t
	 9CdHZPBwdsFyTXltr7C+E/ikvBD8M3GKILT1uJbM/dqVtkzxxeI95NEbtW/zrd+Ep5
	 UJKj7ByQ5cHM7iDUE5YdLldljkvDneKjj7T0/Jl4BAwLIv6rMPS82rffMeFvtqMlii
	 rJtHqvVmDH+CUonBV/bnseaOumQHFjDS8yuzzqj15+2YNU8QWaz2EfS70aqZHG3yUz
	 GrVG3wKTr88ok96rH2QGVO9OvriGTC+fSkO/DeP0k5odor2Iw88fzatiG+tDDQkt+a
	 OH7f8EY3JlCxQ==
Date: Tue, 30 Sep 2025 10:57:48 +0300
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
Subject: Re: [PATCH v4 07/10] vfio/pci: Add dma-buf export config for MMIO
 regions
Message-ID: <20250930075748.GF324804@unreal>
References: <cover.1759070796.git.leon@kernel.org>
 <b1b44823f93fd9e7fa73dc165141d716cb74fa90.1759070796.git.leon@kernel.org>
 <20250929151740.21f001e3.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929151740.21f001e3.alex.williamson@redhat.com>

On Mon, Sep 29, 2025 at 03:17:40PM -0600, Alex Williamson wrote:
> On Sun, 28 Sep 2025 17:50:17 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Add new kernel config which indicates support for dma-buf export
> > of MMIO regions, which implementation is provided in next patches.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/Kconfig | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > index 2b0172f54665..55ae888bf26a 100644
> > --- a/drivers/vfio/pci/Kconfig
> > +++ b/drivers/vfio/pci/Kconfig
> > @@ -55,6 +55,26 @@ config VFIO_PCI_ZDEV_KVM
> >  
> >  	  To enable s390x KVM vfio-pci extensions, say Y.
> >  
> > +config VFIO_PCI_DMABUF
> > +	bool "VFIO PCI extensions for DMA-BUF"
> > +	depends on VFIO_PCI_CORE
> > +	depends on PCI_P2PDMA && DMA_SHARED_BUFFER
> > +	default y
> > +	help
> > +	  Enable support for VFIO PCI extensions that allow exporting
> > +	  device MMIO regions as DMA-BUFs for peer devices to access via
> > +	  peer-to-peer (P2P) DMA.
> > +
> > +	  This feature enables a VFIO-managed PCI device to export a portion
> > +	  of its MMIO BAR as a DMA-BUF file descriptor, which can be passed
> > +	  to other userspace drivers or kernel subsystems capable of
> > +	  initiating DMA to that region.
> > +
> > +	  Say Y here if you want to enable VFIO DMABUF-based MMIO export
> > +	  support for peer-to-peer DMA use cases.
> > +
> > +	  If unsure, say N.
> > +
> >  source "drivers/vfio/pci/mlx5/Kconfig"
> >  
> >  source "drivers/vfio/pci/hisilicon/Kconfig"
> 
> This is only necessary if we think there's a need to build a kernel with
> P2PDMA and VFIO_PCI, but not VFIO_PCI_DMABUF.  Does that need really
> exist?

It is used to filter build of vfio_pci_dmabuf.c - drivers/vfio/pci/Makefile:
vfio-pci-core-$(CONFIG_VFIO_PCI_DMABUF) += vfio_pci_dmabuf.o

> 
> I also find it unusual to create the Kconfig before adding the
> supporting code.  Maybe this could be popped to the end or rolled into
> the last patch if we decided to keep it.  Thanks,

It is leftover from previous version, I can squash it, but first we need
to decide what to do with pcim_p2pdma_init() call, if it needs to be
guarded or not.

Thanks

> 
> Alex
> 
> 

