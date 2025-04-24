Return-Path: <kvm+bounces-44096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB613A9A56F
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:12:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C7461B834A6
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F357020CCC9;
	Thu, 24 Apr 2025 08:11:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5ADE552;
	Thu, 24 Apr 2025 08:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745482276; cv=none; b=CAVJN0JWMmcGyI0sz53vADj2uYM5ZMHYWaxFthQ+z1vXNMgLbturC+qNLOUdkRm2RAy8UcAFcxYjhHk3a0kD3tAB0QzNSXfbcWmirpqFPXtdtVZM4OQGWxLanuKZrECOc/TXkWVbMsrmQR+wk9m+1JNvKpxHkqN0xPTnz/NenFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745482276; c=relaxed/simple;
	bh=JGL3psGtkPH2/js8ND1zwM6GdWFnAznTJQ556NVu1Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rHO4u/Y/lGtHRuH0Uk2/BW6hQZ6oL9oPpn8lmUi3ivcOLa0NoaU8eFySORTnhjI+Q6UL3pfWMUC4Zl8MmW3qVCyBZABRVYTC4vpdutK9tbqj5BfDd2GtKaqvHVJ+wCRbrzrC8QtwY0nLsjhMAGvgaVoEtfYhF/z8+VpalxsjW9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2F45667373; Thu, 24 Apr 2025 10:11:01 +0200 (CEST)
Date: Thu, 24 Apr 2025 10:11:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Zhu Yanjun <zyjzyj2000@gmail.com>,
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
Subject: Re: [PATCH v9 10/24] mm/hmm: let users to tag specific PFN with
 DMA mapped bit
Message-ID: <20250424081101.GA22989@lst.de>
References: <cover.1745394536.git.leon@kernel.org> <0a7c1e06269eee12ff8912fe0da4b7692081fcde.1745394536.git.leon@kernel.org> <7185c055-fc9e-4510-a9bf-6245673f2f92@redhat.com> <20250423181706.GT1213339@ziepe.ca> <36891b0e-d5fa-4cf8-a181-599a20af1da3@redhat.com> <20250423233335.GW1213339@ziepe.ca> <20250424080744.GP48485@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424080744.GP48485@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 24, 2025 at 11:07:44AM +0300, Leon Romanovsky wrote:
> > I see, so yes order occupies 5 bits [-4,-5,-6,-7,-8] and the
> > DMA_MAPPED overlaps, it should be 9 not 7 because of the backwardness.
> 
> Thanks for the fix.

Maybe we can use the chance to make the scheme less fragile?  i.e.
put flags in the high bits and derive the first valid bit from the
pfn order?

