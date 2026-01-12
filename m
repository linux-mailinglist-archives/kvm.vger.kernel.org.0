Return-Path: <kvm+bounces-67829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C7FD8D14DDF
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 20:10:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1AEAC304569A
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 19:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACCD8313E01;
	Mon, 12 Jan 2026 19:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U1TkGW3R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364132701CF
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 19:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768244965; cv=pass; b=cv2daJNPg0kJSyKoopdwW0qoOd593Opxs2kaxBJedTdqsEqRjy/Vjj8fV5WtyDszlpaPbKQc1FytL3OtjR6QOk3Mo11OxQI5YB2KDx6v7HVMN9QfOtbtZSjoAmku1xw+kFTrYrRTNS3FN/yotnzfPLd0QKazOKvT99uh5MTFH+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768244965; c=relaxed/simple;
	bh=xheA9QOjQXvJoAbTTZVMmFI6y8wl+wMqp+t7iExkGCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pI1u/GNu+5FLM/B5erI3qP+AyT31EcntjgV6+0xdbbhZSYtriBCiImkq3rA7AOMNcc3W2Y6ABQzLWQujTQuoWrMLH5g9dpKP2unKsYtGEFnPQG+wsDqF1plf1C8ml4xsI2MEKthSbY9F2/KvmSXEznP1DKSEyB2j5fKyRXgKOjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U1TkGW3R; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ffbaaafac4so43571cf.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 11:09:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768244962; cv=none;
        d=google.com; s=arc-20240605;
        b=bsXMtE+rYb5l6JYv7BuupZD2LkCqXyU6JzwwQGYSwTB1jRNhLmVuDJYlxcXVcxA97E
         XKD5j+q2KBF0yam/jk+tVi3a0wYcltwVxBx/iocbLDs6MyeZYKLZ/6MouYopP/faA1Jy
         VjupA29LO/kG7zdPK89KeeaMTPFNgUNDZvyl+7D0ChB7reu5hvhCtcisQtSGE5MC71KG
         srMtITjFA3farl5GiLTMOY0rkkbd45TguxTmbHYxh4P6wimgpkGlHLAJoeDZZv5YNqsx
         AFiT8K57YwI/w5kyVnSgmKXQaRowz495pPsfZWU1se0y7SnPR4feHJuCDkix40PQ6VcO
         vCuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CI3Qkkbb89cv5bbaE9HcvbYXyBW2GfCAOd3nwRVqS/M=;
        fh=3mM/G6DYzLZulkm9xu/c7cCuyPOu2cqpYExnqepf3RI=;
        b=gg4PfjPcO1BDvGPsAzKryvGrl2jy4qfsqu/DB6LKEV6RkQ+0RxhspyWNw4fGkfS30x
         jm0BPJbxCopkVCciqCKFRjN1HIbUH3MlRmKmDKCRgT5qvxW3hVcmawkX14I84LksqEGg
         RUWKs0yBS+XPYvQn17drYy/EeI8co6wLdNn1de7n4vdTHwC2I0ndWiQsSm1/o63aSdhy
         wKGleLN8kzm7Iw6tbzGGxamPDhH0ctgGaVxqPRTyJm1C8Cs5SrzaeJMOZzIZigFn9P2Z
         REqZNraNL4Tpr+o/OsTloQ33ykNXV5921px6PKKqK4uAblNZqy7RTyNx821pobM/kQOB
         ZLbA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768244962; x=1768849762; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CI3Qkkbb89cv5bbaE9HcvbYXyBW2GfCAOd3nwRVqS/M=;
        b=U1TkGW3R2x+Jm1Pqun+QQoL77XNSM9nOE+Fz+CrfJ93zk0CE7+AJwyG98eqiZmyiej
         L9KNXhyjWHI5cayiwuTkfCGdFUg7mDGoQcKiKKbskcsjbhY+r10zKCoFmkWjT8DMWPlS
         rPlU+ORQYeoGommPU8tNnoL6uPjteH3Uz3B3Mj/57WWR6/CNrBfp6hHXQ9P+EFdlAAV6
         WcsBWaiDdpwin02CD4Zq50j4qZU7/M+QfcguzRufpcImsoCsqAyOSnl9z9OY825EtGaO
         bb1MwRlr5G2xLxwYbJgx5t61IdQwipA+NrmEfZvfyvIM66HgJRffSjO3mkPBAu0M8zgh
         vmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768244962; x=1768849762;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CI3Qkkbb89cv5bbaE9HcvbYXyBW2GfCAOd3nwRVqS/M=;
        b=ZMuEDaC7gJeBS4vbuXun2VgHTdsq2HsXELEVLyTnfsv1kyGjm7GkALxOvbGuLgMwiw
         iV8gEOJcqsbwJXh2iY7crFCPnnUchLBmpuOHYkbmeu4jhs/LG4f2doiPQORoGq33U+ry
         pwjeleXY7/3QPEijVjvW49CKGwrRFkLZPCcSgSxG8SCBCq05a4CNLegmjhUP9RqVeiH5
         EpyK7JWoxeQA0zYawc4JYDPG3F991e/ooDsbH75ECocRiqRIKj0MGTGXaDoGy+OYm0y4
         E2859SsjfufvwzPMRwOM92UET8nCEPNyi4Zt6+SfNSuvX+cYlgRwsuyUvyvqA41StSoH
         Sh/Q==
