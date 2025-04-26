Return-Path: <kvm+bounces-44466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 68CBCA9DDA6
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 00:49:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACB5C3BED87
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 22:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71F4C20125F;
	Sat, 26 Apr 2025 22:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dq4DN7sY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3A71F19A;
	Sat, 26 Apr 2025 22:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745707775; cv=none; b=Z9v8AVidEdQ8uxljX2Caf0ffdwsN5hpZ6SekpAB4kkla5ql970oOHrPXRuqFyI50RCmHsHwS555NWaKQeYeB8Dgy1eQPRWtpWLns647lbCDZ4dgZq1a0aMRDEWX9dDxAmaasxrm+VfUaGAKUUhi+Aa9yxdzHBUh5LptW/k0WRnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745707775; c=relaxed/simple;
	bh=nmMFwB0+2Q83FWwoIeN84/Hsbr1BD0MNyu6u3Ztzl+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqQOKcI6zcxF6ERRLfIwF0Pqqcxmj19j1V/6AweGhUfQ+E8C5qBPOnqxjxxW0FtCiwZA/A8ZoMNhsTI+3vu/v6l2ieBZWzDeZZ5vbRaXAMxNxmr03h0goddky9gi/InCEwbYkyRW2YpLMc+WTH5zokOV5yz7Hvd5on4rCMzXCAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dq4DN7sY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2A6C4CEE2;
	Sat, 26 Apr 2025 22:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745707774;
	bh=nmMFwB0+2Q83FWwoIeN84/Hsbr1BD0MNyu6u3Ztzl+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dq4DN7sYvzyKsbFrdTgHJyYQ/t0IfLJyjoz6RDjDdoU+n+O0s9VMQ5Fe4sETqQqXu
	 DCeQkOkzWcikGSsz5cSEC9TkTjmCk7WVtWRGMVFf+u/m2XaDyfr5iPT82X6WifKMG2
	 gh1V5xEEIy9jECtkpExskL33+bhy82ETGBU7hbmEoEGMpmALKALDa3hF5i3anZHhG3
	 jVXw8747itRVfwTZvsh4/6M7lMFtHzVL1MAcGeyBOA0lj2Rflt0Cr/LoaF/1k5b43X
	 r6s70MJCK+obsUgmZqZbzwSqcw3Wt8+DvxNsviVfWn0igDvBWICqZ4yqkUwueY0OUR
	 l+77ooG0Rb3eQ==
Date: Sat, 26 Apr 2025 15:49:32 -0700
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
Subject: Re: [PATCH v9 08/24] dma-mapping: add a dma_need_unmap helper
Message-ID: <aA1i_HJ1eimihSI2@bombadil.infradead.org>
References: <cover.1745394536.git.leon@kernel.org>
 <e55ceb86c6529a276484e13b0e6ea58764daf854.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e55ceb86c6529a276484e13b0e6ea58764daf854.1745394536.git.leon@kernel.org>

On Wed, Apr 23, 2025 at 11:12:59AM +0300, Leon Romanovsky wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Add helper that allows a driver to skip calling dma_unmap_*
> if the DMA layer can guarantee that they are no-nops.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

