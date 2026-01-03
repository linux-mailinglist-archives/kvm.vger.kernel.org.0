Return-Path: <kvm+bounces-66969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DEA8CF015B
	for <lists+kvm@lfdr.de>; Sat, 03 Jan 2026 16:03:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 67D1F302E144
	for <lists+kvm@lfdr.de>; Sat,  3 Jan 2026 15:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E4E30DEB9;
	Sat,  3 Jan 2026 15:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IbMGk2WM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2744627F4F5
	for <kvm@vger.kernel.org>; Sat,  3 Jan 2026 15:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767452616; cv=none; b=oPIG3w7E7+ODdh/DDnRel5tieT+lAbFmuurdYsC9FgSx9T0Gsc/zPof0lvQNaAGRqatsO/csexXRbn72MamECZNt4NTF9lIWMS6hPgrLJX2gJC4XLV3axZYyOIXX+yTCmGPXW6Gf9D/g3bZoUUqoFfgR5z1kcpwPXzf45j9OpQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767452616; c=relaxed/simple;
	bh=UD317g59Ruo5i7WvP+3dFEC0ZPVLjpHv3T4AxT0MCpo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VSEPtjlw15sKxAF5EIbujRVU+RKR0yB7BuCsbCNOehHjJ0N5VYPF4H90ldicnaqtPi3uD0KXL9s5x8hN9h/Rk2tUKRWCh3OCMsycMfzhGwc0ETu3uEm6fA8Bqd0ML30w+lNgc/+ECTmEObOOZ/Zan+94CtgCwbqPhiiXBHXtDN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IbMGk2WM; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5ebe501b49dso2906087137.1
        for <kvm@vger.kernel.org>; Sat, 03 Jan 2026 07:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767452614; x=1768057414; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mwrVIBUzkZVqv+2p7KMwhr9VJcQGMPPRO78K+5XEw1A=;
        b=IbMGk2WMVdfyymlwomLwHJyePhfQ85lrwb+U5KNfeM9EtvKBJN2rBMpkPG8eumMsbJ
         3126yt/UjSE0F6xHTPZxIkKcNHtx7OwnUW2UaqY35EbLv5/3GdlWcx6DeOPe4GO9979P
         04bWu5XnIf8V2cN7IgVm5mYcTrZHtKGIp/QA/Lfb4ubD1splUs+ZRofOlcmZDw8DcSnH
         NDkhwonIfPDJjO4C4ln8mdRESclWlkJSNl1XuXurMx5WW/WLiN9Lsd6A3wkGeevwZ47Z
         Gai+rQmUrfAMqki1QD/7+pvi4tdZOXcFtxvPArCMxj4T4ASTJUuaEQPsaZSO9f52Kd+z
         LM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767452614; x=1768057414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mwrVIBUzkZVqv+2p7KMwhr9VJcQGMPPRO78K+5XEw1A=;
        b=H4vDjkVz9FTv8vHD5NWyWqRXmrIOViSR7YqbmKG44d6oZCFMy6HFxani1K5uBtg7Vl
         OJzU9bgyV817MfJjKytNfbi0/KtE14ix9LNZ+G9QoEazSL8w8KZd8G4JNBTBGMI0LSAj
         +9WY2sJ93/EGx6bW+/XFzFNlQ25dr7fYvxTFl3f5iXXLjZe+WReHlwRZhIS3erAmyJ6a
         VEtqHw0glu8V2wUiYdcZEygJv/XbKNaUDN5vySOmmsXHrL0JANyKOaKGiEiTVlR1KQS8
         xiNPSpaOL3SRMPpH1T+ZTKyW+cWoUjOlEMsKuHuRGuWXqcxVYptAv/DSWNWknan8jgpb
         70Qw==
X-Forwarded-Encrypted: i=1; AJvYcCXvGA+HHj0jq8zgTMKS8uZMTO2iQfB/fTM8wHezyLUvvfqb+Hh7ojseQXIf7fEHnilyJKg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz//27iOCbM9Xh2iwMnBFcW+TgD9jH367SNOsjYIJfiFvAdkRh+
	hNkEW1cs+vNTFMKofZbe0hbhI5GcJN87apjW5rDgPB6zrz4OUOazFTelcxleJjthMkUB/1yTKCP
	QQ/uzqLdSBop8n1S8kCY5mc+UCy9Upuw=
