Return-Path: <kvm+bounces-34693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 337C8A046EC
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 17:45:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DCA716596B
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 16:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2CF1F4283;
	Tue,  7 Jan 2025 16:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kRRSPS9o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0306B1F0E3C
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 16:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736268231; cv=none; b=temjOfW2llyYktA3PHk877naowRadBEEMsW4+dlxdzQ2LL5GEo3tt79nQlAkXcUOP6lvecFmz7K127vSXdmp5jxsMoIwzwTvEfUrwnXrUxinKpJMOSbr0jAYVFCPoPyPpTdomZ+PEccBHBe/VhOLIVIFCI4Fn02HcJZMas0VDlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736268231; c=relaxed/simple;
	bh=pVD0cc+NpkBhRafv6gV2/6aEjPnjlsqGz1z2VBsII1c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jcglNYqWdHNHVIg9Ak3vL7XyRNNwb6IVYRPdjB4ZLNZvsZRmrGVK0d8SO0BMVTFtkXO4YY90wVzPtVR4RPcg5KfALeRPm++FwGG/61CGdNMb5PuM7Vwwp3zZGhgh7fL/2uBw/V7FT5MoZWKzFpHxtVmPmI2TWare9CBlZf4miBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kRRSPS9o; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4679d366adeso137396191cf.1
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2025 08:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736268229; x=1736873029; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7mgOD19EVIG3yuSbSYqszRBgVjUnFygsdKaqIrBN4To=;
        b=kRRSPS9oTsslaTM/h1ZObdVQBICUUROlqSAqrJk7yC7CY/ljcU2xFSgDfdPrVBlLvN
         jXVDJ5YYlLA6pvgIndKPfWedw2i2T9ruhrkRVgoadPpdOkY6HiloT7EOBd4J1DsYKSYt
         HhiBQvLguRxIdT/kqKKmIHsOIGoG2i5pfXxhpPHDc0VLFjHvr7kPIDlfvyYyTRy7VZDK
         5vC5eAAJZRWX3WNh85s+ZxyX2gnJ0gUG/1/elc2W9L/Fb4d75te3+n8bd5uZSNmsNcLV
         ATy3+SM5cb2uJIHPUfVtdqsZsn8kz4J4lDiyC+1umj/Kvc0imUMyknYob6DWMNjyqnkL
         JRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736268229; x=1736873029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7mgOD19EVIG3yuSbSYqszRBgVjUnFygsdKaqIrBN4To=;
        b=RbDQ4nvqE6F4qukQqfixdY9bFVqaxGN6Ov0DXajw0MlTZLC7sRGAZ48dLTpGOhD0Ty
         5RoE00jvADwe7nd8MMJAOURutSar6GewJQYVBSmHhiMcUVI/2E7pSLEqsJefj4wZp64b
         6NmAjtCNk7EwmDP/84tFYPPdfxmn3Ur4XE+eyIKo71TY/zxZ65Lf7h2x0QaKpGJY6nxe
         StC4cBHaZ/SXARYw2YdCBB94czfY80YAD3H+a9PNPkuRf2a+YN8zFpWqtflFNbrTqv8a
         D7Drk92MVHSBZhjrvvefolRzvYXt0DY3o/bUIlMElbNuh/eaPZEBgO2lmo0jDaisre5n
         8ufg==
X-Forwarded-Encrypted: i=1; AJvYcCWURdSE6KSwSwsEGtHvOTkYlphjt7yrX9E/IaHKqfvxGvv0vSRBSIdzqzloZKsRd3cSzFw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzS2lOdbuygEMhTcrydqDlMU6jabZyoAPbscVEr7JiJQbCI70Q
	P3hmnc7ewLSFuVP6H9mLsuFNUZsGWsdnTuN7b0VdO6o7TzTlZw3FOKkvXJds41sjGIlgLdIaZCz
	05Jg0XncBgH2HyW2fO9y3QJBlo+TnaKfOcR1z
X-Gm-Gg: ASbGncvwJYMvPC/oEpUNvFmfSduP+KLB2aPFEQF7sREbb1SoG7ZEovsAZNZhlNyvXAo
	m9X1bfmIQP0JwJYw1MDufZ60XMlI+Y+ltnlVKw9Q=
