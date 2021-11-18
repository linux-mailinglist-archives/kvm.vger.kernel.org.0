Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4429C455366
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 04:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241600AbhKRDct (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 22:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241189AbhKRDct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 22:32:49 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7831C061764
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 19:29:49 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id y7so4088466plp.0
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 19:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=crzDcYSZi8L4aYplsFhcOzsPsWzLzUkKamRcVYdq/tA=;
        b=XpSAvUy1V3gBE8rkrV9btimxEG8EG24Qme+PJBkUr+9fRBFowldLln/1B+dKUVb8ys
         H8n/OyE7tsadeUH3mPlo8moJ9nZ89PubBjH/9I+MbhmqC4axCRDKgYErLhzj0wOG7x88
         Tdos4HtMCmopmybmiE4bImOMhe+WVZBTh3Hk728RcDjxaP4NlYFrboUWyEDSSNu3ifUT
         z3G1OSmePAEP2bIMaK5sLWzVqYYW+es4VBaDJvi/9VbvYdMbkAFx5uiuug8nmckwb1vQ
         daIyYG7mMK2H1ud7fll5Yk6n8D9C1Pz0eKBE+dFqtnf3h3A2KYhvCdjFYkwe9s9EHO75
         /3fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=crzDcYSZi8L4aYplsFhcOzsPsWzLzUkKamRcVYdq/tA=;
        b=SYi9q+1jsX183JXfRGmdM1bK7nzB9oEfHrU8QfndNrRrFh4I7zMmZlrYrROambSwfT
         oMFd1LLUQhkWe/jdz2htw78cVpTchBsIUTvIamSYf1af1rGljXqwbUIYyWqwxx6HGUaA
         mPjRnh+GbfY4pJhk0Vwtci9gt2j6cwVmwtn4Nz0DSikMKhbu66lNEZTv/rEbqpHAobf5
         YT5KcH8Nu8QdO8W29KDpcB3FkkPTmOdkh92oRfGj/Zg46rnDBgN6r4m1uoLsLrE0dfjm
         F4Cz9usw9WkAoNVNAOyqK+8nH1sqmdELckV5dUAOibUnLedPOoAcys0BeJXdC5aZNvUY
         cCLA==
X-Gm-Message-State: AOAM533pzwQM4KXdcYGlK4cS0p/UoIhb7ab9cVd1jktyrP6VquzfAlIy
        Xddc6N7L4f91HIe0cWHtOIGwVQ==
X-Google-Smtp-Source: ABdhPJzh5ZckEW9vaQwRvLctBxnc9NWUs9KifaJzQNTJGWTpZtjiRSot33OcbkCM4KoQUnIcOyR8WA==
X-Received: by 2002:a17:90a:be0f:: with SMTP id a15mr6204873pjs.243.1637206188901;
        Wed, 17 Nov 2021 19:29:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t18sm872159pgv.21.2021.11.17.19.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 19:29:48 -0800 (PST)
Date:   Thu, 18 Nov 2021 03:29:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [RFC 11/19] KVM: x86/mmu: Factor shadow_zero_check out of
 make_spte
Message-ID: <YZXIqAHftH4d+B9Y@google.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-12-bgardon@google.com>
 <YZW02M0+YzAzBF/w@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZW02M0+YzAzBF/w@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021, Sean Christopherson wrote:
> On Wed, Nov 10, 2021, Ben Gardon wrote:
> > In the interest of devloping a version of make_spte that can function
> > without a vCPU pointer, factor out the shadow_zero_mask to be an
> > additional argument to the function.
> > 
> > No functional change intended.
> > 
> > 
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/spte.c | 11 +++++++----
> >  arch/x86/kvm/mmu/spte.h |  3 ++-
> >  2 files changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> > index b7271daa06c5..d3b059e96c6e 100644
> > --- a/arch/x86/kvm/mmu/spte.c
> > +++ b/arch/x86/kvm/mmu/spte.c
> > @@ -93,7 +93,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >  	       struct kvm_memory_slot *slot, unsigned int pte_access,
> >  	       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
> >  	       bool can_unsync, bool host_writable, bool ad_need_write_protect,
> > -	       u64 mt_mask, u64 *new_spte)
> > +	       u64 mt_mask, struct rsvd_bits_validate *shadow_zero_check,
> 
> Ugh, so I had a big email written about how I think we should add a module param
> to control 4-level vs. 5-level for all TDP pages, but then I realized it wouldn't
> work for nested EPT because that follows the root level used by L1.  We could
> still make a global non_nested_tdp_shadow_zero_check or whatever, but then make_spte()
> would have to do some work to find the right rsvd_bits_validate, and the end result
> would likely be a mess.
> 
> One idea to avoid exploding make_spte() would be to add a backpointer to the MMU
> in kvm_mmu_page.  I don't love the idea, but I also don't love passing in rsvd_bits_validate.

Another idea.  The only difference between 5-level and 4-level is that 5-level
fills in index [4], and I'm pretty sure 4-level doesn't touch that index.  For
PAE NPT (32-bit SVM), the shadow root level will never change, so that's not an issue.

Nested NPT is the only case where anything for an EPT/NPT MMU can change, because
that follows EFER.NX.

In other words, the non-nested TDP reserved bits don't need to be recalculated
regardless of level, they can just fill in 5-level and leave it be.

E.g. something like the below.  The sp->role.direct check could be removed if we
forced EFER.NX for nested NPT.

It's a bit ugly in that we'd pass both @kvm and @vcpu, so that needs some more
thought, but at minimum it means there's no need to recalc the reserved bits.

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 84e64dbdd89e..05db9b89dc53 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -95,10 +95,18 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
               u64 old_spte, bool prefetch, bool can_unsync,
               bool host_writable, u64 *new_spte)
 {
+       struct rsvd_bits_validate *rsvd_check;
        int level = sp->role.level;
        u64 spte = SPTE_MMU_PRESENT_MASK;
        bool wrprot = false;

+       if (vcpu) {
+               rsvd_check = vcpu->arch.mmu->shadow_zero_check;
+       } else {
+               WARN_ON_ONCE(!tdp_enabled || !sp->role.direct);
+               rsvd_check = tdp_shadow_rsvd_bits;
+       }
+
        if (sp->role.ad_disabled)
                spte |= SPTE_TDP_AD_DISABLED_MASK;
        else if (kvm_mmu_page_ad_need_write_protect(sp))
@@ -177,9 +185,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
        if (prefetch)
                spte = mark_spte_for_access_track(spte);

-       WARN_ONCE(is_rsvd_spte(&vcpu->arch.mmu->shadow_zero_check, spte, level),
+       WARN_ONCE(is_rsvd_spte(rsvd_check, spte, level),
                  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
-                 get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
+                 get_rsvd_bits(rsvd_check, spte, level));

        if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
                /* Enforced by kvm_mmu_hugepage_adjust. */
