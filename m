Return-Path: <kvm+bounces-34737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6162A051D7
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 05:05:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA6041674CA
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 04:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B3419F133;
	Wed,  8 Jan 2025 04:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4M9WIG6q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0353314F104
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 04:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736309144; cv=none; b=oferB3cvA7m2hyBt9An9JTi9ZHfZIo+iXsU5DluBXNaUmp9lqWNffLh5eJJR4JUu0NkQJevPGnSTqn3AVhS37uFDQT1s7oxzXUnPLSssjX2O5mbcY//KI7FCtTXdWe6W0+Anw9mikEjCDAlFnwuf9lvZ/VQLYCc/bYvi12a9v9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736309144; c=relaxed/simple;
	bh=mpQLt5uxYirJAEt2CEVpWpsLadQt4yKSwY3j6GYU5eI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IbQhrdIbezl3IlGIrikPFaqnitxaNCZm3EQKEU4xnW3Vfa4wpP9sR+qTCAfXJQZId+Bj8xJZfh+t+6WiSUKpilNv3r/tlQ+URy0LmKkSSQaO8ujuoFif9yEMu5NJCGy56yiUlh9eS+gsvor+wdQuLyUWGSsSqfR+nFGttyjA0w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4M9WIG6q; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-46772a0f8fbso144096141cf.3
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2025 20:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736309141; x=1736913941; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pM8xDErTreDeJZbsmdXBMvFzPyxR2tjeUJEvtP0rfcE=;
        b=4M9WIG6qp7V0UryPoFQfJ7HvYGJxjyLNK24D4DuDt7Jj+YwhBMoxMKEb5m1KujB/gR
         1QPjYLYGMckXReBRXcvCbfa2OOTas/kHNcECqWzxGd7a98IFvDUxtg6AqT3rc3q9caau
         p1IVK4495umyG6JfOEah1Jv+xE8RB7iWG5jIg705GPTLbUam9JPshvSoHAKEs9CR8Ccs
         BsD3GPpMbPinPwM3iOAe3Kd9vAWmP9Q18QThznld/jYvJMivLzZrcH4UPcXBjFOm1Fl0
         N9sxoMz0j8Ai846VMuCPE1rS5gTe0BwWnQbEHAJUxnM2iS3qW02tISzIG3AVvluRqXS5
         bgvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736309141; x=1736913941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pM8xDErTreDeJZbsmdXBMvFzPyxR2tjeUJEvtP0rfcE=;
        b=Vl5WvFv+KhdiplbWeAJ+mwCqLyxcXnjPpJC7Zl0FoDD/M3X+qvLxEPwyX0YSYTblLB
         sWvU3S79jpLrafdGRSNiURTRZWXRi6KiUe7Yx5V/gYFXH5wcPb3QsALMsbJlJewedSiJ
         QACk0vL1aEuaqxSiHHIXquLUEUjetYEmOi73uJbCf+82PxpCeLoC1XXuAYxADNFarIvw
         74hCGcFwm1UXEkgr2DlhkC24PlbacOqBl71u1tA6R/qANP3PysdpjWzhnP1RF19dqvLX
         xXwSOp8Qs4E/6K3mLiusSKe/ZegMCU6jkmNlbO/UyJlDgpi1EvpJI4SfeD3ma9wTw6wc
         czqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkxU7Mz/dwNnGryMNwwSMxcJI7+/JVrM1TEzRkr4dET0xVikhpCu5aGKAWTA3y81Emwoc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNUhhtPqTfc4m32yPEh80NYI4gOfRAxFBIEiJnGJyQLy/QxuY/
	jIGDY5PVL11nWE65K2wTCtAZXTNsD6HS2eXjXnh4Mo3plYjtpZcSZe1DwsbJdSmmYvQD6kwgIWu
	yfd/I9AACmFyMjlv6H/8Rx++2ceGtYa7RxYSH
X-Gm-Gg: ASbGnctUIPStTWg1VSYy/F7/Q4Ig/c45GzU4VCKDosocY8FXdGBY+A2U9WwhHiSI3fE
	v2PQ37mgcP4MOlq6nfpYSBwkbelogyhpWJJ1+/jN2o4oSds9cFsCrvH2j1gcLxNH2DjfK
