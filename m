Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FBE2043BB
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbgFVWin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730927AbgFVWin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:38:43 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F3FC061573
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 15:38:42 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id i3so21220488ljg.3
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 15:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QwQUn2hTU2IS6vsmkshxssfHtwp9dPrk52PNlwXxDc4=;
        b=SuxmVZZfuVkIWYKOfQ38fjqRpc9qQ7/KP2oi5aA0YRPs7VNhBGZ0NQI5X+oSvOe18w
         Uf67nH0gygAfMX0iNC71WFezfzVYhws0z6hrVc2pVCrWHxF4Yl5nxLh5wTwYaoAEV8jh
         Fr+3AZfbC840zN8cOCGYWMXycHPpnMXXZGLxdudvQEG8N7Yg9ShtBSyxV+9/3uwO5MnH
         Q1RSEzjjhjSfMHhoXIs7NINJXzk/iipPjTOaI30GlsxThWMRFTVsdKD7vj+sV8/f+QGV
         o3bVG+5Agf6FhlJZtHhh3KvJ/lpcPHOvW9omlusnhMNmnW33gZiyhsIyEcoAI1OxQOSL
         DUTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QwQUn2hTU2IS6vsmkshxssfHtwp9dPrk52PNlwXxDc4=;
        b=DvyceaF+DCxtDnCkVvLaxEmKqYXM6AGvgTZpFur8Zla738WFTeh6OoXCD7I+KNYK6C
         0xlOen8de4GvxX+3PGvNKu1JrJU42SH08ebBupGozQJ53RW5IWEjrxyOB7gUZP3sGbyE
         58ZxaEL3Cq0A6JhERHcXZX2tloAJiTrJAN+w3egdYp/5IWf/xGwk21WNcTCLhdBF5eKu
         I9/ihuE6rPIrZbnWW92PpU0xX0n5vPxk+Z+4dKYNqlxz5j0hNytM42U5BEFTWg2LZaLK
         oPyFrVZjJvu4BmyHLYBZQanS4ClDxEtpGxmlXcNxsbE9oadaP8W7b9TtNG2pRk0ObUxq
         aahw==
X-Gm-Message-State: AOAM532maBS9oU5/HfO/9TZSAh9bstSLeQ325A75gJe8bOUl+JU7y7LD
        4TycVpJGq9RGUv+0wC3ps83eJGU18VzMyLgGgHw+Qp6r/YI=
X-Google-Smtp-Source: ABdhPJyje+YN6rWzpa56LRlUsLelT33fg5UGpKXKa56N3oqmRp/tspJVcbrBBxz2gqdXSTN6g3VKgLGSwgCK8gOpQxE=
X-Received: by 2002:a2e:8e97:: with SMTP id z23mr9272455ljk.399.1592865520468;
 Mon, 22 Jun 2020 15:38:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200616224305.44242-1-oupton@google.com>
