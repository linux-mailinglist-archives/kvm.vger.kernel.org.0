Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10CA3547B6
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 22:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbhDEUn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 16:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236640AbhDEUn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 16:43:26 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A0CC061788
        for <kvm@vger.kernel.org>; Mon,  5 Apr 2021 13:43:19 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id n198so11028353iod.0
        for <kvm@vger.kernel.org>; Mon, 05 Apr 2021 13:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NHI+xqVLK4P6n38OCQkQ71p7tX2h5LIjFaJxt/ywqAg=;
        b=QDoJDXFcXsGFtpr2QfWzapOPvj3qJp7sdt8z8WaT9c2hyMzs3om0SfT8iB2vhH3CoS
         uZXJYtmr53CRHh/P9NFM0rrjOQlu7NSWXq6oSYGLd1jzijfEp3DbwebDY5FjGD9wRNpJ
         Me+7RNcvmoCUW6vdHocDjlIdYX8O9Zqng2jowTcoSJhfhIvFD+1dkjt2awtOK29Wb/VK
         a7htutSZ9CJvQcmy1dGe5HK0hd85nYnOgLpr3hlH/vk99MzSXPqEtH9VrjsNOJIjz7T5
         QVegaxE8XauiWVHWbSIUr9vQtOmR9+GvD90/i/DASmD/ty7mVOq3L/R2LeTPNnRWTEFx
         Cpyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NHI+xqVLK4P6n38OCQkQ71p7tX2h5LIjFaJxt/ywqAg=;
        b=W3KVUfBQv9Rz9b7tOuXJ3Bef2ROaZP9UytehAmuSTTh5Y2B5+wg+QChPY7q5lUoFYl
         bZbSfVt+iZaUAQvIr4X9TKLaGuqd4/CFNo1ZaNZ+zAD+gcUHCkpyRsrstsVl0DsIBABk
         5HDMf3q2nB9/gEwJk1TC4TtJ+OXWWAaNh3drHrFJ4/K3pwNmw2xtPpUb1T3I38FDhQCh
         T94MMbE7Na+6e/Lgyy5TdBCy1z/yVrp51j/riS9ZY8Xhl6/L+XOmc3+jtjJPAKRP+b9x
         2trotiTA0tEgsFy0d85eiVAhF+CmiuW1HCaO8AvBiEH/sx9gooMpqvJAX67F9nO89QYW
         KnBw==
X-Gm-Message-State: AOAM5333HUhZyZ3UrMQHBxKZ5mM7L+6lJr695s3nliH/x+vUvfvzMU2Y
        DiVXGwi/sRI+RJ2fqsE198NutXYIym6Zz+/NuQyPIQ==
X-Google-Smtp-Source: ABdhPJz6j0NEV6Exhmgjdz5KYswxalLHNoIEjFX2w5h3qnx5aeRqcblXA2aADyITeiVQb4Fk9lhZ6XBMHdrZboUM8BM=
X-Received: by 2002:a02:c6c4:: with SMTP id r4mr24939912jan.77.1617655398273;
 Mon, 05 Apr 2021 13:43:18 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617302792.git.ashish.kalra@amd.com> <4da0d40c309a21ba3952d06f346b6411930729c9.1617302792.git.ashish.kalra@amd.com>
In-Reply-To: <4da0d40c309a21ba3952d06f346b6411930729c9.1617302792.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 5 Apr 2021 13:42:42 -0700
Message-ID: <CABayD+fF7+sn444rMuE_SNwN-SYSPwJr1mrW3qRYw4H7ryi-aw@mail.gmail.com>
Subject: Re: [PATCH v11 08/13] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Will Deacon <will@kernel.org>, maz@kernel.org,
        Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 5, 2021 at 7:28 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> This hypercall is used by the SEV guest to notify a change in the page
