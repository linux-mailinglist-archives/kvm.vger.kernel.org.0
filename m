Return-Path: <kvm+bounces-6704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F290837BAA
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:04:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4A801C28332
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0A014FCED;
	Tue, 23 Jan 2024 00:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nEpL8G0o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25C114F533;
	Tue, 23 Jan 2024 00:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969365; cv=none; b=H/uarzhDEdtTLw+12hiYot8RLI1QH9DgjRth6ju7JeWLNRt6IoL1jbWWIEbCE5N0kp87lM5L1Iwdidd6jrWBCe2EjsNI5nK9Q5f8j3vQWABY92YQa7jD3YuX15W7fXjOAY2Bs9jb3cluE8g8cMb0/t/m6jDU09EDSMQjjBt2zwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969365; c=relaxed/simple;
	bh=kM+vIsAToVEntSe3/3/9ndsSycv4FTnSynsT+d7GTFU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t6uaNmZzSVLPUcSjByH1AII2YeJqc8cZjFEoyQVcj0sbOScdqaIVCcGrkUss8ixsAF5XHzK77YIy0yhDMkeNugUQGlMLsrCzr5vKksCh+X3QTs6IrX8MUpjZa/LEEtvNbwHmKFTT2oq/F78bSiMHL2gjANOmZxNiAKzG2vpna7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nEpL8G0o; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705969363; x=1737505363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kM+vIsAToVEntSe3/3/9ndsSycv4FTnSynsT+d7GTFU=;
  b=nEpL8G0oo4mIclSW+qQYsHc2n2bWo8pVsRIkQmvB16JAesy0PAmFLhMH
   zGfyvfe6WmHnO8H3zMwrFVyj5i9jx6Zr6mg6RcP4SOZzat/QuqZEUJiE0
   SRIKIuaoiB/D1KfEPf/gkgMYwlN2UdAav0C/W1frLoLEaagiR/T/1ZRmL
   aCLovA2Ih1PvHcBTO3SUIo+UlUivE4dHJDs224K+1e+FvajTBTCeAHsRx
   wxVJN7AlHLvwpQ3Ufu7K9SAUJ5tPPVUf6ymjRZJ5/rwoSmO1+mJIYCpn2
   AN0qMdc7zCXKoFMZOymasrUspeiJgVOyMXdBm0NKzWWOjp/j9PFV0EGKf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="405125689"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="405125689"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27825656"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:40 -0800
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
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v7 09/13] KVM: x86/tdp_mmu, TDX: Split a large page when 4KB page within it converted to shared
Date: Mon, 22 Jan 2024 16:22:24 -0800
Message-Id: <c7b2a64d65f1911e84891eba92fd139e24cc9862.1705965958.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965958.git.isaku.yamahata@intel.com>
References: <cover.1705965958.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

When mapping the shared page for TDX, it needs to zap private alias.

In the case that private page is mapped as large page (2MB), it can be
removed directly only when the whole 2MB is converted to shared.
Otherwise, it has to split 2MB page into 512 4KB page, and only remove
the pages that converted to shared.

When a present large leaf spte switches to present non-leaf spte, TDX needs
to split the corresponding SEPT page to reflect it.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v7:
- catch up for tdx_seamcall() change
- typo in a comment of __set_private_spte_present()
- improved a comment in tdx_sept_split_private_spt()

v6:
- repeat TDH.MEM.PAGE.DEMOTE on TDX_INTERRUPTED_RESTARTABLE
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.c         | 21 ++++++++++++++++-----
 arch/x86/kvm/vmx/tdx.c             | 27 +++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx_arch.h        |  1 +
 arch/x86/kvm/vmx/tdx_errno.h       |  1 +
 arch/x86/kvm/vmx/tdx_ops.h         | 13 +++++++++++++
 7 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 527db174d6b5..08c55c3d6e5b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -105,6 +105,7 @@ KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_OPTIONAL(link_private_spt)
 KVM_X86_OP_OPTIONAL(free_private_spt)
+KVM_X86_OP_OPTIONAL(split_private_spt)
 KVM_X86_OP_OPTIONAL(set_private_spte)
 KVM_X86_OP_OPTIONAL(remove_private_spte)
 KVM_X86_OP_OPTIONAL(zap_private_spte)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3a2237ed9dba..8123fad88750 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1783,6 +1783,8 @@ struct kvm_x86_ops {
 				void *private_spt);
 	int (*free_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				void *private_spt);
