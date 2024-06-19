Return-Path: <kvm+bounces-19925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4B0690E415
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 09:12:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4495D1F23C9A
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 07:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 272FE757F3;
	Wed, 19 Jun 2024 07:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VQtpHdXo"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5B46139;
	Wed, 19 Jun 2024 07:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718781114; cv=none; b=sSETAqWBYXsZz7apqrZT3OkcdgVP4ttwA2Tj5KiDZe3Yx6CtayML/1wIgKG777TEQOHfRw8h1r7akjuT2AC0vGRPBYaUI9fELfi+1Ax98xKK4bEOIA5gXPlAmsZDj5qooNrRf+V8pOM+2D7FSiUP2NM6P9YgrgXazbsQZMEYCi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718781114; c=relaxed/simple;
	bh=I6BMr7urVqkHRkOofvwW7G9049g5an3rHmjy9UpkPkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gj/ML2GxISDSbNgI9aupawTf0uCs7SkIlLXbmCWi3BcCFNIUDVbHfd5gxGQq4kZwPBTPtfCxbhM0pTnsEFbRfG7xVSNor95Zyg8ScnJCKwHZQtgaXjLSdsB2XwTn/ERG8PHNm/2YQErN/7tHhX80jzUwXf7l08Advsn/pOcRlfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VQtpHdXo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nlvFZMAkvLJTfCK9T+AzrUEhqJZvzchat7YFdkYhZjU=; b=VQtpHdXoL7GZYinBbsHYIYbzDU
	AINMRCs7yQegfWh++V179ldiyB514epJ6Yu3xhLVriMWd5FGjs+g6yfQcQIOVNj/Lj1lgRHcQPcez
	8ZXikCaXeIpkP3IxpebzOgKgqEkNkfo4XmqVhwWBb5eHIsN1zsaCE7jpRSRnTGFlvBeAzDJ/lyENB
	ZJLoUOtPCGcQg+4wLvbHH2bzJOsmHpV32pUqd7ewSBeU7EYvi/00upJ/0nC2RXPx+jvTele1/C0Uy
	TxPD5ah7MAbBiTNrJr7O4ie00KzdzSD1o6o3RLhG4Z2G9VyllEw+nqdX4dQ2WlJ7jw83Aq67GTRjC
	Idy9gOZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJpU0-000000009BV-147R;
	Wed, 19 Jun 2024 07:11:52 +0000
Date: Wed, 19 Jun 2024 00:11:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/3] vfio/pci: Tolerate oversized BARs by disallowing
 mmap
Message-ID: <ZnKEuCP7o6KurJvq@infradead.org>
References: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
 <20240529-vfio_pci_mmap-v3-2-cd217d019218@linux.ibm.com>
 <20240618095134.41478bbf.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618095134.41478bbf.alex.williamson@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 18, 2024 at 09:51:34AM -0600, Alex Williamson wrote:
> > -		if (!resource_size(res))
> > +		if (!resource_size(res) ||
> > +		    resource_size(res) > (IOREMAP_END + 1 - IOREMAP_START))
> >  			goto no_mmap;
> >  
> >  		if (resource_size(res) >= PAGE_SIZE) {
> > 
> 
> A powerpc build reports:
> 
> ERROR: modpost: "__kernel_io_end" [drivers/vfio/pci/vfio-pci-core.ko] undefined!
> 
> Looks like only __kernel_io_start is exported.  Thanks,

And exported code has no business looking at either one.

I think the right thing here is a core PCI quirk to fix the BAR
size of the ISM device instead of this hack in vfio.


