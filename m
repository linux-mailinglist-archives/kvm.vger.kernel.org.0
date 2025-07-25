Return-Path: <kvm+bounces-53471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA749B12462
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 20:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90299AC66C9
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 18:56:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF10225A2AB;
	Fri, 25 Jul 2025 18:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2ubIJ87"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA73F2550AF;
	Fri, 25 Jul 2025 18:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753469648; cv=none; b=aWMEdVB7xvBsKU0Sf0x7ZtrD9KqcQYK7eAYnOoL2QDlnsUKWI9Rhewu/9zSWldm2dTgEs6zl/zL3/ucq4wk2iDlvp9kO+sdOTZHxuL5GKfPbkgppfiEvL3bDaN1eGol9uyvKVoqVEG+isXt3a9zXjRW1+LGnF05nt4jKuXdebk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753469648; c=relaxed/simple;
	bh=igch2/Ss/D54GGpcC/mqrvyLfhLMkygOnI5MXjmAMDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EXL79sr4c02E1t7CO4V2wPKHays0PShUBR8dLahdwTSYs1uW0URsUW6NaWEsn7e813sDUNUJOGJSQU0K9jFo2NNQb8lL2ic+UyNIW7vjjbpN9ZVt08ukVNUbmeASZGOeUDYlYeAJIi7xSGgdPozZBs5KwqoibKp0EQklS+jJ1DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2ubIJ87; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DD2C4CEE7;
	Fri, 25 Jul 2025 18:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753469646;
	bh=igch2/Ss/D54GGpcC/mqrvyLfhLMkygOnI5MXjmAMDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D2ubIJ87qi+xxbcVIPpnJmq41dKhjQJt63te5mxsuN+D+u3uTt6SDzjPKEApLaF0m
	 M+4ss02eJ1sKTm+IM2wtDSadbEpdxJWPu3JT5UWSN1SsfnLBwiz5/0SysDkUehZ9Oe
	 ZyYDXvuCB4uN9ueMrFqDj6Efdvfcu2tt1/iKKIFs9MPGEofYVOtBWne7JY9eYjl+yk
	 kD3GlC1WRNwoIP394nuY7rGTter8zQVf4ItGOtklcJiCzD7GvWswGgmUIQ+47m2dfP
	 h6z/KX9nBHx/erCsMoi3GS1JfKYY2Yp2uZC3rkuLFmN/1ml0hRbHiwRp9P95+2n831
	 jW81KBhbVrGuw==
Date: Fri, 25 Jul 2025 21:54:02 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Alex Williamson <alex.williamson@redhat.com>,
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
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20250725185402.GU402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de>
 <20250724081321.GT402218@unreal>
 <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>

On Fri, Jul 25, 2025 at 10:30:46AM -0600, Logan Gunthorpe wrote:
> 
> 
> On 2025-07-24 02:13, Leon Romanovsky wrote:
> > On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
> >> On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
> >>> From: Leon Romanovsky <leonro@nvidia.com>
> >>>
> >>> Export the pci_p2pdma_map_type() function to allow external modules
> >>> and subsystems to determine the appropriate mapping type for P2PDMA
> >>> transfers between a provider and target device.
> >>
> >> External modules have no business doing this.
> > 
> > VFIO PCI code is built as module. There is no way to access PCI p2p code
> > without exporting functions in it.
> 
> The solution that would make more sense to me would be for either
> dma_iova_try_alloc() or another helper in dma-iommu.c to handle the
> P2PDMA case. dma-iommu.c already uses those same interfaces and thus
> there would be no need to export the low level helpers from the p2pdma code.

I had same idea in early versions of DMA phys API discussion and it was
pointed (absolutely right) that this is layering violation.

At that time, that remark wasn't such clear to me because HMM code
performs check for p2p on every page and has call to dma_iova_try_alloc()
before that check. But this VFIO DMABUF code shows it much more clearer.

The p2p check is performed before any DMA calls and in case of PCI_P2PDMA_MAP_BUS_ADDR
p2p type between DMABUF exporter device and DMABUF importer device, we
don't call dma_iova_try_alloc() or any DMA API at all.

So unfortunately, I think that dma*.c|h is not right place for p2p
type check.

Thanks

> 
> Logan
> 

