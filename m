Return-Path: <kvm+bounces-53345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D990FB1025C
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 09:53:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D63BAA4A59
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 07:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA1926CE03;
	Thu, 24 Jul 2025 07:52:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6881C6FF5;
	Thu, 24 Jul 2025 07:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753343566; cv=none; b=UakdmFjhcXt++7yUOhemqj1qJdEr/T5v4OTgvLVRpYHqP1zltsHB9VxE8lBkPX7A0KqNKL5WFqg2F/TNO2bsme0SVpKGQozDhF//p67zURnzNBJMIB8+9tldyRi6CASYKbfZfL6B2t7M0C6Ee1hej8YiI3f0Pt7w5VqA5XGcOVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753343566; c=relaxed/simple;
	bh=mWKop4D8i0hQlywL0RLEcKxr6x2x6dy8AoH9oKjF3qM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n1rCCD2rS4kQFFA54+d5BXXhvCmLQVpbE6tPcUhfyoduNWrDf8pEJZVu7lMBj6DTWywA2zvtqye7cdwfrtVrMBZF0EYIM+URCcY5cWf/6bhLGTPJx0vWQ5Ldln4Hf28Xru3ScF3U0Zger/bh5F8DmLgcfv0L6P8FdmF/wyZeYqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 376B168BFE; Thu, 24 Jul 2025 09:52:38 +0200 (CEST)
Date: Thu, 24 Jul 2025 09:52:38 +0200
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
Subject: Re: [PATCH 03/10] PCI/P2PDMA: Simplify bus address mapping API
Message-ID: <20250724075238.GC30590@lst.de>
References: <cover.1753274085.git.leonro@nvidia.com> <30640b5e4ec975f928e685b92aaaf3e2e5e08f72.1753274085.git.leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30640b5e4ec975f928e685b92aaaf3e2e5e08f72.1753274085.git.leonro@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 23, 2025 at 04:00:04PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Update the pci_p2pdma_bus_addr_map() function to take a direct pointer
> to the p2pdma_provider structure instead of the pci_p2pdma_map_state.
> This simplifies the API by removing the need for callers to extract
> the provider from the state structure.
> 
> The change updates all callers across the kernel (block layer, IOMMU,
> DMA direct, and HMM) to pass the provider pointer directly, making
> the code more explicit and reducing unnecessary indirection. This
> also removes the runtime warning check since callers now have direct
> control over which provider they use.

Again I don't actually see any simplification here.  But maybe I'm
missing the ultimate goal here.


