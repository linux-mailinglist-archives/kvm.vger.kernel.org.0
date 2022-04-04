Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1103B4F1260
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 11:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355132AbiDDJzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 05:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355050AbiDDJzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 05:55:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D77A5B48
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 02:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649066016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RGMeyAN5/fZhptvJr5oegmOOt6H0eY64pK6ZfswttPc=;
        b=a5AssIT9ABNLYmMhzdMY8kakoH0LTEXAmP3sShEhxyLDB9mA6Uum2zmfYd5ZY1hnWe1dDv
        TqiI5UHOsgLkhPwFUhem6dSULeAMMNxTwrgTxiCN+uTT0ujUcgcFc6XiyfMCD9b9G9CPl9
        3nlPElv+OBn/Z4s4+eTBPZRh5F4o3Lw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-nE00Rh14MMa3IRoaPmkfVw-1; Mon, 04 Apr 2022 05:53:31 -0400
X-MC-Unique: nE00Rh14MMa3IRoaPmkfVw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B77C280A0AD;
        Mon,  4 Apr 2022 09:53:30 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 669974644E2;
        Mon,  4 Apr 2022 09:53:27 +0000 (UTC)
Message-ID: <4f5234ac2c6d91d90b1c85ccb3081a91a6d3be2a.camel@redhat.com>
Subject: Re: [PATCH 3/5] KVM: nSVM: Don't forget about L1-injected events
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Paolo Bonzini <pbonzini@redhat.com>
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
        linux-kernel@vger.kernel.org
Date:   Mon, 04 Apr 2022 12:53:26 +0300
In-Reply-To: <a28577564a7583c32f0029f2307f63ca8869cf22.1646944472.git.maciej.szmigiero@oracle.com>
References: <cover.1646944472.git.maciej.szmigiero@oracle.com>
         <a28577564a7583c32f0029f2307f63ca8869cf22.1646944472.git.maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-10 at 22:38 +0100, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> In SVM synthetic software interrupts or INT3 or INTO exception that L1
> wants to inject into its L2 guest are forgotten if there is an intervening
> L0 VMEXIT during their delivery.
> 
> They are re-injected correctly with VMX, however.
> 
> This is because there is an assumption in SVM that such exceptions will be
> re-delivered by simply re-executing the current instruction.
> Which might not be true if this is a synthetic exception injected by L1,
> since in this case the re-executed instruction will be one already in L2,
> not the VMRUN instruction in L1 that attempted the injection.
> 
> Leave the pending L1 -> L2 event in svm->nested.ctl.event_inj{,err} until
> it is either re-injected successfully or returned to L1 upon a nested
> VMEXIT.
> Make sure to always re-queue such event if returned in EXITINTINFO.
> 
> The handling of L0 -> {L1, L2} event re-injection is left as-is to avoid
> unforeseen regressions.

Some time ago I noticed this too, but haven't dug into this too much.
I rememeber I even had some half-baked patch for this I never posted,
because I didn't think about the possibility of this syntetic injection. 

Just to be clear that I understand this correctly:

1. What is happening is that L1 is injecting INTn/INTO/INT3 but L2 code
   doesn't actualy contain an INTn/INTO/INT3 instruction.
   This is wierd but legal thing to do.
   Again, if L2 actually contained the instruction, it would have worked?


2. When actual INTn/INT0/INT3 are intercepted on SVM, then
   save.RIP points to address of the instruction, and control.next_rip
   points to address of next instruction after (as expected)

3. When EVENTINJ is used with '(TYPE = 3) with vectors 3 or 4'
   or 'TYPE=4', then next_rip is pushed on the stack, while save.RIP is
   pretty much ignored, and exectution jumps to the handler in the IDT.
   also at least for INT3/INTO, PRM states that IDT's DPL field is checked
   before dispatch, meaning that we can get legit #GP during delivery.
   (this looks like another legit reason to fix exception merging in KVM)


Best regards,
	Maxim Levitsky


> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>  arch/x86/kvm/svm/nested.c | 65 +++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/svm/svm.c    | 17 ++++++++--
>  arch/x86/kvm/svm/svm.h    | 47 ++++++++++++++++++++++++++++
>  3 files changed, 125 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 9656f0d6815c..75017bf77955 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -420,8 +420,17 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
>  void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
>  {
>  	u32 mask;
> -	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
> -	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
> +
> +	/*
> +	 * Leave the pending L1 -> L2 event in svm->nested.ctl.event_inj{,err}
> +	 * if its re-injection is needed
> +	 */
> +	if (!exit_during_event_injection(svm, svm->nested.ctl.event_inj,
> +					 svm->nested.ctl.event_inj_err)) {
> +		WARN_ON_ONCE(svm->vmcb->control.event_inj & SVM_EVTINJ_VALID);
> +		svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
> +		svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
> +	}

Beware that this could backfire in regard to nested migration.

I once chased a nasty bug related to this.

The bug was:

- L1 does VMRUN with injection (EVENTINJ set)

- VMRUN exit handler is 'executed' by KVM,
  This copies EVENINJ fields from VMCB12 to VMCB02

- Once VMRUN exit handler is done executing, we exit to userspace to start migration
  (basically static_call(kvm_x86_handle_exit)(...) handles the SVM_EXIT_VMRUN,
   and that is all, vcpu_enter_guest isn't called again, so injection is not canceled)

- migration happens and it migrates the control area of vmcb02 with EVENTINJ fields set.

- on migration target, we inject another interrupt to the guest via EVENTINJ
  because svm_check_nested_events checks nested_run_pending to avoid doing this
  but nested_run_pending was not migrated correctly, 
  and overwrites the EVENTINJ - injection is lost.

Paolo back then proposed to me that instead of doing direct copy from VMCB12 to VMCB02
we should instead go through 'vcpu->arch.interrupt' and such.
I had a prototype of this but never gotten to clean it up to be accepted upstream,
knowing that current way also works.

  


>  
>  	/* Only a few fields of int_ctl are written by the processor.  */
>  	mask = V_IRQ_MASK | V_TPR_MASK;
> @@ -669,6 +678,54 @@ static void nested_svm_copy_common_state(struct vmcb *from_vmcb, struct vmcb *to
>  	to_vmcb->save.spec_ctrl = from_vmcb->save.spec_ctrl;
>  }
>  
> +void nested_svm_maybe_reinject(struct kvm_vcpu *vcpu)

A personal taste note: I don't like the 'maybe' for some reason.
But I won't fight over this.

> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	unsigned int vector, type;
> +	u32 exitintinfo = svm->vmcb->control.exit_int_info;
> +
> +	if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
> +		return;
> +
> +	/*
> +	 * No L1 -> L2 event to re-inject?
> +	 *
> +	 * In this case event_inj will be cleared by
> +	 * nested_sync_control_from_vmcb02().
> +	 */
> +	if (!(svm->nested.ctl.event_inj & SVM_EVTINJ_VALID))
> +		return;
> +
> +	/* If the last event injection was successful there shouldn't be any pending event */
> +	if (WARN_ON_ONCE(!(exitintinfo & SVM_EXITINTINFO_VALID)))
> +		return;
> +
> +	kvm_make_request(KVM_REQ_EVENT, vcpu);
> +
> +	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
> +	type = exitintinfo & SVM_EXITINTINFO_TYPE_MASK;
> +
> +	switch (type) {
> +	case SVM_EXITINTINFO_TYPE_NMI:
> +		vcpu->arch.nmi_injected = true;
> +		break;
> +	case SVM_EXITINTINFO_TYPE_EXEPT:
> +		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR)
> +			kvm_requeue_exception_e(vcpu, vector,
> +						svm->vmcb->control.exit_int_info_err);
> +		else
> +			kvm_requeue_exception(vcpu, vector);
> +		break;
> +	case SVM_EXITINTINFO_TYPE_SOFT:

Note that AFAIK, SVM_EXITINTINFO_TYPE_SOFT is only for INTn instructions,
while INT3 and INTO are considered normal exceptions but EVENTINJ
handling has special case for them.


On VMX it is a bit cleaner:
It has:

3 - normal stock exception caused by CPU itself, like #PF and such
      
4 - INTn
      * does DPL check and uses VM_EXIT_INSTRUCTION_LEN
       
5 - ICEBP/INT1, which SVM doesnt support to re-inject
      * doesn't do DPL check, but uses VM_EXIT_INSTRUCTION_LEN I think

6 - software exception (INT3/INTO)
      * does DPL check and uses VM_EXIT_INSTRUCTION_LEN as well

I don't know if there is any difference between 4 and 6.




> +	case SVM_EXITINTINFO_TYPE_INTR:
> +		kvm_queue_interrupt(vcpu, vector, type == SVM_EXITINTINFO_TYPE_SOFT);
> +		break;
> +	default:
> +		vcpu_unimpl(vcpu, "unknown L1 -> L2 exitintinfo type 0x%x\n", type);
> +		break;
> +	}
> +}
> +
>  int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
>  			 struct vmcb *vmcb12, bool from_vmrun)
>  {
> @@ -898,6 +955,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	if (svm->nrips_enabled)
>  		vmcb12->control.next_rip  = vmcb->control.next_rip;
>  
> +	/* Forget about any pending L1 event injection since it's a L1 worry now */
> +	svm->nested.ctl.event_inj = 0;
> +	svm->nested.ctl.event_inj_err = 0;
> +
>  	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
>  	vmcb12->control.tlb_ctl           = svm->nested.ctl.tlb_ctl;
>  	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1e5d904aeec3..5b128baa5e57 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3322,13 +3322,18 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	WARN_ON(!gif_set(svm));
> +	WARN_ON(!(vcpu->arch.interrupt.soft || gif_set(svm)));
>  
>  	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
>  	++vcpu->stat.irq_injections;
>  
>  	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
> -		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
> +		SVM_EVTINJ_VALID;
> +	if (vcpu->arch.interrupt.soft) {
> +		svm->vmcb->control.event_inj |= SVM_EVTINJ_TYPE_SOFT;
> +	} else {
> +		svm->vmcb->control.event_inj |= SVM_EVTINJ_TYPE_INTR;
> +	}
>  }
>  
>  void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
> @@ -3627,6 +3632,14 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>  	if (!(exitintinfo & SVM_EXITINTINFO_VALID))
>  		return;
>  
> +	/* L1 -> L2 event re-injection needs a different handling */
> +	if (is_guest_mode(vcpu) &&
> +	    exit_during_event_injection(svm, svm->nested.ctl.event_inj,
> +					svm->nested.ctl.event_inj_err)) {
> +		nested_svm_maybe_reinject(vcpu);
> +		return;
> +	}
> +
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>  
>  	vector = exitintinfo & SVM_EXITINTINFO_VEC_MASK;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index f757400fc933..7cafc2e6c82a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -488,6 +488,52 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
>  	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
>  }
>  
> +static inline bool event_inj_same(u32 event_inj1, u32 event_inj_err1,
> +				  u32 event_inj2, u32 event_inj_err2)
> +{
> +	unsigned int vector_1, vector_2, type_1, type_2;
> +
> +	/* Either of them not valid? */
> +	if (!(event_inj1 & SVM_EVTINJ_VALID) ||
> +	    !(event_inj2 & SVM_EVTINJ_VALID))
> +		return false;
> +
> +	vector_1 = event_inj1 & SVM_EVTINJ_VEC_MASK;
> +	type_1 = event_inj1 & SVM_EVTINJ_TYPE_MASK;
> +	vector_2 = event_inj2 & SVM_EVTINJ_VEC_MASK;
> +	type_2 = event_inj2 & SVM_EVTINJ_TYPE_MASK;
> +
> +	/* Different vector or type? */
> +	if (vector_1 != vector_2 || type_1 != type_2)
> +		return false;
> +
> +	/* Different error code presence flag? */
> +	if ((event_inj1 & SVM_EVTINJ_VALID_ERR) !=
> +	    (event_inj2 & SVM_EVTINJ_VALID_ERR))
> +		return false;
> +
> +	/* No error code? */
> +	if (!(event_inj1 & SVM_EVTINJ_VALID_ERR))
> +		return true;
> +
> +	/* Same error code? */
> +	return event_inj_err1 == event_inj_err2;
> +}
> +
> +/* Did the last VMEXIT happen when attempting to inject that event? */
> +static inline bool exit_during_event_injection(struct vcpu_svm *svm,
> +					       u32 event_inj, u32 event_inj_err)
> +{
> +	BUILD_BUG_ON(SVM_EXITINTINFO_VEC_MASK != SVM_EVTINJ_VEC_MASK ||
> +		     SVM_EXITINTINFO_TYPE_MASK != SVM_EVTINJ_TYPE_MASK ||
> +		     SVM_EXITINTINFO_VALID != SVM_EVTINJ_VALID ||
> +		     SVM_EXITINTINFO_VALID_ERR != SVM_EVTINJ_VALID_ERR);
> +
> +	return event_inj_same(svm->vmcb->control.exit_int_info,
> +			      svm->vmcb->control.exit_int_info_err,
> +			      event_inj, event_inj_err);
> +}
> +
>  /* svm.c */
>  #define MSR_INVALID				0xffffffffU
>  
> @@ -540,6 +586,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
>  	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
>  }
>  
> +void nested_svm_maybe_reinject(struct kvm_vcpu *vcpu);
>  int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
>  			 u64 vmcb_gpa, struct vmcb *vmcb12, bool from_vmrun);
>  void svm_leave_nested(struct kvm_vcpu *vcpu);
> 


I will also review Sean's take on this, let see which one is simplier.


Best regards,
	Maxim Levitsky



