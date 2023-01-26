Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D14D67C292
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 02:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjAZBt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 20:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjAZBtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 20:49:25 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7356A5CE4E
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 17:49:22 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id k10-20020a17090a590a00b0022ba875a1a4so3955899pji.3
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 17:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0GIXSkqWsOL4LYeNVjWDqEt8M4vKe5peV/aIO4Q0JxA=;
        b=IVUCYlXUHWU+ha/IWSmaiUP0Jtu9T8FevanWGooIACSRtHg7fnMIJ+OIK9DrT9WWAW
         9j7eJsDuwf4/HHY2AlAN/45eJgR812tlJShQDI0JO3KbAaWARXQRb5FZ2OdUqeb/UE0f
         xqIeVzEIqTRQiBxApMVxXrRPrg8/mRycw5MkwBBkcprY66EX0jmWdJGFID8UCWzgH+1R
         psx+6eWWBxao4kxvakS/laQ1s1hoj1bLORvWSZWvENDsBOKzQWxBz7Tapn+NL2tetkEd
         Z6a9Pdb9QP2w9r/uQ/8OBPQbUQ+6fHOWRvhOR+l1RXAYYvMjf3iVnwMUyNqM9M5xmC2a
         Xjiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0GIXSkqWsOL4LYeNVjWDqEt8M4vKe5peV/aIO4Q0JxA=;
        b=YFcS2Bpy2y3yDop4/2vOQRDeonMLOSbAqcYTKmv9sgBSOsxgqIVmcRsazAT38BKqls
         sv0NPJTXlfqkm1mbBJO4X9Qg0wOMEGpdK0y+NfLjzQ4CcbDKxp9GhfPGNNKV2qn22iNL
         bIIE/S0V3s8UtreR/ed0XpiKiwb0xMQMkKhrJ4gcROJFUQMi5Gfs+FlzNhrhiRWDyF/c
         /5/4/6JLRAviAAPmrEsn7B8aUlrtGEvMMl0waJOb9NqrouuEsE1lu0BodAXWGrqAfLMx
         uKsJgnaoeJZJnCNzdew3vL9SkuoM1r2o671ik3SKEwOCVbJcG5yjmGLQwjFm4aeuttTj
         KAKA==
X-Gm-Message-State: AO0yUKWpcw2LAHinq7NObJnQezm9cds+rgn7HcQDJIla25xViFlugfaG
        W3R1w8oyCJf4ocJWDfgV4nfryg==
X-Google-Smtp-Source: AK7set8J1hVSdsZix/AxSg8sieW2hOiyhSil/L9fQ6UUbBBHASafbnlJcHmafDJbOv6AIzh9x0ealQ==
X-Received: by 2002:a05:6a20:a696:b0:b8:ca86:f3ab with SMTP id ba22-20020a056a20a69600b000b8ca86f3abmr989768pzb.2.1674697761633;
        Wed, 25 Jan 2023 17:49:21 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w14-20020a170902e88e00b00194d8a98a20sm64444plg.46.2023.01.25.17.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 17:49:21 -0800 (PST)
Date:   Thu, 26 Jan 2023 01:49:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch] KVM: x86/mmu: Make optimized __handle_changed_spte() for
 clear dirty log
Message-ID: <Y9HcHRBShQgjxsQb@google.com>
References: <20230125213857.824959-1-vipinsh@google.com>
 <Y9GmiyRQ6sULCjEG@google.com>
 <CANgfPd9T7jdh1Cjjo4y6DcxC2poTaGhQ7wNLf6OgGtStg-yKJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9T7jdh1Cjjo4y6DcxC2poTaGhQ7wNLf6OgGtStg-yKJg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 25, 2023, Ben Gardon wrote:
