Return-Path: <kvm+bounces-67260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A3D4CCFFC0C
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 20:27:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 80C8D30318DC
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 19:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4AB6238166;
	Wed,  7 Jan 2026 19:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n34r1Dod"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6874318BBD
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 19:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767813944; cv=pass; b=KJzIHM0a5/ydObMSSozYjBsIFkjHO71st1xxGKxndomspO4H889qMKml8w1N36+YYP7ToFFvB4Xh59sGK/KHSV4ZoiD14jPaDJaQWNb56Vzbf+UjTuhu+E3iag9VVdbKk57adxkhJjE/EMFeLQ4BAV3DlE0d4BKmADfEi4ewftE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767813944; c=relaxed/simple;
	bh=7pay+ra3qukgJdVWr8OMTC0IdtAVU2sAntJbg1GqfOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H+VPRlNsDxs9jrFvHtppq2qV8tHnRAZb5ihq4HpDf7iEn1uSu996Mlz/tyk4n3G61Zxsf3kO3pXwkKsPJRDz4/L9EbjvwiQUkES4uqNzeXDcOMGVi+sQe2ieZaMPZLBYg15jERFJD+IwH79n5K1/+RzbMOBwcU1nHaH1spfEELY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n34r1Dod; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ee243b98caso480881cf.1
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 11:25:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767813942; cv=none;
        d=google.com; s=arc-20240605;
        b=E10vAaKwgyrIoh+wSF0ts6209hCMhAvPG4RFoaVSyUnRoGW4U3aDfRWKkOfeIw1NU9
         JiWlVlhovbE6ucXtp6AMZ3hK3rIXQSZFD1lTxqR2b3DiahBuCI1cnYdsgUaEN63lCLWo
         tbQlWWB8NyAO/URTENolVAyUW1BmVz9Ll+davI72Nb3zH+z3RNk7HM/P8NxpwdHimk0I
         0BSSXDQucHinpKj0gT8HDfGFD4xqDRaOPdFFG1m3TICPYojZnGSxS9FqDo8sSxjBNhdf
         QCinD9j/G1Gts1ktVHa+EdlA50PnAmQ0FIPH6+IyBN0b9mrOXAPPW/ln8XXCgznJvFPw
         WFCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gTH8jQvV1D0VfzMEkRl+QRl2D3Hkny/yjDSwKTi/xLY=;
        fh=aM+Aa59UW6PLYAJ+6M7GO6W3y/c88AyW1tDviHEvcvg=;
        b=fYL2jXVt09hUiyRYmI7sYzrUUoWY3k/Ulnjq27SaLgLhoiPlcrGcG30TUvj3khAmK+
         1NohuQiZa3JJ4HE4kdiSNEn0iLdI3r4L2h1hmHdW5K2pXxRfHvcjg2/0Dmv/Q0R+ALkk
         qgj9ur0lvFHhZWDmEgNP0A4aAaKT5r6FIGfGaZ5KcVqpMeuTzWaJXXayPOyq0BXcTDu+
         +TxxCFIEcwsdjM4F2GVi+Tgs313dO4VgeHPMj4kXdewH43GeILc9u9+HAnmCo5QvTSZc
         It4MGkGZ59uIa6Hff+jY+XnXmK/ZZSqL0wnG9h6/wONg1F0XT0yX+4zqTZSuOFweV8vc
         CiiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767813942; x=1768418742; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gTH8jQvV1D0VfzMEkRl+QRl2D3Hkny/yjDSwKTi/xLY=;
        b=n34r1DodRD+EN6E+6ttcvYINTUhqVOCHn7lmUqrj62E24aOnM1KAlkMEreLB6laslM
         sxeAyA++iEsPr4swTHYDv32/jatlzajOlmrrZy1jA3MDJxjXzx4YMZ3zvVVjD6QhQpgq
         wpajlRXh6jEPKCFjthnzZ1CVLZIb/rq1bVCpaJNmy3JKAKypaAzlu3blmQwUQI65hIQc
         yg1VCgoZTgRuz0bV2B3N8psHSK5xiDrlpcIUzHlEE+mF+Gv4e8ScC8DM63tfa6w3Dlqj
         zNgUSIjARpE6OmbauSGBUm1NVmy7FUlJBpxgQLi8UXzZGIiDEb55W/BQa1/R/xrlqkcz
         6R/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767813942; x=1768418742;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gTH8jQvV1D0VfzMEkRl+QRl2D3Hkny/yjDSwKTi/xLY=;
        b=HuAnHsbeZVa3F/4R4VKYsi05wCrrqZY7CKNHz2iloWHlbonEhT4+8vhq1EGX+O/C3F
         LN9GeJVgHBSgT6iv0JRlWZa/xlITChVAvonaNJGvSW5/wiWd6P4Fv2lcHA00n99QtsoS
         JbM1u8KrW3JZTLkKLvBOzP4jAhBzaRgMUOiA98VlkyfRi6iTheVikoDQ+GdqGy+nOK3Q
         77W69SYrIUg0Ng/l8ef/fFngIamOosvNGklrZ8alB956cd5inP87RVM2RMPVAI4mHtt4
         /sw3TiOP3LPJKKB55wbvDL5lXm4BWyyPHgzV2+WXBQ0FnF6lZPohs42IzJ2TpwiIdQFA
         OL0A==
