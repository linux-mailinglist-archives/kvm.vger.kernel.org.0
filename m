Return-Path: <kvm+bounces-44827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A65CAA1CB8
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 23:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9B161716B7
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 21:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B6926B2BF;
	Tue, 29 Apr 2025 21:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bzn65inS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85D4214A8A
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 21:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745961245; cv=none; b=WQvcFQm0LxfeMWw/qKQ3MSD0vy7RKPcT/ArYPCEDyQI9wLGh1EfHo5pFF+jYPiOhByd+ETxcqVagYVNWCXlf7a8Bxrwo5stHbZuXRf4VOqClcM9fhYKa8YoX+ud+6b/oCGQgJWKN2/htxXj7Fl1QwtWgVZV26BQJfzHdiius0vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745961245; c=relaxed/simple;
	bh=1QHm/9Y+ziItoAOaieymbq+ZON7q1+kHvbsE1C6jq60=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OREXRCKdxO3cxMtihB6HJF4Y1ZrRdvLbQRBxHYCA5y1alINUWI9GCumol76h5y2G7DGtBXF9DVI3euOhhfcPT4qlpFX0G5EYl9aVVbHjS+5gq0Ed9vlodROF0GfXGwD+S9V90+wU7Zy1W6WIkkRfFhFjvNCLVvQ5o79Dw25yKm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bzn65inS; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22438c356c8so72267045ad.1
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 14:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745961243; x=1746566043; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hOHQaZoxZ7UbKQya7ht8bDTHCEK26P6Ba+yTQsPhO10=;
        b=bzn65inSW6yLRydCx2FtlDp9ALKCsm4zCkb6quRRQg6ZIfUYyyo8iupz5+fBkWblLR
         U812im9cPy30tAvBfmY0G5/+4RR5ZIEMh1xeUJD/f1A6kD241dj17MRHq2T8lC5Fj1p7
         mt2fglrd5ejYxSkAHpP4AsEJtcWuYqi0rLh3QzbVPufryL5i+qE5mk+jqAPMo6YnYai6
         qwJRM0wM6arvKiz4h9VsPldonYFzXchjNJUOmcQIOZxsJ21xNNEy8XPfXkrk5IT39WSG
         b0aETAkzCPYG7aubYscfIAGIGeSU2Q6+DxtN69V1r3ImIhzSmPGVzUJoD8hwzlpt2wxG
         qmdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745961243; x=1746566043;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hOHQaZoxZ7UbKQya7ht8bDTHCEK26P6Ba+yTQsPhO10=;
        b=qi+oh0VydjX0qeU/M8uKBZ/rk9mi6r0f2nqE1rlTcEHEup2N/jp8+UsE0Y7szr9cPO
         WzuR8eEe1cheLv4BhWAXiZ0M4dkDNT9NdOrIwBTd2ifymp2jBnkwVi1dufqxWAuP5oGq
         jhQl+O+w3xpxCR8T1INFjpwEQBSo/lkEGFQunhVh8tpr1zWod15YBRROT0QNmIl9uYVW
         tbzQIrvB17fQnxMbNhuQZH5p7xvngkhQNoKc4c5ot5N+ofbo6ENqwjnEkfn3ETweWx2m
         2OA4AXQU2fWpUIulI13I9u9Gd7GIaufjGltIZFI2A3nUQeSEP+lg1ax+gDz64sCZB3ZN
         50Pw==
X-Forwarded-Encrypted: i=1; AJvYcCVtm0jjvAUOuniCDeKPK7qm1wfOv/6YCPSlBBwDY4AUIzCVd00W8ZqeTYklETJbh5gp0N0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaLcxK1LZNHfUJINtn6rQrjdz9Njil04kO1Pjlz98P1uS/Qu1x
	2vat0HfGxh8sN9MqjiDPJwZLIlCvNPdL7L+6XYBRnKDi85rpvJgDERZam3vncm8=
