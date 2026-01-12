Return-Path: <kvm+bounces-67820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A237D14A5A
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 19:03:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 96EEF303E40C
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D62A37F732;
	Mon, 12 Jan 2026 17:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z9wZuziO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB20829AAFA
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768240798; cv=pass; b=B0HrOOtRk62RUSkYlcn3HLkwD2n6MeqS6EvakIBwMrVfr26bGc/eRg7E3ZHhpfJ1eNakl/QKzBZILJNpyh3T7SN3Cb/fblVUp6E6cwsv2OXo4BgF3FkJQ9EfpF2KRzAjvleDjM/gz+4/j5Ysr6Nh1kUGtvnawV2FCUkvqXS2UxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768240798; c=relaxed/simple;
	bh=W2KRaBZYvG8HVg3eIWgL8kg0vNUppturNmvWPxflHbg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ryeO5GKmp8V2L5E+sDcoL1H01s16yueIYm07iHOiDHVUxR7g7KQ7Y7Y9E4v5WS5/A+vlhTv1SUfP0rsltIfbNbedKT/GgwHmPPrnlQHYe5V4xIZRrDGwZKc43TaR38GAVDW6/BuMThxAxn+OXW/0BoH7ie+Fgp0KYpTIO6H8tWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z9wZuziO; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ee147baf7bso81cf.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:59:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768240796; cv=none;
        d=google.com; s=arc-20240605;
        b=IjcAigquLlAHB6ibq/0cKv0fKPrvbaNAsJ2G6rO3ox0B8p5tLg9jZhabQUAbuMNNtj
         uE1tTnBn/35LaQntHEBAl+QV9BEGmF0J6eisvNpr/GgPLXEGs09IVJLlAZ0Ax2fuP2fI
         hrTmFjzD0jdCzeMALO2v//POGE+bbtgRlEGCxGkSDtz4Y9mcEAwoocuusR6nqIodDWNL
         WrTRPoWiSXfPbJEmDL8KwpP7VJYUHRo/vVhcRTObHCXFthqrlvUP600R5cqSL0APyerZ
         ajGyBS7n2/vXFFq2O7MZlKYHg9SKOaXMWFy3IhFJwku4gy1aF1xv3ygeq/YIavji7OiN
         2S/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bJjpEAphM/NB+/t61DhxYCEIiQ3uh5viKOO+at6PH6g=;
        fh=GtkDn9RefXOFR8nNio1cYhYmwjB5tafO2C+sB21NeBQ=;
        b=GE+AxZ5f5rDHQI+L9+LzTdqqjrRH/22+nOTb5DOzE6zZm4xoFLlZWg1npBaJqwKXNW
         QMs7n6RNPVaRD2t014YXDZZWz6WsXD/FkQANNge1hxjPQ517NYLwPn67VQ0G6Evl0vtz
         LOYeW77TgYXtsB9YVY1xFh1HXsX61K4peyHDEtrH9WSvCQNOM4b13SLjzT6pvZ9oejsD
         Nair0whIoUDxA4IhWi9BdkcbIEi73BwAKV4Pvw41YkCUFIoa2KiNazaCbLWdIukI8lVe
         jGmLMaS2u80DULlq/F4P290lsHq5UjXWIs4nU399rLRe5adqQmKZ7QJpZ6dMjJFFWjRE
         +uyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768240796; x=1768845596; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bJjpEAphM/NB+/t61DhxYCEIiQ3uh5viKOO+at6PH6g=;
        b=z9wZuziO/HLkdQvgQlLAQeD650exNhp3chBXsmGignnysuk3g8vtBx1tED3fq1fp4Q
         XhTgrjRzniyPykzbI6ggldfLy+EjSZasJ35/9ajLagge7t0vh2BXqLgpImUxaaPoOQcW
         bSC4xSd+TvNOPXWGo7j0YTfRHjN+2HSfNlvTByBKZByVx2gp1OG7oRNk0O3wvb1aFTHF
         VHkUx9DJ1pGTd3RcznuGvaeN07uJWRAs6zOioLQxmotS/fb/C+HsOT9LgSDJGLAOP0Z3
         DC4YQLiWJYS2c7vAxx0kna8t8o1uAwOt8Rc7U98llPuwua9DowDDG6gPNWZUS4OpWnus
         YbKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768240796; x=1768845596;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bJjpEAphM/NB+/t61DhxYCEIiQ3uh5viKOO+at6PH6g=;
        b=uVQ0ftUSo8BBZ+VUptkrR/Wno9WkVmvoPtKIuNaacUHpxu3C7PB1K8SFC6ppXKhaqp
         iR1tA6kZCb7SpuO4c8TPfF9gLLsQF6Mk1cQbOB59HTdj3wtWmQAbi3weF5CkB8r9MaFE
         M+jyRX7ONsBekVLHmRMVWDsjJhtRTcw9KzfDgkBUae6TTjexJ0XqvZwbPZHYH2dOY586
         jNT1jn77ZMJZ6fsXLDty8I3plWEX1pX3V6jljemulSoxH8yoRPsMtowDYe1YOmXNgec1
         Oynb2kS6e1VXPuE8VeOmetNhOCX9FCSU6R/fv0gGJw5oK9raA6vQ/B62VNGHEviGCzmq
         Mkyw==
