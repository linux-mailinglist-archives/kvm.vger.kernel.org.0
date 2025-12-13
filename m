Return-Path: <kvm+bounces-65932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 31794CBB11F
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 17:11:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8444C3001BFB
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 16:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 988392D839B;
	Sat, 13 Dec 2025 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G3cExKm9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD131DED63
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765642288; cv=none; b=VyaBvePxnag0zFap35SkPqGrUXQLIc2taylYeDaaZupzRno3qR9+exusuDDoignLuj3qW762DUxNiinVWB2PS7QBI2aAXciadhMrIpcgSCh0l6AIg6KNaXTAxobol4npzOi6giiihMVnnsjIuLa3+BGmc3VyWK6mIDi0fkfyTu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765642288; c=relaxed/simple;
	bh=Po/jQDLwxfo/URZ6OI5S/273P4BkAmoShoHZrJfUHfU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PBJm6q3XKUJwnRu49H07rbrYfqYKZxcHjp7Fa4uqwRT7TveAbCNvfEd4FdBpI2WN5tyYsIZq98Q1bWiVfJJwzAvy8nI1c9941ZK6KHZ+fVQLmwK83mrUD4LQ9Fb/5/BJYUl3vgK3Gx84VNppnoixMB7SfpqCGSTzNH3pkKDWACU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G3cExKm9; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47a95efd2ceso3931155e9.2
        for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 08:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765642285; x=1766247085; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sDu+m9YFABV7WYpk3W+gmMW0dZkj6O6q+Yiy7VD6kqE=;
        b=G3cExKm9VRVCQdrW0heUTcYtSYYAfIigAutPcN1IATw2a//J22DGX/VhOSiOb8QhLl
         ls8KIj2ycpUWBjDPwLwIZU8S9W9PPQrTkzs6CIG+S0DVNY1C1xQzhWzkdkjupSUlKiSt
         QrZXTraLHcv9qFbtNzWZIu7xuhps8IKq9jBJwuI+iroIcLM5VGJBFvXNrLqTppXaVgVu
         3rEKZlJajZd8eCrbhqbaanpvtR+0G/4PKE8Z8/KuF59MGXqcZu/VrcK0J5uO3GqhprTb
         xBeOPhL0sajlQfQp3+iOgVqK4tmginfaHFdXuREQRM6cJ+B72fmQixYpXS3F+7Es9ef0
         c0wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765642285; x=1766247085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sDu+m9YFABV7WYpk3W+gmMW0dZkj6O6q+Yiy7VD6kqE=;
        b=DBKP+dSjlp53dXtsS/8Ds4ZsNy4/GpJUM62kMsu5DHB3hxuFXUV1PRYeW1fBw69rxq
         KaMY7mcAUDsx9ryPdqZoCJ89Cw+7y5HnG6dpxtRXMHL4SlFbpErDa5VSA/bZV1kRVmdF
         Ra+nf3zqioEigqnXFaFkn/7P3NiImjAEIIAGMqzQYmHepU+Kq8kEb9jbK/P5WaObsrhE
         ICtdnXAHyipQUOU0Ee8rQfSZblTvAjLRKi6YKxdAAqITO7mx55fWZz8AGfyfmRPnhfSl
         NTNT1GptHFB5P1WP3gdJwsfZ7wzSLigcYWl2in8fsLed5Azio3kTTlr3pwgsOVesnk5f
         BzVw==
X-Forwarded-Encrypted: i=1; AJvYcCWk5XE6tcl/7ayNmN+8WAUKDt3oZxFTYZZbBLQK0o29aHvnhuVFKnaTfLQ8954k+6oE/No=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDG3BPQERqbbzAXkY/6CYa2His0qisQkCajCa+tt3YluGxh/IL
	I1vL5R9W0JtMoJHihQjDYJ4wVwiqJU2O+oHhR0q/56FC4BpTMGLcXYY0rVUyrOR7p3poZIluSFG
	5qEIAe0o5+Ro7tV8jCxGlb0xbKahtLV1ruAyDfC8K
X-Gm-Gg: AY/fxX6tJEArq9KTAEqJZaTho5miHIOCijtIy/wLhOL4hYIXmirOVP1RX3GmBFais21
	nN9lBqZuZeCaabhAlgG8BX6rEIpMFUwoKlcfIHN5iZilTe5b13BKPMKxst+o86VtyNo1esJ+pEP
	RbnKps5XdLcsG+oPSMNBJf5klyRnu2KYi13N+qycYHn0CIcQKfWlwCxvixmEfEqiKgcQUQDfmyK
	VMJUFOw3qwdi3PpuwBPrCvE3YNvPR1txccRrZWfqhQCO59mi9cBeKL4vX6EH3B+iNoUVPj3CL/0
	FkVpmNJ6SDXjbqjAZ6bqm2xFv965Mg==