X-Gm-Gg: AY/fxX7zEoLD4D6FGSF7Tz7cfTy9DTLdJv0pElx0SgDNXWSDk5NBWobUs6rYrbWu/Qd
	HK6GpkQI9BpTv33hBLroGHCO6JdTiAXMGwg0wnyfJ+st1QwyLIcH+AcNXF0SryPPweEE5XgHKJL
	vCKC9vWaH5A3F24FOBSolDG5jxaNWMn33CH63AbI6u0v34H5SgRhvFClUJbGrzG0Uzxp7tAxnsy
	LOKoKmmuWFFIRSfL21TopR6VuiV5YZ4WSCmWUNWWMEaA6ngTtjIYPWjxwbvfQyavc8HYi+oflX3
	WPx+uRyjVdFpSnOjQuny7AOJSWpt5/+SIbwtjxQ8
X-Google-Smtp-Source: AGHT+IEe0TGbcVDQqYkKLDV2fz4CdCsKkxINqQGJz/SsAWdLoWUyDnC12Cf+IziDzjbrjZgNHmrLfFHz+90HMxyIiJs=
X-Received: by 2002:a05:6102:c47:b0:5df:aff3:c433 with SMTP id
 ada2fe7eead31-5eb1a699b01mr15138065137.16.1767452613476; Sat, 03 Jan 2026
 07:03:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260103094501.5625-1-naohiko.shimizu@gmail.com>
 <20260103094501.5625-2-naohiko.shimizu@gmail.com> <CAK9=C2XTi9Gjy0oJExGyaVvPbh2+cJzmeea5JnMR4d3kbvDJDA@mail.gmail.com>
In-Reply-To: <CAK9=C2XTi9Gjy0oJExGyaVvPbh2+cJzmeea5JnMR4d3kbvDJDA@mail.gmail.com>
From: Naohiko Shimizu <naohiko.shimizu@gmail.com>
Date: Sun, 4 Jan 2026 00:03:24 +0900
X-Gm-Features: AQt7F2qE5-G8e1VDYm3BBWvysOBQQbD6CjAauhjy-Wp1nfvQllESnaQ8TjIZqrU
Message-ID: <CAA7_YY-t2wWaqztey6Y3+eS8R=uvQnY6kT2h+vMzFAiZkGh4og@mail.gmail.com>
Subject: Re: [PATCH 1/3] riscv: clocksource: Fix stimecmp update hazard on RV32
To: Anup Patel <apatel@ventanamicro.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	anup@brainfault.org, atish.patra@linux.dev, daniel.lezcano@linaro.org, 
	tglx@linutronix.de, nick.hu@sifive.com, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Anup,

Thank you for your review.

I agree. I will update the commit description in v2 to explicitly cite
the RISC-V Privileged Specification and explain why the 3-step
programming sequence is necessary to avoid timer hazards on RV32.

Briefly, the current code writes the LSB first without ensuring it's
in the future, which can trigger a spurious interrupt if Time >=3D
{stimecmph(old), stimecmp(new)} becomes true momentarily. The new
sequence follows the spec's recommendation for mtimecmp (Section
3.2.1) to ensure the 64-bit value is always "in the future" during the
update.

I will apply the same detailed description to [PATCH 2/3] as well.

Regards, Naohiko Shimizu


On Sat, Jan 3, 2026 at 11:46=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> On Sat, Jan 3, 2026 at 3:16=E2=80=AFPM Naohiko Shimizu
> <naohiko.shimizu@gmail.com> wrote:
>
> Please add a detailed commit description about why the
> new way of programming stimecmp is better. Also, explain
> what the current Priv spec says in this context.
>
> >
> > Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>
> > ---
> >  drivers/clocksource/timer-riscv.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/ti=
mer-riscv.c
> > index 4d7cf338824a..cfc4d83c42c0 100644
> > --- a/drivers/clocksource/timer-riscv.c
> > +++ b/drivers/clocksource/timer-riscv.c
> > @@ -50,8 +50,9 @@ static int riscv_clock_next_event(unsigned long delta=
,
> >
> >         if (static_branch_likely(&riscv_sstc_available)) {
> >  #if defined(CONFIG_32BIT)
> > -               csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
> > +               csr_write(CSR_STIMECMP, ULONG_MAX);
> >                 csr_write(CSR_STIMECMPH, next_tval >> 32);
> > +               csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
> >  #else
> >                 csr_write(CSR_STIMECMP, next_tval);
> >  #endif
> > --
> > 2.39.5
> >
> >
>
> Regards,
> Anup

