Return-Path: <kvm+bounces-60279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4B9CBE6BA2
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 08:39:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 907BA627288
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 06:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE1F30FC3F;
	Fri, 17 Oct 2025 06:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="y2DGVXXj"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4538722173D;
	Fri, 17 Oct 2025 06:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760682783; cv=none; b=L9JG/uFVDooZ/R2hz24lV0GKDEkMBF4bKDjxQ6SlSZbTfFmQmKeUjihNcXxB/KQHR03saSYADAMRn+NUysLdkClTxJYiIiAo7skTbPpjT+uZM9bAZnZGw73TrV05oxtXs+td/3Xw36uUcDxcHGPZx4pqrnNv+moOVrXqQ15dL9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760682783; c=relaxed/simple;
	bh=m9g818LpB1ycczOIN8v5KCFvkd6rNq3BAdd09q0GhS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HjilzKi4/55OpNmSEqorv+Wcw2V3U4ocpMpj4qRLNUEICVb+5xFE1He8p+BMBsso/xBFLi4iVtZ2BP4RRGYNjlGOiLr3w4m5mRe4h7EJv1PVvoLU72szZtwHmmN9wc1F05NPez5Rl1alRdHg69640hHVd+ZbqYlDlHNv5FXMZYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=y2DGVXXj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O2HbwcCwjmYp1QGR0urHVDj2pfFgr7Dpd/IflvweDe8=; b=y2DGVXXj0gpAtl2JNiI0w2GeuJ
	D1MzfQ+neLIkx+kckzYv7LwBjazQ62k+27hf5aNq+BlsUF+U8aHjBXt6zOJGu16zjHVGqRTPkdEEu
	J7J3oxXPx7EUhsK032alUNCWg15Qwx/73jcXzZKg4A2vh3+b/+BmM8Y3/WaSGtClcHbbAxKZA9QVl
	N57R4yFKtN2xfak8y/VpsW4KtDleeQUBzzw46/Ow2fEHJvKvIJcgYTwSC2sdwQmrBfbBON84WYu8H
	FlJ6we5VWled1vCHgyMpFauWhKmZ5KagoBR1wg8YoN9Rniv8Wvqk6XIhefKXgcDZdNJQsjMes4+VQ
	1s6pAB/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9e1L-00000006nlK-0idR;
	Fri, 17 Oct 2025 06:32:59 +0000
Date: Thu, 16 Oct 2025 23:32:59 -0700
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
Subject: Re: [PATCH v5 8/9] vfio/pci: Enable peer-to-peer DMA transactions by
 default
Message-ID: <aPHjG2PS5DVgcG93@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <a04c44aa4625a6edfadaf9c9e2c2afb460ad1857.1760368250.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a04c44aa4625a6edfadaf9c9e2c2afb460ad1857.1760368250.git.leon@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 13, 2025 at 06:26:10PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Make sure that all VFIO PCI devices have peer-to-peer capabilities
> enables, so we would be able to export their MMIO memory through DMABUF,

How do you know that they are safe to use with P2P?


