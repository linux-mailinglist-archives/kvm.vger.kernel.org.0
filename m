Return-Path: <kvm+bounces-33091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1937F9E4665
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 22:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73C9816A043
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 21:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 937DB1917FF;
	Wed,  4 Dec 2024 21:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Rw2UNFh6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NBM0o1S1"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFED1944F;
	Wed,  4 Dec 2024 21:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733346899; cv=none; b=DV7KJWhG1e7GsG7IPRyfQFDovRuwm6EB6KVS0OM5a5I6ybXeVYwrNoszq660BSFBr7FL9l1rvuTcWht2bx+hQdqUoqor3q6O2WnBbcqRd52xAiu1uZfaTMhw5oEFYq0UcsHlCCeL1XNF97mV3H7M//vs8RonKaC3dguHZNMxE7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733346899; c=relaxed/simple;
	bh=rbwkvmyO46CY+gzggxI7A3oUWGLx+T+juEN5TbOEtbw=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Q2orsX9ASYqdUALmWN/H4bgQkwuo8gxo1vZnZ1UFNma+NWqf8KOIK7mhjaWlDY1J5JX6LTK3XgAY9hhq2v0uEcsxXMacOjRrKZGqHfaTJe9dfBR5wavKXPD4VQmE36iEp1OG/JRF6v6HEN/XPDjysZAezzVVDMIfe7Zrq9KunpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Rw2UNFh6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NBM0o1S1; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8094C25401C4;
	Wed,  4 Dec 2024 16:14:56 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Wed, 04 Dec 2024 16:14:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1733346896;
	 x=1733433296; bh=LF8iUI8zmIoSB/UxxJx2/rXwczmvG0EFZRWKcV8LpEc=; b=
	Rw2UNFh6IIeoijXWKy15u7/LOcHPRNMWBPMh8RZ5Xkrp+IPp5ag0Ww+CF2MTuEDF
	44XFyJkyRUeQnp+AjtuZ3kyqEHom5bXaE4f1rcxSKZUX2l39ywSdOgO1o0dH9WOA
	FiWdl13jVXhjb+bJ84IZ38fTTcMDruk+rvSU+54mZe4jDzbHr9q3xrrHA96dpgTi
	FHNeG5UHDUcfASoGonabcEsh1Nt8dup1c+CluXMwlp57rB+Watw87tgdMjT2fLfU
	A5rooIGYxxLtlRZrbyeczcyU3v+apsMERggH8itP+b5kGQ1zBa/4AsADjXJ6wNci
	bdUrU93prH+Mxj+15hUcBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733346896; x=
	1733433296; bh=LF8iUI8zmIoSB/UxxJx2/rXwczmvG0EFZRWKcV8LpEc=; b=N
	BM0o1S1dTWKdphVy3sW2axvDp2IhnO1uJDR/+oT8Mebn41HPxrFKIrlZ4oWxINnV
	UHitdMAUtOsH/GewtiUs32zVn+0Ik0dC15kAv0OIFFOwlTBdcHfS2eaf46KedqdF
	Zz/wDshNT2s+Sglg0RPSrdjzPBBWox1WAn1mTqZD7Vwh1qHP6vcUckOg3TOj0ugv
	QiakdsZdY4n9Si2/BnvfZKoREGxuDLrCZ4dGh2ikgku4itwnRHaxqJ46doTqpzcj
	QbImJEI3InfJpqSvD7Z/OANHKjA5hbhRvWD+n/RsRJYbBoVNR4re07kA/w3VoDA3
	MOxycI089WnVaPYf9wrlA==
