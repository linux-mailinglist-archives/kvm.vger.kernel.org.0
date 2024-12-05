Return-Path: <kvm+bounces-33120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5615E9E51A4
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 10:47:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22882161AD2
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 09:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39BB91D5CFA;
	Thu,  5 Dec 2024 09:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="cKOKOVAz";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="p7PN8cW0"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722EED26D;
	Thu,  5 Dec 2024 09:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733392022; cv=none; b=dXhdovdg3C9Yxu1gfNLeLReF+Ia4ZjVz2iYxZsJma17+Kl+gNhTZqNU4Q73YTLSjnU9JaFEx9KEoFhPQ0q8bzhFZY6roQytTt4fJQOzpKgQCfmdcWWODzx/ogiNzP9LUKys6A2mFowfasQLpX9NZ5PK3ymZnNKIf+pQPK8HQecc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733392022; c=relaxed/simple;
	bh=z7CXawo7jHPOadYx5Z0arn4Lk3FGOh8LtwJ9KRXh9ME=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=MV8l+km1G8KniElwu4szMray03A19GXqkTJgk6JNGICSYEnlYCZy5iHoDQRsWuqAy4S68Xezgb6C7YVyjBcrPSzGrPkaMcaYorzmcyQ5Vzpry3Jv+BmvcFgi//9FMKd20w8wDt+FKgGXQnH1xnXdTq4vUq2KVsQmPUTKWD0Cang=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=cKOKOVAz; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=p7PN8cW0; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id F37162540214;
	Thu,  5 Dec 2024 04:46:57 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Thu, 05 Dec 2024 04:46:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733392017;
	 x=1733478417; bh=Eu3EmHEzX20BCIWNkFwG602Ya0HmTFI6PPPpXyFbJFg=; b=
	cKOKOVAz016RE+arjIcVw0mxMlTBmmY4KSVItM/ftGcFUsZ4oWGQaNvgrRIGCV24
	9KL9mg+PLKQGBr/LOYmJG6wZFz4ABtGX8x3fgCPMNBsZqJozMF6loZvUxXFsV6tu
	lfr9SLESJqZw4QR1si4oz//HEgBZQOv/IuUQ0gI4K1HCbPc49yb+0DOBhP91sNzm
	SJlzOVOy+QzeuIuc20JxjdLinxJ15GawYtJRc3BOlW8jDtPftJp1A4/keD6hHgqn
	tLKRpaGOZeOQiLhRZsTjBlPcszKI5pCqD56xbTywzE54HaKbk7pIV2p/wIpIy7WS
	BB12wf3LMYaBO2+BkPA5CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733392017; x=
	1733478417; bh=Eu3EmHEzX20BCIWNkFwG602Ya0HmTFI6PPPpXyFbJFg=; b=p
	7PN8cW0ilj8L1NRKo+CMGUPnpEKk+xaDNh8LqEU2/IBAqOoPnMVvWlH/EduzFep5
	Yft3iYKjdVDoyzppx1xc4uyu2QFGFEe75Pmi7WIj0S7wGSPQkBwNimmKBM+dg2G7
	PzvJXjNdnwZquuu4Kix55dk/wMsSeAxpMRLOHjS6zViKUXbWPP6dTSMICKgrQrN1
	Sg/vvSGhitPHEJv/lDX0+0FCuxs+J5K8/uR6OZ2vAdAbUjo2QJ4Fw5q1TRaAuKOS
	MDswDg7LwnCBMQicEUCqb3ImnzaF2y8BKWZx2JqhE3k2HpMxSAeBQpQb2YV1+l4X
	E756sYySBZ+kpyC92xX5g==
X-ME-Sender: <xms:kHZRZ2kcNRvLGghG72YlbAerF0MqvDrdut7MWqj5GbMGljRZtpLpKw>
    <xme:kHZRZ92K5dMrJmzqrhH20plB0thx65i4BD1ll7d5pzzs12TsxziV9wUxjWqyDFEZl
    zRDEYUOP-KsTj5XB6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieejgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredttden
    ucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdrug
    gvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffg
    vedugeduveelvdekhfdvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeduhedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtg
    hpthhtoheptghimhhinhgrghhhihesghhnuhguugdrtghomhdprhgtphhtthhopehsvggr
    nhhjtgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvg
    grugdrohhrghdprhgtphhtthhopegrnhguhieskhgvrhhnvghlrdhorhhgpdhrtghpthht
    oheprghrnhgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphht
    thhopehtohhrvhgrlhgusheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhg
X-ME-Proxy: <xmx:kHZRZ0oGmxTBjMQzYznGujJEANqWC3TmVVaZghyttBfIULMLQDEwAA>
    <xmx:kHZRZ6mVw0r9vBjtVB8N5aSKIbQOYBiFVK-yiK6Q5qOdTDYoYRtidw>
    <xmx:kHZRZ01TzE_arFB4xkXsEfWlXlcUBvg9CsSkhWdtfRbCzS4Lwz4NFA>
    <xmx:kHZRZxtCuZ6kIJppVQYQIQ7R0_UripjcDbYV7rsMyi8ABN3OoGL8aA>
    <xmx:kXZRZ-Nojanjh2x1Uga-O8ABb8n8WdscYcEj2MjjIb4WHaH3g-JxqW79>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7CB942220072; Thu,  5 Dec 2024 04:46:56 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 05 Dec 2024 10:46:25 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Arnd Bergmann" <arnd@kernel.org>, linux-kernel@vger.kernel.org,
 x86@kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
 "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, "Andy Shevchenko" <andy@kernel.org>,
 "Matthew Wilcox" <willy@infradead.org>,
 "Sean Christopherson" <seanjc@google.com>,
 "Davide Ciminaghi" <ciminaghi@gnudd.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org
