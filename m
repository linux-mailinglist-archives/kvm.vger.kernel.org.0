Return-Path: <kvm+bounces-47687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4290FAC3C30
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 10:59:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10FFB174E04
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 08:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7281E7C05;
	Mon, 26 May 2025 08:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="nBfqjNff"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9306E1E633C
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 08:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748249931; cv=none; b=b8DB1o9CpZWdcq6K9QWm7g72dScjDjCTB9QHaAq4zf5AY9wpj5RP07KuHvJrMIeMf1oxLH3hP4zig7UvznZgScQ/jEAzETywqhL0DR0Nu9u8WLRlwliTIgWs2vU3mwp7GWM/OQfxmteriRIfQjUYIThxSh7PSW6rf34tdB1mVsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748249931; c=relaxed/simple;
	bh=A07uMUlAiHODBnye6U6+ZYgmI+z5BqjupTHEKb1apD0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=WN6TlWrBi2cB2mLW2ptcaoxxeBHfUUxW4wyvMu0C2skmD3hJWf7wuhf6IcyDfkASJtFAIw14MJ288rWUDxEoh3k763qfwYfoV2txVkfjb0KG2mbAjdWicN+poDtP9VULOm0Zp5KyTo+mUTREMQhGzqzXwvRUxHS4QVll9OfW6f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=nBfqjNff; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43cee550af2so418045e9.1
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 01:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1748249928; x=1748854728; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XUa5QDzySuu6U8WB9K8OF+ZIZj9kEnHYCZp+dCaCR0=;
        b=nBfqjNffw48hNkVyyQHtfWhCWLtfYgFnYlWzQxkgwUg1QVgDUfH9XpKxk+cOUvnn3g
         IO4NuFbH15/FllezFedzKyq6v4jZkTFrzMIVGMorT1c/7reVH0HMY8Nz0YuVR5bcVmbb
         2cYsdaUWh1i8uj+KivWANTASq1cxKAOyKd9hA6RY0Yh0COw9BO2AN9tbP4tIXopmWdOr
         vd8Md2mx+PAJyt+XKTBrUa4maEOyVzugxAHU1ZQ8PjDSXzn4RTmGYVmL2OPWbec3tK7s
         dOhESPB4+SQSYcav2M8frCWMcUsa5so2Kxplu5y0B8Tw/fsgpHC44Bnf6Ce9Gec8edEn
         UqSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748249928; x=1748854728;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7XUa5QDzySuu6U8WB9K8OF+ZIZj9kEnHYCZp+dCaCR0=;
        b=NWYICl3+coC9Bu2ZX1DqLx8LoPwhYoXtmYmBG5WuQPtSqZEheMmKUtfSclGU49rOQO
         JZglWNm6MG48tHI9tdrtoYeM0vIH8XWt/qeHkeqOLNwGMV7ZMmPu2AR1p4IescJ9eW7c
         Ryvodae1Kt50jchzKJbJsMsJpdh576eaY/Oj52UsuTCUDTO+SpjG6oN2tUx2dpmQrJ+g
         PitSoqq+6mqM0O8g8q38VwC/Jtf7IQM/jA5cvhD8oqn5H/f6BHDr21DFORI8elY+xHoq
         BvuZu0fxIeZjtmN8cgY/VoO4Nduyi5Kv+Hk/h2rM3pAXA/om07zCu6P9Z1mQdcNiWfkN
         32ig==
X-Forwarded-Encrypted: i=1; AJvYcCUfeX5EmxLJvVSkMb36xZXEOLYzdYkmmLhgXISp8tSsG5tKPc2AeB60UkyqRLpRaRX9fCM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/l4rqSDL/SFqE694ddXIpzvubySKtSBP6BdLKyKCkD4C+QU9/
	XNO7jXbVYIoDxyE7/BACiW6CDFe9YyNbwNe4a6xVqiC62gKGM+LrBOArJidvwq4WHiM=
