Return-Path: <kvm+bounces-2559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 096C77FB223
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:52:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96FA61F20CC8
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 06:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A6D12B68;
	Tue, 28 Nov 2023 06:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YakpO/x/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13540E1
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 22:52:31 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-332e42469f0so3276508f8f.1
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 22:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701154349; x=1701759149; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M3ZE7shiFCKoUO81T1KiXdBLdPBJ/Fr7IoSteLYqKeQ=;
        b=YakpO/x/Ks+JtH1NjbgZSoUGcF8mhCCWu/mfF/3YJWJdVHIB/kcUZjAiG1EOD7W6Pf
         pOzo4U+Zt3WcAgB85+HBBXKOU0TaWojgDTw4IvcoU37xJ+sr/2B0LbFJ+Tr6Qw7ujrDW
         OIxpN+Vj7dOGoznIzw1T67b2dG4nU8lXPe04XdOQLNAJP6QehIb/6SRHbg73kfQJuYhN
         Q7VjrtdnS5qNVCnazG+fx974R+8fpxsP3GPSHD6ce6JsxioYcG18wX6gZ9Vi4rIdWoXj
         Xz2il7kCCOHam5LYwySDE0trUBWC5rHt1cyDEymQ0pV+OgsmvTLqa2J7BFevf1Dsd/TW
         cd7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701154349; x=1701759149;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M3ZE7shiFCKoUO81T1KiXdBLdPBJ/Fr7IoSteLYqKeQ=;
        b=ExAqPVWX1/Tk8Hc2aKFoeZZblFif598Pj8dySaq8yGIPf2CCLs0pxZeJKQ25Hvwf2j
         7cuiQm03kyHL1SkEeIBE30jlSkVSSDKBB//Zy1HuipShnFFFm2Au8eKT7sjogqY8EdRC
         gKoXCRQa598rn1E/+uzqFp67K4dBkP9A2tMnIqXlGC2OqQkgBLDn8tg3U7gRslwQzedQ
         2Q/Ou2+9RoCLCp2PyEA3uza7VX8tEequYqHPcq95A6VG5KXZ3eH907OZnXknt1S0CpcH
         L1KIG17aKWSMQpKoLFOkyK7MhharMTyU8/o2MTSBQaVyCmmSfiWnJCMCbRvcm8ZFm5A4
         mKVQ==
X-Gm-Message-State: AOJu0YwZ1w9siOHUy6e2znyjWUnvXMrZ9oZtjAaO+mUCuKx9wzxTd5Jj
	bAVrZM80CBZrXCjm+Q9kQV8e/w==
X-Google-Smtp-Source: AGHT+IGuBI5Ir68gSS9m/agiw7rdbLSrem/4hA3OK9LF7GGhl3jZpLVFyloG3UPXARlKPc7xheDh0g==
X-Received: by 2002:a5d:488f:0:b0:333:19b:d317 with SMTP id g15-20020a5d488f000000b00333019bd317mr3255424wrq.52.1701154349359;
        Mon, 27 Nov 2023 22:52:29 -0800 (PST)
Received: from [192.168.69.100] (crb44-h02-176-184-13-61.dsl.sta.abo.bbox.fr. [176.184.13.61])
        by smtp.gmail.com with ESMTPSA id w27-20020adf8bdb000000b00332e5624a31sm13406545wra.84.2023.11.27.22.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Nov 2023 22:52:29 -0800 (PST)
Message-ID: <49b491fa-0aa7-43d7-9bb7-ffd9a5172191@linaro.org>
Date: Tue, 28 Nov 2023 07:52:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 05/16] target/arm/kvm: Have kvm_arm_sve_get_vls
 take a ARMCPU argument
Content-Language: en-US
To: Gavin Shan <gshan@redhat.com>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-6-philmd@linaro.org>
 <54a38178-18ca-4bea-9d5d-af34114dda5b@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <54a38178-18ca-4bea-9d5d-af34114dda5b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 27/11/23 05:12, Gavin Shan wrote:
> Hi Phil,
> 
> On 11/24/23 05:35, Philippe Mathieu-Daudé wrote:
>> Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
>> take a ARMCPU* argument. Use the CPU() QOM cast macro When
>> calling the generic vCPU API from "sysemu/kvm.h".
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   target/arm/kvm_arm.h | 6 +++---
>>   target/arm/cpu64.c   | 2 +-
>>   target/arm/kvm.c     | 2 +-
>>   3 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
>> index 6fb8a5f67e..84f87f5ed7 100644
>> --- a/target/arm/kvm_arm.h
>> +++ b/target/arm/kvm_arm.h
>> @@ -129,13 +129,13 @@ void kvm_arm_destroy_scratch_host_vcpu(int 
>> *fdarray);
>>   /**
>>    * kvm_arm_sve_get_vls:
>> - * @cs: CPUState
>> + * @cpu: ARMCPU
>>    *
>>    * Get all the SVE vector lengths supported by the KVM host, setting
>>    * the bits corresponding to their length in quadwords minus one
>>    * (vq - 1) up to ARM_MAX_VQ.  Return the resulting map.
>>    */
>> -uint32_t kvm_arm_sve_get_vls(CPUState *cs);
>> +uint32_t kvm_arm_sve_get_vls(ARMCPU *cpu);
> 
> Either @cs or @cpu isn't dereferenced in kvm_arm_sve_get_vls(). So I guess
> the argument can be simply droped?

If KVM eventually supports heterogeneous vCPUs such big.LITTLE, we'd
de-reference. But then we'd have a major rework of the code.

Peter, do you have a preference?

Thanks,

Phil.

