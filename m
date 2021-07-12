Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5363C6237
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 19:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbhGLRw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 13:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbhGLRwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 13:52:55 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070CBC0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 10:50:07 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e2so3898513ilu.5
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 10:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S81pqwJyXQrKbWdPingYLDeMqFcvLQZHytXkgSvjVrs=;
        b=C9EcIp5K2qLOEfqZ7lf298ZSh5Btaid8lRyxtT2SsL3dcVu8Cdo4o4NNeAWsZvA1Vp
         OpXzfapef5iJknmeCBEkRuC0ONIE7Fwmxnf4LkSAFm2EXOPHw6BNOnSDH/Rn1b+VTvG4
         PuxIkHwXoaKuIC9FURkeJ3Ec9/LjZlvOhENWt5nKB/5xI7u5aMbmTzpgY7xr7q7woCdA
         HFaYdIEjevHegyCRPxfUUtP604c6GzhusT4+Aul0/9hl7cz3t4XBcPJBDfmasiB2T7+c
         qsdkIp7/1LYN52Iai9n8HB4imC4ApqiJDVreuwI0iQAkr565y38y6+Tt9z+L9dRSwKNW
         WZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S81pqwJyXQrKbWdPingYLDeMqFcvLQZHytXkgSvjVrs=;
        b=RhL9Jy1RvNKuvY/VVkZBtrnPd1rFzVn69havh9RbS/LcmV7UqE+e5Rjumv2meiN/96
         Pny9P0Who91OSscgxV6LdyHk1w3M6hSkyRzDeHlOJcOAVpEgT3ox+Ugn8Xs4iH7Yayse
         u+yt7bZsjAg//hd9THjNiPGe72jKZsVjPf5+SJA192fI7LQ9c7mDY+RyfkVozvzAiP5V
         LlNWISPXmn2RdJ37cd1eTdSBjd521qQJ65vFKz/Da8RCs2PAYNdpKei3c437ytAZCMhd
         ZPwt+EYal5ig/F+ohzFHy8Jlb1ACzBFGRGmXv2QVUpNClJr4enwV00MLFTO1CoBaQqW8
         vzGA==
X-Gm-Message-State: AOAM5314nNvPHOXIy14apnU2sGz7hrGP2ztye9b4/nS4FEqJK9b5VoZy
        uevaLxsJduzkNf8JT2lsHX30TN1mr7rWOoP5bop8qw==
X-Google-Smtp-Source: ABdhPJwB92ew4KKXWkHK6GXfTnZP6+QKT72wx3bLTz8Lgiliz+Op5Y1Vck5Bob7k8/MpnE3f24XXoX9ph9NSX4qgMU0=
X-Received: by 2002:a92:dc87:: with SMTP id c7mr38635iln.306.1626112206093;
 Mon, 12 Jul 2021 10:50:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210630214802.1902448-1-dmatlack@google.com> <20210630214802.1902448-5-dmatlack@google.com>
