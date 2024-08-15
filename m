Return-Path: <kvm+bounces-24227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66C759528B6
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 07:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21E57287750
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 05:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E7856742;
	Thu, 15 Aug 2024 05:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ae/UEYWx"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772295381B
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 05:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723698309; cv=none; b=giaxhBLKGg7cFguABG2XUbkbJbPuD4Z6PwukjTLoYvsGh7GBl2G6kooKZ10NXj710K37BTXBNh8dg6Z0WAAbNIOp6k/XvFza1bqx+3sxa3JlCnZXL7R0fryQ5Alv8Nq4IBVr6mTpa7vLDMeyajUX9WZKjtX39T5pMxMLySBNX9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723698309; c=relaxed/simple;
	bh=PA5Hwj+tfgC6UoZCE/5fxSQR+GLHW6h7nA1pX+OUEMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E5RFrbp1CokTW3b+Iu3zWIIyNlq0njAqJG2rbVeSS3FkBia7uneLYikDO9Z+fWuonESNiN3ZR83V1kvQq3WE+C5YcFvP4ITDCw14A2wAAqCHpTJW1sgELpB6/658kZ6r12B6AT9DWYvogBpJIiKDbR4hfsB+7UPrbFd/38hLMDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ae/UEYWx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5H163FAIJf+dNKAeDC1P4tskQtErqFRv7CGKy1izrqo=; b=Ae/UEYWx+pwHkeXMkJ8fj3eNZv
	QBsNGhjI7ErsjKR4IAR7mX3X4B/zUpfphe1eUaa2ysLZoFz2ZtJZ0fsPGCRLMbvJ/NDc6lCsRjrBY
	xVw+O0S0oHOnvk79zBtNSBONi+FiJPwNjaQYhb7XOCtCnugy2ShPQGVm2d7PFOTczVOO8876MX9UH
	P0uU01+PbXqQvaMeWOMgiDfkCj3jQMV4OIjKH/tRXGHD/l9XOW6JKZ/21JBGi2xKO7yvis3qnzex6
	TTMNormUxWvW1Pq9j22oedeWUDzMLt4/Jna8F7XKjZlBzLuVqYsJRl98bFu1VYTsUHiNfW5YS/xPE
	J7YjG10A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1seSfa-000000092Bh-0wzn;
	Thu, 15 Aug 2024 05:05:06 +0000
Date: Wed, 14 Aug 2024 22:05:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Keith Busch <kbusch@meta.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <Zr2Mgst5KNCvUlhV@infradead.org>
References: <20240731155352.3973857-1-kbusch@meta.com>
 <20240801141914.GC3030761@ziepe.ca>
 <20240801094123.4eda2e91.alex.williamson@redhat.com>
 <20240801161130.GD3030761@ziepe.ca>
 <20240801105218.7c297f9a.alex.williamson@redhat.com>
 <20240801171355.GA4830@ziepe.ca>
 <20240801113344.1d5b5bfe.alex.williamson@redhat.com>
 <ZqzsMcrEg5MCV48t@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqzsMcrEg5MCV48t@kbusch-mbp.dhcp.thefacebook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Aug 02, 2024 at 08:24:49AM -0600, Keith Busch wrote:
> Which itself follows the existing pattern from
> pci_create_resource_files(), which creates a write combine
> resource<X>_wc file only when IORESOURCE_PREFETCH is set. But yeah,
> prefetch isn't necessary for wc, but it seems to indicate it's safe.

Apparently IORESOURCE_PREFETCH never implied anything about write
combinability, and Linux got this wrong long time ago.  The fact that
we do this now clashes with PCI SIGs desire to kill the concept of
prefetcable BARs that they are forcing down everyones throat.


