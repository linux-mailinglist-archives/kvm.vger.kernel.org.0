Return-Path: <kvm+bounces-2560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F322C7FB227
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:53:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 302C81C20B10
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 06:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC971078C;
	Tue, 28 Nov 2023 06:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G/iR0u3l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB67197
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 22:52:58 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-332d2b6a84cso3462276f8f.0
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 22:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701154377; x=1701759177; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oUmo3C1pLShDouWu+ZeJVsUjFrpOVE+VE0tTre6Q9A4=;
        b=G/iR0u3lPL43blC73yq0uRwhImhnNW6DUn+Yhho3vz7uauvhZbISXfqHN/SYVKETh6
         cyZi3gPj6hSqgEUncRuigmqcty4locE37y1EbSPsbgevSO4rqOnFr7NBJb617w2MF1kc
         4DkKRVqzH5968DuAV7yDOTppUbJ8cq9T7jG8xYe9QLUt3eshVszYwiAulnfRs1TJL9wb
         u/9b1/GaEYJIW+F8J9/IvPXPF8e+758V+PSzYXZynCI25mEijBfwlVmvEioCv8FLv2tj
         cMz2b/pM8aPpaA7L+oWc1RP+DJmKSf6wBVR1PWDkYTD/ekbULAPXy8dSYpFTb3AtTICs
         A7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701154377; x=1701759177;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oUmo3C1pLShDouWu+ZeJVsUjFrpOVE+VE0tTre6Q9A4=;
        b=lfz6W9zQREFCFb8eaV+xp4PGhh67ZZA5ecwApGAyiy7qZdUc5ru00DN+ujiKT318yf
         GHDVFLs28SWQ1KpaVTyFuI2ywl7+DZ5XB6YoTDdVjgF8ljn7i5QIbJp1Zlz1wtIKzTkp
         XFYH3Pf62UHvBDUIfjyAaOCuH38fLGtuMdPaetfOkgdPGQkicr/ddD0ohU2zoXgQsN5P
         ViKXskoQOpO7VNUleV9qmlYeyDlAUD7CDjiMmodBCXm/r21sXz0Eu3arp6+TP6rwq/g5
         8osU+e1+goGyhEnsQLNrUpkZD2v3g+KXbeEIXvxTiwna6ARiqjotN0cTNxAlSON4kG08
         eKow==
X-Gm-Message-State: AOJu0Yz5khjEtgis3SM9PwD0BpttX9q7Fvp4gJmVa8ktVddvrsU5bljG
	o/3+RtW/n366e/bGY6ZNvqjrlA==
X-Google-Smtp-Source: AGHT+IGfQuAgYK0TAY1xVNqwWVacxP9S+uY59Sn5TG1o51U03XtkUUwTK9OX8cVZn/CaXFY34k6bAg==
X-Received: by 2002:a5d:5273:0:b0:331:6ad3:857 with SMTP id l19-20020a5d5273000000b003316ad30857mr9979882wrc.16.1701154377150;
        Mon, 27 Nov 2023 22:52:57 -0800 (PST)
Received: from [192.168.69.100] (crb44-h02-176-184-13-61.dsl.sta.abo.bbox.fr. [176.184.13.61])
        by smtp.gmail.com with ESMTPSA id w27-20020adf8bdb000000b00332e5624a31sm13406545wra.84.2023.11.27.22.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Nov 2023 22:52:56 -0800 (PST)
Message-ID: <4a04694e-f376-406f-84cb-f677ded08988@linaro.org>
Date: Tue, 28 Nov 2023 07:52:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 03/16] target/arm/kvm: Have
 kvm_arm_add_vcpu_properties take a ARMCPU argument
Content-Language: en-US
To: Gavin Shan <gshan@redhat.com>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-4-philmd@linaro.org>
 <52cf8040-b134-4dc6-b6ce-1d51a3dc13ef@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <52cf8040-b134-4dc6-b6ce-1d51a3dc13ef@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27/11/23 05:05, Gavin Shan wrote:
> Hi Phil,
> 
> On 11/24/23 05:35, Philippe Mathieu-Daudé wrote:
>> Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
>> take a ARMCPU* argument. Use the CPU() QOM cast macro When
>> calling the generic vCPU API from "sysemu/kvm.h".
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   target/arm/kvm_arm.h | 4 ++--
>>   target/arm/cpu.c     | 2 +-
>>   target/arm/kvm.c     | 4 ++--
>>   3 files changed, 5 insertions(+), 5 deletions(-)
>>
> 
> With the following comments resolved:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
>> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
>> index 50967f4ae9..6fb8a5f67e 100644
>> --- a/target/arm/kvm_arm.h
>> +++ b/target/arm/kvm_arm.h
>> @@ -153,7 +153,7 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
>>    * Add all KVM specific CPU properties to the CPU object. These
>>    * are the CPU properties with "kvm-" prefixed names.
>>    */
>> -void kvm_arm_add_vcpu_properties(Object *obj);
>> +void kvm_arm_add_vcpu_properties(ARMCPU *cpu);
> 
> The function's description needs to be modified since @obj has been
> renamed to @cpu?
> 
>    /**
>     * kvm_arm_add_vcpu_properties:
>     * @obj: The CPU object to add the properties to
>     *
>     */

Oops thanks!

