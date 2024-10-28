Return-Path: <kvm+bounces-29895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC3DA9B3C6E
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 21:59:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 37594B21C37
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 20:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE681E1326;
	Mon, 28 Oct 2024 20:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YHWCjZnS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE311DFE1C;
	Mon, 28 Oct 2024 20:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730149145; cv=none; b=IwWKSDkJkiHsCLPQpDeOGR5tFABIVQ2O7tZHohbWqIKczY8nI/uFVF7bryeYno2+Z9uGY+UwUPcA1Pf7Kz5icTs+Y/TrpmyTJxloHYiEO+cE0f1v7US7CiIHeXxo2wzh8gSrfGjwlCgRxtelk5y7BUbRrjg8oUr4wU/MZp5B8Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730149145; c=relaxed/simple;
	bh=XDchRQtmy6pHQo4VldmyUQn5KpIMSBE9FuRx/IQ/fLc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ba/i5GJSzfWbnG6cDm5hqDqK02WJ9aIR73MA4UJvgfoayCXD69BlugrdoOGNP71ujMbWyTRPGgFsT3/+TlQAjK9+7cwoQl8Dss5CEmS5T7fVf7F4vg9td8FxKUHSSqYzblQd/LHdaVFTOUCColqZ78UojIU0LzkvuaaByoNlj+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YHWCjZnS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8324C4CEC3;
	Mon, 28 Oct 2024 20:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730149144;
	bh=XDchRQtmy6pHQo4VldmyUQn5KpIMSBE9FuRx/IQ/fLc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=YHWCjZnSvGD0FLXm38frIZRba2sQQ98rHEmaoqo7+IGWHJUxibwDnNsBZgESkMQf2
	 TsIZgg66kDAZi3cQ/raC0xLCHxFt/n+Q+GfpSPikoPYWogMwVVkT2YGGo6r+mvlpQs
	 LYcYZiWraEirilGEQRB7r1dSqxIlLl6PnIyzBEG69k5H5ZL/4V51yCX9ue/AQ9hoao
	 YtQPx9n4wU6TLKUu3BMoGWW4nbSLG6WcdHPvYzg+727B9k+tQFNcmm7b2B+OIclaEr
	 WoCdB/gjnaxlHYJSzABbNThj3fTHRWtRg5gmc802RNwzAtTGyuBAMLTzhdJzsWVOka
	 YksEeTIOFMwbA==
Date: Mon, 28 Oct 2024 15:59:02 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 01/18] PCI/P2PDMA: refactor the p2pdma mapping helpers
Message-ID: <20241028205902.GA1114413@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4d93ca45f7ad09105a1cf347e6b6d6b6fb7e303.1730037276.git.leon@kernel.org>

Prefer subject capitalization in drivers/pci:

  PCI/P2PDMA: Refactor ...

On Sun, Oct 27, 2024 at 04:21:01PM +0200, Leon Romanovsky wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> The current scheme with a single helper to determine the P2P status
> and map a scatterlist segment force users to always use the map_sg
> helper to DMA map, which we're trying to get away from because they
> are very cache inefficient.
> ...

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

A couple minor nits below.

> @@ -1412,28 +1411,29 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
>  		size_t s_length = s->length;
>  		size_t pad_len = (mask - iova_len + 1) & mask;
>  
> -		if (is_pci_p2pdma_page(sg_page(s))) {
> -			map = pci_p2pdma_map_segment(&p2pdma_state, dev, s);
> -			switch (map) {
> -			case PCI_P2PDMA_MAP_BUS_ADDR:
> -				/*
> -				 * iommu_map_sg() will skip this segment as
> -				 * it is marked as a bus address,
> -				 * __finalise_sg() will copy the dma address
> -				 * into the output segment.
> -				 */
> -				continue;
> -			case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> -				/*
> -				 * Mapping through host bridge should be
> -				 * mapped with regular IOVAs, thus we
> -				 * do nothing here and continue below.
> -				 */
> -				break;
> -			default:
> -				ret = -EREMOTEIO;
> -				goto out_restore_sg;
> -			}
> +		switch (pci_p2pdma_state(&p2pdma_state, dev, sg_page(s))) {
> +		case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> +			/*
> +			 * Mapping through host bridge should be mapped with
> +			 * regular IOVAs, thus we do nothing here and continue
> +			 * below.
> +			 */

I guess this is technically not a fall-through to the next case
because there's no executable code here, but since the comment
separates these two cases, I would find it easier to read if you
included the break here explicitly.

> +		case PCI_P2PDMA_MAP_NONE:
> +			break;

> +void __pci_p2pdma_update_state(struct pci_p2pdma_map_state *state,
> +		struct device *dev, struct page *page);
> +
> +/**
> + * pci_p2pdma_state - check the P2P transfer state of a page
> + * @state: 	P2P state structure

Checkpatch complains about space before tab here.

> + * pci_p2pdma_bus_addr_map - map a PCI_P2PDMA_MAP_BUS_ADDR P2P transfer
> + * @state: 	P2P state structure

And here.

> @@ -462,34 +462,32 @@ int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
>  		enum dma_data_direction dir, unsigned long attrs)
>  {
>  	struct pci_p2pdma_map_state p2pdma_state = {};
> -	enum pci_p2pdma_map_type map;
>  	struct scatterlist *sg;
>  	int i, ret;
>  
>  	for_each_sg(sgl, sg, nents, i) {
> -		if (is_pci_p2pdma_page(sg_page(sg))) {
> -			map = pci_p2pdma_map_segment(&p2pdma_state, dev, sg);
> -			switch (map) {
> -			case PCI_P2PDMA_MAP_BUS_ADDR:
> -				continue;
> -			case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> -				/*
> -				 * Any P2P mapping that traverses the PCI
> -				 * host bridge must be mapped with CPU physical
> -				 * address and not PCI bus addresses. This is
> -				 * done with dma_direct_map_page() below.
> -				 */
> -				break;
> -			default:
> -				ret = -EREMOTEIO;
> +		switch (pci_p2pdma_state(&p2pdma_state, dev, sg_page(sg))) {
> +		case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> +			/*
> +			 * Any P2P mapping that traverses the PCI host bridge
> +			 * must be mapped with CPU physical address and not PCI
> +			 * bus addresses.
> +			 */

Same fall-through comment.

> +		case PCI_P2PDMA_MAP_NONE:
> +			sg->dma_address = dma_direct_map_page(dev, sg_page(sg),
> +					sg->offset, sg->length, dir, attrs);
> +			if (sg->dma_address == DMA_MAPPING_ERROR) {
> +				ret = -EIO;
>  				goto out_unmap;
>  			}
> -		}

