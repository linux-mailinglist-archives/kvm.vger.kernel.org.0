Return-Path: <kvm+bounces-47700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CB58AC3D0E
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F40E5175B7E
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 09:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564B01F1517;
	Mon, 26 May 2025 09:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="t75CBBJ7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3016F143C61
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 09:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748252301; cv=none; b=RxgGM2TnTx5MK7IRaE4I/ovAe9GrWNzTaE67GPkhElqd0if39Gg749S2gXzzBn+2QiR5Dnf+7LSKfsJ71D7i6PHo8RwJZAr98ovtSqNtLu23il4DqN/wFBGcbmq+vTUWuZsSFnfiGaOBH6fQmEO77+1zTgotqyEcStN0VwRG83k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748252301; c=relaxed/simple;
	bh=i9i8/ewq7VfXozbNbj+b/u9iFiv/PHquWUPkUve+/0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C9NcYwrGAYI87QIEwq7y09zhb9IiDR09qcJCsW2UveTHR4POgNIhI5nX/1Z2QKRjPbcEX28T9rZwy6G/FtE+XxJ4nXE6LCK1CzRAcQNAtlvc4sZr/570SGDEmxiwG2VhQmk9dYM6wTbiW2veVGaLzVVHHINs4vLWx3SLNWvW6K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=t75CBBJ7; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso1292174b3a.2
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 02:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1748252297; x=1748857097; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ayXEI8Cfv1/N/P9sk6QD8plzK1Zh4bjNNg4FyYTKeW8=;
        b=t75CBBJ7R1LrkYCsBz5TIfMTqIl70m9KyqO7kgTF4RIHArUiDG3ZzgE1UVinXfohWk
         GJ9cvQDAcoC/365RclM8JQL6xgG9pCX2slQfk/2DvrMbhVqdP8ZBZMJ+Al+U5ODE5Mhc
         mp+M+7B7u8vQ7ENRPl6mzi0UZle+l8TqTtl2BmcoRorbmkr9sgdbD64QW0KEz8iopxT1
         shCd5t/b7KEM92tFRZcN//Cxs23PDZt9jwtHhF7l5d1gTT+FpFqoj168WEvVYfqku8sq
         gKLUvQdgDMvsLtsdUPHAoP3OpR0pFkmEleuPHHsfGjcnZRzU8JCOTCvWzEwMulLXWrDC
         gxTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748252297; x=1748857097;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ayXEI8Cfv1/N/P9sk6QD8plzK1Zh4bjNNg4FyYTKeW8=;
        b=RXAutJSPZcSXMLSMzAR+EFijemXT7eveWCv/LcXYUGMy0FsXzdW2RwS/R2QLDmeor4
         zls/EBCKWk8j9+eaWBSbzuoFMs5BVXpnIqztzqsb3mfBanKMD1gctBCn9mGdUoDrRKg4
         nASSodKXbZReUmR7GNQisflKr53wM/D6UOdJH1Q5NKE42SlYGTxQMNbxzpgqbr5W10YN
         9tv85UyXDHwQ9CMzG64HNr+PWqa0GjLk899QYIQylRfDkuMtzn134ZMehg57VWh9OM1O
         KWcNJKX5Ei3aoOi88HRiFxNRZhBT5iW/KNeVmzggrDvP1JCTcyzxQRIwrZHo5P+iG1Lw
         /lVw==
X-Forwarded-Encrypted: i=1; AJvYcCVmo6/CSwykCD2ylXVpiROjOz09LC6ePpIyVmH7FMDK/f9yPIav/p592Y+rPEyAMVHVT3g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIuwpt60fErHrAK22Kw/4uwOWqfAyi3WseZ8c78as4Bl+XyFLX
	hVKaEgtvzZRcHLm6fMk/oJVUg+WM5ZhYvHoe2k6aMYIzhibgltHVc9Lo1qhL3sVp+Zs=
X-Gm-Gg: ASbGncvHY21KkVYJNbtIPgPf4DssGgCl5NrqWoqP5mFp5rrdih+DwbN+5wpacXGOAXi
	EcPC29gIL40lpQEu3sfxGG2vRFVjP7RUw+YTEeE6ZMy3q0LJLdgV+Wkmerg1y7g6Mjw7VU9Z5HH
	K81lyhGGku9jC/IkHf6Lod1GyXaVfz6RpuFAL/xGAuxmUHDszx9hSWphqWycUO/ZyWlrls3nsJG
	08TDhSF1OZ+IHpxEglnZJZ82+krsyrF9vkrAM8IK/lvLrLjm0Ht/xz79ovU4K5gUdLe4Eyjo4oF
	/d3bzz5p+U03AKXmXmfZCzmbLEpgNigQSNxiK/LvbJoW3efblYqRRkvtkEJI0wTenIcexxIGlLy
	Xi6BnZfCvb2DtTv7zlE9q
