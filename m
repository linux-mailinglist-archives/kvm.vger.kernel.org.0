Return-Path: <kvm+bounces-53346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 201C1B1027A
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 09:56:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EF151CE1CF1
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 07:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF563272815;
	Thu, 24 Jul 2025 07:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BmgGnxFd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D441126FA5A;
	Thu, 24 Jul 2025 07:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753343738; cv=none; b=kJj3Zs6T1hXnNam5TDJOarz9UyfxZ+289nyy9Z6mGtwU9mbSoK2+t2x8MQ4n54RjS/CEccC8Nf05uarBLmBfzqTCxGjdwip5/SPx1SH0lZtX8TPnv5/pnXAhURK6SXCf3CvatFKe83eJ9wJhCmr/toE9fvhHIRIUYAB77I6RVs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753343738; c=relaxed/simple;
	bh=RejzoqE1QxLnfVJEcMygPRhvHl4TUui1JW/EXqf2Ekw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=epesPL9P0x/luY6UROV1ZFMyOJ+xSMoppWuFCTwe7vZRMTTExrURCMhYzKDJZkU5RvhHp0AOfKLShF6yxDMnSiAwrhM7bcScVR/D4MOQs/pnRoqYW82Iydu3+edTW+1b8BHsr2rpmw0Q44CLLWUT3VilACTLD1rzCNALlm9kYGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BmgGnxFd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01868C4CEED;
	Thu, 24 Jul 2025 07:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753343737;
	bh=RejzoqE1QxLnfVJEcMygPRhvHl4TUui1JW/EXqf2Ekw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BmgGnxFd0m0ax8BCXu8Z23nkYEvrbYb+kfQKhThhtk3fHD05jyqUumNras/XMac1K
	 fNsR+wJhnDxgDW3B0m/HYoEQYDy1trcfoIv3oJ5G6lK6WxOJgRTPmYPyorkEbtucoO
	 lstjt+ChPXcIFyADPo+xmzPFYCtn+am83vuGKyQI9REWZ+4QOBGiYXPyVWpj/Mf6Qq
	 1sj2VY/rutJ5LfhdVsfBdfsSZKWAiRCmF5WPvyewWqqP7ARQWZMzXtSEGh/Zr+/bJF
	 bksCHkNXFT6a8dFppzN/TYVK3Vt0jyt6BKBOSqke/cENn8f6Uq9rDv+qbrJJvq5YYP
	 D7SDuGtahnLuA==
Date: Thu, 24 Jul 2025 10:55:33 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <20250724075533.GR402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <c2307cb4c3f1af46da138f3410738754691fbb3d.1753274085.git.leonro@nvidia.com>
 <20250724075145.GB30590@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724075145.GB30590@lst.de>

On Thu, Jul 24, 2025 at 09:51:45AM +0200, Christoph Hellwig wrote:
> On Wed, Jul 23, 2025 at 04:00:03PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Extract the core P2PDMA provider information (device owner and bus
> > offset) from the dev_pagemap into a dedicated p2pdma_provider structure.
> > This creates a cleaner separation between the memory management layer and
> > the P2PDMA functionality.
> > 
> > The new p2pdma_provider structure contains:
> > - owner: pointer to the providing device
> > - bus_offset: computed offset for non-host transactions
> > 
> > This refactoring simplifies the P2PDMA state management by removing
> > the need to access pgmap internals directly. The pci_p2pdma_map_state
> > now stores a pointer to the provider instead of the pgmap, making
> > the API more explicit and easier to understand.
> 
> I really don't see how anything becomes cleaner or simpler here.
> It adds a new structure that only exists embedded in the exist one
> and more code for no apparent benefit.

Please, see last patch in the series https://lore.kernel.org/all/aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com
It gives me a way to call p2p code with stable pointer for whole BAR.

Thanks

> 
> 