> encryption status to the hypervisor. The hypercall should be invoked
> only when the encryption attribute is changed from encrypted -> decrypted
> and vice versa. By default all guest pages are considered encrypted.
>
> The hypercall exits to userspace to manage the guest shared regions and
> integrate with the userspace VMM's migration code.
>
> The patch integrates and extends DMA_SHARE/UNSHARE hypercall to
> userspace exit functionality (arm64-specific) patch from Marc Zyngier,
> to avoid arch-specific stuff and have a common interface
> from the guest back to the VMM and sharing of the host handling of the
> hypercall to support use case for a guest to share memory with a host.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  Documentation/virt/kvm/api.rst        | 18 ++++++++
>  Documentation/virt/kvm/hypercalls.rst | 15 +++++++
>  arch/x86/include/asm/kvm_host.h       |  2 +
>  arch/x86/kvm/svm/sev.c                | 61 +++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c                |  2 +
>  arch/x86/kvm/svm/svm.h                |  2 +
>  arch/x86/kvm/vmx/vmx.c                |  1 +
>  arch/x86/kvm/x86.c                    | 12 ++++++
>  include/uapi/linux/kvm.h              |  8 ++++
>  include/uapi/linux/kvm_para.h         |  1 +
>  10 files changed, 122 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 307f2fcf1b02..52bd7e475fd6 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5475,6 +5475,24 @@ Valid values for 'type' are:
>      Userspace is expected to place the hypercall result into the appropriate
>      field before invoking KVM_RUN again.
>
> +::
> +
> +               /* KVM_EXIT_DMA_SHARE / KVM_EXIT_DMA_UNSHARE */
> +               struct {
> +                       __u64 addr;
> +                       __u64 len;
> +                       __u64 ret;
> +               } dma_sharing;
> +
> +This defines a common interface from the guest back to the KVM to support
> +use case for a guest to share memory with a host.
> +
> +The addr and len fields define the starting address and length of the
> +shared memory region.
> +
> +Userspace is expected to place the hypercall result into the "ret" field
> +before invoking KVM_RUN again.
> +
>  ::
>
>                 /* Fix the size of the union. */
> diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
> index ed4fddd364ea..7aff0cebab7c 100644
> --- a/Documentation/virt/kvm/hypercalls.rst
> +++ b/Documentation/virt/kvm/hypercalls.rst
> @@ -169,3 +169,18 @@ a0: destination APIC ID
>
>  :Usage example: When sending a call-function IPI-many to vCPUs, yield if
>                 any of the IPI target vCPUs was preempted.
> +
> +
> +8. KVM_HC_PAGE_ENC_STATUS
> +-------------------------
> +:Architecture: x86
> +:Status: active
> +:Purpose: Notify the encryption status changes in guest page table (SEV guest)
> +
> +a0: the guest physical address of the start page
> +a1: the number of pages
> +a2: encryption attribute
> +
> +   Where:
> +       * 1: Encryption attribute is set
> +       * 0: Encryption attribute is cleared
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3768819693e5..78284ebbbee7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1352,6 +1352,8 @@ struct kvm_x86_ops {
>         int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
>
>         void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> +       int (*page_enc_status_hc)(struct kvm_vcpu *vcpu, unsigned long gpa,
> +                                 unsigned long sz, unsigned long mode);
>  };
>
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c9795a22e502..fb3a315e5827 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1544,6 +1544,67 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         return ret;
>  }
>
> +static int sev_complete_userspace_page_enc_status_hc(struct kvm_vcpu *vcpu)
> +{
> +       vcpu->run->exit_reason = 0;
I don't believe you need to clear exit_reason: it's universally set on exit.

> +       kvm_rax_write(vcpu, vcpu->run->dma_sharing.ret);
> +       ++vcpu->stat.hypercalls;
> +       return kvm_skip_emulated_instruction(vcpu);
> +}
> +
> +int svm_page_enc_status_hc(struct kvm_vcpu *vcpu, unsigned long gpa,
> +                          unsigned long npages, unsigned long enc)
> +{
> +       kvm_pfn_t pfn_start, pfn_end;
> +       struct kvm *kvm = vcpu->kvm;
> +       gfn_t gfn_start, gfn_end;
> +
> +       if (!sev_guest(kvm))
> +               return -EINVAL;
> +
> +       if (!npages)
> +               return 0;
> +
> +       gfn_start = gpa_to_gfn(gpa);
> +       gfn_end = gfn_start + npages;
> +
> +       /* out of bound access error check */
> +       if (gfn_end <= gfn_start)
> +               return -EINVAL;
> +
> +       /* lets make sure that gpa exist in our memslot */
> +       pfn_start = gfn_to_pfn(kvm, gfn_start);
> +       pfn_end = gfn_to_pfn(kvm, gfn_end);
> +
> +       if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
> +               /*
> +                * Allow guest MMIO range(s) to be added
> +                * to the shared pages list.
> +                */
> +               return -EINVAL;
> +       }
> +
> +       if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
> +               /*
> +                * Allow guest MMIO range(s) to be added
> +                * to the shared pages list.
> +                */
> +               return -EINVAL;
> +       }
> +
> +       if (enc)
> +               vcpu->run->exit_reason = KVM_EXIT_DMA_UNSHARE;
> +       else
> +               vcpu->run->exit_reason = KVM_EXIT_DMA_SHARE;
> +
> +       vcpu->run->dma_sharing.addr = gfn_start;
> +       vcpu->run->dma_sharing.len = npages * PAGE_SIZE;
> +       vcpu->arch.complete_userspace_io =
> +               sev_complete_userspace_page_enc_status_hc;
> +
> +       return 0;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>         struct kvm_sev_cmd sev_cmd;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 58a45bb139f8..3cbf000beff1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4620,6 +4620,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>         .complete_emulated_msr = svm_complete_emulated_msr,
>
>         .vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> +
> +       .page_enc_status_hc = svm_page_enc_status_hc,
>  };
>
>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 39e071fdab0c..9cc16d2c0b8f 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -451,6 +451,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
>                                bool has_error_code, u32 error_code);
>  int nested_svm_exit_special(struct vcpu_svm *svm);
>  void sync_nested_vmcb_control(struct vcpu_svm *svm);
> +int svm_page_enc_status_hc(struct kvm_vcpu *vcpu, unsigned long gpa,
> +                          unsigned long npages, unsigned long enc);
>
>  extern struct kvm_x86_nested_ops svm_nested_ops;
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 32cf8287d4a7..2c98a5ed554b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7748,6 +7748,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>         .can_emulate_instruction = vmx_can_emulate_instruction,
>         .apic_init_signal_blocked = vmx_apic_init_signal_blocked,
>         .migrate_timers = vmx_migrate_timers,
> +       .page_enc_status_hc = NULL,
>
>         .msr_filter_changed = vmx_msr_filter_changed,
>         .complete_emulated_msr = kvm_complete_insn_gp,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f7d12fca397b..ef5c77d59651 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8273,6 +8273,18 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>                 kvm_sched_yield(vcpu->kvm, a0);
>                 ret = 0;
>                 break;
> +       case KVM_HC_PAGE_ENC_STATUS: {
> +               int r;
> +
> +               ret = -KVM_ENOSYS;
> +               if (kvm_x86_ops.page_enc_status_hc) {
> +                       r = kvm_x86_ops.page_enc_status_hc(vcpu, a0, a1, a2);
> +                       if (r >= 0)
> +                               return r;
> +                       ret = r;
Style nit: Why not just set ret, and return ret if ret >=0?

This looks good. I just had a few nitpicks.
Reviewed-by: Steve Rutherford <srutherford@google.com>
