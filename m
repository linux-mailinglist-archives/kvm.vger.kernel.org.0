Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA1C1F7CBA
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 20:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgFLSCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 14:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgFLSCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 14:02:40 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A83C08C5C1
        for <kvm@vger.kernel.org>; Fri, 12 Jun 2020 11:02:40 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id 9so9560717ilg.12
        for <kvm@vger.kernel.org>; Fri, 12 Jun 2020 11:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9RL+bnA/t2I9/+f9q05Ybqo0E3j+56AnUDjas91ew54=;
        b=Jv/2G/vn4x8GMl1fZ0geyYu4vyr+9hmLf0uaIzTgdJJJEZTB9bZ5j/o40j4iJOlFSF
         ER2WuILuNoFA7JbFr8BJ3zJNhOTxe9iuHk5xnfuJsFs/Drs8nfMJKcqkDz0HCUwrXh0L
         zGpp1MLMv7nmDSyxMaLpP7RdRv5gvP5XcfIoDSowiHxaw+zH5xvByj3T+LWkQJdmAKNK
         /ES++BBIygsuY7os+0wwrQ3g4v+lygL8FQRwtRmImzr57NiO9zN3fvh71Z3+CwVn0OL+
         gcUaQpLqyBzRjGioJePGNxWlazWp2TgAi89mGP+L1xVQHkLLLjk3Hg04fphtdykSKfP3
         Qyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9RL+bnA/t2I9/+f9q05Ybqo0E3j+56AnUDjas91ew54=;
        b=shLNjgdoW4H2ZppMa/DoRD92PuLpIdyJg+RbE/w697qJVdhAQDYPNUDYxRlRxYifpq
         IIjC15HaDSZMUANFFW8BJk1SRX1CY2d7ARGgcI4cSu+cn5zfqGh7evUS/6ZF3swF2Twz
         zyMO+p42xHqhaN3TnZSgy3F5ATymiortyn0hJ5nG1mty9LkaU9buojj1hgBMGukqiVgm
         kztmgG+WkzFWuwcK2WErIaGoraCZmrdsNI4VV1iMZ5sXcEdN1168Jw7H+3OUxNkT1FD/
         3w5DlmH4QAqFul/7R7ZxEKeGAr6QxPkiilXxYxOYWDeNKFzFyayruyjhf0aBzH1RzXVr
         NFIQ==
X-Gm-Message-State: AOAM531pzzp6r0aBzoDj7b01amdU0iuZht2HOsx/zyzTI2af5oPUBC/e
        lnaadycHRcC8u93gWq8UQBtOiExP3qnlkyzLMbrkrQ==
X-Google-Smtp-Source: ABdhPJzv+UbygrLkbplfQ0ru5zjr+YIfYtosjexMqhll0H1zaMLhcXAncJgne3gr2xVXTmCOtMNsXHLM/+KS7jvi7w4=
X-Received: by 2002:a05:6e02:11a5:: with SMTP id 5mr14477842ilj.108.1591984959242;
 Fri, 12 Jun 2020 11:02:39 -0700 (PDT)
MIME-Version: 1.0
References: <159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu> <159191211555.31436.7157754769653935735.stgit@bmoger-ubuntu>
In-Reply-To: <159191211555.31436.7157754769653935735.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 12 Jun 2020 11:02:28 -0700
Message-ID: <CALMp9eQrC5a2oquCPerEm29p482mik7Zbh=o74waTY6xqXZohA@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: X86: Move handling of INVPCID types to x86
To:     Babu Moger <babu.moger@amd.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 2:48 PM Babu Moger <babu.moger@amd.com> wrote:
>
> INVPCID instruction handling is mostly same across both VMX and
> SVM. So, move the code to common x86.c.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/kvm/vmx/vmx.c |   78 +-----------------------------------------
>  arch/x86/kvm/x86.c     |   89 ++++++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.h     |    2 +
>  3 files changed, 92 insertions(+), 77 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 170cc76a581f..d9c35f337da6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5477,29 +5477,15 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
>  {
>         u32 vmx_instruction_info;
>         unsigned long type;
> -       bool pcid_enabled;
>         gva_t gva;
> -       struct x86_exception e;
> -       unsigned i;
> -       unsigned long roots_to_free = 0;
>         struct {
>                 u64 pcid;
>                 u64 gla;
>         } operand;
>
> -       if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
> -               kvm_queue_exception(vcpu, UD_VECTOR);
> -               return 1;
> -       }
> -
>         vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
>         type = kvm_register_readl(vcpu, (vmx_instruction_info >> 28) & 0xf);
>
> -       if (type > 3) {
> -               kvm_inject_gp(vcpu, 0);
> -               return 1;
> -       }
> -

You've introduced some fault priority inversions by sinking the above
tests for #UD and #GP below the call to get_vmx_mem_address(), which
may raise #UD, #GP, or #SS.

