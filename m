Return-Path: <kvm+bounces-59710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C515BC9099
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 14:33:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3A8D54FCEEB
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 12:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D602E2F14;
	Thu,  9 Oct 2025 12:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="nDxOT2aX"
X-Original-To: kvm@vger.kernel.org
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390AF33D8;
	Thu,  9 Oct 2025 12:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760013082; cv=none; b=DqTN++vnfwiYTCiyRn8dmUl1Y8yKKPdA7Otnu9TGyIXisCK6/rtx7pqFTY1H6RSTq1+kUuHQlkWRIzA+7Vt05hacfGYdG5C30Z88wI6PQnKDXoGlZx4Z9L1NBfrR4TA77Tawc/HGHSO7zGKhccmO3EAVHWpTJo6spdZnxlVtJI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760013082; c=relaxed/simple;
	bh=XPmYz1+S+KmqCCD+ZvfFDpmo5B52l9HJF9/qsIYDbzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjuRN+CS6fe9FMytNaR635/KxZ7Hdtojddp1DNPtdjs+GoOjXPjplu4wG2uoCOUGcYAyOKiR23rVH4VrgaRyMTSbJl7jp5mYcne0Kz88fZXVAKYZe50uTNhhTXEF/dh3onHl2+vfVqWXFce65Nwrdlx0bemDaCQBxuYENedO2yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=nDxOT2aX; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=eEnoEiQ7x1UW7OqzKfZDiRlKLyvfXySawEDXrSsRNZM=; b=nDxOT2aXHKfgtvt73Y53cNnEOJ
	dqFm8I9mcp7+6v1i/XBbEByG4WEStfNHUweOq55ppwh4fUCdj0BsWknE1fTtZvFwzUxOpPOh4c9Wh
	LIRI5ZVc+DsDaHVFmL18Rp+jsmMyb9iQ/mlvMmkN7ZZqCvrFSaeQNy9Srs0CmVEGtqtQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1v6pnU-00AWj0-SY; Thu, 09 Oct 2025 14:31:04 +0200
Date: Thu, 9 Oct 2025 14:31:04 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] virtio: dwords->qwords
Message-ID: <26d7d26e-dd45-47bb-885b-45c6d44900bb@lunn.ch>
References: <cover.1760008797.git.mst@redhat.com>
 <350d0abfaa2dcdb44678098f9119ba41166f375f.1760008798.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <350d0abfaa2dcdb44678098f9119ba41166f375f.1760008798.git.mst@redhat.com>

On Thu, Oct 09, 2025 at 07:24:08AM -0400, Michael S. Tsirkin wrote:
> A "word" is 16 bit. 64 bit integers like virtio uses are not dwords,
> they are actually qwords.

I'm having trouble with this....

This bit makes sense. 4x 16bits = 64 bits.

> -static const u64 vhost_net_features[VIRTIO_FEATURES_DWORDS] = {
> +static const u64 vhost_net_features[VIRTIO_FEATURES_QWORDS] = {

If this was u16, and VIRTIO_FEATURES_QWORDS was 4, which the Q would
imply, than i would agree with what you are saying. But this is a u64
type.  It is already a QWORD, and this is an array of two of them.

I think the real issue here is not D vs Q, but WORD. We have a default
meaning of a u16 for a word, especially in C. But that is not the
actual definition of a word a computer scientist would use. Wikipedia
has:

  In computing, a word is any processor design's natural unit of
  data. A word is a fixed-sized datum handled as a unit by the
  instruction set or the hardware of the processor.

A word can be any size. In this context, virtio is not referring to
the instruction set, but a protocol. Are all fields in this protocol
u64? Hence word is u64? And this is an array of two words? That would
make DWORD correct, it is two words.

If you want to change anything here, i would actually change WORD to
something else, maybe FIELD?

And i could be wrong here, i've not looked at the actual protocol, so
i've no idea if all fields in the protocol are u64. There are
protocols like this, IPv6 uses u32, not octets, and the length field
in the headers refer to the number of u32s in the header.

	Andrew

