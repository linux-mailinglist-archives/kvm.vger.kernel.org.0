Return-Path: <kvm+bounces-43746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B724A95D2C
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 07:01:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1353B1899538
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 05:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 223461AF4C1;
	Tue, 22 Apr 2025 05:01:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6A2EED6;
	Tue, 22 Apr 2025 05:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745298061; cv=none; b=lYVP/2254zc5oA3I+idXj8TwVTBKuiVMQv9tl/7YkGbNMOP2bIcn9gPXk/74PW8RKjo+udyX0Yyyl8Hmj14kuCnGUryT2txgPLoN60NIFua728xtq3yx/X/7JLlpqaTznnN/RMO9yJO+pMzMOdiH+otfSgoen1SvTTrfUHW5qhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745298061; c=relaxed/simple;
	bh=/ELFZKv4e0D7TteJyW9Rpn8e4XtrEsidyb7gbxlwYqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aFHEzZDzPNVr2hmgdvvdnOqGOORVR1np0nRqkQmPpUOpPK2xkiH4P9M7Q64VrqPNJoo45rzC22XmMAJvtdeU2zI9H9Gvq0Ezy/7MEewzougAP63tKLhxQI621BRNOVCUnLO1mtgCtK/HMqSVtOvJl1kN+WAxOLcUzMOeLDHKVwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1414268BFE; Tue, 22 Apr 2025 07:00:51 +0200 (CEST)
Date: Tue, 22 Apr 2025 07:00:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH v8 23/24] nvme-pci: convert to blk_rq_dma_map
Message-ID: <20250422050050.GB28077@lst.de>
References: <cover.1744825142.git.leon@kernel.org> <f06a04098cb14e1051bddec8a7bdebe1c384d983.1744825142.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f06a04098cb14e1051bddec8a7bdebe1c384d983.1744825142.git.leon@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +	dma_len = min_t(u32, length, NVME_CTRL_PAGE_SIZE - (dma_addr & (NVME_CTRL_PAGE_SIZE - 1)));

And overly long line slipped in here during one of the rebases.

> +		/*
> +		 * We are in this mode as IOVA path wasn't taken and DMA length
> +		 * is morethan two sectors. In such case, mapping was perfoormed
> +		 * per-NVME_CTRL_PAGE_SIZE, so unmap accordingly.
> +		 */

Where does this comment come from?  Lots of spelling errors, and I
also don't understand what it is talking about as setors are entirely
irrelevant here.

> +	if (!blk_rq_dma_unmap(req, dev->dev, &iod->dma_state, iod->total_len)) {
> +		if (iod->cmd.common.flags & NVME_CMD_SGL_METABUF)
> +			nvme_free_sgls(dev, req);

With the addition of metadata SGL support this also needs to check
NVME_CMD_SGL_METASEG.

The commit message should also really mentioned that someone
significantly altered the patch for merging with latest upstream,
as I as the nominal author can't recognize some of that code.

> +	unsigned int entries = req->nr_integrity_segments;
>  	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>  
> +	if (!blk_rq_dma_unmap(req, dev->dev, &iod->dma_meta_state,
> +			      iod->total_meta_len)) {
> +		if (entries == 1) {
> +			dma_unmap_page(dev->dev, iod->meta_dma,
> +				       rq_integrity_vec(req).bv_len,
> +				       rq_dma_dir(req));
> +			return;
>  		}
>  	}
>  
> +	dma_pool_free(dev->prp_small_pool, iod->meta_list, iod->meta_dma);

This now doesn't unmap for entries > 1 in the non-IOVA case.


