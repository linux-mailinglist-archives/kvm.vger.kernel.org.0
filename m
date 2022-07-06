Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD09568761
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 13:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbiGFLzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 07:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiGFLzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 07:55:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16DDD27FF6
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 04:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657108500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SP5EzZrsZsUhsdzc7ve6kmppah+OD80EeNCDT6fCS0E=;
        b=JGXjVgBSZyllKAb6FcygAVMWtYWJMZq1P2pFa2RZzGoQKbNuy3VGcsVKGxVTwzK88Jn40/
        IeYWqWi03RoH26CkY8kROJS5fOkrHvMHYW6st/q/XKvKKdHiInfpNslQgjimPHP62dfEpA
        OgfgsbH7ztelDOOdVNB1Tuj28ZFoWEk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-LZcJpN3tOdOaQRr0FEjXCg-1; Wed, 06 Jul 2022 07:54:59 -0400
X-MC-Unique: LZcJpN3tOdOaQRr0FEjXCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EBDA1C00AC8;
        Wed,  6 Jul 2022 11:54:58 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 186282166B26;
        Wed,  6 Jul 2022 11:54:55 +0000 (UTC)
Message-ID: <cab59dcca8490cbedda3c7cf5f93e579b96a362e.camel@redhat.com>
Subject: Re: [PATCH v2 00/21] KVM: x86: Event/exception fixes and cleanups
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 14:54:54 +0300
In-Reply-To: <CALMp9eSkdj=kwh=4WHPsWZ1mKr9+0VSB527D5CMEx+wpgEGjGw@mail.gmail.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <7e05e0befa13af05f1e5f0fd8658bc4e7bdf764f.camel@redhat.com>
         <CALMp9eSkdj=kwh=4WHPsWZ1mKr9+0VSB527D5CMEx+wpgEGjGw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-06-29 at 06:42 -0700, Jim Mattson wrote:
