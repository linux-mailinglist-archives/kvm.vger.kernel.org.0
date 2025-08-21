Return-Path: <kvm+bounces-55259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6177B2EE34
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 08:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F7D9174333
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 06:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43DFD2E2289;
	Thu, 21 Aug 2025 06:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="D08Ubbdg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2592D47EE
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 06:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755757598; cv=none; b=OnhKyeyIrZDHgCz9nCNkhw15xDAqb668cm9+573lVh5sGW2qdIAQm8wNnW5QjsygzFo+I8UGCXsvcQIox6tMondfyXYRSEvI5Qf/FPx//m15IYtsIppvh8+hUiDBNIbOFK1UWsgziK0ViCotXDBMgi4aQ97xJAz/z6+wgPINALM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755757598; c=relaxed/simple;
	bh=Xr7oeQg2iR1u1golXvnoVAc2GNllf1OEPosZeEe0V6k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aqZEpd+LO1NbykBH0l5GJTo6CrirgFqppTjQx4LisL2lrSdJR7x6EGN0F2U+bLdInmLOiDscJnbOFJr4SzE1n/7usoyu8zX5BOwfcxglHt+9dlU7UfQL0hLPpkKksVJa4mQ/h+JJrT7a2rjcxFyqT2ftKS1rnSycDrTzmQ5Cbq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=D08Ubbdg; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-333f918d71eso4256111fa.3
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 23:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755757593; x=1756362393; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dvy5yQKV8vAz0HPfmKCuQpd8fq7qI9/IN8Rzy62sQac=;
        b=D08UbbdgV2CbehXqdupIrT7HL5abY6+SlW5cVLVmWxIQdaK3RAwj0T7Zb6ihXTidx3
         NKd2KKX+7BZAKit3xg8xEigYnc/ED6gsjUt711/R0RUr+gAFM+e62wCgwZzkk7kUFPsM
         6NjNsF/GYheQWN36jYTqn95z6g6m57XgK41qlOmMGBRxzwuGrg2GFyPsOugp42vr40c/
         U7d6egGRKo4zNILi5pwv+xuax9n/sqakHzpxFFHpF7o1tf2RhiyvDKjZPwzF9CgF5YvC
         xf2x9aWm5Q8gpeiJlYg8i2n1OrouFjFa7jbgTLMmQjIQiRyZ8G/iapx+HyfFyu+zO7ir
         fP2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755757593; x=1756362393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dvy5yQKV8vAz0HPfmKCuQpd8fq7qI9/IN8Rzy62sQac=;
        b=AbNHde3aCIfIB5YgCSj+DDMADTukGDRDIfnKY0jkKPV7HBWjBygYoDk6uNRhJsnOqT
         8mPvJnFY344TcwWTtQPukmrMj7/1Pjsyu0/b13D6FVIqgYar6T0MSB3jUxewXPeZK7SK
         FqOhF3M20drPCrB6FavAoWv05NH05TbCsVB4TVRpH0V7VLryVyWYmTQg4hBadQxkXTVK
         mqz7Bl+rpNKcQnSKsFPQIzpGLJlVsY3D5q6+SwDJIQPuJ5TzorAHcQDbMqibcb99KD5J
         cEi28LQjM08E7YSRghwMugHzI5mjK1Zq79zHOdkr/H19V5Ltc0AwkQCvLBbKtoSpINi4
         iMJg==
X-Forwarded-Encrypted: i=1; AJvYcCUYvb+pWelM1Wd4hGCEgOVO4FeVI/R0TPWCgZuIyNIzKqtyh39/X/By35jx+hcYs01Wh5I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBJPhgbq4WW9S6FVI0qbWGX4CwnH4XwyRsvK0CSDyy/e/xuCsJ
	YKiR/KGYJTl6coobbR1gc0jpFVDSAf6hKPqRMrqqrRIf9iZJMSH7FQCuZYxMooerjIRX9z2cnDs
	KUhtfIxU619cm+27BFES9XhHB1tAGplmRTJ0Q+sA2jg==
X-Gm-Gg: ASbGnctFB2IID4qiMhwKL0JwSSAMpPjao4jYE9TlEZC0VDrhLvs/ukJ6bjm/Glt52EQ
	Tv/8gv5t2lpgD/IHt8a4dzVprky3X7UttdvZs19g6JLm6Uz5LPp4hVKfzWZ9tzOiiGf4A0mTPB/
	f+jeBgx6jbwA7h1s8657EBj8WuvcXHRkH15bnxIJ3ApWMIM4wtImSuf6WN/j8cggYbUZsgGf5oO
	HgIzB05
X-Google-Smtp-Source: AGHT+IEmIpMzL2p0sePSaEQtsWGN7GzTW2rQrcL+IxbKSsSK5y/EXzsfv2bar47BDvSltEwnO/2h5O/l0DwBJFe20eA=
X-Received: by 2002:a05:651c:2352:20b0:333:b6b1:a151 with SMTP id
 38308e7fff4ca-33549e43bd1mr2751101fa.7.1755757593442; Wed, 20 Aug 2025
 23:26:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814155548.457172-1-apatel@ventanamicro.com>
 <DC5HEJRMZ84K.34OPU922A7XBE@ventanamicro.com> <CAK9=C2X8-DBi7qQ87kMA0AiVdiFH0_4L4mzzZzbeCg2eiNm8Qg@mail.gmail.com>
 <DC6DLP13J0LA.XW9J3XFBCM1Y@ventanamicro.com> <CAK9=C2VA2jswYm_yxYsCaGKUkJT46rxUH-6OKdsApMZ8nhkrQw@mail.gmail.com>
 <DC6L3PG5HP48.2J8TC1JZHMJVO@ventanamicro.com>
