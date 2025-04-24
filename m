Return-Path: <kvm+bounces-44094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75234A9A53E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:08:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 113B03BD1EE
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C94F204F83;
	Thu, 24 Apr 2025 08:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODyOD7bZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D0119CCEA;
	Thu, 24 Apr 2025 08:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745482070; cv=none; b=ZRavegX6XgO4ycdaIFapp66EzgMH4jwnRiYHYECVNbjM5GlYxy23egJRDwp79HJiW12ieeXZV+wx66UmhotCI5Eip/tDLOvzXIFWT61lAkBoNlKvHU9BieKczHwcfw/qr3kysb6zd5KaDsMwSsBiUN18OQbF4jLePVKA9QddKYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745482070; c=relaxed/simple;
	bh=gQ9J0xOhC6db6xC9+l1fS/rU8P/+uRvFwj9Ophiqh+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hEhM7mKefqFsB2aVpNrsNouf01/pPPMsJhi33z0xeNU66DwGpXb/oY9s5wrLJUWUOSqqhWaXFfGBcYChvPx1pEc3UqZfCKlMqC34mDU0dSd0i7O3dgC8+/Vdz7PC14srmGIsqqc5CHb8C5MOotDmQMAxfmwUI5GEZR9/RIx60sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODyOD7bZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED08C4CEEB;
	Thu, 24 Apr 2025 08:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745482069;
	bh=gQ9J0xOhC6db6xC9+l1fS/rU8P/+uRvFwj9Ophiqh+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ODyOD7bZFe6psyTBbbqHrGyTN9bbO06+mLsjpOZpZAtyeVZhSMtIzzHp4uk/bPwRF
	 Fg+5AuYPCHFaO1iJ7AZ0hnuzbSatu3RKpWWB0igu+ysf5GxyCdAj0/zoHi8abPgms6
	 UyWqrFeuVLz7KWExbAlMl6sGk3pIBXhjJdgkeyS5U7v4meyETDlnI/bCnajjhgK5ip
	 tIFTA4qEdRjUs4v9+5Yqy4cTSqzgz9evKITnLdxHo0yebJZSxHX+clynB3yYqiaA9g
	 TAOPbev3sVV+FH5Ob1WbUIU/+f8jJU3YQkiM1kHRm7HKmFAywX5r91KPZh1EV5IySo
	 WbMrUBYNBAOvw==
Date: Thu, 24 Apr 2025 11:07:44 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Zhu Yanjun <zyjzyj2000@gmail.com>,
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
Message-ID: <20250424080744.GP48485@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <0a7c1e06269eee12ff8912fe0da4b7692081fcde.1745394536.git.leon@kernel.org>
 <7185c055-fc9e-4510-a9bf-6245673f2f92@redhat.com>
 <20250423181706.GT1213339@ziepe.ca>
 <36891b0e-d5fa-4cf8-a181-599a20af1da3@redhat.com>
 <20250423233335.GW1213339@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250423233335.GW1213339@ziepe.ca>

On Wed, Apr 23, 2025 at 08:33:35PM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 23, 2025 at 09:37:24PM +0300, Mika Penttilä wrote:
> > 
> > On 4/23/25 21:17, Jason Gunthorpe wrote:
> > > On Wed, Apr 23, 2025 at 08:54:05PM +0300, Mika Penttilä wrote:
> > >>> @@ -36,6 +38,13 @@ enum hmm_pfn_flags {
> > >>>  	HMM_PFN_VALID = 1UL << (BITS_PER_LONG - 1),
> > >>>  	HMM_PFN_WRITE = 1UL << (BITS_PER_LONG - 2),
> > >>>  	HMM_PFN_ERROR = 1UL << (BITS_PER_LONG - 3),
> > >>> +
> > >>> +	/*
> > >>> +	 * Sticky flags, carried from input to output,
> > >>> +	 * don't forget to update HMM_PFN_INOUT_FLAGS
> > >>> +	 */
> > >>> +	HMM_PFN_DMA_MAPPED = 1UL << (BITS_PER_LONG - 7),
> > >>> +
> > >> How is this playing together with the mapped order usage?
> > > Order shift starts at bit 8, DMA_MAPPED is at bit 7
> > 
> > hmm bits are the high bits, and order is 5 bits starting from
> > (BITS_PER_LONG - 8)
> 
> I see, so yes order occupies 5 bits [-4,-5,-6,-7,-8] and the
> DMA_MAPPED overlaps, it should be 9 not 7 because of the backwardness.

Thanks for the fix.

