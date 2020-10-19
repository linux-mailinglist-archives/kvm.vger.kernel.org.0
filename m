Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756F9292D5E
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 20:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbgJSSPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 14:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727681AbgJSSPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Oct 2020 14:15:19 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26475C0613CE
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 11:15:18 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id k1so1154755ilc.10
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 11:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4gYuks0eNFNk4+IRmuTj6ZW5y94LvZs1cV9FIEVv/Wo=;
        b=In2Swze9MiDMA5GGIMt/GQabBQG6VnnUpaW3TGpn1NE07MXnVVOrgMfkps06E2YLiL
         t1vs+7ogq8VMAq9nLGGCkIpoX1QhTjQ/caqwDovQ8pqoNB5t7+ObosSN/XfpZCSZ0oN1
         2v1OTk9nQhhdtQ6+IFVr8+FoagrmTh956KBdy9oqi24JKWZ/LdcuIoJBjjMWenp4eASz
         KMblyl61OzmRNKEwPhLSftPEUxyTnNKnvKHPDX8aF9ZJrZGs0buMmNiYsVh+R1WKwzae
         FOFw3U5QFA1WCyvn2YIBLppLLrYsqtEx7Cku00XRThBbke3F/enOQ2Oo8yZcdow0Q50c
         a+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4gYuks0eNFNk4+IRmuTj6ZW5y94LvZs1cV9FIEVv/Wo=;
        b=DZnDrO6lGCxSUSCpS0hv+EtkC/jpsNIRMYt+kIiJ4PnkzV8GWgk1DpLNLIBaYSiV5b
         cXv5CTt6wPdzHMZmNDDchfWCflAy0NQfWZ/Ik0LP7AuTu5rZLTXN9DNrcx9WnSq+hjWr
         1BNNtHvOb3zKMCL+4oS/hijOLas+dHdsLPucmGpIeK/DRGyb6SdU+N4T5ujOuI0YkKG5
         MKN4Az9U66tzVMxOUDAiwykqN8pL/zMFY6a3yCLBLLeWjIUfMORJgdWKv5qs+7Wut46a
         xvzdhlcesnEawL3GXA54c8v91d/3kIg24PLypPRFSuOYxq2laxx2vraCqCFrTjep72an
         wJuw==
X-Gm-Message-State: AOAM533JrJC4YUBLy5D0mI+pJvsBdFtY+wwGjuM26uCULRfX0I5dFInx
        1tgGvsQtULZz+QuPlRYIaZwrUaR+Zne/Tzqe1O0KwQ==
X-Google-Smtp-Source: ABdhPJxUrVrZfl7yPuuSiTqpw20o69qaRJMDT5Up7O0G+BFOHPOXNpzrZdslbqgQAe/zIciB3b8YAZGl6GzKQ5OTaq8=
X-Received: by 2002:a92:5b02:: with SMTP id p2mr1001729ilb.283.1603131317197;
 Mon, 19 Oct 2020 11:15:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com> <f19b7f9c-ff73-c2d2-19f9-173dc8a673c3@redhat.com>
In-Reply-To: <f19b7f9c-ff73-c2d2-19f9-173dc8a673c3@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 19 Oct 2020 11:15:04 -0700
Message-ID: <CANgfPd9CpYt9bVNXWbB+2VTrndfLBezqPauDo2-n8UdKDsrzpA@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] Introduce the TDP MMU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 16, 2020 at 9:50 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 14/10/20 20:26, Ben Gardon wrote:
> >  arch/x86/include/asm/kvm_host.h |   14 +
> >  arch/x86/kvm/Makefile           |    3 +-
> >  arch/x86/kvm/mmu/mmu.c          |  487 +++++++------
> >  arch/x86/kvm/mmu/mmu_internal.h |  242 +++++++
> >  arch/x86/kvm/mmu/paging_tmpl.h  |    3 +-
> >  arch/x86/kvm/mmu/tdp_iter.c     |  181 +++++
> >  arch/x86/kvm/mmu/tdp_iter.h     |   60 ++
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 1154 +++++++++++++++++++++++++++++++
> >  arch/x86/kvm/mmu/tdp_mmu.h      |   48 ++
> >  include/linux/kvm_host.h        |    2 +
> >  virt/kvm/kvm_main.c             |   12 +-
> >  11 files changed, 1944 insertions(+), 262 deletions(-)
> >  create mode 100644 arch/x86/kvm/mmu/tdp_iter.c
> >  create mode 100644 arch/x86/kvm/mmu/tdp_iter.h
> >  create mode 100644 arch/x86/kvm/mmu/tdp_mmu.c
> >  create mode 100644 arch/x86/kvm/mmu/tdp_mmu.h
> >
>
> My implementation of tdp_iter_set_spte was completely different, but
> of course that's not an issue; I would still like to understand and
> comment on why the bool arguments to __tdp_mmu_set_spte are needed.

