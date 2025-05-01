Return-Path: <kvm+bounces-45108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2480AA607B
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:07:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E1E4189D3A1
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CADD202997;
	Thu,  1 May 2025 15:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kiFneBa/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357C02E401
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112066; cv=none; b=e5iOsSReD2qmAQMfTQtsSreBcA7oH/VHSGIjDc0PCsl/TanNwHLOhfCQi0VJ0QbzLNsLfB5fppEATGn9p50uzEifvFucWv6wAE3tC2Wc0hcpts5T+P/Pcg8uhiiOQ6TLVs52R6WeGXe5zbc3EFupVo2Xs3ooPIUibExCJ3Wero8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112066; c=relaxed/simple;
	bh=q4XLLbUXENx+4C4o2QvgmzL0CvniiZNkUrgIwWGWWek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jsOCO/LpJ3YT88rxrnaZW3iTjh6kjA8AonGKvUxtMWUVVG5R8kYISrNGb+6Vdds5fNL3ZM7TiMJep24ug/MjpTL4tGMAcTfTNj+w16l8j26sgmQQqV7iCl7sChJcmres1DaNkCaTQY/TENl5LruPJ4bT6aK6Y4vHDzxdM+rLMT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kiFneBa/; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22e033a3a07so11246045ad.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746112064; x=1746716864; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J6UsLGEvl5QHsostA8JwRSbyir2SZsB7Lm+iq0MyXUU=;
        b=kiFneBa/07aKKCif6MT1849X7qiUyYpvCSZPY1yJc6h41gsk8PBIPhJOk/Yp4L8y05
         tuBErQNJDxe5O6I1YgoMWdtHq/c8Y5dB9pvdp3268pzjiiHhWoagcFwrYT2V8PjNbDBj
         6Y+XaPDTooWZ4RMPG+uC+weE5hmWg1LGDhikR/VuiNGc0Ydv32ygQYAc/w11ZREFhjGe
         fc89QWYHiROia/PUtGM5ITjGHs6mugTo5pfeLJGL7MoPW8/n5sZM4LBYf/hYcjlj82/4
         nmVKRd8jFguplfJptNXGatjfK6hPsDjwB5SxGQk0vosu8sNQ6T9XqMwtK4vlYERoXXT6
         pZaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746112064; x=1746716864;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J6UsLGEvl5QHsostA8JwRSbyir2SZsB7Lm+iq0MyXUU=;
        b=hf54Ba6viy3w6Qpd2rh0vmxhW3rOtJFXjIvdJE66CqcepojRyPWNQct8bwl6k2sVA8
         DEZFNrjROGD3YGnuCW2t9UJFHPCQXTWeCfrPzbD3NmNLMcEgft6XZA5AHqsiHhu3HuX0
         EX7q233DLmIGETEyLzEV2lnxt+zaeLjBaGdkEHYHza/cUqEy7CjZpAd+ZnmtEjkXaIPR
         uvadMI5UuSfwakQxwGvY9QsoLorq7lQdPUiXCl+YjVNrm4jGj0DGTRp8cnHqVCmT6pXh
         1KHKi46PYztRC+jWngups+x/OoVPvyDXBGYq/qFM+taBgJJEvkFi8l7aooqz633x0U6x
         hTdA==
X-Forwarded-Encrypted: i=1; AJvYcCW1cPiuzm9RcoSj4Vw1TpzQUSu0TONidd+nHoV852L3DbXBxcYt4t5G4pacOu7g27iJASo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yynwx4RyciSSRQ3AvTFKZ/U/a7Og2HtGPCd10mNLZWb37F0UHtQ
	y9G3tXXXe4nZTkhX+xE3dBhYtcoLDw+Jetiq2+Ds9qAKmOhY1dl3axSIbmFTl9Y=
X-Gm-Gg: ASbGnct67ZpOfmTaYSXDSoIUjACWIRnyq2lBYokSxHIcUQVOOkcJlFCjHPb2zO6dV0N
	1ZRsKcZA8gJE6OQtjiCI6vU8DVZEADJ7LjmpSVIXhRNV+f+UJwVxHKJJR4IABhRbbeqPhrM83Fk
	uFXB3iSOoyTjG2EG8tGTl7jWxx3Zo0duENmLuyPZhGs/6w/oIyMcQo+zFayqEpffMKY4OaRGSYA
	sF/XaHmz/RF3utxd9938Xk6tFVznwdWS8qCR71UTWcMd6Vs9+QmXQhgNDaUjd5XXeK6znON0Vc/
	8fmm6PmzsDyQ7fbAHPt/RmXv1LFiZdJEk+AoQ9H7sBNLCGvLOLWxO9Halrwzk5Gi7Kz+jrvmqXx
	aGVKlmy4=
X-Google-Smtp-Source: AGHT+IFhtG/bZFVwWc5cOJbYqNLnqgnJjC/vtZgOZfsbK8XeE1XUv6h51c7+2i0dV2j5oOP+IvlPuw==
X-Received: by 2002:a17:902:f64a:b0:220:ff3f:6cc0 with SMTP id d9443c01a7336-22df3587932mr131329555ad.38.1746112064289;
        Thu, 01 May 2025 08:07:44 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e0bc6da92sm7708035ad.150.2025.05.01.08.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:07:43 -0700 (PDT)
Message-ID: <e1afdcf4-a416-4742-bef2-352a9d184ea9@linaro.org>
Date: Thu, 1 May 2025 08:07:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/33] target/arm/debug_helper: remove target_ulong
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-18-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-18-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/debug_helper.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
> index 357bc2141ae..50ef5618f51 100644
> --- a/target/arm/debug_helper.c
> +++ b/target/arm/debug_helper.c
> @@ -381,7 +381,7 @@ bool arm_debug_check_breakpoint(CPUState *cs)
>   {
>       ARMCPU *cpu = ARM_CPU(cs);
>       CPUARMState *env = &cpu->env;
> -    target_ulong pc;
> +    vaddr pc;
>       int n;
>   
>       /*

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

