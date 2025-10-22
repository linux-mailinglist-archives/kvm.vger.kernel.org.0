Return-Path: <kvm+bounces-60806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 716C0BFA79D
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 09:11:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 07ECF4F7E57
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 07:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3519E2741C9;
	Wed, 22 Oct 2025 07:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LA0EsnIv"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE09C223DF0;
	Wed, 22 Oct 2025 07:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761117040; cv=none; b=llLFe7P+K9TDnuZyWV9OaYC5yPXIN9zKkVqGmiRFJhqvBGKxKdFsaF+IewXqaSV62tMRv+zbXvaqOp+ngfemHbH/wYnd4wR6yyWE7x9Yo+9gzDgpikvMgAYS2FeQRR0oD54xbUwOZeXRTIJFsNwY9qCuMTvj7qDb09UioCRnN6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761117040; c=relaxed/simple;
	bh=dluSQgYEPQexXX9fFOmxg4O5613AanDzlWmOrb+I2OY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBSb6z1ciS8C1VULXda8C15kgt6QnXApG2cT4X4XDg5GXInMsniO0R/l4vCQdcFwbHLJdu4J3BwKb66BOQuv2FGmRUzUS6J1dk+nWBWN8aJkWFsj2j1AFKN7ri6AYXZiOaBinmBZYhj6cI3xqN3F22ayFDcWk9VkUArvmfXxGbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LA0EsnIv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=XKoyGCto+Kn0HeCK5i87kYlf6+Be8yWE+pzHWLeDEO0=; b=LA0EsnIvPmdhyAlKnWiGNmOL5l
	dPh0nZUevEw5pwm6HBBuRxpL+2yfoJmbOBQlWDuYglG8QtuSjZzDWUqtSadQ1OFRPkGGDZwk02eQl
	Bu+qOaq4hhb9Bd5VhP+RGw6wG8tKjt+oR0eO64ab5IIneyp3/JhLSsBpmjpjM5a/ycj97uOgmYi+/
	Y1cRAulWoHfCg1kdfl5Alide/1gYw2Rn+VvkITIlqp8loD9nJTP6eJ8kMFPCR/UpvZDtjb6axkHGz
	ZZPEPI9OgbKn0k/f8YRe21WllooKBtsnBOVhBULD9Jfr3RGKlOgLor3ceNm20eilmCX59TC4cQ8TU
	Mj/Wx7eQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBSzT-00000001oYi-2Iys;
	Wed, 22 Oct 2025 07:10:35 +0000
Date: Wed, 22 Oct 2025 00:10:35 -0700
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
Subject: Re: [PATCH v5 1/9] PCI/P2PDMA: Separate the mmap() support from the
 core logic
Message-ID: <aPiDa-QruoHC3alk@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <1044f7aa09836d63de964d4eb6e646b3071c1fdb.1760368250.git.leon@kernel.org>
 <aPHibioUFZV8Wnd1@infradead.org>
 <20251017115320.GF3901471@nvidia.com>
 <aPYqliGwJTcZznSX@infradead.org>
 <20251020125854.GL316284@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251020125854.GL316284@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 20, 2025 at 09:58:54AM -0300, Jason Gunthorpe wrote:
> I explained it in detail in the message you are repling to. If
> something is not clear can you please be more specific??
> 
> Is it the mmap in VFIO perhaps that is causing these questions?
> 
> VFIO uses a PFNMAP VMA, so you can't pin_user_page() it. It uses
> unmap_mapping_range() during its remove() path to get rid of the VMA
> PTEs.

This all needs to g• into the explanation.

> Instead the DMABUF FD is used to pass the MMIO pages between VFIO and
> another driver. DMABUF has a built in invalidation mechanism that VFIO
> triggers before remove(). The invalidation removes access from the
> other driver.
> 
> This is different than NVMe which has no invalidation. NVMe does
> unmap_mapping_range() on the VMA and waits for all the short lived
> pgmap references to clear. We don't need anything like that because
> DMABUF invalidation is synchronous.

Please add documentation for this model to the source tree.


