Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3B1447CCB
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 10:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbhKHJeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 04:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238412AbhKHJeK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 04:34:10 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15ACC061570;
        Mon,  8 Nov 2021 01:31:26 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id h24so6609277pjq.2;
        Mon, 08 Nov 2021 01:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=adDa5h3AaZvOICmGzWHmxNTfBxDHKc1QQGmCAWfLQz0=;
        b=AYQzb/j2hXLC0ljr/2QBm5BODYYx744YNCZCbCujYZdFfKAxhM7esBWSzQLJcyVxus
         1UkK5hvGLq7n5k/+M/OlBuKIc9Dp2SBtS0KFHtu7/cYFk8Gz1mo0w/DK9AWJWarH6PPU
         MaEq7jRGwur80zLgrM+xFRCRTqdqxdqqZOFqbjxkMCPQ4v8pHeU07JIPdcbqQUqymEip
         jujtKU2knYNCy+gJEHjD0FcIVHM2mI2gVNgbk8SBIR0TbM4NdAtyLguVrTdEBjp/n0Qz
         uggrTielswhBs7wqQvFH1hDpFABTAw1o6A2eSmp3M4ZfvNSkVzYdsR6Jrt2mL75JqqSm
         7ifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=adDa5h3AaZvOICmGzWHmxNTfBxDHKc1QQGmCAWfLQz0=;
        b=jpY8Ce9nyoJvkauOcreTlahF/2t86EY411WsKoxZyk4yPqlrHH/FfrznL3VfzHBDzQ
         FPEf/slrJEe19/5gHSWMo7hTYVr9O5EnaCK0kmHT/JqtLXgnmFMHMmcDXgtsZ6Ptvz2z
         xlCVkN75Ff+sZUXjoLGNGaOrYZLPR5vkf1vb0Mgy1Ni6w8rNEC2BRljeR6n6FkN4bs1m
         aw35oMTeoSZ/YvoufyG2imXAHOcFkAASqShQq+218vkZTlUca/Pz6GoRiNYwVBDTUIcx
         VF5CCfnAe2BfGFsFRLpsgTCSy27M7vDogmGwG6AbTD8eiVIEE8X89Q/HtFJ/8XY25k4N
         UlUg==
X-Gm-Message-State: AOAM532QrHqAuYK3fV9RjQFIm0yC/FiKlPq3CjqbbOmD37bGVoWGXxkj
        OhoA7rmv4zr4qzWSJvsEkk8=
X-Google-Smtp-Source: ABdhPJwUvFbbYj+5x6JbmGs2Dr3l7CqvvRPpxTiHQVqyfLmCaitVYQSthgXnFaPQf/c2ol8Wd8Q/fA==
X-Received: by 2002:a17:902:ea10:b0:142:112d:c0b9 with SMTP id s16-20020a170902ea1000b00142112dc0b9mr39440606plg.35.1636363886414;
        Mon, 08 Nov 2021 01:31:26 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v12sm12587352pjs.0.2021.11.08.01.31.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 01:31:26 -0800 (PST)
Message-ID: <47734f2c-5588-1c22-ddcf-c486ceab0d34@gmail.com>
Date:   Mon, 8 Nov 2021 17:31:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 2/3] KVM: x86: Introduce definitions to support static
 calls for kvm_pmu_ops
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211103070310.43380-1-likexu@tencent.com>
 <20211103070310.43380-3-likexu@tencent.com> <YYVSW4Jr75oJ6MhC@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <YYVSW4Jr75oJ6MhC@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/11/2021 11:48 pm, Sean Christopherson wrote:
> On Wed, Nov 03, 2021, Like Xu wrote:
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 0db1887137d9..b6f08c719125 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -50,6 +50,13 @@
>>   struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
>>   EXPORT_SYMBOL_GPL(kvm_pmu_ops);
>>   
>> +#define	KVM_X86_PMU_OP(func)	\
>> +	DEFINE_STATIC_CALL_NULL(kvm_x86_pmu_##func,	\
>> +				*(((struct kvm_pmu_ops *)0)->func))
>> +#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP
> 
> More of a question for the existing code, what's the point of KVM_X86_OP_NULL?

The comment says:

  * KVM_X86_OP_NULL() can leave a NULL definition for the
  * case where there is no definition or a function name that
  * doesn't match the typical naming convention is supplied.

Does it help ?

> AFAICT, it always resolves to KVM_X86_OP.  Unless there's some magic I'm missing,
> I vote we remove KVM_X86_OP_NULL and then not introduce KVM_X86_PMU_OP_NULL.
> And I'm pretty sure it's useless, e.g. get_cs_db_l_bits is defined with the NULL

This transitions will not be included in the next version. Open to you.

> variant, but it's never NULL and its calls aren't guarded with anything.  And if
> KVM_X86_OP_NULL is intended to aid in documenting behavior, it's doing a pretty
> miserable job of that :-)
> 
>> +#include <asm/kvm-x86-pmu-ops.h>
>> +EXPORT_STATIC_CALL_GPL(kvm_x86_pmu_is_valid_msr);
> 
> I'll double down on my nVMX suggestion so that this export can be avoided.

Fine to me.

> 
>>   static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
>>   {
>>   	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index b2fe135d395a..e5550d4acf14 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -3,6 +3,8 @@
>>   #define __KVM_X86_PMU_H
>>   
>>   #include <linux/nospec.h>
>> +#include <linux/static_call_types.h>
>> +#include <linux/static_call.h>
>>   
>>   #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
>>   #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
>> @@ -45,6 +47,19 @@ struct kvm_pmu_ops {
>>   	void (*cleanup)(struct kvm_vcpu *vcpu);
>>   };
>>   
>> +#define	KVM_X86_PMU_OP(func)	\
>> +	DECLARE_STATIC_CALL(kvm_x86_pmu_##func, *(((struct kvm_pmu_ops *)0)->func))
>> +#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP
>> +#include <asm/kvm-x86-pmu-ops.h>
>> +
>> +static inline void kvm_pmu_ops_static_call_update(void)
>> +{
>> +#define	KVM_X86_PMU_OP(func)	\
>> +	static_call_update(kvm_x86_pmu_##func, kvm_pmu_ops.func)
>> +#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP
>> +#include <asm/kvm-x86-pmu-ops.h>
>> +}
> 
> As alluded to in patch 01, I'd prefer these go in kvm_ops_static_call_update()
> to keep the static call magic somewhat contained.

Thank and applied.

> 
>> +
>>   static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
>>   {
>>   	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>> -- 
>> 2.33.0
>>
> 
