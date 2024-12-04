Return-Path: <kvm+bounces-33050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6FBB9E4033
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 17:57:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0EA916766A
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 16:57:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A7920CCFC;
	Wed,  4 Dec 2024 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c3Oyxv/k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4763B20CCEB
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 16:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331460; cv=none; b=FL0KRKTqlGZeCBXD063GEnfyHPIY94EdI3RKI6lLqMgzYjdpwAGoYL+PKzUJ5RJSiQjFNY9pSdaM6vFH8ge+6C3V+yDDHqAphSuZyQyNPpenzSmguV0JeaR5m4WAmvrAAKxeGtXNl4eJXCFxt2w2iBkgczhKIP8bH04gwyg7o68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331460; c=relaxed/simple;
	bh=0HUzdTNj6kvO/sxYp+pg359CCM/bjPbiDVwJpcSLg88=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ryxwyOBcHtxn1NB0YMjh6C/Gf1keF09jyUJakKKAoWa8gecyV00RIFI/o9sri0Bt2jMk3pKJWSvTKpLbiAT+WC3sBViqFfIunuykCW93sOv+UqqIdOtNlzjveJ/2ss4in7ogaRQ/ITmjJt4kU3lA/9FbgTx5feW92OedU8pCjBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c3Oyxv/k; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3a781e908a7so158905ab.0
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 08:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733331458; x=1733936258; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sfmZWfaFUyauxIzYDnk1HIum5vCQdB8u8dJVsYfif1M=;
        b=c3Oyxv/kzmiznaUPrXSJLDY2VK/2Q8b6RHMmOV+84ItJ5kf1coPkvNo4uaCfXX3Hus
         P2JQFiBFvU1rmXRcv1inBFHLIkVUhsIg6Py7efPMdXMGtzNbqNBrEjLpM3xEsCsjIzch
         zgW9zKD/BWtYxxt4oqSoaYDzAv2voAYJDIqgOjhdDQktwvuAoZ3Boo4a8OZtJRlwBZww
         X+64LOK8FaNCz48IZn+ZECmrJlQRfM0lyVjjxanyb9ohtn9O/cxi2LuzTUpw7ahBSPIk
         Vr7bDC7abhJos4jx880eYCiQZM13O6C5Ro2YqO93PuM14OO4IQnGkvL/NxVTdSOmCt5t
         HyqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733331458; x=1733936258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sfmZWfaFUyauxIzYDnk1HIum5vCQdB8u8dJVsYfif1M=;
        b=E24SlsEc+FhDg72WK9fdO1pMmPNqt9hCV/ly3zsvcOEDgUgI2TqlWuc06Fdp2LmcvG
         FZqT1DJOXeKwNKI76i0msg6LEi3LJ8D+sUPeL1+dRZ4GhgbIDwPTdzfzQ6zCV3VIlhHk
         ETMq0WB0bNQDgvy4o4ng1Un71BoKZKuWvlBojhY3L8gCKgw4lCFFynfCD1Gr6pLpcEiP
         HiIDdZ+FxA7K8oHaOLSTdJtuajU3cm2Qap9Szj//C60jSDuvUQfYYG8CL3esOhOCmJOG
         GOxhyxQT7hGR1PKE2CnVQZoW5jlNc43wmI3XsviFVElUos6E/yt3/E/llpGK3FS/oI0v
         ysvg==
X-Gm-Message-State: AOJu0YwJ5Spg4/MwFB+1LDNDZ8n1l1an1w9OABb09jDxsVHXMdFrseEC
	2K+2+XxTS0+BSrfshpyhqN9nJVP9HudsapirKtTu01SYrW7p0DpwWAJHDku92CdmvcTviBhaP5p
	QWW5nGbyE500RSsVDbng5UEvIld7sd3v/UsaK
X-Gm-Gg: ASbGncveR4Ah9AmmJBekGSATUoEzeTAlDWvgZZmOQwmjl7vqro4UkE8+kWRyfGDhKZm
	oJ3zB89w1Z4JiZ5nwmTYc1rUDnTswaw==
