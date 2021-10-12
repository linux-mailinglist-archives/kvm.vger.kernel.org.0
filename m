Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FB842A9F9
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 18:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhJLQxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 12:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbhJLQw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 12:52:57 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3367AC061746
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 09:50:55 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id r19so87367829lfe.10
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 09:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HXB7pq6VEUj8hxAFp1wWH0HcYGQ43G7lLPeeJ7mMODg=;
        b=qMyN2kuRAR8/b61nBYxlai/y5zhTPNYGYI5pokwNJupaFCQHgeTZug5eGhtgzpvxdi
         hCEQSkXye10IsuHbo6/vc/0sfEtJFkAsHrxa5na2TzV1rrGmVvuiOkqTulzBA1aVD1Qw
         nqfVej6T3hSdhTVenZqFlGwJLSc+N1OAfO6P2oBAYUJ5C2OTWwLvaZ3pGKaEgdZ8DsMk
         P6tHTzZMOm7n7/1hLByRhwqP6Bn6j6m9DC/WhPEF+PATF0J3l1FvU+QwU1XaqJHqSrDW
         Hfu6cqaCFWCM08slvQEEigCwglxJqlkpigGtEJXs1m1hQe4kfkKxDyLRf6C2ZabDIb9c
         ZsoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HXB7pq6VEUj8hxAFp1wWH0HcYGQ43G7lLPeeJ7mMODg=;
        b=5Q+EOpE0BWVT/YZpKKAXswZrSehPAvG20iutnAIJOnO8H040EkpjTRXgKEv9IO+VPy
         k5N9CcYkjJc1wKzQ5yd1HTMRY6OVyVU8wHPeUk7t3sMHY+KaMDpZbD6jjdLxuMANb9UB
         NMrsX4HO8eR0wUxELg/9gnxZuqaQwWf9sXyPl1++yjZP+mbcA7YZCyAkJJS6sZp2bsA/
         Jr5PeBpWvk6Nqgc9oZq7lZtY8QoZstz7LLkDQAj4uWNMomLsY5TlZEH7Oi0ZQPGCQjdd
         gypX/WEt/GzIisXqse2XQylhMLEazMqA21hQl53Uj2OSDqvHwtwI4MShiAE9SBrIZRuL
         sevA==
X-Gm-Message-State: AOAM533zU3XaqBRXigBiacTG9+2a4vmvxs9LOClrUgU+TN4Rl8+3mSLW
        BKeGBmpbVN4J937tUYnBf70tM6djIlmDFOGBq14S1w==
X-Google-Smtp-Source: ABdhPJwWQLl4ltH8rAZrzzqG8B8i7VNzN/0vHCSMf8t5s88yo7nWOqGyVHQXfqtovpVFQYCo5iMwh/2kr8ApnffK130=
X-Received: by 2002:a2e:461a:: with SMTP id t26mr31245857lja.198.1634057452993;
 Tue, 12 Oct 2021 09:50:52 -0700 (PDT)
MIME-Version: 1.0
References: <20211012091430.1754492-1-senozhatsky@chromium.org>
In-Reply-To: <20211012091430.1754492-1-senozhatsky@chromium.org>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 12 Oct 2021 09:50:26 -0700
Message-ID: <CALzav=dYeCs=ieC2p074J4KVyFpRsxRVa5ZQuST--2GOVJm7Kw@mail.gmail.com>
Subject: Re: [PATCH] KVM: MMU: make PTE_PREFETCH_NUM tunable
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

On Tue, Oct 12, 2021 at 2:16 AM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Turn PTE_PREFETCH_NUM into a module parameter, so that it
> can be tuned per-VM.

Module parameters do not allow tuning per VM, they effect every VM on
the machine.

If you want per-VM tuning you could introduce a VM ioctl.

