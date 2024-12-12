Return-Path: <kvm+bounces-33567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DCDB9EE1BC
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 09:45:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94AB91887F8B
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 08:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE34F20E03C;
	Thu, 12 Dec 2024 08:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jM/fC3SV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6FB148FED;
	Thu, 12 Dec 2024 08:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733993139; cv=none; b=S5Q/Rjdpy+BFvVREW7Kw7QBrdR24lbbGQxdy7dubjDU4snfqdNRyngOAwRsABYZmftbChtUuccu/i5jUSd6jbr2Nxr9SlMvCggdN4h5l1F9mzJI4A2MEvrURLDmi3hfAsJ8bkiwbnf0m7b/uxSbi3K8xBot3fPosCl0VHM/LDQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733993139; c=relaxed/simple;
	bh=SnaoS3XbMfIwMqA358S7ljqTiZShb2tbxNANsv2qtHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bRwW1Y0+9glEXOaBHpxJyc6/TE1ouzl0IXA0wlNShU+FtRID7MGOYd5w/Cnr3Qm3OfpEhhIInKrz0FMm8PAr6//wIQJq7sl4/oyBI9fjri3CsVPY/M5ePGMq7upvDenzIv8GIkE4PiofAZI+7k5kgyoT10Z1/OYqUfR0OK5xGT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jM/fC3SV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD34C4CECE;
	Thu, 12 Dec 2024 08:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733993138;
	bh=SnaoS3XbMfIwMqA358S7ljqTiZShb2tbxNANsv2qtHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jM/fC3SV71OtekQMes8cU//Y2sVccBO5M1Rp1oSOeTfUHhdh/h8Kp0Wvkl5o9Y05t
	 XZUgwUE2R2RdWaGKe67gws/VOMS7zdgNWvMX8LE9oP3EVbdz9mXouuy/FRi5oTmj1h
	 HBkXA4kz2nWgmHfTNOBM+/FQGz9UW4jC5QE+0HuooFXn+AUPVn1GJd7D8dNvWcBu2h
	 38m7i4D9C3LMpjXAIPmM3N0DXbZhPQMfgP30p/Rbp0BTcWwMNAuanAHMhsbK+tTlgp
	 VtDSO8fkHojv+71VgMMV/oewnpYMbcTPln7F9wB0QO2TpBTFnvhRf0FJehQQTrsban
	 tm5f/HMiAk5mQ==
Date: Thu, 12 Dec 2024 10:45:33 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
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
Subject: Re: [PATCH v4 05/18] dma-mapping: Add check if IOVA can be used
Message-ID: <20241212084533.GG1245331@unreal>
References: <cover.1733398913.git.leon@kernel.org>
 <b23a1e29f00f31f31641479c90f2471aee27fac5.1733398913.git.leon@kernel.org>
 <20241212083459.GB9376@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212083459.GB9376@lst.de>

On Thu, Dec 12, 2024 at 09:34:59AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 05, 2024 at 03:21:04PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > This patch adds a check if IOVA can be used for the specific
> > transaction.
> > 
> > In the new API a DMA mapping transaction is identified by a
> > struct dma_iova_state, which holds some recomputed information
> > for the transaction which does not change for each page being
> > mapped.
> 
> While the content of the patch here looks fine, the super fine
> grained patch split look really odd and makes sensible review
> hard.  Was this a request on one of the earlier versions?

I don't think so. It is combination of two factors:
1. Review cycles, which caused to shrink this patch.
For example, see the amount of content in RFC version of same patch
https://lore.kernel.org/all/cac154df7131984929a1cf73948bc5986af5ef85.1726138681.git.leon@kernel.org/
2. Attempt to localize changes in dma-mapping.h file. The following
patch touches dma-iommu.c, while this doesn't need to do so.

I can squash them.

Thanks