X-Forwarded-Encrypted: i=1; AJvYcCU5eY9iTU8btDrKzI+cAsPbTXNTdG5X3ZeRw6twz9W1fBhFqAX0I5Mss/EoPXOUP+vj/QI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiZAFgTuAwCbd9YCicQFBJrsvSsUD4tE1xY8IeJa+xRfrbdG6G
	hjZt/LLpoXs3LQt8iBDts7LiIKFJ/XiyXqOxR5J8i+IHmg41GmBVfPUTKGCfr94+j9Fjd5iLhML
	Pk50zdH4putxrssNE0BGyOMmBuPYPeNYQmhQwzd4V
X-Gm-Gg: AY/fxX6FNsfGxBfLSr65gWrNB6iD3fPpMmoj8Mp4RZR0aKDi6Ju7Ov+UjL+4C3LJWqj
	4M3gqHfg5MRJ1FhiOvdbI0atpZMkn9ehjtVKoOpcsIPljAHksEFQSkQMnhjbetwrVXpXDJ/iDHe
	bDh9DYT8tqo35r5j4UH78xgOTnCLeWI2myHi0xqdw/SeaFpg2CTMI16RkymQZQ76iIRwjbG5Px/
	KlohdVxkKWUNNXRgYyiR+jiHxMjGuwK31hfHIb7yPie7OyPgzcVna6jVOpbQBIkCh+6hNhS
X-Received: by 2002:ac8:5d42:0:b0:4f1:9c6e:cf1c with SMTP id
 d75a77b69052e-5013a41792cmr752671cf.17.1768244961509; Mon, 12 Jan 2026
 11:09:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-21-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-21-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 12 Jan 2026 19:08:00 +0000
X-Gm-Features: AZwV_Qjgu-sXQZIHm3TAlOW62aUWk-t7wcra038ZJt2_3BJ_d28PSVA3xv4zVCM
Message-ID: <CA+EHjTz4vDFdhbZMz6mNacdzSJLFfVbQKMGmSo=Vt9bSB4ho0Q@mail.gmail.com>
Subject: Re: [PATCH v9 21/30] KVM: arm64: Flush register state on writes to
 SVCR.SM and SVCR.ZA
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

On Tue, 23 Dec 2025 at 01:23, Mark Brown <broonie@kernel.org> wrote:
>
> Writes to the physical SVCR.SM and SVCR.ZA change the state of PSTATE.SM
> and PSTATE.ZA, causing other floating point state to reset. Emulate this
> behaviour for writes done via the KVM userspace ABI.
>
> Setting PSTATE.ZA to 1 causes ZA and ZT0 to be reset to 0, these are stored
> in sme_state. Setting PSTATE.ZA to 0 causes ZA and ZT0 to become inaccesible
> so no reset is needed.

