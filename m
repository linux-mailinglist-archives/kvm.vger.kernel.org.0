Return-Path: <kvm+bounces-17585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF7FB8C82E4
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 11:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2CB81C20E87
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 09:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC672260B;
	Fri, 17 May 2024 09:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lLkhmaEj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5011EB35;
	Fri, 17 May 2024 09:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715936631; cv=none; b=VyZgV0KhDobLNEAlyt4jZqi0lgBAcm8O4rqKiaSGrZm/NcnHMpR2l03LD1nObfBK5rpmnMczqU5o42Svw2md8uWKj6PO4CDP66QV21MG7krGo5ioEkQ20wz6sMxu7iUPdKZ+SNR7bNimoTEDkYv3dSh6sbPsoKsvdmQ1XaJ7R/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715936631; c=relaxed/simple;
	bh=KGnT9dOigV3G8bUpIaLkg23bvq1StkcJPvLoiSqZ480=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UuJjiIvZin2jbzoyufm/VyFs4M0YVDOKW629CHE2vucQCSHG5fcx8Gwo6x8uQD3iC7sl2/9rG+zg/pH59OS4tdvxy6TM3NITyF57l1JJ6onV/r2iuQ5cer3I+3qvJ34QMXya2Tnn/9oCZWyC40qL0GwOecTb8D5yLi7bswgwCBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lLkhmaEj; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715936630; x=1747472630;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=KGnT9dOigV3G8bUpIaLkg23bvq1StkcJPvLoiSqZ480=;
  b=lLkhmaEji9oe0XrGFQXY87J9Ua7BlPJS0OEWkPcmZb9gk6D3pfiaa12T
   xBNJHs9/kesGWr3TsB3xTXwxzZ2AcCqOGHCP3Rc9beF9u3a9ojS/OyyL4
   bNse1S8GHCKPcf/0lU7JtE9fKhAft7NAJe0CwnzmVKCIvRh1roN98CYlA
   r/on5MSexky3ooIkM9NHBd7YKZ3qGfTK1TfbBY831uapN0xD546ZfddNu
   qYGXk56HHKunYvpa8OqEaFcctoCIaT13PUSRkaqPN1zhVZBjh7ncx3iNi
   U6YubmfClAPeDDXYgze0P3HaRKcmA2421pmZSwpKDdMv334KRv+IEByVP
   Q==;
X-CSE-ConnectionGUID: rhgWhCnKSCqBJ6OHfzv/6Q==
X-CSE-MsgGUID: wwHXnd9AToCnfInNU49iEQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11944676"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="11944676"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 02:03:49 -0700
X-CSE-ConnectionGUID: byZhhVS1Qaqwjp+G+UDygg==
X-CSE-MsgGUID: y44izXXlQZCispXPY1A5yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="36294632"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 02:03:49 -0700
Date: Fri, 17 May 2024 02:03:48 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240517090348.GN168153@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
 <20240516194209.GL168153@ls.amr.corp.intel.com>
 <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>

On Fri, May 17, 2024 at 02:35:46AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> Here is a diff of an attempt to merge all the feedback so far. It's on top of
> the the dev branch from this series.
> 
> On Thu, 2024-05-16 at 12:42 -0700, Isaku Yamahata wrote:
> > - rename role.is_private => role.is_mirrored_pt
> 
> Agreed.
> 
> > 
> > - sp->gfn: gfn without shared bit.
> > 
> > - fault->address: without gfn_shared_mask
> >   Actually it doesn't matter much.  We can use gpa with gfn_shared_mask.
> 
> I left fault->addr with shared bits. It's not used anymore for TDX except in the
> tracepoint which I think makes sense.

As discussed with Kai [1], make fault->addr represent the real fault address.

[1] https://lore.kernel.org/kvm/20240517081440.GM168153@ls.amr.corp.intel.com/

