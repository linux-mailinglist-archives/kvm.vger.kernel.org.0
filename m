Return-Path: <kvm+bounces-45165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C3FDAA6415
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:28:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E28E1BC2E28
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 19:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEE6E224B15;
	Thu,  1 May 2025 19:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JksoKo+I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DD0367
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 19:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746127698; cv=none; b=U7TRzCglGocjQyt+oNitmnW60IfCxwI0L9GerfDHZY9P8YBtsaJKIvGmwJ9Nvts10vpMJXjjnepvp7oMMnfsfGgDZJdak7z7Y+mhu0I/q00/HduPzBtuslXL5UT5Ia4nx2BdeJjArS0YAjGsCMPQ//GZ1GFjvIEaPW3oNYQJ26M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746127698; c=relaxed/simple;
	bh=Y8IsPIIRDz2ay3vNHiNp0EF6KWx1bR8tSHpdEYKGluE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lMg+IeBz+pIR2A4KkB1HeIXjLahtBbBK5RDyNVjOlZTNBJ+cPskIFfcWBrmyyhGCVNFKDSyqv5bH310cSxOZyYkwCSRKGGLy6XpjIIdGR7sJqBamijGfR2gYspztRgydHZc1B/qHk6esQPDSd02Bl7XaOjWp06hwYo1162BIHdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JksoKo+I; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3d81cba18e1so9845935ab.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 12:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746127694; x=1746732494; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lIT25lodBDqzC8QsLNZY/pbMkuQESJLFEJeOOfYgS7k=;
        b=JksoKo+InuJzK3LV5QeW9jKndl3ToQ+B4XRE4+bRkZftGDT+RmBw8W7HTejdzZLe2N
         0MQy4Y8y+7hiU4NH4jZL88ef9CWrvcssUXsWN5tSXGgMc759GEI0cIakzfYFpzBD+LaG
         8D8JNftDG9gyrmqCYULCLErlObV19wzHPSpRhFiRSp5KztUf57Utl0OKDA2T8+RYKx3F
         Ne/IFFpY0iXABYXpT9dFRcY0uIcqxUSWCErcbYg7QpbTuxzTC5Z1d5RXxyP7DkvNZtdJ
         HYgz3ZCM17gHoVJNYALVT9o6jQmqtpxe1YI15ObYh8Yyis/dX2kptvo2tJzsEEPDBeO3
         zOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746127694; x=1746732494;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lIT25lodBDqzC8QsLNZY/pbMkuQESJLFEJeOOfYgS7k=;
        b=mL4b3zCElpIUyWlU31hqMYGEdU2FkPqSAGQfwdr8pTcnJ4XNg/GrwIoxJL3s7BVqOK
         aE+QKu85ywZ1DVKIqK2WnwNh8Mh4r7qawJT36MkVLyMe7P3mOrxQazsHYlfDQRPtPm5X
         NzvvB3FeaKljnZLZXvl1B/jNbqoOZ/HXsD8qanWKZqJLbkF+7k4jsDSsXwI89t8JPMZm
         YoobpuMdFp+p65sHD9+mGZfuTyjh40IVYxyv4W1KTjLvzqJc+YctWRLbCIDoEXK2inQ6
         8Fk2aVyorDVrVOlrqNX2hw1KQ43kzRKlFKZcQasREPJlN31jbl/g32sp0zHvbFKal9qs
         NMmA==
X-Forwarded-Encrypted: i=1; AJvYcCVyHrfU40bdG0zPScCgoVWX6D8qZFyyJQcVLjSkXcNLXbVxArses0lnzfUyoqHXPtHs9tM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrIDuQyUCHwSZ5yo2GKiXlRcmWab8rfbsze9JV3ct8U6HvvavA
	zezdnGakiR5yGwQhp4xbm9iPtTaLa0aAUa1XjQfPKnsp9IipIan9En7Cdz6xRFU=
X-Gm-Gg: ASbGncsrHTScyktKYRkD7QRqb2g5zQib6te+UBqUSLcQpXMY+OibwTyGKqJEYc4hqhh
	if4hWnmRGhUI9r+coYXktMi3PQDrMZexo29KzPuUTVgb5VQ8MC8V9T4kH481g3baKJ5aoY+adt4
	WMcG5hcUyrXi20E/PwR6B0am26pBMZm46/gTyc6KIvZG6VrT5WbWwLZhtTfgToR5c7RblPWsAMi
	/tr/ktm1eT6p66wTYwACl2MQU6e2LvvEOBvnvpEVyXn7ANIUCvgkNAZOaF73Tjy+SsgMr4eehiV
	sbJbJsPHkfdUvToTrh/ky4RHXcadjVmfoeXfUlHmGyBPu4AvdpbJZIOeRwEuaSBf+ftsvJbPnyx
	XwWFFJ1d2JJZjgA==
X-Google-Smtp-Source: AGHT+IEoAXhkyPuNP0/8DAdoHy/HqssAna10I2RNVsH3pSdrPQk7pJA03PtTmN5jQqJrUcwb+a9PlA==
X-Received: by 2002:a05:6e02:12e7:b0:3d9:6dfe:5137 with SMTP id e9e14a558f8ab-3d97c19976fmr1707275ab.10.1746127694518;
        Thu, 01 May 2025 12:28:14 -0700 (PDT)
Received: from [192.168.69.244] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88aac80f6sm6839173.141.2025.05.01.12.28.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 12:28:13 -0700 (PDT)
Message-ID: <21b0915b-422f-4186-a6aa-c484f725bdc5@linaro.org>
Date: Thu, 1 May 2025 21:28:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/33] target/arm/debug_helper: remove target_ulong
To: Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-18-pierrick.bouvier@linaro.org>
 <e1afdcf4-a416-4742-bef2-352a9d184ea9@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <e1afdcf4-a416-4742-bef2-352a9d184ea9@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/5/25 17:07, Richard Henderson wrote:
> On 4/30/25 23:23, Pierrick Bouvier wrote:
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>   target/arm/debug_helper.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
>> index 357bc2141ae..50ef5618f51 100644
>> --- a/target/arm/debug_helper.c
>> +++ b/target/arm/debug_helper.c
>> @@ -381,7 +381,7 @@ bool arm_debug_check_breakpoint(CPUState *cs)
>>   {
>>       ARMCPU *cpu = ARM_CPU(cs);
>>       CPUARMState *env = &cpu->env;
>> -    target_ulong pc;
>> +    vaddr pc;

Why not directly use the symbol type (uint64_t)?

>>       int n;
>>       /*
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> 
> r~


