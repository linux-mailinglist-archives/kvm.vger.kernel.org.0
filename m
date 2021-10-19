Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661DF434190
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 00:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhJSWrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 18:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhJSWrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 18:47:19 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91F7C061746
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 15:45:05 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id g36so10860004lfv.3
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 15:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kp1lcq5SmizdvJtg3fAbmr4QnmIcfaNbEFqPYKQlECg=;
        b=HzxwRbzY6rD/APVJyQnhmAfY/CDCK1ahlrblZ4C873k22XkysN8LCIRY5eHsbdXs2m
         v3XXnM31icsuL+sPDFnx4IxPr/Sd2auUJQYcenk+V4Am7YH5JBs9omeOdBUukzbKIEu7
         CaGJbFuW+o8ia7H4Hz2FtNdy3tEywi5SEdoUITv17i6K2USu4bgsb7p5wmibxxfnIqUg
         WBVKJCzqgFJ+wLWmAPSSQywpVW4HnZdED/seS/QmiQhlp0WiR7O/EyKdc33jGiHSmOlP
         08IV4v9sEYRiL1pjaR8WvXNQVYTjDzdlw+OwaUXdJB6DGcpaiAqgopfAT8Pgi8WxTxL/
         Fatg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kp1lcq5SmizdvJtg3fAbmr4QnmIcfaNbEFqPYKQlECg=;
        b=yacQhEUDafaJNj5WJm7NYA3YeDhPyL+Rq36vSn7mp6HgYQV/ERUWhwcX3zZbtqPFll
         rsFgdbQaElv2Wo9nAH90Jze6VQUZzDLf0hDkjZXBWkqo0Fc+s3Bv9f1Y6G5Ze3XMFm1w
         dj+a7DTvInKPzVUwSdF2UXiVZ2VSdNq1xJqdrZjHI7cjP4zDc5Ee2vI1ewQsqXq2Wxlb
         jdLQHN3FYDBQCiFBv8LjMYTHvLVNCMPey8IDgFs+zS6ya8Oe9HqxsM9Z4FvIR4dRMSfY
         9UjNenYYO6Ip1sUFCgWK8EAv1jXkpx60OmZG4uKchGFGXxLNm3Pc0UZfeIBundSlPyTV
         vfJQ==
X-Gm-Message-State: AOAM532Ed3rqslhfxcpRpDbZUg43VCmAYu15kKjHs0jdL0QCtWVYWfE7
        J1+ch6wFgyLQiA23S6ZkjJPuwCZGXskq50T0/Qfq8Q==
X-Google-Smtp-Source: ABdhPJw7g+2vp8v2C8maW9eKrCQuCHw8vRa8IRy3w4xU5k37S7YQhkmMP2+QugERrUS9ZN32z+f9sN6llrjdoiElelk=
X-Received: by 2002:a05:6512:2393:: with SMTP id c19mr8751584lfv.518.1634683503592;
 Tue, 19 Oct 2021 15:45:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211019153214.109519-1-senozhatsky@chromium.org> <20211019153214.109519-2-senozhatsky@chromium.org>