> 
> > 
> > - Update struct tdp_iter
> >   struct tdp_iter
> >     gfn: gfn without shared bit
> > 
> >     /* Add new members */
> > 
> >     /* Indicates which PT to walk. */
> >     bool mirrored_pt;
> > 
> >     // This is used tdp_iter_refresh_sptep()
> >     // shared gfn_mask if mirrored_pt
> >     // 0 if !mirrored_pt
> >     gfn_shared_mask
> > 
> > - Pass mirrored_pt and gfn_shared_mask to
> >   tdp_iter_start(..., mirrored_pt, gfn_shared_mask)
> > 
> >   and update tdp_iter_refresh_sptep()
> >   static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
> >         ...
> >         iter->sptep = iter->pt_path[iter->level - 1] +
> >                 SPTE_INDEX((iter->gfn << PAGE_SHIFT) | iter->gfn_shared_mask,
> > iter->level);
> 
> I tried something else. The iterators still have gfn's with shared bits, but the
> addition of the shared bit is wrapped in tdp_mmu_for_each_pte(), so
> kvm_tdp_mmu_map() and similar don't have to handle the shared bits. They just
> pass in a root, and tdp_mmu_for_each_pte() knows how to adjust the GFN. Like:
> 
> #define tdp_mmu_for_each_pte(_iter, _kvm, _root, _start, _end)	\
> 	for_each_tdp_pte(_iter, _root,	\
> 			 kvm_gfn_for_root(_kvm, _root, _start), \
> 			 kvm_gfn_for_root(_kvm, _root, _end))

I'm wondering to remove kvm_gfn_for_root() at all.


> I also changed the callers to use the new enum to specify roots. This way they
> can pass something with a nice name instead of true/false for bool private.

This is nice.


> Keeping a gfn_shared_mask inside the iterator didn't seem more clear to me, and
> bit more cumbersome. But please compare it.
> 
> > 
> >   Change for_each_tdp_mte_min_level() accordingly.
> >   Also the iteretor to call this.
> >    
> >   #define for_each_tdp_pte_min_level(kvm, iter, root, min_level, start,
> > end)      \
> >           for (tdp_iter_start(&iter, root, min_level,
> > start,                      \
> >                mirrored_root, mirrored_root ? kvm_gfn_shared_mask(kvm) :
> > 0);      \
> >                iter.valid && iter.gfn < kvm_gfn_for_root(kvm, root,
> > end);         \
> >                tdp_iter_next(&iter))
> 
> I liked it a lot because the callers don't need to manually call
> kvm_gfn_for_root() anymore. But I tried it and it required a lot of additions of
> kvm to the iterators call sites. I ended up removing it, but I'm not sure.

...

> > - Update spte handler (handle_changed_spte(), handle_removed_pt()...),
> >   use iter->mirror_pt or pass down mirror_pt.
> 
> You mean just rename it, or something else?

I scratch this. I thought Kai didn't like to use role [2].
But now it seems okay. [3]

[2] https://lore.kernel.org/kvm/4ba18e4e-5971-4683-82eb-63c985e98e6b@intel.com/
  > I don't think using kvm_mmu_page.role is correct.

[3] https://lore.kernel.org/kvm/20240517081440.GM168153@ls.amr.corp.intel.com/
  > I think you can just get @mirrored_pt from the sptep:
  >  mirrored_pt = sptep_to_sp(sptep)->role.mirrored_pt;


> Anyway below is a first cut based on the discussion.
> 
> A few other things:
> 1. kvm_is_private_gpa() is moved into Intel code. kvm_gfn_shared_mask() remains
> for only two operations in common code:
>  - kvm_gfn_for_root() <- required for zapping/mapping
>  - Stripping the bit when setting fault.gfn <- possible to remove if we strip
> cr2_or_gpa
> 2. I also played with changing KVM_PRIVATE_ROOTS to KVM_MIRROR_ROOTS.
> Unfortunately there is still some confusion between private and mirrored. For
> example you walk a mirror root (what is actually happening), but you have to
> allocate private page tables as you do, as well as call out to x86_ops named
> private. So those concepts are effectively linked and used a bit
> interchangeably.

