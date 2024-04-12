Return-Path: <kvm+bounces-14381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E3E58A2518
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 06:23:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B6E3B22ED2
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 04:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74ABA199B0;
	Fri, 12 Apr 2024 04:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J2wf9glL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05E317C96
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 04:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712895777; cv=none; b=AT89nReP/jUKyc6mYGFSmVpgWFmgFi64MMhtVe24t0Qm7QNQxYsquyaSfQBw75NmvJkI5m4lLNcA9lrIzS8d4Ny5LnGn6doiSsKQBe2MU4PaZipfxe3+J+mI+CHB+neLKsrVezVBLeWyzLtjW6NXmBIcIKnhkLvR8jqV5JFwac4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712895777; c=relaxed/simple;
	bh=Ai1IPvil9uFM7PRJoDG9vVMucXOoOd/UrrPNDCt/9Nc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UwtzK1lCT/ynTryD+3W56s5dukbrqQ9wDSgMYJtXRf0Cr11bllDriUCN3ddW6I2+jWCdGrbQLultgH+Ck+U2rCPKyRTN6pKAkIq9G8JEPU6vOZAHL1bnX1u2192DEnu1fOvM+JtXjsn0HIkYDkFGjOkWopAVSrOhS8CzndY3lpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J2wf9glL; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-56fe56d4d9cso5284a12.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 21:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712895774; x=1713500574; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S4lta18S1kYp4kd8Rq2W8Lhel8YYapEdSI0oTgvOWvc=;
        b=J2wf9glLkBwH030lrChzFwS2uVvkjXST7kv08JUwYg4FaY+BpVDFE9A2vytRq24cbe
         2euRX0FdpkFIudRWvAEK5suD7Wx3b4r0xx4Q/mb38ihuExFZhBI1sTDmBuYD5KKgx5s6
         kwOPmnkG+aaIIBMhQJawbGKTExIvcSe8/eUNuPZFasPw8Zmv5i7rR4IbtxWS9UIo8vQt
         +CPn+d0BF2kfJkk505Roo000BcNegcB5kYSTK08Z9ppSGzKCtQ7giqvEttMXd2GksqB+
         UDElzJihNj+luDmHSWTt8/aZt7UddwndUOSXfAp3p/aJtUH7DNIgHVUsmPuMKSxB33iE
         mgxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712895774; x=1713500574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S4lta18S1kYp4kd8Rq2W8Lhel8YYapEdSI0oTgvOWvc=;
        b=vXy34bsSSh1uxF3Zj/Zt+RVXTW3+3PQ2F8tBkOU0lu7ZcTp8to9xZ7Vrl/8R0h+2s4
         2AXRFuqQSIWPcv8Gd2rFFwPfTUq3T1byuwRJm5EXgVozb7llVjeL77qSexFwGiVOjNFP
         vsVkg/Ff7PYlMTMKg/UFWzDO/bRSpyiTPQc3cqtD5SKQpV4BTbAAjTnHwuWAeXJjONsR
         uuNGhQOyZ4VCdhXQYWo7S6nWMe/raU1EoanzXr13bl03VD/SS08U/sRQLwjuTMwAy4h8
         zGDN4MxjhEsP/x1/Wcvmt+4wY3sax1je7rHzCjN86iC9KKkT25kUJHPHlpYzVnfA+niC
         huaA==
X-Gm-Message-State: AOJu0YzwuiVxOa5DLUGsS5eXUV1kPLkGVq/G+tMe9kvsZohYIdxHiTHz
	mn8TRW6nA/xBpXu3i+askHjJW+89B6glCBo2fQY+g5n9nuRpx7+PQk4CmoewSisAKTF3GTjkdQC
	B3KvJXWKvSLAc/4/aF7iefZjnEBPvw1f6A2OoMxKhigMSEDfODR5n
X-Google-Smtp-Source: AGHT+IF6TYWnLEHf+hAivZTJGiZA02FnbcHsJtHyNiawNN6RUD1YB1DYClLRFL6piun2RmeVAf/dgNyppY5qk1lW0ag=
X-Received: by 2002:aa7:df8c:0:b0:56e:34de:69c1 with SMTP id
 b12-20020aa7df8c000000b0056e34de69c1mr100971edy.4.1712895773711; Thu, 11 Apr
 2024 21:22:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240410143446.797262-1-chao.gao@intel.com> <20240410143446.797262-8-chao.gao@intel.com>
In-Reply-To: <20240410143446.797262-8-chao.gao@intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 11 Apr 2024 21:22:40 -0700
Message-ID: <CALMp9eQwDJfioseiWinHN8fJSb-nrs8Eq_YezX7y+q3HEaX77Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 07/10] KVM: x86: Advertise ARCH_CAP_VIRTUAL_ENUM support
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com, 
	Zhang Chen <chen.zhang@intel.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 10, 2024 at 8:08=E2=80=AFAM Chao Gao <chao.gao@intel.com> wrote=
