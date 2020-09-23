Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CD427647E
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 01:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgIWXaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 19:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgIWXaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 19:30:00 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BC2C0613CE
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 16:30:00 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t12so1319281ilh.3
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 16:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kyIVOaqB/Lo9xi5CTeoxW5aB69SRY2R3s7cddxat0oc=;
        b=eiMaJKLhRPOz7y39+m5bj9Z9vmD9Cy3R58ohCFmzGcAHkWC5huS508cTpcNxhjbQcw
         uFi5yYNoQosq5zNa+emGVOTqH+K70WpCrvtk9h1dnsoE3+qFh5fB/j2QsxFymAovjiJb
         G3tu+CUA8OYkLt/Fd6nrVCIqPS9xQRTbdriar5DkpJuKL/DXmyDLPVWd00NjSgegnBUO
         sQlkkhy1bhbiCQcwBBKzN54DYiqpQBajLzwq6hHMb4Tk6cfpBOm0oWxx8rRzlG54ThE0
         NpQ+cuZpPaXtWvb/1gMiEoRK992Fa3rW1Vk11RIbuvd3Tx/EM+b5FxZVc5+td4V37ZIt
         qYkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kyIVOaqB/Lo9xi5CTeoxW5aB69SRY2R3s7cddxat0oc=;
        b=Cq132hitYOW4MAzLKAE9GueIzh9IM08SkfVQc76Ak5f9QY5flo+HUMDshLzWntZZsd
         OipMRJrQJIg7qe09iyjyQ+lWS+iNpn7R9cu4oZjJuEBMOiCBPq6wUPrhtXawFBGkpXYh
         R29UBanQcNNBzNKc1G1KzqptmqkuSf9zXZYaEZO7ibuYTk/zoKsdf/C9JHEaDPuS9pCf
         mhnJ5nSpBamChC2T9GP54+QgyHnDpd1MHy5dVraDwXV50Ua7wXaFWq0354lwRu7/G3GZ
         Rac1s6qw/QTcSzL145mHlTs9LSGg6kERDO4RzdPGvzLMvBOMpO/7fX3KGx58ew42dlpw
         9Tiw==
X-Gm-Message-State: AOAM5316YwgbSqjJA4pQjqWmL6b9ipeEu7xygJcX/mtdRy6xsPPtXjsD
        GhjWY0x/TCdyqwyQBpFsKOooCG2lOc/xOMEbiT9gYG8U/m1iTw==
X-Google-Smtp-Source: ABdhPJyNMV4JjS6sPOq0BgXWVMEzgGdgwLi15ybld1wrptIfEEfCxYfy5l0O1O+J/bAOLFeKz/xPU0zQ+8W/y9EcXxI=
X-Received: by 2002:a92:1e07:: with SMTP id e7mr1647650ile.154.1600903799587;
 Wed, 23 Sep 2020 16:29:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200923221406.16297-1-sean.j.christopherson@intel.com> <20200923221406.16297-3-sean.j.christopherson@intel.com>
In-Reply-To: <20200923221406.16297-3-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 23 Sep 2020 16:29:48 -0700
Message-ID: <CANgfPd9LLhLMsOHtMS1begL_J676Szve5y-qruY85WAu5MpYVw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] KVM: x86/MMU: Recursively zap nested TDP SPs when
 zapping last/only parent
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 3:14 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> From: Ben Gardon <bgardon@google.com>
>
> Recursively zap all to-be-orphaned children, unsynced or otherwise, when
> zapping a shadow page for a nested TDP MMU.  KVM currently only zaps the
> unsynced child pages, but not the synced ones.  This can create problems
> over time when running many nested guests because it leaves unlinked
> pages which will not be freed until the page quota is hit. With the
> default page quota of 20 shadow pages per 1000 guest pages, this looks
> like a memory leak and can degrade MMU performance.
>
> In a recent benchmark, substantial performance degradation was observed:
> An L1 guest was booted with 64G memory.
> 2G nested Windows guests were booted, 10 at a time for 20
> iterations. (200 total boots)
> Windows was used in this benchmark because they touch all of their
> memory on startup.
> By the end of the benchmark, the nested guests were taking ~10% longer
> to boot. With this patch there is no degradation in boot time.
> Without this patch the benchmark ends with hundreds of thousands of
> stale EPT02 pages cluttering up rmaps and the page hash map. As a
> result, VM shutdown is also much slower: deleting memslot 0 was
> observed to take over a minute. With this patch it takes just a
> few miliseconds.
>
> Cc: Peter Shier <pshier@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Ben Gardon <bgardon@google.com>
(I don't know if my review is useful here, but the rebase of this
patch looks correct! Thank you for preventing these from becoming
undead, Sean.)