In-Reply-To: <DC6L3PG5HP48.2J8TC1JZHMJVO@ventanamicro.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Thu, 21 Aug 2025 11:56:21 +0530
X-Gm-Features: Ac12FXyapBEN33sNaasfC13xpNgk4ysy5dm8Jpk-um4MizahmUqGfRu3V32Rwxw
Message-ID: <CAK9=C2Uk-mL251XUVNtbU52KFuu+=sUR5-_=haAHmTACVDBQhA@mail.gmail.com>
Subject: Re: [PATCH 0/6] ONE_REG interface for SBI FWFT extension
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-riscv <linux-riscv-bounces@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 11:05=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcm=
ar@ventanamicro.com> wrote:
>
> 2025-08-19T21:22:27+05:30, Anup Patel <apatel@ventanamicro.com>:
> > On Tue, Aug 19, 2025 at 5:13=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rk=
rcmar@ventanamicro.com> wrote:
> >>
> >> 2025-08-19T12:00:43+05:30, Anup Patel <apatel@ventanamicro.com>:
> >> > On Mon, Aug 18, 2025 at 3:59=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 =
<rkrcmar@ventanamicro.com> wrote:
> >> >>
> >> >> 2025-08-14T21:25:42+05:30, Anup Patel <apatel@ventanamicro.com>:
> >> >> > This series adds ONE_REG interface for SBI FWFT extension impleme=
nted
> >> >> > by KVM RISC-V.
> >> >>
> >> >> I think it would be better to ONE_REG the CSRs (medeleg/menvcfg), o=
r at
> >> >> least expose their CSR fields (each sensible medeleg bit, PMM, ...)
> >> >> through kvm_riscv_config, than to couple this with SBI/FWFT.
> >> >>
> >> >> The controlled behavior is defined by the ISA, and userspace might =
want
> >> >> to configure the S-mode execution environment even when SBI/FWFT is=
 not
> >> >> present, which is not possible with the current design.
> >> >>
> >> >> Is there a benefit in expressing the ISA model through SBI/FWFT?
> >> >>
> >> >
> >> > Exposing medeleg/menvcfg is not the right approach because a
> >> > Guest/VM does not have M-mode hence it is not appropriate to
> >> > expose m<xyz> CSRs via ONE_REG interface. This also aligns
> >> > with H-extension architecture which does not virtualize M-mode.
> >>
> >> We already have mvendorid, marchid, and mipid in kvm_riscv_config.
> >
> > The mvendorid, marchid, and mipid are accessible via SBI BASE
> > extension but not any other M-mode CSRs hence these are special.
> >
> >>
> >> The virtualized M-mode is userspace+KVM.  (KVM doesn't allow userspace
> >> to configure most things now, but I think we'll have to change that wh=
en
> >> getting ready for production.)
> >
> > The RISC-V architecture is not designed to virtualize M-mode
> > and there is no practical use-case for virtualized M-mode hence
> > WE WON'T BE SUPPORTING IT IN KVM RISC-V.
>
> Oh, sorry for the misunderstanding, I'll be clearer next time and talk
> about implementation of the supervisor execution environment.
> KVM+userspace provides SEE to the VS-mode, which is to VS-mode as what
> M-mode is to S-mode, hence I called KVM+userspace a virtualized M-mode.
>
> > FYI, the KVM ARM64 does not virtualize EL3 either and it is
> > already in production so please stop making random arguments
> > for requiring virtualized M-mode for production.
>
> Yeah, I agree that we don't need it, I just had to provide so many
> examples in the previous discussion that I went into quite niche cases.
>
> The increased flexibility is similarly useful for more important cases:
> we can't avoid "virtualized M-mode"/SEE, but we don't have to completely
> implement it in HS-mode.
>
> >> For general virtualization, we want to be able to configure the
> >> following behavior for each exception that would go to the virtualized
> >> M-mode:
> >>   0) delegated to the guest
> >>   1) implemented by userspace
> >>   2-N) implementations by KVM (ideally zero or one)
> >>
> >> We can have medeleg, and another method to decide how to handle trappe=
d
> >> exceptions, but it probably makes more sense to have a per-exception
> >> ONE_REG that sets how each exception behaves.
> >>
> >
> > No pointing in discussing this further since we won't be supporting
> > virtualized M-mode.
>
> I understand, back to the current series:
>
> I think we need to provide means with which userspace can control which
> FWFT features are enabled, because KVM just exposes everything it know
> and hardware supports right now:
>  1) Migration between different systems would be hindered
>  2) We couldn't add more FWFT features without breaking the SEE

The FWFT features are defined to be backward compatible by SBI spec
and these features only affect after Guest/VM has configured them. This
means if a Guest/VM is not aware of SBI FWFT then it won't configure
FWFT features and Guest/VM should still work fine.

>
> The (2) is similar to how we must set ".default_disabled =3D true" to
> current FWFT, because KVM can't be changing the SEE for userspace.

Not needed. We only keep an SBI extension disabled by default if
it is being forwarded to KVM userspace (e.g. DBCN, SUSP) because
KVM userspace needs to opt-in for such SBI extension handling. In other
cases, the SBI extension is enabled by default and KVM userspace can
explicitly disable it for Guest/VM using ONE_REG interface. This is true
for ISA extensions as well.

>
> Do you want me to send a patch that inverts the default, to make all
> future SBI extension start as disabled, so we can't easily repeat the
> mistake in the future?

No need to send any patch. Please focus on your current assignments.

Regards,
Anup

