Return-Path: <kvm+bounces-59844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BECD5BD041E
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 16:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4AFA54E8ABC
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 14:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25E3328EA72;
	Sun, 12 Oct 2025 14:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="JfOQ3fs1"
X-Original-To: kvm@vger.kernel.org
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485D4286410;
	Sun, 12 Oct 2025 14:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760279970; cv=none; b=LcmSeS53dfVJozeD9ZCScq53/0rtBr1blBXLBEcJu3mXcexWTANrraH7iokxBzhOAqEKnW0MmOT8/isjiGuVhU/a3wOENkpffUYNCVc83SPNuVScZVn58dA0eZzB83l6TcYp9VZMfwjBqeJCaYHdKiNL734fuLCV9Ce9QMMJMWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760279970; c=relaxed/simple;
	bh=x6FSE8met5AznBx0nG+InQuLDKapbD1HCiqAUrGl3Hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4hMpVfEoKFXLhuTKQjfmD+VVhtXz6BsCJBlzCrvjahyT0AZs5v4W9n6AdS+MFoANHGylHV8nb6RiSrV3Wu9IAgTHFOXxOG2/lnWsQCDGimHwuttMyLxlzsweuux1BD5yvWYrbW0zBFAts5X6cO7VLVt73sHmr5PGaAU+n2OSF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=JfOQ3fs1; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=TK2hWIUtjAnJM/hdPpjlq0MuFNzIMqUI6yKD+EQ1tVI=; b=JfOQ3fs1Apv6Xi2EDQX2sOW9C+
	tbwX7vKlePJtBM0fqoPd3FYDbX66CAUwh+ucfwD2fYMip+UANEdCQmH0lGlq2nAQ3LIniGL0SAJPc
	D3jxRKrqOaqRUTZbV/hxKcb+FK0n9t46aVzq6YZWOIxSYL9Gzz8PBw4eqDf6ViXi7X78=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1v7xE2-00AiRk-Bj; Sun, 12 Oct 2025 16:39:06 +0200
Date: Sun, 12 Oct 2025 16:39:06 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] virtio: dwords->qwords
Message-ID: <36501d9c-9db9-45e6-9a77-1efd530545ee@lunn.ch>
References: <cover.1760008797.git.mst@redhat.com>
 <350d0abfaa2dcdb44678098f9119ba41166f375f.1760008798.git.mst@redhat.com>
 <26d7d26e-dd45-47bb-885b-45c6d44900bb@lunn.ch>
 <20251009093127-mutt-send-email-mst@kernel.org>
 <6ca20538-d2ab-4b73-8b1a-028f83828f3e@lunn.ch>
 <20251011134052-mutt-send-email-mst@kernel.org>
 <c4aa4304-b675-4a60-bb7e-adcf26a8694d@lunn.ch>
 <20251012031758-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251012031758-mutt-send-email-mst@kernel.org>

> > DeviceFeaturesSel 0x014
> > 
> > Device (host) features word selection.
> > Writing to this register selects a set of 32 device feature bits accessible by reading from DeviceFeatures.
> > 
> > and
> > 
> > DriverFeaturesSel 0x024
> > 
> > Activated (guest) features word selection
> > Writing to this register selects a set of 32 activated feature bits accessible by writing to DriverFeatures.
> > 
> > I would interpret this as meaning a feature word is a u32. Hence a
> > DWORD is a u64, as the current code uses.
> > 
> > 	Andrew
> 
> 
> Hmm indeed.
> At the same time, pci transport has:
> 
>          u8 padding[2];  /* Pad to full dword. */
> 
> and i2c has:
> 
> The \field{padding} is used to pad to full dword.
> 
> both of which use dword to mean 32 bit.
> 
> This comes from PCI which also does not define word but uses it
> to mean 16 bit.

Yes, reading the spec, you need to consider the context 'word' is used
in. Maybe this is something which can be cleaned up, made uniform
across the whole document?

> I don't have the problem changing everything to some other
> wording completely but "chunk" is uninformative, and
> more importantly does not give a clean way to refer to
> 2 chunks and 4 chunks.
> Similarly, if we use "word" to mean 32 bit there is n clean
> way to refer to 16 bits which we use a lot.
> 
> 
> using word as 16 bit has the advantage that you
> can say byte/word/dword/qword and these do not
> cause too much confusion.

> So I am still inclined to align everything on pci terminology
> but interested to hear what alternative you suggest.

How about something simple:

#define VIRTIO_FEATURES_DU32WORDS	2
#define VIRTIO_FEATURES_U32WORDS	(VIRTIO_FEATURES_D32WORDS * 2)

or, if the spec moves away from using 'word':

#define VIRTIO_FEATURES_U64S	2
#define VIRTIO_FEATURES_U32S	(VIRTIO_FEATURES_U32S * 2)

The coding style says not to use Hungarian notation, but here it
actually make sense, and avoids the ambiguity in the spec.

	Andrew

