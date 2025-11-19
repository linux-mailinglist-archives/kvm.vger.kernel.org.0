Return-Path: <kvm+bounces-63719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A56EC6F0C2
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 14:52:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 3FD8A2F00E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 13:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 139C8364054;
	Wed, 19 Nov 2025 13:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KA20TCoH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C7A35FF6C;
	Wed, 19 Nov 2025 13:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763560122; cv=none; b=VD9p+uybpNwr/pZyTpcduXDajHXuEUcXq98C0/fGgCn7kCT9uEKyVnCexVpq+DKpr3hiQsGDic8JYH2mlqIk277SyG946o4FtzwHfdUYPjGmhsepTAM3bm+B/N8ippfJ4FNM9YWayTgnhSTEONQGQeM58lgC10cN3jDQwKCydVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763560122; c=relaxed/simple;
	bh=WBVxdPHFlyOgnD3YarukkHOdXbptm0KrfxkS3OxiyOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fefCQ6x2ExQHqX9kN9w2TX9PZd57SEWWMGkIJrvlO9ZRnYHUY4aYJKRHb0yF2vI6m7+Zny9ibO4YzX6Tm6ih2lWr24ZG7KgM8qw7DU3+lsj80OSekR+IFX+78qmEnzu5ZW9fsu5UMk2HE3hX/wXTt42D34iAkP1trn3qXu1/pgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KA20TCoH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F90C2BCB3;
	Wed, 19 Nov 2025 13:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763560121;
	bh=WBVxdPHFlyOgnD3YarukkHOdXbptm0KrfxkS3OxiyOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KA20TCoHh4xBpJsET+frUdvFAC1/PD10QEHBCIMaao0WAnseVamH90obusp+eQ5o2
	 JrhR8HX77yzaqJbG7RbbqAQs3awsq4Yvi7P4lQEZ99DLZaMLoKH1/O5e8/LLveXrkv
	 HCKoHyda54qc27+KsHvuXB6+0wPcCgAO6rsNtdaEMFdpPZjPGtqLRxBnqe3Arlb9EG
	 osGef8+spXexQcAOPEgMRnoYG//AXXDg2MNWYqsnZOs0wHsYLRrmAJ/9zE8Pdo+dbS
	 CMLK4jt8qhrjL3QY8uNgMZwKArml4umHyJINrVhyQzJ9qdxF59lBOeH32HAdcfhxrX
	 lBCpSzaidWhXw==
Date: Wed, 19 Nov 2025 15:48:36 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
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
Message-ID: <20251119134836.GF18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119132511.GK17968@ziepe.ca>
 <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>

On Wed, Nov 19, 2025 at 02:42:18PM +0100, Christian König wrote:
> On 11/19/25 14:25, Jason Gunthorpe wrote:
> > On Wed, Nov 19, 2025 at 02:16:57PM +0100, Christian König wrote:
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
> >>
> >>> +			     struct p2pdma_provider *provider,
> >>> +			     struct dma_buf_phys_vec *phys_vec,
> >>> +			     size_t nr_ranges, size_t size,
> >>> +			     enum dma_data_direction dir)
> >>> +{
> >>> +	unsigned int nents, mapped_len = 0;
> >>> +	struct dma_buf_dma *dma;
> >>> +	struct scatterlist *sgl;
> >>> +	dma_addr_t addr;
> >>> +	size_t i;
> >>> +	int ret;
> >>> +
> >>> +	dma_resv_assert_held(attach->dmabuf->resv);
> >>> +
> >>> +	if (WARN_ON(!attach || !attach->dmabuf || !provider))
> >>> +		/* This function is supposed to work on MMIO memory only */
> >>> +		return ERR_PTR(-EINVAL);
> >>> +
> >>> +	dma = kzalloc(sizeof(*dma), GFP_KERNEL);
> >>> +	if (!dma)
> >>> +		return ERR_PTR(-ENOMEM);
> >>> +
> >>> +	switch (pci_p2pdma_map_type(provider, attach->dev)) {
> >>> +	case PCI_P2PDMA_MAP_BUS_ADDR:
> >>> +		/*
> >>> +		 * There is no need in IOVA at all for this flow.
> >>> +		 */
> >>> +		break;
> >>> +	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> >>> +		dma->state = kzalloc(sizeof(*dma->state), GFP_KERNEL);
> >>> +		if (!dma->state) {
> >>> +			ret = -ENOMEM;
> >>> +			goto err_free_dma;
> >>> +		}
> >>> +
> >>> +		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
> >>
> >> Oh, that is a clear no-go for the core DMA-buf code.
> >>
> >> It's intentionally up to the exporter how to create the DMA
> >> addresses the importer can work with.
> > 
> > I can't fully understand this remark?
> 
> The exporter should be able to decide if it actually wants to use P2P when the transfer has to go through the host bridge (e.g. when IOMMU/bridge routing bits are enabled).
> 
> Thinking more about it exporters can now probably call pci_p2pdma_map_type(provider, attach->dev) before calling this function so that is probably ok.
> 
> >> We could add something like a dma_buf_sg_helper.c or similar and put it in there.
> > 
> > Yes, the intention is this function is an "exporter helper" that an
> > exporter can call if it wants to help generate the scatterlist.
> > 
> > So your "no-go" is just about what file it is in, not anything about
> > how it works?
> 
> Yes, exactly that. Just move it into a separate file somewhere and it's probably good to go as far as I can see.
> 
> But only take that as Acked-by, I would need at least a day (or week) of free time to wrap my head around all the technical details again. And that is something I won't have before January or even later.

If it helps, we can meet at LPC. Jason and/or I will be happy to assist.

Thanks

> 
> Regards,
> Christian.
> 
> > 
> > Thanks,
> > Jason
> 

