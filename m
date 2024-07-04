Return-Path: <kvm+bounces-20938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 845419270E4
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 09:49:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D84D1F23A21
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 07:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2620A1A38FA;
	Thu,  4 Jul 2024 07:49:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A796D1A0B07;
	Thu,  4 Jul 2024 07:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720079345; cv=none; b=AGs7ij/xR1djEhQQQCowh8ylEdHuJSNbEczNx2cqBAdVZDeaV89Qflgv5KZE7eLWfwBuMez0Q64gJnOfUvoxlm9QuZ9OjlKBlQyE1928IHPOREC5ugccTeEHTobqIE5azA30KrIxPkXBW4hLNE+hxtdAnnn1V/9/fva7JAdqscM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720079345; c=relaxed/simple;
	bh=FXyIm8BUSs84k8MRehwyXAfw5xJzi4jT6joRNBHNI+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+WhsXfcNXzm1hi5OwIu/A4uoYih80ee3L42dPuBnnEHTZTucpMyo+8y+8RK3RN+HqQz/gXlbxKbwXIlmDFbPFUpi7Z99B3aQRNW9GQ/kwtHoVI//JMXSyRWJCZDuHFx5WekoM17nrHi5MtZ4PxkvtY6lzpr5V0mcmYZwJr38xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 52B5468AA6; Thu,  4 Jul 2024 09:48:56 +0200 (CEST)
Date: Thu, 4 Jul 2024 09:48:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
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
Subject: Re: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
Message-ID: <20240704074855.GA26913@lst.de>
References: <cover.1719909395.git.leon@kernel.org> <20240703054238.GA25366@lst.de> <20240703105253.GA95824@unreal> <20240703143530.GA30857@lst.de> <20240703155114.GB95824@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703155114.GB95824@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 03, 2024 at 06:51:14PM +0300, Leon Romanovsky wrote:
> If we put aside this issue, do you think that the proposed API is the right one?

I haven't look at it in detail yet, but from a quick look there is a
few things to note:


1) The amount of code needed in nvme worries me a bit.  Now NVMe a messy
driver due to the stupid PRPs vs just using SGLs, but needing a fair
amount of extra boilerplate code in drivers is a bit of a warning sign.
I plan to look into this to see if I can help on improving it, but for
that I need a working version first.


2) The amount of seemingly unrelated global headers pulled into other
global headers.  Some of this might just be sloppiness, e.g. I can't
see why dma-mapping.h would actually need iommu.h to start with,
but pci.h in dma-map-ops.h is a no-go.

3) which brings me to real layering violations.  dev_is_untrusted and
dev_use_swiotlb are DMA API internals, no way I'd ever want to expose
them. dma-map-ops.h is a semi-internal header only for implementations
of the dma ops (as very clearly documented at the top of that file),
it must not be included by drivers.  Same for swiotlb.h.

Not quite as concerning, but doing an indirect call for each map
through dma_map_ops in addition to the iommu ops is not every efficient.
We've through for a while to allow direct calls to dma-iommu similar
how we do direct calls to dma-direct from the core mapping.c code.
This might be a good time to do that as a prep step for this work.


