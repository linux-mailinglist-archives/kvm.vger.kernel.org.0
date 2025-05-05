Return-Path: <kvm+bounces-45459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBC9FAA9C69
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 21:21:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2721717E513
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 19:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5B026FA40;
	Mon,  5 May 2025 19:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nHMGQ534"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31ACA1487E1
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 19:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746472888; cv=none; b=YuTzZpZR3BSDepOFmuRql18E3I+YVtYAvw6Nz/SdtFiWQz3qUpV2pw6WvgxPW6ODGKNJcpEl5lcftwVCdC4Uq0swBPPlFWTtaxPtWSyraTGav27XXphYNQp6NXTmVnvJfxUWav+LOgmi/12tTm8mblFa4gcxI1rxyCGs0MKgWKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746472888; c=relaxed/simple;
	bh=2N5YVxfvp0/l3hlPu042eGjI8xkvY/ZqrNEwNZZ/j90=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uk8tu5jP5oafaNqJeVFcnUWZxFaLZZSeD1HMejTfdI9r1RxX0GF4Nb6HsuAKqR3CUvB+hPoJYKxu+yWdcf8yom0tE+puWqBcpDPjpyic9IkqMOMxRwAtPbrj5UM0OZH4FhedUtTxqqlzEZ5m/TeuHWvrphEU+4XwrotHD1Qu8ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nHMGQ534; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2295d78b45cso63130145ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 12:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746472886; x=1747077686; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rKUeGEJlprcUuMRYQLCNcs8/KtlUslt/cF30WTx3Smg=;
        b=nHMGQ534j3k4AEqtu2lVJp/JLr6Wt0QjaB9TRMs73VQOAfWGpJG1BMYkDeipoOJ2Gr
         ghkXyMBWjRlSVhCgPy3XYx0a4k9NSRyILRlSQmG6evwv7uStEBZu2GsxUOPxxG+ZntOS
         GObFBu4NOfDaLh8CS2fDKft71re8moTGtg28NuROrFzThhbbcOaBg8yi7Nyowk+1KubE
         Nn4de3NiOQ4ETfa6vpxuiJ7l/YXWWNzhYY1nMrEnGVFirH1Y0r516swO4mrPCDR9lP63
         h8/UWYqOaN87PQx2tD0ASf6M71TrRs8rZ77t7SsGioE7y3cc0bBfUQYvJj7KWTy+4ZWr
         nk8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746472886; x=1747077686;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rKUeGEJlprcUuMRYQLCNcs8/KtlUslt/cF30WTx3Smg=;
        b=nwrywZxWpc7cNoAkRPOaxdHb75HDl9qm4ZbAq3UgX1JP1vnRMM9TMrQ3829Oh85+ek
         wRjo1RPzrISWdqOHl3zolqD2lkrSG0s+1GyQc57fip1AZTRrgJpuLjLUeAOwU5o7oqM2
         2scGoeMJyofV6WMhO6WnNI2A1LUBMFcVKsQWvoWipJuU8f972/wI5AD7UtGhYMvRXJwF
         tNN1Iaa/tn+4DpAvn/MOZRB/JEsIuLSI1UoBX5jDrTCaZIbV3yDTfQyam3RMIQTy+RZU
         MK8dZ9H+EftfoyjlCbMn+6NZs9yURT3MMVibA/B+pgOtm5hJ5j6RWqtzey9tXpAfqqzI
         hkzQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+LFR7cLVIIqjigBrldl1XUffHW8X0BjS7FWzgMYkd+1seF9BuCyb6chb4lVygQYLd8Dw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz+hNmivwGnS8wC5mdnK1uG4nqUsBXp4UQGfcrDVww8+mTRerW
	U08kDOf1A3GgpAGCl09HshrjdJfDW8HL7GiAMcPUjwe1EHJ0+xwKI5ht6YyWefs=
