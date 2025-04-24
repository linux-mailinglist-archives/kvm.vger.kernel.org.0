Return-Path: <kvm+bounces-44132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E6687A9ADF3
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C19C4A07E4
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 12:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B583A27BF7F;
	Thu, 24 Apr 2025 12:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NF+hNjrG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2E1153BE8;
	Thu, 24 Apr 2025 12:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745499057; cv=none; b=RJB0gTby8euN3gN4n+jWDvTuILGEK6zgX7t0PGEZsLCBUy6QOz5P3Is6YXGDI69+E/hFIFvYw+b5QaNV0oq2dygj7yW1W3ODMQMTUMhLTxoT/FVOu4i399iHVV2vH8zIkoYysIbXp+b4ty2/AfUAjpdYWCMTuf5pOk3dRjsibI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745499057; c=relaxed/simple;
	bh=8H9DLsIGypKjg5EA6FxGNO666pgvRrUO/QmIpk1Dbt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AbGu0W7aLEcKekvvQzLIS2KX8Lzf+93H2jVheWFWQMitKRUeCMZqxDBw8cCl+vc6T07w2M8/1NQCtVyUuRWw9KFggEFC3fgKOzjaSt2RPB9m/NFlaDFFCsnlRxdYN+Ncqk/8Fy5qyPfZzddsjbydd4iSi9X/JJqDM1nYkq+4jIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NF+hNjrG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73038C4CEE8;
	Thu, 24 Apr 2025 12:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745499057;
	bh=8H9DLsIGypKjg5EA6FxGNO666pgvRrUO/QmIpk1Dbt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NF+hNjrGDHMWirFNyLpGK+CGY/Wtnrcaz8GKXJy/bE0XGkdVLaecqnHgHaxGfEhML
	 7jpVM/H7S49o+1K+eHQ2EgfO2HX4uAVtcvGRrWZJiMPUTyBYsPFQrSWaQDyWiksE4I
	 zYCVGwUO0Zy3g+Q9YtT5JjZ6L4/EJc4YcANsfzc5P8J46J4DvIu422Ekpr+LWz/xu5
	 1tDTRL8fevCgQaBA+DwfgEVIfNxbm2kn1CppO/72VC+Bxe/6aX19AeSe+j5ZVvsX6c
	 jKIeV1sk1Atk76qflMRZe3BT+0W+nn49+KZBrII6YRZh59RXG6gb+f1yfN7sBXtrbi
	 XI5m2BF99M4Cw==
Date: Thu, 24 Apr 2025 15:50:52 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
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
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v9 10/24] mm/hmm: let users to tag specific PFN with DMA
 mapped bit
Message-ID: <20250424125052.GS48485@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <0a7c1e06269eee12ff8912fe0da4b7692081fcde.1745394536.git.leon@kernel.org>
 <7185c055-fc9e-4510-a9bf-6245673f2f92@redhat.com>
 <20250423181706.GT1213339@ziepe.ca>
 <36891b0e-d5fa-4cf8-a181-599a20af1da3@redhat.com>
 <20250423233335.GW1213339@ziepe.ca>
 <20250424080744.GP48485@unreal>
 <20250424081101.GA22989@lst.de>
 <20250424084626.GQ48485@unreal>
 <20250424120703.GY1213339@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424120703.GY1213339@ziepe.ca>

On Thu, Apr 24, 2025 at 09:07:03AM -0300, Jason Gunthorpe wrote:
> On Thu, Apr 24, 2025 at 11:46:26AM +0300, Leon Romanovsky wrote:
> > On Thu, Apr 24, 2025 at 10:11:01AM +0200, Christoph Hellwig wrote:
> > > On Thu, Apr 24, 2025 at 11:07:44AM +0300, Leon Romanovsky wrote:
> > > > > I see, so yes order occupies 5 bits [-4,-5,-6,-7,-8] and the
> > > > > DMA_MAPPED overlaps, it should be 9 not 7 because of the backwardness.
> > > > 
> > > > Thanks for the fix.
> > > 
> > > Maybe we can use the chance to make the scheme less fragile?  i.e.
> > > put flags in the high bits and derive the first valid bit from the
> > > pfn order?
> >
> > It can be done too. This is what I got:
> 
> Use genmask:

I can do it too, will change.

> 
> enum hmm_pfn_flags {
> 	HMM_FLAGS_START = BITS_PER_LONG - PAGE_SHIFT,
> 	HMM_PFN_FLAGS = GENMASK(BITS_PER_LONG - 1, HMM_FLAGS_START),
> 
> 	/* Output fields and flags */
> 	HMM_PFN_VALID = 1UL << HMM_FLAGS_START + 0,
> 	HMM_PFN_WRITE = 1UL << HMM_FLAGS_START + 1,
> 	HMM_PFN_ERROR = 1UL << HMM_FLAGS_START + 2,
> 	HMM_PFN_ORDER_MASK = GENMASK(HMM_FLAGS_START + 7, HMM_FLAGS_START + 3),
> 
> 	/* Input flags */
> 	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
> 	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
> };
> 
> Jason

