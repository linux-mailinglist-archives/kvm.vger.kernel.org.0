Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850DC56975C
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 03:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiGGBYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 21:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiGGBYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 21:24:16 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0A12E69D
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 18:24:14 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id e16so3560712pfm.11
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 18:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jm6MNJ4PUeFGXCysHHlUvWN5v/r1IZgjyPPIqu8Gq+Q=;
        b=J+lg/ay9COuQmgl/sC4wOhbAs5ZmvxHh7mh8gKQMluH0rudvbNzX0EpWZAwyi1I29/
         7MTwvEJZR79d3n4CLE3FATyP0MgVJKSaJXW1FhpN2p5juERqwxbMMETELeoorujYvrqU
         TqRK/RF++T2KsPL5i27b0kId/ljkMhng1wX3oKjx1T4ZqfbtCaIgn9sCHDmFnSjpUe3u
         E+LFuKspjRjRZITy53HJZgfjtX1JNBn2AGcha33gr4jMHfdWJSKwvo/FfJRmyjHPRmmq
         12HPgHnBgf6FvQVlzGFxoI8R8orhtsWwPvJcXl7I3rN+doG0DKwEv60ICDOvHtuiX14M
         +Q2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jm6MNJ4PUeFGXCysHHlUvWN5v/r1IZgjyPPIqu8Gq+Q=;
        b=pRotXNgPK7mahWoMDdwNoxJVWFUHxMOq9Frg0qwOHYBv9gVhgGwxKH1IX2iP2Xh7A8
         gWA9A+isNA6QfPMlPR3BJeitnIhgD+JS6pSGCr7ehA6hi5oSwTYeEmKFOkv5QmauQhIW
         4ZgjyiOKWTfjRNWY+RK8oqQyv1jqbGyOiJB688etL2tf0f4jjAiN9Da/dIVtjQoVwCst
         xf4PL7wy+LuJJfNukDjjNKpQpCLgQ263a4is8JW4YUNpYQbs+fLyvqfezicAJkF5WIXp
         IFjULaTu/u+6eVCPUKEDnirp5oG7yb1SMb+lOkyFllypoF6p4AnXfYAJI1G1pMjjoD/n
         bEpQ==
X-Gm-Message-State: AJIora9CT96VWBIyDWaTpK/w9V7bnvMbZu9+vcSU8C26bz71RlnAYNEX
        91rjnqPhXGxIsI+Y2WbDDQd8gg==
X-Google-Smtp-Source: AGRyM1te5gRmdptsT0znO/K3dDQVEhCDlihM5xaOgJmfPMN6HLYr/tvffuIZqqYEH+8fZieoekHrGA==
X-Received: by 2002:aa7:8890:0:b0:525:85db:c0d1 with SMTP id z16-20020aa78890000000b0052585dbc0d1mr50903584pfe.69.1657157053713;
        Wed, 06 Jul 2022 18:24:13 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id u17-20020a170902e5d100b0016bea2a0a8dsm6579200plf.91.2022.07.06.18.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 18:24:13 -0700 (PDT)
Date:   Thu, 7 Jul 2022 01:24:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2 17/21] KVM: x86: Morph pending exceptions to pending
 VM-Exits at queue time
Message-ID: <YsY1ud2ZaZq9wvfI@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
 <20220614204730.3359543-18-seanjc@google.com>
 <5eaf496d71b2c8fd321c013c9d1787d4c34d1100.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eaf496d71b2c8fd321c013c9d1787d4c34d1100.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022, Maxim Levitsky wrote:
