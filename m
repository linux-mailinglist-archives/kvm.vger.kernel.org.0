Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F033451C1
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 22:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhCVV1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 17:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhCVV12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 17:27:28 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C42FC061756
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 14:27:28 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id t14so6402822ilu.3
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 14:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SYOrRtrJbYA6OkKkKHgOL4LSFBp7NjwpYOFcZ2Xg8oQ=;
        b=biL3PS2mco1/8v/xGfzTgWHL3bLRKmF7vVYKp5ZB/GvIwmpppCFqdFFX+Qy2+8Mxq9
         tce4ujmHdkJWgx/fa8in5R5vM6cR5dx9uguv6hN1HX/wb/UWj/bYiTbXP50gaVX4aWfw
         YuFL8qCsI2LlyJHAMtvxHUC2OiXv1PZeAYjOLVODLEUJpgsVNc1fzceTa4r8F8kd8nVn
         uin50Sn//XTWHq+ZgHWuwIZ8f+ZWP0TUHvfK4BdE14jlQtX+m17j+Gfdlao/L0FtQDyI
         CEl3RBcXcloGRxLDBOn5bhj1VaA5kD2dJJIjPmtBunCWQykJ/vpacgdAeZHqvxvcnEXn
         nu2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SYOrRtrJbYA6OkKkKHgOL4LSFBp7NjwpYOFcZ2Xg8oQ=;
        b=QLZpzu1bhiFU7oU9BP7kymZJ27BwUSq2rXe2rnWUl4nGlbLEmgEFYF3ZpcpMmHaObM
         ZqZXeBgOW8zQfOWfF5fn1oCVdYhlzVJoCsWGbKi9OUHo1cQBHqz5ACzOG4Z/GYmGWek2
         G9wuHjBaQhyd4GVG14fAEzD9U9MKVklj4WiSSXuk53AX3JLHC88mHq50IA/R8yXtAOgw
         uOjl264ealeEB+N1a3Hb1w3sLrooOvKAD6C3x+vLM5eMfnMfj1X4FIMjUCXIcPl9gU0V
         Ga/21lYpNnaQg9UDzbL1l5dlEVeQ6GwqjjTBby5J5YYgNjXtiW0XMO3GvmmtXW+loOvf
         jd3w==
X-Gm-Message-State: AOAM5300TEKLlOuh+SXbkS13MRs6mV52huSPb7pSg73pq6O5znTTpZRC
        YjwmLnKlvep4SG0JHlUezg6V1yRTinn32OLi31U6Kg==
X-Google-Smtp-Source: ABdhPJzZkbwtlk9oaydGpj46LBjveF5uHSYOahSD6LgzXTLxdnff96/rkKEKWwbpmABNOz5bIT3EXwJ76WVZprd8XAo=
X-Received: by 2002:a05:6e02:1094:: with SMTP id r20mr1802712ilj.154.1616448446765;
 Mon, 22 Mar 2021 14:27:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210319232006.3468382-1-seanjc@google.com> <20210319232006.3468382-3-seanjc@google.com>
In-Reply-To: <20210319232006.3468382-3-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Mar 2021 14:27:15 -0700
Message-ID: <CANgfPd_6d+SvJ-rQxP6k5nRmCsRFyUAJ93B0dE3NtpmdPR78wg@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Ensure TLBs are flushed when yielding
 during NX zapping
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
> Fix two intertwined bugs in the NX huge page zapping that were introduced
> by the incorporation of the TDP MMU.  Because there is a unified list of
> NX huge pages, zapping can encounter both TDP MMU and legacy MMU pages,
> and the two MMUs have different tracking for TLB flushing.  If one flavor
> needs a flush, but the code for the other flavor yields, KVM will fail to
> flush before yielding.
>
> First, honor the "flush needed" return from kvm_tdp_mmu_zap_gfn_range(),
> which does the flush itself if and only if it yields, and otherwise
> expects the caller to do the flush.  This requires feeding the result
> into kvm_mmu_remote_flush_or_zap(), and so also fixes the case where the
> TDP MMU needs a flush, the legacy MMU does not, and the main loop yields.
>
> Second, tell the TDP MMU a flush is pending if the list of zapped pages
> from legacy MMUs is not empty, i.e. the legacy MMU needs a flush.  This
> fixes the case where the TDP MMU yields, but it iteslf does not require a
> flush.
>
> Fixes: 29cf0f5007a2 ("kvm: x86/mmu: NX largepage recovery for TDP MMU")
> Cc: stable@vger.kernel.org
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-By: Ben Gardon <bgardon@google.com>

