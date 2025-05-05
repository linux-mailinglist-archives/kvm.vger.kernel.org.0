Return-Path: <kvm+bounces-45423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D4EAA97F8
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 17:52:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86D6D189DBE7
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 15:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57EFE263C8F;
	Mon,  5 May 2025 15:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K792Qbc6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8D12627EC
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 15:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746460311; cv=none; b=Ql6NRo6az2r5C1b4cSjZybl9oNQSHt+yiF7gFiEKFMevVN0/uQvBR+5L9YmsY8VqGgHFVlKFQnjvQhr7QuyDYG+Z4mvHoGEdnD4Ie/UZl5SbsspauLzy3Md+HwTmCEPaw1wzLXr6qr6rBNzmOLkefBq6P9Jn3YVbwD6Rl88ZHFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746460311; c=relaxed/simple;
	bh=E/ouETHxCribkFH/l4cIUUThSDdAwv1HuscA6q8cJME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f1ub/RTYnos4svn4TOthycDCOFk+QE81x+iYMnodiMGHXAUyEEpbSSqNXLKKpj3Sw/o0QSBq+KjpQop5orwR1iPp8Qheh3yVzhISYQ9AdMjI9y8OEmb8AnhPNQeWq/ToYL+XRySXl4wJomqjQZVwQ7nhevWUhVGff9ZkTGIC+sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K792Qbc6; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso14588a12.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 08:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746460308; x=1747065108; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rfrPNwnin6OLWmMYx+AfwJyrSyct0onk2Si8di7Lblo=;
        b=K792Qbc6KFvBACvlnzQ5US9weZIBz++omt6/QVXy2GvuX8ZMXTuC0pc+Q9c+Nes0xw
         ZF1BzvEmDlk72DQv+AU3M+RHzX3Sx2Tv8J79Jjc2qMl+NmAxeKKm8mAbQZnhhl4f/xqY
         E2FIAS427qc4zp9uGit7O52EbNpOU3iMyAEppQLfWIyAcBvoxcmrphNhzjsJoDA5yomR
         p3K0Md4ewSE/rA63GIqdYTKT3FGo6fjlCUEOIPTF6FGiAU77mQjg2pUWKeER92PnCEr8
         jtH9zl3m+FWQfSZTf44dj84MboBN+OuOQ/L4rh5vhjm+on7kU9fFyziNcS/FHwDOny7q
         pUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746460308; x=1747065108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rfrPNwnin6OLWmMYx+AfwJyrSyct0onk2Si8di7Lblo=;
        b=L8QW2hwKyR8bFrbrj12wwgWllHMQ58Iype/e8msOeHQ+D1HX/tBc6okT5LawBnV6U4
         +lu005njTN3SSIIJVPsrjfM46q6TebvkI3l4X/haNKp4RDZJMO+hy0sd1FVO0IKBWs5H
         hOvEMuz0WmIN4XeCHPpmjiNAQR/1KWbe5APMiUjw7B6CIizKiiWnH41m2PgIZAJMdUsV
         ONxsh++X5PyLB++315VUwPgPzhBwUcPGkAHl0EzUxE3ReR2X6xUPc1xJAOFuE3ZOEzBs
         XsJ0JjLuaZbmNtrtEvfi0IvaLA3vLxvH7KS3Z0LtWpkG4PkjV1dYSSL3iH8ECdkFvtQ1
         aapQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPz/Jn6kqCekLI0/78fLESh3Afp3AKGJU3g0kDNGJ6RVHp/b7xoELN+8JnZ3ZxvNOzpWA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8O12nfRQFg/Xh0PjlocBk7YrOhdJiuWshqYF3E9dB/733lVoc
	C/RSZ6QXqE3ITx7axL7u6AK0T8fEf5OCnPgWTxwPHAQXm3dDBaVp857WMSDhSt+5Ce6g32Q7LSw
	ibgh2v+G9KdDNaJW2QR9UARMTmz/QbrcmmLPd
X-Gm-Gg: ASbGncvK64s7u172tIG5yLLDHUA3lbtGkY1qpDnVu2UPTrAPDS54/rEA85dGFBmZ9eP
	qJl2EdfeZKtILuDNTkTPpv+AidgRmj95bXC99eFU+6+26aMKhvRSlk98ptA9JhO1njkS5WuU4Mi
	tya2qRhFQ5N/jdQz6PL2VKtA==
X-Google-Smtp-Source: AGHT+IEk/oLC58id/Uho8V9/jhtlshoFkjymX27AlthyhCEgesuGdvJ9WKnyLdNmFBJHMMCGrtyrw7tz5tc425zpKpM=
X-Received: by 2002:a05:6402:d6b:b0:5e0:eaa6:a2b0 with SMTP id
 4fb4d7f45d1cf-5fb56694457mr7301a12.5.1746460307575; Mon, 05 May 2025 08:51:47
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250321221444.2449974-1-jmattson@google.com> <20250321221444.2449974-2-jmattson@google.com>
 <aBAIL6oGYJ7IV85X@google.com>
