Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65B94C7F75
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 01:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiCAAoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 19:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiCAAn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 19:43:56 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C478B6141
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 16:43:15 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id f8so7781454edf.10
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 16:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m0MAbTN1Y6pcTXHq3VvIxavRgKJUC69UdeyGhzHOmlU=;
        b=V9ynyBmQCAeq2ATQEZeYFbKM5pp36qFZfK7wlDqGJnvmcQ2zlgHCNB1pbFAwXK2bID
         1W+0UEIJTPQ4nP68mNKAGE/NRcKBTR4Kr1uaukOaaHs8SI8ICQxPO+CCjuFUqeByvCag
         RvUKcGarRWpZ7wMt7ruxSFV77l7mZs9bGgtXHzBZ7U5qvF9bxpenL2pDl0kBM+C90GXg
         Pqh634ex+khgm5kNDCiihBI5WwEuFEdxh5aqsSNUgNnDPgJAT/dLdqvJyhsZxw8boJij
         mPt0pX5EZ2FLjl0D7KUiWMM3oHclrU3RV624u6OnLUyLajb6SQnyo14DYqs2xSLsuGFF
         CU6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m0MAbTN1Y6pcTXHq3VvIxavRgKJUC69UdeyGhzHOmlU=;
        b=rKzUH5/PU9kHk9XqGEV0H28BV/zwEtLsp5g8fs+pioCcvfdiuOVcMN6vbqG9IES9Oj
         QcYbMMi8OIAKpJn4t/k+jYQIWusZWkpIZFy+JzJIw0bm7OWQ/h90HtMOXP90YLCrHg5q
         f1ncThhAKVuQIbOMvhPU71sOyBgtunCVK6U71QKwlkV76zXkyGG8RODRt+dTp2MTRRwl
         YqQXseTEJuVOzKW9ZiKnfQNkDXFFPPm6gXy8i8rboALO8/MTPmfiMmQinYKrP42y128H
         CHEsd2shN+r3Tshf2v2qVn6QqM3Phg5l3y5K17NJFFCceaCDHz3zF7ux2G/r1dwOLKBk
         vEgg==
X-Gm-Message-State: AOAM532JMA1KVjWR96/CMMxgyVJ58XqJzFvHc+y7VdknslWuEQcfJIVT
        rXd30GYaOtWUzU55krQf1vat1tyHmeu13ahYu7rgFg==
X-Google-Smtp-Source: ABdhPJxcPItZ/GtHpnZLpmkWclj4NyLxqdPa5npyeb/mCni2P97zG/EgdGK67M4cT0SBzBuAgcf2MG0k495afoQeJQI=
X-Received: by 2002:a05:6402:518b:b0:412:80a3:fb6e with SMTP id
 q11-20020a056402518b00b0041280a3fb6emr22909696edd.84.1646095394168; Mon, 28
 Feb 2022 16:43:14 -0800 (PST)