X-Google-Smtp-Source: AGHT+IHHyqR07Zip3NbBgqV5TzBeYuik5jVIy5H+n6pceO24Oe/TD+OuIs4wpUPqJ1AXTQyD944S/iDAYHSP5Wpa5Js=
X-Received: by 2002:a05:600c:8115:b0:471:1717:411 with SMTP id
 5b1f17b1804b1-47a8f903f07mr55365745e9.24.1765642284884; Sat, 13 Dec 2025
 08:11:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205070630.4013452-1-chengkev@google.com> <aThT5d5WdMSszN9b@google.com>
In-Reply-To: <aThT5d5WdMSszN9b@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Sat, 13 Dec 2025 11:11:13 -0500
X-Gm-Features: AQt7F2pbHSqHr_C_LWkK23KfDFVZzurB9IgLgE233A03Hw8W5XAgR02XMj8eccI
Message-ID: <CAE6NW_ZwdpGN0F_8NVe77tgGPw7nO5Mi-t1455gGoLcUVpVbpw@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Don't allow L1 intercepts for instructions not advertised
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, jmattson@google.com, yosry.ahmed@linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 9, 2025 at 11:52=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Dec 05, 2025, Kevin Cheng wrote:
> > If a feature is not advertised in the guest's CPUID, prevent L1 from
> > intercepting the unsupported instructions by clearing the corresponding
> > intercept in KVM's cached vmcb12.
> >
> > When an L2 guest executes an instruction that is not advertised to L1,
> > we expect a #UD exception to be injected by L0. However, the nested svm
> > exit handler first checks if the instruction intercept is set in vmcb12=
,
> > and if so, synthesizes an exit from L2 to L1 instead of a #UD exception=
.
> > If a feature is not advertised, the L1 intercept should be ignored.
> >
> > Calculate the nested intercept mask by checking all instructions that
> > can be intercepted and are controlled by a CPUID bit. Use this mask whe=
n
> > copying from the vmcb12 to KVM's cached vmcb12 to effectively ignore th=
e
> > intercept on nested vm exit handling.
> >
> > Another option is to handle ignoring the L1 intercepts in the nested vm
> > exit code path, but I've gone with modifying the cached vmcb12 to keep
> > it simpler.
> >
> > Signed-off-by: Kevin Cheng <chengkev@google.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 30 +++++++++++++++++++++++++++++-
> >  arch/x86/kvm/svm/svm.c    |  2 ++
> >  arch/x86/kvm/svm/svm.h    | 14 ++++++++++++++
> >  3 files changed, 45 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index c81005b245222..f2ade24908b39 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -184,6 +184,33 @@ void recalc_intercepts(struct vcpu_svm *svm)
> >       }
> >  }
> >
> > +/*
> > + * If a feature is not advertised to L1, set the mask bit for the corr=
esponding
> > + * vmcb12 intercept.
> > + */
> > +void svm_recalc_nested_intercepts_mask(struct kvm_vcpu *vcpu)
> > +{
> > +     struct vcpu_svm *svm =3D to_svm(vcpu);
> > +
> > +     memset(svm->nested.nested_intercept_mask, 0,
> > +            sizeof(svm->nested.nested_intercept_mask));
> > +
> > +     if (!guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP))
> > +             set_nested_intercept_mask(&svm->nested, INTERCEPT_RDTSCP)=
;
> > +
> > +     if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SKINIT))
> > +             set_nested_intercept_mask(&svm->nested, INTERCEPT_SKINIT)=
;
> > +
> > +     if (!guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
> > +             set_nested_intercept_mask(&svm->nested, INTERCEPT_XSETBV)=
;
> > +
> > +     if (!guest_cpu_cap_has(vcpu, X86_FEATURE_RDPRU))
> > +             set_nested_intercept_mask(&svm->nested, INTERCEPT_RDPRU);
> > +
> > +     if (!guest_cpu_cap_has(vcpu, X86_FEATURE_INVPCID))
> > +             set_nested_intercept_mask(&svm->nested, INTERCEPT_INVPCID=
);
>
> Ugh.  I don't see any reason for svm->nested.nested_intercept_mask to exi=
st.
> guest_cpu_cap_has() is cheap (which is largely why it even exists), just =
sanitize
> the vmcb02 intercepts on-demand.  The name is also wonky: it "sets" bits =
only to
> effect a "clear" of those bits.
>
> Gah, and the helpers to access/mutate intercepts can be cleaned up.  E.g.=
 if we
> do something like this:
>
> static inline void __vmcb_set_intercept(unsigned long *intercepts, u32 bi=
t)
> {
>         WARN_ON_ONCE(bit >=3D 32 * MAX_INTERCEPT);
>         __set_bit(bit, intercepts);
> }
>
> static inline void __vmcb_clr_intercept(unsigned long *intercepts, u32 bi=
t)
> {
>         WARN_ON_ONCE(bit >=3D 32 * MAX_INTERCEPT);
>         __clear_bit(bit, intercepts);
> }
>
> static inline bool __vmcb_is_intercept(unsigned long *intercepts, u32 bit=
)
> {
>         WARN_ON_ONCE(bit >=3D 32 * MAX_INTERCEPT);
>         return test_bit(bit, intercepts);
> }
>
> static inline void vmcb_set_intercept(struct vmcb_control_area *control, =
u32 bit)
> {
>         __vmcb_set_intercept((unsigned long *)&control->intercepts, bit);
> }
>
> static inline void vmcb_clr_intercept(struct vmcb_control_area *control, =
u32 bit)
> {
>         __vmcb_clr_intercept((unsigned long *)&control->intercepts, bit);
> }
>
> static inline bool vmcb_is_intercept(struct vmcb_control_area *control, u=
32 bit)
> {
>         return __vmcb_is_intercept((unsigned long *)&control->intercepts,=
 bit);
> }
>
> static inline void vmcb12_clr_intercept(struct vmcb_ctrl_area_cached *con=
trol, u32 bit)
> {
>         __vmcb_clr_intercept((unsigned long *)&control->intercepts, bit);
> }
>
> static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *cont=
rol, u32 bit)
> {
>         return __vmcb_is_intercept((unsigned long *)&control->intercepts,=
 bit);
> }
>
> > +}
> > +
> >  /*
> >   * This array (and its actual size) holds the set of offsets (indexing=
 by chunk
> >   * size) to process when merging vmcb12's MSRPM with vmcb01's MSRPM.  =
Note, the
> > @@ -408,10 +435,11 @@ void __nested_copy_vmcb_control_to_cache(struct k=
vm_vcpu *vcpu,
> >                                        struct vmcb_ctrl_area_cached *to=
,
> >                                        struct vmcb_control_area *from)
> >  {
> > +     struct vcpu_svm *svm =3D to_svm(vcpu);
> >       unsigned int i;
> >
> >       for (i =3D 0; i < MAX_INTERCEPT; i++)
> > -             to->intercepts[i] =3D from->intercepts[i];
> > +             to->intercepts[i] =3D from->intercepts[i] & ~(svm->nested=
.nested_intercept_mask[i]);
>
> Then here we can use vmcb_clr_intercept().  And if with macro shenanigans=
, we
> can cut down on the boilerplate like so:
>
> #define __nested_svm_sanitize_intercept(__vcpu, __control, fname, iname) =
       \
> do {                                                                     =
       \
>         if (!guest_cpu_cap_has(__vcpu, X86_FEATURE_##fname))             =
       \
>                 vmcb12_clr_intercept(__control, INTERCEPT_##iname);      =
       \
> } while (0)
>
> #define nested_svm_sanitize_intercept(__vcpu, __control, name)           =
       \
>         __nested_svm_sanitize_intercept(__vcpu, __control, name, name)
>
> static
> void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>                                          struct vmcb_ctrl_area_cached *to=
,
>                                          struct vmcb_control_area *from)
> {
>         unsigned int i;
>
>         for (i =3D 0; i < MAX_INTERCEPT; i++)
>                 to->intercepts[i] =3D from->intercepts[i];
>
>         nested_svm_sanitize_intercept(vcpu, to, RDTSCP);
>         nested_svm_sanitize_intercept(vcpu, to, SKINIT);
>         __nested_svm_sanitize_intercept(vcpu, to, XSAVE, XSETBV);
>         nested_svm_sanitize_intercept(vcpu, to, RDPRU);
>         nested_svm_sanitize_intercept(vcpu, to, INVPCID);
>
> Side topic, do we care about handling the case where userspace sets CPUID=
 after
> stuffing guest state?  I'm very tempted to send a patch disallowing KVM_S=
ET_CPUID
> if is_guest_mode() is true, and hoping no one cares.

Hmm good point I haven't thought about that. Would it be better to
instead update the nested state in svm_vcpu_after_set_cpuid() if
KVM_SET_CPUID is executed when is_guest_mode() is true?

Also sorry if this is a dumb question, but in general if KVM_SET_CPUID
is disallowed, then how does userspace handle a failed IOCTL call? Do
they just try again later or accept that the call has failed? Or is
there an error code that signals that the vcpu is executing in guest
mode and should wait until not in guest mode to call the IOCTL?

>
> >
> >       to->iopm_base_pa        =3D from->iopm_base_pa;
> >       to->msrpm_base_pa       =3D from->msrpm_base_pa;