> On Wed, Jun 29, 2022 at 4:17 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> > > The main goal of this series is to fix KVM's longstanding bug of not
> > > honoring L1's exception intercepts wants when handling an exception that
> > > occurs during delivery of a different exception.  E.g. if L0 and L1 are
> > > using shadow paging, and L2 hits a #PF, and then hits another #PF while
> > > vectoring the first #PF due to _L1_ not having a shadow page for the IDT,
> > > KVM needs to check L1's intercepts before morphing the #PF => #PF => #DF
> > > so that the #PF is routed to L1, not injected into L2 as a #DF.
> > > 
> > > nVMX has hacked around the bug for years by overriding the #PF injector
> > > for shadow paging to go straight to VM-Exit, and nSVM has started doing
> > > the same.  The hacks mostly work, but they're incomplete, confusing, and
> > > lead to other hacky code, e.g. bailing from the emulator because #PF
> > > injection forced a VM-Exit and suddenly KVM is back in L1.
> > > 
> > > Everything leading up to that are related fixes and cleanups I encountered
> > > along the way; some through code inspection, some through tests.
> > > 
> > > v2:
> > >   - Rebased to kvm/queue (commit 8baacf67c76c) + selftests CPUID
> > >     overhaul.
> > >     https://lore.kernel.org/all/20220614200707.3315957-1-seanjc@google.com
> > >   - Treat KVM_REQ_TRIPLE_FAULT as a pending exception.
> > > 
> > > v1: https://lore.kernel.org/all/20220311032801.3467418-1-seanjc@google.com
> > > 
> > > Sean Christopherson (21):
> > >   KVM: nVMX: Unconditionally purge queued/injected events on nested
> > >     "exit"
> > >   KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS
> > >   KVM: x86: Don't check for code breakpoints when emulating on exception
> > >   KVM: nVMX: Treat General Detect #DB (DR7.GD=1) as fault-like
> > >   KVM: nVMX: Prioritize TSS T-flag #DBs over Monitor Trap Flag
> > >   KVM: x86: Treat #DBs from the emulator as fault-like (code and
> > >     DR7.GD=1)
> > >   KVM: x86: Use DR7_GD macro instead of open coding check in emulator
> > >   KVM: nVMX: Ignore SIPI that arrives in L2 when vCPU is not in WFS
> > >   KVM: nVMX: Unconditionally clear mtf_pending on nested VM-Exit
> > >   KVM: VMX: Inject #PF on ENCLS as "emulated" #PF
> > >   KVM: x86: Rename kvm_x86_ops.queue_exception to inject_exception
> > >   KVM: x86: Make kvm_queued_exception a properly named, visible struct
> > >   KVM: x86: Formalize blocking of nested pending exceptions
> > >   KVM: x86: Use kvm_queue_exception_e() to queue #DF
> > >   KVM: x86: Hoist nested event checks above event injection logic
> > >   KVM: x86: Evaluate ability to inject SMI/NMI/IRQ after potential
> > >     VM-Exit
> > >   KVM: x86: Morph pending exceptions to pending VM-Exits at queue time
> > >   KVM: x86: Treat pending TRIPLE_FAULT requests as pending exceptions
> > >   KVM: VMX: Update MTF and ICEBP comments to document KVM's subtle
> > >     behavior
> > >   KVM: selftests: Use uapi header to get VMX and SVM exit reasons/codes
> > >   KVM: selftests: Add an x86-only test to verify nested exception
> > >     queueing
> > > 
> > >  arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
> > >  arch/x86/include/asm/kvm_host.h               |  35 +-
> > >  arch/x86/kvm/emulate.c                        |   3 +-
> > >  arch/x86/kvm/svm/nested.c                     | 102 ++---
> > >  arch/x86/kvm/svm/svm.c                        |  18 +-
> > >  arch/x86/kvm/vmx/nested.c                     | 319 +++++++++-----
> > >  arch/x86/kvm/vmx/sgx.c                        |   2 +-
> > >  arch/x86/kvm/vmx/vmx.c                        |  53 ++-
> > >  arch/x86/kvm/x86.c                            | 404 +++++++++++-------
> > >  arch/x86/kvm/x86.h                            |  11 +-
> > >  tools/testing/selftests/kvm/.gitignore        |   1 +
> > >  tools/testing/selftests/kvm/Makefile          |   1 +
> > >  .../selftests/kvm/include/x86_64/svm_util.h   |   7 +-
> > >  .../selftests/kvm/include/x86_64/vmx.h        |  51 +--
> > >  .../kvm/x86_64/nested_exceptions_test.c       | 295 +++++++++++++
> > >  15 files changed, 886 insertions(+), 418 deletions(-)
> > >  create mode 100644 tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
> > > 
> > > 
> > > base-commit: 816967202161955f398ce379f9cbbedcb1eb03cb
> > 
> > Hi Sean and everyone!
> > 
> > 
> > Before I continue reviewing the patch series, I would like you to check if
> > I understand the monitor trap/pending debug exception/event injection
> > logic on VMX correctly. I was looking at the spec for several hours and I still have more
> > questions that answers about it.
> > 
> > So let me state what I understand:
> > 
> > 1. Event injection (aka eventinj in SVM terms):
> > 
> >   (VM_ENTRY_INTR_INFO_FIELD/VM_ENTRY_EXCEPTION_ERROR_CODE/VM_ENTRY_INSTRUCTION_LEN)
> > 
> >   If I understand correctly all event injections types just like on SVM just inject,
> >   and never create something pending, and/or drop the injection if event is not allowed
> >   (like if EFLAGS.IF is 0). VMX might have some checks that could fail VM entry,
> >   if for example you try to inject type 0 (hardware interrupt) and EFLAGS.IF is 0,
> >   I haven't checked this)
> 
> The event is never just "dropped." If it is illegal to deliver the
> event, VM-entry fails. See the second bullet under section 26.2.1.3:
> VM-Entry Control Fields, in the SDM, volume 3.
> 
> 
> >   All event injections happen right away, don't deliver any payload (like DR6), etc.
> 
> Correct.
> 
> >   Injection types 4/5/6, do the same as injection types 0/2/3 but in addition to that,
> >   type 4/6 do a DPL check in IDT, and also these types can promote the RIP prior
> >   to pushing it to the exception stack using VM_ENTRY_INSTRUCTION_LEN to be consistent
> >   with cases when these trap like events are intercepted, where the interception happens
> >   on the start of the instruction despite exceptions being trap-like.
> 
> Unlike the AMD "INTn intercept," these trap intercepts *do not* happen
> at the start of the instruction. In early Intel VT-x parts, one could
> not easily reinject an intercepted software interrupt or exception
> using event injection, because VM-entry required a non-zero
> instruction length, and the guest RIP had already advanced. On CPUs
> that support a non-zero instruction length, one can now reinject a
> software interrupt or exception, by setting the VM-entry instruction
> length to 0.
> 
> > 2. #DB is the only trap like exception that can be pending for one more instruction
> >    if MOV SS shadow is on (any other cases?).
> 
> I believe that's it. I'm not entirely sure about RTM,though.
> 
> >    (AMD just ignores the whole thing, rightfully)
> 
> When you say "ignores," do you mean that AMD ignores a data breakpoint
> or single-step trap generated by MOV-SS, or it ignores the fact that
> delivering such a #DB trap between the MOV-SS and the subsequent
> MOV-ESP will create a stack frame in the wrong place?
> 
> >    That is why we have the GUEST_PENDING_DBG_EXCEPTIONS vmcs field.
> >    I understand that it will be written by CPU in case we have VM exit at the moment
> >    where #DB is already pending but not yet delivered.
> > 
> >    That field can also be (sadly) used to "inject" #DB to the guest, if the hypervisor sets it,
> >    and this #DB will actually update DR6 and such, and might be delayed/lost.
> 
> Injecting a #DB this way (if the hypervisor just emulated MOV-SS) is
> easier than emulating the next instruction or using MTF to step
> through the next instruction, and getting all of the deferred #DB
> delivery rules right. :-)
> 
> > 3. Facts about MTF:
> > 
> >    * MTF as a feature is basically 'single step the guest by generating MTF VM exits after each executed
> >      instruction', and is enabled in primary execution controls.
> > 
> >    * MTF is also an 'event', and it can be injected separately by the hypervisor with event type 7,
> >      and that has no connection to the 'feature', although usually this injection will be useful
> >      when the hypervisor does some kind of re-injection, triggered by the actual MTF feature.
> > 
> >    * MTF event can be lost, if higher priority VM exit happens, this is why the SDM says about 'pending MTF',
> >      which means that MTF vmexit should happen unless something else prevents it and/or higher priority VM exit
> >      overrides it.
> 
> Hence, the facility for injecting a "pending MTF"--so that it won't be "lost."
> 
> >    * MTF event is raised (when the primary execution controls bit is enabled) when:
> > 
> >         - after an injected (vectored), aka eventinj/VM_ENTRY_INTR_INFO_FIELD, done updating the guest state
> >           (that is stack was switched, stuff was pushed to new exception stack, RIP updated to the handler)
> >           I am not 100% sure about this but this seems to be what PRM implies:
> > 
> >           "If the “monitor trap flag” VM-execution control is 1 and VM entry is injecting a vectored event (see Section
> >           26.6.1), an MTF VM exit is pending on the instruction boundary before the first instruction following the
> >           VM entry."
> > 
> >         - If an interrupt and or #DB exception happens prior to executing first instruction of the guest,
> >           then once again MTF will happen on first instruction of the exception/interrupt handler
> > 
> >           "If the “monitor trap flag” VM-execution control is 1, VM entry is not injecting an event, and a pending event
> >           (e.g., debug exception or interrupt) is delivered before an instruction can execute, an MTF VM exit is pending
> >           on the instruction boundary following delivery of the event (or any nested exception)."
> > 
> >           That means that #DB has higher priority that MTF, but not specified if fault DB or trap DB
> 
> These are single-step, I/O and data breakpoint traps.
> 
> >         - If instruction causes exception, once again, on first instruction of the exception handler MTF will happen.
> > 
> >         - Otherwise after an instruction (or REP iteration) retires.
> > 
> > 
> > If you have more facts about MTF and related stuff and/or if I made a mistake in the above, I am all ears to listen!
> 
> You might be interested in my augmented Table 6-2 (from volume 3 of
> the SDM): https://docs.google.com/spreadsheets/d/e/2PACX-1vR8TkbSl4TqXtD62agRUs1QY3SY-98mKtOh-s8vYDzaDmDOcdfyTvlAxF9aVnHWRu7uyGhRwvHUziXT/pubhtml
> 


