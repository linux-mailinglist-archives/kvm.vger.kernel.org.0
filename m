Return-Path: <kvm+bounces-60103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17DE6BE07E6
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 21:42:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B95545E0BFF
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 19:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A7F030C635;
	Wed, 15 Oct 2025 19:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="gNE62Tbj";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RWFieLpV"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BDE30C37A;
	Wed, 15 Oct 2025 19:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760557008; cv=none; b=aBMXqaQFVYEkQ/rdwOSJiQSDE+LPxkmiEXki4e7dEqK0wFTzrDFwd2lZkMQJgE3SZMLXj1U+6/rgpgFnsLfjSTLSia4tDYAotpAhJGjMv8cY//QDOTzhiaEBKcBLmy262h1ZE0gajKdjxTGD/LLYn+5EjP7eUW/fg1P4JLcxq5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760557008; c=relaxed/simple;
	bh=dJV53bCbomWFqgNsDuLHOIaIuVZyji7kkN5naxm2CJA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ij38i9pbOWfQKxRZuxvX9ffeddLZIGuu4gGV8rhT6nmVEiCyY6rjcXLfkjgNoBVRRQyXg+dTxvswokLCk3B0/tr4x13VogCr2v3MKYR/IuZp2AQ4z0JoN60hoy9UzDBkEOCHx7MB3bFO8sX35IHeMMl3TPoREN21p2vKIsVfTN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=gNE62Tbj; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RWFieLpV; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 81DC91400220;
	Wed, 15 Oct 2025 15:36:45 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 15 Oct 2025 15:36:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1760557005;
	 x=1760643405; bh=fTysGrfdZ/rsGNGo591/yYazsd2SWqezJCCj8EPO0Bc=; b=
	gNE62Tbj+0KOKfPuUNGR465/7TgPwH3pQVhB4ayeKwidrKq7We7jDfZz0WI9vgVv
	VKpVmcH31bSmF4T0vTsdf/A2+1rKo6yAmvD2Y+SwtbbGDohxDuzvwq7C/kziqZvv
	Ln57qugiiZIh8JZ11x6ujyLJ6blaoJN8d6NTc+TAlI4BUVvbchrGEJ6cA80QRv5n
	VaQ6L+4sq+wxYc7wqqvpYZS+GoJ8YRJBfeuQJcBeLuYj2FgGJ5owAP9W2BV1GuDi
	by/qLrY3pxSOGKcRhUFGkYvgE4lY9OAf6AbKaxtsCParXSJWvf43y3CeyETYw37i
	E8uvF6aVJzDsNdTO/ncdHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1760557005; x=
	1760643405; bh=fTysGrfdZ/rsGNGo591/yYazsd2SWqezJCCj8EPO0Bc=; b=R
	WFieLpV/2+4QYtSPKPYwKaTr+37WzsvaD+KfqDv1dfY7K4VQvwAxhIwCqdbk6Qd7
	ts/dh6CKTwzokwAPbcbG7pMWbpEHrPzoORttX20cudTkf5aMnjcfKPZnUu7TTL8b
	RkQuAl1PAja8ZWetbojuM4JSgjS3rCHHcUO/cvcDhJ+Snr0R+gu6sv41iy67fGY8
	22SKpWs7BjbfMB7d576HqlPWGoSCaWeX+MzF3CdRPu/0UiECsZM3NJVtNmtY4Y6E
	76iAsO5onft+KomgMg/alOcoky5RAIhjR/A0CMFxx3kmaqkCooLdvR3Vq7RbeF/l
	ra8MvowjOVcGeNLLocN0A==
X-ME-Sender: <xms:zffvaJy_O9whnyPeceebA0xybn6m-ROV9M3SyUWB3swstD1uh5EPqw>
    <xme:zffvaF2kMte9gag7mlNTjUEPCyQQJsCVPHi5aM_FjGvAh7MN46MKXs3sz4dO2WqH6
    VfbKNrSXPTuWFBL779Agx3Vkrw4FVeFsUWg51XSFlOWDSAHElT_>
X-ME-Received: <xmr:zffvaHzCnb8YugvaUVFmmU1kwatg-m-SDYGk7u80mnhL_LvYz9rSge7qkmE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduvdegvdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejfedttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepueeuheeutedvgfejkeekgfdttedvjeefieduveettdefveffjeetteffheei
    jedtnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdp
    nhgspghrtghpthhtohepledpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhhngh
    ihrggurghmsegrmhgriihonhdruggvpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghr
    nhgvlhdrohhrghdprhgtphhtthhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhope
    hksghushgthheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsggvnhhhsehkvghrnhgv
    lhdrtghrrghshhhinhhgrdhorhhgpdhrtghpthhtohepugifmhifsegrmhgriihonhdrtg
    hordhukhdprhgtphhtthhopehprhgrvhhkmhhrsegrmhgriihonhdruggvpdhrtghpthht
    ohepnhgrghihsehkhhifrghtvghrnhgrghihrdgtohhmpdhrtghpthhtoheplhhinhhugi
    dqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:zffvaCU4rFVJbfnlei3qFd2lOIlmCm3MEkBouZCLYEeCgKaIJIR7nw>
    <xmx:zffvaL_9_mjSkvzq2rGLuDQkFZ91cIjsLAHEY2B-gh29li0cJBooDQ>
    <xmx:zffvaNsbojM3AEjIyqx8LO7gpTsTLfMC8seQ2Ep0KfKOFLYu-FfZ1g>
    <xmx:zffvaD0HscwGiF2YIU6pxbX8kwO18LaBLcrne6-eIb2nYfJWLuqg-g>
    <xmx:zffvaMB-UYQGs8KvDFTAjYcfdqWcTvc-6D8aE7y8thScrdvPqZfBB8OR>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Oct 2025 15:36:44 -0400 (EDT)