X-Google-Smtp-Source: AGHT+IGtpgkfGcWHXNllZ6N7OfshZvdC/ul39y9uFpqnjdl5yZSiN5+nr2uee+5tOzhJpdCxTYM3zg==
X-Received: by 2002:a05:6a21:8dc6:b0:20d:5076:dd78 with SMTP id adf61e73a8af0-2188c3c78f7mr13332787637.42.1748252297429;
        Mon, 26 May 2025 02:38:17 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eb0a4af6sm16624196a12.77.2025.05.26.02.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 May 2025 02:38:16 -0700 (PDT)
Message-ID: <20aeb166-6128-4dda-a963-c9f66f491bcc@rivosinc.com>
Date: Mon, 26 May 2025 11:38:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/14] riscv: misaligned: move emulated access
 uniformity check in a function
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Charlie Jenkins <charlie@rivosinc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Samuel Holland <samuel.holland@sifive.com>,
 Deepak Gupta <debug@rivosinc.com>
References: <20250523101932.1594077-1-cleger@rivosinc.com>
 <20250523101932.1594077-10-cleger@rivosinc.com> <aDC-0qe5STR7ow4m@ghost>
 <b2afb9c7-a3d2-4bf6-bfaa-d804358ccd88@rivosinc.com>
 <20250526-baaca3f03adcac2b6488f040@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250526-baaca3f03adcac2b6488f040@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 26/05/2025 10:41, Andrew Jones wrote:
> On Fri, May 23, 2025 at 09:21:51PM +0200, Clément Léger wrote:
>>
>>
>> On 23/05/2025 20:30, Charlie Jenkins wrote:
>>> On Fri, May 23, 2025 at 12:19:26PM +0200, Clément Léger wrote:
>>>> Split the code that check for the uniformity of misaligned accesses
>>>> performance on all cpus from check_unaligned_access_emulated_all_cpus()
>>>> to its own function which will be used for delegation check. No
>>>> functional changes intended.
>>>>
>>>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>>>> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>>>> ---
>>>>  arch/riscv/kernel/traps_misaligned.c | 20 ++++++++++++++------
>>>>  1 file changed, 14 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
>>>> index f1b2af515592..7ecaa8103fe7 100644
>>>> --- a/arch/riscv/kernel/traps_misaligned.c
>>>> +++ b/arch/riscv/kernel/traps_misaligned.c
>>>> @@ -645,6 +645,18 @@ bool __init check_vector_unaligned_access_emulated_all_cpus(void)
>>>>  }
>>>>  #endif
>>>>  
>>>> +static bool all_cpus_unaligned_scalar_access_emulated(void)
>>>> +{
>>>> +	int cpu;
>>>> +
>>>> +	for_each_online_cpu(cpu)
>>>> +		if (per_cpu(misaligned_access_speed, cpu) !=
>>>> +		    RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
>>>> +			return false;
>>>> +
>>>> +	return true;
>>>> +}
>>>
>>> This ends up wasting time when !CONFIG_RISCV_SCALAR_MISALIGNED since it
>>> will always return false in that case. Maybe there is a way to simplify
>>> the ifdefs and still have performant code, but I don't think this is a
>>> big enough problem to prevent this patch from merging.
>>
>> Yeah I though of that as well but the amount of call to this function is
>> probably well below 10 times so I guess it does not really matters in
>> that case to justify yet another ifdef ?
> 
> Would it need an ifdef? Or can we just do
> 
>  if (!IS_ENABLED(CONFIG_RISCV_SCALAR_MISALIGNED))
>     return false;
> 
> at the top of the function?
> 
> While the function wouldn't waste much time since it's not called much and
> would return false on the first check done in the loop, since it's a
> static function, adding the IS_ENABLED() check would likely allow the
> compiler to completely remove it and all the branches depending on it.

Ah yeah indeed ! I'll do that

Thanks,

Clément

> 
> Thanks,
> drew
> 
>>
>>>
>>> Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
>>> Tested-by: Charlie Jenkins <charlie@rivosinc.com>
>>
>> Thanks,
>>
>> Clément
>>
>>>
>>>> +
>>>>  #ifdef CONFIG_RISCV_SCALAR_MISALIGNED
>>>>  
>>>>  static bool unaligned_ctl __read_mostly;
>>>> @@ -683,8 +695,6 @@ static int cpu_online_check_unaligned_access_emulated(unsigned int cpu)
>>>>  
>>>>  bool __init check_unaligned_access_emulated_all_cpus(void)
>>>>  {
>>>> -	int cpu;
>>>> -
>>>>  	/*
>>>>  	 * We can only support PR_UNALIGN controls if all CPUs have misaligned
>>>>  	 * accesses emulated since tasks requesting such control can run on any
>>>> @@ -692,10 +702,8 @@ bool __init check_unaligned_access_emulated_all_cpus(void)
>>>>  	 */
>>>>  	on_each_cpu(check_unaligned_access_emulated, NULL, 1);
>>>>  
>>>> -	for_each_online_cpu(cpu)
>>>> -		if (per_cpu(misaligned_access_speed, cpu)
>>>> -		    != RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
>>>> -			return false;
>>>> +	if (!all_cpus_unaligned_scalar_access_emulated())
>>>> +		return false;
>>>>  
>>>>  	unaligned_ctl = true;
>>>>  	return true;
>>>> -- 
>>>> 2.49.0
>>>>
>>


