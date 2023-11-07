Return-Path: <kvm+bounces-970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D939C7E42AB
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:05:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4DC16B23216
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B451436B17;
	Tue,  7 Nov 2023 15:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KMU3p1k0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF35734CD3
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:04:50 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D51619C;
	Tue,  7 Nov 2023 07:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369322; x=1730905322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sfcvaEnOpo4ero8hHRfU6N/0voaPVRE4zSXR2iFJIJ0=;
  b=KMU3p1k043Cj2m4eEp+vSg+TcV6RwEk5rc5rWkr+vSMO2i+wdAoy3FFY
   zwDmBoo9rhlpTAxOURUn8ziNRe9ohqJYCfzskEacS04oYPwepFFDCakfr
   B1gccTOq2NiX0Aso6aBVWGaHyYzWPTZcfqATnzdOG34sSh7GBXHWWRfpV
   72kRFDFZxLGUcs3mW/ATbwOoq5pr6D6E47/qFe0rfEmq+j86YT0/nTNv7
   HGj4egUqugMHxqJeXoykR4FwrUe69f8fnHzFWBGRVvpTzWAytR+ZC3+UJ
   08fGRR7JI6xEU9cgw7hzz38vOHWA1I91rE69qbbjk8g4JMFtBsZnfxnYL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="388397630"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="388397630"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:01:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10446878"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:01:03 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v6 14/16] KVM: x86/tdp_mmu: TDX: Implement merge pages into a large page
Date: Tue,  7 Nov 2023 07:00:41 -0800
Message-Id: <db6681db72a7667c06687923232277ddde2d9949.1699368363.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368363.git.isaku.yamahata@intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement merge_private_stp callback.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c       | 72 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx_arch.h  |  1 +
 arch/x86/kvm/vmx/tdx_errno.h |  2 +
 arch/x86/kvm/vmx/tdx_ops.h   |  6 +++
 4 files changed, 81 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 91eca578a7da..df53a971ff21 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1684,6 +1684,49 @@ static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static int tdx_sept_merge_private_spt(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level, void *private_spt)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_module_args out;
+	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
+	u64 err;
+
+	/* See comment in tdx_sept_set_private_spte() */
+	err = tdh_mem_page_promote(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
+	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
+		return -EAGAIN;
+	if (unlikely(err == (TDX_EPT_INVALID_PROMOTE_CONDITIONS |
+			     TDX_OPERAND_ID_RCX)))
+		/*
+		 * Some pages are accepted, some pending.  Need to wait for TD
+		 * to accept all pages.  Tell it the caller.
+		 */
+		return -EAGAIN;
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_PAGE_PROMOTE, err, &out);
+		return -EIO;
+	}
+	WARN_ON_ONCE(out.rcx != __pa(private_spt));
+
+	/*
+	 * TDH.MEM.PAGE.PROMOTE frees the Secure-EPT page for the lower level.
+	 * Flush cache for reuse.
+	 */
+	do {
+		err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(__pa(private_spt),
+							     to_kvm_tdx(kvm)->hkid));
+	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
+		return -EIO;
+	}
+
+	tdx_clear_page(__pa(private_spt), PAGE_SIZE);
+	return 0;
+}
+
 static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 				      enum pg_level level)
 {
@@ -1758,6 +1801,33 @@ static void tdx_track(struct kvm *kvm)
 
 }
 
+static int tdx_sept_unzap_private_spte(struct kvm *kvm, gfn_t gfn,
+				       enum pg_level level)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
+	struct tdx_module_args out;
+	u64 err;
+
+	do {
+		err = tdh_mem_range_unblock(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
+
+		/*
+		 * tdh_mem_range_block() is accompanied with tdx_track() via kvm
+		 * remote tlb flush.  Wait for the caller of
+		 * tdh_mem_range_block() to complete TDX track.
+		 */
+	} while (err == (TDX_TLB_TRACKING_NOT_DONE | TDX_OPERAND_ID_SEPT));
+	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
+		return -EAGAIN;
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MEM_RANGE_UNBLOCK, err, &out);
+		return -EIO;
+	}
+	return 0;
+}
+
 static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, void *private_spt)
 {
@@ -3204,9 +3274,11 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	x86_ops->link_private_spt = tdx_sept_link_private_spt;
 	x86_ops->free_private_spt = tdx_sept_free_private_spt;
 	x86_ops->split_private_spt = tdx_sept_split_private_spt;
+	x86_ops->merge_private_spt = tdx_sept_merge_private_spt;
 	x86_ops->set_private_spte = tdx_sept_set_private_spte;
 	x86_ops->remove_private_spte = tdx_sept_remove_private_spte;
 	x86_ops->zap_private_spte = tdx_sept_zap_private_spte;
+	x86_ops->unzap_private_spte = tdx_sept_unzap_private_spte;
 
 	return 0;
 
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index cab6a74446a0..fb7e54953a85 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -29,6 +29,7 @@
 #define TDH_MNG_KEY_FREEID		20
 #define TDH_MNG_INIT			21
 #define TDH_VP_INIT			22
+#define TDH_MEM_PAGE_PROMOTE		23
 #define TDH_MEM_SEPT_RD			25
 #define TDH_VP_RD			26
 #define TDH_MNG_KEY_RECLAIMID		27
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index bb093e292fef..940d6de332eb 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -23,6 +23,8 @@
 #define TDX_FLUSHVP_NOT_DONE			0x8000082400000000ULL
 #define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
 #define TDX_EPT_ENTRY_NOT_FREE			0xC0000B0200000000ULL
+#define TDX_TLB_TRACKING_NOT_DONE		0xC0000B0800000000ULL
+#define TDX_EPT_INVALID_PROMOTE_CONDITIONS	0xC0000B0900000000ULL
 #define TDX_EPT_ENTRY_STATE_INCORRECT		0xC0000B0D00000000ULL
 
 /*
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 38ab0ab1509c..774fee3b2d46 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -190,6 +190,12 @@ static inline u64 tdh_mem_page_demote(hpa_t tdr, gpa_t gpa, int level, hpa_t pag
 	return tdx_seamcall_sept(TDH_MEM_PAGE_DEMOTE, gpa | level, tdr, page, 0, out);
 }
 
+static inline u64 tdh_mem_page_promote(hpa_t tdr, gpa_t gpa, int level,
+				       struct tdx_module_args *out)
+{
+	return tdx_seamcall_sept(TDH_MEM_PAGE_PROMOTE, gpa | level, tdr, 0, 0, out);
+}
+
 static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
 				struct tdx_module_args *out)
 {
-- 
2.25.1


