Return-Path: <kvm+bounces-67385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B2897D03549
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 15:26:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AE02B3009223
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 14:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22FEC4A8F73;
	Thu,  8 Jan 2026 14:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EJehrLmG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827774A5B17
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 14:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881426; cv=pass; b=GydaWDFg4DmuKTQSmq8jEhgtnJ0/H6uvlZAefCWf1I7ohKvRAXlY7OejybJn49EceYAK6FY7eVsDYemTUmXawVIUZD6OLyH+l0Jh1DA4c4AXNH7QvsNZNfhTV1TWidv7ygjctGEJ7/F3HrQIed5FLlnvT2IYvB8N9YLXVpGIfjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881426; c=relaxed/simple;
	bh=fqIKEGVdrdDwWR5GKD0/DnIsXWNq4kTzHRbVfGW+jJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TIsdEQeEdaZ++RpO/q79I3nUipnl+D2uuhiNxmOc+zIZrgOj3U+zAeAuetRZ/2XcjEPzbgfzRnbDLWf4Vx8+WrOD9PxmD3UO5DHgHuPVytWYklJUJJtfI9/qSLiWu8y6c0L/MosZZzI3+23WN/tk1ByVQCyDRBp4REPfCh02wr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EJehrLmG; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ffbaaafac4so743091cf.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 06:10:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767881423; cv=none;
        d=google.com; s=arc-20240605;
        b=P/vnvGUVjK19+ncUwHYRnqPH78r5Gf7V15zcXg8U/9gP232sFU+p3olPICyxJvG9gf
         M0af7Y9fDBEtx8MDte0YIgb8ZDrm7DG8sJ/A3s2mzk3YMk808x/LoAAW2ErAdAjZMKlv
         xs0yGkhtHnthVzCGDHqU5OWlFveFtP0Xvy8OmAayLYpYrjdCg6eqPhgvpCzN/vAsrTk0
         P+wFonSqvEW6+rBe9BEA3EXh2lfb1J0B0INhhTfhc+ubmGVrFRaTmevQG2SEmkvM0SgQ
         S/knJ3VTTNWNLEWZFlrB2Dp6G/426M+z8RqxAvbd1iPZpQxD0UQcmNVh0mE5/pfD+I7v
         N02w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NaZEGS72KLSqcxT/8N5H1mx02StcfqZHeuPXe2e7POg=;
        fh=T8C3EJCIWTchMT38ltW3FlLXQM1IxcQBjwH7pHKMq6A=;
        b=GI+t2WYDZDKBIAdynA03zczEo2qul+9mJR0kMpQWlQWDaakbU1g0LHdg0iryMcZt1h
         QRNUWIIEU35vzdGuEPIwtCImFZmmbvoNlIWO9GYXLsKVtREEaByAb42EKyd/O8v0iv+w
         5S7z2NbzupxNsB/sNSMDX9nMOVx9jn/TUEsItDt94nOdrwMgnV/cXHRUC6bd6/J/a1tZ
         irUD1dUy1xN/FQJzirrZVscoU2NWaEc0K7Pf6UDcDjxgpHSNRdNJb7chidxuO/6+gu3A
         AjYB9sNKVdnPnx0toZ7P6x2bA/q4bDXent/GXwquVqP2gk7X7D+SWlz9GFC08/+dss2Y
         q8pA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767881423; x=1768486223; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NaZEGS72KLSqcxT/8N5H1mx02StcfqZHeuPXe2e7POg=;
        b=EJehrLmGVBdJ8xjO7wCBNPGGHCIDyqSfyF0nUdUeicZOzj4iIUUhfxqYt7RqrNWc1P
         UPLloSiW1ZSpb/O4ugOsDWC+0FllVmFUSxHZNHmcKEgYPLwoGQdUYHaydqyWHPDVTP9l
         J6Uu/D8sxBVp6JFHCq7ETy4GJ2xYEbaR39pF501c34iTfE3oSF1fYho3W1C6q0ZQGQga
         j5mioPq1wxSs+taAMifaYy6tSHT5quBNSpWE9fNw59LkysIwR1z0YCkzg0vPGrYusTTS
         CuzmgcE5OGX8Z6Vig5a8ovbiDJmjwTy0x3pxX3MHCdomtcME8TRLeYwfF2W9AWkNk1sD
         /Qzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881423; x=1768486223;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NaZEGS72KLSqcxT/8N5H1mx02StcfqZHeuPXe2e7POg=;
        b=ooWfW7t11UmV4KMfpP6t8WNhVd+1Kp+8wARbmzeqikTKXVAtqcpfeZeJFzbGO4jph8
         6XO2uuSUPBTyct8MOKfR4GDt3BmLi1FKjs+pbX3sg7U8EwDl/pz2RV2M+RhinOlWn9nT
         Mmgc59vXumbKfIyN3YDWs/Y7o0R8fkUUQ3SRxf3qqo9rAoHBoWy2VChL4g1lQCQ91kxV
         CM6S9p6dc9lGmRmExDMVagJ9pUtKNM8Qc6Xe7ZjxaFZChirDP223md3UZqCFszf4srK4
         vedcc5RO1yya8tP+xxBYXCBfL5pB5zqSARyCxMUSliT4Wl/K7e9764I/REUG7cWBb1vK
         BEGQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5QRmkjVWQ4DfA4PgPDxkFi5RJVJEZYZJ33BqMJjlZkPAkGh8Mm0/d70JhAksZxzK7JPA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzy2yZTZgMikOojx2yv2h7ca5E5dwnlGitL9E23IapWzpeZ/rwv
	1VUvCYMRX1f0MhsmgTpe15Baxm01a0dlXzyxRB0yGuI/86sm1KHDi2MCcvpGH6XjUcGasaABa50
	B3n/PXhLXT7vdZXTLsGN5OLAwyt32rGPIznSoaMOD
