Return-Path: <kvm+bounces-53850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3DB5B18743
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 20:18:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64C9D3B1998
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 18:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC08288C37;
	Fri,  1 Aug 2025 18:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tYqCwjCG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD291B4F0E
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 18:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754072286; cv=none; b=NC9P5rIuASxumZG+3B65xELgHFczQfpiCKFoxIwSN9t14TRp7vf29Ak1kk43fGonCfIIee8VDfYx5x71jtrmihwwLAKe8juTyBrHs6mRwSelDQjHREovrpsQo1DKuQPT3K92ely2HIW1xalsUO90i+4ikpsugtePcAZAD3dqg34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754072286; c=relaxed/simple;
	bh=YL2B6gEXrJOvRYYui6bt3ppoA05sAipcf7SBVn38r3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W9woRrbTXN05KSy1qw1dscSWH9VB9CKKwBwBQuXHdNc8pnhG6l0cJ1jiN1AKQVCQZBFxCZWLI3w6k0Ny65yJH1YKRhXkiIOXiMeg88eP04jO6nEkwc5LPOVVwEqz7ilruuh4dVFVvG0fBGitgKcSa6s/umpm+Rc+p9w4p4VENi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tYqCwjCG; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3324e6a27a0so6544421fa.1
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 11:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754072283; x=1754677083; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HLBVWalAvcyfl5wmHOrCf7XYp2lIoIUMZMHifMzN82A=;
        b=tYqCwjCGT+7qjGYk1pjwQMHxd/57ASSoS0Flz0aVyxTqADN7jIWyBZ1CXzWt2NZFCS
         VgwWJXGutWigkYLvA734hhKAnD7Tw0wKk0sxw1aI6K7q6QUet2LYKdzVTSQApojdIXAL
         QR9wRScumVpU0Aj2EOIIQrzSfNOd9eCoKDIG1bc3N1h/tExg4dZBntT7s3JJq85fC5Ss
         OOgEDK3eCV1cjFomGiZ7jZ8m+IG+t+B7JamypUoH3r9YlSMUSfgNChRif7BSwjSzcfHJ
         5H632KIfrm274Fmy4k4SEMyIhLC68geZN4+tSLN/VDPGF95jUAeTxtLPKyX7eZMU9zTs
         Hfkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754072283; x=1754677083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HLBVWalAvcyfl5wmHOrCf7XYp2lIoIUMZMHifMzN82A=;
        b=iqIbT/vO4rZUFun7XcXgcVsn+g3msCyYw9EUfrnR9fTOxJzIMMmxgKeqEB2iMTAHwa
         ET8rCwd1kc0cXBq+hcY4TIqKjAsBKAw63FENutT4IUcbrZM5zjqYZBzgx/ceUzI1YuEN
         MlXf+/15cFfJMwQE4BkMVgJBoKLcLyKHrcrtZ7EsutIX7zAiganPZsCrLmJ0f4aBarb5
         H8gQqK+yE+8EaiDB52AGbqSQA9sCRBkJ85hhAIVnuKzgb1D+pQ8/7qMORd6MFg4lvwIP
         fp0Kns5CYgXkcAPjuGV3YEw/jPGlJtgIbd8pYr1UqBjJi/x/kzZuBLkxNKVOUBs4NQF1
         Yomg==
X-Forwarded-Encrypted: i=1; AJvYcCV2MMlkfsuBDQATESPMsXF3p9rmLWH8LW2jHnuOqBezfNlNmZ8YbKzc1Zgb/WoIltKOpo0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy51ylccd0GJRiWQvY1AeR5y8GhNeqBGqJcwPle9u/yns8KsN2j
	8REDnf1MaayIkld7z8/iVBcvJ236ZRYdaEm5EiO2nZ6C+RSBCyIv6tT39S8zbcLwITt4betvtSE
	GemlaLcDp2ezYaJfc1BDxQdjH7jdz4zPtxqfAbQFp
