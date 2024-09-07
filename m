Return-Path: <kvm+bounces-26070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E2E629701B6
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 12:31:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39659B23332
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 10:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D1D15884A;
	Sat,  7 Sep 2024 10:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="SsI2IE6y";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BZ7oF3tF"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh3-smtp.messagingengine.com (fhigh3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D366B1B85FC;
	Sat,  7 Sep 2024 10:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725705043; cv=none; b=AxNdCzb4Z4EOjss5xlswKKm9MWwkUSCSBpyMNbA5LBAK4kIqPxXdrGQzbxX9L7LPEeFrM+B1ULfeuFdMywqk+RXApOgXuIO+/N3tBsAxrfXGrv5nD88JS2sR/3uJen4QX+tYc86I6+ynJFS1k1A6E/azFl0Kf0dKeCZktng+CvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725705043; c=relaxed/simple;
	bh=gTRnS+H0K3fdd4v/4EEGgyEIT8Dhp7diLhNDjA8eX8Y=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=hJjdowmWI+mUBgiC0T+K1xyL4ll1rRJYIdmxdh4LRu0vuCQCIX8ieN3A3MHKhewOtf66zXxYpc4Je843rmg/U7P3RT/Qukun+Ba6b2R9po5V/guZ8Xwpz3DhzVHLiswaP2KN+3yq2OdciNQkvrEw0iY7NMtHaPG4fHLFalpv02E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=SsI2IE6y; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BZ7oF3tF; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 15DF3114023C;
	Sat,  7 Sep 2024 06:30:41 -0400 (EDT)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-09.internal (MEProxy); Sat, 07 Sep 2024 06:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1725705041;
	 x=1725791441; bh=b7Kfbz9Fro8dBk93ekS9R/GXYRzSR7ixy4z+yYXqL4A=; b=
	SsI2IE6yddd5O+mb4iy4qwv2mywJkmyqyTnbgW1wVn7RBHBdV3Vcs/Ox4tUWsXEX
	hrq+C5Jkss+khBi3WJ6isz1RVWBJd02SzLCcAXpLgMuRheCEq3JKH+d7/sBCYERQ
	if/QtH61AWasJDfwxdIvlpPsX/ITZXo8Zj8HXu8CseSGbjoVT0gkSkOZ9StSdXor
	SfjKfWXxa7Rmfdbeegn7NNnTvA+Eeg2nES1pjmN1avm1XBCbHZ2kNGLMyEfnqbRm
	MlRWTUeaMjXAQNai1ulos/i0qzEpyWU86ms9vIlimqWV6HCjUSPLjnJzAcH2CbUu
	ipqH7+G+TCo8YJD/qCxOww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725705041; x=
	1725791441; bh=b7Kfbz9Fro8dBk93ekS9R/GXYRzSR7ixy4z+yYXqL4A=; b=B
	Z7oF3tF0wpDe6SJ2yv7ebFKeLM6mHL/VnDs7xMyV/OBex87ZNEMYvlRv9fCD+Jgq
	UdLjYvwkTmfZciDaGQ1l2wkNGXVAOk4gAqXEFIgVqBwa+SdmvsWm0YsVnUIlTKFM
	9JGy7lad5WjJaOLaz4iDi5qNGN5vI4DwadRSGYhapcDb+K7i4PHLecbcbAVueGOc
	t1mdsgQr6YFKKiUfOp/3w6xiKbTSGVijyxaV0V0htij3fQGGRk3kZicS83WMUiRN
	qlRjKUGFApDjK7Pv6KZ1aKDQqoJnMt6NbWrNQvYNHKUad7bmy7M7EEkx8aLupikA
	4ebDpv/6BVqCniVRittZQ==
X-ME-Sender: <xms:UCvcZtWhZUvkNKGa3kAzMluxN2I_FSySUAM-shDvgWotS6uBEdiBPg>
    <xme:UCvcZtlh_ZcxJfx9ADkF8UQ935QfM890IHcWoZvZaxAUNQkgm9EYPReOFxoG3uw5W
    3mKUyQvBgLrzF0M4no>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudeifedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdej
    necuhfhrohhmpedflfhirgiguhhnucgjrghnghdfuceojhhirgiguhhnrdihrghnghesfh
    hlhihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhepjeehfeduvddtgffgvdffkeet
    hefhlefgvdevvdekuefffeekheehgeevhfevteejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgr
    thdrtghomhdpnhgspghrtghpthhtohepuddupdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopehtshgsohhgvghnugesrghlphhhrgdrfhhrrghnkhgvnhdruggvpdhrtghpthht
    oheptghhvghnhhhurggtrghisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehrrghfrg
    gvlheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhhirhgvshhhrdhkuhhmrghrsehl
    ihhnrghrohdrohhrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvg
    dprhgtphhtthhopehlohhonhhgrghrtghhsehlihhsthhsrdhlihhnuhigrdguvghvpdhr
    tghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlih
    hnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdhmihhpshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:UCvcZpb3N7ZGZ__4bW3EA5hDNCpVtmDo4PtDhNXGYK9w6Ofl9hWxJA>
    <xmx:UCvcZgWbcHXASo03eUhdHUtvQVx7zpgudZ_GcbIHGLr-AMVztnV0Fg>
    <xmx:UCvcZnlDGKeHuG9tQJTzWuRoDyj8sB5o1syV-Gewc9Ll6UmESZZ2mg>
    <xmx:UCvcZtcMZpRIG7a2YQXCARMNVrp46ef0s1Ii_IAldeo05K3hUi2f5Q>
    <xmx:USvcZgem6iAKBM49GLewisNpgcKkWll8jHQ_4ctaSuJm2dvedithXsJc>
