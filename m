Return-Path: <kvm+bounces-45457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82BE5AA9C56
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 21:17:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 810FA7A8CB8
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 19:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5EB826FA40;
	Mon,  5 May 2025 19:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q+x8+0De"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436061487E1
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 19:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746472635; cv=none; b=eC3K5A37P19uEvS2Casq4y+LLjm/n6UDa8G0qyMGCqQKsaLFPg/oa2P6/UKFFelTLpKhEzxsvr0rVIem/osVTt5zGY2zDyaWQHpN0T+y6lAfP1xe0qTs2mNLT+2iJioU4Fq3vrW659QBBZNriiR+GG7QYyBxEQ7sdWrgJ/b6yPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746472635; c=relaxed/simple;
	bh=K6/8cOOrVZ98OQevrpLOcByD2e7QtyvMeL+Wn5ONcmc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=tXXz0y0/FmmiKLymHItMb7R0efPTxifMk7ITehO0xhQJCwpBE7hi2B0yio9uRhEUQQunMvaTBGKGTaEfmC4DtXuqLYAKksiD+RihdEcNf39tcvpZVML7LZ+klQPlFgBdCXeMqTNwsBx4GQ7L8+IFau8Bayvr8SMXfNQ9olio3Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q+x8+0De; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-223f4c06e9fso43993425ad.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 12:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746472633; x=1747077433; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GW6KVIAEijcEBLlWWBZL706R8iQgdB2ZER5S3nvinZo=;
        b=q+x8+0Deam7RGHEtUTcnCs8G090ftiMKJX1Rd3wdjcPdFhCHAAeucOPu6+5zheRsGS
         mfg9I7L81TeF5TMm5M5NG5r6/yiK4KI1dj0XpieNBQgM7LHObGAZCq6sTdlo326ANo9b
         R+uxdLWZ9UhykGhSg3ePaFyza/qhuGSjgCRnuHmQqtnpsM8AxIknIu/9NmeIVqTWn57r
         rYGg89xRVTQVHHYB9vwioRPj26LWfFMpuIgb6KsIj++le4PDl2gHdbgZvgI08zMQA0MV
         zW62XMocViANXjFMaODw0Tpa0akHjm7DpZ/AMv1nRCyfZXoYoG5Pb0n3QMLMGXBPAr2h
         Is0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746472633; x=1747077433;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GW6KVIAEijcEBLlWWBZL706R8iQgdB2ZER5S3nvinZo=;
        b=FkKHpFsYPR7xiRjsHJWSFG3j6VC3KaqSG+UWrzdFUV0bIhWXPiBZEQPAfKcRpQ6xTa
         q4iFCvymWqmMgxvOGuQZJ2CK6jWXl7bZpMmarmpvugEz40JpaWMKt0m4FuBZ6u4QB7D7
         AnbkzyMfQ+Knj+sBXo4uZic4tBTEBntJuDHu2Fj/E3n+GMz7/WpqohZXyTC6TY9C8Ajs
         d1a/igp/32CmSWuiXNSyZX/YfyyPMLiwXzuwMf5Gh7NgAHE0HjEZ5S2xgRjQF30uiZ2n
         tg1+GXLUDZ4kH9m1GZ1+sWrWyv2wnezodqlX49fdaVTWJaJjoi7aICmdzQW3VUd/5YIg
         Rmsg==
X-Forwarded-Encrypted: i=1; AJvYcCWsk8kf7V7nWrGltjlPe7j2Sbbrl4U7eZhZ3DxNmluXuKLMH375lmvi3KhLs31fyW15nwU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxO1MBq3DM1GOGIeKdYCUlyrfyngxGgjFyhcrWFNZknl51bU8Jn
	c+//69vO/oy28jF4iZXouSSecJdiQQ8kPFoYpYmAUMi0YHl4cDF5o5pdndRDgrY=
