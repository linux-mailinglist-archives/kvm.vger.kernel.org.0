Return-Path: <kvm+bounces-41454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEED3A67F8F
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 840013ADE8E
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271391F4C80;
	Tue, 18 Mar 2025 22:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QuThI8Q0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971951C5F3F
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742336208; cv=none; b=syyWyKPVWuiSS8UfhSWPz1+bIkJk8Fw4F/ilCrJjiu46qRY9hZbjmHTp2oPR1TmOaxXtpVAnyblKe3HyaoHr092MHUyXJELUPCdH7hHRjo6W/eunNkQ+O9pCClFGv0JvDQstQi1cLLP+2etdOk2ERcuuff63DsY0qJ2cWVrNdnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742336208; c=relaxed/simple;
	bh=bdacYQP1a+Vgd7gdIPXB6fDnHW4cG/Vs9y9YeiyRuO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fPgyEfNGFs0UWPAelOWnudXKeeZtTObTV54WEA4pv9FUVg4d/Oqa+CVJw+NY4i4QtBmET+Xcwzsa9mIWkgWouyukdgRzktkVbCSh99xemiwcic5DjazNnF2sJwvzE0nwUDulItFCS/AHdAtfM0yKnKfqbWk7SDSgqCCmH6y79lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QuThI8Q0; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ff65d88103so7732396a91.2
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742336206; x=1742941006; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rlhpsl5tgVQ8zMRpowh4yQuosLc3O2JMgDZISfiZ5hM=;
        b=QuThI8Q01mPxAKExcbZ/jSJtIeg+wjzthd6BvHh/yJR6ih6m4maeSawgzZ1XYQ3Q83
         SVH8oF8qSjD2jPGKf2Kdb6wifo6J7eQCw1sITRfvPVPWkMhjpseDV9e66wTK/jY3GSGk
         LcIQ5OLJVMdYn/X6DTmF82pgju8ZN2jgH2sQ5JHCFoLlYpQ3VtGYEhf2UKk+8HMhp1OT
         nBOkDqQPgcxcy+/g8QMs60hrkxOPWAQ7eaEUGRlVP26hexV13XziX9TmFZYjMZwEUn5u
         Gq+5k/3QzUiAk+hJQ5vhYtCRPVYx//9cKpKwlPmn3bZe49YSuBySh9PPFfEER+i/6DAN
         td9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742336206; x=1742941006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rlhpsl5tgVQ8zMRpowh4yQuosLc3O2JMgDZISfiZ5hM=;
        b=fDR5uMDbUhXmnAHDCWoCZYC0T/L88+E3BOJcnhh5D8NdIkDrECOZAGKSEqveoxf9tN
         EhIy1xfqK3KvOs442j96Zb8pI/ks0FITNJT4Np9Hv/pZLL3u6/JJS6cmviOPLIOdZjp5
         nxmQBJvdQy7qLDrSRUYgucsXjL35RhJsCm8X6q6yADDh9L0Gd4s45kW0BphM75bvG9HH
         sRn3EXF93+YedhA+D5hqbDySESOVx4hWkZd6oiF5gefu/0uvUFe3qCXGDA054/G7Jk2D
         uggUOba9TB2XlytrmlhHx//NguuCNpRADqrLdcA6vG+Y56e045zgcF7lGf9ognuq4J8H
         bg3g==
X-Forwarded-Encrypted: i=1; AJvYcCUkNWEKcoSlxhlewEFoLNVZiMhtU10lWoOYMn0SpaxAtilT5k8jZPK2gmsqKkJWRoWHz1I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxgtln0aRoJxIDGARPFVAiND74XU3CsziS+HbVc/3A2TC7N2l6
	sBwv6DTTfGpELvTYhv3F1GQHDLj47+m9XypTAmIWqU3MJX8p4Cd7MlOZMvHFQ1o=
