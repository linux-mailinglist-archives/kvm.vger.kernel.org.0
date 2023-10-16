Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5747CAFAA
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbjJPQgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbjJPQfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:35:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731F98279;
        Mon, 16 Oct 2023 09:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473397; x=1729009397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kvkqy/cP7bWGs8zyVnGaL4oZutpS6cXKUkDMo9VqnfE=;
  b=QXuNZzLML+Q5d+7R0Qjk+5lOLit3ZMS3U+SL/p9fwrcAKUNQGdA8CXcI
   bigRbIJ4i4z1HW09c2tEx/FpbVce0YISfC13gewEIqEqq9Rgo9X7hNWC0
   C0obkYsQn9Z+HFrzEUpbT5ELYwbteRAhl4spJjO2AiNHqOTTyzpiUWdRF
   nxJZCS/+I9XAdROhqgZntZkh76/NmxJOUJd6Jqa6EQhtA4Z73hCegfVRs
   F0Jy/Jy74W9mV/HcEJAlzVjurisGo6fuIKARBlOmIXrVd41AyMS7VHVc2
   CQ4ojgC0QXvcYwClJ8iVcZWzPu8q3r1h6Jl3CIpXi/tv/ehzRMw+RmM5E
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471793210"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="471793210"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:21:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="899569269"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="899569269"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:19:18 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [RFC PATCH v5 14/16] KVM: x86/tdp_mmu: TDX: Implement merge pages into a large page
Date:   Mon, 16 Oct 2023 09:21:05 -0700
Message-Id: <341dc50c854d078c91097dd3145a55fc2c50625c.1697473009.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697473009.git.isaku.yamahata@intel.com>
References: <cover.1697473009.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
index 1db56696ad99..2627dcf240cc 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1683,6 +1683,49 @@ static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn,
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
@@ -1757,6 +1800,33 @@ static void tdx_track(struct kvm *kvm)
 
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
@@ -3304,9 +3374,11 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
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
index 0c9823fcf829..aa9c927e4adc 100644
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
index dbee050b2356..99424336f534 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -23,6 +23,8 @@
 #define TDX_FLUSHVP_NOT_DONE			0x8000082400000000ULL
 #define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
 #define TDX_EPT_ENTRY_NOT_FREE			0xC0000B0200000000ULL
+#define TDX_TLB_TRACKING_NOT_DONE		0xC0000B0800000000ULL
+#define TDX_EPT_INVALID_PROMOTE_CONDITIONS	0xC0000B0900000000ULL
 
 /*
  * TDG.VP.VMCALL Status Codes (returned in R10)
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 7293510fa2e5..3094008ba390 100644
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