X-Google-Smtp-Source: AGHT+IEAV8Jt6FsN6HaISJaR5nVC7V9rJz7cXjyj/1gSoV0D0zFme8i864Un+qNsAihNynf9x+RV93juKVVJN+LanpI=
X-Received: by 2002:ac8:7e84:0:b0:467:5cd2:4001 with SMTP id
 d75a77b69052e-46b3ac393aemr57141011cf.3.1736268228786; Tue, 07 Jan 2025
 08:43:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-2-suleiman@google.com>
 <Z31H3dkAktjUO2tR@google.com>
In-Reply-To: <Z31H3dkAktjUO2tR@google.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Wed, 8 Jan 2025 01:43:37 +0900
X-Gm-Features: AbW1kvYQyb2BhhiNq0S3yTAhpF2NQzO28pz5j_4ma7FzGQzJY5gRsAr9MVyqKdU
Message-ID: <CABCjUKDkP3-LWxHwVGxi1A3hM1WWEpuUF=moOdwN_iDyV0zVww@mail.gmail.com>
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

On Wed, Jan 8, 2025 at 12:27=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> KVM: for the scope.
>
> On Tue, Jan 07, 2025, Suleiman Souhlal wrote:
> > It returns the cumulative nanoseconds that the host has been suspended.
>
> Please write changelogs that are standalone.  "It returns ..." is complet=
ely
> nonsensical without the context of the shortlog.
>
> > It is intended to be used for reporting host suspend time to the guest.
> >
> > Change-Id: I8f644c9fbdb2c48d2c99dd9efaa5c85a83a14c2a
>
> Drop gerrit's metadata before posting.
>
> > Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> > ---
> >  include/linux/kvm_host.h |  2 ++
> >  virt/kvm/kvm_main.c      | 26 ++++++++++++++++++++++++++
> >  2 files changed, 28 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 401439bb21e3e6..cf926168b30820 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2553,4 +2553,6 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vc=
pu *vcpu,
> >                                   struct kvm_pre_fault_memory *range);
> >  #endif
> >
> > +u64 kvm_total_suspend_ns(void);
> > +
> >  #endif
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index de2c11dae23163..d5ae237df76d0d 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -889,13 +889,39 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
> >
> >  #endif /* CONFIG_KVM_GENERIC_MMU_NOTIFIER */
> >
> > +static u64 last_suspend;
> > +static u64 total_suspend_ns;
> > +
> > +u64 kvm_total_suspend_ns(void)
> > +{
> > +     return total_suspend_ns;
> > +}
> > +
> > +
>
> Extra whitespace.
>
> >  #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
> > +static int kvm_pm_notifier(struct kvm *kvm, unsigned long state)
> > +{
> > +     switch (state) {
> > +     case PM_HIBERNATION_PREPARE:
> > +     case PM_SUSPEND_PREPARE:
> > +             last_suspend =3D ktime_get_boottime_ns();
> > +     case PM_POST_HIBERNATION:
> > +     case PM_POST_SUSPEND:
> > +             total_suspend_ns +=3D ktime_get_boottime_ns() - last_susp=
end;
>
> This is broken.  As should be quite clear from the function parameters, t=
his is
> a per-VM notifier.  While clobbering "last_suspend" is relatively benign,
> accumulating into "total_suspend_ns" for every VM will cause the "total" =
suspend
> time to be wildly inaccurate if there are multiple VMs.

Good catch. Thanks for spotting that.

>
> > +     }
> > +
> > +     return NOTIFY_DONE;
> > +}
> > +
> >  static int kvm_pm_notifier_call(struct notifier_block *bl,
> >                               unsigned long state,
> >                               void *unused)
> >  {
> >       struct kvm *kvm =3D container_of(bl, struct kvm, pm_notifier);
> >
> > +     if (kvm_pm_notifier(kvm, state) !=3D NOTIFY_DONE)
> > +             return NOTIFY_BAD;
>
> This is ridiculous on multiple fronts.  There's zero reason for kvm_pm_no=
tifier()
> to return a value, it always succeeds.  I also see zero reason to put thi=
s code
> in common KVM.  It's 100% an x86-only concept, and x86 is the only archit=
ecture
> that implements kvm_arch_pm_notifier().  So just shove the logic into x86=
's
> implementation.

The feedback I thought I got in v1 was that this could be useful for
other architectures too.
But given that the current series only implements it for x86, I guess
it's fair for it to be out of common KVM for now.
I will move it back into x86's implementation.

Thanks for the very quick reviews.
-- Suleiman

