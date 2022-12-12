Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A677264A707
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbiLLSZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbiLLSYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:24:47 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786AE1146C
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:24:43 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id u10so8781516qvp.4
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AMcXpU9xF78qNj4uAPl+XF5OMVRy/HcRZ5eu+9Qyxok=;
        b=OwsVpfa01F6Vy1licgfoHfJAh300jir6SR8hGTbRWrx9HTeKg0xZPDCCt+5dd8pusT
         rGbZhVXiQHmIzMeTkfc1aGvwobd/+EdNM6SkF1+VCoUAjUvpbe2hwVzUKkOJuIryOnpw
         kLa95FwRX0IoFYtBZqP2gfUz2LRqfHCcykOPBEuMfRc4Ujt0DOtkDDvFOxcjg/diyIy0
         gPjUEEWEcA4PXdH/TbGxgRrm5JPZ5fSs/GawoWTfeOJEebJzDbDnqJgKFGzQd/JOIVEB
         aRc3NjkudM2tmCsD1JTWZGQLR/EoV9nXjRPHQn7ZIol/iewVFH6MQhvEfI/MCwJPODcm
         v7xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AMcXpU9xF78qNj4uAPl+XF5OMVRy/HcRZ5eu+9Qyxok=;
        b=s1WRbvQISXryMo4AJZmuZRh7kZx6qR6aRrGBDNy+R9cz0fbzlsdfFebPKNQCxVbMDc
         rKUJYNdH3kARoyrjx26NQwJccF0SdIIefphx3YkFe+FsTQH5ssf/0zHpMG4cmPJJ99OJ
         gdGN7EHxkYQJsxDgQPIO1EFeVmpsvLt/wdt+BMNmhOr0mbcH9CB5wYuPCZiv94TV5XfM
         zy04DVSCFyCXYkgUJoUVB9L8XFlz8xociGz3lYyFYC24aEcvrnD33N5rkiQgGvIkoexn
         2YVYIFgd/YAFuDAp+JrhHAMpFCfmoWiM9GUDDghI4Q9IAnZ+T5en8JFhblz9PJlhQ28z
         s70w==
X-Gm-Message-State: ANoB5pmq2nGntXioAnShFGTziZQbBK6xYodoSgc9DGJKNex6lj+xjd95
        kDPcqSKem8pGBgY/ZYEycit8ZCtZrRr6zLQnDjSNbQ==
X-Google-Smtp-Source: AA0mqf6fu7BuuPFxqp6T8XG4FGosl4ytNjM6B55YI7JB6FeyGgrfnzSzOHl5Ktl+KxaL+Yjgll/5/5F5JDyyvFAZIlg=
X-Received: by 2002:a0c:e6a9:0:b0:4bb:892a:fc11 with SMTP id
 j9-20020a0ce6a9000000b004bb892afc11mr68548097qvn.28.1670869482342; Mon, 12
 Dec 2022 10:24:42 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-11-dmatlack@google.com>
