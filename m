Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93FA61434B
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 03:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiKAChW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 22:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiKAChU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 22:37:20 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6855D1788C
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 19:37:19 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N1YvT3r63zVhqn;
        Tue,  1 Nov 2022 10:32:21 +0800 (CST)
Received: from [10.67.110.176] (10.67.110.176) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 10:37:16 +0800
Subject: Re: [PATCH] KVM: x86: fix undefined behavior in bit shift for
 __feature_bit
To:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>, <peterz@infradead.org>
CC:     <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <kvm@vger.kernel.org>
References: <20221031113638.4182263-1-cuigaosheng1@huawei.com>
 <Y2AJIFQlF5C0ozoU@google.com>
 <D6AA5A76-46F0-48BA-85B3-C6FD7B1E2A14@zytor.com>
From:   cuigaosheng <cuigaosheng1@huawei.com>
Message-ID: <82698836-a00e-5bfc-a0e1-a094505817ef@huawei.com>
Date:   Tue, 1 Nov 2022 10:37:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <D6AA5A76-46F0-48BA-85B3-C6FD7B1E2A14@zytor.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.176]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for taking time to review the patch!

> PeterZ is contending that this isn't actually undefined behavior given how the
> kernel is compiled[*].  That said, I would be in favor of replacing the open-coded
> shift with BIT() to make the code a bit more self-documenting, and that would
> naturally fix this maybe-undefined-behavior issue.
>
> [*]https://lore.kernel.org/all/Y1%2FAaJOcgIc%2FINtv@hirez.programming.kicks-ass.net

I have made a patch v2 and submitted it, replacing the open-coded shift with BIT().

> One really ought to change the input to unsigned, though, and I would argue >> 5 would be more idiomatic than / 32; / goes with % whereas >> goes with &; a mishmash is just ugly AF.
> .

I have changed the input to unsigned in patch v2, and replaced "/ 32" with "argue >> 5".

On 2022/11/1 4:27, H. Peter Anvin wrote:
> On October 31, 2022 10:42:56 AM PDT, Sean Christopherson <seanjc@google.com> wrote:
>> On Mon, Oct 31, 2022, Gaosheng Cui wrote:
>>> Shifting signed 32-bit value by 31 bits is undefined, so changing
>>> significant bit to unsigned. The UBSAN warning calltrace like below:
>>>
>>> UBSAN: shift-out-of-bounds in arch/x86/kvm/reverse_cpuid.h:101:11
>>> left shift of 1 by 31 places cannot be represented in type 'int'
>> PeterZ is contending that this isn't actually undefined behavior given how the
>> kernel is compiled[*].  That said, I would be in favor of replacing the open-coded
>> shift with BIT() to make the code a bit more self-documenting, and that would
>> naturally fix this maybe-undefined-behavior issue.
>>
>> [*] https://lore.kernel.org/all/Y1%2FAaJOcgIc%2FINtv@hirez.programming.kicks-ass.net
>>
>>> ---
>>>   arch/x86/kvm/reverse_cpuid.h | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
>>> index a19d473d0184..ebd6b621d3b8 100644
>>> --- a/arch/x86/kvm/reverse_cpuid.h
>>> +++ b/arch/x86/kvm/reverse_cpuid.h
>>> @@ -98,7 +98,7 @@ static __always_inline u32 __feature_bit(int x86_feature)
>>>   	x86_feature = __feature_translate(x86_feature);
>>>   
>>>   	reverse_cpuid_check(x86_feature / 32);
>>> -	return 1 << (x86_feature & 31);
>>> +	return 1U << (x86_feature & 31);
>>>   }
>>>   
>>>   #define feature_bit(name)  __feature_bit(X86_FEATURE_##name)
>>> -- 
>>> 2.25.1
>>>
> One really ought to change the input to unsigned, though, and I would argue >> 5 would be more idiomatic than / 32; / goes with % whereas >> goes with &; a mishmash is just ugly AF.
> .
