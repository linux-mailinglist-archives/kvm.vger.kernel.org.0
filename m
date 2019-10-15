Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD9ED7D1B
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 19:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfJORNU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 13:13:20 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36534 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfJORNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 13:13:19 -0400
Received: by mail-io1-f67.google.com with SMTP id b136so47667897iof.3
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 10:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oV2aRJfjwxrp1aTTb2RbqxY1TRDfcY5eP89TMv37HPk=;
        b=Im7kZr2LxVc4OTY8cRY4GGEXPi/K2KvYf8J+L0W9RIDXCqMYJQYXFnvEABgccc1EfG
         UcCpHihoHYP4QzoxsWviYM690fed51Kwfmvy4+THgbwo3LpJzLAjQlh5LFsYu2PRj+tE
         cd909iorvMdYnZ8IwrI5QVI5u6NRO64Lg7H5DabgXBxgOs7sjUUWw4JnuP6H6X8Dr8/B
         ccuFxP0xV4s2gQwbSzP8qlCCoebgwIn87oAXBsW2a7I/9dCrAmMQkQSUlkHyathGKVcB
         DVqadAXVBg7WYLNYfw7CNAVLrCkpLJZZGMhY+MhxhGMRYRU2pUy2LxhXsy9YSBBYC1Q0
         y1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oV2aRJfjwxrp1aTTb2RbqxY1TRDfcY5eP89TMv37HPk=;
        b=RdggTph4mZo7isfd2FxBdh42oZa7MBxda4EplEUbnxivaquHl0zRrXeXNrgYSRz9li
         7pS2OHcBVhTWCp2Nm+maWNMdTbmTmXlzU5frq38uzpR/NORDADr76BeQwDQ10m1Tdbj8
         wdQdlRd5OXqnsRdrpeRvxXZ75bN+WtEG0DUoEK8KpvvgB8j7ZWy9QGgS9XvQvSTsGySq
         WngcfZgSqas72HhOr2ZUOLBxWk7RVdq2KxSv3I7D2G4iUGQRWpvG0wG7TFHGx0pococY
         ojQm2cojwmOVY2LQlYmmvwtlCurzhGLuBenf2a5Pacfburk2RZvMRw22pmunQCYD85+D
         ABYw==
X-Gm-Message-State: APjAAAU1disuodoxDXXaYMt5o+ZvlGi7UYxj5tU8RRMwXe+j5do7SrRG
        Xbus1UnSDyF49aWJ62oSmVjaw4KQdM4VakAuneLLcg==
X-Google-Smtp-Source: APXvYqzB4GcHPIajCoaRqk+mtbqU9ThkZvnz+aumZu35NS2gtmjkBtaCY6s1EKCysJ6B6DuFDY9yNMVOckLHNPONI5s=
X-Received: by 2002:a5d:8d8f:: with SMTP id b15mr6024098ioj.296.1571159598198;
 Tue, 15 Oct 2019 10:13:18 -0700 (PDT)
