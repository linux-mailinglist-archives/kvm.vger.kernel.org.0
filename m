Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890A24F838E
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345051AbiDGPfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344890AbiDGPev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:34:51 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580425F5B;
        Thu,  7 Apr 2022 08:32:23 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1ncU7C-0005Jj-Qd; Thu, 07 Apr 2022 17:32:06 +0200
Message-ID: <04ac8bcd-54f7-acd1-0764-11f6925c2c94@maciej.szmigiero.name>
Date:   Thu, 7 Apr 2022 17:32:01 +0200
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
References: <YkshgrUaF4+MrrXf@google.com>
 <7caee33a-da0f-00be-3195-82c3d1cd4cb4@maciej.szmigiero.name>
 <YkzxXw1Aznv4zX0a@google.com>
 <eed1cea4-409a-f03e-5c31-e82d49bb2101@maciej.szmigiero.name>
 <Yk3Jd6xAfgVoFgLc@google.com>
 <5135b502-ce2e-babb-7812-4d4c431a5252@maciej.szmigiero.name>
 <Yk3uh6f+0nOdybd3@google.com>
 <cd348e77-cb40-a64c-6b82-24e9a9158946@maciej.szmigiero.name>
 <Yk39j8f81+iDOsDG@google.com>
 <7e8f558d-c00a-7170-f671-bd10c0a56557@maciej.szmigiero.name>
 <Yk4cOGC5/B6fKoJD@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 5/8] KVM: SVM: Re-inject INT3/INTO instead of retrying the
 instruction
In-Reply-To: <Yk4cOGC5/B6fKoJD@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7.04.2022 01:03, Sean Christopherson wrote:
> On Thu, Apr 07, 2022, Maciej S. Szmigiero wrote:
>> On 6.04.2022 22:52, Sean Christopherson wrote:
>>> On Wed, Apr 06, 2022, Maciej S. Szmigiero wrote:
>>>> Another option for saving and restoring a VM would be to add it to
>>>> KVM_{GET,SET}_NESTED_STATE somewhere (maybe as a part of the saved VMCB12
>>>> control area?).
>>>
>>> Ooh.  What if we keep nested_run_pending=true until the injection completes?  Then
>>> we don't even need an extra flag because nested_run_pending effectively says that
>>> any and all injected events are for L1=>L2.  In KVM_GET_NESTED_STATE, shove the
>>> to-be-injected event into the normal vmc*12 injection field, and ignore all
>>> to-be-injected events in KVM_GET_VCPU_EVENTS if nested_run_pending=true.
>>>
>>> That should work even for migrating to an older KVM, as keeping nested_run_pending
>>> will cause the target to reprocess the event injection as if it were from nested
>>> VM-Enter, which it technically is.
>>
>> I guess here by "ignore all to-be-injected events in KVM_GET_VCPU_EVENTS" you
>> mean *moving* back the L1 -> L2 event to be injected from KVM internal data
>> structures like arch.nmi_injected (and so on) to the KVM_GET_NESTED_STATE-returned
>> VMCB12 EVENTINJ field (or its VMX equivalent).
>>
>> But then the VMM will need to first call KVM_GET_NESTED_STATE (which will do
>> the moving), only then KVM_GET_VCPU_EVENTS (which will then no longer show
>> these events as pending).
>> And their setters in the opposite order when restoring the VM.
> 
> I wasn't thinking of actually moving things in the source VM, only ignoring events
> in KVM_GET_VCPU_EVENTS.  Getting state shouldn't be destructive, e.g. the source VM
> should still be able to continue running.

Right, getters should not change state.

> Ahahahaha, and actually looking at the code, there's this gem in KVM_GET_VCPU_EVENTS
> 
> 	/*
> 	 * The API doesn't provide the instruction length for software
> 	 * exceptions, so don't report them. As long as the guest RIP
> 	 * isn't advanced, we should expect to encounter the exception
> 	 * again.
> 	 */
> 	if (kvm_exception_is_soft(vcpu->arch.exception.nr)) {
> 		events->exception.injected = 0;
> 		events->exception.pending = 0;
> 	}
> 
> and again for soft interrupts
> 
> 	events->interrupt.injected =
> 		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
> 
> so through KVM's own incompetency, it's already doing half the work.

So KVM_GET_VCPU_EVENTS was basically already explicitly broken for this
case (where RIP does not point to a INT3/INTO/INT x instruction).

> This is roughly what I had in mind.  It will "require" moving nested_run_pending
> to kvm_vcpu_arch, but I've been itching for an excuse to do that anyways.
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb71727acecb..62c48f6a0815 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4846,6 +4846,8 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
>   static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>                                                 struct kvm_vcpu_events *events)
>   {
> +       bool drop_injected_events = vcpu->arch.nested_run_pending;
> +
>          process_nmi(vcpu);
> 
>          if (kvm_check_request(KVM_REQ_SMI, vcpu))
> @@ -4872,7 +4874,8 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>           * isn't advanced, we should expect to encounter the exception
>           * again.
>           */
> -       if (kvm_exception_is_soft(vcpu->arch.exception.nr)) {
> +       if (drop_injected_events ||
> +           kvm_exception_is_soft(vcpu->arch.exception.nr)) {
>                  events->exception.injected = 0;
>                  events->exception.pending = 0;
>          } else {
> @@ -4893,13 +4896,14 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>          events->exception_has_payload = vcpu->arch.exception.has_payload;
>          events->exception_payload = vcpu->arch.exception.payload;
> 
> -       events->interrupt.injected =
> -               vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
> +       events->interrupt.injected = vcpu->arch.interrupt.injected &&
> +                                    !vcpu->arch.interrupt.soft &&
> +                                    !drop_injected_events;
>          events->interrupt.nr = vcpu->arch.interrupt.nr;
>          events->interrupt.soft = 0;
>          events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
> 
> -       events->nmi.injected = vcpu->arch.nmi_injected;
> +       events->nmi.injected = vcpu->arch.nmi_injected && !drop_injected_events;
>          events->nmi.pending = vcpu->arch.nmi_pending != 0;
>          events->nmi.masked = static_call(kvm_x86_get_nmi_mask)(vcpu);
>          events->nmi.pad = 0;
> 

So the VMM will get VMCB12 with EVENTINJ field filled with the event
to re-inject from KVM_GET_NESTED_STATE and events.{exception,interrupt,nmi}.injected
unset from KVM_GET_VCPU_EVENTS.

Let's say now that the VMM uses this data to restore a VM: it restores nested
state by using KVM_SET_NESTED_STATE and then events by calling KVM_SET_VCPU_EVENTS.

So it ends with VMCB12 EVENTINJ field filled, but KVM injection structures
(arch.{exception,interrupt,nmi}.injected) zeroed by that later KVM_SET_VCPU_EVENTS
call.

Assuming that L1 -> L2 event injection is always based on KVM injection structures
(like we discussed earlier), rather than on a direct copy of EVENTINJ field like
it is now, before doing the first VM entry KVM will need to re-parse VMCB12 EVENTINJ
field into KVM arch.{exception,interrupt,nmi}.injected to make it work properly.

Thanks,
Maciej