:
>
> From: Zhang Chen <chen.zhang@intel.com>
>
> Bit 63 of IA32_ARCH_CAPABILITIES MSR indicates availablility of the
> VIRTUAL_ENUMERATION_MSR (index 0x50000000) which enumerates features
> like e.g., mitigation enumeration that in turn is used for the guest to
> report software mitigations it is using.
>
> Advertise ARCH_CAP_VIRTUAL_ENUM support for VMX and emulate read/write
> of the VIRTUAL_ENUMERATION_MSR. Now VIRTUAL_ENUMERATION_MSR is always 0.
>
> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
> Co-developed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>  arch/x86/kvm/svm/svm.c |  1 +
>  arch/x86/kvm/vmx/vmx.c | 19 +++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.h |  2 ++
>  arch/x86/kvm/x86.c     | 16 +++++++++++++++-
>  4 files changed, 37 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d1a9f9951635..e3406971a8b7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4288,6 +4288,7 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u=
32 index)
>  {
>         switch (index) {
>         case MSR_IA32_MCG_EXT_CTL:
> +       case MSR_VIRTUAL_ENUMERATION:
>         case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
>                 return false;
>         case MSR_IA32_SMBASE:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cdfcc1290d82..dcb06406fd09 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1955,6 +1955,8 @@ static inline bool is_vmx_feature_control_msr_valid=
(struct vcpu_vmx *vmx,
>         return !(msr->data & ~valid_bits);
>  }
>
> +#define VIRTUAL_ENUMERATION_VALID_BITS 0ULL
> +
>  static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>  {
>         switch (msr->index) {
> @@ -1962,6 +1964,9 @@ static int vmx_get_msr_feature(struct kvm_msr_entry=
 *msr)
>                 if (!nested)
>                         return 1;
>                 return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &=
msr->data);
> +       case MSR_VIRTUAL_ENUMERATION:
> +               msr->data =3D VIRTUAL_ENUMERATION_VALID_BITS;
> +               return 0;
>         default:
>                 return KVM_MSR_RET_INVALID;
>         }
> @@ -2113,6 +2118,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
>         case MSR_IA32_DEBUGCTLMSR:
>                 msr_info->data =3D vmcs_read64(GUEST_IA32_DEBUGCTL);
>                 break;
> +       case MSR_VIRTUAL_ENUMERATION:
> +               if (!msr_info->host_initiated &&
> +                   !(vcpu->arch.arch_capabilities & ARCH_CAP_VIRTUAL_ENU=
M))
> +                       return 1;
> +               msr_info->data =3D vmx->msr_virtual_enumeration;
> +               break;
>         default:
>         find_uret_msr:
>                 msr =3D vmx_find_uret_msr(vmx, msr_info->index);
> @@ -2457,6 +2468,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
>                 }
>                 ret =3D kvm_set_msr_common(vcpu, msr_info);
>                 break;
> +       case MSR_VIRTUAL_ENUMERATION:
> +               if (!msr_info->host_initiated)
> +                       return 1;
> +               if (data & ~VIRTUAL_ENUMERATION_VALID_BITS)
> +                       return 1;
> +
> +               vmx->msr_virtual_enumeration =3D data;
> +               break;
>
>         default:
>         find_uret_msr:
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index a4dfe538e5a8..0519cf6187ac 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -294,6 +294,8 @@ struct vcpu_vmx {
>         u64                   force_spec_ctrl_mask;
>         u64                   force_spec_ctrl_value;
>
> +       u64                   msr_virtual_enumeration;
> +
>         u32                   msr_ia32_umwait_control;
>
>         /*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9a59b5a93d0e..4721b6fe7641 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1564,6 +1564,7 @@ static const u32 emulated_msrs_all[] =3D {
>
>         MSR_K7_HWCR,
>         MSR_KVM_POLL_CONTROL,
> +       MSR_VIRTUAL_ENUMERATION,
>  };
>
>  static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
> @@ -1579,6 +1580,7 @@ static const u32 msr_based_features_all_except_vmx[=
] =3D {
>         MSR_IA32_UCODE_REV,
>         MSR_IA32_ARCH_CAPABILITIES,
>         MSR_IA32_PERF_CAPABILITIES,
> +       MSR_VIRTUAL_ENUMERATION,
>  };
>
>  static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all_except_v=
mx) +
> @@ -1621,7 +1623,8 @@ static bool kvm_is_immutable_feature_msr(u32 msr)
>          ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_N=
O | \
>          ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
>          ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO | ARCH_CA=
P_GDS_NO | \
> -        ARCH_CAP_RFDS_NO | ARCH_CAP_RFDS_CLEAR | ARCH_CAP_BHI_NO)
> +        ARCH_CAP_RFDS_NO | ARCH_CAP_RFDS_CLEAR | ARCH_CAP_BHI_NO | \
> +        ARCH_CAP_VIRTUAL_ENUM)
>
>  static u64 kvm_get_arch_capabilities(void)
>  {
> @@ -1635,6 +1638,17 @@ static u64 kvm_get_arch_capabilities(void)
>          */
>         data |=3D ARCH_CAP_PSCHANGE_MC_NO;
>
> +       /*
> +        * Virtual enumeration is a paravirt feature. The only usage for =
now
> +        * is to bridge the gap caused by microarchitecture changes betwe=
en
> +        * different Intel processors. And its usage is linked to "virtua=
lize
> +        * IA32_SPEC_CTRL" which is a VMX feature. Whether AMD SVM can be=
nefit
> +        * from the same usage and how to implement it is still unclear. =
Limit
> +        * virtual enumeration to VMX.
> +        */

Virtualize IA32_SPEC_CTRL has been an SVM feature for years. See
https://lore.kernel.org/kvm/160738054169.28590.5171339079028237631.stgit@bm=
oger-ubuntu/.

> +       if (static_call(kvm_x86_has_emulated_msr)(NULL, MSR_VIRTUAL_ENUME=
RATION))
> +               data |=3D ARCH_CAP_VIRTUAL_ENUM;
> +
>         /*
>          * If we're doing cache flushes (either "always" or "cond")
>          * we will do one whenever the guest does a vmlaunch/vmresume.
> --
> 2.39.3
>
>