This is this table, slightly processed by me:

--
=====================================================================================
My Notes:
=====================================================================================


- Events happen on the instruction boundary.

- On the instruction boundary, the previous instruction is fully finished executing,
  which means that it is retired, or in other words, the arch state changes made by it
  are fully commited, and that includes transfer to an exception handler if
  that instruction caused a fault like exception.
  
  (Statement about transfer to an exception is not 100% true in KVM, since we use hardware to inject
   exceptions, thus when we deal with events, we still have to finish last instruction
   by delivering an exception it caused if any).

- On instruction boundary, the next instruction might already started executing, but none of its results
  were not committed to arch state YET.

- The events are from highest (1) to lowest (10). The highest event always wins,
  meaning that it is delivered, while all other events are lost.

=====================================================================================
Previous instruciton is retired
=====================================================================================

1.0 Hardware Reset and Machine Checks
  - RESET
  - Machine Check


2.0 Trap on Task Switch
  - T flag in TSS is set, and the task switch was done by previous instruction


3.0 External Hardware Interventions
  - FLUSH
  - STOPCLK
  - SMI
  - INIT

3.5 Pending MTF VM-exit
   "System-management interrupts (SMIs), INIT signals, and higher priority events take priority over MTF
   VM exits. MTF VM exits take priority over debug-trap exceptions and lower priority events."

   - Note that MTF became pending due to previous instruction and/or injection.