> On Wed, Jan 25, 2023 at 2:00 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Wed, Jan 25, 2023 at 01:38:57PM -0800, Vipin Sharma wrote:
> > > Use a tone down version of __handle_changed_spte() when clearing dirty
> > > log. Remove checks which will not be needed when dirty logs are cleared.
> > >
> > > This change shows ~13% improvement in clear dirty log calls in
> > > dirty_log_perf_test
> > >
> > > Before tone down version:
> > > Clear dirty log over 3 iterations took 10.006764203s. (Avg 3.335588067s/iteration)
> > >
> > > After tone down version:
> > > Clear dirty log over 3 iterations took 8.686433554s. (Avg 2.895477851s/iteration)
> > >
> > > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/tdp_mmu.c | 20 +++++++++++++++++++-
> > >  1 file changed, 19 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index bba33aea0fb0..ca21b33c4386 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -504,6 +504,19 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
> > >       call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
> > >  }
> > >
> > > +static void handle_changed_spte_clear_dirty_log(int as_id, gfn_t gfn,
> > > +                                             u64 old_spte, u64 new_spte,
> > > +                                             int level)
> > > +{
> > > +     if (old_spte == new_spte)
> > > +             return;
> > > +
> > > +     trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
> > > +
> > > +     if (is_dirty_spte(old_spte) &&  !is_dirty_spte(new_spte))
> > > +             kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> > > +}
> > > +
> > >  /**
> > >   * __handle_changed_spte - handle bookkeeping associated with an SPTE change
> > >   * @kvm: kvm instance
> > > @@ -736,7 +749,12 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> > >
> > >       old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
> > >
> > > -     __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
> > > +     if (record_dirty_log)
> > > +             __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte,
> > > +                                   level, false);
> > > +     else
> > > +             handle_changed_spte_clear_dirty_log(as_id, gfn, old_spte,
> > > +                                                 new_spte, level);
> >
> > I find it very non-intuitive to tie this behavior to !record_dirty_log,
> > even though it happens to work. It's also risky if any future calls are
> > added that pass record_dirty_log=false but change other bits in the
> > SPTE.
> >
> > I wonder if we could get the same effect by optimizing
> > __handle_changed_spte() to check for a cleared D-bit *first* and if
> > that's the only diff between the old and new SPTE, bail immediately
> > rather than doing all the other checks.
> 
> I would also prefer that course. One big lesson I took when building
> the TDP MMU was the value of having all the changed PTE handling go
> through one function. That's not always the right choice but the
> Shadow MMU has a crazy spaghetti code of different functions which
> handle different parts of responding to a PTE change and it makes the
> code very hard to read. I agree this path is worth optimizing, but the
> more we can keep the code together, the better.

Hrm, not sure I agree on that last point.  I find record_dirty_log and record_acc_track
to be eye sores and terribly confusing (I always forget when they're true/false).
I think we would end up with cleaner code overall if we special case clearing A/D
bits (or their write-protected/access-protect counterparts).

handle_changed_spte_dirty_log() takes effect if and only a SPTE becomes newly
writable, and that should never happen when aging gfns (record_acc_track=%false),
i.e. neither the "age gfns" nor the "clear dirty" paths need to call
handle_changed_spte_dirty_log(), which means @record_dirty_log is superfluous.  

Similarly, clearing dirty bits should never clear the accessed bit, nor should it
toggle PRESENT or change the PFN, i.e. neither path needs to call
handle_changed_spte_acc_track(), which means @record_acc_track is superfluous too.

If we jettison those, then AFAICT the only remaining heuristic is that
tdp_mmu_set_spte_atomic() doesn't update the dirty bitmaps (the comment about
that behavior is unhelpful and doesn't explain _why_).  That heuristic is easy to
handled by looking at @shared.

Looking through all the other stuff in __handle_changed_spte()...

I'm 100% comfortable skipping these sanity checks:

	if (was_leaf && is_leaf && pfn_changed)
		BUG();

	if (is_leaf)
		check_spte_writable_invariants(new_spte);

	if (!was_present && !is_present)
		WARN_ON(!MMIO && !REMOVED);

And none of these are relevant (again assuming we don't have an egregious bug)
except for the kvm_set_pfn_dirty() case, which is trivial to handle.

	if (is_leaf != was_leaf)
		kvm_update_page_stats(kvm, level, is_leaf ? 1 : -1);

	if (was_leaf && is_dirty_spte(old_spte) &&
	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
		kvm_set_pfn_dirty(spte_to_pfn(old_spte));

	/*
	 * Recursively handle child PTs if the change removed a subtree from
	 * the paging structure.  Note the WARN on the PFN changing without the
	 * SPTE being converted to a hugepage (leaf) or being zapped.  Shadow
	 * pages are kernel allocations and should never be migrated.
	 */
	if (was_present && !was_leaf &&
	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);


So unless I'm missing something, I think we can end up with the below.  Compile
tested only...

---
 arch/x86/kvm/mmu/tdp_mmu.c | 92 ++++++++++----------------------------
 1 file changed, 24 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bba33aea0fb0..2f78ca43a276 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -505,7 +505,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 }
 
 /**
- * __handle_changed_spte - handle bookkeeping associated with an SPTE change
+ * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
  * @as_id: the address space of the paging structure the SPTE was a part of
  * @gfn: the base GFN that was mapped by the SPTE
@@ -519,9 +519,9 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * Handle bookkeeping that might result from the modification of a SPTE.
  * This function must be called for all TDP SPTE modifications.
  */
-static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				  u64 old_spte, u64 new_spte, int level,
-				  bool shared)
+static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
+				u64 old_spte, u64 new_spte, int level,
+				bool shared)
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
@@ -605,23 +605,18 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	if (was_present && !was_leaf &&
 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
-}
 
