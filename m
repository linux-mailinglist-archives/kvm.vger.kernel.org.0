Return-Path: <kvm+bounces-28836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A87AC99DD03
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 05:48:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9AD01C21572
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 03:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D5D171E5F;
	Tue, 15 Oct 2024 03:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vDeMPD1N"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5538A46B8;
	Tue, 15 Oct 2024 03:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728964111; cv=none; b=KigdZuE7jGXrYHyaOFGdFOH3UqKuOkIQlOxpXJUy+qZN6Uzj9HSZ1cDfzs8HzcAb8zBNds0G9uhCcBEORIh4gJBTGRtFGjMQ6rFl3yXVCYtXqiN9Vn8HDsOvvarWWLo9Hkn5Cr5trH/2R7AefspUd3z6aL567hpjSLCKdYWoQK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728964111; c=relaxed/simple;
	bh=drrTDQ8js09DBGoaGl0soaU1qoiSTaK56Ft3tPyADfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRDmIXTiw18dD+gWAcUWVlO0h1o/UZJazLfqPJQ5AL26OEwdJuBfaqt0udy76mS9fp1LfMRkvWuReNzRroAKEqcQjCUKMoq+5WNl9SZbe85HVB0FZtpDX5KxG+FFf2fBhtD/CXABvkSnuK8HCDqqmS51nkpe5OewUDtmzFQpfHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vDeMPD1N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hRok9Qp1s40lbPIjtmrDMQyfxjUxa5tARAxC/U2urus=; b=vDeMPD1NaNZ3bgCFl/93z/j5kS
	E0Y3xLCNOasek26fefo0kbWbUd4p10GMWNWk9k4Ej0xMGhtV34g7mJ+s4abdFyuvCalUf+a+6RJPF
	JFpOuXePqLYF4yNVEmbo4qJdo7JVRWGV2s9YoFTIvZSerRIL6VxMCwlUVBIN2CMaxUoIkqwE3noyQ
	U+4Gr3B216rKQZ7BpBYbYFhVkJvu8tMVSI+79Htv8ycEQmumovcSZRD7xo634df0MpCFp0pK7ZFF/
	TADT8Pm1vl9G92FL4xLJj/KvVdw4mwBNcJs4aq7LnG5UsejCY55vQB/SFierXXYk8jRTdZ6Xn8eLW
	7inb/vsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0YXr-000000070ar-25ie;
	Tue, 15 Oct 2024 03:48:27 +0000
Date: Mon, 14 Oct 2024 20:48:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Srujana Challa <schalla@marvell.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"mst@redhat.com" <mst@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>,
	Jerin Jacob <jerinj@marvell.com>
Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Message-ID: <Zw3mC3Ej7m0KyZVv@infradead.org>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 14, 2024 at 01:18:01PM +0000, Srujana Challa wrote:
> > On Fri, Sep 20, 2024 at 07:35:28PM +0530, Srujana Challa wrote:
> > > This patchset introduces support for an UNSAFE, no-IOMMU mode in the
> > > vhost-vdpa driver. When enabled, this mode provides no device
> > > isolation, no DMA translation, no host kernel protection, and cannot
> > > be used for device assignment to virtual machines. It requires RAWIO
> > > permissions and will taint the kernel.
> > >
> > > This mode requires enabling the
> > "enable_vhost_vdpa_unsafe_noiommu_mode"
> > > option on the vhost-vdpa driver and also negotiate the feature flag
> > > VHOST_BACKEND_F_NOIOMMU. This mode would be useful to get better
> > > performance on specifice low end machines and can be leveraged by
> > > embedded platforms where applications run in controlled environment.
> > 
> > ... and is completely broken and dangerous.
> Based on the discussions in this thread https://www.spinics.net/lists/kvm/msg357569.html,
> we have decided to proceed with this implementation. Could you please share any
> alternative ideas or suggestions you might have?

Don't do this.  It is inherently unsafe and dangerous and there is not
valid reason to implement it.

Double-Nacked-by: Christoph Hellwig <hch@lst.de>

