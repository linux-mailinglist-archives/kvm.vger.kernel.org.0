Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04CB4E452A
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239764AbiCVRaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239735AbiCVRad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:30:33 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAD3DFDF
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:28:54 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2d07ae0b1c0so199091537b3.2
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ngLIg9b4BlGvztL4m59Z6YNmmHxfTM8WHA3l9qn5cQw=;
        b=p4kXZ57BGxTHMyT63eQqh+aVMHPNJP6siHAhD8Qz8wWtqDCYeluc9hvog8YHro/8nF
         Jto/x2Die2vbaHlQq8eUojlc7umSrjRAPBZEBhA7aUAlJ68M4L+HiWvlp24eF/oPv8c8
         GrC1WdAIzQELqr8iVdZcLM8ECe/EiCJYlggXM/YXIdOh8abmnJD50NfLJCA/CloGeq5r
         Jme7fTDpENccLa6rMCqBBKoldhhifXKiZhb/Hfm6YlThLJzD9WtyF71tJKvXTHcShF3F
         vDHHPHJRUjq6OrEHzIJpJ38KhVqMBrFjSXLSPhHN+Svtqjm+ani6vVEnWtAlAabK2ZGA
         gxSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ngLIg9b4BlGvztL4m59Z6YNmmHxfTM8WHA3l9qn5cQw=;
        b=DPrvbxi8TQSTGNwqNFgNNCj536SeZmSKIOTxJ9GejGV7YqwElgWBlszH3IOCxakAys
         71eV/s2M1zkrl1XiTLggQsCuMLs0QhN2TZzfL1QpHFA4MdG2ID4ZAXinQLmfU01fDRFk
         wY9ora1dvDZaK8E4RBMYufKsUj1c7Jucn4sGS2RisIXtMsK93hgvb9GH4Ff5h1Ekvy1N
         0+rBxMMWIIbNnMxDCJIpsIlt/0d73bGTHCFfz20xoPOgaLoJB7/57FpvsDfWIpOH/R/4
         pLt5NQSd+TeC59Oql/CdG22EpTQUdieeeJjyH4DLFS3HQWhaJUSJEPsfgqeUmOhe3eFO
         l0zQ==
X-Gm-Message-State: AOAM532x6gD8snt/tHRYWtk+meTC5ulY6gERFPCw/SqSsLElvEQpyGcp
        OpFbtKSJ2zGkx/fl64fSnqGi6lmUFS5z4u6JYdHgAg==
X-Google-Smtp-Source: ABdhPJxBrAZ89IvwaQcef+Yp1XwPz+DqEpA5BuCi2RyulXypYZnUIjDR55DShtn8q6ZkvHAshQ6yTNpy1vnHtXFbcr8=
X-Received: by 2002:a0d:f485:0:b0:2e6:8c95:d874 with SMTP id
 d127-20020a0df485000000b002e68c95d874mr1924073ywf.23.1647970133194; Tue, 22
 Mar 2022 10:28:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1646422845.git.isaku.yamahata@intel.com> <cedda3dbe8597356374ef64de26ecef0d8cd7a62.1646422845.git.isaku.yamahata@intel.com>
