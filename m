Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954E749B4FC
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 14:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575958AbiAYNZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 08:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576513AbiAYNWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 08:22:44 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42530C061763
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 05:22:40 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id p203so14552690oih.10
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 05:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aZqUIlm4PvtJlcx9bRdDGrSDogo725VWLZaRdcVhoa0=;
        b=iDkwH6BdBn7ZudT5jGT+bAtp8x9UEMX9taW9pwmkBeWl3VLuWFtgadqeNOdkOiFply
         5jNbQMDzH3uqgodmXACE6eoYtQ0lXndqYh8j+LxtV8hxOos8uykInR2qSpEF2xWj7RL6
         Q1cXZp6+Uu0DUJZ+h2Cs+78Bxgf9sTURDTlGibrZF2+XGtOr4SRdjKIMErWXBaUg6bRo
         fde3XT7aTdIbD5GlCGc38OcWmJE+WiZ7NHSW1CA9g9rcqmI4mE6XXioZUw7iQjcezgNj
         d38NtfGoyMlu7U9oU/SliZL0eYjsW3kDw7gp1RKcqOcFSWk2C1xxZhQL1qbPZ7xCOad7
         VdNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aZqUIlm4PvtJlcx9bRdDGrSDogo725VWLZaRdcVhoa0=;
        b=mB5mrp5YeN9Y3pvWdJvBl6SUiNFbuV4YqunJ9PGClXMLLxd40F3nUbeQu6sbgX+2+U
         9SCIFoNrLrf/q2y99l7LtFe71sE0M2Sp4T44xjIEI4Wwtylevg8L5nMabArFA2gV6j4G
         mJrHS3VRK8SNOfkZSo3QljqAhZ0R/xL6l824CvP25bvbfrCYzfQxE6+NZgSBEZeQIyn9
         epg5LsnGVfTbp5fYn4W3tpNHjx3f1N6Njqnoq+AoWY7sE3f6b/GMKxOLLtnqKLHS+XJk
         Yz3CetOSxpzdVilrVbZ04xHSJNeC94Heu7v3QBZc2cXs5i3dXJkBZbsWdFawX4BRBYN8
         8zHw==
X-Gm-Message-State: AOAM53304BrTL4tb4W+xPeiGPOi4LSAqO6/9TMsac3LAtETarUTdZ++J
        aOtjfwrShzG/xV+Ob/PFq1aoaK7W5Uhf6fL7pzUgJA==
X-Google-Smtp-Source: ABdhPJzMLwLIYDJONpUkGz4SJ/EhA3LdVHMhbBMl+Al394fvAYZIoKOdmC+i2H9D+sqiDiSCUOIaVac7X2yO2iSVYYI=
X-Received: by 2002:a05:6808:1785:: with SMTP id bg5mr578166oib.171.1643116959083;
 Tue, 25 Jan 2022 05:22:39 -0800 (PST)
MIME-Version: 1.0
References: <20220118015703.3630552-1-jingzhangos@google.com> <20220118015703.3630552-2-jingzhangos@google.com>
In-Reply-To: <20220118015703.3630552-2-jingzhangos@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 25 Jan 2022 13:22:03 +0000
Message-ID: <CA+EHjTw0NHow89cnPV4h0YZAZ32be6+_CQCqVov34xEUuuaa0w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Use read/write spin lock for MMU protection
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On Tue, Jan 18, 2022 at 1:57 AM Jing Zhang <jingzhangos@google.com> wrote:
>
> Replace MMU spinlock with rwlock and update all instances of the lock
> being acquired with a write lock acquisition.
> Future commit will add a fast path for permission relaxation during
> dirty logging under a read lock.

Looking at the code, building it and running it, it seems that all
instances of the lock are covered.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad




> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/mmu.c              | 36 +++++++++++++++----------------
>  2 files changed, 20 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3b44ea17af88..6c99c0335bae 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -50,6 +50,8 @@
>  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>                                      KVM_DIRTY_LOG_INITIALLY_SET)
>
> +#define KVM_HAVE_MMU_RWLOCK
> +
>  /*
>   * Mode of operation configurable with kvm-arm.mode early param.
>   * See Documentation/admin-guide/kernel-parameters.txt for more information.
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index bc2aba953299..cafd5813c949 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -58,7 +58,7 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
>                         break;
>
>                 if (resched && next != end)
> -                       cond_resched_lock(&kvm->mmu_lock);
> +                       cond_resched_rwlock_write(&kvm->mmu_lock);
>         } while (addr = next, addr != end);
>
>         return ret;
> @@ -179,7 +179,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>         struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>         phys_addr_t end = start + size;
>
> -       assert_spin_locked(&kvm->mmu_lock);
> +       lockdep_assert_held_write(&kvm->mmu_lock);
>         WARN_ON(size & ~PAGE_MASK);
>         WARN_ON(stage2_apply_range(kvm, start, end, kvm_pgtable_stage2_unmap,
>                                    may_block));
> @@ -213,13 +213,13 @@ static void stage2_flush_vm(struct kvm *kvm)
>         int idx, bkt;
>
>         idx = srcu_read_lock(&kvm->srcu);
> -       spin_lock(&kvm->mmu_lock);
> +       write_lock(&kvm->mmu_lock);
>
>         slots = kvm_memslots(kvm);
>         kvm_for_each_memslot(memslot, bkt, slots)
>                 stage2_flush_memslot(kvm, memslot);
>
> -       spin_unlock(&kvm->mmu_lock);
> +       write_unlock(&kvm->mmu_lock);
>         srcu_read_unlock(&kvm->srcu, idx);
>  }
>
> @@ -720,13 +720,13 @@ void stage2_unmap_vm(struct kvm *kvm)
>
>         idx = srcu_read_lock(&kvm->srcu);
>         mmap_read_lock(current->mm);
> -       spin_lock(&kvm->mmu_lock);
> +       write_lock(&kvm->mmu_lock);
>
>         slots = kvm_memslots(kvm);
>         kvm_for_each_memslot(memslot, bkt, slots)
>                 stage2_unmap_memslot(kvm, memslot);
>
> -       spin_unlock(&kvm->mmu_lock);
> +       write_unlock(&kvm->mmu_lock);
>         mmap_read_unlock(current->mm);
>         srcu_read_unlock(&kvm->srcu, idx);
>  }
> @@ -736,14 +736,14 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>         struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>         struct kvm_pgtable *pgt = NULL;
>
> -       spin_lock(&kvm->mmu_lock);
> +       write_lock(&kvm->mmu_lock);
>         pgt = mmu->pgt;
>         if (pgt) {
>                 mmu->pgd_phys = 0;
>                 mmu->pgt = NULL;
>                 free_percpu(mmu->last_vcpu_ran);
>         }
> -       spin_unlock(&kvm->mmu_lock);
> +       write_unlock(&kvm->mmu_lock);
>
>         if (pgt) {
>                 kvm_pgtable_stage2_destroy(pgt);
> @@ -783,10 +783,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>                 if (ret)
>                         break;
>
> -               spin_lock(&kvm->mmu_lock);
> +               write_lock(&kvm->mmu_lock);
>                 ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
>                                              &cache);
> -               spin_unlock(&kvm->mmu_lock);
> +               write_unlock(&kvm->mmu_lock);
>                 if (ret)
>                         break;
>
> @@ -834,9 +834,9 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
>         start = memslot->base_gfn << PAGE_SHIFT;
>         end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
>
> -       spin_lock(&kvm->mmu_lock);
> +       write_lock(&kvm->mmu_lock);
>         stage2_wp_range(&kvm->arch.mmu, start, end);
> -       spin_unlock(&kvm->mmu_lock);
> +       write_unlock(&kvm->mmu_lock);
>         kvm_flush_remote_tlbs(kvm);
>  }
>
> @@ -1212,7 +1212,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (exec_fault && device)
>                 return -ENOEXEC;
>
> -       spin_lock(&kvm->mmu_lock);
> +       write_lock(&kvm->mmu_lock);
>         pgt = vcpu->arch.hw_mmu->pgt;
>         if (mmu_notifier_retry(kvm, mmu_seq))
>                 goto out_unlock;
> @@ -1271,7 +1271,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         }
>
>  out_unlock:
> -       spin_unlock(&kvm->mmu_lock);
> +       write_unlock(&kvm->mmu_lock);
>         kvm_set_pfn_accessed(pfn);
>         kvm_release_pfn_clean(pfn);
>         return ret != -EAGAIN ? ret : 0;
> @@ -1286,10 +1286,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>
>         trace_kvm_access_fault(fault_ipa);
>
> -       spin_lock(&vcpu->kvm->mmu_lock);
> +       write_lock(&vcpu->kvm->mmu_lock);
>         mmu = vcpu->arch.hw_mmu;
>         kpte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
> -       spin_unlock(&vcpu->kvm->mmu_lock);
> +       write_unlock(&vcpu->kvm->mmu_lock);
>
>         pte = __pte(kpte);
>         if (pte_valid(pte))
> @@ -1692,9 +1692,9 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>         gpa_t gpa = slot->base_gfn << PAGE_SHIFT;
>         phys_addr_t size = slot->npages << PAGE_SHIFT;
>
> -       spin_lock(&kvm->mmu_lock);
> +       write_lock(&kvm->mmu_lock);
>         unmap_stage2_range(&kvm->arch.mmu, gpa, size);
> -       spin_unlock(&kvm->mmu_lock);
> +       write_unlock(&kvm->mmu_lock);
>  }
>
>  /*
> --
> 2.34.1.703.g22d0c6ccf7-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
