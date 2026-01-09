Return-Path: <kvm+bounces-67583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A1FD0B6B5
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 17:58:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1DAA0303E413
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 16:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC15364E8B;
	Fri,  9 Jan 2026 16:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1MwnqwsA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD5630CDA1
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767977855; cv=pass; b=ZSDDvkz2oQ1+YKYXL6D/7v5//Xvhgbd2h+aG0C/C7O70ZrZJCPWw2C80gbZd10G6hgnxEpYrTll3YWVb/BwM1UjXlY2GGaQBShQ/dRJNzLJydFbwaYuxSXIlDMTf+/xhh+vRUVSJL9S2rvT8u7eV0X/+FYyuvfPUuBqBFIZELcw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767977855; c=relaxed/simple;
	bh=SkjHGF8FR8F2ZPGg4e/H1IK+TJO92/b+hbarPM46pt4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dtK7NjvS9MSsdiEcceCiDlOHxeBImSg8u2AvmDLnwzvC6YzIrR4TFXei/XRWUyCXtMUJt3nV2IoWZM0Sn7B4A3QsCIA3Fx9X6XG9Ki3SnNXLVEXNBPSiFDgbxoItwmEc96l/EAjQR73soUIaQ2w3NKd9BpfVN5V/DSYAutyse+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1MwnqwsA; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ee147baf7bso486651cf.1
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 08:57:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767977851; cv=none;
        d=google.com; s=arc-20240605;
        b=jyPz5CUieXFUOUk5q1oykSk75lQ6gM8bmuGkZl6VTDOnMJ7xl0aAFdOs2pAIj5sTdo
         EWF+5Ejz4WAd7pLz41QcIufN+rekXU15jimmW0WvReWiA4y9P3KbFC3DoJc4v2f2MN5p
         PWvpQl0trwAW7oLSQcsScynUTHJdPk8o9lk+PBr4p1WOAA91GVpjWC7P7V1RReOdFeaP
         Q8bwemXIOMcPscinLiikfUSdehXvuYqPoWXsOImnzKbvEQLRRWLRhDWwHhwsqdvNpvIQ
         yxbjDMZ97f+u3wMm0jmcBYzqxEeyuPH8T+tZc13ufHq0RU7HR9IFoQaJIvVZLaZgq+1c
         C9Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=MpztCWy9ipsSXHs0mL6YjlVmfult44YS26X504J/dJw=;
        fh=wZ+WwORvB7tCT+/AFltygZ2ywTjnt+oV72iS4kBcaw4=;
        b=K8MSgm/YZjUu5VwXpYmDjr2tfgJ/XWTBv3+VfcrFdFsXDuN/Ce/AhL7OIeCkpB9PTb
         QewE1yFRLLzBkJSQFlQky9hdxpVcis1rp+sppapHmrKweL7UZk3L6+41mevlX1Mg7ums
         8Hg44eN0i4Px1ZsSoCxixfekoc9H52uSuR5avbcu0vs1ZGRnqMNfXdpNuIUc/+1xRCRu
         1mrtJkMP7lhHOrBhrDcynHYaKZtwxRJ5titHheQeq8lm4smxBOfr2UR1O8nasQ+GEpjk
         ZfSXKBQ2pWXdbFcHNyAY2TatCTh29GXyk/ynQykCivmMrV5Hrl5gNKTJ/mW7EmMncrSs
         ByWA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767977851; x=1768582651; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MpztCWy9ipsSXHs0mL6YjlVmfult44YS26X504J/dJw=;
        b=1MwnqwsA56nPfeMq/y0NAzhBtPXZtuG+jenGXdhITh3WJ0bs686hgm+uz1VQbtAw92
         TILHKrK3s4MDEwKMcWyWMHGLQUhqJEbWgiANkchDVj9ajkdbAak9B6m+LBQI9asPtn4m
         Uo2ckqThpv7ixB/7aZzhUYz5e6CWwJ1nYvo0gdCanSSBXKNjOLdMqhL2xf+BsELr1AF3
         t9QAzrTEqk6cWBDjaUsJEoI1x5iP2ZFlhm/WAtzTMuKb8J5YTLStQJ9b527ZraSR/z7j
         YUNzdCFhs9i3osWszSz8pAmjxkwduZB+L7nIg4Ca/LKmRoS7wzTLyoyCIcx85ypwapiR
         Wwjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767977851; x=1768582651;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MpztCWy9ipsSXHs0mL6YjlVmfult44YS26X504J/dJw=;
        b=lD+6OTY5af7Uy3My506tQxCbI3rlmtoc0Z44XHF2NHzy9CQDEaauA82cdDjnNySkz/
         10nVUiPA0GjHIWtMepNKKYWJMrE5v6jcIdDgBFDmdAEaGH3VOCSjD9XudP2vV4zzA1UX
         EuM9vSYH1UtVT1kjLnx4zSFAIMFPk5rPC0Ks+ckIO+OD9rNEIeNVmcE1ux+N3zwd+GGE
         QPRi38BOxTeILQR2/vLePIyxWn2+1e5JwFupswJTmY+x1wj8Ae358wKeuy1TpWbQZfyu
         0+EltVSg0UkVXk2vheU78VL15vI3StBUk2lEhHTkUpIQb6xzAQ9ZHJQX2/bzp4JaepSA
         KcBA==
