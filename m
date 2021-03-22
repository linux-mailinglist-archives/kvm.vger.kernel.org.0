Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876E93451C2
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 22:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhCVV1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 17:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbhCVV1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 17:27:39 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8ACC061574
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 14:27:38 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id k25so3408019iob.6
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 14:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mWk+o8yYno4oVPKt5FUKRgmtDcCg2vWgufyVv5FBitg=;
        b=XRbP1uRQOWdGrB5dAQAeGEmFIhRaUHlPu/4JKaV0VZ3eA6OVJucYU5r1WM3Nf+fvRV
         /dzPCimcl4Sbp/85GuQvk3ZCbmp2wK2iaUjPFUnFccrdrCZWlj5mjNiLYc7CS/x/0TNx
         cbhjETbsmG5aZZBaClMRf/8ME5otTZWD1IG3ad+lGkI3385I3Uy7x2zEwxrlpXnnIaer
         M6WlK2Ec2A3mkK2BVEP1I/UpLr+ddrt8pWutT372pFO95hIhCPHp01FdFS1g+nXnhJp6
         Qb00L92nkOKl2+YefGWJq3kIYDFHGIjgX8WLsB4EJYvivtE9aYjZS6SA0lgRXMa7ZeZ3
         07Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mWk+o8yYno4oVPKt5FUKRgmtDcCg2vWgufyVv5FBitg=;
        b=SIYK1R6j8X8yz+aQTxvoDvlaMjEu06pakwkamjaSNUwg4By7PvObYu0Zf94M4pyhZO
         dn2YVcqpq4TAz4C98GAS06+ClRKH//6Mpw43HBLS/xALy33u/z5MAmkTajhVpyAT9Iyh
         zKnJ3Hu4a9o/dZ/ZlIkwbOYBbtR7RHt77egqZEqHjFJq0sZ8VX2IP8Tl1rw6KFBGVeqM
         C+Qwlh0z6ilzdhg+t7Wp63rT6uAVrBchnD/j94iLN5yxiXmWG3TNDDvgwc0TUzJp8Rr0
         dhGMhxJ0HtsGEBwmi/s4UGiEYFe0wwrtCepNLc/5qf7e0UuL4NyF9y3zMjtYMUIwADHd
         SOHw==
X-Gm-Message-State: AOAM530xwD7R14bseftDDw6BcHOvcMOnPzKLS64jXhA7qWFi+Jkgnn4S
        ZxEMnXrO3VrprK26uAoVxJKbXIdZfbhml+iwpI6iuA==
X-Google-Smtp-Source: ABdhPJww3mD1TXBJYl00cIfS9T6MiDk6YqDbxQKLNa1BoI+zjPaBX4htazdomOuP9Nr+FxwSsOX5aLF2PfuPnWFhLGI=
X-Received: by 2002:a02:cbb2:: with SMTP id v18mr1345431jap.4.1616448458015;
 Mon, 22 Mar 2021 14:27:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210319232006.3468382-1-seanjc@google.com> <20210319232006.3468382-2-seanjc@google.com>
In-Reply-To: <20210319232006.3468382-2-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Mar 2021 14:27:27 -0700
Message-ID: <CANgfPd9Rzk3GwggqGkw2yAH355AnvLAwSihoW2JZ8r3qjSzUWA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Ensure TLBs are flushed when yielding
 during GFN range zap
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

On Fri, Mar 19, 2021 at 4:20 PM Sean Christopherson <seanjc@google.com> wrote:
>
> When flushing a range of GFNs across multiple roots, ensure any pending
> flush from a previous root is honored before yielding while walking the
> tables of the current root.
>
> Note, kvm_tdp_mmu_zap_gfn_range() now intentionally overwrites it local
> "flush" with the result to avoid redundant flushes.  zap_gfn_range()
> preserves and return the incoming "flush", unless of course the flush was
> performed prior to yielding and no new flush was triggered.
>
> Fixes: 1af4a96025b3 ("KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed")
> Cc: stable@vger.kernel.org
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-By: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index f0c99fa04ef2..6cf08c3c537f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -86,7 +86,7 @@ static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>         list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
>
>  static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> -                         gfn_t start, gfn_t end, bool can_yield);
> +                         gfn_t start, gfn_t end, bool can_yield, bool flush);

This function is going to acquire so many arguments. Don't need to do
anything about it here, but this is going to need some kind of cleanup
at some point.
I'll have to add another "shared" type arg for running this function
under the read lock in a series I'm prepping.


>
>  void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
>  {
> @@ -99,7 +99,7 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
>
>         list_del(&root->link);
>
> -       zap_gfn_range(kvm, root, 0, max_gfn, false);
> +       zap_gfn_range(kvm, root, 0, max_gfn, false, false);
>
>         free_page((unsigned long)root->spt);
>         kmem_cache_free(mmu_page_header_cache, root);
> @@ -664,20 +664,21 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
>   * scheduler needs the CPU or there is contention on the MMU lock. If this
>   * function cannot yield, it will not release the MMU lock or reschedule and
>   * the caller must ensure it does not supply too large a GFN range, or the
> - * operation can cause a soft lockup.
> + * operation can cause a soft lockup.  Note, in some use cases a flush may be
> + * required by prior actions.  Ensure the pending flush is performed prior to
> + * yielding.
>   */
>  static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> -                         gfn_t start, gfn_t end, bool can_yield)
> +                         gfn_t start, gfn_t end, bool can_yield, bool flush)
>  {
>         struct tdp_iter iter;
> -       bool flush_needed = false;
>
>         rcu_read_lock();
>
>         tdp_root_for_each_pte(iter, root, start, end) {
>                 if (can_yield &&
> -                   tdp_mmu_iter_cond_resched(kvm, &iter, flush_needed)) {
> -                       flush_needed = false;
> +                   tdp_mmu_iter_cond_resched(kvm, &iter, flush)) {
> +                       flush = false;
>                         continue;
>                 }
>
> @@ -695,11 +696,11 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>                         continue;
>
>                 tdp_mmu_set_spte(kvm, &iter, 0);
> -               flush_needed = true;
> +               flush = true;
>         }
>
>         rcu_read_unlock();
> -       return flush_needed;
> +       return flush;
>  }
>
>  /*
> @@ -714,7 +715,7 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
>         bool flush = false;
>
>         for_each_tdp_mmu_root_yield_safe(kvm, root)
> -               flush |= zap_gfn_range(kvm, root, start, end, true);
> +               flush = zap_gfn_range(kvm, root, start, end, true, flush);
>
>         return flush;
>  }
> @@ -931,7 +932,7 @@ static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
>                                      struct kvm_mmu_page *root, gfn_t start,
>                                      gfn_t end, unsigned long unused)
>  {
> -       return zap_gfn_range(kvm, root, start, end, false);
> +       return zap_gfn_range(kvm, root, start, end, false, false);
>  }
>
>  int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
> --
> 2.31.0.rc2.261.g7f71774620-goog
>
