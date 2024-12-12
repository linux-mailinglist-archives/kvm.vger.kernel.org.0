Return-Path: <kvm+bounces-33571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8DDF9EE201
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 09:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62ED41888DDA
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 08:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 439CF20E32D;
	Thu, 12 Dec 2024 08:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ojj28dCC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF91204C1D;
	Thu, 12 Dec 2024 08:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733993697; cv=none; b=sJZEOsjdS3tGEskKn8wPdMuzWVtBcKvkgru15bMqHF8UHt2tYyXbDCSAan3bqk+rNbBI9ezHROcQDaQsZlZDDBYxHrJAfk19bifIqOaKQ0irlWOJCs79XxFOhWksz99GdEfT4XJuIKZAoI0Lpiw5EkbNrBlD1PpfpOLy6hD0tkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733993697; c=relaxed/simple;
	bh=Fy4YngrVcpagRsu5yXaXhy6khObq1+63mtDUkXZu0Hs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQ2wKUH+T7OjfNi/2jo8pes7/nQNW0dIYlRGh3kSL9F8Qau7LkxTW02S5/YTajzQLPMkVae3yiyESHD7kb16wtlBt9yKds/u4UTS+WGA9rHDPK+V+CjC8O17UZQrEO7f1tFEQtj2LHHGy/M3q72LLQ+qDNxxZBfDBEyzEA0Ei9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ojj28dCC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6C8C4CECE;
	Thu, 12 Dec 2024 08:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733993696;
	bh=Fy4YngrVcpagRsu5yXaXhy6khObq1+63mtDUkXZu0Hs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ojj28dCCyJsYWCQ3nZtMUHqqKD7pLZ/ITymNq/65CKEPSxvMwaKmSBEcXxLYPPKy0
	 bCCF3nZPaJ7k//9SBQ/rYhvwJimsjRdm+91sZWCtORRbzPjDtteY0DSoFIUcv1x+Lr
	 1CBtlVjnuOx8tTbgfpy+LEAsfWvTLFFTYZp7gkMuh4x2UvzAENWOExWVLSc4743UO9
	 JCTRe0c+Y4hkv7hgXehu2a9IN4oO88rQf5qeTV3yngqTzQ8uA8ZEtTJYYWl8RkEd5C
	 CPaD72/jVRnOkLoezb3tHNft0IcASYCJ/ywixjCc6QTi7fbpx3tk7LTpPjb2MxQzXP
	 gZjbGel83uyhg==
Date: Thu, 12 Dec 2024 10:54:52 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v4 11/18] mm/hmm: let users to tag specific PFN with DMA
 mapped bit
Message-ID: <20241212085452.GI1245331@unreal>
References: <cover.1733398913.git.leon@kernel.org>
 <e4551571fc10d9c73ab9e38a75ea701c1b492686.1733398913.git.leon@kernel.org>
 <20241212084856.GE9376@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212084856.GE9376@lst.de>

On Thu, Dec 12, 2024 at 09:48:56AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 05, 2024 at 03:21:10PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Introduce new sticky flag (HMM_PFN_DMA_MAPPED), which isn't overwritten
> > by HMM range fault. Such flag allows users to tag specific PFNs with information
> > if this specific PFN was already DMA mapped.
> 
> Missing line wrap at 73 characters here.
> 
> >  
> > @@ -253,14 +262,14 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
> >  			cpu_flags = HMM_PFN_VALID;
> >  			if (is_writable_device_private_entry(entry))
> >  				cpu_flags |= HMM_PFN_WRITE;
> > -			*hmm_pfn = swp_offset_pfn(entry) | cpu_flags;
> > +			*hmm_pfn = (*hmm_pfn & HMM_PFN_INOUT_FLAGS) | swp_offset_pfn(entry) | cpu_flags;
> 
> Please avoid the overly long line here.
> 
> That being said I hate the structure here.  Can't we just have a local
> variable for the actual new pfn value, and then a single goto label
> at the end that takes the keeper flags from the argument and assigning
> the new out value to *hmm_pfn instead of duplicating this in half a
> dozen places?

Yes, sure, it makes sense, will do.

> 

