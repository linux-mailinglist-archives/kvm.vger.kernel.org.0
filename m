Return-Path: <kvm+bounces-44388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 81AEBA9D6D1
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 02:52:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E33871BC6C20
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 00:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50CFB1EE021;
	Sat, 26 Apr 2025 00:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o0knlVac"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7203A1BA;
	Sat, 26 Apr 2025 00:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745628725; cv=none; b=r2eySnQ8eUbprzHfUWRcYLUTUwO1D1osBdf0wzd3umA8o4rZPiHlEHMhCVzfQ78H1Xy5QPcSfIvZ/jYkI4zVkUCTJXk6ecDkka+r34L5qAvvWDPAY7BdcM5xTP63DhnouX/FgeaLkXqYC0SKMSV19YT4GjTeN8cYcyBMc37XgsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745628725; c=relaxed/simple;
	bh=vS960RN8eoznhuaOAbkLk3VNvo6fl9t3ybOtAhS+oxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TpQw6gjCikd0xJPnUxeXBHQ6iXkRI9Gr5Da1DFTRSYVrI0N1z2ojWoKres1AI6LCVK+IDFIsJIcEgewyNN29AzSwCtdxLvay1ypeb2DYR3s6MLKC6OySV77LHoaNhphNoGyd0x0hJlGvFgaTAA33qNSRuiQIeusXFAByGyJWaNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o0knlVac; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF217C4CEE4;
	Sat, 26 Apr 2025 00:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745628724;
	bh=vS960RN8eoznhuaOAbkLk3VNvo6fl9t3ybOtAhS+oxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o0knlVacjd58fKaCv8W4WgMSAjurA8qjNdSrVkIqhnTxhCS2Xljmgu2cICXBDsYYr
	 OfXyt6i600xsrD20SrzjLSVs+N4otmMZ84yBX4K/P6PYEbfRjJDtkPhxXLK0RgWJll
	 3CdpyOs1DtyoAmEHFuDJ6Qg34sSmxKxo3O6IiObCP8Zp4VQZ+Tjqw/E1IKwoBHhsIk
	 Q2jkrzUFV5ZON9p1uYvMAV2yZO5y0BluyblQjBpeKYxVpi70Ty1ZWVNV6EB4MDnNj8
	 DqN8txJfMQy3COKXPJWUCYsvWcNg8LLurWldjBa586FP8IuXAYU+kVIBUCJqYa0N0f
	 Gm2ccqz/e76xw==
Date: Fri, 25 Apr 2025 17:52:02 -0700
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
Subject: Re: [PATCH v9 03/24] iommu: generalize the batched sync after map
 interface
Message-ID: <aAwuMuR3tpWtyCTa@bombadil.infradead.org>
References: <cover.1745394536.git.leon@kernel.org>
 <2ce6a74ddf5e13a7fdb731984aa781a15f17749d.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ce6a74ddf5e13a7fdb731984aa781a15f17749d.1745394536.git.leon@kernel.org>

On Wed, Apr 23, 2025 at 11:12:54AM +0300, Leon Romanovsky wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> For the upcoming IOVA-based DMA API we want to use the interface batch the
> sync after mapping multiple entries from dma-iommu without having a
> scatterlist.

This reads odd, how about:

For the upcoming IOVA-based DMA API, we want to batch the sync operation
after mapping multiple entries from dma-iommu without requiring a
scatterlist.

Other than that:

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

