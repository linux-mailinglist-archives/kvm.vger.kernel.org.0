Return-Path: <kvm+bounces-33089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7B1E9E45E3
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 21:38:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4D5F16998C
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 20:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DBA18EFD4;
	Wed,  4 Dec 2024 20:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="qoCHFVF4";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="V0SSfTMk"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8B93D0D5;
	Wed,  4 Dec 2024 20:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733344720; cv=none; b=V+x5z8jpFR95jBPYqknPHkmKV72Fhr/eNlVnQnPh/p42WqafmQ3NQGD4ly079AEVXRIOu7BcwoblU5MiI3pRlWtJc5xN07GpVegPFrRhtSHEXElxr6m1BBYFrK1i7TqGJ25C4aVSJ+u+VcOR5iDX+CJnUJ3o/d9QoNUnhrSXze4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733344720; c=relaxed/simple;
	bh=VQBTDrrTUucSRw8JgUt8ni66mHo0/auasFVHGVJMEzI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Z7ExpYlU/zdlPEVQGgoC8w9OMt4QFNjtWfS6PK26nZM6Vh1CCj/BnUH8BRcO8W9y3J/QvWQCYM+KlpD0iPZQ8TS/CW0vJOegR6nT0mpD6ONLyGCjOKHyYewJOx1/ZxKoKnF5PRAa7njfffeltrFImj15NjsY1pzF1MkcZLSI/T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=qoCHFVF4; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=V0SSfTMk; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 104B31140171;
	Wed,  4 Dec 2024 15:38:37 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Wed, 04 Dec 2024 15:38:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733344716;
	 x=1733431116; bh=ksk/xRcQCZNYpbBOvPXhkI3woRZO+aaqHCZZvSVVLLw=; b=
	qoCHFVF4S5D2doDweDzCR4Ylyq8+iJA2Up03bTAnYLbmxRXQYJj7j3dcCWpQ3lY4
	OHUp1dm2BVtiEu3MrA2q5ydj8+mRE7QBCqp0ECCp0VKB3PLBtgEo0mcRIFBPb33x
	1ddeIEHFVFcM5s68EYf3i1px0E8Z3viKt+vqhwoagDxMw+kKK2k+/YFcAugMVQLP
	Z/zGclMKCapYGS2EBQJzexoGYUUKHcVkHeqAvk94Akr/YuP7GG3VTBLkNaaJ+SsU
	wtqmE+7d+6o3KLQ3quxb7TsVWdj6ptxaSTeiBN3Dm1ELxvHCHxgCHxTFpfTGpuWN
	1mPxAbxmu5tEsIjVb1jSaA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733344716; x=
	1733431116; bh=ksk/xRcQCZNYpbBOvPXhkI3woRZO+aaqHCZZvSVVLLw=; b=V
	0SSfTMkDud9RO0XEh9wgmA5abO7TD/+iNLFPtVPfNft6slLo9XV7+QVyruNKUFMy
	clOLwQoK9I/A68fArltA42j6Y/GgCCLq5cSL11YhqL9DI2owaKFgotCaZVxm4Hzr
	YlAodhIHstCawUKA9F11zr9Yd1EC/R1ypo0KfhHl5CwHuzl0ngY2yn7+GPPY4YdG
	oZW/uqDHY3IaDnAWoHc3WO4nraq/2HJQ1HxbnXe3YxoMrS66LlKAxyyoI2oi1SOb
	KlEh8KlbcAk0cMgfXbaQGKjyxbirWorhs7dyYq00qBDCSQRAVCponj1Upc4J57s3
	1lVVUOHH7GQPimn8y6YoA==
