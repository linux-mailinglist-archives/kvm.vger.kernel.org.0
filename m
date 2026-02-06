Return-Path: <kvm+bounces-70514-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WGC1FJJnhmmAMwQAu9opvQ
	(envelope-from <kvm+bounces-70514-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 23:13:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E0FB103AE3
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 23:13:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6ED64301327D
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 22:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F098C30E856;
	Fri,  6 Feb 2026 22:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="ZMFI7pNg";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cMoF1xgh"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4630F303A1A;
	Fri,  6 Feb 2026 22:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770416012; cv=none; b=GCPgtwTlaUUvV+7jCJXQjTMdFpt5/QSvfDdhdLVPMBLOp7P6yHePxLDj3LXnBuVKNPWENoNYGgws+bOSMY1X8+qiO9gozq7EyxjGs+4IDPc83+HKi9ChwQ4V6EjCpZzfqvxzQ4BnlTiH3gX9Lsu3vBYdWCyimAP/iTrybLyBSz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770416012; c=relaxed/simple;
	bh=L7i0Sz3eO7RBI5TN5ntjQtLExJefod8fLQ5VVDQ0yDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mUHdStbhi0bgacwlm0vBKAeva5A13e8+tEbftgbSoej+z4vFescNyovc5L2Jn6PAx0cJK3VYhSv7b2rwwCXGEy2pfg/hLyR778jml93dHlh5mYzd9+o2YAJpUqc0RIXDSlzhAU1DYcQJbqWNf7h2d62KCt4ThgL6kAcWILABLZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=ZMFI7pNg; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cMoF1xgh; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.stl.internal (Postfix) with ESMTP id 7C3721D00011;
	Fri,  6 Feb 2026 17:13:31 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Fri, 06 Feb 2026 17:13:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770416011;
	 x=1770502411; bh=kDc1sN6h/MEdA3hS+mH1kELrGrgw+AmtTh16NpDYUmw=; b=
	ZMFI7pNgcIiciXNyGLvsIaCt/Zd4ld2qZ/f+flQUHyNb0wx4HadcYbuIzd5SzGgs
	G/D1N50yTEHrOA2Pl2Adoh2GXoq/HAKV10EIcnnipVUK6LT+lg8gO7Xhn+VZadur
	yBzj1SabZ4rgFvcILSf9LIqpWfblM+Kwmqs0SgiMlWOPoo5uEj8TXa1e3KZ1Em2H
	S0Sl3HW81lC4bY35cr/VklaIlUSYF6IgIQiOwM2XRWwlJA+oiEICprlRuYVx+H67
	oOKjSOapaDEVXRrFv9oExu6pjoRHc3KcfEywn+TFo/FoFcjjYddUXwCqjaMSaZHY
	Fz5089LvC5sKiYswyymEpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770416011; x=
	1770502411; bh=kDc1sN6h/MEdA3hS+mH1kELrGrgw+AmtTh16NpDYUmw=; b=c
	MoF1xghZ9fphvIUsPiENuvaoDhsoZtLdZM5C8Fe4m5c9dU0vsQmdxmMTK3oL0e7C
	L+eosJSSqYGuRzxXADj4WfUgSivldhr7MXnIyxi320hJin+DZJ1wkwnPVrnOfQ3n
	L/7F197bTv+GwFuOwY7ZRUk/5pJ6+xaIkWsH5YzF0xazAZlnvUsSQ2mxqwrisogQ
	35gIex+MD0QE0cheJL+ZPKdFcmZ9lyHoUZH+0MTYzZgLMTVkPueVk5A9xHFLwLnL
	JrdFNYDhd46oEEwwyyOyQW2hqb1x0uRW0sOJ2KaQFHPN5mZ/LM7qslnizmRNj/NO
	fTYP+ftP9Ag0gWvXzfoEw==
X-ME-Sender: <xms:i2eGaR8mDnXq-C2DJKF7CCa5lhJatXRKBW6fGURNgDV9ohvUl82FIw>
    <xme:i2eGaT-bUvYJvNFwXA7q1UoSads207_Ih8s7Khp95aeIoO6pQM7yZoSL13QkgvvAD
    E2BpgOfwhuMfqTqwnnlnfn6Co73JAEUnjrdt5zXV0H4jR3QgkN0>
X-ME-Received: <xmr:i2eGaYX3CNC_PQmg9FGzV2bGxbKHmXUoqkn6e3Su4mmhIaMVSHs03gPNZkk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeelfeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeefjeekvdduhfduhfetkedugfduieettedvueekvdehtedvkefgudeg
    veeuueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepledpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtohepfhgrrhhmrghnsehlihhnuhigrdhisghmrdgtohhmpd
    hrtghpthhtohepmhhjrhhoshgrthhosehlihhnuhigrdhisghmrdgtohhmpdhrtghpthht
    oheprghlihhfmheslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopegsohhrnhhtrh
    grvghgvghrsehlihhnuhigrdhisghmrdgtohhmpdhrtghpthhtohepfhhrrghnkhhjrges
    lhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehimhgsrhgvnhgurgeslhhinhhugi
    drihgsmhdrtghomhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdhsfeeltdesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtph
    htthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:i2eGaYe0sx0mCxasNf_FMrmXBWhVkyJnQ0TPBkQLHUkM5dzzFdE2vw>
    <xmx:i2eGaZZC9GdddHeaRkxqdzsn_H_KKUo5m6MzCspE1BbmSdRk4M-bjg>
    <xmx:i2eGacOITOrKA9A6PTPXTlgqGawGRsgxS6H8ChGQheqlfJlsEHvX5Q>
    <xmx:i2eGaXWminvFSqfAqTrxYHg91eF3ceU8FtiSzJTjdV7wNrg6T2X7nQ>
    <xmx:i2eGaUSgfQk_uJNDX4-sUaMZaW7OhacWgTV9SYQLILsOMP_IKFhDo6oY>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Feb 2026 17:13:30 -0500 (EST)
Date: Fri, 6 Feb 2026 15:13:29 -0700
From: Alex Williamson <alex@shazbot.org>
To: Eric Farman <farman@linux.ibm.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>, Farhan Ali
 <alifm@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>,
 linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Replace backup for s390 vfio-pci
Message-ID: <20260206151329.0d92d78e@shazbot.org>
In-Reply-To: <20260202144557.1771203-1-farman@linux.ibm.com>
References: <20260202144557.1771203-1-farman@linux.ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm2,messagingengine.com:s=fm3];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70514-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[shazbot.org:email,shazbot.org:dkim,shazbot.org:mid,messagingengine.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3E0FB103AE3
X-Rspamd-Action: no action

On Mon,  2 Feb 2026 15:45:57 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> Farhan has been doing a masterful job coming on in the
> s390 PCI space, and my own attention has been lacking.
> Let's make MAINTAINERS reflect reality.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0efa8cc6775b..0d7e76313492 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23094,7 +23094,8 @@ F:	include/uapi/linux/vfio_ccw.h
>  
>  S390 VFIO-PCI DRIVER
>  M:	Matthew Rosato <mjrosato@linux.ibm.com>
> -M:	Eric Farman <farman@linux.ibm.com>
> +M:	Farhan Ali <alifm@linux.ibm.com>
> +R:	Eric Farman <farman@linux.ibm.com>
>  L:	linux-s390@vger.kernel.org
>  L:	kvm@vger.kernel.org
>  S:	Supported

Acked-by: Alex Williamson <alex@shazbot.org>

Given the cc list, I'm guessing this is intended to go via s390,
otherwise please let me know if I should take it.  Thanks,

Alex

