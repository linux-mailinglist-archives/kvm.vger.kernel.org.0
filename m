Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDC13EAA3F
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 20:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbhHLSaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 14:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbhHLSaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 14:30:13 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18603C061756
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:29:48 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id a7-20020a9d5c870000b029050333abe08aso8820999oti.13
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8p/OCx8wfKLI1Vwr3WoruCyYyLDk0HKlG9q3THas0Ro=;
        b=pCkiiuBcAuyJQfE4lgHO2ZNaNUHxyIZv+gkKlkHTrJLj5xvMeJrz9bWScyqw/CpS24
         YZ+1Q8phMUIM9RivFHJsILLnwPWCWsXFbUTNrUi9gUfYWVUuUI93UEj1Ol6uwBY3alyn
         P/deOXHX0+ZtYJfTnYvzFAIdZ79Y3niK8GIX0bATy2Pkv1WicFhfc75p31bOoAmQtr2D
         siqWqJ2SiIxlmKmr+hg5DahX0u3DwOT83FVQtueF/qQKjhk3fEgSsQXcwi4U6OYnJhSQ
         qxj1aJfTWJ/BGdp5X6hAdhaK1VFAYJDW6YItkYu5eOXSaEX0JWr3HsODbMbraE8ogrPl
         kBlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8p/OCx8wfKLI1Vwr3WoruCyYyLDk0HKlG9q3THas0Ro=;
        b=mjSDzPlSUWX8159/22dUi29f4L6sOti62Ed85pWJyfnSeuA5lH8vELfcjhl4AiEYUy
         6k5sA5iekdTCvIIn/j3egGzjYjsi+d6jAffU3pM6OKNiO5amkNRoyH7BM5T7z9YmNgka
         b4Ipvo5RIWySvh5v6lxUDF3CBXJKud4ZrgbwzEktz89fA1Pg7sDyZmaqpoMdKisJp3W0
         ECBwfda3V1S4t2JgFZwleWg7Zr8bNICdXs0FA6438uu2oaY3zd5YvHYesyO2mYnj/vOp
         6BcjLeEooXwd1mBfWf04MJxtGha1teTSGwmwOaYvmTwtfwzu5pAFhvJ0uIuPEGoF1rQA
         cpTw==
X-Gm-Message-State: AOAM533YzN01Pu9EHhvkiZSX5bezujzMEg3yDnPrZTCT3aX04bvOOZoX
        pDrVHW7ywDsBaKcaDn0Uy8No8AJGqSmx8HF/vFKs/Q==
X-Google-Smtp-Source: ABdhPJwmK/AbZDsA28wYWSSvhqmGx87EEzk8m55h/Bl6sOe/aSIg0F5Q/OX5FkRbNMXJ6bvis0pEJwYbT6vvgpWqJyo=
X-Received: by 2002:a05:6830:189:: with SMTP id q9mr4548874ota.313.1628792987226;
 Thu, 12 Aug 2021 11:29:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210812181815.3378104-1-seanjc@google.com>