On top of your patch, I created the following patch to remove kvm_gfn_for_root().
Although I haven't tested it yet, I think the following shows my idea.

- Add gfn_shared_mask to struct tdp_iter.
- Use iter.gfn_shared_mask to determine the starting sptep in the root.
- Remove kvm_gfn_for_root()

---
 arch/x86/kvm/mmu/mmu_internal.h | 10 -------
 arch/x86/kvm/mmu/tdp_iter.c     |  5 ++--
 arch/x86/kvm/mmu/tdp_iter.h     | 16 ++++++-----
 arch/x86/kvm/mmu/tdp_mmu.c      | 48 ++++++++++-----------------------
 4 files changed, 26 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 2b1b2a980b03..9676af0cb133 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -180,16 +180,6 @@ static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_m
 	sp->private_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_private_spt_cache);
 }
 
-static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
-				     gfn_t gfn)
-{
-	gfn_t gfn_for_root = kvm_gfn_to_private(kvm, gfn);
-
-	/* Set shared bit if not private */
-	gfn_for_root |= -(gfn_t)!is_mirrored_sp(root) & kvm_gfn_shared_mask(kvm);
-	return gfn_for_root;
-}
-
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 04c247bfe318..c5f2ca1ceede 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -12,7 +12,7 @@
 static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
 {
 	iter->sptep = iter->pt_path[iter->level - 1] +
-		SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
+		SPTE_INDEX((iter->gfn | iter->gfn_shared_mask) << PAGE_SHIFT, iter->level);
 	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 }
 
@@ -37,7 +37,7 @@ void tdp_iter_restart(struct tdp_iter *iter)
  * rooted at root_pt, starting with the walk to translate next_last_level_gfn.
  */
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
-		    int min_level, gfn_t next_last_level_gfn)
+		    int min_level, gfn_t next_last_level_gfn, gfn_t gfn_shared_mask)
 {
 	if (WARN_ON_ONCE(!root || (root->role.level < 1) ||
 			 (root->role.level > PT64_ROOT_MAX_LEVEL))) {
@@ -46,6 +46,7 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 	}
 
 	iter->next_last_level_gfn = next_last_level_gfn;
+	iter->gfn_shared_mask = gfn_shared_mask;
 	iter->root_level = root->role.level;
 	iter->min_level = min_level;
 	iter->pt_path[iter->root_level - 1] = (tdp_ptep_t)root->spt;
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 8a64bcef9deb..274b42707f0a 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -91,8 +91,9 @@ struct tdp_iter {
 	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
 	/* A pointer to the current SPTE */
 	tdp_ptep_t sptep;
-	/* The lowest GFN (shared bits included) mapped by the current SPTE */
+	/* The lowest GFN (shared bits excluded) mapped by the current SPTE */
 	gfn_t gfn;
+	gfn_t gfn_shared_mask;
 	/* The level of the root page given to the iterator */
 	int root_level;
 	/* The lowest level the iterator should traverse to */
@@ -120,18 +121,19 @@ struct tdp_iter {
  * Iterates over every SPTE mapping the GFN range [start, end) in a
  * preorder traversal.
  */
-#define for_each_tdp_pte_min_level(iter, root, min_level, start, end) \
-	for (tdp_iter_start(&iter, root, min_level, start); \
-	     iter.valid && iter.gfn < end;		     \
+#define for_each_tdp_pte_min_level(iter, kvm, root, min_level, start, end) \
+	for (tdp_iter_start(&iter, root, min_level, start,			\
+			    is_mirrored_sp(root) ? 0: kvm_gfn_shared_mask(kvm)); \
+	     iter.valid && iter.gfn < end;					\
 	     tdp_iter_next(&iter))
 
-#define for_each_tdp_pte(iter, root, start, end) \
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end)
+#define for_each_tdp_pte(iter, kvm, root, start, end)				\
+	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_4K, start, end)
 
 tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
-		    int min_level, gfn_t next_last_level_gfn);
+		    int min_level, gfn_t next_last_level_gfn, gfn_t gfn_shared_mask);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f13016e210b..bf7aa87eb593 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -862,20 +862,18 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 					  iter->gfn, iter->level);
 }
 
