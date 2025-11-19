Return-Path: <kvm+bounces-63716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BE5AC6EFD1
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 14:45:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 83887241FF
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 13:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52FA9365A01;
	Wed, 19 Nov 2025 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LZPWhNTp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B66235F8B5;
	Wed, 19 Nov 2025 13:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763559773; cv=none; b=KZlpzx5ui6FXh7WtSA1bUxX0K8fddmNpcHHa9MPCYOh6ZJ/iZzU4PnCnP1BEyQ//s8Qx0uuGVGchNTu6MXPeyHa++8enWcaSmDvXaPu1G4nH16N1o1d4LdRXDnJySFRJx7QcCGm7ZjZj8DwrL5kVGqKTfGhJaAYPuSL91/Smaug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763559773; c=relaxed/simple;
	bh=P/9pmsmDZmkNlTyjbeOkKXUp9EgbKAdqcxRg8cTn9uY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C31gd/5PwFYCFvlCizi2jRfegSPp5tTfQr4E9mL9R4sLYDY8DWy8UlC1TTDnbk4SeHoN+EGjZndaOmV2ta3jXQEeF6V/mkOqCpc/Pb6czac2sjTYGgr9zSxRTbQ1YJRzdO+zZupcxElCDLm2HQEgNGvP89ILpceEDWuNtjMzQsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LZPWhNTp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0206DC4AF10;
	Wed, 19 Nov 2025 13:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763559772;
	bh=P/9pmsmDZmkNlTyjbeOkKXUp9EgbKAdqcxRg8cTn9uY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LZPWhNTptIctgTzaFpTd1ekG9qrGfohBqAXAHzzaU/HV67myANBywQIS/3x/phUjm
	 DYDIhDYRi2Ivwc7B5q7hVUqiI/vIfjCdDNCVRado+aVdcD0tmv7IO4i0D/u40bFrWT
	 CjvOkJ2Z7lepRX0ifqfXVjCrMPqnStFWbLVY19g24sOYIuWTbQo0y1QAm4DprRGO1i
	 aboRJ2HuKLHhg3MYwK/LN0Tzpuf27/kObDzlA9GsZ9k+CZgy9xrXEQJk0bKopSx1Dd
	 Bv28ygxN1NRHIbPAah5Y1t2rJIGCMFf0WAQN8PfHquHssFUz8z2mldqA3t1Hi8XD3S
	 jDXI73w0cwhrg==
Date: Wed, 19 Nov 2025 15:42:45 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
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
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
Message-ID: <20251119134245.GD18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>

