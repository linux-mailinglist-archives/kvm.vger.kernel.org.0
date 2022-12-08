Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF45647A22
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiLHXge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiLHXgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:36:05 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340D16FF21;
        Thu,  8 Dec 2022 15:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542561; x=1702078561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fdZOUAgVPY7OENFbNI36Sie/heTRpm7Xf4nyeZ5gKeQ=;
  b=Eh0dWeqJ9+88sN0Af+kU8Jnls/V/JVTwhCtUfR3tVXjFk/H9z2TlZqki
   SanHZfoM4QGeDoSefWY7Vfip55m5Jz1L3vbkSn6aYuIczhbNaVGwBVtsa
   Uxv4fwP9hFhTUGYfofMlhSVmOB6Us2cJHtKGvzqMk5VfBOYOkg89nHrQF
   VnHa9/uOLtoExp/U8TPjIaScvOHBnOl7IjPti+sR4xxFffu15eq4xuuAv
   xYZGyEeIhaarzcHaQQLxxOPA2huniR8lIQKIoOQoYFUKnWB78Kb0gWTkD
   0MB3j0/2Y6swcb+/0rn7+aMACPLTFW4UCskru3AnODElgagaCinOYUUdl
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403586551"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403586551"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677950998"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677950998"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:59 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v2 11/15] KVM: x86/tdp_mmu, TDX: Split a large page when 4KB page within it converted to shared
Date:   Thu,  8 Dec 2022 15:35:46 -0800
Message-Id: <de5455ea0c55da3f8496177909f1044b91b887bd.1670541736.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1670541736.git.isaku.yamahata@intel.com>
References: <cover.1670541736.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu/tdp_mmu.c         | 24 +++++++++++++++---------
 arch/x86/kvm/vmx/tdx.c             | 25 +++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx_arch.h        |  1 +
 arch/x86/kvm/vmx/tdx_ops.h         |  7 +++++++
 6 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 0cf928d12067..1e86542141f7 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -97,6 +97,7 @@ KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_OPTIONAL(link_private_spt)
 KVM_X86_OP_OPTIONAL(free_private_spt)
+KVM_X86_OP_OPTIONAL(split_private_spt)
 KVM_X86_OP_OPTIONAL(set_private_spte)
 KVM_X86_OP_OPTIONAL(remove_private_spte)
 KVM_X86_OP_OPTIONAL(zap_private_spte)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bb790466ebae..282b083f9b6a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1687,6 +1687,8 @@ struct kvm_x86_ops {
 				void *private_spt);
 	int (*free_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				void *private_spt);
+	int (*split_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				  void *private_spt);
 	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				 kvm_pfn_t pfn);
 	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e9af8c95a3ae..6fd982e3701e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -566,18 +566,24 @@ static int __must_check handle_changed_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	if (is_present) {
-		/* TDP MMU doesn't change present -> present */
-		KVM_BUG_ON(was_present, kvm);
+		void *private_spt;
 
-		/*
-		 * Use different call to either set up middle level
-		 * private page table, or leaf.
-		 */
-		if (is_leaf)
+		if (level > PG_LEVEL_4K && was_leaf && !is_leaf) {
+			/*
+			 * splitting large page into 4KB.
+			 * tdp_mmu_split_huage_page() => tdp_mmu_link_sp()
+			 */
+			private_spt = get_private_spt(gfn, new_spte, level);
+			KVM_BUG_ON(!private_spt, kvm);
+			ret = static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
+			kvm_flush_remote_tlbs(kvm);
+			if (!ret)
+				ret = static_call(kvm_x86_split_private_spt)(kvm, gfn,
+									     level, private_spt);
+		} else if (is_leaf)
 			ret = static_call(kvm_x86_set_private_spte)(kvm, gfn, level, new_pfn);
 		else {
-			void *private_spt = get_private_spt(gfn, new_spte, level);
-
+			private_spt = get_private_spt(gfn, new_spte, level);
 			KVM_BUG_ON(!private_spt, kvm);
 			ret = static_call(kvm_x86_link_private_spt)(kvm, gfn, level, private_spt);
 		}
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 39760ee95f04..ce7026136334 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1465,6 +1465,28 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn,
+				      enum pg_level level, void *private_spt)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	hpa_t hpa = __pa(private_spt);
+	struct tdx_module_output out;
+	u64 err;
+
+	/* See comment in tdx_sept_set_private_spte() */
+	err = tdh_mem_page_demote(kvm_tdx->tdr.pa, gpa, tdx_level, hpa, &out);
+	if (err == TDX_ERROR_SEPT_BUSY)
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
@@ -1474,8 +1496,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct tdx_module_output out;
 	u64 err;
 
-	/* For now large page isn't supported yet. */
-	WARN_ON_ONCE(level != PG_LEVEL_4K);
 	err = tdh_mem_range_block(kvm_tdx->tdr.pa, gpa, tdx_level, &out);
 	if (err == TDX_ERROR_SEPT_BUSY)
 		return -EAGAIN;
@@ -2660,6 +2680,7 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 
 	x86_ops->link_private_spt = tdx_sept_link_private_spt;
 	x86_ops->free_private_spt = tdx_sept_free_private_spt;
+	x86_ops->split_private_spt = tdx_sept_split_private_spt;
 	x86_ops->set_private_spte = tdx_sept_set_private_spte;
 	x86_ops->remove_private_spte = tdx_sept_remove_private_spte;
 	x86_ops->zap_private_spte = tdx_sept_zap_private_spte;
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 471a9f61fc81..508d9a1139ce 100644
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
index 4b03acce5003..60cbc7f94b18 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -133,6 +133,13 @@ static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct tdx_module_output *out
 	return __seamcall(TDH_MNG_RD, tdr, field, 0, 0, out);
 }
 
+static inline u64 tdh_mem_page_demote(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
+				      struct tdx_module_output *out)
+{
+	tdx_clflush_page(page, PG_LEVEL_4K);
+	return seamcall_sept(TDH_MEM_PAGE_DEMOTE, gpa | level, tdr, page, 0, out);
+}
+
 static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
 				struct tdx_module_output *out)
 {
-- 
2.25.1