This preserves an extremely unlikely degenerate case, which could
cause an unexpected delay.
The scenario is described below, but I don't think this change needs
to be blocked on it.

> ---
>  arch/x86/kvm/mmu/mmu.c     | 15 ++++++++++-----
>  arch/x86/kvm/mmu/tdp_mmu.c |  6 +++---
>  arch/x86/kvm/mmu/tdp_mmu.h |  3 ++-
>  3 files changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c6ed633594a2..413d6259340e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5517,7 +5517,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>         }
>
>         if (is_tdp_mmu_enabled(kvm)) {
> -               flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end);
> +               flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end,
> +                                                 false);
>                 if (flush)
>                         kvm_flush_remote_tlbs(kvm);
>         }
> @@ -5939,6 +5940,8 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>         struct kvm_mmu_page *sp;
>         unsigned int ratio;
>         LIST_HEAD(invalid_list);
> +       bool flush = false;
> +       gfn_t gfn_end;
>         ulong to_zap;
>
>         rcu_idx = srcu_read_lock(&kvm->srcu);
> @@ -5960,19 +5963,21 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>                                       lpage_disallowed_link);
>                 WARN_ON_ONCE(!sp->lpage_disallowed);
>                 if (is_tdp_mmu_page(sp)) {
> -                       kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn,
> -                               sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level));
> +                       gfn_end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
> +                       flush = kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn, gfn_end,
> +                                                         flush || !list_empty(&invalid_list));
>                 } else {
>                         kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
>                         WARN_ON_ONCE(sp->lpage_disallowed);
>                 }
>
>                 if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
> -                       kvm_mmu_commit_zap_page(kvm, &invalid_list);
> +                       kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);

This pattern of waiting until a yield is needed or lock contention is
detected has always been a little suspect to me because
kvm_mmu_commit_zap_page does work proportional to the work done before
the yield was needed. That seems like more work than we should like to
be doing at that point.

The yield in kvm_tdp_mmu_zap_gfn_range makes that phenomenon even
worse. Because we can satisfy the need to yield without clearing out
the invalid list, we can potentially queue many more pages which will
then all need to have their zaps committed at once. This is an
admittedly contrived case which could only be hit in a high load
nested scenario.

It could be fixed by forbidding kvm_tdp_mmu_zap_gfn_range from
yielding. Since we should only need to zap one SPTE, the yield should
not be needed within the kvm_tdp_mmu_zap_gfn_range call. To ensure
that only one SPTE is zapped we would have to specify the root though.
Otherwise we could end up zapping all the entries for the same GFN
range under an unrelated root.

Anyway, I can address this in another patch.

>                         cond_resched_rwlock_write(&kvm->mmu_lock);
> +                       flush = false;
>                 }
>         }
> -       kvm_mmu_commit_zap_page(kvm, &invalid_list);
> +       kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
>
>         write_unlock(&kvm->mmu_lock);
>         srcu_read_unlock(&kvm->srcu, rcu_idx);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 6cf08c3c537f..367f12bf1026 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -709,10 +709,10 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>   * SPTEs have been cleared and a TLB flush is needed before releasing the
>   * MMU lock.
>   */
> -bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
> +bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
> +                              bool flush)
>  {
>         struct kvm_mmu_page *root;
> -       bool flush = false;
>
>         for_each_tdp_mmu_root_yield_safe(kvm, root)
>                 flush = zap_gfn_range(kvm, root, start, end, true, flush);
> @@ -725,7 +725,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>         gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
>         bool flush;
>
> -       flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn);
> +       flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn, false);
>         if (flush)
>                 kvm_flush_remote_tlbs(kvm);
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 3b761c111bff..e39bee52d49e 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -8,7 +8,8 @@
>  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
>  void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
>
> -bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
> +bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
> +                              bool flush);
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
>
>  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> --
> 2.31.0.rc2.261.g7f71774620-goog
>