On Wed, Nov 19, 2025 at 02:16:57PM +0100, Christian König wrote:
> 
> 
> On 11/11/25 10:57, Leon Romanovsky wrote:
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
> > ---
> >  drivers/dma-buf/dma-buf.c | 235 ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/dma-buf.h   |  18 ++++
> >  2 files changed, 253 insertions(+)
> > 
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index 2bcf9ceca997..cb55dff1dad5 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -1254,6 +1254,241 @@ void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
> >  }
> >  EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment_unlocked, "DMA_BUF");
> >  
> > +static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
> > +					 dma_addr_t addr)
> > +{
> > +	unsigned int len, nents;
> > +	int i;
> > +
> > +	nents = DIV_ROUND_UP(length, UINT_MAX);
> > +	for (i = 0; i < nents; i++) {
> > +		len = min_t(size_t, length, UINT_MAX);
> > +		length -= len;
> > +		/*
> > +		 * DMABUF abuses scatterlist to create a scatterlist
> > +		 * that does not have any CPU list, only the DMA list.
> > +		 * Always set the page related values to NULL to ensure
> > +		 * importers can't use it. The phys_addr based DMA API
> > +		 * does not require the CPU list for mapping or unmapping.
> > +		 */
> > +		sg_set_page(sgl, NULL, 0, 0);
> > +		sg_dma_address(sgl) = addr + i * UINT_MAX;
> > +		sg_dma_len(sgl) = len;
> > +		sgl = sg_next(sgl);
> > +	}
> > +
> > +	return sgl;
> > +}
> > +
> > +static unsigned int calc_sg_nents(struct dma_iova_state *state,
> > +				  struct dma_buf_phys_vec *phys_vec,
> > +				  size_t nr_ranges, size_t size)
> > +{
> > +	unsigned int nents = 0;
> > +	size_t i;
> > +
> > +	if (!state || !dma_use_iova(state)) {
> > +		for (i = 0; i < nr_ranges; i++)
> > +			nents += DIV_ROUND_UP(phys_vec[i].len, UINT_MAX);
> > +	} else {
> > +		/*
> > +		 * In IOVA case, there is only one SG entry which spans
> > +		 * for whole IOVA address space, but we need to make sure
> > +		 * that it fits sg->length, maybe we need more.
> > +		 */
> > +		nents = DIV_ROUND_UP(size, UINT_MAX);
> > +	}
> > +
> > +	return nents;
> > +}
> > +
> > +/**
> > + * struct dma_buf_dma - holds DMA mapping information
> > + * @sgt:    Scatter-gather table
> > + * @state:  DMA IOVA state relevant in IOMMU-based DMA
> > + * @size:   Total size of DMA transfer
> > + */
> > +struct dma_buf_dma {
> > +	struct sg_table sgt;
> > +	struct dma_iova_state *state;
> > +	size_t size;
> > +};
> > +
> > +/**
> > + * dma_buf_map - Returns the scatterlist table of the attachment from arrays
> > + * of physical vectors. This funciton is intended for MMIO memory only.
> > + * @attach:	[in]	attachment whose scatterlist is to be returned
> > + * @provider:	[in]	p2pdma provider
> > + * @phys_vec:	[in]	array of physical vectors
> > + * @nr_ranges:	[in]	number of entries in phys_vec array
> > + * @size:	[in]	total size of phys_vec
> > + * @dir:	[in]	direction of DMA transfer
> > + *
> > + * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
> > + * on error. May return -EINTR if it is interrupted by a signal.
> > + *
> > + * On success, the DMA addresses and lengths in the returned scatterlist are
> > + * PAGE_SIZE aligned.
> > + *
> > + * A mapping must be unmapped by using dma_buf_unmap().
> > + */
> > +struct sg_table *dma_buf_map(struct dma_buf_attachment *attach,
> 
> That is clearly not a good name for this function. We already have overloaded the term *mapping* with something completely different.

This function performs DMA mapping, so what name do you suggest instead of dma_buf_map()?

> 
> > +			     struct p2pdma_provider *provider,
> > +			     struct dma_buf_phys_vec *phys_vec,
> > +			     size_t nr_ranges, size_t size,
> > +			     enum dma_data_direction dir)
> > +{
> > +	unsigned int nents, mapped_len = 0;
> > +	struct dma_buf_dma *dma;
> > +	struct scatterlist *sgl;
> > +	dma_addr_t addr;
> > +	size_t i;
> > +	int ret;
> > +
> > +	dma_resv_assert_held(attach->dmabuf->resv);
> > +
> > +	if (WARN_ON(!attach || !attach->dmabuf || !provider))
> > +		/* This function is supposed to work on MMIO memory only */
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	dma = kzalloc(sizeof(*dma), GFP_KERNEL);
> > +	if (!dma)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	switch (pci_p2pdma_map_type(provider, attach->dev)) {
> > +	case PCI_P2PDMA_MAP_BUS_ADDR:
> > +		/*
> > +		 * There is no need in IOVA at all for this flow.
> > +		 */
> > +		break;
> > +	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> > +		dma->state = kzalloc(sizeof(*dma->state), GFP_KERNEL);
> > +		if (!dma->state) {
> > +			ret = -ENOMEM;
> > +			goto err_free_dma;
> > +		}
> > +
> > +		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
> 
> Oh, that is a clear no-go for the core DMA-buf code.
> 
> It's intentionally up to the exporter how to create the DMA addresses the importer can work with.

I didn't fully understand the email either. The importer needs to
configure DMA and it supports only MMIO addresses. Exporter controls it
by asking for peer2peer.

Thanks

