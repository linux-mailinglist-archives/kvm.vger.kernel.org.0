Return-Path: <kvm+bounces-36289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1DC7A19865
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 19:25:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B53A47A025D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 18:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CC5C2153F5;
	Wed, 22 Jan 2025 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BLErSSFb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6632153D5
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 18:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737570288; cv=none; b=iy7MBlzEyAQdd1wDNeB4k1K9//g5SlXtfc7jMkvmDcBD7vRG3NnUyndPwI/2utzBq4b2W1PG24hndeBMrOfeHx9rr3Fzgsu2GjkWsyJemqWqSS0XXAAJ9Ha2SMoH7MSXCYL6QZw3Yw61QrAi34qBhY1WvEHoeD8c8pQ2rPFjUXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737570288; c=relaxed/simple;
	bh=fDTckeX/CL1zTNJjaNBfkhP3uZYpCCy33GaBAfaxNeQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sCSJEmFuk6S1N1v1LmtxX01DGmNiW0IA1YTxIkHJWkeGIFHXWr5ptitFjTroFfbe766Bz4Sw5JIhAJSF5ZyRi6XmI2aFQvPIeFy+LtHbPNv9geHxrDO0TnH/w4+PBwy0wGogKiv1SIRa1JIt36JjjRfNDCc25CZ/WvoowOns8zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BLErSSFb; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aaecf50578eso18367366b.2
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 10:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737570285; x=1738175085; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eBcKF3WDi7cpZRdTQuhnil5npY1ucs6/K2dTpV5cSVE=;
        b=BLErSSFbPZZ6xCrWp9hndASC+bMF50+ly5JNCoW7tq4TogkuldVqM3QBuzJJJs0fxT
         JtS8WzmauHHbE3rEPA0pe9cJGpDEsiBOoRE/Jog9/3Er1XN8SDJ3gyVQSklyJtAPjdXL
         /Hv1cTnXEA95B0H4pW/amvEUj1orC0hb5ll2jNTJkcEtxsufID4MMBrtmM0w5vsJwR/j
         xEPUb119HtfCOkCb5cgjpRav9HBctZmq50eD7twjmu5mwsb2SJMI5X+riSa9OfqqXANO
         wCocZD/vHKtZtQoj5la84XRnhI+iiod2tOz00JFRwC5p1VVs5nLiy38cVa9prmNrvgA5
         /uOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737570285; x=1738175085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eBcKF3WDi7cpZRdTQuhnil5npY1ucs6/K2dTpV5cSVE=;
        b=GrwiGYJSF9YNgvvTJvYBMoh23CNjx1inwZdVf8o59gPMPzUctg7vTfPe8+QO/KRCZ7
         3xGKsmQrjWpw9GhZhhUZdrzI5U6AFRQMaamGrircRgJ/jQZJbu1yDA4QLczvvlNk5QZ0
         Bn101fpq+tj8gMxSQRl+sdz16l3Vf/vtlhoJZHDldbVHfPqQK7UQO8gspyTnCI7s9zoF
         QTSQaTZ57c7uhVpUabhoTJJwA+A8dQL6nSp0hU5aFHO2engbgRTMRPpM/77QUuIaXf5D
         1zZes1rwEYmoonMSAxHhSkRrKTWYOOc4AM6GCaUPP+ZUKPuhlU8WsbzpcQc8fbOMyfrr
         gwqA==
X-Forwarded-Encrypted: i=1; AJvYcCUHLPJeftoc5EILlwkzSXnLCrhRTKKCUt40i/6oYP2t6BmNSV5oOoVHJ5v3/NEYZmpiGjY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLNTRNToVur4QuE7br1pZ+ptYXSFnm8TFAVxhpuXaXl3iu27Rk
	i6ePFpJntfIi06QDozkayDMwyJDAgt8dk9vyfYcAbP8fIFeLZViPUkSiKx3nsmmVymsPg1MI+hR
	nfkGzo5F+vX9h+Y9KSCWicU1C40ebelEaMhw=
