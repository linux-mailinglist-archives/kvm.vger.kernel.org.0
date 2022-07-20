Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9602E57BB17
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 18:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiGTQId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 12:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGTQIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 12:08:31 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191F33FA28;
        Wed, 20 Jul 2022 09:08:26 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1oECEy-0003q2-KT; Wed, 20 Jul 2022 18:08:00 +0200
Message-ID: <d311c92a-d753-3584-d662-7d82b2fc1e50@maciej.szmigiero.name>
Date:   Wed, 20 Jul 2022 18:07:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <4caa0f67589ae3c22c311ee0e6139496902f2edc.1658159083.git.maciej.szmigiero@oracle.com>
 <7458497a8694ba0fbabee28eabf557e6e4406fbe.camel@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH] KVM: nSVM: Pull CS.Base from actual VMCB12 for soft
 int/ex re-injection
In-Reply-To: <7458497a8694ba0fbabee28eabf557e6e4406fbe.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.07.2022 10:43, Maxim Levitsky wrote:
> On Mon, 2022-07-18 at 17:47 +0200, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> enter_svm_guest_mode() first calls nested_vmcb02_prepare_control() to copy
>> control fields from VMCB12 to the current VMCB, then
>> nested_vmcb02_prepare_save() to perform a similar copy of the save area.
>>
>> This means that nested_vmcb02_prepare_control() still runs with the
>> previous save area values in the current VMCB so it shouldn't take the L2
>> guest CS.Base from this area.
>>
>> Explicitly pull CS.Base from the actual VMCB12 instead in
>> enter_svm_guest_mode().
>>
>> Granted, having a non-zero CS.Base is a very rare thing (and even
>> impossible in 64-bit mode), having it change between nested VMRUNs is
>> probably even rarer, but if it happens it would create a really subtle bug
>> so it's better to fix it upfront.
>>
>> Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
>>   arch/x86/kvm/svm/nested.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index adf4120b05d90..23252ab821941 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -639,7 +639,8 @@ static bool is_evtinj_nmi(u32 evtinj)
>>   }
>>   
>>   static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>> -                                         unsigned long vmcb12_rip)
>> +                                         unsigned long vmcb12_rip,
>> +                                         unsigned long vmcb12_csbase)
> 
> Honestly I don't like that nested_vmcb02_prepare_control starts to grow its parameter list,
> because it kind of defeats the purpose of vmcb12 cache we added back then.
> 
> I think that it is better to add csbase/rip to vmcb_save_area_cached,
> but I am not 100% sure. What do you think?

This function has only 3 parameters now, so they fit well into registers
without taking any extra memory (even assuming it won't get inlined).

If in the future more parameters need to be added to this function
(which may or may not happen) then they all can be moved to, for example,
vmcb_ctrl_area_cached.

> Best regards,
> 	Maxim Levitsky
> 
> 

Thanks,
Maciej
