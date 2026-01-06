Return-Path: <kvm+bounces-67185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A473CFB482
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 23:46:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7A06530509DB
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 22:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31CF72FFDE6;
	Tue,  6 Jan 2026 22:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="mjDIweou";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PyevTlAc"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD9C18DB35
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 22:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767739571; cv=none; b=etx9rWfEdsvF0dy6yONuPUSbyxNLyfuMtC+HU5axKLKlO7UrZi33YL5yEznd/zo2z+B+cE8xL4pXNPc/KKAT1bjQacSXZvvhU8fii0bA5urc6yXjo5kJZkUag9KAr08gUjMVCEY41g1AfSvtOQteokjQ+tKZt391kc2NlYaQR5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767739571; c=relaxed/simple;
	bh=ztA4phoBNLHzWY5zeVFovNNINPx5mlRB68sfYvcy+GM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N1Bz4fTyzKiPj8Lt1fbWCjFFOj6q+EP8h+gSDIfNiEMhdDNBr+WybrdsAWwkoOXbk82Bf4zZyFGPLFUHIZMXZDVn5UUOGLtx1FJSFaoCQl7iDami4X5o8ajmBCEd+ypH77qdKHdDSRQ8K4G9aHwuSBNtoFO6fFQSC+Its17ll8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=mjDIweou; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PyevTlAc; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 501B57A00D9;
	Tue,  6 Jan 2026 17:46:06 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 06 Jan 2026 17:46:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1767739566;
	 x=1767825966; bh=eYp/YFsWQMdao0wFpX7K6NhajHJeShmGhotN86WKTOs=; b=
	mjDIweouCOlYIRforyqsg9Lv1fMxxCc+Vi8w+jNtqsYcHsUU2WvcynoDXsX71JW1
	LXdsoVKfjJLecPN0zDyDd2Fue5Iznz4SmQ7TUhGO38nVbXDgyGwtqRrj5KZ0OAuG
	rzfPmiH3P7z914IOyr9agcJZv4Wd4iozzB6oQeTCjQFu+P/ahgtAY1qWhLGzfpJU
	NWFlr+nkWTaLtxIqfAEn5Sv6ahmNqUfczjQvQ9cKf9D2aXdNhJBTuic96/OVKm/G
	yQ0NsUAi0QB+aDpMTySKLPS0fI2AM09sqcAp+lx4BbuyMEzMK3MuwVL+iEZFbgK1
	qY7X1spYAsoOYH53vSAFqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1767739566; x=
	1767825966; bh=eYp/YFsWQMdao0wFpX7K6NhajHJeShmGhotN86WKTOs=; b=P
	yevTlAccnTjTqVEa6DrfQV4WJ/8ZT0v8uTjd5+pR1R3THbCDX8hsxdCe2Z23OEfH
	jy1yN/T5tZoF7oFWgoWOoDOrzHmudgHO5wj0JZb0nXdFBKjwcA7IHhFmAeCSAl0+
	6JOe0JBpiEnl4og5xcvtkPoI9wXhgS4Oo+B5c25khAfuypvjJGa3I4CSC3toXl0l
	k0DiyoEqr+Up+ZUuWwMtjYDc+4YGpVoyhQVh3UwsWq2zX6F4Yb/Tg2VvtOLfRwWD
	trWoB5SeybtNoz7nsK/gb1pDiZIXSCTrZvaftBkSd6WGxmMoLRuCzBBrUjlBr6vj
	g2S8kTM/vC+94FslGL0bA==
X-ME-Sender: <xms:rpBdaYxeRg40iTghLCr19tu_x3oEIszHz1oSo6WD1g-ZNpQZMWMqAA>
    <xme:rpBdaSSpi7ZH_q4DD-vfXevBazPeiC6Va0TY1CAYta0xUO7LySjD5BXryifjTafgR
    9Hx1bR1XYxNpZHNP5FuyD-FupqijmC9Qehf_U5HHoUoYxq-w24kpA>