>         /* According to the Intel instruction reference, the memory operand
>          * is read even if it isn't needed (e.g., for type==all)
>          */
> @@ -5508,69 +5494,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
>                                 sizeof(operand), &gva))
>                 return 1;
>
> -       if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
> -               kvm_inject_emulated_page_fault(vcpu, &e);
> -               return 1;
> -       }
> -
> -       if (operand.pcid >> 12 != 0) {
> -               kvm_inject_gp(vcpu, 0);
> -               return 1;
> -       }
> -
> -       pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> -
> -       switch (type) {
> -       case INVPCID_TYPE_INDIV_ADDR:
> -               if ((!pcid_enabled && (operand.pcid != 0)) ||
> -                   is_noncanonical_address(operand.gla, vcpu)) {
> -                       kvm_inject_gp(vcpu, 0);
> -                       return 1;
> -               }
> -               kvm_mmu_invpcid_gva(vcpu, operand.gla, operand.pcid);
> -               return kvm_skip_emulated_instruction(vcpu);
> -
> -       case INVPCID_TYPE_SINGLE_CTXT:
> -               if (!pcid_enabled && (operand.pcid != 0)) {
> -                       kvm_inject_gp(vcpu, 0);
> -                       return 1;
> -               }
> -
> -               if (kvm_get_active_pcid(vcpu) == operand.pcid) {
> -                       kvm_mmu_sync_roots(vcpu);
> -                       kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> -               }
> -
> -               for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> -                       if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].pgd)
> -                           == operand.pcid)
> -                               roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
> -
> -               kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
> -               /*
> -                * If neither the current cr3 nor any of the prev_roots use the
> -                * given PCID, then nothing needs to be done here because a
> -                * resync will happen anyway before switching to any other CR3.
> -                */
> -
> -               return kvm_skip_emulated_instruction(vcpu);
> -
> -       case INVPCID_TYPE_ALL_NON_GLOBAL:
> -               /*
> -                * Currently, KVM doesn't mark global entries in the shadow
> -                * page tables, so a non-global flush just degenerates to a
> -                * global flush. If needed, we could optimize this later by
> -                * keeping track of global entries in shadow page tables.
> -                */
> -
> -               /* fall-through */
> -       case INVPCID_TYPE_ALL_INCL_GLOBAL:
> -               kvm_mmu_unload(vcpu);
> -               return kvm_skip_emulated_instruction(vcpu);
> -
> -       default:
> -               BUG(); /* We have already checked above that type <= 3 */
> -       }
> +       return kvm_handle_invpcid_types(vcpu,  gva, type);
>  }
>
>  static int handle_pml_full(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9e41b5135340..13373359608c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -72,6 +72,7 @@
>  #include <asm/hypervisor.h>
>  #include <asm/intel_pt.h>
>  #include <asm/emulate_prefix.h>
> +#include <asm/tlbflush.h>
>  #include <clocksource/hyperv_timer.h>
>
>  #define CREATE_TRACE_POINTS
> @@ -10714,6 +10715,94 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
>
> +int kvm_handle_invpcid_types(struct kvm_vcpu *vcpu, gva_t gva,
> +                            unsigned long type)
> +{
> +       unsigned long roots_to_free = 0;
> +       struct x86_exception e;
> +       bool pcid_enabled;
> +       unsigned i;
> +       struct {
> +               u64 pcid;
> +               u64 gla;
> +       } operand;
> +
> +       if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
> +               kvm_queue_exception(vcpu, UD_VECTOR);
> +               return 1;
> +       }
> +
> +       if (type > 3) {
> +               kvm_inject_gp(vcpu, 0);
> +               return 1;
> +       }
> +
> +       if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
> +               kvm_inject_emulated_page_fault(vcpu, &e);
> +               return 1;
> +       }
> +
> +       if (operand.pcid >> 12 != 0) {
> +               kvm_inject_gp(vcpu, 0);
> +               return 1;
> +       }
> +
> +       pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> +
> +       switch (type) {
> +       case INVPCID_TYPE_INDIV_ADDR:
> +               if ((!pcid_enabled && (operand.pcid != 0)) ||
> +                   is_noncanonical_address(operand.gla, vcpu)) {
> +                       kvm_inject_gp(vcpu, 0);
> +                       return 1;
> +               }
> +               kvm_mmu_invpcid_gva(vcpu, operand.gla, operand.pcid);
> +               return kvm_skip_emulated_instruction(vcpu);
> +
> +       case INVPCID_TYPE_SINGLE_CTXT:
> +               if (!pcid_enabled && (operand.pcid != 0)) {
> +                       kvm_inject_gp(vcpu, 0);
> +                       return 1;
> +               }
> +
> +               if (kvm_get_active_pcid(vcpu) == operand.pcid) {
> +                       kvm_mmu_sync_roots(vcpu);
> +                       kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> +               }
> +
> +               for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> +                       if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].pgd)
> +                           == operand.pcid)
> +                               roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
> +
> +               kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
> +               /*
> +                * If neither the current cr3 nor any of the prev_roots use the
> +                * given PCID, then nothing needs to be done here because a
> +                * resync will happen anyway before switching to any other CR3.
> +                */
> +
> +               return kvm_skip_emulated_instruction(vcpu);
> +
> +       case INVPCID_TYPE_ALL_NON_GLOBAL:
> +               /*
> +                * Currently, KVM doesn't mark global entries in the shadow
> +                * page tables, so a non-global flush just degenerates to a
> +                * global flush. If needed, we could optimize this later by
> +                * keeping track of global entries in shadow page tables.
> +                */
> +
> +               /* fall-through */
> +       case INVPCID_TYPE_ALL_INCL_GLOBAL:
> +               kvm_mmu_unload(vcpu);
> +               return kvm_skip_emulated_instruction(vcpu);
> +
> +       default:
> +               BUG(); /* We have already checked above that type <= 3 */
> +       }
> +}
> +EXPORT_SYMBOL_GPL(kvm_handle_invpcid_types);
> +
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 6eb62e97e59f..8e23f2705344 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -365,5 +365,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
>  void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
>  u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
>  bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
> +int kvm_handle_invpcid_types(struct kvm_vcpu *vcpu, gva_t gva,
> +                            unsigned long type);
>
>  #endif
>
