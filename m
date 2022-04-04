Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320004F1BAC
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380835AbiDDVWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379749AbiDDSAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 14:00:47 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AD2186E4
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 10:58:50 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2eb9412f11dso13056907b3.4
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 10:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zDeo6fXGhg6EAiuUbbF5arvW/VwJQGLFv7Esfpjiwxc=;
        b=KkEd+zIJGYIpQxzBTpFyiBcZU0CtUucN0HlhH1+mWsOgvtliSRhxHGU01qfdjbCPXl
         M+v6/rlX3V4kkx8NjJq3uUWjXpldT9HlQVluNXz3M5q4+zltAsteY2zHJ7CHhD+7C4jd
         9DsoRA18YEYvpvnmQLejLB222cRfZzYRzyHeynvrLqjXN7jB2aPftkAWcR0MHd+ZGrj+
         tLjiXyoOmVjheLm+2ITrQY1UT50HKL9+OE1VDcE5OgnGX7gVbwJQkx31e8wpgZSVLcRp
         aFcNh7up3NffSS18OMap4bOELYj+gM+QY2nbCRTmyhnpV+N9rZo6ktiNa1zr/9TlaHNA
         JDlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zDeo6fXGhg6EAiuUbbF5arvW/VwJQGLFv7Esfpjiwxc=;
        b=ZSz4X5vmAvg0nd2oeOVsa8lg3wc5q8gCgA2HJ5EGI7XqDoPvoX1zZHNfQPlTmrkA4i
         /YzRG4tVV4LF4zfRvWdbGKY94Zh1lGmDcy++hUC41EA8CGwsBLhSbDFWw3Bu4jn2ze6x
         op76t1VzUuHCfnGRX9e4oxvw1ei6uajCJsALbQ15evWHCCAgux2FIA9bTzRB58SKd6ZD
         HjnXOUCE0TmPIoRUA0otNjWZDpNmo4tQ54SsUfVK1W3xWvB0sP3sq00syoJvVkALnwf5
         QFjWyyhsiJ/cWLpc4b1YvPDbvkI6jq+8bDjPSI+mTVqV/q4Jawa+7H/FWFl0ZkcybHsC
         SEfw==
X-Gm-Message-State: AOAM531Z7dLSSGp9DYJXyagXqh5+9zweZHvm+HFh7BfaQkcb/j/NQV+y
        ISEzE2ugGo/XWunzCJhH+rdMsiFRYSTo0Lx7WEVjCg==
X-Google-Smtp-Source: ABdhPJyTF9OVOfpvezGKNXupF8hmRYE///GfHCK9sr2nsheioCf9CrdPzSGJAhtIalNOhxQfvb3IlDmJuJmulPVIYKk=
X-Received: by 2002:a81:15ce:0:b0:2e5:e189:7366 with SMTP id
 197-20020a8115ce000000b002e5e1897366mr1163853ywv.188.1649095129129; Mon, 04
 Apr 2022 10:58:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220401063636.2414200-1-mizhang@google.com> <20220401063636.2414200-2-mizhang@google.com>
In-Reply-To: <20220401063636.2414200-2-mizhang@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 4 Apr 2022 10:58:38 -0700
Message-ID: <CANgfPd9OqV35BGfRCvJZNK_kemgqDWPx8TKKObfyGb0iiC-uxg@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] KVM: x86/mmu: Set lpage_disallowed in TDP MMU
 before setting SPTE
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yosry Ahmed <yosryahmed@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022 at 11:36 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Set lpage_disallowed in TDP MMU shadow pages before making the SP visible
> to other readers, i.e. before setting its SPTE.  This will allow KVM to
> query lpage_disallowed when determining if a shadow page can be replaced
> by a NX huge page without violating the rules of the mitigation.
>
> Reviewed-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 14 ++++++++++----
>  arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      | 20 ++++++++++++--------
>  3 files changed, 23 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1361eb4599b4..5cb845fae56e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -812,14 +812,20 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>         kvm_mmu_gfn_disallow_lpage(slot, gfn);
>  }
>
> -void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +void __account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -       if (sp->lpage_disallowed)
> -               return;
> -
>         ++kvm->stat.nx_lpage_splits;
>         list_add_tail(&sp->lpage_disallowed_link,
>                       &kvm->arch.lpage_disallowed_mmu_pages);
> +}
> +
> +static void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +       if (sp->lpage_disallowed)
> +               return;
> +
> +       __account_huge_nx_page(kvm, sp);
> +
>         sp->lpage_disallowed = true;
>  }
>
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 1bff453f7cbe..4a0087efa1e3 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -168,7 +168,7 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>
>  void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>
> -void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> +void __account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);

I believe we need to modify the usage of this function in
paging_tmpl.h as well, at which point there should be no users of
account_huge_nx_page, so we can just modify the function directly
instead of adding a __helper.
(Disregard if the source I was looking at was out of date. Lots of
churn in this code recently.)


>  void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>
>  #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index b3b6426725d4..f05423545e6d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1122,16 +1122,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>   * @kvm: kvm instance
>   * @iter: a tdp_iter instance currently on the SPTE that should be set
>   * @sp: The new TDP page table to install.
> - * @account_nx: True if this page table is being installed to split a
> - *              non-executable huge page.
>   * @shared: This operation is running under the MMU lock in read mode.
>   *
>   * Returns: 0 if the new page table was installed. Non-0 if the page table
>   *          could not be installed (e.g. the atomic compare-exchange failed).
>   */
>  static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
> -                          struct kvm_mmu_page *sp, bool account_nx,
> -                          bool shared)
> +                          struct kvm_mmu_page *sp, bool shared)
>  {
>         u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
>         int ret = 0;
> @@ -1146,8 +1143,6 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>
>         spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>         list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
> -       if (account_nx)
> -               account_huge_nx_page(kvm, sp);
>         spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>
>         return 0;
> @@ -1160,6 +1155,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>         struct kvm_mmu *mmu = vcpu->arch.mmu;
> +       struct kvm *kvm = vcpu->kvm;
>         struct tdp_iter iter;
>         struct kvm_mmu_page *sp;
>         int ret;
> @@ -1210,10 +1206,18 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                         sp = tdp_mmu_alloc_sp(vcpu);
>                         tdp_mmu_init_child_sp(sp, &iter);
>
> -                       if (tdp_mmu_link_sp(vcpu->kvm, &iter, sp, account_nx, true)) {
> +                       sp->lpage_disallowed = account_nx;
> +
> +                       if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
>                                 tdp_mmu_free_sp(sp);
>                                 break;
>                         }
> +
> +                       if (account_nx) {
> +                               spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> +                               __account_huge_nx_page(kvm, sp);
> +                               spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +                       }
>                 }
>         }
>
> @@ -1501,7 +1505,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>          * correctness standpoint since the translation will be the same either
>          * way.
>          */
> -       ret = tdp_mmu_link_sp(kvm, iter, sp, false, shared);
> +       ret = tdp_mmu_link_sp(kvm, iter, sp, shared);
>         if (ret)
>                 goto out;
>
> --
> 2.35.1.1094.g7c7d902a7c-goog
>
