Return-Path: <kvm+bounces-53344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DEFEB10256
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 09:52:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97912188A919
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 07:52:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BA626CE11;
	Thu, 24 Jul 2025 07:51:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC523263F3C;
	Thu, 24 Jul 2025 07:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753343511; cv=none; b=IelViTQWa1hUYGZrkB9zxy/AnnJEa0D45j0w3g4czh2Ow9n7bSqkdBNuSLRoFbaGA3rhasrKN9PLoTl5+/cl5jDZKSMrfozjxMvztaEPqL2IMAeZSnlP0pFyag/eCtIJ55lgQx5PZcSJZGJKNP2tLaj1VPDsVrvQSoV4KG3Yj9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753343511; c=relaxed/simple;
	bh=oReA6uvpTJLn+s9satNB6NAjt/O+vScIIkZcY2WVwdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGHUYdQvhUx+xLwXwaFlFf62OuamNTprunEexXYbN2P320w5qbD9ZHSxXr9Kl5KkhJI1tklNyd5Q9eBA50avyRiz3YYHl5J3P1k+9Fha6dNCd17xYG/ClKjvRxB9gDkE4+ODDmK5ug8vp9SSGZhWru8orz9qbU0qiIrF0U1iVYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 662E568BEB; Thu, 24 Jul 2025 09:51:45 +0200 (CEST)
Date: Thu, 24 Jul 2025 09:51:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>, Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 02/10] PCI/P2PDMA: Introduce p2pdma_provider structure
 for cleaner abstraction
Message-ID: <20250724075145.GB30590@lst.de>
References: <cover.1753274085.git.leonro@nvidia.com> <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 23, 2025 at 04:00:03PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Extract the core P2PDMA provider information (device owner and bus
> offset) from the dev_pagemap into a dedicated p2pdma_provider structure.
> This creates a cleaner separation between the memory management layer and
> the P2PDMA functionality.
> 
> The new p2pdma_provider structure contains:
> - owner: pointer to the providing device
> - bus_offset: computed offset for non-host transactions
> 
> This refactoring simplifies the P2PDMA state management by removing
> the need to access pgmap internals directly. The pci_p2pdma_map_state
> now stores a pointer to the provider instead of the pgmap, making
> the API more explicit and easier to understand.

I really don't see how anything becomes cleaner or simpler here.
It adds a new structure that only exists embedded in the exist one
and more code for no apparent benefit.


