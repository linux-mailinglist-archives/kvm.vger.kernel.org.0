Return-Path: <kvm+bounces-55817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9052CB376C6
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 03:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FB9F1B66EAB
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 01:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C332F1B87C9;
	Wed, 27 Aug 2025 01:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bnGZsvJW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019FF1C861E
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 01:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756257600; cv=none; b=FfL9JlG3f9GOnXNJ0AaoYiVFKHGAS0HtXDDX0Eaugd9x1Q5gCCFKrslZ1x173VWJkJ6t9ZbpVQmEkebeCOq2+0WGpVI6ybUxKHhbTrQRYGzo67jpZ8AkJ8VUQ7C4zALcHRygR5IURbNtr/oAUeWECNG5pjg0RPxPVwdJU3WkQe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756257600; c=relaxed/simple;
	bh=mN+oo1UNJnN0omvqd9BShyz+gqPQoohgjOkZHJOQHzw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SkW+i0nC5tNSXv1lJSSUQjIp9QeHViiEMXqc23j+cGAAa82pJE0WZSEFEHQ8jk3yK7UPcBryW/xCbzUN6ITZpXuKDjzb4PWuIUALlZzFW/xl4C7D6ly+C57Kk7AMJH5QGEMz+bjazafHNrv6uXipFVqmtruiYTNfitClzcGnPpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bnGZsvJW; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b2f497c230so1401cf.0
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 18:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756257597; x=1756862397; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJzFNZaEh8t4luv7LOF1kGwNO9AtZDR3vDyNbCF3Rn8=;
        b=bnGZsvJWAFNcAZgdc3ujjpd0t6rn1FHCgRnzxPwxexdmvikyL1pGUYJB0vg/pxlr9C
         9+hLQUFAheCbfW6eHGERed6Bgqw7PqeCRdDWRCLv0ZHPzOuUufpDWQh1fMVGYMmI7vak
         EdtHAHWTVspMh5IH8DK7QyO5AZutANh9sTwpW+K4JX7i+jkN+8AYYBg5MCRi7sSKqtYS
         P49yphoIxSotkGZDHSwUXi3T2xWc4e3NRGxEgNdAPRbmAhfVP78s/IpyU9X6K8sNWDd2
         yj6dEjhkpYVEup+Bq1kw4MCpMXL32iHEp/wO49nxjqWmNmbYZ3MIotJY49klyzRLRzgr
         2/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756257597; x=1756862397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CJzFNZaEh8t4luv7LOF1kGwNO9AtZDR3vDyNbCF3Rn8=;
        b=EHVJ9nZn0KOgM8YQ0Mf4ZS8t7DyMtssQqLjjgMgmG73mW3NEFYLSvxq62ER03vPRgt
         eGyY9pn9S9oxIZn/vFftwilbiM3kKja5QCVCZG1CAmS7oF5oawLvkVXsd01Qux7CwG70
         /BYeDPxyKp7Uik+ouAHxHd+QaG3AUhtl/OLSyRxIZcOKf/R413R1qE+nW7QHGnmKOcNG
         rHdAJT9im/fYrytXrOd2gU4jWsfeRcCq0PPQGIfy7bgkUtQdOhDAKvITCUftQn+0P1C6
         iaTn17pPOYMQefxY+rtH+S22AQNRwyQmPoAOaJZ94kKVa0mSVyNGyX1WD/KVTIOEtV/4
         My/w==
X-Forwarded-Encrypted: i=1; AJvYcCXLLsLpaNmo/SDsqe8WnRGOAO7N56bFeiQhQlVqQR9yJk4ZHc6Eq8lVS5LWChBWtQcoGgE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4Dj4V5lvGBoVLc8rLtFAYeKUBoZY8bUJLKFG+SWUvBq4qfB2i
	bHzpwGKdYfgU68qPf82itCDeg4XBh7fZy9qSbDm76j6Chu5fmgtPrRoDYMDEAT7vQL+zjJRIHmz
	+s0+7vYK0yrTVRApTJpnhjNA+l34jal7pHKOC6bE/
