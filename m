Return-Path: <kvm+bounces-45287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6107EAA832F
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 00:16:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C315417C9C9
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 22:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6291E27C15D;
	Sat,  3 May 2025 22:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vFBdJ92x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF2C4315F
	for <kvm@vger.kernel.org>; Sat,  3 May 2025 22:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746310571; cv=none; b=qmsQ2MSAhcakMfBjihjPcVbnu4u6kB3IdN9Wp0CA+fws16pY8kmqJlzPz2eK3+usXdPQkd05dg4B6YhJ/FyYc/yp+JFJ9qyFl2rl409XCzr0Wzf5LP0W1ZmXo8TzPjqj18SYkgV1Fl5nTbic/RVZgFSFsqY/em2xlSDWyy11Yfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746310571; c=relaxed/simple;
	bh=SgCE2R6kOpZiKufjvPHhkpeXH5NdUrlD3N/Rmk12ZBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZERfCcKsh7dP12fhvlOkIOWcsBdiiW5rWIIKPX4u3auSRJVucMlnUbHuHX9olUg7fKTcTT53J8VlQg+7O1Q/ZiTQehOzvWFmowmBDC1mm7R1PDwYS7VW/J+L9Ugf3GkmFZHjmnhw3xuKNgEpygYcHdBS0R3jWMPytSCFmpTTksg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vFBdJ92x; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-227b828de00so35037565ad.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 15:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746310568; x=1746915368; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xNJJtrnpFes8ekXTjTuSMN1yHRw6b+bD6cpME1WD6Xs=;
        b=vFBdJ92xzyvWJRbX+MaLD0GgVuFtNulorDBrGmTtNoCFKoWk0/vgIu/DYIx9PUHOoe
         KvF+mIFsFbITGBef0vbbm1g5JTbzgymsLHa9u93rkGu2bwSke7l0yDdfIZCg0Yzh7K3C
         gXNcogVdanvrS5NujZ0/GPyEQbYSB3FHY9Whg3InZbIDHVp2GpeChvsaF9X3g+DiMm57
         DYRMLSB2XbmwzcZXK4ziY+nFPVaPirynWRv1nJpmRX4L3sIE1+5nEzf8dUkhrAc/tSf5
         L3BRHhZh7+aUEuWj8bLkXGV+sdSmIFPJltBYPoqsj6jYfBIo8R3MEBD31//68Bv0P83n
         L/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746310568; x=1746915368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xNJJtrnpFes8ekXTjTuSMN1yHRw6b+bD6cpME1WD6Xs=;
        b=VMFMyEWSJhu6BsUsuMZgy+8DAzS6pf+hKgYsgiAiQnMmONBHTQj550V9lZyYJeU+b9
         njyp1x3c4kq281QEu+q0IbEI6cbP4S50dS32/QCUxLV/Spws66/8KtVU5wS0O26gva7C
         pAIzFkbCMlcq1xsIhnI8mEEZ39SP7wpon0rAQVGoIEoUcjEOC7RByDOicTNSd845IiQB
         HQprTjYK7sufS++cvA/cXhETrUvq+zqh64OIcCd0cTLFsplEsuPUgcKGGId7iDToq6Fn
         1/hpYWc4KmT2IekTiFgShsbDmx6Z7jrtTXbkep7Dt/6ZJJw5EF72ZmybMj7Plu+ju1rW
         u+TA==
X-Forwarded-Encrypted: i=1; AJvYcCVv7hO7wCY/L2luicc01YYXPpNgID8BVx8w9ERjJaNqTIHwDB+ISJrPDnoP7uTHK0HTrp4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9E/4Lzg4iZywCmi7YpjtSN8qsNaI9uSs8yDj7UEBZBe8EDS6k
	Mbhu9ulXSSLDNLBE7qQbMo3+YjQ3fF3yIfiCop0N1a1bKX3NBt8oqcn/3J3FHGA1AxvfspOiGam
	IlvQ=
X-Gm-Gg: ASbGncte2g1cfENPCcw8K3hVgW7mj87f5tJy5Y/0L4nh+vxzgHD8bXRsyBt/Lb+11bc
	vlLKzhMPf/E13ijLtz/TNX+qGb21b84rRdJOeI3GA6GJvrrW5Mn/SP/yzNLO1QoCKCz2QePzSQo
	zb+KEd/tvJnVGeb5bnDA3GFMW0LYCg8IbncbeYhGJVc9Ui1/yByunpXovJExRI22TI+qBCgMDMr
	5GH37RL9zNY3fi9H7uCt2NYcKqcGuEdNbGlXemdMkc5Hd2j3f8wjqbKb+rDVift4OsdOJPQVd/0
	O7+XzyeOvrHanugPoZFxPZSqGNC0iFb1CU/AmA8i4T8FIglb9/pZESH/Enszyo7y
X-Google-Smtp-Source: AGHT+IElNjYwVrPUjFtvyA2d3knY64Cb6zZPqR97k5sUlwVVLCppxJDJZTNzGc+wxdKVsKG/xnF6dw==
X-Received: by 2002:a17:902:f693:b0:223:3bf6:7e6a with SMTP id d9443c01a7336-22e18b97939mr67777725ad.12.1746310568613;
        Sat, 03 May 2025 15:16:08 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058d7adb1sm3839896b3a.36.2025.05.03.15.16.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 May 2025 15:16:08 -0700 (PDT)
Message-ID: <dfab0f03-453e-4fea-8313-05c6b08561b8@linaro.org>
Date: Sat, 3 May 2025 15:16:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/33] target/arm/debug_helper: remove target_ulong
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-18-pierrick.bouvier@linaro.org>
 <e1afdcf4-a416-4742-bef2-352a9d184ea9@linaro.org>
 <21b0915b-422f-4186-a6aa-c484f725bdc5@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <21b0915b-422f-4186-a6aa-c484f725bdc5@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/1/25 12:28 PM, Philippe Mathieu-Daudé wrote:
> On 1/5/25 17:07, Richard Henderson wrote:
>> On 4/30/25 23:23, Pierrick Bouvier wrote:
>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>> ---
>>>    target/arm/debug_helper.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
>>> index 357bc2141ae..50ef5618f51 100644
>>> --- a/target/arm/debug_helper.c
>>> +++ b/target/arm/debug_helper.c
>>> @@ -381,7 +381,7 @@ bool arm_debug_check_breakpoint(CPUState *cs)
>>>    {
>>>        ARMCPU *cpu = ARM_CPU(cs);
>>>        CPUARMState *env = &cpu->env;
>>> -    target_ulong pc;
>>> +    vaddr pc;
> 
> Why not directly use the symbol type (uint64_t)?
>

IIRC, Richard mentioned "use vaddr instead of uint64_t for pc" on 
another series.

>>>        int n;
>>>        /*
>>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>>
>> r~
> 


