Return-Path: <kvm+bounces-19352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A004B904442
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 21:11:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04820B23068
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 19:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C52E613D615;
	Tue, 11 Jun 2024 19:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qGeF1z59"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2359171A5;
	Tue, 11 Jun 2024 19:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718133087; cv=none; b=aAl1mBLtEccDBiNjrVuMmfSNwRvbInlxLbXHO2tF9D41sxlG/A7AEPsyroJNHqW5VWF0l5wkdNG14lokUwC7pt11AccYS2AKJmySuMylc1WAmanDUJ2JnUlr/oIqQPsYs9rpAYYl935mwmcvpc7Y2xkGNRnUnWEu/T2yjjx9+5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718133087; c=relaxed/simple;
	bh=VL91sYxrS8ClC4b8/FdOk7/0y+PMB1c26MCrYyZDHlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K/jDjmlCSzn7BIMClUn0K44ejEwcc7jNmGOfYeVZNCQgihyzZTgpyOYxNIeGiQoEMjHZjR3AUnL/Gd0DlEFOKDrpgUZ7fe00um1XaLoP/jaLemcieSOM3Ex6Im/4S4Eil07NauywxHJChXg9MvWSnbx4IDboqCzsoZtnB9gmfSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qGeF1z59; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2943C4AF48;
	Tue, 11 Jun 2024 19:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718133086;
	bh=VL91sYxrS8ClC4b8/FdOk7/0y+PMB1c26MCrYyZDHlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qGeF1z59jrpZ1RnFDkbFTHlzMrh2tlbdyzzMeTbp/apFSEEZTKtHkH+3loP9CksbW
	 En1EFU2PvaPwg8kwPv58hUH/00Z1iJaK+TYLFlY7jq60EmSHn58BFrPjyBuLSg6kUy
	 szjRV8n4ki19tOLkxEzrvNUz/1FvmLxUyHFx8FXvupsoPReOnwziyyb2DWhwA8gLT0
	 rcx8zCFMkZDVxz7DB+vMIFm9V2odi09cuXNc6Wz54by/flNmIEo+NsJWB8ixRZyOOy
	 ZaePydnV8sQeml50d7Nyw2E27Fj9eEs+p6aDVCIPkBDnMmJmhcJStvrDcHXQWZUDvZ
	 +Q+PdkPi3MXew==
Date: Tue, 11 Jun 2024 22:11:21 +0300
From: Leon Romanovsky <leon@kernel.org>
To: "Zeng, Oak" <oak.zeng@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	"Brost, Matthew" <matthew.brost@intel.com>,
	"Hellstrom, Thomas" <thomas.hellstrom@intel.com>,
	Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"jack@suse.com" <jack@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
	"Bommu, Krishnaiah" <krishnaiah.bommu@intel.com>,
	"Ghimiray, Himal Prasad" <himal.prasad.ghimiray@intel.com>
Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
Message-ID: <20240611191121.GD4966@unreal>
References: <cover.1709635535.git.leon@kernel.org>
 <SA1PR11MB6991CB2B1398948F4241E51992182@SA1PR11MB6991.namprd11.prod.outlook.com>
 <20240503164239.GB901876@ziepe.ca>
 <PH7PR11MB70047236290DC1CFF9150B8592C62@PH7PR11MB7004.namprd11.prod.outlook.com>
 <20240610161826.GA4966@unreal>
 <PH7PR11MB7004A071F27B4CF45740B87E92C62@PH7PR11MB7004.namprd11.prod.outlook.com>
 <20240610172501.GJ791043@ziepe.ca>
 <PH7PR11MB7004DDE9816D92F690A5C0B692C62@PH7PR11MB7004.namprd11.prod.outlook.com>
 <20240611154515.GC4966@unreal>
 <SA1PR11MB69915818E4DC6FFAD620D62C92C72@SA1PR11MB6991.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SA1PR11MB69915818E4DC6FFAD620D62C92C72@SA1PR11MB6991.namprd11.prod.outlook.com>

On Tue, Jun 11, 2024 at 06:26:23PM +0000, Zeng, Oak wrote:
> Thank you Leon. That is helpful.
> 
> I also have another very naïve question. I don't understand what is the iova address. I previously thought the iova address space is the same as the dma_address space when iommu is involved. I thought the dma_alloc_iova would allocate some contiguous iova address range and later dma_link_range function would link a physical page to the iova address and return the iova address. In other words, I thought the dma_address is iova address, and the iommu page table translate a dma_address or iova address to the physical address.

