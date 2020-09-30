Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EE327F532
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 00:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731339AbgI3WeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 18:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3WeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 18:34:03 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B17DC0613D0
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 15:34:02 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g7so4262572iov.13
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 15:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+S9ma2h9nZrG9Sat/6z/ehgUrIx5BYnTDTi/tV6A6k4=;
        b=I3B14Ii7kuDQDslqdcm/IPjckSxnWQUi4OXiqFU5KnR6INOv6VpiNMsKafQ5WPIWKg
         y2bajmGzD1rNhvlzwFClWar0ikBP4/uBWoA0C5AIioOc9u5Qy+hLDKGyiJuDAig84rJh
         nvY5JO9BFmvI4PaW1xUI39uEIaKeW/xIF0Es347XU7ez+qoUU6h+16taGC2220lkx2gj
         jHPKf+0/YkVuJj29oS5lvnIYbm/umJ1IFWfA0PteJzWDPswwnDe9Gn6VhbByGJ6sN0Ze
         KFb0pNkX+tt1HhZx8sOK80US9EPdKzS9/kAz5ORuPm/wl3DRgUm9/tHFeCOrJCm8WC/K
         InOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+S9ma2h9nZrG9Sat/6z/ehgUrIx5BYnTDTi/tV6A6k4=;
        b=nR1aMEbiGoqRjqw5CFKQUcLURNJAi8DKBFHJdJemZV1hmmwGdXx6Z4zK+DlyFWyGeS
         2nT+IqMLCqm8rWo+qbFGN0T8wAhzNL10ycHBLYqQfhKAc0tAWXSytKI8mZo99466lJwU
         LDxbc6xtj120UJsZfL2q2J8iqj8rn70NxDvbFRcg3aZiBVQv6ReasJof5Oh9EAOyTQrw
         8Q1/CVGiPED2yF4IE7Sn/aDQpZjAJG98pAe4Y+OAQiYas8g/K9NGls9s+zfyUGdjW7Zn
         N0FMhiZ8wAG+t0PqyrjDr0ioUAcTXTwVFVHZMjpRrjfuZOFVkZy+oxTwZSVwzqNECNwi
         vPTg==
X-Gm-Message-State: AOAM530K5Hwy1T+wEjNaZdA5OcDBtGE4kA2oaCK3jicpFZ/6Z+mMEwNY
        pdoWyxY7YdB94SjaTy+rQvZUwYMuZSEe4silhOB79w==
X-Google-Smtp-Source: ABdhPJwLWfY5kfVzNFAU16o9aKJQSSccovFArV9jJq7IdHkyon92S/JDGl+GtDilvhp1G6pIJ7JPsrdWg3jKU46iWPY=
X-Received: by 2002:a05:6638:1643:: with SMTP id a3mr3730239jat.4.1601505241093;
 Wed, 30 Sep 2020 15:34:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-21-bgardon@google.com>
 <20200930181556.GJ32672@linux.intel.com> <d2bcf512-00f3-8499-420d-b31690bdb511@redhat.com>