X-Gm-Gg: AY/fxX5X8uDE2cin4g05RANXnIfKd6pyfSg6vAaskgWR6xL1Y493AkJN2NlApnx3ghx
	Eyt29w4dM/hU2D+W9IYJ01C0IGCc9RiY1/rlZLL/bvOEroE9BEPdk20ejLEykx9v6sXKSydCPeu
	D9I5Xk+k9MWAI0hbJonvktEMxzWp7hCw4Li+dXvys+uVVu9dTnCAaCnMH1aEFfDTJPclHPSognW
	mKFvpAFjwQ9eHPCOuePvnWyVAqKYmCKQ5A70ssJ+6YTKNrjKl/vMwZEkPaYVO40yd0eI81n
X-Received: by 2002:ac8:574f:0:b0:4f1:9c6e:cf1c with SMTP id
 d75a77b69052e-4ffc0997e9emr8640981cf.17.1767881422911; Thu, 08 Jan 2026
 06:10:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-7-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-7-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 8 Jan 2026 14:09:46 +0000
X-Gm-Features: AQt7F2pJrrFIu8j-RnjtZsOw-SyaBAdPJA09Q8QxhF8SmvfGBU7bWTwW9oJJhUU
Message-ID: <CA+EHjTzTjaZoGQzivOSd97Z9VzySOAM=Qvye0p-R5rzUDwrSFw@mail.gmail.com>
Subject: Re: [PATCH v9 07/30] KVM: arm64: Pull ctxt_has_ helpers to start of sysreg-sr.h
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> Rather than add earlier prototypes of specific ctxt_has_ helpers let's just
> pull all their definitions to the top of sysreg-sr.h so they're all
> available to all the individual save/restore functions.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 84 +++++++++++++++---------------
>  1 file changed, 41 insertions(+), 43 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index a17cbe7582de..5624fd705ae3 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -16,8 +16,6 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>
> -static inline bool ctxt_has_s1poe(struct kvm_cpu_context *ctxt);
> -
>  static inline struct kvm_vcpu *ctxt_to_vcpu(struct kvm_cpu_context *ctxt)
>  {
>         struct kvm_vcpu *vcpu = ctxt->__hyp_running_vcpu;
> @@ -28,47 +26,6 @@ static inline struct kvm_vcpu *ctxt_to_vcpu(struct kvm_cpu_context *ctxt)
>         return vcpu;
>  }
>
> -static inline bool ctxt_is_guest(struct kvm_cpu_context *ctxt)
> -{
> -       return host_data_ptr(host_ctxt) != ctxt;
> -}
> -
> -static inline u64 *ctxt_mdscr_el1(struct kvm_cpu_context *ctxt)
> -{
> -       struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
> -
> -       if (ctxt_is_guest(ctxt) && kvm_host_owns_debug_regs(vcpu))
> -               return &vcpu->arch.external_mdscr_el1;
> -
> -       return &ctxt_sys_reg(ctxt, MDSCR_EL1);
> -}
> -
> -static inline u64 ctxt_midr_el1(struct kvm_cpu_context *ctxt)
> -{
> -       struct kvm *kvm = kern_hyp_va(ctxt_to_vcpu(ctxt)->kvm);
> -
> -       if (!(ctxt_is_guest(ctxt) &&
> -             test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &kvm->arch.flags)))
> -               return read_cpuid_id();
> -
> -       return kvm_read_vm_id_reg(kvm, SYS_MIDR_EL1);
> -}
> -
> -static inline void __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
> -{
> -       *ctxt_mdscr_el1(ctxt)   = read_sysreg(mdscr_el1);
> -
> -       // POR_EL0 can affect uaccess, so must be saved/restored early.
> -       if (ctxt_has_s1poe(ctxt))
> -               ctxt_sys_reg(ctxt, POR_EL0)     = read_sysreg_s(SYS_POR_EL0);
> -}
> -
> -static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
> -{
> -       ctxt_sys_reg(ctxt, TPIDR_EL0)   = read_sysreg(tpidr_el0);
> -       ctxt_sys_reg(ctxt, TPIDRRO_EL0) = read_sysreg(tpidrro_el0);
> -}
> -
>  static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
>  {
>         struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
> @@ -131,6 +88,47 @@ static inline bool ctxt_has_sctlr2(struct kvm_cpu_context *ctxt)
>         return kvm_has_sctlr2(kern_hyp_va(vcpu->kvm));
>  }
>
> +static inline bool ctxt_is_guest(struct kvm_cpu_context *ctxt)
> +{
> +       return host_data_ptr(host_ctxt) != ctxt;
> +}
> +
> +static inline u64 *ctxt_mdscr_el1(struct kvm_cpu_context *ctxt)
> +{
> +       struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
> +
> +       if (ctxt_is_guest(ctxt) && kvm_host_owns_debug_regs(vcpu))
> +               return &vcpu->arch.external_mdscr_el1;
> +
> +       return &ctxt_sys_reg(ctxt, MDSCR_EL1);
> +}
> +
> +static inline u64 ctxt_midr_el1(struct kvm_cpu_context *ctxt)
> +{
> +       struct kvm *kvm = kern_hyp_va(ctxt_to_vcpu(ctxt)->kvm);
> +
> +       if (!(ctxt_is_guest(ctxt) &&
> +             test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &kvm->arch.flags)))
> +               return read_cpuid_id();
> +
> +       return kvm_read_vm_id_reg(kvm, SYS_MIDR_EL1);
> +}
> +
> +static inline void __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
> +{
> +       *ctxt_mdscr_el1(ctxt)   = read_sysreg(mdscr_el1);
> +
> +       // POR_EL0 can affect uaccess, so must be saved/restored early.
> +       if (ctxt_has_s1poe(ctxt))
> +               ctxt_sys_reg(ctxt, POR_EL0)     = read_sysreg_s(SYS_POR_EL0);
> +}
> +
> +static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
> +{
> +       ctxt_sys_reg(ctxt, TPIDR_EL0)   = read_sysreg(tpidr_el0);
> +       ctxt_sys_reg(ctxt, TPIDRRO_EL0) = read_sysreg(tpidrro_el0);
> +}
> +
>  static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  {
>         ctxt_sys_reg(ctxt, SCTLR_EL1)   = read_sysreg_el1(SYS_SCTLR);
>
> --
> 2.47.3
>

