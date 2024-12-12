Return-Path: <kvm+bounces-33569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5FE9EE1CC
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 09:49:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F6C4281053
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 08:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80EED20E311;
	Thu, 12 Dec 2024 08:49:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975F9202F88;
	Thu, 12 Dec 2024 08:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733993345; cv=none; b=OBdf3T33N3p02SriLUiiWlwypWujv4QncyJyianfrF+8dmLsBdSaPyL8W7kVPVxBIkcks2sias69GoGOm2VEkTgKkb7JDVLvvpBf9BrnqgI5k4TEKokINRjGNXq6aZr5jRGQnxckHaiZXxEq1xHcQxqKgcERNVCMW7P5rKTUdLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733993345; c=relaxed/simple;
	bh=wNfdSZmyat0UwD7526wx2IW+8Fb/6Fxc7sKATjUY7Pc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=so7/uMXLU9em7oTaW7vkuiq62EiEVQ5mBWiBnC9Aw1jEa3G12HDYzo2I8iwygg1ZPti9Omjg/qxz5+eua8rByuDa+/x8MOW3QmLjEzai2xvCL8X0l4w4DuVFL6OxeuXmyXxtSmonmzpkSPPH2+Mx20iSeL1wcjNSCgU46mRUxfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 594C268D1E; Thu, 12 Dec 2024 09:48:57 +0100 (CET)
Date: Thu, 12 Dec 2024 09:48:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Leon Romanovsky <leonro@nvidia.com>,
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
Subject: Re: [PATCH v4 11/18] mm/hmm: let users to tag specific PFN with
 DMA mapped bit
Message-ID: <20241212084856.GE9376@lst.de>
References: <cover.1733398913.git.leon@kernel.org> <e4551571fc10d9c73ab9e38a75ea701c1b492686.1733398913.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4551571fc10d9c73ab9e38a75ea701c1b492686.1733398913.git.leon@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 05, 2024 at 03:21:10PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Introduce new sticky flag (HMM_PFN_DMA_MAPPED), which isn't overwritten
> by HMM range fault. Such flag allows users to tag specific PFNs with information
> if this specific PFN was already DMA mapped.

Missing line wrap at 73 characters here.

>  
> @@ -253,14 +262,14 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>  			cpu_flags = HMM_PFN_VALID;
>  			if (is_writable_device_private_entry(entry))
>  				cpu_flags |= HMM_PFN_WRITE;
> -			*hmm_pfn = swp_offset_pfn(entry) | cpu_flags;
> +			*hmm_pfn = (*hmm_pfn & HMM_PFN_INOUT_FLAGS) | swp_offset_pfn(entry) | cpu_flags;

Please avoid the overly long line here.

That being said I hate the structure here.  Can't we just have a local
variable for the actual new pfn value, and then a single goto label
at the end that takes the keeper flags from the argument and assigning
the new out value to *hmm_pfn instead of duplicating this in half a
dozen places?


