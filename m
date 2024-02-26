Return-Path: <kvm+bounces-9765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACE5A866DDB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:14:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63007283F3F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD1841353E6;
	Mon, 26 Feb 2024 08:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B3lUEs4L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C452E3E4;
	Mon, 26 Feb 2024 08:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936194; cv=none; b=t+VE/3SgSAjXUHoJ+iXL4T/JlG5XKET1r2HmK8vpWRd35eznlfCadOEnGBwVY8jd+bK3/P1BxJZEXhSi5fO/GK/5ov7DlMIpI/GOxUCaapleniYDBiCwRK3fHG30XQydHM4bpb72tDAWC1AKG2cf9Xl9glRIYPLki9acRme0enc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936194; c=relaxed/simple;
	bh=bl9k+dlnXJduQusfWfzV1yxMDCOOObFRijgwH0XuSM0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L02AD6XoMdSu/LqbFShwfKGyb1SvTKrnfPyGEV+XrvKJo5+bXBX+7cWlHBiSdfucYCOq9GvpODqkjzm1fyw1Vj8p0JCvgFWCWrK4cZqjpmzGx9Gt1pcvXtZGAWEZbCBEjsXbnawTcDUMuQ65+VLCKyRnW7uf84zTGuUsOnaeQ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B3lUEs4L; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936193; x=1740472193;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bl9k+dlnXJduQusfWfzV1yxMDCOOObFRijgwH0XuSM0=;
  b=B3lUEs4LKGivOcp7I4hXL8xiz0Y0gnDYBgpc4EZPRvMok5HEHfqTuPGx
   bSLWRjlFfPR6Zn8oNhZW8u60INDSk1+Xg9gjCz50JhpX2Aiy5TPM8SSbb
   Og+i1mM9PmY8fn9R5R9VGDQ0Md09fFMJe8SGnDUmC3jmjtivn5Jesu+G7
   vbvuueFSN18Y1iaxixOsrxdW8fIYxtBPK91aGzRDsVS11fs3LyaWpOzCo
   +piZrRLKEIPwnO9osSr/vxNoPK4UmbjEHVvfhm9wDXjVA16xPoM/Etcb+
   XPEjgMzqumyWITHiNk8D4ADMzWYKay0nUeM/j1eeO6TCuqZaqif35pN/w
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="14623321"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="14623321"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6519419"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:34 -0800
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
Subject: [PATCH v8 10/14] KVM: x86/tdp_mmu, TDX: Split a large page when 4KB page within it converted to shared
Date: Mon, 26 Feb 2024 00:29:24 -0800
Message-Id: <b387dcfc499d2f17e448cd4574115d1fd2437921.1708933624.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933624.git.isaku.yamahata@intel.com>
References: <cover.1708933624.git.isaku.yamahata@intel.com>
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

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
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
index 3a7140129855..ada6865100ee 100644
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
index c864a1ff2eb1..9c9742cc469c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1766,6 +1766,8 @@ struct kvm_x86_ops {
 				void *private_spt);
 	int (*free_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				void *private_spt);
+	int (*split_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				  void *private_spt);
 	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				 kvm_pfn_t pfn);
 	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e3682794adda..0ac2a4911fd1 100644
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
index 6941e9483e7e..88af64658a9c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1650,6 +1650,30 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
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
@@ -1663,8 +1687,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (unlikely(!is_hkid_assigned(kvm_tdx)))
 		return 0;
 
-	/* For now large page isn't supported yet. */
-	WARN_ON_ONCE(level != PG_LEVEL_4K);
 	err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
 	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
 		return -EAGAIN;
@@ -3308,6 +3330,7 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 
 	x86_ops->link_private_spt = tdx_sept_link_private_spt;
 	x86_ops->free_private_spt = tdx_sept_free_private_spt;
+	x86_ops->split_private_spt = tdx_sept_split_private_spt;
 	x86_ops->set_private_spte = tdx_sept_set_private_spte;
 	x86_ops->remove_private_spte = tdx_sept_remove_private_spte;
 	x86_ops->zap_private_spte = tdx_sept_zap_private_spte;
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 19f2deafde5b..bb324f744bbf 100644
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
index 5366bf476d2c..416708e6cbb7 100644
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
index ef4748943ac7..d8f0d9aa7439 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -241,6 +241,19 @@ static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct tdx_module_args *out)
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


