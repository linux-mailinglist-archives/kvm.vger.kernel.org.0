Return-Path: <kvm+bounces-41004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67B08A602DD
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:41:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CD24422978
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 196F51F4630;
	Thu, 13 Mar 2025 20:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UyJcOFiv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E4442AA9
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 20:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741898481; cv=none; b=qBnl149+kwfSkS//C2RqBalUrZy/0Odxi0P53/CZvAw/HDhheyHqVPSJcQajT5fugBKftJh+oBxjYkDfz020uc5yzZzx77ge2RtFY8g5B5hRCAWMGgaTk+w2UA8kSGYWF92IC59XzQs2WV7LUdj9057odiIzHyAd8kBhERfIEj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741898481; c=relaxed/simple;
	bh=WfHbsVg+8+m6T3C4mOX76eMeT53HcQtAH3nNHYrMgYg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=svlQ8cQeMuFFZsJ12qeWhD1TZa2MwDbwMA2K6qg65XmYsk6xOwf5cetohReKjmZgNc2Pjl/d/Vok9BJKTXTt4+dUWMo1uQ3wQOHk8Kndo0lyTuTKY/ZRGhB4El3121/RrO6gOXQABRP/Ge47xZFjYKJ3euBOIVN0aZeAjKwPAQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UyJcOFiv; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4769e30af66so9381cf.1
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 13:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741898478; x=1742503278; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S1j2sAHUj+CAJ13I6BXoJ8vV/H9oFgTFSLh/3sfLmiA=;
        b=UyJcOFivQi7Y3pSz/4Iw1ARLhJmFTVbXYsw4dHwdT8MW4UbjbDr4vFMwNBkPZNZDP0
         JJ0TgjlvOMUDP9ZnRkbEGBkqtD1Lho+g51X7W0jQi7vi2S1ZXMweKaImdVndiGd8Jq9E
         2F7dssLqhMfcmFKhAMqm2KdblwU7KKetC+EVN0h+N5OhRS/s2+z3Qxh0WjNYy6LFQygr
         Zs7rnZLwEu/uxW519qoCICpBJ1txp5FFsWWNztx0Z3niz1+J/sMMfOEWpHc6jeyI+wZh
         8Y/SiHdHezVxHpVqUXn20Gi7MwNpoqywUJARYNNfuM/HsEQwHjIOqUsuJNf/b9NxMUAu
         1dcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741898478; x=1742503278;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S1j2sAHUj+CAJ13I6BXoJ8vV/H9oFgTFSLh/3sfLmiA=;
        b=N7Of9uZAGjBbLMOCBc88fdFZ97+VEmMGfsShvHC3hh+nXNxpvxTchEVoA8au3XXYbP
         yTi460AGPpcFNPB7pqj/YB0cNiNjm+/daR+WGysqfhaj29IRcWnATwNnd2imnTomq4a0
         BdVOuU3yvxYlMVzDC0SUBDGdUQxF4lB/hqnlCH3XctUJbUPzk3++NAIKMjQUk+d04rMJ
         jo+cZOEGRWIXmBQrGVDqksYnEEFVb++DaEbg6H0v2xA3ypc8B9hfRG4nr8fq5/sqESun
         wePEz4PHZ3PR2aotoXez4vQbgE11jZCTjywsCUzH2auX6WOSp/ayLM+FXc64IVvUa73l
         zx1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUP5FYisJP9Nb4aqjvWC+FBPeXjvlXH9xPcoEKLWgtdqE0/6BB0ckqs8MXfWrZrAKNgMgc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFEnlrQLiEfuDpk2S5/YZB+iRXw0BhqAKZKM+bONle3geLrkCq
	Pnl8wICFmUeU8P2AgbITfbPOOwrZZa97dLmXYYl5ktDfV/bsnrEiHXKHakdCW8JlbOpbSKkCSxJ
	mFmn9V+riNS5Ii07RTvgeEsK3McJXZCSR2+bO
X-Gm-Gg: ASbGnctWN71tc2lG/Ty7fHwz3E1U8p5iRIHaQs4o4Uhf2y7rwqALcsOd6pVbXoZb+V4
	/r+s2gLP2tiRZOgcKc6EGxddBLQ2lV9Ry9fjBUolYp1TQzZXPBytiYKyHw5BEYP8srjySXQd+5G
	ptnQz9ly2BtuniU4WF1LjKqwjsmg==
