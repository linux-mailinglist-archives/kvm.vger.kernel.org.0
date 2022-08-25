Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25015A10E9
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 14:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241119AbiHYMqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 08:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiHYMqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 08:46:11 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011E74D17E;
        Thu, 25 Aug 2022 05:46:06 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1oRCFC-0002Ci-QW; Thu, 25 Aug 2022 14:45:58 +0200
Message-ID: <3752b74b-74e1-00fd-d80d-41104e07fe95@maciej.szmigiero.name>
Date:   Thu, 25 Aug 2022 14:45:53 +0200
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
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCHv3 5/8] KVM: SVM: Add VNMI support in inject_nmi
In-Reply-To: <1062bf85-0d44-011b-2377-d6be1485ce65@amd.com>
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

On 25.08.2022 12:56, Shukla, Santosh wrote:
> On 8/24/2022 6:26 PM, Maciej S. Szmigiero wrote:
>> On 24.08.2022 14:13, Shukla, Santosh wrote:
>>> Hi Maciej,
>>>
>>> On 8/11/2022 2:54 AM, Maciej S. Szmigiero wrote:
>>>> On 10.08.2022 08:12, Santosh Shukla wrote:
>>>>> Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
>>>>> will clear V_NMI to acknowledge processing has started and will keep the
>>>>> V_NMI_MASK set until the processor is done with processing the NMI event.
>>>>>
>>>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>>>> ---
>>>>> v3:
>>>>> - Removed WARN_ON check.
>>>>>
>>>>> v2:
>>>>> - Added WARN_ON check for vnmi pending.
>>>>> - use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.
>>>>>
>>>>>     arch/x86/kvm/svm/svm.c | 7 +++++++
>>>>>     1 file changed, 7 insertions(+)
>>>>>
>>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>>> index e260e8cb0c81..8c4098b8a63e 100644
>>>>> --- a/arch/x86/kvm/svm/svm.c
>>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>>> @@ -3479,7 +3479,14 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>>>>>     static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>>>>     {
>>>>>         struct vcpu_svm *svm = to_svm(vcpu);
>>>>> +    struct vmcb *vmcb = NULL;
>>>>>     +    if (is_vnmi_enabled(svm)) {
>>>>
>>>> I guess this should be "is_vnmi_enabled(svm) && !svm->nmi_l1_to_l2"
>>>> since if nmi_l1_to_l2 is true then the NMI to be injected originally
>>>> comes from L1's VMCB12 EVENTINJ field.
>>>>
>>>
>>> Not sure if I understood the case fully.. so trying to sketch scenario here -
>>> if nmi_l1_to_l2 is true then event is coming from EVTINJ. .which could
>>> be one of following case -
>>> 1) L0 (vnmi enabled) and L1 (vnmi disabled)
>>
>> As far as I can see in this case:
>> is_vnmi_enabled() returns whether VMCB02's int_ctl has V_NMI_ENABLE bit set.
>>
> 
> For L1 with vnmi disabled case - is_vnmi_enabled()->get_vnmi_vmcb() will return false so the
> execution path will opt EVTINJ model for re-injection.

I guess by "get_vnmi_vmcb() will return false" you mean it will return NULL,
since this function returns a pointer, not a bool.

I can't see however, how this will happen:
>static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
>{
>	if (!vnmi)
>		return NULL;
         ^ "vnmi" variable controls whether L0 uses vNMI,
	   so this variable is true in our case

>
>	if (is_guest_mode(&svm->vcpu))
>		return svm->nested.vmcb02.ptr;
		^ this should be always non-NULL.

So get_vnmi_vmcb() will return VMCB02 pointer in our case, not NULL...

> 
> Thanks,
> Santosh
> 
>> This field in VMCB02 comes from nested_vmcb02_prepare_control() which
>> in the !nested_vnmi_enabled() case (L1 is not using vNMI) copies these bits
>> from VMCB01:
>>> int_ctl_vmcb01_bits |= (V_NMI_PENDING | V_NMI_ENABLE | V_NMI_MASK);
>>
>> So in this case (L0 uses vNMI) V_NMI_ENABLE will be set in VMCB01, right?
>>
>> This bit will then be copied to VMCB02 

... and due to the above is_vnmi_enabled() will return true, so
re-injection will attempt to use vNMI instead of EVTINJ (wrong).

>>> 2) L0 & L1 both vnmi disabled.
>>
>> This case is ok.
>>
>>>
>>> In both cases the vnmi check will fail for L1 and execution path
>>> will fall back to default - right?
>>>
>>> Thanks,
>>> Santosh
>>

Thanks,
Maciej
