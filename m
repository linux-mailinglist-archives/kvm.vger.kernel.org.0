Return-Path: <kvm+bounces-51176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1866AAEF4A6
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 12:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0336165C2F
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 10:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 629FB25D212;
	Tue,  1 Jul 2025 10:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vy7ZIyxQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D5726CE09
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 10:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751364753; cv=none; b=L1qrPUIByqI2U+vnqufjLOF4gcDgV0KZw0FBSXgAtdFoJzquPQrjTqkcGEeBjsjm+aN7bKnFzxN1RBc81dCUiy0uNkKSDWR7wgqIMpLuFJC2lyAY0SZDXAsdUtirtWOE60Bk+wrB+ga4sj0KslSs2w49FP6yZxOGvpESiWRNITM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751364753; c=relaxed/simple;
	bh=2Jh4c4Lof+h3Td1ipSJZyDgru+ovuTWUVLePoEE8/Jg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mKwB+6Dp9+y7kR9FIQTJOWtmk0sWK66NkkkDG47pj9FVjg3VB5eLoej7BTpqtUY8v8bBAxvdRLj2pb0uyuIqP1XNi1lzkxGX3dROy32D2SZ9TUUI6KhSU1BIFV75ACdAglDOvqFNxuqJBe3BM66TCSRlk0Gw3GrSd/XBP5+vIfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Vy7ZIyxQ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-450cb2ddd46so31312855e9.2
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 03:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751364750; x=1751969550; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i48kyF48WGF1kOw5a2fFzh77wpZJNP5oYB8FFOd+ev8=;
        b=Vy7ZIyxQ6fq9S0fMAynvzcUntPo6aOghDHHuWZVYNWTN2+Hvwelx4etq00+Ca88hfF
         h3mmLpS5GZbwdR1sl+ISL/FvPDjeXpidUrEFBPGDds4ktRAE7DLG1zd0Zfpm1HKfp7r6
         UmnFNG3clRZvMZv0ywLV6IXSWdMAlxWzqFoTD3b1HZZnUhjWOxEEY1pAkxdLq+AB19Qi
         ogxSOvRQUFTmm24ghyMGKjLyJ/GTbVCRw518v0Cwn4K5+WgqRE8tY89RI33t2smb3d3/
         MsI1L/yEbf4sCE+uAT7gZrwfdpxUnq7doLp2AYBR1HXQ9TDT9dbDMCvUnOTE4nRUgofK
         LwXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751364750; x=1751969550;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i48kyF48WGF1kOw5a2fFzh77wpZJNP5oYB8FFOd+ev8=;
        b=wKPPSN36sIbRF1SgmuQjDIB6BcId5p2yWf/oyT968fhkAy28+xVjT9BOQ9bGx3Q3kW
         68Qs3YLx+fYaEUajQ0UM7qqNFpUoGbDCv9Q1JnvZGptXfveqa5NLzL+zpwfvRU00iQqs
         GYApYwFMyZNLhiPDVtWkNbAqUI90cOfjDtWTTAdf8VfLweYBI9wd9qEtdhTnqd+C6FK1
         VSbkht3gv3yWJnQ2t0py9L1+lsa1domVwC1BObng/WxWjNMcOdtLRb0DtdIeNOiGSuZS
         A9wEat7/DaVoV2phvgqDPBljjjg3ATaa/ozrcHJL82IK8/xW5x+D4ws4KT/8yxdZga5x
         aeXA==
X-Forwarded-Encrypted: i=1; AJvYcCVU7SCntWusNZ12qPyKSzfevDiM29e02+uGgG4PzGdvw1LbKdj49BhQIaPscq9TQJiuz4U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+Xo7wZnP+ootpx5yW/wYjVZUhJ+BLDKidUck0MJiZj5Jt8Jlm
	9uvV7Z+8LRadLpi2mqauXe7zAcI+CApW/Ee3BjfDqcjd7E/A2QhtFaqBAAcxaphd8iQ=
