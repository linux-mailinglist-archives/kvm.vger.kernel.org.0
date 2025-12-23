Return-Path: <kvm+bounces-66633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A0AACDAD80
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:41:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0490B302F803
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A1D42F5A3D;
	Tue, 23 Dec 2025 23:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="HWJdSR+e";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bQTIrgDk"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F2128A1E6;
	Tue, 23 Dec 2025 23:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766533272; cv=none; b=utI0O3jB1k1IFxpso6k0qe2mMGlfDUhhf+33Cv+S5MFHxWNwCb6jcrK+8QeUSLteNi5ysr30CF3MBRsSBrP2/jMLtD7XxPuE8tnwhg644e/+zxeWVwbQ6BRb53rKZr+qL3lF240A8zFBRiYLZgeIXbq/P4wndivqMAl13ZeknlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766533272; c=relaxed/simple;
	bh=HN7EQVL5A8qU6+3Rg3qyippxHFdzSFSUbETLO78imUo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KMCcA7WUIn747pu4clPJC9YOrgFAVp1rmJxftkoQWIlIANBaTSZUXbOZXErIK31/Q5Ml6F02oLh0HYmZP0YQNQB5g7aF/lbvOw3lg0t8073Nvb7SdNreOAYNtUJ625hsKkyTUs02/NMvQzZBXPRkD80yTQg403JKufrD0+5gdxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=HWJdSR+e; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bQTIrgDk; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 6014E140009B;
	Tue, 23 Dec 2025 18:41:07 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 23 Dec 2025 18:41:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1766533267;
	 x=1766619667; bh=4R6tzEtjMo4V0EGw9kgGtRXJXIDPIrppaECc/CPlpkM=; b=
	HWJdSR+eYNUhmgdiWpF5HSEk4V2uXSaofGSUwH6XU/3envzh0Wj8E21K79l6/eoi
	jFGIDKRv1i0nHmUApjKSjWMqWVq5uUwVAzDtDU/GUoBlXxEdJh3H3gRAE75xMZva
	of7XR0yOQq3VX5zDa51rMY/ObhRWXD7TqpqGuwVu3KTZXkIR/ZeN4H34UysPfRBI
	2M2QgbYeOAlD2YmA1AA/VhAStcJ/DfUkWkZ3hwMKDtNDhH4KNssSWZXjyReBRSgD
	Z3raOZz+xCDfo0EFh7Z0zXbnBdbhUwnuwFYOFDGof4oKQFOMzpdRbkEZXPmaXGKs
	QLewFMgDVj6K6BeI3WtswQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1766533267; x=
	1766619667; bh=4R6tzEtjMo4V0EGw9kgGtRXJXIDPIrppaECc/CPlpkM=; b=b
	QTIrgDkNQbqbEuKwwHn9UUWSyE6tPIlELtYegT5Iyhui8dFjzzETavzSqRtd3SD5
	Aj9p0hl49V1fzxM16f/T0pVaastQrSiesvTUVPk97oFKm2zJ8CPaJbWy0RiMrcPW
	m2gi582oYx3ZerofBieKiAq3VRloNyPTfxzNyE9OEL+1PWe7wrB5XMxuj+G8fxqx
	bW7DJjd+su1+sdrtzDu28jJPFdwiONXZkN6wzpLucUzFVF08hIBBE8K4Y/rGOIsu
	yE9ZHmC3UXaVqQaskZr6FV6C1kRnluN7Z8wWt6vPGsKSPVDqgV6MhdZk31xKUb6h
	r752Jn5YqP9oYQBYmk44Q==
X-ME-Sender: <xms:kihLaRCEBvndYlrpns9ErBqv9cTyJPP1sSeDR5thNZHWBIHBXLHm_w>
    <xme:kihLaUdQuY41YItBhe5bqS8-FYC5Gvk3t9Ejz9yyR0cR4s58k_NH5RaXy9kdc0a5J
    rB6-m7XseF1Ur3jYGVFeCjMHjGDbt-R-LMqzBaaaDd9_Rrr4Oinww>