X-Gm-Gg: ASbGnctZRARKe775cHSm5E4AVOnr/Ugp+d6glEQp8dcohuaew5UCUxjDz6cKsSnvEWV
	xMAcz8P9hgm73PORbjjNcwNosOjDBWNvPjLraZshOIHi62iCzpw7WLqILUaloSkYEhxTuHpJoA1
	bWxExSY2xRzjut/JToscWd1+CUKTPqHE9q/MhLaHfTYD/IpzZF3IqaB+i6D6Gc6wfLKyouqcKuE
	/z++XU=
X-Google-Smtp-Source: AGHT+IGEfUaghABA5DNvg5gyW3d2855oZuYkBZv3LcxmE/vVGwOdccz+q+H6M6wVnet9p88MTN4WT+jz1gEyz4s2QSY=
X-Received: by 2002:a2e:b531:0:b0:332:133b:1513 with SMTP id
 38308e7fff4ca-33256796e05mr766051fa.30.1754072282670; Fri, 01 Aug 2025
 11:18:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
 <20250707224720.4016504-4-jthoughton@google.com> <aIFHc83PtfB9fkKB@google.com>
 <CADrL8HW46uQQKYUngYwomzfKWB0Vf4nG1WRjZu84hiXxtHN14Q@mail.gmail.com>
 <CALzav=e0cUTMzox7p3AU37wAFRrOXEDdU24eqe6DX+UZYt9FeQ@mail.gmail.com>
 <aIft7sUk_w8rV2DB@google.com> <CADrL8HWE+TQ8Vm1a=eb5ZKo2+zeeE-b8-PUXLOS0g5KuJ5kfZQ@mail.gmail.com>
In-Reply-To: <CADrL8HWE+TQ8Vm1a=eb5ZKo2+zeeE-b8-PUXLOS0g5KuJ5kfZQ@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 1 Aug 2025 11:17:34 -0700
X-Gm-Features: Ac12FXyG-livDFOfmfOOHNKjIHeLx2MQ0V7JxyxWoRrLh7_sfVekRt_nK9TcnqU
Message-ID: <CALzav=eQWJ-97T7YPt2ikFJ+hPqUSqQ+U_spq8M4vMaQWfasWQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] KVM: x86/mmu: Recover TDP MMU NX huge pages using
 MMU read lock
