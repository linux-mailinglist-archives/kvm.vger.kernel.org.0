Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E967626E5
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbjGYWgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbjGYWgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:36:00 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE8F83E5;
        Tue, 25 Jul 2023 15:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690324168; x=1721860168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/sulDBAQPv/3f6qn1kAE0FJbpL2CD1Bkq27pU5IWjjk=;
  b=DxxZ1GMiuT6/1wegM+8x1x8SO5jojb7sY8fd+aU0fRcWymXMn0Wv2HvA
   R/Behmj58P95nMYL9hEk7LNFS2K/dVPCIturb2u6MEa82ORx3+7nJoqCG
   kOf4qCb0LAfuDlTB+IUI4Ay3TyvwvLoU22ctTT9P7P46VkdNJuD4ELQaZ
   2nH1+jRIJyV8uVutvFwFgZWhyCdydRrXTvBw221gHdSuidojrZlui2uSF
   kGi+9rW/HjxkoMs9hPVnsrePIGTI6SfTmKNNqPqvnjGKSfDN+aVmXhwAa
   VzyWv7gtpzaJR85gO/qd3N0lA88KT7gV2or8twFAmoMPEL/++86qLjiPM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="371467164"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="371467164"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="972855839"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="972855839"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:13 -0700
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
Subject: [RFC PATCH v4 14/16] KVM: x86/tdp_mmu: TDX: Implement merge pages into a large page
Date:   Tue, 25 Jul 2023 15:24:00 -0700
Message-Id: <55fa2a218702db4bc2f2619322fb7645f00f04e2.1690323516.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690323516.git.isaku.yamahata@intel.com>
References: <cover.1690323516.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index f2f1b40d9ae8..2f375e0e45aa 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1556,6 +1556,49 @@ static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static int tdx_sept_merge_private_spt(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level, void *private_spt)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_module_output out;
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
@@ -1629,6 +1672,33 @@ static void tdx_track(struct kvm_tdx *kvm_tdx)
 
 }
 
+static int tdx_sept_unzap_private_spte(struct kvm *kvm, gfn_t gfn,
+				       enum pg_level level)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
+	struct tdx_module_output out;
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
@@ -3073,9 +3143,11 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
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
index dd5e5981b39e..0828a35dc4e6 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -29,6 +29,7 @@
 #define TDH_MNG_KEY_FREEID		20
 #define TDH_MNG_INIT			21
 #define TDH_VP_INIT			22
+#define TDH_MEM_PAGE_PROMOTE		23
 #define TDH_VP_RD			26
 #define TDH_MNG_KEY_RECLAIMID		27
 #define TDH_PHYMEM_PAGE_RECLAIM		28
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index 53dc14ba9107..f1a050cae05c 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -21,6 +21,8 @@
 #define TDX_KEY_CONFIGURED			0x0000081500000000ULL
 #define TDX_NO_HKID_READY_TO_WBCACHE		0x0000082100000000ULL
 #define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
+#define TDX_TLB_TRACKING_NOT_DONE		0xC0000B0800000000ULL
+#define TDX_EPT_INVALID_PROMOTE_CONDITIONS	0xC0000B0900000000ULL
 
 /*
  * TDG.VP.VMCALL Status Codes (returned in R10)
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 739c67af849b..df41ab8f4ff7 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -168,6 +168,12 @@ static inline u64 tdh_mem_page_demote(hpa_t tdr, gpa_t gpa, int level, hpa_t pag
 	return tdx_seamcall_sept(TDH_MEM_PAGE_DEMOTE, gpa | level, tdr, page, 0, out);
 }
 
+static inline u64 tdh_mem_page_promote(hpa_t tdr, gpa_t gpa, int level,
+				       struct tdx_module_output *out)
+{
+	return tdx_seamcall_sept(TDH_MEM_PAGE_PROMOTE, gpa | level, tdr, 0, 0, out);
+}
+
 static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
 				struct tdx_module_output *out)
 {
-- 
2.25.1