4.0 #DB Traps on Previous Instruction
  - Breakpoints
  - Debug Trap Exceptions (TF flag set or data/IO breakpoint)

4.3 VMX-preemption timer expired VM-exit
   "Debug-trap exceptions and higher priority events take priority over VM exits caused by the VMX-preemption
    timer. VM exits caused by the VMX-preemption timer take priority over VM exits caused by the “NMI-window
    exiting” VM-execution control and lower priority events."

4.6 NMI-window exiting VM-exit
   "Debug-trap exceptions (see Section 26.7.3) and higher priority events take priority over VM exits caused by
   [NMI-window exiting]. VM exits caused by this control take priority over non-maskable interrupts (NMIs) and lower
   priority events."

5.0 Nonmaskable Interrupts (NMI)


5.5 Interrupt-window exiting VM-exit + Virtual-interrupt delivery (if "interrupt-window exiting" is 0)

  "Virtual-interrupt delivery has the same priority as that of VM exits due to the 1-setting of the “interrupt-window
  exiting” VM-execution control.1 Thus, non-maskable interrupts (NMIs) and higher priority events take priority over
  delivery of a virtual interrupt; delivery of a virtual interrupt takes priority over external interrupts and lower priority
  events. "

6.0 Maskable Hardware Interrupts
  - Real hardware interrupts

=====================================================================================
Execution of next instruction starts
=====================================================================================

7.0 #DB Fault on next instruction
  - Instruction breakpoint
  - General detect ?? 

8.0 Faults from Fetching Next Instruction
  - Code-Segment Limit Violation
  - Code Page Fault
  - Control protection exception (missing ENDBRANCH at target of indirect call or jump)

9.0 Faults from Decoding Next Instruction
  - Instruction length > 15 bytes
  - Invalid Opcode
  - Coprocessor Not Available

10. Faults on Executing Next Instruction
  - Overflow
  - Bound error
  - Invalid TSS
  - Segment Not Present
  - Stack fault
  - General Protection
  - Data Page Fault
  - Alignment Check
  - x86 FPU Floating-point exception
  - SIMD floating-point exception
  - Virtualization exception
  - Control protection exception
--


So here are my questions:


1. Since #SMI is higher priority than the #MTF, that means that unless dual monitor treatment is used,
   and the dual monitor handler figures out that #MTF was pending and re-injects it when it
   VMRESUME's the 'host', the MTF gets lost, and there is no way for a normal hypervisor to
   do anything about it.

   Or maybe pending MTF is saved to SMRAM somewhere.

   In case you will say that I am inventing this again, I am saying now that the above is
   just a guess.


2. For case 7, what about General Detect? Since to raise it, the CPU needs to decode the instruction
   Its more natural to have it belong to case 9.


3. Finally just to state it, looks like MTF can only be lost due to #SMI or machine check,
   because the trap on task switch under VMX is purely software thing - task switch is emulated,
   thus the hypervisor can (and KVM doesn't) test that bit upon completion of the task switch,
   and do all monitor trap related things it needs then.

   (RESET/INIT doesn't matter as that makes the CPU lose most of its state)


Best regards,
	Maxim Levitsky