> > @@ -1618,9 +1620,9 @@ struct kvm_x86_ops {
> >  
> >  struct kvm_x86_nested_ops {
> >         void (*leave_nested)(struct kvm_vcpu *vcpu);
> > +       bool (*is_exception_vmexit)(struct kvm_vcpu *vcpu, u8 vector,
> > +                                   u32 error_code);
> >         int (*check_events)(struct kvm_vcpu *vcpu);
> > -       bool (*handle_page_fault_workaround)(struct kvm_vcpu *vcpu,
> > -                                            struct x86_exception *fault);
> 
> I think that since this patch is already quite large, it would make sense
> to split the removal of workaround/hack code to patch after this one?

Hmm, at a glance it seems doable, but I'd prefer to keep it as a single patch, in
no small part because I don't want to risking creating a transient bug whether KVM
blows up during bisection due to some weird interaction.  IMO, keeping the #PF hack
for a single patch would yield nonsensical code for that one patch.  It's a lot of
code, but logically the changes are very much a single thing.

> > @@ -3870,14 +3845,24 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
> >   * from the emulator (because such #DBs are fault-like and thus don't trigger
> >   * actions that fire on instruction retire).
> >   */
> > -static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
> > +static unsigned long vmx_get_pending_dbg_trap(struct kvm_queued_exception *ex)
> Any reason to remove the inline?

Mainly to avoid an unnecessarily long line, and because generally speaking local
static functions shouldn't be tagged inline.  The compiler is almost always smarter
than humans when it comes to inlining (or not).

> >  {
> > -       if (!vcpu->arch.exception.pending ||
> > -           vcpu->arch.exception.vector != DB_VECTOR)
> > +       if (!ex->pending || ex->vector != DB_VECTOR)
> >                 return 0;
> >  
> >         /* General Detect #DBs are always fault-like. */
> > -       return vcpu->arch.exception.payload & ~DR6_BD;
> > +       return ex->payload & ~DR6_BD;
> > +}

...

> This comment also probably should go to a separate patch to reduce this patch size.

I'll split it out.

> Other than that, this is a _very_ good idea to add it to KVM, although
> maybe we should put it in Documentation folder instead?
> (but I don't have a strong preference on this)

I definitely want a comment in KVM that's relatively close to the code.  I'm not
opposed to also adding something in Documentation, but I'd want that to be an "and"
not an "or".

> >  static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> >  {
> >         struct kvm_lapic *apic = vcpu->arch.apic;
> >         struct vcpu_vmx *vmx = to_vmx(vcpu);
> > -       unsigned long exit_qual;
> >         /*
> >          * Only a pending nested run blocks a pending exception.  If there is a
> >          * previously injected event, the pending exception occurred while said
> > @@ -3943,19 +4011,20 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> >                 /* Fallthrough, the SIPI is completely ignored. */
> >         }
> >  
> > -       /*
> > -        * Process exceptions that are higher priority than Monitor Trap Flag:
> > -        * fault-like exceptions, TSS T flag #DB (not emulated by KVM, but
> > -        * could theoretically come in from userspace), and ICEBP (INT1).
> > -        */
> > +       if (vcpu->arch.exception_vmexit.pending &&
> > +           !vmx_is_low_priority_db_trap(&vcpu->arch.exception_vmexit)) {
> > +               if (block_nested_exceptions)
> > +                       return -EBUSY;
> > +
> > +               nested_vmx_inject_exception_vmexit(vcpu);
> > +               return 0;
> > +       }
> 
> > +
> >         if (vcpu->arch.exception.pending &&
> > -           !(vmx_get_pending_dbg_trap(vcpu) & ~DR6_BT)) {
> > +           !vmx_is_low_priority_db_trap(&vcpu->arch.exception)) {
> Small nitpick: vmx_is_low_priority_db_trap refactoring could be done in a separate patch

Ya, will do.  No idea why I didn't do that.

> + Maybe it would be nice to add a WARN_ON_ONCE check here that this exception
> is not intercepted by the guest
>
> >                 if (block_nested_exceptions)
> >                         return -EBUSY;
> > -               if (!nested_vmx_check_exception(vcpu, &exit_qual))
> > -                       goto no_vmexit;
> > -               nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
> > -               return 0;
> > +               goto no_vmexit;
> >         }
> >  
> >         if (vmx->nested.mtf_pending) {
> > @@ -3966,13 +4035,18 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> >                 return 0;
> >         }
> >  
> > +       if (vcpu->arch.exception_vmexit.pending) {
> > +               if (block_nested_exceptions)
> > +                       return -EBUSY;
> 
> And here add a WARN_ON_ONCE check that it is intercepted.

I like the idea of sanity check, but I really don't want to splatter them in both
VMX and SVM, and it's a bit kludgy to implement the checks in common code.  I'll
play with it and see if I can figure out a decent solution.

> > @@ -618,18 +633,31 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
> >  
> >         kvm_make_request(KVM_REQ_EVENT, vcpu);
> >  
> > +       /*
> > +        * If the exception is destined for L2 and isn't being reinjected,
> > +        * morph it to a VM-Exit if L1 wants to intercept the exception.  A
> > +        * previously injected exception is not checked because it was checked
> > +        * when it was original queued, and re-checking is incorrect if _L1_
> > +        * injected the exception, in which case it's exempt from interception.
> > +        */
> > +       if (!reinject && is_guest_mode(vcpu) &&
> > +           kvm_x86_ops.nested_ops->is_exception_vmexit(vcpu, nr, error_code)) {
> > +               kvm_queue_exception_vmexit(vcpu, nr, has_error, error_code,
> > +                                          has_payload, payload);
> > +               return;
> > +       }
> > +
> >         if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
> >         queue:
> >                 if (reinject) {
> >                         /*
> > -                        * On vmentry, vcpu->arch.exception.pending is only
> > -                        * true if an event injection was blocked by
> > -                        * nested_run_pending.  In that case, however,
> > -                        * vcpu_enter_guest requests an immediate exit,
> > -                        * and the guest shouldn't proceed far enough to
> > -                        * need reinjection.
> > +                        * On VM-Entry, an exception can be pending if and only
> > +                        * if event injection was blocked by nested_run_pending.
> > +                        * In that case, however, vcpu_enter_guest() requests an
> > +                        * immediate exit, and the guest shouldn't proceed far
> > +                        * enough to need reinjection.
> 
> Now that I had read the Jim's document on event priorities, I think we can
> update the comment:
>
> On VMX we set expired preemption timer, and on SVM we do self IPI, thus pend a real interrupt.
> Both events should have higher priority than processing the injected event

No, they don't.  Injected events (exceptions, IRQs, NMIs, etc...) "occur" as part
of the VMRUN/VMLAUNCH/VMRESUME, i.e. are vectored before an interrupt window is
opened at the next instruction boundary.  E.g. if the hypervisor intercepts an
exception and then reflects it back into the guest, any pending event must not be
recognized until after the injected exception is delivered, otherwise the event
would, from the guest's perspective, arrive in the middle of an instruction.

This is calling out something slightly different.  What it's saying is that if
there was a pending exception, then KVM should _not_ have injected said pending
exception and instead should have requested an immediate exit.  That "immediate
exit" should have forced a VM-Exit before the CPU could fetch a new instruction,
and thus before the guest could trigger an exception that would require reinjection.

The "immediate exit" trick works because all events with higher priority than the
VMX preeemption timer (or IRQ) are guaranteed to exit, e.g. a hardware SMI can't
cause a fault in the guest.

Though there might be an edge case with vmcs12.GUEST_PENDING_DBG_EXCEPTIONS that
could result in a #DB => #PF interception + reinjection when using shadow paging.
Maybe.

> (This is something I didn't find in the Intel/AMD docs, so I might be wrong here)
> thus the CPU will not attempt to process the injected event 
> (via EVENTINJ on SVM, or via VM_ENTRY_INTR_INFO_FIELD) and instead just straight copy
> them back to exit_int_info/IDT_VECTORING_INFO_FIELD)
> 
> So in this case the event will actually be re-injected, but no new exception can
> be generated since we will re-execute the VMRUN/VMRESUME instruction.
> 
> 
> >                          */
> > -                       WARN_ON_ONCE(vcpu->arch.exception.pending);
> > +                       WARN_ON_ONCE(kvm_is_exception_pending(vcpu));
> >                         vcpu->arch.exception.injected = true;
> >                         if (WARN_ON_ONCE(has_payload)) {
> >                                 /*
> > @@ -732,20 +760,22 @@ static int complete_emulated_insn_gp(struct kvm_vcpu *vcpu, int err)
> >  void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
> >  {
> >         ++vcpu->stat.pf_guest;
> > -       vcpu->arch.exception.nested_apf =
> > -               is_guest_mode(vcpu) && fault->async_page_fault;
> > -       if (vcpu->arch.exception.nested_apf) {
> > -               vcpu->arch.apf.nested_apf_token = fault->address;
> > -               kvm_queue_exception_e(vcpu, PF_VECTOR, fault->error_code);
> > -       } else {
> > +
> > +       /*
> > +        * Async #PF in L2 is always forwarded to L1 as a VM-Exit regardless of
> > +        * whether or not L1 wants to intercept "regular" #PF.
> 
> We might want to also mention that the L1 has to opt-in to this
> (vcpu->arch.apf.delivery_as_pf_vmexit), but the fact that we are
> here, means that it did opt-in
> 
> (otherwise kvm_can_deliver_async_pf won't return true).
> 
> A WARN_ON_ONCE(!vcpu->arch.apf.delivery_as_pf_vmexit) would be
> nice to also check this in the runtime.

Eh, I'm not convinced this would be a worthwhile WARN, the logic is fully contained
in kvm_can_deliver_async_pf() and I don't see that changing, i.e. odds of breaking
this are very, very low.  At some point we just have to trust that we don't suck
that much :-)

> Also note that AFAIK, qemu doesn't opt-in for this feature sadly,
> thus this code is not tested (unless there is some unit test).
> 
> 
> > +        */
> > +       if (is_guest_mode(vcpu) && fault->async_page_fault)
> > +               kvm_queue_exception_vmexit(vcpu, PF_VECTOR,
> > +                                          true, fault->error_code,
> > +                                          true, fault->address);
> > +       else
> >                 kvm_queue_exception_e_p(vcpu, PF_VECTOR, fault->error_code,
> >                                         fault->address);
> > -       }
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
> >  
> > -/* Returns true if the page fault was immediately morphed into a VM-Exit. */
> > -bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
> > +void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
> >                                     struct x86_exception *fault)
> >  {
> >         struct kvm_mmu *fault_mmu;
> > @@ -763,26 +793,7 @@ bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
> >                 kvm_mmu_invalidate_gva(vcpu, fault_mmu, fault->address,
> >                                        fault_mmu->root.hpa);
> >  
> > -       /*
> > -        * A workaround for KVM's bad exception handling.  If KVM injected an
> > -        * exception into L2, and L2 encountered a #PF while vectoring the
> > -        * injected exception, manually check to see if L1 wants to intercept
> > -        * #PF, otherwise queuing the #PF will lead to #DF or a lost exception.
> > -        * In all other cases, defer the check to nested_ops->check_events(),
> > -        * which will correctly handle priority (this does not).  Note, other
> > -        * exceptions, e.g. #GP, are theoretically affected, #PF is simply the
> > -        * most problematic, e.g. when L0 and L1 are both intercepting #PF for
> > -        * shadow paging.
> > -        *
> > -        * TODO: Rewrite exception handling to track injected and pending
> > -        *       (VM-Exit) exceptions separately.
> > -        */
> > -       if (unlikely(vcpu->arch.exception.injected && is_guest_mode(vcpu)) &&
> > -           kvm_x86_ops.nested_ops->handle_page_fault_workaround(vcpu, fault))
> > -               return true;
> > -
> >         fault_mmu->inject_page_fault(vcpu, fault);
> > -       return false;
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);
> >  
> > @@ -4752,7 +4763,7 @@ static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
> >         return (kvm_arch_interrupt_allowed(vcpu) &&
> >                 kvm_cpu_accept_dm_intr(vcpu) &&
> >                 !kvm_event_needs_reinjection(vcpu) &&
> > -               !vcpu->arch.exception.pending);
> > +               !kvm_is_exception_pending(vcpu));
> >  }
> >  
> >  static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
> > @@ -4881,13 +4892,27 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
> >  static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
> >                                                struct kvm_vcpu_events *events)
> >  {
> > -       struct kvm_queued_exception *ex = &vcpu->arch.exception;
> > +       struct kvm_queued_exception *ex;
> >  
> >         process_nmi(vcpu);
> >  
> >         if (kvm_check_request(KVM_REQ_SMI, vcpu))
> >                 process_smi(vcpu);
> >  
> > +       /*
> > +        * KVM's ABI only allows for one exception to be migrated.  Luckily,
> > +        * the only time there can be two queued exceptions is if there's a
> > +        * non-exiting _injected_ exception, and a pending exiting exception.
> > +        * In that case, ignore the VM-Exiting exception as it's an extension
> > +        * of the injected exception.
> > +        */
> 
> I think that we will lose the injected exception, thus will only deliver after
> the migration the VM-exiting exception but without the correct IDT_VECTORING_INFO_FIELD/exit_int_info.
> 
> It's not that big deal and can be fixed by extending this API, with a new cap,
> as I did in my patches. This can be done later, but the above comment
> which tries to justify it, should be updated to mention that it is wrong.

No?  The below will migrate the pending VM-Exit if and only if there's no pending
or injected exception.  The pending VM-Exit is dropped, and in theory could be
lost if something fixes the underlying exception (that results in VM-Exit) before
the guest is resumed, but that's ok.  If the exception was somehow fixed then the
exception was inherently non-deterministic anyways, i.e. the guest can't have
guaranteed that it would occur.

Or did I misunderstand?

> > +       if (vcpu->arch.exception_vmexit.pending &&
> > +           !vcpu->arch.exception.pending &&
> > +           !vcpu->arch.exception.injected)
> > +               ex = &vcpu->arch.exception_vmexit;
> > +       else
> > +               ex = &vcpu->arch.exception;