MIME-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com> <20220226001546.360188-22-seanjc@google.com>
In-Reply-To: <20220226001546.360188-22-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 28 Feb 2022 16:43:03 -0800
Message-ID: <CANgfPd-pRRoAD3=eWgFOVmaHJnpnbUhwT84p4oJp1NovhxUCow@mail.gmail.com>
Subject: Re: [PATCH v3 21/28] KVM: x86/mmu: Zap roots in two passes to avoid
 inducing RCU stalls
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 4:16 PM Sean Christopherson <seanjc@google.com> wrote:
>
> When zapping a TDP MMU root, perform the zap in two passes to avoid
> zapping an entire top-level SPTE while holding RCU, which can induce RCU
> stalls.  In the first pass, zap SPTEs at PG_LEVEL_1G, and then
> zap top-level entries in the second pass.
>
> With 4-level paging, zapping a PGD that is fully populated with 4kb leaf
> SPTEs take up to ~7 or so seconds (time varies based on kernel config,
> number of (v)CPUs, etc...).  With 5-level paging, that time can balloon
> well into hundreds of seconds.
>
> Before remote TLB flushes were omitted, the problem was even worse as
> waiting for all active vCPUs to respond to the IPI introduced significant
> overhead for VMs with large numbers of vCPUs.
>
> By zapping 1gb SPTEs (both shadow pages and hugepages) in the first pass,
> the amount of work that is done without dropping RCU protection is
> strictly bounded, with the worst case latency for a single operation
> being less than 100ms.
>
> Zapping at 1gb in the first pass is not arbitrary.  First and foremost,
> KVM relies on being able to zap 1gb shadow pages in a single shot when
> when repacing a shadow page with a hugepage.  Zapping a 1gb shadow page
> that is fully populated with 4kb dirty SPTEs also triggers the worst case
> latency due writing back the struct page accessed/dirty bits for each 4kb
> page, i.e. the two-pass approach is guaranteed to work so long as KVM can
> cleany zap a 1gb shadow page.
>
>   rcu: INFO: rcu_sched self-detected stall on CPU
>   rcu:     52-....: (20999 ticks this GP) idle=7be/1/0x4000000000000000
>                                           softirq=15759/15759 fqs=5058
>    (t=21016 jiffies g=66453 q=238577)
>   NMI backtrace for cpu 52
>   Call Trace:
>    ...
>    mark_page_accessed+0x266/0x2f0
>    kvm_set_pfn_accessed+0x31/0x40
>    handle_removed_tdp_mmu_page+0x259/0x2e0
>    __handle_changed_spte+0x223/0x2c0
>    handle_removed_tdp_mmu_page+0x1c1/0x2e0
>    __handle_changed_spte+0x223/0x2c0
>    handle_removed_tdp_mmu_page+0x1c1/0x2e0
>    __handle_changed_spte+0x223/0x2c0
>    zap_gfn_range+0x141/0x3b0
>    kvm_tdp_mmu_zap_invalidated_roots+0xc8/0x130
>    kvm_mmu_zap_all_fast+0x121/0x190
>    kvm_mmu_invalidate_zap_pages_in_memslot+0xe/0x10
>    kvm_page_track_flush_slot+0x5c/0x80
>    kvm_arch_flush_shadow_memslot+0xe/0x10
>    kvm_set_memslot+0x172/0x4e0
>    __kvm_set_memory_region+0x337/0x590
>    kvm_vm_ioctl+0x49c/0xf80
>
> Reported-by: David Matlack <dmatlack@google.com>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

Nice. This is very well explained in the comments and commit
description. Thanks for fixing this.

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 51 +++++++++++++++++++++++++-------------
>  1 file changed, 34 insertions(+), 17 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index b838cfa984ad..ec28a88c6376 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -802,14 +802,36 @@ static inline gfn_t tdp_mmu_max_gfn_host(void)
>         return 1ULL << (shadow_phys_bits - PAGE_SHIFT);
>  }
>
> -static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
> -                            bool shared)
> +static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +                              bool shared, int zap_level)
>  {
>         struct tdp_iter iter;
>
>         gfn_t end = tdp_mmu_max_gfn_host();
>         gfn_t start = 0;
>
> +       for_each_tdp_pte_min_level(iter, root, zap_level, start, end) {
> +retry:
> +               if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
> +                       continue;
> +
> +               if (!is_shadow_present_pte(iter.old_spte))
> +                       continue;
> +
> +               if (iter.level > zap_level)
> +                       continue;
> +
> +               if (!shared)
> +                       tdp_mmu_set_spte(kvm, &iter, 0);
> +               else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
> +                       goto retry;
> +       }
> +}
> +
> +static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +                            bool shared)
> +{
> +
>         /*
>          * The root must have an elevated refcount so that it's reachable via
>          * mmu_notifier callbacks, which allows this path to yield and drop
> @@ -827,22 +849,17 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>         rcu_read_lock();
>
>         /*
> -        * No need to try to step down in the iterator when zapping an entire
> -        * root, zapping an upper-level SPTE will recurse on its children.
> +        * To avoid RCU stalls due to recursively removing huge swaths of SPs,
> +        * split the zap into two passes.  On the first pass, zap at the 1gb
> +        * level, and then zap top-level SPs on the second pass.  "1gb" is not
> +        * arbitrary, as KVM must be able to zap a 1gb shadow page without
> +        * inducing a stall to allow in-place replacement with a 1gb hugepage.
> +        *
> +        * Because zapping a SP recurses on its children, stepping down to
> +        * PG_LEVEL_4K in the iterator itself is unnecessary.
>          */
> -       for_each_tdp_pte_min_level(iter, root, root->role.level, start, end) {
> -retry:
> -               if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
> -                       continue;
> -
> -               if (!is_shadow_present_pte(iter.old_spte))
> -                       continue;
> -
> -               if (!shared)
> -                       tdp_mmu_set_spte(kvm, &iter, 0);
> -               else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
> -                       goto retry;
> -       }
> +       __tdp_mmu_zap_root(kvm, root, shared, PG_LEVEL_1G);
> +       __tdp_mmu_zap_root(kvm, root, shared, root->role.level);
>
>         rcu_read_unlock();
>  }
> --
> 2.35.1.574.g5d30c73bfb-goog
>