X-Google-Smtp-Source: AGHT+IGsVjekEc6VwhrFlrIDeAOXUGOndFAXAYVwx/+uQqFZtni53tvqfJXUpqrgjf1M2MWknzQGCI3eZVcZBFQ1W38=
X-Received: by 2002:a05:6e02:370a:b0:3a7:a468:69df with SMTP id
 e9e14a558f8ab-3a800ab423fmr3177165ab.3.1733331458201; Wed, 04 Dec 2024
 08:57:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204134345.189041-1-davydov-max@yandex-team.ru> <20241204134345.189041-2-davydov-max@yandex-team.ru>
In-Reply-To: <20241204134345.189041-2-davydov-max@yandex-team.ru>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 4 Dec 2024 08:57:27 -0800
Message-ID: <CALMp9eRa3yJ=-azTVtsapHsfCFTo74mTMQXPkguxD3P8upYchg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] x86: KVM: Advertise FSRS and FSRC on AMD to userspace
To: Maksim Davydov <davydov-max@yandex-team.ru>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	babu.moger@amd.com, seanjc@google.com, mingo@redhat.com, bp@alien8.de, 
	tglx@linutronix.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 5:43=E2=80=AFAM Maksim Davydov
<davydov-max@yandex-team.ru> wrote:
>
> Fast short REP STOSB and fast short CMPSB support on AMD processors are
> provided in other CPUID function in comparison with Intel processors:
> * FSRS: 10 bit in 0x80000021_EAX
> * FSRC: 11 bit in 0x80000021_EAX

I have to wonder why these bits aren't documented in the APM. I assume
you pulled them out of some PPR? I would be hesitant to include CPUID
bit definitions that may be microarchitecture-specific rather than
architectural.

Perhaps someone from AMD should at least ACK this change?

> AMD bit numbers differ from existing definition of FSRC and
> FSRS. So, the new appropriate values have to be added with new names.
>
> It's safe to advertise these features to userspace because they are a par=
t
> of CPU model definition and they can't be disabled (as existing Intel
> features).
>
> Fixes: 2a4209d6a9cb ("KVM: x86: Advertise fast REP string features inhere=
nt to the CPU")
> Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
> ---
>  arch/x86/include/asm/cpufeatures.h | 2 ++
>  arch/x86/kvm/cpuid.c               | 4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cp=
ufeatures.h
> index 17b6590748c0..45f87a026bba 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -460,6 +460,8 @@
>  #define X86_FEATURE_NULL_SEL_CLR_BASE  (20*32+ 6) /* Null Selector Clear=
s Base */
>  #define X86_FEATURE_AUTOIBRS           (20*32+ 8) /* Automatic IBRS */
>  #define X86_FEATURE_NO_SMM_CTL_MSR     (20*32+ 9) /* SMM_CTL MSR is not =
present */
> +#define X86_FEATURE_AMD_FSRS           (20*32+10) /* AMD Fast short REP =
STOSB supported */
> +#define X86_FEATURE_AMD_FSRC           (20*32+11) /* AMD Fast short REP =
CMPSB supported */
>
>  #define X86_FEATURE_SBPB               (20*32+27) /* Selective Branch Pr=
ediction Barrier */
>  #define X86_FEATURE_IBPB_BRTYPE                (20*32+28) /* MSR_PRED_CM=
D[IBPB] flushes all branch type predictions */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 097bdc022d0f..7bc095add8ee 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -799,8 +799,8 @@ void kvm_set_cpu_caps(void)
>
>         kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
>                 F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLoc=
k */ |
> -               F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr =
*/ |
> -               F(WRMSR_XX_BASE_NS)
> +               F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | F(AMD_FSRS) |
> +               F(AMD_FSRC) | 0 /* PrefetchCtlMsr */ | F(WRMSR_XX_BASE_NS=
)
>         );
>
>         kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);
> --
> 2.34.1
>