-static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared)
-{
-	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
-			      shared);
 	handle_changed_spte_acc_track(old_spte, new_spte, level);
-	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
-				      new_spte, level);
+
+	/* COMMENT GOES HERE. */
+	if (!shared)
+		handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
+					      new_spte, level);
 }
 
 /*
  * tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically
- * and handle the associated bookkeeping.  Do not mark the page dirty
- * in KVM's dirty bitmaps.
+ * and handle the associated bookkeeping.
  *
  * If setting the SPTE fails because it has changed, iter->old_spte will be
  * refreshed to the current value of the spte.
@@ -658,9 +653,8 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
 		return -EBUSY;
 
-	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, true);
-	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
+	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
+			    new_spte, iter->level, true);
 
 	return 0;
 }
@@ -705,23 +699,12 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
  * @new_spte:	      The new value that will be set for the SPTE
  * @gfn:	      The base GFN that was (or will be) mapped by the SPTE
  * @level:	      The level _containing_ the SPTE (its parent PT's level)
- * @record_acc_track: Notify the MM subsystem of changes to the accessed state
- *		      of the page. Should be set unless handling an MMU
- *		      notifier for access tracking. Leaving record_acc_track
- *		      unset in that case prevents page accesses from being
- *		      double counted.
- * @record_dirty_log: Record the page as dirty in the dirty bitmap if
- *		      appropriate for the change being made. Should be set
- *		      unless performing certain dirty logging operations.
- *		      Leaving record_dirty_log unset in that case prevents page
- *		      writes from being double counted.
  *
  * Returns the old SPTE value, which _may_ be different than @old_spte if the
  * SPTE had voldatile bits.
  */
 static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
-			      u64 old_spte, u64 new_spte, gfn_t gfn, int level,
-			      bool record_acc_track, bool record_dirty_log)
+			      u64 old_spte, u64 new_spte, gfn_t gfn, int level)
 {
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
@@ -736,46 +719,18 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
 
-	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
-
-	if (record_acc_track)
-		handle_changed_spte_acc_track(old_spte, new_spte, level);
-	if (record_dirty_log)
-		handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
-					      new_spte, level);
+	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
 	return old_spte;
 }
 
-static inline void _tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-				     u64 new_spte, bool record_acc_track,
-				     bool record_dirty_log)
+static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
+				     u64 new_spte)
 {
 	WARN_ON_ONCE(iter->yielded);
 
 	iter->old_spte = __tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep,
 					    iter->old_spte, new_spte,
-					    iter->gfn, iter->level,
-					    record_acc_track, record_dirty_log);
-}
-
-static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-				    u64 new_spte)
-{
-	_tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
-}
-
-static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
-						 struct tdp_iter *iter,
-						 u64 new_spte)
-{
-	_tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
-}
-
-static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
-						 struct tdp_iter *iter,
-						 u64 new_spte)
-{
-	_tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
+					    iter->gfn, iter->level);
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
@@ -925,7 +880,7 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 		return false;
 
 	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
-			   sp->gfn, sp->role.level + 1, true, true);
+			   sp->gfn, sp->role.level + 1);
 
 	return true;
 }
@@ -1289,8 +1244,7 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 		new_spte = mark_spte_for_access_track(new_spte);
 	}
 
-	tdp_mmu_set_spte_no_acc_track(kvm, iter, new_spte);
-
+	kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte, new_spte, iter->level);
 	return true;
 }
 
@@ -1326,7 +1280,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	 * Note, when changing a read-only SPTE, it's not strictly necessary to
 	 * zero the SPTE before setting the new PFN, but doing so preserves the
 	 * invariant that the PFN of a present * leaf SPTE can never change.
-	 * See __handle_changed_spte().
+	 * See handle_changed_spte().
 	 */
 	tdp_mmu_set_spte(kvm, iter, 0);
 
@@ -1351,7 +1305,7 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	/*
 	 * No need to handle the remote TLB flush under RCU protection, the
 	 * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
-	 * shadow page.  See the WARN on pfn_changed in __handle_changed_spte().
+	 * shadow page.  See the WARN on pfn_changed in handle_changed_spte().
 	 */
 	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
 }
@@ -1703,9 +1657,11 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 				new_spte = iter.old_spte & ~shadow_dirty_mask;
 			else
 				continue;
+
+			kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
 		}
 
-		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
+		kvm_tdp_mmu_write_spte(iter.sptep, iter.old_spte, new_spte, iter.level);
 	}
 
 	rcu_read_unlock();

base-commit: f15a87c006901e02727bf8ac75b0251cdf8e0ecc
-- 

