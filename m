Return-Path: <kvm+bounces-61323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EEF45C16E55
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:14:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 95646354B0A
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 21:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68F8C34AB1C;
	Tue, 28 Oct 2025 21:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="opwuj9wX"
X-Original-To: kvm@vger.kernel.org
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85652D9786;
	Tue, 28 Oct 2025 21:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686077; cv=none; b=MLJEpyJjwMp9TgV3FV8JZQrf5mjQzxU7gVKXd4KNdbk5DzllHl114P0vCP32aPgS/sayYrRrSQWqTDrofVevM7N0gxuVcoLdFCFUnXnCqVPhW3Cnbf8FOtahCrm0MXPDdh5nQVxa87E0WWYL02RZfZDjN0Z7UyzCOrj3tYUOtec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686077; c=relaxed/simple;
	bh=pDCaA3VtdEbST9/sHZ9aSHefMi7n6DjY3k6UpztZQL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pHrx9Krl00RsZygYxJRNHk1OfRdK1nDLOZ/SZyQQBs6aprJaOwPz6jr2QzD0DaBaoL7DpHOkCt16h1oyuYVpZG8WBbnfECyAWW0seFT+Buken5Wy1p0EMiYOLmdt76+2ma3/e4Ica7oJEGIRhXXZwUDerKYLVE4OVPAS+CgKTf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=opwuj9wX; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=shB4MkKGkpHGmnR7F+tNaXY9sMT0VsGN2rfRsljJlhY=; b=opwuj9wXcdKgSQXPJMWmZ658vg
	00cNG99rdVeKyzB08G0hX0usoim3DXl9oM4Zs8qy4+gDObVOESw5oQ71XbLvh/fFPKwjAFCzQSFSP
	/v6xS2Ij/SiJCQg/AuciRZS15nfPwmAQcXltVUxrljdCrAW5OL4q1Ln58fYRdVfIkj7c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1vDr1R-00CKhH-Lk; Tue, 28 Oct 2025 22:14:29 +0100
Date: Tue, 28 Oct 2025 22:14:29 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Nick Hudson <nhudson@akamai.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Max Tottenham <mtottenh@akamai.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vhost: add a new ioctl VHOST_GET_VRING_WORKER_INFO
 and use in net.c
Message-ID: <881d2462-895c-4ee6-a530-957a8dbac072@lunn.ch>
References: <20251028152856.1554948-1-nhudson@akamai.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028152856.1554948-1-nhudson@akamai.com>

On Tue, Oct 28, 2025 at 03:28:54PM +0000, Nick Hudson wrote:
> The vhost_net (and vhost_sock) drivers create worker tasks to handle
> the virtual queues. Provide a new ioctl VHOST_GET_VRING_WORKER_INFO that
> can be used to determine the PID of these tasks so that, for example,
> they can be pinned to specific CPU(s).

Could you add something about the lifetime of the PID. How do you know
the PID still belongs to the worker by the time you come to use it?

	Andrew

