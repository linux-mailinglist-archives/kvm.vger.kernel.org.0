Return-Path: <kvm+bounces-9671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AC89866CA4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:43:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DBAE1C20E6C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5258350A68;
	Mon, 26 Feb 2024 08:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Md8qd05y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8006B3DBBF;
	Mon, 26 Feb 2024 08:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936096; cv=none; b=u2hvQu2aI6C4bxQt80aCs++PlsY1UTLXhXILz27ukot1pQKbQ6Zq4bgpu/MQaphTcPohlPzREOmQKw9sAbggSDSaasBq6thgyBIbzHiSeGtJeTok0o0fz8B0fZ3/EGOcJmo0xMhg4FG75asQq/ahc8L1R/r7ScbRpJA466m4/1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936096; c=relaxed/simple;
	bh=wNBryeQQw95QhWpkNBLeGWBbrsE5OGf6Bj8TyqRgf1I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IveZqE4Ahm1CbmvOPRRrvFhcXynP5LVMUVfZRDxx+wBRH3K8KxOI+JudxC5DtmEQ/J3U4hNI27XeaURT2d9LbyHdGI9DopbXbkurnOXuBVm5KfAWlrwRWJA3Vae+DOBM5lUT225HEMgJlRp5lqcBFty4loeLLtSdHSS32Zl+U3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Md8qd05y; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936093; x=1740472093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wNBryeQQw95QhWpkNBLeGWBbrsE5OGf6Bj8TyqRgf1I=;
  b=Md8qd05yrHH3YnIQS64OX7aGFGxu7cVM3wPhUed0QIPZedzJcflWN4m+
   f51buCWfspViByMjHNkgFiqQHplZ0TtJb9trFgbYnsIixf/4A7JHyCoxq
   WmKN+eeiJR6V3Zhp3bhf5FLlKjX6r3fesnTRYX96tYTAwysQ9gQCc/2r4
   9sBy4cO/IqTO5tTD0afLI9u+EFmtjhekBobddlRMM9zRIzKOaY4DFlaaz
   lQ+mrRyqRQ8g68FEqdogGwBX3H2jBbLBm3N8Uj316gXk9RAoRXMy8rHPV
   ES6WO0Opr737CDLllymxDCejD0pbUkmYel5w3BVm3xToXkTV51iYoa94X
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155373"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155373"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615795"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:09 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v19 049/130] KVM: x86/mmu: Replace hardcoded value 0 for the initial value for SPTE
Date: Mon, 26 Feb 2024 00:25:51 -0800
Message-Id: <69fc71c7fbb5f5abfb6d2948d56bb6fa85ebd7d5.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

The TDX support will need the "suppress #VE" bit (bit 63) set as the
initial value for SPTE.  To reduce code change size, introduce a new macro
SHADOW_NONPRESENT_VALUE for the initial value for the shadow page table
entry (SPTE) and replace hard-coded value 0 for it.  Initialize shadow page
tables with their value.

The plan is to unconditionally set the "suppress #VE" bit for both AMD and
Intel as: 1) AMD hardware uses the bit 63 as NX for present SPTE and
ignored for non-present SPTE; 2) for conventional VMX guests, KVM never
enables the "EPT-violation #VE" in VMCS control and "suppress #VE" bit is
ignored by hardware.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 20 +++++++++++++++-----
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/mmu/spte.h        |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.c     | 14 +++++++-------
 4 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2becc86c71b2..211c0e72f45d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -567,9 +567,9 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 
 	if (!is_shadow_present_pte(old_spte) ||
 	    !spte_has_volatile_bits(old_spte))
-		__update_clear_spte_fast(sptep, 0ull);
+		__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
 	else
-		old_spte = __update_clear_spte_slow(sptep, 0ull);
+		old_spte = __update_clear_spte_slow(sptep, SHADOW_NONPRESENT_VALUE);
 
 	if (!is_shadow_present_pte(old_spte))
 		return old_spte;
@@ -603,7 +603,7 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
  */
 static void mmu_spte_clear_no_track(u64 *sptep)
 {
-	__update_clear_spte_fast(sptep, 0ull);
+	__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
 }
 
 static u64 mmu_spte_get_lockless(u64 *sptep)
@@ -1950,7 +1950,8 @@ static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 static int kvm_sync_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
 {
-	if (!sp->spt[i])
+	/* sp->spt[i] has initial value of shadow page table allocation */
+	if (sp->spt[i] == SHADOW_NONPRESENT_VALUE)
 		return 0;
 
 	return vcpu->arch.mmu->sync_spte(vcpu, sp, i);
@@ -6204,7 +6205,16 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
-	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+	/*
+	 * When X86_64, initial SEPT entries are initialized with
+	 * SHADOW_NONPRESENT_VALUE.  Otherwise zeroed.  See
+	 * mmu_memory_cache_alloc_obj().
+	 */
+	if (IS_ENABLED(CONFIG_X86_64))
+		vcpu->arch.mmu_shadow_page_cache.init_value =
+			SHADOW_NONPRESENT_VALUE;
+	if (!vcpu->arch.mmu_shadow_page_cache.init_value)
+		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4d4e98fe4f35..bebd73cd61bb 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -911,7 +911,7 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
 	gpa_t pte_gpa;
 	gfn_t gfn;
 
-	if (WARN_ON_ONCE(!sp->spt[i]))
+	if (WARN_ON_ONCE(sp->spt[i] == SHADOW_NONPRESENT_VALUE))
 		return 0;
 
 	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a129951c9a88..4d1799ba2bf8 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -149,6 +149,8 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
 
 #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
 
+#define SHADOW_NONPRESENT_VALUE	0ULL
+
 extern u64 __read_mostly shadow_host_writable_mask;
 extern u64 __read_mostly shadow_mmu_writable_mask;
 extern u64 __read_mostly shadow_nx_mask;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6ae19b4ee5b1..bdeb23ff9e71 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -570,7 +570,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * here since the SPTE is going from non-present to non-present.  Use
 	 * the raw write helper to avoid an unnecessary check on volatile bits.
 	 */
-	__kvm_tdp_mmu_write_spte(iter->sptep, 0);
+	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
 
 	return 0;
 }
@@ -707,8 +707,8 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		if (!shared)
-			tdp_mmu_iter_set_spte(kvm, &iter, 0);
-		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
+			tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
+		else if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
 			goto retry;
 	}
 }
@@ -764,8 +764,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
 		return false;
 
-	tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
-			 sp->gfn, sp->role.level + 1);
+	tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
+			 SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1);
 
 	return true;
 }
@@ -799,7 +799,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		tdp_mmu_iter_set_spte(kvm, &iter, 0);
+		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
 		flush = true;
 	}
 
@@ -1226,7 +1226,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	 * invariant that the PFN of a present * leaf SPTE can never change.
 	 * See handle_changed_spte().
 	 */
-	tdp_mmu_iter_set_spte(kvm, iter, 0);
+	tdp_mmu_iter_set_spte(kvm, iter, SHADOW_NONPRESENT_VALUE);
 
 	if (!pte_write(range->arg.pte)) {
 		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
-- 
2.25.1