X-Forwarded-Encrypted: i=1; AJvYcCVRcYmXt8hk3FnAsaTtes7qN9qiLHUi7oDry7WltSkB8oVZ5fWq0uLnSW/1FJt4qOlZyPc=@vger.kernel.org
X-Gm-Message-State: AOJu0YytSuaO8AnufntmOUyLS+ZMGC1pox5uKhNznAuMy0q5ZyF4HAt3
	/EnzOX25j7ftGZSjZw0SUPhIaqz0+k+6DSiS7O9DlbT3dfqi7Kv8oivYwEoaflwHu/yKyh0A8JH
	qBjAkSutNjTuP5N9lfk26K5sBb+U/Gyzzdxg8eOgk
X-Gm-Gg: AY/fxX7mlwnKTRDVpp8Fnnvny8MfAfm+tY1hJKdFpREPOm5OLcCv9dpZzfjWFse4bKf
	XjbyEH3BqaO9LzP1VQzA7qohsDH2jtpG0cCRW4CksC2KfoWBzm4WEvb6piyuQLdCsbfGfepUNg1
	9V2F2R7XFdM+Mnil/jwF1hDlmO7ToqXhbu5cJg9QxI5tVX8IJdjQFYhzVMiElYtVtz7E5dvlQ2U
	A4u+ihHzxEs90wqpaUBgzORRGjxBHs+PTPxIPsjkwy7Q7ZvQ1cYcbAxF5tdqpTFScp530sw
X-Received: by 2002:ac8:5e06:0:b0:4f3:5474:3cb9 with SMTP id
 d75a77b69052e-4ffb3e48178mr14758401cf.14.1767813940920; Wed, 07 Jan 2026
 11:25:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-2-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-2-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Jan 2026 19:25:04 +0000
X-Gm-Features: AQt7F2qijfqrn1SiSoVThoOMWciACqxsLrgyDpsjmJY9k2NsoSwPIOlWKacYC-Y
Message-ID: <CA+EHjTxdSnpFHkm6o85EtjQjAWemBfcv9Oq6omWyrrMdkOuuVA@mail.gmail.com>
Subject: Re: [PATCH v9 02/30] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
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

On Tue, 23 Dec 2025 at 01:21, Mark Brown <broonie@kernel.org> wrote:
>
> Currently we enable EL0 and EL1 access to FA64 and ZT0 at boot and leave
> them enabled throughout the runtime of the system. When we add KVM support
> we will need to make this configuration dynamic, these features may be
> disabled for some KVM guests. Since the host kernel saves the floating
> point state for non-protected guests and we wish to avoid KVM having to
> reload the floating point state needlessly on guest reentry let's move the
> configuration of these enables to the floating point state reload.
>
> We provide a helper which does the configuration as part of a
> read/modify/write operation along with the configuration of the task VL,
> then update the floating point state load and SME access trap to use it.
> We also remove the setting of the enable bits from the CPU feature
> identification and resume paths.  There will be a small overhead from
> setting the enables one at a time but this should be negligable in the

nit: negligible

> context of the state load or access trap.  In order to avoid compiler
> warnings due to unused variables in !CONFIG_ARM64_SME cases we avoid
> storing the vector length in temporary variables.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimd.h | 14 ++++++++++++
>  arch/arm64/kernel/cpufeature.c  |  2 --
>  arch/arm64/kernel/fpsimd.c      | 47 +++++++++++------------------------------
>  3 files changed, 26 insertions(+), 37 deletions(-)
>
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index 1d2e33559bd5..ece65061dea0 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -428,6 +428,18 @@ static inline size_t sme_state_size(struct task_struct const *task)
>         return __sme_state_size(task_get_sme_vl(task));
>  }
>
> +#define sme_cond_update_smcr(vl, fa64, zt0, reg)               \
> +       do {                                                    \
> +               u64 __old = read_sysreg_s((reg));               \
> +               u64 __new = vl;                                 \
> +               if (fa64)                       \
> +                       __new |= SMCR_ELx_FA64;                 \
> +               if (zt0)                                        \
> +                       __new |= SMCR_ELx_EZT0;                 \
> +               if (__old != __new)                             \
> +                       write_sysreg_s(__new, (reg));           \
> +       } while (0)
> +

Should we cap the VL based on SMCR_ELx_LEN_MASK (as we do in
sve_cond_update_zcr_vq())?

Should we also preserve the remaining old bits from SMCR_EL1, i.e.,
copy over the bits that aren't
SMCR_ELx_LEN_MASK|SMCR_ELx_FA64|SMCR_ELx_EZT0? For now they are RES0,
but that could change.

