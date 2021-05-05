Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4CB373FC8
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 18:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbhEEQ3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 12:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbhEEQ3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 12:29:14 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDB5C061574
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 09:28:17 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b17so2809848ede.0
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 09:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nTkLQfjHibG2TZVtD4E1QeQHQ5DUZBDMH+aq+qk94dk=;
        b=UBDcGIKFB1GZT58kfY1NnomDLYno5HFIAPiE1EJxwgNbr9sm0mnjr0l/VpQ5iOXLL0
         xhE60sG2m07Pqhn34RiNKyI8BV14zJB+GUDxIU4gJZGmgLy66BRQJhdPqZ6B0cG5Zrhw
         pYVwt0/yCpR5g0cqexyf0bb/eMNOTXWHFJsVFMdJM26f+ymta6YU0gJVrlxyHUJMM6E1
         1/+0ejR1MfXueyvVL/LkfkzvFFlvuQUOKKHqv8NT7A9cNpDMs8BAsFMUj+teKGpeqJjO
         VGu7CUf8CzxDwoPJoWBVrkjRK9BxCFCiD3PUwfIaFExbt6yBaV94X0Uuhp8gCz4/PiFS
         6q5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nTkLQfjHibG2TZVtD4E1QeQHQ5DUZBDMH+aq+qk94dk=;
        b=CVDI0gJUg8uVrlCsZiBxi9uWT0DBoKKxuo/Yc15q11s8DbahqjjT3XDAtLHRix2Iaz
         lCRDlAoxIyB9yIUfCNNa7p3SHs/tMc/kLPAGKet5Pt3mMhBq+d70tTvh5k2SCXqnGw0w
         lD6GJkF6bySsAZV7QJ6tMAMFF/o7pS4RLJcM8mW5Bamkbn3qkpYoPoOWXDsD/MXAaURf
         fB4RJMTKTTWZ4haLvQBAH0aU0HYmM4xFGcbQlmx91LxOrsuxIKhk+LonblN4C7xg10RF
         8iI3GT7xphQ8mJSo6xBiFnNKbIm446IJnQC77tAGK+4BN1qcMxVQgnJ9cpFCLuEciQul
         rokg==
X-Gm-Message-State: AOAM530AlvraZ4/CHhRAgyjR4A9Ww5dmPB8ZJXmG+ug2+NHfGk3HsmW8
        O2s4XNF2enkdtn6Ib3lgv4fjLZCa92kiw+Sn89ki0g==
X-Google-Smtp-Source: ABdhPJzDH1iRuyqWQlacfkSchO7Jrpdzl5R2DoPVSb6Jyrvoc7sAoy1svaTEMDPmiGZrsaUJZz32hTXBrWJGsPebnhc=
X-Received: by 2002:aa7:dad1:: with SMTP id x17mr22551283eds.47.1620232096198;
 Wed, 05 May 2021 09:28:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1620200410.git.kai.huang@intel.com> <817eae486273adad0a622671f628c5a99b72a375.1620200410.git.kai.huang@intel.com>
In-Reply-To: <817eae486273adad0a622671f628c5a99b72a375.1620200410.git.kai.huang@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 5 May 2021 09:28:05 -0700
Message-ID: <CANgfPd_gWZB9NMjzsZ-v61e=p53WytCR1qm_28vRg6bdESD1fQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: Fix TDP MMU page table level
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 5, 2021 at 2:38 AM Kai Huang <kai.huang@intel.com> wrote:
>
> TDP MMU iterator's level is identical to page table's actual level.  For
> instance, for the last level page table (whose entry points to one 4K
> page), iter->level is 1 (PG_LEVEL_4K), and in case of 5 level paging,
> the iter->level is mmu->shadow_root_level, which is 5.  However, struct
> kvm_mmu_page's level currently is not set correctly when it is allocated
> in kvm_tdp_mmu_map().  When iterator hits non-present SPTE and needs to
> allocate a new child page table, currently iter->level, which is the
> level of the page table where the non-present SPTE belongs to, is used.
> This results in struct kvm_mmu_page's level always having its parent's
> level (excpet root table's level, which is initialized explicitly using
> mmu->shadow_root_level).  This is kinda wrong, and not consistent with
> existing non TDP MMU code.  Fortuantely the sp->role.level is only used
> in handle_removed_tdp_mmu_page(), which apparently is already aware of
> this, and handles correctly.  However to make it consistent with non TDP
> MMU code (and fix the issue that both root page table and any child of
> it having shadow_root_level), fix this by using iter->level - 1 in
> kvm_tdp_mmu_map().  Also modify handle_removed_tdp_mmu_page() to handle
> such change.

Ugh. Thank you for catching this. This is going to take me a bit to
review as I should audit the code more broadly for this problem in the
TDP MMU.
It would probably also be a good idea to add a comment on the level
field to say that it represents the level of the SPTEs in the
associated page, not the level of the SPTE that links to the
associated page.
Hopefully that will prevent similar future misunderstandings.

>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index debe8c3ec844..bcfb87e1c06e 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -335,7 +335,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
>
>         for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
>                 sptep = rcu_dereference(pt) + i;
> -               gfn = base_gfn + (i * KVM_PAGES_PER_HPAGE(level - 1));
> +               gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
>
>                 if (shared) {
>                         /*
> @@ -377,12 +377,12 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
>                         WRITE_ONCE(*sptep, REMOVED_SPTE);
>                 }
>                 handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
> -                                   old_child_spte, REMOVED_SPTE, level - 1,
> +                                   old_child_spte, REMOVED_SPTE, level,
>                                     shared);
>         }
>
>         kvm_flush_remote_tlbs_with_address(kvm, gfn,
> -                                          KVM_PAGES_PER_HPAGE(level));
> +                                          KVM_PAGES_PER_HPAGE(level + 1));
>
>         call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
> @@ -1009,7 +1009,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>                 }
>
>                 if (!is_shadow_present_pte(iter.old_spte)) {
> -                       sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
> +                       sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
>                         child_pt = sp->spt;
>
>                         new_spte = make_nonleaf_spte(child_pt,
> --
> 2.31.1
>
