Return-Path: <kvm+bounces-26771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BE50977338
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 22:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F3A2B249C9
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 20:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE831C1ADB;
	Thu, 12 Sep 2024 20:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="ReM/YMkp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PYGH24lp"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh4-smtp.messagingengine.com (fhigh4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0565B13CFB7;
	Thu, 12 Sep 2024 20:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726174763; cv=none; b=dhaJPGHGb6Ieel/kdVBBkYgut5+aryBOMkffLESIQ38mY0KUKb6hAYHKt5xGhPuoahotMQPztyuM/Oc35GTWRlhyrBz7X5GsEJIC+rsyNuZPmXfJx6LUm3sA4Lfn0Bv+ImrE2gdt0yV1vn4pZgR1NfFU9qNtPOT8sZqK7N9ZbjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726174763; c=relaxed/simple;
	bh=qr1Df2OoDZPLJ69NWzli/7RsKLfj4rBzJ3FhmLOg1hs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=bwmrm1uCAz8ddPr0q5fWwrxiE/HrqKQ/v9zjyYONPzLZdeA+h3JXcq1cQeV76Ei/Bxv9I9Aj4pJSamvzO/Y3my6HFsTOKZXBTeUccdISiqIbZw/QcqGt4d6t/1f8S3oDS4duK8OYX6NMKlsfc30KMwqVrOTh90PsvPXrHsyc1HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=ReM/YMkp; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PYGH24lp; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 47F3B114012B;
	Thu, 12 Sep 2024 16:59:21 -0400 (EDT)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-09.internal (MEProxy); Thu, 12 Sep 2024 16:59:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1726174761;
	 x=1726261161; bh=z9RyMeYnaCpJjL5NRxfd4gM6cPZLEzjGh1sm47Fz4fU=; b=
	ReM/YMkpzLgrnxitYaJbJI8wvFkkU+WBRml2AmADWw/xJIdcrYBQcZqESacdPqLZ
	PBS7b/qKuvxCAchFgu6AfJ2ihfqDoj6mefKm1BGVeXzLcecSEJd3D7BUpAtCVAZw
	2QsZ0cWbTWY2LK5oSWro6Fo8c4uxjiVFmh8QFU8FSZsp28AKI6vZ0DnxgXrzoYzI
	nSA03gxElsAMAmErBJ3jTIYlm7bWg7CzGTUN3km1mR/bE5v7LmgiEiXkH3WppAf3
	1vZEeElRMGQIXKYn7oBNPV8ECYREJmdwkmI7bv+VvAPmrEkFumLA3Qr/AzrdGcad
	/E/vU36AUR6YRSiOQAMAhA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1726174761; x=
	1726261161; bh=z9RyMeYnaCpJjL5NRxfd4gM6cPZLEzjGh1sm47Fz4fU=; b=P
	YGH24lpXVjiOxGgkZlx51jOtPc475IvnJkaUSJ30/969MismK00XfaOOZssIj0+B
	m8pWKPctI1Fl4oYF7lfP/UsqHvYuz6/mFNKLIMDraLFQFi1H6vp6wjd1SDsfnDQI
	0JurWsYizqj+/HXa8vC4kr2WmjYqrkRVlwJTl0Adi50jkmbGT2vG7sZ6lJH90tEp
	RXbjKOVjWmOJ27VvIpQYlJhj53Idbfk6lyMRWq9E9rS/2yK/VBH1KSuxQQVPOf7P
	GcAe5Uy44aHQ7pFQUgURC9SmfbRPfZ/f2cREZf73iWOsWyiabPFZR2/fbtd/S6yw
	wxpjbYcj4RCk0I+ZTbIsg==
X-ME-Sender: <xms:KVbjZtAeprkZeyYcuyzTRRu5Vb_EaC4d6T7nNY2o98CyKF6a9PwWfw>
    <xme:KVbjZrgaIFvIQ0dxG2XAKZLCatYNwvx1BwsZEcPPfcB-te5wfYzgjeetHJ8jOo6Zt
    4gUzyhD6hOL8cS9f2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudejfedgudehkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthhqredtredt
    jeenucfhrhhomhepfdflihgrgihunhcujggrnhhgfdcuoehjihgrgihunhdrhigrnhhgse
    hflhihghhorghtrdgtohhmqeenucggtffrrghtthgvrhhnpeejheefuddvtdfggfdvffek
    teehhfelgfdvvedvkeeuffefkeehheegvefhveetjeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhihghho
    rghtrdgtohhmpdhnsggprhgtphhtthhopeduuddpmhhouggvpehsmhhtphhouhhtpdhrtg
    hpthhtohepthhssghoghgvnhgusegrlhhphhgrrdhfrhgrnhhkvghnrdguvgdprhgtphht
    thhopegthhgvnhhhuhgrtggriheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprhgrfh
    grvghlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvihhrvghshhdrkhhumhgrrhes
    lhhinhgrrhhordhorhhgpdhrtghpthhtohepthhglhigsehlihhnuhhtrhhonhhigidrug
    gvpdhrtghpthhtoheplhhoohhnghgrrhgthheslhhishhtshdrlhhinhhugidruggvvhdp
    rhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqmhhiphhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:KVbjZokIrc3L0xm36htY1eEFyXuC3F_Z-TxQCwXCmq1BlKg3M-axJQ>
    <xmx:KVbjZnwkh_lkFc5d-d77ZOllCysaaR1jOqhFz5DZvi6hU2pW-cECHg>
    <xmx:KVbjZiS15Q-P5hCAfA-QJH8EtwbWTsgTqIJii7Jer02l4sf286lFyQ>
    <xmx:KVbjZqYUo9u-vOMzqbVAHc-MNPNYF-numoMTXGGza8SiYyZgz9V85A>
    <xmx:KVbjZnLYc_nRyVRP3_dfJowA1Uyk5CWcfKVF6h2KEm2UJntAErRXEFgj>
Feedback-ID: ifd894703:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 072B31C20065; Thu, 12 Sep 2024 16:59:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 12 Sep 2024 21:59:00 +0100
From: "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To: "Huacai Chen" <chenhuacai@kernel.org>, "Xuerui Wang" <kernel@xen0n.name>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 "Viresh Kumar" <viresh.kumar@linaro.org>,
 "Thomas Gleixner" <tglx@linutronix.de>,
 "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 kvm@vger.kernel.org
Message-Id: <4f631f4a-eeb8-4b57-8424-4f5e970f0b69@app.fastmail.com>
In-Reply-To: <20240912-iocsr-v2-2-e88f75b37da4@flygoat.com>
References: <20240912-iocsr-v2-0-e88f75b37da4@flygoat.com>
 <20240912-iocsr-v2-2-e88f75b37da4@flygoat.com>
Subject: Re: [PATCH v2 2/4] LoongArch: cpu-probe: Move IOCSR probing out of
 cpu_probe_common
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



=E5=9C=A82024=E5=B9=B49=E6=9C=8812=E6=97=A5=E4=B9=9D=E6=9C=88 =E4=B8=8B=E5=
=8D=889:55=EF=BC=8CJiaxun Yang=E5=86=99=E9=81=93=EF=BC=9A
[...]
> +
> +	if (c->options & LOONGARCH_CPU_IOCSR)
> +		return;
Oops, typo here, there should be a not :-(

Huacai, if the series is ok for you please fix this when applying
the patch. I only tested against NEMU so didn't catch this :-(

Thanks
- Jiaxun

> +
> +	*vendor =3D iocsr_read64(LOONGARCH_IOCSR_VENDOR);
> +	*cpuname =3D iocsr_read64(LOONGARCH_IOCSR_CPUNAME);
> +
> +	if (!__cpu_full_name[cpu])
> +		__cpu_full_name[cpu] =3D cpu_full_name;
> +
> +	config =3D iocsr_read32(LOONGARCH_IOCSR_FEATURES);
> +	if (config & IOCSRF_CSRIPI)
> +		c->options |=3D LOONGARCH_CPU_CSRIPI;
> +	if (config & IOCSRF_EXTIOI)
> +		c->options |=3D LOONGARCH_CPU_EXTIOI;
> +	if (config & IOCSRF_FREQSCALE)
> +		c->options |=3D LOONGARCH_CPU_SCALEFREQ;
> +	if (config & IOCSRF_FLATMODE)
> +		c->options |=3D LOONGARCH_CPU_FLATMODE;
> +	if (config & IOCSRF_EIODECODE)
> +		c->options |=3D LOONGARCH_CPU_EIODECODE;
> +	if (config & IOCSRF_AVEC)
> +		c->options |=3D LOONGARCH_CPU_AVECINT;
> +	if (config & IOCSRF_VM)
> +		c->options |=3D LOONGARCH_CPU_HYPERVISOR;
>  }
>=20
>  #ifdef CONFIG_64BIT
>
> --=20
> 2.46.0

--=20
- Jiaxun

