Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51369459704
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 22:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbhKVV6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 16:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbhKVV6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 16:58:53 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8DAC061714
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 13:55:46 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id y16so25289276ioc.8
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 13:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XSpq6ZH1XcxQkNF3HIQ8h0JgHQppNbExjsyr2yer2lQ=;
        b=B1TQ5q1O5biipLy30+j2jKbzjyqx2EuiNpdaaLz69KllhJNLLvPBgj+qfmUJvGEGtr
         cTxDsc99NKNbZjk22HHhyvYFFq/a2ItTTjloVLqQNFRTHkxhcn5swA24blkujFmQ39l1
         1O+6oSSSbk33pyPhrt2a9OQcc9A8LQwK+H23q/hCGMaGd+hGzEnIo1hXzAHnaqaNMGTb
         8jytBiWRphDJnWVx9hzC6DQjwPLqzEAYjME5Zmi9iuV7/F54Tw0I6NLKq1SKy37rve5C
         0akp3sX7tp2f8jQtIx+r9c5lSuBsV7LM+wPBi31gFl+SrYxy1IxMPZG9KrfqfpzWJA/I
         G62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XSpq6ZH1XcxQkNF3HIQ8h0JgHQppNbExjsyr2yer2lQ=;
        b=WpEnbczqX8UFpBOnFarkNhouhPr+mkAExkuXuK9PrKB36n4vE45hh2M4uvT58ZKwg1
         /uhDkqfhAwEyOL5vbqgK04LazIK0tXgZbX6BL/TLrtEpC8OsBLeMm8cy1/fFLd43/O7N
         w7CB6v2qzv6/auLv5EPf/d3dHDRYXkY2+sMDaejyixv46fkH5REKvWabV5OBt3/87uaV
         MnePAaCIbRhX5N7nA5NxC4SX1Qr8IA5Yypu6KyT64Fw3UD8sGJziSAhxeuW0B85KizhB
         RUDE1oJ98f7My7LyXQyLEOcFbGQyExXWuxUflJkLTh2W14Xb310nGnIWabdi6TQvbjvP
         fOeg==
X-Gm-Message-State: AOAM532/YAHgT/LnpgIStaaU+0FvI19H3RoCE4sHqSFrEFcKPjtEgrb3
        ZNcIyiNSpDMByVB5ovpWMuJhTnLMU09S4pnu/FpM2w==
X-Google-Smtp-Source: ABdhPJyv3XAiVt3H7JjwH30n/KmuT3bcPexjTxPLf3oNbI3GWmlKL8kperzLHDNa2HIKw2qSbZBm3nyYeldfIT3R8qA=
X-Received: by 2002:a05:6638:1923:: with SMTP id p35mr360649jal.16.1637618145708;
 Mon, 22 Nov 2021 13:55:45 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-15-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-15-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 13:55:34 -0800
Message-ID: <CANgfPd-QcU1FYkTQRnWY8w_GANbRGf2ZWzEGEFnV18ZdQUgEKQ@mail.gmail.com>
Subject: Re: [PATCH 14/28] KVM: x86/mmu: Add helpers to read/write TDP MMU
 SPTEs and document RCU
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
> Add helpers to read and write TDP MMU SPTEs instead of open coding
> rcu_dereference() all over the place, and to provide a convenient
> location to document why KVM doesn't exempt holding mmu_lock for write
> from having to hold RCU (and any future changes to the rules).
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

Modulo a couple nits below.

> ---
>  arch/x86/kvm/mmu/tdp_iter.c |  6 +++---
>  arch/x86/kvm/mmu/tdp_iter.h | 16 ++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c  | 14 +++++++-------
>  3 files changed, 26 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index b3ed302c1a35..1f7741c725f6 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -12,7 +12,7 @@ static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
>  {
>         iter->sptep = iter->pt_path[iter->level - 1] +
>                 SHADOW_PT_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
> -       iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
> +       iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
>  }
>
>  static gfn_t round_gfn_for_level(gfn_t gfn, int level)
> @@ -86,7 +86,7 @@ static bool try_step_down(struct tdp_iter *iter)
>          * Reread the SPTE before stepping down to avoid traversing into page
>          * tables that are no longer linked from this entry.
>          */
> -       iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
> +       iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
>
>         child_pt = spte_to_child_pt(iter->old_spte, iter->level);
>         if (!child_pt)
> @@ -120,7 +120,7 @@ static bool try_step_side(struct tdp_iter *iter)
>         iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
>         iter->next_last_level_gfn = iter->gfn;
>         iter->sptep++;
> -       iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
> +       iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
>
>         return true;
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index b1748b988d3a..9c04d8677cb3 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -9,6 +9,22 @@
>
>  typedef u64 __rcu *tdp_ptep_t;
>
> +/*
> + * TDP MMU SPTEs are RCU protected to allow paging structures (non-leaf SPTEs)
> + * to be zapped while holding mmu_lock for read.  Holding RCU isn't required for
> + * correctness if mmu_lock is held for write, but plumbing "struct kvm" down to
> + * the lower* depths of the TDP MMU just to make lockdep happy is a nightmare,
> + * so all* accesses to SPTEs are must be done under RCU protection.

Nit: Are those extra asterisks intentional?  I think this line should also be:
so all accesses to SPTEs must be done under RCU protection.

> + */
> +static inline u64 kvm_tdp_mmu_read_spte(tdp_ptep_t sptep)

Nit: function names could also be tdp_iter_read/write_spte. It's a
little shorter, and in the tdp_iter file, but doesn't matter too much
either way.

> +{
> +       return READ_ONCE(*rcu_dereference(sptep));
> +}
> +static inline void kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 val)
> +{
> +       WRITE_ONCE(*rcu_dereference(sptep), val);
> +}
> +
>  /*
>   * A TDP iterator performs a pre-order walk over a TDP paging structure.
>   */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 3ff7b4cd7d0e..ca6b30a7130d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -572,7 +572,7 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>          * here since the SPTE is going from non-present
>          * to non-present.
>          */
> -       WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
> +       kvm_tdp_mmu_write_spte(iter->sptep, 0);
>
>         return true;
>  }
> @@ -609,7 +609,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>          */
>         WARN_ON(is_removed_spte(iter->old_spte));
>
> -       WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
> +       kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
>
>         __handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
>                               new_spte, iter->level, false);
> @@ -775,7 +775,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>                          * The iter must explicitly re-read the SPTE because
>                          * the atomic cmpxchg failed.
>                          */
> -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> +                       iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
>                         goto retry;
>                 }
>         }
> @@ -1012,7 +1012,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                          * because the new value informs the !present
>                          * path below.
>                          */
> -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> +                       iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
>                 }
>
>                 if (!is_shadow_present_pte(iter.old_spte)) {
> @@ -1225,7 +1225,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>                          * The iter must explicitly re-read the SPTE because
>                          * the atomic cmpxchg failed.
>                          */
> -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> +                       iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
>                         goto retry;
>                 }
>                 spte_set = true;
> @@ -1296,7 +1296,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>                          * The iter must explicitly re-read the SPTE because
>                          * the atomic cmpxchg failed.
>                          */
> -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> +                       iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
>                         goto retry;
>                 }
>                 spte_set = true;
> @@ -1427,7 +1427,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>                          * The iter must explicitly re-read the SPTE because
>                          * the atomic cmpxchg failed.
>                          */
> -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> +                       iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);

Wow this was open coded in a LOT of places. Thanks for cleaning it up.

>                         goto retry;
>                 }
>         }
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
