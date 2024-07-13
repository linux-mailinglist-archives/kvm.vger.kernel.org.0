Return-Path: <kvm+bounces-21594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0D669303C5
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 07:24:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 230EC28293A
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 05:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E5691D696;
	Sat, 13 Jul 2024 05:24:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D731AAD7;
	Sat, 13 Jul 2024 05:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720848257; cv=none; b=pFMUY/kRYzBzVJ8FCL0V7RbnSwclhjFynZqC5qb+Pa61kWFUfX8pb0bD57MsnLfYlJvGFktQCbYMf8QnEYIA5CylQx47zHIKVghsikyo0pRxb5kVTsji4NnHks4252mfLSihLpt/MFqGS8RZqQBU/lCIUkhuOpDNFly3q3X6bIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720848257; c=relaxed/simple;
	bh=i1tyWKO6ViZfMuMG8iDhebaM0e4ILH5wb7R8M5/Ml28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ma8RtNY73NNod/H9ZchNqjDM85QnYsjkN/PRKtI4Mu6QoF3dg21KKDFVM/en4m8sZ5FmeffhdbKPd35rfqid5oOqPxDqlTz3OcC4VMukC0brtuOeaxsYs2i98kBMDDbhxpuDkKf0LutKPHRBrsTh7i/ThY6G/bjgBGcZEZWIIGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5CE8768B05; Sat, 13 Jul 2024 07:24:09 +0200 (CEST)
Date: Sat, 13 Jul 2024 07:24:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Keith Busch <kbusch@kernel.org>, "Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
Message-ID: <20240713052408.GA25890@lst.de>
References: <cover.1719909395.git.leon@kernel.org> <20240705063910.GA12337@lst.de> <20240708235721.GF14050@ziepe.ca> <20240709062015.GB16180@lst.de> <20240709190320.GN14050@ziepe.ca> <20240710062212.GA25895@lst.de> <20240711232917.GR14050@ziepe.ca> <20240712045422.GA4774@lst.de> <20240712124237.GX14050@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240712124237.GX14050@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 12, 2024 at 09:42:37AM -0300, Jason Gunthorpe wrote:
> On Fri, Jul 12, 2024 at 06:54:22AM +0200, Christoph Hellwig wrote:
> 
> > This is all purely hypothetical, and I'm happy to just check for it
> > and reject it for it now.
> 
> I do know a patch set is cooking to allow mixing ZONE_DEVICE P2P and
> anon memory in the same VMA ala HMM with transparent migration of
> ZONE_DEVICE to anon.
> 
> In this situation userspace will be generating IO with no idea about
> any P2P/!P2P boundaries.

Yes.  And as said from the beginning of these discussion I think the
right way is to change the gup code so that for a single call to
get/pin_user_pages it always returns either only P2P pages or non-P2P
pages only, with the FOLL_PCI_P2PDMA just allowing P2P pages at all.
Similarly they could easily just return one kind of P2P pages per
call only.

