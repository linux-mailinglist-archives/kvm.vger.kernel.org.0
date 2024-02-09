Return-Path: <kvm+bounces-8478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEF9784FCBB
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 20:21:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF22A1C23DA2
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 19:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E92983CB7;
	Fri,  9 Feb 2024 19:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Wl3N3mv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3887BB16
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 19:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707506450; cv=none; b=nYAdVKAgiAr7BW0T8d3PaPVy9WozCgXpcwb2ZjBLnBVsD2Q3cWA6HtwpRreIafvYt03JCQwonruJbSQoV/2AW5dhAkW3/7hxrsu+Y07vHowlGGskG6oda5Z8hUc9EclyLO+cDfJYIIDbeplYJZdJi0YH95gcTps4E/tQXXJfyLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707506450; c=relaxed/simple;
	bh=RMUeTIdrpjvqLvRywC3xhAkIf7wdZECwCEXb1rHQiBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R/O3WX/qqELL3nvF+yxgcvOra2KkRu0y1qmyAY9fEyyTBmMaavQ0pLjKmgwHkV9UluV6Q/VzomZlBXjd9iEWGSAeg4+W4sJtsq3yG6tyEfmMATEhs5O2kprO96dYTmt46vwurXDyhuO25kgmrJBWwa5+IhD14mFzwO66ma9ds0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Wl3N3mv; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40fe59b22dbso10370645e9.3
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 11:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707506447; x=1708111247; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sKc43LnuruE4C4gTj1SBUB4Fdvh7DqI2CHhYP6wkvVw=;
        b=0Wl3N3mvxvWZAyGwWlWHkOB2+o92YmmRKaRDhW/LaUnWcupROsZiDwUvgb3wku/DTD
         YOwS8dFLmCquwltT0T9OFWCz2ydOn+E/n5jQbWIsTYcW2myVpPwcjtKKvPrFIYpdUr2g
         DNpSlq1mHeiiyAOSSOQUwnzm//0v9SP5ojLYRskpnoEwlg6HBDEPwT4klHWvtChy4pL7
         8kSvHYRhBv3zxCt46ev0y29gb955/fa9VdAghRFk9dtCpckFpgdPgKDmH6UWFr6ZkeW7
         6eoaHzq/Yn2oYaOEfAh3zgC7XpMOurpuoVBGwJ/3A4DaXm2pUHSWIaRZNNOy/7Vv8osc
         DJnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707506447; x=1708111247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sKc43LnuruE4C4gTj1SBUB4Fdvh7DqI2CHhYP6wkvVw=;
        b=uX45OJAVhajFPiBsnF0WKZ/aSYHIeR7jS7tD2fuKPLbtUoSfKoz7yVeVKDjhfLrjGe
         +JU+jysZuMfRVYAT/uH4pY2g0KVxDH/GP8xfLEXjwUyioyheUn31cKgM2E1Oh+/iHNSk
         vzJt24iv3P8Chqne8kwGh8Ynoz/xqj+I0oX+bmYjgTfka4rS6viiWT6wOew1eAbruSBS
         wrdNdZAV4iGIgfRIu3811RiSh7AMoL97aThy4BgYzKmuO0XPToOaNw/V1TJ8mZhvqDA6
         rvP0hLqDN0zpEnqtEOCukC1giABhjHHM47QhXUMf9mOZPDG/Um68HUwMth85XbIfgS55
         NGcA==
X-Gm-Message-State: AOJu0Yw8Cl1sWUoEInKsB2zxrYr2Ln1Tv1i3Kfk/m7leRkaRh3UOQRgO
	EVKPhHpEE26AYawVUdgb0Y+eOu65Tv+a2dnyMQNfg87EALy9a/IoGpkgws+ZC0QrUkufV7ftg4M
	fZ6FdmKBzfDFqjq7RobJX67aYL2TJLika6gmb
X-Google-Smtp-Source: AGHT+IHwTSDT+MnzDoA8cyrgvtFd1tKeYUR9vJ0xnKAtFsUjgBYL1mvbM+dKH2OxpQQSIHliCiPivf2zfPShytqxp/g=
X-Received: by 2002:a05:6000:1250:b0:33b:1577:a2d1 with SMTP id
 j16-20020a056000125000b0033b1577a2d1mr1835327wrx.1.1707506446818; Fri, 09 Feb
 2024 11:20:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240208220604.140859-1-seanjc@google.com> <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com> <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
 <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
In-Reply-To: <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 9 Feb 2024 11:20:35 -0800
Message-ID: <CAKwvOdk5E=vu8RNOOsJmTu2ioTYhiqZ=xSj-4YwkKhH8d4wb7A@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sean Christopherson <seanjc@google.com>, "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 9, 2024 at 11:01=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, 9 Feb 2024 at 10:55, Nick Desaulniers <ndesaulniers@google.com> w=
rote:
> >
> > And also pessimizes all asm gotos (for gcc) including ones that don't
> > contain output as described in 43c249ea0b1e.  The version checks would
> > at least not pessimize those.
>
> Yeah, no, we should limit that workaround only to the asm goto with
> outputs case.
>
> We should also probably get rid of the existing "asm_volatile_goto()"
> macro name entirely. That name was always pretty horrific, in that it
> didn't even mark the asm as volatile even in the case where it did
> anything.

+1.

43c249ea0b1e could have done so, but I'm guessing "tree wide changes
in Linux are not fun" was perhaps the reason it wasn't done so then.

I also think folks are too aggressive putting volatile on asm
statements that might not need them; it's definitely less cognitive
burden to just always put `volatile` on inline asm but I suspect
that's leaving some performance on the floor in certain cases.  (I had
a patch to clang to warn when the volatile was unnecessary in cases
where it was explicit, but that was shot down in code review as being
harassing to users).

>
> So the name of that macro made little sense, and the new workaround
> should be only for asm goto with outputs. So I'd suggest jmaking a new
> macro with that name:
>
>    #define asm_goto_output(x...)
>
> and on gcc use that old workaround, and on clang just make it be a
> plain "asm goto".
>
> Hmm?

Thinking through the tradeoffs, the Kconfig approach would pessimize
GCC versions with the "lack of implicit volatile" bug to not use asm
goto w/ outputs at all.

Having a new macro would just make the `volatile` qualifier explicit,
which is a no-op on gcc versions that don't contain the bug (while
allowing them to use asm goto with outputs, which is probably better
for codegen).

So I agree a new macro seems better than disabling things for kconfig.
(Assuming the only issue is the need to make `volatile` explicit for a
few GCC versions; it's not clear to me from Sean's latest response if
there's more than one bug here).  I'm not signing up to shave either
yak though.
--=20
Thanks,
~Nick Desaulniers

