Return-Path: <kvm+bounces-31878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE5709C906D
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 18:03:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B34C1F2175A
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EFDC18A930;
	Thu, 14 Nov 2024 17:02:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118E7126C03;
	Thu, 14 Nov 2024 17:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731603774; cv=none; b=l4GlxCOB0X8dzK6SiBc+myppYKIp1VTn7jhuGDmAUBPbvZvvWMwh1OaYS/Ma0FrUQxk6EIxPA1vx4eRJN2BpEUSAE2wjhU8dLt2FQFOxhPrJluZrRA/eh+lxAeEBi358u5bYbhAvIUaMjd//0MSh/xiBF1gbugIGqPBhGfgC0ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731603774; c=relaxed/simple;
	bh=36OSqPoAQyVIULHWPhuhVBJ+iSHV5/kk5o+So/6AzXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jOEKx1njhCp0EuP66mEtEnZH17Wj2uaQEjaZDeITbB6fJjgO/3trOVgjb/mREhysx9tNIoVj+Ep0DvWnIvsEiyiPjWt0dsR4g5zabiEYmDrHTLgb7DQwpcApsoGWD8TWSYc/Q2CGWL0Dc+YZY6k/GfCddR1baEkSoxQ+aws9Hzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 51BBB68C7B; Thu, 14 Nov 2024 18:02:47 +0100 (CET)
Date: Thu, 14 Nov 2024 18:02:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>,
	Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>, ill Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
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
Subject: Re: [PATCH v3 00/17] Provide a new two step DMA mapping API
Message-ID: <20241114170247.GA5813@lst.de>
References: <cover.1731244445.git.leon@kernel.org> <20241112072040.GG71181@unreal> <20241114133011.GA606631@unreal> <20241114163622.GA3121@lst.de> <20241114164823.GB606631@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114164823.GB606631@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 14, 2024 at 06:48:23PM +0200, Leon Romanovsky wrote:
> It is fine, but as a bare minimum, I would expect some sort of response,
> so I won't sit and wait for unknown date when this API will be acknowledged/NACKed.
> 
> I would like to start to work on next step, e.g removing SG from RDMA,
> and I need to know if this foundation is stable to do so.
> 
> > 
> > No changs to dma-iommu.c are going to get merged without an explicit
> > ACK from Robin, and while there is no 100% for the core dma-mapping
> > code I will also not merge anything that hasn't been resolved with
> > my most trusted reviewer first, not even code I wrote myself.
> 
> And do you know what is not resolved here? I don't.
> All technical questions/issues were handled.

Let's just wait a little bit, we're all overworked can't instantly
context switch.


