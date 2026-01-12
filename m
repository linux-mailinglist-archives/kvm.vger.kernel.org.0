Return-Path: <kvm+bounces-67827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D18DD14C89
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 19:36:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 163E630056D4
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D33387590;
	Mon, 12 Jan 2026 18:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TTXmfXNR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B87E2DCBF7
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 18:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768242999; cv=pass; b=gEHO4l5Y2QevOAFoCu23dx7xoLTycC0XWFshnrSWnPSO4Cogoem1B0b1gA61LeEYujeOyXQguSiCVAfQLa4cgPgw1+wvT2sLPKo3x0+HVZSBJW1iqWur1Mb7HmSJvkq5kJ26Wlv4lVSoglJ8+lnkdVMK2owlSoxppndCC1C3Jzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768242999; c=relaxed/simple;
	bh=EIrMm4XF6YXDK5QFU6GazWT7Q5wK9ZblkKgC5n9hRM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LrFqnXNEmW8m8U7T2dYWzLk6QAiI2NMIWLjFdlcekwHBXYmoM7dpBfLyiUelR36pchCj911wxKsdLyemwRRGsCUT4SsD10JT4qA3Bz1pcffp+oR4qnu1r1W8qwcCkch/8+uS7Z5cIO9uAyi3UAfhAoOsGvdtyJCY7y44aPvl+Fw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TTXmfXNR; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee243b98caso29451cf.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 10:36:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768242997; cv=none;
        d=google.com; s=arc-20240605;
        b=e/06+3Ap0ZJ7PKAAIFqgthlbA/7bC17UuXi+C1pugAPlrHJOdip4vii6fbx4oiQnvh
         64rhRxEjio5vxo6hY9peofxdpcaMB9Ooa/SU0Td+RBIJ0eRpR5Gk53CCXYgKKaHgs6MX
         bQ5bHSVI0GRlClvvnBdsY7zYyTixIsFj4ELiKT1w3zWZp/2GKGOd200qBO7btkV/Qi4R
         kf8w4KONW2uQU9RWjEUDdzsvCBtXU2/MzgxPVTBMDb0c5qGv2D+yqqAjEJsnFSLb96Vh
         dj8+eoFmLlvBLcF0UHO0X9muw8s1+4WTyj76wxO38hxrXH9OgRrW/QHDCf1vzPonalqn
         0h0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YeVorztV8L2661ciMsTJRNHNSwWuFDTDQ9Xn6dJSHXo=;
        fh=lGCKcgRE+wt9DmVedQGCXHvrW9sMVRC1Et3GIUId8VM=;
        b=ZQFRrCO/wNTa9FUNJ1SvBLJSWO3opY+FN+lPtazhBR7PmMdKvlckG2lsv/mYlk6RA3
         T6VIKNkGALCSpDy0VE0JbJObgBhZnOQMT8pYIK9N7I3V7rijy5CXZeqNu/iEqM+aplcc
         RyynANt0d8gVz0bIceqsMEo1eTjin9SgjUQ1p1Nrgk1AVegtgEX1KcW1Ajfxuove4gHG
         TDj8CloZc3PAL170QdpEUDTH+nNpmg0ZbIHnKQnl+ZRKU6GncvfxTi/3cYRvvSBhTtQy
         TBqBQ+DSLZ4pB/IWWRre1ovNcamUem3Lz+FsDFHl8zmwePUJOZZY6msjAGikFZygmCU9
         0h9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768242997; x=1768847797; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YeVorztV8L2661ciMsTJRNHNSwWuFDTDQ9Xn6dJSHXo=;
        b=TTXmfXNRpK5BjEGnPo2Ny+2wKrAZFDF21FlLYOqEzhrIJfy5ixbDTtNTuvDhtuEYMY
         guUoTMMoH4MW735ULy5rRLyPDGRAQuN6JPByzEHhem6nUYMi4q40uPpdotyNaLgDzHUS
         yTlPjkOicu0IWw8sL40+NIqZn0H9+7EMKBjqJu1wDsNq6cY87+TaBtSZuWuLyGlaUBgQ
         acCEqYH7yNLbq+04MHW7+2hNqUILzv4SGoY8sXqdfPNmgEA005011Z0g6rWMIrjwHVhj
         BvhmCjFNJWAKoVYlLurmZYVxfXmpXLowAp0h+Iatc+LoZA42mbNobb3+oXmTPF2symw2
         dZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768242997; x=1768847797;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YeVorztV8L2661ciMsTJRNHNSwWuFDTDQ9Xn6dJSHXo=;
        b=kN2GE9VLA6xrq68J/rauuo1qANbJ2sI5BczuDq+6BmNpuGYXs66pGa9EFkOTtNFbo6
         00ma6eXmmCZmRyihzPd5kSaa9A+Ec8iP35M7TZE2CpzjaszqA6Czay2wlm5RMnCMWEiP
         EXHsmCKNzprWaFNX4MFUHFK5yBif/NTK6Sk33BSI10LiCHZXl1rAFZSNZixRub6Xs/6n
         qF+p2/eacUOxyc7vkH9iHJTWq1jit4gDsGhY/24fe3biI90F/Y3oQoD9tCh9uyRW3xAU
         /9m2MD6TcJh4uSsl6NF6rda6DR3ipbByPa5gXLmWlkam0fcqAgQmFVoxN43foqLy7Hny
         fZHw==
