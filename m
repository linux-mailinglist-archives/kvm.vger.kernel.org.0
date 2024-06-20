Return-Path: <kvm+bounces-20038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 725CB90FBD8
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 06:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 169EA1F224DC
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 04:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA5F2B9DB;
	Thu, 20 Jun 2024 04:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jq1KRo9e"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64901DA4E;
	Thu, 20 Jun 2024 04:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718856600; cv=none; b=UZI7sasZ7hITIs9dyJbgm2MiiUrBgkJjbs32JsECbsg3FrYmtorA1AMX4NONzPLaO/ugTWWz1U41d7vf6uJbCq9HeC102F30u8cTWMQbF4eLSJAuP+aK1SXA0mLQNxdGul1AVxd1MPQkmDBycebqF4MCbeA4btva5+XbEatLKfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718856600; c=relaxed/simple;
	bh=iJsMX5524mFToCj+FEJuOmHaWKE/c+jREBhQLu3dJtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9PGl3pX+kOwAUNBPL31aNpbtkF3UHR1Gn4RQVQkfRz9OpDWGj6UeZGo72d4HVKonz1XlDDfFyqrGrFfxqQr/ASlkwUfmQP3SsM02Jxgu9NDGfZ74Gb0rhrXf8vdc5QBPkp/s1f6Y9pGQu2FO0MzGigqRNpmNGf0gOHMELiSq3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jq1KRo9e; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6TOQyDostt3/ZLFBNjYuARI255CyBwhymG/tQVPb5MQ=; b=jq1KRo9eNQ6B6sSpElNd5FGuvB
	WinOEbu13YF1b33fbKP6UzVCwc2ZPR31/wBIq/cUcc39DM1xXDZ78NS85+5oLAiz6WbisrFcEyLj/
	NNf0V5hFrlXq81tZFpdtGmsTjCBQNFubyLW+UFZWKao3m14dn6LgmfnBLXWKarDOjCuVRXaqpY0xV
	Un6u65+ki/nDFa+woHzsgSjOMWt0zi5CdKXUPfmaD3LW3fAXpEyLZBab0xiuZ0Q8yHONE5HHJuKRD
	AzGxUqSjBlg+cTkOvOuzT/QP7H/+WA1pxAqYw5mNq+piAndW0FvcBwJ9lt5NB9cfffAYRvH5P+eoi
	kfQSyn1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sK97U-00000003XWT-0RzC;
	Thu, 20 Jun 2024 04:09:56 +0000
Date: Wed, 19 Jun 2024 21:09:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <ZnOrlB6fqYC4S-RJ@infradead.org>
References: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
 <20240529-vfio_pci_mmap-v3-2-cd217d019218@linux.ibm.com>
 <20240618095134.41478bbf.alex.williamson@redhat.com>
 <ZnKEuCP7o6KurJvq@infradead.org>
 <76a840711f7c073e52149107aa62045c462d7033.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76a840711f7c073e52149107aa62045c462d7033.camel@linux.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 19, 2024 at 12:56:47PM +0200, Niklas Schnelle wrote:
> In short, the ISM BAR 0 is stupidly large but this is intentional. It
> not fitting in the VMAP is simply the least crazy filter I could come
> up with to keep the ISM device from causing trouble for use of vfio-pci
> mmap() for other, normal, PCI devices.

Then maybe add a PCI quirk to prevent mapping it.  This would also
affect the sysfs resource0 file unless I'm missing something.