> ---
>  arch/x86/kvm/mmu/mmu.c         | 30 +++++++++++++++++++++++-------
>  arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
>  2 files changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a91e8601594d..e993d5cd4bc8 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2615,8 +2615,9 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>         }
>  }
>
> -static void mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
> -                            u64 *spte)
> +/* Returns the number of zapped non-leaf child shadow pages. */
> +static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
> +                           u64 *spte, struct list_head *invalid_list)
>  {
>         u64 pte;
>         struct kvm_mmu_page *child;
> @@ -2630,19 +2631,34 @@ static void mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
>                 } else {
>                         child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
>                         drop_parent_pte(child, spte);
> +
> +                       /*
> +                        * Recursively zap nested TDP SPs, parentless SPs are
> +                        * unlikely to be used again in the near future.  This
> +                        * avoids retaining a large number of stale nested SPs.
> +                        */
> +                       if (tdp_enabled && invalid_list &&
> +                           child->role.guest_mode && !child->parent_ptes.val)
> +                               return kvm_mmu_prepare_zap_page(kvm, child,
> +                                                               invalid_list);
>                 }
>         } else if (is_mmio_spte(pte)) {
>                 mmu_spte_clear_no_track(spte);
>         }
> +       return 0;
>  }
>
> -static void kvm_mmu_page_unlink_children(struct kvm *kvm,
> -                                        struct kvm_mmu_page *sp)
> +static int kvm_mmu_page_unlink_children(struct kvm *kvm,
> +                                       struct kvm_mmu_page *sp,
> +                                       struct list_head *invalid_list)
>  {
> +       int zapped = 0;
>         unsigned i;
>
>         for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
> -               mmu_page_zap_pte(kvm, sp, sp->spt + i);
> +               zapped += mmu_page_zap_pte(kvm, sp, sp->spt + i, invalid_list);
> +
> +       return zapped;
>  }
>
>  static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
> @@ -2688,7 +2704,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
>         trace_kvm_mmu_prepare_zap_page(sp);
>         ++kvm->stat.mmu_shadow_zapped;
>         *nr_zapped = mmu_zap_unsync_children(kvm, sp, invalid_list);
> -       kvm_mmu_page_unlink_children(kvm, sp);
> +       *nr_zapped += kvm_mmu_page_unlink_children(kvm, sp, invalid_list);
>         kvm_mmu_unlink_parents(kvm, sp);
>
>         /* Zapping children means active_mmu_pages has become unstable. */
> @@ -5396,7 +5412,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>                         u32 base_role = vcpu->arch.mmu->mmu_role.base.word;
>
>                         entry = *spte;
> -                       mmu_page_zap_pte(vcpu->kvm, sp, spte);
> +                       mmu_page_zap_pte(vcpu->kvm, sp, spte, NULL);
>                         if (gentry &&
>                             !((sp->role.word ^ base_role) & ~role_ign.word) &&
>                             rmap_can_add(vcpu))
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 3bb624a3dda9..e1066226b8f0 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -929,7 +929,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
>                         pte_gpa = FNAME(get_level1_sp_gpa)(sp);
>                         pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
>
> -                       mmu_page_zap_pte(vcpu->kvm, sp, sptep);
> +                       mmu_page_zap_pte(vcpu->kvm, sp, sptep, NULL);
>                         if (is_shadow_present_pte(old_spte))
>                                 kvm_flush_remote_tlbs_with_address(vcpu->kvm,
>                                         sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
> --
> 2.28.0
>
