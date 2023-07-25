Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7487626E7
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjGYWgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbjGYWf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:35:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7758683DB;
        Tue, 25 Jul 2023 15:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690324165; x=1721860165;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SwpsVor8kYJNjZcyc80JpJy0ODBvYwBoy+OegZ+04EY=;
  b=egoOfnMV/zAoOn7Z7PWr1xtt6QpLCb5I4s7WFr9xYw/OHmDRGaLVCYcP
   gIfoGxPWrP4mnRGPMsjBMoECoAFwGpBKV2iWMKUT+2Lpnp68oi+PFZCbg
   wjD5iG3akuqipQcnRiuTJ88Oi/dGdoLkdHktiBIvzhnfo8g6KwGET6wMm
   mNRT9xbsNQFeQABOP3/wkEM3IX9YTnXuaRFBEpHepMQjaxP1O7SLi/THs
   g4AEpKBx5QM3UbnOZZGphwTaCuDmliQ5KCrRMIMIqX6bloMgQZ7MAm6wt
   SGihOUJqcyHwN3wm2FgY7LJLWMfn8RjOxUxWdiHw5ljo5U/R7WFCjK6Zj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="371467154"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="371467154"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="972855833"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="972855833"
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
        hang.yuan@intel.com, tina.zhang@intel.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v4 12/16] KVM: x86/tdp_mmu, TDX: Split a large page when 4KB page within it converted to shared
Date:   Tue, 25 Jul 2023 15:23:58 -0700
Message-Id: <eeda770a7c5a4297324f878f42a1e96c799bdd21.1690323516.git.isaku.yamahata@intel.com>
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
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.c         | 26 +++++++++++++++++++++-----
 arch/x86/kvm/vmx/tdx.c             | 25 +++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx_arch.h        |  1 +
 arch/x86/kvm/vmx/tdx_ops.h         |  7 +++++++
 6 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index aaa7db45d809..5989503112c6 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -102,6 +102,7 @@ KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_OPTIONAL(link_private_spt)
 KVM_X86_OP_OPTIONAL(free_private_spt)
+KVM_X86_OP_OPTIONAL(split_private_spt)
 KVM_X86_OP_OPTIONAL(set_private_spte)
 KVM_X86_OP_OPTIONAL(remove_private_spte)
 KVM_X86_OP_OPTIONAL(zap_private_spte)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 97c9a0d5a9e3..7fe85b2d9a38 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1715,6 +1715,8 @@ struct kvm_x86_ops {
 				void *private_spt);
 	int (*free_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				void *private_spt);
+	int (*split_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				  void *private_spt);
 	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				 kvm_pfn_t pfn);
 	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e1169082c68c..c3963002722c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -648,23 +648,39 @@ static int __must_check __set_private_spte_present(struct kvm *kvm, tdp_ptep_t s
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
+	/*
+	 * TDP MMU doesn't change present -> present. split or merge of large
+	 * page can happen.
+	 */
+	KVM_BUG_ON(was_present && (was_leaf == is_leaf), kvm);
 
 	/*
 	 * Use different call to either set up middle level
 	 * private page table, or leaf.
 	 */
-	if (is_leaf)
+	if (level > PG_LEVEL_4K && was_leaf && !is_leaf) {
+		/*
+		 * splitting large page into 4KB.
+		 * tdp_mmu_split_huage_page() => tdp_mmu_link_sp()
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
index d6d5a9020f99..f2f1b40d9ae8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1534,6 +1534,28 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level, void *private_spt)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
+	hpa_t hpa = __pa(private_spt);
+	struct tdx_module_output out;
+	u64 err;
+
+	/* See comment in tdx_sept_set_private_spte() */
+	err = tdh_mem_page_demote(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
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
@@ -1547,8 +1569,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (unlikely(!is_hkid_assigned(kvm_tdx)))
 		return 0;
 
-	/* For now large page isn't supported yet. */
-	WARN_ON_ONCE(level != PG_LEVEL_4K);
 	err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
 	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
 		return -EAGAIN;
@@ -3052,6 +3072,7 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 
 	x86_ops->link_private_spt = tdx_sept_link_private_spt;
 	x86_ops->free_private_spt = tdx_sept_free_private_spt;
+	x86_ops->split_private_spt = tdx_sept_split_private_spt;
 	x86_ops->set_private_spte = tdx_sept_set_private_spte;
 	x86_ops->remove_private_spte = tdx_sept_remove_private_spte;
 	x86_ops->zap_private_spte = tdx_sept_zap_private_spte;
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 73fa33e7c943..dd5e5981b39e 100644
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
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index e3d7e19e5324..739c67af849b 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -161,6 +161,13 @@ static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct tdx_module_output *out
 	return tdx_seamcall(TDH_MNG_RD, tdr, field, 0, 0, out);
 }
 
+static inline u64 tdh_mem_page_demote(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
+				      struct tdx_module_output *out)
+{
+	tdx_clflush_page(page, PG_LEVEL_4K);
+	return tdx_seamcall_sept(TDH_MEM_PAGE_DEMOTE, gpa | level, tdr, page, 0, out);
+}
+
 static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
 				struct tdx_module_output *out)
 {
-- 
2.25.1

