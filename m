Return-Path: <kvm+bounces-9270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70AAB85D03A
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:05:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A8651C21BF4
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 06:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BF9C39FF7;
	Wed, 21 Feb 2024 06:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KROK9+QF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BF039FC8
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 06:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708495542; cv=none; b=RuedwQM0mJct4p4e1+1XpPiq5PkHMBDOkDt/9h/738CYcKBrGyFPhamBZt7wzmjkFkbYwcSIDAUTHpyPKWSTY+YU2dA4bXeqoTINJCwJw1Rg55embq+XTxJ/9C+WeX+yn0pMZONcPrtI4OKHniDTwU89l1ddotmk2ImLLgUDyx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708495542; c=relaxed/simple;
	bh=qxqD9OboNB5MJTngrlpVRY1GfPED4n6/ANjl2SqXUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ofSa3XF8MOvDfEFw0TdozNN8Up/KR4uj2VbgxcRJo6zZRSyZe33zWIYET8LhHoLxoa3PHnXw3nH8wYVosoR4M5F1ch8Nb1Hm4z46F/ccW16ZDHmIstHDNMf+o6zi0VyZ55cJccY+KfnfEvJP9uftwDA8GOr0HHcDYCpBCJZP4jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=KROK9+QF; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d1094b5568so82612051fa.1
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 22:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708495539; x=1709100339; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O2Z3YPpifLO+v9LYFEzmiWXk2FbpYOnhII5xRfQ0SCw=;
        b=KROK9+QFr4w5Io8O+CQpjEiciECzpxBRVhsy9F9kyMzZunp/2NghN8c0MlQZR99kwM
         1iJDrwz3BbrklF26mY+1pGE5a74q2A4tlpaYp6EUieF67ztzcPWsIZ0H5AWhv+Eij3h3
         uHrAmkZaweklwySkRyEm/lgkQKHYXkChSVWAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708495539; x=1709100339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O2Z3YPpifLO+v9LYFEzmiWXk2FbpYOnhII5xRfQ0SCw=;
        b=q/J+11r+pxgyH772/SmAnBI6u9e6fYCdn8EZXHDO6LuaKhuq5J78SoMooUn89Bz54I
         A8QvLbbls8yGn8KSP7nUVVgjHYLXykLxaYON4BA0aa3/W8LhyWidy5CEJsjKUmFv2s5o
         5/d7/sJ8m772C4xiTMgWv6WvNb5rNW+hK0HlaWt1Ain8okZy5V+nb+wpBNeOxYYzxhRz
         Jkbm6vN/coTPkGpJGBRxC8/zw5OLPJa1/Vgzkpj9ScebLBIEslLePOmsW6B9suJe5Olj
         DaZR+Gc/Q+AAu/lMknlHpgJvaVFnkSe6esuvuTguJi5IBdfVNeba/d+JFlM2LzoJAq0M
         0guw==
X-Forwarded-Encrypted: i=1; AJvYcCWA/zMNpzOVOydXKiZDDT08THgxewH4BoMC85f1/Yhnku3D2vN1Hghxg3dUbRJLpoebpdF2zr1AxUi8uvrqirqt7j1k
X-Gm-Message-State: AOJu0Yy3gzEPDRU0zLlyQkZT5Z7zgFFwC+NJQwTW3lctbe15o6NgW2zO
	XELXeJ9JOgdu0XgRPLQNOKPHK11CXvD6/175rXAt9x2tMUxEaBDeQMoEQ1jpKKSUskcBGwRESlc
	8UHUC470cDufyeLYcsnVCVnTwIYdYeYepI5qjt09eTsL1TpA=
X-Google-Smtp-Source: AGHT+IHpzKQIyntrxNuQosyoWuA3YfqQc5Z/nsxyG5p3QePuUaVL24CuxlJrIlatb6/JHiziUwnqV6yOeBe5ljVDn0o=
X-Received: by 2002:a2e:9bd0:0:b0:2d2:3c9b:ab70 with SMTP id
 w16-20020a2e9bd0000000b002d23c9bab70mr4256464ljj.21.1708495539115; Tue, 20
 Feb 2024 22:05:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
 <ZUEPn_nIoE-gLspp@google.com> <CAD=HUj5g9BoziHT5SbbZ1oFKv75UuXoo32x8DC3TYgLGZ6G_Bw@mail.gmail.com>
 <ZYJFPoFYkp4xajRO@google.com> <ZcGn0t3l8OCL5mv6@google.com> <ZcrkhTn1Da5-vND2@google.com>
