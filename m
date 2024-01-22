Return-Path: <kvm+bounces-6609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EEBD837985
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:41:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E27B1F27997
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CDA25F847;
	Mon, 22 Jan 2024 23:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fWJAf2LJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B0A5EE96;
	Mon, 22 Jan 2024 23:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967726; cv=none; b=ZHK65deIMjmK3cAn2dJMYqDaxucHGmzJ9phuyEZ98AwSyxsWj5gvG+LKqgei5Qtrvku1JoH5Z17S2xXRzDJGjO2llE0ixFnhUlYDW+cvjWOKmYqKG5sjDhOuAB6fKy8D6siT+wa8uxkaE/5rxgkBFF3kw2ujHmjJ0khSEOzudWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967726; c=relaxed/simple;
	bh=W7n8vjIkmQn8VO13mPbVo91HBk6Ha/DtEnjVAt/VXjw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TcIBLcGiscNWcsED5DR7ReFD4HJd0wdSUmM9zQYMmhip+hn+2+LmwgfEORPb9GpZFhzIX7+QohaB7jgKl6c89JzCbPt9X9HsDkp833Jg5xnLadCcF/OpvjSQOboipC7tJu69mldHAqLYxUcqh3+PxqV+rENvu1jid4LZvIFTMAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fWJAf2LJ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967725; x=1737503725;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W7n8vjIkmQn8VO13mPbVo91HBk6Ha/DtEnjVAt/VXjw=;
  b=fWJAf2LJ2AM4Glhh0SoRZzJoe7otcoy+6ZaZZrv1MEFR3Pg1XPe3KUfD
   5ip9/GcPG1rZZIi64c5Vjki2HpZwUTrhbSnuQYxt/pQSzeMBWtk5ICVtZ
   9Uu6Lstrlm++QaAubCI2DEyWcg352n+Tw0cXG/ZPWPnAi7SvKlbhd3GDw
   1npl9GU92JR665ADFtYxDimGkysb3cz8W1jE68RBu02X1gxNCvPus5TNo
   emLkVm5TGsRezw2uKOQb1/ld7KDc+NQvGREDvHykn7cW1H5Zq0SiE/eiC
   9eQIshQM0XhOvMII5hMrvl1CixMzQRfuVdgCdFuakpAB3xUF5aFBUmZvw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1243878"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1243878"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="819888652"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="819888652"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:24 -0800
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
Subject: [PATCH v18 036/121] KVM: x86/mmu: Replace hardcoded value 0 for the initial value for SPTE
Date: Mon, 22 Jan 2024 15:53:12 -0800
Message-Id: <acdf09bf60cad12c495005bf3495c54f6b3069c9.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
index fa57db06f322..f1cec0f8e3d6 100644
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
@@ -6129,7 +6130,16 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
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


