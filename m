Return-Path: <kvm+bounces-44489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42111A9E051
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 09:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CA331899F86
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 07:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1019A246327;
	Sun, 27 Apr 2025 07:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M96skoYC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F43B173;
	Sun, 27 Apr 2025 07:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745737833; cv=none; b=C6j1/ZlAv9na6uhfYAI06H53qIjhyqzh/v0lg4INQRC043yroqIDqHEa6+RRgXGDZ9b6BYY41gwH0MkxzLo8iSuOmtc/CTK7mtiUbQ193yMsFFqpr9kJBqRDQzJMPDBgzyvqvMCz/pgOEDxLOg7zjt2DJgLaPl/hnOZUwWn4nnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745737833; c=relaxed/simple;
	bh=CGnsiRcgcTLWNshlRKt3+TY3846/zeQqAZXDX5kQlSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LqkWi8+P2ZDAkrg1g3/cQELePi0zNRNAsMgpWyC/+fYJMcSxojzW6zQQueR8s8sTOupZz7FFn3t7G/VbGTFyv0Os2qAP/5aWFDlG0+aA6seBOPhMDYiimwozYy/gYyc8NOn/ACxl7+7NitRrn1i0mRhviqnx5kiQ5mG8+kWPiO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M96skoYC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7284DC4CEE3;
	Sun, 27 Apr 2025 07:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745737832;
	bh=CGnsiRcgcTLWNshlRKt3+TY3846/zeQqAZXDX5kQlSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M96skoYCIAliV9mE/cHFjQyXeYgIKCso7ocEVoV4QwsavwZFE3rfEM0dziGcjOR6b
	 7kjkhtEE/0EQdgXtARUS6cI7T75h7ppRVSbbVbM6R6qxPwg9Sg1vSFr6VbnyOZQ57g
	 o/iTgqG/YLNmmypwMR2+p+Nr3hxoD01W7r5hdZeZwzGeiH97kZ/4Ut5fcVkg1wzjts
	 hXvK19kK7wEZSW5jdM0EDEgy9k/RevkU6uLUiXDosGVulyNXnwwR8BBoNXzP3d0oXt
	 HjLpbmZL7Uu8naYplITM7UrID84hix6jY7jTs9NC+PEEEgVOxLpTdYZy8aECiq9kdG
	 KVcDCKntZyoxA==
Date: Sun, 27 Apr 2025 10:10:26 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Jake Edge <jake@lwn.net>,
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
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH v9 23/24] nvme-pci: convert to blk_rq_dma_map
Message-ID: <20250427071026.GA5848@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <7c5c5267cba2c03f6650444d4879ba0d13004584.1745394536.git.leon@kernel.org>
 <20250423092437.GA1895@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423092437.GA1895@lst.de>

On Wed, Apr 23, 2025 at 11:24:37AM +0200, Christoph Hellwig wrote:
> I don't think the meta SGL handling is quite right yet, and the
> single segment data handling also regressed.  

If my testing is correct, my dma-split-wip branch passes all tests,
including single segment.

Thanks

