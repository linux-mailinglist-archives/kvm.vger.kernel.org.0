Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA674F1BC0
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381163AbiDDVWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380707AbiDDVIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 17:08:21 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6112F397;
        Mon,  4 Apr 2022 14:06:23 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nbTtd-0003gN-O5; Mon, 04 Apr 2022 23:05:57 +0200
Message-ID: <7d67bc6f-00ac-7c07-f6c2-c41b2f0d35a1@maciej.szmigiero.name>
Date:   Mon, 4 Apr 2022 23:05:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jon Grimm <Jon.Grimm@amd.com>,
        David Kaplan <David.Kaplan@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <cover.1646944472.git.maciej.szmigiero@oracle.com>
 <a28577564a7583c32f0029f2307f63ca8869cf22.1646944472.git.maciej.szmigiero@oracle.com>
 <4f5234ac2c6d91d90b1c85ccb3081a91a6d3be2a.camel@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 3/5] KVM: nSVM: Don't forget about L1-injected events
In-Reply-To: <4f5234ac2c6d91d90b1c85ccb3081a91a6d3be2a.camel@redhat.com>
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

On 4.04.2022 11:53, Maxim Levitsky wrote:
> On Thu, 2022-03-10 at 22:38 +0100, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> In SVM synthetic software interrupts or INT3 or INTO exception that L1
>> wants to inject into its L2 guest are forgotten if there is an intervening
>> L0 VMEXIT during their delivery.
>>
>> They are re-injected correctly with VMX, however.
>>
>> This is because there is an assumption in SVM that such exceptions will be
>> re-delivered by simply re-executing the current instruction.
>> Which might not be true if this is a synthetic exception injected by L1,
>> since in this case the re-executed instruction will be one already in L2,
>> not the VMRUN instruction in L1 that attempted the injection.
>>
>> Leave the pending L1 -> L2 event in svm->nested.ctl.event_inj{,err} until
>> it is either re-injected successfully or returned to L1 upon a nested
>> VMEXIT.
>> Make sure to always re-queue such event if returned in EXITINTINFO.
>>
>> The handling of L0 -> {L1, L2} event re-injection is left as-is to avoid
>> unforeseen regressions.
> 
> Some time ago I noticed this too, but haven't dug into this too much.
> I rememeber I even had some half-baked patch for this I never posted,
> because I didn't think about the possibility of this syntetic injection.
> 
> Just to be clear that I understand this correctly:
> 
> 1. What is happening is that L1 is injecting INTn/INTO/INT3 but L2 code
>     doesn't actualy contain an INTn/INTO/INT3 instruction.
>     This is wierd but legal thing to do.
>     Again, if L2 actually contained the instruction, it would have worked?

