Return-Path: <kvm+bounces-60517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 77E6ABF12A5
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 14:28:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 63BD54F4073
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9554C311C3B;
	Mon, 20 Oct 2025 12:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bBc3P6XH"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBAF2E1C6B;
	Mon, 20 Oct 2025 12:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760963287; cv=none; b=ZLRKX99Mvt2rBGt/uFkd6zIOcXiPUix/2xuo4G4aI7rq8NON2vojAgLHm2hmm3buVwGUQuQyTt1wB/razErAIjbxUkbA1YXE6eCfTBDJd4Jc7c0h5GRsq7MbECoCzdC7jFFRTK42WrES5HrbCf5xZcGAJPAYUkqDSNUE52aRG9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760963287; c=relaxed/simple;
	bh=1lO772fc4p3qDgbZy7pAy3hVsBDNuQC1cZ8gI4aaH8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YwZP1GoW+eXhM5Hv26HqulbGSgI+03ew61Mxf1yvpDX0olTIda6MZmRPtvS54ol5/Xr249hGhLBQU1f5ElH53VlXYpdKd5WJfpzaP3g5DuwVYJWf1zixwG/6ItIfQtTOZPDwbxck4mgGPzcWuKWTn3qKDfXrNZY41f1SYs+Xlg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bBc3P6XH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7ETt/cIS7y36wzPdSWatPH0bjRaT9Kgy267Fn9GummA=; b=bBc3P6XH7OO6YaM6cL+h/RmHiB
	pDsB9AwmEla0WgHxgeNIiwwubVzoGXiigjeTvvej2RHeBXuzYAo99jNSU/Y44MSsDSW2oaom1jTJS
	yiWdm/IfNyvT3pB0m5irfyIriyKYefci4PDagpdEftDl1FFqk7mB/Y92Cb+ziu1dqwrNVNnTYbHE9
	BemCDU97SZrbmKGLwQHL7UIMD1F7tJWpFBNqWqCpc+wmV4bhsvaJiPHQ5CvZ1lcFlJVQfSSyFfMLS
	AkcS83i+dBFyjGqtFgcCKRA/A/MjU/IhUJR4CHIoZ2HclrlrsHruKWu6PFSUYnL8P2+TyEfe+KXQU
	DQeNiswQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAoza-0000000DPeN-2I74;
	Mon, 20 Oct 2025 12:28:02 +0000
Date: Mon, 20 Oct 2025 05:28:02 -0700
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
Message-ID: <aPYq0jQZOrn-lUJW@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <a04c44aa4625a6edfadaf9c9e2c2afb460ad1857.1760368250.git.leon@kernel.org>
 <aPHjG2PS5DVgcG93@infradead.org>
 <20251017115524.GG3901471@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017115524.GG3901471@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 17, 2025 at 08:55:24AM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 16, 2025 at 11:32:59PM -0700, Christoph Hellwig wrote:
> > On Mon, Oct 13, 2025 at 06:26:10PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Make sure that all VFIO PCI devices have peer-to-peer capabilities
> > > enables, so we would be able to export their MMIO memory through DMABUF,
> > 
> > How do you know that they are safe to use with P2P?
> 
> All PCI devices are "safe" for P2P by spec. I've never heard of a
> non-complaint device causing problems in this area.

Real PCIe device, yes.  But we have a lot of stuff mascquerading as
such with is just emulated or special integrated.  I.e. a lot of
integrated Intel GPUs claim had issue there.


