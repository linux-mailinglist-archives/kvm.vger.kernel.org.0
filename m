Return-Path: <kvm+bounces-27759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6B5798B780
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 10:49:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BFB31C22669
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 08:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D3719FA98;
	Tue,  1 Oct 2024 08:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rWN2w4Jr"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEB619F466;
	Tue,  1 Oct 2024 08:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727772448; cv=none; b=gaJYcnRJdgnPpmPJA9dRpS7bZBAlHpC0pzcyR6ZAzNsBQqWzCcMN2e8/pLajmLyjArtX6XYs78UauNkXQKDKQJNz8COgb/dytFxWCqB7KEwMyHJww7yDG2zlnBvE+H1qKRgAXTwLQs9SroKBbwt4ncs0o/YQtbmIAFZah6jrNwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727772448; c=relaxed/simple;
	bh=+gaPzNsCZQOr4VCJ8VidECoUZMzdtDuIZk/Lnk/iwW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=guDufRE4LnwZPvsrCegdrmScXYtdNUSdaGI/zRAfhbOoltMvBqSX5IUXlqjYoTeyA0Of/P3NOAvkUfO0ssLYvruCnjQDFv2v6E0ghxyW9p7OtEvV4lOamaoOrwVfSm1BquKlArQrR8fVPu1NCu58Vvpui72bmG2SwiGUliAUZFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rWN2w4Jr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=q1nkpS6A5NXCi237YqhQxNqBbwH4xTO/TAMf/Y2ZkoE=; b=rWN2w4Jr5zbVYy8b6B9XdGXa/U
	f+mcqFz/ct2x5PguuXGbA/XQmGiOcUKODU9abUZ4DXDqEx5bf8BEcIIVtEzljI9dlGiirIyEtkN6Z
	6eUgflJtnSPq2jXrCxmMciNitfQprnL4y+Fz+RyqbEqzxxWk6Tn3MsYSDLEswL9WW6ld05wJ81gMY
	nEdDT6omPrBHKn8JU2wAyX9bJaQVJlbZjuUJes3DkhJ8tkPrKUrHt8X+cdKTe3F0/A3dak6cLr3rs
	g/XRKEWnCPjYrJEWh3KOKDKi+D2Z1slM55blII4GM9AOpgz1rzv5+kRhciwsi3jpt22tp/29ScivR
	XOwTlcPQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svYXW-000000027nP-3dbR;
	Tue, 01 Oct 2024 08:47:26 +0000
Date: Tue, 1 Oct 2024 01:47:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Srujana Challa <schalla@marvell.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org, mst@redhat.com,
	jasowang@redhat.com, eperezma@redhat.com, ndabilpuram@marvell.com,
	jerinj@marvell.com
Subject: Re: [PATCH v2 0/2] vhost-vdpa: Add support for NO-IOMMU mode
Message-ID: <Zvu3HktM4imgHpUw@infradead.org>
References: <20240920140530.775307-1-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240920140530.775307-1-schalla@marvell.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 20, 2024 at 07:35:28PM +0530, Srujana Challa wrote:
> This patchset introduces support for an UNSAFE, no-IOMMU mode in the
> vhost-vdpa driver. When enabled, this mode provides no device isolation,
> no DMA translation, no host kernel protection, and cannot be used for
> device assignment to virtual machines. It requires RAWIO permissions
> and will taint the kernel.
> 
> This mode requires enabling the "enable_vhost_vdpa_unsafe_noiommu_mode"
> option on the vhost-vdpa driver and also negotiate the feature flag
> VHOST_BACKEND_F_NOIOMMU. This mode would be useful to get
> better performance on specifice low end machines and can be leveraged
> by embedded platforms where applications run in controlled environment.

... and is completely broken and dangerous.


