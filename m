Return-Path: <kvm+bounces-30461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F0479BAEB5
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:56:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DA1FB2141B
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFE1A1AC45F;
	Mon,  4 Nov 2024 08:55:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ED9189F47;
	Mon,  4 Nov 2024 08:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730710550; cv=none; b=CMO6HO8SH5/XZ2GMruc4lnGWlgsoY64KOW6Svn6/tNrph84WsIhICk56z7Si2p+TA6RQVhroRAJF6R92X+KQAUfdOBcymv99jSozwPpS2pbkhldU1oWcIc0Ar/Z7D/y8RkYVJBC0QXIg7Dxqssv/B8JlGOkVp7mEuZmlHm9tRCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730710550; c=relaxed/simple;
	bh=Y388ylC4i8iTPvc9B4G+QXOv3nw5BajY8qwg0zTx0Lo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPE80N8eoVbG7yusZBtvMuS2WOIOHtekgvG2lwszvjNyBpz+4fcIDwxeYPz12hTx+4LFV/t2YMis3dWhpITVHy++uimViEl6m+OC5UhGfgZ7TUUrvVQrPMaHtusaNTqjIu6zWGrWXxnQnl46gGllwKn9ScSJd8Gfkqe4qM6cz6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8DFB9227AB0; Mon,  4 Nov 2024 09:55:45 +0100 (CET)
Date: Mon, 4 Nov 2024 09:55:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/7] block: don't merge different kinds of P2P
 transfers in a single bio
Message-ID: <20241104085545.GB24211@lst.de>
References: <cover.1730037261.git.leon@kernel.org> <34d44537a65aba6ede215a8ad882aeee028b423a.1730037261.git.leon@kernel.org> <d4378502-6bc2-4064-8c35-191738105406@acm.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4378502-6bc2-4064-8c35-191738105406@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 31, 2024 at 01:58:37PM -0700, Bart Van Assche wrote:
> On 10/27/24 7:21 AM, Leon Romanovsky wrote:
>> +		/*
>> +		 * When doing ZONE_DEVICE-based P2P transfers, all pages in a
>> +		 * bio must be P2P pages from the same device.
>> +		 */
>> +		if ((bio->bi_opf & REQ_P2PDMA) &&
>> +		    !zone_device_pages_have_same_pgmap(bv->bv_page, page))
>> +			return 0;
>
> It's probably too late to change the "zone_device_" prefix into
> something that cannot be confused with a reference to zoned block
> devices?

It's too late and also wrong and also entirely out of scope for this
series.


