Return-Path: <kvm+bounces-31876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7A189C901F
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:49:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FAF51F2769B
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CDEE17A583;
	Thu, 14 Nov 2024 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oj9j4lFl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684002BD1D;
	Thu, 14 Nov 2024 16:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731602912; cv=none; b=TFv58pwrBR8GuKT7+LIw/D3T2ShgJQtYCN0VjxBIJp6rOe1EGI7pShQ/Rz3iVkCu/HiWk8ixX1nbaNOWPG3kKW8rHQLUxWetQai/lN/AGiirs3SpjdPect8vCW9j1Qrq21tzwn767Jhjs5bQSS+HH8QQewMxYAcxC0UfpNvpodo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731602912; c=relaxed/simple;
	bh=Hx8YYfB1GiMgjudYqJkAl8tvbolgpNIbwv5wiDGpWKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tFaLNRlH8OdDwCgn6XKhrgLHuNrHcc09YecueWXb04lV6VrZCW7Jz6DdubljzKIXPkACa9FzV16tRsiK9O8j6SVtBL9J3F8+POpm8jXBwr7wr0cb+ZaDfTyjnZLfLq5vPbd1XyTUU/BWddAjI+DeaDU9ov3UyPm8MLtDQzcrWUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oj9j4lFl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434D1C4CECD;
	Thu, 14 Nov 2024 16:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731602911;
	bh=Hx8YYfB1GiMgjudYqJkAl8tvbolgpNIbwv5wiDGpWKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oj9j4lFlZh6intpQ4wpfMP6Sm/OaAQmcYgcgKinj3ga8KXj+JnstzlbjR1onQ5Cql
	 hSESVrvCeEITPT1mzAD+bQIZnJP3n+ef6tQ3L6XpUr6ZjcQ3ncpVydh0ZqmXAgVioA
	 IYM0j5KeW4xRYkVPj3GHhOJ2aHGIoj16yfozYBJAX8MRkteE5t7gpf5o+hhm8/ZIy+
	 plLDS2dJdw/pCg8sGjF23ZIi88P1Q06aOxkhlyweHqHtB5s38blARUAmF+7JyurAZn
	 HdBH8z9Dk8/wOOhFIPwX8aM8JpTMq5Bu61qE+wN+1839i9DJ6rHjqJcZi/3moETGMu
	 ahRHoyu8lSKAw==
Date: Thu, 14 Nov 2024 18:48:23 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Robin Murphy <robin.murphy@arm.com>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	ill Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
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
Subject: Re: [PATCH v3 00/17] Provide a new two step DMA mapping API
Message-ID: <20241114164823.GB606631@unreal>
References: <cover.1731244445.git.leon@kernel.org>
 <20241112072040.GG71181@unreal>
 <20241114133011.GA606631@unreal>
 <20241114163622.GA3121@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114163622.GA3121@lst.de>

On Thu, Nov 14, 2024 at 05:36:22PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 14, 2024 at 03:30:11PM +0200, Leon Romanovsky wrote:
> > > All technical concerns were handled and this series is ready to be merged.
> > > 
> > > Robin, can you please Ack the dma-iommu patches?
> > 
> > I don't see any response, so my assumption is that this series is ready
> > to be merged. Let's do it this cycle and save from us the burden of
> > having dependencies between subsystems.
> 
> Slow down, please.  Nothing of this complexity is going to get merged
> half a week before a release.

It is fine, but as a bare minimum, I would expect some sort of response,
so I won't sit and wait for unknown date when this API will be acknowledged/NACKed.

I would like to start to work on next step, e.g removing SG from RDMA,
and I need to know if this foundation is stable to do so.

> 
> No changs to dma-iommu.c are going to get merged without an explicit
> ACK from Robin, and while there is no 100% for the core dma-mapping
> code I will also not merge anything that hasn't been resolved with
> my most trusted reviewer first, not even code I wrote myself.

And do you know what is not resolved here? I don't.
All technical questions/issues were handled.

Thanks

