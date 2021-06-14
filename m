Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269FA3A7214
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 00:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhFNWhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 18:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhFNWhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 18:37:04 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0C2C061574
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 15:34:47 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id w31so7345210pga.6
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 15:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gDlYxVLTJVN+IzDe5ZymRop7HLbPaP8fyb3bx0VwOwg=;
        b=UdTI+64LznBBfRmLrc9RDAaskYZBeALSv4udd1LsyIZe1T2/r2ABa8+IIIp+1ekO/R
         wmOXhYDHn7jqslaNAUn8G/Zcu/q1KuAoK6Ur/kffEqADNz68aCL1tvzBMmC5sAH6TjMR
         CGe0FBVeGm/b+iN+cCFGEzv6NEPq2qkgAfQUS/gYaakQlLHtUBU/imAcw11mWBLZQVLj
         Z8hzJwOSlKQSdG2FR1Pz3Smbqm3kFshwZ4Izi8gpmLFQdxcPzT2tgqQajxCVc/G9Hz/G
         ZVcVA6uhBKpId7wxlgqa4bgH+Qja5GgXFNFqdNEkuRbh2uXEWyoyfhqVA+RK0NyLrnOs
         vi+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gDlYxVLTJVN+IzDe5ZymRop7HLbPaP8fyb3bx0VwOwg=;
        b=mf1ASL4t7l2GZGbLJtIBYEioRGNogghBNaR0/cEQt3rx62EGz6lrzsImqcXgXixVDo
         3RaevnwJlgQph5dePH6jdOoRpcoRvp6NVxKRtf+fMId4O+yURbcJuuFcCkeI4z1ZltNA
         hvZUDS65571Jnhp9biRzUi9wvnMPcnS4Py6ReWuasgPJ2mCqeQFIoY/7mh2nv254VBUj
         +9IoOtT5XtdbTBNA+lqFBSRSkmRDsKdi+9aGpnjwlRnwTpDxKVAGabhvQGTGojiGMsKu
         6BvzJKgJngfNYCERJuniYipJ66whXo9u/4YqhH/eTSOGVW+1MphOIexPDpDS2tlfD6gR
         4AXQ==
X-Gm-Message-State: AOAM5303i1+sUrUpNDlnf8X/hhX6BewDBfinqZRCoUKTorNsB+tpnNhl
        NAMqGO6TJLIGqddcC/QW6pdlPg==
X-Google-Smtp-Source: ABdhPJzo4Vo5Zo4Dz/L38yPl5qzNYWFdughWH3lj8AGFhIBLSiGym6s5xGZl6gB1fhtRq6VXK7j8Qw==
X-Received: by 2002:a63:a80b:: with SMTP id o11mr19434797pgf.53.1623710087197;
        Mon, 14 Jun 2021 15:34:47 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id t39sm13047961pfg.147.2021.06.14.15.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:34:46 -0700 (PDT)
Date:   Mon, 14 Jun 2021 22:34:42 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 6/8] KVM: x86/mmu: fast_page_fault support for the TDP MMU
Message-ID: <YMfZgufRGaW//gKE@google.com>
References: <20210611235701.3941724-1-dmatlack@google.com>
 <20210611235701.3941724-7-dmatlack@google.com>
 <CALzav=embwx9PoZrMSS3XkQsFjnAu4UyG8VBY=3yj8uqzKBgRg@mail.gmail.com>
 <CANgfPd97iUUduRi-faL4i3fMov7f67iU_LheeJzYoW=QnaHXLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd97iUUduRi-faL4i3fMov7f67iU_LheeJzYoW=QnaHXLg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 10:56:47AM -0700, Ben Gardon wrote:
> On Fri, Jun 11, 2021 at 4:59 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Fri, Jun 11, 2021 at 4:57 PM David Matlack <dmatlack@google.com> wrote:
> > >
> > > This commit enables the fast_page_fault handler to work when the TDP MMU
> > > is enabled by leveraging the new walk_shadow_page_lockless* API to
> > > collect page walks independent of the TDP MMU.
> > >
> > > fast_page_fault was already using
> > > walk_shadow_page_lockless_{begin,end}(), we just have to change the
> > > actual walk to use walk_shadow_page_lockless() which does the right
> > > thing if the TDP MMU is in use.
> > >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> >
> > Adding this feature was suggested by Ben Gardon:
> >
> > Suggested-by: Ben Gardon <bgardon@google.com>
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> 
> >
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 52 +++++++++++++++++-------------------------
> > >  1 file changed, 21 insertions(+), 31 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 765f5b01768d..5562727c3699 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -657,6 +657,9 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
> > >         local_irq_enable();
> > >  }
> > >
> > > +static bool walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
> > > +                                     struct shadow_page_walk *walk);
> > > +
> > >  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
> > >  {
> > >         int r;
> > > @@ -2967,14 +2970,9 @@ static bool page_fault_can_be_fast(u32 error_code)
> > >   * Returns true if the SPTE was fixed successfully. Otherwise,
> > >   * someone else modified the SPTE from its original value.
> > >   */
> > > -static bool
> > > -fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> > > -                       u64 *sptep, u64 old_spte, u64 new_spte)
> > > +static bool fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, gpa_t gpa,
> > > +                                   u64 *sptep, u64 old_spte, u64 new_spte)
> > >  {
> > > -       gfn_t gfn;
> > > -
> > > -       WARN_ON(!sp->role.direct);
> > > -
> > >         /*
> > >          * Theoretically we could also set dirty bit (and flush TLB) here in
> > >          * order to eliminate unnecessary PML logging. See comments in
> > > @@ -2990,14 +2988,8 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> > >         if (cmpxchg64(sptep, old_spte, new_spte) != old_spte)
> > >                 return false;
> > >
> > > -       if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
> > > -               /*
> > > -                * The gfn of direct spte is stable since it is
> > > -                * calculated by sp->gfn.
> > > -                */
> > > -               gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
> > > -               kvm_vcpu_mark_page_dirty(vcpu, gfn);
> > > -       }
> > > +       if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
> > > +               kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
> 
> I love how cleanly you've implemented TDP MMU fast PF support here
> with so little code duplication. I think this approach will work well.
> 
> My only reservation is that this links the way we locklessly change
> (and handle changes to) SPTEs between the TDP and legacy MMUs.
> 
> fast_pf_fix_direct_spte is certainly a much simpler function than
> tdp_mmu_set_spte_atomic, but it might be worth adding a comment
> explaining that the function can modify SPTEs in a TDP MMU paging
> structure. Alternatively, fast_page_fault could call
> tdp_mmu_set_spte_atomic, but I don't know if that would carry a
> performance penalty. On the other hand, the handling for this
> particular type of SPTE modification is unlikely to change, so it
> might not matter.

