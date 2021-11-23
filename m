Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56809459B68
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 06:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhKWFSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 00:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbhKWFSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 00:18:13 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65638C061714
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 21:15:05 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id s13so36785044wrb.3
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 21:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AKcgqbCp1Cy8+LhB8UcVKuSg60PXpWvbc4LvES8p2bA=;
        b=2AN9JS0aowpreC6q2T8Fge+X3kNHilsb7fa6TUdJ3LyIXhRTSgkjSp8IUG9H2kd0pv
         UHw9nRCfUSbvWNbvouRRGLtXdMw4a3wN1EH2LdLbpalvqjTw4VGQ8ObXp0MbLmzEJTj4
         LwE3rtWx26PAtsCzU/EQ4a/fgYNfRUyzRAgI0zrYYPf2DlULBJGQtuJMzMi+Y34iihem
         WHSkpCuzOOBSzLfe8xm+JuEic/gzpAWEvZIitjcVn+YwvwVfbS064oebvHxmLMHK1ea5
         7Yh30XD5d8pvP2hjBfhk+jEICbvDXHLA2b7eaCrUMHoLD9MJNYwK8RNwhDQBhaTCF0Er
         HYoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AKcgqbCp1Cy8+LhB8UcVKuSg60PXpWvbc4LvES8p2bA=;
        b=Jb3Pqiy8E1Ooir5yA6p5cPlcrr/xvw2pt2otQpqGD1gdIAemTIhEXpBcfQpO+rzSdm
         qIj3PD+Dh+i0Hnd3WCMAIInWYLl30tDgc9fACeU6qHjGn+k9l2rlcfi9KcEU2aG2R0PA
         y2TBf0cXq2ri3HkZwpKrqklc4mqU4fV+6aaVxgsniVVcYlEcfLW8ZNGDrYIS2eBjyXZE
         F/IilPI8fnGAhgc7Sbh+fBnWIQw0dxRd1XORoTulfmXFDSWMgg0Wm9yYVZIlNrv4i3ne
         BedtErWT+NDvo1RrDJdLj4q4Ch8QyHcP/j+6yPFZYhhQtnQn5PYOdNz8pPNtJc8M3JPI
         ZqJQ==
X-Gm-Message-State: AOAM532/maVFVPk66ObewOQPqxhvwOGKg7ehSYP8MBvN9PoK/4e3Fj8R
        XVubmdo+0j4vzBcbmq31IppypyZJycxZBGzaB6DE0Q==
X-Google-Smtp-Source: ABdhPJyPRrS1gUVjPUM3cjTY6ocEx881FWgvJht67rMwgKiYeFSQ3dDOGIeK/6fA1xlnHWwgibku4Gr+E0uEbGiI7q4=
X-Received: by 2002:a5d:4846:: with SMTP id n6mr3738714wrs.249.1637644503773;
 Mon, 22 Nov 2021 21:15:03 -0800 (PST)
MIME-Version: 1.0
References: <20211104164107.1291793-1-seanjc@google.com> <20211104164107.1291793-3-seanjc@google.com>
In-Reply-To: <20211104164107.1291793-3-seanjc@google.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 23 Nov 2021 10:44:52 +0530
Message-ID: <CAAhSdy2wxYaR92PLhP8j_kr=VDVi6WyckXAe83M4KF1Z5UJH9A@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: RISC-V: Use common KVM implementation of MMU
 memory caches
