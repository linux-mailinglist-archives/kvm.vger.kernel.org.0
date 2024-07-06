Return-Path: <kvm+bounces-21053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD40929138
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 08:08:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28CA6283BEA
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 06:08:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3B81C69D;
	Sat,  6 Jul 2024 06:08:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34D81BF3A;
	Sat,  6 Jul 2024 06:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720246106; cv=none; b=WkIdPJrGJ2gyuNFmYhdl2XA5seje8ktjVYT7KE+VR9WXUUROLcRLCN75emgJUXz96FurkelVrJK83WWn0S81MtW4JxOGIKJ1UwSrt7PejYSvjV6ieS8LzlEhg3jbVAZE49YjgcKYFbrTOJxtlrgUpLTlp31ynuKNXbNIX+dRG+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720246106; c=relaxed/simple;
	bh=FJjvC1mF0q7aqcVpwtDwuOCzqnQ0w4rL5HfWLZFRs+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BEb/+bNpw4k0/OlOTSoSmH0xT3iME0ny60bKPxXQadgFevqb/A3XV5yALGDx5K65jQf0aw938Bf7wHHolC3OYGGwbDurPcP1pOCw/zGGJb5UmEIo41xAnshS02PvKEobCtL5T37lRsc2Tn9X4klVVrfdrHsP0DttZdQzfM/nmAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1FCD868D0E; Sat,  6 Jul 2024 08:08:19 +0200 (CEST)
Date: Sat, 6 Jul 2024 08:08:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>,
	Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Keith Busch <kbusch@kernel.org>, "Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 18/18] nvme-pci: use new dma API
Message-ID: <20240706060818.GA13470@lst.de>
References: <cover.1719909395.git.leon@kernel.org> <47eb0510b0a6aa52d9f5665d75fa7093dd6af53f.1719909395.git.leon@kernel.org> <249ec228-4ffd-4121-bd51-f4a19275fee1@arm.com> <20240704171602.GE95824@unreal> <20240705055806.GA11885@lst.de> <20240705184846.GF95824@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240705184846.GF95824@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 05, 2024 at 09:48:46PM +0300, Leon Romanovsky wrote:
> In that case the flow is dma_map_sg()->iommu_dma_map_sg()->dev_use_sg_swiotlb().

Even for that you'll still need to check the first and last entry
for being kmalloc misaligned if we assume that all middle entries are
aligned (which for NVMe they have to, but we're probably better off
figuring out a way to enforce that).