X-Google-Smtp-Source: AGHT+IEcc50YB1Vs4g7ghyMk1h2HQ5454hcP8QO99ExL1jOf9Rrf9am1qkg6/fjUZkIyE0HAfB2XXVy7rav6IZ4zQqA=
X-Received: by 2002:a05:622a:19a2:b0:466:96ef:90c with SMTP id
 d75a77b69052e-46c710871ccmr24083311cf.41.1736309140554; Tue, 07 Jan 2025
 20:05:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-3-suleiman@google.com>
 <Z31KK-9Z_b-UleVT@google.com>
In-Reply-To: <Z31KK-9Z_b-UleVT@google.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Wed, 8 Jan 2025 13:05:29 +0900
X-Gm-Features: AbW1kvb6r_3xYo2TwOCdwSKu5RyI0uAvZCoWiDHeh-2IcCW190kdvTR5r3D_kzo
Message-ID: <CABCjUKB-pzcY-XFzpBQ6mRi-LiPJ7exAwr+RQXR-pD+P0cxrYA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: Include host suspended time in steal time.
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 12:37=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Jan 07, 2025, Suleiman Souhlal wrote:
> > When the host resumes from a suspend, the guest thinks any task
> > that was running during the suspend ran for a long time, even though
> > the effective run time was much shorter, which can end up having
> > negative effects with scheduling. This can be particularly noticeable
> > if the guest task was RT, as it can end up getting throttled for a
> > long time.
> >
> > To mitigate this issue, we include the time that the host was
>
> No "we".
>
> > suspended in steal time, which lets the guest can subtract the
> > duration from the tasks' runtime.
> >
> > Note that the case of a suspend happening during a VM migration
> > might not be accounted.
>
> And this isn't considered a bug because?  I asked for documentation, not =
a
> statement of fact.

I guess I don't really understand what the difference between
documentation and statements of fact is.

It's not completely clear to me what the desired behavior would be
when suspending during a VM migration.
If we wanted to inject the suspend duration that happened after the
migration started, but before it ended, I suppose we would need to add
a way for the new VM instance to add to steal time, possibly through a
new uAPI.

It is also not clear to me why we would want that.

>
> > Change-Id: I18d1d17d4d0d6f4c89b312e427036e052c47e1fa
>
> gerrit.
>
> > Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/x86.c              | 11 ++++++++++-
> >  2 files changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index e159e44a6a1b61..01d44d527a7f88 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -897,6 +897,7 @@ struct kvm_vcpu_arch {
> >               u8 preempted;
> >               u64 msr_val;
> >               u64 last_steal;
> > +             u64 last_suspend_ns;
> >               struct gfn_to_hva_cache cache;
> >       } st;
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index c8160baf383851..12439edc36f83a 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3650,7 +3650,7 @@ static void record_steal_time(struct kvm_vcpu *vc=
pu)
> >       struct kvm_steal_time __user *st;
> >       struct kvm_memslots *slots;
> >       gpa_t gpa =3D vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
> > -     u64 steal;
> > +     u64 steal, suspend_ns;
> >       u32 version;
> >
> >       if (kvm_xen_msr_enabled(vcpu->kvm)) {
> > @@ -3677,6 +3677,7 @@ static void record_steal_time(struct kvm_vcpu *vc=
pu)
> >                       return;
> >       }
> >
> > +     suspend_ns =3D kvm_total_suspend_ns();
> >       st =3D (struct kvm_steal_time __user *)ghc->hva;
> >       /*
> >        * Doing a TLB flush here, on the guest's behalf, can avoid
> > @@ -3731,6 +3732,13 @@ static void record_steal_time(struct kvm_vcpu *v=
cpu)
> >       steal +=3D current->sched_info.run_delay -
> >               vcpu->arch.st.last_steal;
> >       vcpu->arch.st.last_steal =3D current->sched_info.run_delay;
> > +     /*
> > +      * Include the time that the host was suspended in steal time.
> > +      * Note that the case of a suspend happening during a VM migratio=
n
> > +      * might not be accounted.
> > +      */
>
> This is not a useful comment.  It's quite clear what that suspend time is=
 being
> accumulated into steal_time, and restating the migration caveat does more=
 harm
> than good, as that flaw is an issue with the overall design, i.e. has not=
hing to
> do with this specific snippet of code.

I will remove it.

Thanks,
-- Suleiman

