Return-Path: <kvm+bounces-21677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5048F931E68
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 03:21:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD33E1F217CD
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 01:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874024C7B;
	Tue, 16 Jul 2024 01:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dSfRGrQP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44165139B;
	Tue, 16 Jul 2024 01:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721092874; cv=none; b=DC4onsI8D00VHwZ9EAwesNghjbXtvn+8I7nrJQ8JSAz7D0mfnS5rW5UR6PFSSp82KnBk9Sl2h6eelF2tqAwFu8A0WY+XqjIl+hJQnjC6URHMjJEBeQehbhH7T9ElDJZmmUbWUzstRQbGCZr4gxNXqUhyzLmi+HPzxye5l6eoqN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721092874; c=relaxed/simple;
	bh=YLnF3vXmTwHVi/fglXgJKae0Ty7PKcRO4fdfrxeMSg4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B0yT7CXTgxrI4afZIdBEw/PJS3JwyRyu1qgAJyiPJoAOYczMSY0xk7y01V4qnUY/PX1hKVM6i+zNpOUibHk1PsXn1jIbwl4cAmcXkD4gxJxQILGvJUDiYX0N2P6t9KNhA05By0U5Ltw4vj/F7buArwlAmjwzz3kjf+gAGa8IEaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dSfRGrQP; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721092872; x=1752628872;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YLnF3vXmTwHVi/fglXgJKae0Ty7PKcRO4fdfrxeMSg4=;
  b=dSfRGrQP9iy9KP+eGUOcaZcP0hIHmDDIDxv4xQdc4eAWeC6N5kYThva+
   rvKmKtLtXbXyiUB67yy++Y5+AsrGFkXcM45/bXF4Xjv3pceDd6iFGcng2
   cH34m4/xweHk87XaFyqcer1WlkRmigK/97vUFNu6zOp9XH6Mb5XAQEyA5
   fMNA3uAfDZxlpGFkiK8P6UFqvftMIUxkBPogWqXZk0WsLdQ2e2hrptYxj
   ZFrwSe0J9ofJNZQpk52rujl+kYuyNNN+8GHDBJYzLH7udGjPLZpMtXTWH
   ClhpoOvaEkDMS0+GUNQz4YBdu+zGZQ6jzJOrtwzAlcx0QMwEoi/8KZaqH
   w==;
X-CSE-ConnectionGUID: 1h026Oq1TVu0/hGJwVoE4A==
X-CSE-MsgGUID: 1g4L3RdXQu+tPCM48eFckA==
X-IronPort-AV: E=McAfee;i="6700,10204,11134"; a="18699447"
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="18699447"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 18:21:11 -0700
X-CSE-ConnectionGUID: L+/jyIgiRHGjy+g616567g==
X-CSE-MsgGUID: dhyjsaffTVWXCI8AereOYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="73062583"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 18:21:10 -0700
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Allow per VM kvm_mmu_max_gfn()
Date: Mon, 15 Jul 2024 18:21:03 -0700
Message-ID: <fdddad066c88c6cd8f2090f11e32e54f7d5c6178.1721092739.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Prepare for TDX support by making kvm_mmu_max_gfn() configurable.  Have
this preparation also be useful by non-TDX changes to improve correctness
associated with the combination of 4-level EPT and MAXPA > 48.  The issue
is analyzed at [1].

Like other confidential computing technologies, TDX has the concept of
private and shared memory.  For TDX, the private and shared mappings of the
same GFN are mapped at separate GPAs, with a configurable GPA bit selecting
between private and shared aliases of the same GFN.  This means that
operations working with the concept of a maximum GFN should only go up to
this configurable GPA bit instead of the existing behavior based on
shadow_phys_bits.  Other TDX changes will handle applying the operation
across both GFN aliases.

Using the existing kvm_mmu_max_gfn() based on shadow_phys_bits would cause
functional problems for TDX.  Specifically, because the function is used to
restrict the range where memslots can be created.  For TDX, if a memslot is
created at a GFN that includes the bit that selects between private/shared,
it would confuse the logic that zaps both aliases.  It would end up zapping
only the higher alias and missing the lower one.  In this case, freed pages
could remain mapped in the TDX guest.

Since this GPA bit is configurable per-VM, make kvm_mmu_max_gfn() per-VM by
having it take a struct kvm, and keep the max GFN as a member on that
struct.  Future TDX changes will set this member based on the configurable
position of the private/shared bit.

