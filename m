Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CEA232B1D
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 07:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgG3FBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 01:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgG3FBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 01:01:36 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E52C061794;
        Wed, 29 Jul 2020 22:01:35 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id j8so14621491ioe.9;
        Wed, 29 Jul 2020 22:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/KArmywzz24MgEo7tKqsv3AHtwJuFSIPw8fTxLugAe8=;
        b=cFevK0RQOjEkddBY6KpbERE3ICB6EDEJCe8CClM2n+/sAsilIVq+5+agqUi5vBcexP
         r0Z5ltwXxW97GjjZ1Gb/CPXBNrppgLt9IGafGMf+YeZi7qm1di9xCouTRt0U3fNG//3I
         RWx0L3KqNVcDokDFeMN1LoqNjfS4drWHM0y0DWHxbE9v31DlBAPp1M0y5JvvzwV48LkX
         wBfn9rS5BlI7kltgb2S2GE9tOmI/eM+FBLF5iBhjFVe43Evh1l9PSLET3oIvrI47mlrz
         h4SQdiYkDYYkwaywq5XtLJEFUDRDi5Fwgf/7FQM4WcucSoGfoyHQ4GHl6BEEKYZ8xsll
         skbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/KArmywzz24MgEo7tKqsv3AHtwJuFSIPw8fTxLugAe8=;
        b=Ejr6PQBGQGxTfnKr0wqUTcd2Z+vaHALju/tweXM1P3y9BEyYuqAZFToyS8Bj7+D99A
         PJJUt6AJlXPt2c22PKjznVATgb5fQ+ivMzEvdB1FQn9R3dE7quZithpZ7qZTE9CaN8k4
         wjIXOKL+bMnqD7ZslDLLLDoGzOgVKtugSFXutSP+d9TX2G3DOA5E7iI2hfB1X1TsupCI
         RffKiAM7t/wPwZN+6C2JcTEQ0UyHXVb2IAjjoiQSoWGTfmk8we54lCfTzgPoYkUE8eSx
         9NbT+wsU3LiHvyvBQZxUDXBOQSAr9RAABLOs/2w0DPrpnUIOLC7yBZQgz8GSgH4c0AYX
         JJUQ==
X-Gm-Message-State: AOAM530IGfZ2ZE9jk2j4NNqQnOZd9LaHrmZoS29nZ9CrvqPGaY3UBS3n
        g3SXj4hfNUHkGq0jozWGiH4xgSHQT3vO3dI5v/HKCLMgZCE=
X-Google-Smtp-Source: ABdhPJzspyL1/iHod5fhOAkpurAAXLc78LWILFI8gco/WMBysdAIQV659ymQnQ7l7L0h3k+jPPucX/H2TvdyQKghQe4=
X-Received: by 2002:a02:6d1b:: with SMTP id m27mr1551017jac.129.1596085294383;
 Wed, 29 Jul 2020 22:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200720211359.GF502563@redhat.com>