In-Reply-To: <20200616224305.44242-1-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 22 Jun 2020 15:38:29 -0700
Message-ID: <CAOQ_QsjFTzf0gdoSnRrOYQoNtUPVM6NhAfQQ+PDke+Vxv8wL+A@mail.gmail.com>
Subject: Re: [PATCH] kvm: nVMX: flush TLB when decoded insn != VM-exit reason
To:     kvm list <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 16, 2020 at 3:43 PM Oliver Upton <oupton@google.com> wrote:
>
> It is possible for the instruction emulator to decode a different
> instruction from what was implied by the VM-exit information provided by
> hardware in vmcs02. Such is the case when the TLB entry for the guest's
> IP is out of sync with the appropriate page-table mapping if page
> installation isn't followed with a TLB flush.
>
> Currently, KVM refuses to emulate in these scenarios, instead injecting
> a #UD into L2. While this does address the security risk of
> CVE-2020-2732, it could result in spurious #UDs to the L2 guest. Fix
> this by instead flushing the TLB then resuming L2, allowing hardware to
> generate the appropriate VM-exit to be reflected into L1.
>
> Exceptional handling is also required for RSM and RDTSCP instructions.
> RDTSCP could be emulated on hardware which doesn't support it,
> therefore hardware will not generate a RDTSCP VM-exit on L2 resume. The
> dual-monitor treatment of SMM is not supported in nVMX, which implies
> that L0 should never handle a RSM instruction. Resuming the guest will
> only result in another #UD. Avoid getting stuck in a loop with these
> instructions by injecting a #UD for RSM and the appropriate VM-exit for
> RDTSCP.
>
> Fixes: 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/emulate.c     |  2 ++
>  arch/x86/kvm/kvm_emulate.h |  1 +
>  arch/x86/kvm/vmx/vmx.c     | 68 ++++++++++++++++++++++++++++----------
>  arch/x86/kvm/x86.c         |  2 +-
>  4 files changed, 55 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index d0e2825ae617..6e56e7a29ba1 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -5812,6 +5812,8 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
>         }
>         if (rc == X86EMUL_INTERCEPTED)
>                 return EMULATION_INTERCEPTED;
> +       if (rc == X86EMUL_RETRY_INSTR)
> +               return EMULATION_RETRY_INSTR;
>
>         if (rc == X86EMUL_CONTINUE)
>                 writeback_registers(ctxt);
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 43c93ffa76ed..5bfab8d65cd1 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -496,6 +496,7 @@ bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
>  #define EMULATION_OK 0
>  #define EMULATION_RESTART 1
>  #define EMULATION_INTERCEPTED 2
> +#define EMULATION_RETRY_INSTR 3
>  void init_decode_cache(struct x86_emulate_ctxt *ctxt);
>  int x86_emulate_insn(struct x86_emulate_ctxt *ctxt);
>  int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 08e26a9518c2..ebfafd7837ba 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7329,12 +7329,11 @@ static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
>         to_vmx(vcpu)->req_immediate_exit = true;
>  }
>
> -static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
> -                                 struct x86_instruction_info *info)
> +static bool vmx_check_intercept_io(struct kvm_vcpu *vcpu,
> +                                  struct x86_instruction_info *info)
>  {
>         struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>         unsigned short port;
> -       bool intercept;
>         int size;
>
>         if (info->intercept == x86_intercept_in ||
> @@ -7354,13 +7353,10 @@ static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
>          * Otherwise, IO instruction VM-exits are controlled by the IO bitmaps.
>          */
>         if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
> -               intercept = nested_cpu_has(vmcs12,
> -                                          CPU_BASED_UNCOND_IO_EXITING);
> -       else
> -               intercept = nested_vmx_check_io_bitmaps(vcpu, port, size);
> +               return nested_cpu_has(vmcs12,
> +                                     CPU_BASED_UNCOND_IO_EXITING);
>
> -       /* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
> -       return intercept ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
> +       return nested_vmx_check_io_bitmaps(vcpu, port, size);
>  }
>
>  static int vmx_check_intercept(struct kvm_vcpu *vcpu,
> @@ -7369,6 +7365,7 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
>                                struct x86_exception *exception)
>  {
>         struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> +       bool intercepted;
>
>         switch (info->intercept) {
>         /*
> @@ -7381,13 +7378,27 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
>                         exception->error_code_valid = false;
>                         return X86EMUL_PROPAGATE_FAULT;
>                 }
> +
> +               intercepted = nested_cpu_has(vmcs12, CPU_BASED_RDTSC_EXITING);
> +
> +               /*
> +                * RDTSCP could be emulated on a CPU which doesn't support it.
> +                * As such, flushing the TLB and resuming L2 will result in
> +                * another #UD rather than a VM-exit to reflect into L1.
> +                * Instead, synthesize the VM-exit here.
> +                */
> +               if (intercepted) {
> +                       nested_vmx_vmexit(vcpu, EXIT_REASON_RDTSCP, 0, 0);
> +                       return X86EMUL_INTERCEPTED;
> +               }
>                 break;
>
>         case x86_intercept_in:
>         case x86_intercept_ins:
>         case x86_intercept_out:
>         case x86_intercept_outs:
> -               return vmx_check_intercept_io(vcpu, info);
> +               intercepted = vmx_check_intercept_io(vcpu, info);
> +               break;
>
>         case x86_intercept_lgdt:
>         case x86_intercept_lidt:
> @@ -7397,18 +7408,41 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
>         case x86_intercept_sidt:
>         case x86_intercept_sldt:
>         case x86_intercept_str:
> -               if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC))
> -                       return X86EMUL_CONTINUE;
> -
> -               /* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
> +               intercepted = nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC);
>                 break;
>
> -       /* TODO: check more intercepts... */
> +       /*
> +        * The dual-monitor treatment of SMM is not supported in nVMX. As such,
> +        * L0 will never handle the RSM instruction nor should it retry
> +        * instruction execution. Instead, a #UD should be injected into the
> +        * guest for the execution of RSM outside of SMM.
> +        */
> +       case x86_intercept_rsm:
> +               exception->vector = UD_VECTOR;
> +               exception->error_code_valid = false;
> +               return X86EMUL_PROPAGATE_FAULT;
> +
>         default:
> -               break;
> +               intercepted = true;
>         }
>
> -       return X86EMUL_UNHANDLEABLE;
> +       if (!intercepted)
> +               return X86EMUL_CONTINUE;
> +
> +       /*
> +        * The only uses of the emulator in VMX for instructions which may be
> +        * intercepted are port IO instructions, descriptor-table accesses, and
> +        * the RDTSCP instruction. As such, if the emulator has decoded an
> +        * instruction that is different from the VM-exit provided by hardware
> +        * it is likely that the TLB entry and page-table mapping for the
> +        * guest's RIP are out of sync.
> +        *
> +        * Rather than synthesizing a VM-exit into L1 for every possible
> +        * instruction just flush the TLB, resume L2, and let hardware generate
> +        * the appropriate VM-exit.
> +        */
> +       vmx_flush_tlb_gva(vcpu, kvm_rip_read(vcpu));
> +       return X86EMUL_RETRY_INSTR;
>  }
>
>  #ifdef CONFIG_X86_64
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 00c88c2f34e4..2ab47485100f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6967,7 +6967,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>
>         r = x86_emulate_insn(ctxt);
>
> -       if (r == EMULATION_INTERCEPTED)
> +       if (r == EMULATION_INTERCEPTED || r == EMULATION_RETRY_INSTR)
>                 return 1;
>
>         if (r == EMULATION_FAILED) {
> --
> 2.27.0.290.gba653c62da-goog
>

Ping :)
