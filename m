Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1CB244001
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 22:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHMUoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 16:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgHMUoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 16:44:21 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537EFC061757
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 13:44:21 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id w25so7637653ljo.12
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 13:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SXxKCMzN27egp8LRywm9+4+JxqSEbai9A8e5j4MAwuk=;
        b=KU3yeEqDT3nbztzoRsLLNXZmAXGWfn+eRZUUrgGV2HmhBA8HMmOX8AOsVDcueboROr
         yH2CfjyzpwP3mIXoT3XcbCGnwQsGFV43nZ4gguD3jHj2wDVb8C2b47RyV1C0bBPhtIxo
         HePV4EQ3wrVBiV0a5D2rlGEc7lzaTkVjUtFfEsfIxu3yEXPG9oTYpbBuf+MwLLgOH55U
         86kcyDFRFI+sdTw5Krrj2jIf+xP0ulQh67tD1NaUeKAjKy4TL6tObCoXI1w5C14+CXKF
         J6u36+VbVRya399Vc5+N5zQG8zJiozqZ4ZfdNK/IMpt8nJBO/y+75L979Y3z1KTQTdAX
         M62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SXxKCMzN27egp8LRywm9+4+JxqSEbai9A8e5j4MAwuk=;
        b=VV8m/p7DeeCBjTsc5gzkrDGGcusGnnRT/7h/PuORjLoujR0Tu8YF6F7Ki8wohSw2S6
         FBwcViSHH2czuDCt/UlMkGXGRfER+vmQDRmu1bhgqGQuo3LAFjJCdDAQJ7+ArD3g3LJB
         dPNfsu9t3dYVOsEdfOKSPBXdXhbIdAagq9NHsOZdLW78nISNIvG+IhQ2xMKVxj0Ks+oV
         qDDlWgk+zDT3/SnWD3ai5rfxpCVVG3DYd1FCc8MsZVnopJJbh7cls+VvcpwShCsF/+R5
         5usfh3HldUywD06LzHFh/q8t7Yg/7k8I26+fBSEk7EAWwdJg6/PpY/K+5qtVsPkWLHyc
         5zHA==
X-Gm-Message-State: AOAM5334p1nq5aigW5DcMqdXeauem3mza6tibTmJg1iaApWNSsEkG/80
        9xdr4fn1HJBOTShSB2RPBsBLvNB00cSqJ3xEkzTVSQ==
X-Google-Smtp-Source: ABdhPJwE2vx6YeBFXLal858/BWqH46CCDXHVJIgHykTYXV2Df1bjHz4UIr9XfPxz9VlqXfIK1kjXsrJdyo8Js0Afxu0=
X-Received: by 2002:a2e:99cc:: with SMTP id l12mr2669082ljj.235.1597351459260;
 Thu, 13 Aug 2020 13:44:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200616224305.44242-1-oupton@google.com> <20200813170331.GI29439@linux.intel.com>
