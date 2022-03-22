Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C814E4994
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 00:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbiCVXPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 19:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238806AbiCVXPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 19:15:02 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF342657A
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 16:13:33 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id q5so25980287ljb.11
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 16:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CdD+JYhTfxheiUR7WNwAiovzVBuyAP5TWLhgOgwTzlU=;
        b=r5LxUfBlV4o0eg0saZlM8YXqFp9/mrkNnZNAvD22bfn3s0c3E6p2vqW2yDsxcjbzIW
         7/3ADewiXm5aW98z3QE21KGI7W13CBycQcHpOf3hosEjxsIxZb7al6/J69SUQwwpsG5z
         REz7UOD4kVW1kMGf3KAKgInu7U64UqJp0sn3iZ/L9CeHM10yKqSlR0ggQln6fPUZpGpw
         dI4vb1jO7CaauNaGFhDDIRt/YBmW8SKEfZZr5nrTss3oeI4xU+x5ujpq8FhjI8XU9w/z
         bvazSD042TV4Kw1We5XrWuqKetZz9vRLxZytcr7b36IJm2ApBVAgURtkAdyaH95HE3Yb
         3OXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CdD+JYhTfxheiUR7WNwAiovzVBuyAP5TWLhgOgwTzlU=;
        b=UndqUF5YeOLgp3GW/wvZhkVZcq/9/glPP7D92PnhmxUM8g7ffAz1FPUaPkXaDgcSd6
         IsLI+6DEqWdoe65xNUVccxejELN5WH2Jo48DrsZcpa4R+sYegeq5OJ0eHgjzIEU3ZB1k
         Xmd9NdlLYLK5skay/QFvyI7VFMEICX+igL1OomL3wn+o32MaykIw9i/W7D/BbKwlk+2u
         W9N8UrElBV27myfj6RiN1zt1SCd2QUkoWJpd5qP9qUp6xwJcQK0WtPdr3Y9DeXz+Y5OF
         u7+e/Plg8SANyKgnXDcmYRpBeQI2QC17XW9UzMjtqanJdXeyEISUSjXs4wCbZvD8kYub
         Y6kg==
X-Gm-Message-State: AOAM53030Ap0MJQdo9+LgBLFaXu9fjqnNheCHWgOkbhJeugcprQbt1yS
        ZBaHRcAzUHh956pHJuds5NAK+5Xmo5UVAz55dRqeIw==
X-Google-Smtp-Source: ABdhPJwAlGxr/1zawHOEblcIMu7Aqs0xO0V2N6++er6ast4QTNh0buwlDd9LFnxCQshsU2V7TjQxdDbA73wA3gTefp8=
X-Received: by 2002:a05:651c:54c:b0:249:9d06:24ef with SMTP id
 q12-20020a05651c054c00b002499d0624efmr2192669ljp.331.1647990811807; Tue, 22
 Mar 2022 16:13:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com> <20220311002528.2230172-22-dmatlack@google.com>
 <CAAhSdy1GzqknT1=tO0+LcjYkVQYRm0yUrpMbqo0UY5Ge6AdU0g@mail.gmail.com>
In-Reply-To: <CAAhSdy1GzqknT1=tO0+LcjYkVQYRm0yUrpMbqo0UY5Ge6AdU0g@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 22 Mar 2022 16:13:05 -0700
Message-ID: <CALzav=e3EoY0ev1nYC3kfFO0LBXnN1bgY2vcPJPcGxkiB3TuPA@mail.gmail.com>
Subject: Re: [PATCH v2 21/26] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To:     Anup Patel <anup@brainfault.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
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

