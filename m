Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB223C6158
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 19:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbhGLRFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 13:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbhGLRFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 13:05:32 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7DFC0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 10:02:43 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id y6so19199868ilj.13
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 10:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EmoJmXmJuiNG+cQlokBLAVlhi8UKWPuEwJQKPpEdOnk=;
        b=jRMpw21uoArmkvld2PZfLWSRP6CveH0bJLTWnqJqfyXo+2cIj1D8J3HfyZNF3fHM6T
         McIJNfitt4vomieQA/v+P5j5dK65VlXDg4zgvLhMFnqlTdPX6mI9+hYqGN51qibt5zMp
         GokVilNpmxBMDqMh1vJWmfqQS9JW9sIyQqbiTlJRHOhH7JyrOzKo/PTf5O6AbaD/WSd0
         q1wTC7FjCyawiKAf4nodn6ca9KXtlLgmRHKePdVjmIwCrknnJ0ZlcwOfKvu+0HAE8UDQ
         ZvVPoqI9VeuUCgOR9xjSh8AhjqbO3BHspukKR6iyPMtHY+eUZgoORUx3/CO5P6Pua2cZ
         b0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EmoJmXmJuiNG+cQlokBLAVlhi8UKWPuEwJQKPpEdOnk=;
        b=mUnBqIERpkWkzm+8WEJYIV+zQ1tWCkVMt8q2OErxm3gFaiobVnZL3kisOS+BpFOi6q
         6bBxUzsjFmSLd3qF7wfB4Wq3SzFuDTkv6NlG//Mnv0Mx0SEta0J+AojfLiAImVDMvkV2
         kGwAm6ktqsMMFUbgFnzJ5nRv8q1NHN2MT+gdV8gVfKjerUkd+d00a/8X2PtCDtzpMMHa
         HfuXch9vh+kgK/M9ysY+0+hT/Sp3weeIhAleCpaUScsTdzqnumjUVyJQm58I917fJVxx
         PllDRZ/Ye44MTircO6hWf11s69a2PCHZV90IbxRNJCoNJJXU1MAUCF5fUvafLshx3Lvz
         8/CA==
X-Gm-Message-State: AOAM531MZhWQu5W3x0ifVsfVvYI6Ks4jA0qVt3hhXiRf/NP/PY3kRH/1
        Grjo0y2hkaLnLpntIjGzs0UqJtoGDb6cYL2ONV/HiQ==
X-Google-Smtp-Source: ABdhPJx5H/P8OJImvoUlJGmrR5RCLHx9mRsdCmWaJv0N4oZUwGnHpdbz8a+WpQ5mWcTNhfZcOf589UDy31K3D9TS51M=
X-Received: by 2002:a92:d251:: with SMTP id v17mr7291958ilg.283.1626109362834;
 Mon, 12 Jul 2021 10:02:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210630214802.1902448-1-dmatlack@google.com> <20210630214802.1902448-4-dmatlack@google.com>
In-Reply-To: <20210630214802.1902448-4-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 12 Jul 2021 10:02:31 -0700
Message-ID: <CANgfPd8Vo0qvBiGuQLrt4U6ChCUgXZ9kx3VoEjAZDjkOS5bZWQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] KVM: x86/mmu: Make walk_shadow_page_lockless_{begin,end}
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

On Wed, Jun 30, 2021 at 2:48 PM David Matlack <dmatlack@google.com> wrote:
>
> Acquire the RCU read lock in walk_shadow_page_lockless_begin and release
> it in walk_shadow_page_lockless_end when the TDP MMU is enabled.  This
> should not introduce any functional changes but is used in the following
> commit to make fast_page_fault interoperate with the TDP MMU.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

This as I understand this, we're just lifting the rcu_lock/unlock out
of kvm_tdp_mmu_get_walk, and then putting all the TDP MMU specific
stuff down a level under walk_shadow_page_lockless_begin/end and
get_walk.

Instead of moving kvm_tdp_mmu_get_walk_lockless into get_walk, it
could also be open-coded as:

walk_shadow_page_lockless_begin
 if (is_tdp_mmu(vcpu->arch.mmu))
               leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
 else
               leaf = get_walk(vcpu, addr, sptes, &root);
walk_shadow_page_lockless_end

in get_mmio_spte, since get_walk isn't used anywhere else. Then
walk_shadow_page_lockless_begin/end could also be moved up out of
get_walk instead of having to add a goto to that function.
I don't have a strong preference either way, but the above feels like
a slightly simpler refactor.


> ---
>  arch/x86/kvm/mmu/mmu.c     | 24 ++++++++++++++++++------
>  arch/x86/kvm/mmu/tdp_mmu.c | 20 ++++++++++++++------
>  arch/x86/kvm/mmu/tdp_mmu.h |  6 ++++--
>  3 files changed, 36 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 45274436d3c0..88c71a8a55f1 100644
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
> @@ -3621,6 +3631,12 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
>
>         walk_shadow_page_lockless_begin(vcpu);
>
> +       if (is_tdp_mmu(vcpu->arch.mmu)) {
> +               leaf = kvm_tdp_mmu_get_walk_lockless(vcpu, addr, sptes,
> +                                                    root_level);
> +               goto out;
> +       }
> +
>         for (shadow_walk_init(&iterator, vcpu, addr),
>              *root_level = iterator.level;
>              shadow_walk_okay(&iterator);
> @@ -3634,8 +3650,8 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
>                         break;
>         }
>
> +out:
>         walk_shadow_page_lockless_end(vcpu);
> -
>         return leaf;
>  }
>
> @@ -3647,11 +3663,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>         int root, leaf, level;
>         bool reserved = false;
>
> -       if (is_tdp_mmu(vcpu->arch.mmu))
> -               leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
> -       else
> -               leaf = get_walk(vcpu, addr, sptes, &root);
> -
> +       leaf = get_walk(vcpu, addr, sptes, &root);
>         if (unlikely(leaf < 0)) {
>                 *sptep = 0ull;
>                 return reserved;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index caac4ddb46df..c6fa8d00bf9f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1513,12 +1513,24 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>         return spte_set;
>  }
>
> +void kvm_tdp_mmu_walk_lockless_begin(void)
> +{
> +       rcu_read_lock();
> +}
> +
> +void kvm_tdp_mmu_walk_lockless_end(void)
> +{
> +       rcu_read_unlock();
> +}
> +
>  /*
>   * Return the level of the lowest level SPTE added to sptes.
>   * That SPTE may be non-present.
> + *
> + * Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
>   */
> -int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> -                        int *root_level)
> +int kvm_tdp_mmu_get_walk_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> +                                 int *root_level)
>  {
>         struct tdp_iter iter;
>         struct kvm_mmu *mmu = vcpu->arch.mmu;
> @@ -1527,14 +1539,10 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
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
> index 1cae4485b3bc..e9dde5f9c0ef 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -77,8 +77,10 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>                                    struct kvm_memory_slot *slot, gfn_t gfn,
>                                    int min_level);
>
> -int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> -                        int *root_level);
> +void kvm_tdp_mmu_walk_lockless_begin(void);
> +void kvm_tdp_mmu_walk_lockless_end(void);
> +int kvm_tdp_mmu_get_walk_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> +                                 int *root_level);
>
>  #ifdef CONFIG_X86_64
>  bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> --
> 2.32.0.93.g670b81a890-goog
>