In-Reply-To: <20210812181815.3378104-1-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 12 Aug 2021 11:29:35 -0700
Message-ID: <CANgfPd-SsnkBeAuZ0eVRknjLo3DNP2ZnzF88KQTkACj+sU55OQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Protect marking SPs unsync when using
 TDP MMU with spinlock
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 12, 2021 at 11:18 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Add yet another spinlock for the TDP MMU and take it when marking indirect
> shadow pages unsync.  When using the TDP MMU and L1 is running L2(s) with
> nested TDP, KVM may encounter shadow pages for the TDP entries managed by
> L1 (controlling L2) when handling a TDP MMU page fault.  The unsync logic
> is not thread safe, e.g. the kvm_mmu_page fields are not atomic, and
> misbehaves when a shadow page is marked unsync via a TDP MMU page fault,
> which runs with mmu_lock held for read, not write.
>
> Lack of a critical section manifests most visibly as an underflow of
> unsync_children in clear_unsync_child_bit() due to unsync_children being
> corrupted when multiple CPUs write it without a critical section and
> without atomic operations.  But underflow is the best case scenario.  The
> worst case scenario is that unsync_children prematurely hits '0' and
> leads to guest memory corruption due to KVM neglecting to properly sync
> shadow pages.
>
> Use an entirely new spinlock even though piggybacking tdp_mmu_pages_lock
> would functionally be ok.  Usurping the lock could degrade performance when
> building upper level page tables on different vCPUs, especially since the
> unsync flow could hold the lock for a comparatively long time depending on
> the number of indirect shadow pages and the depth of the paging tree.
>
> For simplicity, take the lock for all MMUs, even though KVM could fairly
> easily know that mmu_lock is held for write.  If mmu_lock is held for
> write, there cannot be contention for the inner spinlock, and marking
> shadow pages unsync across multiple vCPUs will be slow enough that
> bouncing the kvm_arch cacheline should be in the noise.
>
> Note, even though L2 could theoretically be given access to its own EPT
> entries, a nested MMU must hold mmu_lock for write and thus cannot race
> against a TDP MMU page fault.  I.e. the additional spinlock only _needs_ to
> be taken by the TDP MMU, as opposed to being taken by any MMU for a VM
> that is running with the TDP MMU enabled.  Holding mmu_lock for read also
> prevents the indirect shadow page from being freed.  But as above, keep
> it simple and always take the lock.
>
> Alternative #1, the TDP MMU could simply pass "false" for can_unsync and
> effectively disable unsync behavior for nested TDP.  Write protecting leaf
> shadow pages is unlikely to noticeably impact traditional L1 VMMs, as such
> VMMs typically don't modify TDP entries, but the same may not hold true for
> non-standard use cases and/or VMMs that are migrating physical pages (from
> L1's perspective).
>
> Alternative #2, the unsync logic could be made thread safe.  In theory,
> simply converting all relevant kvm_mmu_page fields to atomics and using
> atomic bitops for the bitmap would suffice.  However, (a) an in-depth audit
> would be required, (b) the code churn would be substantial, and (c) legacy
> shadow paging would incur additional atomic operations in performance
> sensitive paths for no benefit (to legacy shadow paging).
>
> Fixes: a2855afc7ee8 ("KVM: x86/mmu: Allow parallel page faults for the TDP MMU")
> Cc: stable@vger.kernel.org
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  Documentation/virt/kvm/locking.rst |  8 ++++----
>  arch/x86/include/asm/kvm_host.h    |  7 +++++++
>  arch/x86/kvm/mmu/mmu.c             | 28 ++++++++++++++++++++++++++++
>  3 files changed, 39 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
> index 8138201efb09..5d27da356836 100644
> --- a/Documentation/virt/kvm/locking.rst
> +++ b/Documentation/virt/kvm/locking.rst
> @@ -31,10 +31,10 @@ On x86:
>
>  - vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock
>
> -- kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock is
> -  taken inside kvm->arch.mmu_lock, and cannot be taken without already
> -  holding kvm->arch.mmu_lock (typically with ``read_lock``, otherwise
> -  there's no need to take kvm->arch.tdp_mmu_pages_lock at all).
> +- kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock and
> +  kvm->arch.mmu_unsync_pages_lock are taken inside kvm->arch.mmu_lock, and
> +  cannot be taken without already holding kvm->arch.mmu_lock (typically with
> +  ``read_lock`` for the TDP MMU, thus the need for additional spinlocks).
>
>  Everything else is a leaf: no other lock is taken inside the critical
>  sections.
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 20daaf67a5bf..cf32b87b6bd3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1036,6 +1036,13 @@ struct kvm_arch {
>         struct list_head lpage_disallowed_mmu_pages;
>         struct kvm_page_track_notifier_node mmu_sp_tracker;
>         struct kvm_page_track_notifier_head track_notifier_head;
> +       /*
> +        * Protects marking pages unsync during page faults, as TDP MMU page
> +        * faults only take mmu_lock for read.  For simplicity, the unsync
> +        * pages lock is always taken when marking pages unsync regardless of
> +        * whether mmu_lock is held for read or write.
> +        */
> +       spinlock_t mmu_unsync_pages_lock;
>
>         struct list_head assigned_dev_head;
>         struct iommu_domain *iommu_domain;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a272ccbddfa1..cef526dac730 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2596,6 +2596,7 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
>  {
>         struct kvm_mmu_page *sp;
> +       bool locked = false;
>
>         /*
>          * Force write-protection if the page is being tracked.  Note, the page

It might also be worth adding a note about how it's safe to use
for_each_gfn_indirect_valid_sp under the MMU read lock because
mmu_page_hash is only modified with the lock held for write.

> @@ -2618,9 +2619,34 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
>                 if (sp->unsync)
>                         continue;
>
> +               /*
> +                * TDP MMU page faults require an additional spinlock as they
> +                * run with mmu_lock held for read, not write, and the unsync
> +                * logic is not thread safe.  Take the spinklock regardless of
> +                * the MMU type to avoid extra conditionals/parameters, there's
> +                * no meaningful penalty if mmu_lock is held for write.
> +                */
> +               if (!locked) {
> +                       locked = true;
> +                       spin_lock(&vcpu->kvm->arch.mmu_unsync_pages_lock);
> +
> +                       /*
> +                        * Recheck after taking the spinlock, a different vCPU
> +                        * may have since marked the page unsync.  A false
> +                        * positive on the unprotected check above is not
> +                        * possible as clearing sp->unsync _must_ hold mmu_lock
> +                        * for write, i.e. unsync cannot transition from 0->1
> +                        * while this CPU holds mmu_lock for read (or write).
> +                        */
> +                       if (READ_ONCE(sp->unsync))
> +                               continue;
> +               }
> +
>                 WARN_ON(sp->role.level != PG_LEVEL_4K);
>                 kvm_unsync_page(vcpu, sp);
>         }
> +       if (locked)
> +               spin_unlock(&vcpu->kvm->arch.mmu_unsync_pages_lock);
>
>         /*
>          * We need to ensure that the marking of unsync pages is visible
> @@ -5604,6 +5630,8 @@ void kvm_mmu_init_vm(struct kvm *kvm)
>  {
>         struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
>
> +       spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
> +
>         if (!kvm_mmu_init_tdp_mmu(kvm))
>                 /*
>                  * No smp_load/store wrappers needed here as we are in
> --
> 2.33.0.rc1.237.g0d66db33f3-goog
>
