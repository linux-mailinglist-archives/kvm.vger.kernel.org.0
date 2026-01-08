Return-Path: <kvm+bounces-67386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 576C4D0399D
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 15:58:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B594E326918E
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 14:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E4D54BED13;
	Thu,  8 Jan 2026 14:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hh+edRsd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582054ABFB8
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 14:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881430; cv=pass; b=fY8Kot/1D20ipbFbLWzBtldKIIys8/wxVzYg63JUG1C0ERcvP3sI0NRazXBQdph5opLNCj/iLV3lsfHZS4UO3SsYlcdaPLsvtyZXQ/HrgjGtx6Nix2k/EgHv1CXySiR6wook1i2qWV/SHKFLV+YYMqEeDGJHH3NE+KBJ++h4k0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881430; c=relaxed/simple;
	bh=6s+1Fa+lgma2W6VO//e9W/EKZ99EnAtWNWD0KjYryo0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A3ciWbqh15rNN13VHpeMQQLub0ntbmVFQB/4q6qnTDW7ikmhdV1rFRMZ0IdrXuBPwfcvplNp274OCVCCQqpUoPp8td6vD3cHrQF1o3+lXDqeP1OSza1lXLh3Q3p7E4eWoIfnAYBFL4K+8pvlKzHdk/K4vQGMgCqOd8Fo5juhdw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hh+edRsd; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ee243b98caso845911cf.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 06:10:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767881427; cv=none;
        d=google.com; s=arc-20240605;
        b=TndN5VesFXeBeS/6D8H6c8wwt0e7+b/pX/fV4G8jp36JSzKvAcDxj7mgyTqjCGUdhg
         E0AJHWTRq8exXb/O5HF4KdRrtjKmIDR1ppNyXi++fS75Ahn4yrYVPTCp+8nlEEv8UPec
         LmO/fZybqV/yiMYsRup5Bzv+GB17aNG536EPq1pGTzPR6i3CuVhmGUUEIK1SNRK88pxb
         jUcFtsHF6a1uM/AVGoHx63Gmh77lnVFifbmSN316SbH5jUwfrdIRJk9xvDki7Os6hIPV
         FfGTnUzC3BTkMlfKueYdE9KIlQkT9nGS3LeLHMpDUtVys8t0FyYF4AzfwQ2uCTL+t6O/
         kdGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UkFBVVF2FUVuKrFgmcHW8CUldvJtVwVqevSTZGxcxL0=;
        fh=m+Z/CesERMztd5qp27GfL1BnNJbsJhqgCyoDHlgHyFQ=;
        b=GhDRptQ5pclL53xbyeh6/WukIbc+C5EnzyrKwutAZvZbuv/oiARktHmETovCAfrBuj
         9bcYTU8uIOFyyWeOioyZZk6d/FEKl7Z/s9Kf1tgrLOR0sDrXkPU+KeuI7oy9UfQ9I+9w
         XcW/sdz4ihAAQjP6eibuGHQo3PLRkQeaEpLdm98GPJRZcCpEx8XXRtPd27LyVufJBdAt
         jGihxsRfkv2nqEBr2W/MSZprk5/jeGfWMlh3OTE7e1BaXLSv2a1SNS8O5g3sEG/HZK4v
         JM1U7mBmapgMUAyKjmZDN9urE6uTSo4SAUxwPkrc4PyUw6BWvNlnNjknIPglt5Q11E1C
         eqIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767881427; x=1768486227; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UkFBVVF2FUVuKrFgmcHW8CUldvJtVwVqevSTZGxcxL0=;
        b=hh+edRsdP3j8FirfLiyEGrzOOXApW88U+v02QYWE5AV+tspa/pUm0oPm2EnxRQ+E6h
         QW4ucjynddmBipIgLDIXu4/CCUKDoFB8gHMsOdRYtT2bXy3+Ri3CAL/hxf9XMsLTiBr6
         OWbmMXnkdmF1TbddIf52CIftJ7VwuHOaAVmxCNMeDbXyVXD0kL1+XVOBNSHF6rjjz9bX
         LLo59wasQtkhD0QQqjeG96GJGVlL/eV26LzzQ/lTwj4kY5K6FYYYImicoyoyWwB/PmNU
         ECV8p92C0RDkSBloU3DBjN9PdlfKTticCX+3dLI/mlCHj4+SB6nT25+0Ir6ara6oI98s
         mTmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881427; x=1768486227;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UkFBVVF2FUVuKrFgmcHW8CUldvJtVwVqevSTZGxcxL0=;
        b=qTeCClDuf6CdEtvmXiBLAZR6xmRnUB4yz9PP+tSaFHwB8gbc9E1Bqe1dnA644g4Iy6
         LEuWzkwuBSRK0ACmr/OFlfiJ174WynN8ytDKXoZqJM2FFrXDTIKl0kqpuOcyv80dklGp
         SI3C0JsqpFmLkDRe2jjxFYZL+dk4xUve9lhLfZLe8bIHx0gKN/kefF/lgJ2SjZNWGTTr
         dQHQIu2izk5U9zf/I9E8n0gPJeNITfG+WcnC7v9REx4njGblED8KIAQ5jX6u9yelrEX+
         IClZRQQBE19Tp8HNqLqyNuhRcvF0onlUzVXme6XMt0BjHWn3HcUTXPf7cp0lR9DlQS8v
         uK5g==