Date: Wed, 15 Oct 2025 13:36:42 -0600
From: Alex Williamson <alex@shazbot.org>
To: Mahmoud Adam <mngyadam@amazon.de>
Cc: <kvm@vger.kernel.org>, <jgg@ziepe.ca>, <kbusch@kernel.org>,
 <benh@kernel.crashing.org>, David Woodhouse <dwmw@amazon.co.uk>,
 <pravkmr@amazon.de>, <nagy@khwaternagy.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/7] vfio: Add alias region uapi for device feature
Message-ID: <20251015133642.16134684@shazbot.org>
In-Reply-To: <20250924141018.80202-1-mngyadam@amazon.de>
References: <20250924141018.80202-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 Sep 2025 16:09:51 +0200
Mahmoud Adam <mngyadam@amazon.de> wrote:

> This RFC proposes a new uapi VFIO DEVICE_FEATURE to create per-region
> aliases with selectable attributes, initially enabling write-combine
> (WC) where supported by the underlying region. The goal is to expose a
> UAPI for userspace to request an alias of an existing VFIO region with
> extra flags, then interact with it via a stable alias index through
> existing ioctls and mmap where applicable.
> 
> This proposal is following Alex's suggestion [1]. This uapi allows
> creating a region alias where the user could specify to enable certain
> attributes through the alias. And then could use the alias index to
> get the region info and grab the offset to operate on.
> 
> One example is to create a new Alias for bar 0 or similar BAR with WC
> enabled. Then you can use the alias offset to mmap to the region with
> WC enabled.
> 
> The uapi allows the user to request a region index to alias and the
> extra flags to be set. Users can PROBE to get which flags are
> supported by this region. The flags are the same to the region flags
> in the region_info uapi.
> 
> This adds two new region flags:
> - VFIO_REGION_INFO_FLAG_ALIAS: set on alias regions.
> - VFIO_REGION_INFO_FLAG_WC: indicates WC is in effect for that region.

Sorry for the delayed feedback...

I think these should be described via capabilities returned with the
vfio_region_info rather than flags.  A flag that indicates the region
is an alias is really only useful for the restriction that we don't
want to allow aliases of aliases, but it doesn't provide full
introspection of what region this is actually an alias of.

The WC flag also doesn't allow much extension.  I think we want this to
have natural room to implement further mapping flags, so likely the
same capability that describes the region as being an alias should also
report back the mapping flags for the alias.  Thanks,

Alex

> 
> Then this series implement this uapi on vfio-pci. For vfio-pci, Alias
> regions are only (for now) possible for mmap supported regions. There
> could be future usages for these alias regions other than mmaps (like
> I think we could use it to also allow to use read & write on
> pci_iomap_wc version of the region?). In case if similar alias region
> already exist return the current alias index to the user.
> 
> To mmap the region alias, we use the mmap region ops. Through that we
> translate the vm_pgoff to its aliased region and call vfio_device mmap
> with the alias pgoff. This enables us to mmap the original region then
> update the pgrot for WC afterwards.
> 
> The call path would be:
> vfio_pci_core_mmap (index >= VFIO_PCI_NUM_REGIONS)
>  vfio_pci_alias_region_mmap (update vm_pgoff)
>   vfio_pci_core_mmap
> 
> This series also adds required locking for region array
> accessing. Since now regions are added after initial setup.
> 
> [1]: https://lore.kernel.org/kvm/20250811160710.174ca708.alex.williamson@redhat.com/
> 
> references:
> https://lore.kernel.org/kvm/20250804104012.87915-1-mngyadam@amazon.de/
> https://lore.kernel.org/kvm/20240731155352.3973857-1-kbusch@meta.com/
> https://lore.kernel.org/kvm/lrkyq4ivccb6x.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com/
> 
> Mahmoud Adam (7):
>   vfio/pci: refactor region dereferences for RCU.
>   vfio_pci_core: split krealloc to allow use RCU & return index
>   vfio/pci: add RCU locking for regions access
>   vfio: add FEATURE_ALIAS_REGION uapi
>   vfio_pci_core: allow regions with no release op
>   vfio-pci: add alias_region mmap ops
>   vfio-pci-core: implement FEATURE_ALIAS_REGION uapi
> 
>  drivers/vfio/pci/vfio_pci_core.c | 289 +++++++++++++++++++++++++++----
>  drivers/vfio/pci/vfio_pci_igd.c  |  34 +++-
>  include/linux/vfio_pci_core.h    |   1 +
>  include/uapi/linux/vfio.h        |  24 +++
>  4 files changed, 301 insertions(+), 47 deletions(-)
> 