X-Gm-Gg: ASbGncsGMf1Rcs4qdfhBrf68sMj1HrMwxKFkd8v32k1HV21NHzyObTtUk7JujhUK58D
	qYmn/ex95E08lSjbBO2LzsXNA/6gupLxXOC51ub6eLpBVygwUG50TwYoSzfIxVLbEnYxidzFedt
	Jvpj8Bikz+WeEhL205QhhViTWHnbctfxcNk6VlT/JZ9VuNjl/ATG1XS8H59ZYrEaLmhkRcxIMtP
	QhmCh9DxOdFuU/JnKr7HYqQCllhIOLF+8TijV4GNSdYdSRHEdQeLW1jUA==
X-Google-Smtp-Source: AGHT+IEuJOVMdHxH96QYBu81qdl4hzMnO1M43D+ICiIrJTwTVM5ft8LUlc2sjL/MoQ9n/Gyz8MLTTSRAsQSFrw0dT2M=
X-Received: by 2002:ac8:5a42:0:b0:4b2:939c:9c1a with SMTP id
 d75a77b69052e-4b2e2c4f835mr8119611cf.13.1756257596585; Tue, 26 Aug 2025
 18:19:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250826213455.2338722-1-sagis@google.com> <aK4rmD7QpotYXume@google.com>
