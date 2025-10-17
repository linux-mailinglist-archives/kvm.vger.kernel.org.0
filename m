Return-Path: <kvm+bounces-60277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5899ABE6AC4
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 08:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4817F4E3880
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 06:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 108BC30FC02;
	Fri, 17 Oct 2025 06:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FfObMG0/"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B36423B60C;
	Fri, 17 Oct 2025 06:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760682613; cv=none; b=sAHRovrfgMHatl73LHfcNEMmZMAKUy/w8Nx7vv7ZGAtiK+09v5+iqdyWgFNxmVdSwLYUoSz6/zVuqR5dKvGSHCAqu+Twkn10bEkG7LAiuAHdaS5Z5SNG+7N26/5EGH9eyLRwI9OJf+pSX2+GAiXgSO2BaGDow232xMT3dYRj+iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760682613; c=relaxed/simple;
	bh=ahQFGH87qB+/TCHDG5C5jHfcBfMTOADdvVwEPm1tBcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WqQMHQwfUggt0JFFx6Q0l1lRnvI/Hx39xwwoBJwj4S9QliFp+ClgzeekwAtK+tuOBEogQ5CvKzKxwW4rm2ZniblGy6CAlWOOVEs19Atjg6RHSV7eKMq2aXKtNsPobDPHiQvMMsb3CO7bT0yl5HIjmfOSWpSDok6b6tg83GXpS9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FfObMG0/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7pd8xu2BQLfOjempHtq7iHnkhNuH0dguXz1a13wDXOQ=; b=FfObMG0/tRIyrpoLwagMgvca16
	ZBCXDWqMeZdoS/MkWG/P0NiNjEObHEld5ZrPkjGCYV9ht7av76XBdbzq+UHINeirBZSMjnv5iGAF6
	pJB+mcw13Grq4C5oq8umF4dIhZkQXk5UW7gi0gp74MglLK8g/bcf90kHvTe4EA9Y3231+veU5nPp6
	qVaJDBvzWZ58NbVAASJSU45+HmKPK9o1e/lIAXcS7KDAvBhiYpjnepl6/ptnGwBjRDbo0V5PHbk1x
	V71HMJ9pcrRpCGvX+EEo5h8TCxTuIy18KwdQsjnR7rxLfY0FFb8DO4O1/RLTpsn+yc+z6mXGaRhzz
	O7iEvjlA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9dyY-00000006mal-41MA;
	Fri, 17 Oct 2025 06:30:06 +0000
Date: Thu, 16 Oct 2025 23:30:06 -0700
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
Subject: Re: [PATCH v5 1/9] PCI/P2PDMA: Separate the mmap() support from the
 core logic
Message-ID: <aPHibioUFZV8Wnd1@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <1044f7aa09836d63de964d4eb6e646b3071c1fdb.1760368250.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1044f7aa09836d63de964d4eb6e646b3071c1fdb.1760368250.git.leon@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 13, 2025 at 06:26:03PM +0300, Leon Romanovsky wrote:
> The DMA API now has a new flow, and has gained phys_addr_t support, so
> it no longer needs struct pages to perform P2P mapping.

That's news to me.  All the pci_p2pdma_map_state machinery is still
based on pgmaps and thus pages.

> Lifecycle management can be delegated to the user, DMABUF for instance
> has a suitable invalidation protocol that does not require struct page.

How?


