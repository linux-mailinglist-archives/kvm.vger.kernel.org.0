Return-Path: <kvm+bounces-63727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D490DC6F7EC
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 16:01:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 106794F652D
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 14:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 363BF36998B;
	Wed, 19 Nov 2025 14:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LcrsNEP/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B544A36920F;
	Wed, 19 Nov 2025 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763563814; cv=none; b=VN221qGwVrPBRfsNY/5qwEer20HC2dHn6Ia3GOfHj+0dyhICrDcGB/Vd0RJdk4Wdu7BERWUnaQB6MJ1Sio+ZUd5a5B5Po6lE5EiuN5iBjnldwzKHXGXpUmK3gAUVcaTmkiOR9xVdbrq3p2vOuVBa2eOF+5P2QSfUzE2dEd6pq+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763563814; c=relaxed/simple;
	bh=pmpKDnH2uKvstiaClRjE20PveVTzDLqcJ5J5KfQb6S8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MAVfccOW+ZCCGPh4odYYL/vbgM+U/AJaDMZTAXFjHKxxHuVXOgx9jspQWf1TxQtCWc72QX74pDJOWbYhOO3CmJ60YFu8Kz8z6JMH0T7GcDc3VFJkuagy2UqZmTbBMrZybX7R6tgVnHNZqQUMyLLbpm5qFlmEPBgygl1Jxkc6+jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LcrsNEP/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3938C4AF10;
	Wed, 19 Nov 2025 14:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763563813;
	bh=pmpKDnH2uKvstiaClRjE20PveVTzDLqcJ5J5KfQb6S8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LcrsNEP/cYavn31vXsC8q8kxUgGv+46Et2MVwTZ8gF77SMbTjkF4nB2wQBaMxNKGU
	 i+/2o+bM64GJu+BLuW6zLkjUKBtHHlYMzXlzM4pjSA67NNU6s8zYkBNJUnTexK17Bp
	 6Lp7os/5KlQKtqIhtjEsdU8wY04+SUaC7u9XgDC4zc+2soLqxFspe2w73PrOMeKxNt
	 AUg0MlRp4Bmlt8WgpdK3oISI5amq2WLKRQY3kuFLVW4pYtnU4Msh1vXWt5/EM/PsUq
	 aa9jiHbd1oaJWuoqBo+qGbB2tVoKiV6ppNZF0P5h52bxUi4hyZv7/jqxC0VtZW9jWG
	 EHx9C2fLK2a/w==
Date: Wed, 19 Nov 2025 16:50:07 +0200
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
Message-ID: <20251119145007.GJ18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119134245.GD18335@unreal>
 <6714dc49-6b5c-4d58-9a43-95bb95873a97@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6714dc49-6b5c-4d58-9a43-95bb95873a97@amd.com>

