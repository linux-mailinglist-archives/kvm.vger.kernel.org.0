Return-Path: <kvm+bounces-67161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DC570CFA128
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 19:20:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 64E3E309D7F2
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 18:17:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C429734CFB0;
	Tue,  6 Jan 2026 17:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i/v+mhsp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393AB1DF965
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722212; cv=pass; b=mzQywYfUgp/RXxhTcELv7ytj08vvtr0okfsMvoCBvSJUmoIBYFKI+yaHrt5Ez0HFLrvukBqjT4rU2Y+M1Zb3Y2h4Q0TtLgSP3G6g6WbsL9kR4Lhlgx8x6eAmNfxtei7MPvM0vBuSA95ILv343drFBFwyeuPqbHpA1aJq+bJaRiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722212; c=relaxed/simple;
	bh=b1EoNNjieLxcoSo0AfHltNs1toOanJO0lCrICvL08UU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gvgAYLJpd+zAcaIfLhzH56fc5R57WRQI1weD/nPj3bx08AkozqGV0TRwr2qsIGDx6OACZ4WPuGGdfMzTPGacQpyBodz5VR37KolqGJVbBaOMMXy9MnN/ax66Gm2PxAKmyGjUqnrE4J2EMYbHeolyV6bF7jZET/y82UvuGz+u1zg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i/v+mhsp; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6505d147ce4so431a12.0
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 09:56:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767722208; cv=none;
        d=google.com; s=arc-20240605;
        b=A5xbN2keq/8aBYDWetoF7sMDO0v5ve2sWoF67Mg65ZIQcdJzF/oDvLkdr4oRVmZPDU
         Tfqsdt9COcdPiScyR6/gxHM8+5mViHs1X9EBohVJ/5MKviIiQl8XTvwXdkhT3kFSUMcM
         qAYZGR6PBlrDTLyLuYR+YOtemQQJg5bF/EFsBIYJQY+gl8iImFdcyN3uxNKUUE8At+RD
         /AIOuZjqdIj1/dGiZ2q6qGduQhtEIQRvTgsXvP/wgnOsjd2EzZ6Vp3zFdfyLUgfOiR1u
         v0x75ZdSeQnnq/j21GVVi3DXyvyV+n3xk8/3NnihniM1KkzQr/OUIOyj/V+lsBJ8yxg3
         C4DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QYxpL+XnUS5UB2Ui7qcrOxbu+fTcZjWEGOnFGGJMq0w=;
        fh=w2sCn3WTPDX/dVG3dYZSPfz22+leD+WFIOnO6O58MA0=;
        b=FaHSL77rV1nXXX0ptJmlxK/CqljbTp76cJRMG20cdag17b7oaOjsKPgdI+lZ3xGzhe
         120LKaS8NE5ig8r36pMfSj24XqzK9nuUTN1jJyxkw6vqaKO5GvUwj0538rq5ylt9OnY9
         vxd42bYgNMSjoXY5Uckzq1LU+LxWpnjFY5HNzRryhAa9Z3a6v2PLg+WqMbgb5aMfUsni
         63vwm63KuQvu9zHXffqCVoMyT3Ep5LbrvP4m8Ayl5U08RwGLSH4OxhLUHVfAA/HTZRkq
         4aDyuGRzSDsK/F4N98+nk/KQJ4dXlCyXf+BqXp5v9XTn8WFmdFuIfCwJqifLymX6PCEd
         65+g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767722208; x=1768327008; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QYxpL+XnUS5UB2Ui7qcrOxbu+fTcZjWEGOnFGGJMq0w=;
        b=i/v+mhspmYYRWZL5UHeqx7uEVuojyOIHnb1Lhm3+loxCqyD+4+AoYnJNNGu8CR9jo9
         TbTlbcfmSEpX/LebGAQWybe0laWU6RH1NeLhrJWotkfjnP31pKxUbpq4EEOT8HYiX4or
         eXqJevgssbTiOO1n5Pjq/Q7IbiRcMMdU944HG4OaIrSLsT/zZ0NfivhmE6RM3HYfsfSV
         HtDYK2HRr/CfmNT70+8KIKbaa5xWL7DiHflmvw/3opCFxtTAXzaLSJ56CIYpxNfjGzBf
         seIHyOyZxJWug6UKDHbDp+llbV6S8l8aGKpge88tkUu3ygYRiQLzv4eCEaEZzGaH4b+w
         dS4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767722208; x=1768327008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QYxpL+XnUS5UB2Ui7qcrOxbu+fTcZjWEGOnFGGJMq0w=;
        b=eQ4B3R4ebHB4GhZAFYTMvs9IcEwKbYFGa+bfmaTc/hXDxOJuErawJYZfU9bzPuozZD
         xlUhl/nbbAa/ItbW1otg0xLb8wAMxgVFfPnT7ttxuB2qpGjpoBggbV4t+PCE61kp76IS
         QJBTIyGDRHyweNk9tqZg7TXX3TzRQQbibpO4j/GE5m5XadT3ZIVIUpLRRL3eGFT5I9C0
         2vx54gIYYiufivm83BqAUNwWEO0q0Li9qpCe2Uhqbm8htj55kMGmP+0ne6Z6R089hFD8
         WHuOSokYdSltmg1wkXJFxFKAtpD1Lkju1MNCzxmvg5aiR+QW7aVsrF2HpY+9cVK72JVi
         zdxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmdpKc2R+6YfsmSgl42cvcG6g0gTEF+40/6olunkZjovNzvVTS7Z+POeh22ZdhVje7O/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxnw5uHyXJgbuPrCCE4jejXc7G40O6CUuCsgOSj9sZVrduAooFU
	iS3BW7mr5z3IheSyz5pcj4zvR+cB9m3Mv3Cddg5Uxz9bFJWzovSJxVQv9phuuO+YbMyeSsCa8ko
	XH3LvtOBpPGQ+KIpcNJVjKeoDMJr5y9fDo9gT/b7HJuuzMnhqk6U+1ZVx
