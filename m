Return-Path: <kvm+bounces-29128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6ED49A3434
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 07:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7636F285874
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 05:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B8917B516;
	Fri, 18 Oct 2024 05:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BZQd4OeF"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4558E20E30D;
	Fri, 18 Oct 2024 05:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729229047; cv=none; b=HPTsqoz/dDmTodXB8GHl6JzqOpo0+QpY7ECph0R2FyUNDfheV7ksHM2a7K4DB5yIvsVrolxuncSXle5nK5A/OBi3FxcJajmUfLE09qMFtEQjNneqCtIFJrsufopw8jIXwONTyABTYupYXApbFiNsmmH1Vlux10JvlKU1pLempsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729229047; c=relaxed/simple;
	bh=3ZKsCUkZWNUPDJ9DbtgUYXmmC/Z9bWQJVtySt7SECo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvWS4KZuXR1j8ImhdmHXhEflqcrUuSn6i1qxmE91UVhL8bna/QyXmsylhO5YFjP2vq8rqAk99ddpoyMWua5UwBnqmIXHlhP9UYiBPrTw8kFf0yJxrQvU220jPtf+il5s63NRmaTCQJ0/3KgpGeXtM0aC9csSLZBsxXh9IQGy2k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BZQd4OeF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ujLsC95NRQUFB1sYDO5embkBUTcaVaC92ecoVw3I32E=; b=BZQd4OeFMWpPfU0amgNkRW/4l/
	7QXnfbWXbNq11JmbhNNAoqsCGq0Q2c5RSRw9YmAL0ZWdOpxY1QY0Xf2nGHLFirdzABBYajcOPW4BT
	X/m+tvh0cvQ5A3ERtOakCTrD/LnTQT6aM22aiorCSoX/Gb1g6YiouV6ktehYaG5R0sYGGkozpaS9A
	deq3U0MeF4QR5A+VzZdywC5Eav60yIO+WEpnMJULjX5tjadC0v9JNHdNcLzTEh7Adx1jDzP04lb9l
	66NDptNLkHwBPj882TwCoH0UbENK7GkeQOqH4TtT5D54L+5zxmpMAQ0MbgaQlMXoRU4q1kzZCsWQB
	isjILU7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t1fT3-0000000GxsR-3OxN;
	Fri, 18 Oct 2024 05:24:05 +0000
Date: Thu, 17 Oct 2024 22:24:05 -0700
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
Message-ID: <ZxHw9dZ-EolHR0k3@infradead.org>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
 <DS0PR18MB5368CB509A66A6617E519672A0462@DS0PR18MB5368.namprd18.prod.outlook.com>
 <ZxCsaMSBpoozpEQH@infradead.org>
 <DS0PR18MB53686815E2F86EFC5DFE1E45A0472@DS0PR18MB5368.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR18MB53686815E2F86EFC5DFE1E45A0472@DS0PR18MB5368.namprd18.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 17, 2024 at 08:53:08AM +0000, Srujana Challa wrote:
> We observed better performance with "intel_iommu=on" in high-end x86 machines,
> indicating that the performance limitations are specific to low-end x86 hardware.

What does "low-end" vs "high-end" mean?  Atom vs other cores?

> This presents a trade-off between performance and security. Since intel_iommu
> is enabled by default, users who prioritize security over performance do not need to
> disable this option.

Either way, just disabling essential protection because it is slow
is a no-go.  We'll need to either fix your issues, or you need to use
more suitable hardware for your workload.

