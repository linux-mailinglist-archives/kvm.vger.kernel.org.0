Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B548558BDE1
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242330AbiHGWcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242186AbiHGWbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:31:38 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635E41834B;
        Sun,  7 Aug 2022 15:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659910730; x=1691446730;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EtDHJys8JQbAqNtz2Ir/5m2Mw+AMu1zQswdGXIEagW4=;
  b=h89AAWd7LSMSc2gBjrHLWeCVKydKofK/HdkiDACZbnmqd3QYSwP37x1D
   g7DsRYh7HNBs+bMK4eYsd6i5su7Oz+0bk2g2NBU67HiCLhWg4mTzEFfPk
   A5hlWSpGcfTjaWhrqLIGdC66raTNjXftTRPXEhs1l/MeGDkvLrcutmh4N
   PuIaq2ifllQhKdELsHMmqWi+Tih8dneod2z9yQujdQa6vQB+c6dPbgVBO
   FELvA1qg4hYhoixaJ3PwrfD3HGoUYIBzCTgJJ7FXy1L1Y7PNUQ2XPD+LG
   QZyZyCT/orki2k/BUCQ7swXWsuBx2WrbpCISM0AE+PX1Z8NsOo6qQoXBw
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270852832"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="270852832"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="632642309"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH 04/13] KVM: TDX: Pass KVM page level to tdh_mem_page_add() and tdh_mem_page_aug()
Date:   Sun,  7 Aug 2022 15:18:37 -0700
Message-Id: <86bb6025f375587aae50a59c347fb16ea28efcd6.1659854957.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854957.git.isaku.yamahata@intel.com>
References: <cover.1659854957.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Level info is needed in tdh_clflush_page() to generate the correct page
size.

Besides, explicitly pass level info to SEAMCALL instead of assuming
it's zero. It works naturally when 2MB support lands.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c     |  7 ++++---
 arch/x86/kvm/vmx/tdx_ops.h | 21 ++++++++++++++-------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2d34f0b41b26..b717d50ee4d3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1443,6 +1443,7 @@ static void tdx_unpin_pfn(struct kvm *kvm, kvm_pfn_t pfn)
 static void __tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 					enum pg_level level, kvm_pfn_t pfn)
 {
+	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	hpa_t hpa = pfn_to_hpa(pfn);
 	gpa_t gpa = gfn_to_gpa(gfn);
@@ -1463,7 +1464,7 @@ static void __tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
 			return;
 
-		err = tdh_mem_page_aug(kvm_tdx->tdr.pa, gpa, hpa, &out);
+		err = tdh_mem_page_aug(kvm_tdx->tdr.pa, gpa, tdx_level, hpa, &out);
 		if (KVM_BUG_ON(err, kvm)) {
 			pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
 			tdx_unpin_pfn(kvm, pfn);
@@ -1491,12 +1492,12 @@ static void __tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	source_pa = kvm_tdx->source_pa & ~KVM_TDX_MEASURE_MEMORY_REGION;
 
-	err = tdh_mem_page_add(kvm_tdx->tdr.pa, gpa, hpa, source_pa, &out);
+	err = tdh_mem_page_add(kvm_tdx->tdr.pa, gpa, tdx_level, hpa, source_pa, &out);
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
 		tdx_unpin_pfn(kvm, pfn);
 	} else if ((kvm_tdx->source_pa & KVM_TDX_MEASURE_MEMORY_REGION))
-		tdx_measure_page(kvm_tdx, gpa);
+		tdx_measure_page(kvm_tdx, gpa); /* TODO: handle page size > 4KB */
 
 	kvm_tdx->source_pa = INVALID_PAGE;
 }
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 9accf2fe04ae..da662aa46cd9 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -19,6 +19,11 @@
 
 void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_output *out);
 
+static inline enum pg_level tdx_sept_level_to_pg_level(int tdx_level)
+{
+       return tdx_level + 1;
+}
+
 static inline void tdx_clflush_page(hpa_t addr, enum pg_level level)
 {
 	clflush_cache_range(__va(addr), KVM_HPAGE_SIZE(level));
@@ -50,11 +55,12 @@ static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 	return __seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, NULL);
 }
 
-static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
-				   struct tdx_module_output *out)
+static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, int level, hpa_t hpa,
+				   hpa_t source, struct tdx_module_output *out)
 {
-	tdx_clflush_page(hpa, PG_LEVEL_4K);
-	return seamcall_sept_retry(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
+	tdx_clflush_page(hpa, tdx_sept_level_to_pg_level(level));
+	return seamcall_sept_retry(TDH_MEM_PAGE_ADD, gpa | level, tdr, hpa,
+				   source, out);
 }
 
 static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
@@ -84,11 +90,12 @@ static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 	return __seamcall(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0, out);
 }
 
-static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, int level, hpa_t hpa,
 				   struct tdx_module_output *out)
 {
-	tdx_clflush_page(hpa, PG_LEVEL_4K);
-	return seamcall_sept_retry(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
+	tdx_clflush_page(hpa, tdx_sept_level_to_pg_level(level));
+	return seamcall_sept_retry(TDH_MEM_PAGE_AUG, gpa | level, tdr, hpa, 0,
+				   out);
 }
 
 static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
-- 
2.25.1

