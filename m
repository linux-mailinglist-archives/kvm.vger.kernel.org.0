Return-Path: <kvm+bounces-53607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 411C6B1497C
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 09:53:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB9F57AF5F1
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 07:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB653272E56;
	Tue, 29 Jul 2025 07:52:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B33270EAD;
	Tue, 29 Jul 2025 07:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753775538; cv=none; b=hyc8xEebfuICx/WerQmHpcIKJm5Jxdvp71WyTlJlfsQ8GRvqspSZZ67ePgoQat07nBFbc+CDj4PC2T0lrqK8Dm9/8k4bbj/HBhvkaYaHFX725Bu/Ih84xyy2C9sIOV4mbK8wNk4tem/TNxNbg0gi03trZ/cAJBGcUF6UVVU2bwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753775538; c=relaxed/simple;
	bh=qTxjpdw/DHeS/OfkN0sZot0E4aCxepXfaejZYDj9sC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dGOrNGsCQtbCvWOyYk79h3Pr5o0lfqrKShqpcRTEkbT33DF5QgIgW/0hRtohHcXB6FrX0N3WKHDo4qHaG764k9AUx0GIYqvRpCEZlpgbsSXRfWbFc13O1cg0O4LnDuCha9z2zXLvLRSBurjq3kSvEGSXTKkpVMV0UUkc3mDTg4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5B85168BFE; Tue, 29 Jul 2025 09:52:09 +0200 (CEST)
Date: Tue, 29 Jul 2025 09:52:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
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
Message-ID: <20250729075209.GA23823@lst.de>
References: <cover.1753274085.git.leonro@nvidia.com> <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com> <20250724075145.GB30590@lst.de> <20250724075533.GR402218@unreal> <20250724075922.GD30590@lst.de> <20250727185158.GE7551@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250727185158.GE7551@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jul 27, 2025 at 03:51:58PM -0300, Jason Gunthorpe wrote:
> On Thu, Jul 24, 2025 at 09:59:22AM +0200, Christoph Hellwig wrote:
> > On Thu, Jul 24, 2025 at 10:55:33AM +0300, Leon Romanovsky wrote:
> > > Please, see last patch in the series https://lore.kernel.org/all/aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com
> > > It gives me a way to call p2p code with stable pointer for whole BAR.
> > > 
> > 
> > That simply can't work.
> 
> Why not?
> 
> That's the whole point of this, to remove struct page and use
> something else as a handle for the p2p when doing the DMA API stuff.

Because the struct page is the only thing that:

 a) dma-mapping works on
 b) is the only place we can discover the routing information, but also
    more importantly ensure that the underlying page is still present
    and the device is not hot unplugged, or in a very theoretical worst
    case replaced by something else.


