Return-Path: <kvm+bounces-44389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 95B69A9D6D9
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 02:55:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9EDD27B25C1
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 00:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB941EF0B9;
	Sat, 26 Apr 2025 00:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uiSMb7zC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1439C3A1BA;
	Sat, 26 Apr 2025 00:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745628934; cv=none; b=RtlnPDcR8H1jskXWD1OCvyrhbt9XrW0mBISgiBQLHebWgZXyG11XtAgpwN+AebsB92Uv9vAtCOKNFDviq+Gwc+TDMd90yuLX378uKsLzhePxEWjONJ9pPgM1KqH94DZyj6fWGLi8qh4B7grP1h11SuNZiC8ZdP9o9+CE/neGUO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745628934; c=relaxed/simple;
	bh=BOXccjPCEJxJiPSX1YxnZeQAyhQmKv1c/BGHYEt+AQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TK4TSVJ52X5WxNj6injY123kVfy6HFFkCr46/5l4EW7j0C47zsaarbEnr4JKjksvyvN1PZ6hWOsyDtYAhxdyzGfG5Hxaci/2KulVGguUh9Dfwo97Pze1olxgeRo4pIv3VdXBjSIObis3cx7GNWwl5fEgzinaXY73tXLEIB5WTMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uiSMb7zC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9371CC4CEE4;
	Sat, 26 Apr 2025 00:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745628933;
	bh=BOXccjPCEJxJiPSX1YxnZeQAyhQmKv1c/BGHYEt+AQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uiSMb7zCbEnm/zWGn7r9DqfOzGFDieaQGHpUN/NLclU8yohOsRJV0b8VlvZ8vHnfZ
	 j629XNFsK92BCIGb/47jnK6G+v1TLnv5qMOk0YCv2pbyxQ5uVV9cUeyWrhVs/54ym1
	 X5kJdXQtjULkoUqi3pPYuKDIbr4YZdscn9yNnLfv4WPbHgpS65N8AtFsS2gsgeeVNY
	 SuX3OHwk8XVamrwdbLNpTKGGWFQ9HIrTpqsC2+ALw2nHooGVf3ZGkVpolFHelMSllb
	 QVl1DmjsAa5DeVaTSawCaZggs4AUOfWX3v/Z/ZMIpMfeyRV0MR0Kb5ebrxolRAKJ/8
	 NXVVDs+pM3rpQ==
Date: Fri, 25 Apr 2025 17:55:31 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, Jake Edge <jake@lwn.net>,
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
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v9 04/24] iommu: add kernel-doc for iommu_unmap_fast
Message-ID: <aAwvAzZdVigusu8J@bombadil.infradead.org>
References: <cover.1745394536.git.leon@kernel.org>
 <9becc0989ed0a6770e4e320580d1152b716acd0d.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9becc0989ed0a6770e4e320580d1152b716acd0d.1745394536.git.leon@kernel.org>

On Wed, Apr 23, 2025 at 11:12:55AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Add kernel-doc section for iommu_unmap_fast to document existing
> limitation of underlying functions which can't split individual ranges.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Acked-by: Will Deacon <will@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

