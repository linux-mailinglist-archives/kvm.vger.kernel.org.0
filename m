Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E86061FB92
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 18:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbiKGRhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 12:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbiKGRhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 12:37:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A62821E35
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 09:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667842588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nl6PigmsrqrYF158XeHabBGrVbZA9yih4rZ/4bxbZV8=;
        b=GwOsgeovYwAgFKX+0tBxAlyP3AM0st5QDs4ztMjkR8nUBHgTS4iyx4/295UyJodsylpO59
        yGUa+IUdaVBcly8k8NysHerIPSK2aGJu/FuD0szx6Wi1r70IY3g4yebdzCwQtD8lmkisGW
        v6iNfO0IeHrk977cnss6gPWV83jqikU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-218-qaYRrKASMK2sLcFML0om5g-1; Mon, 07 Nov 2022 12:36:24 -0500
X-MC-Unique: qaYRrKASMK2sLcFML0om5g-1
Received: by mail-wr1-f70.google.com with SMTP id i14-20020adfa50e000000b0023652707418so3064895wrb.20
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 09:36:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nl6PigmsrqrYF158XeHabBGrVbZA9yih4rZ/4bxbZV8=;
        b=kbQy/Qb1DB7T4sABC/c2sEqVdxbCqa2IXOjBJkCA4fPpNIAEPRwXvWVNj+zAAwq5/g
         6qAW/1Nn0hRa8+q+hrOfJ3P3KeoWJUpd/my8quGjhIgVcvtAstSsMVDy8wtv6/ZB7H0F
         juIz1mw3SjlKpquvkuj9LUWQRWqvsp2w2k5OjipP4tt1c4F0iLa48+ZKW6K1mf+IAFG8
         qoK6kcKh+G9EyItrwfihdTFt0LLegVQmjFsH0ST0ItiCxjGiST96ikGulrabf+XN+Rev
         UGpwKcyYoISrYHvtq/Bi2U/Jp9JgK3ZIxbVHjuF3cd12dEpYhfP7pqKKpuPUEIdTCGZ2
         kRWw==
X-Gm-Message-State: ACrzQf1rkNgbP4c2rNLPNXMjI3azBhVSsDTWyqjA9b8z5Yqx1twl7M7+
        66VlJ87aMlpVvGq7PubKEoftUaDincTyZ+4Znj63/9V8ZOT9AE//fP1ajowfw7WbQFBBUlWBtiD
        JsxwUfuqadpLD
X-Received: by 2002:adf:f781:0:b0:236:5559:215b with SMTP id q1-20020adff781000000b002365559215bmr32866503wrp.16.1667842583166;
        Mon, 07 Nov 2022 09:36:23 -0800 (PST)
X-Google-Smtp-Source: AMsMyM77Pa61NR6xu9Ntx+EjzyzNbGvCxuDdApim1+QETi5e/cbTSUAqTgB4iFEEHhowEcbV94Bu0g==
X-Received: by 2002:adf:f781:0:b0:236:5559:215b with SMTP id q1-20020adff781000000b002365559215bmr32866485wrp.16.1667842582852;
        Mon, 07 Nov 2022 09:36:22 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id k28-20020a5d525c000000b0022e653f5abbsm7758610wrc.69.2022.11.07.09.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 09:36:22 -0800 (PST)
Message-ID: <3ca5e8b6-c786-2f15-8f81-fd6353c43692@redhat.com>
Date:   Mon, 7 Nov 2022 18:36:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, stable@vger.kernel.org
References: <20221107145436.276079-1-pbonzini@redhat.com>
 <20221107145436.276079-2-pbonzini@redhat.com> <Y2k7o8i/qhBm9bpC@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/8] KVM: SVM: extract VMCB accessors to a new file
In-Reply-To: <Y2k7o8i/qhBm9bpC@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/7/22 18:08, Sean Christopherson wrote:
> On Mon, Nov 07, 2022, Paolo Bonzini wrote:
>> Having inline functions confuses the compilation of asm-offsets.c,
>> which cannot find kvm_cache_regs.h because arch/x86/kvm is not in
>> asm-offset.c's include path.  Just extract the functions to a
>> new file.
>>
>> No functional change intended.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: f14eec0a3203 ("KVM: SVM: move more vmentry code to assembly")
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/svm/avic.c         |   1 +
>>   arch/x86/kvm/svm/nested.c       |   1 +
>>   arch/x86/kvm/svm/sev.c          |   1 +
>>   arch/x86/kvm/svm/svm.c          |   1 +
>>   arch/x86/kvm/svm/svm.h          | 200 ------------------------------
>>   arch/x86/kvm/svm/svm_onhyperv.c |   1 +
>>   arch/x86/kvm/svm/vmcb.h         | 211 ++++++++++++++++++++++++++++++++
> 
> I don't think vmcb.h is a good name.  The logical inclusion sequence would be for
> svm.h to include vmcb.h, e.g. SVM requires knowledge about VMCBs, but this requires
> vmcb.h to include svm.h to dereference "struct vcpu_svm".
> Unlike VMX's vmcs.h, the new file isn't a "pure" VMCB helper, it also holds a
> decent amount of KVM's SVM logic.

Yes, it's basically the wrappers that KVM uses to access the VMCB fields.

> What about making KVM self-sufficient?

You mean having a different asm-offsets.h file just for arch/x86/kvm/?

> The includes in asm-offsets.c are quite ugly
> 
>   #include "../kvm/vmx/vmx.h"
>   #include "../kvm/svm/svm.h"
> 
> or as a stopgap to make backporting easier, just include kvm_cache_regs.h?

The problem is that the _existing_ include of kvm_cache_regs.h in svm.h 
fails, with

arch/x86/kernel/../kvm/svm/svm.h:25:10: fatal error: kvm_cache_regs.h: 
No such file or directory
    25 | #include "kvm_cache_regs.h"
       |          ^~~~~~~~~~~~~~~~~~
compilation terminated.

The other two solutions here are:

1) move kvm_cache_regs.h to arch/x86/include/asm/ so it can be included 
normally

2) extract the structs to arch/x86/kvm/svm/svm_types.h and include that 
from asm-offsets.h, basically the opposite of this patch.

(2) is my preference if having a different asm-offsets.h file turns out 
to be too complex.  We can do the same for VMX as well.

Paolo

>>   void svm_leave_nested(struct kvm_vcpu *vcpu);
>> diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
>> index 8cdc62c74a96..ae0a101329e6 100644
>> --- a/arch/x86/kvm/svm/svm_onhyperv.c
>> +++ b/arch/x86/kvm/svm/svm_onhyperv.c
>> @@ -8,6 +8,7 @@
>>   #include <asm/mshyperv.h>
>>   
>>   #include "svm.h"
>> +#include "vmcb.h"
>>   #include "svm_ops.h"
>>   
>>   #include "hyperv.h"
>> diff --git a/arch/x86/kvm/svm/vmcb.h b/arch/x86/kvm/svm/vmcb.h
>> new file mode 100644
>> index 000000000000..8757cda27e3a
>> --- /dev/null
>> +++ b/arch/x86/kvm/svm/vmcb.h
>> @@ -0,0 +1,211 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Kernel-based Virtual Machine driver for Linux
>> + *
>> + * AMD SVM support - VMCB accessors
>> + */
>> +
>> +#ifndef __SVM_VMCB_H
>> +#define __SVM_VMCB_H
>> +
>> +#include "kvm_cache_regs.h"
> 
> This should include "svm.h" instead of relying on the parent to include said file.
> 

