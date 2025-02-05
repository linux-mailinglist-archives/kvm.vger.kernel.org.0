Return-Path: <kvm+bounces-37296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54C7FA283F2
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 06:56:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24FBA1887745
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 05:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8A8221D8C;
	Wed,  5 Feb 2025 05:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XR+aFArH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C908021C180
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 05:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738734973; cv=none; b=ttMMdYeWdzCzWmqZp6T7CTWMvC+bSgoN1xLIWW7onulP/LxpSaLWuV6OUS6ZHsQ0qXYbP/JpkIMjZsmBlQzMnQYRNbOYGKRybRTx2hueekclH3SVivKSyoAeg6VxboCaeu5Ko6PfKN4bpKYY+1Gpn9xgtWH2T1OjeGCSb3dzyok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738734973; c=relaxed/simple;
	bh=3hsKS+IE/hLQEjmLSaE9iZPhj5c/VVA7iHDu6OHpeQk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P+SKIlrFGq8kHdMqTwISZy0OibEK5OCVoqIghxW26gZVqWnx6OzlVdtY+XyXD75++ptkE9SoflhZLW4su/Ah4kac4H6lcrGnwJ9npxuQOHeQdZMzixS2qmegibvz/px5gHOl5PLLhURQYbMlrpwpFfIitnUGkcqu2B5Dn+4CMjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XR+aFArH; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-46c7855df10so111495291cf.3
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 21:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738734970; x=1739339770; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g5AhHQDn0bEXPWxuXhngqzcoGAHY7aYnLb8oO1Oa7Jg=;
        b=XR+aFArHJIJnt5KlxCHLN9Rik3zF8D39NyY/NKCViCGOcEF7qzXsWGEN5Tho/W19Yx
         jUrclt+lkIBwylB8vDUGuR0zNCnwiUS+gQAn4s9XiukQsB4MPQ+MPlFTe3LDR4c5Ihqx
         Y9F1AAwsYierozDSOB+601oWUlt1KV/Ba1wRfFQgllNpx2uLCVINPFy8LrQ2MYPtsq6i
         kvw//miaj6PCZRq8FFO5p9cJ1eYG8B6YOzohm57CgROeUI4t+yVuR8P/zy1m0UWndRMK
         Ee+plawymhN6Xw6YcmcyLHTPp3I5BRp8T8PVUTG7ESp227buGnodt6oSewp5U36L2S4S
         shbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738734970; x=1739339770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g5AhHQDn0bEXPWxuXhngqzcoGAHY7aYnLb8oO1Oa7Jg=;
        b=Cl2Y13FZvZIDlmxdQH3rjhCLnlXV/nbZjuDHOEwOrpH8VDCfOoxCZpe61moqXLCFFi
         hGUzO6ArEYPrZlEfbnJz/r2UHdx3qcMgm14ubaUSNXf5J9AMPl8LdFTad2iNK6OLExtt
         9+6+EcA3gC/rh1fQV7jkTbHuaiOlBLBqPTMOLYieZMhlG2IWT+bhkYpVw9RCbzFcSB8Z
         kyCMRLN3Pue+aRqqZ6od/j03p1TvS1Rv0JtRODVJCaVUzXo5elvuI8F2sMR38TVOK174
         RfykPQVBmW03A1MmyqjWFEqQHaRcQ9omefgDF4ZRqGTi5+RKDG5ky8SNPvOWBpr4jhzq
         Rj+g==
X-Forwarded-Encrypted: i=1; AJvYcCUBI1kWk5CDCB9yPZl6ckm+FBkSqll7l+hj6d142FyHqeXzTz6SXqcXVjwIl8DmQUT4yI0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDvPLkblstYKUuPBfYc2JqodZ3G05vnWgDlCqZzBQUA1ZZjkB+
	7kJr1lGdJEBheaT7ArNsY5gVmf6+qPWYtIoZxX3w1YsAQ6LEmgds1rlZZoqmezatLew9fPhUhd8
	pwPBofII2I7H72t+C/qL+3oxSC3imjf0bTfvp
