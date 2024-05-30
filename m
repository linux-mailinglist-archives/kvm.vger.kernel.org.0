Return-Path: <kvm+bounces-18425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 219038D4E29
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 16:39:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A238D1F225CA
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 14:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B654917D8A5;
	Thu, 30 May 2024 14:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="sInuQO+n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1EC17C236
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 14:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717079916; cv=none; b=IbKCS7poOkf7QmmZYDNHPoFWmzG0EQmiWCr4TAw91Hb6Qcw6uiL+LfCXHwa5UHe+Jhw8qzE1e1jbA356tprp9J4ShC3AYVo9yD5B1rVFrRkv8J95oSBEf/vn+NRezAK4aP+Gt2ONopsIrmbkmfjOx7ZctlBuW67xtBD05ZTUuK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717079916; c=relaxed/simple;
	bh=H6kbJAMgSyiK2Mm362YL1uVRFh8mkzI+q2iR1ROJpTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NYN1q3p3ZMuDRuHhMTDmlsdH9jIBcR+lChXjoTDo2IMAhwLS80lwWloIMfQkeQdKrbrbfi+JXfJbu3E128o7c21HvPHizMPsvF901UnX5z5QL0Jjqdlr2FwGrRF2s/0TpILG6NjQc8vS6mjWhrb7ZNzrC5V/xXG1WOyw7iTxb1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=sInuQO+n; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4211323a709so1166575e9.3
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 07:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1717079913; x=1717684713; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lCqk0Wbl0C/qkffAR5D1GSnGrOBHuEfWLT6qcnFKC74=;
        b=sInuQO+nBoq3aLpAlYrsQgUkiQrAbbqRyB+9VZ5PVCRag4oWSgZv+NOkyfId//4HDc
         cjdtbQUp7iXJGaGgYIF2wmPNpjcwhsNVBTUbUWAINectGTciOeBRYx0fNQL/Kx7ZhxRE
         n7hmKwo7wJdMhyAVdXmKms1mqcELViZZrBA9GpaMn8HkDV9y6EqrS6j8m4RwmEWsS86V
         iSTnp01nITZoHQ6uIuIfudWS4nnkkWZKnpBKSMhALvDrEitrvSLPN37R6zZQgI+FrQ0L
         A1ZHU4f8yMXh9hJsPBTLpFSgwWXLSM0A/MK7DF6mbV5dBIzcY0EhA2Z1s0ULeXhyc50Z
         FisQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717079913; x=1717684713;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lCqk0Wbl0C/qkffAR5D1GSnGrOBHuEfWLT6qcnFKC74=;
        b=mUbnTjyRNUMmrJy2PE6Cmkqi7cYnFA/tkaIus31pWVA4Y3OTNGOX1he2FHJE/dPb/q
         QKRKg8o4VK9Wlg0gFOe1s2EgPc9UFPzuZUL6mBJ+YjqzcvnSnFfDHSKWNs3cJeehfUHo
         nYLoATL+WLyyL/A+lE+OsWCnMRhX3l/EEL1ICSsIHt/XMEFlnenHwR/6F6W1WKE+ELIo
         SkzLeN1nJ/wfifo6O5NrnjnFi9pw6wxT3JwzD2yzmG6gUF4ZMtdJRMCDPFSViELOQnpE
         53d9WBD0mjHkEca9ira8LqWUFQxe/GXfFdlLP+PuoWyE7U1QPMGI1ZuIroZWPjGjjafD
         tw8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUANwYSsYWJtayTptnrYIydlinKMiWwxRPk5hy7IPfqRZR7GoxWSyVH4D6rbsLrTS1n2EAqpiqFwOn3hjEWO6Yfsnll
X-Gm-Message-State: AOJu0Yw1YlygB3wbVXCYHlFsvDLM68WnzQDMbrJB00vG531XGjEO6veh
	X5xElHm3NuAI3L0oza5z2+jqxIqqOc41ydAwW9FLo2UsCV8QvbpsxTAabWIS6i0=
