Return-Path: <kvm+bounces-6700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B27AC837CD7
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:19:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09AFCB2667B
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A15C614F525;
	Tue, 23 Jan 2024 00:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dYgkNXlQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C2C14DB52;
	Tue, 23 Jan 2024 00:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969361; cv=none; b=XATqWTfE1qYyB0CBjSbY3r+Lt1mhL4Qg8DKZ4/c7yivZnTYx8TbUzPBDlaA0QNTgYBQaPAVDx4pinLX6fzZUM8r/MzvVeMBz0CRkuhVKO1xMHLNDUqM9ti7SrYCTxZSshmdh+j4QAd1TztRZR2Zal1MFFC9VssOEY8Sm2fcYYbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969361; c=relaxed/simple;
	bh=B2fYQbNPR8MbbYhfXBQKVD17dagYwkNTN36DYUV0ZJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cv8Bdy+8n4FKBxyriX1FIS1mci4tQq7pxJvixjaY99cfpH6trNdO83ZHBTLhbzrX4O0Jg41zZK233y7X4/dSRe+tLCEirp1Z4lMGe448DukLcxscDw39edo/QWWEEw1lHxjlXHtWnA70zottjHOcMOTnOp4JWHWy5Mg3P0VJAXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dYgkNXlQ; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705969360; x=1737505360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B2fYQbNPR8MbbYhfXBQKVD17dagYwkNTN36DYUV0ZJ0=;
  b=dYgkNXlQmHT/rldo/W7S8HLNZPk1yDDparFkRrqs/RwsNQPkdlluHATK
   ZcMmPHb4q3LzKbMGa4k2yO+PzXz1nhDNe+g8+J2ODyi5oZG8pd1QLOEHW
   lKj5xdiuGWfVh2AggjEemCUVMtaJbf1jPdyvZ+eJWck3zytpAyUIXE6jf
   i7CPNZh1uoMTKNFdT268Yvptnu+5RE5M5ZE0MpLxO6Dv4fmUwmsPQc1yx
   ZZ5BqJKhUjqReEydPLoqQtZoC7zsv/5P5+BQh7e/ive0vEEqneOP0HL16
   geNm7AdvSdwiVG/Ej7acFJDTTaXkfJia6mfyC8FsAgKagxcnUMV7mSZVi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="405125657"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="405125657"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27825634"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:37 -0800
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
Subject: [PATCH v7 04/13] KVM: TDX: Update tdx_sept_{set,drop}_private_spte() to support large page
Date: Mon, 22 Jan 2024 16:22:19 -0800
Message-Id: <4a2f6212b3efb1fa7a51f0eafc4ed333e08eb07d.1705965958.git.isaku.yamahata@intel.com>
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

Allow large page level AUG and REMOVE for TDX pages.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 68 ++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 68f3a4c40be4..e2a0d521f806 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1504,11 +1504,12 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
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
@@ -1525,7 +1526,7 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 
 	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
 	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EAGAIN;
 	}
 	if (unlikely(err == (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))) {
@@ -1534,7 +1535,7 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 		if (level_state.level == tdx_level &&
 		    level_state.state == TDX_SEPT_PENDING &&
 		    entry.leaf && entry.pfn == pfn && entry.sve) {
-			tdx_unpin(kvm, pfn);
+			tdx_unpin(kvm, pfn, level);
 			WARN_ON_ONCE(!(to_kvm_tdx(kvm)->attributes &
 				       TDX_TD_ATTR_SEPT_VE_DISABLE));
 			return -EAGAIN;
@@ -1542,7 +1543,7 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	}
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EIO;
 	}
 
@@ -1578,7 +1579,7 @@ static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn,
 	 * always uses vcpu 0's page table and protected by vcpu->mutex).
 	 */
 	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EINVAL;
 	}
 
@@ -1596,7 +1597,7 @@ static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn,
 	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EIO;
 	} else if (measure) {
 		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
@@ -1616,10 +1617,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
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
@@ -1629,7 +1627,8 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * TODO: Once restricted mem introduces callback on page migration,
 	 * implement it and remove get_page/put_page().
 	 */
-	get_page(pfn_to_page(pfn));
+	for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++)
+		get_page(pfn_to_page(pfn + i));
 
 	if (likely(is_td_finalized(kvm_tdx)))
 		return tdx_mem_page_aug(kvm, gfn, level, pfn);
@@ -1646,11 +1645,9 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
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
@@ -1660,7 +1657,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdx_reclaim_page(hpa, level);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return 0;
 	}
 
@@ -1677,22 +1674,27 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
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


