Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750D97CB039
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbjJPQiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbjJPQhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:37:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D1E824B;
        Mon, 16 Oct 2023 09:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473394; x=1729009394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qraYcW5IY/UHw2621ZBIfhsYEJTaAoFyy8cv5ZLjX0M=;
  b=TLCFxMTdA9h91wreHTjSYrhDMkmJSjgWJkPeFTBb2qhfVpsqsgccihQe
   GoAJtUNLNuHD2POQD9gbaRtElT6Dzsfw/0HQAZUtC8GjRbhSzxPFiX5iM
   pD2p6pP18Y0PfvSg+cvJJQD1TeN+kRZ5CkE/AIULMoOMlSp2W+Z/2c9ai
   mpTjIzKyvPtAc1Q5MQN/ckqjk+N0hG9VNykn+2ZvLzQkvlXQBMfPzgfy9
   5kIS6Pz+rxTStiw1Q39CA8F+duc1uaHl7YlrHBkpVUsdJrRi3b9gArOkv
   +kII9vsM8izw7U9wfMEuFIkvElTW1kX/sbGxlhZcm/hoWoT84Oauc2j3Z
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471793120"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="471793120"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:21:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="899569218"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="899569218"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:19:12 -0700
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
Subject: [RFC PATCH v5 03/16] KVM: TDX: Pass KVM page level to tdh_mem_page_add() and tdh_mem_page_aug()
Date:   Mon, 16 Oct 2023 09:20:54 -0700
Message-Id: <792c88756f17b07459847b2846dcb9a80202c065.1697473009.git.isaku.yamahata@intel.com>
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
index 4e7bd884e972..471128946e63 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1449,7 +1449,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 	union tdx_sept_entry entry;
 	u64 err;
 
-	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, hpa, &out);
+	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
 	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
 		tdx_unpin(kvm, pfn);
 		return -EAGAIN;
@@ -1496,6 +1496,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
 			     enum pg_level level, kvm_pfn_t pfn)
 {
+	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	hpa_t hpa = pfn_to_hpa(pfn);
 	gpa_t gpa = gfn_to_gpa(gfn);
@@ -1530,8 +1531,8 @@ static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
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
index c9de1b48a022..afc85e7ffb8e 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -63,6 +63,11 @@ static inline u64 tdx_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out);
 #endif
 
+static inline enum pg_level tdx_sept_level_to_pg_level(int tdx_level)
+{
+	return tdx_level + 1;
+}
+
 static inline void tdx_clflush_page(hpa_t addr, enum pg_level level)
 {
 	clflush_cache_range(__va(addr), KVM_HPAGE_SIZE(level));
@@ -104,11 +109,11 @@ static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 	return tdx_seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, NULL);
 }
 
-static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
-				   struct tdx_module_args *out)
+static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, int level, hpa_t hpa,
+				   hpa_t source, struct tdx_module_args *out)
 {
-	tdx_clflush_page(hpa, PG_LEVEL_4K);
-	return tdx_seamcall_sept(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
+	tdx_clflush_page(hpa, tdx_sept_level_to_pg_level(level));
+	return tdx_seamcall_sept(TDH_MEM_PAGE_ADD, gpa | level, tdr, hpa, source, out);
 }
 
 static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
@@ -143,11 +148,11 @@ static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 	return tdx_seamcall_sept(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0, out);
 }
 
-static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, int level, hpa_t hpa,
 				   struct tdx_module_args *out)
 {
-	tdx_clflush_page(hpa, PG_LEVEL_4K);
-	return tdx_seamcall_sept(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
+	tdx_clflush_page(hpa, tdx_sept_level_to_pg_level(level));
+	return tdx_seamcall_sept(TDH_MEM_PAGE_AUG, gpa | level, tdr, hpa, 0, out);
 }
 
 static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
-- 
2.25.1

