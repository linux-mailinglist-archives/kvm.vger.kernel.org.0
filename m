Return-Path: <kvm+bounces-45166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E1C3AA6416
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:28:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2590A1BC2F97
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 19:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 461D3225785;
	Thu,  1 May 2025 19:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BUis2Es5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD042253EB
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 19:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746127700; cv=none; b=E5MZze4qXYe2eKjII9WA6U32Cq1bjXXrVFD41Y1HixSF/zm6L1lvup/rT7c/gdovpWRKq0cLOcRTw5F/Fdqt/mE1r5w6km8PkHPCpEUxX5Ti9bCkdD4smS0NcMm4Mr/P5s22ysOKBIoUUUp69GPOSsMHPlXFDiljGS6d8gKVx8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746127700; c=relaxed/simple;
	bh=+OpGAf9DE3WwKF5Rp9SNB5sC/V12rTs5KcfaU7ov5yA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a3pA/9a7ElNLAx7S5iHAzt/0qkfO29OC55Rbuh+G+ln2RgX2e+Kp+amam/DhjznxDW6LghWGceFSdMkjSBCW9Kvm0reJ6DkVskoare28h143bD+5m/r9gabZ1FxwCu8mv0NAOLRon5dLfhsEbVeQ8mdf7dFLfMLgvrExB9MgarU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BUis2Es5; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d81768268dso11219225ab.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 12:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746127698; x=1746732498; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nE/d6v4IGNsCc5cE6DF/N4iko97FJvkzG6xIWkN6qYI=;
        b=BUis2Es5QET6FytnyY2W2SqDzLSAmRpNHx+PshLg1EzOu0QGf3r0pc9yLX6pRzNlzP
         Q/TDCrvgMy3e8/5dPgCuJSF20oJrZIPTAyPBTPWed4sbpq8632P73BApBXjeAOWdNMU2
         UCX5iCWR/lUKrEgyJ51eYBqZTm8qDHexPkP24inY3d1AUHXoiktsahyNIkziWVY0Ppp3
         GcblOd59Uj2oOOL9H607NnZl89ewLhduJe99rUsR+9+d9aaOMeUwMDPCQhH2wxj7hPSy
         JhTYfCh9q20gipKwMlFdUyMGRjZh1tzFCLt4O5twLSg7BWFMUScnoGLlrSMj9X2JuyyJ
         9Z3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746127698; x=1746732498;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nE/d6v4IGNsCc5cE6DF/N4iko97FJvkzG6xIWkN6qYI=;
        b=SFKg/Rl7vTtD4p7+/xLMdOUugjxuCvVg7IqVX6ZgwV0ucZ0S5Y3wTxZ42neEFiPDoq
         mzwG8naPjroN65I00F2Fh0P67oDxkPQR+2vmxO2OQIFqFDnWuC6XTKHPAVrhwqazngB4
         4Wr4gXVjpOW8gcXbauSEkSnzjXphGURBP7mmq67V1PbXCyAo3FV/cUnY6o9Uu9Xj70ak
         Eqh+UazMKzT1A0eJ+VxTw9IfLF6o8VBWbLUO4t0EXQ5JEv69SVgRnz2YDeqgbHOE/sac
         4Eq0/cR1uh+01AcD9EGyM39ajAGMh/jEeSDKlMguv5dFhTeGGcGwMXgdiUBVC8NFTPsu
         QEgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQ5ajcEDx/ALsTTMUDBIqLP4th26NnQs8toFVy3ICnudHBCGeCOGyM0K7ACPLc6LtwMNA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+tuqZLNY09qXSlEtPragcOgeNGRUHk6vg3A8SnUfHGolunb9O
	ymnLEl0Mogjwhf55mYCVnzY2ExQixMbTw9A5K+JfYY0PDoKajfLlDDDafdeAmPU=
X-Gm-Gg: ASbGnctYvddrRbDl/PtzDq1Q/0HN3iBVqRfbWmc0c4al+pRBtuCRsKQEiztTZhWpFMG
	IgA7+OIf8G8AxvTmP2jvhFYvtWv4RTBQ0W1A7+FgMCERVOa4hvEPlmJeVIvKB1Slf+uSUBvZVHu
	wa7Md8KTGaYL0+6vjlC9iBGUeknj9qijHPmTQ+Bmz6aHBL9q4fP89m9bgyD0Xeech/5xHrUzXxL
	WHI3AM3xwhORRdtNOwEwF6v5T+pEKZ0oZ08MmMUnxhsnI5bKsqBAZmlBIyrQDhtkVeVUZYP4wyn
	4/dAiKLrtlLYAG2HClbKxV+hC5wCdEnwLcxMuvG/Ww+n2YsJfE3JkCiHdaes4ZQOZTvMJPtDjJb
	7aYUdHh9guegoFvBwlnx7UzL9
X-Google-Smtp-Source: AGHT+IE4RafrimaLP7DXlBAwC7zDUl/SOUxW6inbiqP5la0qzJpi5CZnsNEjOu6aX7DEPEFOg1EwFw==
X-Received: by 2002:a05:6e02:15c8:b0:3d8:1768:242f with SMTP id e9e14a558f8ab-3d97c134260mr1865245ab.2.1746127698075;
        Thu, 01 May 2025 12:28:18 -0700 (PDT)
Received: from [192.168.69.244] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88aac80f6sm6839173.141.2025.05.01.12.28.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 12:28:17 -0700 (PDT)
Message-ID: <a9d29064-e4c7-4536-b918-057951dcc1ac@linaro.org>
Date: Thu, 1 May 2025 21:28:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 20/33] target/arm/helper: replace target_ulong by vaddr
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng, kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-21-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250501062344.2526061-21-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/5/25 08:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/arm/helper.c b/target/arm/helper.c
> index 085c1656027..595d9334977 100644
> --- a/target/arm/helper.c
> +++ b/target/arm/helper.c
> @@ -10641,7 +10641,7 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
>       ARMCPU *cpu = ARM_CPU(cs);
>       CPUARMState *env = &cpu->env;
>       unsigned int new_el = env->exception.target_el;
> -    target_ulong addr = env->cp15.vbar_el[new_el];
> +    vaddr addr = env->cp15.vbar_el[new_el];

Why not directly use the symbol type (uint64_t)? Anyway,

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