-#define tdp_root_for_each_pte(_iter, _root, _start, _end) \
-	for_each_tdp_pte(_iter, _root, _start, _end)
+#define tdp_root_for_each_pte(_iter, _kvm, _root, _start, _end)	\
+	for_each_tdp_pte(_iter, _kvm, _root, _start, _end)
 
-#define tdp_root_for_each_leaf_pte(_iter, _root, _start, _end)	\
-	tdp_root_for_each_pte(_iter, _root, _start, _end)		\
+#define tdp_root_for_each_leaf_pte(_iter, _kvm, _root, _start, _end)	\
+	tdp_root_for_each_pte(_iter, _kvm, _root, _start, _end)		\
 		if (!is_shadow_present_pte(_iter.old_spte) ||		\
 		    !is_last_spte(_iter.old_spte, _iter.level))		\
 			continue;					\
 		else
 
 #define tdp_mmu_for_each_pte(_iter, _kvm, _root, _start, _end)	\
-	for_each_tdp_pte(_iter, _root,	\
-			 kvm_gfn_for_root(_kvm, _root, _start), \
-			 kvm_gfn_for_root(_kvm, _root, _end))
+	for_each_tdp_pte(_iter, _kvm, _root, _start, _end)
 
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
@@ -941,7 +939,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	gfn_t end = tdp_mmu_max_gfn_exclusive();
 	gfn_t start = 0;
 
-	for_each_tdp_pte_min_level(iter, root, zap_level, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, zap_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
@@ -1043,17 +1041,9 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	/*
-	 * start and end doesn't have GFN shared bit.  This function zaps
-	 * a region including alias.  Adjust shared bit of [start, end) if the
-	 * root is shared.
-	 */
-	start = kvm_gfn_for_root(kvm, root, start);
-	end = kvm_gfn_for_root(kvm, root, end);
-
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_4K, start, end) {
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
@@ -1448,19 +1438,9 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	 * into this helper allow blocking; it'd be dead, wasteful code.
 	 */
 	__for_each_tdp_mmu_root(kvm, root, range->slot->as_id, types) {
-		gfn_t start, end;
-
-		/*
-		 * For TDX shared mapping, set GFN shared bit to the range,
-		 * so the handler() doesn't need to set it, to avoid duplicated
-		 * code in multiple handler()s.
-		 */
-		start = kvm_gfn_for_root(kvm, root, range->start);
-		end = kvm_gfn_for_root(kvm, root, range->end);
-
 		rcu_read_lock();
 
-		tdp_root_for_each_leaf_pte(iter, root, start, end)
+		tdp_root_for_each_leaf_pte(iter, kvm, root, range->start, range->end)
 			ret |= handler(kvm, &iter, range);
 
 		rcu_read_unlock();
@@ -1543,7 +1523,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
 
-	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, min_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
@@ -1706,7 +1686,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	 * level above the target level (e.g. splitting a 1GB to 512 2MB pages,
 	 * and then splitting each of those to 512 4KB pages).
 	 */
-	for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, target_level + 1, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
@@ -1791,7 +1771,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	tdp_root_for_each_pte(iter, root, start, end) {
+	tdp_root_for_each_pte(iter, kvm, root, start, end) {
 retry:
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
@@ -1846,7 +1826,7 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	tdp_root_for_each_leaf_pte(iter, root, gfn + __ffs(mask),
+	tdp_root_for_each_leaf_pte(iter, kvm, root, gfn + __ffs(mask),
 				    gfn + BITS_PER_LONG) {
 		if (!mask)
 			break;
@@ -1903,7 +1883,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_2M, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
@@ -1973,7 +1953,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, min_level, gfn, gfn + 1) {
+	for_each_tdp_pte_min_level(iter, kvm, root, min_level, gfn, gfn + 1) {
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
-- 
2.43.2


-- 
Isaku Yamahata <isaku.yamahata@intel.com>

