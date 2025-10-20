Return-Path: <kvm+bounces-60516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C6A5BF1326
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 14:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 459743AEB7E
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B048B3128B9;
	Mon, 20 Oct 2025 12:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KQhiungt"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDF22F549E;
	Mon, 20 Oct 2025 12:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760963237; cv=none; b=e2v19sLf0CvcZBlyp3WGLMvZluvk1hqpfhO29w6LNbsulC1kbsoXKSgkESo33uDY3z50PSnWCRmEShImgDMfIafV2pZYBMfYjE0nDY2RoHpuRCEKU6ZBnv9HLe0W7q68e38zAdVxctODL7eUcusRcluOsn3LEE/BLHy9iVyoi8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760963237; c=relaxed/simple;
	bh=FWqTuU31olvHn7Eaizpk8jtM+MU3rAxvnzWUJUzSqAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FcbasST5a9TcTg4zWz0dqOhXY2NWoOqso+zeIA7wta9RCSy/8+gRntvQ/lEMjSI+2BQahxSt5vCUQ4XOU6JrpS0sRQ9ol2wS0sJWpPR2+DWmH/wgmXAM5PpE+37pyjr0mrtlUyJBFAKXpgvtbWk03HMMXzSjwcwEV7FLgfkzsP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KQhiungt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jdaQM4uR5JLsKGA0oS0VASYRTZKdaGisbnRnH43EfLY=; b=KQhiungt0DOFTC/2vEdmUu5RdM
	IjizyZW3KhQexecpWhn1JKycVRVYWQTJ9G7l/7owVKfDlpqNGVtDnwK8xwsjX6I64YK5ejanAY0FB
	zzX4HHOKjNYa4wCLEeTShJPyzXTrVdkNr6T+/TruAVmGzKfuVYgSNuwpcWQwRtB1xfAiScls8jaTF
	CtGh0RsnHpRzgHMaS7buG481FDfyI7wa7CD/qzHH4+SgPejuNG/LF4EmwQHr8caZKTi5KEcUFoY9W
	z+5GpLZZYb6wF0dThq4Fmcc6GulKZn6HurCZW1AoO7vNphT4pMFJzXHY8iCTyrAiXmSBWSKpPvYGt
	H76pYSOw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAoyc-0000000DPQg-3mdN;
	Mon, 20 Oct 2025 12:27:02 +0000
Date: Mon, 20 Oct 2025 05:27:02 -0700
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
Message-ID: <aPYqliGwJTcZznSX@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <1044f7aa09836d63de964d4eb6e646b3071c1fdb.1760368250.git.leon@kernel.org>
 <aPHibioUFZV8Wnd1@infradead.org>
 <20251017115320.GF3901471@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017115320.GF3901471@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 17, 2025 at 08:53:20AM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 16, 2025 at 11:30:06PM -0700, Christoph Hellwig wrote:
> > On Mon, Oct 13, 2025 at 06:26:03PM +0300, Leon Romanovsky wrote:
> > > The DMA API now has a new flow, and has gained phys_addr_t support, so
> > > it no longer needs struct pages to perform P2P mapping.
> > 
> > That's news to me.  All the pci_p2pdma_map_state machinery is still
> > based on pgmaps and thus pages.
> 
> We had this discussion already three months ago:
> 
> https://lore.kernel.org/all/20250729131502.GJ36037@nvidia.com/
> 
> These couple patches make the core pci_p2pdma_map_state machinery work
> on struct p2pdma_provider, and pgmap is just one way to get a
> p2pdma_provider *
> 
> The struct page paths through pgmap go page->pgmap->mem to get
> p2pdma_provider.
> 
> The non-struct page paths just have a p2pdma_provider * without a
> pgmap. In this series VFIO uses
> 
> +	*provider = pcim_p2pdma_provider(pdev, bar);
> 
> To get the provider for a specific BAR.

And what protects that life time?  I've not seen anyone actually
building the proper lifetime management.  And if someone did the patches
need to clearly point to that.

> I think I've answered this three times now - for DMABUF the DMABUF
> invalidation scheme is used to control the lifetime and no DMA mapping
> outlives the provider, and the provider doesn't outlive the driver.

How?

> Obviously you cannot use the new p2provider mechanism without some
> kind of protection against use after hot unplug, but it doesn't have
> to be struct page based.

And how does this interact with everyone else expecting pgmap based
lifetime management.


