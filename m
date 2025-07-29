Return-Path: <kvm+bounces-53633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D384BB14C65
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 12:41:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24B6B3A560A
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 10:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F1928A406;
	Tue, 29 Jul 2025 10:41:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A526F2877DA;
	Tue, 29 Jul 2025 10:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753785669; cv=none; b=jGPUuSqgzwa+wQcJb457katkrqURErRkPS/4hD3O/s0QUCDIwf++22EOcyGjv+hJHHXqHuO86FQqjG7bmuSaNaxOhfjekwlS9SGOUmEi7YOtNnwTaNofYPv+jdPMPNJcHEH9LqgJQEpcSYlIiz0Uf/2pyZGyVTJ7ii849tKjCOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753785669; c=relaxed/simple;
	bh=hB810dymkUE8vn2hoLlDxLRpBGl/LHNWTNB6ohp4T7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HN4WdfTEUR+6oMXJJtWFUMzHDj4CJgrzpc3SCXK15PSc2m+LNgmCK/8Ox80m6iPwkzVuCi63JXvdt07bagAkIPkDSN85NxIqlk7gWd1OD2YUgS7jRhn5e4U2RbTt1pSEq17YyiMZdYZIHWBy9xWHuGlBvjrWFUUaSG6NCK14zYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DDC6668AFE; Tue, 29 Jul 2025 12:41:00 +0200 (CEST)
Date: Tue, 29 Jul 2025 12:41:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <20250729104100.GA29053@lst.de>
References: <cover.1753274085.git.leonro@nvidia.com> <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com> <20250724075145.GB30590@lst.de> <20250724075533.GR402218@unreal> <20250724075922.GD30590@lst.de> <20250727185158.GE7551@nvidia.com> <20250729075209.GA23823@lst.de> <20250729085336.GG402218@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729085336.GG402218@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 29, 2025 at 11:53:36AM +0300, Leon Romanovsky wrote:
> > Because the struct page is the only thing that:
> > 
> >  a) dma-mapping works on
> >  b) is the only place we can discover the routing information, but also
> >     more importantly ensure that the underlying page is still present
> >     and the device is not hot unplugged, or in a very theoretical worst
> >     case replaced by something else.
> 
> It is correct in general case, but here we are talking about MMIO
> memory, which is "connected" to device X and routing information is
> stable.

MMIO is literally the only thing we support to P2P to/from as that is
how PCIe P2P is defined.  And not, it's not stable - devices can be
unplugged, and BARs can be reenumerated.


