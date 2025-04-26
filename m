Return-Path: <kvm+bounces-44391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A04A9D6F5
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 03:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E0BB1BC3E15
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 01:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 379891F4C94;
	Sat, 26 Apr 2025 01:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5DnBKuz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4296E282EE;
	Sat, 26 Apr 2025 01:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745630074; cv=none; b=m2DBs4LYFiA8w7DLerNO7Vs7Xi5Xg0JVXftjMn6sgLeT88GOaS3m7lTDz1vubX1XH7HAqyXuDGPfIVdJeV9or70+DhPGrKa1xOEHdrFu+rNRu614v4YIQbsF+Jah4/7x25WmvWhx+I2Z7V67cPt1zTPXMBcGPV0N8nm0khtTZE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745630074; c=relaxed/simple;
	bh=2LCUrZMeV2HZzBU2CuLrVTRtvZm5lDggJtqpE4KrVpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sDlydX8SmHI4GVfZ2p3vXpALt6fWKhX42pPwm3tqxsoG4JWO+BTPEF0B+GW5pwctwdFqbSnyiLqLFjA9NekHLNqUUj3gf15ZzURD7K1yCJ+4cIQDD9n5uFhAQs17G5HH3fqzqGGWN0nT42djIzUtoEPseF/idasw7qtOYJnA2Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q5DnBKuz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45A8C4CEE4;
	Sat, 26 Apr 2025 01:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745630073;
	bh=2LCUrZMeV2HZzBU2CuLrVTRtvZm5lDggJtqpE4KrVpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q5DnBKuzNiqtvCl6bt5OSuQ4Tc06r1bDEkNLVpzhjD6vhR5V5lliPHNnef8KwuRTG
	 YUUrqLo48zbTsbToeDLKvt7DHSn7KOpZkaC7YPm/XMeVJox3cmAD22GhCnSbz8Hgep
	 eMz7yioUwd3EDW+jW9mv2QPglXm4OO5jDGi7umHe0BslaXl3e3veXTl+YrY1kifVHi
	 4XQITuMZUb873n0U8G2mYYDyiy9Fz5rUgdyja1NzYtgg1qwPX5nxLWdauAOlbasW+s
	 3b6rwAUYeWMKhP2es1RmPrWaM/kXo2KHDrF5OfYVP4QcQ83jMavfxt/JRQoUA1WruP
	 ddvaSB+syb4UQ==
Date: Fri, 25 Apr 2025 18:14:31 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH v9 06/24] iommu/dma: Factor out a iommu_dma_map_swiotlb
 helper
Message-ID: <aAwzd_PE6U4ukQQp@bombadil.infradead.org>
References: <cover.1745394536.git.leon@kernel.org>
 <9ef79ed6c24d12cfea7e6f491da48ae170a5f3f3.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ef79ed6c24d12cfea7e6f491da48ae170a5f3f3.1745394536.git.leon@kernel.org>

On Wed, Apr 23, 2025 at 11:12:57AM +0300, Leon Romanovsky wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Split the iommu logic from iommu_dma_map_page into a separate helper.
> This not only keeps the code neatly separated, but will also allow for
> reuse in another caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