On Wed, Nov 19, 2025 at 03:11:01PM +0100, Christian König wrote:
> On 11/19/25 14:42, Leon Romanovsky wrote:
> > On Wed, Nov 19, 2025 at 02:16:57PM +0100, Christian König wrote:
> >>
> >>
> >> On 11/11/25 10:57, Leon Romanovsky wrote:
> >>> From: Leon Romanovsky <leonro@nvidia.com>
> >>>
> >>> Add dma_buf_map() and dma_buf_unmap() helpers to convert an array of
> >>> MMIO physical address ranges into scatter-gather tables with proper
> >>> DMA mapping.
> >>>
> >>> These common functions are a starting point and support any PCI
> >>> drivers creating mappings from their BAR's MMIO addresses. VFIO is one
> >>> case, as shortly will be RDMA. We can review existing DRM drivers to
> >>> refactor them separately. We hope this will evolve into routines to
> >>> help common DRM that include mixed CPU and MMIO mappings.
> >>>
> >>> Compared to the dma_map_resource() abuse this implementation handles
> >>> the complicated PCI P2P scenarios properly, especially when an IOMMU
> >>> is enabled:
> >>>
> >>>  - Direct bus address mapping without IOVA allocation for
> >>>    PCI_P2PDMA_MAP_BUS_ADDR, using pci_p2pdma_bus_addr_map(). This
> >>>    happens if the IOMMU is enabled but the PCIe switch ACS flags allow
> >>>    transactions to avoid the host bridge.
> >>>
> >>>    Further, this handles the slightly obscure, case of MMIO with a
> >>>    phys_addr_t that is different from the physical BAR programming
> >>>    (bus offset). The phys_addr_t is converted to a dma_addr_t and
> >>>    accommodates this effect. This enables certain real systems to
> >>>    work, especially on ARM platforms.
> >>>
> >>>  - Mapping through host bridge with IOVA allocation and DMA_ATTR_MMIO
> >>>    attribute for MMIO memory regions (PCI_P2PDMA_MAP_THRU_HOST_BRIDGE).
> >>>    This happens when the IOMMU is enabled and the ACS flags are forcing
> >>>    all traffic to the IOMMU - ie for virtualization systems.
> >>>
> >>>  - Cases where P2P is not supported through the host bridge/CPU. The
> >>>    P2P subsystem is the proper place to detect this and block it.
> >>>
> >>> Helper functions fill_sg_entry() and calc_sg_nents() handle the
> >>> scatter-gather table construction, splitting large regions into
> >>> UINT_MAX-sized chunks to fit within sg->length field limits.
> >>>
> >>> Since the physical address based DMA API forbids use of the CPU list
> >>> of the scatterlist this will produce a mangled scatterlist that has
> >>> a fully zero-length and NULL'd CPU list. The list is 0 length,
> >>> all the struct page pointers are NULL and zero sized. This is stronger
> >>> and more robust than the existing mangle_sg_table() technique. It is
> >>> a future project to migrate DMABUF as a subsystem away from using
> >>> scatterlist for this data structure.
> >>>
> >>> Tested-by: Alex Mastro <amastro@fb.com>
> >>> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> >>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >>> ---
> >>>  drivers/dma-buf/dma-buf.c | 235 ++++++++++++++++++++++++++++++++++++++++++++++
> >>>  include/linux/dma-buf.h   |  18 ++++
> >>>  2 files changed, 253 insertions(+)
> >>>
> >>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> >>> index 2bcf9ceca997..cb55dff1dad5 100644
> >>> --- a/drivers/dma-buf/dma-buf.c
> >>> +++ b/drivers/dma-buf/dma-buf.c
> >>> @@ -1254,6 +1254,241 @@ void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
> >>>  }
> >>>  EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment_unlocked, "DMA_BUF");
> >>>  
> >>> +static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
> >>> +					 dma_addr_t addr)
> >>> +{
> >>> +	unsigned int len, nents;
> >>> +	int i;
> >>> +
> >>> +	nents = DIV_ROUND_UP(length, UINT_MAX);
> >>> +	for (i = 0; i < nents; i++) {
> >>> +		len = min_t(size_t, length, UINT_MAX);
> >>> +		length -= len;
> >>> +		/*
> >>> +		 * DMABUF abuses scatterlist to create a scatterlist
> >>> +		 * that does not have any CPU list, only the DMA list.
> >>> +		 * Always set the page related values to NULL to ensure
> >>> +		 * importers can't use it. The phys_addr based DMA API
> >>> +		 * does not require the CPU list for mapping or unmapping.
> >>> +		 */
> >>> +		sg_set_page(sgl, NULL, 0, 0);
> >>> +		sg_dma_address(sgl) = addr + i * UINT_MAX;
> >>> +		sg_dma_len(sgl) = len;
> >>> +		sgl = sg_next(sgl);
> >>> +	}
> >>> +
> >>> +	return sgl;
> >>> +}
> >>> +
> >>> +static unsigned int calc_sg_nents(struct dma_iova_state *state,
> >>> +				  struct dma_buf_phys_vec *phys_vec,
> >>> +				  size_t nr_ranges, size_t size)
> >>> +{
> >>> +	unsigned int nents = 0;
> >>> +	size_t i;
> >>> +
> >>> +	if (!state || !dma_use_iova(state)) {
> >>> +		for (i = 0; i < nr_ranges; i++)
> >>> +			nents += DIV_ROUND_UP(phys_vec[i].len, UINT_MAX);
> >>> +	} else {
> >>> +		/*
> >>> +		 * In IOVA case, there is only one SG entry which spans
> >>> +		 * for whole IOVA address space, but we need to make sure
> >>> +		 * that it fits sg->length, maybe we need more.
> >>> +		 */
> >>> +		nents = DIV_ROUND_UP(size, UINT_MAX);
> >>> +	}
> >>> +
> >>> +	return nents;
> >>> +}
> >>> +
> >>> +/**
> >>> + * struct dma_buf_dma - holds DMA mapping information
> >>> + * @sgt:    Scatter-gather table
> >>> + * @state:  DMA IOVA state relevant in IOMMU-based DMA
> >>> + * @size:   Total size of DMA transfer
> >>> + */
> >>> +struct dma_buf_dma {
> >>> +	struct sg_table sgt;
> >>> +	struct dma_iova_state *state;
> >>> +	size_t size;
> >>> +};
> >>> +
> >>> +/**
> >>> + * dma_buf_map - Returns the scatterlist table of the attachment from arrays
> >>> + * of physical vectors. This funciton is intended for MMIO memory only.
> >>> + * @attach:	[in]	attachment whose scatterlist is to be returned
> >>> + * @provider:	[in]	p2pdma provider
> >>> + * @phys_vec:	[in]	array of physical vectors
> >>> + * @nr_ranges:	[in]	number of entries in phys_vec array
> >>> + * @size:	[in]	total size of phys_vec
> >>> + * @dir:	[in]	direction of DMA transfer
> >>> + *
> >>> + * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
> >>> + * on error. May return -EINTR if it is interrupted by a signal.
> >>> + *
> >>> + * On success, the DMA addresses and lengths in the returned scatterlist are
> >>> + * PAGE_SIZE aligned.
> >>> + *
> >>> + * A mapping must be unmapped by using dma_buf_unmap().
> >>> + */
> >>> +struct sg_table *dma_buf_map(struct dma_buf_attachment *attach,
> >>
> >> That is clearly not a good name for this function. We already have overloaded the term *mapping* with something completely different.
> > 
> > This function performs DMA mapping, so what name do you suggest instead of dma_buf_map()?
> 
> Something like dma_buf_phys_vec_to_sg_table(). I'm not good at naming either.

Can I call it simply dma_buf_mapping() as I plan to put that function in dma_buf_mapping.c
file per-your request.

Regarding SG, the long term plan is to remove SG table completely, so at
least external users of DMABUF shouldn't be exposed to internal implementation
details (SG table).

Thanks