In-Reply-To: <20200720211359.GF502563@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Thu, 30 Jul 2020 07:01:23 +0200
Message-ID: <CAM9Jb+inmDius485qfG=W22ENsLad7uinvMmW_YpQgvj-OTvvw@mail.gmail.com>
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        virtio-fs-list <virtio-fs@redhat.com>, vkuznets@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        sean.j.christopherson@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Page fault error handling behavior in kvm seems little inconsistent when
> page fault reports error. If we are doing fault synchronously
> then we capture error (-EFAULT) returned by __gfn_to_pfn_memslot() and
> exit to user space and qemu reports error, "error: kvm run failed Bad address".
>
> But if we are doing async page fault, then async_pf_execute() will simply
> ignore the error reported by get_user_pages_remote() or
> by kvm_mmu_do_page_fault(). It is assumed that page fault was successful
> and either a page ready event is injected in guest or guest is brought
> out of artificial halt state and run again. In both the cases when guest
> retries the instruction, it takes exit again as page fault was not
> successful in previous attempt. And then this infinite loop continues
> forever.
>
> Trying fault in a loop will make sense if error is temporary and will
> be resolved on retry. But I don't see any intention in the code to
> determine if error is temporary or not.  Whether to do fault synchronously
> or asynchronously, depends on so many variables but none of the varibales
s/varibales/variables
> is whether error is temporary or not. (kvm_can_do_async_pf()).
>
> And that makes it very inconsistent or unpredictable to figure out whether
> kvm will exit to qemu with error or it will just retry and go into an
> infinite loop.
>
> This patch tries to make this behavior consistent. That is instead of
> getting into infinite loop of retrying page fault, exit to user space
> and stop VM if page fault error happens.
>
> In future this can be improved by injecting errors into guest. As of
> now we don't have any race free method to inject errors in guest.
>
> When page fault error happens in async path save that pfn and when next
> time guest retries, do a sync fault instead of async fault. So that if error
> is encountered, we exit to qemu and avoid infinite loop.
>
> We maintain a cache of error gfns and force sync fault if a gfn is
> found in cache of error gfn. There is a small possibility that we
> miss an error gfn (as it got overwritten by a new error gfn). But
> its just a hint and sooner or later some error pfn will match
> and we will force sync fault and exit to user space.
>
> Changes from v3:
> - Added function kvm_find_and_remove_error_gfn() and removed
>   kvm_find_error_gfn() and kvm_del_error_gfn(). (Vitaly)
>
> - Added a macro GFN_INVALID (Vitaly).
>
> - Used gpa_to_gfn() to convert gpa to gfn (Vitaly)
>
> Change from v2:
> - Fixed a warning by converting kvm_find_error_gfn() static.
>
> Change from v1:
> - Maintain a cache of error gfns, instead of single gfn. (Vitaly)
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu.h              |  2 +-
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/x86.c              | 54 +++++++++++++++++++++++++++++++--
>  include/linux/kvm_types.h       |  1 +
>  5 files changed, 56 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index be5363b21540..e6f8d3f1a377 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -137,6 +137,7 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
>  #define KVM_NR_VAR_MTRR 8
>
>  #define ASYNC_PF_PER_VCPU 64
> +#define ERROR_GFN_PER_VCPU 64
>
>  enum kvm_reg {
>         VCPU_REGS_RAX = __VCPU_REGS_RAX,
> @@ -778,6 +779,7 @@ struct kvm_vcpu_arch {
>                 unsigned long nested_apf_token;
>                 bool delivery_as_pf_vmexit;
>                 bool pageready_pending;
> +               gfn_t error_gfns[ERROR_GFN_PER_VCPU];
>         } apf;
>
>         /* OSVW MSRs (AMD only) */
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 444bb9c54548..d0a2a12c7bb6 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -60,7 +60,7 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots);
>  void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer);
>  void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>                              bool accessed_dirty, gpa_t new_eptp);
> -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
> +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn);
>  int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>                                 u64 fault_address, char *insn, int insn_len);
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d6a0ae7800c..b51d4aa405e0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4078,7 +4078,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>         if (!async)
>                 return false; /* *pfn has correct page already */
>
> -       if (!prefault && kvm_can_do_async_pf(vcpu)) {
> +       if (!prefault && kvm_can_do_async_pf(vcpu, gpa_to_gfn(cr2_or_gpa))) {
>                 trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
>                 if (kvm_find_async_pf_gfn(vcpu, gfn)) {
>                         trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 88c593f83b28..c1f5094d6e53 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -263,6 +263,13 @@ static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
>                 vcpu->arch.apf.gfns[i] = ~0;
>  }
>
> +static inline void kvm_error_gfn_hash_reset(struct kvm_vcpu *vcpu)
> +{
> +       int i;
> +       for (i = 0; i < ERROR_GFN_PER_VCPU; i++)
> +               vcpu->arch.apf.error_gfns[i] = GFN_INVALID;
> +}
> +
>  static void kvm_on_user_return(struct user_return_notifier *urn)
>  {
>         unsigned slot;
> @@ -9484,6 +9491,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
>
>         kvm_async_pf_hash_reset(vcpu);
> +       kvm_error_gfn_hash_reset(vcpu);
>         kvm_pmu_init(vcpu);
>
>         vcpu->arch.pending_external_vector = -1;
> @@ -9608,6 +9616,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>
>         kvm_clear_async_pf_completion_queue(vcpu);
>         kvm_async_pf_hash_reset(vcpu);
> +       kvm_error_gfn_hash_reset(vcpu);
>         vcpu->arch.apf.halted = false;
>
>         if (kvm_mpx_supported()) {
> @@ -10369,6 +10378,36 @@ void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_rflags);
>
> +static inline u32 kvm_error_gfn_hash_fn(gfn_t gfn)
> +{
> +       BUILD_BUG_ON(!is_power_of_2(ERROR_GFN_PER_VCPU));
> +
> +       return hash_32(gfn & 0xffffffff, order_base_2(ERROR_GFN_PER_VCPU));
> +}
> +
> +static void kvm_add_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +       u32 key = kvm_error_gfn_hash_fn(gfn);
> +
> +       /*
> +        * Overwrite the previous gfn. This is just a hint to do
> +        * sync page fault.
> +        */
> +       vcpu->arch.apf.error_gfns[key] = gfn;
> +}
> +
> +/* Returns true if gfn was found in hash table, false otherwise */
> +static bool kvm_find_and_remove_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +       u32 key = kvm_error_gfn_hash_fn(gfn);
> +
> +       if (vcpu->arch.apf.error_gfns[key] != gfn)
> +               return 0;
> +
> +       vcpu->arch.apf.error_gfns[key] = GFN_INVALID;
> +       return true;
> +}
> +
>  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  {
>         int r;
> @@ -10385,7 +10424,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>               work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
>                 return;
>
> -       kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
> +       r = kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
> +       if (r < 0)
> +               kvm_add_error_gfn(vcpu, gpa_to_gfn(work->cr2_or_gpa));
>  }
>
>  static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
> @@ -10495,7 +10536,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>         return true;
>  }
>
> -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
> +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn)
>  {
>         if (unlikely(!lapic_in_kernel(vcpu) ||
>                      kvm_event_needs_reinjection(vcpu) ||
> @@ -10509,7 +10550,14 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>          * If interrupts are off we cannot even use an artificial
>          * halt state.
>          */
> -       return kvm_arch_interrupt_allowed(vcpu);
> +       if (!kvm_arch_interrupt_allowed(vcpu))
> +               return false;
> +
> +       /* Found gfn in error gfn cache. Force sync fault */
> +       if (kvm_find_and_remove_error_gfn(vcpu, gfn))
> +               return false;
> +
> +       return true;
>  }
>
>  bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 68e84cf42a3f..677bb8269cd3 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -36,6 +36,7 @@ typedef u64            gpa_t;
>  typedef u64            gfn_t;
>
>  #define GPA_INVALID    (~(gpa_t)0)
> +#define GFN_INVALID    (~(gfn_t)0)
>
>  typedef unsigned long  hva_t;
>  typedef u64            hpa_t;
> --
> 2.25.4

This patch looks good to me.

Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>

>