This is right understanding.

> 
> But from my print below, my above understanding is obviously wrong: the iova.dma_addr is 0 and the dma_address returned from dma_link_range is none zero... Can you help me what is iova address? Is iova address iommu related? Since dma_link_range returns a non-iova address, does this function allocate the dma-address itself? Is dma-address correlated with iova address?

This is a combination of two things:
1. Need to support HMM specific logic
2. Outcome of v0 version where I implemented dma_link_range() to perform fallback to DMA direct mode. See patch 2 and 3.
https://lore.kernel.org/all/54a3554639bfb963c9919c5d7c1f449021bebdb3.1709635535.git.leon@kernel.org/
https://lore.kernel.org/all/f1049f0fc280288ae2f0c1e02388cde91b0f7876.1709635535.git.leon@kernel.org/

So dma-iova == 0 means that you are working in direct mode and not with IOMMU, e.g. you can translate from physical address
to DMA address by simple call to phys_to_dma().

One of the comments was that it is not desired behaviour and I need to
create separate functions that will be in use only when IOMMU is used.

See the difference between v0 and v1 for dma_link_range() function.
v0: https://lore.kernel.org/all/f1049f0fc280288ae2f0c1e02388cde91b0f7876.1709635535.git.leon@kernel.org/
v1: https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=dma-split-v1&id=5aa29f2620ef86ac58c17a0297929a0b9e8d7790

And HMM variant of dma_link_range() function, which saves from you the
need to copy/paste same HMM logic from RDMA to DRM.
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=dma-split-v1&id=4d8d8d4fbe7891b1412f03ecaff88bc492e2e4eb

Thanks

