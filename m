Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B2F3C7A4E
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 01:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbhGMXs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 19:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhGMXs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 19:48:56 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23385C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 16:46:05 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id l5so29377896iok.7
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 16:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UWn3hagpoC3z6r6qdl32UEy1TBH9DlBHI2cMjWokLLg=;
        b=ci/WULn5kvAp8Wi+4zCv/+4LUm7S12L3dDmwJFPbtFTm6HBlhY77JqBGSV1xAQSaME
         YNJgkCrNypBnH127++bXsJ0HK/kCZNKp63PC+a7qPVcrFdvemuvZ0jwQt+pMNJBKsbzq
         FlLZ79JWyx/xp765MRyVkBZbYo0QehL8VUz1SNk3JWfXg/YXgGeTDnBah198S4VF6Yon
         dAwcsAvyXQG0zMBp4NG/8/4x9/lkSSTyIBOkcW/bp/S3867VMkuI406GtFfeGvg63mB8
         jshsVHkrDO5uGqpOfmVR2eBgSxG/8W/RAM/yCIxFFXXf9KoVIXi0K2RnjQKqGWaI+kRH
         sD1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UWn3hagpoC3z6r6qdl32UEy1TBH9DlBHI2cMjWokLLg=;
        b=e+meQLjBNafCq3464ipyDIfP6Hqv2ytho8VQg0f3BMYbGN7B0nV5TlHjBxkehpWHdx
         fha/n9U4n7joY6CGTrIkocUCp6wlw/1NrrtesRnHq/NuBDW3iLOkRsCbiwzelowtbfmA
         PTWPsiPHfHMXGneyrMZcRQ+0JtihoZoiik6V4qEuA6vQDps4dgXnV5s2U2UZZsP/6dkt
         1d11LfSZ8WNTYx8eP+Zy0PjeG75JuGkGmbnfo+fsAyqSdiYkB3Sa33Tjb+1Aku4tEGl6
         ADtXW/EwzEDKWII48U3nZY6l6o9chnoJeK95lGhsxUBqOUt3WVZF4FLRmyzHBQ4wEwrG
         /YDg==
X-Gm-Message-State: AOAM530SItNUUchsmarykg0Y1Nkgn/P6dZyGO+0Imx2QBuL/as65FxL5
        LciFdHgo+prVoSfIx1FyWxsCK7m2x+7vbAGIb6vzKw==
X-Google-Smtp-Source: ABdhPJw9wOHuMupI3xO5mBNkg6LWja9bm8RVNY4vrqAcwJwndWgzalSBrpVwpynVqfMMIQ19bKZKMsTjSWaLSfFEboE=
X-Received: by 2002:a05:6602:3404:: with SMTP id n4mr5233394ioz.19.1626219964435;
 Tue, 13 Jul 2021 16:46:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210713220957.3493520-1-dmatlack@google.com> <20210713220957.3493520-5-dmatlack@google.com>
