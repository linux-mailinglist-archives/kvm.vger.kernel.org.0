Return-Path: <kvm+bounces-29821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 785E49B2746
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 07:47:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30BCD1F24864
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:47:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE7D18FDCC;
	Mon, 28 Oct 2024 06:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXfr6iuk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AC118A924;
	Mon, 28 Oct 2024 06:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097998; cv=none; b=J3ZtHsAZyrH8qGEVw+MaJQv9SHD0kf5mw//1+ssxKo/DvDrFAiZMCX0Wxg88ujEV4HIcDwuoQNtwPi6Rj5yorl8526qHnrQJvlCfpxH2YBDcd/zAAd8dy+1xngecpo/G5lXlok0KIBbaYpOuRq/8pova5ks7UJNcK/rK/i7lppk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097998; c=relaxed/simple;
	bh=JxpLCeEPUhJrMkdL0TYudbC/XbTxYSrHktHQOg5tBzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pajR0/ucKNIQXo/E8COdMX0upwc/8LRvqEdlN1DPHe3PvwIBxvHrdcJgyZVhaAbyaEiRtpSxQuiGXN2OTXcnm8WUid/G/JObx3NVF3ToBjf6LZSiAF1IenFBisuWbL8HC9T3pElTmPKXM+2hP0ROzci1+tLjYsooP8wvZLS3KcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXfr6iuk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA05C4CEC3;
	Mon, 28 Oct 2024 06:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730097998;
	bh=JxpLCeEPUhJrMkdL0TYudbC/XbTxYSrHktHQOg5tBzY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pXfr6iukpFNitgAKIIVSyCYtDDCh3B1GaWuseUbNm4XLfuvHiPNIEI1RqzgXGCn+r
	 T8x3ffU9NvEGqhEZOlcisSCjWlq5PsrCdXVG8sEw7pR+jCveH56xttouEjDQJDV8WY
	 bx5SFdkmU/eJH7Hrzmkv07xrrIzZ4Y8X8n46X7ryPLmoTBBwUTYHLhLxEw9x3XHUY1
	 Sze57dE6qj3rdN/EwuSVQ8/g13tIxT1HqDmg5aZ6q77NA2Bid5WHDDtaexWJgT2Sgx
	 tKYkFMMAg8RNVBv4t74ApVds33Nr2L4PoRFdOrDOZnsgk8sPPHU+TQP6pn8GBLAoZx
	 12xZsB0TjAqdA==
Date: Mon, 28 Oct 2024 08:46:34 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Srinivasulu Thanneeru <dev.srinivasulu@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/18] dma: Provide an interface to allow allocate IOVA
Message-ID: <20241028064634.GE1615717@unreal>
References: <cover.1730037276.git.leon@kernel.org>
 <844f3dcf9c341b8178bfbc90909ef13d11dd2193.1730037276.git.leon@kernel.org>
 <CAMtOeKJeVrELCp5JpYTC64KdfKpbnW9a8QrnL6ziCYL48nc=qQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMtOeKJeVrELCp5JpYTC64KdfKpbnW9a8QrnL6ziCYL48nc=qQ@mail.gmail.com>

On Mon, Oct 28, 2024 at 09:54:49AM +0530, Srinivasulu Thanneeru wrote:
> On Sun, Oct 27, 2024 at 10:23 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > The existing .map_page() callback provides both allocating of IOVA
> > and linking DMA pages. That combination works great for most of the
> > callers who use it in control paths, but is less effective in fast
> > paths where there may be multiple calls to map_page().
> 
> Can you please share perf stats with this patch in fast path, if available?

I don't have this data for HMM and VFIO as they have other benefits from this
series except performance. For NVMe, I don't have the data yet, but it will
come https://lore.kernel.org/all/cover.1730037261.git.leon@kernel.org/,
as it is the main performant user of this API.

This is the main reason why NVMe series is marked as RFC yet.

Thanks

