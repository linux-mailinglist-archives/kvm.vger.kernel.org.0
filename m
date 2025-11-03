Return-Path: <kvm+bounces-61797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F18CC2A82C
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 09:14:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA13A3BAF8A
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 08:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0093E2D837C;
	Mon,  3 Nov 2025 08:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YNIMhHK+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01DC2C0F63;
	Mon,  3 Nov 2025 08:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762157127; cv=none; b=P76Z9moxFAwTsJTIF1/fy1YWuw6n56Yw1tE3c/8ftjoMChhhycaKhPeAWMdQbuOJ3+4TZgUqZooYK9yPZGENZYhRSpn6nvNFSLyewVF/7otaqBDaMmbzfwFd5ZzHYactkQc6df9l+qu4uoFMG5zTALaHSvjqhgXzif+kDChPLSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762157127; c=relaxed/simple;
	bh=/Z00hsFx0kFKgS/fH2fkWOXPCRXDBSY3j5PVFskPLtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d/y0xbp5LMVt+pDAUSF0YqPeaOUJTU1A8tuh0c5vCsf6lUhpFHYi9p07usY6fhYOt/5jp/PlPbVxXvRQm3NsZMAOc61OtyVr2BRvr/479QW4549K3GpqE/vrrA7piieEIj92lR/lQe8kgnGQ+w5jthJVzLfyCEbxE2qdfZ0gXdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YNIMhHK+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBE8C4CEE7;
	Mon,  3 Nov 2025 08:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762157126;
	bh=/Z00hsFx0kFKgS/fH2fkWOXPCRXDBSY3j5PVFskPLtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YNIMhHK+TIAw9S8epUQRLJ0hHWrXGrX021AASru7kQYHYuMFC6zo5jxbc7KUmJ0L3
	 YNEe1nE+4ae3JtQxcTTez3gXWgSy2u2msyRHFv6Ufnrx2bt2n0+8KYqma3OyMomdHy
	 Und0omT0toRmHQSOMJHh8FIiBDSXmNrLx8mv1uScrl9HdFKsXLarM713jjbRgR+/v4
	 7/jTF678ISrptDm6AzMN9ALIVAtiWOrlbYsGz2TuzZPwPoiteJ/wA8NnfdkaDlmCac
	 R8sanushWpLqk/uQd051eoYlDOALHHRNHhGhWZBT9cBCKpSLGzr/fRIrMBO19/jAvs
	 SiEU4tXpMsS3Q==
Date: Mon, 3 Nov 2025 10:05:18 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v6 05/11] PCI/P2PDMA: Document DMABUF model
Message-ID: <20251103080518.GB50752@unreal>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
 <20251102-dmabuf-vfio-v6-5-d773cff0db9f@nvidia.com>
 <86383031-807e-43d9-976e-dd955d79dc52@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86383031-807e-43d9-976e-dd955d79dc52@infradead.org>

On Sun, Nov 02, 2025 at 10:16:59AM -0800, Randy Dunlap wrote:
> 
> 
> On 11/2/25 1:00 AM, Leon Romanovsky wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > Reflect latest changes in p2p implementation to support DMABUF lifecycle.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  Documentation/driver-api/pci/p2pdma.rst | 95 +++++++++++++++++++++++++--------
> >  1 file changed, 72 insertions(+), 23 deletions(-)

<...>

> > +guarentee that the consuming driver has stopped using the MMIO during a removal
> 
>    guarantee

<...>

> > +if are used with mmap() must create special PTEs. As such there are very few
> 
>    if used

<...>

> > +pggmap of MEMORY_DEVICE_PCI_P2PDMA to create struct pages. The lifecylce of
> 
>    pgmap ?                                                        lifecycle

<...>

> > +architectures, others will experiance corruption or just crash in the kernel.
> 
>                               experience

<...>

> > +In this case the initator and target pci_devices are known and the P2P subsystem
> 
>                     initiator

<...>

> > +exporting driver has destroyed it's p2p_provider.
>                                   its

Thanks a lot, fixed.

> 
> -- 
> ~Randy
> 
> 

