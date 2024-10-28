Return-Path: <kvm+bounces-29887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F0159B3925
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 19:28:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C1F41F229DE
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 18:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A7FD1DFE3A;
	Mon, 28 Oct 2024 18:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EtaFK3pd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512481DF996;
	Mon, 28 Oct 2024 18:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730140102; cv=none; b=qY1B6Nni08/odBmHs5MtilT9J2GDrWvQ6o7FL5pX0y25oAu/f0yVQwmWTtwD+2+QxV9LCLZAxtjIYisleTkF4Z4xRv2JVOTxP/v6p6Pp5MBBeHv/uWo9ReWA6cCWJEOiT+NpguNZOxUDvsx75A951K8eQdt/aJFGek0b22GfeuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730140102; c=relaxed/simple;
	bh=9iGMLbwbu5+Y6xL5FtHUey8KkpvIorHUri9eopVp1bE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C+19Cn1VHp9Z0UvKoqiIl+c43zPOQgeLd7x8lkHcUe5dJWaaTkSGBikolAdYq9HerCwtdNP7wjIbOTW+DSNVAVSmb4w1xSsowCMIXyf2ZbeCWYBna6VwIoXtrzKWf4TepCCrrKD1Z0BhceLfkqme8yKxieDF1jt9hmTqIfr3LgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EtaFK3pd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46CDC4CEE4;
	Mon, 28 Oct 2024 18:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730140101;
	bh=9iGMLbwbu5+Y6xL5FtHUey8KkpvIorHUri9eopVp1bE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EtaFK3pduFuYsNn4Y7vW1E2l8VducP0vst+UuBVEbClW4TWipnGHfz233fzJPLCp+
	 A8MRUIYC0+zA/CM3TbtJ1baS+UV1GvKGP0/Xu+HTYmzt6DJJI4akRbyQlZuKLR1PxK
	 spZ+zcbKZqLolf9P5ku2y3lq4gNNZA+Af5r7z2cpagVx7I8KvRjidzMAXhV0m6tffA
	 S7Z0oPNwV6kv0xsSjIkq0tLfhpRA7b0nVQDSdTWRXEimMGWEhNnHTy/txVooweHpWM
	 wtikULfejvKP5embybCWsN/6Rll2WIBurWpHWzaokEHX3ZC+tVhEJuljI7i+MtbL1d
	 A/quvdDcUEdvA==
Date: Mon, 28 Oct 2024 20:28:15 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
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
Subject: Re: [PATCH 09/18] docs: core-api: document the IOVA-based API
Message-ID: <20241028182815.GH1615717@unreal>
References: <cover.1730037276.git.leon@kernel.org>
 <f7ee023a7497ad3d8a7a31b12f492339d155ac39.1730037276.git.leon@kernel.org>
 <30e87c78-1021-4fa4-8aa6-e81245e77379@deltatee.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30e87c78-1021-4fa4-8aa6-e81245e77379@deltatee.com>

On Mon, Oct 28, 2024 at 12:12:34PM -0600, Logan Gunthorpe wrote:
> 
> I noticed a couple of typos below:
> 
> On 2024-10-27 08:21, Leon Romanovsky wrote:
> 
> > +Part Ie - IOVA-based DMA mappings
> > +---------------------------------
> > +
> > +These APIs allow a very efficient mapping when using an IOMMU.  They are an
> > +optional path that requires extra code and are only recommended for drivers
> > +where DMA mapping performance, or the space usage for storing the dma addresses
> 
> The second 'dma' should be capitalized as it is in other uses.
> 
> 
> > +    int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
> > +		size_t offset, size_t size, int ret);
> > +
> > +Must called to sync the IOMMU page tables for IOVA-range mapped by one or
> > +more calls to ``dma_iova_link()``.
> 
> "Must be called" instead of "Must called"

Thanks, will fix.

> 
> Thanks,
> 
> Logan