X-ME-Received: <xmr:kihLaQ0o-1f3LBRQNHc7Z8d8QoQqUZV8151RRFeZajSVT74J9mYPnSIq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeiuddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfgjfhggtgfgsehtjeertddttddvnecuhfhrohhmpeetlhgvgicuhghi
    lhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrghtth
    gvrhhnpeehvddtueevjeduffejfeduhfeufeejvdetgffftdeiieduhfejjefhhfefueev
    udenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhn
    sggprhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehkvghvih
    hnrdhtihgrnhesihhnthgvlhdrtghomhdprhgtphhtthhopegrnhhkihhtrgesnhhvihgu
    ihgrrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhrtghpthhtohephi
    hishhhrghihhesnhhvihguihgrrdgtohhmpdhrtghpthhtohepshhkohhlohhthhhumhht
    hhhosehnvhhiughirgdrtghomhdprhgtphhtthhopehrrghmvghshhdrthhhohhmrghsse
    hinhhtvghlrdgtohhmpdhrtghpthhtohephihunhigihgrnhhgrdhlihesrghmugdrtgho
    mhdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:kihLabhxiV81jC-eZQKdj5e1LHKjHz41IVFLX2hIrtCNChCNE4-vBQ>
    <xmx:kihLaZm3V1g2kDeyxVnOvWGXvXjRAI2GgIHKt6nBbj5hddzrKU11eA>
    <xmx:kihLaRaJJNOSEezS5v8LEf-2KG5ItqLQVKdd1xyl-Fq7bhkxb8Q53w>
    <xmx:kihLaUFbpqHSZ85qm8lBDl7SoWnvX9itIpEVGmTCqTht75VjqD6taA>
    <xmx:kyhLaS0DJ5J8zYC60hECcUD-D2jB6esxHyfrGP4kq6LlVh-tShfTbN_6>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Dec 2025 18:41:06 -0500 (EST)
Date: Tue, 23 Dec 2025 16:41:03 -0700
From: Alex Williamson <alex@shazbot.org>
To: Kevin Tian <kevin.tian@intel.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
 <skolothumtho@nvidia.com>, Ramesh Thomas <ramesh.thomas@intel.com>,
 Yunxiang Li <Yunxiang.Li@amd.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] vfio/pci: Fix issues with qword access
Message-ID: <20251223164103.4e591c3a.alex@shazbot.org>
In-Reply-To: <20251218081650.555015-1-kevin.tian@intel.com>
References: <20251218081650.555015-1-kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Dec 2025 08:16:48 +0000
Kevin Tian <kevin.tian@intel.com> wrote:

> Certain devices (e.g. Intel X710) don't support qword access to the
> rom bar, otherwise PCI aer errors are observed. Fix it by disabling
> the qword access to the rom bar.
> 
> While at it, also restrict accesses to the legacy VGA resource to
> dword. More for paranoia so stable kernel is not CC-ed.
> 
> v2:
> - Rebase to 6.19-rc1
> - Use enum to avoid adding another bool arg (Alex)
> - Elaborate the commit msg (Alex)
> - New patch to disallow qword access to legacy VGA (Alex)
> 
> v1:
> https://lore.kernel.org/all/20251212020941.338355-1-kevin.tian@intel.com/
> 
> Kevin Tian (2):
>   vfio/pci: Disable qword access to the PCI ROM bar
>   vfio/pci: Disable qword access to the VGA region
> 
>  drivers/vfio/pci/nvgrace-gpu/main.c |  4 ++--
>  drivers/vfio/pci/vfio_pci_rdwr.c    | 25 ++++++++++++++++++-------
>  include/linux/vfio_pci_core.h       | 10 +++++++++-
>  3 files changed, 29 insertions(+), 10 deletions(-)
> 

Applied to vfio for-linus branch for v6.19.  Thanks,

Alex

