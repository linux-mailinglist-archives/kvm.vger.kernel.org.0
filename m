Return-Path: <kvm+bounces-44136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE0BBA9AE6B
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:07:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 899693BC1AB
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 13:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B0B27F751;
	Thu, 24 Apr 2025 13:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="VYXbB5tz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAECE545
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 13:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745499849; cv=none; b=TNJa0FbIRjUwEK239cHcrn2MdBnzW8iXfJavyz+CQZeMpg+xNX7UksyYhqkrQ4Fcamvoji7X9BQqaIy5vW2mq8w+/7jHtN1Atyu1Mejln0rI/+x51cRwcZgYX00TgEDOcCOQ0alt/AAdJSzh7woGRGhFC9XVqxt1CVTBY8wfC4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745499849; c=relaxed/simple;
	bh=pgbvCwp/paE3IyGYTw9Wb1/PXLYgEcy616PkjyGJOSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kmGChHlnEvTKu6VULAJ2xwPnH665Y36IJTKT+LFZMZzFvKhidOl6o0W9rzIYWfQKA65uHrbovjN98BW5H+MmDspdlcc4c5q/lwnpwqeQh25SsEgL4C6/VKydaekJGehvyjv+rJPfWm1bxN8Oa8JBv8UicYMzh/zsMpuJC+Q0SpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=VYXbB5tz; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43d0782d787so6365005e9.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 06:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745499845; x=1746104645; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZlenUvh61lykgI0moQ4b5m5MpD7H2yqiNR9KiWkzX9o=;
        b=VYXbB5tzb8XIudiEVaWQPT0utH1Kbc7Qh7zQqzmmafEhB0TN+/xnDJexH5WGp+bZhv
         +RhOH4Hc6SkwqB17dLvBAsfueWIK61ukMaVRtecbbPbbqj+mWbp8Ag+lqZYDvy74z4uR
         xkzZat/8z+83jkZLpcX6mJ7eArAXYQxYlY8XhxErxf/bNCDTx4Z6aF7g5eiWv//ynzwF
         qxWRgvFXu0wps+/UBC7DDbXKoJ23qDqHHRQPG1x7hen31q0NoR2fhA3G+plnTmSWVTbA
         idPJOzPq8lgdbfKCG1pufzge194CNUcc254VBhwWSljNtLcREgGr/wfQ77vzapK3G+YK
         araw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745499845; x=1746104645;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZlenUvh61lykgI0moQ4b5m5MpD7H2yqiNR9KiWkzX9o=;
        b=a2KJqoBLxBaJpgb1n12vNfzihUpzgwV/bA/ccTi9ovpPTC5LlLuFs9xsVk+Xzeo8jJ
         kHiwnv9v8rkd5+H/UFUCCTSDERhoHOQf2Zw8m+65Gf66qUMF+pAegtUvSKSOKwjo+qap
         7i5fNL1yeeCLa9wiUBFUlVddrJPE0YlToe6eaSEeNgXmFK/CcbdO+wjmQ64j18M1octY
         9aqrIvyGu4ZAl/2xGKh/7G8wsna7vvxMeQG4YJllPGUMEnVWoVYqE3Kr8O84WxtpvVHS
         Yj12I8dzZB1FGmcVKJKqzmOweErlJgWNOTQ9oH287HLtVR24g+/Avh0C9ukS8VSPoA57
         z9eg==
X-Forwarded-Encrypted: i=1; AJvYcCXxFdk4veLafj/nyNySjHtauWV6Ab5SKUDrulOMjS3+cY5yHds5R8SkB0i8C9L7yUasb2A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1jK78TMUOK1s8aPa6Falc57xny9jpRB0d/Hf/6YvewLiNXuwi
	FETC6Q8PyX+glFiIUi3FQSZ68WXZ6ezxD6GDTZ2Ta05z4IagJI59U0zTOn9f4gc=
X-Gm-Gg: ASbGncs6AmIaN3/icmaLzRDGb7osBLTwhg+RQMLktuDkbrvnY2b1OhI67fjWvK/oXQv
	fpGGYmKTV77MaWcn4qb6XjT+WBtRhSx4mvqHvFGub3EobC05QhW9/iTTUHwxGzaLsWizAEvXOIt
	z9XqGTfcVulXBqL5y+lkanPBRS1xEhD8GMMm0ZhDabzmKGrEu3nPFKyQQ1xk4InDI25/nfA5Bt4
	NPigyFKULvm8zW74DCyqSD+9uVG+JPmvyu8tPTj8ISA8tv48Okao6ukNEYF2hxoOoofhS5Q21/P
	bkJDZlzQokOthpash9B7mSvhnU9Y3B0a4S/7GKvh+c6GoPfgF8zsPv8dNk+HgGP1V8x6lF3HSTR
	yk4T8J6GqqA==
X-Google-Smtp-Source: AGHT+IFY/zQrAFYpl1F/wfq7qZKx4PChEo3rOT9RvUxXUgDej0UjL+OvlI8WpktqulU98FccnhbKpQ==
X-Received: by 2002:a05:600c:5110:b0:43c:ef55:f1e8 with SMTP id 5b1f17b1804b1-4409bd20ab9mr23814095e9.13.1745499844890;
        Thu, 24 Apr 2025 06:04:04 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2acf8dsm20366545e9.23.2025.04.24.06.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 06:04:04 -0700 (PDT)
Message-ID: <8c7c1632-ced2-491a-92a3-8b98de655b4a@rivosinc.com>
Date: Thu, 24 Apr 2025 15:04:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/13] riscv: sbi: add SBI FWFT extension calls
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Samuel Holland <samuel.holland@sifive.com>
References: <20250417122337.547969-1-cleger@rivosinc.com>
 <20250417122337.547969-5-cleger@rivosinc.com>
 <20250424-c0700f89bcd29438d6d8d65c@orel>
 <f6c5c92d-73aa-41a7-99bb-f95e388ea294@rivosinc.com>
 <20250424-27a672c1da15353051b52c59@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250424-27a672c1da15353051b52c59@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 24/04/2025 14:59, Andrew Jones wrote:
> On Thu, Apr 24, 2025 at 02:35:02PM +0200, Clément Léger wrote:
>>
>>
>> On 24/04/2025 13:06, Andrew Jones wrote:
>>> On Thu, Apr 17, 2025 at 02:19:51PM +0200, Clément Léger wrote:
>>>> Add FWFT extension calls. This will be ratified in SBI V3.0 hence, it is
>>>> provided as a separate commit that can be left out if needed.
>>>>
>>>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>>>> ---
>>>>  arch/riscv/kernel/sbi.c | 20 +++++++++++++++++++-
>>>>  1 file changed, 19 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
>>>> index 379981c2bb21..7b062189b184 100644
>>>> --- a/arch/riscv/kernel/sbi.c
>>>> +++ b/arch/riscv/kernel/sbi.c
>>>> @@ -299,6 +299,8 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +static bool sbi_fwft_supported;
>>>
>>> At some point we may want an SBI extension bitmap, but this is only the
>>> second SBI extension supported boolean that I'm aware of, so I guess we're
>>> still OK for now.
>>
>> That seems reasonable to have a bitmap rather than duplicating
>> *ext*_supported. If that's something that bothers you, I can take care
>> of it and use a bitmap. SSE will also have a sse_supported boolean but
>> in it's own driver file though.
> 
> Up to you. We can always do it later.

I will let that for the next extension being added then ;)

Clément

> 
> Thanks,
> drew


