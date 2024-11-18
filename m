Return-Path: <kvm+bounces-32016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A8DC9D1385
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 15:47:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46BE11F222B4
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 14:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A3CF1ADFE4;
	Mon, 18 Nov 2024 14:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gcqYJFjE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348C320309;
	Mon, 18 Nov 2024 14:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731941194; cv=none; b=MGdhZGndeR8wLCaJ/DMBJhpY86M015BOPlG3kpJtelDdvr7RlByZ8BAbx+VzAE1Ebv2pt7SEZo2Q7kVkRLqStVOzscoDHHdNFxFeq8M2Dl5P6LTkcFlAdhsPfl+i/OeSQli2LPe2zYNgluulcXmvrivWQI+zo33izO6UfIaOZS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731941194; c=relaxed/simple;
	bh=nNisB9deNFEifWbAA1Dvw/hHdpmPPX8zsLH5xbacxY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ImiSFomJQFNpsQsANk+d5CtEvw/PerIMQt3fzj0wLJ0StOEQy83pGgmFjCKMn/43tROX/8bQbfStWsznvxIRi7Y89O6NXSVMtohWMTztelJfk9CKpFHkZdoOeXYAIgHZb/OCvCQ2DyAsP12Tm69ZihcCkPatK0gpEcF+EIGkxrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gcqYJFjE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2885AC4CECC;
	Mon, 18 Nov 2024 14:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731941193;
	bh=nNisB9deNFEifWbAA1Dvw/hHdpmPPX8zsLH5xbacxY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gcqYJFjERDxmTKO3Jzdv0vArTE/dXSGOuwdgyjk2yJn/d2ltrlEq3xcV6A9UTOQQs
	 4fk2tk5dJmkt6KttbPce7YR877xgwmsSgBNTIhehvPSLAWTNhJeG+CoHLygfSzT2FF
	 vwP2mTJFky9C4OAfWLy5n+S05ganaVPqDQ6hjxvnLdaX1EWpuwxWgQbbn4NLMVL+Ai
	 OegOfG2sPWxlDxbnltGRDouKx9glSiedeWMI/9xjbdN+wzO2Ul86ef9SOlufRt1uKG
	 qlmTelutMmqg5UjnfQf6N3ovc/FxuMiHsWW+rvK0cqbLErHhUmeNyIRWNX24IY7jCi
	 u6pMfsD6X9UYg==
Date: Mon, 18 Nov 2024 14:46:25 +0000
From: Will Deacon <will@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
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
Subject: Re: [PATCH v3 03/17] iommu: generalize the batched sync after map
 interface
Message-ID: <20241118144624.GA27795@willie-the-truck>
References: <cover.1731244445.git.leon@kernel.org>
 <589adb3a4b53121942e9a39051ae49a27f7a074c.1731244445.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <589adb3a4b53121942e9a39051ae49a27f7a074c.1731244445.git.leon@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Sun, Nov 10, 2024 at 03:46:50PM +0200, Leon Romanovsky wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> For the upcoming IOVA-based DMA API we want to use the interface batch the
> sync after mapping multiple entries from dma-iommu without having a
> scatterlist.
> 
> For that move more sanity checks from the callers into __iommu_map and
> make that function available outside of iommu.c as iommu_map_nosync.
> 
> Add a wrapper for the map_sync as iommu_sync_map so that callers don't
> need to poke into the methods directly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/iommu/iommu.c | 65 +++++++++++++++++++------------------------
>  include/linux/iommu.h |  4 +++
>  2 files changed, 33 insertions(+), 36 deletions(-)

I was a little worried that exposing iommu_map_nosync() directly could
expose driver bugs where the range being sync'd was assumed to be mapped,
but I couldn't spot anything obvious from a quick check, so:

Acked-by: Will Deacon <will@kernel.org>

Will

