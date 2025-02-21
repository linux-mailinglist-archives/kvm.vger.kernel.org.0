Return-Path: <kvm+bounces-38882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 432B2A3FE0D
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 18:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FC8B164DDB
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 17:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8C1250C08;
	Fri, 21 Feb 2025 17:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KiIJ90zM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF15824F599
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 17:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740160761; cv=none; b=dcrZh7b3P7z2Q3hGFJOj7viKeKBGesB+obRCv68z8F3bKu9SKb4Us0bmKucYRjdttLSOMthvnvDw3PzWq9GXoQgzVYz8PvBu0cj78qu7sm+Sjf24A9iXJR5sSc7QyM8ewUNo3k5i8zOTldb9X1n5/zHBn2syRn26DsiGQYG9UIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740160761; c=relaxed/simple;
	bh=CyMlJMe49dtCI1C7oW6yHzdSBo+lOci8YsZ/sxkb6c4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H0yG9E+XSmLjrQnE0LOCh/lp/Yxld93Z/Cxs6aA0CKz571rsv4TguUk+hEAHorz+uzuCbx4Iww6kEtrJbSOdi0bu8K+k+zdWLJNyzU0DqqA0+LTkpJwmiWhjJMiIvoKS+tSqPVvBRd+0iBgiKQVnOq8+Xr6YT1gTI024XDPYkqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KiIJ90zM; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d19702f977so3045ab.1
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 09:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740160758; x=1740765558; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CFPr39VkmmOxeSrSHJh0/Wu5Z4JXTxhJP6/WQ8TPNMw=;
        b=KiIJ90zMvWd0nTfAHa2DEiglD6YWIjY8/aAykBP/qOPFubclplTB7aPaJUh7N5O40p
         XcAemYZsfWxwrO7CDtzr6PVYplXnXtUI24LdSZof86qmn3XRYCrnln5IvyS5k2Nz0q0S
         FncQy1VNlXZqe3ICzxaCEjruUFCjyMUHXTa6oBTSP2zfbJvajtgOJFPxXyg/plaVr5x3
         6iB8zxIRHp8agPLBa3ft9WOgA55BU1mAa7h2CcMS9g4SvLqg30sjrACs7Agdo94q1+yN
         Nr06qv8LTn+LiGrunFoA7sCaUEuwuwnUf2xPFOCBenuzL2fcOYaxH3/3UJD88VDVBxDl
         4lmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740160758; x=1740765558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CFPr39VkmmOxeSrSHJh0/Wu5Z4JXTxhJP6/WQ8TPNMw=;
        b=YHit55RT8445PWVCVZRb4SdmIknkLUdXQgMnZV+YlNKo8UHBfsfQLVxpLVtWqto/qt
         YMuxQho7MkbrGnLJOsjqaila7rhfwN2ZhcV2MUoZnWeOrSFa4aLLRlOub7wPqsWo2829
         JgEo0kMOWynuOIdHyN5e+Vc88CsZH4b2X3KsIi7TIQcRcYh06WDrsiTqQ5jErQHyGDmK
         PqIyQqt6T5qKYAqpfAD3RUWWK/rrcPRrkllPyNMoCMS2+ZsJRC9Kr9Y0zoaxJAbDGtXl
         ByEQXv3bkFwzIvCNj4SlMizCIDrfwAga4p7a7pArvpnp3LSMQuBO2mgwhJYsf3IeNMHA
         Xgkw==
X-Forwarded-Encrypted: i=1; AJvYcCUfURkpLSEzqYmgKQ4JcyNY4TP3JQnbG7lW9oIgdxplk8FnfPpxsliRGHhesVs2SXc2/rE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrMW21TS7+iAlRRo1GlMzDgHCuYnMidRUYg4lWxLPdMbfViX8r
	HMc7VXHcbg6KUydRR1e1I5fXIX1Wc3S6lonzPLYexHXfS8t8Ybx7WCvdCbx2NwbknaaZhvHHbuh
	ir5jCgeDE2L2/YzQh7FIZMorb2QIxBE7V4XKo
X-Gm-Gg: ASbGncuC2pbFupurqZHYiVVIzuNWvOe+M4qfg8cI5xrpT1wTym1V4T6PRx8ZfUFJq+B
	D1D256U/N8mv8xhrleCukxuZAQNntw/kfirHiEaKSStFRVEbnP0rJiJvj7caNkescdTWXum80Sj
	XloXaNr48=
