Return-Path: <kvm+bounces-38891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F54BA4000B
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 20:52:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF2384221F1
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 19:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23D9B25291F;
	Fri, 21 Feb 2025 19:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w5hvqION"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997B21EBA0C
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 19:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740167555; cv=none; b=PRYuKROfC90xeIeIKf58nlIspLTP/ml9qsenakAp5NAdHCUUv54eB6R1m9Vriqu4SV5AJ+bs0SgZ/6tMhkEs0cIvCtarbPhqJATpog/NT2SYw9jSXLVUqdK8CBUNt3h4hO+1Bn9u0FHNfMTom3X7CWCt51o+ksOtqY41v1JIpC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740167555; c=relaxed/simple;
	bh=p1BHJgEr/kBQTAvVNk1lMQFlh93Kvergwn/kU5w4XiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WBbdqe1rsjOHbb7oWYcFcW3fpq5NgcV7y1GpvDr6jw4WrXbPVVzOQjeCVYFE7IUeWZ7l3ylHJkb4lH1341RKocB/qtERa+O50m36SBdHoFGmwnPKX334G5UY6VRwNB90pR2xn+QmPTBYPdPu4r8W5bS/vfBBd2yx2es6zKxjEw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w5hvqION; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d19702f977so18505ab.1
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 11:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740167553; x=1740772353; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Juu9QRBj4KDiXNpG5MgixnDb1rrNSBPu1sSw6k6sDE=;
        b=w5hvqION8Xp+6yqI536vlji8suWVD3DRSVxyGKFLcLxlXGHQrLOUEX87BaB4Tlo3dy
         30W+I3P++AM/P63zoOnRD62PpARD8bYNeuQ5eEXlSrCawv6V4RISjTw4O1JMrL4hVFFL
         fdaN3gHw0wyzKiabQTIj213kNGOHsAvbhS8gtbk2Do+/NJMDT10I4RmG1ejTiFj9R0K6
         s3ZTFXbJARrdTaJe+tpkr4qbF5m7x8N0GGYE297BxXKMuxKf43gxeMn0JTqwBlZtgDVj
         s95JXcY5K9V18d/D+L4r96cOUeI7hAb+9uBokqY0mnnPkrSd/1ZhUkha0+20NOYAr+rH
         PKQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740167553; x=1740772353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Juu9QRBj4KDiXNpG5MgixnDb1rrNSBPu1sSw6k6sDE=;
        b=BmvwtAqT1bMlJYOLUYNqcgFPWMlvT6qenX2Q/x8+4Na/ANLLQKmh1/6d7bfXBKjjwH
         OiQgPIwrFgjGAjdeSzxhH+ydGOY3LSqsVi+JYWOT2ofLle41q7AT3hrUM+AJHgUC8YvC
         S2+SjMpDXSJjrD9ZImVP4rw2UahYwSxB9bxkVoyYoTmXfiK0g7A6EFQYWwupFepRrYLR
         PrL/+yc6MwSSJOMdFhZKBFEuP3cMLVhPu7xiVEEh+6H2Z2DGZxwjEUe5cXJLO50CQXH3
         YrKE4Kg8jvvnJpbjUJN3uTRdN89JS4k9uCqO+X+k8T+10KkyWLddNb5p05Ccip4yYQ79
         37+g==
X-Forwarded-Encrypted: i=1; AJvYcCWYlh6MZD5iyGfI+rXBh/d2KatAPXzcHdwbO1t9a+euxJEX4rxXaa97LcFLsLsuxw8NQPE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyT4x6HqaAIIEMnDpNlXO9Zeq75YAzMzExcaTcT95JL+Xvq28oS
	LCcuhoka+ra6NLgu8ShXTkJCipvq4PTiuBTGZL7onbBMjeu5+OHwoXQIAS9pzsNhXxd9QSy0zTT
	/0APp4jn0yPfwC//VVJy/meL3dhbc9UBkcvE8
X-Gm-Gg: ASbGncvecTMZgaaYO/ct18kpWWbkfr7ACRGbM9RCwoDq22kBjV0jUlUhLugrHkuSE1k
	CGVjl3zhcY4LKIODpR4njSrJaRRJdFtyEvREqXlaiTBsBZkKPi3ChBtECseoOn5eNamYHJ4OAjL
	N37AIt30c=
X-Google-Smtp-Source: AGHT+IFkAJq3icJ6W6tfdycXQITqnOEyF4TiuFhBNcS2/oxZ7nFkWw6i9mSkDlFw9bEpSnjWmm2jKFvWGykB214vG3U=
X-Received: by 2002:a05:6e02:3387:b0:3d0:5959:629f with SMTP id
 e9e14a558f8ab-3d2d7247d71mr384725ab.16.1740167552505; Fri, 21 Feb 2025
 11:52:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250221163352.3818347-1-yosry.ahmed@linux.dev>
 <20250221163352.3818347-4-yosry.ahmed@linux.dev> <CALMp9eSPVDYC7v4Rm13ZUcE4wWPb8dUfm=qBx_jETAQEQrt4_w@mail.gmail.com>
 <Z7jISUVBeAbw8zt6@google.com> <CALMp9eQmsFd1QyCPOsPXBnkUdGmsW-ZBW5CoDR4pmSwF7ic0XA@mail.gmail.com>
 <Z7jTQc8FB4gpuNVN@google.com>
