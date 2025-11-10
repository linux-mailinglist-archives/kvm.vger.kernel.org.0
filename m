Return-Path: <kvm+bounces-62513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82EF1C4761E
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 15:59:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74CDD1892B46
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 14:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A03313267;
	Mon, 10 Nov 2025 14:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="R+MfrppO";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="snw1OOJ7"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817A8199935
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762786752; cv=none; b=tSdfK8XR9XUSZLwwBJSmomCG7e7+AQpvLBVofytkhwZqaLgB9soW566bn5zwaRg06twU/M3LrIeKCSCEj1ooFHEwqAGkRjMX9L6GRnjPody0gMc5dNPkJg6tj/kI2IR28ztyQwfFM7ul98pHqi8Q9y1ijYBpRRypAJyZGBWM/F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762786752; c=relaxed/simple;
	bh=MoZKJbNEEL7dJCMPkSpj54RkPBaUCZ8glAsAHs5dzjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dv/xS1rZOyNOuz747Ui2lXRRSelR257fxu2DjF+8yF77NFZm4uIi3aErcyBtrKqVhXFvx16V3dk1ahCsh3SJF7OQK7uOBoGlSTp5s1V2xRxc2myFdJZaRLh6tQcWul6PCsP8+AZ77+DAjU8yQYXlT1nfv3tVgxorvMy/pQcufl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=R+MfrppO; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=snw1OOJ7; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 75CD514001D1;
	Mon, 10 Nov 2025 09:59:08 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 10 Nov 2025 09:59:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762786748;
	 x=1762873148; bh=k8oL0rZhRULD9QhoKb/Mut8jIeqm5DEP6R/+qN+DPqc=; b=
	R+MfrppO7yqVPxnQwBnpT3mufKHCGEHErmzaCCrBplUpuIfoW4cANMHMVTt8Fg3x
	XrPsg4j4uQzEjjPBg3XsEvjJU3o9nrg4NSrTmJRXAoNdZnc2O69MU9Q+v/FEOsbw
	bSvBx4FhfoClJNrSRX7OU9Rqxo5e5tVLHpk479CGthz0+PQxYHJJ4FPOhAbUX9Pq
	BygPAs5N7vinD8WcMWvgA3zp92UkSffvyVFE5TUHxRbdR9DOXbt9jJkoxK0re+66
	5h1b7bXJKKUEX2iQ+9AZrso+hJtkttwteC+JrcXbbsh+/mA3Bh3WOC3q2YiNKq9l
	yYnoDl3heB3NdUqd29xKVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762786748; x=
	1762873148; bh=k8oL0rZhRULD9QhoKb/Mut8jIeqm5DEP6R/+qN+DPqc=; b=s
	nw1OOJ7GLfc7a9beEzt8vtEWLPKoP1Bg6A2XsFsVfQiW6pZSbCJ+yZHxIxEuUkgv
	kG7GC1PfaH6UdxxrEmgKWUOi2GWc9x0cAf94jD180xO4q/Y4LzBTZOSoHVEUAysM
	2+bB2Wocut4szKdEzEikJxYH1tf6gLxbQpow/JPQO/gAV/qkw2xFQuyal+qlLy/A
	+GSzp4Z+Ffvs3f49sETd7pIa0erfYCpWGRes+XzuKu/gz3YQZeXy+rq7YyzpkeZJ
	qBr1H7uhRm/ThIE1cEuhRKQOudCwqM1fpM7KWsoVVSuV9nes+g8uGCZD6fx6OYQV
	OvRu6kB7QVSGTaL3rwJdQ==
X-ME-Sender: <xms:vP0RaZClufYJ2M_wvKdg4V9sIdYUUh_bM31sUE15WOxP2DVCM-LzlA>
    <xme:vP0RaebEt3O6nbTsTrwWuLEYpMDFmE5XrNoloA1-TnPQgDnrXe0UD2hxy2otDdJZn
    Bm9xSxFuMbESnmQxC--5W-AXq8owQukepLTbe7O8mK5Cc-OZk1L>
X-ME-Received: <xmr:vP0Rac4MQPtZ3sQ-ek6ZjT8XGfbjiMJxepf4Zf5_B8Dpc3YLIyKc67Xv>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduleekieduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhggtgfgsehtjeertd
    dttddvnecuhfhrohhmpeetlhgvgicuhghilhhlihgrmhhsohhnuceorghlvgigsehshhgr
    iigsohhtrdhorhhgqeenucggtffrrghtthgvrhhnpeetteduleegkeeigedugeeluedvff
    egheeliedvtdefkedtkeekheffhedutefhhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgspg
    hrtghpthhtohephedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepjhhgghesnhhv
    ihguihgrrdgtohhmpdhrtghpthhtohepughmrghtlhgrtghksehgohhoghhlvgdrtghomh
    dprhgtphhtthhopegrlhgvgidrfihilhhlihgrmhhsohhnsehnvhhiughirgdrtghomhdp
    rhgtphhtthhopegrmhgrshhtrhhosehfsgdrtghomhdprhgtphhtthhopehkvhhmsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:vP0RafaxT32o1vqwHbQ4ik7pnLn5svk_dHTPtzsZUs6w0UpF11kaUg>
    <xmx:vP0RabiGr4xgR9l5rgchFks6B6ZUzDEoZaOiEMLQNWnmDkzs7VUWSA>
    <xmx:vP0RaQ8GYl_E78ZT4vY5kPlXcTwGLcnmLmYfQLYvEt25NCfIElAA3Q>
    <xmx:vP0RaWpWO5zL9d2HSwe-AodKzfrE-Xu0ptn73wVZAR5d50_B5hbfvA>
    <xmx:vP0RacjovL35w0BrdXoUa4DjfWBiwUCIaJJOm9qhVDsj-Zu0yzhD-3zK>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 10 Nov 2025 09:59:07 -0500 (EST)
Date: Mon, 10 Nov 2025 07:59:04 -0700
From: Alex Williamson <alex@shazbot.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: dmatlack@google.com, Alex Williamson <alex.williamson@nvidia.com>,
 amastro@fb.com, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio: selftests: Incorporate IOVA range info
Message-ID: <20251110075904.6c9f0fc6.alex@shazbot.org>
In-Reply-To: <20251108225842.GI1932966@nvidia.com>
References: <20251108212954.26477-1-alex@shazbot.org>
	<20251108225842.GI1932966@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 8 Nov 2025 18:58:42 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:
> On Sat, Nov 08, 2025 at 02:29:49PM -0700, Alex Williamson wrote:
> > ---
> > 
> > This happened upon another interesting vfio-compat difference for
> > IOMMUFD, native type1 returns the correct set of IOVA ranges after
> > VFIO_SET_IOMMU, vfio-compat requires the next step of calling
> > VFIO_GROUP_GET_DEVICE_FD to attach the device to the IOAS.  If
> > checked prior to this, the IOVA range is reported as the full
> > 64-bit address space.  ISTR this is known, but it's sufficiently
> > subtle to make note of again.  
> 
> Maybe we should fail in this in between state rather than give wrong
> information?

That's probably an improvement, maybe with a WARN_ONCE indicating the
ordering requirement for vfio-compat.  Thanks,

Alex