I'm open to delegating the cmpxchg64 to separate functions for the TDP
and legacy MMU, but didn't see any reason why it would be necessary.
That combined with the fact that it would require a bunch of new code
and helper functions in the TDP MMU (e.g. tdp_mmu_set_spte_atomic has to
be split up further so it doesn't do the lockdep check) led me to just
re-use fast_pf_fix_direct_spte.

I can add a comment though in v2 in fast_pf_fix_direct_spte and another
in tdp_mmu_set_spte_atomic explaining how the two interact.

> 
> 
> 
> > >
> > >         return true;
> > >  }
> > > @@ -3019,10 +3011,9 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
> > >   */
> > >  static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
> > >  {
> > > -       struct kvm_shadow_walk_iterator iterator;
> > > -       struct kvm_mmu_page *sp;
> > >         int ret = RET_PF_INVALID;
> > >         u64 spte = 0ull;
> > > +       u64 *sptep = NULL;
> > >         uint retry_count = 0;
> > >
> > >         if (!page_fault_can_be_fast(error_code))
> > > @@ -3031,17 +3022,19 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
> > >         walk_shadow_page_lockless_begin(vcpu);
> > >
> > >         do {
> > > +               struct shadow_page_walk walk;
> > >                 u64 new_spte;
> > >
> > > -               for_each_shadow_entry_lockless(vcpu, gpa, iterator, spte)
> > > -                       if (!is_shadow_present_pte(spte))
> > > -                               break;
> > > +               if (!walk_shadow_page_lockless(vcpu, gpa, &walk))
> > > +                       break;
> > > +
> > > +               spte = walk.sptes[walk.last_level];
> > > +               sptep = walk.spteps[walk.last_level];
> > >
> > >                 if (!is_shadow_present_pte(spte))
> > >                         break;
> > >
> > > -               sp = sptep_to_sp(iterator.sptep);
> > > -               if (!is_last_spte(spte, sp->role.level))
> > > +               if (!is_last_spte(spte, walk.last_level))
> > >                         break;
> > >
> > >                 /*
> > > @@ -3084,7 +3077,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
> > >                          *
> > >                          * See the comments in kvm_arch_commit_memory_region().
> > >                          */
> > > -                       if (sp->role.level > PG_LEVEL_4K)
> > > +                       if (walk.last_level > PG_LEVEL_4K)
> > >                                 break;
> > >                 }
> > >
> > > @@ -3098,8 +3091,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
> > >                  * since the gfn is not stable for indirect shadow page. See
> > >                  * Documentation/virt/kvm/locking.rst to get more detail.
> > >                  */
> > > -               if (fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte,
> > > -                                           new_spte)) {
> > > +               if (fast_pf_fix_direct_spte(vcpu, gpa, sptep, spte, new_spte)) {
> > >                         ret = RET_PF_FIXED;
> > >                         break;
> > >                 }
> > > @@ -3112,7 +3104,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
> > >
> > >         } while (true);
> > >
> > > -       trace_fast_page_fault(vcpu, gpa, error_code, iterator.sptep, spte, ret);
> > > +       trace_fast_page_fault(vcpu, gpa, error_code, sptep, spte, ret);
> > >         walk_shadow_page_lockless_end(vcpu);
> > >
> > >         return ret;
> > > @@ -3748,11 +3740,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> > >         if (page_fault_handle_page_track(vcpu, error_code, gfn))
> > >                 return RET_PF_EMULATE;
> > >
> > > -       if (!is_vcpu_using_tdp_mmu(vcpu)) {
> > > -               r = fast_page_fault(vcpu, gpa, error_code);
> > > -               if (r != RET_PF_INVALID)
> > > -                       return r;
> > > -       }
> > > +       r = fast_page_fault(vcpu, gpa, error_code);
> > > +       if (r != RET_PF_INVALID)
> > > +               return r;
> > >
> > >         r = mmu_topup_memory_caches(vcpu, false);
> > >         if (r)
> > > --
> > > 2.32.0.272.g935e593368-goog
> > >