X-Gm-Gg: ASbGncs8hqIPFbrI9e4ecmHl1nvdZBP34+ljYzZvifZgwsNrdvK/MFjOatSct4qsget
	TxPsxRaSJyfKt9R99b0lSvq71BPpifgc5vGMId60r4AFFy/6hgn2u/WK48QjejIi9bebyFDPrz9
	ys/2ts
X-Google-Smtp-Source: AGHT+IEzUkcgan8AwVnGF8RuNwIIoZjQ+k7oV6MdkuH4bMn2lkY/6rWxDiDg2qfigx4q6lH7C/ouueU9mIoooOIfDtk=
X-Received: by 2002:a17:907:3e8f:b0:aae:85a9:e2d with SMTP id
 a640c23a62f3a-ab38b381397mr2159854566b.45.1737570285188; Wed, 22 Jan 2025
 10:24:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANDhNCq5_F3HfFYABqFGCA1bPd_+xgNj-iDQhH4tDk+wi8iZZg@mail.gmail.com>
 <CABgObfbWqcorZC+1Hjh7SQtn69LE-Wng-wBKOq=tqh00_3R6dw@mail.gmail.com> <CALMp9eTcsDcnm2cqWW-tjLJEXb5PeoLUr-Pk=0oOH=_3oowREg@mail.gmail.com>
In-Reply-To: <CALMp9eTcsDcnm2cqWW-tjLJEXb5PeoLUr-Pk=0oOH=_3oowREg@mail.gmail.com>
From: John Stultz <jstultz@google.com>
Date: Wed, 22 Jan 2025 10:24:33 -0800
X-Gm-Features: AbW1kvY3nFcAyHPkFYzrkMdO4P5yXrTKK6bHtoX_Slr6GUVI7h-ZNIgi-Lw_rfQ
Message-ID: <CANDhNCoFQXAGT9D=oRefjmAEU=LFVa4Y8-0+peJwiSMf1DuyeA@mail.gmail.com>
Subject: Re: BUG: Occasional unexpected DR6 value seen with nested
 virtualization on x86
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, kvm <kvm@vger.kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Frederic Weisbecker <fweisbec@gmail.com>, 
	Andy Lutomirski <luto@kernel.org>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, 
	"Team, Android" <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025 at 8:56=E2=80=AFAM Jim Mattson <jmattson@google.com> w=
rote:
>
> On Wed, Jan 22, 2025 at 1:01=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.co=
m> wrote:
> >
> > Il mer 22 gen 2025, 07:07 John Stultz <jstultz@google.com> ha scritto:
> > >
> > > I then cut down and ported the bionic test out so it could build unde=
r
> > > a standard debian environment:
> > > https://github.com/johnstultz-work/bionic-ptrace-reproducer
> > >
> > > Where I was able to reproduce the same problem in a debian VM (after
> > > running the test in a loop for a short while).
> >
> >
> > Thanks, that's nice to have.
> >
> > > Now, here's where it is odd. I could *not* reproduce the problem on
> > > bare metal hardware, *nor* could I reproduce the problem in a virtual
> > > environment.  I can *only* reproduce the problem with nested
> > > virtualization (running the VM inside a VM).
> >
> > Typically in that case the best thing to do is turn it into a
> > kvm-unit-test or selftest (though that's often an endeavor of its own,
> > as it requires distilling the Linux kernel and userspace code into a
> > guest that runs without an OS). But what you've done is already a good
> > step.
>
> Just run the kvm-unit-tests 'x86/debug' test in a loop inside an L1
> VM. It will eventually fail. Maybe not the same bug, but we can hope.
> :)

Thanks Jim,

I've just reproduced this as well, after running the debug test in a
loop.  The one odd bit is that it's not always the same subtest that
fails.

I've seen:
FAIL: Single-step #DB w/ STI blocking
FAIL: Usermode Single-step #DB w/ STI blocking
FAIL: Single-step #DB on emulated instructions
FAIL: Single-step #DB w/ MOVSS blocking
FAIL: Usermode Single-step #DB basic test
FAIL: Single-step #DB w/ MOVSS blocking and DR7.GD=3D1
FAIL: hw breakpoint (test that dr6.BS is not cleared)

So yeah, hopefully all the same bug? :)

thanks
-john