X-Forwarded-Encrypted: i=1; AJvYcCX0+Be7p58Dfx71MbQo/AFsCWdfjG/Rwz4AFB4hSsx7JGfVmHtJg9+pUOPEaMQLhWEwc+g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2pfZkqBncU3jYe6ssv5aan+qxiwvE4SfCMr84Q20E/xtiFSLD
	fN120B3VRFJyETWqogJpqkXTnlDh1s2gVCdCPF38/9N29jX3iStF7rmYljsPW+hlJXU7h1Cy4eb
	XSxRI1/Kz8wFqf0/MR37WnlU7KlskJNsMKGPCm8sZ
X-Gm-Gg: AY/fxX4+RvzBIT4aCG8duLbozFAuS5NAko8YhrSAVs+JYDYepajmGQuszLTEK110Hlj
	INa4GXV7ZvG0PFuynIOiBU0RhDiFDRgr9l3v5lVp8ptc93J9obEnvjZ5/49MI8SXkUTElb/exNt
	NfTKm0b2Pd2fSxrHGuH2zgtMxo9WMX1v9XTB59zTh7nwkwVsDjCj/AbVv2SPC2Ir9lkzvsaSpkZ
	d/psg7sZxNT3WkKBoKHuQjL6v1aqFPInMMLjEFwrS5qV+Mn80BX9rnUg+w1Tn+dBYZz0WLNp39N
	zD/bQlk=
X-Received: by 2002:a05:622a:54a:b0:4f4:bb86:504f with SMTP id
 d75a77b69052e-4ffc0a70687mr8479691cf.16.1767881426893; Thu, 08 Jan 2026
 06:10:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-8-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-8-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 8 Jan 2026 14:09:50 +0000
X-Gm-Features: AQt7F2q2Xuj85YtjC8aNYrYefXO_WXhklsHw1E8DTYu1HFx1qzlPPDyk9yC5egA
Message-ID: <CA+EHjTx8hu=WEu54Bt82PtcsOdQHaVkw9ivQSSC9=SV7bf1Zvg@mail.gmail.com>
Subject: Re: [PATCH v9 08/30] KVM: arm64: Move SVE state access macros after
 feature test macros
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
> In preparation for SME support move the macros used to access SVE state
> after the feature test macros, we will need to test for SME subfeatures to
> determine the size of the SME state.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> ---
>  arch/arm64/include/asm/kvm_host.h | 50 +++++++++++++++++++--------------------
>  1 file changed, 25 insertions(+), 25 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ac7f970c7883..e6d25db10a6b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1048,31 +1048,6 @@ struct kvm_vcpu_arch {
>  #define NESTED_SERROR_PENDING  __vcpu_single_flag(sflags, BIT(8))
>
>
> -/* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> -#define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +     \
> -                            sve_ffr_offset((vcpu)->arch.sve_max_vl))
> -
> -#define vcpu_sve_max_vq(vcpu)  sve_vq_from_vl((vcpu)->arch.sve_max_vl)
> -
> -#define vcpu_sve_zcr_elx(vcpu)                                         \
> -       (unlikely(is_hyp_ctxt(vcpu)) ? ZCR_EL2 : ZCR_EL1)
> -
> -#define sve_state_size_from_vl(sve_max_vl) ({                          \
> -       size_t __size_ret;                                              \
> -       unsigned int __vq;                                              \
> -                                                                       \
> -       if (WARN_ON(!sve_vl_valid(sve_max_vl))) {                       \
> -               __size_ret = 0;                                         \
> -       } else {                                                        \
> -               __vq = sve_vq_from_vl(sve_max_vl);                      \
> -               __size_ret = SVE_SIG_REGS_SIZE(__vq);                   \
> -       }                                                               \
> -                                                                       \
> -       __size_ret;                                                     \
> -})
> -
> -#define vcpu_sve_state_size(vcpu) sve_state_size_from_vl((vcpu)->arch.sve_max_vl)
> -
>  #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
>                                  KVM_GUESTDBG_USE_SW_BP | \
>                                  KVM_GUESTDBG_USE_HW | \
> @@ -1108,6 +1083,31 @@ struct kvm_vcpu_arch {
>
>  #define vcpu_gp_regs(v)                (&(v)->arch.ctxt.regs)
>
> +/* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> +#define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +     \
> +                            sve_ffr_offset((vcpu)->arch.sve_max_vl))
> +
> +#define vcpu_sve_max_vq(vcpu)  sve_vq_from_vl((vcpu)->arch.sve_max_vl)
> +
> +#define vcpu_sve_zcr_elx(vcpu)                                         \
> +       (unlikely(is_hyp_ctxt(vcpu)) ? ZCR_EL2 : ZCR_EL1)
> +
> +#define sve_state_size_from_vl(sve_max_vl) ({                          \
> +       size_t __size_ret;                                              \
> +       unsigned int __vq;                                              \
> +                                                                       \
> +       if (WARN_ON(!sve_vl_valid(sve_max_vl))) {                       \
> +               __size_ret = 0;                                         \
> +       } else {                                                        \
> +               __vq = sve_vq_from_vl(sve_max_vl);                      \
> +               __size_ret = SVE_SIG_REGS_SIZE(__vq);                   \
> +       }                                                               \
> +                                                                       \
> +       __size_ret;                                                     \
> +})
> +
> +#define vcpu_sve_state_size(vcpu) sve_state_size_from_vl((vcpu)->arch.sve_max_vl)
> +
>  /*
>   * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
>   * memory backed version of a register, and not the one most recently
>
> --
> 2.47.3
>

