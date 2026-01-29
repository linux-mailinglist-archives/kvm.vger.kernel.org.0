Return-Path: <kvm+bounces-69593-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gOiUL02se2kAHwIAu9opvQ
	(envelope-from <kvm+bounces-69593-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:51:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 600BEB3B9C
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:51:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 04300305A6E4
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7122630AAAE;
	Thu, 29 Jan 2026 18:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="PfFwAT9U";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NCNU3++S"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418D43090C2;
	Thu, 29 Jan 2026 18:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769712646; cv=none; b=VAyCYtw6uJ5V/8NBXZcAdCr1oksxtAgI3ezaw9Lbro28cOT1Rmjq2QveIOPVvU/CnddcuKhPx1rLw9bEoYF7WKrzH0A4HHQPfjlcJ30oZCi3HlhLEt0xSoAWxHwPo4N4Ld2BxVDOiRFUC37C2cblpIV2C3HnGuZVGkoW61laJzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769712646; c=relaxed/simple;
	bh=WKec3arCCMNRrGJBEnRE3sLK4j3onPSV3T75MrOsaWI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u3YM5BSGZd9EPLVs5ASWYQXQLUTwBMbH+Kqb45QbC7X4+z2YjdvQXOicXwp+1KNgiJ4cn54mjelVDX1be30HpL0q0HGw0JHtwEw0E0tTBlZr6he6Gszxpd6YJcLcJR+x/RVkNgbqcJTm1GcsXebgvkzrAGIWC5a5ijRktV79n8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=PfFwAT9U; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NCNU3++S; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id 524CBEC0602;
	Thu, 29 Jan 2026 13:50:42 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 29 Jan 2026 13:50:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1769712642;
	 x=1769799042; bh=ufj3Z5ElDLmJd7fO42cOWXMjtgm9/Nt9Eiy1rxbPIFA=; b=
	PfFwAT9UUE0dhiSQ+h5829y3AIAqVryHRhItnAQG8NX5AWay1xdQRd6N+Zs0TEDM
	OZL47WwTcitp9t7kJGba6BJqXNj41Utpa+Vwl/iW47uqyM95G55HYUxLVXJpiH1h
	JfXeMSfLdXJYcu2MIhR45hBLekrJyDTr2ubaY/4Cq+CTdv9Ndjf08z3AZkz82Wz6
	Yh8Ep7wUMm3vaQpUCDu7+b2XFgt9EyiTeXoAo6NN0Rko0nf3g8rI9Ky5wh0tD+PU
	i65XgYlM3GdVCwChHE42KXbEgZ9iTNJSPHNK6ycnvSuaOnW2idX4dtRpuzz0BP7o
	/MsDUVJnLucLaVpFFWI/7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1769712642; x=
	1769799042; bh=ufj3Z5ElDLmJd7fO42cOWXMjtgm9/Nt9Eiy1rxbPIFA=; b=N
	CNU3++SMvVM12tD6bZal5g6l4UDt3lkFDWZVeIG3afquAlzVvse1GPZ4zMgEYUeR
	rpMFhoxLQykllbI+h4hZaS2/8FjXZFOp2UO4Xks6bty41UiYwNpWgH9Nwlkgu/FU
	R2GpdJhS+6qGk/tdAL+iMKlh0lnVdSW51dH9SQxJDkA3oy1t7+1PwJ0G+C97b9uP
	H9PH9CNLRvGpUj/L1U1c+3ijL7GqoxN9IuAyKNoCq+g0dSsspArY9BAAQoY0IDGZ
	aMUIcYqAsPduqP/1q/d44e4WmJp5eGk7Ybu2GehVKcwqtwnUkITZinc8x6I1uuOH
	yqRuOcLEnWYL8ODZVNJkg==
X-ME-Sender: <xms:Aax7aeWS-lIvTJN2WFNH-JLygTLYjfzWr_LPUwvHHTeGI7WKHxOglA>
    <xme:Aax7aQnByE7SA_ChI5cZ10Y75OqJZ4U5ywItwvklFQhcAbTs7MZKRN8vI57uUQLJ7
    RRHDf5N5ThKPYD1tpXkerCJjtcv8W6ExDDn50E4iZim5JkKOqELug>
X-ME-Received: <xmr:Aax7adOv9D6PTYAKA3cIs749ROzqde0UwDkgcX44bU8ArNDe67ezW-pry6M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieeileeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeetuefgleefhfdvueegffdtffevhfffgfffiedutdetgffhheejtdekfeek
    ieehgfenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhg
    pdhnsggprhgtphhtthhopedutddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepug
    hmrghtlhgrtghksehgohhoghhlvgdrtghomhdprhgtphhtthhopehrughunhhlrghpsehi
    nhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepthgvughlohhgrghnsehfsgdrtghomh
    dprhgtphhtthhopehshhhurghhsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehrrghn
    rghnthgrsehgohhoghhlvgdrtghomhdprhgtphhtthhopegrmhgrshhtrhhosehfsgdrtg
    homhdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    oheplhhinhhugidqkhhsvghlfhhtvghsthesvhhgvghrrdhkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:Aax7aYJ_HHdpOwnUcx3pM__qj8vWsJWR7-9MmuB9ptXphqJayxXv_Q>
    <xmx:Aax7aX3YAyPX45O0OaCPFUbT24K1PnR4f52bm9Yr4m-KCJFHKNxzEw>
    <xmx:Aax7aUUB2LioUGNPEx92oplF9ZTTrNEcEWrQZlXfGto5SGlQoeY_TA>
    <xmx:Aax7aRPMBr62WZQJTQutZa3_uwndURAe1rpe2D5YhA5XYk-3jukGUA>
    <xmx:Aqx7aXHY0v-Z3_2ZWr_yDsuMNCLPkovj3iODpi1O3-b3zXJwLDJc0PmU>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Jan 2026 13:50:41 -0500 (EST)
Date: Thu, 29 Jan 2026 11:50:39 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Ted Logan <tedlogan@fb.com>, Shuah
 Khan <shuah@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, Alex
 Mastro <amastro@fb.com>, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kernel test
 robot <lkp@intel.com>
Subject: Re: [PATCH] vfio: selftests: fix format conversion compiler warning
Message-ID: <20260129115039.10fe3c76@shazbot.org>
In-Reply-To: <CALzav=cWEoydGBpf4j5gPWy0TzLoAPP3YeG3VocbeEzytHTFrw@mail.gmail.com>
References: <20260128183750.1240176-1-tedlogan@fb.com>
	<CALzav=dMhycS2iBxkhPCz3tMUKxkfgr1dCLFGYzGuXZCeYhijw@mail.gmail.com>
	<9d992d4a-1aea-42a7-aa79-4ede80293f9b@infradead.org>
	<CALzav=cWEoydGBpf4j5gPWy0TzLoAPP3YeG3VocbeEzytHTFrw@mail.gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm2,messagingengine.com:s=fm3];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69593-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,infradead.org:email,messagingengine.com:dkim]
