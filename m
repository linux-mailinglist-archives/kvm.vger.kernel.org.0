Return-Path: <kvm+bounces-43695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DC4AA946FC
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 09:10:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E759175369
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 07:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 535021EEA3B;
	Sun, 20 Apr 2025 07:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RDz9qVfp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC9A1EDA27;
	Sun, 20 Apr 2025 07:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745132992; cv=none; b=Wq+dCA2qI5tTq5LkoU1VgacLUtKSHJ5d25cgtvsZ5uIo5icHH9cKdmyjqCCAdlX16XGc9qYnhWAI3lVjJfymyg3uxXSSUmGFH3GXSQPxNNGf5K2XOi6i88+wVxoT2ivpEUCZ9Xww0Ij6yT3EHEW2YdwhplMnih3fPwY93DysTv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745132992; c=relaxed/simple;
	bh=DnPJAtQCAT1601If/hRz83wTZ4UHqcQsShHrfo6H7rM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hNT2VaoMwH/yFx+hEwwhHAISx952WB6Zkjmh2hXQXi2d0kw5+qSM0Pb+sJUAvqZWu9rQcOlvCMgWxJvrofwfu4gdfCEwir364NAX3G3/a8V9FKWrJyKNtjsAjzIgtaCxEr2vQhf1c37dOkoAGpa7h0TulajmXKwaRuuMV0P8kPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RDz9qVfp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858A7C4CEE2;
	Sun, 20 Apr 2025 07:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745132991;
	bh=DnPJAtQCAT1601If/hRz83wTZ4UHqcQsShHrfo6H7rM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RDz9qVfpkRY4EAI36WaskxJdBPEHUlHFbAqFkCaVljTQw2lc/CZWqFZnCOm8MUu+u
	 UrnadqItcqjJX8psssUB220xLgoCNkTErsCMMfM+LcQNv/lN9+7iyBAixDzSSYRERs
	 9QvymfQ6DxqnBDFAPnDfrK3vcmVwiHkXZQebyeCwLRbHisYArdA1/1Ng8W7pTvxGdN
	 ExFInLH9/9MK/zmr0slhL5h+cLRxxF3IiVZqx3CiPDDOuIqmNXHF3wJ8GD6rscX14G
	 v8WEpFME6iQdRojmcM1vpWqjFnfXt8wLrQZoE00EvORp7GOiurN3OrarLMgd6b2C6G
	 j2uwfP3dJ++Dg==
Date: Sun, 20 Apr 2025 10:09:46 +0300
From: Leon Romanovsky <leon@kernel.org>
To: ALOK TIWARI <alok.a.tiwari@oracle.com>
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
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v8 20/24] blk-mq: add scatterlist-less DMA mapping helpers
Message-ID: <20250420070946.GA10635@unreal>
References: <cover.1744825142.git.leon@kernel.org>
 <87b151a3791d71e58ec6f1b42bcf5fe06304cf80.1744825142.git.leon@kernel.org>
 <65b0070e-3386-4725-8e8a-15b0409b8368@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65b0070e-3386-4725-8e8a-15b0409b8368@oracle.com>

On Fri, Apr 18, 2025 at 11:33:09PM +0530, ALOK TIWARI wrote:
> 
> 
> > + * Start DMA mapping @req to @dma_dev.  @state and @iter are provided by the
> > + * caller and don't need to be initialized.  @state needs to be stored for use
> > + * at unmap time, @iter is only needed at map time.
> > + *
> > + * Returns %false if there is no segment to map, including due to an error, or
> > + * %true it it did map a segment.
> 
> typo - it it -> if it

Thanks, will fix all types on my dma-split-wip branch.