X-Gm-Gg: ASbGncu9uDzBeSHZk9BMRBtgpu9O6geh73KcB60lHqAaDMc4sVodSYlJypRWRKR9m9L
	ExIC5cPttI74XjSQ+K803q7Gkpt1dFRgriiuE1eqjUE0DJirg7u3oyjGcEiM5VxFQTdunwanxrA
	==
X-Google-Smtp-Source: AGHT+IEnCT9Mxk4s4jfw1y9cT85TuXzXUHUiyKxLJlAMjwWLzXhTqAw3kmVxz76CNIKiK82EUwGgwsJph8Vp3nTeE/o=
X-Received: by 2002:ac8:5a42:0:b0:46c:7150:ee81 with SMTP id
 d75a77b69052e-4702817b741mr21819121cf.3.1738734970461; Tue, 04 Feb 2025
 21:56:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-2-suleiman@google.com>
 <Z4gtb-Z2GpbEkAsQ@google.com> <CABCjUKDU4b5QodgT=tSgrV-fb_qnksmSxhMK3gNrUGsT9xeitg@mail.gmail.com>
 <Z4qK4B6taSoZTJMp@google.com> <CABCjUKDDDhXx8mSRKHCa34JjSX1nfM5WMG-UrPu9fjei6gkUJA@mail.gmail.com>
 <Z5AB-6bLRNLle27G@google.com> <CABCjUKB-4kvAg5U0D2O2aiTgfHnYx5qBTBEJJsK7edZY5g5eTQ@mail.gmail.com>
In-Reply-To: <CABCjUKB-4kvAg5U0D2O2aiTgfHnYx5qBTBEJJsK7edZY5g5eTQ@mail.gmail.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Wed, 5 Feb 2025 14:55:58 +0900
X-Gm-Features: AWEUYZmHpWzARyqXjryMn7VnU91wv7g1aqBNgfOFBosLD3QnjUDp0I1J232tgyU
Message-ID: <CABCjUKCDoHtLyX2CvrN+_D4N5ZiL2sLzyg+vY=LMkWZefrP_cA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] kvm: Introduce kvm_total_suspend_ns().
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 4:58=E2=80=AFPM Suleiman Souhlal <suleiman@google.co=
m> wrote:
>
> On Wed, Jan 22, 2025 at 5:22=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Tue, Jan 21, 2025, Suleiman Souhlal wrote:
> > > On Sat, Jan 18, 2025 at 1:52=E2=80=AFAM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > > In short, AFAICT the issues you are observing are mostly a problem =
with kvmclock.
> > > > Or maybe it's the other way around and effectively freezing guest T=
SC is super
> > > > problematic and fundamentally flawed.
> > > >
> > > > Regardless of which one is "broken", unconditionally accounting sus=
pend time to
> > > > steal_time will do the wrong thing when sched_clock=3Dtsc.  To furt=
her muddy the
> > > > waters, current Linux-as-a-guest on modern hardware will likely use=
 clocksource=3Dtsc,
> > > > but sched_clock=3Dkvmclock.  In that scenario, guest time doesn't a=
dvanced, but
> > > > guest scheduler time does.  Ugh.
> > > >
> > > > That particular wart can be avoided by having the guest use TSC for=
 sched_clock[*],
> > > > e.g. so that at least the behavior of time is consistent.
> > > >
> > > > Hmm, if freezing guest time across suspend is indeed problematic, o=
ne thought
> > > > would be to put the onus on the VMM/user to not advertise a "nonsto=
p TSC" if the
> > > > host may be suspending.  The Linux-as-a-guest would prefer kvmclock=
 over TSC for
