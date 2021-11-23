Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3AB145AD1B
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 21:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbhKWUPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 15:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbhKWUPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 15:15:36 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD8DC061714
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 12:12:27 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id x6so149618iol.13
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 12:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y/zr9KXdL5IDn5jRo1Y7NkNHyOLRr6gdxgMls6qts44=;
        b=l4DE0aM7QYVKgOXcgSYTJVMJwyB2akVm2kVe6Pun2KNJJnzE/9Uti2DAp7SAYV/Vmg
         CMe0Q2jR0d5Lf5cmBxgMn6jYc5AuN8wfawVLniR3gc7cy7WChzlVu1y+fuBJvWakI1tK
         tv7SX5tUvc55gL7lMr/P2j0ei4tnk+h0WzfE7tKhFTCHX6fq0rFQgOnnDiYfJyGiUAgR
         A89/QZIdUtNk71l1P2WTrI11qTRAAZe/X07is8I2mZVUCISZ/2BeLpYK6XznK07SV2gh
         TBpGySow0FO+EDgtBX2Ir1u3BQG1eD/a625p5CjBR7mnN2xPTpKA/pboS/a+zCbsYMl8
         VPLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y/zr9KXdL5IDn5jRo1Y7NkNHyOLRr6gdxgMls6qts44=;
        b=P4YOfYuyshrYkxHlK+YYg4a3ulmR185eChMAvyfFqegsLmi5eZPZDSY9Yg2HBymhlt
         n7RZ1UPOeCKsuU2t9dRt04N7Ko/g9wTn6wPXwJuIgmOxTvHBcNDLN9Krm3PEGUnxp2lT
         Sc5IlJuSesUUjXHLbDLJSCC2AjvUxMCzIPEw+JTjyeeMrHH06srKPSA4bDhIGh7dQg8y
         m6bItPCIyNOYvi09Fd+Td/1TckvlYcPg/iQYu5xg3dUuFYyZl7ewBIplTdjxv49s2E4O
         J8IrGYxEJ8838PD8eN8w8VnELrKe1LIHT20NTG4e9gfBHsDAZ8Z5tlkZs4oV5AJP7Hlh
         nhHA==
X-Gm-Message-State: AOAM530z+M1pc4LH9h8K2bS8h53MqxiLAZ1l7PqSsX42J+8MXGPQOSuf
        +lMcpywjDLZLBdlXGGrm/fHpTb7ZKH7VazjydquNgiuycIw=
X-Google-Smtp-Source: ABdhPJxMksFC76skny4IutTmROUuh0bgiA13aqaydsXsEKQtkKAHQJrLMs8xdTMkRw1MXJ1o/v5rQDWEzvyU7g1e0PY=
X-Received: by 2002:a5d:9d92:: with SMTP id ay18mr9050917iob.130.1637698346795;
 Tue, 23 Nov 2021 12:12:26 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-29-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-29-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 23 Nov 2021 12:12:15 -0800
Message-ID: <CANgfPd-U3B+WG6LbVu26ncm=u=TVj60-6mNPEnFkYkSBmSm1Gw@mail.gmail.com>
Subject: Re: [PATCH 28/28] KVM: x86/mmu: Defer TLB flush to caller when
 freeing TDP MMU shadow pages
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Defer TLB flushes to the caller when freeing TDP MMU shadow pages instead
> of immediately flushing.  Because the shadow pages are freed in an RCU
> callback, so long as at least one CPU holds RCU, all CPUs are protected.
> For vCPUs running in the guest, i.e. consuming TLB entries, KVM only
> needs to ensure the caller services the pending TLB flush before dropping
> its RCU protections.  I.e. use the caller's RCU as a proxy for all vCPUs
> running in the guest.
>
> Deferring the flushes allows batching flushes, e.g. when installing a
> 1gb hugepage and zapping a pile of SPs, and when zapping an entire root,
> allows skipping the flush entirely (becaues flushes are not needed in
> that case).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c      | 12 ++++++++++++
>  arch/x86/kvm/mmu/tdp_iter.h |  7 +++----
>  arch/x86/kvm/mmu/tdp_mmu.c  | 23 +++++++++++------------
>  3 files changed, 26 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ef689b8bab12..7aab9737dffa 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6237,6 +6237,12 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>         rcu_idx = srcu_read_lock(&kvm->srcu);
>         write_lock(&kvm->mmu_lock);
>
> +       /*
> +        * Zapping TDP MMU shadow pages, including the remote TLB flush, must
> +        * be done under RCU protection, the pages are freed via RCU callback.
> +        */
> +       rcu_read_lock();
> +
>         ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
>         to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
>         for ( ; to_zap; --to_zap) {
> @@ -6261,12 +6267,18 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>
>                 if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
>                         kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
> +                       rcu_read_unlock();
> +
>                         cond_resched_rwlock_write(&kvm->mmu_lock);
>                         flush = false;
> +
> +                       rcu_read_lock();
>                 }
>         }
>         kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
>
> +       rcu_read_unlock();
> +
>         write_unlock(&kvm->mmu_lock);
>         srcu_read_unlock(&kvm->srcu, rcu_idx);
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index 0693f1fdb81e..0299703fc844 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -9,10 +9,9 @@
>
>  /*
>   * TDP MMU SPTEs are RCU protected to allow paging structures (non-leaf SPTEs)
> - * to be zapped while holding mmu_lock for read.  Holding RCU isn't required for
> - * correctness if mmu_lock is held for write, but plumbing "struct kvm" down to
> - * the lower* depths of the TDP MMU just to make lockdep happy is a nightmare,
> - * so all* accesses to SPTEs are must be done under RCU protection.
> + * to be zapped while holding mmu_lock for read, and to allow TLB flushes to be
> + * batched without having to collect the list of zapped SPs.  Flows that can
> + * remove SPs must service pending TLB flushes prior to dropping RCU protection.
>   */
>  static inline u64 kvm_tdp_mmu_read_spte(tdp_ptep_t sptep)
>  {
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 55c16680b927..62cb357b1dff 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -433,9 +433,6 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
>                                     shared);
>         }
>
> -       kvm_flush_remote_tlbs_with_address(kvm, base_gfn,
> -                                          KVM_PAGES_PER_HPAGE(level + 1));
> -
>         call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
>
> @@ -815,21 +812,14 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>
>  bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -       u64 old_spte;
> +       u64 old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
>
> -       rcu_read_lock();
> -
> -       old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
> -       if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte))) {
> -               rcu_read_unlock();
> +       if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
>                 return false;
> -       }
>
>         __tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
>                            sp->gfn, sp->role.level + 1, true, true);
>
> -       rcu_read_unlock();
> -
>         return true;
>  }
>
> @@ -871,6 +861,11 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>         }
>
>         rcu_read_unlock();
> +
> +       /*
> +        * Because this flows zaps _only_ leaf SPTEs, the caller doesn't need
> +        * to provide RCU protection as no 'struct kvm_mmu_page' will be freed.
> +        */
>         return flush;
>  }
>
> @@ -1011,6 +1006,10 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>                 ret = RET_PF_SPURIOUS;
>         else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
>                 return RET_PF_RETRY;
> +       else if (is_shadow_present_pte(iter->old_spte) &&
> +                !is_last_spte(iter->old_spte, iter->level))
> +               kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
> +                                                  KVM_PAGES_PER_HPAGE(iter->level + 1));
>
>         /*
>          * If the page fault was caused by a write but the page is write
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