X-Google-Smtp-Source: AGHT+IEkDbvVLdBI5iEWTYlew9DQ2Vm6e10LsvWegkivoF4QHRu2jaKEVQjRTzgoB3g+OJM6L63CHzvoK4tQHB/mjOo=
X-Received: by 2002:ac8:5f4e:0:b0:474:f516:4572 with SMTP id
 d75a77b69052e-476c7fca78amr100941cf.13.1741898471300; Thu, 13 Mar 2025
 13:41:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250225004708.1001320-1-jmattson@google.com>
In-Reply-To: <20250225004708.1001320-1-jmattson@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 13 Mar 2025 13:40:54 -0700
X-Gm-Features: AQ5f1JoANgz5q--iL-vS2feHZw7NP7pSkRFNi-i96fZ44Vy-y4QZgtzctM_oxqw
Message-ID: <CALMp9eRHrEZX4-JWyGXNRvafU2dNbfa6ZjT5HhrDBYujGYEvaw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Provide a capability to disable APERF/MPERF
 read intercepts
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2025 at 4:47=E2=80=AFPM Jim Mattson <jmattson@google.com> w=
rote:
>
> Allow a guest to read the physical IA32_APERF and IA32_MPERF MSRs
> without interception.
>
> The IA32_APERF and IA32_MPERF MSRs are not virtualized. Writes are not
> handled at all. The MSR values are not zeroed on vCPU creation, saved
> on suspend, or restored on resume. No accommodation is made for
> processor migration or for sharing a logical processor with other
> tasks. No adjustments are made for non-unit TSC multipliers. The MSRs
> do not account for time the same way as the comparable PMU events,
> whether the PMU is virtualized by the traditional emulation method or
> the new mediated pass-through approach.
>
> Nonetheless, in a properly constrained environment, this capability
> can be combined with a guest CPUID table that advertises support for
> CPUID.6:ECX.APERFMPERF[bit 0] to induce a Linux guest to report the
> effective physical CPU frequency in /proc/cpuinfo. Moreover, there is
> no performance cost for this capability.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  Documentation/virt/kvm/api.rst  | 1 +
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm/svm.c          | 7 +++++++
>  arch/x86/kvm/svm/svm.h          | 2 +-
>  arch/x86/kvm/vmx/vmx.c          | 4 ++++
>  arch/x86/kvm/x86.c              | 7 +++++--
>  arch/x86/kvm/x86.h              | 5 +++++
>  include/uapi/linux/kvm.h        | 1 +
>  tools/include/uapi/linux/kvm.h  | 4 +++-
>  9 files changed, 28 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 2b52eb77e29c..6431cd33f06a 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7684,6 +7684,7 @@ Valid bits in args[0] are::
>    #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
>    #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
>    #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
> +  #define KVM_X86_DISABLE_EXITS_APERFMPERF       (1 << 4)
>
>  Enabling this capability on a VM provides userspace with a way to no
>  longer intercept some instructions for improved latency in some
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 0b7af5902ff7..53de91fccc20 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1380,6 +1380,7 @@ struct kvm_arch {
>         bool hlt_in_guest;
>         bool pause_in_guest;
>         bool cstate_in_guest;
> +       bool aperfmperf_in_guest;
>
>         unsigned long irq_sources_bitmap;
>         s64 kvmclock_offset;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a713c803a3a3..5ebcbff341bc 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -111,6 +111,8 @@ static const struct svm_direct_access_msrs {
>         { .index =3D MSR_IA32_CR_PAT,                     .always =3D fal=
se },
>         { .index =3D MSR_AMD64_SEV_ES_GHCB,               .always =3D tru=
e  },
>         { .index =3D MSR_TSC_AUX,                         .always =3D fal=
se },
> +       { .index =3D MSR_IA32_APERF,                      .always =3D fal=
se },
> +       { .index =3D MSR_IA32_MPERF,                      .always =3D fal=
se },
>         { .index =3D X2APIC_MSR(APIC_ID),                 .always =3D fal=
se },
>         { .index =3D X2APIC_MSR(APIC_LVR),                .always =3D fal=
se },
>         { .index =3D X2APIC_MSR(APIC_TASKPRI),            .always =3D fal=
se },
> @@ -1359,6 +1361,11 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>         if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>                 set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL=
, 1, 1);
>
> +       if (kvm_aperfmperf_in_guest(vcpu->kvm)) {
> +               set_msr_interception(vcpu, svm->msrpm, MSR_IA32_APERF, 1,=
 0);
> +               set_msr_interception(vcpu, svm->msrpm, MSR_IA32_MPERF, 1,=
 0);
> +       }
> +
>         if (kvm_vcpu_apicv_active(vcpu))
>                 avic_init_vmcb(svm, vmcb);
>
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 9d7cdb8fbf87..3ee2b7e07395 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -44,7 +44,7 @@ static inline struct page *__sme_pa_to_page(unsigned lo=
ng pa)
>  #define        IOPM_SIZE PAGE_SIZE * 3
>  #define        MSRPM_SIZE PAGE_SIZE * 2
>
> -#define MAX_DIRECT_ACCESS_MSRS 48
> +#define MAX_DIRECT_ACCESS_MSRS 50
>  #define MSRPM_OFFSETS  32
>  extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6c56d5235f0f..88a555328932 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7597,6 +7597,10 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>                 vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY=
, MSR_TYPE_R);
>                 vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY=
, MSR_TYPE_R);
>         }
> +       if (kvm_aperfmperf_in_guest(vcpu->kvm)) {
> +               vmx_disable_intercept_for_msr(vcpu, MSR_IA32_APERF, MSR_T=
YPE_R);
> +               vmx_disable_intercept_for_msr(vcpu, MSR_IA32_MPERF, MSR_T=
YPE_R);
> +       }
>
>         vmx->loaded_vmcs =3D &vmx->vmcs01;
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 02159c967d29..98f3df24ac9a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4533,7 +4533,7 @@ static inline bool kvm_can_mwait_in_guest(void)
>
>  static u64 kvm_get_allowed_disable_exits(void)
>  {
> -       u64 r =3D KVM_X86_DISABLE_EXITS_PAUSE;
> +       u64 r =3D KVM_X86_DISABLE_EXITS_PAUSE | KVM_X86_DISABLE_EXITS_APE=
RFMPERF;
>
>         if (!mitigate_smt_rsb) {
>                 r |=3D KVM_X86_DISABLE_EXITS_HLT |
> @@ -6543,7 +6543,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>
>                 if (!mitigate_smt_rsb && boot_cpu_has_bug(X86_BUG_SMT_RSB=
) &&
>                     cpu_smt_possible() &&
> -                   (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
> +                   (cap->args[0] & ~(KVM_X86_DISABLE_EXITS_PAUSE |
> +                                     KVM_X86_DISABLE_EXITS_APERFMPERF)))
>                         pr_warn_once(SMT_RSB_MSG);
>
>                 if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
> @@ -6554,6 +6555,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                         kvm->arch.hlt_in_guest =3D true;
>                 if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
>                         kvm->arch.cstate_in_guest =3D true;
> +               if (cap->args[0] & KVM_X86_DISABLE_EXITS_APERFMPERF)
> +                       kvm->arch.aperfmperf_in_guest =3D true;
>                 r =3D 0;
>  disable_exits_unlock:
>                 mutex_unlock(&kvm->lock);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 91e50a513100..0c3ac99454e5 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -488,6 +488,11 @@ static inline bool kvm_cstate_in_guest(struct kvm *k=
vm)
>         return kvm->arch.cstate_in_guest;
>  }
>
> +static inline bool kvm_aperfmperf_in_guest(struct kvm *kvm)
> +{
> +       return kvm->arch.aperfmperf_in_guest;
> +}
> +
>  static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
>  {
>         return kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_ENAB=
LED;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 45e6d8fca9b9..b4a4eb52f6df 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -617,6 +617,7 @@ struct kvm_ioeventfd {
>  #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
>  #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
>  #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
> +#define KVM_X86_DISABLE_EXITS_APERFMPERF     (1 << 4)
>
>  /* for KVM_ENABLE_CAP */
>  struct kvm_enable_cap {
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kv=
m.h
> index 502ea63b5d2e..9b60f0509cdc 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -617,10 +617,12 @@ struct kvm_ioeventfd {
>  #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
>  #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
>  #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
> +#define KVM_X86_DISABLE_EXITS_APERFMPERF     (1 << 4)
>  #define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAI=
T | \
>                                                KVM_X86_DISABLE_EXITS_HLT =
| \
>                                                KVM_X86_DISABLE_EXITS_PAUS=
E | \
> -                                              KVM_X86_DISABLE_EXITS_CSTA=
TE)
> +                                             KVM_X86_DISABLE_EXITS_CSTAT=
E | \
> +                                             KVM_X86_DISABLE_EXITS_APERF=
MPERF)
>
>  /* for KVM_ENABLE_CAP */
>  struct kvm_enable_cap {
> --
> 2.48.1.658.g4767266eb4-goog
>

Ping.

Any thoughts?

