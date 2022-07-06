Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890AD56881D
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 14:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbiGFMQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 08:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbiGFMQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 08:16:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C4282DDB
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 05:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657109761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cN3fCY/jZRtiSP1AVvOHIw5q3A4ya2jQsTFhAtE4dV8=;
        b=a6ddhKny5nTdfamWGBQKGh+ZPrbUywR1O0FoFSx+h7l8lufyCyLVnblRFm8MbxD15GSdTn
        lG3lLbGikedXs2niUCx8VT0GryiTZ0gABdOBqsOmM+7suoRR1bVGRMr8mUsN8iOWuHqFeN
        6oE72jXZMUkIo7kDymRkvvjnWxeqRjU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-OwPprUC_Pbmpz5Xa-TW3ug-1; Wed, 06 Jul 2022 08:15:56 -0400
X-MC-Unique: OwPprUC_Pbmpz5Xa-TW3ug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C49FD9389C4;
        Wed,  6 Jul 2022 12:15:55 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F11422166B26;
        Wed,  6 Jul 2022 12:15:52 +0000 (UTC)
Message-ID: <5eaf496d71b2c8fd321c013c9d1787d4c34d1100.camel@redhat.com>
Subject: Re: [PATCH v2 17/21] KVM: x86: Morph pending exceptions to pending
 VM-Exits at queue time
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 15:15:51 +0300
In-Reply-To: <20220614204730.3359543-18-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-18-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Morph pending exceptions to pending VM-Exits (due to interception) when
> the exception is queued instead of waiting until nested events are
> checked at VM-Entry.  This fixes a longstanding bug where KVM fails to
> handle an exception that occurs during delivery of a previous exception,
> KVM (L0) and L1 both want to intercept the exception (e.g. #PF for shadow
> paging), and KVM determines that the exception is in the guest's domain,
> i.e. queues the new exception for L2.  Deferring the interception check
> causes KVM to esclate various combinations of injected+pending exceptions
> to double fault (#DF) without consulting L1's interception desires, and
> ends up injecting a spurious #DF into L2.
> 
> KVM has fudged around the issue for #PF by special casing emulated #PF
> injection for shadow paging, but the underlying issue is not unique to
> shadow paging in L0, e.g. if KVM is intercepting #PF because the guest
> has a smaller maxphyaddr and L1 (but not L0) is using shadow paging.
> Other exceptions are affected as well, e.g. if KVM is intercepting #GP
> for one of SVM's workaround or for the VMware backdoor emulation stuff.
> The other cases have gone unnoticed because the #DF is spurious if and
> only if L1 resolves the exception, e.g. KVM's goofs go unnoticed if L1
> would have injected #DF anyways.
> 
> The hack-a-fix has also led to ugly code, e.g. bailing from the emulator
> if #PF injection forced a nested VM-Exit and the emulator finds itself
> back in L1.  Allowing for direct-to-VM-Exit queueing also neatly solves
> the async #PF in L2 mess; no need to set a magic flag and token, simply
> queue a #PF nested VM-Exit.
> 
> Deal with event migration by flagging that a pending exception was queued
> by userspace and check for interception at the next KVM_RUN, e.g. so that
> KVM does the right thing regardless of the order in which userspace
> restores nested state vs. event state.
> 
> When "getting" events from userspace, simply drop any pending excpetion
> that is destined to be intercepted if there is also an injected exception
> to be migrated.  Ideally, KVM would migrate both events, but that would
> require new ABI, and practically speaking losing the event is unlikely to
> be noticed, let alone fatal.  The injected exception is captured, RIP
> still points at the original faulting instruction, etc...  So either the
> injection on the target will trigger the same intercepted exception, or
> the source of the intercepted exception was transient and/or
> non-deterministic, thus dropping it is ok-ish.
> 
> Opportunistically add a gigantic comment above vmx_check_nested_events()
> to document the priorities of all known events on Intel CPUs.  Kudos to
> Jim Mattson for doing the hard work of collecting and interpreting the
> priorities from various locations throughtout the SDM (because putting
> them all in one place in the SDM would be too easy).
> 
> Fixes: a04aead144fd ("KVM: nSVM: fix running nested guests when npt=0")
> Fixes: feaf0c7dc473 ("KVM: nVMX: Do not generate #DF if #PF happens during exception delivery into L2")
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  12 +-
>  arch/x86/kvm/svm/nested.c       |  41 ++----
>  arch/x86/kvm/vmx/nested.c       | 220 +++++++++++++++++++++-----------
>  arch/x86/kvm/vmx/vmx.c          |   6 +-
>  arch/x86/kvm/x86.c              | 159 ++++++++++++++++-------
>  arch/x86/kvm/x86.h              |   7 +
>  6 files changed, 287 insertions(+), 158 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7f321d53a7e9..3bf7fdeeb25c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -648,7 +648,6 @@ struct kvm_queued_exception {
>         u32 error_code;
>         unsigned long payload;
>         bool has_payload;
> -       u8 nested_apf;
>  };
>  
>  struct kvm_vcpu_arch {
> @@ -750,8 +749,12 @@ struct kvm_vcpu_arch {
>  
>         u8 event_exit_inst_len;
>  
> +       bool exception_from_userspace;
> +
>         /* Exceptions to be injected to the guest. */
>         struct kvm_queued_exception exception;
> +       /* Exception VM-Exits to be synthesized to L1. */
> +       struct kvm_queued_exception exception_vmexit;
>  
>         struct kvm_queued_interrupt {
>                 bool injected;
> @@ -861,7 +864,6 @@ struct kvm_vcpu_arch {
>                 u32 id;
>                 bool send_user_only;
>                 u32 host_apf_flags;
> -               unsigned long nested_apf_token;
>                 bool delivery_as_pf_vmexit;
>                 bool pageready_pending;
>         } apf;
> @@ -1618,9 +1620,9 @@ struct kvm_x86_ops {
>  
>  struct kvm_x86_nested_ops {
>         void (*leave_nested)(struct kvm_vcpu *vcpu);
> +       bool (*is_exception_vmexit)(struct kvm_vcpu *vcpu, u8 vector,
> +                                   u32 error_code);
>         int (*check_events)(struct kvm_vcpu *vcpu);
> -       bool (*handle_page_fault_workaround)(struct kvm_vcpu *vcpu,
> -                                            struct x86_exception *fault);

I think that since this patch is already quite large, it would make sense
to split the removal of workaround/hack code to patch after this one?


>         bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
>         void (*triple_fault)(struct kvm_vcpu *vcpu);
>         int (*get_state)(struct kvm_vcpu *vcpu,
> @@ -1847,7 +1849,7 @@ void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, unsigned long pay
>  void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
>  void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
>  void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
> -bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
> +void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
>                                     struct x86_exception *fault);
>  bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
>  bool kvm_require_dr(struct kvm_vcpu *vcpu, int dr);
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 460161e67ce5..4075deefd132 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -55,28 +55,6 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
>         nested_svm_vmexit(svm);
>  }
>  
> -static bool nested_svm_handle_page_fault_workaround(struct kvm_vcpu *vcpu,
> -                                                   struct x86_exception *fault)
> -{
> -       struct vcpu_svm *svm = to_svm(vcpu);
> -       struct vmcb *vmcb = svm->vmcb;
> -
> -       WARN_ON(!is_guest_mode(vcpu));
> -
> -       if (vmcb12_is_intercept(&svm->nested.ctl,
> -                               INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
> -           !WARN_ON_ONCE(svm->nested.nested_run_pending)) {
> -               vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
> -               vmcb->control.exit_code_hi = 0;
> -               vmcb->control.exit_info_1 = fault->error_code;
> -               vmcb->control.exit_info_2 = fault->address;
> -               nested_svm_vmexit(svm);
> -               return true;
> -       }
> -
> -       return false;
> -}
> -
>  static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
> @@ -1297,16 +1275,17 @@ int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
>         return 0;
>  }
>  
> -static bool nested_exit_on_exception(struct vcpu_svm *svm)
> +static bool nested_svm_is_exception_vmexit(struct kvm_vcpu *vcpu, u8 vector,
> +                                          u32 error_code)
>  {
> -       unsigned int vector = svm->vcpu.arch.exception.vector;
> +       struct vcpu_svm *svm = to_svm(vcpu);
>  
>         return (svm->nested.ctl.intercepts[INTERCEPT_EXCEPTION] & BIT(vector));
>  }
>  
>  static void nested_svm_inject_exception_vmexit(struct kvm_vcpu *vcpu)
>  {
> -       struct kvm_queued_exception *ex = &vcpu->arch.exception;
> +       struct kvm_queued_exception *ex = &vcpu->arch.exception_vmexit;
>         struct vcpu_svm *svm = to_svm(vcpu);
>         struct vmcb *vmcb = svm->vmcb;
>  
> @@ -1368,15 +1347,19 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
>                 return 0;
>         }
>  
> -       if (vcpu->arch.exception.pending) {
> +       if (vcpu->arch.exception_vmexit.pending) {
>                 if (block_nested_exceptions)
>                          return -EBUSY;
> -               if (!nested_exit_on_exception(svm))
> -                       return 0;
>                 nested_svm_inject_exception_vmexit(vcpu);
>                 return 0;
>         }

I see, so my approach was to have pending and injected exception,
while your approach is basically to have the 'pending' exception
only when it can't be merged right away with the injected exception.


It's less elegant IMHO, but on the other hand is less
risky, so I agree upon it.

You also still want to delay the actual VM exit to the vcpu run time,
which also reduces the risk, which is also a justified design choice.

>  
> +       if (vcpu->arch.exception.pending) {
> +               if (block_nested_exceptions)
> +                       return -EBUSY;
> +               return 0;
> +       }
> +
>         if (vcpu->arch.smi_pending && !svm_smi_blocked(vcpu)) {
>                 if (block_nested_events)
>                         return -EBUSY;
> @@ -1714,8 +1697,8 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>  
>  struct kvm_x86_nested_ops svm_nested_ops = {
>         .leave_nested = svm_leave_nested,
> +       .is_exception_vmexit = nested_svm_is_exception_vmexit,
>         .check_events = svm_check_nested_events,
> -       .handle_page_fault_workaround = nested_svm_handle_page_fault_workaround,
>         .triple_fault = nested_svm_triple_fault,
>         .get_nested_state_pages = svm_get_nested_state_pages,
>         .get_state = svm_get_nested_state,
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 50fe66f0cc1b..53f6ea15081d 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -438,59 +438,22 @@ static bool nested_vmx_is_page_fault_vmexit(struct vmcs12 *vmcs12,
>         return inequality ^ bit;
>  }
>  
> -
> -/*
> - * KVM wants to inject page-faults which it got to the guest. This function
> - * checks whether in a nested guest, we need to inject them to L1 or L2.
> - */
> -static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit_qual)
> -{
> -       struct kvm_queued_exception *ex = &vcpu->arch.exception;
> -       struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> -
> -       if (ex->vector == PF_VECTOR) {
> -               if (ex->nested_apf) {
> -                       *exit_qual = vcpu->arch.apf.nested_apf_token;
> -                       return 1;
> -               }
> -               if (nested_vmx_is_page_fault_vmexit(vmcs12, ex->error_code)) {
> -                       *exit_qual = ex->has_payload ? ex->payload : vcpu->arch.cr2;
> -                       return 1;
> -               }
> -       } else if (vmcs12->exception_bitmap & (1u << ex->vector)) {
> -               if (ex->vector == DB_VECTOR) {
> -                       if (ex->has_payload) {
> -                               *exit_qual = ex->payload;
> -                       } else {
> -                               *exit_qual = vcpu->arch.dr6;
> -                               *exit_qual &= ~DR6_BT;
> -                               *exit_qual ^= DR6_ACTIVE_LOW;
> -                       }
> -               } else
> -                       *exit_qual = 0;
> -               return 1;
> -       }
> -
> -       return 0;
> -}
> -
> -static bool nested_vmx_handle_page_fault_workaround(struct kvm_vcpu *vcpu,
> -                                                   struct x86_exception *fault)
> +static bool nested_vmx_is_exception_vmexit(struct kvm_vcpu *vcpu, u8 vector,
> +                                          u32 error_code)
>  {
>         struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>  
> -       WARN_ON(!is_guest_mode(vcpu));
> +       /*
> +        * Drop bits 31:16 of the error code when performing the #PF mask+match
> +        * check.  All VMCS fields involved are 32 bits, but Intel CPUs never
> +        * set bits 31:16 and VMX disallows setting bits 31:16 in the injected
> +        * error code.  Including the to-be-dropped bits in the check might
> +        * result in an "impossible" or missed exit from L1's perspective.
> +        */
> +       if (vector == PF_VECTOR)
> +               return nested_vmx_is_page_fault_vmexit(vmcs12, (u16)error_code);
>  
> -       if (nested_vmx_is_page_fault_vmexit(vmcs12, fault->error_code) &&
> -           !WARN_ON_ONCE(to_vmx(vcpu)->nested.nested_run_pending)) {
> -               vmcs12->vm_exit_intr_error_code = fault->error_code;
> -               nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
> -                                 PF_VECTOR | INTR_TYPE_HARD_EXCEPTION |
> -                                 INTR_INFO_DELIVER_CODE_MASK | INTR_INFO_VALID_MASK,
> -                                 fault->address);
> -               return true;
> -       }
> -       return false;
> +       return (vmcs12->exception_bitmap & (1u << vector));
>  }
>  
>  static int nested_vmx_check_io_bitmap_controls(struct kvm_vcpu *vcpu,
> @@ -3823,12 +3786,24 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
>         return -ENXIO;
>  }
>  
> -static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
> -                                              unsigned long exit_qual)
> +static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu)
>  {
> -       struct kvm_queued_exception *ex = &vcpu->arch.exception;
> +       struct kvm_queued_exception *ex = &vcpu->arch.exception_vmexit;
>         u32 intr_info = ex->vector | INTR_INFO_VALID_MASK;
>         struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> +       unsigned long exit_qual;
> +
> +       if (ex->has_payload) {
> +               exit_qual = ex->payload;
> +       } else if (ex->vector == PF_VECTOR) {
> +               exit_qual = vcpu->arch.cr2;
> +       } else if (ex->vector == DB_VECTOR) {
> +               exit_qual = vcpu->arch.dr6;
> +               exit_qual &= ~DR6_BT;
> +               exit_qual ^= DR6_ACTIVE_LOW;
> +       } else {
> +               exit_qual = 0;
> +       }
>  
>         if (ex->has_error_code) {
>                 /*
> @@ -3870,14 +3845,24 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
>   * from the emulator (because such #DBs are fault-like and thus don't trigger
>   * actions that fire on instruction retire).
>   */
> -static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
> +static unsigned long vmx_get_pending_dbg_trap(struct kvm_queued_exception *ex)
Any reason to remove the inline?
>  {
> -       if (!vcpu->arch.exception.pending ||
> -           vcpu->arch.exception.vector != DB_VECTOR)
> +       if (!ex->pending || ex->vector != DB_VECTOR)
>                 return 0;
>  
>         /* General Detect #DBs are always fault-like. */
> -       return vcpu->arch.exception.payload & ~DR6_BD;
> +       return ex->payload & ~DR6_BD;
> +}
> +
> +/*
> + * Returns true if there's a pending #DB exception that is lower priority than
> + * a pending Monitor Trap Flag VM-Exit.  TSS T-flag #DBs are not emulated by
> + * KVM, but could theoretically be injected by userspace.  Note, this code is
> + * imperfect, see above.
> + */
> +static bool vmx_is_low_priority_db_trap(struct kvm_queued_exception *ex)
> +{
> +       return vmx_get_pending_dbg_trap(ex) & ~DR6_BT;
>  }
>  
>  /*
> @@ -3889,8 +3874,9 @@ static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
>   */
>  static void nested_vmx_update_pending_dbg(struct kvm_vcpu *vcpu)
>  {
> -       unsigned long pending_dbg = vmx_get_pending_dbg_trap(vcpu);
> +       unsigned long pending_dbg;
>  
> +       pending_dbg = vmx_get_pending_dbg_trap(&vcpu->arch.exception);
>         if (pending_dbg)
>                 vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, pending_dbg);
>  }
> @@ -3901,11 +3887,93 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
>                to_vmx(vcpu)->nested.preemption_timer_expired;
>  }
>  
> +/*
> + * Per the Intel SDM's table "Priority Among Concurrent Events", with minor
> + * edits to fill in missing examples, e.g. #DB due to split-lock accesses,
> + * and less minor edits to splice in the priority of VMX Non-Root specific
> + * events, e.g. MTF and NMI/INTR-window exiting.
> + *
> + * 1 Hardware Reset and Machine Checks
> + *     - RESET
> + *     - Machine Check
> + *
> + * 2 Trap on Task Switch
> + *     - T flag in TSS is set (on task switch)
> + *
> + * 3 External Hardware Interventions
> + *     - FLUSH
> + *     - STOPCLK
> + *     - SMI
> + *     - INIT
> + *
> + * 3.5 Monitor Trap Flag (MTF) VM-exit[1]
> + *
> + * 4 Traps on Previous Instruction
> + *     - Breakpoints
> + *     - Trap-class Debug Exceptions (#DB due to TF flag set, data/I-O
> + *       breakpoint, or #DB due to a split-lock access)
> + *
> + * 4.3 VMX-preemption timer expired VM-exit
> + *
> + * 4.6 NMI-window exiting VM-exit[2]
> + *
> + * 5 Nonmaskable Interrupts (NMI)
> + *
> + * 5.5 Interrupt-window exiting VM-exit and Virtual-interrupt delivery
> + *
> + * 6 Maskable Hardware Interrupts
> + *
> + * 7 Code Breakpoint Fault
> + *
> + * 8 Faults from Fetching Next Instruction
> + *     - Code-Segment Limit Violation
> + *     - Code Page Fault
> + *     - Control protection exception (missing ENDBRANCH at target of indirect
> + *                                     call or jump)
> + *
> + * 9 Faults from Decoding Next Instruction
> + *     - Instruction length > 15 bytes
> + *     - Invalid Opcode
> + *     - Coprocessor Not Available
> + *
> + *10 Faults on Executing Instruction
> + *     - Overflow
> + *     - Bound error
> + *     - Invalid TSS
> + *     - Segment Not Present
> + *     - Stack fault
> + *     - General Protection
> + *     - Data Page Fault
> + *     - Alignment Check
> + *     - x86 FPU Floating-point exception
> + *     - SIMD floating-point exception
> + *     - Virtualization exception
> + *     - Control protection exception
> + *
> + * [1] Per the "Monitor Trap Flag" section: System-management interrupts (SMIs),
> + *     INIT signals, and higher priority events take priority over MTF VM exits.
> + *     MTF VM exits take priority over debug-trap exceptions and lower priority
> + *     events.
> + *
> + * [2] Debug-trap exceptions and higher priority events take priority over VM exits
> + *     caused by the VMX-preemption timer.  VM exits caused by the VMX-preemption
> + *     timer take priority over VM exits caused by the "NMI-window exiting"
> + *     VM-execution control and lower priority events.
> + *
> + * [3] Debug-trap exceptions and higher priority events take priority over VM exits
> + *     caused by "NMI-window exiting".  VM exits caused by this control take
> + *     priority over non-maskable interrupts (NMIs) and lower priority events.
> + *
> + * [4] Virtual-interrupt delivery has the same priority as that of VM exits due to
> + *     the 1-setting of the "interrupt-window exiting" VM-execution control.  Thus,
> + *     non-maskable interrupts (NMIs) and higher priority events take priority over
> + *     delivery of a virtual interrupt; delivery of a virtual interrupt takes
> + *     priority over external interrupts and lower priority events.
> + */
This comment also probably should go to a separate patch to reduce this patch size.

Other than that, this is a _very_ good idea to add it to KVM, although
maybe we should put it in Documentation folder instead?
(but I don't have a strong preference on this)


>  static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_lapic *apic = vcpu->arch.apic;
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
> -       unsigned long exit_qual;
>         /*
>          * Only a pending nested run blocks a pending exception.  If there is a
>          * previously injected event, the pending exception occurred while said
> @@ -3943,19 +4011,20 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>                 /* Fallthrough, the SIPI is completely ignored. */
>         }
>  
> -       /*
> -        * Process exceptions that are higher priority than Monitor Trap Flag:
> -        * fault-like exceptions, TSS T flag #DB (not emulated by KVM, but
> -        * could theoretically come in from userspace), and ICEBP (INT1).
> -        */
> +       if (vcpu->arch.exception_vmexit.pending &&
> +           !vmx_is_low_priority_db_trap(&vcpu->arch.exception_vmexit)) {
> +               if (block_nested_exceptions)
> +                       return -EBUSY;
> +
> +               nested_vmx_inject_exception_vmexit(vcpu);
> +               return 0;
> +       }

> +
>         if (vcpu->arch.exception.pending &&
> -           !(vmx_get_pending_dbg_trap(vcpu) & ~DR6_BT)) {
> +           !vmx_is_low_priority_db_trap(&vcpu->arch.exception)) {
Small nitpick: vmx_is_low_priority_db_trap refactoring could be done in a separate patch

+ Maybe it would be nice to add a WARN_ON_ONCE check here that this exception is not intercepted
by the guest

>                 if (block_nested_exceptions)
>                         return -EBUSY;
> -               if (!nested_vmx_check_exception(vcpu, &exit_qual))
> -                       goto no_vmexit;
> -               nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
> -               return 0;
> +               goto no_vmexit;
>         }
>  
>         if (vmx->nested.mtf_pending) {
> @@ -3966,13 +4035,18 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>                 return 0;
>         }
>  
> +       if (vcpu->arch.exception_vmexit.pending) {
> +               if (block_nested_exceptions)
> +                       return -EBUSY;

And here add a WARN_ON_ONCE check that it is intercepted.

> +
> +               nested_vmx_inject_exception_vmexit(vcpu);
> +               return 0;
> +       }
> +
>         if (vcpu->arch.exception.pending) {
>                 if (block_nested_exceptions)
>                         return -EBUSY;
> -               if (!nested_vmx_check_exception(vcpu, &exit_qual))
> -                       goto no_vmexit;
> -               nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
> -               return 0;
> +               goto no_vmexit;
>         }
>  
>         if (nested_vmx_preemption_timer_pending(vcpu)) {
> @@ -6863,8 +6937,8 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
>  
>  struct kvm_x86_nested_ops vmx_nested_ops = {
>         .leave_nested = vmx_leave_nested,
> +       .is_exception_vmexit = nested_vmx_is_exception_vmexit,
>         .check_events = vmx_check_nested_events,
> -       .handle_page_fault_workaround = nested_vmx_handle_page_fault_workaround,
>         .hv_timer_pending = nested_vmx_preemption_timer_pending,
>         .triple_fault = nested_vmx_triple_fault,
>         .get_state = vmx_get_nested_state,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7ef5659a1bbd..3591fdf7ecf9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1585,7 +1585,9 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
>          */
>         if (nested_cpu_has_mtf(vmcs12) &&
>             (!vcpu->arch.exception.pending ||
> -            vcpu->arch.exception.vector == DB_VECTOR))
> +            vcpu->arch.exception.vector == DB_VECTOR) &&
> +           (!vcpu->arch.exception_vmexit.pending ||
> +            vcpu->arch.exception_vmexit.vector == DB_VECTOR))


>                 vmx->nested.mtf_pending = true;
>         else
>                 vmx->nested.mtf_pending = false;
> @@ -5624,7 +5626,7 @@ static bool vmx_emulation_required_with_pending_exception(struct kvm_vcpu *vcpu)
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
>         return vmx->emulation_required && !vmx->rmode.vm86_active &&
> -              (vcpu->arch.exception.pending || vcpu->arch.exception.injected);
> +              (kvm_is_exception_pending(vcpu) || vcpu->arch.exception.injected);
>  }
>  
>  static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1a301a1730a5..63ee79da50df 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -609,6 +609,21 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
>  }
>  EXPORT_SYMBOL_GPL(kvm_deliver_exception_payload);
>  
> +static void kvm_queue_exception_vmexit(struct kvm_vcpu *vcpu, unsigned int vector,
> +                                      bool has_error_code, u32 error_code,
> +                                      bool has_payload, unsigned long payload)
> +{
> +       struct kvm_queued_exception *ex = &vcpu->arch.exception_vmexit;
> +
> +       ex->vector = vector;
> +       ex->injected = false;
> +       ex->pending = true;
> +       ex->has_error_code = has_error_code;
> +       ex->error_code = error_code;
> +       ex->has_payload = has_payload;
> +       ex->payload = payload;
> +}
> +
>  static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>                 unsigned nr, bool has_error, u32 error_code,
>                 bool has_payload, unsigned long payload, bool reinject)
> @@ -618,18 +633,31 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>  
>         kvm_make_request(KVM_REQ_EVENT, vcpu);
>  
> +       /*
> +        * If the exception is destined for L2 and isn't being reinjected,
> +        * morph it to a VM-Exit if L1 wants to intercept the exception.  A
> +        * previously injected exception is not checked because it was checked
> +        * when it was original queued, and re-checking is incorrect if _L1_
> +        * injected the exception, in which case it's exempt from interception.
> +        */
> +       if (!reinject && is_guest_mode(vcpu) &&
> +           kvm_x86_ops.nested_ops->is_exception_vmexit(vcpu, nr, error_code)) {
> +               kvm_queue_exception_vmexit(vcpu, nr, has_error, error_code,
> +                                          has_payload, payload);
> +               return;
> +       }
> +
>         if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
>         queue:
>                 if (reinject) {
>                         /*
> -                        * On vmentry, vcpu->arch.exception.pending is only
> -                        * true if an event injection was blocked by
> -                        * nested_run_pending.  In that case, however,
> -                        * vcpu_enter_guest requests an immediate exit,
> -                        * and the guest shouldn't proceed far enough to
> -                        * need reinjection.
> +                        * On VM-Entry, an exception can be pending if and only
> +                        * if event injection was blocked by nested_run_pending.
> +                        * In that case, however, vcpu_enter_guest() requests an
> +                        * immediate exit, and the guest shouldn't proceed far
> +                        * enough to need reinjection.

Now that I had read the Jim's document on event priorities, I think we can
update the comment:

On VMX we set expired preemption timer, and on SVM we do self IPI, thus pend a real interrupt.
Both events should have higher priority than processing the injected event

(This is something I didn't find in the Intel/AMD docs, so I might be wrong here)

thus the CPU will not attempt to process the injected event 
(via EVENTINJ on SVM, or via VM_ENTRY_INTR_INFO_FIELD) and instead just straight copy
them back to exit_int_info/IDT_VECTORING_INFO_FIELD)

So in this case the event will actually be re-injected, but no new exception can
be generated since we will re-execute the VMRUN/VMRESUME instruction.


>                          */
> -                       WARN_ON_ONCE(vcpu->arch.exception.pending);
> +                       WARN_ON_ONCE(kvm_is_exception_pending(vcpu));
>                         vcpu->arch.exception.injected = true;
>                         if (WARN_ON_ONCE(has_payload)) {
>                                 /*
> @@ -732,20 +760,22 @@ static int complete_emulated_insn_gp(struct kvm_vcpu *vcpu, int err)
>  void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
>  {
>         ++vcpu->stat.pf_guest;
> -       vcpu->arch.exception.nested_apf =
> -               is_guest_mode(vcpu) && fault->async_page_fault;
> -       if (vcpu->arch.exception.nested_apf) {
> -               vcpu->arch.apf.nested_apf_token = fault->address;
> -               kvm_queue_exception_e(vcpu, PF_VECTOR, fault->error_code);
> -       } else {
> +
> +       /*
> +        * Async #PF in L2 is always forwarded to L1 as a VM-Exit regardless of
> +        * whether or not L1 wants to intercept "regular" #PF.

We might want to also mention that the L1 has to opt-in to this
(vcpu->arch.apf.delivery_as_pf_vmexit), but the fact that we are
here, means that it did opt-in

(otherwise kvm_can_deliver_async_pf won't return true).

A WARN_ON_ONCE(!vcpu->arch.apf.delivery_as_pf_vmexit) would be
nice to also check this in the runtime.

Also note that AFAIK, qemu doesn't opt-in for this feature sadly,
thus this code is not tested (unless there is some unit test).


> +        */
> +       if (is_guest_mode(vcpu) && fault->async_page_fault)
> +               kvm_queue_exception_vmexit(vcpu, PF_VECTOR,
> +                                          true, fault->error_code,
> +                                          true, fault->address);
> +       else
>                 kvm_queue_exception_e_p(vcpu, PF_VECTOR, fault->error_code,
>                                         fault->address);
> -       }
>  }
>  EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
>  
> -/* Returns true if the page fault was immediately morphed into a VM-Exit. */
> -bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
> +void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
>                                     struct x86_exception *fault)
>  {
>         struct kvm_mmu *fault_mmu;
> @@ -763,26 +793,7 @@ bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
>                 kvm_mmu_invalidate_gva(vcpu, fault_mmu, fault->address,
>                                        fault_mmu->root.hpa);
>  
> -       /*
> -        * A workaround for KVM's bad exception handling.  If KVM injected an
> -        * exception into L2, and L2 encountered a #PF while vectoring the
> -        * injected exception, manually check to see if L1 wants to intercept
> -        * #PF, otherwise queuing the #PF will lead to #DF or a lost exception.
> -        * In all other cases, defer the check to nested_ops->check_events(),
> -        * which will correctly handle priority (this does not).  Note, other
> -        * exceptions, e.g. #GP, are theoretically affected, #PF is simply the
> -        * most problematic, e.g. when L0 and L1 are both intercepting #PF for
> -        * shadow paging.
> -        *
> -        * TODO: Rewrite exception handling to track injected and pending
> -        *       (VM-Exit) exceptions separately.
> -        */
> -       if (unlikely(vcpu->arch.exception.injected && is_guest_mode(vcpu)) &&
> -           kvm_x86_ops.nested_ops->handle_page_fault_workaround(vcpu, fault))
> -               return true;
> -
>         fault_mmu->inject_page_fault(vcpu, fault);
> -       return false;
>  }
>  EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);
>  
> @@ -4752,7 +4763,7 @@ static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
>         return (kvm_arch_interrupt_allowed(vcpu) &&
>                 kvm_cpu_accept_dm_intr(vcpu) &&
>                 !kvm_event_needs_reinjection(vcpu) &&
> -               !vcpu->arch.exception.pending);
> +               !kvm_is_exception_pending(vcpu));
>  }
>  
>  static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
> @@ -4881,13 +4892,27 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
>  static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>                                                struct kvm_vcpu_events *events)
>  {
> -       struct kvm_queued_exception *ex = &vcpu->arch.exception;
> +       struct kvm_queued_exception *ex;
>  
>         process_nmi(vcpu);
>  
>         if (kvm_check_request(KVM_REQ_SMI, vcpu))
>                 process_smi(vcpu);
>  
> +       /*
> +        * KVM's ABI only allows for one exception to be migrated.  Luckily,
> +        * the only time there can be two queued exceptions is if there's a
> +        * non-exiting _injected_ exception, and a pending exiting exception.
> +        * In that case, ignore the VM-Exiting exception as it's an extension
> +        * of the injected exception.
> +        */

I think that we will lose the injected exception, thus will only deliver after
the migration the VM-exiting exception but without the correct IDT_VECTORING_INFO_FIELD/exit_int_info.

It's not that big deal and can be fixed by extending this API, with a new cap,
as I did in my patches. This can be done later, but the above comment
which tries to justify it, should be updated to mention that it is wrong.



> +       if (vcpu->arch.exception_vmexit.pending &&
> +           !vcpu->arch.exception.pending &&
> +           !vcpu->arch.exception.injected)
> +               ex = &vcpu->arch.exception_vmexit;
> +       else
> +               ex = &vcpu->arch.exception;


> +
>         /*
>          * In guest mode, payload delivery should be deferred if the exception
>          * will be intercepted by L1, e.g. KVM should not modifying CR2 if L1
> @@ -4994,6 +5019,19 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>                 return -EINVAL;
>  
>         process_nmi(vcpu);
> +
> +       /*
> +        * Flag that userspace is stuffing an exception, the next KVM_RUN will
> +        * morph the exception to a VM-Exit if appropriate.  Do this only for
> +        * pending exceptions, already-injected exceptions are not subject to
> +        * intercpetion.  Note, userspace that conflates pending and injected
> +        * is hosed, and will incorrectly convert an injected exception into a
> +        * pending exception, which in turn may cause a spurious VM-Exit.
> +        */
> +       vcpu->arch.exception_from_userspace = events->exception.pending;

If I understand correctly, the only reason you added arch.exception_from_userspace,
is that you don't want to check if the L2 intercepts the exception here,
and set the exception_vmexit directly here, because nested state might not be loaded
yet, etc.

> +
> +       vcpu->arch.exception_vmexit.pending = false;
> +
>         vcpu->arch.exception.injected = events->exception.injected;
>         vcpu->arch.exception.pending = events->exception.pending;
>         vcpu->arch.exception.vector = events->exception.nr;
> @@ -7977,18 +8015,17 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
>         }
>  }
>  
> -static bool inject_emulated_exception(struct kvm_vcpu *vcpu)
> +static void inject_emulated_exception(struct kvm_vcpu *vcpu)
>  {
>         struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> +
>         if (ctxt->exception.vector == PF_VECTOR)
> -               return kvm_inject_emulated_page_fault(vcpu, &ctxt->exception);
> -
> -       if (ctxt->exception.error_code_valid)
> +               kvm_inject_emulated_page_fault(vcpu, &ctxt->exception);
> +       else if (ctxt->exception.error_code_valid)
>                 kvm_queue_exception_e(vcpu, ctxt->exception.vector,
>                                       ctxt->exception.error_code);
>         else
>                 kvm_queue_exception(vcpu, ctxt->exception.vector);
> -       return false;
>  }
>  
>  static struct x86_emulate_ctxt *alloc_emulate_ctxt(struct kvm_vcpu *vcpu)
> @@ -8601,8 +8638,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  
>         if (ctxt->have_exception) {
>                 r = 1;
> -               if (inject_emulated_exception(vcpu))
> -                       return r;
> +               inject_emulated_exception(vcpu);
>         } else if (vcpu->arch.pio.count) {
>                 if (!vcpu->arch.pio.in) {
>                         /* FIXME: return into emulator if single-stepping.  */
> @@ -9540,7 +9576,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>          */
>         if (vcpu->arch.exception.injected)
>                 kvm_inject_exception(vcpu);
> -       else if (vcpu->arch.exception.pending)
> +       else if (kvm_is_exception_pending(vcpu))
>                 ; /* see above */
>         else if (vcpu->arch.nmi_injected)
>                 static_call(kvm_x86_inject_nmi)(vcpu);
> @@ -9567,6 +9603,14 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>         if (r < 0)
>                 goto out;
>  
> +       /*
> +        * A pending exception VM-Exit should either result in nested VM-Exit
> +        * or force an immediate re-entry and exit to/from L2, and exception
> +        * VM-Exits cannot be injected (flag should _never_ be set).
> +        */
> +       WARN_ON_ONCE(vcpu->arch.exception_vmexit.injected ||
> +                    vcpu->arch.exception_vmexit.pending);
> +
>         /*
>          * New events, other than exceptions, cannot be injected if KVM needs
>          * to re-inject a previous event.  See above comments on re-injecting
> @@ -9666,7 +9710,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>             kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
>                 *req_immediate_exit = true;
>  
> -       WARN_ON(vcpu->arch.exception.pending);
> +       WARN_ON(kvm_is_exception_pending(vcpu));
>         return 0;
>  
>  out:
> @@ -10680,6 +10724,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
>  
>  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  {
> +       struct kvm_queued_exception *ex = &vcpu->arch.exception;
>         struct kvm_run *kvm_run = vcpu->run;
>         int r;
>  
> @@ -10738,6 +10783,21 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                 }
>         }
>  
> +       /*
> +        * If userspace set a pending exception and L2 is active, convert it to
> +        * a pending VM-Exit if L1 wants to intercept the exception.
> +        */
> +       if (vcpu->arch.exception_from_userspace && is_guest_mode(vcpu) &&
> +           kvm_x86_ops.nested_ops->is_exception_vmexit(vcpu, ex->vector,
> +                                                       ex->error_code)) {
> +               kvm_queue_exception_vmexit(vcpu, ex->vector,
> +                                          ex->has_error_code, ex->error_code,
> +                                          ex->has_payload, ex->payload);
> +               ex->injected = false;
> +               ex->pending = false;
> +       }
> +       vcpu->arch.exception_from_userspace = false;
> +
>         if (unlikely(vcpu->arch.complete_userspace_io)) {
>                 int (*cui)(struct kvm_vcpu *) = vcpu->arch.complete_userspace_io;
>                 vcpu->arch.complete_userspace_io = NULL;
> @@ -10842,6 +10902,7 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>         kvm_set_rflags(vcpu, regs->rflags | X86_EFLAGS_FIXED);
>  
>         vcpu->arch.exception.pending = false;
> +       vcpu->arch.exception_vmexit.pending = false;
>  
>         kvm_make_request(KVM_REQ_EVENT, vcpu);
>  }
> @@ -11209,7 +11270,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  
>         if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {
>                 r = -EBUSY;
> -               if (vcpu->arch.exception.pending)
> +               if (kvm_is_exception_pending(vcpu))
>                         goto out;
>                 if (dbg->control & KVM_GUESTDBG_INJECT_DB)
>                         kvm_queue_exception(vcpu, DB_VECTOR);
> @@ -12387,7 +12448,7 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>         if (vcpu->arch.pv.pv_unhalted)
>                 return true;
>  
> -       if (vcpu->arch.exception.pending)
> +       if (kvm_is_exception_pending(vcpu))
>                 return true;
>  
>         if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
> @@ -12641,7 +12702,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>  {
>         if (unlikely(!lapic_in_kernel(vcpu) ||
>                      kvm_event_needs_reinjection(vcpu) ||
> -                    vcpu->arch.exception.pending))
> +                    kvm_is_exception_pending(vcpu)))
>                 return false;
>  
>         if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index dc2af0146220..eee259e387d3 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -82,10 +82,17 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
>  void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu);
>  int kvm_check_nested_events(struct kvm_vcpu *vcpu);
>  
> +static inline bool kvm_is_exception_pending(struct kvm_vcpu *vcpu)
> +{
> +       return vcpu->arch.exception.pending ||
> +              vcpu->arch.exception_vmexit.pending;
> +}
> +
>  static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
>  {
>         vcpu->arch.exception.pending = false;
>         vcpu->arch.exception.injected = false;
> +       vcpu->arch.exception_vmexit.pending = false;
>  }
>  
>  static inline void kvm_queue_interrupt(struct kvm_vcpu *vcpu, u8 vector,


So overall it looks like you encountered the same pain points I encountered and overall your
approach is a bit less risky than my approach so to me it looks OK.

Best regards,
	Maxim Levitsky

