Return-Path: <kvm+bounces-38660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 445E9A3D6B3
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:31:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 135023B7B19
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 10:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A37401F3D49;
	Thu, 20 Feb 2025 10:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GQctZt/A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EBD1F30DE;
	Thu, 20 Feb 2025 10:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740047263; cv=none; b=Hj0Eiy/c3vvyi883xvXbK5w1l+QWgVL34+T7r8jKUOlfc12E2nyi883qQMEaQhkgRNuF7eVbIpBpUajVX3OxHGIR3QTD5KwXiyyKXwtxat4WddFUSeadSV/OLO63qibUTT9D/bP/3kKhQznnseTnYuvOQp8lV22vejDFrVUyzHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740047263; c=relaxed/simple;
	bh=guVlViceCpWzhyE0XNu0a1so6svtGjYT+uKK+f2b4B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miVkHs34nh+ytp011TVTKc/lJSZxiydfOwQ35LKvn8KM7ygHLm2mn9ggJMRs1Z6yCQSKRYvk5+ETFaq+GqmKJeF9ldqZ8K+RWE0CkuC5kFGoig08oOPmTJrPEcIYk+tjvOApMcenr0tGBGIklYLkqeR1fIRgmYMiM+YwVLzD7s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GQctZt/A; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740047261; x=1771583261;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=guVlViceCpWzhyE0XNu0a1so6svtGjYT+uKK+f2b4B0=;
  b=GQctZt/AZEGzk0lzms7lkk+adMU9SQkKXuvMvs1K7hKtaiDZoA5SS7rG
   GesrHy7jvCZRATZ74IFkeede2sqnR8Cs20XhIbShSzGIxDk3fIHt1eTWE
   2+HcRvmw6R9rdIpO7YtrDPt3lOWk462JhevEvLOCVm6LUAI4YCuZnMDMK
   uw9WqvHzi50Iwe8TJj3pFT0kFaE0FGCFZngl/b+3dSGKbz2OKXkms5bfA
   CTcndNgvlacBnu5pKDnKnsHKs5W7M4Mf4RlFJ1L2UpaAkIuudBz31aK1P
   qqXOFBTvsGCrIerU7lObez49UtHU35KDRMeEF1zNVlQMqydXeN7BRyyOq
   g==;
X-CSE-ConnectionGUID: 9UnnlzgCQWW4qG9XNBeCaQ==
X-CSE-MsgGUID: vg2VLb58Qh+71IVlakVG/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="40674768"
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="40674768"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 02:27:41 -0800
X-CSE-ConnectionGUID: 4bW6r7wVSD2MxKV8fS5PNw==
X-CSE-MsgGUID: OgJK/ykgShahoKJKgVtKLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="115668509"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 02:27:39 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 1/2] KVM: TDX: Handle SEPT zap error due to page add error in premap
Date: Thu, 20 Feb 2025 18:26:29 +0800
Message-ID: <20250220102629.24476-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250220102436.24373-1-yan.y.zhao@intel.com>
References: <20250220102436.24373-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the handling of SEPT zap errors caused by unsuccessful execution of
tdh_mem_page_add() in KVM_TDX_INIT_MEM_REGION from
tdx_sept_drop_private_spte() to tdx_sept_zap_private_spte(). Introduce a
new helper function tdx_is_sept_zap_err_due_to_premap() to detect this
specific error.

During the IOCTL KVM_TDX_INIT_MEM_REGION, KVM premaps leaf SPTEs in the
mirror page table before the corresponding entry in the private page table
is successfully installed by tdh_mem_page_add(). If an error occurs during
the invocation of tdh_mem_page_add(), a mismatch between the mirror and
private page tables results in SEAMCALLs for SEPT zap returning the error
code TDX_EPT_ENTRY_STATE_INCORRECT.

The error TDX_EPT_WALK_FAILED is not possible because, during
KVM_TDX_INIT_MEM_REGION, KVM only premaps leaf SPTEs after successfully
mapping non-leaf SPTEs. Unlike leaf SPTEs, there is no mismatch in non-leaf
PTEs between the mirror and private page tables. Therefore, during zap,
SEAMCALLs should find an empty leaf entry in the private EPT, leading to
the error TDX_EPT_ENTRY_STATE_INCORRECT instead of TDX_EPT_WALK_FAILED.