X-Forwarded-Encrypted: i=1; AJvYcCV4Any7dbSRhizFEX5pRzHZKOrPRa3HOiQO3QCg5XxSKkhMbgFm5mdynWRgbCgk6c8wETY=@vger.kernel.org
X-Gm-Message-State: AOJu0YykrXD3WIuUFw6K4LAlcontZLnbEz8jS57VSoYBsxfSG7RhLnFf
	gFY0ISB6D5WIqq8Cwcyqg79ik5oEz1NFR4wn9eVQfA+MKB80hanXbL80NLHh1XshtiCegP2CDI7
	CBfcwHcFZ6tWn1upDEgWJ1WgoWAajnxsrVoroPEH7
X-Gm-Gg: AY/fxX44f3qIS7EXnBz/Ljfo5HzYVHMsRBDYc4i42pDw/raYwXEGGEr3w4qh3kmQIeg
	IlU+0GNB55hAM6INhQa89Bt7Z+3zTJQcASqTkPJGf70KyRjaohCREivVHJTxNW2tUVqASuYT02G
	x4rzWHo3isS7FLxA6x4ui3bKN0wjlKzhQO8NWEc8yBdGQ56PB5EMRVtPeK7Hkam7ZWcFX6IF7B8
	x1AlsFDFxQ1BwiPnj4ZR1nkKpBcVDSV/HoXcEylxJfgdhj02W8siw+c/AGvbw0aL2lu95yC
X-Received: by 2002:ac8:505a:0:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-5013a3c78b1mr163381cf.1.1768242996667; Mon, 12 Jan 2026
 10:36:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-20-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-20-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 12 Jan 2026 18:35:00 +0000
