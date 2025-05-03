Return-Path: <kvm+bounces-45284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D68AA82FB
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 23:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A552189E94B
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 21:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05BB1A9B40;
	Sat,  3 May 2025 21:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VSV09Ev4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1D0E56A
	for <kvm@vger.kernel.org>; Sat,  3 May 2025 21:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746307122; cv=none; b=newqAEERFSCMyKE/kAWj/E8wkjjifYXWIKurKblDdVL/Zrp3+XNfpO8yVmzomlnuSUIpwJ6fcoLbuv+9DBdKLweJcFMxIbSGJQcwIwg35LgopwyUoHMI/LNlBfTLD6YtVsfa6dB7t18VqkqNzLyt3Rj6I2lBjPVTx1wNvk5WHzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746307122; c=relaxed/simple;
	bh=ogmaKr3lui9hqRXmxznI2xzvaLEoAI9I8D0VqqiMwYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QoMo9SBaHM6cNXCsh+iB4MS3y5z0Q8mXeox41CuOQLj1OHhOHrTlt3y0Td5gZ3uJ0v9xqSerDNMYYT2UVLJTKTmn76P0p+i9XFEwxl3xKZGwoj8faRg5Y+3yjMCESl62eKxZeCjn3/h4iHrBsmtcPU8gvhmPfMzKeFKsM4HD1tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VSV09Ev4; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-224171d6826so47454355ad.3
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 14:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746307119; x=1746911919; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=45ezGvBYBHyKW+GUcBxuGvzarphaJYBNYk9QW0DXKLU=;
        b=VSV09Ev40tjL+9MP7/6QIX5IYaTIKSR2Us9xl6FS6eB9IGYbpyFShJO+4GNoIdoNnj
         N7VDwiNAMK5nmPSmcnptKBViYTud21YZihX7YVn6rLmQiLwqrDYO7FXTOeyFriry46MR
         azxohth3IDXWR+Vc0Ygv1uVVBT/Hsjs2UfCEPIXtWHO/eqymiPl6ZUmr45j/bQ53vPpR
         +4xutHECdQ0tZJRP4qVmV5cFAosOjvzppt4Tx+XqQShs2NWkB3yL2KB3tOBvkdSOSEEX
         JbtJpGxwFBseHBZfYSBVQCdQwJl2V0D4hSx5fwAY1GIqOFgep3Oc54uCVVnhMh6KyixH
         WDGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746307119; x=1746911919;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=45ezGvBYBHyKW+GUcBxuGvzarphaJYBNYk9QW0DXKLU=;
        b=Q1MZnGTBHk1+MnO0g0eLF0jNm9EX4hEl9Q0Yfbq9XC2iGnEYnBkWRp9oLbCJH06AZN
         gbztnu8cX1GevM8M0H8P+Fsz6lgzEA77qLoMyk3x3wua4Ug9CvIoMeWHB8u2MHITRwb2
         zONK0YyBjMfNkTWZ9ByO1W5dLmowTHMq3IpYDCyI15ybzVmcU76B/KfdEPDo4I9/5MIp
         FHRaHKDo8wwvASqM2SbDdbWBrnrNFN5RGYi+vIBCdrb1rXYVa7i0BsGYLf/7ID8P3M1B
         TuLx08f9l3bTw0hPCuOlNgKpCIU8mXTdHo2OFeUAoV6+fWMJ4FPzX85xMVjs32VCqR7G
         Pz+g==
X-Forwarded-Encrypted: i=1; AJvYcCXh1Hg7o4A/MS9Q5hcswFMOzcz9fawt0prYn5Z0gqOqlLI4Aut9IGlgTGWTSjAodExJAtU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiJipW0JcGNqnzXyd+njz11RX46us3NWxnMxkMP9Zgcg/i16n/
	q/ssbfyTRVmPTe8gjrgfB9YbtBp7YYrz8Ayx+IuNYTRWa2KYmkGXhBUsACBgAW8=
X-Gm-Gg: ASbGncsawW4AvkrN0EC4bUoy3WPOvB7ooDFCMh5ax4fUdGmywxHdj/YOpihy0L5pquV
	YYRNtkhAUyZ02Pxa2b5Uc+Pm1D8vhggeGNEhN5pjHGNz6OLa+5bQHOkSre88MKnvZEVUaumJ2sK
	6sTTgLqrD/zymTJVboUa5QKMrUfVy57vKVheiL/tLwiecqIEigtzyajH5qDPe2E1FRXxoWvOe9I
	BWjinOk13RU37RkFGuWD00LXVDt50pfjwrTLBmla3MAPrRxrcQxC6wwEg0Yrfz594jp7tn1YAmD
	VJnRVU3y6JwHK4pmalMrc1m0glX57LnrdBwe09ZpcY5rqiTu9arfFg==
X-Google-Smtp-Source: AGHT+IH3UsnAzBT5enZnNLGLoJsukEKh1TbN9yI/pnjynITTwoYoYrOIa5hc3zCcGSfsIbx5/+ChYg==
X-Received: by 2002:a17:903:190:b0:224:1ef:1e00 with SMTP id d9443c01a7336-22e1e8f8833mr32193285ad.19.1746307119511;
        Sat, 03 May 2025 14:18:39 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e150eb21dsm28272865ad.40.2025.05.03.14.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 May 2025 14:18:39 -0700 (PDT)
Message-ID: <21893e4f-700e-4a9f-b877-98a863a47c02@linaro.org>
Date: Sat, 3 May 2025 14:18:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/33] target/arm/cpu: remove TARGET_AARCH64 around
 aarch64_cpu_dump_state common
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng, kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-10-pierrick.bouvier@linaro.org>
 <24662e56-d6cf-4c17-b792-e4d1ece6e241@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <24662e56-d6cf-4c17-b792-e4d1ece6e241@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/1/25 12:06 PM, Philippe Mathieu-Daudé wrote:
> Missing the "Why?". Answer, because it is guarded by is_a64().
> 

We are guaranteed it was not used because the whole definition is under 
TARGET_AARCH64 (and not only the code inside the function).
If it was called before, out of this target, it would have triggered a 
g_assert_not_reached().

As well, yes, it's guarded by is_a64(env).
I'll update description with this.

> Should we assert on is_a64() on entry?
> 

I don't think so, from the reason above 'If it was called before'.

> On 1/5/25 08:23, Pierrick Bouvier wrote:
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/cpu.c | 11 -----------
>>    1 file changed, 11 deletions(-)
>>
>> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
>> index 37b11e8866f..00ae2778058 100644
>> --- a/target/arm/cpu.c
>> +++ b/target/arm/cpu.c
>> @@ -1183,8 +1183,6 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
>>    #endif
>>    }
>>    
>> -#ifdef TARGET_AARCH64
>> -
>>    static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
>>    {
>>        ARMCPU *cpu = ARM_CPU(cs);
>> @@ -1342,15 +1340,6 @@ static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
>>        }
>>    }
>>    
>> -#else
>> -
>> -static inline void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
>> -{
>> -    g_assert_not_reached();
>> -}
>> -
>> -#endif
>> -
>>    static void arm_cpu_dump_state(CPUState *cs, FILE *f, int flags)
>>    {
>>        ARMCPU *cpu = ARM_CPU(cs);
> 