The simplest explanation for those options to not mark the page as
dirty in the dirty bitmap or not mark the page accessed is simply that
the legacy MMU doesn't do it, but I will outline why it doesn't more
specifically.

Let's consider dirty logging first. When getting the dirty log, we
follow the following steps:
1. Atomically get and clear an unsigned long of the dirty bitmap
2. For each GFN in the range of pages covered by the unsigned long mask:
    3. Clear the dirty or writable bit on the SPTE
4. Copy the mask of dirty pages to be returned to userspace

If we mark the page as dirty in the dirty bitmap in step 3, we'll
report the page as dirty twice - once in this dirty log call, and
again in the next one. This can lead to unexpected behavior:
1. Pause all vCPUs
2. Get the dirty log <--- Returns all pages dirtied before the vCPUs were paused
3. Get the dirty log again <--- Unexpectedly returns a non-zero number
of dirty pages even though no pages were actually dirtied

I believe a similar process happens for access tracking though MMU
notifiers which would lead to incorrect behavior if we called
kvm_set_pfn_accessed during the handler for notifier_clear_young or
notifier_clear_flush_young

>
> Apart from splitting tdp_mmu_iter_flush_cond_resched from
> tdp_mmu_iter_cond_resched, my remaining changes on top are pretty
> small and mostly cosmetic.  I'll give it another go next week
> and send it Linus's way if everything's all right.

Fantastic, thank you!