X-Rspamd-Queue-Id: 600BEB3B9C
X-Rspamd-Action: no action

On Wed, 28 Jan 2026 11:21:52 -0800
David Matlack <dmatlack@google.com> wrote:

> On Wed, Jan 28, 2026 at 11:12=E2=80=AFAM Randy Dunlap <rdunlap@infradead.=
org> wrote:
> > On 1/28/26 11:06 AM, David Matlack wrote: =20
> > > On Wed, Jan 28, 2026 at 10:38=E2=80=AFAM Ted Logan <tedlogan@fb.com> =
wrote: =20
> > >>
> > >> Use the standard format conversion macro PRIx64 to generate the
> > >> appropriate format conversion for 64-bit integers. Fixes a compiler
> > >> warning with -Wformat on i386.
> > >>
> > >> Signed-off-by: Ted Logan <tedlogan@fb.com>
> > >> Reported-by: kernel test robot <lkp@intel.com>
> > >> Closes: https://lore.kernel.org/oe-kbuild-all/202601211830.aBEjmEFD-=
lkp@intel.com/ =20
> > >
> > > Thanks for the patch.
> > >
> > > I've been seeing these i386 reports as well. I find the PRIx64, etc.
> > > format specifiers make format strings very hard to read. And I think
> > > there were some other issues when building VFIO selftests with i386
> > > the last time I tried.
> > >
> > > I was thinking instead we should just not support i386 builds of VFIO
> > > selftests. But I hadn't gotten around to figuring out the right
> > > Makefile magic to make that happen. =20
> >
> > There are other 32-bit CPUs besides i386.
> > Or do only support X86? =20
>=20
> At this point I would only call x86_64 and arm64 as supported. At
> least that is all I have access to and tested.
>=20
> If there is legitimate desire to run these tests on 32-bit CPUs, then
> we can support it.
>=20
> Alex, do you test on 32-bit CPUs?

No, I haven't tested 32-bit in a very long time.  I'd like to think it
works, but I'm not aware of any worthwhile use case.  Thanks,

Alex

