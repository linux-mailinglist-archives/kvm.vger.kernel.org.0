Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04FD56CFE0
	for <lists+kvm@lfdr.de>; Sun, 10 Jul 2022 17:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiGJP4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Jul 2022 11:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJP4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Jul 2022 11:56:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5096512A96
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 08:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657468572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L8Cf1mkeLyXW6DIKymdgR6zo5IhIgd+22n56lWrkS+o=;
        b=OCgu2AKWDJOu9MivNQ5rBLKamJyOjQvNmdB0G6gI24AkQKFxJhr0ackCNbq82S1Z7wk4sg
        6+S/OS9FrFjiTF/IhoTZTPz8cXrKLIfAh0cLU/4VL5FU8VYkWpjnCymK9L+hpn2vdNmheH
        2YYKbWADRKJ+/nrRate5fWaM2YiECgk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-5vMntzkZMjC2EMs0EhhGxw-1; Sun, 10 Jul 2022 11:56:09 -0400
X-MC-Unique: 5vMntzkZMjC2EMs0EhhGxw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9953A811E81;
        Sun, 10 Jul 2022 15:56:08 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 774DE492C3B;
        Sun, 10 Jul 2022 15:56:05 +0000 (UTC)
Message-ID: <6fad40967afa4a7ed74c0f4158c8e841b1384318.camel@redhat.com>
Subject: Re: [PATCH v2 17/21] KVM: x86: Morph pending exceptions to pending
 VM-Exits at queue time
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Sun, 10 Jul 2022 18:56:04 +0300
In-Reply-To: <YsY1ud2ZaZq9wvfI@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-18-seanjc@google.com>
         <5eaf496d71b2c8fd321c013c9d1787d4c34d1100.camel@redhat.com>
         <YsY1ud2ZaZq9wvfI@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-07 at 01:24 +0000, Sean Christopherson wrote:
> On Wed, Jul 06, 2022, Maxim Levitsky wrote:
> > > @@ -1618,9 +1620,9 @@ struct kvm_x86_ops {
> > >  
> > >  struct kvm_x86_nested_ops {
> > >         void (*leave_nested)(struct kvm_vcpu *vcpu);
> > > +       bool (*is_exception_vmexit)(struct kvm_vcpu *vcpu, u8 vector,
> > > +                                   u32 error_code);
> > >         int (*check_events)(struct kvm_vcpu *vcpu);
> > > -       bool (*handle_page_fault_workaround)(struct kvm_vcpu *vcpu,
> > > -                                            struct x86_exception *fault);
> > 
> > I think that since this patch is already quite large, it would make sense
> > to split the removal of workaround/hack code to patch after this one?
> 
> Hmm, at a glance it seems doable, but I'd prefer to keep it as a single patch, in
> no small part because I don't want to risking creating a transient bug whether KVM
> blows up during bisection due to some weird interaction.  IMO, keeping the #PF hack
> for a single patch would yield nonsensical code for that one patch.  It's a lot of
> code, but logically the changes are very much a single thing.

Let it be then. I don't have a strong preference on this matter.

> 
> > > @@ -3870,14 +3845,24 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
> > >   * from the emulator (because such #DBs are fault-like and thus don't trigger
> > >   * actions that fire on instruction retire).
> > >   */
> > > -static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
> > > +static unsigned long vmx_get_pending_dbg_trap(struct kvm_queued_exception *ex)
> > Any reason to remove the inline?
> 
> Mainly to avoid an unnecessarily long line, and because generally speaking local
> static functions shouldn't be tagged inline.  The compiler is almost always smarter
> than humans when it comes to inlining (or not).

Makes sense.

> 
> > >  {
> > > -       if (!vcpu->arch.exception.pending ||
> > > -           vcpu->arch.exception.vector != DB_VECTOR)
> > > +       if (!ex->pending || ex->vector != DB_VECTOR)
> > >                 return 0;
> > >  
> > >         /* General Detect #DBs are always fault-like. */
> > > -       return vcpu->arch.exception.payload & ~DR6_BD;
> > > +       return ex->payload & ~DR6_BD;
> > > +}
> 
> ...
> 
> > This comment also probably should go to a separate patch to reduce this patch size.
> 
> I'll split it out.
> 
> > Other than that, this is a _very_ good idea to add it to KVM, although
> > maybe we should put it in Documentation folder instead?
> > (but I don't have a strong preference on this)
> 
> I definitely want a comment in KVM that's relatively close to the code.  I'm not
> opposed to also adding something in Documentation, but I'd want that to be an "and"
> not an "or".

Also makes sense. 

I do think that it is worthwhile to also add a comment about the way KVM
handles exceptions, which means that inject_pending_event is not always called on instruction
boundary. When we have a pending/injected exception we have first to get rid of it,
and only then we will be on instruction boundary.

And to be sure that we will inject pending interrupts on the closest instruction
boundary, we actually open an interrupt/smi/nmi window there.

> 
> > >  static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> > >  {
> > >         struct kvm_lapic *apic = vcpu->arch.apic;
> > >         struct vcpu_vmx *vmx = to_vmx(vcpu);
> > > -       unsigned long exit_qual;
> > >         /*
> > >          * Only a pending nested run blocks a pending exception.  If there is a
> > >          * previously injected event, the pending exception occurred while said
> > > @@ -3943,19 +4011,20 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> > >                 /* Fallthrough, the SIPI is completely ignored. */
> > >         }
> > >  
> > > -       /*
> > > -        * Process exceptions that are higher priority than Monitor Trap Flag:
> > > -        * fault-like exceptions, TSS T flag #DB (not emulated by KVM, but
> > > -        * could theoretically come in from userspace), and ICEBP (INT1).
> > > -        */
> > > +       if (vcpu->arch.exception_vmexit.pending &&
> > > +           !vmx_is_low_priority_db_trap(&vcpu->arch.exception_vmexit)) {
> > > +               if (block_nested_exceptions)
> > > +                       return -EBUSY;
> > > +
> > > +               nested_vmx_inject_exception_vmexit(vcpu);
> > > +               return 0;
> > > +       }
> > > +
> > >         if (vcpu->arch.exception.pending &&
> > > -           !(vmx_get_pending_dbg_trap(vcpu) & ~DR6_BT)) {
> > > +           !vmx_is_low_priority_db_trap(&vcpu->arch.exception)) {
> > Small nitpick: vmx_is_low_priority_db_trap refactoring could be done in a separate patch
> 
> Ya, will do.  No idea why I didn't do that.
> 
> > + Maybe it would be nice to add a WARN_ON_ONCE check here that this exception
> > is not intercepted by the guest
> > 
> > >                 if (block_nested_exceptions)
> > >                         return -EBUSY;
> > > -               if (!nested_vmx_check_exception(vcpu, &exit_qual))
> > > -                       goto no_vmexit;
> > > -               nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
> > > -               return 0;
> > > +               goto no_vmexit;
> > >         }
> > >  
> > >         if (vmx->nested.mtf_pending) {
> > > @@ -3966,13 +4035,18 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> > >                 return 0;
> > >         }
> > >  
> > > +       if (vcpu->arch.exception_vmexit.pending) {
> > > +               if (block_nested_exceptions)
> > > +                       return -EBUSY;
> > 
> > And here add a WARN_ON_ONCE check that it is intercepted.
> 
> I like the idea of sanity check, but I really don't want to splatter them in both
> VMX and SVM, and it's a bit kludgy to implement the checks in common code.  I'll
> play with it and see if I can figure out a decent solution.

Makes sense, that is what I am thinking as well, I also don't have a strong preference
on this case.

> 
> > > @@ -618,18 +633,31 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
> > >  
> > >         kvm_make_request(KVM_REQ_EVENT, vcpu);
> > >  
> > > +       /*
> > > +        * If the exception is destined for L2 and isn't being reinjected,
> > > +        * morph it to a VM-Exit if L1 wants to intercept the exception.  A
> > > +        * previously injected exception is not checked because it was checked
> > > +        * when it was original queued, and re-checking is incorrect if _L1_
> > > +        * injected the exception, in which case it's exempt from interception.
> > > +        */
> > > +       if (!reinject && is_guest_mode(vcpu) &&
> > > +           kvm_x86_ops.nested_ops->is_exception_vmexit(vcpu, nr, error_code)) {
> > > +               kvm_queue_exception_vmexit(vcpu, nr, has_error, error_code,
> > > +                                          has_payload, payload);
> > > +               return;
> > > +       }
> > > +
> > >         if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
> > >         queue:
> > >                 if (reinject) {
> > >                         /*
> > > -                        * On vmentry, vcpu->arch.exception.pending is only
> > > -                        * true if an event injection was blocked by
> > > -                        * nested_run_pending.  In that case, however,
> > > -                        * vcpu_enter_guest requests an immediate exit,
> > > -                        * and the guest shouldn't proceed far enough to
> > > -                        * need reinjection.
> > > +                        * On VM-Entry, an exception can be pending if and only
> > > +                        * if event injection was blocked by nested_run_pending.
> > > +                        * In that case, however, vcpu_enter_guest() requests an
> > > +                        * immediate exit, and the guest shouldn't proceed far
> > > +                        * enough to need reinjection.
> > 
> > Now that I had read the Jim's document on event priorities, I think we can
> > update the comment:
> > 
> > On VMX we set expired preemption timer, and on SVM we do self IPI, thus pend a real interrupt.
> > Both events should have higher priority than processing the injected event
> 
> No, they don't.  Injected events (exceptions, IRQs, NMIs, etc...) "occur" as part
> of the VMRUN/VMLAUNCH/VMRESUME, i.e. are vectored before an interrupt window is
> opened at the next instruction boundary. 
>  E.g. if the hypervisor intercepts an
> exception and then reflects it back into the guest, any pending event must not be
> recognized until after the injected exception is delivered, otherwise the event
> would, from the guest's perspective, arrive in the middle of an instruction.

Yes I was afraid that I didn't understand that correctly.

> 
> This is calling out something slightly different.  What it's saying is that if
> there was a pending exception, then KVM should _not_ have injected said pending
> exception and instead should have requested an immediate exit.  That "immediate
> exit" should have forced a VM-Exit before the CPU could fetch a new instruction,
> and thus before the guest could trigger an exception that would require reinjection.
> 
> The "immediate exit" trick works because all events with higher priority than the
> VMX preeemption timer (or IRQ) are guaranteed to exit, e.g. a hardware SMI can't
> cause a fault in the guest.

Yes it all makes sense now. It really helps thinking in terms of instruction boundary.

However, that makes me think: Can that actually happen?

A pending exception can only be generated by KVM itself (nested hypervisor,
and CPU reflected exceptions/interrupts are all injected).

If VMRUN/VMRESUME has a pending exception, it means that it itself generated it,
in which case we won't be entering the guest, but rather jump to the
exception handler, and thus nested run will not be pending.

We can though have pending NMI/SMI/interrupts.

Also just a note about injected exceptions/interrupts during VMRUN/VMRESUME.

If nested_run_pending is true, then the injected exception due to the same
reasoning can not come from VMRUN/VMRESUME. It can come from nested hypevisor's EVENTINJ,
but in this case we currently just copy it from vmcb12/vmcs12 to vmcb02/vmcs02,
without touching vcpu->arch.interrupt.

Luckily this doesn't cause issues because when the nested run is pending
we don't inject anything to the guest.

If nested_run_pending is false however, the opposite is true. The EVENTINJ
will be already delivered, and we can only have injected exception/interrupt
that come from the cpu itself via exit_int_info/IDT_VECTORING_INFO_FIELD which
we will copy back as injected interrupt/exception to 'vcpu->arch.exception/interrupt'.
and later re-inject, next time we run the same VMRUN instruction.

> 
> Though there might be an edge case with vmcs12.GUEST_PENDING_DBG_EXCEPTIONS that
> could result in a #DB => #PF interception + reinjection when using shadow paging.
> Maybe.

x86 is a fractal :(

> 
> > (This is something I didn't find in the Intel/AMD docs, so I might be wrong here)
> > thus the CPU will not attempt to process the injected event 
> > (via EVENTINJ on SVM, or via VM_ENTRY_INTR_INFO_FIELD) and instead just straight copy
> > them back to exit_int_info/IDT_VECTORING_INFO_FIELD)
> > 
> > So in this case the event will actually be re-injected, but no new exception can
> > be generated since we will re-execute the VMRUN/VMRESUME instruction.
> > 
> > 
> > >                          */
> > > -                       WARN_ON_ONCE(vcpu->arch.exception.pending);
> > > +                       WARN_ON_ONCE(kvm_is_exception_pending(vcpu));
> > >                         vcpu->arch.exception.injected = true;
> > >                         if (WARN_ON_ONCE(has_payload)) {
> > >                                 /*
> > > @@ -732,20 +760,22 @@ static int complete_emulated_insn_gp(struct kvm_vcpu *vcpu, int err)
> > >  void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
> > >  {
> > >         ++vcpu->stat.pf_guest;
> > > -       vcpu->arch.exception.nested_apf =
> > > -               is_guest_mode(vcpu) && fault->async_page_fault;
> > > -       if (vcpu->arch.exception.nested_apf) {
> > > -               vcpu->arch.apf.nested_apf_token = fault->address;
> > > -               kvm_queue_exception_e(vcpu, PF_VECTOR, fault->error_code);
> > > -       } else {
> > > +
> > > +       /*
> > > +        * Async #PF in L2 is always forwarded to L1 as a VM-Exit regardless of
> > > +        * whether or not L1 wants to intercept "regular" #PF.
> > 
> > We might want to also mention that the L1 has to opt-in to this
> > (vcpu->arch.apf.delivery_as_pf_vmexit), but the fact that we are
> > here, means that it did opt-in
> > 
> > (otherwise kvm_can_deliver_async_pf won't return true).
> > 
> > A WARN_ON_ONCE(!vcpu->arch.apf.delivery_as_pf_vmexit) would be
> > nice to also check this in the runtime.
> 
> Eh, I'm not convinced this would be a worthwhile WARN, the logic is fully contained
> in kvm_can_deliver_async_pf() and I don't see that changing, i.e. odds of breaking
> this are very, very low.  At some point we just have to trust that we don't suck
> that much :-)

Agree, but my goal was more to add this warning as a form of a documentation
and not to make it catch a bug.


> 
> > Also note that AFAIK, qemu doesn't opt-in for this feature sadly,
> > thus this code is not tested (unless there is some unit test).
> > 
> > 
> > > +        */
> > > +       if (is_guest_mode(vcpu) && fault->async_page_fault)
> > > +               kvm_queue_exception_vmexit(vcpu, PF_VECTOR,
> > > +                                          true, fault->error_code,
> > > +                                          true, fault->address);
> > > +       else
> > >                 kvm_queue_exception_e_p(vcpu, PF_VECTOR, fault->error_code,
> > >                                         fault->address);
> > > -       }
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
> > >  
> > > -/* Returns true if the page fault was immediately morphed into a VM-Exit. */
> > > -bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
> > > +void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
> > >                                     struct x86_exception *fault)
> > >  {
> > >         struct kvm_mmu *fault_mmu;
> > > @@ -763,26 +793,7 @@ bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
> > >                 kvm_mmu_invalidate_gva(vcpu, fault_mmu, fault->address,
> > >                                        fault_mmu->root.hpa);
> > >  
> > > -       /*
> > > -        * A workaround for KVM's bad exception handling.  If KVM injected an
> > > -        * exception into L2, and L2 encountered a #PF while vectoring the
> > > -        * injected exception, manually check to see if L1 wants to intercept
> > > -        * #PF, otherwise queuing the #PF will lead to #DF or a lost exception.
> > > -        * In all other cases, defer the check to nested_ops->check_events(),
> > > -        * which will correctly handle priority (this does not).  Note, other
> > > -        * exceptions, e.g. #GP, are theoretically affected, #PF is simply the
> > > -        * most problematic, e.g. when L0 and L1 are both intercepting #PF for
> > > -        * shadow paging.
> > > -        *
> > > -        * TODO: Rewrite exception handling to track injected and pending
> > > -        *       (VM-Exit) exceptions separately.
> > > -        */
> > > -       if (unlikely(vcpu->arch.exception.injected && is_guest_mode(vcpu)) &&
> > > -           kvm_x86_ops.nested_ops->handle_page_fault_workaround(vcpu, fault))
> > > -               return true;
> > > -
> > >         fault_mmu->inject_page_fault(vcpu, fault);
> > > -       return false;
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);
> > >  
> > > @@ -4752,7 +4763,7 @@ static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
> > >         return (kvm_arch_interrupt_allowed(vcpu) &&
> > >                 kvm_cpu_accept_dm_intr(vcpu) &&
> > >                 !kvm_event_needs_reinjection(vcpu) &&
> > > -               !vcpu->arch.exception.pending);
> > > +               !kvm_is_exception_pending(vcpu));
> > >  }
> > >  
> > >  static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
> > > @@ -4881,13 +4892,27 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
> > >  static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
> > >                                                struct kvm_vcpu_events *events)
> > >  {
> > > -       struct kvm_queued_exception *ex = &vcpu->arch.exception;
> > > +       struct kvm_queued_exception *ex;
> > >  
> > >         process_nmi(vcpu);
> > >  
> > >         if (kvm_check_request(KVM_REQ_SMI, vcpu))
> > >                 process_smi(vcpu);
> > >  
> > > +       /*
> > > +        * KVM's ABI only allows for one exception to be migrated.  Luckily,
> > > +        * the only time there can be two queued exceptions is if there's a
> > > +        * non-exiting _injected_ exception, and a pending exiting exception.
> > > +        * In that case, ignore the VM-Exiting exception as it's an extension
> > > +        * of the injected exception.
> > > +        */
> > 
> > I think that we will lose the injected exception, thus will only deliver after
> > the migration the VM-exiting exception but without the correct IDT_VECTORING_INFO_FIELD/exit_int_info.
> > 
> > It's not that big deal and can be fixed by extending this API, with a new cap,
> > as I did in my patches. This can be done later, but the above comment
> > which tries to justify it, should be updated to mention that it is wrong.
> 
> No?  The below will migrate the pending VM-Exit if and only if there's no pending
> or injected exception.  

I missed that part.

BTW, another thing to note that there can't be two pending exceptions, because
pending exceptions can only be generated by KVM, and as long as it is not injected,
there can be no new pending exception generated.

Same for pending interrupt + pending exception, as long as we didn't inject the interrupt
we won't get any new exception.



> The pending VM-Exit is dropped, and in theory could be
> lost if something fixes the underlying exception (that results in VM-Exit) before
> the guest is resumed, but that's ok.  If the exception was somehow fixed then the
> exception was inherently non-deterministic anyways, i.e. the guest can't have
> guaranteed that it would occur.
> 
> Or did I misunderstand?

No, it looks reasonable now.

So basically you are saying that we have an injected exception/interrupt,
and during the injection we got another exception (only exception possible).

If we inject the exception again, we should get the nested exception again,
unless it was non deterministic (e.g #MC or page fault that was fixed
somehow during migration), and it indeed looks OK to drop the nested exception
in this case.

As usual there could be corner cases, similar on how recently a case
of nested hypervisor injecting a software interrupt on RIP that doesn't contain
INTn instruction was fixed, which was wrong before the fix when we just re-executed the instruction,
but all of this is a corner case of a corner case of a corner case, so I fully approve it.

It is 3 times corner case because:

1. Nested exceptions are a corner case.
2. Migrating right when a nested exception happened is a corner case.
3. Somehow losing that vmexit would be a corner case as well.


Best regards,
	Maxim Levitsky

> 
> > > +       if (vcpu->arch.exception_vmexit.pending &&
> > > +           !vcpu->arch.exception.pending &&
> > > +           !vcpu->arch.exception.injected)
> > > +               ex = &vcpu->arch.exception_vmexit;
> > > +       else
> > > +               ex = &vcpu->arch.exception;