X-ME-Sender: <xms:T8ZQZ6xPqRFKFYNpHTmwgMvBqpYsVSwotgeVq_RCzVH_nAnj5udxEQ>
    <xme:T8ZQZ2SQMYWcEUXHFUiXZhhZQ9nsGvEdLMnBjauLOXQ3YipltGZu_kTQAOk_cHkxi
    ZswSP-Ujki8RZjIRw0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieehgddugedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdej
    necuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrd
    guvgeqnecuggftrfgrthhtvghrnhepvdfhvdekueduveffffetgfdvveefvdelhedvvdeg
    jedvfeehtdeggeevheefleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudej
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprh
    gtphhtthhopegrnhguhidrshhhvghvtghhvghnkhhosehgmhgrihhlrdgtohhmpdhrtghp
    thhtohepsghrghgvrhhsthesghhmrghilhdrtghomhdprhgtphhtthhopegtihhmihhnrg
    hghhhisehgnhhuuggurdgtohhmpdhrtghpthhtohepshgvrghnjhgtsehgohhoghhlvgdr
    tghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpth
    htoheprghnugihsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrrhhnugeskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:T8ZQZ8WqZAml3Yv-vejuW-qPq_1UZ_5fsQCvgchXSpDE4NzVSyO0QA>
    <xmx:T8ZQZwggyfktWj-ZmBNFybSO5XqrCoPbjAXIDsqUyqPna8dWXJdJ-w>
    <xmx:T8ZQZ8CXDcGoZzGN4nk9Ypq4g1G0vpM4REaI1iNlq6KNtByu5D8IhA>
    <xmx:T8ZQZxK5Bk8GwSpxuQml_q2pFAPyUn7ErsxK-1aMAzU8DujZ-M28Aw>
    <xmx:UMZQZ2ydIhi2LYwxf4_p8Cwv6d9mSGWJXwBBkI_4_Aamjg3Rqqf5Cy43>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 419CC2220073; Wed,  4 Dec 2024 16:14:55 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 04 Dec 2024 22:14:33 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andy Shevchenko" <andy.shevchenko@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Brian Gerst" <brgerst@gmail.com>,
 "Arnd Bergmann" <arnd@kernel.org>, linux-kernel@vger.kernel.org,
 x86@kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
 "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andy Shevchenko" <andy@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Sean Christopherson" <seanjc@google.com>,
 "Davide Ciminaghi" <ciminaghi@gnudd.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org
Message-Id: <dccca669-7981-4f36-a701-0692c6b5c958@app.fastmail.com>
In-Reply-To: 
 <CAHp75VfyBLTnY1kReQ-ALngWqPoyLaHhsmT1shR_UzpL8sK1UA@mail.gmail.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-6-arnd@kernel.org>
 <CAMzpN2joPcvg887tJLF_4SU4aJt+wTGy2M_xaExrozLS-mvXsw@mail.gmail.com>
 <A0F192E7-EFD2-4DD4-8E84-764BF7210C6A@zytor.com>
 <13308b89-53d1-4977-970f-81b34f40f070@app.fastmail.com>
 <CAHp75VfyBLTnY1kReQ-ALngWqPoyLaHhsmT1shR_UzpL8sK1UA@mail.gmail.com>
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024, at 19:37, Andy Shevchenko wrote:
> On Wed, Dec 4, 2024 at 6:57=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> w=
rote:
>> On Wed, Dec 4, 2024, at 17:37, H. Peter Anvin wrote:
>> > On December 4, 2024 5:29:17 AM PST, Brian Gerst <brgerst@gmail.com>=
 wrote:
>> >>>
>> >>> Removing this also drops the need for PHYS_ADDR_T_64BIT and SWIOT=
LB.
>> >>> PAE mode is still required to get access to the 'NX' bit on Atom
>> >>> 'Pentium M' and 'Core Duo' CPUs.
>> >
>> > By the way, there are 64-bit machines which require swiotlb.
>>
>> What I meant to write here was that CONFIG_X86_PAE no longer
>> needs to select PHYS_ADDR_T_64BIT and SWIOTLB. I ended up
>> splitting that change out to patch 06/11 with a better explanation,
>> so the sentence above is just wrong now and I've removed it
>> in my local copy now.
>>
>> Obviously 64-bit kernels still generally need swiotlb.
>
> Theoretically swiotlb can be useful on 32-bit machines as well for the
> DMA controllers that have < 32-bit mask. Dunno if swiotlb was designed
> to run on 32-bit machines at all.

Right, that is a possibility. However those machines would
currently be broken on kernels without X86_PAE, since they
don't select swiotlb.

If anyone does rely on the current behavior of X86_PAE to support
broken DMA devices, it's probably best to fix it in a different
way.

      Arnd

