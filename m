Return-Path: <kvm+bounces-41530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA24FA69CB2
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 00:25:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 300B4189A05B
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 23:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38CC52236FC;
	Wed, 19 Mar 2025 23:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nI9qKS1U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7ABC221F3A
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 23:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742426750; cv=none; b=tVJx9Xk/Q9tp218w5UoA5ht+Wz3M2Q8gkorI+5BBBRUxXGo6bmb+Ikvr0oqC9PS9gHqA498acE9lMI3vfzuIbfRW0i17tE/KVjBE8DiYSzZaOM/+PhsC1VufHbrIPFE+raKGpCkKJlCilKYOz3FcM1zox7Ln86VNsnkqL76P7ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742426750; c=relaxed/simple;
	bh=A5vSIn2rAAozaArJcM3rr4Uv67bgCbFcjKmAfcN8/eM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qILWTUa3mkQcIRBQTPh12PdY+wZSoUD2bUCVOTCLIhOxcg2skWXG9+H1P1UszqJMHYO9qEKKe9bkfczPRBEM2zaw+Co51L7rnJDDq7KpDa9fegOkV9TeJIBBca6a0RdaGK4H9y5o7H0zZ03IYIfV1D5iJYgsozrTdTeM9QegwPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nI9qKS1U; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-223fb0f619dso1761875ad.1
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 16:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742426748; x=1743031548; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vjfR9UwecaSn8yWmmPZcnLHVsPnQ7Q3oWoSlhpoapEQ=;
        b=nI9qKS1UKaHn4BfiBKjdLSr32X4oS5RV+sRodc7ohv7jISmGRD8+WWeiww+0GZsPAN
         gJrunUE8eDzXr4LWDtkoGb4MAF2lcYdR92XBoXn3jY8YJF2pmQXKfhMGocMHGB+kfYA1
         x6OJTyKXiOy2btznmYWmHBEZ/RKBh06s3jAqbCtu3BRm/HDW/F7XHFSxEIXfYQVmBS9K
         vl/F4fe9WUf+JTJ+YV8t2Nx42ll0q3l1eL0gbmpvt+kSGM+j1tRVbKUe7qUtxeP9SmWk
         Nz8ZZefXjqkXanI7LYftjngSjxGryZbUGjRT53fPhbnyxMGlHKm8w57w7os0cM9H8O9x
         2vlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742426748; x=1743031548;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vjfR9UwecaSn8yWmmPZcnLHVsPnQ7Q3oWoSlhpoapEQ=;
        b=aZsOv+9mpFVr923TPsJ+LBpdamnA9pzM8Ab4nUzFSDSI2XjLPPu1ERy22vxj9dI6QW
         6h1ri/PwUyESw01WgTtzpUsh0TLuT2JLtBgsZDUQsiLevxH76dnAsuyiZnyUlW4+uOib
         QtYVr5GAtOUOGDcnTrUS2zn3S1ZMxFW15Olfjb3yw+UB+wCK61jpeEPyzjN8cYQ2EAIo
         ve9e2ORFpcfSb9ePJS6bnNvJTFEoVPFue77bODwaYmXS7UxVzOeMtws67La8nYVb/teX
         qTLiw8q9ddsqhU4jwO5/QRG55gd0syMXpiHTzTmKu7s2IBPpANXfIX40URNeaQgmukdL
         xrfw==
X-Forwarded-Encrypted: i=1; AJvYcCXB49TyuSJ70nyKSjfrczPuQUb05Y5WFIEimZG+l5EFOXKeWV/5XcsO4/vjffPJAerouco=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/8WpNu1RlIimHObXWHQpZ0Ytr1eBT/UfJmpLgGY+USISFv2B9
	i10tk+eNI1SPpOcbKzKpuGIk+lqUrexwehrcOBuM98MDO3xvfqWE+CfpWQPRex4sBBsWMzieXjA
	7
X-Gm-Gg: ASbGncseO9V+7kjt7ygXFSMBA6aNmGUawn2iO9RqR2jju7T1C0AtPsN1euKeI+QDd6d
	E+JIBH36/fBPAEfsWAb7b0KA96DBYM0YAMYhp3bAvYdgy7YbvCAvtNE7ADLGI/IFcULShBhA7qK
	zgrXekEDLwdDBJWCBwXjBbefI0r7N6dSDw+ZHbgI+Nloy0B7mPH9tqlj0RmOlRcauWAToYSoYG/
	yyts4zIy0cAgti62JDkVN8rnBN1iAcNZbpInd4sMHy5uLfrbEbe4ZUwcJursCWY1Z45y9Vx7NzY
	1EPVKbFktIw7Ok7yGjOu4RG4dtxR4NnnE7JN0ubxRxKzO5NUJy7xytZ7gw==
X-Google-Smtp-Source: AGHT+IFJSivWE9HxeLEiVE+QiZGXG8QzUS2VqFdO5auKLYIsHhq4jw3PL5s5J4DC4SaIBehnDY63Fw==
X-Received: by 2002:a17:903:2f8c:b0:220:e9ac:e746 with SMTP id d9443c01a7336-22649cb45b7mr67889955ad.53.1742426747979;
        Wed, 19 Mar 2025 16:25:47 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c68a80e3sm121661665ad.83.2025.03.19.16.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 16:25:47 -0700 (PDT)
Message-ID: <a4830467-1096-4d62-a57c-33f6bc05423f@linaro.org>
Date: Wed, 19 Mar 2025 16:25:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/13] target/arm/cpu: define same set of registers for
 aarch32 and aarch64
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-11-pierrick.bouvier@linaro.org>
 <2b438e13-b377-4b4e-a4ff-0b219d7f3964@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <2b438e13-b377-4b4e-a4ff-0b219d7f3964@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/25 15:45, Richard Henderson wrote:
> On 3/17/25 21:51, Pierrick Bouvier wrote:
>> To eliminate TARGET_AARCH64, we need to make various definitions common
>> between 32 and 64 bit Arm targets.
>> Added registers are used only by aarch64 code, and the only impact is on
>> the size of CPUARMState, and added zarray
>> (ARMVectorReg zarray[ARM_MAX_VQ * 16]) member (+64KB)
>>
>> It could be eventually possible to allocate this array only for aarch64
>> emulation, but I'm not sure it's worth the hassle to save a few KB per
>> vcpu. Running qemu-system takes already several hundreds of MB of
>> (resident) memory, and qemu-user takes dozens of MB of (resident) memory
>> anyway.
>>
>> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/cpu.h | 6 ------
>>    1 file changed, 6 deletions(-)
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> 
> I think this could easily squash with ARM_MAX_VQ, since the
> rationale is better spelled out here.
> 

Yes, makes sense. I'll squash it.

> 
> r~


