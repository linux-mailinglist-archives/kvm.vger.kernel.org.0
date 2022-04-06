Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB814F6DD9
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 00:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbiDFWg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 18:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiDFWg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 18:36:56 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3A210E06D;
        Wed,  6 Apr 2022 15:34:57 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1ncEEh-00033Z-Ge; Thu, 07 Apr 2022 00:34:47 +0200
Message-ID: <7e8f558d-c00a-7170-f671-bd10c0a56557@maciej.szmigiero.name>
Date:   Thu, 7 Apr 2022 00:34:41 +0200
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
References: <20220402010903.727604-6-seanjc@google.com>
 <a47217da0b6db4f1b6b6c69a9dc38350b13ac17c.camel@redhat.com>
 <YkshgrUaF4+MrrXf@google.com>
 <7caee33a-da0f-00be-3195-82c3d1cd4cb4@maciej.szmigiero.name>
 <YkzxXw1Aznv4zX0a@google.com>
 <eed1cea4-409a-f03e-5c31-e82d49bb2101@maciej.szmigiero.name>
 <Yk3Jd6xAfgVoFgLc@google.com>
 <5135b502-ce2e-babb-7812-4d4c431a5252@maciej.szmigiero.name>
 <Yk3uh6f+0nOdybd3@google.com>
 <cd348e77-cb40-a64c-6b82-24e9a9158946@maciej.szmigiero.name>
 <Yk39j8f81+iDOsDG@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 5/8] KVM: SVM: Re-inject INT3/INTO instead of retrying the
 instruction
In-Reply-To: <Yk39j8f81+iDOsDG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6.04.2022 22:52, Sean Christopherson wrote:
> On Wed, Apr 06, 2022, Maciej S. Szmigiero wrote:
>> On 6.04.2022 21:48, Sean Christopherson wrote:
>>> On Wed, Apr 06, 2022, Maciej S. Szmigiero wrote:
>>>> On 6.04.2022 19:10, Sean Christopherson wrote:
>>>>> On Wed, Apr 06, 2022, Maciej S. Szmigiero wrote:
>>>> And what if it's L0 that is trying to inject a NMI into L2?
>>>> In this case is_guest_mode() is true, but the full NMI injection machinery
>>>> should be used.
>>>
>>> Gah, you're right, I got misled by a benign bug in nested_vmx_l1_wants_exit() and
>>> was thinking that NMIs always exit.  The "L1 wants" part should be conditioned on
>>> NMI exiting being enabled.  It's benign because KVM always wants "real" NMIs, and
>>> so the path is never encountered.
>>>
>>> @@ -5980,7 +6005,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
>>>           switch ((u16)exit_reason.basic) {
>>>           case EXIT_REASON_EXCEPTION_NMI:
>>>                   intr_info = vmx_get_intr_info(vcpu);
>>> -               if (is_nmi(intr_info))
>>> +               if (is_nmi(intr_info) && nested_cpu_has_nmi_exiting(vmcs12))
>>>                           return true;
>>>                   else if (is_page_fault(intr_info))
>>>                           return true;
>>>
>>
>> I guess you mean "benign" when having KVM as L1, since other hypervisors may
>> let their L2s handle NMIs themselves.
> 
> No, this one's truly benign.  The nVMX exit processing is:
> 
> 	if (nested_vmx_l0_wants_exit())
> 		handle in L0 / KVM;
> 
> 	if (nested_vmx_l1_wants_exit())
> 		handle in L1
> 
> 	handle in L0 / KVM
> 
> Since this is for actual hardware NMIs, the first "L0 wants" check always returns
> true for NMIs, so the fact that KVM screws up L1's wants is a non-issue.

Got it, forgot the path was for actual hardware NMIs, which obviously
can't go directly to L1 or L2.

>>>>>> With the code in my previous patch set I planned to use
>>>>>> exit_during_event_injection() to detect such case, but if we implement
>>>>>> VMCB12 EVENTINJ parsing we can simply add a flag that the relevant event
>>>>>> comes from L1, so its normal injection side-effects should be skipped.
>>>>>
>>>>> Do we still need a flag based on the above?  Honest question... I've been staring
>>>>> at all this for the better part of an hour and may have lost track of things.
>>>>
>>>> If checking just is_guest_mode() is not enough due to reasons I described
>>>> above then we need to somehow determine in the NMI / IRQ injection handler
>>>> whether the event to be injected into L2 comes from L0 or L1.
>>>> For this (assuming we do VMCB12 EVENTINJ parsing) I think we need an extra flag.
>>>
>>> Yes :-(  And I believe the extra flag would need to be handled by KVM_{G,S}ET_VCPU_EVENTS.
>>>
>>
>> Another option for saving and restoring a VM would be to add it to
>> KVM_{GET,SET}_NESTED_STATE somewhere (maybe as a part of the saved VMCB12
>> control area?).
> 
> Ooh.  What if we keep nested_run_pending=true until the injection completes?  Then
> we don't even need an extra flag because nested_run_pending effectively says that
> any and all injected events are for L1=>L2.  In KVM_GET_NESTED_STATE, shove the
> to-be-injected event into the normal vmc*12 injection field, and ignore all
> to-be-injected events in KVM_GET_VCPU_EVENTS if nested_run_pending=true.
> 
> That should work even for migrating to an older KVM, as keeping nested_run_pending
> will cause the target to reprocess the event injection as if it were from nested
> VM-Enter, which it technically is.

I guess here by "ignore all to-be-injected events in KVM_GET_VCPU_EVENTS" you
mean *moving* back the L1 -> L2 event to be injected from KVM internal data
structures like arch.nmi_injected (and so on) to the KVM_GET_NESTED_STATE-returned
VMCB12 EVENTINJ field (or its VMX equivalent).

But then the VMM will need to first call KVM_GET_NESTED_STATE (which will do
the moving), only then KVM_GET_VCPU_EVENTS (which will then no longer show
these events as pending).
And their setters in the opposite order when restoring the VM.

Although, if the VMCB12 EVENTINJ field contents perfectly matches things like
arch.nmi_injected there should be no problem in principle if these events are
restored by VMM to both places by KVM_SET_NESTED_STATE and KVM_SET_VCPU_EVENTS.

Another option would be to ignore either a first KVM_SET_VCPU_EVENTS after
KVM_SET_NESTED_STATE with KVM_STATE_NESTED_RUN_PENDING or every such call
while nested_run_pending is still true (but wouldn't either of these changes
break KVM API?).

I'm not sure, however, that there isn't some corner case lurking here :(

> We could probably get away with completely dropping the intermediate event as
> the vmc*12 should still have the original event, but that technically could result
> in architecturally incorrect behavior, e.g. if vectoring up to the point of
> interception sets A/D bits in the guest.

Thanks,
Maciej
