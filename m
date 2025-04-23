Return-Path: <kvm+bounces-43973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5260AA99385
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:59:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A600D7AAF2E
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0042980A4;
	Wed, 23 Apr 2025 15:47:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B4F296D05;
	Wed, 23 Apr 2025 15:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745423240; cv=none; b=DfVx9em+BQayu6b50vimGdhj2TQJ1ahPDRW4GMRrahnaAOCSZ4yNg6m0QIdKcC3fkfFL3TD50PRL1035cNKmli4q2S5YRDrNfod0w5lIhe7fPeEmjCZmZN5LU5HfHCfbwrF6mZVINusEXsV67p/z6OmeQ+7hopalwX2piOmh/xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745423240; c=relaxed/simple;
	bh=d0E+HtNmdn/LhlxxF/h1C5SJbuFpS6D0hMGAOAoU4xM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rrkh6bFRR5ynbbwrsgCDcgOccElvNR8M494sc0lAf50mG07s1SBBKdBzPdNA3agjI5YSvJsplYRxi8XG/de6A9LeX7Tbx2LfkgNQejx1LwnSKI1BjlNDW6yeMns++hORZ0Vy/gCq+2vf05xB9esRKM4FpKDhkB5FqU6N0CBij8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8A79D68C4E; Wed, 23 Apr 2025 17:47:12 +0200 (CEST)
Date: Wed, 23 Apr 2025 17:47:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
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
Message-ID: <20250423154712.GA32009@lst.de>
References: <cover.1745394536.git.leon@kernel.org> <7c5c5267cba2c03f6650444d4879ba0d13004584.1745394536.git.leon@kernel.org> <20250423092437.GA1895@lst.de> <20250423100314.GH48485@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423100314.GH48485@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 23, 2025 at 01:03:14PM +0300, Leon Romanovsky wrote:
> On Wed, Apr 23, 2025 at 11:24:37AM +0200, Christoph Hellwig wrote:
> > I don't think the meta SGL handling is quite right yet, and the
> > single segment data handling also regressed.  Totally untested
> > patch below, I'll try to allocate some testing time later today.
> 
> Christoph,
> 
> Can we please progress with the DMA patches and leave NVMe for later?
> NVMe is one the users for new DMA API, let's merge API first.

We'll need to merge the block/nvme patches through the block tree
anyway to avoid merges from hell, so yes.