X-Forwarded-Encrypted: i=1; AJvYcCU+bf+68KpV+OcZven+KVtwMR4pyZpZD2ffPzTmcS60Ely0Kc0vRL8gXiP0F92Ar+mhI5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdOLVh+6AZRqeXh9623EsAysiBYtrxY+cxjSr0hHw2nw1DlvnT
	3Q830WOBGekLjB3S+r4YPkfCC81QYJEPLyFw+CWSs1w6kWrzKrH02OlXfplMcjVS2QlzceG7ZR7
	mH7MBnExJNDzWjzYxbU9PQu8AUAzolkOWSR61/1Mx
X-Gm-Gg: AY/fxX5p3bDKimt8elLScOg/8mpgHSD8zhgRQqBwGnL6TlA8gtjKpW9G77FIZ+2/jCx
	Uu5ivkbZhwfyoVvBrTP9lUHnoz6fZFdAeutjwr5wEyyH5IHbm4xeI3D/N8VSCpk4G4kGga4nmQg
	NrTZcX1CERRt9MnvcuTyMx02iXWJLxj9mTlrJ2/vzPwf2+03WaGiTsVl5HCHrMHC5H28uT3DF2F
	IIvxjsoXbq2VDwfx7vMuvzjjU0hhnEicEmSPjl3qxuFPonJXCOEmRSPPoG7kZJD7moqx6w8
X-Received: by 2002:ac8:7dc5:0:b0:4f1:9c3f:2845 with SMTP id
 d75a77b69052e-50119766a66mr21632291cf.9.1768240795172; Mon, 12 Jan 2026
 09:59:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-19-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-19-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 12 Jan 2026 17:59:17 +0000
X-Gm-Features: AZwV_QiQU0Otl0OZ50pDvqjq5GLQexN4JJXUaeH6JoNDjhaymp7I-l_cuFsktUI
Message-ID: <CA+EHjTwQ4fLBE1YXoB6M0eamSgGDW=nfLaC+-_surBfVbh3byQ@mail.gmail.com>
Subject: Re: [PATCH v9 19/30] KVM: arm64: Provide assembly for SME register access
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
> Provide versions of the SME state save and restore functions for the
> hypervisor to allow it to restore ZA and ZT for guests.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_hyp.h |  3 +++
>  arch/arm64/kvm/hyp/fpsimd.S      | 26 ++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 0317790dd3b7..1cef9991d238 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -116,6 +116,9 @@ void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
>  void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
>  void __sve_save_state(void *sve_pffr, u32 *fpsr, int save_ffr);
>  void __sve_restore_state(void *sve_pffr, u32 *fpsr, int restore_ffr);
> +int __sve_get_vl(void);
> +void __sme_save_state(void const *state, bool restore_zt);
> +void __sme_restore_state(void const *state, bool restore_zt);

Would it be a good idea to pass the VL to these functions. Currently,
they assume that the hardware's current VL matches the buffer's
intended layout. But if there is a mismatch between the guest's VL and
the current one, this could be difficult to debug. Passing the VL and
checking it against _sme_rdsvl would be an inexpensive way to avoid
these.

>
>  u64 __guest_enter(struct kvm_vcpu *vcpu);
>
> diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
> index 6e16cbfc5df2..44a1b0a483da 100644
> --- a/arch/arm64/kvm/hyp/fpsimd.S
> +++ b/arch/arm64/kvm/hyp/fpsimd.S
> @@ -29,3 +29,29 @@ SYM_FUNC_START(__sve_save_state)
>         sve_save 0, x1, x2, 3
>         ret
>  SYM_FUNC_END(__sve_save_state)
> +
> +SYM_FUNC_START(__sve_get_vl)
> +       _sve_rdvl       0, 1
> +       ret
> +SYM_FUNC_END(__sve_get_vl)

Since this is just one instruction, would it be better to implement it
as an inline assembly in the header file rather than a full
SYM_FUNC_START, to reduce the overhead?

> +
> +SYM_FUNC_START(__sme_save_state)

I think that this needs an isb(). We need to ensure that SMCR updates
are visible here. Looking ahead to where you introduce
__hyp_sme_save_guest(), that doesn't have a barrier after updating
SMCR. The alternative is to call the barrier where it's needed, but
make sure that this is well documented.

> +       _sme_rdsvl      2, 1            // x2 = VL/8
> +       sme_save_za 0, x2, 12           // Leaves x0 pointing to the end of ZA
> +
> +       cbz     x1, 1f
> +       _str_zt 0
> +1:
> +       ret
> +SYM_FUNC_END(__sme_save_state)
> +
> +SYM_FUNC_START(__sme_restore_state)

Same as above.

Cheers,
/fuad







> +       _sme_rdsvl      2, 1            // x2 = VL/8
> +       sme_load_za     0, x2, 12       // Leaves x0 pointing to end of ZA
> +
> +       cbz     x1, 1f
> +       _ldr_zt 0
> +
> +1:
> +       ret
> +SYM_FUNC_END(__sme_restore_state)
>
> --
> 2.47.3
>