In-Reply-To: <Z7jTQc8FB4gpuNVN@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 21 Feb 2025 11:52:21 -0800
X-Gm-Features: AWEUYZnSU6FMwRFV6h7tf_zEnpaH_dTt0K93rE5Jyq6CIdm8blMIBbA3tJqt1Gs
Message-ID: <CALMp9eR+sr-qMj8-XfN_E9DgX00YhcaX8=aZ2+efGzQ9gXtRRQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86: Generalize IBRS virtualization on emulated VM-exit
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: x86@kernel.org, Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kaplan, David" <David.Kaplan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2025 at 11:26=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev=
> wrote:
>
> On Fri, Feb 21, 2025 at 11:02:16AM -0800, Jim Mattson wrote:
> > On Fri, Feb 21, 2025 at 10:39=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux=
.dev> wrote:
> > >
> > > On Fri, Feb 21, 2025 at 09:59:04AM -0800, Jim Mattson wrote:
> > > > On Fri, Feb 21, 2025 at 8:34=E2=80=AFAM Yosry Ahmed <yosry.ahmed@li=
nux.dev> wrote:
> > > > >
> > > > > Commit 2e7eab81425a ("KVM: VMX: Execute IBPB on emulated VM-exit =
when
> > > > > guest has IBRS") added an IBPB in the emulated VM-exit path on In=
tel to
> > > > > properly virtualize IBRS by providing separate predictor modes fo=
r L1
> > > > > and L2.
> > > > >
> > > > > AMD requires similar handling, except when IbrsSameMode is enumer=
ated by
> > > > > the host CPU (which is the case on most/all AMD CPUs). With
> > > > > IbrsSameMode, hardware IBRS is sufficient and no extra handling i=
s
> > > > > needed from KVM.
> > > > >
> > > > > Generalize the handling in nested_vmx_vmexit() by moving it into =
a
> > > > > generic function, add the AMD handling, and use it in
> > > > > nested_svm_vmexit() too. The main reason for using a generic func=
tion is
> > > > > to have a single place to park the huge comment about virtualizin=
g IBRS.
> > > > >
> > > > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > > ---
> > > > >  arch/x86/kvm/svm/nested.c |  2 ++
> > > > >  arch/x86/kvm/vmx/nested.c | 11 +----------
> > > > >  arch/x86/kvm/x86.h        | 18 ++++++++++++++++++
> > > > >  3 files changed, 21 insertions(+), 10 deletions(-)
> > > > >
> > > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.=
c
> > > > > index d77b094d9a4d6..61b73ff30807e 100644
> > > > > --- a/arch/x86/kvm/svm/nested.c
> > > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > > @@ -1041,6 +1041,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> > > > >
> > > > >         nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm-=
>vmcb01.ptr);
> > > > >
> > > > > +       kvm_nested_vmexit_handle_spec_ctrl(vcpu);
> > > > > +
> > > > >         svm_switch_vmcb(svm, &svm->vmcb01);
> > > > >
> > > > >         /*
> > > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.=
c
> > > > > index 8a7af02d466e9..453d52a6e836a 100644
> > > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > > @@ -5018,16 +5018,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vc=
pu, u32 vm_exit_reason,
> > > > >
> > > > >         vmx_switch_vmcs(vcpu, &vmx->vmcs01);
> > > > >
> > > > > -       /*
> > > > > -        * If IBRS is advertised to the vCPU, KVM must flush the =
indirect
> > > > > -        * branch predictors when transitioning from L2 to L1, as=
 L1 expects
> > > > > -        * hardware (KVM in this case) to provide separate predic=
tor modes.
> > > > > -        * Bare metal isolates VMX root (host) from VMX non-root =
(guest), but
> > > > > -        * doesn't isolate different VMCSs, i.e. in this case, do=
esn't provide
> > > > > -        * separate modes for L2 vs L1.
> > > > > -        */
> > > > > -       if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL))
> > > > > -               indirect_branch_prediction_barrier();
> > > > > +       kvm_nested_vmexit_handle_spec_ctrl(vcpu);
> > > > >
> > > > >         /* Update any VMCS fields that might have changed while L=
2 ran */
> > > > >         vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.ho=
st.nr);
> > > > > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > > > > index 7a87c5fc57f1b..008c8d381c253 100644
> > > > > --- a/arch/x86/kvm/x86.h
> > > > > +++ b/arch/x86/kvm/x86.h
> > > > > @@ -116,6 +116,24 @@ static inline void kvm_leave_nested(struct k=
vm_vcpu *vcpu)
> > > > >         kvm_x86_ops.nested_ops->leave_nested(vcpu);
> > > > >  }
> > > > >
> > > > > +/*
> > > > > + * If IBRS is advertised to the vCPU, KVM must flush the indirec=
t branch
> > > > > + * predictors when transitioning from L2 to L1, as L1 expects ha=
rdware (KVM in
> > > > > + * this case) to provide separate predictor modes.  Bare metal i=
solates the host
> > > > > + * from the guest, but doesn't isolate different guests from one=
 another (in
> > > > > + * this case L1 and L2). The exception is if bare metal supports=
 same mode IBRS,
> > > > > + * which offers protection within the same mode, and hence prote=
cts L1 from L2.
> > > > > + */
> > > > > +static inline void kvm_nested_vmexit_handle_spec_ctrl(struct kvm=
_vcpu *vcpu)
> > > >
> > > > Maybe just kvm_nested_vmexit_handle_ibrs?
> > >
> > > I was trying to use a generic name to accomodate any future handling
> > > needed for non-IBRS speculation control virtualization. But I could j=
ust
> > > be overthinking. Happy to take whatever name is agreed upon in during
> > > reviews.
> > >
> > > >
> > > > > +{
> > > > > +       if (cpu_feature_enabled(X86_FEATURE_AMD_IBRS_SAME_MODE))
> > > > > +               return;
> > > > > +
> > > > > +       if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
> > > > > +           guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBRS))
> > > >
> > > > This is a bit conservative, but I don't think there's any ROI in be=
ing
> > > > more pedantic.
> > >
> > > Could you elaborate on this?
> > >
> > > Is this about doing the IBPB even if L1 does not actually execute an
> > > IBRS? I thought about this for a bit, but otherwise we'd have to
> > > intercept the MSR write IIUC, and I am not sure if that's better. Als=
o,
> > > that's what we are already doing so I just kept it as-is.
> > >
> > > Or maybe about whether we need this on AMD only with AUTOIBRS? The AP=
M
> > > is a bit unclear to me in this regard, but I believe may be needed ev=
en
> > > for 'normal' IBRS.
> >
> > If IA32_SPEC_CTRL.IBRS is clear at emulated VM-exit, then this IBPB is
> > unnecessary.
> >
> > However, since the host (L1) is running in a de-privileged prediction
> > domain, simply setting IA32_SPEC_CTRL.IBRS in the future won't protect
> > it from the guest (L2) that just exited. If we don't eagerly perform
> > an IBPB now, then L0 would have to intercept WRMSR(IA32_SPEC_CTRL)
> > from L1 so that we can issue an IBPB in the future, if L1 ever sets
> > IA32_SPEC_CTRL.IBRS.
>
> Right, that's what I meant by "we'd have to intercept the MSR write"
> above, but I didn't put it as eloquently as you just did :)
>
> We'd also need to have different handling for eIBRS/AUTOIBRS. It would
> basically be:
>
> if eIBRS/AUTOIBRS is enabled by L1:
>   - Do not intercept IBRS MSR writes
>   - Always IBPB on emulated VM-exits (unless IbrsSameMode).
> else if IBRS is advertised to L1:
>   - Intercept IBRS MSR writes and do an IBPB.
>   - Do not IBPB on emulated VM-exits.
>
> We'd basically have two modes of IBRS virtualization and we'd need to
> switch between them at runtime according to L1's setting of
> eIBRS/AUTOIBRS.
>
> We can simplify it if we always intercept IBRS MSR writes assuming L1
> won't do them with eIBRS/AUTOIBRS anyway, so this becomes:
>
> - On emulated VM-exits, IBPB if eIBRS/AUTOIBRS is enabled (unless
>   IbrsSameMode).
> - On IBRS MSR writes, do an IBPB.
>
> Simpler, but not sure if it buys us much.
>
> >
> > Eagerly performing an IBPB now seems like the better option.
>
> So yeah I definitely agree, unless we get regression reports caused by
> the IBPB on emulated VM-exits, and the MSR write interception turns out
> to be an improvement.

For "normal" configurations, I would expect L1 to set eIBRS or
autoIBRS on modern CPUs. In that case, the IBPB is required. However,
if L1 is a Linux OS booted with mitigations=3Doff, the IBPB is probably
gratuitous.

On the Intel side, KVM tries to do some optimization of the case where
the guest doesn't use IA32_SPEC_CTRL. Since writes to IA32_SPEC_CTRL
are intercepted until the first non-zero value is written, I suppose
you could skip the IBPB when writes to IA32_SPEC_CTRL are intercepted,
and then just blindly perform an IBPB when disabling the intercept in
vmx_set_msr() if nested is enabled. Again, though, I don't think this
is worth it.

