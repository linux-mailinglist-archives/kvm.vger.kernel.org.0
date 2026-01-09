Return-Path: <kvm+bounces-67573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5CFBD0B16E
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 17:00:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9F6EC30570AB
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 15:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 457B635CB96;
	Fri,  9 Jan 2026 15:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bc40ye1x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CD9280A5B
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 15:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974177; cv=pass; b=buEnkrDx9YloDxNmwCEHj7tUFrKZ29a2eknvu0VRrBTr29p3AzOsJbLgWARJwjUK0ahLdB/1F3hho1GdxSYM7AByFaWXlV2xO6wqvdPHndLzOkEmT06fzt3ST5ETaIlZXYoO1CypYEb+wV2706nSdYqhT1vOlysXOUwYdqwm5gw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974177; c=relaxed/simple;
	bh=iK5AUYKKnG1GCt/80DpdeQQfwbtmqro71Xoh6GzOc/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KoBl+xubNtZ0qf4OtyveZnWPdVgfCEr4Nx8XD+zYkAzt1b4TT/FmalvwIHw0fEdtLZyzRUpnDLuGRPAMl6M2EE1AYGPJxch3eHhUL5gketNBNkwfS7pQPRngEjRPSY0BXUe0iiX1Pn7dPUDy59DlQ6OZr2XCJoVz3fvkXKUAWYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bc40ye1x; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4edb8d6e98aso578291cf.0
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 07:56:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767974174; cv=none;
        d=google.com; s=arc-20240605;
        b=Zn2dYlDhYmH1+Gnbwvur4mrDZLP96m3WvYZW9fuLone69yzxT+8cauYrvvzqWt2VsI
         76zEA6NfGMpCpKC0cnE3MSH38bETmwhRhZho7PIzJfvQM85qAaZTuqz07u6Wk4BcJdlk
         AU2D5c21Nltn4Bk7yucld3Jdyiu+kZLu50m8JqTz8NWbns5IwiWUwEsknL+GkLEsEz23
         W141ShZ5M7JilBbEIf05mF/ppsbAhUrzibaM0BcwS3UmJtfjr91hmcIo5f9OJHgzHJbT
         SKMQqO4GjtJ+totYu3FLzPnDW1h5Cj7M0SqeyInqymDgp7L/bip6+VErsnrf+BDnHTl8
         z6Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=U8I+9Z/SzReDIbFo3xnWDAd13nvsAbuR5scsRwJQ9D4=;
        fh=JyJZbmanUoeheKONy11AUjudM2abfvX/HVz51rzKwTo=;
        b=dlI274YQLJVgf4Xh+RnaVzi5hdEHDz4yAD6G0+B1Em4n8eYXbyVTkPUPpUPBnDjO6r
         9SvQGJNU2RZ0R/hAkYYoQxOmMkZu+KA3xt6uzP/kSRXPwSTXUKU3R4sFL0bf/+HKlYoR
         cp9fYVBMkeO35JM5nKkX7SRe6W+hDh3HxKMgRuCIHMsNtZV2XyllELhBRTSbYWjDXDk2
         nqnYsh2iaIUz7okzPgjO/vxdBvt5lBmbo6mf1co+UmYfIfuGE8CQ6VV3WFeVU8dpy/Fm
         sEPu0T9vta6zlrImg4e8w5A/t0RFTzas5aO2K8XMGBq9Pdxpx1MhVN8lAfUWIrRrid79
         fOIw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767974174; x=1768578974; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U8I+9Z/SzReDIbFo3xnWDAd13nvsAbuR5scsRwJQ9D4=;
        b=bc40ye1xcX2mE+ZkSnFA8u+EZ1OrY+ZQImu6xQ9OAG6AFN4lOG3lexGowS+tL9XfJz
         B690N/tCOz5nweQgH7lePbyGUMN4Iy14FXXqjfxdM2kj+wxWJKJedAtAqzVAfUXvqWLr
         dsSk6AZGJcEqbIS/6P8I5nGRo3J5uWYLxlCNINU7izUrD3y45aYx97DQJ5nNXfTf48/c
         rMxuoqVhOD8xd6+WYHiPZyt5EdIA6iUX0EzTbnL17LMCE1lHTR6GjIbm/86ImShWvjya
         qvOBUG6r9CVbcdus+VGbH0s8ZGRvqq2B0brYJZbyvMRnI6EGjo4Vp3mKk2G7eYpd3wte
         HkHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767974174; x=1768578974;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U8I+9Z/SzReDIbFo3xnWDAd13nvsAbuR5scsRwJQ9D4=;
        b=qbg+vP1j3uEra4hC4ctvnhMhUISvPzRMr66/XEzi3Vj5saLFG+WoFqoHSFsfhywl90
         49S4q86CQMgonOufc46As8BJjh+tmMl8pw87ISyFwl8yArZKdQyyTlKEDSdSeFstnbvh
         sb3p4KMSxoI/uYuGHgwmipVlhgqgDzsP0Pz995yD4+nebubeYl6HFtKiV1PUlbr+fyv6
         mDaOe9FcjDjZD97ij3uMDGfQ7UPjmM607f72ZuVql0djEK8fSSzNin8yhWbQgxkh3/En
         Zl5tewKjYZcF1DU5cFmJxLc52zccIi5urAib+MDxiwrtXS0a6LjvOUQbRyiI9rnzPM8x
         SsRw==
X-Forwarded-Encrypted: i=1; AJvYcCXf02ZNCEC4M+1YArVygi00iZNoqHiqHxXCUURXcnJh4pFtcLyTNqzsNKDxdxEvYXWnSDc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjHn95L3lg2mbsK6xEFw3m4Xtak628Df2YpgsVqdjWU9G+7IaR
	8Cyd1/A+VJG8m8k5HVtdDMqshKEtb/MeapuEv8F1YTEA2z0SBE95Ff4J5nuT6w7WzcnZKg7vpov
	iwNJtQU6Ny/V4F6m50P/o6fFznl0He3MF1ge66ojq