To:     Sean Christopherson <seanjc@google.com>
Cc:     Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atish.patra@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 4, 2021 at 10:11 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Use common KVM's implementation of the MMU memory caches, which for all
> intents and purposes is semantically identical to RISC-V's version, the
> only difference being that the common implementation will fall back to an
> atomic allocation if there's a KVM bug that triggers a cache underflow.
>
> RISC-V appears to have based its MMU code on arm64 before the conversion
> to the common caches in commit c1a33aebe91d ("KVM: arm64: Use common KVM
> implementation of MMU memory caches"), despite having also copy-pasted
> the definition of KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE in kvm_types.h.

Yes, I missed moving to common KVM memory cache APIs in the recent revisions
of the KVM RISC-V series. Thanks for this patch.

>
> Opportunistically drop the superfluous wrapper
> kvm_riscv_stage2_flush_cache(), whose name is very, very confusing as
> "cache flush" in the context of MMU code almost always refers to flushing
> hardware caches, not freeing unused software objects.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I have queued this for 5.17.

Thanks,
Anup

> ---
>  arch/riscv/include/asm/kvm_host.h  | 10 +----
>  arch/riscv/include/asm/kvm_types.h |  2 +-
>  arch/riscv/kvm/mmu.c               | 64 +++++-------------------------
>  arch/riscv/kvm/vcpu.c              |  5 ++-
>  4 files changed, 16 insertions(+), 65 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 25ba21f98504..37589b953bcb 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -79,13 +79,6 @@ struct kvm_sbi_context {
>         int return_handled;
>  };
>
> -#define KVM_MMU_PAGE_CACHE_NR_OBJS     32
> -
> -struct kvm_mmu_page_cache {
> -       int nobjs;
> -       void *objects[KVM_MMU_PAGE_CACHE_NR_OBJS];
> -};
> -
>  struct kvm_cpu_trap {
>         unsigned long sepc;
>         unsigned long scause;
> @@ -195,7 +188,7 @@ struct kvm_vcpu_arch {
>         struct kvm_sbi_context sbi_context;
>
>         /* Cache pages needed to program page tables with spinlock held */
> -       struct kvm_mmu_page_cache mmu_page_cache;
> +       struct kvm_mmu_memory_cache mmu_page_cache;
>
>         /* VCPU power-off state */
>         bool power_off;
> @@ -223,7 +216,6 @@ void __kvm_riscv_hfence_gvma_all(void);
>  int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
>                          struct kvm_memory_slot *memslot,
>                          gpa_t gpa, unsigned long hva, bool is_write);
> -void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
>  int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
>  void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
>  void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
> diff --git a/arch/riscv/include/asm/kvm_types.h b/arch/riscv/include/asm/kvm_types.h
> index e476b404eb67..e15765f98d7a 100644
> --- a/arch/riscv/include/asm/kvm_types.h
> +++ b/arch/riscv/include/asm/kvm_types.h
> @@ -2,6 +2,6 @@
>  #ifndef _ASM_RISCV_KVM_TYPES_H
>  #define _ASM_RISCV_KVM_TYPES_H
>
> -#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 32
>
>  #endif /* _ASM_RISCV_KVM_TYPES_H */
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index fc058ff5f4b6..b8b902b08deb 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -83,43 +83,6 @@ static int stage2_level_to_page_size(u32 level, unsigned long *out_pgsize)
>         return 0;
>  }
>
> -static int stage2_cache_topup(struct kvm_mmu_page_cache *pcache,
> -                             int min, int max)
> -{
> -       void *page;
> -
> -       BUG_ON(max > KVM_MMU_PAGE_CACHE_NR_OBJS);
> -       if (pcache->nobjs >= min)
> -               return 0;
> -       while (pcache->nobjs < max) {
> -               page = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
> -               if (!page)
> -                       return -ENOMEM;
> -               pcache->objects[pcache->nobjs++] = page;
> -       }
> -
> -       return 0;
> -}
> -
> -static void stage2_cache_flush(struct kvm_mmu_page_cache *pcache)
> -{
> -       while (pcache && pcache->nobjs)
> -               free_page((unsigned long)pcache->objects[--pcache->nobjs]);
> -}
> -
> -static void *stage2_cache_alloc(struct kvm_mmu_page_cache *pcache)
> -{
> -       void *p;
> -
> -       if (!pcache)
> -               return NULL;
> -
> -       BUG_ON(!pcache->nobjs);
> -       p = pcache->objects[--pcache->nobjs];
> -
> -       return p;
> -}
> -
>  static bool stage2_get_leaf_entry(struct kvm *kvm, gpa_t addr,
>                                   pte_t **ptepp, u32 *ptep_level)
>  {
> @@ -171,7 +134,7 @@ static void stage2_remote_tlb_flush(struct kvm *kvm, u32 level, gpa_t addr)
>  }
>
>  static int stage2_set_pte(struct kvm *kvm, u32 level,
> -                          struct kvm_mmu_page_cache *pcache,
> +                          struct kvm_mmu_memory_cache *pcache,
>                            gpa_t addr, const pte_t *new_pte)
>  {
>         u32 current_level = stage2_pgd_levels - 1;
> @@ -186,7 +149,7 @@ static int stage2_set_pte(struct kvm *kvm, u32 level,
>                         return -EEXIST;
>
>                 if (!pte_val(*ptep)) {
> -                       next_ptep = stage2_cache_alloc(pcache);
> +                       next_ptep = kvm_mmu_memory_cache_alloc(pcache);
>                         if (!next_ptep)
>                                 return -ENOMEM;
>                         *ptep = pfn_pte(PFN_DOWN(__pa(next_ptep)),
> @@ -209,7 +172,7 @@ static int stage2_set_pte(struct kvm *kvm, u32 level,
>  }
>
>  static int stage2_map_page(struct kvm *kvm,
> -                          struct kvm_mmu_page_cache *pcache,
> +                          struct kvm_mmu_memory_cache *pcache,
>                            gpa_t gpa, phys_addr_t hpa,
>                            unsigned long page_size,
>                            bool page_rdonly, bool page_exec)
> @@ -384,7 +347,10 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>         int ret = 0;
>         unsigned long pfn;
>         phys_addr_t addr, end;
> -       struct kvm_mmu_page_cache pcache = { 0, };
> +       struct kvm_mmu_memory_cache pcache;
> +
> +       memset(&pcache, 0, sizeof(pcache));
> +       pcache.gfp_zero = __GFP_ZERO;
>
>         end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
>         pfn = __phys_to_pfn(hpa);
> @@ -395,9 +361,7 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>                 if (!writable)
>                         pte = pte_wrprotect(pte);
>
> -               ret = stage2_cache_topup(&pcache,
> -                                        stage2_pgd_levels,
> -                                        KVM_MMU_PAGE_CACHE_NR_OBJS);
> +               ret = kvm_mmu_topup_memory_cache(&pcache, stage2_pgd_levels);
>                 if (ret)
>                         goto out;
>
> @@ -411,7 +375,7 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>         }
>
>  out:
> -       stage2_cache_flush(&pcache);
> +       kvm_mmu_free_memory_cache(&pcache);
>         return ret;
>  }
>
> @@ -646,7 +610,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
>         gfn_t gfn = gpa >> PAGE_SHIFT;
>         struct vm_area_struct *vma;
>         struct kvm *kvm = vcpu->kvm;
> -       struct kvm_mmu_page_cache *pcache = &vcpu->arch.mmu_page_cache;
> +       struct kvm_mmu_memory_cache *pcache = &vcpu->arch.mmu_page_cache;
>         bool logging = (memslot->dirty_bitmap &&
>                         !(memslot->flags & KVM_MEM_READONLY)) ? true : false;
>         unsigned long vma_pagesize, mmu_seq;
> @@ -681,8 +645,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
>         }
>
>         /* We need minimum second+third level pages */
> -       ret = stage2_cache_topup(pcache, stage2_pgd_levels,
> -                                KVM_MMU_PAGE_CACHE_NR_OBJS);
> +       ret = kvm_mmu_topup_memory_cache(pcache, stage2_pgd_levels);
>         if (ret) {
>                 kvm_err("Failed to topup stage2 cache\n");
>                 return ret;
> @@ -731,11 +694,6 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
>         return ret;
>  }
>
> -void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu)
> -{
> -       stage2_cache_flush(&vcpu->arch.mmu_page_cache);
> -}
> -
>  int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm)
>  {
>         struct page *pgd_page;
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index e3d3aed46184..a50abe400ea8 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -77,6 +77,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>
>         /* Mark this VCPU never ran */
>         vcpu->arch.ran_atleast_once = false;
> +       vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>
>         /* Setup ISA features available to VCPU */
>         vcpu->arch.isa = riscv_isa_extension_base(NULL) & KVM_RISCV_ISA_ALLOWED;
> @@ -107,8 +108,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>         /* Cleanup VCPU timer */
>         kvm_riscv_vcpu_timer_deinit(vcpu);
>
> -       /* Flush the pages pre-allocated for Stage2 page table mappings */
> -       kvm_riscv_stage2_flush_cache(vcpu);
> +       /* Free unused pages pre-allocated for Stage2 page table mappings */
> +       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>  }
>
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
> --
> 2.34.0.rc0.344.g81b53c2807-goog
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