X-Forwarded-Encrypted: i=1; AJvYcCV47bUowshPP5Vh3FF/3RAKdDe4KprjcYA1zMJcZ4KSoHIjTBQeaI4etHkfd7J5HFp0XUc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+JWxtpcTWZHcaK8K4ptRAGuZ2p8CVZFx1JgEetnYdEIP0gBZL
	/Z6Yy6ZOiN9WtFrO/xkL9cJESbKPpC2mpahSnD+ZFfxsX0F5CuTVGaedpBJCP08BaOUwPstOZuC
	HXHO6AkR+jawl8CjZ5CCL/hGDEu+pA/pXqBr+do4y
X-Gm-Gg: AY/fxX5grFpNcnG4BwPS+828p7hkN4/vkAuqiuH5gtH0JVgiQW3T62pGB6I7tE5y6jv
	p9swfZNqmGWbioX2QK7DnkeeBkG3R+Dg5dQ7/lMEnVkdsXp0PKqyLze43bqEe5cKLn65tUg9mMZ
	vbx6DXeyeXYcadGJhohIbH5rHsGZoUhRLqoK9JObj6Slm4/u4LqHa9d1KhszatPjMtuXVsSArYc
	z2dTSIOtuml48vGTqM32bW+9/JzPYZ1kb6di0gx+0f0ei4TmpR+iePqlEGHBLeDOr97/+yl
X-Received: by 2002:a05:622a:198e:b0:4e8:aa24:80ec with SMTP id
 d75a77b69052e-4ffca38a667mr12955411cf.14.1767977851098; Fri, 09 Jan 2026
 08:57:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-16-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-16-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 9 Jan 2026 16:57:00 +0000
X-Gm-Features: AZwV_QiwST85CNc25KZYMBDJwxaQzBlftzyvIde5n_9dAYz2SEbvmx43n1faTzI
Message-ID: <CA+EHjTwTmjNEV+4w8w=LXfR0g_v7yHk1pQD+Oos8V3vFfEVdMw@mail.gmail.com>
Subject: Re: [PATCH v9 16/30] KVM: arm64: Support TPIDR2_EL0
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
> SME adds a new thread ID register, TPIDR2_EL0. This is used in userspace
> for delayed saving of the ZA state but in terms of the architecture is
> not really connected to SME other than being part of FEAT_SME. It has an
> independent fine grained trap and the runtime connection with the rest
> of SME is purely software defined.
>
> Expose the register as a system register if the guest supports SME,
> context switching it along with the other EL0 TPIDRs.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/include/asm/kvm_host.h          |  1 +
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 15 +++++++++++++++
>  arch/arm64/kvm/sys_regs.c                  |  3 ++-
>  3 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f24441244a68..825b74f752d6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -448,6 +448,7 @@ enum vcpu_sysreg {
>         CSSELR_EL1,     /* Cache Size Selection Register */
>         TPIDR_EL0,      /* Thread ID, User R/W */
>         TPIDRRO_EL0,    /* Thread ID, User R/O */
> +       TPIDR2_EL0,     /* Thread ID, Register 2 */
>         TPIDR_EL1,      /* Thread ID, Privileged */
>         CNTKCTL_EL1,    /* Timer Control Register (EL1) */
>         PAR_EL1,        /* Physical Address Register */
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index 5624fd705ae3..8c3b3d6df99f 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -88,6 +88,17 @@ static inline bool ctxt_has_sctlr2(struct kvm_cpu_context *ctxt)
>         return kvm_has_sctlr2(kern_hyp_va(vcpu->kvm));
>  }
>
> +static inline bool ctxt_has_sme(struct kvm_cpu_context *ctxt)
> +{
> +       struct kvm_vcpu *vcpu;
> +
> +       if (!system_supports_sme())
> +               return false;
> +
> +       vcpu = ctxt_to_vcpu(ctxt);
> +       return kvm_has_sme(kern_hyp_va(vcpu->kvm));
> +}
> +
>  static inline bool ctxt_is_guest(struct kvm_cpu_context *ctxt)
>  {
>         return host_data_ptr(host_ctxt) != ctxt;
> @@ -127,6 +138,8 @@ static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
>  {
>         ctxt_sys_reg(ctxt, TPIDR_EL0)   = read_sysreg(tpidr_el0);
>         ctxt_sys_reg(ctxt, TPIDRRO_EL0) = read_sysreg(tpidrro_el0);
> +       if (ctxt_has_sme(ctxt))
> +               ctxt_sys_reg(ctxt, TPIDR2_EL0)  = read_sysreg_s(SYS_TPIDR2_EL0);
>  }
>
>  static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
> @@ -204,6 +217,8 @@ static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
>  {
>         write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL0),     tpidr_el0);
>         write_sysreg(ctxt_sys_reg(ctxt, TPIDRRO_EL0),   tpidrro_el0);
> +       if (ctxt_has_sme(ctxt))
> +               write_sysreg_s(ctxt_sys_reg(ctxt, TPIDR2_EL0), SYS_TPIDR2_EL0);
>  }
>
>  static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5c912139d264..7e550f045f4d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3504,7 +3504,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>           .visibility = s1poe_visibility },
>         { SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
>         { SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
> -       { SYS_DESC(SYS_TPIDR2_EL0), undef_access },
> +       { SYS_DESC(SYS_TPIDR2_EL0), NULL, reset_unknown, TPIDR2_EL0,
> +         .visibility = sme_visibility},
>
>         { SYS_DESC(SYS_SCXTNUM_EL0), undef_access },
>
>
> --
> 2.47.3
>

