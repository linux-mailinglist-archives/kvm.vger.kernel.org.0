Return-Path: <kvm+bounces-43749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9CD9A95E5F
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9F637AA02E
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 06:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0958823A9B2;
	Tue, 22 Apr 2025 06:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qAJ9ve3O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0C222A814;
	Tue, 22 Apr 2025 06:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745303802; cv=none; b=cPVoqyKbYRtwQvEvboLbQ1KSS5lllaLoLqymQFzzAE+T9PrAxriogpPhLs9zkQE9Zif62QVylEoo17JpCswSEJy+Ll1UbjeOqN1dTk0gfjSpUu46jqBivOGDXod/pn3AmcGr08mURX02NAerrhzzgo4XbxzfBIXFY5724JFRbzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745303802; c=relaxed/simple;
	bh=HfetzUxRXy4rCDFO2Jid01crVoBGhZcgFFPhx3Tl4zQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gbe5RIKE/cYY8WM46Nw5VvXyeCQQTKP/M61vKHva5cyuCwUrkK+nb1+709BOsOdDI1eoyQvFFiGVGVoJnp5DQoz8CogUPsWWe5xmd1t1093FeXMbOjkG2LPOWCGuSZ8a7ytm0YErPEck/tmNVoK3Mi5Le8nETRdnMeGGAIVgSmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qAJ9ve3O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66D0C4CEEA;
	Tue, 22 Apr 2025 06:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745303801;
	bh=HfetzUxRXy4rCDFO2Jid01crVoBGhZcgFFPhx3Tl4zQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qAJ9ve3OT0ZJnEWm3PYqcpUZBluuU64tZMSjgqeGPlLsklDQcSPGF19PJHu4OVyak
	 +mfowzS/d2IZFkhAaKZSZmz3bFxaaljwCLKAbX4CkMGSTFnCxZYKExIhX8brBVrDIn
	 EnlOR/RtUrvb5TEsQ3vHZY8rvQVuJb4STE7Le7iVPo+vTGVmuK4GjktT2YA8InWPCx
	 uofgjFe0OVXsEodcivnhb8/7guwb3Azqlc/8/cOSiqu4hlvpFTrOi2w+4KOno8BYEF
	 ZAUjL+s5coWHLBK4MTAwZgXnOjZruNtZfPNGBTDgLtup3GvGYhpyREXyrFYAhySxzj
	 pUOOurdEnqncw==
Date: Tue, 22 Apr 2025 09:36:38 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>,
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
Subject: Re: [PATCH v8 20/24] blk-mq: add scatterlist-less DMA mapping helpers
Message-ID: <20250422063638.GB48485@unreal>
References: <cover.1744825142.git.leon@kernel.org>
 <87b151a3791d71e58ec6f1b42bcf5fe06304cf80.1744825142.git.leon@kernel.org>
 <20250422042727.GC27723@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422042727.GC27723@lst.de>

On Tue, Apr 22, 2025 at 06:27:27AM +0200, Christoph Hellwig wrote:
> On Fri, Apr 18, 2025 at 09:47:50AM +0300, Leon Romanovsky wrote:
> > +#define blk_phys_to_page(_paddr) \
> > + 	(pfn_to_page(__phys_to_pfn(_paddr)))
> 
> The code can use phys_to_page now that that is provided kernel-wide
> instead this temporary helper.

Thanks, will change.

