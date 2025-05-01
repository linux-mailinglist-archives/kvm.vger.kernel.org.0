Return-Path: <kvm+bounces-45132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE7EAA6158
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:24:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32A233BFE51
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 16:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0816F20DD51;
	Thu,  1 May 2025 16:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JEI27oxz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE6318DB16
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 16:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746116658; cv=none; b=UdJNp0ApiIrTpHflskvPG1xrzUZsTPvzPyuaHLFTcgh6B9z3JjYYgoLw14TC2Kz3n8h3v5z3W+zhSThIhLiBMZkzkWQN7gpXjdfQuB5Y5NtptOWcAFwZ6VstsFA4V84IWLJwetkIfyUU2M3B1bV0yE817cxXfhgKE5I/EjyadWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746116658; c=relaxed/simple;
	bh=uIG8+s9tonlQECXuI5z1Noq1lSxGnNt4+Jh2JbNQXpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OFV258fM59Bn4ECBi6xvQGaYiZUaWYoOX7ms5uMaVAR7R/T2ZQfH8Ida9rVJOzC1ihVgPSCUqYVm/5XNEgxpAPbhKGfosTsgyFJ3JfgKleSJAhUqKRYus6Q9hRzrPDEr33jJkmaa8DWD17WPEHXkc/yMRmLG56h0NwkDgzKAtm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JEI27oxz; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b1396171fb1so736017a12.2
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 09:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746116656; x=1746721456; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8shYTt0huEPDIa1HB4ziLet0D+S6VQEydJTXu8w/URY=;
        b=JEI27oxzNEXWw+CoqBy74F6VcJYYkGMpt12kqMsk6bzobwZfjZVQKuM8ihsv3z44xz
         gaIYxGkOqckFLXtyySppUCFw/0IsaXsCk0ZOhHcGflMtZhUHuzbseH0xT+5Ypt99AxJ2
         1UUSZP9abJnFxbEAObRI+l+2LKAJSyUqXO1UzijL422u/x/sgVueRBQ7Rt4Ze683FM2T
         KqVqRZfahd2hRwbq4AevjMfNM+hhJ0lfoOmXg69PP8jqy20PhBnjHPSDF6hsqBebVY6w
         ZGGObOTzZD8Z/ZjD0KifwZzRVb1hCze+b6vC4UdqCQTD2SvVle456AIV1udrhxdY4nMv
         PZ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746116656; x=1746721456;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8shYTt0huEPDIa1HB4ziLet0D+S6VQEydJTXu8w/URY=;
        b=RPWQ7wa59cT5eOaf+gT7+dJMEOG5PdKZlqBVd1vULDmY2xFI/yQG1d1WNKLH+EYd3x
         s7hxuXStM/bZghQaYsOlt7b4bOojFA5qccO7/Ww/NDbWkF72O3gBSn1amFMtTjewpF+o
         558cuaaagRLN3jHMdj84/0aNLyT2iGcm/FpKco3TGZ1M/mZ3TpDsorbIyPtXcAgMq+Tu
         TfdH9plpL66sS0L1q53VbmnabAXReclyh6W6mJran4H+gZXm6cz9UWq8qSpsMXPtwn+z
         EXqTUvDYW3vwxWCynooBdglAyC708b2u2s9WWpCaiu3xMg3jOloKtKb72rCZRRfphSuG
         NDOw==
X-Forwarded-Encrypted: i=1; AJvYcCVYE5oXtSRvhcJjTfCAowhGxmHK+eOhEyRdQAKkOfFLNWhvY9alPUiabCZnT6ag02xQdd4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx83CtPe2llvfOW2y9zH8exqWFKjfnKk31QD6KCdnHtWzr9zOQM
	Q3yccWx412TmwJ25NgkbGKywPRzJfjcOzfRwAVb//CdqHU9R0/FEP5t9HMilDF4=
X-Gm-Gg: ASbGncuAdFxoRQ425YVG7+TfZRR/LeqhwgkdRGa5VKTlM26A5JYz2Z/QYWWM926MGtV
	AgH2zq6u4yKLHS5fXVmqQaAVxSoBYotTfDXWemJt0ZN2H8pDPwZyeiClp+CaV3GlkxgJzErkfFz
	JaSvB7mzQwdC5cKSrQ/taAALwXp/QZtSuroiAT/zP9eAEezpzXzN9wNXfZJx/ZWhAAUEdQGAIAq
	GvCE5LEjQ4QhaLxYRWaJrh4Gc9yA6fK6BRcxChbJeUvXF8WAfuYntH97Nx29sJT56Uzko1V15qf
	2eGhYdV4f4UMZISrLqUu4+oLgPI1pHkTPdiFC1GAEPOzAJ2mxS7h6kV3Tvb6AhLGC4kql6AWihD
	tYggdPW9wf+MJMQyiPA==
X-Google-Smtp-Source: AGHT+IFp9RYUi3DTgZBnQQd1bJeJF3D8RFCuafFxfdL4LtCEbdgaydTH3sWqG75vv9BY+KKGRU4EGA==
X-Received: by 2002:a05:6a21:6d8c:b0:206:a9bd:ad7b with SMTP id adf61e73a8af0-20bd6556ebbmr5219945637.7.1746116655846;
        Thu, 01 May 2025 09:24:15 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1f9d6432aasm908860a12.50.2025.05.01.09.24.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 09:24:15 -0700 (PDT)
Message-ID: <a6fdb501-438e-4591-b166-87c8dbd14887@linaro.org>
Date: Thu, 1 May 2025 09:24:13 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 30/33] target/arm/ptw: remove TARGET_AARCH64 from
 arm_casq_ptw
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-31-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-31-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/ptw.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/target/arm/ptw.c b/target/arm/ptw.c
> index 424d1b54275..f428c9b9267 100644
> --- a/target/arm/ptw.c
> +++ b/target/arm/ptw.c
> @@ -737,7 +737,14 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
>                                uint64_t new_val, S1Translate *ptw,
>                                ARMMMUFaultInfo *fi)
>   {
> -#if defined(TARGET_AARCH64) && defined(CONFIG_TCG)
> +#ifndef CONFIG_TCG
> +    /* non-TCG guests only use debug-mode. */
> +    g_assert_not_reached();
> +#endif
> +
> +    /* AArch32 does not have FEAT_HADFS */
> +    g_assert(arm_feature(env, ARM_FEATURE_AARCH64));
> +

I don't think we need an assert here.

The ifdef for aarch64 also protects the qatomic_cmpxchg__nocheck below, because aarch64 
guest can only be built with a 64-bit host.

Are we still able to build qemu-system-arm on a 32-bit host with these changes?  It may be 
tricky to check, because the two easiest 32-bit hosts (i686, armv7) also happen to have a 
64-bit cmpxchg.  I think "make docker-test-build@debian-mipsel-cross" will be the right test.

If that fails, I think you could s/TARGET_AARCH64/CONFIG_ATOMIC64/ here.


r~