> 
> Oak 
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Tuesday, June 11, 2024 11:45 AM
> > To: Zeng, Oak <oak.zeng@intel.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Christoph Hellwig <hch@lst.de>; Robin
> > Murphy <robin.murphy@arm.com>; Marek Szyprowski
> > <m.szyprowski@samsung.com>; Joerg Roedel <joro@8bytes.org>; Will
> > Deacon <will@kernel.org>; Chaitanya Kulkarni <chaitanyak@nvidia.com>;
> > Brost, Matthew <matthew.brost@intel.com>; Hellstrom, Thomas
> > <thomas.hellstrom@intel.com>; Jonathan Corbet <corbet@lwn.net>; Jens
> > Axboe <axboe@kernel.dk>; Keith Busch <kbusch@kernel.org>; Sagi
> > Grimberg <sagi@grimberg.me>; Yishai Hadas <yishaih@nvidia.com>;
> > Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>; Tian, Kevin
> > <kevin.tian@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
> > Jérôme Glisse <jglisse@redhat.com>; Andrew Morton <akpm@linux-
> > foundation.org>; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-block@vger.kernel.org; linux-rdma@vger.kernel.org;
> > iommu@lists.linux.dev; linux-nvme@lists.infradead.org;
> > kvm@vger.kernel.org; linux-mm@kvack.org; Bart Van Assche
> > <bvanassche@acm.org>; Damien Le Moal
> > <damien.lemoal@opensource.wdc.com>; Amir Goldstein
> > <amir73il@gmail.com>; josef@toxicpanda.com; Martin K. Petersen
> > <martin.petersen@oracle.com>; daniel@iogearbox.net; Williams, Dan J
> > <dan.j.williams@intel.com>; jack@suse.com; Zhu Yanjun
> > <zyjzyj2000@gmail.com>; Bommu, Krishnaiah
> > <krishnaiah.bommu@intel.com>; Ghimiray, Himal Prasad
> > <himal.prasad.ghimiray@intel.com>
> > Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to
> > two steps
> > 
> > On Mon, Jun 10, 2024 at 09:28:04PM +0000, Zeng, Oak wrote:
> > > Hi Jason, Leon,
> > >
> > > I was able to fix the issue from my side. Things work fine now. I got two
> > questions though:
> > >
> > > 1) The value returned from dma_link_range function is not contiguous, see
> > below print. The "linked pa" is the function return.
> > > I think dma_map_sgtable API would return some contiguous dma address.
> > Is the dma-map_sgtable api is more efficient regarding the iommu page table?
> > i.e., try to use bigger page size, such as use 2M page size when it is possible.
> > With your new API, does it also have such consideration? I vaguely
> > remembered Jason mentioned such thing, but my print below doesn't look
> > like so. Maybe I need to test bigger range (only 16 pages range in the test of
> > below printing). Comment?
> > 
> > My API gives you the flexibility to use any page size you want. You can
> > use 2M pages instead of 4K pages. The API doesn't enforce any page size.
> > 
> > >
> > > [17584.665126] drm_svm_hmmptr_map_dma_pages iova.dma_addr = 0x0,
> > linked pa = 18ef3f000
> > > [17584.665146] drm_svm_hmmptr_map_dma_pages iova.dma_addr = 0x0,
> > linked pa = 190d00000
> > > [17584.665150] drm_svm_hmmptr_map_dma_pages iova.dma_addr = 0x0,
> > linked pa = 190024000
> > > [17584.665153] drm_svm_hmmptr_map_dma_pages iova.dma_addr = 0x0,
> > linked pa = 178e89000
> > >
> > > 2) in the comment of dma_link_range function, it is said: " @dma_offset
> > needs to be advanced by the caller with the size of previous page that was
> > linked + DMA address returned for the previous page".
> > > Is this description correct? I don't understand the part "+ DMA address
> > returned for the previous page ".
> > > In my codes, let's say I call this function to link 10 pages, the first
> > dma_offset is 0, second is 4k, third 8k. This worked for me. I didn't add the
> > previously returned dma address.
> > > Maybe I need more test. But any comment?
> > 
> > You did it perfectly right. This is the correct way to advance dma_offset.
> > 
> > Thanks
> > 
> > >
> > > Thanks,
> > > Oak
> > >
> > > > -----Original Message-----
> > > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > > Sent: Monday, June 10, 2024 1:25 PM
> > > > To: Zeng, Oak <oak.zeng@intel.com>
> > > > Cc: Leon Romanovsky <leon@kernel.org>; Christoph Hellwig
> > <hch@lst.de>;
> > > > Robin Murphy <robin.murphy@arm.com>; Marek Szyprowski
> > > > <m.szyprowski@samsung.com>; Joerg Roedel <joro@8bytes.org>; Will
> > > > Deacon <will@kernel.org>; Chaitanya Kulkarni <chaitanyak@nvidia.com>;
> > > > Brost, Matthew <matthew.brost@intel.com>; Hellstrom, Thomas
> > > > <thomas.hellstrom@intel.com>; Jonathan Corbet <corbet@lwn.net>;
> > Jens
> > > > Axboe <axboe@kernel.dk>; Keith Busch <kbusch@kernel.org>; Sagi
> > > > Grimberg <sagi@grimberg.me>; Yishai Hadas <yishaih@nvidia.com>;
> > > > Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>; Tian,
> > Kevin
> > > > <kevin.tian@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
> > > > Jérôme Glisse <jglisse@redhat.com>; Andrew Morton <akpm@linux-
> > > > foundation.org>; linux-doc@vger.kernel.org; linux-
> > kernel@vger.kernel.org;
> > > > linux-block@vger.kernel.org; linux-rdma@vger.kernel.org;
> > > > iommu@lists.linux.dev; linux-nvme@lists.infradead.org;
> > > > kvm@vger.kernel.org; linux-mm@kvack.org; Bart Van Assche
> > > > <bvanassche@acm.org>; Damien Le Moal
> > > > <damien.lemoal@opensource.wdc.com>; Amir Goldstein
> > > > <amir73il@gmail.com>; josef@toxicpanda.com; Martin K. Petersen
> > > > <martin.petersen@oracle.com>; daniel@iogearbox.net; Williams, Dan J
> > > > <dan.j.williams@intel.com>; jack@suse.com; Zhu Yanjun
> > > > <zyjzyj2000@gmail.com>; Bommu, Krishnaiah
> > > > <krishnaiah.bommu@intel.com>; Ghimiray, Himal Prasad
> > > > <himal.prasad.ghimiray@intel.com>
> > > > Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to
> > > > two steps
> > > >
> > > > On Mon, Jun 10, 2024 at 04:40:19PM +0000, Zeng, Oak wrote:
> > > > > Thanks Leon and Yanjun for the reply!
> > > > >
> > > > > Based on the reply, we will continue use the current version for
> > > > > test (as it is tested for vfio and rdma). We will switch to v1 once
> > > > > it is fully tested/reviewed.
> > > >
> > > > I'm glad you are finding it useful, one of my interests with this work
> > > > is to improve all the HMM users.
> > > >
> > > > Jason
> 