>
> Paolo
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index f8525c89fc95..baf260421a56 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -7,20 +7,15 @@
>  #include "tdp_mmu.h"
>  #include "spte.h"
>
> +#ifdef CONFIG_X86_64
>  static bool __read_mostly tdp_mmu_enabled = false;
> +module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
> +#endif
>
>  static bool is_tdp_mmu_enabled(void)
>  {
>  #ifdef CONFIG_X86_64
> -       if (!READ_ONCE(tdp_mmu_enabled))
> -               return false;
> -
> -       if (WARN_ONCE(!tdp_enabled,
> -                     "Creating a VM with TDP MMU enabled requires TDP."))
> -               return false;
> -
> -       return true;
> -
> +       return tdp_enabled && READ_ONCE(tdp_mmu_enabled);
>  #else
>         return false;
>  #endif /* CONFIG_X86_64 */
> @@ -277,8 +277,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>                         unaccount_huge_nx_page(kvm, sp);
>
>                 for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
> -                       old_child_spte = *(pt + i);
> -                       *(pt + i) = 0;
> +                       old_child_spte = READ_ONCE(*(pt + i));
> +                       WRITE_ONCE(*(pt + i), 0);
>                         handle_changed_spte(kvm, as_id,
>                                 gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
>                                 old_child_spte, 0, level - 1);
> @@ -309,7 +309,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>         struct kvm_mmu_page *root = sptep_to_sp(root_pt);
>         int as_id = kvm_mmu_page_as_id(root);
>
> -       *iter->sptep = new_spte;
> +       WRITE_ONCE(*iter->sptep, new_spte);
>
>         __handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
>                               iter->level);
> @@ -361,16 +361,28 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
>         for_each_tdp_pte(_iter, __va(_mmu->root_hpa),           \
>                          _mmu->shadow_root_level, _start, _end)
>
> -static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
> +/*
> + * Flush the TLB if the process should drop kvm->mmu_lock.
> + * Return whether the caller still needs to flush the tlb.
> + */
> +static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
>  {
>         if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
>                 kvm_flush_remote_tlbs(kvm);
>                 cond_resched_lock(&kvm->mmu_lock);
>                 tdp_iter_refresh_walk(iter);
> +               return false;
> +       } else {
>                 return true;
>         }
> +}
>
> -       return false;
> +static void tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
> +{
> +       if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
> +               cond_resched_lock(&kvm->mmu_lock);
> +               tdp_iter_refresh_walk(iter);
> +       }
>  }
>
>  /*
> @@ -407,7 +419,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>                 tdp_mmu_set_spte(kvm, &iter, 0);
>
>                 if (can_yield)
> -                       flush_needed = !tdp_mmu_iter_cond_resched(kvm, &iter);
> +                       flush_needed = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
>                 else
>                         flush_needed = true;
>         }
> @@ -479,7 +479,10 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
>                                          map_writable, !shadow_accessed_mask,
>                                          &new_spte);
>
> -       tdp_mmu_set_spte(vcpu->kvm, iter, new_spte);
> +       if (new_spte == iter->old_spte)
> +               ret = RET_PF_SPURIOUS;
> +       else
> +               tdp_mmu_set_spte(vcpu->kvm, iter, new_spte);
>
>         /*
>          * If the page fault was caused by a write but the page is write
> @@ -496,7 +496,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
>         }
>
>         /* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
> -       if (unlikely(is_mmio_spte(new_spte)))
> +       else if (unlikely(is_mmio_spte(new_spte)))
>                 ret = RET_PF_EMULATE;
>
>         trace_kvm_mmu_set_spte(iter->level, iter->gfn, iter->sptep);
> @@ -528,8 +528,10 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         int level;
>         int req_level;
>
> -       BUG_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa));
> -       BUG_ON(!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa));
> +       if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
> +               return RET_PF_ENTRY;
> +       if (WARN_ON(!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)))
> +               return RET_PF_ENTRY;
>
>         level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
>                                         huge_page_disallowed, &req_level);
> @@ -579,7 +581,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>                 }
>         }
>
> -       BUG_ON(iter.level != level);
> +       if (WARN_ON(iter.level != level))
> +               return RET_PF_RETRY;
>
>         ret = tdp_mmu_map_handle_target_level(vcpu, write, map_writable, &iter,
>                                               pfn, prefault);
> @@ -817,9 +829,8 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
>                  */
>                 kvm_mmu_get_root(kvm, root);
>
> -               spte_set = wrprot_gfn_range(kvm, root, slot->base_gfn,
> -                               slot->base_gfn + slot->npages, min_level) ||
> -                          spte_set;
> +               spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
> +                            slot->base_gfn + slot->npages, min_level);
>
>                 kvm_mmu_put_root(kvm, root);
>         }
> @@ -886,8 +897,8 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
>                  */
>                 kvm_mmu_get_root(kvm, root);
>
> -               spte_set = clear_dirty_gfn_range(kvm, root, slot->base_gfn,
> -                               slot->base_gfn + slot->npages) || spte_set;
> +               spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
> +                               slot->base_gfn + slot->npages);
>
>                 kvm_mmu_put_root(kvm, root);
>         }
> @@ -1009,8 +1020,8 @@ bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
>                  */
>                 kvm_mmu_get_root(kvm, root);
>
> -               spte_set = set_dirty_gfn_range(kvm, root, slot->base_gfn,
> -                               slot->base_gfn + slot->npages) || spte_set;
> +               spte_set |= set_dirty_gfn_range(kvm, root, slot->base_gfn,
> +                               slot->base_gfn + slot->npages);
>
>                 kvm_mmu_put_root(kvm, root);
>         }
> @@ -1042,9 +1053,9 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>                         continue;
>
>                 tdp_mmu_set_spte(kvm, &iter, 0);
> -               spte_set = true;
>
> -               spte_set = !tdp_mmu_iter_cond_resched(kvm, &iter);
> +               spte_set = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
>         }
>
>         if (spte_set)
>