Besides functional issues, it is generally more correct and easier to
reason about in the context of solutions like TDX which have multiple
aliases for the same GFN.  For example, in other TDX changes the logic in
__tdp_mmu_zap_root() will made to iterate twice for each alias.  Using a
correct kvm_mmu_max_gfn() will avoid iterating over high GFN ranges that
could not have set PTEs.

It is worth noting, that existing VM types could get correctness/efficiency
benefits in the same way.  One case would be where a host MAXPA is above
48, but 4-level EPT is used.  In this case, KVM could skip iterating over
EPT that cannot be mapped.  In this case, the benefit of the per-VM value
is to cache the max GFN.  Another could be SEV, where it is unnecessary to
iterate over the C-bits position.  The benefit of the per-VM max GFN in
that case would be not all guests would have a C-bit.

No functional change intended.

Link: https://lore.kernel.org/kvm/20240522223413.GC212599@ls.amr.corp.intel.com/ [1]
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/mmu.h              | 7 ++++++-
 arch/x86/kvm/mmu/mmu.c          | 3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 8 ++++----
 arch/x86/kvm/x86.c              | 2 +-
 5 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9bb2e164c523..2e1d330206a4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1519,6 +1519,8 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+	gfn_t mmu_max_gfn;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index dc80e72e4848..670ec63b0434 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -63,7 +63,7 @@ static __always_inline u64 rsvd_bits(int s, int e)
  */
 extern u8 __read_mostly shadow_phys_bits;
 
-static inline gfn_t kvm_mmu_max_gfn(void)
+static inline gfn_t __kvm_mmu_max_gfn(void)
 {
 	/*
 	 * Note that this uses the host MAXPHYADDR, not the guest's.
@@ -81,6 +81,11 @@ static inline gfn_t kvm_mmu_max_gfn(void)
 	return (1ULL << (max_gpa_bits - PAGE_SHIFT)) - 1;
 }
 
+static inline gfn_t kvm_mmu_max_gfn(struct kvm *kvm)
+{
+	return kvm->arch.mmu_max_gfn;
+}
+
 static inline u8 kvm_get_shadow_phys_bits(void)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e0e9963066f..b8f36779898a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3302,7 +3302,7 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 	 * only if L1's MAXPHYADDR is inaccurate with respect to the
 	 * hardware's).
 	 */
-	if (unlikely(fault->gfn > kvm_mmu_max_gfn()))
+	if (unlikely(fault->gfn > kvm_mmu_max_gfn(vcpu->kvm)))
 		return RET_PF_EMULATE;
 
 	return RET_PF_CONTINUE;
@@ -6483,6 +6483,7 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
 
 void kvm_mmu_init_vm(struct kvm *kvm)
 {
+	kvm->arch.mmu_max_gfn = __kvm_mmu_max_gfn();
 	kvm->arch.shadow_mmio_value = shadow_mmio_value;
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ff27e1eadd54..a903300d3869 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -733,7 +733,7 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	return iter->yielded;
 }
 
-static inline gfn_t tdp_mmu_max_gfn_exclusive(void)
+static inline gfn_t tdp_mmu_max_gfn_exclusive(struct kvm *kvm)
 {
 	/*
 	 * Bound TDP MMU walks at host.MAXPHYADDR.  KVM disallows memslots with
@@ -741,7 +741,7 @@ static inline gfn_t tdp_mmu_max_gfn_exclusive(void)
 	 * MMIO SPTEs for "impossible" gfns, instead sending such accesses down
 	 * the slow emulation path every time.
 	 */
-	return kvm_mmu_max_gfn() + 1;
+	return kvm_mmu_max_gfn(kvm) + 1;
 }
 
 static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
@@ -749,7 +749,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 {
 	struct tdp_iter iter;
 
-	gfn_t end = tdp_mmu_max_gfn_exclusive();
+	gfn_t end = tdp_mmu_max_gfn_exclusive(kvm);
 	gfn_t start = 0;
 
 	for_each_tdp_pte_min_level(iter, root, zap_level, start, end) {
@@ -850,7 +850,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 {
 	struct tdp_iter iter;
 
-	end = min(end, tdp_mmu_max_gfn_exclusive());
+	end = min(end, tdp_mmu_max_gfn_exclusive(kvm));
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6968eadd418..f8bfbcb818e3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12939,7 +12939,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		return -EINVAL;
 
 	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
-		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn())
+		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn(kvm))
 			return -EINVAL;
 
 		return kvm_alloc_memslot_metadata(kvm, new);

base-commit: c8b8b8190a80b591aa73c27c70a668799f8db547
-- 
2.45.2


