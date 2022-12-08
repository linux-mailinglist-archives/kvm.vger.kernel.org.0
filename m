Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA20647A12
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiLHXgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiLHXfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:35:55 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8C06BCA6;
        Thu,  8 Dec 2022 15:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542554; x=1702078554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M34NeVz1PBu1b57DkBN+ftBVWONg/hFZwbeXaP8bdDQ=;
  b=HufHdii5sMJx2HeboEInTqVYkqGoP+Y9EVg0J+yrseRXQM6bEh+kBwKj
   ZoW/RiuL+8J3a/1D46tCUwIEBy18UW1hECxMT4graIk/DmPt8EkAwjuOV
   awfMJeFpamA464S64Y5FGsioveXsNMGpmqH7PyKtRt827DGEPQPjmXMcX
   N5GTKQiAEIXCmpypFR4uBAPfvw3AgAE0I0NeDCQzS6VwOOc2lMw+xpQUx
   Nqt6DtvU3617lfkRusUa7LWqNkVvxl2/3zu4LrigPTkENSCgy8T8behXB
   fUfhtcIUOwkqI1bqwsTJK4Zzh3Nv6mf9ZXytC/YzlGpYCvptvk0JAqDE4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403586486"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403586486"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677950896"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677950896"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:53 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v2 03/15] KVM: TDX: Pass KVM page level to tdh_mem_page_add() and tdh_mem_page_aug()
Date:   Thu,  8 Dec 2022 15:35:38 -0800
Message-Id: <3ec36b03fd43de9b0756dfad7bc789483381643b.1670541736.git.isaku.yamahata@intel.com>
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

Level info is needed in tdh_clflush_page() to generate the correct page
size.

Besides, explicitly pass level info to SEAMCALL instead of assuming
it's zero. It works naturally when 2MB support lands.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c     |  7 ++++---
 arch/x86/kvm/vmx/tdx_ops.h | 19 ++++++++++++-------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0645d28b93a7..4f8479c20553 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1298,6 +1298,7 @@ static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, kvm_pfn_t pfn)
 {
+	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	hpa_t hpa = pfn_to_hpa(pfn);
 	gpa_t gpa = gfn_to_gpa(gfn);
@@ -1319,7 +1320,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
 			return -EINVAL;
 
-		err = tdh_mem_page_aug(kvm_tdx->tdr.pa, gpa, hpa, &out);
+		err = tdh_mem_page_aug(kvm_tdx->tdr.pa, gpa, tdx_level, hpa, &out);
 		if (err == TDX_ERROR_SEPT_BUSY) {
 			tdx_unpin(kvm, pfn);
 			return -EAGAIN;
@@ -1358,8 +1359,8 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	kvm_tdx->source_pa = INVALID_PAGE;
 
 	do {
-		err = tdh_mem_page_add(kvm_tdx->tdr.pa, gpa, hpa, source_pa,
-				       &out);
+		err = tdh_mem_page_add(kvm_tdx->tdr.pa, gpa, tdx_level, hpa,
+				       source_pa, &out);
 		/*
 		 * This path is executed during populating initial guest memory
 		 * image. i.e. before running any vcpu.  Race is rare.
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 4db983b1dc94..4b03acce5003 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -19,6 +19,11 @@
 
 void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_output *out);
 
+static inline enum pg_level tdx_sept_level_to_pg_level(int tdx_level)
+{
+	return tdx_level + 1;
+}
+
 static inline void tdx_clflush_page(hpa_t addr, enum pg_level level)
 {
 	clflush_cache_range(__va(addr), KVM_HPAGE_SIZE(level));
@@ -60,11 +65,11 @@ static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 	return __seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, NULL);
 }
 
-static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
-				   struct tdx_module_output *out)
+static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, int level, hpa_t hpa,
+				   hpa_t source, struct tdx_module_output *out)
 {
-	tdx_clflush_page(hpa, PG_LEVEL_4K);
-	return seamcall_sept(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
+	tdx_clflush_page(hpa, tdx_sept_level_to_pg_level(level));
+	return seamcall_sept(TDH_MEM_PAGE_ADD, gpa | level, tdr, hpa, source, out);
 }
 
 static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
@@ -93,11 +98,11 @@ static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 	return __seamcall(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0, out);
 }
 
-static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, int level, hpa_t hpa,
 				   struct tdx_module_output *out)
 {
-	tdx_clflush_page(hpa, PG_LEVEL_4K);
-	return seamcall_sept(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
+	tdx_clflush_page(hpa, tdx_sept_level_to_pg_level(level));
+	return seamcall_sept(TDH_MEM_PAGE_AUG, gpa | level, tdr, hpa, 0, out);
 }
 
 static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
-- 
2.25.1

