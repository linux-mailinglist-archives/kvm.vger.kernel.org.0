Return-Path: <kvm+bounces-44728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB2CAA0889
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 12:29:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E14887A3785
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 10:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E58FF2BEC28;
	Tue, 29 Apr 2025 10:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wuRlCHC0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412941E766F
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 10:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745922534; cv=none; b=TupV2nBts/vGpWQCJOI1nxcTkMT38cd6XVCLsjV/j5o5aONvtrvDRBfr11/H0O6bcJhdkumuWpI0MwpwMPiMZVqcvxGGD8EfJa2rOWuG+H14zMOMHLKQSC16TDHrtTqQ3++Ax+dyh01sb4CFZIjxXxCD4DxR0ye+0TidaSuzOHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745922534; c=relaxed/simple;
	bh=kWFpCGBiQMVNQPHa6SwC2pqaJRAQDlQA2QAGbOC89Qk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Z8CoCPxBebjYnD0Frb3gIPMOCvEfS4y9Go7T99AsFMxRym+1T8Mg2O1aMshg09S3O1mxWS68WPDcEtkrICnOThQsmNU4OpHXMGFV3WSQjPBUq2aqM/tvpJM+8LMpPWiQgjITHGCOBYSrdJb2a8mcqik6tJQFaO+m13SZoYUWN+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wuRlCHC0; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aca99fc253bso878227066b.0
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 03:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745922530; x=1746527330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4rOWVjl/1DXK0gZtSfaoRm6OeA5/IKVvn80lwHtioKQ=;
        b=wuRlCHC0EGLmw6ymggpmhjf/GWuf2ZN5RaNGsov9BPmabrsemOcWMy4dOJ9lxrNArE
         gfMe/p1/lD2Vm5J7fEf5NOCyi8aMwlcXe/ofKN5A5QWBRBFKPtz2iMWa4vNv+mTN7US/
         Oeq+W32VPKIJkc6Wq+GuVzbRe3X0nr9xJiFL7jQ5LvaPvJh0I1oQuxuJaB64WTppUgOL
         qPPiBYn/pZCMeQ2pPOAFVPGP9ashbWHEZkgTPD5U9/NsPEHeDVIFnO247lWHdDH2l680
         FNDGhATct3CMu5twl5JkaBjl1CldPKhtJftZul1rFqVsQ97un03pZfzOXjaWT63VKKOy
         C6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745922530; x=1746527330;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4rOWVjl/1DXK0gZtSfaoRm6OeA5/IKVvn80lwHtioKQ=;
        b=wA3Z2w3WzG83rIK7buLWxTAXXmQvmREOjSNeSzOjidohhr2WS4BCN0YoqjJLi1fmtY
         dMV0RkseoKVQwR3yzqEDaFRw6J+nAbNaaYCwzU19Ng6NE0ddLZF8ZTId001Y8n2RMC8V
         TrqEl0oJ4atOy0DxvTWUx9fWZQ5CD6gE0NZuOTU7ftN3f9VIZb4dWIKNm9p3z8Ifwktb
         0RT8twVAlajQV6JpucviH1PDeJct7TPGABg/qPUDBk2bVGlYSgwGy561FAX8q7uT9xik
         QY+xUNweEbPVjzU6zfAc0hyjHuBFd7I0NhaQcD+QwMTBI8O3PFI/blbS9AK1AqmamZqk
         ZO+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUk/Z+5j/AIcnFCLR30P1DxdtYnvvezCqQRiuKnSrlQbogmxoesddrsKuzwSDN6oUbgasQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWfXYR4k6BN4RA2eOo79rZp4BEZtPp3gTR63heiLvw3XXPAPUO
	k4+j5xzvTET271xaJl+2lgNTn7iZ7VwYlNtfF2AFgrqcM7Lw/srr5jlhJafr1zQ=