I think so (haven't tested it though).

> 
> 2. When actual INTn/INT0/INT3 are intercepted on SVM, then
>     save.RIP points to address of the instruction, and control.next_rip
>     points to address of next instruction after (as expected)

Yes.

> 3. When EVENTINJ is used with '(TYPE = 3) with vectors 3 or 4'
>     or 'TYPE=4', then next_rip is pushed on the stack, while save.RIP is
>     pretty much ignored, and exectution jumps to the handler in the IDT.

Yes.

>     also at least for INT3/INTO, PRM states that IDT's DPL field is checked
>     before dispatch, meaning that we can get legit #GP during delivery.
>     (this looks like another legit reason to fix exception merging in KVM)
> 

That's right.

> Best regards,
> 	Maxim Levitsky
> 
> 
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
>>   arch/x86/kvm/svm/nested.c | 65 +++++++++++++++++++++++++++++++++++++--
>>   arch/x86/kvm/svm/svm.c    | 17 ++++++++--
>>   arch/x86/kvm/svm/svm.h    | 47 ++++++++++++++++++++++++++++
>>   3 files changed, 125 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index 9656f0d6815c..75017bf77955 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -420,8 +420,17 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
>>   void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
>>   {
>>   	u32 mask;
>> -	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
>> -	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
>> +
>> +	/*
>> +	 * Leave the pending L1 -> L2 event in svm->nested.ctl.event_inj{,err}
>> +	 * if its re-injection is needed
>> +	 */
>> +	if (!exit_during_event_injection(svm, svm->nested.ctl.event_inj,
>> +					 svm->nested.ctl.event_inj_err)) {
>> +		WARN_ON_ONCE(svm->vmcb->control.event_inj & SVM_EVTINJ_VALID);
>> +		svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
>> +		svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
>> +	}
> 
> Beware that this could backfire in regard to nested migration.
> 
> I once chased a nasty bug related to this.
> 
> The bug was:
> 
> - L1 does VMRUN with injection (EVENTINJ set)
> 
> - VMRUN exit handler is 'executed' by KVM,
>    This copies EVENINJ fields from VMCB12 to VMCB02
> 
> - Once VMRUN exit handler is done executing, we exit to userspace to start migration
>    (basically static_call(kvm_x86_handle_exit)(...) handles the SVM_EXIT_VMRUN,
>     and that is all, vcpu_enter_guest isn't called again, so injection is not canceled)
> 
> - migration happens and it migrates the control area of vmcb02 with EVENTINJ fields set.
> 
> - on migration target, we inject another interrupt to the guest via EVENTINJ
>    because svm_check_nested_events checks nested_run_pending to avoid doing this
>    but nested_run_pending was not migrated correctly,
>    and overwrites the EVENTINJ - injection is lost.
> 
> Paolo back then proposed to me that instead of doing direct copy from VMCB12 to VMCB02
> we should instead go through 'vcpu->arch.interrupt' and such.
> I had a prototype of this but never gotten to clean it up to be accepted upstream,
> knowing that current way also works.
> 

This sounds like a valid, but different, bug - to be honest, it would
look much cleaner to me, too, if EVENTINJ was parsed from VMCB12 into
relevant KVM injection structures on a nested VMRUN rather than following
a hybrid approach:
1) Copy the field from VMCB12 to VMCB02 directly on a nested VMRUN,

2) Parse the EXITINTINFO into KVM injection structures when re-injecting.

>>   
>>   	/* Only a few fields of int_ctl are written by the processor.  */
>>   	mask = V_IRQ_MASK | V_TPR_MASK;
>> @@ -669,6 +678,54 @@ static void nested_svm_copy_common_state(struct vmcb *from_vmcb, struct vmcb *to
>>   	to_vmcb->save.spec_ctrl = from_vmcb->save.spec_ctrl;
>>   }
>>   
>> +void nested_svm_maybe_reinject(struct kvm_vcpu *vcpu)
> 
> A personal taste note: I don't like the 'maybe' for some reason.
> But I won't fight over this.

What's you proposed name then?

>> +{
>> +	struct vcpu_svm *svm = to_svm(vcpu);
>> +	unsigned int vector, type;
>> +	u32 exitintinfo = svm->vmcb->control.exit_int_info;
>> +
>> +	if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
>> +		return;
>> +
>> +	/*
>> +	 * No L1 -> L2 event to re-inject?
>> +	 *
>> +	 * In this case event_inj will be cleared by
>> +	 * nested_sync_control_from_vmcb02().
>> +	 */
>> +	if (!(svm->nested.ctl.event_inj & SVM_EVTINJ_VALID))
>> +		return;
>> +
>> +	/* If the last event injection was successful there shouldn't be any pending event */
>> +	if (WARN_ON_ONCE(!(exitintinfo & SVM_EXITINTINFO_VALID)))
>> +		return;
>> +
>> +	kvm_make_request(KVM_REQ_EVENT, vcpu);
>> +
>> +	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
>> +	type = exitintinfo & SVM_EXITINTINFO_TYPE_MASK;
>> +
>> +	switch (type) {
>> +	case SVM_EXITINTINFO_TYPE_NMI:
>> +		vcpu->arch.nmi_injected = true;
>> +		break;
>> +	case SVM_EXITINTINFO_TYPE_EXEPT:
>> +		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR)
>> +			kvm_requeue_exception_e(vcpu, vector,
>> +						svm->vmcb->control.exit_int_info_err);
>> +		else
>> +			kvm_requeue_exception(vcpu, vector);
>> +		break;
>> +	case SVM_EXITINTINFO_TYPE_SOFT:
> 
> Note that AFAIK, SVM_EXITINTINFO_TYPE_SOFT is only for INTn instructions,
> while INT3 and INTO are considered normal exceptions but EVENTINJ
> handling has special case for them.
> 
That's right.

> On VMX it is a bit cleaner:
> It has:
> 
> 3 - normal stock exception caused by CPU itself, like #PF and such
>        
> 4 - INTn
>        * does DPL check and uses VM_EXIT_INSTRUCTION_LEN
>         
> 5 - ICEBP/INT1, which SVM doesnt support to re-inject
>        * doesn't do DPL check, but uses VM_EXIT_INSTRUCTION_LEN I think
> 
> 6 - software exception (INT3/INTO)
>        * does DPL check and uses VM_EXIT_INSTRUCTION_LEN as well
> 
> I don't know if there is any difference between 4 and 6.
> 
> 
> 
> 
(..)
> 
> 
> I will also review Sean's take on this, let see which one is simplier.

Since Sean's patch set is supposed to supersede this one let's continue
the discussion there.

> Best regards,
> 	Maxim Levitsky

Thanks,
Maciej
