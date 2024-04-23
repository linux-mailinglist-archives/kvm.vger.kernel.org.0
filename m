Return-Path: <kvm+bounces-15735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D498D8AFCDF
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 01:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 036A71C22792
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 23:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE9AA4597F;
	Tue, 23 Apr 2024 23:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mc3JIgMz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2D644384;
	Tue, 23 Apr 2024 23:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713916217; cv=none; b=KqlzQis3wEceS+MXA8nplCjofe+jQbv5/xqhFhQM+lmT+3CEaRfED2KUTUuvwqZU8Umou3fGB5JXSdE0LHc1wAEkhfdvrLXDGZjELLv/Orf1Yibbkd2jbV9y2dQ+oPJrlM++/paiAvSoBlCofHClj/2g6jlT9EfEO2A8xEWxke0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713916217; c=relaxed/simple;
	bh=+WPlueIv66ky5YK9PKL2xzG7cIJjxnQn5CQCbAettMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZnXVjCuVDw+RriuVbscegND6/s9/YVJrvhY8YFPnBi7MbK4rUay2KnWn5P5CmkuzCosm0KOTtoXTWpobGz2WtF4dRZBPyODvZ/mLuqo9zEYpINO3PYwtd6nCQ7V6BVF7L/TCy9Y2YnrX9Fmv3wsWZyJKLreM3vAgN/0JaJSF13g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mc3JIgMz; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713916214; x=1745452214;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+WPlueIv66ky5YK9PKL2xzG7cIJjxnQn5CQCbAettMs=;
  b=Mc3JIgMz3zXRegaWwGpo36upHvpafoq8eMHRjoTqhDYiVJBMYibZcWZ/
   z63+OYlvLyeAChC0xkUz5FeBv4wdAGMbohtQnjcqD2IOPaWZkLk/aFahp
   OULPly+0IjFja3zCcLEYo1n88QpcyzjsqnzCiUPe/GaGHYwt7rlvFDVDl
   8O3tETFDvkol7zigbeIXXdj2hI0OXOl4X0tUTt5btyCX76T9IWTCu2yrn
   SCJcNVIHU+cI/cznAH87VapDozNv8J5z8j+9diMzEhAVctrnCqZ110Bt4
   KNYdxwykTjMv1tzZr1LhUzQKzEE3V+holCaehy8tmqo+guzUnU5HRw07G
   A==;
X-CSE-ConnectionGUID: z9qwDTKtRqS0512Afekf0w==
X-CSE-MsgGUID: IMlaakHDSC+ZTmMXSS4vww==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="12461264"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="12461264"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 16:50:13 -0700
X-CSE-ConnectionGUID: h0ovcEApQ5Kg+fFpK7RJAQ==
X-CSE-MsgGUID: Pc+YW/6sRJ6YhPysYev4gA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29325113"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 16:50:14 -0700
Date: Tue, 23 Apr 2024 16:50:13 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	michael.roth@amd.com, isaku.yamahata@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 09/11] KVM: guest_memfd: Add interface for populating
 gmem pages with user data
Message-ID: <20240423235013.GO3596705@ls.amr.corp.intel.com>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
 <20240404185034.3184582-10-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240404185034.3184582-10-pbonzini@redhat.com>

On Thu, Apr 04, 2024 at 02:50:31PM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> During guest run-time, kvm_arch_gmem_prepare() is issued as needed to
> prepare newly-allocated gmem pages prior to mapping them into the guest.
> In the case of SEV-SNP, this mainly involves setting the pages to
> private in the RMP table.
> 
> However, for the GPA ranges comprising the initial guest payload, which
> are encrypted/measured prior to starting the guest, the gmem pages need
> to be accessed prior to setting them to private in the RMP table so they
> can be initialized with the userspace-provided data. Additionally, an
> SNP firmware call is needed afterward to encrypt them in-place and
> measure the contents into the guest's launch digest.
> 
> While it is possible to bypass the kvm_arch_gmem_prepare() hooks so that
> this handling can be done in an open-coded/vendor-specific manner, this
> may expose more gmem-internal state/dependencies to external callers
> than necessary. Try to avoid this by implementing an interface that
> tries to handle as much of the common functionality inside gmem as
> possible, while also making it generic enough to potentially be
> usable/extensible for TDX as well.

I explored how TDX will use this hook.  However, it resulted in not using this
hook, and instead used kvm_tdp_mmu_get_walk() with a twist.  The patch is below.

