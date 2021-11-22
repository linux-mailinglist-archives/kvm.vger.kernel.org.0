Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667E8459527
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236971AbhKVS4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbhKVS4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:56:15 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E986C06174A
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:53:07 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id t8so9266497ilu.8
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VDuh9Y+ZGDuAhrjUCO67MElt5qvWSC6BVX3uBXj2tzA=;
        b=OZelNcoy0k5TsxY0K4JmKgmtpEi78piocq2n8jRNXJXuaqHEEMazqsVvcj9XzGOZu/
         dlUTbBc8Nr3A1487uIhMwTI+kRldpPDLyEMuKTsUYxD0BFtsI6HNtVKovgWaDhnE5VSP
         fXl3kbjNgmySV48LyXT/y2OGWFXXxiLzC3RuTLuVKD76tI+Enay3/rKliSY3vRBnxm0f
         eCgStCcVLQsb4wqAoXycOhmMAn3ccqZXTeBNKO+onFN0tSjF3C5hsf2achMZFhiM+R/s
         GRoXMQ5C5eYD09sjhv1AoF6kK6/rIP6ZogQut/Dc6XFYJJu6qN/JZC39mgE97mRP0eVf
         d8vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VDuh9Y+ZGDuAhrjUCO67MElt5qvWSC6BVX3uBXj2tzA=;
        b=U3VW6/3AWpSxpaUMDJGNKZ0d6GHyEr/UETt9pMhlDRmtMRF0VbZXUx/ZgCShWcp1ER
         +BT5BOmTdZxtUXog1nelZI4yw+tvf0Dg16ExbWpvVPo+5w4YKKGFhDSsWCKGonQLFsTu
         MayggUFot3wwsVbscificYiOxcjXmYs4rF3tBTXIY0a21p6O7e111DSvSZ5InH5YMAbZ
         qbCsIB9MFRjkVHbmAHOw3RcVPxVfaR5wnQupJldsJZS6uqLB3ziYokfK6tBAMzmB0Yih
         ZBm77KAllwYQulePV2up7pdpET4qJTqBuaW6VxFj40ISIRHJkGGv31I3ea4hLsMuzETO
         /PCA==
X-Gm-Message-State: AOAM5300e28r9GQf/pN7SoOIuVrkUqdpIP5eA/eQ1hXfL/7ApNZBsjQL
        /w1pfP8i6+th9/gZwK9xn4VlAJsduyvi60F1puXoEA==
X-Google-Smtp-Source: ABdhPJzJVUBYljJsikXBmL8jrcp87mRtBaXTaId9zrWE8G2G/uLcSIbV9c2kYISTRyrMSyfHmcw9up3Yro+m4kti3V8=
X-Received: by 2002:a05:6e02:547:: with SMTP id i7mr21193957ils.298.1637607186491;
 Mon, 22 Nov 2021 10:53:06 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-5-dmatlack@google.com>
In-Reply-To: <20211119235759.1304274-5-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 10:52:55 -0800
Message-ID: <CANgfPd_DyTgb2z-1YQB-Rf+aYpGvHWogqUfv=8jH5+s7Vk-tvA@mail.gmail.com>
Subject: Re: [RFC PATCH 04/15] KVM: x86/mmu: Factor out logic to atomically
 install a new page table
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 3:58 PM David Matlack <dmatlack@google.com> wrote:
>
> Factor out the logic to atomically replace an SPTE with an SPTE that
> points to a new page table. This will be used in a follow-up commit to
> split a large page SPTE into one level lower.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 53 ++++++++++++++++++++++++++------------
>  1 file changed, 37 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index cc9fe33c9b36..9ee3f4f7fdf5 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -945,6 +945,39 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>         return ret;
>  }
>
> +/*
> + * tdp_mmu_install_sp_atomic - Atomically replace the given spte with an
> + * spte pointing to the provided page table.
> + *
> + * @kvm: kvm instance
> + * @iter: a tdp_iter instance currently on the SPTE that should be set
> + * @sp: The new TDP page table to install.
> + * @account_nx: True if this page table is being installed to split a
> + *              non-executable huge page.
> + *
> + * Returns: True if the new page table was installed. False if spte being
> + *          replaced changed, causing the atomic compare-exchange to fail.
> + *          If this function returns false the sp will be freed before
> + *          returning.
> + */
> +static bool tdp_mmu_install_sp_atomic(struct kvm *kvm,
> +                                     struct tdp_iter *iter,
> +                                     struct kvm_mmu_page *sp,
> +                                     bool account_nx)
> +{
> +       u64 spte;
> +
> +       spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
> +
> +       if (tdp_mmu_set_spte_atomic(kvm, iter, spte)) {
> +               tdp_mmu_link_page(kvm, sp, account_nx);
> +               return true;
> +       } else {
> +               tdp_mmu_free_sp(sp);
> +               return false;
> +       }
> +}
> +
>  /*
>   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
>   * page tables and SPTEs to translate the faulting guest physical address.
> @@ -954,8 +987,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>         struct kvm_mmu *mmu = vcpu->arch.mmu;
>         struct tdp_iter iter;
>         struct kvm_mmu_page *sp;
> -       u64 *child_pt;
> -       u64 new_spte;
>         int ret;
>
>         kvm_mmu_hugepage_adjust(vcpu, fault);
> @@ -983,6 +1014,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                 }
>
>                 if (!is_shadow_present_pte(iter.old_spte)) {
> +                       bool account_nx = fault->huge_page_disallowed &&
> +                                         fault->req_level >= iter.level;
> +
>                         /*
>                          * If SPTE has been frozen by another thread, just
>                          * give up and retry, avoiding unnecessary page table
> @@ -992,21 +1026,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                                 break;
>
>                         sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
> -                       child_pt = sp->spt;
> -
> -                       new_spte = make_nonleaf_spte(child_pt,
> -                                                    !shadow_accessed_mask);
> -
> -                       if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
> -                               tdp_mmu_link_page(vcpu->kvm, sp,
> -                                                 fault->huge_page_disallowed &&
> -                                                 fault->req_level >= iter.level);
> -
> -                               trace_kvm_mmu_get_page(sp, true);

This refactoring drops this trace point. Is that intentional?


> -                       } else {
> -                               tdp_mmu_free_sp(sp);
> +                       if (!tdp_mmu_install_sp_atomic(vcpu->kvm, &iter, sp, account_nx))
>                                 break;
> -                       }
>                 }
>         }
>
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
