Return-Path: <kvm+bounces-60805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 6806FBFA77F
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 09:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 139EE345E07
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 07:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F9702F5A2A;
	Wed, 22 Oct 2025 07:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SdNtRvN9"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBBE2F3C12;
	Wed, 22 Oct 2025 07:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761116936; cv=none; b=m1O7ktc+1gG2h8ASsaGSDMHWrX75XnErUtZJU6dos2NGnUs5R10VklwSg9QjYe5Awxp5IvoVElmFPwM/6MjRm15/rI9ca2gHaD6R2BXrracGIjDR0ZYgo8RjbW8TZt75+cmXPlP3QlzY9/WOFfHRlt34z5Nr4GNHsRV0PB5QYEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761116936; c=relaxed/simple;
	bh=RZfNn8b8mW0sEmuXaQMaNf0XrCYG7zBzjmxoWD6SwPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MF26B+JEdLWP1fv0+5joatSGnv4hv12qOd57u54UfVLjslgRzCvTPLAEFcrDeKnvXDOOEq7y7YMnT5HjJyadx2fJw8xpfuHdTtl9aid9LYT7IOq1kNgwq4XqOde0AptGuPrq7ItwwCKd+N9wF8TxdOzpPKXRvTI+kbwFf5f4v9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SdNtRvN9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v9tFlJ2fSBgWVG5dQp+BqV6oOUweYHcntX3sRf6YFKM=; b=SdNtRvN9ECbH+6Wq5VOUBng1tV
	rbcoTW7YrrfUGP/4J4whwouG1kDyvf3Lmdfi7LbnRPq89BMYv58xbUTBmXgSPXZVYRb6mJhJAPQU1
	ZIA0/wC+S1RJMhiGYJjhCAdfm4FEwCrzY3g3l4cgwQjuPypeTpyBjpkFiGnJ3/MzMXNCCwCjSZrzm
	n6BBFOL61exQBTv/xlQB1DwMELcEAU2ArzUgD/NYvkI2kZUkmNNPseZu9Lnk8f+brxHeHjW+o2OQa
	50dWmbeHSHNr0vGLwBLSjUlfEwJXoZAmppaRqh0WNeM+hhzaF/nXElPtxtD2OmafhI0Tejkvpb775
	0PevGOYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBSxk-00000001oCQ-0f7W;
	Wed, 22 Oct 2025 07:08:48 +0000
Date: Wed, 22 Oct 2025 00:08:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 8/9] vfio/pci: Enable peer-to-peer DMA transactions by
 default
Message-ID: <aPiDACJHZY7Gu4y1@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <a04c44aa4625a6edfadaf9c9e2c2afb460ad1857.1760368250.git.leon@kernel.org>
 <aPHjG2PS5DVgcG93@infradead.org>
 <20251017115524.GG3901471@nvidia.com>
 <aPYq0jQZOrn-lUJW@infradead.org>
 <20251020130855.GM316284@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020130855.GM316284@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 20, 2025 at 10:08:55AM -0300, Jason Gunthorpe wrote:
> Sure, but this should be handled by the P2P subsystem and PCI quirks,
> IMHO. It isn't VFIOs job.. If people complain about broken HW then it
> is easy to add those things.

I think it is.  You now open up behavior generally that previously
had specific drivers in charge.

> IDK where Intel GPU lands on this, but VFIO has always supported P2P

How?