In-Reply-To: <aBAIL6oGYJ7IV85X@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 5 May 2025 08:51:35 -0700
X-Gm-Features: ATxdqUF8s45XhGILx8sqJ676GY2Xk8LlUB1Fsvc90iMTYiTwy2rWSDMf28VCrxo
Message-ID: <CALMp9eS7XHpFWMAtnJPQijYO1TVW25-UGmFqc33eAeb1AE_9YA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Provide a capability to disable
 APERF/MPERF read intercepts
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2025 at 3:58=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Mar 21, 2025, Jim Mattson wrote:
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/ap=
i.rst
> > index 2b52eb77e29c..6431cd33f06a 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -7684,6 +7684,7 @@ Valid bits in args[0] are::
> >    #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
> >    #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
> >    #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
> > +  #define KVM_X86_DISABLE_EXITS_APERFMPERF       (1 << 4)
>
> Might be pre-existing with C-states, but I think the documentation needs =
to call
> out that userspace is responsible for enumerating APERFMPERF in guest CPU=
ID.
>
> And more importantly, KVM either needs to honor APERFMPERF in each vCPU's=
 CPUID,
> or the documentation needs to call out that KVM doesn't honor guest CPUID=
 for
> APERF/MPERF MSRs.  I don't have a strong preference either way, but I'm l=
eaning
> toward having KVM honor CPUID so that if someone copy+pastes the KVM self=
test
> code for the host enabling, it'll do the right thing.  On the other hand,=
 KVM
> doesn't (and shouldn't) fully emulate the MSRs, so I'm a-ok if we ignore =
CPUID
> entirely (but document it).
>
> Ignoring CPUID entirely would also make it easier to document that KVM do=
esn't
> upport loading/saving C-state or APERF/MPERF MSRs via load/store lists on=
 VM-Enter
> and VM-Exit.  E.g. we can simply say KVM doesn't emulate the MSRs in any =
capacity,
> and that the capability disable the exit/interception, no more no less.
>
> Heh, I guess maybe I've talked myself into having KVM ignore guest CPUID =
:-)

I concur. I will add a note to that effect.

> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index ea44c1da5a7c..5b38d5c00788 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -44,7 +44,7 @@ static inline struct page *__sme_pa_to_page(unsigned =
long pa)
> >  #define      IOPM_SIZE PAGE_SIZE * 3
> >  #define      MSRPM_SIZE PAGE_SIZE * 2
> >
> > -#define MAX_DIRECT_ACCESS_MSRS       48
> > +#define MAX_DIRECT_ACCESS_MSRS       50
>
> Ugh, I really need to get the MSR interception cleanup series posted.
>
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 4b64ab350bcd..1b3cdca806b4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4535,6 +4535,9 @@ static u64 kvm_get_allowed_disable_exits(void)
> >  {
> >       u64 r =3D KVM_X86_DISABLE_EXITS_PAUSE;
> >
> > +     if (boot_cpu_has(X86_FEATURE_APERFMPERF))
> > +             r |=3D KVM_X86_DISABLE_EXITS_APERFMPERF;
> > +
> >       if (!mitigate_smt_rsb) {
> >               r |=3D KVM_X86_DISABLE_EXITS_HLT |
> >                       KVM_X86_DISABLE_EXITS_CSTATE;
> > @@ -6543,7 +6546,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >
> >               if (!mitigate_smt_rsb && boot_cpu_has_bug(X86_BUG_SMT_RSB=
) &&
> >                   cpu_smt_possible() &&
> > -                 (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
> > +                 (cap->args[0] & ~(KVM_X86_DISABLE_EXITS_PAUSE |
> > +                                   KVM_X86_DISABLE_EXITS_APERFMPERF)))
> >                       pr_warn_once(SMT_RSB_MSG);
> >
> >               if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
> > @@ -6554,6 +6558,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >                       kvm->arch.hlt_in_guest =3D true;
> >               if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
> >                       kvm->arch.cstate_in_guest =3D true;
> > +             if (cap->args[0] & KVM_X86_DISABLE_EXITS_APERFMPERF)
> > +                     kvm->arch.aperfmperf_in_guest =3D true;
>
> Rather that an ever-growing stream of a booleans, what about tracing the =
flags
> as a u64 and providing a builder macro to generate the helper?  The latte=
r is a
> bit gratuitous, but this seems like the type of boilerplate that would be
> embarassingly easy to screw up without anyone noticing.
>
> Very lightly tested...
>
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Mon, 28 Apr 2025 11:35:47 -0700
> Subject: [PATCH] KVM: x86: Consolidate DISABLE_EXITS_xxx handling into a
>  single kvm_arch field
>
> Replace the individual xxx_in_guest booleans with a single field to track
> exits that have been disabled for a VM.  To further cut down on the amoun=
t
> of boilerplate needed for each disabled exit, add a builder macro to
> generate the accessor.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  5 +----
>  arch/x86/kvm/svm/svm.c          |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  2 +-
>  arch/x86/kvm/x86.c              | 25 ++++++++-----------------
>  arch/x86/kvm/x86.h              | 28 +++++++++-------------------
>  5 files changed, 20 insertions(+), 42 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 6c06f3d6e081..4b174499b29c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1389,10 +1389,7 @@ struct kvm_arch {
>
>         gpa_t wall_clock;
>
> -       bool mwait_in_guest;
> -       bool hlt_in_guest;
> -       bool pause_in_guest;
> -       bool cstate_in_guest;
> +       u64 disabled_exits;
>
>         unsigned long irq_sources_bitmap;
>         s64 kvmclock_offset;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cc1c721ba067..0f0c06be85d6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5053,7 +5053,7 @@ static int svm_vm_init(struct kvm *kvm)
>         }
>
>         if (!pause_filter_count || !pause_filter_thresh)
> -               kvm->arch.pause_in_guest =3D true;
> +               kvm->arch.disabled_exits |=3D KVM_X86_DISABLE_EXITS_PAUSE=
;
>
>         if (enable_apicv) {
>                 int ret =3D avic_vm_init(kvm);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ef2d7208dd20..109ade8fc47b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7613,7 +7613,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>  int vmx_vm_init(struct kvm *kvm)
>  {
>         if (!ple_gap)
> -               kvm->arch.pause_in_guest =3D true;
> +               kvm->arch.disabled_exits |=3D KVM_X86_DISABLE_EXITS_PAUSE=
;
>
>         if (boot_cpu_has(X86_BUG_L1TF) && enable_ept) {
>                 switch (l1tf_mitigation) {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f6ce044b090a..3800d6cfecce 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6591,27 +6591,18 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                         break;
>
>                 mutex_lock(&kvm->lock);
> -               if (kvm->created_vcpus)
> -                       goto disable_exits_unlock;
> -
> +               if (!kvm->created_vcpus) {
>  #define SMT_RSB_MSG "This processor is affected by the Cross-Thread Retu=
rn Predictions vulnerability. " \
>                     "KVM_CAP_X86_DISABLE_EXITS should only be used with S=
MT disabled or trusted guests."
>
> -               if (!mitigate_smt_rsb && boot_cpu_has_bug(X86_BUG_SMT_RSB=
) &&
> -                   cpu_smt_possible() &&
> -                   (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
> -                       pr_warn_once(SMT_RSB_MSG);
> +                       if (!mitigate_smt_rsb && cpu_smt_possible() &&
> +                           boot_cpu_has_bug(X86_BUG_SMT_RSB) &&
> +                           (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE)=
)
> +                               pr_warn_once(SMT_RSB_MSG);
>
> -               if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
> -                       kvm->arch.pause_in_guest =3D true;
> -               if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
> -                       kvm->arch.mwait_in_guest =3D true;
> -               if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
> -                       kvm->arch.hlt_in_guest =3D true;
> -               if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
> -                       kvm->arch.cstate_in_guest =3D true;
> -               r =3D 0;
> -disable_exits_unlock:
> +                       kvm->arch.disabled_exits |=3D cap->args[0];
> +                       r =3D 0;
> +               }
>                 mutex_unlock(&kvm->lock);
>                 break;
>         case KVM_CAP_MSR_PLATFORM_INFO:
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 88a9475899c8..1675017eea88 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -481,25 +481,15 @@ static inline u64 nsec_to_cycles(struct kvm_vcpu *v=
cpu, u64 nsec)
>             __rem;                                              \
>          })
>
> -static inline bool kvm_mwait_in_guest(struct kvm *kvm)
> -{
> -       return kvm->arch.mwait_in_guest;
> -}
> -
> -static inline bool kvm_hlt_in_guest(struct kvm *kvm)
> -{
> -       return kvm->arch.hlt_in_guest;
> -}
> -
> -static inline bool kvm_pause_in_guest(struct kvm *kvm)
> -{
> -       return kvm->arch.pause_in_guest;
> -}
> -
> -static inline bool kvm_cstate_in_guest(struct kvm *kvm)
> -{
> -       return kvm->arch.cstate_in_guest;
> -}
> +#define BUILD_DISABLED_EXITS_HELPER(lname, uname)                       =
       \
> +static inline bool kvm_##lname##_in_guest(struct kvm *kvm)              =
       \
> +{                                                                       =
       \
> +       return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_##uname; =
       \
> +}
> +BUILD_DISABLED_EXITS_HELPER(hlt, HLT);
> +BUILD_DISABLED_EXITS_HELPER(pause, PAUSE);
> +BUILD_DISABLED_EXITS_HELPER(mwait, MWAIT);
> +BUILD_DISABLED_EXITS_HELPER(cstate, CSTATE);

The boilerplate is bad, but that's abhorrent.

>  static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
>  {
>
> base-commit: 45eb29140e68ffe8e93a5471006858a018480a45
> --