X-Google-Smtp-Source: AGHT+IFlbatkP5YNI0+cCdIM7/+OIHMvdLvagld1bA6xjJeK+Uh1NabWQhxIBQr5mw7eUxpTgrJABw==
X-Received: by 2002:a05:600c:3b99:b0:418:1303:c3d1 with SMTP id 5b1f17b1804b1-4212793612bmr20925615e9.3.1717079913490;
        Thu, 30 May 2024 07:38:33 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:999:a3a0:1c45:973a:b74b:ef3c? ([2a01:e0a:999:a3a0:1c45:973a:b74b:ef3c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4212706ea02sm27143985e9.30.2024.05.30.07.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 07:38:33 -0700 (PDT)
Message-ID: <920cc061-f5bf-4eae-88b9-7b7c2b32ed53@rivosinc.com>
Date: Thu, 30 May 2024 16:38:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/16] riscv: add ISA extension parsing for Zimop
To: Charlie Jenkins <charlie@rivosinc.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>,
 Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Anup Patel <anup@brainfault.org>, Shuah Khan <shuah@kernel.org>,
 Atish Patra <atishp@atishpatra.org>, linux-doc@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
References: <20240517145302.971019-1-cleger@rivosinc.com>
 <20240517145302.971019-3-cleger@rivosinc.com> <ZlenZ+NvXxOxvqEO@ghost>
 <ZleqVUhDW+xgiTwu@ghost> <4d23f17e-cc1e-45e3-9ca2-a884baacf207@rivosinc.com>
 <ZliPL4yXBAir5pr2@ghost>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <ZliPL4yXBAir5pr2@ghost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 30/05/2024 16:37, Charlie Jenkins wrote:
> On Thu, May 30, 2024 at 10:12:39AM +0200, Clément Léger wrote:
>>
>>
>> On 30/05/2024 00:21, Charlie Jenkins wrote:
>>> On Wed, May 29, 2024 at 03:08:39PM -0700, Charlie Jenkins wrote:
>>>> On Fri, May 17, 2024 at 04:52:42PM +0200, Clément Léger wrote:
>>>>> Add parsing for Zimop ISA extension which was ratified in commit
>>>>> 58220614a5f of the riscv-isa-manual.
>>>>>
>>>>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>>>>> ---
>>>>>  arch/riscv/include/asm/hwcap.h | 1 +
>>>>>  arch/riscv/kernel/cpufeature.c | 1 +
>>>>>  2 files changed, 2 insertions(+)
>>>>>
>>>>> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
>>>>> index 1f2d2599c655..b1896dade74c 100644
>>>>> --- a/arch/riscv/include/asm/hwcap.h
>>>>> +++ b/arch/riscv/include/asm/hwcap.h
>>>>> @@ -80,6 +80,7 @@
>>>>>  #define RISCV_ISA_EXT_ZFA		71
>>>>>  #define RISCV_ISA_EXT_ZTSO		72
>>>>>  #define RISCV_ISA_EXT_ZACAS		73
>>>>> +#define RISCV_ISA_EXT_ZIMOP		74
>>>>
>>>> Since my changes for removing xandespmu haven't landed here yet I think
>>>> you should keep RISCV_ISA_EXT_XANDESPMU in the diff here and make
>>>> RISCV_ISA_EXT_ZIMOP have a key of 75. Palmer can probably resolve the
>>>> conflicting keys when these two series are merged.
>>>>
>>>> - Charlie
>>>
>>> I missed that other patches in this series were based off my
>>> xtheadvector changes. It's not in the cover letter that there is a
>>> dependency though. What do you need from that series for this series to
>>> work?
>>
>> Hey Charlie, I'm not based directly on any of your series, but on
>> riscv/for-next which probably already contains your patches.
>>
>> Clément
> 
> There was some churn here so I didn't expect those to be merged, it
> looks like a subset of the patches were added to riscv/for-next, sorry
> for the confusion!

No worries, it seems strange indeed that some of them were merged but
not the other :/

> 
> Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>

Thanks !

> 
>>
>>>
>>> - Charlie
>>>
>>>>
>>>>>  
>>>>>  #define RISCV_ISA_EXT_XLINUXENVCFG	127
>>>>>  
>>>>> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
>>>>> index 2993318b8ea2..41f8ae22e7a0 100644
>>>>> --- a/arch/riscv/kernel/cpufeature.c
>>>>> +++ b/arch/riscv/kernel/cpufeature.c
>>>>> @@ -241,6 +241,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
>>>>>  	__RISCV_ISA_EXT_DATA(zihintntl, RISCV_ISA_EXT_ZIHINTNTL),
>>>>>  	__RISCV_ISA_EXT_DATA(zihintpause, RISCV_ISA_EXT_ZIHINTPAUSE),
>>>>>  	__RISCV_ISA_EXT_DATA(zihpm, RISCV_ISA_EXT_ZIHPM),
>>>>> +	__RISCV_ISA_EXT_DATA(zimop, RISCV_ISA_EXT_ZIMOP),
>>>>>  	__RISCV_ISA_EXT_DATA(zacas, RISCV_ISA_EXT_ZACAS),
>>>>>  	__RISCV_ISA_EXT_DATA(zfa, RISCV_ISA_EXT_ZFA),
>>>>>  	__RISCV_ISA_EXT_DATA(zfh, RISCV_ISA_EXT_ZFH),
>>>>> -- 
>>>>> 2.43.0
>>>>>
>>>>>
>>>>> _______________________________________________
>>>>> linux-riscv mailing list
>>>>> linux-riscv@lists.infradead.org
>>>>> http://lists.infradead.org/mailman/listinfo/linux-riscv
>>>>