X-Gm-Gg: ASbGncul/0udJOVrpU9Gq+ojNwPDIlarXOYkRS1wFZlKzopOsYy+HbhX/cBNpA0Z4GB
	LbAGo1taCuPP46EPRYwG5+J/k93wd4UZXFPb7w/UN2KuaeFl9smQtHiOnlGf6BmbK+E6fWVWEXu
	eBZbSDWjR3OIXffGZQfz4EMVr5/BgQnu4tVcTdRUNk5XcXpLJsYQ9PWzXVojWT0fmeSs8uejVd2
	3NmRdzy0/K5jq0lN/HhcMnjXOXcWTHxvBInRoLgHTD4Ya3lCqrQ+845l0I2the5Krav8FAIdqJ4
	Q5jhQ6ohrBtCJvEqXxAxTakzt51VbLi0RRVhxIQyvJ2jMBsHrvBLyVrsUw==
X-Google-Smtp-Source: AGHT+IF0Ndckq3b583mtKOlY3MX+DN60sgn8v5grOSR3pSkEnnl/CZ8U2ZVgWTXR0oI67omvJr7PSg==
X-Received: by 2002:a17:90b:4d05:b0:2ff:5ed8:83d0 with SMTP id 98e67ed59e1d1-301be08e808mr471081a91.16.1742336205845;
        Tue, 18 Mar 2025 15:16:45 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf61b34dsm10012a91.30.2025.03.18.15.16.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:16:45 -0700 (PDT)
Message-ID: <7202c9e9-1002-4cdc-9ce4-64785aac5de4@linaro.org>
Date: Tue, 18 Mar 2025 15:16:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/13] exec/cpu-all: allow to include specific cpu
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-5-pierrick.bouvier@linaro.org>
 <35c90e78-2c2c-4bbb-9996-4031c9eef08a@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <35c90e78-2c2c-4bbb-9996-4031c9eef08a@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/25 15:11, Richard Henderson wrote:
> On 3/17/25 21:51, Pierrick Bouvier wrote:
>> Including "cpu.h" from code that is not compiled per target is ambiguous
>> by definition. Thus we introduce a conditional include, to allow every
>> architecture to set this, to point to the correct definition.
>>
>> hw/X or target/X will now include directly "target/X/cpu.h", and
>> "target/X/cpu.h" will define CPU_INCLUDE to itself.
>> We already do this change for arm cpu as part of this commit.
>>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    include/exec/cpu-all.h | 4 ++++
>>    target/arm/cpu.h       | 2 ++
>>    2 files changed, 6 insertions(+)
>>
>> diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
>> index 7c6c47c43ed..1a756c0cfb3 100644
>> --- a/include/exec/cpu-all.h
>> +++ b/include/exec/cpu-all.h
>> @@ -46,7 +46,11 @@
>>    
>>    CPUArchState *cpu_copy(CPUArchState *env);
>>    
>> +#ifdef CPU_INCLUDE
>> +#include CPU_INCLUDE
>> +#else
>>    #include "cpu.h"
>> +#endif
>>    
>>    #ifdef CONFIG_USER_ONLY
>>    
>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>> index a8177c6c2e8..7aeb012428c 100644
>> --- a/target/arm/cpu.h
>> +++ b/target/arm/cpu.h
>> @@ -31,6 +31,8 @@
>>    #include "target/arm/multiprocessing.h"
>>    #include "target/arm/gtimer.h"
>>    
>> +#define CPU_INCLUDE "target/arm/cpu.h"
>> +
>>    #ifdef TARGET_AARCH64
>>    #define KVM_HAVE_MCE_INJECTION 1
>>    #endif
> 
> This doesn't make any sense to me.  CPU_INCLUDE is defined within the very file that
> you're trying to include by avoiding "cpu.h".
> 

Every target/X/cpu.h includes cpu-all.h, which includes "cpu.h" itself, 
relying on per target include path set by build system. Now we have 
common code, there is no "per target include path".

The other solutions are:
- build hw common libraries with per target include path, but I thought 
it was a good way to cleanup this, and not rely on this hidden 
dependency on the build system
- remove cpu.h inclusion from cpu-all.h, but it requires more 
modifications in other places.

I'm not sure which is the more desirable, compare to having this weird 
CPU_INCLUDE trick.

> 
> r~