Feedback-ID: ifd894703:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 8660E1C20066; Sat,  7 Sep 2024 06:30:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 07 Sep 2024 11:30:20 +0100
From: "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To: "Huacai Chen" <chenhuacai@kernel.org>
Cc: "Xuerui Wang" <kernel@xen0n.name>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 "Viresh Kumar" <viresh.kumar@linaro.org>,
 "Thomas Gleixner" <tglx@linutronix.de>,
 "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 kvm@vger.kernel.org
Message-Id: <3ff03992-09cc-4df7-ab2a-6c46fc308a09@app.fastmail.com>
In-Reply-To: 
 <CAAhV-H7W06a8cyPtSTPibJw5jOsv9Oees-hJ+-jZgaiU31Ki-g@mail.gmail.com>
References: <20240907-iocsr-v1-0-0c99b3334444@flygoat.com>
 <CAAhV-H7W06a8cyPtSTPibJw5jOsv9Oees-hJ+-jZgaiU31Ki-g@mail.gmail.com>
Subject: Re: [PATCH 0/5] LoongArch, MIPS: Unify Loongson IOCSR handling
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



=E5=9C=A82024=E5=B9=B49=E6=9C=887=E6=97=A5=E4=B9=9D=E6=9C=88 =E4=B8=8A=E5=
=8D=8811:25=EF=BC=8CHuacai Chen=E5=86=99=E9=81=93=EF=BC=9A
> Hi, Jiaxun,
>
> On Sat, Sep 7, 2024 at 6:17=E2=80=AFPM Jiaxun Yang <jiaxun.yang@flygoa=
t.com> wrote:
>>
>> Hi folks,
>>
>> This series unfied LoongArch and MIPS's IOCSR functions and
>> macros so they will expose same interface to arch-indenpendent
>> drivers.
>>
>> This can reduce code deuplication, and also help my unifed IPI driver
>> and MIPS extio driver effort.
>>
>> This is touching many sub-systems in once so might be hard to merge.
>>
>> Huacai, can you apply first three patch via loongarch-next tree.
>> For last two patch maybe better merge them via a second PR after
>> all subsystem PRs merged.
> The problem is I'm not sure whether IOCSR registers are compatible in
> all Loongson processors.

Maybe we can introduce something like IOCSR flavour later, however my ta=
ke
would be force all IOCSR devices to be probed by OF/ACPI.

In this case, it's still better to share IOCSR macro and functions betwe=
en
MIPS/LoongArch Loongson-3 processors, as they are guaranteed to be compa=
tible.

Future incompatible definitions will benefit from better resilience prov=
ided
by this series as well.

Thanks
- Jiaxun

>
> Huacai
>
>>
>> Please review.
>> Thanks
>>
>> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
>> ---
>> Jiaxun Yang (5):
>>       LoongArch: Rename cpu_has_csr as cpu_has_iocsr
>>       LoongArch: Probe more CPU features from CPUCFG
>>       LoongArch: cpu-probe: Move IOCSR probing out of cpu_probe_common
>>       LoongArch: Extract IOCSR definitions to standalone header
>>       MIPS: Loongson64: Use shared IOCSR header
>>
>>  MAINTAINERS                                        |   1 +
>>  arch/loongarch/include/asm/cpu-features.h          |   2 +-
>>  arch/loongarch/include/asm/cpu.h                   |   4 +-
>>  arch/loongarch/include/asm/loongarch.h             |  90 -----------=
-----
>>  arch/loongarch/kernel/cpu-probe.c                  | 111 +++++++++++=
+--------
>>  arch/loongarch/kernel/relocate_kernel.S            |   5 +-
>>  arch/loongarch/kernel/smp.c                        |  23 +++--
>>  .../include/asm/mach-loongson64/loongson_regs.h    |  58 +++--------
>>  arch/mips/kvm/vz.c                                 |   2 +-
>>  arch/mips/loongson64/smp.c                         |  44 ++++----
>>  drivers/cpufreq/loongson3_cpufreq.c                |  10 +-
>>  drivers/irqchip/irq-loongarch-avec.c               |   5 +-
>>  drivers/irqchip/irq-loongson-eiointc.c             |   5 +-
>>  drivers/platform/mips/cpu_hwmon.c                  |   7 +-
>>  include/linux/loongson/iocsr.h                     | 113 +++++++++++=
++++++++++
>>  15 files changed, 256 insertions(+), 224 deletions(-)
>> ---
>> base-commit: 9aaeb87ce1e966169a57f53a02ba05b30880ffb8
>> change-id: 20240906-iocsr-829075458511
>>
>> Best regards,
>> --
>> Jiaxun Yang <jiaxun.yang@flygoat.com>
>>

--=20
- Jiaxun

