Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0DF3C7A45
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 01:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbhGMXqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 19:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhGMXqn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 19:46:43 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A453C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 16:43:53 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id y6so23868485ilj.13
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 16:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k2fdRft1E4AaIJA1VsNrMx4Wco2zOstcBWm9HKe7eyc=;
        b=fMF4H8+7JhawGmdg8eC87JqD8NIThYu5zHGrGO4iYsvM8C5QqLe3/roeCmM00bkNRM
         CCkTTLUL8RHIqSeQjdUyq+eryPMxeRU87ytu8bcNU6vYRF+X9QNurf/rW5oABEHJvAbN
         nc5gAoSsJfJIMkbL1jgkDZWA4G7MrLaoM4Wy+v5/WSfpuuMcm2wahOdVLxHrN3KZC6SH
         wT2jMOuNvnRKE5WYaE0at7Nf3oV1pOVZQqjp8WL4D5HdQXwiGNyMltVF0DpeHQ1gHWS0
         eh8kQNf7PLSb4Ah7uxHlMl2Q9YT5W8x8o5dFJlm3eOjpD8uTzL0ff7OkJQUCENoJmTl8
         gH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k2fdRft1E4AaIJA1VsNrMx4Wco2zOstcBWm9HKe7eyc=;
        b=OqhNUtH+hCCDDeZ17ZOAmt5PF0p4ru6oNvGZI6woXg7+P0ypQE5ca8lz5/ALbzB0jp
         1GsFhMQH/vmBRKqWUS8W+e9zEf8aQiRgawpWbR1cEAGCwabEtnshbWZO0US/ID6ZWCKI
         /CZo3INidc8fWKm6rGmBbbjJoRZk+eodrpq+6NQt2XWQw48qg7LqjLalJYMl9D/6/Zlq
         GL5+lLCot/b5X3fBK8CaHBsiFwdvagz7Qy4GHI0t+aK548XN3yrmXFNtmuMNJQ2Ha7xv
         Fx3qwkFuVTpuUZkS41GdwBY2fdQbfuNmQriuhAiX/H32caeJSvS1nUmuO+ERjmJpYnK0
         IEiw==
X-Gm-Message-State: AOAM533Q42l5ZzffAKJ8XThC37SR1WdRVO+LM4K5Zz+kPneXqhKbZgSz
        vqxqJUApR3BzA/bENpS1y++4Ee9ZfggdVRKk2d8h0Q==
X-Google-Smtp-Source: ABdhPJzso1CAlz2nzrANZhoc5E9Xs/vc265z6i1/JaCTbe0giJ6ds6vsAmfYcQiLkPDEg4n7UaiM3WaRs6M1a7LczpY=
X-Received: by 2002:a05:6e02:19cc:: with SMTP id r12mr4815858ill.285.1626219832562;
 Tue, 13 Jul 2021 16:43:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210713220957.3493520-1-dmatlack@google.com> <20210713220957.3493520-4-dmatlack@google.com>
In-Reply-To: <20210713220957.3493520-4-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 13 Jul 2021 16:43:41 -0700
Message-ID: <CANgfPd8ffb3GYy3_HvDf+eKbrCnDs2AH8DT=AfVSyYbCFmoi-g@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] KVM: x86/mmu: Make walk_shadow_page_lockless_{begin,end}
 interoperate with the TDP MMU
To:     David Matlack <dmatlack@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021 at 3:10 PM David Matlack <dmatlack@google.com> wrote:
>
> Acquire the RCU read lock in walk_shadow_page_lockless_begin and release
> it in walk_shadow_page_lockless_end when the TDP MMU is enabled.  This
> should not introduce any functional changes but is used in the following
> commit to make fast_page_fault interoperate with the TDP MMU.
>

Reviewed-by: Ben Gardon <bgardon@google.com>

> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 20 ++++++++++++++++----
>  arch/x86/kvm/mmu/tdp_mmu.c |  6 ++----
>  arch/x86/kvm/mmu/tdp_mmu.h | 10 ++++++++++
>  3 files changed, 28 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 45274436d3c0..e3d99853b962 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -686,6 +686,11 @@ static bool mmu_spte_age(u64 *sptep)
>
>  static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
>  {
> +       if (is_tdp_mmu(vcpu->arch.mmu)) {
> +               kvm_tdp_mmu_walk_lockless_begin();
> +               return;
> +       }
> +
>         /*
>          * Prevent page table teardown by making any free-er wait during
>          * kvm_flush_remote_tlbs() IPI to all active vcpus.
> @@ -701,6 +706,11 @@ static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
>
>  static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>  {
> +       if (is_tdp_mmu(vcpu->arch.mmu)) {
> +               kvm_tdp_mmu_walk_lockless_end();
> +               return;
> +       }
> +
>         /*
>          * Make sure the write to vcpu->mode is not reordered in front of
>          * reads to sptes.  If it does, kvm_mmu_commit_zap_page() can see us
> @@ -3612,6 +3622,8 @@ static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>  /*
>   * Return the level of the lowest level SPTE added to sptes.
>   * That SPTE may be non-present.
> + *
> + * Must be called between walk_shadow_page_lockless_{begin,end}.
>   */
>  static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level)
>  {
> @@ -3619,8 +3631,6 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
>         int leaf = -1;
>         u64 spte;
>
> -       walk_shadow_page_lockless_begin(vcpu);
> -
>         for (shadow_walk_init(&iterator, vcpu, addr),
>              *root_level = iterator.level;
>              shadow_walk_okay(&iterator);
> @@ -3634,8 +3644,6 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
>                         break;
>         }
>
> -       walk_shadow_page_lockless_end(vcpu);
> -
>         return leaf;
>  }
>
> @@ -3647,11 +3655,15 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>         int root, leaf, level;
>         bool reserved = false;
>
> +       walk_shadow_page_lockless_begin(vcpu);
> +
>         if (is_tdp_mmu(vcpu->arch.mmu))
>                 leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
>         else
>                 leaf = get_walk(vcpu, addr, sptes, &root);
>
> +       walk_shadow_page_lockless_end(vcpu);
> +
>         if (unlikely(leaf < 0)) {
>                 *sptep = 0ull;
>                 return reserved;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index caac4ddb46df..98ffd1ba556e 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1516,6 +1516,8 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>  /*
>   * Return the level of the lowest level SPTE added to sptes.
>   * That SPTE may be non-present.
> + *
> + * Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
>   */
>  int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>                          int *root_level)
> @@ -1527,14 +1529,10 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>
>         *root_level = vcpu->arch.mmu->shadow_root_level;
>
> -       rcu_read_lock();
> -
>         tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
>                 leaf = iter.level;
>                 sptes[leaf] = iter.old_spte;
>         }
>
> -       rcu_read_unlock();
> -
>         return leaf;
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 1cae4485b3bc..93e1bf5089c4 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -77,6 +77,16 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>                                    struct kvm_memory_slot *slot, gfn_t gfn,
>                                    int min_level);
>
> +static inline void kvm_tdp_mmu_walk_lockless_begin(void)
> +{
> +       rcu_read_lock();
> +}
> +
> +static inline void kvm_tdp_mmu_walk_lockless_end(void)
> +{
> +       rcu_read_unlock();
> +}
> +
>  int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>                          int *root_level);
>
> --
> 2.32.0.93.g670b81a890-goog
>
