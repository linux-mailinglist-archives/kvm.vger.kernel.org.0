Return-Path: <kvm+bounces-43820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D48AA967DE
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 13:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBE3E3A95CC
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 11:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9F427D79B;
	Tue, 22 Apr 2025 11:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJq30b87"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6271B27CCF2;
	Tue, 22 Apr 2025 11:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745321810; cv=none; b=rXW2JnlFqS1GE72AplJn/I0KLX+ZqEquwboVaZMhfxkLS0+RYepcLEYGvifYOjUZcIRB67ICxYLQhOLAZJnDdG0iEXJZwLeGv0jK5YXibpYo9B6T+v+swGqzQXVwVLhU+zJT+ldk9C7uMjUSTLn5Eg8D969hsLgjKz6f9cK6Eks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745321810; c=relaxed/simple;
	bh=r6X7KW5xA2Bid9qqNeraU4aDSG9uP20Keu4UbEk1LHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j2UBD4KbZg/6raQShqix+QodTHMA0rZe1f6UY2I/2MT7hzqNwYMTX+NA/gdcA+pVpymO8Iej9DdwWdByFcHJg8TLr6SjhSLtw5qOmBavLfDxCDFZmS+nkzZhbpNVUHesk1JkGQumKIixljgC1LepiSbzz2jCYN+/tYmd1TZQh2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJq30b87; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA605C4CEE9;
	Tue, 22 Apr 2025 11:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745321809;
	bh=r6X7KW5xA2Bid9qqNeraU4aDSG9uP20Keu4UbEk1LHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FJq30b87/TflnB9DVVipFNU57Znk7OWclwNiEv1U1CkREJE7TpnQD5/hqoZtIuTZJ
	 dTPGGSPbMLaLEb2zNkLd3Q778H6VAa8OOBofqBahNpMdxezfgyVohmR6Rd9GiEqit6
	 rqQQDP3Pc8mFmUp7rVwkCwExrNjkUbpZzr5cC8mMpJGiZVgmXx+K5vas3ebglhBMWf
	 RVeOeSh6BNTXES/fWcmFmi51oMgzzUf4ye8EeNe7AB8tBKDLrYmlZv3p0jO5PK+S/3
	 YSBQMCWgd1JztmQ+CpvrmAO4qjEfa68n3WyOSSCxk7QhEyBqnidI1p8GTad9JjjkB8
	 RxKZi4poFx/gQ==
Date: Tue, 22 Apr 2025 14:36:43 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
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
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH v8 24/24] nvme-pci: optimize single-segment handling
Message-ID: <20250422113643.GE48485@unreal>
References: <cover.1744825142.git.leon@kernel.org>
 <670389227a033bd5b7c5aa55191aac9943244028.1744825142.git.leon@kernel.org>
 <20250422043955.GA28077@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422043955.GA28077@lst.de>

On Tue, Apr 22, 2025 at 06:39:56AM +0200, Christoph Hellwig wrote:
> On Fri, Apr 18, 2025 at 09:47:54AM +0300, Leon Romanovsky wrote:
> > From: Kanchan Joshi <joshi.k@samsung.com>
> > 
> > blk_rq_dma_map API is costly for single-segment requests.
> > Avoid using it and map the bio_vec directly.
> 
> This needs to be folded into the earlier patches or split prep patches
> instead of undoing work done earlier, preferably combined with a bit
> of code movement so that the new nvme_try_setup_prp_simple stays in
> the same place as before and the diff shows it reusing code.
> 
> E.g. change
> 
> "nvme-pci: use a better encoding for small prp pool allocations" to
> already use the flags instead of my boolean, and maybe include 
> abort in the flags instead of using a separate bool so that we
> don't increase hte iod size.
> 
> Slot in a new patch after that that dropping the single SGL segment
> fastpath if we think we don't need that, although if we need the PRP
> one I suspect that one would still be very helpful as well.
> 
> Add a patch if we want the try_ version of, although when keeping
> the optimization for SGLs as well that are will look a bit different.

I uploaded new tag dma-split-Apr-22 with the changes. At the end, I
decided to keep SGL optimized path too, but didn't create separate
patch for try_* variants as they require block iterator, which is
introduced in conversion patch only.

> 
> I'm happy to give away my patch authorship credits if that helps with
> the folding.

I kept you as an author. Please advise if I need to change it to be someone else.

Thanks

