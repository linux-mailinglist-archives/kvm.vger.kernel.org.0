Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240034F1BA3
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380732AbiDDVV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380638AbiDDUqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 16:46:17 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED7113E9A;
        Mon,  4 Apr 2022 13:44:18 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nbTYX-0003cQ-TV; Mon, 04 Apr 2022 22:44:09 +0200
Message-ID: <7caee33a-da0f-00be-3195-82c3d1cd4cb4@maciej.szmigiero.name>
Date:   Mon, 4 Apr 2022 22:44:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-6-seanjc@google.com>
 <a47217da0b6db4f1b6b6c69a9dc38350b13ac17c.camel@redhat.com>
 <YkshgrUaF4+MrrXf@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 5/8] KVM: SVM: Re-inject INT3/INTO instead of retrying the
 instruction
In-Reply-To: <YkshgrUaF4+MrrXf@google.com>
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

On 4.04.2022 18:49, Sean Christopherson wrote:
> On Mon, Apr 04, 2022, Maxim Levitsky wrote:
>> On Sat, 2022-04-02 at 01:09 +0000, Sean Christopherson wrote:
>>> Re-inject INT3/INTO instead of retrying the instruction if the CPU
>>> encountered an intercepted exception while vectoring the software
>>> exception, e.g. if vectoring INT3 encounters a #PF and KVM is using
>>> shadow paging.  Retrying the instruction is architecturally wrong, e.g.
>>> will result in a spurious #DB if there's a code breakpoint on the INT3/O,
>>> and lack of re-injection also breaks nested virtualization, e.g. if L1
>>> injects a software exception and vectoring the injected exception
>>> encounters an exception that is intercepted by L0 but not L1.
>>>
>>> Due to, ahem, deficiencies in the SVM architecture, acquiring the next
>>> RIP may require flowing through the emulator even if NRIPS is supported,
>>> as the CPU clears next_rip if the VM-Exit is due to an exception other
>>> than "exceptions caused by the INT3, INTO, and BOUND instructions".  To
>>> deal with this, "skip" the instruction to calculate next_ript, and then
>>> unwind the RIP write and any side effects (RFLAGS updates).
> 
> ...
> 
(..)
>>> +
>>>   	kvm_make_request(KVM_REQ_EVENT, vcpu);
>>>   
>>>   	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
>>> @@ -3711,9 +3762,9 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>>>   	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
>>>   	 * be the reported vectored event, but RIP still needs to be unwound.
>>>   	 */
>>> -	if (int3_injected && type == SVM_EXITINTINFO_TYPE_EXEPT &&
>>> -	   kvm_is_linear_rip(vcpu, svm->int3_rip))
>>> -		kvm_rip_write(vcpu, kvm_rip_read(vcpu) - int3_injected);
>>> +	if (soft_int_injected && type == SVM_EXITINTINFO_TYPE_EXEPT &&
>>> +	   kvm_is_linear_rip(vcpu, svm->soft_int_linear_rip))
>>> +		kvm_rip_write(vcpu, kvm_rip_read(vcpu) - soft_int_injected);
>>>   
>>>   	switch (type) {
>>>   	case SVM_EXITINTINFO_TYPE_NMI:
>>> @@ -3726,14 +3777,6 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>>>   		if (vector == X86_TRAP_VC)
>>>   			break;
>>>   
>>> -		/*
>>> -		 * In case of software exceptions, do not reinject the vector,
>>> -		 * but re-execute the instruction instead. Rewind RIP first
>>> -		 * if we emulated INT3 before.
>>> -		 */
>>> -		if (kvm_exception_is_soft(vector))
>>> -			break;
>>> -
>>>   		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
>>>   			u32 err = svm->vmcb->control.exit_int_info_err;
>>>   			kvm_requeue_exception_e(vcpu, vector, err);
>>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>>> index 47e7427d0395..a770a1c7ddd2 100644
>>> --- a/arch/x86/kvm/svm/svm.h
>>> +++ b/arch/x86/kvm/svm/svm.h
>>> @@ -230,8 +230,8 @@ struct vcpu_svm {
>>>   	bool nmi_singlestep;
>>>   	u64 nmi_singlestep_guest_rflags;
>>>   
>>> -	unsigned int3_injected;
>>> -	unsigned long int3_rip;
>>> +	unsigned soft_int_injected;
>>> +	unsigned long soft_int_linear_rip;
>>>   
>>>   	/* optional nested SVM features that are enabled for this guest  */
>>>   	bool nrips_enabled                : 1;
>>
>>
>> I mostly agree with this patch, but think that it doesn't address the
>> original issue that Maciej wanted to address:
>>
>> Suppose that there is *no* instruction in L2 code which caused the software
>> exception, but rather L1 set arbitrary next_rip, and set EVENTINJ to software
>> exception with some vector, and that injection got interrupted.
>>
>> I don't think that this code will support this.
> 
> Argh, you're right.  Maciej's selftest injects without an instruction, but it doesn't
> configure the scenario where that injection fails due to an exception+VM-Exit that
> isn't intercepted by L1 and is handled by L0.  The event_inj test gets the coverage
> for the latter, but always has a backing instruction.
> 
>> I think that svm_complete_interrupts should store next_rip it in some field
>> like VMX does (vcpu->arch.event_exit_inst_len).
> 
> Yeah.  The ugly part is that because next_rip is guaranteed to be cleared on exit
> (the exit is gauranteed to be due to a fault-like exception), KVM has to snapshot
> next_rip during the "original" injection and use the linear_rip matching heuristic
> to detect this scenario.
> 
>> That field also should be migrated, or we must prove that it works anyway.
>> E.g, what happens when we tried to inject event,
>> injection was interrupted by other exception, and then we migrate?
> 
> Ya, should Just Work if control.next_rip is used to cache the next rip.
> 
> Handling this doesn't seem to be too awful (haven't tested yet), it's largely the
> same logic as the existing !nrips code.
> 
> In svm_update_soft_interrupt_rip(), snapshot all information regardless of whether
> or not nrips is enabled:
> 
> 	svm->soft_int_injected = true;
> 	svm->soft_int_csbase = svm->vmcb->save.cs.base;
> 	svm->soft_int_old_rip = old_rip;
> 	svm->soft_int_next_rip = rip;
> 
> 	if (nrips)
> 		kvm_rip_write(vcpu, old_rip);
> 
> 	if (static_cpu_has(X86_FEATURE_NRIPS))
> 		svm->vmcb->control.next_rip = rip;
> 
> and then in svm_complete_interrupts(), change the linear RIP matching code to look
> for the old rip in the nrips case and stuff svm->vmcb->control.next_rip on match.
> 
> 	bool soft_int_injected = svm->soft_int_injected;
> 	unsigned soft_int_rip;
> 
> 	svm->soft_int_injected = false;
> 
> 	if (soft_int_injected) {
> 		if (nrips)
> 			soft_int_rip = svm->soft_int_old_rip;
> 		else
> 			soft_int_rip = svm->soft_int_next_rip;
> 	}
> 
> 	...
> 
> 	if soft_int_injected && type == SVM_EXITINTINFO_TYPE_EXEPT &&
> 	   kvm_is_linear_rip(vcpu, soft_int_rip + svm->soft_int_csbase)) {
> 		if (nrips)
> 			svm->vmcb->control.next_rip = svm->soft_int_next_rip;
> 		else
> 			kvm_rip_write(vcpu, svm->soft_int_old_rip);
> 	}
> 
> 
> 

Despite what the svm_update_soft_interrupt_rip() name might suggest this
handles only *soft exceptions*, not *soft interrupts*
(which are injected by svm_inject_irq() and also need proper next_rip
management).

Also, I'm not sure that even the proposed updated code above will
actually restore the L1-requested next_rip correctly on L1 -> L2
re-injection (will review once the full version is available).

Thanks,
Maciej