In-Reply-To: <d2bcf512-00f3-8499-420d-b31690bdb511@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 30 Sep 2020 15:33:50 -0700
Message-ID: <CANgfPd9h_Epb8qZZ6qCP5BKD0DOYv5v2NQm-J2ajq9_wXfWb1g@mail.gmail.com>
Subject: Re: [PATCH 20/22] kvm: mmu: NX largepage recovery for TDP MMU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 30, 2020 at 12:56 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 30/09/20 20:15, Sean Christopherson wrote:
> > On Fri, Sep 25, 2020 at 02:23:00PM -0700, Ben Gardon wrote:
> >> +/*
> >> + * Clear non-leaf SPTEs and free the page tables they point to, if those SPTEs
> >> + * exist in order to allow execute access on a region that would otherwise be
> >> + * mapped as a large page.
> >> + */
> >> +void kvm_tdp_mmu_recover_nx_lpages(struct kvm *kvm)
> >> +{
> >> +    struct kvm_mmu_page *sp;
> >> +    bool flush;
> >> +    int rcu_idx;
> >> +    unsigned int ratio;
> >> +    ulong to_zap;
> >> +    u64 old_spte;
> >> +
> >> +    rcu_idx = srcu_read_lock(&kvm->srcu);
> >> +    spin_lock(&kvm->mmu_lock);
> >> +
> >> +    ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
> >> +    to_zap = ratio ? DIV_ROUND_UP(kvm->stat.nx_lpage_splits, ratio) : 0;
> >
> > This is broken, and possibly related to Paolo's INIT_LIST_HEAD issue.  The TDP
> > MMU never increments nx_lpage_splits, it instead has its own counter,
> > tdp_mmu_lpage_disallowed_page_count.  Unless I'm missing something, to_zap is
> > guaranteed to be zero and thus this is completely untested.
>
> Except if you do shadow paging (through nested EPT) and then it bombs
> immediately. :)
>
> > I don't see any reason for a separate tdp_mmu_lpage_disallowed_page_count,
> > a single VM can't have both a legacy MMU and a TDP MMU, so it's not like there
> > will be collisions with other code incrementing nx_lpage_splits.   And the TDP
> > MMU should be updating stats anyways.
>
> This is true, but having two counters is necessary (in the current
> implementation) because otherwise you zap more than the requested ratio
> of pages.
>
> The simplest solution is to add a "bool tdp_page" to struct
> kvm_mmu_page, so that you can have a single list of
> lpage_disallowed_pages and a single thread.  The while loop can then
> dispatch to the right "zapper" code.

I actually did add that bool in patch 4: kvm: mmu: Allocate and free
TDP MMU roots.
I'm a little nervous about putting them in the same list, but I agree
it would definitely simplify the implementation of reclaim.

>
> Anyway this patch is completely broken, so let's kick it away to the
> next round.

Understood, sorry I didn't test this one better. I'll incorporate your
feedback and include it in the next series.

>
> Paolo
>
> >> +
> >> +    while (to_zap &&
> >> +           !list_empty(&kvm->arch.tdp_mmu_lpage_disallowed_pages)) {
> >> +            /*
> >> +             * We use a separate list instead of just using active_mmu_pages
> >> +             * because the number of lpage_disallowed pages is expected to
> >> +             * be relatively small compared to the total.
> >> +             */
> >> +            sp = list_first_entry(&kvm->arch.tdp_mmu_lpage_disallowed_pages,
> >> +                                  struct kvm_mmu_page,
> >> +                                  lpage_disallowed_link);
> >> +
> >> +            old_spte = *sp->parent_sptep;
> >> +            *sp->parent_sptep = 0;
> >> +
> >> +            list_del(&sp->lpage_disallowed_link);
> >> +            kvm->arch.tdp_mmu_lpage_disallowed_page_count--;
> >> +
> >> +            handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), sp->gfn,
> >> +                                old_spte, 0, sp->role.level + 1);
> >> +
> >> +            flush = true;
> >> +
> >> +            if (!--to_zap || need_resched() ||
> >> +                spin_needbreak(&kvm->mmu_lock)) {
> >> +                    flush = false;
> >> +                    kvm_flush_remote_tlbs(kvm);
> >> +                    if (to_zap)
> >> +                            cond_resched_lock(&kvm->mmu_lock);
> >> +            }
> >> +    }
> >> +
> >> +    if (flush)
> >> +            kvm_flush_remote_tlbs(kvm);
> >> +
> >> +    spin_unlock(&kvm->mmu_lock);
> >> +    srcu_read_unlock(&kvm->srcu, rcu_idx);
> >> +}
> >> +
> >> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> >> index 2ecb047211a6d..45ea2d44545db 100644
> >> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> >> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> >> @@ -43,4 +43,6 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
> >>
> >>  bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
> >>                                 struct kvm_memory_slot *slot, gfn_t gfn);
> >> +
> >> +void kvm_tdp_mmu_recover_nx_lpages(struct kvm *kvm);
> >>  #endif /* __KVM_X86_MMU_TDP_MMU_H */
> >> --
> >> 2.28.0.709.gb0816b6eb0-goog
> >>
> >
>