Since tdh_mem_range_block() is always invoked before tdh_mem_page_remove(),
move the handling of SEPT zap errors from tdx_sept_drop_private_spte() to
tdx_sept_zap_private_spte(). In tdx_sept_zap_private_spte(), return 0 for
errors due to premap to skip executing other SEAMCALLs for zap, which are
unnecessary. Return 1 to indicate no other errors, allowing the execution
of other zap SEAMCALLs to continue.

The failure of tdh_mem_page_add() is uncommon and has not been observed in
real workloads. Currently, this failure is only hypothetically triggered by
skipping the real SEAMCALL and faking the add error in the SEAMCALL
wrapper. Additionally, without this fix, there will be no host crashes or
other severe issues.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 64 +++++++++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ff28528d8d2c..b550ba5e9864 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1606,20 +1606,6 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		tdx_no_vcpus_enter_stop(kvm);
 	}
 
-	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE &&
-		     err == (TDX_EPT_WALK_FAILED | TDX_OPERAND_ID_RCX))) {
-		/*
-		 * Page is mapped by KVM_TDX_INIT_MEM_REGION, but hasn't called
-		 * tdh_mem_page_add().
-		 */
-		if ((!is_last_spte(entry, level) || !(entry & VMX_EPT_RWX_MASK)) &&
-		    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
-			atomic64_dec(&kvm_tdx->nr_premapped);
-			tdx_unpin(kvm, page);
-			return 0;
-		}
-	}
-
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
 		return -EIO;
@@ -1657,8 +1643,41 @@ int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+/*
+ * Check if the error returned from a SEPT zap SEAMCALL is due to that a page is
+ * mapped by KVM_TDX_INIT_MEM_REGION without tdh_mem_page_add() being called
+ * successfully.
+ *
+ * Since tdh_mem_sept_add() must have been invoked successfully before a
+ * non-leaf entry present in the mirrored page table, the SEPT ZAP related
+ * SEAMCALLs should not encounter err TDX_EPT_WALK_FAILED. They should instead
+ * find TDX_EPT_ENTRY_STATE_INCORRECT due to an empty leaf entry found in the
+ * SEPT.
+ *
+ * Further check if the returned entry from SEPT walking is with RWX permissions
+ * to filter out anything unexpected.
+ *
+ * Note: @level is pg_level, not the tdx_level. The tdx_level extracted from
+ * level_state returned from a SEAMCALL error is the same as that passed into
+ * the SEAMCALL.
+ */
+static int tdx_is_sept_zap_err_due_to_premap(struct kvm_tdx *kvm_tdx, u64 err,
+					     u64 entry, int level)
+{
+	if (!err || kvm_tdx->state == TD_STATE_RUNNABLE)
+		return false;
+
+	if (err != (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))
+		return false;
+
+	if ((is_last_spte(entry, level) && (entry & VMX_EPT_RWX_MASK)))
+		return false;
+
+	return true;
+}
+
 static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
-				     enum pg_level level)
+				     enum pg_level level, struct page *page)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -1676,12 +1695,18 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
 		tdx_no_vcpus_enter_stop(kvm);
 	}
+	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
+	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
+		atomic64_dec(&kvm_tdx->nr_premapped);
+		tdx_unpin(kvm, page);
+		return 0;
+	}
 
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
 		return -EIO;
 	}
-	return 0;
+	return 1;
 }
 
 /*
@@ -1759,6 +1784,7 @@ int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 				 enum pg_level level, kvm_pfn_t pfn)
 {
+	struct page *page = pfn_to_page(pfn);
 	int ret;
 
 	/*
@@ -1769,8 +1795,8 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
 		return -EINVAL;
 
-	ret = tdx_sept_zap_private_spte(kvm, gfn, level);
-	if (ret)
+	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
+	if (ret <= 0)
 		return ret;
 
 	/*
@@ -1779,7 +1805,7 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	 */
 	tdx_track(kvm);
 
-	return tdx_sept_drop_private_spte(kvm, gfn, level, pfn_to_page(pfn));
+	return tdx_sept_drop_private_spte(kvm, gfn, level, page);
 }
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
-- 
2.43.2