+	int (*split_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				  void *private_spt);
 	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				 kvm_pfn_t pfn);
 	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 98de2c093815..3f7307938982 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -588,23 +588,34 @@ static int __must_check __set_private_spte_present(struct kvm *kvm, tdp_ptep_t s
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
+	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
+	void *private_spt;
 	int ret = 0;
 
 	lockdep_assert_held(&kvm->mmu_lock);
-	/* TDP MMU doesn't change present -> present */
-	KVM_BUG_ON(was_present, kvm);
 
 	/*
 	 * Use different call to either set up middle level
 	 * private page table, or leaf.
 	 */
-	if (is_leaf)
+	if (level > PG_LEVEL_4K && was_leaf && !is_leaf) {
+		/*
+		 * splitting large page into 4KB.
+		 * tdp_mmu_split_huge_page() => tdp_mmu_link_sp()
+		 */
+		private_spt = get_private_spt(gfn, new_spte, level);
+		KVM_BUG_ON(!private_spt, kvm);
+		ret = static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
+		kvm_flush_remote_tlbs(kvm);
+		if (!ret)
+			ret = static_call(kvm_x86_split_private_spt)(kvm, gfn,
+								     level, private_spt);
+	} else if (is_leaf)
 		ret = static_call(kvm_x86_set_private_spte)(kvm, gfn, level, new_pfn);
 	else {
-		void *private_spt = get_private_spt(gfn, new_spte, level);
-
+		private_spt = get_private_spt(gfn, new_spte, level);
 		KVM_BUG_ON(!private_spt, kvm);
 		ret = static_call(kvm_x86_link_private_spt)(kvm, gfn, level, private_spt);
 	}
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 747152af0882..10dbe4a4db7a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1718,6 +1718,30 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level, void *private_spt)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
+	hpa_t hpa = __pa(private_spt);
+	struct tdx_module_args out;
+	u64 err;
+
+	/* See comment in tdx_sept_set_private_spte() to pin pages. */
+	do {
+		err = tdh_mem_page_demote(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
+	} while (err == TDX_INTERRUPTED_RESTARTABLE);
+	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
+		return -EAGAIN;
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_PAGE_DEMOTE, err, &out);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 				      enum pg_level level)
 {
@@ -1731,8 +1755,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (unlikely(!is_hkid_assigned(kvm_tdx)))
 		return 0;
 
-	/* For now large page isn't supported yet. */
-	WARN_ON_ONCE(level != PG_LEVEL_4K);
 	err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
 	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
 		return -EAGAIN;
@@ -3286,6 +3308,7 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 
 	x86_ops->link_private_spt = tdx_sept_link_private_spt;
 	x86_ops->free_private_spt = tdx_sept_free_private_spt;
+	x86_ops->split_private_spt = tdx_sept_split_private_spt;
 	x86_ops->set_private_spte = tdx_sept_set_private_spte;
 	x86_ops->remove_private_spte = tdx_sept_remove_private_spte;
 	x86_ops->zap_private_spte = tdx_sept_zap_private_spte;
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index eb62b8804cb4..e663abaa3aa0 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -21,6 +21,7 @@
 #define TDH_MNG_CREATE			9
 #define TDH_VP_CREATE			10
 #define TDH_MNG_RD			11
+#define TDH_MEM_PAGE_DEMOTE		15
 #define TDH_MR_EXTEND			16
 #define TDH_MR_FINALIZE			17
 #define TDH_VP_FLUSH			18
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index bb093e292fef..d08b4d14e57b 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -11,6 +11,7 @@
  */
 #define TDX_NON_RECOVERABLE_VCPU		0x4000000100000000ULL
 #define TDX_INTERRUPTED_RESUMABLE		0x8000000300000000ULL
+#define TDX_INTERRUPTED_RESTARTABLE		0x8000000400000000ULL
 #define TDX_OPERAND_INVALID			0xC000010000000000ULL
 #define TDX_OPERAND_BUSY			0x8000020000000000ULL
 #define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000ULL
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index ce722e917d14..772e2e7d61e7 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -249,6 +249,19 @@ static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct tdx_module_args *out)
 	return tdx_seamcall(TDH_MNG_RD, &in, out);
 }
 
+static inline u64 tdh_mem_page_demote(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
+				      struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa | level,
+		.rdx = tdr,
+		.r8 = page,
+	};
+
+	tdx_clflush_page(page, PG_LEVEL_4K);
+	return tdx_seamcall_sept(TDH_MEM_PAGE_DEMOTE, &in, out);
+}
+
 static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
 				struct tdx_module_args *out)
 {
-- 
2.25.1