> > > > both clocksource and sched_clock.
> > > >
> > > > [*] https://lore.kernel.org/all/Z4gqlbumOFPF_rxd@google.com
> > >
> > > I see what you're saying. Thanks for explaining.
> > >
> > > To complicate things further there are also different kinds of
> > > suspends. From what I've seen "shallow" (and/or "suspend-to-idle")
> > > suspends don't stop the CPU, at least on our machines, so the host TS=
C
> > > keeps ticking. On "deep" suspends, on the other hand, the TSC might g=
o
> > > backwards.
> >
> > Yeah, only S3 and lower will power down the CPU.  All bets are off if t=
he CPU
> > doesn't have a nonstop TSC, but that's not at all unique to suspend, e.=
g. it's a
> > problem if the CPU goes idle, and so I think it's safe to only worry ab=
out CPUs
> > with nonstop TSC.
> >
> > > But I suppose if the guest uses kvmclock the behavior should be the
> > > same in either case.
> > >
> > > At least for our use case we would definitely want guest *wall* time
> > > to keep advancing, so we would still want to use kvmclock.
> > >
> > > Would accounting the suspend duration in steal time be acceptable if
> > > it was conditional on the guest using kvmclock?
> > > We would need a way for the host to be notified that the guest is
> > > indeed using it,
> >
> > And not just using kvmclock, but specifically using for sched_clock.  E=
.g. the
> > current behavior for most Linux guests on modern hardware is that they'=
ll use TSC
> > for clocksource, but kvmclock for sched_clock and wall clock.
> >
> > > possibly by adding a new MSR to be written to in
> > > kvm_cs_enable().
> >
> > I don't think that's a good way forward.  I expect kvmclock to be large=
ly
> > deprecated (guest side) in favor of raw TSC (with hardware-provided sca=
le+offset),
> > at which point tying this to kvmclock puts us back at square one.
> >
> > Given that s2idle and standby don't reset host TSC, I think the right w=
ay to
> > handle this conundrum is to address the flaw that's noted in the "backw=
ards TSC"
> > logic, and adjust guest TSC to be fully up-to-date in the S3 (or lower)=
 case.
> >
> >          * ......................................  Unfortunately, we ca=
n't
> >          * bring the TSCs fully up to date with real time, as we aren't=
 yet far
> >          * enough into CPU bringup that we know how much real time has =
actually
> >          * elapsed; our helper function, ktime_get_boottime_ns() will b=
e using boot
> >          * variables that haven't been updated yet.
> >
> > I have no idea why commit 0dd6a6edb012 ("KVM: Dont mark TSC unstable du=
e to S4
> > suspend") hooked kvm_arch_enable_virtualization_cpu() instead of implem=
enting a
> > PM notifier, but I don't see anything that suggests it was deliberate, =
i.e. that
> > KVm *needs* to effectively snapshot guest TSC when onlining CPUs.
> >
> > If that wart is fixed, then both kvmclock and TSC will account host sus=
pend time,
> > and KVM can safely account the suspend time into steal time regardless =
of which
> > clock(s) the guest is using.
>
> I tried your suggestion of moving this to a PM notifier and I found
> that it's possible for VCPUs to run after resume but before the PM
> notifier has been called, because the resume notifiers get called
> after tasks are unfrozen. Unfortunately that means that if we were to
> do that, guest TSCs could go backwards.
>
> However, I think it should be possible to keep the existing backwards
> guest TSC prevention code but also use a notifier that further adjusts
> the guest TSCs to advance time on suspends where the TSC did go
> backwards. This would make both s2idle and deep suspends behave the
> same way.

An alternative might be to block VCPUs from newly entering the guest
between the pre and post suspend notifiers.
Otherwise, some of the steal time accounting would have to be done in
kvm_arch_enable_virtualization_cpu(), to make sure it gets applied on
the first VCPU run, in case that happens before the resume notifier
would have fired. But the comment there says we can't call
ktime_get_boottime_ns() there, so maybe that's not possible.

-- Suleiman

