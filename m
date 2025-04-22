Return-Path: <kvm+bounces-43744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 88898A95D08
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 06:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 839047A9984
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 04:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33DF19D8B7;
	Tue, 22 Apr 2025 04:40:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2EA186E40;
	Tue, 22 Apr 2025 04:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745296806; cv=none; b=oc4JqcOKb3zNuf/eqzKihL5YU/6lXYPm2P5hB+AlIAT1mRT51q/5hq5fgk193cbOwLQ/mJ16NU2SSVXM1vO+rwSJ/HIK4vLfQeClPLQYH4XZQeFnMB/SY+f9QWmTbw4yLtRxU22wPAL5yDg6RakLUOmn4S11CZkGAwDv3UlJmwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745296806; c=relaxed/simple;
	bh=CpQQRZuyWfvKRbSY9l+oYTtKKd/SUjT2q+YM4GZSr6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QELs/JkBS25XsACH7L6moom0efRANZONpE/sNyhs2g8WYIAem/geWK0P0z/QSO86zX1HjujNjxA9Bpf2dfa7JUc4wt+XcGWpOkgqCYBec/F8ulZF8KQzUxMtRntvxAP08gujIS/qsBeMG4bprh+U87mJGS8FJqu6kZEcVvaXv08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 89EBF68BFE; Tue, 22 Apr 2025 06:39:56 +0200 (CEST)
Date: Tue, 22 Apr 2025 06:39:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Kanchan Joshi <joshi.k@samsung.com>, Jake Edge <jake@lwn.net>,
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
	Chaitanya Kulkarni <kch@nvidia.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH v8 24/24] nvme-pci: optimize single-segment handling
Message-ID: <20250422043955.GA28077@lst.de>
References: <cover.1744825142.git.leon@kernel.org> <670389227a033bd5b7c5aa55191aac9943244028.1744825142.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <670389227a033bd5b7c5aa55191aac9943244028.1744825142.git.leon@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 18, 2025 at 09:47:54AM +0300, Leon Romanovsky wrote:
> From: Kanchan Joshi <joshi.k@samsung.com>
> 
> blk_rq_dma_map API is costly for single-segment requests.
> Avoid using it and map the bio_vec directly.

This needs to be folded into the earlier patches or split prep patches
instead of undoing work done earlier, preferably combined with a bit
of code movement so that the new nvme_try_setup_prp_simple stays in
the same place as before and the diff shows it reusing code.

E.g. change

"nvme-pci: use a better encoding for small prp pool allocations" to
already use the flags instead of my boolean, and maybe include 
abort in the flags instead of using a separate bool so that we
don't increase hte iod size.

Slot in a new patch after that that dropping the single SGL segment
fastpath if we think we don't need that, although if we need the PRP
one I suspect that one would still be very helpful as well.

Add a patch if we want the try_ version of, although when keeping
the optimization for SGLs as well that are will look a bit different.

I'm happy to give away my patch authorship credits if that helps with
the folding.

