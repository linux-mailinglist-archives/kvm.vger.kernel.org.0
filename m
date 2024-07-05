Return-Path: <kvm+bounces-21049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 214A8928D9F
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 20:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C181D1F221D9
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 18:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0684E16EB52;
	Fri,  5 Jul 2024 18:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ht2Sg2t2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B73A955;
	Fri,  5 Jul 2024 18:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720205332; cv=none; b=mxo4bqYlqGV3arZLnd3h5xdSarTRP7IHhkMRbKaEJbLUJoX1hSoBFjW1PZi8BXgWuUQztUZRr6p1j430aiF+C2QnJpRmJGXQszztHesRGRiKi47ICR09SMDyTgokvzEMrHgxyW/N4/ZmMbK3jZlTXp8paRhfVLUIwe+vjX7Awx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720205332; c=relaxed/simple;
	bh=3gQdxm9rrq4HH+3IgyK33e5U18PihTEsMAv3ZFMKGl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n7cJcpkzqsPw1YsYGmiGRJ7dhq9Cl+rI7cU1j6SertII/9DAuQYBCk01jiO03k3oHaL47F25qx6e8onWv1ta1yDMRGuczxAOZEtFtb2XWBVt2nzdxQJO5kx2tdxiBSc205vUmbRyO9rgoFkcmIWP5DXLtn4AGX7guIsBHBZn/ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ht2Sg2t2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17E5C116B1;
	Fri,  5 Jul 2024 18:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720205331;
	bh=3gQdxm9rrq4HH+3IgyK33e5U18PihTEsMAv3ZFMKGl4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ht2Sg2t2ndCjMGA6QKO2lqpTrzx5fDYVZJW7Ovgfr1eplx4adbkUHrvVY0Fu92JLt
	 mU5W84MEOLzWeruLzCzFJBMcezP+9RWb4w2qbxVzYCrWWzfG7s4lg/Gv7+t1mLvgfO
	 2fdSWrA5Q1UyDcQM7GTChwnkpqlcbSPsNUt/V748Qr4OW0E18YwIXE9gUZ8xqbm3Pa
	 QZ5HR5+kS74PefChnaUbAqlutm/0zUWk4Ir6koict+0o/SIMktXHfmKvALkPRAwy7e
	 60A1hFUaIMAvaXkUU5Xx3C78C3VfTgwAozfACG4DXiep2AGvT26MouaYytY3hJ3pYn
	 tSYLgRXYv+5hA==
Date: Fri, 5 Jul 2024 21:48:46 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Robin Murphy <robin.murphy@arm.com>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Keith Busch <kbusch@kernel.org>,
	"Zeng, Oak" <oak.zeng@intel.com>,
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
Message-ID: <20240705184846.GF95824@unreal>
References: <cover.1719909395.git.leon@kernel.org>
 <47eb0510b0a6aa52d9f5665d75fa7093dd6af53f.1719909395.git.leon@kernel.org>
 <249ec228-4ffd-4121-bd51-f4a19275fee1@arm.com>
 <20240704171602.GE95824@unreal>
 <20240705055806.GA11885@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240705055806.GA11885@lst.de>

On Fri, Jul 05, 2024 at 07:58:06AM +0200, Christoph Hellwig wrote:
> > This is exactly how dma_map_sg() works.
> 
> Which dma_map_sg?  swiotlb handling is implemented in the underlying
> ops, dma-direct and dma-iommu specifically.
> 
> dma-direct just iterates over the entries and calls dma_direct_map_page,
> which does a per-entry decision to bounce based on
> is_swiotlb_force_bounce, dma_capable and dma_kmalloc_needs_bounce.

dma-direct is not going to have "use_iova" flag. Robin pointed to
dma-iommu path.

In that case the flow is dma_map_sg()->iommu_dma_map_sg()->dev_use_sg_swiotlb().

Thanks

> 
> 

