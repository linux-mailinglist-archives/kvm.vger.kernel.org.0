Return-Path: <kvm+bounces-68544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC40D3B8B8
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 21:43:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8436330C7B06
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 20:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A0B2F745C;
	Mon, 19 Jan 2026 20:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="PoHvnbQV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KwvP7dbO"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12882F6591;
	Mon, 19 Jan 2026 20:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768855203; cv=none; b=NgOd1iUsTW4XUkymLHQEtZqgrN/avOnXgG7zziVspb3U4mJ/GkIwDa+3DWwSKQKZ4kYaHDGLYGVmfXYvXV9h5fO9COFjNOpfm5nIiFOqx279qBzBuBCtD95/FeKH6dqL46Jv9/pBOq2ADolerCRCdTql/o91FL5US3JPosnHAQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768855203; c=relaxed/simple;
	bh=Tae5l31VxXDyRoUIAhHMtiGJQoVslUrxoRJ7teGlGCY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=emJOle1IOn3AVTbgHfbD4w18fy5yQiTtnLK5aj/c1dsGU7F9qqBND1okFo/ljlMJFAIGzgESAss8Yx8HLLrouywYPTJ3izJpLk7H3IMTtYAGD7LTektgHDAJqbHOGd8n3KZo3MaaUubQ63zP2DqOvUk63rwCq3ZegPR9jgOFJy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=PoHvnbQV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KwvP7dbO; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 4266D14003D7;
	Mon, 19 Jan 2026 15:39:47 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 19 Jan 2026 15:39:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1768855187;
	 x=1768941587; bh=RkCClocs/cUERcMmsWY5jSrB6y9rYXwydeEawzmi6Hs=; b=
	PoHvnbQVEMxRJbpu6qlWPVEg9qs/JASv13CW/yA618pFgQ802gygb90mCWnVJ7jJ
	mt8WlKx6in0BTwHQ01kvP23QyrXP7ofSx35U+ZkiAN8EQ/u9DTshACAcZ1Mx8xTK
	4sZoeJg265I8dDFrAldpmop1Ce9g3YBX+PiVUfJB+rGUJ89walzYwQ4tzN0Uofjx
	EmZNwe0mec+GGr5rB9RaD6wxcogfQGFvSgPKrCapWk+EHJ0pGKgfv6SRwrlBeHX3
	ic+Go9zrjsgYnwP+Wpj1M6GwtDYm4GKlgwSf9G9ZwOFzzDpRwW5L9x0eq/MdRX06
	X9aAgCtT9aRRaAo6Lw3imw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768855187; x=
	1768941587; bh=RkCClocs/cUERcMmsWY5jSrB6y9rYXwydeEawzmi6Hs=; b=K
	wvP7dbOUatayPiSEGLsB6InVzivlGrth2+nHDO7IT8snd9WH5PdtxrTLpFNLABma
	44Hm9dxvWkXVfciY4o8K88A51gB7s45473DEhDfmd3ri7DDfdpOJZj2TswGq1V6r
	Qw60TDwyvXgCE7n6yRJ2DCLzNW8eh4MrD07IBufhoqfybkw3uc0qvhhSgPgaF92F
	CS7yKGb9nT5uhIrA8/fVk9up3Ope+ZcDckJjSaKUqzYrVD4AiAl2EKbBJUPmJH9g
	lD34j2snZAeb//PdfRcL41AY1dJeEo3WI2oVb+UJvAqoNh3qI6FBD11y0sixlrb3
	as5v2xiYPXz9Gbe1nPhew==
X-ME-Sender: <xms:kZZuaaVI1uflDSMLS-gSjlnI1Wj3BCG2zuFzVlJawb33yWM6QntLrg>
    <xme:kZZuaXDiPlvOfli7NWtaV_f3yROxmiLcUAW6uieVFcRBMdJYZUB-97bcORbB8K8Ep
    oQtYYYfgS1NPluySpAmOdi2Xo9BEsYiehhVYhds0JiZo_MhWYG0xA>
X-ME-Received: <xmr:kZZuafEFfgEa__VWm2pW8zZsv6anPvb5qdqk5LWTDiRJI8PxuXVvUXFo2po>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufeekheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepkedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtohepjhhulhhirgdrlhgrfigrlhhlsehinhhrihgrrdhfrh
    dprhgtphhtthhopehkfigrnhhkhhgvuggvsehnvhhiughirgdrtghomhdprhgtphhtthho
    peihuhhnsgholhihuhesshhmuhdrvgguuhdrshhgpdhrtghpthhtohepkhgvgihinhhsuh
    hnsehsmhgrihhlrdhnjhhurdgvughurdgtnhdprhgtphhtthhopehrrghtnhgrughirhgr
    fiesshhmuhdrvgguuhdrshhgpdhrtghpthhtohepgihuthhonhhgrdhmrgesihhnrhhirg
    drfhhrpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphht
    thhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:kZZuaY709suI7KvUNFh3EDY4LloPIENSYl49Lg-C6bQCfu1kSA2qMw>
    <xmx:kZZuaVnta8JHlrnSZ7FYq4lxQNTY3ljNJYi0g779o2yMYmtdcpiBAg>
    <xmx:kZZuaT4Gs-uC1r6mzuDzFOhvJyF8arzvEdlOdlSaRQNCrrTk91ETFg>
    <xmx:kZZuaWQ0GxT9CMgSJnF5ucLtfD_USQzP7ZzP9pxhiTh7W1xzsaOIqA>
    <xmx:k5ZuaekBo_kcF8Gs-3tyCNJiJbfQZkhEBqaFO9SodNGhOnIsRSclXELl>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jan 2026 15:39:45 -0500 (EST)
Date: Mon, 19 Jan 2026 13:37:57 -0700
From: Alex Williamson <alex@shazbot.org>
To: Julia Lawall <Julia.Lawall@inria.fr>
Cc: Kirti Wankhede <kwankhede@nvidia.com>, yunbolyu@smu.edu.sg,
 kexinsun@smail.nju.edu.cn, ratnadiraw@smu.edu.sg, xutong.ma@inria.fr,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/mdev: update outdated comment
Message-ID: <20260119133757.3c0dac5c@shazbot.org>
In-Reply-To: <20251230164113.102604-1-Julia.Lawall@inria.fr>
References: <20251230164113.102604-1-Julia.Lawall@inria.fr>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 Dec 2025 17:41:13 +0100
Julia Lawall <Julia.Lawall@inria.fr> wrote:

> The function add_mdev_supported_type() was renamed mdev_type_add() in
> commit da44c340c4fe ("vfio/mdev: simplify mdev_type handling").
> Update the comment accordingly.
> 
> Note that just as mdev_type_release() now states that its put pairs
> with the get in mdev_type_add(), mdev_type_add() already stated that
> its get pairs with the put in mdev_type_release().
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  drivers/vfio/mdev/mdev_sysfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index e44bb44c581e..b2596020e62f 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -156,7 +156,7 @@ static void mdev_type_release(struct kobject *kobj)
>  	struct mdev_type *type = to_mdev_type(kobj);
>  
>  	pr_debug("Releasing group %s\n", kobj->name);
> -	/* Pairs with the get in add_mdev_supported_type() */
> +	/* Pairs with the get in mdev_type_add() */
>  	put_device(type->parent->dev);
>  }
>  
> 
> 

Applied to vfio next branch for v6.20/7.0.  Thanks,

Alex

