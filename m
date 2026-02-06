Return-Path: <kvm+bounces-70464-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AHi8B88ohmmSKAQAu9opvQ
	(envelope-from <kvm+bounces-70464-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 18:45:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C595101542
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 18:45:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 89D5430804C3
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 17:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 011AE4219E8;
	Fri,  6 Feb 2026 17:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DJo/32dy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F6741C2FA
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 17:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770399701; cv=none; b=LSWbcBF6eBq+qxXSiSK5Al+2n1lUkWT8Z33AYzDUAF9DOysp9vDNvH+B4CfvhWzlfVm89QHvD3luUvdeyeLy6Xmv9t3iZUXKhsVfWYWAygm0eJIi0F9Bz/Xa+ahGHGxFysq5kNEQujRBbmreT3253seQBGd4aari6OzsEm9Jhig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770399701; c=relaxed/simple;
	bh=V8stX1MTslQ30U3kv1nbGCF1AkgXmGyyiE3ofC/i2rg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mWHLntu03pwIchqkZSvWDz8mGWTxEGC0Pn7Ktx2TSIgL23yxWV72N0T4cqaCykMP5kAo7YtD3AFq3MOj8WNaGFr0rS/HC8bUXlLTEPr/6wa3DkXhunX1cqTIbUL/GSnq2oG40XQTqzpduPNSdYPs1OTX84d1Maa99jGl73OaCiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DJo/32dy; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34e70e2e363so2280617a91.1
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 09:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770399700; x=1771004500; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NCUERx4Dj8SS7uxNo+P7/vk/wOPCa19vPc6SRYaH8Ps=;
        b=DJo/32dy7syKOzz8WzjSGyttZPNaS8TUVwNprYD6WSfHyUcF4mknN/SS6r4nXSuM6B
         yUIEaCTPTQgEpkHQpJM2zoAMv/8G0xjwRbLb14szPQz6VwBm40RM3U3K8hJvnGi3vwKp
         uASDBT0VFbLdlTWfWDYcj/6Fz3njclXU0l1o28Pbvtn5NiOCynedCCYUY/TjB8vdR2HH
         1YlXNRChbfDeUvYxqca1zXnKvtwIf9i+UMUzNOPtxefZLGMGtlnQNndv6whNsznM5ey7
         av0xoXVy/anSP4lhJo+HiCnWf6MZNaEU/VYFXdV55ngL8DinXj0rLrQKmmCLwwP5oMfL
         quQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770399700; x=1771004500;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NCUERx4Dj8SS7uxNo+P7/vk/wOPCa19vPc6SRYaH8Ps=;
        b=TsoyTIZ0g66FA21JkR9AbkSXA5cJn70NLh0y3bD/naKqbDRJtQmaFLzyCp7OLB9GPH
         1EzIjHHcproL1JtHVGcbAxPcP9KdVZNaxeGOWLkgrIEgDp38vqaG1ifyKzs7U2O87tNW
         XuCLME4hLIL3omcbnHwI2686QS8RUY3PzzkGhHubYPEsnPHx+FUjpZwAyOlZ1BXBv1pP
         mzhRR09F/UvnQUT5dg4+j7f6+lfp3IR8QZFk73Q+l+OvZM213GBTYTN50xYaohmHaxiU
         LWn1zpcqvgjAl+2ACxPDdfcmxARtwwkRK5CWacCuOh5oBk9ObPbPuJQmKWWglDfwq4pH
         663g==
X-Forwarded-Encrypted: i=1; AJvYcCXYYFLtENCDM3lRh14uJcoYAGJVCAvsD+iSz0GLwVH35X2frolTUgwp9ZWPc5sHFBD30Nw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy10e2MPtsdJ4HU8sg6VSzb5rXanXQMKk5DNpj4EKSvOZmdQdzd
	hGneOqnlIpyeWk/8cJ07m0nQ6H4ppnesj3GvVLsr6jFCLjz37p7/sLXElxrF+AUNPLLIQUSmneH
	XmzpaKg==
X-Received: from pjbmu14.prod.google.com ([2002:a17:90b:388e:b0:34c:2f52:23aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1802:b0:34c:6d33:7d34
 with SMTP id 98e67ed59e1d1-354b3be3325mr2946494a91.16.1770399700342; Fri, 06
 Feb 2026 09:41:40 -0800 (PST)
Date: Fri, 6 Feb 2026 09:41:38 -0800
In-Reply-To: <aYVPN5M7QQwu/r/n@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-9-seanjc@google.com>
 <aYMMHVvwDjZ7Lz9l@yzhao56-desk.sh.intel.com> <aYP_Ko3FGRriGXWR@google.com>
 <aYQtIK/Lq5T3ad6V@yzhao56-desk.sh.intel.com> <aYUarHf3KEwHGuJe@google.com> <aYVPN5M7QQwu/r/n@yzhao56-desk.sh.intel.com>
Message-ID: <aYYn0nf2cayYu8e7@google.com>
Subject: Re: [RFC PATCH v5 08/45] KVM: x86/mmu: Propagate mirror SPTE removal
 to S-EPT in handle_changed_spte()
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70464-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_TWELVE(0.00)[19];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 7C595101542
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Yan Zhao wrote:
> On Thu, Feb 05, 2026 at 02:33:16PM -0800, Sean Christopherson wrote:
> > On Thu, Feb 05, 2026, Yan Zhao wrote:
> > > > > >  	if (was_present && !was_leaf &&
> > > > > >  	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
> > > > > >  		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
> > > > > > +	else if (was_leaf && is_mirror_sptep(sptep) && !is_leaf)
> > > > > Should we check !is_present instead of !is_leaf?
> > > > > e.g. a transition from a present leaf entry to a present non-leaf entry could
> > > > > also trigger this if case.
> > > > 
> > > > No, the !is_leaf check is very intentional.  At this point in the series, S-EPT
> > > > doesn't support hugepages.  If KVM manages to install a leaf SPTE and replaces
> > > > that SPTE with a non-leaf SPTE, then we absolutely want the KVM_BUG_ON() in
> > > > tdx_sept_remove_private_spte() to fire:
> > > > 
> > > > 	/* TODO: handle large pages. */
> > > > 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> > > > 		return -EIO;
> > > But the op is named remove_external_spte().
> > > And the check of "level != PG_LEVEL_4K" is for removing large leaf entries.
> > 
> > I agree that the naming at this point in the series is unfortunate, but I don't
> > see it as outright wrong.  That the TDP MMU could theoretically replace the leaf
> > SPTE with a non-leaf SPTE doesn't change the fact that the old leaf SPTE *is*
> > being removed.
> Hmm, I can't agree with that. But I won't insist if you think it's ok :)

If the code is read through a TDX lens, then I agree, it's seems wrong.  Because
then you *know* that TDX doesn't support back-to-back remove()=>add() operations
to handle a page split.

But from a TDP MMU perspective, this is entirely logical (ignoring that
link_external_spt() is gone at this point in the series).

	else if (was_leaf && is_mirror_sptep(sptep) && !is_leaf) {
		kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_spte);

		/*
		 * Link the new page table if a hugepage is being split, i.e.
		 * if a leaf SPTE is being replaced with a non-leaf SPTE.
		 */
		if (is_present)
			kvm_x86_call(link_external_spt)(kvm, gfn, level, ...);
	}

And that is *exactly* why I want to get rid of the hyper-specific kvm_x86_ops
hooks.  They bleed all kinds of implementation details all over the TDP MMU, which
makes it difficult to read and understand the relevant TDP MMU code if you don't
already know the TDX rules.  And I absolutely do not want to effectively require
others to understand TDX's rules to be able to make changes to the TDP MMU.

> > > Relying on the TDX code's lockdep_assert_held_write() for warning seems less
> > > clear than having an explicit check here.
> > 
> > ...that's TDX's responsibility to enforce, and I don't see any justification for
> > something more than a lockdep assertion.  As I've said elsewhere, several times,
> My concern is that handle_changed_spte() can be invoked by callers other than
> tdp_mmu_set_spte(). e.g.,
> 
> tdp_mmu_set_spte_atomic
>   | __tdp_mmu_set_spte_atomic
>   |     | kvm_x86_call(set_external_spte)
>   | handle_changed_spte
>         | kvm_x86_call(set_external_spte)
> 
> When !is_frozen_spte(new_spte) and was_leaf, set_external_spte() may be invoked
> twice for splitting under shared mmu_lock.

But we don't support that yet.  I was going to punt dealing with that to the future,
but now that I've looked at it, I honestly think the problem is that I didn't go
far enough with the cleanup.  I shouldn't have hedged.

What I said in "KVM: TDX: Drop kvm_x86_ops.link_external_spt(), use .set_external_spte()
for all":

 : Ideally, KVM would provide a single pair of hooks to set S-EPT entries,
 : one hook for setting SPTEs under write-lock and another for settings SPTEs
 : under read-lock (e.g. to ensure the entire operation is "atomic", to allow
 : for failure, etc.).  Sadly, TDX's requirement that all child S-EPT entries
 : are removed before the parent makes that impractical: the TDP MMU
 : deliberately prunes non-leaf SPTEs and _then_ processes its children, thus
 : making it quite important for the TDP MMU to differentiate between zapping
 : leaf and non-leaf S-EPT entries.

isn't quite right.  Ideally, KVM would provide *one* hook to set S-EPT entries.
Because the API to actually *set* the external SPTE shouldn't be any different
for read-lock vs. write-lost.  I.e. the child S-EPT case remains the sole
exception.  More below.

> Therefore, I think it would be better to check for !shared and only invoke
> set_external_spte() when !shared.

No.  I am dead set against conditionally invoking set_external_spte() based on
shared vs. exclusive.  The rules for how SPTE updates are forwarded to TDX, and
how TDX reacts to those updates, need to be defined purely on state transitions,
i.e. on old_spte vs. new_spte.

Actually, even that isn't a strong enough statement.  *All* updates need to be
forwarded to TDX, and then TDX can react as appropriate.

> BTW: in the patch log, you mentioned that
> 
> : Invoke .remove_external_spte() in handle_changed_spte() as appropriate
> : instead of relying on callers to do the right thing.  Relying on callers
> : to invoke .remove_external_spte() is confusing and brittle, e.g. subtly
> : relies tdp_mmu_set_spte_atomic() never removing SPTEs, and removing an
> : S-EPT entry in tdp_mmu_set_spte() is bizarre (yeah, the VM is bugged so
> : it doesn't matter in practice, but it's still weird).
> 
> However, when tdp_mmu_set_spte_atomic() removes SPTEs in the future, it will
> still need to follow the sequence in __tdp_mmu_set_spte_atomic() :
> 1. freeze, 2. set_external_spte(). 3. set the new_spte 4. handle_changed_spte().
> 
> So, do you think we should leave set_external_spte() in tdp_mmu_set_spte() for
> exclusive mmu_lock scenarios instead of moving it to handle_changed_spte()?

Nope, as above, 100% the opposite.  Over ~3 patches, e.g.

 1. Drop the KVM_BUG_ON()s or move them to TDX
 2. Morph the !is_frozen_spte() check into a KVM_MMU_WARN_ON()
 3. Rework the code to rely on __handle_changed_spte() to propagate writes to S-EPT

That way, the _only_ path that updates external SPTEs is this:

	if (was_present && !was_leaf &&
	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
	else if (is_mirror_sptep(sptep))
		return kvm_x86_call(set_external_spte)(kvm, gfn, old_spte,
						       new_spte, level);

which is fully aligned with handle_changed_spte()'s role for !mirror roots: it
exists to react to changes (the sole exception to that being aging SPTEs, which
is a special case).

Compile-tested only.

---
 arch/x86/kvm/mmu/tdp_mmu.c | 118 ++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 847f2fcb6740..33a321aedac0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -464,7 +464,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 }
 
 /**
- * handle_changed_spte - handle bookkeeping associated with an SPTE change
+ * __handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
  * @as_id: the address space of the paging structure the SPTE was a part of
  * @sptep: pointer to the SPTE
@@ -480,9 +480,9 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * dirty logging updates are handled in common code, not here (see make_spte()
  * and fast_pf_fix_direct_spte()).
  */
-static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
-				gfn_t gfn, u64 old_spte, u64 new_spte,
-				int level, bool shared)
+static int __handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
+				 gfn_t gfn, u64 old_spte, u64 new_spte,
+				 int level, bool shared)
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
@@ -518,7 +518,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	}
 
 	if (old_spte == new_spte)