X-Gm-Features: AZwV_Qio1zjivzMeQYMIWVOvizuY7XatkfCAEo9m4hnoTRYK322NCwDdKHaZ9i8
Message-ID: <CA+EHjTyovGEkb6svw-=wR=DF52j-wWTawJ5a19EuvSt4i9Re2Q@mail.gmail.com>
Subject: Re: [PATCH v9 20/30] KVM: arm64: Support userspace access to
 streaming mode Z and P registers
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
> SME introduces a mode called streaming mode where the Z, P and optionally
> FFR registers can be accessed using the SVE instructions but with the SME
> vector length. Reflect this in the ABI for accessing the guest registers by
> making the vector length for the vcpu reflect the vector length that would
> be seen by the guest were it running, using the SME vector length when the
> guest is configured for streaming mode.
>
> Since SME may be present without SVE we also update the existing checks for
> access to the Z, P and V registers to check for either SVE or streaming
> mode. When not in streaming mode the guest floating point state may be
> accessed via the V registers.
>
> Any VMM that supports SME must be aware of the need to configure streaming
> mode prior to writing the floating point registers that this creates.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/guest.c | 38 ++++++++++++++++++++++++++++++++++----
>  1 file changed, 34 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 2a1fdcb0ec49..90dcacb35f01 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -73,6 +73,11 @@ static u64 core_reg_offset_from_id(u64 id)
>         return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
>  }
>
> +static bool vcpu_has_sve_regs(const struct kvm_vcpu *vcpu)
> +{
> +       return vcpu_has_sve(vcpu) || vcpu_in_streaming_mode(vcpu);
> +}
> +
>  static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
>  {
>         int size;
> @@ -110,9 +115,10 @@ static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
>         /*
>          * The KVM_REG_ARM64_SVE regs must be used instead of
>          * KVM_REG_ARM_CORE for accessing the FPSIMD V-registers on
> -        * SVE-enabled vcpus:
> +        * SVE-enabled vcpus or when a SME enabled vcpu is in
> +        * streaming mode:
>          */
> -       if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(off))
> +       if (vcpu_has_sve_regs(vcpu) && core_reg_offset_is_vreg(off))
>                 return -EINVAL;
>
>         return size;
> @@ -426,6 +432,24 @@ struct vec_state_reg_region {
>         unsigned int upad;      /* extra trailing padding in user memory */
>  };
>
> +/*
> + * We represent the Z and P registers to userspace using either the
> + * SVE or SME vector length, depending on which features the guest has
> + * and if the guest is in streaming mode.
> + */
> +static unsigned int vcpu_sve_cur_vq(struct kvm_vcpu *vcpu)
> +{
> +       unsigned int vq = 0;
> +
> +       if (vcpu_has_sve(vcpu))
> +               vq = vcpu_sve_max_vq(vcpu);
> +
> +       if (vcpu_in_streaming_mode(vcpu))
> +               vq = vcpu_sme_max_vq(vcpu);
> +
> +       return vq;
> +}
> +
>  /*
>   * Validate SVE register ID and get sanitised bounds for user/kernel SVE
>   * register copy
> @@ -466,7 +490,7 @@ static int sve_reg_to_region(struct vec_state_reg_region *region,
>                 if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)

Should this be vcpu_has_sve_regs()? (zreg range)

>                         return -ENOENT;
>
> -               vq = vcpu_sve_max_vq(vcpu);
> +               vq = vcpu_sve_cur_vq(vcpu);
>
>                 reqoffset = SVE_SIG_ZREG_OFFSET(vq, reg_num) -
>                                 SVE_SIG_REGS_OFFSET;
> @@ -476,7 +500,7 @@ static int sve_reg_to_region(struct vec_state_reg_region *region,
>                 if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)

And should this also be vcpu_has_sve_regs()? (preg range)

Should you also handle FFR here, considering that in streaming mode
it's optional?

Cheers,
/fuad



>                         return -ENOENT;
>
> -               vq = vcpu_sve_max_vq(vcpu);
> +               vq = vcpu_sve_cur_vq(vcpu);
>
>                 reqoffset = SVE_SIG_PREG_OFFSET(vq, reg_num) -
>                                 SVE_SIG_REGS_OFFSET;
> @@ -515,6 +539,9 @@ static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>         if (!kvm_arm_vcpu_vec_finalized(vcpu))
>                 return -EPERM;
>
> +       if (!vcpu_has_sve_regs(vcpu))
> +               return -EBUSY;
> +
>         if (copy_to_user(uptr, vcpu->arch.sve_state + region.koffset,
>                          region.klen) ||
>             clear_user(uptr + region.klen, region.upad))
> @@ -541,6 +568,9 @@ static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>         if (!kvm_arm_vcpu_vec_finalized(vcpu))
>                 return -EPERM;
>
> +       if (!vcpu_has_sve_regs(vcpu))
> +               return -EBUSY;
> +
>         if (copy_from_user(vcpu->arch.sve_state + region.koffset, uptr,
>                            region.klen))
>                 return -EFAULT;
>
> --
> 2.47.3
>

