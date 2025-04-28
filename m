Return-Path: <kvm+bounces-44588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 75739A9F61F
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 18:47:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84D741890AE1
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 16:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 935A327F747;
	Mon, 28 Apr 2025 16:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tlk2eBun"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942BD7082D;
	Mon, 28 Apr 2025 16:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745858784; cv=none; b=bzY94I3H4nk6RVYMGYY1JRmHHU/ZWiabr4x+PL/UoWk9MYMs7o3tICFRTgPuT8ejpZaFErYVLm2Ui8K+3duTrAvopinNn2mf+GFETskQPZw45l2GoM1+kx6Kom60z3kV1b0dLijVyqt9+2Kvbks5GtP2sn1hklTCCDvMz6M2Vtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745858784; c=relaxed/simple;
	bh=Z8PCmnJ0yV8qERDqeQfISVPvJ3tqJw2Q7aIBdlyPo/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ae2QHgO7A/bt1204w33xdWN12kgigiEFQJlJnh3M5hxE4LU7C4sNygoYDu4IThr2JEhZ56PJ4AtLGJ1RHj549wAQ7zjtiOD9U/zzmYdahNJr4kWuaN8hMCSXTHpyzZ858GU25uc8kR6r7ESHkfpJj+DOtUNTq/Pe3ycdQt1B52s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tlk2eBun; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90AEC4CEEC;
	Mon, 28 Apr 2025 16:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745858784;
	bh=Z8PCmnJ0yV8qERDqeQfISVPvJ3tqJw2Q7aIBdlyPo/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tlk2eBunYES27PROXmHIGQe3zmMP6HvdTE2sKVLCxFcGCmH8DHxdGjHqd3wobjohg
	 VwJfw0ItrR32xKrcgdCW8TRpmdlk+DeJY1swcEr9VbaiBCu3yyJuag7MxpY9rcCj1j
	 8nTXrf6GECR+mLe+QAKunFydd77qXJZBtfWsqaoubYbzZfTupDTo+1dZCG4DPhnIKw
	 GE9ORFXi++TgAbviRRmsybWuVr08WLZvPsjcAv5o6bRpncDLzkKDP2jiGKorIc8UjF
	 OQmxqQxbREQlcM8XfaIRqR6lFGfo4bo5dy+E+StVFWQQTe6kZ8U9u+SSstYkVmXSTR
	 4chXnE6KS/Cag==
Date: Mon, 28 Apr 2025 10:46:19 -0600
From: Keith Busch <kbusch@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>,
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
	Nitesh Shetty <nj.shetty@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH v10 23/24] nvme-pci: convert to blk_rq_dma_map
Message-ID: <aA-w20gOKus5hyAV@kbusch-mbp.dhcp.thefacebook.com>
References: <cover.1745831017.git.leon@kernel.org>
 <007e00134d49160d5edab94a72c35b7b91429b09.1745831017.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007e00134d49160d5edab94a72c35b7b91429b09.1745831017.git.leon@kernel.org>

On Mon, Apr 28, 2025 at 12:22:29PM +0300, Leon Romanovsky wrote:
> +	do {
> +		if (WARN_ON_ONCE(mapped == entries)) {
> +			iter.status = BLK_STS_IOERR;
> +			break;
> +		}
> +		nvme_pci_sgl_set_data(&sg_list[mapped++], &iter);

I think this should say "++mapped" so that the data blocks start at
index 1 (continued below...)

> +		iod->total_len += iter.len;
> +	} while (blk_rq_dma_map_iter_next(req, dev->dev, &iod->dma_meta_state,
> +				 &iter));
>  
> -out_unmap_sg:
> -	dma_unmap_sgtable(dev->dev, &iod->meta_sgt, rq_dma_dir(req), 0);
> -out_free_sg:
> -	mempool_free(iod->meta_sgt.sgl, dev->iod_meta_mempool);
> -	return BLK_STS_RESOURCE;
> +	nvme_pci_sgl_set_seg(sg_list, sgl_dma, mapped);

because this here is setting sg_list index 0 to be the segment
descriptor.

And you also need to increment sgl_dma to point to the element after
sg_list, otherwise it's pointing right back to itself, creating a looped
list.

> +	if (unlikely(iter.status))
> +		nvme_unmap_metadata(dev, req);
> +	return iter.status;
>  }

