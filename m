Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF545614DE
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 10:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiF3IWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 04:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbiF3IWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 04:22:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDE9CB0D
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 01:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656577355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SpvDJDYrWiyEX6j/kWWghxQHe9L8KW/2pv5AGZNAv4U=;
        b=i15kVdQaUhS/0yRyX30lhBAeEAJSPLXCrNzN+oMdY9TI/NEiVC7l8AT1ngm1zMDRIHhvMA
        +srRGedPEI8B+LcsSHIqzP+UokIbTuYArF8127Fxxm3WlSfgGfb8hVmAHdO9R2dTfdZMrx
        AHSvPw2leonrq2TpjIJHVuSIz2hPNq8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-uHb135smPzeUQPkxIZiYgg-1; Thu, 30 Jun 2022 04:22:32 -0400
X-MC-Unique: uHb135smPzeUQPkxIZiYgg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E87CE19705A7;
        Thu, 30 Jun 2022 08:22:31 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FAB11121314;
        Thu, 30 Jun 2022 08:22:29 +0000 (UTC)
Message-ID: <f55889a50ba404381e3edc1a192770f2779d40f1.camel@redhat.com>
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
Date:   Thu, 30 Jun 2022 11:22:28 +0300
In-Reply-To: <CALMp9eSkdj=kwh=4WHPsWZ1mKr9+0VSB527D5CMEx+wpgEGjGw@mail.gmail.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <7e05e0befa13af05f1e5f0fd8658bc4e7bdf764f.camel@redhat.com>
         <CALMp9eSkdj=kwh=4WHPsWZ1mKr9+0VSB527D5CMEx+wpgEGjGw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Yes, that is what I wanted to confirm.


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
> at the start of the instruction.

Are you sure about that? 


This is what the SDM says for direct intercepts.

27.3.3 Saving RIP, RSP, RFLAGS, and SSP

"If the VM exit is due to a software exception (due to an execution of INT3 or INTO) or a privileged software
exception (due to an execution of INT1), the value saved references the INT3, INTO, or INT1 instruction
that caused that exception."


If these events were intecepted indirectly (via IDT_VECTORING_INFO_FIELD),
its hard to understand from the PRM where the RIP points, but at least we at KVM,
do read VM_EXIT_INSTRUCTION_LEN, and then stuff it into the VM_ENTRY_INSTRUCTION_LEN
when we re-inject the event.
(look at __vmx_complete_interrupts)


Also note that you can't intercept INTn on Intel at all,
but they can be intercepted indirectly via the IDT vectoring field.


> In early Intel VT-x parts, one could
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

Two things which can be infered from the SVM spec. 
	- AMD doesn't distinguish between MOV SS and STI int shadow.
	- AMD has no 'pending debug exception field' in the vmcb.

I don't know what AMD does for #DB that happens on MOV SS, nor if it
does distinguish these internally, 
probably just drops the #DB or something.



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
Yes, though that is would be mostly useful for nesting.

For not nesting hypervisor, if the hypervisor figured out that a higher priority event overrode
the MTF, it can just process the MTF - why to re-inject it?


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

I am not sure what you mean. single-step, IO, data breakpoints are indeed the trap #DB,
while "general detect", code breakpoint are fault #DB, and we also have the task switch #DB, but since the hardware doesn't
emulate the task switches, this has to be injected.

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

I can't access this document for some reason (from my redhat account, which is gmail as well).

Thanks for the info,
Best regards,
	Maxim Levitsky