In-Reply-To: <20210630214802.1902448-5-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 12 Jul 2021 10:49:55 -0700
Message-ID: <CANgfPd_Ew2AcwegRxcwr+M_myVjyjq2UVz=pHqVuy-UnPWY_ew@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: fast_page_fault support for the TDP MMU
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
> Make fast_page_fault interoperate with the TDP MMU by leveraging
> walk_shadow_page_lockless_{begin,end} to acquire the RCU read lock and
> introducing a new helper function kvm_tdp_mmu_get_last_sptep_lockless to
> grab the lowest level sptep.
>
> Suggested-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 55 +++++++++++++++++++++++++++-----------
>  arch/x86/kvm/mmu/tdp_mmu.c | 36 +++++++++++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.h |  2 ++
>  3 files changed, 78 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 88c71a8a55f1..1d410278a4cc 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3105,15 +3105,45 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
>         return spte & PT_PRESENT_MASK;
>  }
>
> +/*
> + * Returns the last level spte pointer of the shadow page walk for the given
> + * gpa, and sets *spte to the spte value. This spte may be non-preset.
> + *
> + * If no walk could be performed, returns NULL and *spte does not contain valid
> + * data.
> + *
> + * Constraints:
> + *  - Must be called between walk_shadow_page_lockless_{begin,end}.
> + *  - The returned sptep must not be used after walk_shadow_page_lockless_end.
> + */
> +u64 *get_last_sptep_lockless(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
> +{
> +       struct kvm_shadow_walk_iterator iterator;
> +       u64 old_spte;
> +       u64 *sptep = NULL;
> +
> +       if (is_tdp_mmu(vcpu->arch.mmu))
> +               return kvm_tdp_mmu_get_last_sptep_lockless(vcpu, gpa, spte);
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
> -       struct kvm_mmu_page *sp;
>         int ret = RET_PF_INVALID;
>         u64 spte = 0ull;
> +       u64 *sptep = NULL;
>         uint retry_count = 0;
>
>         if (!page_fault_can_be_fast(error_code))
> @@ -3122,16 +3152,14 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
>         walk_shadow_page_lockless_begin(vcpu);
>
>         do {
> +               struct kvm_mmu_page *sp;
>                 u64 new_spte;
>
> -               for_each_shadow_entry_lockless(vcpu, gpa, iterator, spte)
> -                       if (!is_shadow_present_pte(spte))
> -                               break;
> -
> +               sptep = get_last_sptep_lockless(vcpu, gpa, &spte);
>                 if (!is_shadow_present_pte(spte))
>                         break;
>
> -               sp = sptep_to_sp(iterator.sptep);
> +               sp = sptep_to_sp(sptep);
>                 if (!is_last_spte(spte, sp->role.level))
>                         break;
>
> @@ -3189,8 +3217,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
>                  * since the gfn is not stable for indirect shadow page. See
>                  * Documentation/virt/kvm/locking.rst to get more detail.
>                  */
> -               if (fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte,
> -                                           new_spte)) {
> +               if (fast_pf_fix_direct_spte(vcpu, sp, sptep, spte, new_spte)) {
>                         ret = RET_PF_FIXED;
>                         break;
>                 }
> @@ -3203,7 +3230,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
>
>         } while (true);
>
> -       trace_fast_page_fault(vcpu, gpa, error_code, iterator.sptep, spte, ret);
> +       trace_fast_page_fault(vcpu, gpa, error_code, sptep, spte, ret);
>         walk_shadow_page_lockless_end(vcpu);
>
>         return ret;
> @@ -3838,11 +3865,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
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
> index c6fa8d00bf9f..2c9e0ed71fa0 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -527,6 +527,10 @@ static inline bool tdp_mmu_set_spte_atomic_no_dirty_log(struct kvm *kvm,
>         if (is_removed_spte(iter->old_spte))
>                 return false;
>
> +       /*
> +        * TDP MMU sptes can also be concurrently cmpxchg'd in
> +        * fast_pf_fix_direct_spte as part of fast_page_fault.
> +        */
>         if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
>                       new_spte) != iter->old_spte)
>                 return false;

I'm a little nervous about not going through the handle_changed_spte
flow for the TDP MMU, but as things are now, I think it's safe.

> @@ -1546,3 +1550,35 @@ int kvm_tdp_mmu_get_walk_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>
>         return leaf;
>  }
> +
> +/*
> + * Must be called between kvm_tdp_mmu_walk_shadow_page_lockless_{begin,end}.
> + *
> + * The returned sptep must not be used after
> + * kvm_tdp_mmu_walk_shadow_page_lockless_end.
> + */
> +u64 *kvm_tdp_mmu_get_last_sptep_lockless(struct kvm_vcpu *vcpu, u64 addr,
> +                                        u64 *spte)
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
> +       if (sptep)
> +               /*
> +                * Perform the rcu dereference here since we are passing the
> +                * sptep up to the generic MMU code which does not know the
> +                * synchronization details of the TDP MMU. This is safe as long
> +                * as the caller obeys the contract that the sptep is not used
> +                * after kvm_tdp_mmu_walk_shadow_page_lockless_end.
> +                */

There's a little more to this contract:
1. The caller should only modify the SPTE using an atomic cmpxchg with
the returned spte value.
2. The caller should not modify the mapped PFN or present <-> not
present state of the SPTE.
3. There are other bits the caller can't modify too. (lpage, mt, etc.)

If the comments on this function don't document all the constraints on
how the returned sptep can be used, it might be safer to specify that
this is only meant to be used as part of the fast page fault handler.

> +               return rcu_dereference(sptep);
> +
> +       return NULL;
> +}
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index e9dde5f9c0ef..508a23bdf7da 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -81,6 +81,8 @@ void kvm_tdp_mmu_walk_lockless_begin(void);
>  void kvm_tdp_mmu_walk_lockless_end(void);
>  int kvm_tdp_mmu_get_walk_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>                                   int *root_level);
> +u64 *kvm_tdp_mmu_get_last_sptep_lockless(struct kvm_vcpu *vcpu, u64 addr,
> +                                        u64 *spte);
>
>  #ifdef CONFIG_X86_64
>  bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> --
> 2.32.0.93.g670b81a890-goog
>
