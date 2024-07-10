Return-Path: <kvm+bounces-21268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 846A992CAEA
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 08:22:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1D27B2358C
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 06:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA4B78C63;
	Wed, 10 Jul 2024 06:22:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C115BAF0;
	Wed, 10 Jul 2024 06:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720592539; cv=none; b=ehRfjnBLffcoV6YgiCpuc+cxdmxbNrbZT6V6Jf9u0v79mYkDlXM/peFXTRjCuAy8kEOO/RhWUpxz1uoUsDv7fw9TKL2pZKK11J6sLut5CDioai3ZWFyjnNqlcIt6rG3l1MHn6aU4tke5k1jFcZXlBIhhQmUWA5raE7SXyTDRocg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720592539; c=relaxed/simple;
	bh=NGY6+a5EweXEppSGRkflKSDqFxD1LoZFRBntbil7k4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PmSyOAwZE3d2YSfLl9Dt976QbrPsBEdrpqzDa3eqGxfn3oq+4uO+7HddSmmKRx+8gRr1xC+2QR3wpE13877RgaDLurM8J0fCZIIfE89bQUOsGWdsHBW+31KhYdPzDS54e0UYrAPTFgNazP7W4RmUiyFlIAi6dgMg9wTafJ4uwgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ACBCC227A87; Wed, 10 Jul 2024 08:22:12 +0200 (CEST)
Date: Wed, 10 Jul 2024 08:22:12 +0200
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
Message-ID: <20240710062212.GA25895@lst.de>
References: <cover.1719909395.git.leon@kernel.org> <20240705063910.GA12337@lst.de> <20240708235721.GF14050@ziepe.ca> <20240709062015.GB16180@lst.de> <20240709190320.GN14050@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709190320.GN14050@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 09, 2024 at 04:03:20PM -0300, Jason Gunthorpe wrote:
> > Except for the powerpc bypass IOMMU or not is a global decision,
> > and the bypass is per I/O.  So I'm not sure what else you want there?
> 
> For P2P we know if the DMA will go through the IOMMU or not based on
> the PCIe fabric path between the initiator (the one doing the DMA) and
> the target (the one providing the MMIO memory).

Oh, yes.  So effectively you are asking if we can arbitrarily mix
P2P sources in a single map request.  I think the only sane answer
from the iommu/dma subsystem perspective is: hell no.

But that means the upper layer need to split at such a boundary.
E.g. get_user_pages needs to look at this and stop at the boundary,
leaving the rest to the next call.

For the block layer just having one kind per BIO is fine right now,
although I could see use cases where people would want to combine
them.  We can probably defer that until it is needed, though.