In-Reply-To: <cedda3dbe8597356374ef64de26ecef0d8cd7a62.1646422845.git.isaku.yamahata@intel.com>
From:   Erdem Aktas <erdemaktas@google.com>
Date:   Tue, 22 Mar 2022 10:28:42 -0700
Message-ID: <CAAYXXYy3QLWyq9QrEnrsOLB3r44QTgKaOW4=HhOozDuw1073Gg@mail.gmail.com>
Subject: Re: [RFC PATCH v5 064/104] KVM: TDX: Implement TDX vcpu enter/exit path
To:     "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc:     "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 4, 2022 at 11:50 AM <isaku.yamahata@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> This patch implements running TDX vcpu.  Once vcpu runs on the logical
> processor (LP), the TDX vcpu is associated with it.  When the TDX vcpu
> moves to another LP, the TDX vcpu needs to flush its status on the LP.
> When destroying TDX vcpu, it needs to complete flush and flush cpu memory
> cache.  Track which LP the TDX vcpu run and flush it as necessary.
>
> Do nothing on sched_in event as TDX doesn't support pause loop.
>
> TDX vcpu execution requires restoring PMU debug store after returning back
> to KVM because the TDX module unconditionally resets the value.  To reuse
> the existing code, export perf_restore_debug_store.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/main.c    | 10 +++++++++-
>  arch/x86/kvm/vmx/tdx.c     | 34 ++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h     | 33 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/x86_ops.h |  2 ++
>  arch/x86/kvm/x86.c         |  1 +
>  5 files changed, 79 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index f571b07c2aae..2e5a7a72d560 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -89,6 +89,14 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>         return vmx_vcpu_reset(vcpu, init_event);
>  }
>
> +static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu)
> +{
> +       if (is_td_vcpu(vcpu))
> +               return tdx_vcpu_run(vcpu);
> +
> +       return vmx_vcpu_run(vcpu);
> +}
> +
>  static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
>  {
>         if (is_td_vcpu(vcpu))
> @@ -200,7 +208,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>         .tlb_flush_guest = vt_flush_tlb_guest,
>
>         .vcpu_pre_run = vmx_vcpu_pre_run,
> -       .run = vmx_vcpu_run,
> +       .run = vt_vcpu_run,
>         .handle_exit = vmx_handle_exit,
>         .skip_emulated_instruction = vmx_skip_emulated_instruction,
>         .update_emulated_instruction = vmx_update_emulated_instruction,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 85d5f961d97e..ebe4f9bf19e7 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -10,6 +10,9 @@
>  #include "vmx.h"
>  #include "x86.h"
>
> +#include <trace/events/kvm.h>
> +#include "trace.h"
> +
>  #undef pr_fmt
>  #define pr_fmt(fmt) "tdx: " fmt
>
> @@ -509,6 +512,37 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>         vcpu->kvm->vm_bugged = true;
>  }
>
> +u64 __tdx_vcpu_run(hpa_t tdvpr, void *regs, u32 regs_mask);
> +
> +static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> +                                       struct vcpu_tdx *tdx)
> +{
> +       guest_enter_irqoff();
> +       tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr.pa, vcpu->arch.regs, 0);
> +       guest_exit_irqoff();
> +}
> +
> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
> +{
> +       struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +       if (unlikely(vcpu->kvm->vm_bugged)) {
> +               tdx->exit_reason.full = TDX_NON_RECOVERABLE_VCPU;
> +               return EXIT_FASTPATH_NONE;
> +       }
> +
> +       trace_kvm_entry(vcpu);
> +
> +       tdx_vcpu_enter_exit(vcpu, tdx);
> +
> +       vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
> +       trace_kvm_exit(vcpu, KVM_ISA_VMX);
> +
> +       if (tdx->exit_reason.error || tdx->exit_reason.non_recoverable)
> +               return EXIT_FASTPATH_NONE;

Looks like the above if statement has no effect. Just checking if this
is intentional.

> +       return EXIT_FASTPATH_NONE;
> +}
> +
>  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>  {
>         td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index bf9865a88991..e950404ce5de 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -44,12 +44,45 @@ struct kvm_tdx {
>         spinlock_t seamcall_lock;
>  };
>
> +union tdx_exit_reason {
> +       struct {
> +               /* 31:0 mirror the VMX Exit Reason format */
> +               u64 basic               : 16;
> +               u64 reserved16          : 1;
> +               u64 reserved17          : 1;
> +               u64 reserved18          : 1;
> +               u64 reserved19          : 1;
> +               u64 reserved20          : 1;
> +               u64 reserved21          : 1;
> +               u64 reserved22          : 1;
> +               u64 reserved23          : 1;
> +               u64 reserved24          : 1;
> +               u64 reserved25          : 1;
> +               u64 bus_lock_detected   : 1;
> +               u64 enclave_mode        : 1;
> +               u64 smi_pending_mtf     : 1;
> +               u64 smi_from_vmx_root   : 1;
> +               u64 reserved30          : 1;
> +               u64 failed_vmentry      : 1;
> +
> +               /* 63:32 are TDX specific */
> +               u64 details_l1          : 8;
> +               u64 class               : 8;
> +               u64 reserved61_48       : 14;
> +               u64 non_recoverable     : 1;
> +               u64 error               : 1;
> +       };
> +       u64 full;
> +};
> +
>  struct vcpu_tdx {
>         struct kvm_vcpu vcpu;
>
>         struct tdx_td_page tdvpr;
>         struct tdx_td_page *tdvpx;
>
> +       union tdx_exit_reason exit_reason;
> +
>         bool initialized;
>  };
>
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 922a3799336e..44404dd25737 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -140,6 +140,7 @@ void tdx_vm_free(struct kvm *kvm);
>  int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>  void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>  void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
>
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> @@ -160,6 +161,7 @@ static inline void tdx_vm_free(struct kvm *kvm) {}
>  static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
>  static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>  static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
> +static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
>
>  static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>  static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index da411bcd8cbc..66400810d54f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -300,6 +300,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
>  };
>
>  u64 __read_mostly host_xcr0;
> +EXPORT_SYMBOL_GPL(host_xcr0);
>  u64 __read_mostly supported_xcr0;
>  EXPORT_SYMBOL_GPL(supported_xcr0);
>
> --
> 2.25.1
>
