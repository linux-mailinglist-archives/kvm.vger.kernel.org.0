Return-Path: <kvm+bounces-63712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BB36BC6F082
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 14:49:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8A6124FBA41
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 13:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408363587DA;
	Wed, 19 Nov 2025 13:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fugn6SXe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DD61E5B9E;
	Wed, 19 Nov 2025 13:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763559174; cv=none; b=OkVnmTniGIWFN3Ln5g+JfqcN2878Ge6TnnlUX8h8vjh4vfl9TL/G4+Tn13yhmBUkUidwI5RNTaDgDWj46o7ng1yrwEg2+CnYa7s8JOgNTMvaQVKYh2u8kNiblEmnt/7e+KeGKCd5MaxYVFKFzHeHpz5SeNK4H8D6k6AHtxHHUm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763559174; c=relaxed/simple;
	bh=xSg1qo4eywYavdQS8dmG/E50BvlEVMWFbME3wXOYqAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IP5bqs0t2HYkPN7A7/gbi5uQKThfe0rV4WgHUWUSKhfxLPqLQpqGUdFhth9JXAdm5uzmmWt/4cZ8scHzzIw5ltGD8C3wJ1y2KM2JyKrteyDrylItMrz1XM7lfEDLMFJGwHO5titB3X8fK3c7KPDon1GInNZXrYe3Q34XhcB82H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fugn6SXe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F49C116D0;
	Wed, 19 Nov 2025 13:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763559173;
	bh=xSg1qo4eywYavdQS8dmG/E50BvlEVMWFbME3wXOYqAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fugn6SXe3G4/lghJftzverkKri5Zm6llziGFELpjSdO5rFXibaH9e3wtAHC8eYq0A
	 UHDxjWoty5cjHUhouVKrIOhuKM9z7mexk/F5r4cf7BxkwPnbErmXBmxpeleMMNnVNp
	 Zn2bBiJcVDshc8OQL4VrNwTENPVUYBtgD3PYJarKK+WMN7WiwzSdhiNC8St3ekVG9T
	 MppaNiyGtAujQGVj62oii6C8Mlzol4XrwMJkNVyNsz6rtOtPKYXJ1wwf8GpAxLr+PZ
	 rp7GRTmkkKYO75+nzC3UJyt0A8Qyuha45HbfXhXuCmDdddQ4ykA2clId10wnbfNPl0
	 6tfxCzsiPdxfQ==
Date: Wed, 19 Nov 2025 15:32:48 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>
Subject: Re: [PATCH v8 06/11] dma-buf: provide phys_vec to scatter-gather
 mapping routine
Message-ID: <20251119133248.GC18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <aR0J8zHtfe/j4ajU@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR0J8zHtfe/j4ajU@Asurada-Nvidia>

On Tue, Nov 18, 2025 at 04:06:11PM -0800, Nicolin Chen wrote:
> On Tue, Nov 11, 2025 at 11:57:48AM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Add dma_buf_map() and dma_buf_unmap() helpers to convert an array of
> > MMIO physical address ranges into scatter-gather tables with proper
> > DMA mapping.
> > 
> > These common functions are a starting point and support any PCI
> > drivers creating mappings from their BAR's MMIO addresses. VFIO is one
> > case, as shortly will be RDMA. We can review existing DRM drivers to
> > refactor them separately. We hope this will evolve into routines to
> > help common DRM that include mixed CPU and MMIO mappings.
> > 
> > Compared to the dma_map_resource() abuse this implementation handles
> > the complicated PCI P2P scenarios properly, especially when an IOMMU
> > is enabled:
> > 
> >  - Direct bus address mapping without IOVA allocation for
> >    PCI_P2PDMA_MAP_BUS_ADDR, using pci_p2pdma_bus_addr_map(). This
> >    happens if the IOMMU is enabled but the PCIe switch ACS flags allow
> >    transactions to avoid the host bridge.
> > 
> >    Further, this handles the slightly obscure, case of MMIO with a
> >    phys_addr_t that is different from the physical BAR programming
> >    (bus offset). The phys_addr_t is converted to a dma_addr_t and
> >    accommodates this effect. This enables certain real systems to
> >    work, especially on ARM platforms.
> > 
> >  - Mapping through host bridge with IOVA allocation and DMA_ATTR_MMIO
> >    attribute for MMIO memory regions (PCI_P2PDMA_MAP_THRU_HOST_BRIDGE).
> >    This happens when the IOMMU is enabled and the ACS flags are forcing
> >    all traffic to the IOMMU - ie for virtualization systems.
> > 
> >  - Cases where P2P is not supported through the host bridge/CPU. The
> >    P2P subsystem is the proper place to detect this and block it.
> > 
> > Helper functions fill_sg_entry() and calc_sg_nents() handle the
> > scatter-gather table construction, splitting large regions into
> > UINT_MAX-sized chunks to fit within sg->length field limits.
> > 
> > Since the physical address based DMA API forbids use of the CPU list
> > of the scatterlist this will produce a mangled scatterlist that has
> > a fully zero-length and NULL'd CPU list. The list is 0 length,
> > all the struct page pointers are NULL and zero sized. This is stronger
> > and more robust than the existing mangle_sg_table() technique. It is
> > a future project to migrate DMABUF as a subsystem away from using
> > scatterlist for this data structure.
> > 
> > Tested-by: Alex Mastro <amastro@fb.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> 
> With a nit:
> 
> > +err_unmap_dma:
> > +	if (!i || !dma->state) {
> > +		; /* Do nothing */
> > +	} else if (dma_use_iova(dma->state)) {
> > +		dma_iova_destroy(attach->dev, dma->state, mapped_len, dir,
> > +				 DMA_ATTR_MMIO);
> > +	} else {
> > +		for_each_sgtable_dma_sg(&dma->sgt, sgl, i)
> > +			dma_unmap_phys(attach->dev, sg_dma_address(sgl),
> > +				       sg_dma_len(sgl), dir, DMA_ATTR_MMIO);
> 
> Would it be safer to skip dma_unmap_phys() the range [i, nents)?

[i, nents) is not supposed to be in SG list which we are iterating.

Thanks

