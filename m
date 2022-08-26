Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8435A27B7
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 14:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344173AbiHZMXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 08:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344061AbiHZMWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 08:22:41 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC43DEA4B;
        Fri, 26 Aug 2022 05:21:02 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1oRYKT-0005Wk-JK; Fri, 26 Aug 2022 14:20:53 +0200
Message-ID: <d30192e4-9e12-f770-e944-e3c38b9514b8@maciej.szmigiero.name>
Date:   Fri, 26 Aug 2022 14:20:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     "Shukla, Santosh" <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com
References: <20220810061226.1286-1-santosh.shukla@amd.com>
 <20220810061226.1286-6-santosh.shukla@amd.com>
 <bf9e8a9c-5172-b61a-be6e-87a919442fbd@maciej.szmigiero.name>
 <e10b3de6-2df0-1339-4574-8477a924b78e@amd.com>
 <f96b867f-4c32-4950-8508-234fe2cda7b9@maciej.szmigiero.name>
 <1062bf85-0d44-011b-2377-d6be1485ce65@amd.com>
 <3752b74b-74e1-00fd-d80d-41104e07fe95@maciej.szmigiero.name>
 <ce3c852e-4ee0-36df-383c-0957a6e02a6d@amd.com>
 <ddbb19b8-417f-f839-591d-a0610ea9629b@maciej.szmigiero.name>
 <ca464c8c-872f-f86b-6fca-7ef7b374a304@amd.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCHv3 5/8] KVM: SVM: Add VNMI support in inject_nmi
In-Reply-To: <ca464c8c-872f-f86b-6fca-7ef7b374a304@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.08.2022 11:35, Shukla, Santosh wrote:
> On 8/25/2022 7:46 PM, Maciej S. Szmigiero wrote:
>> On 25.08.2022 16:05, Shukla, Santosh wrote:
>>> On 8/25/2022 6:15 PM, Maciej S. Szmigiero wrote:
>>>> On 25.08.2022 12:56, Shukla, Santosh wrote:
>>>>> On 8/24/2022 6:26 PM, Maciej S. Szmigiero wrote:
>>>>>> On 24.08.2022 14:13, Shukla, Santosh wrote:
>>>>>>> Hi Maciej,
>>>>>>>
>>>>>>> On 8/11/2022 2:54 AM, Maciej S. Szmigiero wrote:
>>>>>>>> On 10.08.2022 08:12, Santosh Shukla wrote:
>>>>>>>>> Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
>>>>>>>>> will clear V_NMI to acknowledge processing has started and will keep the
>>>>>>>>> V_NMI_MASK set until the processor is done with processing the NMI event.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>>>>>>>> ---
>>>>>>>>> v3:
>>>>>>>>> - Removed WARN_ON check.
>>>>>>>>>
>>>>>>>>> v2:
>>>>>>>>> - Added WARN_ON check for vnmi pending.
>>>>>>>>> - use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.
>>>>>>>>>
>>>>>>>>>       arch/x86/kvm/svm/svm.c | 7 +++++++
>>>>>>>>>       1 file changed, 7 insertions(+)
>>>>>>>>>
>>>>>>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>>>>>>> index e260e8cb0c81..8c4098b8a63e 100644
>>>>>>>>> --- a/arch/x86/kvm/svm/svm.c
>>>>>>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>>>>>>> @@ -3479,7 +3479,14 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>>>>>>>>>       static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>>>>>>>>       {
>>>>>>>>>           struct vcpu_svm *svm = to_svm(vcpu);
>>>>>>>>> +    struct vmcb *vmcb = NULL;
>>>>>>>>>       +    if (is_vnmi_enabled(svm)) {
>>>>>>>>
>>>>>>>> I guess this should be "is_vnmi_enabled(svm) && !svm->nmi_l1_to_l2"
>>>>>>>> since if nmi_l1_to_l2 is true then the NMI to be injected originally
>>>>>>>> comes from L1's VMCB12 EVENTINJ field.
>>>>>>>>
>>>>>>>
>>>>>>> Not sure if I understood the case fully.. so trying to sketch scenario here -
>>>>>>> if nmi_l1_to_l2 is true then event is coming from EVTINJ. .which could
>>>>>>> be one of following case -
>>>>>>> 1) L0 (vnmi enabled) and L1 (vnmi disabled)
>>>>>>
>>>>>> As far as I can see in this case:
>>>>>> is_vnmi_enabled() returns whether VMCB02's int_ctl has V_NMI_ENABLE bit set.
>>>>>>
>>>>>
>>>>> For L1 with vnmi disabled case - is_vnmi_enabled()->get_vnmi_vmcb() will return false so the
>>>>> execution path will opt EVTINJ model for re-injection.
>>>>
>>>> I guess by "get_vnmi_vmcb() will return false" you mean it will return NULL,
>>>> since this function returns a pointer, not a bool.
>>>>
>>>
>>> Yes, I meant is_vnmi_enabled() will return false if vnmi param is unset.
>>>
>>>> I can't see however, how this will happen:
>>>>> static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
>>>>> {
>>>>>       if (!vnmi)
>>>>>           return NULL;
>>>>           ^ "vnmi" variable controls whether L0 uses vNMI,
>>>>          so this variable is true in our case
>>>>
>>>
>>> No.
>>>
>>> In L1 case (vnmi disabled) - vnmi param will be false.
>>
>> Perhaps there was a misunderstanding here - the case here
>> isn't the code under discussion running as L1, but as L0
>> where L1 not using vNMI - L1 here can be an old version of KVM,
>> or Hyper-V, or any other hypervisor.
>>
> 
> Ok.
> 
>> In this case L0 is re-injecting an EVENTINJ NMI into L2 on
>> the behalf of L1.
>> That's when "nmi_l1_to_l2" is true.
>   
> hmm,. trying to understand the event re-injection flow -
> First L1 (non-vnmi) injecting event to L2 guest, in-turn
> intercepted by L0, 

That's right, the L1's VMRUN of L2 gets intercepted by L0.

> L0 sees event injection through EVTINJ

It sees that L1 wants to inject an NMI into L2 via VMCB12 EVTINJ.

> so sets the 'nmi_l1_to_l2' var 

That's right, L0 needs to keep track of this fact.

> and then L0 calls svm_inject_nmi()

Not yet - at this point svm_inject_nmi() is NOT called
(rather than, VMCB12 EVTINJ is directly copied into VMCB02 EVTINJ).

Now L0 does the actual VMRUN of L2.

Let's say that there is an intervening VMExit during delivery of
that NMI to L2, of type which is handled by L0 (perhaps a NPF on
L2 IDT or so).

In this case the NMI will be returned in VMCB02 EXITINTINFO and
needs to be re-injected into L2 on the next VMRUN,
again via EVTINJ.

That's when svm_inject_nmi() will get called to re-inject
that NMI.

> to re-inject event in L2 - is that correct (nmi_l1_to_l2) flow?
Hope the flow is clear now.

> 
> Thanks,.
> Santosh

Thanks,
Maciej