In-Reply-To: <20211019153214.109519-2-senozhatsky@chromium.org>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 19 Oct 2021 15:44:37 -0700
Message-ID: <CALzav=cLXXZYBSH6iJifkqVijLAU5EvgVg2W4HKhqke2JBa+yg@mail.gmail.com>
Subject: Re: [PATCHV2 1/3] KVM: x86: introduce kvm_mmu_pte_prefetch structure
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suleiman Souhlal <suleiman@google.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 19, 2021 at 8:32 AM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> kvm_mmu_pte_prefetch is a per-VCPU structure that holds a PTE
> prefetch pages array, lock and the number of PTE to prefetch.
>
> This is needed to turn PTE_PREFETCH_NUM into a tunable VM
> parameter.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  arch/x86/include/asm/kvm_host.h | 12 +++++++
>  arch/x86/kvm/mmu.h              |  4 +++
>  arch/x86/kvm/mmu/mmu.c          | 57 ++++++++++++++++++++++++++++++---
>  arch/x86/kvm/x86.c              |  9 +++++-
>  4 files changed, 77 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5271fce6cd65..11400bc3c70d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -607,6 +607,16 @@ struct kvm_vcpu_xen {
>         u64 runstate_times[4];
>  };
>
> +struct kvm_mmu_pte_prefetch {
> +       /*
> +        * This will be cast either to array of pointers to struct page,
> +        * or array of u64, or array of u32
> +        */
> +       void *ents;
> +       unsigned int num_ents;
> +       spinlock_t lock;

The spinlock is overkill. I'd suggest something like this:
- When VM-ioctl is invoked to update prefetch count, store it in
kvm_arch. No synchronization with vCPUs needed.
- When a vCPU takes a fault: Read the prefetch count from kvm_arch. If
different than count at last fault, re-allocate vCPU prefetch array.
(So you'll need to add prefetch array and count to kvm_vcpu_arch as
well.)

No extra locks are needed. vCPUs that fault after the VM-ioctl will
get the new prefetch count. We don't really care if a prefetch count
update races with a vCPU fault as long as vCPUs are careful to only
read the count once (i.e. use READ_ONCE(vcpu->kvm.prefetch_count)) and
use that. Assuming prefetch count ioctls are rare, the re-allocation
on the fault path will be rare as well.

Note: You could apply this same approach to a module param, except
vCPUs would be reading the module param rather than vcpu->kvm during
each fault.

And the other alternative, like you suggested in the other patch, is
to use a vCPU ioctl. That would side-step the synchronization issue
because vCPU ioctls require the vCPU mutex. So the reallocation could
be done in the ioctl and not at fault time.

Taking a step back, can you say a bit more about your usecase? The
module param approach would be simplest because you would not have to
add userspace support, but in v1 you did mention you wanted per-VM
control.

> +};
> +
>  struct kvm_vcpu_arch {
>         /*
>          * rip and regs accesses must go through
> @@ -682,6 +692,8 @@ struct kvm_vcpu_arch {
>         struct kvm_mmu_memory_cache mmu_gfn_array_cache;
>         struct kvm_mmu_memory_cache mmu_page_header_cache;
>
> +       struct kvm_mmu_pte_prefetch mmu_pte_prefetch;
> +
>         /*
>          * QEMU userspace and the guest each have their own FPU state.
>          * In vcpu_run, we switch between the user and guest FPU contexts.
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 75367af1a6d3..b953a3a4083a 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -68,6 +68,10 @@ static __always_inline u64 rsvd_bits(int s, int e)
>  void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
>  void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
>
> +int kvm_set_pte_prefetch(struct kvm_vcpu *vcpu, u64 num_ents);
> +int kvm_init_pte_prefetch(struct kvm_vcpu *vcpu);
> +void kvm_pte_prefetch_destroy(struct kvm_vcpu *vcpu);
> +
>  void kvm_init_mmu(struct kvm_vcpu *vcpu);
>  void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
>                              unsigned long cr4, u64 efer, gpa_t nested_cr3);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 24a9f4c3f5e7..fed3a498a729 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -115,6 +115,7 @@ module_param(dbg, bool, 0644);
>  #endif
>
>  #define PTE_PREFETCH_NUM               8
> +#define MAX_PTE_PREFETCH_NUM           128
>
>  #define PT32_LEVEL_BITS 10
>
> @@ -732,7 +733,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>
>         /* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
>         r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> -                                      1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
> +                                      1 + PT64_ROOT_MAX_LEVEL + MAX_PTE_PREFETCH_NUM);
>         if (r)
>                 return r;
>         r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> @@ -2753,12 +2754,13 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
>                                     struct kvm_mmu_page *sp,
>                                     u64 *start, u64 *end)
>  {
> -       struct page *pages[PTE_PREFETCH_NUM];
> +       struct page **pages;
>         struct kvm_memory_slot *slot;
>         unsigned int access = sp->role.access;
>         int i, ret;
>         gfn_t gfn;
>
> +       pages = (struct page **)vcpu->arch.mmu_pte_prefetch.ents;
>         gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
>         slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, access & ACC_WRITE_MASK);
>         if (!slot)
> @@ -2781,14 +2783,17 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
>                                   struct kvm_mmu_page *sp, u64 *sptep)
>  {
>         u64 *spte, *start = NULL;
> +       unsigned int pte_prefetch_num;
>         int i;
>
>         WARN_ON(!sp->role.direct);
>
> -       i = (sptep - sp->spt) & ~(PTE_PREFETCH_NUM - 1);
> +       spin_lock(&vcpu->arch.mmu_pte_prefetch.lock);
> +       pte_prefetch_num = vcpu->arch.mmu_pte_prefetch.num_ents;
> +       i = (sptep - sp->spt) & ~(pte_prefetch_num - 1);
>         spte = sp->spt + i;
>
> -       for (i = 0; i < PTE_PREFETCH_NUM; i++, spte++) {
> +       for (i = 0; i < pte_prefetch_num; i++, spte++) {
>                 if (is_shadow_present_pte(*spte) || spte == sptep) {
>                         if (!start)
>                                 continue;
> @@ -2800,6 +2805,7 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
>         }
>         if (start)
>                 direct_pte_prefetch_many(vcpu, sp, start, spte);
> +       spin_unlock(&vcpu->arch.mmu_pte_prefetch.lock);
>  }
>
>  static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
> @@ -4914,6 +4920,49 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_init_mmu);
>
> +int kvm_set_pte_prefetch(struct kvm_vcpu *vcpu, u64 num_ents)
> +{
> +       u64 *ents;
> +
> +       if (!num_ents)
> +               return -EINVAL;
> +
> +       if (!is_power_of_2(num_ents))
> +               return -EINVAL;
> +
> +       if (num_ents > MAX_PTE_PREFETCH_NUM)
> +               return -EINVAL;
> +
> +       ents = kmalloc_array(num_ents, sizeof(u64), GFP_KERNEL);
> +       if (!ents)
> +               return -ENOMEM;
> +
> +       spin_lock(&vcpu->arch.mmu_pte_prefetch.lock);
> +       kfree(vcpu->arch.mmu_pte_prefetch.ents);
> +       vcpu->arch.mmu_pte_prefetch.ents = ents;
> +       vcpu->arch.mmu_pte_prefetch.num_ents = num_ents;
> +       spin_unlock(&vcpu->arch.mmu_pte_prefetch.lock);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_set_pte_prefetch);
> +
> +int kvm_init_pte_prefetch(struct kvm_vcpu *vcpu)
> +{
> +       spin_lock_init(&vcpu->arch.mmu_pte_prefetch.lock);
> +
> +       return kvm_set_pte_prefetch(vcpu, PTE_PREFETCH_NUM);
> +}
> +EXPORT_SYMBOL_GPL(kvm_init_pte_prefetch);
> +
> +void kvm_pte_prefetch_destroy(struct kvm_vcpu *vcpu)
> +{
> +       vcpu->arch.mmu_pte_prefetch.num_ents = 0;
> +       kfree(vcpu->arch.mmu_pte_prefetch.ents);
> +       vcpu->arch.mmu_pte_prefetch.ents = NULL;
> +}
> +EXPORT_SYMBOL_GPL(kvm_pte_prefetch_destroy);
> +
>  static union kvm_mmu_page_role
>  kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b0f99132d7d1..4805960a89e6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10707,10 +10707,14 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         vcpu->arch.hv_root_tdp = INVALID_PAGE;
>  #endif
>
> -       r = static_call(kvm_x86_vcpu_create)(vcpu);
> +       r = kvm_init_pte_prefetch(vcpu);
>         if (r)
>                 goto free_guest_fpu;
>
> +       r = static_call(kvm_x86_vcpu_create)(vcpu);
> +       if (r)
> +               goto free_pte_prefetch;
> +
>         vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
>         vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
>         kvm_vcpu_mtrr_init(vcpu);
> @@ -10721,6 +10725,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         vcpu_put(vcpu);
>         return 0;
>
> +free_pte_prefetch:
> +       kvm_pte_prefetch_destroy(vcpu);
>  free_guest_fpu:
>         kvm_free_guest_fpu(vcpu);
>  free_user_fpu:
> @@ -10782,6 +10788,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>         kvm_free_lapic(vcpu);
>         idx = srcu_read_lock(&vcpu->kvm->srcu);
>         kvm_mmu_destroy(vcpu);
> +       kvm_pte_prefetch_destroy(vcpu);
>         srcu_read_unlock(&vcpu->kvm->srcu, idx);
>         free_page((unsigned long)vcpu->arch.pio_data);
>         kvfree(vcpu->arch.cpuid_entries);
> --
> 2.33.0.1079.g6e70778dc9-goog
>