To: James Houghton <jthoughton@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 2:49=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> On Mon, Jul 28, 2025 at 2:38=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Mon, Jul 28, 2025, David Matlack wrote:
> > > On Mon, Jul 28, 2025 at 11:08=E2=80=AFAM James Houghton <jthoughton@g=
oogle.com> wrote:
> > > > On Wed, Jul 23, 2025 at 1:35=E2=80=AFPM Sean Christopherson <seanjc=
@google.com> wrote:
> > > > > > @@ -7559,8 +7590,17 @@ static void kvm_recover_nx_huge_pages(st=
ruct kvm *kvm,
> > > > > >       rcu_read_lock();
> > > > > >
> > > > > >       for ( ; to_zap; --to_zap) {
> > > > > > -             if (list_empty(nx_huge_pages))
> > > > > > +#ifdef CONFIG_X86_64
> > > > >
> > > > > These #ifdefs still make me sad, but I also still think they're t=
he least awful
> > > > > solution.  And hopefully we will jettison 32-bit sooner than late=
r :-)
> > > >
> > > > Yeah I couldn't come up with anything better. :(
> > >
> > > Could we just move the definition of tdp_mmu_pages_lock outside of
> > > CONFIG_X86_64? The only downside I can think of is slightly larger kv=
m
> > > structs for 32-bit builds.
> >
> > Hmm, I was going to say "no, because we'd also need to do spin_lock_ini=
t()", but
> > obviously spin_(un)lock() will only ever be invoked for 64-bit kernels.=
  I still
> > don't love the idea of making tdp_mmu_pages_lock visible outside of CON=
FIG_X86_64,
> > it feels like we're just asking to introduce (likely benign) bugs.
> >
> > Ugh, and I just noticed this as well:
> >
> >   #ifndef CONFIG_X86_64
> >   #define KVM_TDP_MMU -1
> >   #endif
> >
> > Rather than expose kvm->arch.tdp_mmu_pages_lock, what about using a sin=
gle #ifdef
> > section to bury both is_tdp_mmu and a local kvm->arch.tdp_mmu_pages_loc=
k pointer?
>
> SGTM.
>
> >
> > Alternatively, we could do:
> >
> >         const bool is_tdp_mmu =3D IS_ENABLED(CONFIG_X86_64) && mmu_type=
 !=3D KVM_SHADOW_MMU;
>
> I tried something like this before and it didn't work; my compiler
> still complained. Maybe I didn't do it quite right...
>
> >
> > to avoid referencing KVM_TDP_MMU, but that's quite ugly.  Overall, I th=
ink the
> > below strikes the best balance between polluting the code with #ifdefs,=
 and
> > generating robust code.
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 52bf6a886bfd..c038d7cd187d 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1372,10 +1372,6 @@ enum kvm_mmu_type {
> >         KVM_NR_MMU_TYPES,
> >  };
> >
> > -#ifndef CONFIG_X86_64
> > -#define KVM_TDP_MMU -1
> > -#endif
> > -
> >  struct kvm_arch {
> >         unsigned long n_used_mmu_pages;
> >         unsigned long n_requested_mmu_pages;
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index a6a1fb42b2d1..e2bde6a5e346 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -7624,8 +7624,14 @@ static bool kvm_mmu_sp_dirty_logging_enabled(str=
uct kvm *kvm,
> >  static void kvm_recover_nx_huge_pages(struct kvm *kvm,
> >                                       const enum kvm_mmu_type mmu_type)
> >  {
> > +#ifdef CONFIG_X86_64
> > +       const bool is_tdp_mmu =3D mmu_type =3D=3D KVM_TDP_MMU;
> > +       spinlock_t *tdp_mmu_pages_lock =3D &kvm->arch.tdp_mmu_pages_loc=
k;
> > +#else
> > +       const bool is_tdp_mmu =3D false;
> > +       spinlock_t *tdp_mmu_pages_lock =3D NULL;
> > +#endif
> >         unsigned long to_zap =3D nx_huge_pages_to_zap(kvm, mmu_type);
> > -       bool is_tdp_mmu =3D mmu_type =3D=3D KVM_TDP_MMU;
> >         struct list_head *nx_huge_pages;
> >         struct kvm_mmu_page *sp;
> >         LIST_HEAD(invalid_list);
> > @@ -7648,15 +7654,12 @@ static void kvm_recover_nx_huge_pages(struct kv=
m *kvm,
> >         rcu_read_lock();
> >
> >         for ( ; to_zap; --to_zap) {
> > -#ifdef CONFIG_X86_64
> >                 if (is_tdp_mmu)
> > -                       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > -#endif
> > +                       spin_lock(tdp_mmu_pages_lock);
> > +
> >                 if (list_empty(nx_huge_pages)) {
> > -#ifdef CONFIG_X86_64
> >                         if (is_tdp_mmu)
> > -                               spin_unlock(&kvm->arch.tdp_mmu_pages_lo=
ck);
> > -#endif
> > +                               spin_unlock(tdp_mmu_pages_lock);
> >                         break;
> >                 }
> >
> > @@ -7675,10 +7678,8 @@ static void kvm_recover_nx_huge_pages(struct kvm=
 *kvm,
> >
> >                 unaccount_nx_huge_page(kvm, sp);
> >
> > -#ifdef CONFIG_X86_64
> >                 if (is_tdp_mmu)
> > -                       spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > -#endif
> > +                       spin_unlock(tdp_mmu_pages_lock);
> >
> >                 /*
> >                  * Do not attempt to recover any NX Huge Pages that are=
 being
> > --
>
> LGTM! Thanks Sean.

Is the compiler not smart enough to optimize out
kvm->arch.tdp_mmu_pages_lock? (To avoid needing the extra local
variable?) I thought there was some other KVM code that relied on
similar optimizations but I would have to go dig them up to remember.

Either way, this LGTM!