-		return;
+		return 0;
 
 	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
 
@@ -547,7 +547,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 			       "a temporary frozen SPTE.\n"
 			       "as_id: %d gfn: %llx old_spte: %llx new_spte: %llx level: %d",
 			       as_id, gfn, old_spte, new_spte, level);
-		return;
+		return 0;
 	}
 
 	if (is_leaf != was_leaf)
@@ -559,30 +559,31 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	 * SPTE being converted to a hugepage (leaf) or being zapped.  Shadow
 	 * pages are kernel allocations and should never be migrated.
 	 *
-	 * When modifying leaf entries in mirrored page tables, propagate the
-	 * changes to the external SPTE.  Bug the VM on failure, as callers
-	 * aren't prepared to handle errors, e.g. due to lock contention in the
-	 * TDX-Module.  Note, changes to non-leaf mirror SPTEs are handled by
-	 * handle_removed_pt() (the TDX-Module requires that child entries are
-	 * removed before the parent SPTE), and changes to non-present mirror
-	 * SPTEs are handled by __tdp_mmu_set_spte_atomic() (KVM needs to set
-	 * the external SPTE while the mirror SPTE is frozen so that installing
-	 * a new SPTE is effectively an atomic operation).
+	 * When modifying leaf entries in mirrored page tables, propagate all
+	 * changes to the external SPTE.
 	 */
 	if (was_present && !was_leaf &&
 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
-	else if (was_leaf && is_mirror_sptep(sptep))
-		KVM_BUG_ON(kvm_x86_call(set_external_spte)(kvm, gfn, old_spte,
-							   new_spte, level), kvm);
+	else if (is_mirror_sptep(sptep))
+		return kvm_x86_call(set_external_spte)(kvm, gfn, old_spte,
+						       new_spte, level);
+
+	return 0;
+}
+
+static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
+				gfn_t gfn, u64 old_spte, u64 new_spte,
+				int level, bool shared)
+{
+	KVM_BUG_ON(__handle_changed_spte(kvm, as_id, sptep, gfn, old_spte,
+					 new_spte, level, shared), kvm);
 }
 
 static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
 							 struct tdp_iter *iter,
 							 u64 new_spte)
 {
-	u64 *raw_sptep = rcu_dereference(iter->sptep);
-
 	/*
 	 * The caller is responsible for ensuring the old SPTE is not a FROZEN
 	 * SPTE.  KVM should never attempt to zap or manipulate a FROZEN SPTE,
@@ -591,40 +592,6 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	 */
 	WARN_ON_ONCE(iter->yielded || is_frozen_spte(iter->old_spte));
 
-	if (is_mirror_sptep(iter->sptep) && !is_frozen_spte(new_spte)) {
-		int ret;
-
-		/*
-		 * KVM doesn't currently support zapping or splitting mirror
-		 * SPTEs while holding mmu_lock for read.
-		 */
-		if (KVM_BUG_ON(is_shadow_present_pte(iter->old_spte), kvm) ||
-		    KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
-			return -EBUSY;
-
-		/*
-		 * Temporarily freeze the SPTE until the external PTE operation
-		 * has completed, e.g. so that concurrent faults don't attempt
-		 * to install a child PTE in the external page table before the
-		 * parent PTE has been written.
-		 */
-		if (!try_cmpxchg64(raw_sptep, &iter->old_spte, FROZEN_SPTE))
-			return -EBUSY;
-
-		/*
-		 * Update the external PTE.  On success, set the mirror SPTE to
-		 * the desired value.  On failure, restore the old SPTE so that
-		 * the SPTE isn't frozen in perpetuity.
-		 */
-		ret = kvm_x86_call(set_external_spte)(kvm, iter->gfn, iter->old_spte,
-						      new_spte, iter->level);
-		if (ret)
-			__kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte);
-		else
-			__kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
-		return ret;
-	}
-
 	/*
 	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
 	 * does not hold the mmu_lock.  On failure, i.e. if a different logical
@@ -632,7 +599,7 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	 * the current value, so the caller operates on fresh data, e.g. if it
 	 * retries tdp_mmu_set_spte_atomic()
 	 */
-	if (!try_cmpxchg64(raw_sptep, &iter->old_spte, new_spte))
+	if (!try_cmpxchg64(rcu_dereference(iter->sptep), &iter->old_spte, new_spte))
 		return -EBUSY;
 
 	return 0;
@@ -663,14 +630,44 @@ static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	ret = __tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
+	/* KVM should never freeze SPTEs using higher level APIs. */
+	KVM_MMU_WARN_ON(is_frozen_spte(new_spte));
+
+	/*
+	  * Temporarily freeze the SPTE until the external PTE operation has
+	  * completed (unless the new SPTE itself will be frozen), e.g. so that
+	  * concurrent faults don't attempt to install a child PTE in the
+	  * external page table before the parent PTE has been written, or try
+	  * to re-install a page table before the old one was removed.
+	  */
+	if (is_mirror_sptep(iter->sptep))
+		ret = __tdp_mmu_set_spte_atomic(kvm, iter, FROZEN_SPTE);
+	else
+		ret = __tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
 	if (ret)
 		return ret;
 
-	handle_changed_spte(kvm, iter->as_id, iter->sptep, iter->gfn,
-			    iter->old_spte, new_spte, iter->level, true);
+	ret = __handle_changed_spte(kvm, iter->as_id, iter->sptep, iter->gfn,
+				    iter->old_spte, new_spte, iter->level, true);
 
-	return 0;
+	/*
+	 * Unfreeze the mirror SPTE.  If updating the external SPTE failed,
+	 * restore the old SPTE so that the SPTE isn't frozen in perpetuity,
+	 * otherwise set the mirror SPTE to the new desired value.
+	 */
+	if (is_mirror_sptep(iter->sptep)) {
+		if (ret)
+			__kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte);
+		else
+			__kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
+	} else {
+		/*
+		 * Bug the VM if handling the change failed, as failure is only
+		 * allowed if KVM couldn't update the external SPTE.
+		 */
+		KVM_BUG_ON(ret, kvm);
+	}
+	return ret;
 }
 
 /*
@@ -1325,6 +1322,9 @@ static void kvm_tdp_mmu_age_spte(struct kvm *kvm, struct tdp_iter *iter)
 {
 	u64 new_spte;
 
+	if (WARN_ON_ONCE(is_mirror_sptep(iter->sptep)))
+		return;
+
 	if (spte_ad_enabled(iter->old_spte)) {
 		iter->old_spte = tdp_mmu_clear_spte_bits_atomic(iter->sptep,
 								shadow_accessed_mask);

base-commit: c86be62d601ede14cbad1d0fb5af9b67d4172342
--

