Return-Path: <kvm+bounces-19338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA9C890405E
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 17:45:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62EDD282E4A
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 15:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E76EB3A1AC;
	Tue, 11 Jun 2024 15:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Em6r9Li6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7523839C;
	Tue, 11 Jun 2024 15:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718120721; cv=none; b=k8dDiLxjUVTQhqgbI4Ylwup1VFMw2tfssqT9KNST+pPNydLo4EPYyKLMCdUpl1HvVUu6OwhHRS4aNhEDhJN6Zx7AN2joZOVS9CCg8Lw20e+0quw3Emx3o72rPkK4+5OFxcye/UBJ1QRKmj/kRnP/8BA1QfmObOWr0l3/8MT6B9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718120721; c=relaxed/simple;
	bh=alWpFRyGJPPxpA/qvEhIVLYBDfG5gKLw2O2vjFdIXBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czunXMBSo9nYx1wQ169rUewIPe+WhxELmLSBnbIUgixTW/sVe7I6qhI1aAF0uciXWUg232p8cLB0KOjEPQDbkbEbw11eFheeDqVOgIqbhlr/N+3QwN4pqKnaqvG+ainypWLtptADGcMITxAVlEi6HdbrOqnvCKqlGIuyUy4hy0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Em6r9Li6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EE2C2BD10;
	Tue, 11 Jun 2024 15:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718120719;
	bh=alWpFRyGJPPxpA/qvEhIVLYBDfG5gKLw2O2vjFdIXBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Em6r9Li64MS4dfA1Fm6Omrjb4w5oyfw2XsNlofj9qeCLh5G5cxfGwuZ4yQPTUgZzW
	 6kxO2WwG1YbfeA57p9rgmFg6DOXF7B/o2lriNTV968OIdIJj6h+vJ28mFcLCklf+8k
	 loMrtXfftGiWNK48qosW/nixEPYc2CM6BDV0pD+OBtk1iB7sMjJs6yl/UgKehavFC0
	 ucx5PHa+Nq4Qc5SPa5Zz1cwEjWeiDWr0yVMVZnqrufT33mec/2ulkMu2y2JlMDYEFe
	 LOKNY2IV8maq2WwEhsDrM6P7s8EXMvED5vtpoqf+uru1kkwcRDd4cMFZ+KsLRjANr5
	 5MbGSb9lFaR2g==
Date: Tue, 11 Jun 2024 18:45:15 +0300
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
Message-ID: <20240611154515.GC4966@unreal>
References: <cover.1709635535.git.leon@kernel.org>
 <SA1PR11MB6991CB2B1398948F4241E51992182@SA1PR11MB6991.namprd11.prod.outlook.com>
 <20240503164239.GB901876@ziepe.ca>
 <PH7PR11MB70047236290DC1CFF9150B8592C62@PH7PR11MB7004.namprd11.prod.outlook.com>
 <20240610161826.GA4966@unreal>
 <PH7PR11MB7004A071F27B4CF45740B87E92C62@PH7PR11MB7004.namprd11.prod.outlook.com>
 <20240610172501.GJ791043@ziepe.ca>
 <PH7PR11MB7004DDE9816D92F690A5C0B692C62@PH7PR11MB7004.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PH7PR11MB7004DDE9816D92F690A5C0B692C62@PH7PR11MB7004.namprd11.prod.outlook.com>

On Mon, Jun 10, 2024 at 09:28:04PM +0000, Zeng, Oak wrote:
> Hi Jason, Leon,
> 
> I was able to fix the issue from my side. Things work fine now. I got two questions though:
> 
> 1) The value returned from dma_link_range function is not contiguous, see below print. The "linked pa" is the function return.
> I think dma_map_sgtable API would return some contiguous dma address. Is the dma-map_sgtable api is more efficient regarding the iommu page table? i.e., try to use bigger page size, such as use 2M page size when it is possible. With your new API, does it also have such consideration? I vaguely remembered Jason mentioned such thing, but my print below doesn't look like so. Maybe I need to test bigger range (only 16 pages range in the test of below printing). Comment?

My API gives you the flexibility to use any page size you want. You can
use 2M pages instead of 4K pages. The API doesn't enforce any page size.

> 
> [17584.665126] drm_svm_hmmptr_map_dma_pages iova.dma_addr = 0x0, linked pa = 18ef3f000
> [17584.665146] drm_svm_hmmptr_map_dma_pages iova.dma_addr = 0x0, linked pa = 190d00000
> [17584.665150] drm_svm_hmmptr_map_dma_pages iova.dma_addr = 0x0, linked pa = 190024000
> [17584.665153] drm_svm_hmmptr_map_dma_pages iova.dma_addr = 0x0, linked pa = 178e89000
> 
> 2) in the comment of dma_link_range function, it is said: " @dma_offset needs to be advanced by the caller with the size of previous page that was linked + DMA address returned for the previous page".
> Is this description correct? I don't understand the part "+ DMA address returned for the previous page ".
> In my codes, let's say I call this function to link 10 pages, the first dma_offset is 0, second is 4k, third 8k. This worked for me. I didn't add the previously returned dma address.
> Maybe I need more test. But any comment?

You did it perfectly right. This is the correct way to advance dma_offset.

Thanks

> 
> Thanks,
> Oak
> 
> > -----Original Message-----
> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > Sent: Monday, June 10, 2024 1:25 PM
> > To: Zeng, Oak <oak.zeng@intel.com>
> > Cc: Leon Romanovsky <leon@kernel.org>; Christoph Hellwig <hch@lst.de>;
> > Robin Murphy <robin.murphy@arm.com>; Marek Szyprowski
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
> > On Mon, Jun 10, 2024 at 04:40:19PM +0000, Zeng, Oak wrote:
> > > Thanks Leon and Yanjun for the reply!
> > >
> > > Based on the reply, we will continue use the current version for
> > > test (as it is tested for vfio and rdma). We will switch to v1 once
> > > it is fully tested/reviewed.
> > 
> > I'm glad you are finding it useful, one of my interests with this work
> > is to improve all the HMM users.
> > 
> > Jason