X-Gm-Gg: ASbGncsQFOQE2CZXB9TcvSR3fob7O3GukaoNYao9jJMFcYBAf0wkMc2IDjZxQgV4zLH
	MuhnnqzV08EeEMWX+j2hXeAW0kYubYv4bDaK7IgCkEHwTHsH7LJH6qQE+DxJB9kUtcz0cR63zdg
	j1lt3FprgDIjsjNFyTx7aZdMpVJ5ikmjCvIJDYL/aqCWvLzwYDNpjoL0yYz5ZR1bbocSOxsP51z
	VbX6E9UqB5b4T17xJqVC1ZiAli8ug2YJqDXIMWVpK7WUIVg+5LlbZ9ZLRAmN/YbGXjIJ3mrhbDj
	MULxJPZKkINZC7dIxTCdkUegywH4U368AMppBDHPVWXCUg3lXYMbOePptJqgU2zYS6ylwo9x0xX
	6fX09QERvMOv8x+UH9U4tfyt8CjRoig==
X-Google-Smtp-Source: AGHT+IG3V/DgLWI7Rr9w/9AtpjvbqCpEr0yemPeswRn1wIGk+oob6kO0PmMCNon/JHwIcG/zcwIGUQ==
X-Received: by 2002:a05:600c:8219:b0:43d:42b:e186 with SMTP id 5b1f17b1804b1-4549f5db40cmr11080065e9.8.1751364749915;
        Tue, 01 Jul 2025 03:12:29 -0700 (PDT)
Received: from [192.168.69.166] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453823ad247sm197230345e9.26.2025.07.01.03.12.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 03:12:28 -0700 (PDT)
Message-ID: <1c7a557f-2ab4-465c-a84a-43dffbf4e0f4@linaro.org>
Date: Tue, 1 Jul 2025 12:12:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/26] target/arm/hvf: Simplify GIC
 hvf_arch_init_vcpu()
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@csgraf.de>,
 Bernhard Beschow <shentey@gmail.com>, John Snow <jsnow@redhat.com>,
 Thomas Huth <thuth@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
 Cameron Esfahani <dirty@apple.com>, Cleber Rosa <crosa@redhat.com>,
 Radoslaw Biernacki <rad@semihalf.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
 <20250623121845.7214-5-philmd@linaro.org>
 <CAFEAcA8+9TPps4NkRwRTZXq-nkR=zJ1SsFLnMzzNf7MioU-qsw@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CAFEAcA8+9TPps4NkRwRTZXq-nkR=zJ1SsFLnMzzNf7MioU-qsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/7/25 11:39, Peter Maydell wrote:
> On Mon, 23 Jun 2025 at 13:19, Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
>>
>> Only update the ID_AA64PFR0_EL1 register when a GIC is provided.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> ---
>>   target/arm/hvf/hvf.c | 14 +++++++++-----
>>   1 file changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
>> index 42258cc2d88..c1ed8b510db 100644
>> --- a/target/arm/hvf/hvf.c
>> +++ b/target/arm/hvf/hvf.c
>> @@ -1057,11 +1057,15 @@ int hvf_arch_init_vcpu(CPUState *cpu)
>>                                 arm_cpu->mp_affinity);
>>       assert_hvf_ok(ret);
>>
>> -    ret = hv_vcpu_get_sys_reg(cpu->accel->fd, HV_SYS_REG_ID_AA64PFR0_EL1, &pfr);
>> -    assert_hvf_ok(ret);
>> -    pfr |= env->gicv3state ? (1 << 24) : 0;
>> -    ret = hv_vcpu_set_sys_reg(cpu->accel->fd, HV_SYS_REG_ID_AA64PFR0_EL1, pfr);
>> -    assert_hvf_ok(ret);
>> +    if (env->gicv3state) {
>> +        ret = hv_vcpu_get_sys_reg(cpu->accel->fd,
>> +                                  HV_SYS_REG_ID_AA64PFR0_EL1, &pfr);
>> +        assert_hvf_ok(ret);
>> +        pfr = FIELD_DP64(pfr, ID_AA64PFR0, GIC, 1);
>> +        ret = hv_vcpu_set_sys_reg(cpu->accel->fd,
>> +                                  HV_SYS_REG_ID_AA64PFR0_EL1, pfr);
>> +        assert_hvf_ok(ret);
>> +    }
> 
> This doesn't seem like a simplification to me...
> 
> Looking at the code, I suspect what we should really be doing
> is setting the GIC field to either 0 or 1 depending on whether
> env->gicv3state. Currently if hvf hands us an initial value with
> the GIC field set to 1 but we don't have a gicv3state we won't
> correctly clear it to 0. i.e. we should change the current
>    pfr |= env->gicv3state ? (1 << 24) : 0;
> to
>    pfr = FIELD_DP64(pfr, ID_AA64PFR0, GIC, env->gicv3state ? 1 : 0);

Good idea.