X-Gm-Gg: ASbGnct7Dl9znZvLdmbGdxgr0mpMFTtsbw1kw1Os6IYM/Gxs1TwQmRny068ikkeQDAy
	mL2jXLizKck670xoACTmrby4mZOlyIGBGHIH7+gXpAYccbWrhQAJ3+xSfkfGooKPSrMgPeLBaGa
	SlvVTWbCFqE/KzrcwNZraf3vmIXGsh/G6bzGyP1RRX9+4TG0jyc6qevk7AHjDPxUaWYQi1ROxEi
	CnMajm/inUMPZKALa9bY5csdhx/LsFNiXtWDv1CEdDGtxsVEYSWbnjkQHNJ1/7dlTxBP0AUvONh
	VnHO0yNRpSYPeqleWUrAXCAkwt+P1oBiFwTBf+8qqekanMlgXBEGuyRh5goJUNkt
X-Google-Smtp-Source: AGHT+IGnPIGHq8VjO3UXrxZyCh63NER++S0TiK8mYQqalmCCQirVcYO0Wpw015CxlvaOu9I3VCFpcQ==
X-Received: by 2002:a17:902:d591:b0:215:a2f4:d4ab with SMTP id d9443c01a7336-22e327567a0mr9562555ad.7.1746472633594;
        Mon, 05 May 2025 12:17:13 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522936csm58574325ad.204.2025.05.05.12.17.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 12:17:13 -0700 (PDT)
Message-ID: <14dc3ba2-576a-4ce6-b07d-6b78280e235f@linaro.org>
Date: Mon, 5 May 2025 12:17:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 41/48] target/arm/tcg/crypto_helper: compile file twice
 (system, user)
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-42-pierrick.bouvier@linaro.org>
 <79916f8d-2793-40a7-b769-ee109c52ef63@linaro.org>
 <f33fa744-1557-4c01-ba49-e64b4d3b6368@linaro.org>
 <c67c4a79-7855-4d15-8064-b2f448ac9a42@linaro.org>
 <83038814-8527-44ec-b1c1-2d17362d08da@linaro.org>
In-Reply-To: <83038814-8527-44ec-b1c1-2d17362d08da@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/5/25 11:53 AM, Pierrick Bouvier wrote:
> On 5/5/25 11:51 AM, Richard Henderson wrote:
>> On 5/5/25 11:47, Pierrick Bouvier wrote:
>>> On 5/5/25 11:38 AM, Richard Henderson wrote:
>>>> On 5/4/25 18:52, Pierrick Bouvier wrote:
>>>>> --- a/target/arm/tcg/meson.build
>>>>> +++ b/target/arm/tcg/meson.build
>>>>> @@ -30,7 +30,6 @@ arm_ss.add(files(
>>>>>        'translate-mve.c',
>>>>>        'translate-neon.c',
>>>>>        'translate-vfp.c',
>>>>> -  'crypto_helper.c',
>>>>>        'hflags.c',
>>>>>        'iwmmxt_helper.c',
>>>>>        'm_helper.c',
>>>>> @@ -63,3 +62,10 @@ arm_system_ss.add(files(
>>>>>      arm_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
>>>>>      arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
>>>>> +
>>>>> +arm_common_system_ss.add(files(
>>>>> +  'crypto_helper.c',
>>>>> +))
>>>>> +arm_user_ss.add(files(
>>>>> +  'crypto_helper.c',
>>>>> +))
>>>>
>>>> Could this use arm_common_ss?  I don't see anything that needs to be built user/system in
>>>> this file...
>>>>
>>>
>>> It needs vec_internal.h (clear_tail), which needs CPUARMState, which pulls cpu.h, which
>>> uses CONFIG_USER_ONLY.
>>
>> Ah, right.  I didn't see that coming.  :-)
>>
> 
> I like the idea to have it built once though, since so far
> {arch}_common_ss was not used, and I was not even sure such a
> compilation unit exists.
>

Done.

>>> I'll take a look to break this dependency, so it can be built only once, and for other
>>> files as well.
>>
>> Thanks.  Building twice is still an improvement, so for this set,
>>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>>
>> r~
> 