In-Reply-To: <20200813170331.GI29439@linux.intel.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 13 Aug 2020 15:44:08 -0500
Message-ID: <CAOQ_QsiVV7Btj5yJ5Dpqxf3V7OuHY3N9b1xW6rrZjyv6dOC8ig@mail.gmail.com>
Subject: Re: [PATCH] kvm: nVMX: flush TLB when decoded insn != VM-exit reason
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 12:03 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Jun 16, 2020 at 10:43:05PM +0000, Oliver Upton wrote:
> > It is possible for the instruction emulator to decode a different
> > instruction from what was implied by the VM-exit information provided by
> > hardware in vmcs02. Such is the case when the TLB entry for the guest's
> > IP is out of sync with the appropriate page-table mapping if page
> > installation isn't followed with a TLB flush.
> >
> > Currently, KVM refuses to emulate in these scenarios, instead injecting
> > a #UD into L2. While this does address the security risk of
> > CVE-2020-2732, it could result in spurious #UDs to the L2 guest. Fix
> > this by instead flushing the TLB then resuming L2, allowing hardware to
> > generate the appropriate VM-exit to be reflected into L1.
> >
> > Exceptional handling is also required for RSM and RDTSCP instructions.
> > RDTSCP could be emulated on hardware which doesn't support it,
> > therefore hardware will not generate a RDTSCP VM-exit on L2 resume. The
> > dual-monitor treatment of SMM is not supported in nVMX, which implies
> > that L0 should never handle a RSM instruction. Resuming the guest will
> > only result in another #UD. Avoid getting stuck in a loop with these
> > instructions by injecting a #UD for RSM and the appropriate VM-exit for
> > RDTSCP.
> >
> > Fixes: 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > ---
> >  arch/x86/kvm/emulate.c     |  2 ++
> >  arch/x86/kvm/kvm_emulate.h |  1 +
> >  arch/x86/kvm/vmx/vmx.c     | 68 ++++++++++++++++++++++++++++----------
> >  arch/x86/kvm/x86.c         |  2 +-
> >  4 files changed, 55 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index d0e2825ae617..6e56e7a29ba1 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -5812,6 +5812,8 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
> >       }
> >       if (rc == X86EMUL_INTERCEPTED)
> >               return EMULATION_INTERCEPTED;
> > +     if (rc == X86EMUL_RETRY_INSTR)
> > +             return EMULATION_RETRY_INSTR;
> >
> >       if (rc == X86EMUL_CONTINUE)
> >               writeback_registers(ctxt);
> > diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> > index 43c93ffa76ed..5bfab8d65cd1 100644
> > --- a/arch/x86/kvm/kvm_emulate.h
> > +++ b/arch/x86/kvm/kvm_emulate.h
> > @@ -496,6 +496,7 @@ bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
> >  #define EMULATION_OK 0
> >  #define EMULATION_RESTART 1
> >  #define EMULATION_INTERCEPTED 2
> > +#define EMULATION_RETRY_INSTR 3
> >  void init_decode_cache(struct x86_emulate_ctxt *ctxt);
> >  int x86_emulate_insn(struct x86_emulate_ctxt *ctxt);
> >  int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 08e26a9518c2..ebfafd7837ba 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7329,12 +7329,11 @@ static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
> >       to_vmx(vcpu)->req_immediate_exit = true;
> >  }
> >
> > -static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
> > -                               struct x86_instruction_info *info)
> > +static bool vmx_check_intercept_io(struct kvm_vcpu *vcpu,
> > +                                struct x86_instruction_info *info)
> >  {
> >       struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> >       unsigned short port;
> > -     bool intercept;
> >       int size;
> >
> >       if (info->intercept == x86_intercept_in ||
> > @@ -7354,13 +7353,10 @@ static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
> >        * Otherwise, IO instruction VM-exits are controlled by the IO bitmaps.
> >        */
> >       if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
> > -             intercept = nested_cpu_has(vmcs12,
> > -                                        CPU_BASED_UNCOND_IO_EXITING);
> > -     else
> > -             intercept = nested_vmx_check_io_bitmaps(vcpu, port, size);
> > +             return nested_cpu_has(vmcs12,
> > +                                   CPU_BASED_UNCOND_IO_EXITING);
> >
> > -     /* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
> > -     return intercept ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
> > +     return nested_vmx_check_io_bitmaps(vcpu, port, size);
>
> It might be a slightly bigger patch, but I think it'll be cleaner code in the
> end if this section is reordered to:
>
>         /*
>          * If the 'use IO bitmaps' VM-execution control is 1, IO instruction
>          * VM-exits are controlled by the IO bitmaps, otherwise they depend
>          * on the 'unconditional IO exiting' VM-execution control.
>          */
>         if (nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
>                 return nested_vmx_check_io_bitmaps(vcpu, port, size);
>
>         return nested_cpu_has(vmcs12, CPU_BASED_UNCOND_IO_EXITING);
>
> >  }
> >
> >  static int vmx_check_intercept(struct kvm_vcpu *vcpu,
> > @@ -7369,6 +7365,7 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
> >                              struct x86_exception *exception)
> >  {
> >       struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> > +     bool intercepted;
> >
> >       switch (info->intercept) {
> >       /*
> > @@ -7381,13 +7378,27 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
> >                       exception->error_code_valid = false;
> >                       return X86EMUL_PROPAGATE_FAULT;
> >               }
> > +
> > +             intercepted = nested_cpu_has(vmcs12, CPU_BASED_RDTSC_EXITING);
> > +
> > +             /*
> > +              * RDTSCP could be emulated on a CPU which doesn't support it.
> > +              * As such, flushing the TLB and resuming L2 will result in
> > +              * another #UD rather than a VM-exit to reflect into L1.
> > +              * Instead, synthesize the VM-exit here.
> > +              */
> > +             if (intercepted) {
> > +                     nested_vmx_vmexit(vcpu, EXIT_REASON_RDTSCP, 0, 0);
> > +                     return X86EMUL_INTERCEPTED;
> > +             }
>
> Maybe this instead?
>
>                 if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_RDTSCP)) {
>                         exception->vector = UD_VECTOR;
>                         exception->error_code_valid = false;
>                         return X86EMUL_PROPAGATE_FAULT;
>                 } else if (nested_cpu_has(vmcs12, CPU_BASED_RDTSC_EXITING)) {
>                         /*
>                          * RDTSCP could be emulated on a CPU which doesn't
>                          * support it.  As such, flushing the TLB and resuming
>                          * L2 will result in another #UD rather than a VM-exit
>                          * to reflect into L1.  Instead, synthesize the VM-exit
>                          * here.
>                          */
>                         nested_vmx_vmexit(vcpu, EXIT_REASON_RDTSCP, 0, 0);
>                         return X86EMUL_INTERCEPTED;
>                 }
>                 intercepted = false;
>
>
> >               break;
> >
> >       case x86_intercept_in:
> >       case x86_intercept_ins:
> >       case x86_intercept_out:
> >       case x86_intercept_outs:
> > -             return vmx_check_intercept_io(vcpu, info);
> > +             intercepted = vmx_check_intercept_io(vcpu, info);
> > +             break;
> >
> >       case x86_intercept_lgdt:
> >       case x86_intercept_lidt:
> > @@ -7397,18 +7408,41 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
> >       case x86_intercept_sidt:
> >       case x86_intercept_sldt:
> >       case x86_intercept_str:
> > -             if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC))
> > -                     return X86EMUL_CONTINUE;
> > -
> > -             /* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
> > +             intercepted = nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC);
> >               break;
> >
> > -     /* TODO: check more intercepts... */
> > +     /*
> > +      * The dual-monitor treatment of SMM is not supported in nVMX. As such,
> > +      * L0 will never handle the RSM instruction nor should it retry
> > +      * instruction execution. Instead, a #UD should be injected into the
> > +      * guest for the execution of RSM outside of SMM.
> > +      */
> > +     case x86_intercept_rsm:
> > +             exception->vector = UD_VECTOR;
> > +             exception->error_code_valid = false;
> > +             return X86EMUL_PROPAGATE_FAULT;
>
> Why does RSM need special treatment?  Won't it just naturally #UD if we fall
> through to the flush-and-retry path?
>
> >       default:
> > -             break;
> > +             intercepted = true;
> >       }
> >
> > -     return X86EMUL_UNHANDLEABLE;
> > +     if (!intercepted)
> > +             return X86EMUL_CONTINUE;
> > +
> > +     /*
> > +      * The only uses of the emulator in VMX for instructions which may be
> > +      * intercepted are port IO instructions, descriptor-table accesses, and
> > +      * the RDTSCP instruction. As such, if the emulator has decoded an
>
> I wouldn't list out the individual cases, it's pretty obvious what can be
> emulated by looking at the above code, and inevitably something will be added
> that requires updating this comment.
>
> > +      * instruction that is different from the VM-exit provided by hardware
> > +      * it is likely that the TLB entry and page-table mapping for the
>
> Probaby better to avoid talking about "page-table mapping", because it's not
> clear which page tables are being referenced.
>
> > +      * guest's RIP are out of sync.
>
> Maybe something like:
>
>         /*
>          * There are very few instructions that KVM will emulate for L2 and can
>          * also be intercepted by l1.  If the emulator decoded an instruction
>          * that is different from the VM-exit provided by hardware, the TLB
>          * entry for guest's RIP is likely stale.  Rather than synthesizing a
>          * VM-exit into L1 for every possible instruction, just flush the TLB,
>          * resume L2, and let hardware generate the appropriate VM-exit.
>          */
>
> > +      *
> > +      * Rather than synthesizing a VM-exit into L1 for every possible
> > +      * instruction just flush the TLB, resume L2, and let hardware generate
> > +      * the appropriate VM-exit.
> > +      */
> > +     vmx_flush_tlb_gva(vcpu, kvm_rip_read(vcpu));
>
> This is wrong, it should flush kvm_get_linear_rip(vcpu).
>

I do not believe that the aim of this patch will work anymore, since:

1dbf5d68af6f ("KVM: VMX: Add guest physical address check in EPT
violation and misconfig")

Since it is possible to get into the emulator on any instruction that
induces an EPT violation, we'd wind up looping when we believe the
instruction needs to exit to L1 (TLB flush, resume guest, hit the same
EPT violation. Rinse, wash, repeat).

> > +     return X86EMUL_RETRY_INSTR;
> >  }
> >
> >  #ifdef CONFIG_X86_64
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 00c88c2f34e4..2ab47485100f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -6967,7 +6967,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >
> >       r = x86_emulate_insn(ctxt);
> >
> > -     if (r == EMULATION_INTERCEPTED)
> > +     if (r == EMULATION_INTERCEPTED || r == EMULATION_RETRY_INSTR)
> >               return 1;
> >
> >       if (r == EMULATION_FAILED) {
> > --
> > 2.27.0.290.gba653c62da-goog
> >