Cheers,
/fuad


>  #else
>
>  static inline void sme_user_disable(void) { BUILD_BUG(); }
> @@ -456,6 +468,8 @@ static inline size_t sme_state_size(struct task_struct const *task)
>         return 0;
>  }
>
> +#define sme_cond_update_smcr(val, fa64, zt0, reg) do { } while (0)
> +
>  #endif /* ! CONFIG_ARM64_SME */
>
>  /* For use by EFI runtime services calls only */
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index c840a93b9ef9..ca9e66cc62d8 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2965,7 +2965,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>                 .type = ARM64_CPUCAP_SYSTEM_FEATURE,
>                 .capability = ARM64_SME_FA64,
>                 .matches = has_cpuid_feature,
> -               .cpu_enable = cpu_enable_fa64,
>                 ARM64_CPUID_FIELDS(ID_AA64SMFR0_EL1, FA64, IMP)
>         },
>         {
> @@ -2973,7 +2972,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>                 .type = ARM64_CPUCAP_SYSTEM_FEATURE,
>                 .capability = ARM64_SME2,
>                 .matches = has_cpuid_feature,
> -               .cpu_enable = cpu_enable_sme2,
>                 ARM64_CPUID_FIELDS(ID_AA64PFR1_EL1, SME, SME2)
>         },
>  #endif /* CONFIG_ARM64_SME */
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index c154f72634e0..be4499ff6498 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -405,11 +405,15 @@ static void task_fpsimd_load(void)
>
>         /* Restore SME, override SVE register configuration if needed */
>         if (system_supports_sme()) {
> -               unsigned long sme_vl = task_get_sme_vl(current);
> -
> -               /* Ensure VL is set up for restoring data */
> +               /*
> +                * Ensure VL is set up for restoring data.  KVM might
> +                * disable subfeatures so we reset them each time.
> +                */
>                 if (test_thread_flag(TIF_SME))
> -                       sme_set_vq(sve_vq_from_vl(sme_vl) - 1);
> +                       sme_cond_update_smcr(sve_vq_from_vl(task_get_sme_vl(current)) - 1,
> +                                            system_supports_fa64(),
> +                                            system_supports_sme2(),
> +                                            SYS_SMCR_EL1);
>
>                 write_sysreg_s(current->thread.svcr, SYS_SVCR);
>
> @@ -1250,26 +1254,6 @@ void cpu_enable_sme(const struct arm64_cpu_capabilities *__always_unused p)
>         isb();
>  }
>
> -void cpu_enable_sme2(const struct arm64_cpu_capabilities *__always_unused p)
> -{
> -       /* This must be enabled after SME */
> -       BUILD_BUG_ON(ARM64_SME2 <= ARM64_SME);
> -
> -       /* Allow use of ZT0 */
> -       write_sysreg_s(read_sysreg_s(SYS_SMCR_EL1) | SMCR_ELx_EZT0_MASK,
> -                      SYS_SMCR_EL1);
> -}
> -
> -void cpu_enable_fa64(const struct arm64_cpu_capabilities *__always_unused p)
> -{
> -       /* This must be enabled after SME */
> -       BUILD_BUG_ON(ARM64_SME_FA64 <= ARM64_SME);
> -
> -       /* Allow use of FA64 */
> -       write_sysreg_s(read_sysreg_s(SYS_SMCR_EL1) | SMCR_ELx_FA64_MASK,
> -                      SYS_SMCR_EL1);
> -}
> -
>  void __init sme_setup(void)
>  {
>         struct vl_info *info = &vl_info[ARM64_VEC_SME];
> @@ -1314,17 +1298,9 @@ void __init sme_setup(void)
>
>  void sme_suspend_exit(void)
>  {
> -       u64 smcr = 0;
> -
>         if (!system_supports_sme())
>                 return;
>
> -       if (system_supports_fa64())
> -               smcr |= SMCR_ELx_FA64;
> -       if (system_supports_sme2())
> -               smcr |= SMCR_ELx_EZT0;
> -
> -       write_sysreg_s(smcr, SYS_SMCR_EL1);
>         write_sysreg_s(0, SYS_SMPRI_EL1);
>  }
>
> @@ -1439,9 +1415,10 @@ void do_sme_acc(unsigned long esr, struct pt_regs *regs)
>                 WARN_ON(1);
>
>         if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
> -               unsigned long vq_minus_one =
> -                       sve_vq_from_vl(task_get_sme_vl(current)) - 1;
> -               sme_set_vq(vq_minus_one);
> +               sme_cond_update_smcr(sve_vq_from_vl(task_get_sme_vl(current)) - 1,
> +                                    system_supports_fa64(),
> +                                    system_supports_sme2(),
> +                                    SYS_SMCR_EL1);
>
>                 fpsimd_bind_task_to_cpu();
>         } else {
>
> --
> 2.47.3
>

