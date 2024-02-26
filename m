Return-Path: <kvm+bounces-9760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87069866DCF
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:12:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2776B1F26265
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1958D133428;
	Mon, 26 Feb 2024 08:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HCxYqcri"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FD1132C13;
	Mon, 26 Feb 2024 08:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936178; cv=none; b=KTEBMZB0UIuDQ2T8s1BBP6Q6fXxrxBUrGDP1f2tIWIDuHqEsYo0rHoXj0O3FPQjTyaQlz61+cI9Qdt+P1had61vOh1rKMYIk9bv78qd3IXXtXBVFjTWkcVMk4ulZk7yUR4Kct9bCtuWY95kESYSasl1T5beDT1JqF45+jxWjpEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936178; c=relaxed/simple;
	bh=KhO9+dBhvKMB6pZRM19WAk4VyKqQ7LgR/rHkkV+J3mM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b7SWsRnIP3fZ9pdDLmDo7U9jqxY3uyC8DWk8+wo85w7YuNaGhdv7gS2DKFwC+6hNITyx5mnRuhALZzF1qfOyxDeL+nPFpSKZeivG0gApCa2F+vlBr4+BAeWwP9DXQN3dRZ3LyTkSDusymkmzofgMgFdCDXTAZWwUavTeOSgh0Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HCxYqcri; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936176; x=1740472176;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KhO9+dBhvKMB6pZRM19WAk4VyKqQ7LgR/rHkkV+J3mM=;
  b=HCxYqcri6thDVQhpln36QrpOHtyw/2LdhSYVToKrGibTAl+QcbryjonY
   72Za+j9It3lzwFaomifyidVdCHBZt8KMaumauvrll7oNm6f/CvSDDntS8
   F+lQtogeYUdfSYBlnitE9Fd7zAmmm3p2cPwgemRbIJQOzBTfqtwj1AUR/
   8msRaQZJsv2xfPhE6gWeapqwMgP289TszFzwADjVcAfosh+6xCdNHW/o7
   HQJ/oSFqWve/XSD5Um0qgyeU2aGOd84s9ZJEew+HFjUVaQazKcRJJxxD1
   cL76m5DT+h2JXwWzd/v2X96RgPi7wE3YhXqBIt5woZ6PYuuAponcOqNyx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751517"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751517"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735302"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:33 -0800
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
Subject: [PATCH v8 05/14] KVM: TDX: Update tdx_sept_{set,drop}_private_spte() to support large page
Date: Mon, 26 Feb 2024 00:29:19 -0800
Message-Id: <69f9845176b8a4f59440ce1c2d2d7f10c5585ed7.1708933624.git.isaku.yamahata@intel.com>
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

Allow large page level AUG and REMOVE for TDX pages.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 68 ++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8205d68ed477..d73a32588ad8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1454,11 +1454,12 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
 }
 
-static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
+static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn, enum pg_level level)
 {
-	struct page *page = pfn_to_page(pfn);
+	int i;
 
-	put_page(page);
+	for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++)
+		put_page(pfn_to_page(pfn + i));
 }
 
 static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
@@ -1475,7 +1476,7 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 
 	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
 	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EAGAIN;
 	}
 	if (unlikely(err == (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))) {
@@ -1484,7 +1485,7 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 		if (level_state.level == tdx_level &&
 		    level_state.state == TDX_SEPT_PENDING &&
 		    entry.leaf && entry.pfn == pfn && entry.sve) {
-			tdx_unpin(kvm, pfn);
+			tdx_unpin(kvm, pfn, level);
 			WARN_ON_ONCE(!(to_kvm_tdx(kvm)->attributes &
 				       TDX_TD_ATTR_SEPT_VE_DISABLE));
 			return -EAGAIN;
@@ -1492,7 +1493,7 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	}
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EIO;
 	}
 
@@ -1519,7 +1520,7 @@ static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn,
 		return -EINVAL;
 
 	if (KVM_BUG_ON(!kvm_tdx->source_page, kvm)) {
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EINVAL;
 	}
 
@@ -1537,7 +1538,7 @@ static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn,
 	 * fail with parameters user provided.
 	 */
 	if (err) {
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EIO;
 	}
 
@@ -1548,10 +1549,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, kvm_pfn_t pfn)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EINVAL;
+	int i;
 
 	/*
 	 * Because restricted mem doesn't support page migration with
@@ -1561,7 +1559,8 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * TODO: Once restricted mem introduces callback on page migration,
 	 * implement it and remove get_page/put_page().
 	 */
-	get_page(pfn_to_page(pfn));
+	for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++)
+		get_page(pfn_to_page(pfn + i));
 
 	if (likely(is_td_finalized(kvm_tdx)))
 		return tdx_mem_page_aug(kvm, gfn, level, pfn);
@@ -1578,11 +1577,9 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	gpa_t gpa = gfn_to_gpa(gfn);
 	hpa_t hpa = pfn_to_hpa(pfn);
 	hpa_t hpa_with_hkid;
+	int r = 0;
 	u64 err;
-
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EINVAL;
+	int i;
 
 	if (unlikely(!is_hkid_assigned(kvm_tdx))) {
 		/*
@@ -1592,7 +1589,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdx_reclaim_page(hpa, level);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return 0;
 	}
 
@@ -1609,22 +1606,27 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 	}
 
-	hpa_with_hkid = set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
-	do {
-		/*
-		 * TDX_OPERAND_BUSY can happen on locking PAMT entry.  Because
-		 * this page was removed above, other thread shouldn't be
-		 * repeatedly operating on this page.  Just retry loop.
-		 */
-		err = tdh_phymem_page_wbinvd(hpa_with_hkid);
-	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
-		return -EIO;
+	for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++) {
+		hpa_with_hkid = set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
+		do {
+			/*
+			 * TDX_OPERAND_BUSY can happen on locking PAMT entry.
+			 * Because this page was removed above, other thread
+			 * shouldn't be repeatedly operating on this page.
+			 * Simple retry should work.
+			 */
+			err = tdh_phymem_page_wbinvd(hpa_with_hkid);
+		} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
+		if (KVM_BUG_ON(err, kvm)) {
+			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
+			r = -EIO;
+		} else {
+			tdx_clear_page(hpa, PAGE_SIZE);
+			tdx_unpin(kvm, pfn + i, PG_LEVEL_4K);
+		}
+		hpa += PAGE_SIZE;
 	}
-	tdx_clear_page(hpa, PAGE_SIZE);
-	tdx_unpin(kvm, pfn);
-	return 0;
+	return r;
 }
 
 static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
-- 
2.25.1


