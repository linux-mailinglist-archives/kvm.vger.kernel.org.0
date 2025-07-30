Return-Path: <kvm+bounces-53727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02615B15BB7
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 11:32:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D88C5548655
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 09:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D27027781D;
	Wed, 30 Jul 2025 09:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="re3qBfXG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733841D5AC6;
	Wed, 30 Jul 2025 09:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753867941; cv=none; b=OCL9xLG4stSMrw3wBxnVDZ/UVwopXcDT1TqOOzG3+OScIh3daA4RS/2CdtibhaTtLxlRxt2I+cIuwIlAnrj0L8pTszcjRPCqn3LS393+vW4MSwax+DGI3XmRwZ4A7Q/JDPIRGki8IDujjJg5hXEsRrJ6ZZAct9FBtyccKDHgl1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753867941; c=relaxed/simple;
	bh=4W4puONHgBcGHwoNV0CY3xma0bboz0RMz11XR/y9JNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gxfu9Lc2X1BBXbid2aO32/1hbmawJS8Fv17vl5f5u2d2hcge84XIraU8CHirLywwLbgqHzp1IqUGsmoKxXybA/nqkc+vPnOI1x46w/nvAY57d+KfcwIY8txgPo2jM0TFoFRskLIUiN24E3Ba7nOvzk4FxLmY5d3vI2OkTEwQo1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=re3qBfXG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5ABC4CEE7;
	Wed, 30 Jul 2025 09:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753867941;
	bh=4W4puONHgBcGHwoNV0CY3xma0bboz0RMz11XR/y9JNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=re3qBfXG4XyZtA/RqPxafo444qv+5COTZZvAJcsIAudJvNJ5GRUrGxzmLMht7qn04
	 hwCyO3Hzt2ruEpZEzwjjG5TqM57jCt7NS/wTLq9A4i30flu1luxSTT3gmO7ssNsvS2
	 Lb5pXFUz6XiBnwlYG8HhanlHIjmJFWfrePje/Dln8nbnfZZITOpG3X+Mc4VYGCgMtY
	 LtRFBtuou9BEeShW+H/gLAcqTOk0FFSJQaVIa0Z6ohVZeUE9/L2qylX3UiuRgQ91sw
	 bEWg/OKcbPZyTRB/9hC19ZqDyhbFiEikEPzuwYdJ2SVd4jtrfVeKeJap5nBj7dN4c4
	 1MrJJzfkPtKTQ==
Date: Wed, 30 Jul 2025 12:32:15 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
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
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20250730093215.GP402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com>
 <8f912671-f1d9-4f73-9c1d-e39938bfc09f@arm.com>
 <20250729201351.GA82395@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729201351.GA82395@nvidia.com>

On Tue, Jul 29, 2025 at 05:13:51PM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 29, 2025 at 08:44:21PM +0100, Robin Murphy wrote:
> 
> > In this case with just one single
> > contiguous mapping, it is clearly objectively worse to have to bounce in and
> > out of the IOMMU layer 3 separate times and store a dma_map_state,
> 
> The non-contiguous mappings are comming back, it was in earlier drafts
> of this. Regardless, the point is to show how to use the general API
> that we would want to bring into the DRM drivers that don't have
> contiguity even though VFIO is a bit special.

Yes, we will see comeback of DMA ranges in v2.

Thanks