In-Reply-To: <ZcrkhTn1Da5-vND2@google.com>
From: David Stevens <stevensd@chromium.org>
Date: Wed, 21 Feb 2024 15:05:28 +0900
Message-ID: <CAD=HUj5fO9QCaMJhiJdzQsMPnVSRvM6T9RLYqE03_dEfzeQmtw@mail.gmail.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 13, 2024 at 12:39=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> On Mon, Feb 05, 2024, Sean Christopherson wrote:
> > On Tue, Dec 19, 2023, Sean Christopherson wrote:
> > > On Tue, Dec 12, 2023, David Stevens wrote:
> > > > On Tue, Oct 31, 2023 at 11:30=E2=80=AFPM Sean Christopherson <seanj=
c@google.com> wrote:
> > > > >
> > > > > On Tue, Oct 31, 2023, David Stevens wrote:
> > > > > > Sean, have you been waiting for a new patch series with respons=
es to
> > > > > > Maxim's comments? I'm not really familiar with kernel contribut=
ion
> > > > > > etiquette, but I was hoping to get your feedback before spendin=
g the
> > > > > > time to put together another patch series.
> > > > >
> > > > > No, I'm working my way back toward it.  The guest_memfd series to=
ok precedence
> > > > > over everything that I wasn't confident would land in 6.7, i.e. l=
arger series
> > > > > effectively got put on the back burner.  Sorry :-(
> > > >
> > > > Is this series something that may be able to make it into 6.8 or 6.=
9?
> > >
> > > 6.8 isn't realistic.  Between LPC, vacation, and non-upstream stuff, =
I've done
> > > frustratingly little code review since early November.  Sorry :-(
> > >
> > > I haven't paged this series back into memory, so take this with a gra=
in of salt,
> > > but IIRC there was nothing that would block this from landing in 6.9.=
  Timing will
> > > likely be tight though, especially for getting testing on all archite=
ctures.
> >
> > I did a quick-ish pass today.  If you can hold off on v10 until later t=
his week,
> > I'll try to take a more in-depth look by EOD Thursday.
>
> So I took a "deeper" look, but honestly it wasn't really any more in-dept=
h than
> the previous look.  I think I was somewhat surprised at the relatively sm=
all amount
> of churn this ended up requiring.
>
> Anywho, no major complaints.  This might be fodder for 6.9?  Maybe.  It'l=
l be
> tight.  At the very least though, I expect to shove v10 in a branch and s=
tart
> beating on it in anticipation of landing it no later than 6.10.
>
> One question though: what happened to the !FOLL_GET logic in kvm_follow_r=
efcounted_pfn()?
>
> In a previous version, I suggested:
>
>   static kvm_pfn_t kvm_follow_refcounted_pfn(struct kvm_follow_pfn *foll,
>                                              struct page *page)
>   {
>        kvm_pfn_t pfn =3D page_to_pfn(page);
>
>        foll->is_refcounted_page =3D true;
>
>        /*
>         * FIXME: Ideally, KVM wouldn't pass FOLL_GET to gup() when the ca=
ller
>         * doesn't want to grab a reference, but gup() doesn't support get=
ting
>         * just the pfn, i.e. FOLL_GET is effectively mandatory.  If that =
ever
>         * changes, drop this and simply don't pass FOLL_GET to gup().
>         */
>        if (!(foll->flags & FOLL_GET))
>                put_page(page);
>
>        return pfn;
>   }
>
> but in v9 it's simply:
>
>   static kvm_pfn_t kvm_follow_refcounted_pfn(struct kvm_follow_pfn *foll,
>                                              struct page *page)
>   {
>         kvm_pfn_t pfn =3D page_to_pfn(page);
>
>         foll->is_refcounted_page =3D true;
>         return pfn;
>   }
>
> And instead the x86 page fault handlers manually drop the reference.  Why=
 is that?

I don't think FOLL_GET adds much to the API if is_refcounted_page is
present. At least right now, all of the callers need to pay attention
to is_refcounted_page so that they can update the access/dirty flags
properly. If they already have to do that anyway, then it's not any
harder for them to call put_page(). Not taking a reference also adds
one more footgun to the API, since the caller needs to make sure it
only accesses the page under an appropriate lock (v7 of this series
had that bug).

That said, I don't have particularly strong feelings one way or the
other, so I've added it back to v10 of the series.

-David