On Fri, Mar 18, 2022 at 10:27 PM Anup Patel <anup@brainfault.org> wrote:
>
> On Fri, Mar 11, 2022 at 5:56 AM David Matlack <dmatlack@google.com> wrote:
> >
> > Allow the capacity of the kvm_mmu_memory_cache struct to be chosen at
> > declaration time rather than being fixed for all declarations. This will
> > be used in a follow-up commit to declare an cache in x86 with a capacity
> > of 512+ objects without having to increase the capacity of all caches in
> > KVM.
> >
> > This change requires each cache now specify its capacity at runtime,
> > since the cache struct itself no longer has a fixed capacity known at
> > compile time. To protect against someone accidentally defining a
> > kvm_mmu_memory_cache struct directly (without the extra storage), this
> > commit includes a WARN_ON() in kvm_mmu_topup_memory_cache().
> >
> > This change, unfortunately, adds some grottiness to
> > kvm_phys_addr_ioremap() in arm64, which uses a function-local (i.e.
> > stack-allocated) kvm_mmu_memory_cache struct. Since C does not allow
> > anonymous structs in functions, the new wrapper struct that contains
> > kvm_mmu_memory_cache and the objects pointer array, must be named, which
> > means dealing with an outer and inner struct. The outer struct can't be
> > dropped since then there would be no guarantee the kvm_mmu_memory_cache
> > struct and objects array would be laid out consecutively on the stack.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 +-
> >  arch/arm64/kvm/arm.c              |  1 +
> >  arch/arm64/kvm/mmu.c              | 13 +++++++++----
> >  arch/mips/include/asm/kvm_host.h  |  2 +-
> >  arch/mips/kvm/mips.c              |  2 ++
> >  arch/riscv/include/asm/kvm_host.h |  2 +-
> >  arch/riscv/kvm/vcpu.c             |  1 +
> >  arch/x86/include/asm/kvm_host.h   |  8 ++++----
> >  arch/x86/kvm/mmu/mmu.c            |  9 +++++++++
> >  include/linux/kvm_types.h         | 19 +++++++++++++++++--
> >  virt/kvm/kvm_main.c               | 10 +++++++++-
> >  11 files changed, 55 insertions(+), 14 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 5bc01e62c08a..1369415290dd 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -357,7 +357,7 @@ struct kvm_vcpu_arch {
> >         bool pause;
> >
> >         /* Cache some mmu pages needed inside spinlock regions */
> > -       struct kvm_mmu_memory_cache mmu_page_cache;
> > +       DEFINE_KVM_MMU_MEMORY_CACHE(mmu_page_cache);
> >
> >         /* Target CPU and feature flags */
> >         int target;
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index ecc5958e27fe..5e38385be0ef 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -319,6 +319,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >         vcpu->arch.target = -1;
> >         bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> >
> > +       vcpu->arch.mmu_page_cache.capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
> >         vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> >
> >         /* Set up the timer */
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index bc2aba953299..940089ba65ad 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -765,7 +765,12 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >  {
> >         phys_addr_t addr;
> >         int ret = 0;
> > -       struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> > +       DEFINE_KVM_MMU_MEMORY_CACHE(cache) page_cache = {
> > +               .cache = {
> > +                       .gfp_zero = __GFP_ZERO,
> > +                       .capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
> > +               },
> > +       };
> >         struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> >         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
> >                                      KVM_PGTABLE_PROT_R |
> > @@ -778,14 +783,14 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >         guest_ipa &= PAGE_MASK;
> >
> >         for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
> > -               ret = kvm_mmu_topup_memory_cache(&cache,
> > +               ret = kvm_mmu_topup_memory_cache(&page_cache.cache,
> >                                                  kvm_mmu_cache_min_pages(kvm));
> >                 if (ret)
> >                         break;
> >
> >                 spin_lock(&kvm->mmu_lock);
> >                 ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
> > -                                            &cache);
> > +                                            &page_cache.cache);
> >                 spin_unlock(&kvm->mmu_lock);
> >                 if (ret)
> >                         break;
> > @@ -793,7 +798,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >                 pa += PAGE_SIZE;
> >         }
> >
> > -       kvm_mmu_free_memory_cache(&cache);
> > +       kvm_mmu_free_memory_cache(&page_cache.cache);
> >         return ret;
> >  }
> >
> > diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> > index 717716cc51c5..935511d7fc3a 100644
> > --- a/arch/mips/include/asm/kvm_host.h
> > +++ b/arch/mips/include/asm/kvm_host.h
> > @@ -347,7 +347,7 @@ struct kvm_vcpu_arch {
> >         unsigned long pending_exceptions_clr;
> >
> >         /* Cache some mmu pages needed inside spinlock regions */
> > -       struct kvm_mmu_memory_cache mmu_page_cache;
> > +       DEFINE_KVM_MMU_MEMORY_CACHE(mmu_page_cache);
> >
> >         /* vcpu's vzguestid is different on each host cpu in an smp system */
> >         u32 vzguestid[NR_CPUS];
> > diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> > index a25e0b73ee70..45c7179144dc 100644
> > --- a/arch/mips/kvm/mips.c
> > +++ b/arch/mips/kvm/mips.c
> > @@ -387,6 +387,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >         if (err)
> >                 goto out_free_gebase;
> >
> > +       vcpu->arch.mmu_page_cache.capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
> > +
> >         return 0;
> >
> >  out_free_gebase:
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > index 99ef6a120617..5bd4902ebda3 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -186,7 +186,7 @@ struct kvm_vcpu_arch {
> >         struct kvm_sbi_context sbi_context;
> >
> >         /* Cache pages needed to program page tables with spinlock held */
> > -       struct kvm_mmu_memory_cache mmu_page_cache;
> > +       DEFINE_KVM_MMU_MEMORY_CACHE(mmu_page_cache);
> >
> >         /* VCPU power-off state */
> >         bool power_off;
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 624166004e36..6a5f5aa45bac 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -94,6 +94,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >
> >         /* Mark this VCPU never ran */
> >         vcpu->arch.ran_atleast_once = false;
> > +       vcpu->arch.mmu_page_cache.capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
> >         vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>
> There another function stage2_ioremap() which also needs to change
> because this function creates a kvm_mmu_memory_cache on stack.

Thanks for catching that. Will fix in v3.

>
> Regards,
> Anup
>
> >
> >         /* Setup ISA features available to VCPU */
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 0f5a36772bdc..544dde11963b 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -692,10 +692,10 @@ struct kvm_vcpu_arch {
> >          */
> >         struct kvm_mmu *walk_mmu;
> >
> > -       struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
> > -       struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> > -       struct kvm_mmu_memory_cache mmu_shadowed_translation_cache;
> > -       struct kvm_mmu_memory_cache mmu_page_header_cache;
> > +       DEFINE_KVM_MMU_MEMORY_CACHE(mmu_pte_list_desc_cache);
> > +       DEFINE_KVM_MMU_MEMORY_CACHE(mmu_shadow_page_cache);
> > +       DEFINE_KVM_MMU_MEMORY_CACHE(mmu_shadowed_translation_cache);
> > +       DEFINE_KVM_MMU_MEMORY_CACHE(mmu_page_header_cache);
> >
> >         /*
> >          * QEMU userspace and the guest each have their own FPU state.
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index dd56b5b9624f..24e7e053e05b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5817,12 +5817,21 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
> >  {
> >         int ret;
> >
> > +       vcpu->arch.mmu_pte_list_desc_cache.capacity =
> > +               KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
> >         vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
> >         vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
> >
> > +       vcpu->arch.mmu_page_header_cache.capacity =
> > +               KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
> >         vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
> >         vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
> >
> > +       vcpu->arch.mmu_shadowed_translation_cache.capacity =
> > +               KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
> > +
> > +       vcpu->arch.mmu_shadow_page_cache.capacity =
> > +               KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
> >         vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> >
> >         vcpu->arch.mmu = &vcpu->arch.root_mmu;
> > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > index ac1ebb37a0ff..579cf39986ec 100644
> > --- a/include/linux/kvm_types.h
> > +++ b/include/linux/kvm_types.h
> > @@ -83,14 +83,29 @@ struct gfn_to_pfn_cache {
> >   * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
> >   * holding MMU locks.  Note, these caches act more like prefetch buffers than
> >   * classical caches, i.e. objects are not returned to the cache on being freed.
> > + *
> > + * The storage for the cache object pointers is laid out after the struct, to
> > + * allow different declarations to choose different capacities. The capacity
> > + * field defines the number of object pointers available after the struct.
> >   */
> >  struct kvm_mmu_memory_cache {
> >         int nobjs;
> > +       int capacity;
> >         gfp_t gfp_zero;
> >         struct kmem_cache *kmem_cache;
> > -       void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
> > +       void *objects[];
> >  };
> > -#endif
> > +
> > +#define __DEFINE_KVM_MMU_MEMORY_CACHE(_name, _capacity)                \
> > +       struct {                                                \
> > +               struct kvm_mmu_memory_cache _name;              \
> > +               void *_name##_objects[_capacity];               \
> > +       }
> > +
> > +#define DEFINE_KVM_MMU_MEMORY_CACHE(_name) \
> > +       __DEFINE_KVM_MMU_MEMORY_CACHE(_name, KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE)
> > +
> > +#endif /* KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE */
> >
> >  #define HALT_POLL_HIST_COUNT                   32
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 9581a24c3d17..1d849ba9529f 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -371,9 +371,17 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> >  {
> >         void *obj;
> >
> > +       /*
> > +        * The capacity fieldmust be initialized since the storage for the
> > +        * objects pointer array is laid out after the kvm_mmu_memory_cache
> > +        * struct and not known at compile time.
> > +        */
> > +       if (WARN_ON(mc->capacity == 0))
> > +               return -EINVAL;
> > +
> >         if (mc->nobjs >= min)
> >                 return 0;
> > -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> > +       while (mc->nobjs < mc->capacity) {
> >                 obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> >                 if (!obj)
> >                         return mc->nobjs >= min ? 0 : -ENOMEM;
> > --
> > 2.35.1.723.g4982287a31-goog
> >