X-Gm-Gg: AY/fxX4Bwqr62idw2j59uPQqgKKt6ENvTh9H7cWIwJt3yD4bkPpcwRsLQqtsK/1ip3a
	8CsM89zV5WbchJU+C0SY51AD/2gxwu1rwWi4hdt2rnsZFjTyrlMk7CM1CpLtJ7TEGu2Njly/cM2
	6RmkWRXHTboflNoE9zFnlP1m67eDO2c/fL8YRDAm/yIlA1CiXd0mCqBT8de4QxlWqLa/tgh5+DY
	yyFLk78NqPpCjbbFndTDmhUkluRa0v8R8Qs6QuG1RXeYptUonubxCTMX6qnbL/Fk2nqSmKN
X-Received: by 2002:a05:622a:206:b0:4ff:a96a:90fc with SMTP id
 d75a77b69052e-4ffca10c9e7mr11956941cf.0.1767974173794; Fri, 09 Jan 2026
 07:56:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-11-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-11-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 9 Jan 2026 15:55:36 +0000
X-Gm-Features: AZwV_Qjl7-V6jtqPJiWFE-pNSysqHN43mjzymjYZ55x2bRwN0FRgaHUdOP2UPAs
Message-ID: <CA+EHjTznZj94NFVQGG8Bi0=kkQUMYA0omdGS++83jwLj-CDRNQ@mail.gmail.com>
Subject: Re: [PATCH v9 11/30] KVM: arm64: Define internal features for SME
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

Hi Mark,

On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> In order to simplify interdependencies in the rest of the series define
> the feature detection for SME and it's subfeatures.  Due to the need for

nit: it's -> its

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> vector length configuration we define a flag for SME like for SVE.  We
> also have two subfeatures which add architectural state, FA64 and SME2,
> which are configured via the normal ID register scheme.
>
> Also provide helpers which check if the vCPU is in streaming mode or has
> ZA enabled.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>


> ---
>  arch/arm64/include/asm/kvm_host.h | 35 ++++++++++++++++++++++++++++++++++-
>  arch/arm64/kvm/sys_regs.c         |  2 +-
>  2 files changed, 35 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0f3d26467bf0..0816180dc551 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -353,6 +353,8 @@ struct kvm_arch {
>  #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS             10
>         /* Unhandled SEAs are taken to userspace */
>  #define KVM_ARCH_FLAG_EXIT_SEA                         11
> +       /* SME exposed to guest */
> +#define KVM_ARCH_FLAG_GUEST_HAS_SME                    12
>         unsigned long flags;
>
>         /* VM-wide vCPU feature set */
> @@ -1062,7 +1064,16 @@ struct kvm_vcpu_arch {
>  #define vcpu_has_sve(vcpu)     kvm_has_sve((vcpu)->kvm)
>  #endif
>
> -#define vcpu_has_vec(vcpu) vcpu_has_sve(vcpu)
> +#define kvm_has_sme(kvm)       (system_supports_sme() &&               \
> +                                test_bit(KVM_ARCH_FLAG_GUEST_HAS_SME, &(kvm)->arch.flags))
> +
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +#define vcpu_has_sme(vcpu)     kvm_has_sme(kern_hyp_va((vcpu)->kvm))
> +#else
> +#define vcpu_has_sme(vcpu)     kvm_has_sme((vcpu)->kvm)
> +#endif
> +
> +#define vcpu_has_vec(vcpu) (vcpu_has_sve(vcpu) || vcpu_has_sme(vcpu))
>
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  #define vcpu_has_ptrauth(vcpu)                                         \
> @@ -1602,6 +1613,28 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
>  #define kvm_has_sctlr2(k)                              \
>         (kvm_has_feat((k), ID_AA64MMFR3_EL1, SCTLRX, IMP))
>
> +#define kvm_has_fa64(k)                                        \
> +       (system_supports_fa64() &&                      \
> +        kvm_has_feat((k), ID_AA64SMFR0_EL1, FA64, IMP))
> +
> +#define kvm_has_sme2(k)                                        \
> +       (system_supports_sme2() &&                      \
> +        kvm_has_feat((k), ID_AA64PFR1_EL1, SME, SME2))
> +
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +#define vcpu_has_sme2(vcpu)    kvm_has_sme2(kern_hyp_va((vcpu)->kvm))
> +#define vcpu_has_fa64(vcpu)    kvm_has_fa64(kern_hyp_va((vcpu)->kvm))
> +#else
> +#define vcpu_has_sme2(vcpu)    kvm_has_sme2((vcpu)->kvm)
> +#define vcpu_has_fa64(vcpu)    kvm_has_fa64((vcpu)->kvm)
> +#endif
> +
> +#define vcpu_in_streaming_mode(vcpu) \
> +       (__vcpu_sys_reg(vcpu, SVCR) & SVCR_SM_MASK)
> +
> +#define vcpu_za_enabled(vcpu) \
> +       (__vcpu_sys_reg(vcpu, SVCR) & SVCR_ZA_MASK)
> +
>  static inline bool kvm_arch_has_irq_bypass(void)
>  {
>         return true;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c8fd7c6a12a1..3576e69468db 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1945,7 +1945,7 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
>  static unsigned int sme_visibility(const struct kvm_vcpu *vcpu,
>                                    const struct sys_reg_desc *rd)
>  {
> -       if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SME, IMP))
> +       if (vcpu_has_sme(vcpu))
>                 return 0;
>
>         return REG_HIDDEN;
>
> --
> 2.47.3
>

