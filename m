Return-Path: <kvm+bounces-41074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 073B9A6150B
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 16:35:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 013741655A1
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD990202C51;
	Fri, 14 Mar 2025 15:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wpwq+yes"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284681E5B8E
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 15:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741966403; cv=none; b=n/s/DB4RDEomwq/oX/9ZmzayZxz9R/8WCfuUqXc3PzQyvnLBebcZ7ZKpAu0EoFXyvGkPeCObwAJBNSr5DMnH9UnK/h+mQMwg3jvmbiqTt0+m1NO/cnQKyr3wjdgZA28hINOEDsZ02mZ8aDg6HGag33LK8NiNsHYUBQ5j4PzWnkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741966403; c=relaxed/simple;
	bh=/f2p3mVne0w65vJBsRvlHiSppBWtyePw6OccsVBcLdc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WAz58zLVlmPvWvLL3YKqba909VwbhBNMZFjSwZVF2SY1xjwymixsbBDcFITs/kP944gqhPSix6xbPHys2uojHUumxFI+8ltO278BDEe4K5qFxHB/CM2gwKtD8+WBRtW/zBDTd7t4lEDDTHublT6ZRW7eAPM7QCoZofm64KS6Xkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wpwq+yes; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e789411187so8996a12.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 08:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741966399; x=1742571199; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZkLdAwaa8FNMkQTBuDbjMAgl7BLJESMsVIBZknuir4=;
        b=wpwq+yesxd722wzuAFLZWuHqLmqJbtguuYQMkPenrdSJmbvnDD4FmdO/ecCSvIBDAW
         SeynUSAxKsyakCC81QIPFwm7bW9273ZspUor9GOebNmAsW/FV+SCAGCAQsEZLQxLqWPG
         nGj19nqCCyyW9qZlS8XCjl2hLuGa+pWvLPGNsSvRTgPxP3Dd5kebp+mLP8GMCeO1J0xP
         Emh9DwLzAwFdGPa5YIIT1g+L/DyBeElzdqAqUDpFeleCxoX4v3RWq17+Kv+rF5SCswYF
         aqCjJVZX1e+LgnJtLdUk38yUnNGNo4e0GoHDvzHr1BkgsFDeMTA4fdwmP/LQkKrrrGLk
         x3SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741966399; x=1742571199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KZkLdAwaa8FNMkQTBuDbjMAgl7BLJESMsVIBZknuir4=;
        b=LDWbmbY5Z5TYJWV/p2BlhSZoSzXMPvSvHranHYGv/3j3hnAnjv9BmNp0HwLim0khTr
         jgBltk/VhgC2A43LURS5BihvlnzgTjmT2FUzZk3cdMMwzlGMSiC4hZ6rCHrFBClWsJY/
         xCRkBPVc6YPN3zU8SGcFnpY6+uSDSUtLv7XTheTp6AiNkDrzfWRB6bqp63ayla5ntwBF
         Cy+C4g9vf5zRIUFpdlPyDzwpSoq6X/E01rzIKxAhG+7NPIpFJ1P76eAYSgjcGrCKpG59
         j73DUyh5q8M45SkWGL0IgD1tgzqHFMfrnqXoA0n2K4XRFdqcaRBYHsrpD3FNVn2Y/Sia
         4Seg==
X-Forwarded-Encrypted: i=1; AJvYcCUMB8kHhAymGu8b6v5CbSV546P8uiQsKV+BMcGhJO5FVfYQGRG+RIiOJmvWLQHB14V/O+o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJw45ILKYH21Efw3peUw5q6Mm3PC1tzDTeI9OfmJh+YqaZtzbx
	TzSQAo7oU6cqXJbDx0/U9GmPchHEYi+7eQfYyJt1ON3AbnCElZNJ5IAeGWSQhekqSkDSL7cLSX/
	7VsM3gNV9cF0ipMcpH0aGYwJRD02lENkM7Fl3
X-Gm-Gg: ASbGncunZY6ji6OluusceI7ykmFwj4jIlOiPgTkbR6krwmD2K3R/L6b6KhN022Uq2N/
	mPVkEbqNQmRV96Y9t++XdnuC5hhavjubEhiVdEULMprdfJMXhV6gKomhcXEuJR1ESY0UZCCq0k1
	USiKgVt5cCkEmKGOTHzzWWOVaevg==