In-Reply-To: <aK4rmD7QpotYXume@google.com>
From: Sagi Shahar <sagis@google.com>
Date: Tue, 26 Aug 2025 20:19:44 -0500
X-Gm-Features: Ac12FXzsv--5ke-C6XCdNU_yxA0o12QzJXdsM9jcz03myYwjsGmhKcUfEtHHOZ0
Message-ID: <CAAhR5DH9sY3EvHcEcoV4yq-HZGVjzKv6t_D-8oJ2V+hSBoskFw@mail.gmail.com>
Subject: Re: [PATCH] KVM: TDX: Force split irqchip for TDX at irqchip creation time
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2025 at 4:48=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Aug 26, 2025, Sagi Shahar wrote:
> > TDX module protects the EOI-bitmap which prevents the use of in-kernel
> > I/O APIC. See more details in the original patch [1]
> >
> > The current implementation already enforces the use of split irqchip fo=
r
> > TDX but it does so at the vCPU creation time which is generally to late
> > to fallback to split irqchip.
> >
> > This patch follows Sean's recomendation from [2] and move the check if
> > I/O APIC is supported for the VM at irqchip creation time.
> >
> > [1] https://lore.kernel.org/lkml/20250222014757.897978-11-binbin.wu@lin=
ux.intel.com/
> > [2] https://lore.kernel.org/lkml/aK3vZ5HuKKeFuuM4@google.com/
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Sagi Shahar <sagis@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  3 +++
> >  arch/x86/kvm/vmx/tdx.c          | 15 ++++++++-------
> >  arch/x86/kvm/x86.c              | 10 ++++++++++
> >  3 files changed, 21 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index f19a76d3ca0e..cb22fc48cdec 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1357,6 +1357,7 @@ struct kvm_arch {
> >       u8 vm_type;
> >       bool has_private_mem;
> >       bool has_protected_state;
> > +     bool has_protected_eoi;
> >       bool pre_fault_allowed;
> >       struct hlist_head *mmu_page_hash;
> >       struct list_head active_mmu_pages;
> > @@ -2284,6 +2285,8 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_f=
orced_root_level,
> >
> >  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_sta=
te)
> >
> > +#define kvm_arch_has_protected_eoi(kvm) (!(kvm)->arch.has_protected_eo=
i)
> > +
> >  static inline u16 kvm_read_ldt(void)
> >  {
> >       u16 ldt;
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 66744f5768c8..8c270a159692 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -658,6 +658,12 @@ int tdx_vm_init(struct kvm *kvm)
> >        */
> >       kvm->max_vcpus =3D min_t(int, kvm->max_vcpus, num_present_cpus())=
;
> >
> > +     /*
> > +      * TDX Module doesn't allow the hypervisor to modify the EOI-bitm=
ap,
> > +      * i.e. all EOIs are accelerated and never trigger exits.
> > +      */
> > +     kvm->arch.has_protected_eoi =3D true;
> > +
> >       kvm_tdx->state =3D TD_STATE_UNINITIALIZED;
> >
> >       return 0;
> > @@ -671,13 +677,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> >       if (kvm_tdx->state !=3D TD_STATE_INITIALIZED)
> >               return -EIO;
> >
> > -     /*
> > -      * TDX module mandates APICv, which requires an in-kernel local A=
PIC.
> > -      * Disallow an in-kernel I/O APIC, because level-triggered interr=
upts
> > -      * and thus the I/O APIC as a whole can't be faithfully emulated =
in KVM.
> > -      */
> > -     if (!irqchip_split(vcpu->kvm))
> > -             return -EINVAL;
> > +     /* Split irqchip should be enforced at irqchip creation time. */
> > +     KVM_BUG_ON(irqchip_split(vcpu->kvm), vcpu->kvm);
>
> Sadly, the existing check needs to stay, because userspace could simply n=
ot create
> any irqchip.  My complaints about KVM_CREATE_IRQCHIP is that KVM is allow=
ing an
> explicit action that is unsupported/invalid.  For lack of an in-kernel lo=
cal APIC,
> there's no better alternative to enforcing the check at vCPU creation.
>
> >       fpstate_set_confidential(&vcpu->arch.guest_fpu);
> >       vcpu->arch.apic->guest_apic_protected =3D true;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index a1c49bc681c4..a846dd3dcb23 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -6966,6 +6966,16 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigne=
d int ioctl, unsigned long arg)
> >               if (irqchip_in_kernel(kvm))
> >                       goto create_irqchip_unlock;
> >
> > +             /*
> > +              * Disallow an in-kernel I/O APIC for platforms that has =
protected
> > +              * EOI (such as TDX). The hypervisor can't modify the EOI=
-bitmap
> > +              * on these platforms which prevents the proper emulation=
 of
> > +              * level-triggered interrupts.
> > +              */
>
> Slight tweak to shorten this and to avoid mentioning the EOI-bitmap.  The=
 use of
> a software-controlled EOI-bitmap is a vendor specific detail, and it's no=
t so much
> the inability to modify the bitmap that's problematic, it's that TDX does=
n't
> allow intercepting EOIs.  E.g. TDX also requires x2APIC and PICv to be en=
abled,
> without which EOIs would effectively be intercepted by other means.
>
>                 /*
>                  * Disallow an in-kernel I/O APIC if the VM has protected=
 EOIs,
>                  * i.e. if KVM can't intercept EOIs and thus can't proper=
ly
>                  * emulate level-triggered interrupts.
>                  */
>
> > +             r =3D -ENOTTY;
> > +             if (kvm_arch_has_protected_eoi(kvm))
>
> No need for a macro wrapper, just do
>
>                 if (kvm->arch.has_protected_eoi)
>
> kvm_arch_has_readonly_mem() and similar accessors exist so that arch-neut=
ral
> code, e.g. check_memory_region_flags() in kvm_main.c, can query arch-spec=
ific
> state.  Nothing outside of KVM x86 should care about protected EOI, becau=
se that's
> very much an x86-specific detail.
>

Applied all the changes and sent out V2

> > +                     goto create_irqchip_unlock;
> > +
> >               r =3D -EINVAL;
> >               if (kvm->created_vcpus)
> >                       goto create_irqchip_unlock;
> > --
> > 2.51.0.261.g7ce5a0a67e-goog
> >

