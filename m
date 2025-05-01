Return-Path: <kvm+bounces-45162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0058AA6369
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:06:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 227904A1132
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 19:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49370224B15;
	Thu,  1 May 2025 19:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hd/L6T4n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29DB2236FA
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 19:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746126384; cv=none; b=RE5SxjG2PcXeuUSOs+s/TuZE2OUre2AXo/haeUeDreNiP+TqukTLsKyCAsb0Z5UcU9DI4j4AFM8CRGiVKYYjxy6fKJ5ddEfNcOTOXeeQrOSVS/GiHFnVhypo06r0Brfb5+OvNqvkcF/S4bf7k/0T97ejS2l0Qc0R+BD0l0nz5CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746126384; c=relaxed/simple;
	bh=WB4D0Mim4PdgeEPxbTGkLLD8kQmm8N8WgcwC3bZHkgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g2yx3NLS8kbH4B/lqmpu2bRfKl/yJX62FQl68oZoFA9aP4xre/yyTyOl3QprPUFpzV9Qi358eJC993tN8TaaDcxbtLH7IYrCf3+jL7eeBYLzV0s5WvySlX6jL1phenUHSBO8Kxj+4WULxyxEuMjTJGxLQEDoCK0/816H2Mj9h54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hd/L6T4n; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-86142446f3fso36914439f.2
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 12:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746126382; x=1746731182; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qj22zgHL05O6e85jZdMZPreQfGsPPd3ympYXool2RfE=;
        b=hd/L6T4ny1X+NBWfobTknAgUjbq3GkIdNEhWa+pJu4my2b1FEbMK3Z4kJDk4dCMz7/
         sYASjFmGDvdwHqBJdlt1qNiVRYiczv/8k7RlXujpj79B3ibBajEESbWzDtQufevLmGWV
         N0bJ2z4kp2tIt2MUrafCY2rXPl/S662o48C9P4mAx3g371IertR8mpAKnjk7KIIcJQF5
         Wk/Lc8GHopfu6VL3mGSUFKdBngRBcxGwpEF1cvnepBJcAi2FSle64dV1iApokwhfWlEX
         TGmNLAfou+LKE/dSVeKdzVajNtZ49D3IkHxmyClMWh5ieAzNMz7e+xMldRuWbqZvoBgU
         0JQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746126382; x=1746731182;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qj22zgHL05O6e85jZdMZPreQfGsPPd3ympYXool2RfE=;
        b=IN4JzNTOk1xvkQg9KFbLFz9R3fvkrYw/j+WcSbLTZvcxCnoRRTAT50wm2vkP1Qv2WT
         GlP+p5H8taWG8PRwoIHTgrst4ztslC2SuXSoSYtGe0oq2B2tQhofK6iuoRYdOnFaI999
         Ya7A3K19BFQywBY25bsvLJ+IjfQeoMeFKwtaFKO8fqUBGjEq1wLkY5vRy9ExFojSwAtw
         e36vBha40wKBSp47abXDqGz1qwnyeV150daJ0APzfxXrAkFINeeMqLWhmeDE42OD4uOj
         qQtp+g9+JvIpIM5E90cYsKPDlzRQFseZxOhSJfzkkXd0ZC5doPjptxneF303kshcVtkh
         UDig==
X-Forwarded-Encrypted: i=1; AJvYcCXdH2AUFUhz/qIoZpN9vGzsAOjhsPaKTMJaOuZVE0Bzbsx6om9+cm73cB/Vkj5CJRg4Cpw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1+DT4vAp2cYysQV06h1qMOXbHbB1dRsB/LSYtC8ubkhWLtxHM
	2/oufqF8RhJSr+xKxVi+Q24r65+1whtRiGvLQKX236JytO0HnbK2T3JYo18cS7Q=
X-Gm-Gg: ASbGnctAgqzwyEkjMsvnC1jAGeOV0fMP7wzDCALrAb9ALTNR3D4BuDpcKXNjB38A5fb
	3WKuX/MAokbXPegj4VIURYHGjyd+781mYNoYwFWN4rGex6h+FHUS4CaU0aKesS9t0JktEkjlcAX
	XVkcK5yBOrSYuMbhQeB64ml3Vkgg9zwjZZtQIZ4Cmt7msBxhNgBnrwr77kGIiUqGZfLnxqj7+Q5
	MjYXshZOmXoD2MXcjdaXPhhcxb7OWY2siMVbckzuETuXuIIjICq1QfbLIbO3mgw1DOuVN4rnpQh
	2tKSKbguqFNmUNdvsQ6Gw9jQeZBTss4vOg2wijyFJkPZYz6YPHcSLgNUoBoF96AVBKx9F++QOJe
	12Px0C6mBW/IdDw==
X-Google-Smtp-Source: AGHT+IEmRiAS2i9D2r6MeZjyjnR/NC+zjy6ATHPXH1vxn6/jW+cvSw68CoxCLQSSGuusRfck9NKyEg==
X-Received: by 2002:a05:6e02:218c:b0:3d8:1b0b:c930 with SMTP id e9e14a558f8ab-3d97c129edbmr736955ab.5.1746126381678;
        Thu, 01 May 2025 12:06:21 -0700 (PDT)
Received: from [192.168.69.244] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d975e27c99sm2745345ab.5.2025.05.01.12.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 12:06:21 -0700 (PDT)
Message-ID: <24662e56-d6cf-4c17-b792-e4d1ece6e241@linaro.org>
Date: Thu, 1 May 2025 21:06:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/33] target/arm/cpu: remove TARGET_AARCH64 around
 aarch64_cpu_dump_state common
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng, kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-10-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250501062344.2526061-10-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Missing the "Why?". Answer, because it is guarded by is_a64().

Should we assert on is_a64() on entry?

On 1/5/25 08:23, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/cpu.c | 11 -----------
>   1 file changed, 11 deletions(-)
> 
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 37b11e8866f..00ae2778058 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1183,8 +1183,6 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
>   #endif
>   }
>   
> -#ifdef TARGET_AARCH64
> -
>   static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
>   {
>       ARMCPU *cpu = ARM_CPU(cs);
> @@ -1342,15 +1340,6 @@ static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
>       }
>   }
>   
> -#else
> -
> -static inline void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
> -{
> -    g_assert_not_reached();
> -}
> -
> -#endif
> -
>   static void arm_cpu_dump_state(CPUState *cs, FILE *f, int flags)
>   {
>       ARMCPU *cpu = ARM_CPU(cs);