X-Gm-Gg: ASbGncsSKLFKo61hbD479cbHCfh4VaFXNQS1nDQGqEMPzMja/BLhX2BwQGZpBBBi5oU
	EO2fOUVry6rcVsOKdd85Iv/Zh0PeUnNYrHkPVBUwXDx3hSezYAMabrQmHUZ6BOpFkRYmrMUEBGC
	SzMOMC6cbhlewwV2SQT+lEa91GPMqnfzthCzymAendRxsMUfU0Rqzv0NfWBefXDQiV2fgG7/PGc
	np4azIqsf5n+UX3KsKFI2pVHVj3tArEGkflGvDw0NjFiMigfIxC+dn/98E5mgjobrgw9lUkZ79B
	6RVtq2he4Yf3LUFAKPXdUGjRAMwQ3b+GeSeFHvfw940P8LRBEHuEH7nwxjw=
X-Google-Smtp-Source: AGHT+IEdx9Lxmxr6Jj4a/VtrbY6n55+AjozaESSFCcKKfyGvvRTO9hEvIbHH5Dnsj/C495VBfSOibw==
X-Received: by 2002:a05:600c:1c24:b0:439:9ec5:dfa with SMTP id 5b1f17b1804b1-44c938cb1e6mr27073595e9.7.1748249927727;
        Mon, 26 May 2025 01:58:47 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:b85a:a7d4:fa4e:bb11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4d007bbccsm5654781f8f.89.2025.05.26.01.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 01:58:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 May 2025 10:58:46 +0200
Message-Id: <DA5YVKW682V3.2DODRY4EDL3IW@ventanamicro.com>
Subject: Re: [PATCH v8 13/14] RISC-V: KVM: add support for FWFT SBI
 extension
Cc: "Samuel Holland" <samuel.holland@sifive.com>, "Andrew Jones"
 <ajones@ventanamicro.com>, "Deepak Gupta" <debug@rivosinc.com>, "Charlie
 Jenkins" <charlie@rivosinc.com>, "linux-riscv"
 <linux-riscv-bounces@lists.infradead.org>
To: "Atish Patra" <atish.patra@linux.dev>,
 =?utf-8?q?Cl=C3=A9ment_L=C3=A9ger?= <cleger@rivosinc.com>, "Paul Walmsley"
 <paul.walmsley@sifive.com>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Anup
 Patel" <anup@brainfault.org>, "Atish Patra" <atishp@atishpatra.org>, "Shuah
 Khan" <shuah@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>, <linux-kselftest@vger.kernel.org>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250523101932.1594077-1-cleger@rivosinc.com>
 <20250523101932.1594077-14-cleger@rivosinc.com>
 <DA3K95ZYJ52S.1K6O3LN6WEI0N@ventanamicro.com>
 <9f9e2869-725d-4590-887a-9b0ef091472e@rivosinc.com>
 <DA3OJ7WWUGLT.35AVP0QQDJRZV@ventanamicro.com>
 <5dd587b3-8c04-41d1-b677-5b07266cfec5@linux.dev>
In-Reply-To: <5dd587b3-8c04-41d1-b677-5b07266cfec5@linux.dev>

2025-05-23T11:02:11-07:00, Atish Patra <atish.patra@linux.dev>:
> On 5/23/25 9:27 AM, Radim Kr=C3=84m=C3=83=C2=A1=C3=85 wrote:
>> 2025-05-23T17:29:49+02:00, Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>=
:
>>> Is this something blocking though ? We'd like to merge FWFT once SBI 3.=
0
>>> is ratified so that would be nice not delaying it too much. I'll take a
>>> look at it to see if it isn't too long to implement.
>>=20
>> Not blocking, but I would at least default FWFT to disabled, because
>> current userspace cannot handle [14/14].  (Well... save/restore was
>> probably broken even before, but let's try to not make it worse. :])
>>=20
>
> User space can not enable or disable misaligned access delegation as=20
> there is no interface for now rightly pointed by you.

I mean setting default_disabled=3Dtrue and just disabling FWFT for the
guest unless userspace explicitly enables the incomplete extension.
We would blame the user for wanting mutually exclusive features.

>                                                       I guess supporting=
=20
> that would be quicker than fixing the broader guest save/restore=20
> anyways. Isn't it ?

Yes.  The save/restore for FWFT is simple (if we disregard the
discussions), but definitely more than a single line.

