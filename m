Return-Path: <kvm+bounces-31405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2705F9C3884
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 07:39:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D33B61F21EA9
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 06:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2075942A8A;
	Mon, 11 Nov 2024 06:39:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC28513E02E;
	Mon, 11 Nov 2024 06:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731307177; cv=none; b=TPwGPdmjge80DVV+oPM4BHtGHndRyIa/8Zf5CYUz3crcSxnq4wELb46bJO/oOGgJIThfivRLOEYODAhsjtsyVrPHNMny0BqPCt5Rb6vRHCihExOU3PiWUiZ5DZwUXA0OCvur4yFFpoZeo5nVAk9ofSyWbNT5G3Tgg2UJvAQF1Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731307177; c=relaxed/simple;
	bh=XMRwi/lwwuG/4OcjixsIyJzR/dyttShCUKokbIXK1DY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hfQJWqtRazfoMnd3fzGBYrNP1PPnJ4hKhDeN6fkr22ILERzF6YlLP7f3F8pzIAwHCSNgj/UjMm6YPFXVrD0Fnkxhb8f2z2vb56Q+mVs/zEgyBt6fvO0qpb0OxL8hi8rYDk8zFzf2Gw3GgN/TRJCefz9sT2RXkzNQfRMjyb8WPFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3F82B68C7B; Mon, 11 Nov 2024 07:39:32 +0100 (CET)
Date: Mon, 11 Nov 2024 07:39:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 04/17] dma-mapping: Add check if IOVA can be used
Message-ID: <20241111063932.GC23992@lst.de>
References: <cover.1730298502.git.leon@kernel.org> <9515f330b9615de92a1864ab46acbd95e32634b6.1730298502.git.leon@kernel.org> <5ea594b3-7451-4553-92c1-2590c8baef20@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ea594b3-7451-4553-92c1-2590c8baef20@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Nov 10, 2024 at 04:09:11PM +0100, Zhu Yanjun wrote:
>> +
>> +/*
>> + * Use the high bit to mark if we used swiotlb for one or more ranges.
>> + */
>> +#define DMA_IOVA_USE_SWIOTLB		(1ULL << 63)
>
> A trivial problem.
> In the above macro, using BIT_ULL(63) is better?

No, and can people please stop suggesting it?  That macro is so fucking
pointless that it's revolting,


