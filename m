Return-Path: <kvm+bounces-44197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CE92A9B340
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 18:02:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C05BD5A65E9
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:01:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB23927FD79;
	Thu, 24 Apr 2025 16:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wm8VevHV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E361624C5;
	Thu, 24 Apr 2025 16:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745510503; cv=none; b=sOkGLJ35SfzSdUYtXLM8RJfIqhzDWNlta9AVA3plZwuYiQP20fv3ujizaYiqdJui37qYKj79cMkIdNNvU/EyhCTlgvXBcjwMPDqFRmlggmjrx8M8SQlJgUhwosUeEzZdjE2LflSk8xJopoaHCPyZfByRmkA+Val5aohHTmwXlhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745510503; c=relaxed/simple;
	bh=2EsFN3KQzZNWveqPmKQ2uvMTlzDkWMvMTWZFw/RE+lA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZtRbC4VExiZsdjzvG8UG2eu+yKX0RgLLt/SHGz72DeOR+w7LL0DlkTE+nhQ8biME4RvOyXyzrjZZM/H7qhfOvnwLY+57lOlYe0RZu3Pq8LbB83KNrLSzFh0PeOYd1r9gfX4JpKYs1GKoeNwsz8EHYtXo63qP4xLPhM/QP+L2Ry4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wm8VevHV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5C2C4CEE3;
	Thu, 24 Apr 2025 16:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745510503;
	bh=2EsFN3KQzZNWveqPmKQ2uvMTlzDkWMvMTWZFw/RE+lA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wm8VevHVEohfFXx1uchcfmtL+zcZ6xSp9jmMA3lzuk8AwHIyLQmcHNh0McnSrCcx3
	 lIkmFdP+VzpGEpwEKphWvTET5ebVyPTPFMB80cvGgeYljv5/yF/In310jRDQC6j3Xe
	 enCjXdYVPMQ3v7aENOXrr8Z1Q/znZ+vOdsJ5KN84mcOFLlEP45lED6O7qLOvupMMaK
	 lBtmEryEpv3oaYU2xAYKqHcEOWsb8P+1vrzSoARX2cvfIjSdXU2qZFlV+DPcWa735h
	 beec4plnuKPHYBuMtW0ndvkO/fM+I0YWu6BDRZ5NUppB0Cqwzxtn9QVLIFtHY5tX8k
	 eFD7fbEi5hXLw==
Date: Thu, 24 Apr 2025 19:01:38 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: [PATCH v9 10/24] mm/hmm: let users to tag specific PFN with DMA
 mapped bit
Message-ID: <20250424160138.GT48485@unreal>
References: <0a7c1e06269eee12ff8912fe0da4b7692081fcde.1745394536.git.leon@kernel.org>
 <7185c055-fc9e-4510-a9bf-6245673f2f92@redhat.com>
 <20250423181706.GT1213339@ziepe.ca>
 <36891b0e-d5fa-4cf8-a181-599a20af1da3@redhat.com>
 <20250423233335.GW1213339@ziepe.ca>
 <20250424080744.GP48485@unreal>
 <20250424081101.GA22989@lst.de>
 <20250424084626.GQ48485@unreal>
 <20250424120703.GY1213339@ziepe.ca>
 <20250424125052.GS48485@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424125052.GS48485@unreal>

On Thu, Apr 24, 2025 at 03:50:52PM +0300, Leon Romanovsky wrote:
> On Thu, Apr 24, 2025 at 09:07:03AM -0300, Jason Gunthorpe wrote:
> > On Thu, Apr 24, 2025 at 11:46:26AM +0300, Leon Romanovsky wrote:
> > > On Thu, Apr 24, 2025 at 10:11:01AM +0200, Christoph Hellwig wrote:
> > > > On Thu, Apr 24, 2025 at 11:07:44AM +0300, Leon Romanovsky wrote:
> > > > > > I see, so yes order occupies 5 bits [-4,-5,-6,-7,-8] and the
> > > > > > DMA_MAPPED overlaps, it should be 9 not 7 because of the backwardness.
> > > > > 
> > > > > Thanks for the fix.
> > > > 
> > > > Maybe we can use the chance to make the scheme less fragile?  i.e.
> > > > put flags in the high bits and derive the first valid bit from the
> > > > pfn order?
> > >
> > > It can be done too. This is what I got:
> > 
> > Use genmask:
> 
> I can do it too, will change.

If you don't mind, I'll stick with my previous proposal.

GENMASK() alone is not enough and the best solution will include use
of FIELD_GET FIELD_PREP mocros. IMHO, that will make code unreadable.
The simple, clean and reliable bitfield OR operations much better fit
here.

Thanks

> 
> > 
> > enum hmm_pfn_flags {
> > 	HMM_FLAGS_START = BITS_PER_LONG - PAGE_SHIFT,
> > 	HMM_PFN_FLAGS = GENMASK(BITS_PER_LONG - 1, HMM_FLAGS_START),
> > 
> > 	/* Output fields and flags */
> > 	HMM_PFN_VALID = 1UL << HMM_FLAGS_START + 0,
> > 	HMM_PFN_WRITE = 1UL << HMM_FLAGS_START + 1,
> > 	HMM_PFN_ERROR = 1UL << HMM_FLAGS_START + 2,
> > 	HMM_PFN_ORDER_MASK = GENMASK(HMM_FLAGS_START + 7, HMM_FLAGS_START + 3),
> > 
> > 	/* Input flags */
> > 	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
> > 	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
> > };
> > 
> > Jason
> 

