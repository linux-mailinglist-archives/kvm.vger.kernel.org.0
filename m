Return-Path: <kvm+bounces-44384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 784C7A9D6A6
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 02:22:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2EA04C80DF
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 00:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3881C1E1E09;
	Sat, 26 Apr 2025 00:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uSx9KLDJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F89613B284;
	Sat, 26 Apr 2025 00:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745626922; cv=none; b=AB3y6iaPDAcs8fgGNuphYafoTk39BKpQK1UzKrjo4Wjd/RKntNszLOc1ekBUZxXUdzrwl/7vNK3U6eOpAFrK4oiCfJyeytrs7S3eY3b0fyuOdNWS8gat4T4kxLH2qp/ARlflcbOQ6HVGXYWOcB2MEuqe9bfAw+azAfsmwVXldQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745626922; c=relaxed/simple;
	bh=h50G9mpEZaBwJcj8NBjbBVE9qsIsc9fyuWGRd2gmBsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=clCqOeqgKlcM+8L7v01XLLF+7qZfuwoVawcdhz13G/HRJsNZn5uXQsKeXCyorV6usIB762d+7hk4oRvcEzvLh1xYSoC76seolUcJvjSGaKyj++4lvlDfyQnnijLWhHxjyvP4rpsUZJykhlVMKV7zTdhPjEP2Q7iRNloQ3WyxvcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uSx9KLDJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A96C4CEE4;
	Sat, 26 Apr 2025 00:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745626921;
	bh=h50G9mpEZaBwJcj8NBjbBVE9qsIsc9fyuWGRd2gmBsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uSx9KLDJxnN6lYn0LOZiC4gIIRTMcevzUKTtv7QtHq94vnzWzXAWCWK4YS8t/lvCv
	 alHXKJFiqiZH5uLDlN+4stNQPEDcFlWuzLtnpyGxFQaHCXmY/sJ3NasmNfPQ10XOsD
	 wUw2k76EwWqC8e0qBP5fC1orpyG4CQVrSTzu1rraBPS49Yf+gV2ATcRoe77STUECZ4
	 KJl2G7PvDJa9oNMl3b9jsvgxkMxCD7AlH1dhdpNSZwOELkRM++Hgq3UOE+eTSBx7Az
	 pefT0sVbAaXyzhhHb4ziaDfP3nFsriO8NgoukTNrsqDiCzAfPrcBbyGzvg66JNeo6z
	 O2DMUdv81udLg==
Date: Fri, 25 Apr 2025 17:21:59 -0700
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
Subject: Re: [PATCH v9 01/24] PCI/P2PDMA: Refactor the p2pdma mapping helpers
Message-ID: <aAwnJwLeOs7rfkHL@bombadil.infradead.org>
References: <cover.1745394536.git.leon@kernel.org>
 <3a962f9039f0265de939f4c81924ee8208fc93a6.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a962f9039f0265de939f4c81924ee8208fc93a6.1745394536.git.leon@kernel.org>

On Wed, Apr 23, 2025 at 11:12:52AM +0300, Leon Romanovsky wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> The current scheme with a single helper to determine the P2P status
> and map a scatterlist segment force users to always use the map_sg
> helper to DMA map, which we're trying to get away from because they
> are very cache inefficient.
> 
> Refactor the code so that there is a single helper that checks the P2P
> state for a page, including the result that it is not a P2P page to
> simplify the callers, and a second one to perform the address translation
> for a bus mapped P2P transfer that does not depend on the scatterlist
> structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Tested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Might make it easier for patch review to split off adding
__pci_p2pdma_update_state() in a seprate patch first. Other than that,
looks good.

Reviewed-by: Luis Chamberlain <mcgrof@kenrel.org>

  Luis

