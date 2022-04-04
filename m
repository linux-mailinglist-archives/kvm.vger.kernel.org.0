Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E424B4F1B96
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380329AbiDDVVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380379AbiDDTxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 15:53:06 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC18559A;
        Mon,  4 Apr 2022 12:51:08 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nbSj5-0003Uu-05; Mon, 04 Apr 2022 21:50:59 +0200
Message-ID: <53a9ac0a-fce5-69a0-41e5-9a1a2dab9317@maciej.szmigiero.name>
Date:   Mon, 4 Apr 2022 21:50:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-6-seanjc@google.com>
 <a47217da0b6db4f1b6b6c69a9dc38350b13ac17c.camel@redhat.com>
 <YkshgrUaF4+MrrXf@google.com>
 <a3cf781b-0b1a-0bba-6b37-12666c7fc154@maciej.szmigiero.name>
 <YktIGHM86jHkzGdF@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 5/8] KVM: SVM: Re-inject INT3/INTO instead of retrying the
 instruction
In-Reply-To: <YktIGHM86jHkzGdF@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4.04.2022 21:33, Sean Christopherson wrote:
> On Mon, Apr 04, 2022, Maciej S. Szmigiero wrote:
>>>>> index 47e7427d0395..a770a1c7ddd2 100644
>>>>> --- a/arch/x86/kvm/svm/svm.h
>>>>> +++ b/arch/x86/kvm/svm/svm.h
>>>>> @@ -230,8 +230,8 @@ struct vcpu_svm {
>>>>>    	bool nmi_singlestep;
>>>>>    	u64 nmi_singlestep_guest_rflags;
>>>>> -	unsigned int3_injected;
>>>>> -	unsigned long int3_rip;
>>>>> +	unsigned soft_int_injected;
>>>>> +	unsigned long soft_int_linear_rip;
>>>>>    	/* optional nested SVM features that are enabled for this guest  */
>>>>>    	bool nrips_enabled                : 1;
>>>>
>>>>
>>>> I mostly agree with this patch, but think that it doesn't address the
>>>> original issue that Maciej wanted to address:
>>>>
>>>> Suppose that there is *no* instruction in L2 code which caused the software
>>>> exception, but rather L1 set arbitrary next_rip, and set EVENTINJ to software
>>>> exception with some vector, and that injection got interrupted.
>>>>
>>>> I don't think that this code will support this.
>>>
>>> Argh, you're right.  Maciej's selftest injects without an instruction, but it doesn't
>>> configure the scenario where that injection fails due to an exception+VM-Exit that
>>> isn't intercepted by L1 and is handled by L0.  The event_inj test gets the coverage
>>> for the latter, but always has a backing instruction.
>>
>> Still reviewing the whole patch set, but want to clear this point quickly:
>> The selftest does have an implicit intervening NPF (handled by L0) while
>> injecting the first L1 -> L2 event.
> 
> I'll do some debug to figure out why the test passes for me.  I'm guessing I either
> got lucky, e.g. IDT was faulted in already, or I screwed up and the test doesn't
> actually pass.

Try applying Maxim's proposed change to this test (adding two additional ud2s at the
start of L2 guest code and adjusting just the next_rip field accordingly).

We might have been lucky in the patched KVM code and have next_rip = rip at this
re-injection case now (the next_rip field was zero in the original KVM code).

Thanks,
Maciej