>
> - /sys/module/kvm/parameters/pte_prefetch_num 8
>
>              VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time         Avg time
>
>        EPT_VIOLATION     760998    54.85%     7.23%      0.92us  31765.89us      7.78us ( +-   1.46% )
>            MSR_WRITE     170599    12.30%     0.53%      0.60us   3334.13us      2.52us ( +-   0.86% )
>   EXTERNAL_INTERRUPT     159510    11.50%     1.65%      0.49us  43705.81us      8.45us ( +-   7.54% )
> [..]
>
> Total Samples:1387305, Total events handled time:81900258.99us.
>
> - /sys/module/kvm/parameters/pte_prefetch_num 16
>
>              VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time         Avg time
>
>        EPT_VIOLATION     658064    52.58%     7.04%      0.91us  17022.84us      8.34us ( +-   1.52% )
>            MSR_WRITE     163776    13.09%     0.54%      0.56us   5192.10us      2.57us ( +-   1.25% )
>   EXTERNAL_INTERRUPT     144588    11.55%     1.62%      0.48us  97410.16us      8.75us ( +-  11.44% )
> [..]
>
> Total Samples:1251546, Total events handled time:77956187.56us.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  arch/x86/kvm/mmu/mmu.c | 31 ++++++++++++++++++++++---------

Please also update the shadow paging prefetching code in
arch/x86/kvm/mmu/paging_tmpl.h, unless there is a good reason to
diverge.

>  1 file changed, 22 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 24a9f4c3f5e7..0ab4490674ec 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -115,6 +115,8 @@ module_param(dbg, bool, 0644);
>  #endif
>
>  #define PTE_PREFETCH_NUM               8
> +static uint __read_mostly pte_prefetch_num = PTE_PREFETCH_NUM;
> +module_param(pte_prefetch_num, uint, 0644);
>
>  #define PT32_LEVEL_BITS 10
>
> @@ -732,7 +734,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>
>         /* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
>         r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> -                                      1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
> +                                      1 + PT64_ROOT_MAX_LEVEL + pte_prefetch_num);

There is a sampling problem. What happens if the user changes
pte_prefetch_num while a fault is being handled?

>         if (r)
>                 return r;
>         r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> @@ -2753,20 +2755,29 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
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
> +       pages = kmalloc_array(pte_prefetch_num, sizeof(struct page *),
> +                             GFP_KERNEL);

This code runs with the MMU lock held. From
https://www.kernel.org/doc/html/latest/core-api/memory-allocation.html:

    Note, that using GFP_KERNEL implies GFP_RECLAIM, which means
    that direct reclaim may be triggered under memory pressure; the calling
    context must be allowed to sleep.

In general we avoid doing any dynamic memory allocation while the MMU
lock is held. That's why the memory caches exist. You can avoid
allocating under a lock by allocating the prefetch array when the vCPU
is first initialized. This would also solve the module parameter
sampling problem because you can read it once and store it in struct
kvm_vcpu.

> +       if (!pages)
> +               return -1;
> +
>         gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
>         slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, access & ACC_WRITE_MASK);
> -       if (!slot)
> -               return -1;
> +       if (!slot) {
> +               ret = -1;
> +               goto out;
> +       }
>
>         ret = gfn_to_page_many_atomic(slot, gfn, pages, end - start);
> -       if (ret <= 0)
> -               return -1;
> +       if (ret <= 0) {
> +               ret = -1;
> +               goto out;
> +       }
>
>         for (i = 0; i < ret; i++, gfn++, start++) {
>                 mmu_set_spte(vcpu, slot, start, access, gfn,
> @@ -2774,7 +2785,9 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
>                 put_page(pages[i]);
>         }
>
> -       return 0;
> +out:
> +       kfree(pages);
> +       return ret;
>  }
>
>  static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
> @@ -2785,10 +2798,10 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
>
>         WARN_ON(!sp->role.direct);
>
> -       i = (sptep - sp->spt) & ~(PTE_PREFETCH_NUM - 1);
> +       i = (sptep - sp->spt) & ~(pte_prefetch_num - 1);

This code assumes pte_prefetch_num is a power of 2, which is now no
longer guaranteed to be true.

>         spte = sp->spt + i;
>
> -       for (i = 0; i < PTE_PREFETCH_NUM; i++, spte++) {
> +       for (i = 0; i < pte_prefetch_num; i++, spte++) {
>                 if (is_shadow_present_pte(*spte) || spte == sptep) {
>                         if (!start)
>                                 continue;
> --
> 2.33.0.882.g93a45727a2-goog
>
