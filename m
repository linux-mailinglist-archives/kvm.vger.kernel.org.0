Return-Path: <kvm+bounces-30278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F9CB9B8B04
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 07:11:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 267961F225F8
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 06:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F5DD14D70E;
	Fri,  1 Nov 2024 06:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GxotyBrg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED17142623;
	Fri,  1 Nov 2024 06:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730441482; cv=none; b=cbd4V0zc8L1fDA2CeWvlXPunbwN0yueQDoPhvcPjpeyoG4ZS2YyRsYBEgC1NaJQS1HPFnZrrFXymF68HGErdbNUv88cwpjVWXa480m1YE/lCG5ITwSzidJR/AuBmcWN/P9wswJ81R0f/7PngfeH268TPk/zNkqz8YYt8rA0XNxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730441482; c=relaxed/simple;
	bh=xuvDhMPsSnRBldbb9zqlIWoH9RpyHnNr2U6kz9Sckdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tHF/LwrVqE8V7BRl88UC8sZTPdWa+lVlIuo/pGI7Wjb9JoSyM0hlLydOwTPwqRST3m+AebfyQZWCsNA5U0rPGk7PFAuhxpuyH90SywNkqAvl3aMo52PjoF8hPJxrg7VvZk6PmvZYWpqbcFMTvYs+Z83NJqH0kpt2oOn0Ozlu7dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GxotyBrg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71BBC4CECD;
	Fri,  1 Nov 2024 06:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730441481;
	bh=xuvDhMPsSnRBldbb9zqlIWoH9RpyHnNr2U6kz9Sckdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GxotyBrgjRANc5p7HrsCLBXgaj4HLa5WC8j/hwfVk4KJAdkHmExC7kSQTYNp89ILA
	 Yx2fbg2gbC1Wjyn01FDcCrk577MzfB5np9DJobJUCMYKqeBjjKbyJl4ye3AMAvF9/M
	 eWLWv6oFnkXuCdVlONIFHy4LNALMfsWKyHZrQE/pe6g5rPZdzyyrOB4cB2hoNjYS79
	 lqHPB1G+uBa5evs4A6a/506EDsJ0Nq/l3fddVEF8YAVmp1SK1vnA6Z0/l70YE3mAJc
	 C3wKq7ppvuxcUZM3NDVqxKZW+swjVBkdxdhk2qeZWESspprkV0FeKW4hemHsE21yeg
	 a8+9J8MNFi77A==
Date: Fri, 1 Nov 2024 08:11:16 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
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
Subject: Re: [RFC PATCH 2/7] block: don't merge different kinds of P2P
 transfers in a single bio
Message-ID: <20241101061116.GC88858@unreal>
References: <cover.1730037261.git.leon@kernel.org>
 <34d44537a65aba6ede215a8ad882aeee028b423a.1730037261.git.leon@kernel.org>
 <d4378502-6bc2-4064-8c35-191738105406@acm.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4378502-6bc2-4064-8c35-191738105406@acm.org>

On Thu, Oct 31, 2024 at 01:58:37PM -0700, Bart Van Assche wrote:
> On 10/27/24 7:21 AM, Leon Romanovsky wrote:
> > +		/*
> > +		 * When doing ZONE_DEVICE-based P2P transfers, all pages in a
> > +		 * bio must be P2P pages from the same device.
> > +		 */
> > +		if ((bio->bi_opf & REQ_P2PDMA) &&
> > +		    !zone_device_pages_have_same_pgmap(bv->bv_page, page))
> > +			return 0;
> 
> It's probably too late to change the "zone_device_" prefix into
> something that cannot be confused with a reference to zoned block
> devices?

It is never too late to send a patch which renames the names, but it needs
to be worth it. However it is hard to see global benefit from zone_device_* rename.
ZONE_DEVICE is a well known term in the kernel and it is used all other places
in the kernel.

Thanks

> 
> Thanks,
> 
> Bart.
> 

