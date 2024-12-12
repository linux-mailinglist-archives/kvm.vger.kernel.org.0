Return-Path: <kvm+bounces-33565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7BEE9EE18C
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 09:42:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FA9328352E
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 08:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862B120DD7F;
	Thu, 12 Dec 2024 08:42:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BC0259496;
	Thu, 12 Dec 2024 08:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733992942; cv=none; b=WzEfqDL+jqOJ0c4DCYRzxLxizux8yD3KvubU5/EUOMxigE0vKXNMhulPab9oLdRSChWqERGNswFuf30KCapvUf6n6irxeKXPJSqENhMnhb6IOsxQYdTjFZDm1pOz2DyepV3ca8xbSCpBfY1HnKIeadXxyaOxcldgM07CVGDsqrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733992942; c=relaxed/simple;
	bh=qgD99XvHAf4K0f9XtMZ9UgqBA9Ac49qZgXfEM0h8An0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ENG/fo3lNc3I79MiugQ0YMadoSHBgcpCZM4cvrC3aN3kNYZY/F9RXDcSkc52kRbJZ8/okGVuaP+vw4H0c1rd9y5BtGyCg8qQ56iMfVgeJiO5pxLEjWV2013BK3gTUXNk+we5I/D+xNFhd+hM/jgJr7HPqvT73aS/QHCmpzCiIck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B516068D1C; Thu, 12 Dec 2024 09:42:07 +0100 (CET)
Date: Thu, 12 Dec 2024 09:42:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Leon Romanovsky <leonro@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v4 06/18] dma: Provide an interface to allow allocate
 IOVA
Message-ID: <20241212084206.GC9376@lst.de>
References: <cover.1733398913.git.leon@kernel.org> <e562e9a5c5107fae2345150e550e9e850dbe3c0c.1733398913.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e562e9a5c5107fae2345150e550e9e850dbe3c0c.1733398913.git.leon@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

s/dma/dma-mapping/ in the subject.

> function call per API call used in datapath as well as a lot of boilerplate

Please trim commit messages to 73 characters so that they still look good
in git show output.

> +bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
> +		phys_addr_t phys, size_t size)
> +{
> +	memset(state, 0, sizeof(*state));
> +	if (!use_dma_iommu(dev))
> +		return false;
> +	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
> +	    iommu_deferred_attach(dev, iommu_get_domain_for_dev(dev)))
> +		return false;
> +	return iommu_dma_iova_alloc(dev, state, phys, size);
> +}

Now that dma_iova_try_alloc is the only caller of iommu_dma_iova_alloc,
maybe merge the two?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