X-Google-Smtp-Source: AGHT+IFnOum0ttM4Vesa4j7BS4V1b1HS+JdyQLXvhh94IUPbFFJZJtKhFR7C2WnWnWLciQ4OgC/AGEzv5ut3LKeZKto=
X-Received: by 2002:a92:c26d:0:b0:3a7:a468:69df with SMTP id
 e9e14a558f8ab-3d2cc651b7bmr3185285ab.3.1740160757626; Fri, 21 Feb 2025
 09:59:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250221163352.3818347-1-yosry.ahmed@linux.dev> <20250221163352.3818347-4-yosry.ahmed@linux.dev>
In-Reply-To: <20250221163352.3818347-4-yosry.ahmed@linux.dev>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 21 Feb 2025 09:59:04 -0800
X-Gm-Features: AWEUYZkxFQiGf-_lxDEUzcA7SqwrlvLQH5PgX1Cfgm8nfiHstooh97YlLZePtUM
Message-ID: <CALMp9eSPVDYC7v4Rm13ZUcE4wWPb8dUfm=qBx_jETAQEQrt4_w@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86: Generalize IBRS virtualization on emulated VM-exit
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: x86@kernel.org, Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kaplan, David" <David.Kaplan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2025 at 8:34=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> Commit 2e7eab81425a ("KVM: VMX: Execute IBPB on emulated VM-exit when
> guest has IBRS") added an IBPB in the emulated VM-exit path on Intel to
> properly virtualize IBRS by providing separate predictor modes for L1
> and L2.
>
> AMD requires similar handling, except when IbrsSameMode is enumerated by
> the host CPU (which is the case on most/all AMD CPUs). With
> IbrsSameMode, hardware IBRS is sufficient and no extra handling is
> needed from KVM.
>
> Generalize the handling in nested_vmx_vmexit() by moving it into a
> generic function, add the AMD handling, and use it in
> nested_svm_vmexit() too. The main reason for using a generic function is
> to have a single place to park the huge comment about virtualizing IBRS.
>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c |  2 ++
>  arch/x86/kvm/vmx/nested.c | 11 +----------
>  arch/x86/kvm/x86.h        | 18 ++++++++++++++++++
>  3 files changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index d77b094d9a4d6..61b73ff30807e 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1041,6 +1041,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>
>         nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.=
ptr);
>
> +       kvm_nested_vmexit_handle_spec_ctrl(vcpu);
> +
>         svm_switch_vmcb(svm, &svm->vmcb01);
>
>         /*
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 8a7af02d466e9..453d52a6e836a 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5018,16 +5018,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 =
vm_exit_reason,
>
>         vmx_switch_vmcs(vcpu, &vmx->vmcs01);
>
> -       /*
> -        * If IBRS is advertised to the vCPU, KVM must flush the indirect
> -        * branch predictors when transitioning from L2 to L1, as L1 expe=
cts
> -        * hardware (KVM in this case) to provide separate predictor mode=
s.
> -        * Bare metal isolates VMX root (host) from VMX non-root (guest),=
 but
> -        * doesn't isolate different VMCSs, i.e. in this case, doesn't pr=
ovide
> -        * separate modes for L2 vs L1.
> -        */
> -       if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL))
> -               indirect_branch_prediction_barrier();
> +       kvm_nested_vmexit_handle_spec_ctrl(vcpu);
>
>         /* Update any VMCS fields that might have changed while L2 ran */
>         vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 7a87c5fc57f1b..008c8d381c253 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -116,6 +116,24 @@ static inline void kvm_leave_nested(struct kvm_vcpu =
*vcpu)
>         kvm_x86_ops.nested_ops->leave_nested(vcpu);
>  }
>
> +/*
> + * If IBRS is advertised to the vCPU, KVM must flush the indirect branch
> + * predictors when transitioning from L2 to L1, as L1 expects hardware (=
KVM in
> + * this case) to provide separate predictor modes.  Bare metal isolates =
the host
> + * from the guest, but doesn't isolate different guests from one another=
 (in
> + * this case L1 and L2). The exception is if bare metal supports same mo=
de IBRS,
> + * which offers protection within the same mode, and hence protects L1 f=
rom L2.
> + */
> +static inline void kvm_nested_vmexit_handle_spec_ctrl(struct kvm_vcpu *v=
cpu)

Maybe just kvm_nested_vmexit_handle_ibrs?

> +{
> +       if (cpu_feature_enabled(X86_FEATURE_AMD_IBRS_SAME_MODE))
> +               return;
> +
> +       if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
> +           guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBRS))

This is a bit conservative, but I don't think there's any ROI in being
more pedantic.

For the series,

Reviewed-by: Jim Mattson <jmattson@google.com>

> +               indirect_branch_prediction_barrier();
> +}
> +
>  static inline bool kvm_vcpu_has_run(struct kvm_vcpu *vcpu)
>  {
>         return vcpu->arch.last_vmentry_cpu !=3D -1;
> --
> 2.48.1.601.g30ceb7b040-goog
>

