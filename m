Return-Path: <kvm+bounces-21269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B79E992CB0A
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 08:27:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 605B41F2394D
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 06:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E27F7D412;
	Wed, 10 Jul 2024 06:27:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928626F31C;
	Wed, 10 Jul 2024 06:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720592832; cv=none; b=E1yzBDxfaRT1UUWMztAqJfhUvqX5FdQh0siCx+1vPzTZdw1MwiymJlz53I8hAR+JjT2FMYmxJSNPlcACJLhSam5Rofn+ZBNoYaRW1ThtqDN0ps1JvPFomcVT/+ijsjg/YO7C90meXF46PKmSnsKM4SULguVFc3d6G/ozanolP08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720592832; c=relaxed/simple;
	bh=66r1q88ch9VtoTiN4TFn3SCBV6+FPnySmnxU4V8acQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=syyCgOHf3yYZ6XNOWOa/CULpS+lPLoOD4jVz/zrFuJ0HdOQpWlHAzYQJOcOeD7cgdu49z1op6dTTCCHci3oKyxhUXPKWCw1hSCAW++uDMUa3Vac9A+YK3n0Qg/Eq2K49tLYEqeW7GvNc6LB5JWuOr/wpRCYz81owOHIVj81ZU0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5C935227A87; Wed, 10 Jul 2024 08:27:04 +0200 (CEST)
Date: Wed, 10 Jul 2024 08:27:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Robin Murphy <robin.murphy@arm.com>,
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
Message-ID: <20240710062704.GA25953@lst.de>
References: <cover.1719909395.git.leon@kernel.org> <20240703054238.GA25366@lst.de> <20240703105253.GA95824@unreal> <20240703143530.GA30857@lst.de> <20240703155114.GB95824@unreal> <20240704074855.GA26913@lst.de> <20240708165238.GE14050@ziepe.ca> <20240709061721.GA16180@lst.de> <20240709185315.GM14050@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709185315.GM14050@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 09, 2024 at 03:53:15PM -0300, Jason Gunthorpe wrote:
> > That whole thing of course opens the question if we want a pure
> > in-memory version of the dma_addr_t/len tuple.  IMHO that is the best
> > way to migrate and allows to share code easily.  We can look into ways
> > to avoiding that more for drivers that care, but most drivers are
> > probably best serve with it to keep the code simple and make the
> > conversion easier.
> 
> My feeling has been that this RFC is the low level interface and we
> can bring our own data structure on top.
>
> It would probably make sense to build a scatterlist v2 on top of this
> that has an in-memory dma_addr_t/len list close to today

Yes, the usage of the dma_vec would be in a higher layer.  But I'd
really like to see it from the beginning.

> . Yes it costs
> a memory allocation, or a larger initial allocation, but many places
> may not really care. Block drivers have always allocated a SGL, for
> instance.

Except for those optimizing for snall transfer of a single segment
(like nvme). 

> My main take away was that we should make the dma_ops interface
> simpler and more general so we can have this choice instead of welding
> a single datastructure through everything.

Yes, I don't think the dma_vec should be the low-level interface.
I think a low-level interface based on physical address is the right
one.  I'll see what I can do to move the single segment map interface
to be physical address based instead of page based so that we can
unify them.


