Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB5045ACF1
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 20:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240279AbhKWUBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 15:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240220AbhKWUBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 15:01:50 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD800C061714
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 11:58:41 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id e8so224508ilu.9
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 11:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FaX0MNa28ktDMFJ703YUr1snjJaPsMvJN89bnC0T+OA=;
        b=XjLNCiDLH+OR/sFFIfmbrvuQtg1+myUNeQMVevDRVkyXKNp1f5bK5ZRBG/GlV7RFaD
         bfU3sFNzaEEtIZngzr1WMaLMfmmhOAI3t1BGL1L3plPXsbz2LJiGFjdS93TI3yhovTl0
         UoaIP/lwgCXxyxTUgz93nRdAh0lXH9TdGzxwbZpDY0YCh2UuXuGdTe47SLZhlzNP6NNY
         kxLD6wYPfCId/EMz3rK3AjIbCszbS7OzhNEgDDO+uClyKf0RQd0FvSO0tLYURp8Vl3BU
         MjwXY3czZxtS2AfnWIX6TIk+TZkOX3TY/pASxhnw1+0Benfrr+ya82kTdksxemJnWo3r
         IXEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FaX0MNa28ktDMFJ703YUr1snjJaPsMvJN89bnC0T+OA=;
        b=fZS9FNNWd0UfMjPphuVTxGzoDMh8lLEunSlT5wD/1ZLcI78i3WAYU6gnr5zOuFajTU
         eezvuE7OFCfLcq4hNMpcbEmUwFkbyhL4IwX6WDNfVXxNM9FdE88DRzng5Zia1fQClzHG
         ESWJkvOeGGQvrlj3Q7XBdg5j/Xxy/Mp5QDMPLGpVj8r/KZGhjyDW6OtjXx3nWCsBmSG7
         FIWeD1/qD7ydlZG1JooBvsx8AmYe14qG9jUqwCdI+5B2le3dk9w9ILjb9VR3Et6v3ARm
         JPnmN0Ve6NHRD3ooUswr2hHgHE2oFlZHjwF2NzU4urmeBI3zk+aetyLrSTdDZoOXHFEm
         n72w==
X-Gm-Message-State: AOAM533pYux6Q6HycuVvub87hTImI3Y9+wFs+ofAxpKBxRKZXpxVV8wz
        dhklmMvT1YLQYyY9EH8NuoYHa1p2ntBYlAM0StQKPA==
X-Google-Smtp-Source: ABdhPJxtHRLnxuXgs8zcOvR5NCKIU2rYbV2sGPqOvTbIHGiP/5UdPTctE15YYZSZgYakGfLgxIM+x+avcLdf8vwtWcI=
X-Received: by 2002:a05:6e02:52d:: with SMTP id h13mr7398380ils.274.1637697521193;
 Tue, 23 Nov 2021 11:58:41 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-26-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-26-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 23 Nov 2021 11:58:30 -0800
Message-ID: <CANgfPd8EmhE3wWCp9cYat-GQ_uB83TTyLXyMj0tBXhnZ1yVwig@mail.gmail.com>
Subject: Re: [PATCH 25/28] KVM: x86/mmu: Require mmu_lock be held for write to
 zap TDP MMU range
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
> Now that all callers of zap_gfn_range() hold mmu_lock for write, drop
> support for zapping with mmu_lock held for read.  That all callers hold
> mmu_lock for write isn't a random coincedence; now that the paths that
> need to zap _everything_ have their own path, the only callers left are
> those that need to zap for functional correctness.  And when zapping is
> required for functional correctness, mmu_lock must be held for write,
> otherwise the caller has no guarantees about the state of the TDP MMU
> page tables after it has run, e.g. the SPTE(s) it zapped can be
> immediately replaced by a vCPU faulting in a page.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 29 ++++++-----------------------
>  1 file changed, 6 insertions(+), 23 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 0e5a0d40e54a..926e92473e92 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -844,15 +844,9 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>   * function cannot yield, it will not release the MMU lock or reschedule and
>   * the caller must ensure it does not supply too large a GFN range, or the
>   * operation can cause a soft lockup.
> - *
> - * If shared is true, this thread holds the MMU lock in read mode and must
> - * account for the possibility that other threads are modifying the paging
> - * structures concurrently. If shared is false, this thread should hold the
> - * MMU lock in write mode.
>   */
>  static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> -                         gfn_t start, gfn_t end, bool can_yield, bool flush,
> -                         bool shared)
> +                         gfn_t start, gfn_t end, bool can_yield, bool flush)
>  {
>         bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
>         struct tdp_iter iter;
> @@ -865,15 +859,14 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>
>         end = min(end, tdp_mmu_max_gfn_host());
>
> -       kvm_lockdep_assert_mmu_lock_held(kvm, shared);
> +       lockdep_assert_held_write(&kvm->mmu_lock);
>
>         rcu_read_lock();
>
>         for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
>                                    min_level, start, end) {
> -retry:
>                 if (can_yield &&
> -                   tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
> +                   tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
>                         flush = false;
>                         continue;
>                 }
> @@ -892,17 +885,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>                     !is_last_spte(iter.old_spte, iter.level))
>                         continue;
>
> -               if (!shared) {
> -                       tdp_mmu_set_spte(kvm, &iter, 0);
> -                       flush = true;
> -               } else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
> -                       /*
> -                        * The iter must explicitly re-read the SPTE because
> -                        * the atomic cmpxchg failed.
> -                        */
> -                       iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
> -                       goto retry;
> -               }
> +               tdp_mmu_set_spte(kvm, &iter, 0);
> +               flush = true;
>         }
>
>         rcu_read_unlock();
> @@ -921,8 +905,7 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
>         struct kvm_mmu_page *root;
>
>         for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
> -               flush = zap_gfn_range(kvm, root, start, end, can_yield, flush,
> -                                     false);
> +               flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
>
>         return flush;
>  }
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