X-Gm-Gg: AY/fxX4Pm7pG8NFSHitJTP7qApp0Kb6yiUFYyuPXa64xdHNSYS27cBj9oRD44c9VOUF
	crrQ2jGnaurm+dwo+at6PQlflnLBekClRZkFaSL3YET6SPqOBvUVf6blwjWDy2H3TWuGMaOMq5z
	HPcZ8tJhIk0dz2jQpPOhXTnu2ZfGxosoy/GHsFoiTvB8C6w5u20BMt3sg5ZXjAbPslcdM7skWe7
	FZTtYTCrGGhbmlvFDKM8jHirek6lPzRGh3daL3V1E56ib9PR8m9NX3PKSx/u5MEutm2v44=
X-Google-Smtp-Source: AGHT+IHKi5u0ZUoIiLDKZvTW1fieJbK4f2Ck1yEd4b1rskSfipnf8lmsJb/sxIxC/QxMT48vm6QhJurThfZqBdXk6DI=
X-Received: by 2002:a05:6402:1811:b0:643:6975:537f with SMTP id
 4fb4d7f45d1cf-65080907a25mr39042a12.13.1767722208281; Tue, 06 Jan 2026
 09:56:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260101090516.316883-1-pbonzini@redhat.com> <20260101090516.316883-2-pbonzini@redhat.com>
 <CALMp9eSWwjZ83VQXRSD3ciwHmtaK5_i-941KdiAv9V9eU20B8g@mail.gmail.com> <aVxiowGbWNgY2cWD@google.com>
In-Reply-To: <aVxiowGbWNgY2cWD@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 6 Jan 2026 09:56:35 -0800
X-Gm-Features: AQt7F2ri3iKInZYTA5GeVwZP_koMuCHpRuMrgpaA7xmYZy37HUARMY0JidPig6w
Message-ID: <CALMp9eToT-af8kntKK2TiFHHUcUQgU25GaaNqq49RZZt2Buffg@mail.gmail.com>
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever XFD[i]=1
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 5:17=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, Jan 05, 2026, Jim Mattson wrote:
> > On Thu, Jan 1, 2026 at 1:13=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.c=
om> wrote:
> > >
> > > From: Sean Christopherson <seanjc@google.com>
> > > ...
> > > +       /*
> > > +        * KVM's guest ABI is that setting XFD[i]=3D1 *can* immediate=
ly revert
> > > +        * the save state to initialized.
> >
> > This comment suggests that an entry should be added to
> > Documentation/virt/kvm/x86/errata.rst.
>
> Hmm, I don't think it's necessary, the SDM (in a style more suited for th=
e APM,
> *sigh*), "recommends" that software not rely on state being maintained wh=
en disabled
> via XFD.
>
>   Before doing so, system software should first initialize AMX state (e.g=
., by
>   executing TILERELEASE); maintaining AMX state in a non-initialized stat=
e may
>   have negative power and performance implications and will prevent the e=
xecution
>   of In-Field Scan tests. In addition, software should not rely on the st=
ate of
>   the tile data after setting IA32_XFD[17] or IA32_XFD[18]; software shou=
ld always
>   reload or reinitialize the tile data after clearing IA32_XFD[17] and IA=
32_XFD[18].
>
>   System software should not use XFD to implement a =E2=80=9Clazy restore=
=E2=80=9D approach to
>   management of the TILEDATA state component. This approach will not oper=
ate correctly
>   for a variety of reasons. One is that the LDTILECFG and TILERELEASE ins=
tructions
>   initialize TILEDATA and do not cause an #NM exception. Another is that =
an execution
>   of XSAVE, XSAVEC, XSAVEOPT, or XSAVES by a user thread will save TILEDA=
TA as
>   initialized instead of the data expected by the user thread.
>
> I suppose that doesn't _quite_ say that the CPU is allowed to clobber sta=
te, but
> it's darn close.
>
> I'm definitely not opposed to officially documenting KVM's virtual CPU im=
plementation,
> but IMO calling it an erratum is a bit unfair.

Apologies. You're right. Though Intel is a bit coy, the only way to
interpret that section of the SDM is to conclude that the AMX state in
the CPU becomes undefined when XFD[18] is set.

