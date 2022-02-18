Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DF34BBE40
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 18:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238484AbiBRRUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 12:20:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238443AbiBRRUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 12:20:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C53392B5B8D
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645204822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NgDqx8HSqCkXZKNu7vuKVqOOrMrgIVsFIgF5vX7lT30=;
        b=J4YHQRY8wVHEYh1lNEQLvrEWITKvSey03uZkxthaNJbjgHZ0d105onLmIFyq4t6Cb9XZMs
        B/CxU9sIs0RbXjcB1tIyhtyeNGKavftA72nh2lzeS0YicAY7Vua3ACrik+G1oPGw1lIyR6
        bdbTHQPbx/2Ha+mf5NVOtMKJbEqQTek=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-1IIQtYzIO06nHM2QjQ4vmg-1; Fri, 18 Feb 2022 12:20:21 -0500
X-MC-Unique: 1IIQtYzIO06nHM2QjQ4vmg-1
Received: by mail-ej1-f69.google.com with SMTP id r18-20020a17090609d200b006a6e943d09eso3344756eje.20
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:20:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NgDqx8HSqCkXZKNu7vuKVqOOrMrgIVsFIgF5vX7lT30=;
        b=CWzFfeULnTDUp6IWF2jAEQaEdSOnCcqTE42Tcg9qICTrTnqy/7k3hJb11Pl7Ddcg80
         OHRahEqKfoBoq/ZDNJP5OYSiVunJV6aUWH/RXgn7LZrvB8sBzAZKmol70xRXLEAePbaa
         AsvUl7GQh8mRdFxfw16VbK9y83OuRNW44lz9EYzqWdDdP9NNMEN0INHl8AwgoO7p1UF/
         J6sUMUB3GqkAMRCNQP6bED2Hx0JR8KdW/icXMFmDLZI16u5M1o1U1uveDe/bVGTQ86aE
         PJhg4VYDPMUBygF4Qfw4F/jErRqjc95W7wN9JKvGVcxjaZAw3ICNyNt0jJ/VquQZfGiU
         C8fA==
X-Gm-Message-State: AOAM532bc/wGi2R6JYxNRa0yqqcv7jlUPd7Zqbgw9Ng5vDNyJSeyR2bd
        PW4ng02RcFHSdbYdYJyhvnbdGGXKS76sBUZGLYUirXBUZEHcv7essM655TWMWE8IfY1Fi9ekumC
        3FCKNkSKiptMx
X-Received: by 2002:a17:906:27db:b0:6cf:69cb:505b with SMTP id k27-20020a17090627db00b006cf69cb505bmr7267515ejc.481.1645204819726;
        Fri, 18 Feb 2022 09:20:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJ36aQL0l5tavfqy6yy1q3Uovk2dBAsmZ84rUawH7dFx9yLTPPdhpoohSi1qhMwI9Ry39arw==
X-Received: by 2002:a17:906:27db:b0:6cf:69cb:505b with SMTP id k27-20020a17090627db00b006cf69cb505bmr7267503ejc.481.1645204819491;
        Fri, 18 Feb 2022 09:20:19 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id j8sm5312944edw.40.2022.02.18.09.20.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 09:20:18 -0800 (PST)
Message-ID: <8f99a6a2-b64e-0211-a7d3-8b84c668a92f@redhat.com>
Date:   Fri, 18 Feb 2022 18:20:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 6/6] KVM: x86: allow defining return-0 static calls
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220217180831.288210-1-pbonzini@redhat.com>
 <20220217180831.288210-7-pbonzini@redhat.com> <Yg/JZZ+i67HDKCVK@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yg/JZZ+i67HDKCVK@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/22 17:29, Sean Christopherson wrote:
> On Thu, Feb 17, 2022, Paolo Bonzini wrote:
>> A few vendor callbacks are only used by VMX, but they return an integer
>> or bool value.  Introduce KVM_X86_OP_OPTIONAL_RET0 for them: if a func is
>> NULL in struct kvm_x86_ops, it will be changed to __static_call_return0
>> when updating static calls.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/include/asm/kvm-x86-ops.h | 15 +++++++++------
>>   arch/x86/include/asm/kvm_host.h    |  4 ++++
>>   arch/x86/kvm/svm/avic.c            |  5 -----
>>   arch/x86/kvm/svm/svm.c             | 20 --------------------
>>   arch/x86/kvm/x86.c                 |  2 +-
>>   kernel/static_call.c               |  1 +
>>   6 files changed, 15 insertions(+), 32 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>> index c0ec066a8599..29affccb353c 100644
>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>> @@ -10,7 +10,9 @@ BUILD_BUG_ON(1)
>>    *
>>    * KVM_X86_OP_OPTIONAL() can be used for those functions that can have
>>    * a NULL definition, for example if "static_call_cond()" will be used
>> - * at the call sites.
>> + * at the call sites.  KVM_X86_OP_OPTIONAL_RET0() can be used likewise
>> + * to make a definition optional, but in this case the default will
>> + * be __static_call_return0.
> 
> __static_call_return0()
> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index ab1c4778824a..d3da64106685 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -131,6 +131,7 @@ struct kvm_x86_ops kvm_x86_ops __read_mostly;
>>   	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
>>   				*(((struct kvm_x86_ops *)0)->func));
>>   #define KVM_X86_OP_OPTIONAL KVM_X86_OP
>> +#define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
>>   #include <asm/kvm-x86-ops.h>
>>   EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
>>   EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
>> @@ -12016,7 +12017,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>>   static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
>>   {
>>   	return (is_guest_mode(vcpu) &&
>> -			kvm_x86_ops.guest_apic_has_interrupt &&
>>   			static_call(kvm_x86_guest_apic_has_interrupt)(vcpu));
> 
> Can you opportunistically align the indentation and drop the outer parantheses? I.e.
> 
> 	return is_guest_mode(vcpu) &&
> 	       static_call(kvm_x86_guest_apic_has_interrupt)(vcpu);

Hmm, I like having the parentheses (despite "return not being a 
function") because editors are inconsistent in what indentation to use 
after return.

Some use a tab (which does the right thing just by chance with Linux 
because "return " is as long as a tab is wide), but vim for example does 
the totally awkward

int f()
{
         return a &&
                 b;
}

Of course I can fix the indentation.

Paolo

>>   }
>>   
>> diff --git a/kernel/static_call.c b/kernel/static_call.c
>> index 43ba0b1e0edb..76abd46fe6ee 100644
>> --- a/kernel/static_call.c
>> +++ b/kernel/static_call.c
>> @@ -503,6 +503,7 @@ long __static_call_return0(void)
>>   {
>>   	return 0;
>>   }
>> +EXPORT_SYMBOL_GPL(__static_call_return0)
> 
> This doesn't compile, it needs a semicolon.
> 