X-Google-Smtp-Source: AGHT+IHgibR7ADqZA35lgaDS2RgZ8vFqR4FlGXDJh3YM+0ILrAchqkHslljrvId/LqcXOKRCV8qLaO1Lhi8GKR9+5qY=
X-Received: by 2002:aa7:c642:0:b0:5e4:afad:9a83 with SMTP id
 4fb4d7f45d1cf-5e8846f4a08mr112948a12.2.1741966399048; Fri, 14 Mar 2025
 08:33:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250225004708.1001320-1-jmattson@google.com> <CALMp9eRHrEZX4-JWyGXNRvafU2dNbfa6ZjT5HhrDBYujGYEvaw@mail.gmail.com>
 <Z9Q2Tl50AjxpwAKG@google.com> <2fd1f956-3c6c-4d96-ad16-7c8a6803120c@redhat.com>
In-Reply-To: <2fd1f956-3c6c-4d96-ad16-7c8a6803120c@redhat.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 14 Mar 2025 08:33:07 -0700
X-Gm-Features: AQ5f1Jp_7HH-kHyl_ZHpZdf2UgPE-gHIUbSENkLZMH8Wh8uKbOKB3H5Bw5MC98w
Message-ID: <CALMp9eRYvPJ5quwa7Dr1GgjPpmZVm+6TM_fkhA6KbVAdMsGH7g@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Provide a capability to disable APERF/MPERF
 read intercepts
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2025 at 8:07=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On 3/14/25 14:59, Sean Christopherson wrote:
> > On Thu, Mar 13, 2025, Jim Mattson wrote:
> >> On Mon, Feb 24, 2025 at 4:47=E2=80=AFPM Jim Mattson <jmattson@google.c=
om> wrote:
> >>>
> >>> Allow a guest to read the physical IA32_APERF and IA32_MPERF MSRs
> >>> without interception.
> >>>
> >>> The IA32_APERF and IA32_MPERF MSRs are not virtualized. Writes are no=
t
> >>> handled at all. The MSR values are not zeroed on vCPU creation, saved
> >>> on suspend, or restored on resume. No accommodation is made for
> >>> processor migration or for sharing a logical processor with other
> >>> tasks. No adjustments are made for non-unit TSC multipliers. The MSRs
> >>> do not account for time the same way as the comparable PMU events,
> >>> whether the PMU is virtualized by the traditional emulation method or
> >>> the new mediated pass-through approach.
> >>>
> >>> Nonetheless, in a properly constrained environment, this capability
> >>> can be combined with a guest CPUID table that advertises support for
> >>> CPUID.6:ECX.APERFMPERF[bit 0] to induce a Linux guest to report the
> >>> effective physical CPU frequency in /proc/cpuinfo. Moreover, there is
> >>> no performance cost for this capability.
> >>>
> >>> Signed-off-by: Jim Mattson <jmattson@google.com>
> >>> ---
> >
> > ...
> >
> >> Any thoughts?
> >
> > It's absolutely absurd, but I like it.  I would much rather provide fun=
ctionality
> > that is flawed in obvious ways, as opposed to functionality that is fla=
wed in
> > subtle and hard-to-grok ways.  Especially when the former is orders of =
magnitude
> > less complex.
> >
> > I have no objections, so long as we add very explicit disclaimers in th=
e docs.
> >
> > FWIW, the only reason my response was delayed is because I was trying t=
o figure
> > out if there's a clean way to avoid adding a large number of a capabili=
ties for
> > things like this.
>
> True but it's not even a capability, it's just a new bit in the existing
> KVM_CAP_X86_DISABLE_EXITS.
>
> Just one question:
>
> > -       u64 r =3D KVM_X86_DISABLE_EXITS_PAUSE;
> > +       u64 r =3D KVM_X86_DISABLE_EXITS_PAUSE | KVM_X86_DISABLE_EXITS_A=
PERFMPERF;
>
> Should it be conditional on the host having the APERFMPERF feature
> itself?  As is the patch _does_ do something sensible, i.e. #GP, but
> this puts the burden on userspace of checking the host CPUID and
> figuring out whether it makes sense to expose the feature to the guest.
> It would be simpler for userspace to be able to say "if the bit is there
> then enable it and make it visible through CPUID".

Good point. I'll take care of that in v2.

I feel like I am abandoning my principles with this patch, but as long
as you and Sean are on-board, I will do what needs to be done.