X-ME-Received: <xmr:rpBdaX9S5owQZBWh3wT7py7eFj6-dJNesUjbKfiO8Tnk1ung_rR_0Rqi_90>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddutddugeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopedvpdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopehmihhlohhsrdhkrghurhhinhesphhrohhtohhnrdhmvg
    dprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:rpBdaRqDHUM1DHYI_9jd1CkEYmFqlrYAMPj-UYf11gsWvojXgIjTVQ>
    <xmx:rpBdacmrGGltVZ9b7dgDNCs7Dz6whJ8cRXCNIK9qgU6XuC-tGCs96Q>
    <xmx:rpBdaQKmuzLgDEo4yng-BxBEYdZO8XqsnKIprZi59C_Kdsdpoc_SQw>
    <xmx:rpBdaZwteNIMBVt8PCmBDzrgVYH4G9K8-iLo4iDfue17HfWhfM0XdA>
    <xmx:rpBdac0GnPGNE8M9zeCCvw4NFcWCaQ7CH-wJ0Si_O6GdfeAkkJDq-o7b>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Jan 2026 17:46:05 -0500 (EST)
Date: Tue, 6 Jan 2026 15:46:04 -0700
From: Alex Williamson <alex@shazbot.org>
To: Milos Kaurin <milos.kaurin@proton.me>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Kernel 6.18 not respecting my VFIO bindings
Message-ID: <20260106154604.731d8fcf.alex@shazbot.org>
In-Reply-To: <FIIM2M4ECH85jKrC8T5ugdjzymC-aMAXvLiC8cX0ufYqfl39yxq5kVTf1bJGj-nqkOm9Scvd5-cPAlUn8ZL_Fu4EhBjXwypfZpbd-ApyFQs=@proton.me>
References: <FIIM2M4ECH85jKrC8T5ugdjzymC-aMAXvLiC8cX0ufYqfl39yxq5kVTf1bJGj-nqkOm9Scvd5-cPAlUn8ZL_Fu4EhBjXwypfZpbd-ApyFQs=@proton.me>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 06 Dec 2025 01:52:31 +0000
Milos Kaurin <milos.kaurin@proton.me> wrote:

> Hi all,
> 
> Warning: No line-wrapping.
> 
> I have had this Alpine Linux setup for a few years now working normally with the IOMMU group 4 bound to vfio-pci. The hardware is unchanged.
> 
> This is a fresh-install of the Alpine 3.23.0 with the 3.18 Kernel. Even though I can see vfio-pci bind early to my IOMMU group 4 devices, I still see USB drivers getting assigned after-the-fact:
> 
> [   12.814303] vfio_pci: add [8086:3a67[ffffffff:ffffffff]] class 0x000000/00000000
> [   12.814312] vfio_pci: add [8086:3a68[ffffffff:ffffffff]] class 0x000000/00000000
> [   12.814319] vfio_pci: add [8086:3a69[ffffffff:ffffffff]] class 0x000000/00000000
> [   12.814324] vfio_pci: add [8086:3a6c[ffffffff:ffffffff]] class 0x000000/00000000
> [   12.814330] vfio_pci: add [10c4:ea60[ffffffff:ffffffff]] class 0x000000/00000000
> [   12.823306] usbcore: registered new interface driver usbserial_generic
> [   12.823346] usbserial: USB Serial support registered for generic
> [   12.826651] usbcore: registered new interface driver cp210x <<<<<<<< why? :(
> [   12.826692] usbserial: USB Serial support registered for cp210x 
> [   12.826744] cp210x 3-2:1.0: cp210x converter detected
> [   12.836475] usb 3-2: cp210x converter now attached to ttyUSB0
> 
> 
> ... I don't remember if this is what the case was before, but I highly doubt it was.

Your USB host controller drivers were loaded ages before this from the
initrd.  The output above is after the root filesystem has been
mounted.  Regardless of what IDs are added to the vfio-pci dynamic
table, it cannot steal a device that's already bound to another driver.

Typically this means that the vfio drivers are not actually in the
initrd and/or the modprobe.d directives are not in the initrd.  Note
that the vfio modules have changed over time, vfio-pci has had a
vfio-pci-core module split from it that may not be available in your
initrd.

The more foolproof approach here is to use driverctl to instigate a
driver change for the device, and if you really need to prevent the
default driver from binding use pci-stub.ids= (same syntax as
vfio-pci) on the kernel command line to temporarily bind the device to
a stub driver until driverctl comes along to move it to vfio-pci.  All
distros should build pci-stub statically into the kernel so that it
loads before any modules.  Thanks,

Alex