MIME-Version: 1.0
References: <20191015001304.2304-1-jmattson@google.com> <20191015010740.GA24895@linux.intel.com>
In-Reply-To: <20191015010740.GA24895@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 15 Oct 2019 10:13:06 -0700
Message-ID: <CALMp9eQ-xcQSESs7et3voPU7-Jbs6X14S1U74_izYCSpyNbstg@mail.gmail.com>
Subject: Re: [PATCH v4] KVM: nVMX: Don't leak L1 MMIO regions to L2
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Cross <dcross@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 6:07 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Oct 14, 2019 at 05:13:04PM -0700, Jim Mattson wrote:
> > If the "virtualize APIC accesses" VM-execution control is set in the
> > VMCS, the APIC virtualization hardware is triggered when a page walk
> > in VMX non-root mode terminates at a PTE wherein the address of the 4k
> > page frame matches the APIC-access address specified in the VMCS. On
> > hardware, the APIC-access address may be any valid 4k-aligned physical
> > address.
> >
> > KVM's nVMX implementation enforces the additional constraint that the
> > APIC-access address specified in the vmcs12 must be backed by
> > a "struct page" in L1. If not, L0 will simply clear the "virtualize
> > APIC accesses" VM-execution control in the vmcs02.
> >
> > The problem with this approach is that the L1 guest has arranged the
> > vmcs12 EPT tables--or shadow page tables, if the "enable EPT"
> > VM-execution control is clear in the vmcs12--so that the L2 guest
> > physical address(es)--or L2 guest linear address(es)--that reference
> > the L2 APIC map to the APIC-access address specified in the
> > vmcs12. Without the "virtualize APIC accesses" VM-execution control in
> > the vmcs02, the APIC accesses in the L2 guest will directly access the
> > APIC-access page in L1.
> >
> > When there is no mapping whatsoever for the APIC-access address in L1,
> > the L2 VM just loses the intended APIC virtualization. However, when
> > the APIC-access address is mapped to an MMIO region in L1, the L2
> > guest gets direct access to the L1 MMIO device. For example, if the
> > APIC-access address specified in the vmcs12 is 0xfee00000, then L2
> > gets direct access to L1's APIC.
> >
> > Since this vmcs12 configuration is something that KVM cannot
> > faithfully emulate, the appropriate response is to exit to userspace
> > with KVM_INTERNAL_ERROR_EMULATION.
> >
> > Fixes: fe3ef05c7572 ("KVM: nVMX: Prepare vmcs02 from vmcs01 and vmcs12")
> > Reported-by: Dan Cross <dcross@google.com>
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > ---
>
> With two nits below:
>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>
> > @@ -3244,13 +3247,9 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
> >        * the nested entry.
> >        */
> >       vmx->nested.nested_run_pending = 1;
> > -     ret = nested_vmx_enter_non_root_mode(vcpu, true);
> > -     vmx->nested.nested_run_pending = !ret;
> > -     if (ret > 0)
> > -             return 1;
> > -     else if (ret)
> > -             return nested_vmx_failValid(vcpu,
> > -                     VMXERR_ENTRY_INVALID_CONTROL_FIELD);
> > +     status = nested_vmx_enter_non_root_mode(vcpu, true);
> > +     if (unlikely(status != NVMX_VMENTRY_SUCCESS))
>
> KVM doesn't usually add (un)likely annotations for things that are under
> L1's control.  The "unlikely(vmx->fail)" in nested_vmx_exit_reflected() is
> there because it's true iff KVM missed a VM-Fail condition that was caught
> by hardware.

I would argue that it makes sense to optimize for the success path in
this case. If L1 is taking the failure path more frequently than the
success path, something is wrong. Moreover, you have already indicated
that the success path should be statically predicted taken by asking
me to move the failure path out-of-line. (Forward conditional branches
are statically predicted not taken, per section 3.4.1.3 of the Intel
64 and IA-32 Architectures Optimization Reference Manual.) I'm just
asking the compiler not to undo that hint.

> > +             goto vmentry_failed;
> >
> >       /* Hide L1D cache contents from the nested guest.  */
> >       vmx->vcpu.arch.l1tf_flush_l1d = true;
> > @@ -3281,6 +3280,16 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
> >               return kvm_vcpu_halt(vcpu);
> >       }
> >       return 1;
> > +
> > +vmentry_failed:
> > +     vmx->nested.nested_run_pending = 0;
> > +     if (status == NVMX_VMENTRY_KVM_INTERNAL_ERROR)
> > +             return 0;
> > +     if (status == NVMX_VMENTRY_VMEXIT)
> > +             return 1;
> > +     WARN_ON_ONCE(status != NVMX_VMENTRY_VMFAIL);
> > +     return nested_vmx_failValid(vcpu,
> > +                                 VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>
> This can fit on a single line.
>
> >  }
> >
> >  /*
