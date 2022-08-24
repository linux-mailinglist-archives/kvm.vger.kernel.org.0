Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691B459FA9F
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 14:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbiHXM5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 08:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237556AbiHXM5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 08:57:13 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E5F85FFF;
        Wed, 24 Aug 2022 05:57:11 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1oQpwN-0005wX-Rc; Wed, 24 Aug 2022 14:57:03 +0200
Message-ID: <f96b867f-4c32-4950-8508-234fe2cda7b9@maciej.szmigiero.name>
Date:   Wed, 24 Aug 2022 14:56:57 +0200
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
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCHv3 5/8] KVM: SVM: Add VNMI support in inject_nmi
In-Reply-To: <e10b3de6-2df0-1339-4574-8477a924b78e@amd.com>
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

On 24.08.2022 14:13, Shukla, Santosh wrote:
> Hi Maciej,
> 
> On 8/11/2022 2:54 AM, Maciej S. Szmigiero wrote:
>> On 10.08.2022 08:12, Santosh Shukla wrote:
>>> Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
>>> will clear V_NMI to acknowledge processing has started and will keep the
>>> V_NMI_MASK set until the processor is done with processing the NMI event.
>>>
>>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>>> ---
>>> v3:
>>> - Removed WARN_ON check.
>>>
>>> v2:
>>> - Added WARN_ON check for vnmi pending.
>>> - use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.
>>>
>>>    arch/x86/kvm/svm/svm.c | 7 +++++++
>>>    1 file changed, 7 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index e260e8cb0c81..8c4098b8a63e 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -3479,7 +3479,14 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>>>    static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>>    {
>>>        struct vcpu_svm *svm = to_svm(vcpu);
>>> +    struct vmcb *vmcb = NULL;
>>>    +    if (is_vnmi_enabled(svm)) {
>>
>> I guess this should be "is_vnmi_enabled(svm) && !svm->nmi_l1_to_l2"
>> since if nmi_l1_to_l2 is true then the NMI to be injected originally
>> comes from L1's VMCB12 EVENTINJ field.
>>
> 
> Not sure if I understood the case fully.. so trying to sketch scenario here -
> if nmi_l1_to_l2 is true then event is coming from EVTINJ. .which could
> be one of following case -
> 1) L0 (vnmi enabled) and L1 (vnmi disabled)

As far as I can see in this case:
is_vnmi_enabled() returns whether VMCB02's int_ctl has V_NMI_ENABLE bit set.

This field in VMCB02 comes from nested_vmcb02_prepare_control() which
in the !nested_vnmi_enabled() case (L1 is not using vNMI) copies these bits
from VMCB01:
> int_ctl_vmcb01_bits |= (V_NMI_PENDING | V_NMI_ENABLE | V_NMI_MASK);

So in this case (L0 uses vNMI) V_NMI_ENABLE will be set in VMCB01, right?

This bit will then be copied to VMCB02 so re-injection will attempt to use
vNMI instead of EVTINJ.

> 2) L0 & L1 both vnmi disabled.

This case is ok.

> 
> In both cases the vnmi check will fail for L1 and execution path
> will fall back to default - right?
> 
> Thanks,
> Santosh

Thanks,
Maciej