Message-Id: <66fefc5a-8cd9-4e6f-971d-0efc9810851b@app.fastmail.com>
In-Reply-To: 
 <CAHk-=wji1sV93yKbc==Z7OSSHBiDE=LAdG_d5Y-zPBrnSs0k2A@mail.gmail.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
 <CAHk-=wh_b8b1qZF8_obMKpF+xfYnPZ6t38F1+5pK-eXNyCdJ7g@mail.gmail.com>
 <d189f1a1-40d4-4f19-b96e-8b5dd4b8cefe@app.fastmail.com>
 <CAHk-=wji1sV93yKbc==Z7OSSHBiDE=LAdG_d5Y-zPBrnSs0k2A@mail.gmail.com>
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Dec 5, 2024, at 00:33, Linus Torvalds wrote:
> On Wed, 4 Dec 2024 at 11:44, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> I guess the other side of it is that the current selection
>> between pentium4/core2/k8/bonnell/generic is not much better,
>> given that in practice nobody has any of the
>> pentium4/core2/k8/bonnell variants any more.
>
> So I suspect:
>
>> A more radical solution would be to just drop the entire
>> menu for 64-bit kernels and always default to "-march=x86_64
>> -mtune=generic" and 64 byte L1 cachelines.
>
> would actually be perfectly acceptable. The non-generic choices are
> all entirely historical and not really very interesting.
>
> Absolutely nobody sane cares about instruction scheduling for the old P4 cores.

Ok, I'll do that instead then. This also means I can drop
the patch for CONFIG_MATOM.

> In the bad old 32-bit days, we had real code generation issues with
> basic instruction set, ie the whole "some CPU's are P6-class, but
> don't actually support the CMOVxx instruction". Those days are gone.

I did come across a remaining odd problem with this, as Crusoe and
GeodeLX both identify as Family 5 but have CMOV.  Trying to use
a CONFIG_M686+CONFIG_X86_GENERIC on these runs fails with a boot
error "This kernel requires a 686 CPU but only detected a 586 CPU".

As a result, the Debian 686 kernel binary gets built with
CONFIG_MGEODE_LX , which seems mildly wrong but harmful enough
to require a change in how we handle the levels.

> And yes, on x86-64, we still have the whole cmpxchg16b issue, which
> really is a slight annoyance. But the emphasis is on "slight" - we
> basically have one back for this in the SLAB code, and a couple of
> dynamic tests for one particular driver (iommu 128-bit IRTE mode).
>
> So yeah, the cmpxchg16b thing is annoying, but _realistically_ I don't
> think we care.
>
> And some day we will forget about it, notice that those (few) AMD
> early 64-bit CPU's can't possibly have been working for the last year
> or two, and we'll finally just kill that code, but in the meantime the
> cost of maintaining it is so slight that it's not worth actively going
> out to kill it.

Right, in particular my hope of turning the runtime detection into
always using compile-time configuration for cmpxchg16b is no longer
works as I noticed that risc-v has also gained a runtime detection
for system_has_cmpxchg128().

Besides cmpxchg16b, I can also see compile-time configuration
for some instructions (popcnt, tzcnt, movbe) and for 5-level
paging being useful, but not enough so to make up for the
configuration complexity.

I still think we will end up needing more compile time
configurability like this on arm64 to deal with small-memory
embedded systems, e.g. with a specialized cortex-a55 kernel
that leaves out support for other CPUs, but this is quite
different from the situation on x86-64.

> I do think that the *one* option we might have is "optimize for the
> current CPU" for people who just want to build their own kernel for
> their own machine. That's a nice easy choice to give people, and
> '-march=native' is kind of simple to use.
>
> Will that work when you cross-compile? No. Do we care? Also no. It's
> basically a simple "you want to optimize for your own local machine"
> switch.

Sure, I'll add that as a separate patch. Should it be -march=native
or -mtune=native though? Using -march= can be faster if it picks
up newer instructions, but it will eventually lead to users
running into a boot panic if it is accidentally turned on for
a kernel that runs on an older machine than it was built on.

> Maybe that could replace some of the 32-bit choices too?

Probably not. I spent hours looking through the 32-bit choices
in the hope of finding a way that is less of a mess. The current
menu mixes up instruction set level (486/586/686), optimization
(atom/k7/m3/pentiumm) and platform (elan/geode/pc) options.
This is needlessly confusing, but any change to the status quo
is going to cause more problems for existing users than it
solves. All the "interesting" embedded ones are likely to be
cross-compiled anyway, so mtune=native or -march=native wouldn't
help them either.

     Arnd

