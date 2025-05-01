Return-Path: <kvm+bounces-45114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EDCB8AA6091
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:15:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ABE767AB178
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 331B31E9906;
	Thu,  1 May 2025 15:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eZTTy6EA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02BF3D561
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112546; cv=none; b=PrK88e7vHfKP5najbsY4qJBN5Mo2m9YGfwhOSzTJiWhV27qRa2ZnwezBpEwo4wVevAcwEqo7ZfsjVw9ptcHaZY4ivf8xColBUfJInEC6zjPxo6HCqxcmaZs+Y6Ae6uiAzvlGNoyZKTjVwLEjsqw3EvsNcZayh1N/va4n4Lf9UDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112546; c=relaxed/simple;
	bh=7hfp+8V6ZBuCnvWV5ThaUU+/y92IZ/Ggwge/fbZqSVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VzncxlZDCdB/y4ILdYVfopx2//lAVS+ig9QJ3i3TQSEnDiwi9skzK2l4JD2v7MWqeDfK3cHva9D8mVuoUox61ccxEvfgDw0Z7KSFtzTVXBmPJ2f6Tv75Z7kVmtee/k5X4nlRf9fcNXIgKzqt00Yj1iqOAqf7rK1fI/K5YiveSYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eZTTy6EA; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3081fe5987eso1112241a91.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746112544; x=1746717344; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o9YF4VdarcUzqcru+xCQ9pFm43bwCCqoeOh82TAihtU=;
        b=eZTTy6EADoX/L0gqNmSthlkKmvAA+YqF67r/w5leD1Wpcokqk6BPx0kTSatfXrau7q
         Q+s3obgvVDK/yV15CtLRpFCBaG1rq0L0jJ8E99vy3DEgQHuF25deWru3MOmb3DyYM6qC
         XgMcdJQJ9v121fnMFH/aVfiKm17JgkQ5QvO0hZ1rova06FU9ecLGMniZ23HpG1tR8wVs
         MfXdi+LUn9mJjxHZ7r0E02+jhNc28g9UHCdHf7kqX2QIuV7QPCe24pJgmyvf8EhknQIK
         Aamu/keQeY8OocpOBzxlhSrIMiF8ctK4rYP93YACGj84hcnDEFOBdOfnvSL4ykXPbqdp
         fxyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746112544; x=1746717344;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o9YF4VdarcUzqcru+xCQ9pFm43bwCCqoeOh82TAihtU=;
        b=dVAozFrGdYrK8kt9ciII6XTYS+RWl8qoDXVvvxbGzyJMjtY0geEU6mtsFZf81Wy+SB
         CbTN9T83x1oVX8CsWtL6BjmQcSXErb8FwIo8/tN7WCEfj9/MZDPv4ftFtuLW9Q/w2s+m
         cy0vP3PEALiHpxtfbCY1Qv5+tDU3U98thPHG8nITNU56zAIEvZxI4J8Z3c7c+3MJwkeR
         NysP+Od/mstzoOZQM7QtLTcRJ4qAgWvolttBKM5k1HPjmxsXvK0rVOQ+b07birIWgYY3
         hTsWsMJgEyupc3TYeQmnpoLKrB/tViO87kBrWGR8usckbgjAwGuOGBTQjaZVNnGiy3Jk
         j0mQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrE+jvXIMfGqn45LSaw9nijIHN4gipzbgwGojojw5D1dEk/7h4rFk928sP+KNx6ncNCiY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5HPgV8rT8YYHXqMcYnLqM5jHqJlQChgKQVqK6hFH2ZhvT7iai
	f04Lnxv0t2693QdEsBsV8q1t7E1saETHhull63Q0N9nXpsKDwYruc2I4YX3fhjo=
X-Gm-Gg: ASbGncuidcpM1gN9bbWeQ00GGQTXz3qcGHVA0zg3WXr4+vOa7z+/JG1joD7SB1/1vLL
	eN4Qq3eRnnJMk1OgsyKXXa3p1qR+t3HcrqA0jF9+wSjhx3v+VTuIC47uDo/IAGOvAJbkyJnkg7r
	Et3/rU87zPC+Meu1C6vs+7v3C45itw5v1160Bru7/O7VFzDeCE8JYrig1rISLotbm9ITzlzZzdk
	4P6QBR75RBd/AFqOOPJlImo6sOlJQBUVf547N7X7DWkpvjUjoXxVJ6Q86Sd4zOkgYnWljdVD3um
	4v9WeLR+XWQxM4Rh5LdxzgZ2SvitWeYF2xXXLXk2QMVTXAXv4wro7w1F2RLZHebcNzwSG998FZQ
	PP++81Fo=
X-Google-Smtp-Source: AGHT+IERIGRaWjaqtZwcbtTyPeLfdjPE0lHKg9DKCKEf2LmmlpAdU1RNvXJwqWOBdTUZoY4u10k+pQ==
X-Received: by 2002:a17:90b:5388:b0:305:5f25:fd30 with SMTP id 98e67ed59e1d1-30a343ce769mr10555550a91.4.1746112544064;
        Thu, 01 May 2025 08:15:44 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34826760sm3755129a91.46.2025.05.01.08.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:15:43 -0700 (PDT)
Message-ID: <67d187a1-95d3-4e9a-a891-ae8090e7c6b6@linaro.org>
Date: Thu, 1 May 2025 08:15:42 -0700
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
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-21-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-21-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
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
>       unsigned int new_mode = aarch64_pstate_mode(new_el, true);
>       unsigned int old_mode;
>       unsigned int cur_el = arm_current_el(env);

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

