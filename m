Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EB51A4CF4
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 02:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgDKAee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 20:34:34 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:39668 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgDKAee (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 20:34:34 -0400
Received: by mail-oi1-f193.google.com with SMTP id d63so2775536oig.6;
        Fri, 10 Apr 2020 17:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E6YUmBjR0fBCGslDkJmyTLVbD+8lR5N1hTG4sjgnQoE=;
        b=dKs229QfLA7CAqV6V5toDFM43RPvaz00wOWhrNBV15mlsM2PG2qz8Fst+xdRXAvpyz
         59KP6GtG6sB0Wt4600u/i+O7CBcugtcNzTn9d9VkqQiF6nobl/dJP5YWhhKlgR6/N/AT
         qv5DfMOKFOHnhm+NQ6ra5fj6LiUKlBmQHQNSk9M9Uvg8veeCYIsiVb6mj7j/00Mhtif4
         jmc4pzj8ghUyOvjTKw6OACZNy8JmG3jIsl1zJt03HPI6UrFfB456IFXd8VIwcep2YfKO
         X3bz4rK7Zgeq3agyeJApaQboQyq4ibjcBp4vT6pso+qbwCAJVEg/De7BK6vUwMazIyhw
         s39A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E6YUmBjR0fBCGslDkJmyTLVbD+8lR5N1hTG4sjgnQoE=;
        b=fmIXEtOAbtKqQzvpJHzaTLq4a/LZFLxXLxMXjhPa9dG8/+FoHkYc60zwc5d6oqH7hl
         PMFhJ5xk4o2BlyGb0wx72+kfPR4vjPRnrF2gcTs8cNHaH4V21wxDZyrmwHlVBSKI8/Of
         968pRmontCxAF4xUy4BrKqGtYM8Z+WPJiJxsk8r8YYJTVdkFk7u1/TMVH7uJmYEWRQcl
         VuJZPqn4N8Bgjh0BRvYpv4HhoVsecDSM4YMIDYjCrYzOv5ssFufTfou+O7iDMT1ZBHvl
         00zmkCDtugTz6URk30QqfoeOX86r48dxflDdQR4bogQLDaJhXJbft9UPiobD4l7Yuma+
         lwKg==
X-Gm-Message-State: AGi0PuaxVyOPiFvlRr3V+mFlndhqkh3WMLrVyjqt5H2wUU8+z7j/aqw3
        v8JKpsdKY13FQnRRWux9focRs3RLgm08MVBprZs=
X-Google-Smtp-Source: APiQypKvqud4Yvx31Wo0W69/niUj0pF19DTfdpIMyMQw5kDzIbAVnP9BWDb/JtzDbOJZbgclzCOlObUAqhNpRDIfYtQ=
X-Received: by 2002:aca:f1c6:: with SMTP id p189mr3509209oih.5.1586565273774;
 Fri, 10 Apr 2020 17:34:33 -0700 (PDT)
MIME-Version: 1.0
References: <f51251cc-885e-2f7a-b18d-faa76db15b87@redhat.com> <20200410174703.1138-1-sean.j.christopherson@intel.com>
In-Reply-To: <20200410174703.1138-1-sean.j.christopherson@intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Sat, 11 Apr 2020 08:34:22 +0800
Message-ID: <CANRm+CxGsBTeVy6-2-DhMYhB3J64jstaDgotEem01bpeiCY-7g@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: X86: Ultra fast single target IPI fastpath
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 11 Apr 2020 at 01:47, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Apr 10, 2020 at 05:50:35PM +0200, Paolo Bonzini wrote:
> > On 10/04/20 17:35, Sean Christopherson wrote:
> > > IMO, this should come at the very end of vmx_vcpu_run().  At a minimum, it
> > > needs to be moved below the #MC handling and below
> > >
> > >     if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
> > >             return;
> >
> > Why?  It cannot run in any of those cases, since the vmx->exit_reason
> > won't match.
>
> #MC and consistency checks should have "priority" over everything else.
> That there isn't actually a conflict is irrelevant IMO.  And it's something
> that will likely confuse newbies (to VMX and/or KVM) as it won't be obvious
> that the motivation was to shave a few cycles, e.g. versus some corner case
> where the fastpath handling does something meaningful even on failure.
>
> > > KVM more or less assumes vmx->idt_vectoring_info is always valid, and it's
> > > not obvious that a generic fastpath call can safely run before
> > > vmx_complete_interrupts(), e.g. the kvm_clear_interrupt_queue() call.
> >
> > Not KVM, rather vmx.c.  You're right about a generic fastpath, but in
> > this case kvm_irq_delivery_to_apic_fast is not touching VMX state; even
> > if you have a self-IPI, the modification of vCPU state is only scheduled
> > here and will happen later via either kvm_x86_ops.sync_pir_to_irr or
> > KVM_REQ_EVENT.
>
> I think what I don't like is that the fast-IPI code is buried in a helper
> that masquerades as a generic fastpath handler.  If that's open-coded in
> vmx_vcpu_run(), I'm ok with doing the fast-IPI handler immediately after
> the failure checks.
>
> And fast-IPI aside, the code could use a bit of optimization to prioritize
> successful VM-Enter, which would slot in nicely as a prep patch.  Patches
> (should be) following.

Thanks for v3. :)

>
> IMO, this is more logically correct:
>
>         vmx->exit_reason = vmcs_read32(VM_EXIT_REASON);
>         if (unlikely((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY))
>                 kvm_machine_check();
>
>         if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
>                 return EXIT_FASTPATH_NONE;
>
>         if (!is_guest_mode(vcpu) && vmx->exit_reason == EXIT_REASON_MSR_WRITE)
>                 exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
>         else
>                 exit_fastpath = EXIT_FASTPATH_NONE;
>
> And on my system, the compiler hoists fast-IPI above the #MC, e.g. moving
> the fast-IPI down only adds a single macrofused uop, testb+jne for
> FAILED_VMENTERY, to the code path.
>
>    0xffffffff81067d1d <+701>:   vmread %rax,%rax
>    0xffffffff81067d20 <+704>:   ja,pt  0xffffffff81067d2d <vmx_vcpu_run+717>
>    0xffffffff81067d23 <+707>:   pushq  $0x0
>    0xffffffff81067d25 <+709>:   push   %rax
>    0xffffffff81067d26 <+710>:   callq  0xffffffff81071790 <vmread_error_trampoline>
>    0xffffffff81067d2b <+715>:   pop    %rax
>    0xffffffff81067d2c <+716>:   pop    %rax
>    0xffffffff81067d2d <+717>:   test   %eax,%eax
>    0xffffffff81067d2f <+719>:   mov    %eax,0x32b0(%rbp)
>    0xffffffff81067d35 <+725>:   js     0xffffffff81067d5a <vmx_vcpu_run+762>
>    0xffffffff81067d37 <+727>:   testb  $0x20,0x2dc(%rbp)
>    0xffffffff81067d3e <+734>:   jne    0xffffffff81067d49 <vmx_vcpu_run+745>
>    0xffffffff81067d40 <+736>:   cmp    $0x20,%eax
>    0xffffffff81067d43 <+739>:   je     0xffffffff810686d4 <vmx_vcpu_run+3188> <-- fastpath handler
>    0xffffffff81067d49 <+745>:   xor    %ebx,%ebx
>    0xffffffff81067d4b <+747>:   jmpq   0xffffffff81067e65 <vmx_vcpu_run+1029>