X-Gm-Gg: ASbGnctggThA44vI8SCGuBbph/iQlJ9Mu5s7if7LUyurPe8iWMhnrIooqqymb+BqZJW
	9/5cpjQVIn4zRIRpm+Y+LIEHO8OM/fMpnOA0C0b2kAoGWewiS1mIYCl5QaUVZs+NbTNvkasrcB5
	CxjWzf6z/xgVE0oT5DJmDVWDR4T38CcrFUvN4aiB76xTDJapNnHVbf8iRKR07Mf97jZpg2qp/hP
	dPKnRIhfc6j9UXOQ1gCFVjX62dzNO2gdz87t25+obdgPpSI3i+foX8wLorxN7QqR1DACG7TPm29
	5HD/t2QaHG94BvuXK0YDIAPA9qJZGtgU+LQ4dojks2zaS6XDY0y4BQptFJ0dG88M
X-Google-Smtp-Source: AGHT+IGVp4+1Bhotq0d4aremIqEwnPUtzY6snkcOfYlsGofhxa81gl1LdUI7VT6xUzXDUNe4F7okDg==
X-Received: by 2002:a17:903:2f43:b0:224:1943:c5c with SMTP id d9443c01a7336-22df34d33edmr13219515ad.15.1745961243059;
        Tue, 29 Apr 2025 14:14:03 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db50e7b50sm107997675ad.130.2025.04.29.14.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 14:14:02 -0700 (PDT)
Message-ID: <d455055c-a13b-4e00-b921-5ede2be08e89@linaro.org>
Date: Tue, 29 Apr 2025 14:14:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/13] target/arm/kvm_arm: copy definitions from kvm
 headers
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-arm@nongnu.org, anjo@rev.ng, richard.henderson@linaro.org
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
 <20250429050010.971128-6-pierrick.bouvier@linaro.org>
 <87msbz45y6.fsf@draig.linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <87msbz45y6.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/29/25 3:28 AM, Alex Bennée wrote:
> Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:
> 
>> "linux/kvm.h" is not included for code compiled without
>> COMPILING_PER_TARGET, and headers are different depending architecture
>> (arm, arm64).
>> Thus we need to manually expose some definitions that will
>> be used by target/arm, ensuring they are the same for arm amd aarch64.
>>
>> As well, we must but prudent to not redefine things if code is already
>> including linux/kvm.h, thus the #ifndef COMPILING_PER_TARGET guard.
>>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>   target/arm/kvm_arm.h | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
>> index c8ddf8beb2e..eedd081064c 100644
>> --- a/target/arm/kvm_arm.h
>> +++ b/target/arm/kvm_arm.h
>> @@ -16,6 +16,21 @@
>>   #define KVM_ARM_VGIC_V2   (1 << 0)
>>   #define KVM_ARM_VGIC_V3   (1 << 1)
>>   
>> +#ifndef COMPILING_PER_TARGET
>> +
>> +/* we copy those definitions from asm-arm and asm-aarch64, as they are the same
>> + * for both architectures */
>> +#define KVM_ARM_IRQ_CPU_IRQ 0
>> +#define KVM_ARM_IRQ_CPU_FIQ 1
>> +#define KVM_ARM_IRQ_TYPE_CPU 0
>> +typedef unsigned int __u32;
>> +struct kvm_vcpu_init {
>> +    __u32 target;
>> +    __u32 features[7];
>> +};
>> +
>> +#endif /* COMPILING_PER_TARGET */
>> +
> 
> I'm not keen on the duplication. It seems to be the only reason we have
> struct kvm_vcpu_init is for kvm_arm_create_scratch_host_vcpu() where the
> only *external* user passes in a NULL.
>

I'm not keen about it either, so thanks for pointing it.

> If kvm_arm_create_scratch_host_vcpu() is made internal static to
> target/arm/kvm.c which will should always include the real linux headers
> you just need a QMP helper.
>

Yes, sounds like the good approach! Thanks.

> For the IRQ types is this just a sign of target/arm/cpu.c needing
> splitting into TCG and KVM bits?
> 

I'll move relevant functions to target/arm/kvm.c, so cpu.c can be 
isolated from this.

> 
>>   /**
>>    * kvm_arm_register_device:
>>    * @mr: memory region for this device
> 