X-Gm-Gg: ASbGncu8nzwdqOHCi5yqY70G1J492ZtRkjmcPyHNkXxqKbEneaeOvIjm7WqreQB3Oat
	D8aESHKvFZpODM14XMgSb1i9bA2ronrlR8smk46q09tPvVGuO4qnrKgXwEH6IDtu4CUvRP+IrSe
	LfwMU7qVdHQsYGl2dyIhQAdeRcAo2Mwep0kFe2EJCtXcn2l1+aKrfqWbGrhXuKeE1wZtnWP1ON6
	wa0egrGeBSrNsE3vGZFA55yoJJtm5+gsjXOrp0BK1Uke4ozK/FZdjlTuWlf/z2gaZ46S/17/bJl
	z84jre7v+TOanTHlF9KaXMg1Jj+aNYy6zzlJ7SBpDpM=
X-Google-Smtp-Source: AGHT+IEBZUnAyyYT54h37+wjYFYJg0lSj5oXqRABO3XpWGJh41kqGVVuJO5FVEJvP6bxnQODDW7u2Q==
X-Received: by 2002:a17:907:6d27:b0:ac4:169:3664 with SMTP id a640c23a62f3a-ace8493c5e0mr1133416666b.33.1745922530486;
        Tue, 29 Apr 2025 03:28:50 -0700 (PDT)
Received: from draig.lan ([185.126.160.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6ed49c2fsm752361666b.124.2025.04.29.03.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 03:28:49 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 1BEF45F863;
	Tue, 29 Apr 2025 11:28:49 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org,  Peter Maydell <peter.maydell@linaro.org>,
  kvm@vger.kernel.org,  Paolo Bonzini <pbonzini@redhat.com>,  Philippe
 =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  qemu-arm@nongnu.org,
  anjo@rev.ng,
  richard.henderson@linaro.org
Subject: Re: [PATCH 05/13] target/arm/kvm_arm: copy definitions from kvm
 headers
In-Reply-To: <20250429050010.971128-6-pierrick.bouvier@linaro.org> (Pierrick
	Bouvier's message of "Mon, 28 Apr 2025 22:00:02 -0700")
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
	<20250429050010.971128-6-pierrick.bouvier@linaro.org>
User-Agent: mu4e 1.12.9; emacs 30.1
Date: Tue, 29 Apr 2025 11:28:49 +0100
Message-ID: <87msbz45y6.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:

> "linux/kvm.h" is not included for code compiled without
> COMPILING_PER_TARGET, and headers are different depending architecture
> (arm, arm64).
> Thus we need to manually expose some definitions that will
> be used by target/arm, ensuring they are the same for arm amd aarch64.
>
> As well, we must but prudent to not redefine things if code is already
> including linux/kvm.h, thus the #ifndef COMPILING_PER_TARGET guard.
>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>  target/arm/kvm_arm.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index c8ddf8beb2e..eedd081064c 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -16,6 +16,21 @@
>  #define KVM_ARM_VGIC_V2   (1 << 0)
>  #define KVM_ARM_VGIC_V3   (1 << 1)
>=20=20
> +#ifndef COMPILING_PER_TARGET
> +
> +/* we copy those definitions from asm-arm and asm-aarch64, as they are t=
he same
> + * for both architectures */
> +#define KVM_ARM_IRQ_CPU_IRQ 0
> +#define KVM_ARM_IRQ_CPU_FIQ 1
> +#define KVM_ARM_IRQ_TYPE_CPU 0
> +typedef unsigned int __u32;
> +struct kvm_vcpu_init {
> +    __u32 target;
> +    __u32 features[7];
> +};
> +
> +#endif /* COMPILING_PER_TARGET */
> +

I'm not keen on the duplication. It seems to be the only reason we have
struct kvm_vcpu_init is for kvm_arm_create_scratch_host_vcpu() where the
only *external* user passes in a NULL.

If kvm_arm_create_scratch_host_vcpu() is made internal static to
target/arm/kvm.c which will should always include the real linux headers
you just need a QMP helper.

For the IRQ types is this just a sign of target/arm/cpu.c needing
splitting into TCG and KVM bits?


>  /**
>   * kvm_arm_register_device:
>   * @mr: memory region for this device

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

