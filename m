Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C542696CE
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgINUhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgINUhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:37:37 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2439BC06174A;
        Mon, 14 Sep 2020 13:37:37 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id di5so517648qvb.13;
        Mon, 14 Sep 2020 13:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I2OzYJ6xPeZhP4x82a+1YQaKUR65COoxfFnnaJ/SSos=;
        b=a4fihNQCoChJQs73vA2/I1/+NnZm0vixEupe6AgASWkMBub6dt2xG0l02iVCmUTALz
         0QB7w7FWvoV+wUW2vyx2/YdP4G2zk1+XzuBrCrojTBIong7alLd6eGmFt941MAvJEKM4
         9UYg+T+vgBmCRFyiQTMkxES4aRtzFNQawEtuc2TmZe342t/0FuW+Y9mNnxwQhf01Xpj2
         NUdktc5TTpPMizGLfD14JfRRb212C1M0zy9l6TwYDdD+kh3qeKiUF1VaTHB9mK898XVZ
         pA2zSAMhdKWSNG+TwNTQRw2us0+XRzmhC/5nRjWLfmB22Ah6P8RYFCzHKybhJICtQ1J8
         nEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I2OzYJ6xPeZhP4x82a+1YQaKUR65COoxfFnnaJ/SSos=;
        b=ntP7wrBqLiq6ETdUdlxWL6PyToNBZ4lZLDG2MIpwT9/z586ri95rvdOEn83SGVzB8w
         31UkrBT8CCuqfZylfgiepyJ0y4/mKsImIfJGL2Elz4M4duS6nnhYUtZWk/P8ZlS+JrZl
         roDa8BnptJM4Q86El2dbTqSD8WKj5VjF2ffMOV16fNsqG8RN66P6m0tNPWwkD437gkOI
         AeN8tKwL8m/1xiefWlyCwMA4SWp+ArZ3srglN38SzwsIIzV10YjsJcX8sSoqkL92nBCt
         uN+p3/Xxa5WNeZY9VH/YD7FpiafSF2VGE1bTlzrPLVqpaEJePM1c4uJlHM9TASjxWV0m
         +llg==
X-Gm-Message-State: AOAM530HTwx34DucFmwwprQaDG5mTq+lEbvu9njfQRZl0I57I98CVLn6
        Ris/T/4YCyEhhBuikpdCw141hMReCxS0+MOI1w4=
X-Google-Smtp-Source: ABdhPJxuyNYEuEAEPepeEZuZ8j9wSxoeTs/1RpQI9is7tY8tGnSgp8C6u4sJBGjPNsW3NoqIcQ6f/1kUiRuE1rU3UpQ=
X-Received: by 2002:a0c:90f1:: with SMTP id p104mr15149674qvp.16.1600115856253;
 Mon, 14 Sep 2020 13:37:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200914195634.12881-1-sean.j.christopherson@intel.com> <20200914195634.12881-2-sean.j.christopherson@intel.com>
In-Reply-To: <20200914195634.12881-2-sean.j.christopherson@intel.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Mon, 14 Sep 2020 22:37:25 +0200
Message-ID: <CAFULd4aNVW1Wzs=Y9+-wwFw2FyjHZRKe=SPkJ7uBdGmbN6i47A@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Move IRQ invocation to assembly subroutine
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 9:56 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Move the asm blob that invokes the appropriate IRQ handler after VM-Exit
> into a proper subroutine.  Slightly rework the blob so that it plays
> nice with objtool without any additional hints (existing hints aren't
> able to handle returning with a seemingly modified stack size).
>
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Uros Bizjak <ubizjak@gmail.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmenter.S | 28 ++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c     | 33 +++------------------------------
>  2 files changed, 31 insertions(+), 30 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 799db084a336..baec1e0fefc5 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -4,6 +4,7 @@
>  #include <asm/bitsperlong.h>
>  #include <asm/kvm_vcpu_regs.h>
>  #include <asm/nospec-branch.h>
> +#include <asm/segment.h>
>
>  #define WORD_SIZE (BITS_PER_LONG / 8)
>
> @@ -294,3 +295,30 @@ SYM_FUNC_START(vmread_error_trampoline)
>
>         ret
>  SYM_FUNC_END(vmread_error_trampoline)
> +
> +SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
> +       /*
> +        * Unconditionally create a stack frame.  RSP needs to be aligned for
> +        * x86-64, getting the correct RSP on the stack (for x86-64) would take
> +        * two instructions anyways, and it helps make objtool happy (see below).
> +        */
> +       push %_ASM_BP
> +       mov %rsp, %_ASM_BP

_ASM_SP instead of %rsp to avoid assembly failure for 32bit targets.

> +
> +#ifdef CONFIG_X86_64
> +       push $__KERNEL_DS
> +       push %_ASM_BP
> +#endif
> +       pushf
> +       push $__KERNEL_CS
> +       CALL_NOSPEC _ASM_ARG1
> +
> +       /*
> +        * "Restore" RSP from RBP, even though IRET has already unwound RSP to
> +        * the correct value.  objtool doesn't know the target will IRET and so
> +        * thinks the stack is getting walloped (without the explicit restore).
> +        */
> +       mov %_ASM_BP, %rsp
> +       pop %_ASM_BP
> +       ret
> +SYM_FUNC_END(vmx_do_interrupt_nmi_irqoff)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 46ba2e03a892..391f079d9136 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6409,6 +6409,8 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>         memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
>  }
>
> +void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
> +
>  static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>  {
>         u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
> @@ -6430,10 +6432,6 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>  static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  {
>         unsigned int vector;
> -       unsigned long entry;
> -#ifdef CONFIG_X86_64
> -       unsigned long tmp;
> -#endif
>         gate_desc *desc;
>         u32 intr_info = vmx_get_intr_info(vcpu);
>
> @@ -6443,36 +6441,11 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>
>         vector = intr_info & INTR_INFO_VECTOR_MASK;
>         desc = (gate_desc *)host_idt_base + vector;
> -       entry = gate_offset(desc);

I'd leave the above line...

>
>         kvm_before_interrupt(vcpu);
> -
> -       asm volatile(
> -#ifdef CONFIG_X86_64
> -               "mov %%rsp, %[sp]\n\t"
> -               "and $-16, %%rsp\n\t"
> -               "push %[ss]\n\t"
> -               "push %[sp]\n\t"
> -#endif
> -               "pushf\n\t"
> -               "push %[cs]\n\t"
> -               CALL_NOSPEC
> -               :
> -#ifdef CONFIG_X86_64
> -               [sp]"=&r"(tmp),
> -#endif
> -               ASM_CALL_CONSTRAINT
> -               :
> -               [thunk_target]"r"(entry),
> -#ifdef CONFIG_X86_64
> -               [ss]"i"(__KERNEL_DS),
> -#endif
> -               [cs]"i"(__KERNEL_CS)
> -       );
> -
> +       vmx_do_interrupt_nmi_irqoff(gate_offset(desc));

... to make the above line read as:

vmx_do_interrupt_nmi_irqoff(entry);

This way, it looks more descriptive to me.

Uros.

>         kvm_after_interrupt(vcpu);
>  }
> -STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
>
>  static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>  {
> --
> 2.28.0
>
