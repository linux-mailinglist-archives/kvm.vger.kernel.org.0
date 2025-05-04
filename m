Return-Path: <kvm+bounces-45342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D115AA87F6
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 18:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFBDA177301
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 16:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66DE11D63C6;
	Sun,  4 May 2025 16:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CrF/vHP3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07AA8F58
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 16:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746375635; cv=none; b=V+jqxGZUq8+hFT5L5aJbKESF3kGJR1PkDw0gHvFOrOAHNK21blEmulXZ66kExpYTtuhfakxiYwxmLxLWZkR+RpUEvbclch7PPO21+5JgvbNH5EfAD1P3fRTv7huaoRRRshUaZ402HeK4hUVkai4EUOZxDSisJkivoYuliXIYM7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746375635; c=relaxed/simple;
	bh=rn/0XHyZ8yAL0tP7Rhd1DJJSB8auw3TsQFR51Hj4zzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zz8dk5DElE4BRaMzI/j6ETk9GMVUCUwCYTQrdSdUYJBL3wuxUkWtYezI+bxPqT5P42Ns3FXtwmdf+4Ft10/fZetTKKx4wxsAWTGVCzfZgtR2+Qd+hsWoRzXbiLoiIOt19kDkUCAEXG1X5TOxVApqWeWaErTsDwAtOROEt3v09BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CrF/vHP3; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-736b0c68092so3221632b3a.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 09:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746375633; x=1746980433; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zJHceEEkeyxcT3zd6mSkgQuCloVcRXc5aoVen58Kk/E=;
        b=CrF/vHP3Y1tK1RJjD+oWCgcBO8+D6orCz7CVY0VrDemk/qyB4lrisnmXkNwhtJj3Mu
         a9RBtke6H2z7FOxHEWnE1Y4C+bsGkKm1QUz9cizwt3nB8l3ZX+m78Zd5BY+EwL6UnbvV
         flw6NjLUj2C18SCYTGh383+NMd+y8CBOT+Vjresx/tlkewbd7cCbaqcavJx0KjpmYw+5
         ZgQzkN19IRfLmG3ipFVQwWrVSnbTSEH5c6FMEQAq0cYYLMbyY4dMGrzo3yzN/bnJUYTn
         SK9ymJOjFfcmgYclHrr7y/A2EEW8MozSULVp2gVTTapqnt6ezP/3hqQQzDiR25GcGDOJ
         JxAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746375633; x=1746980433;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zJHceEEkeyxcT3zd6mSkgQuCloVcRXc5aoVen58Kk/E=;
        b=xAr0o7RNPwINIouqHYeOzExCiyfBWoxSIgzRG9rIaZgS/tT2bMIubATh3+TiaMGMpz
         ksO/sCA/C4j9oByVImkdn+IeOFJj+ITwrgWRvYnXB+rqwYZbhf7ylx1q0dIAHEP1dobj
         Ud0LyaQt4U7PiXLQSlIC/U3G0kVNa20xy37wZpMJ6cRhmayPm14RM8pKI3tzN2LnVskM
         vxcPyMPa0HkRxvx+zqE3yPzEOJw4aXR24QyPo6fSPFPp5M6TLVxOjR8inHqcUXsoHhmD
         ofr+iYsj3B2pFlWrKCqlqUO6jkbPtfxhhtWlWXe0vWm2oLQVSDXE5TyKNB2AvDhiE1Cs
         HJjA==
X-Forwarded-Encrypted: i=1; AJvYcCVRIWeT/5Z1HlfQxwFfaBHamHbQl3FsrHQAUW0aVXxjM3AYcFykI8FOaWAnpLjajYJzbcI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUVTF46KpURC4LbwQFftB4LUn0RMCb1p6TQR9hVyclifhqed7m
	lJqK9Xox41ahzQ1hTHaWSU4c0uD3pg/IhcFWDJCX4gcvIaxHfBgG4XvoqVTaKn8=
X-Gm-Gg: ASbGncvObs0Tb+S9Phwqm6BxEk2CZZBlmHVKZ5SmxbNRAM9GLL59npMoA/kQU6+hPyU
	1y1NPWuOoEs6wCRASwGeACW6yeZmTYBhQyD8CHJRgxYDj59KCczH4B9F/4ugBbUAjLyp6Rkpf8W
	P908X4SN/OyfyWfP7XfpXbBkN645yMs24w21tmqz8kNP8xOlyuKdmpkJ1XgWeQyWuDxpNRvbaIF
	PtKv7Bk9A0ksztOro8j29oa9v656ma+dglzrpkqbI09fosX+oTebu0lw4b+JVXJL5j3W+Xo9CtC
	fneIRV55zuN+jyL/aG6Wux5RpkkZ5x4qAKghFmrHLNcBelqNX31F4JX7m7uGazKTobIwkROVeh9
	lockyGc676kAtQl8oag==
X-Google-Smtp-Source: AGHT+IGtwwpdCoFgoeHENo7R8imMlsVj5gbbGhDx/+eRpKnO+uoh+dxjP4dhQqBg49qM6YaKXQNzeQ==
X-Received: by 2002:a05:6a00:6ca1:b0:736:5753:12f7 with SMTP id d2e1a72fcca58-740589050bdmr16062495b3a.3.1746375633152;
        Sun, 04 May 2025 09:20:33 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7405905d029sm5162896b3a.134.2025.05.04.09.20.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 May 2025 09:20:32 -0700 (PDT)
Message-ID: <2ce2b462-bce7-4160-b8fb-98ca2409df55@linaro.org>
Date: Sun, 4 May 2025 09:20:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 37/40] target/arm/machine: remove TARGET_AARCH64 from
 migration state
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, anjo@rev.ng,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
 <20250504052914.3525365-38-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250504052914.3525365-38-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/3/25 22:29, Pierrick Bouvier wrote:
> This exposes two new subsections for arm: vmstate_sve and vmstate_za.
> Those sections have a ".needed" callback, which already allow to skip
> them when not needed.
> 
> vmstate_sve .needed is checking cpu_isar_feature(aa64_sve, cpu).
> vmstate_za .needed is checking ZA flag in cpu->env.svcr.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/machine.c | 4 ----
>   1 file changed, 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

> 
> diff --git a/target/arm/machine.c b/target/arm/machine.c
> index f7956898fa1..868246a98c0 100644
> --- a/target/arm/machine.c
> +++ b/target/arm/machine.c
> @@ -241,7 +241,6 @@ static const VMStateDescription vmstate_iwmmxt = {
>       }
>   };
>   
> -#ifdef TARGET_AARCH64
>   /* The expression ARM_MAX_VQ - 2 is 0 for pure AArch32 build,
>    * and ARMPredicateReg is actively empty.  This triggers errors
>    * in the expansion of the VMSTATE macros.
> @@ -321,7 +320,6 @@ static const VMStateDescription vmstate_za = {
>           VMSTATE_END_OF_LIST()
>       }
>   };
> -#endif /* AARCH64 */
>   
>   static bool serror_needed(void *opaque)
>   {
> @@ -1102,10 +1100,8 @@ const VMStateDescription vmstate_arm_cpu = {
>           &vmstate_pmsav7,
>           &vmstate_pmsav8,
>           &vmstate_m_security,
> -#ifdef TARGET_AARCH64
>           &vmstate_sve,
>           &vmstate_za,
> -#endif
>           &vmstate_serror,
>           &vmstate_irq_line_state,
>           &vmstate_wfxt_timer,