In-Reply-To: <20221208193857.4090582-11-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 12 Dec 2022 10:24:31 -0800
Message-ID: <CANgfPd-DaxszBe6vLQGe=LKNKx8bDX-AC_30qLVAyYkQXwN7WA@mail.gmail.com>
Subject: Re: [RFC PATCH 10/37] KVM: MMU: Move struct kvm_page_fault to common code
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 8, 2022 at 11:39 AM David Matlack <dmatlack@google.com> wrote:
>
> Move struct kvm_page_fault to common code. This will be used in a future
> commit to move the TDP MMU to common code.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/include/asm/kvm/mmu_types.h | 20 +++++++
>  arch/x86/kvm/mmu/mmu.c               | 19 +++----
>  arch/x86/kvm/mmu/mmu_internal.h      | 79 ++++++----------------------
>  arch/x86/kvm/mmu/mmutrace.h          |  2 +-
>  arch/x86/kvm/mmu/paging_tmpl.h       | 14 ++---
>  arch/x86/kvm/mmu/tdp_mmu.c           |  6 +--
>  include/kvm/mmu_types.h              | 44 ++++++++++++++++
>  7 files changed, 100 insertions(+), 84 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm/mmu_types.h b/arch/x86/include/asm/kvm/mmu_types.h
> index affcb520b482..59d1be85f4b7 100644
> --- a/arch/x86/include/asm/kvm/mmu_types.h
> +++ b/arch/x86/include/asm/kvm/mmu_types.h
> @@ -5,6 +5,7 @@
>  #include <linux/bitmap.h>
>  #include <linux/list.h>
>  #include <linux/types.h>
> +#include <linux/kvm_types.h>
>
>  /*
>   * This is a subset of the overall kvm_cpu_role to minimize the size of
> @@ -115,4 +116,23 @@ struct kvm_mmu_page_arch {
>         atomic_t write_flooding_count;
>  };
>
> +struct kvm_page_fault_arch {
> +       const u32 error_code;
> +
> +       /* x86-specific error code bits */
> +       const bool present;
> +       const bool rsvd;
> +       const bool user;
> +
> +       /* Derived from mmu and global state.  */
> +       const bool is_tdp;
> +       const bool nx_huge_page_workaround_enabled;
> +
> +       /*
> +        * Whether a >4KB mapping can be created or is forbidden due to NX
> +        * hugepages.
> +        */
> +       bool huge_page_disallowed;
> +};
> +
>  #endif /* !__ASM_KVM_MMU_TYPES_H */
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e47f35878ab5..0593d4a60139 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3092,7 +3092,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>         struct kvm_memory_slot *slot = fault->slot;
>         kvm_pfn_t mask;
>
> -       fault->huge_page_disallowed = fault->exec && fault->nx_huge_page_workaround_enabled;
> +       fault->arch.huge_page_disallowed =
> +               fault->exec && fault->arch.nx_huge_page_workaround_enabled;
>
>         if (unlikely(fault->max_level == PG_LEVEL_4K))
>                 return;
> @@ -3109,7 +3110,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>          */
>         fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, slot,
>                                                      fault->gfn, fault->max_level);
> -       if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
> +       if (fault->req_level == PG_LEVEL_4K || fault->arch.huge_page_disallowed)
>                 return;
>
>         /*
> @@ -3158,7 +3159,7 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                  * We cannot overwrite existing page tables with an NX
>                  * large page, as the leaf could be executable.
>                  */
> -               if (fault->nx_huge_page_workaround_enabled)
> +               if (fault->arch.nx_huge_page_workaround_enabled)
>                         disallowed_hugepage_adjust(fault, *it.sptep, it.level);
>
>                 base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
> @@ -3170,7 +3171,7 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                         continue;
>
>                 link_shadow_page(vcpu, it.sptep, sp);
> -               if (fault->huge_page_disallowed)
> +               if (fault->arch.huge_page_disallowed)
>                         account_nx_huge_page(vcpu->kvm, sp,
>                                              fault->req_level >= it.level);
>         }
> @@ -3221,7 +3222,7 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
>                                    struct kvm_page_fault *fault,
>                                    unsigned int access)
>  {
> -       gva_t gva = fault->is_tdp ? 0 : fault->addr;
> +       gva_t gva = fault->arch.is_tdp ? 0 : fault->addr;
>
>         vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
>                              access & shadow_mmio_access_mask);
> @@ -3255,7 +3256,7 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
>          * generation number.  Refreshing the MMIO generation needs to go down
>          * the slow path.  Note, EPT Misconfigs do NOT set the PRESENT flag!
>          */
> -       if (fault->rsvd)
> +       if (fault->arch.rsvd)
>                 return false;
>
>         /*
> @@ -3273,7 +3274,7 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
>          *    SPTE is MMU-writable (determined later), the fault can be fixed
>          *    by setting the Writable bit, which can be done out of mmu_lock.
>          */
> -       if (!fault->present)
> +       if (!fault->arch.present)
>                 return !kvm_ad_enabled();
>
>         /*
> @@ -4119,10 +4120,10 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>  static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
>                                          struct kvm_page_fault *fault)
>  {
> -       if (unlikely(fault->rsvd))
> +       if (unlikely(fault->arch.rsvd))
>                 return false;
>
> -       if (!fault->present || !fault->write)
> +       if (!fault->arch.present || !fault->write)
>                 return false;
>
>         /*
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index af2ae4887e35..4abb80a3bd01 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -77,60 +77,6 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
>         return READ_ONCE(nx_huge_pages) && !kvm->arch.disable_nx_huge_pages;
>  }
>
> -struct kvm_page_fault {
> -       /* arguments to kvm_mmu_do_page_fault.  */
> -       const gpa_t addr;
> -       const u32 error_code;
> -       const bool prefetch;
> -
> -       /* Derived from error_code.  */
> -       const bool exec;
> -       const bool write;
> -       const bool present;
> -       const bool rsvd;
> -       const bool user;
> -
> -       /* Derived from mmu and global state.  */
> -       const bool is_tdp;
> -       const bool nx_huge_page_workaround_enabled;
> -
> -       /*
> -        * Whether a >4KB mapping can be created or is forbidden due to NX
> -        * hugepages.
> -        */
> -       bool huge_page_disallowed;
> -
> -       /*
> -        * Maximum page size that can be created for this fault; input to
> -        * FNAME(fetch), direct_map() and kvm_tdp_mmu_map().
> -        */
> -       u8 max_level;
> -
> -       /*
> -        * Page size that can be created based on the max_level and the
> -        * page size used by the host mapping.
> -        */
> -       u8 req_level;
> -
> -       /*
> -        * Page size that will be created based on the req_level and
> -        * huge_page_disallowed.
> -        */
> -       u8 goal_level;
> -
> -       /* Shifted addr, or result of guest page table walk if addr is a gva.  */
> -       gfn_t gfn;
> -
> -       /* The memslot containing gfn. May be NULL. */
> -       struct kvm_memory_slot *slot;
> -
> -       /* Outputs of kvm_faultin_pfn.  */
> -       unsigned long mmu_seq;
> -       kvm_pfn_t pfn;
> -       hva_t hva;
> -       bool map_writable;
> -};
> -
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>
>  /*
> @@ -164,22 +110,27 @@ enum {
>  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>                                         u32 err, bool prefetch)
>  {
> +       bool is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault);
>         struct kvm_page_fault fault = {
>                 .addr = cr2_or_gpa,
> -               .error_code = err,
> -               .exec = err & PFERR_FETCH_MASK,
> -               .write = err & PFERR_WRITE_MASK,
> -               .present = err & PFERR_PRESENT_MASK,
> -               .rsvd = err & PFERR_RSVD_MASK,
> -               .user = err & PFERR_USER_MASK,
>                 .prefetch = prefetch,
> -               .is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
> -               .nx_huge_page_workaround_enabled =
> -                       is_nx_huge_page_enabled(vcpu->kvm),
> +
> +               .write = err & PFERR_WRITE_MASK,
> +               .exec = err & PFERR_FETCH_MASK,
>
>                 .max_level = KVM_MAX_HUGEPAGE_LEVEL,
>                 .req_level = PG_LEVEL_4K,
>                 .goal_level = PG_LEVEL_4K,
> +
> +               .arch = {
> +                       .error_code = err,
> +                       .present = err & PFERR_PRESENT_MASK,
> +                       .rsvd = err & PFERR_RSVD_MASK,
> +                       .user = err & PFERR_USER_MASK,
> +                       .is_tdp = is_tdp,
> +                       .nx_huge_page_workaround_enabled =
> +                               is_nx_huge_page_enabled(vcpu->kvm),
> +               },
>         };
>         int r;
>
> @@ -196,7 +147,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>         if (!prefetch)
>                 vcpu->stat.pf_taken++;
>
> -       if (IS_ENABLED(CONFIG_RETPOLINE) && fault.is_tdp)
> +       if (IS_ENABLED(CONFIG_RETPOLINE) && fault.arch.is_tdp)
>                 r = kvm_tdp_page_fault(vcpu, &fault);
>         else
>                 r = vcpu->arch.mmu->page_fault(vcpu, &fault);
> diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
> index 335f26dabdf3..b01767acf073 100644
> --- a/arch/x86/kvm/mmu/mmutrace.h
> +++ b/arch/x86/kvm/mmu/mmutrace.h
> @@ -270,7 +270,7 @@ TRACE_EVENT(
>         TP_fast_assign(
>                 __entry->vcpu_id = vcpu->vcpu_id;
>                 __entry->cr2_or_gpa = fault->addr;
> -               __entry->error_code = fault->error_code;
> +               __entry->error_code = fault->arch.error_code;
>                 __entry->sptep = sptep;
>                 __entry->old_spte = old_spte;
>                 __entry->new_spte = *sptep;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 18bb92b70a01..daf9c7731edc 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -698,7 +698,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>                  * We cannot overwrite existing page tables with an NX
>                  * large page, as the leaf could be executable.
>                  */
> -               if (fault->nx_huge_page_workaround_enabled)
> +               if (fault->arch.nx_huge_page_workaround_enabled)
>                         disallowed_hugepage_adjust(fault, *it.sptep, it.level);
>
>                 base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
> @@ -713,7 +713,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>                         continue;
>
>                 link_shadow_page(vcpu, it.sptep, sp);
> -               if (fault->huge_page_disallowed)
> +               if (fault->arch.huge_page_disallowed)
>                         account_nx_huge_page(vcpu->kvm, sp,
>                                              fault->req_level >= it.level);
>         }
> @@ -793,8 +793,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>         int r;
>         bool is_self_change_mapping;
>
> -       pgprintk("%s: addr %lx err %x\n", __func__, fault->addr, fault->error_code);
> -       WARN_ON_ONCE(fault->is_tdp);
> +       pgprintk("%s: addr %lx err %x\n", __func__, fault->addr, fault->arch.error_code);
> +       WARN_ON_ONCE(fault->arch.is_tdp);
>
>         /*
>          * Look up the guest pte for the faulting address.
> @@ -802,7 +802,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>          * The bit needs to be cleared before walking guest page tables.
>          */
>         r = FNAME(walk_addr)(&walker, vcpu, fault->addr,
> -                            fault->error_code & ~PFERR_RSVD_MASK);
> +                            fault->arch.error_code & ~PFERR_RSVD_MASK);
>
>         /*
>          * The page is not mapped by the guest.  Let the guest handle it.
> @@ -830,7 +830,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>         vcpu->arch.write_fault_to_shadow_pgtable = false;
>
>         is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
> -             &walker, fault->user, &vcpu->arch.write_fault_to_shadow_pgtable);
> +             &walker, fault->arch.user, &vcpu->arch.write_fault_to_shadow_pgtable);
>
>         if (is_self_change_mapping)
>                 fault->max_level = PG_LEVEL_4K;
> @@ -846,7 +846,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>          * we will cache the incorrect access into mmio spte.
>          */
>         if (fault->write && !(walker.pte_access & ACC_WRITE_MASK) &&
> -           !is_cr0_wp(vcpu->arch.mmu) && !fault->user && fault->slot) {
> +           !is_cr0_wp(vcpu->arch.mmu) && !fault->arch.user && fault->slot) {
>                 walker.pte_access |= ACC_WRITE_MASK;
>                 walker.pte_access &= ~ACC_USER_MASK;
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 66231c7ed31e..4940413d3767 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1156,7 +1156,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>         tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
>                 int r;
>
> -               if (fault->nx_huge_page_workaround_enabled)
> +               if (fault->arch.nx_huge_page_workaround_enabled)
>                         disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
>
>                 if (iter.level == fault->goal_level)
> @@ -1181,7 +1181,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                 sp = tdp_mmu_alloc_sp(vcpu);
>                 tdp_mmu_init_child_sp(sp, &iter);
>
> -               sp->arch.nx_huge_page_disallowed = fault->huge_page_disallowed;
> +               sp->arch.nx_huge_page_disallowed = fault->arch.huge_page_disallowed;
>
>                 if (is_shadow_present_pte(iter.old_spte))
>                         r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
> @@ -1197,7 +1197,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                         goto retry;
>                 }
>
> -               if (fault->huge_page_disallowed &&
> +               if (fault->arch.huge_page_disallowed &&
>                     fault->req_level >= iter.level) {
>                         spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>                         track_possible_nx_huge_page(kvm, sp);
> diff --git a/include/kvm/mmu_types.h b/include/kvm/mmu_types.h
> index a9da33d4baa8..9f0ca920bf68 100644
> --- a/include/kvm/mmu_types.h
> +++ b/include/kvm/mmu_types.h
> @@ -66,4 +66,48 @@ struct kvm_mmu_page {
>         struct kvm_mmu_page_arch arch;
>  };
>
> +struct kvm_page_fault {
> +       /* The raw faulting address. */
> +       const gpa_t addr;
> +
> +       /* Whether the fault was synthesized to prefetch a mapping. */
> +       const bool prefetch;
> +
> +       /* Information about the cause of the fault. */
> +       const bool write;
> +       const bool exec;
> +
> +       /* Shifted addr, or result of guest page table walk if shadow paging. */
> +       gfn_t gfn;

Is this redundant to have in common code? If we're not doing common
shadow paging, then this is just addr shifted. Would this be better
placed in the arch specific struct?

> +
> +       /* The memslot that contains @gfn. May be NULL. */
> +       struct kvm_memory_slot *slot;
> +
> +       /* Maximum page size that can be created for this fault. */
> +       u8 max_level;
> +
> +       /*
> +        * Page size that can be created based on the max_level and the page
> +        * size used by the host mapping.
> +        */
> +       u8 req_level;
> +
> +       /* Final page size that will be created. */
> +       u8 goal_level;
> +
> +       /*
> +        * The value of kvm->mmu_invalidate_seq before fetching the host
> +        * mapping. Used to verify that the host mapping has not changed
> +        * after grabbing the MMU lock.
> +        */
> +       unsigned long mmu_seq;

Should this be ifdef'ed with  KVM_ARCH_WANT_MMU_NOTIFIER?

> +
> +       /* Information about the host mapping. */
> +       kvm_pfn_t pfn;
> +       hva_t hva;
> +       bool map_writable;
> +
> +       struct kvm_page_fault_arch arch;
> +};
> +
>  #endif /* !__KVM_MMU_TYPES_H */
> --
> 2.39.0.rc1.256.g54fd8350bd-goog
>