X-ME-Sender: <xms:zL1QZ_3FDXLAbKztnXiCuxxARK19Rpm9C7I5UUPyQQ4FrbNHvl5Ghg>
    <xme:zL1QZ-G28CL1974tU6SbCKP9-l0SKBDoG6nUWU7GC38C1uGpP4q3Uo4eJri4LFmfo
    qQL5S6u5AofKYpvKrs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieehgddufeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdej
    necuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrd
    guvgeqnecuggftrfgrthhtvghrnhepvdfhvdekueduveffffetgfdvveefvdelhedvvdeg
    jedvfeehtdeggeevheefleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudej
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprh
    gtphhtthhopegrnhguhidrshhhvghvtghhvghnkhhosehgmhgrihhlrdgtohhmpdhrtghp
    thhtohepfhhnthhothhhsehgmhgrihhlrdgtohhmpdhrtghpthhtoheptghimhhinhgrgh
    hhihesghhnuhguugdrtghomhdprhgtphhtthhopehsvggrnhhjtgesghhoohhglhgvrdgt
    ohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtth
    hopegrnhguhieskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghrnhgusehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:zL1QZ_5bmNF3wlrWiVzllBMuNvMPA9v7KB3SR9GBLyM-1FDlGZXRTA>
    <xmx:zL1QZ03LkHcoMaIYTBYMu5HiJI4Pc84pP6zanTJlo4c2kGtnKDs3Hw>
    <xmx:zL1QZyGCjWz5jpGcHxDpchV68ZKoknPHrnt3PRb2jby8ugFZnbU7hQ>
    <xmx:zL1QZ1-qfHAFb6YwugznW2kovljpts5sG44MQBd7OjlpzrCFDdmg_Q>
    <xmx:zL1QZwVlPoss2pnnJk2SobNTuiMeFEdt3C1ATY5yVXZod2haWD5EuxSq>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 1DF612220072; Wed,  4 Dec 2024 15:38:36 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 04 Dec 2024 21:38:05 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andy Shevchenko" <andy.shevchenko@gmail.com>,
 "Arnd Bergmann" <arnd@kernel.org>, "Ferry Toth" <fntoth@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andy Shevchenko" <andy@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Sean Christopherson" <seanjc@google.com>,
 "Davide Ciminaghi" <ciminaghi@gnudd.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org
Message-Id: <206b50a2-922f-4a29-8c1a-b8695b19e65c@app.fastmail.com>
In-Reply-To: 
 <CAHp75VfzHmV2anw6C8iSCiwnJc2YNa+1aLDj6Frf9OZyGjD0MQ@mail.gmail.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-9-arnd@kernel.org>
 <CAHp75VfzHmV2anw6C8iSCiwnJc2YNa+1aLDj6Frf9OZyGjD0MQ@mail.gmail.com>
Subject: Re: [PATCH 08/11] x86: document X86_INTEL_MID as 64-bit-only
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024, at 19:55, Andy Shevchenko wrote:
> +Cc: Ferry
>
> On Wed, Dec 4, 2024 at 12:31=E2=80=AFPM Arnd Bergmann <arnd@kernel.org=
> wrote:
>>
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> The X86_INTEL_MID code was originally introduced for the
>> 32-bit Moorestown/Medfield/Clovertrail platform, later the 64-bit
>> Merrifield/Moorefield variant got added, but the final
>
> variant got --> variants were

Fixed

>> Morganfield/Broxton 14nm chips were canceled before they hit
>> the market.
>
> Inaccurate. "Broxton for Mobile", and not "Broxton" in general.

Changed to "but the final Morganfield 14nm platform was canceled
before it hit the market"=20

>> To help users understand what the option actually refers to,
>> update the help text, and make it a hard dependency on 64-bit
>> kernels. While they could theoretically run a 32-bit kernel,
>> the devices originally shipped with 64-bit one in 2015, so that
>> was proabably never tested.
>
> probably

Fixed.

> It's all other way around (from SW point of view). For unknown reasons
> Intel decided to release only 32-bit SW and it became the only thing
> that was heavily tested (despite misunderstanding by some developers
> that pointed finger to the HW without researching the issue that
> appears to be purely software in a few cases) _that_ time.  Starting
> ca. 2017 I enabled 64-bit for Merrifield and from then it's being used
> by both 32- and 64-bit builds.
>
> I'm totally fine to drop 32-bit defaults for Merrifield/Moorefield,
> but let's hear Ferry who might/may still have a use case for that.

Ok. I tried to find the oldest Android image and saw it used a 64-bit
kernel, but that must have been after your work then.

>
>> -               Moorestown MID devices
>
> FTR, a year or so ago it was a (weak) interest to revive Medfield, but
> I think it would require too much work even for the person who is
> quite familiar with HW, U-Boot, and Linux kernel, so it is most
> unlikely to happen.

Ok.

>> +
>> +         The only supported devices are the 22nm Merrified (Z34xx) a=
nd
>> +         Moorefield (Z35xx) SoC used in Android devices such as the
>> +         Asus Zenfone 2, Asus FonePad 8 and Dell Venue 7.
>
> The list is missing the Intel Edison DIY platform which is probably
> the main user of Intel MID kernels nowadays.

Ah, that explains a lot ;-)

Changed now to

          The only supported devices are the 22nm Merrified (Z34xx) and
          Moorefield (Z35xx) SoC used in the Intel Edison board and
          a small number of Android devices such as the Asus Zenfone 2,
          Asus FonePad 8 and Dell Venue 7.

> ...
>
>> -         Intel MID platforms are based on an Intel processor and chi=
pset which
>> -         consume less power than most of the x86 derivatives.
>
> Why remove this? AFAIK it states the truth.

It seemed irrelevant for users that configure the kernel. I've
put it back now.

Thanks for the review!

     Arnd