Because SEV-SNP manages the RMP that is not tied to NPT directly, SEV-SNP can
ignore TDP MMU page tables when updating RMP.
On the other hand, TDX essentially updates Secure-EPT when it adds a page to
the guest by TDH.MEM.PAGE.ADD().  It needs to protect KVM TDP MMU page tables
with mmu_lock, not guest memfd file mapping with invalidate_lock.  The hook
doesn't apply to TDX well.  The resulted KVM_TDX_INIT_MEM_REGION logic is as
follows.

  get_user_pages_fast(source addr)
  read_lock(mmu_lock)
  kvm_tdp_mmu_get_walk_private_pfn(vcpu, gpa, &pfn);
  if the page table doesn't map gpa, error.
  TDH.MEM.PAGE.ADD()
  TDH.MR.EXTEND()
  read_unlock(mmu_lock)
  put_page()


From 7d4024049b51969a2431805c2117992fc7ec0981 Mon Sep 17 00:00:00 2001
Message-ID: <7d4024049b51969a2431805c2117992fc7ec0981.1713913379.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1713913379.git.isaku.yamahata@intel.com>
References: <cover.1713913379.git.isaku.yamahata@intel.com>
From: Isaku Yamahata <isaku.yamahata@intel.com>
Date: Tue, 23 Apr 2024 11:33:44 -0700
Subject: [PATCH] KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU

KVM_TDX_INIT_MEM_REGION needs to check if the given GFN is already
populated.  Add wrapping logic to kvm_tdp_mmu_get_walk() to export it.

Alternatives are as follows.  Choose the approach of this patch as the
least intrusive change.
- Refactor kvm page fault handler.  Populating part and unlock function.
  The page fault handler to populate with keeping lock, TDH.MEM.PAGE.ADD(),
  unlock.
- Add a callback function to struct kvm_page_fault and call it
  after the page fault handler before unlocking mmu_lock and releasing PFN.

Based on the feedback of
https://lore.kernel.org/kvm/ZfBkle1eZFfjPI8l@google.com/
https://lore.kernel.org/kvm/Zh8DHbb8FzoVErgX@google.com/

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu.h         |  3 +++
 arch/x86/kvm/mmu/tdp_mmu.c | 44 ++++++++++++++++++++++++++++++++------
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 712e9408f634..4f61f4b9fd64 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -287,6 +287,9 @@ extern bool tdp_mmu_enabled;
 #define tdp_mmu_enabled false
 #endif
 
+int kvm_tdp_mmu_get_walk_private_pfn(struct kvm_vcpu *vcpu, u64 gpa,
+				     kvm_pfn_t *pfn);
+
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
 	return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3592ae4e485f..bafcd8aeb3b3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -2035,14 +2035,25 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
  *
  * Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
  */
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
-			 int *root_level)
+static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+				  bool is_private)
 {
 	struct tdp_iter iter;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
+	tdp_mmu_for_each_pte(iter, mmu, is_private, gfn, gfn + 1) {
+		leaf = iter.level;
+		sptes[leaf] = iter.old_spte;
+	}
+
+	return leaf;
+}
+
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			 int *root_level)
+{
 	*root_level = vcpu->arch.mmu->root_role.level;
 
 	/*
@@ -2050,15 +2061,34 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	 * instructions in protected guest memory can't be parsed by VMM.
 	 */
 	if (WARN_ON_ONCE(kvm_gfn_shared_mask(vcpu->kvm)))
-		return leaf;
+		return -1;
 
-	tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
-		leaf = iter.level;
-		sptes[leaf] = iter.old_spte;
+	return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, false);
+}
+
+int kvm_tdp_mmu_get_walk_private_pfn(struct kvm_vcpu *vcpu, u64 gpa,
+				     kvm_pfn_t *pfn)
+{
+	u64 sptes[PT64_ROOT_MAX_LEVEL + 1], spte;
+	int leaf;
+
+	lockdep_assert_held(&vcpu->kvm->mmu_lock);
+
+	kvm_tdp_mmu_walk_lockless_begin();
+	leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, true);
+	kvm_tdp_mmu_walk_lockless_end();
+	if (leaf < 0)
+		return -ENOENT;
+
+	spte = sptes[leaf];
+	if (is_shadow_present_pte(spte) && is_last_spte(spte, leaf)) {
+		*pfn = spte_to_pfn(spte);
+		return leaf;
 	}
 
-	return leaf;
+	return -ENOENT;
 }
+EXPORT_SYMBOL_GPL(kvm_tdp_mmu_get_walk_private_pfn);
 
 /*
  * Returns the last level spte pointer of the shadow page walk for the given
-- 
2.43.2

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

