Return-Path: <kvm+bounces-60278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D6FBE6B93
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 08:38:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4217F6E0E77
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 06:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B38B30FC3C;
	Fri, 17 Oct 2025 06:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="493urc9v"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CF026F44C;
	Fri, 17 Oct 2025 06:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760682717; cv=none; b=HN/Q9SpWEifZIGpohnr4WEFFhNse/oGf5nJJ/pvGit6IpmL7TblotwYS8GwFeJO3SE6SH411gEUaZpBUcWR1Lkh3GgMUc0TWQhbQSus+QDzCbKyDAYvBqBJ3tIxHObQTuh8mWG8vVDcJ2Pk49aWR7V9cSKK4/uD3/bsgIGuUng0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760682717; c=relaxed/simple;
	bh=IEfXHjkm4PHwmnvbVSl5tuNaj6e1eVl+g3ChB+S4a9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c36UB8IkeI5UJUgghp3G/DM8ZDnL1ppCgAtTr9UrFWlHxWhmEpXyK86ix29jCkcKhM8jlEBma8gre5gP1111ulYKuf97+FJ+MEN/K1+fweA5nOnuz17tNU1XxLdM6ixr0WzwSP+UUC2eJBgVvF5BMqK+loyIycTJBsVxptZhMuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=493urc9v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pmHn5+tRqJO2fDf6pS/Dahy8vpk/9cVU0mdR9JQWhq0=; b=493urc9vdCLUHtN/APrPDMt+Nw
	AAbBU0C8dfMa1U8/04w8afM0UbQ7W4gfcGrT1PBGuKApCfeI/yVbNcy67l/1CHbSzWig+DgEMzhl1
	ZzpKrqbkQ86pXT09AHT/LEn9pdUs7xyx39HR4pPuC0C9RK1ZEmdj52vKjGs8HzpfXkoQOv3DRNBAo
	iiC9vjRotySW9JM5FhYFwF21OgRE0gkvj0t2hF3xqmFaqwWaYjuZbpS5u4slbgR3A/lwVwbjv0Qs8
	3wRUKZuJqg22v24KQ247pwYg+VEk3THzgctOopEJX1pwFYWtXV1JYoFEi9fP+5GDHzAhdIYSMFrOU
	EcuOZFYw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9e0H-00000006nP1-0jS7;
	Fri, 17 Oct 2025 06:31:53 +0000
Date: Thu, 16 Oct 2025 23:31:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: Re: [PATCH v5 4/9] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <aPHi2c2BQNB4eqm_@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <0fa715706e1adf5e26199dc3eaa3b1ff3b14db67.1760368250.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fa715706e1adf5e26199dc3eaa3b1ff3b14db67.1760368250.git.leon@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html


Nacked-by: Christoph Hellwig <hch@lst.de>

As explained to you multiple times, pci_p2pdma_map_type is a low-level
helper that absolutely MUST be wrapper in proper accessors.  It is
dangerous when used incorrectly and requires too much boiler plate.
There is no way this can be directly exported, and you really need to
stop resending this.


