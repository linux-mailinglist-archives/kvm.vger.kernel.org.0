Return-Path: <kvm+bounces-26920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32025978FF6
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 12:28:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5721B1C220B1
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 10:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0104F1CEEAD;
	Sat, 14 Sep 2024 10:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="ZTVwrOwg";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kFl6aUv0"
X-Original-To: kvm@vger.kernel.org
Received: from fout7-smtp.messagingengine.com (fout7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE87139CE9;
	Sat, 14 Sep 2024 10:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726309697; cv=none; b=mGuZuGN71oMTu2vCbxm9/a24BQHyse4Ero+1XMUbINwddbVFendQavwqhYWqtPh/UaMji4ILQ0NjQmE+DU20qLswkQ8jdodV2zObTjBeZwyRBp+hgArBJT0R9nZqP/j47eRjBHn9I1XgDe27OYsdq9HFg+QHnjR/EPrtaQn+n4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726309697; c=relaxed/simple;
	bh=CCWTWrL1CydY3BbMjeEC6jRmI5josYSow3PV8jabXok=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=JSbYmJe9GSJIij+mWAzA7qTOdtIF8hfOkK1UwZw8HP9PlAnCQIltuHjcEDzj0CaSQ0WaLSuOFM5F0k4xQEw9YuyhN6Dly2JMiyuIuyGhukjk+4ULMT4+/RRtWCJVeqWnpGW1/q6vvQCRbacHwJkWARBK/mXZwx8r7I3IWAyku98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=ZTVwrOwg; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kFl6aUv0; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id B95F4138035C;
	Sat, 14 Sep 2024 06:28:13 -0400 (EDT)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-09.internal (MEProxy); Sat, 14 Sep 2024 06:28:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1726309693;
	 x=1726396093; bh=danSfcBwMUd//FTPPuU989iGYB86QAvoXE8dOeG4wXc=; b=
	ZTVwrOwgqQj1oaNZ6vQsYLGEDIiMibXeMKUibdQr/F9UGUGEkyhPXVjTmeBQEi8R
	WWkBXXKDVgyJRnqAF8yiFLqYAoayqJbDWkZH9O73nmGNa+bluHUZcSLZU0q5fjPD
	DXC0G4YmHInw5FQ9Ziy6lv/Twxp//jxJh+Y2bvBnEoS7KtgJZYURRe/n1xS3qrx1
	aQMhwlQs2HTrQO23RtaBo++CMosTYhTlljtsc/+uyUsdvk0QDfqqn5WMM9ntYtjZ
	0pC3w0R6nXuLix9dpKv7IATtCHZ87UYv+g+g+L+dW8OnkV0ndMI5n0fziIwtI8XI
	iLaVNAwZntxag4oC3/HI/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1726309693; x=
	1726396093; bh=danSfcBwMUd//FTPPuU989iGYB86QAvoXE8dOeG4wXc=; b=k
	Fl6aUv0OJNzQxZLZ/e/zWD3Kj75p/b2EuAMu4Rwaa08/g+Wep+AWD94xhAa3mMcP
	nGCIonKLiW5/vCzfrCkZCKnkEzRM4XIixuRolWC7Zhv+IrnKhOC1j5WLYKjRjzGR
	xTcgZoWz3W/CuZZ4E6VLYU+6+FmrGN7eao8NZh4aCu0c5jmXhoQSMTEwdoDVA52L
	wY+mUpA5thnT+9HzlkEU3f6oJV90whfbSbp6bk69jNnJKxyrWBl7R3ETm577w2W/
	OoAirIDOmhbTr3QosTnd2AVSQ+hWevSBv4LKT5aTHBagxY9yAzgGv4/GgmGHDhjV
	ObHaAyBLnV477dcwQsn/g==
X-ME-Sender: <xms:PGXlZp69WOKZC4OhV9RaLoXqsomDZPaYzdpB_Ua5a0RYOfFIWaNffQ>
    <xme:PGXlZm7MwjPvquLh8fLVJHoSzjUQ3PS-R8kuS5aJG2eUfSG_2C8gnoBGmy5mtDmEi
    RDFyeqQ12cE0y2rw90>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudektddgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdej
    necuhfhrohhmpedflfhirgiguhhnucgjrghnghdfuceojhhirgiguhhnrdihrghnghesfh
    hlhihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhepveeuffetfeekhefhtdfhleef
    ffejvdffkefgieeuudegkeegjeevtdffieeltdeunecuffhomhgrihhnpehgihhthhhusg
    drtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmpdhnsggprhgtphhtthhope
    duvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepthhssghoghgvnhgusegrlhhp
    hhgrrdhfrhgrnhhkvghnrdguvgdprhgtphhtthhopegthhgvnhhhuhgrtggriheskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheprhgrfhgrvghlsehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehvihhrvghshhdrkhhumhgrrheslhhinhgrrhhordhorhhgpdhrtghpthhtoh
    epthhglhigsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtoheplhhoohhnghgrrhgt
    hheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehmrghosghisghosehloh
    honhhgshhonhdrtghnpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdroh
    hrgh
X-ME-Proxy: <xmx:PGXlZgc3ZN7_Pjo63NJkLxrPCUkqa6z_LrJy4zvDJ1NSfJVIJ9H7hw>
    <xmx:PGXlZiIkc8u6wH2xMrn61miU9lfUdbhj6Vs8mFjuEGeg9JTWoOaubQ>
    <xmx:PGXlZtKyGBpNJCoYIqkeG0h_cbVN2FKf7WoElEw0Fy8tfCzncvGxdQ>
    <xmx:PGXlZrxrq8NpE_QddsrbFkvwIduad_oqokN9lgvWr6kHl0_yCJEeRQ>
    <xmx:PWXlZnzlI5XCaFmxr3Io9Glca9KA9BwlajY3wj45qQPC5tlsl5rM06iV>
Feedback-ID: ifd894703:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 4D1671C20065; Sat, 14 Sep 2024 06:28:12 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 14 Sep 2024 11:27:44 +0100
From: "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To: "Bibo Mao" <maobibo@loongson.cn>, "Huacai Chen" <chenhuacai@kernel.org>,
 "Xuerui Wang" <kernel@xen0n.name>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "Viresh Kumar" <viresh.kumar@linaro.org>,
 "Thomas Gleixner" <tglx@linutronix.de>,
 "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 kvm@vger.kernel.org
Message-Id: <5e29630b-36ec-4f9e-a7d8-d8afa29150d1@app.fastmail.com>
In-Reply-To: <147e72c9-8177-9c03-8baf-df7362143cd6@loongson.cn>
References: <20240913-iocsr-v3-0-81a57f60350d@flygoat.com>
 <20240913-iocsr-v3-3-81a57f60350d@flygoat.com>
 <147e72c9-8177-9c03-8baf-df7362143cd6@loongson.cn>
Subject: Re: [PATCH v3 3/4] LoongArch: Extract IOCSR definitions to standalone header
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



=E5=9C=A82024=E5=B9=B49=E6=9C=8814=E6=97=A5=E4=B9=9D=E6=9C=88 =E4=B8=8A=E5=
=8D=889:56=EF=BC=8Cmaobibo=E5=86=99=E9=81=93=EF=BC=9A
> Hi jiaxun,
Hi Bibo,

Thanks for your comments.

[...]
>> +
>> +#define LOONGSON_IOCSR_FEATURES	0x8
>> +#define  IOCSRF_TEMP			BIT_ULL(0)
>> +#define  IOCSRF_NODECNT			BIT_ULL(1)
>> +#define  IOCSRF_MSI			BIT_ULL(2)
>> +#define  IOCSRF_EXTIOI			BIT_ULL(3)
>> +#define  IOCSRF_CSRIPI			BIT_ULL(4)
>> +#define  IOCSRF_FREQCSR			BIT_ULL(5)
>> +#define  IOCSRF_FREQSCALE		BIT_ULL(6)
>> +#define  IOCSRF_DVFSV1			BIT_ULL(7)
>> +#define  IOCSRF_EIODECODE		BIT_ULL(9)
>> +#define  IOCSRF_FLATMODE		BIT_ULL(10)
>> +#define  IOCSRF_VM			BIT_ULL(11)
>> +#define  IOCSRF_AVEC			BIT_ULL(15)
> Is these definiton the same between Loongson3 mips and LoongArch machi=
ne=20
> such as IOCSRF_FLATMODE/IOCSRF_AVEC?

Those bits are only defined on LoongArch based loongson3, and will be ze=
ro
on MIPS loongson3 systems. Zero means hardware doesn't have such feature,
this is still semantically correct.

Given that there will be no more future MIPS loongson3 it makes sense to
just define them in common header.

>
[...]
>> +
>> +/* PerCore CSR, only accessible by local cores */
>> +#define LOONGSON_IOCSR_IPI_STATUS	0x1000
>> +#define LOONGSON_IOCSR_IPI_EN		0x1004
>> +#define LOONGSON_IOCSR_IPI_SET		0x1008
>> +#define LOONGSON_IOCSR_IPI_CLEAR	0x100c
>> +#define LOONGSON_IOCSR_MBUF0		0x1020
>> +#define LOONGSON_IOCSR_MBUF1		0x1028
>> +#define LOONGSON_IOCSR_MBUF2		0x1030
>> +#define LOONGSON_IOCSR_MBUF3		0x1038
> It seems that it is only used with arch/loongarch/kernel/smp.c,
> and file smp.c is arch specific. No generic driver uses this.

Yes, but arch/mips/loongson64/smp.c are using those bits as well,
and will be converted in next patch.

Just FYI, I'm now trying to implement a common SMP IPI driver for
MIPS/LoongArch Loongson chips, there is a preview [1].

>
>> +
[...]
>> +
>> +/* Register offset and bit definition for CSR access */
>> +#define LOONGSON_IOCSR_TIMER_CFG       0x1060
>> +#define LOONGSON_IOCSR_TIMER_TICK      0x1070
>> +#define  IOCSR_TIMER_CFG_RESERVED       (_ULCAST_(1) << 63)
>> +#define  IOCSR_TIMER_CFG_PERIODIC       (_ULCAST_(1) << 62)
>> +#define  IOCSR_TIMER_CFG_EN             (_ULCAST_(1) << 61)
>> +#define  IOCSR_TIMER_MASK		0x0ffffffffffffULL
>> +#define  IOCSR_TIMER_INITVAL_RST        (_ULCAST_(0xffff) << 48)
> I do not find any use about IOCSR_TIMER macro, which does ip driver us=
e=20
> this?

So IOCSR timer is obsoleted by LoongArch's architecture timer, but still
present on at least 3A5000 for compatibility reason. We may write a driv=
er
for it at some point.

It is common practice that hardware headers contains those bits that are=
 not used
by drivers yet to serve as a document to the hardware.

>
>> +
>> +#define LOONGSON_IOCSR_EXTIOI_NODEMAP_BASE	0x14a0
>> +#define LOONGSON_IOCSR_EXTIOI_IPMAP_BASE	0x14c0
>> +#define LOONGSON_IOCSR_EXTIOI_EN_BASE		0x1600
>> +#define LOONGSON_IOCSR_EXTIOI_BOUNCE_BASE	0x1680
>> +#define LOONGSON_IOCSR_EXTIOI_ISR_BASE		0x1800
>> +#define LOONGSON_IOCSR_EXTIOI_ROUTE_BASE	0x1c00
>> +#define IOCSR_EXTIOI_VECTOR_NUM			256
> Is it better to define these macro in common header file or in extioi=20
> driver?  It seems that only extioi use it.

Maybe :-) This is a little bit out of scope of this series but I can try
later.

Thanks
[...]

[1]: https://github.com/FlyGoat/linux/commit/0a5ee611529d359b4d22eaae22c=
2b9835c63c63f

--=20
- Jiaxun

