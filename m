Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721B67626D6
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbjGYWgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjGYWfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:35:51 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE8183C9;
        Tue, 25 Jul 2023 15:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690324155; x=1721860155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cz3Z/fMsorXNGBvik/gAt+HVjJZFPQba00xTkIHG2+o=;
  b=dqqKGP3Th8bgM7bIV0Ba621uW+trsm3LKQIgkup/5gQ2bOXbxUzEuqFd
   HP3xls5jllwG50rC/FrNqj5ndWXLfsGpFhuPZfqUq3xeOz/eB9AAeZ0+s
   VAZ9UHK1k+eIuXReNesCuM06bb75lnaRqwsxU3ik8TobCYygtwK4ASD6/
   4++BFtg3OV3FBtnGzCw717k84dlDdK3z9zd0ycwPFAQNsWy7G41uOYWk+
   1r5clSKG0ycNbVpeYU/zciexDq3iY7aLS4H4nvsNHlSf9AvC+uWmytR3b
   pytv7jdDWTnPud0tzJ1LoZHLIveOUyxqQvaUjJOtVeZQgKeqLyrg46ZRj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="371467105"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="371467105"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="972855792"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="972855792"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:09 -0700
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
Subject: [RFC PATCH v4 03/16] KVM: TDX: Pass KVM page level to tdh_mem_page_add() and tdh_mem_page_aug()
Date:   Tue, 25 Jul 2023 15:23:49 -0700
Message-Id: <1ddcfb83506e9448a4bd10ae913bb8c67acd99fc.1690323516.git.isaku.yamahata@intel.com>
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
index 1a8a3fa92303..f3a8ae3e81bd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1365,6 +1365,7 @@ static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, kvm_pfn_t pfn)
 {
+	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	hpa_t hpa = pfn_to_hpa(pfn);
 	gpa_t gpa = gfn_to_gpa(gfn);
@@ -1389,7 +1390,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
 			return -EINVAL;
 
-		err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, hpa, &out);
+		err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
 		if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
 			tdx_unpin(kvm, pfn);
 			return -EAGAIN;
@@ -1428,8 +1429,8 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	kvm_tdx->source_pa = INVALID_PAGE;
 
 	do {
-		err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, hpa, source_pa,
-				       &out);
+		err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, tdx_level, hpa,
+				       source_pa, &out);
 		/*
 		 * This path is executed during populating initial guest memory
 		 * image. i.e. before running any vcpu.  Race is rare.
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 3d0968c98437..e3d7e19e5324 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -47,6 +47,11 @@ static inline u64 tdx_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_output *out);
 #endif
 
+static inline enum pg_level tdx_sept_level_to_pg_level(int tdx_level)
+{
+	return tdx_level + 1;
+}
+
 static inline void tdx_clflush_page(hpa_t addr, enum pg_level level)
 {
 	clflush_cache_range(__va(addr), KVM_HPAGE_SIZE(level));
@@ -88,11 +93,11 @@ static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 	return tdx_seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, NULL);
 }
 
-static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
-				   struct tdx_module_output *out)
+static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, int level, hpa_t hpa,
+				   hpa_t source, struct tdx_module_output *out)
 {
-	tdx_clflush_page(hpa, PG_LEVEL_4K);
-	return tdx_seamcall_sept(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
+	tdx_clflush_page(hpa, tdx_sept_level_to_pg_level(level));
+	return tdx_seamcall_sept(TDH_MEM_PAGE_ADD, gpa | level, tdr, hpa, source, out);
 }
 
 static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
@@ -121,11 +126,11 @@ static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 	return tdx_seamcall(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0, out);
 }
 
-static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, int level, hpa_t hpa,
 				   struct tdx_module_output *out)
 {
-	tdx_clflush_page(hpa, PG_LEVEL_4K);
-	return tdx_seamcall_sept(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
+	tdx_clflush_page(hpa, tdx_sept_level_to_pg_level(level));
+	return tdx_seamcall_sept(TDH_MEM_PAGE_AUG, gpa | level, tdr, hpa, 0, out);
 }
 
 static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
-- 
2.25.1

