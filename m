Return-Path: <kvm+bounces-59807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 32DEBBCFB2C
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 20:52:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9969189BC25
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 18:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A65A28488B;
	Sat, 11 Oct 2025 18:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="eY//RnJ/"
X-Original-To: kvm@vger.kernel.org
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418C9246793;
	Sat, 11 Oct 2025 18:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760208751; cv=none; b=P+Uin6oJV5s1y6vnjvOS2n9XGWGAcPcZ3/CX/cPA9zDXWSGxsATe3vhG8fbMoW93KT7XJE0FjNS5bD1hpWb7RNG3epRAzqHnQP7mUlGhlPZv998GPIr8VMvkewoaSDMGjmqunxLpPyEDwaU+JxT89CDMgs0ESJ72MUf6mDEXAsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760208751; c=relaxed/simple;
	bh=0h4gT68eVwzFNQ4ql0PAM2G2QU1YrCNWrtkdF0+rzXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qKSk0tUI65G9imgvVNBqRnGUWBDjcLZdqqZCDzFur63ZoQdsD7O3f2g5oZNXY34a8vCsQGrz2k2uNpTYYCFbHPL9Zb2kwko9JU59sfNdokof3r6KWYpEOzIGSC1EnLhdX0cIsWUzPxvZIg7ZGBW+hctxHc+AHgh+7r6BaC6/LEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=eY//RnJ/; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=8YkkRvntH2lmBxGMbxu5YEt1wQu1wmRQ+IfMdCf3sZk=; b=eY//RnJ/RGfTAsy/4wBgGpvT5V
	68rPc2HiL/gE2jWbClfukl8YGAJuFw8zBulvwWzWVpgoSb5k2Q3JGz2BIoo8Foro+AXdVEWYx1RQr
	F0dkxvJLpxCQsY4N8b0ShZ5QJhZ6GHDNEvk8XqJov3GFPeJ+AuEoCByLaj+Lx9dyotGY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1v7ehW-00AgHw-E5; Sat, 11 Oct 2025 20:52:18 +0200
Date: Sat, 11 Oct 2025 20:52:18 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] virtio: dwords->qwords
Message-ID: <c4aa4304-b675-4a60-bb7e-adcf26a8694d@lunn.ch>
References: <cover.1760008797.git.mst@redhat.com>
 <350d0abfaa2dcdb44678098f9119ba41166f375f.1760008798.git.mst@redhat.com>
 <26d7d26e-dd45-47bb-885b-45c6d44900bb@lunn.ch>
 <20251009093127-mutt-send-email-mst@kernel.org>
 <6ca20538-d2ab-4b73-8b1a-028f83828f3e@lunn.ch>
 <20251011134052-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251011134052-mutt-send-email-mst@kernel.org>

> That's not spec, that's linux driver. The spec is the source of truth.

Right, lets follow this.

I'm looking at

https://docs.oasis-open.org/virtio/virtio/v1.3/csd01/virtio-v1.3-csd01.html

Is that correct?

That document does not have a definition of word. However, what is
interesting is section "4.2.2 MMIO Device Register Layout"

DeviceFeaturesSel 0x014

Device (host) features word selection.
Writing to this register selects a set of 32 device feature bits accessible by reading from DeviceFeatures.

and

DriverFeaturesSel 0x024

Activated (guest) features word selection
Writing to this register selects a set of 32 activated feature bits accessible by writing to DriverFeatures.

I would interpret this as meaning a feature word is a u32. Hence a
DWORD is a u64, as the current code uses.

	Andrew