X-Gm-Gg: ASbGncsf0N3SO2jGUO4aGm36/r57GLO8ab+RlO6WB1bFrL5rKqXyNDSkWfMcXHqMcUp
	8cVam2gVfdPdjsfYZKfppbDmV84drbY8aCtOKAFryJbyPqB7BuoraFXfgrdFurtwk+M+tuJPXuJ
	cNitsYbhnFEHgMc9jsCpmv3FJwXUxr10JHbiAwHGbFt+Qt6sL10ihq1tORnxuiJgAm07BoIRC7b
	UdqT1LtvdeDAXcMwaA7Xcpk/3A3sppKLtRkTJsUsMV2y271+XA41pasxcOly1lpdiy+Ep2toF6o
	pCsc2fhgOzlTIY9XrEzpMRHNoYh/uKi+AI4JESJUD6/xQeFCowLbKg==
X-Google-Smtp-Source: AGHT+IEU3LO3BLYHgDWrtN9CLYWTq6t5MCfWL98ImCZ5M7qGwidnZY2CVsEvZfUEZd+rLsDHEoZTxw==
X-Received: by 2002:a17:902:ecc3:b0:223:5c33:56a8 with SMTP id d9443c01a7336-22e32eeea95mr8802935ad.35.1746472886426;
        Mon, 05 May 2025 12:21:26 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e363a1aa1sm648655ad.194.2025.05.05.12.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 12:21:25 -0700 (PDT)
Message-ID: <afa68161-39cf-4d3b-96b9-9c20d3a3f732@linaro.org>
Date: Mon, 5 May 2025 12:21:25 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 44/48] target/arm/tcg/neon_helper: compile file twice
 (system, user)
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-45-pierrick.bouvier@linaro.org>
 <7ff2dff3-20dd-4144-8905-149f30f665b1@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <7ff2dff3-20dd-4144-8905-149f30f665b1@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/5/25 11:44 AM, Richard Henderson wrote:
> On 5/4/25 18:52, Pierrick Bouvier wrote:
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/tcg/neon_helper.c | 4 +++-
>>    target/arm/tcg/meson.build   | 3 ++-
>>    2 files changed, 5 insertions(+), 2 deletions(-)
> 
> Likewise, I think this could be built once.
> 

needs access to env->vfp.qc[0], so pulls cpu.h.

> 
> r~
> 
>>
>> diff --git a/target/arm/tcg/neon_helper.c b/target/arm/tcg/neon_helper.c
>> index e2cc7cf4ee6..2cc8241f1e4 100644
>> --- a/target/arm/tcg/neon_helper.c
>> +++ b/target/arm/tcg/neon_helper.c
>> @@ -9,11 +9,13 @@
>>    
>>    #include "qemu/osdep.h"
>>    #include "cpu.h"
>> -#include "exec/helper-proto.h"
>>    #include "tcg/tcg-gvec-desc.h"
>>    #include "fpu/softfloat.h"
>>    #include "vec_internal.h"
>>    
>> +#define HELPER_H "tcg/helper.h"
>> +#include "exec/helper-proto.h.inc"
>> +
>>    #define SIGNBIT (uint32_t)0x80000000
>>    #define SIGNBIT64 ((uint64_t)1 << 63)
>>    
>> diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
>> index 3482921ccf0..ec087076b8c 100644
>> --- a/target/arm/tcg/meson.build
>> +++ b/target/arm/tcg/meson.build
>> @@ -32,7 +32,6 @@ arm_ss.add(files(
>>      'translate-vfp.c',
>>      'm_helper.c',
>>      'mve_helper.c',
>> -  'neon_helper.c',
>>      'op_helper.c',
>>      'tlb_helper.c',
>>      'vec_helper.c',
>> @@ -65,9 +64,11 @@ arm_common_system_ss.add(files(
>>      'crypto_helper.c',
>>      'hflags.c',
>>      'iwmmxt_helper.c',
>> +  'neon_helper.c',
>>    ))
>>    arm_user_ss.add(files(
>>      'crypto_helper.c',
>>      'hflags.c',
>>      'iwmmxt_helper.c',
>> +  'neon_helper.c',
>>    ))
> 