In-Reply-To: <20210713220957.3493520-5-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 13 Jul 2021 16:45:53 -0700
Message-ID: <CANgfPd-i15KR1vkD8pQZHMneQ2dBGwOCyFsaGsnxV5TEyygcOA@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] KVM: x86/mmu: fast_page_fault support for the TDP MMU
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
> Make fast_page_fault interoperate with the TDP MMU by leveraging
> walk_shadow_page_lockless_{begin,end} to acquire the RCU read lock and
> introducing a new helper function kvm_tdp_mmu_fast_pf_get_last_sptep to
> grab the lowest level sptep.
>
> Suggested-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c     | 50 ++++++++++++++++++++++++++++----------
>  arch/x86/kvm/mmu/tdp_mmu.c | 41 +++++++++++++++++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.h |  2 ++
>  3 files changed, 80 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e3d99853b962..dedde4105adb 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3105,15 +3105,41 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
>         return spte & PT_PRESENT_MASK;
>  }
>
> +/*
> + * Returns the last level spte pointer of the shadow page walk for the given
> + * gpa, and sets *spte to the spte value. This spte may be non-preset. If no
> + * walk could be performed, returns NULL and *spte does not contain valid data.
> + *
> + * Contract:
> + *  - Must be called between walk_shadow_page_lockless_{begin,end}.
> + *  - The returned sptep must not be used after walk_shadow_page_lockless_end.
> + */
> +static u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
> +{
> +       struct kvm_shadow_walk_iterator iterator;
> +       u64 old_spte;
> +       u64 *sptep = NULL;
> +
> +       for_each_shadow_entry_lockless(vcpu, gpa, iterator, old_spte) {
> +               sptep = iterator.sptep;
> +               *spte = old_spte;
> +
> +               if (!is_shadow_present_pte(old_spte))
> +                       break;
> +       }
> +
> +       return sptep;
> +}
> +
>  /*
>   * Returns one of RET_PF_INVALID, RET_PF_FIXED or RET_PF_SPURIOUS.
>   */
>  static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
>  {
> -       struct kvm_shadow_walk_iterator iterator;
>         struct kvm_mmu_page *sp;
>         int ret = RET_PF_INVALID;
>         u64 spte = 0ull;
> +       u64 *sptep = NULL;
>         uint retry_count = 0;
>
>         if (!page_fault_can_be_fast(error_code))
> @@ -3124,14 +3150,15 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
>         do {
>                 u64 new_spte;
>
> -               for_each_shadow_entry_lockless(vcpu, gpa, iterator, spte)
> -                       if (!is_shadow_present_pte(spte))
> -                               break;
> +               if (is_tdp_mmu(vcpu->arch.mmu))
> +                       sptep = kvm_tdp_mmu_fast_pf_get_last_sptep(vcpu, gpa, &spte);
> +               else
> +                       sptep = fast_pf_get_last_sptep(vcpu, gpa, &spte);
>
>                 if (!is_shadow_present_pte(spte))
>                         break;
>
> -               sp = sptep_to_sp(iterator.sptep);
> +               sp = sptep_to_sp(sptep);
>                 if (!is_last_spte(spte, sp->role.level))
>                         break;
>
> @@ -3189,8 +3216,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
>                  * since the gfn is not stable for indirect shadow page. See
>                  * Documentation/virt/kvm/locking.rst to get more detail.
>                  */
> -               if (fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte,
> -                                           new_spte)) {
> +               if (fast_pf_fix_direct_spte(vcpu, sp, sptep, spte, new_spte)) {
>                         ret = RET_PF_FIXED;
>                         break;
>                 }
> @@ -3203,7 +3229,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
>
>         } while (true);
>
> -       trace_fast_page_fault(vcpu, gpa, error_code, iterator.sptep, spte, ret);
> +       trace_fast_page_fault(vcpu, gpa, error_code, sptep, spte, ret);
>         walk_shadow_page_lockless_end(vcpu);
>
>         return ret;
> @@ -3838,11 +3864,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         if (page_fault_handle_page_track(vcpu, error_code, gfn))
>                 return RET_PF_EMULATE;
>
> -       if (!is_tdp_mmu_fault) {
> -               r = fast_page_fault(vcpu, gpa, error_code);
> -               if (r != RET_PF_INVALID)
> -                       return r;
> -       }
> +       r = fast_page_fault(vcpu, gpa, error_code);
> +       if (r != RET_PF_INVALID)
> +               return r;
>
>         r = mmu_topup_memory_caches(vcpu, false);
>         if (r)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 98ffd1ba556e..313999c462d1 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -527,6 +527,10 @@ static inline bool tdp_mmu_set_spte_atomic_no_dirty_log(struct kvm *kvm,
>         if (is_removed_spte(iter->old_spte))
>                 return false;
>
> +       /*
> +        * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
> +        * does not hold the mmu_lock.
> +        */
>         if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
>                       new_spte) != iter->old_spte)
>                 return false;
> @@ -1536,3 +1540,40 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>
>         return leaf;
>  }
> +
> +/*
> + * Returns the last level spte pointer of the shadow page walk for the given
> + * gpa, and sets *spte to the spte value. This spte may be non-preset. If no
> + * walk could be performed, returns NULL and *spte does not contain valid data.
> + *
> + * Contract:
> + *  - Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
> + *  - The returned sptep must not be used after kvm_tdp_mmu_walk_lockless_end.
> + *
> + * WARNING: This function is only intended to be called during fast_page_fault.

Heh, this warning seems a bit overkill, but no harm there.

> + */
> +u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
> +                                       u64 *spte)
> +{
> +       struct tdp_iter iter;
> +       struct kvm_mmu *mmu = vcpu->arch.mmu;
> +       gfn_t gfn = addr >> PAGE_SHIFT;
> +       tdp_ptep_t sptep = NULL;
> +
> +       tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
> +               *spte = iter.old_spte;
> +               sptep = iter.sptep;
> +       }
> +
> +       /*
> +        * Perform the rcu_dereference to get the raw spte pointer value since
> +        * we are passing it up to fast_page_fault, which is shared with the
> +        * legacy MMU and thus does not retain the TDP MMU-specific __rcu
> +        * annotation.
> +        *
> +        * This is safe since fast_page_fault obeys the contracts of this
> +        * function as well as all TDP MMU contracts around modifying SPTEs
> +        * outside of mmu_lock.
> +        */
> +       return rcu_dereference(sptep);
> +}
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 93e1bf5089c4..361b47f98cc5 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -89,6 +89,8 @@ static inline void kvm_tdp_mmu_walk_lockless_end(void)
>
>  int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>                          int *root_level);
> +u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
> +                                       u64 *spte);
>
>  #ifdef CONFIG_X86_64
>  bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> --
> 2.32.0.93.g670b81a890-goog
>