nit: inaccesible -> inaccessible

>
> Any change in PSTATE.SM causes the V, Z, P, FFR and FPMR registers to be
> reset to 0 and FPSR to be reset to 0x800009f.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 24 ++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c         | 29 ++++++++++++++++++++++++++++-
>  2 files changed, 52 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 44595a789a97..bd7a9a4efbc3 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1147,6 +1147,30 @@ struct kvm_vcpu_arch {
>
>  #define vcpu_sve_state_size(vcpu) sve_state_size_from_vl((vcpu)->arch.max_vl[ARM64_VEC_SVE])
>
> +#define vcpu_sme_state(vcpu) (kern_hyp_va((vcpu)->arch.sme_state))
> +
> +#define sme_state_size_from_vl(vl, sme2) ({                            \
> +       size_t __size_ret;                                              \
> +       unsigned int __vq;                                              \
> +                                                                       \
> +       if (WARN_ON(!sve_vl_valid(vl))) {                               \
> +               __size_ret = 0;                                         \
> +       } else {                                                        \
> +               __vq = sve_vq_from_vl(vl);                              \
> +               __size_ret = ZA_SIG_REGS_SIZE(__vq);                    \
> +               if (sme2)                                               \
> +                       __size_ret += ZT_SIG_REG_SIZE;                  \
> +       }                                                               \
> +                                                                       \
> +       __size_ret;                                                     \
> +})
> +
> +#define vcpu_sme_state_size(vcpu) ({                                   \
> +       unsigned long __vl;                                             \
> +       __vl = (vcpu)->arch.max_vl[ARM64_VEC_SME];                      \
> +       sme_state_size_from_vl(__vl, vcpu_has_sme2(vcpu));              \
> +})
> +
>  /*
>   * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
>   * memory backed version of a register, and not the one most recently
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 51f175bbe8d1..4ecfcb0af24c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -927,6 +927,33 @@ static unsigned int hidden_visibility(const struct kvm_vcpu *vcpu,
>         return REG_HIDDEN;
>  }
>
> +static int set_svcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +                   u64 val)
> +{
> +       u64 old = __vcpu_sys_reg(vcpu, rd->reg);
> +
> +       if (val & SVCR_RES0)
> +               return -EINVAL;
> +
> +       if ((val & SVCR_ZA) && !(old & SVCR_ZA) && vcpu->arch.sme_state)
> +               memset(vcpu->arch.sme_state, 0, vcpu_sme_state_size(vcpu));
> +
> +       if ((val & SVCR_SM) != (old & SVCR_SM)) {
> +               memset(vcpu->arch.ctxt.fp_regs.vregs, 0,
> +                      sizeof(vcpu->arch.ctxt.fp_regs.vregs));
> +
> +               if (vcpu->arch.sve_state)
> +                       memset(vcpu->arch.sve_state, 0,
> +                              vcpu_sve_state_size(vcpu));

If sve_state isn't allocated, this means that we've gotten here before
finalization. Is it better to return an error rather than silently
skipping this?

> +
> +               __vcpu_assign_sys_reg(vcpu, FPMR, 0);
> +               vcpu->arch.ctxt.fp_regs.fpsr = 0x800009f;

This matches the Arm Arm, but can we use a define or construct it,
rather than using a magic number?

Cheers,
/fuad


> +       }
> +
> +       __vcpu_assign_sys_reg(vcpu, rd->reg, val);
> +       return 0;
> +}
> +
>  static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
>                                    const struct sys_reg_desc *r)
>  {
> @@ -3512,7 +3539,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>                     CTR_EL0_DminLine_MASK |
>                     CTR_EL0_L1Ip_MASK |
>                     CTR_EL0_IminLine_MASK),
> -       { SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
> +       { SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility, .set_user = set_svcr },
>         { SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility = fp8_visibility },
>
>         { PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
>
> --
> 2.47.3
>

