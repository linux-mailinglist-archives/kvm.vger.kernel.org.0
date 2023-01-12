Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679F7667C3C
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 18:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240651AbjALRKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 12:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238687AbjALRJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 12:09:36 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE595E67C;
        Thu, 12 Jan 2023 08:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673542053; x=1705078053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hqWWs96g8j8J+o2BvB4eR8w2w9BH0DQPRuS3KFwmOI0=;
  b=V0DsdpLaAqHZDSCCAhXwUr9DyX1J8mhvDjyKevQmKv7UuTxdecI4BCb0
   aJnKnypKPPRNYFbQyqNSe8ADb0e6Gbb+2fD5wQ7forqUp/9cGvpOYUO/A
   q51cMxxmCklcLnsJh5Dlc1iaRsZlvEwGNV2QqTIs25G9v9rJ3hGsFJy56
   o1ADVbKvoeIhbYRn3fvSgjIX3e587QbHkjVekqK75uce9Qs4Si+ta/Rep
   XZVqQf1ocH02q4A1jcDMBtfIqlyrDmcnTsXKtHDjLCoQnrXoN4Y4YSUk8
   Wltk1MatOdMLvAbTfxXGLXcvVcXVD1kwF2iLoWRE7ryaGwYlAQ20bMamE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323816280"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323816280"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="986658322"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="986658322"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:16 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v3 02/16] KVM: TDX: Pass page level to cache flush before TDX SEAMCALL
Date:   Thu, 12 Jan 2023 08:43:54 -0800
Message-Id: <76098021c9ff33c9b60ab0bff97b68a4e664fdaf.1673541292.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673541292.git.isaku.yamahata@intel.com>
References: <cover.1673541292.git.isaku.yamahata@intel.com>
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

tdh_mem_page_aug() will support 2MB large page in the near future.  Cache
flush also needs to be 2MB instead of 4KB in such cases.  Introduce a
helper function to flush cache with page size info in preparation for large
pages.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx_ops.h | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 86330d0e4b22..4db983b1dc94 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -6,6 +6,7 @@
 
 #include <linux/compiler.h>
 
+#include <asm/pgtable_types.h>
 #include <asm/cacheflush.h>
 #include <asm/asm.h>
 #include <asm/kvm_host.h>
@@ -18,6 +19,11 @@
 
 void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_output *out);
 
+static inline void tdx_clflush_page(hpa_t addr, enum pg_level level)
+{
+	clflush_cache_range(__va(addr), KVM_HPAGE_SIZE(level));
+}
+
 /*
  * TDX module acquires its internal lock for resources.  It doesn't spin to get
  * locks because of its restrictions of allowed execution time.  Instead, it
@@ -50,21 +56,21 @@ static inline u64 seamcall_sept(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 
 static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 {
-	clflush_cache_range(__va(addr), PAGE_SIZE);
+	tdx_clflush_page(addr, PG_LEVEL_4K);
 	return __seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, NULL);
 }
 
 static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
 				   struct tdx_module_output *out)
 {
-	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	tdx_clflush_page(hpa, PG_LEVEL_4K);
 	return seamcall_sept(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
 }
 
 static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
 				   struct tdx_module_output *out)
 {
-	clflush_cache_range(__va(page), PAGE_SIZE);
+	tdx_clflush_page(page, PG_LEVEL_4K);
 	return seamcall_sept(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, out);
 }
 
@@ -76,21 +82,21 @@ static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
 
 static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
 {
-	clflush_cache_range(__va(addr), PAGE_SIZE);
+	tdx_clflush_page(addr, PG_LEVEL_4K);
 	return __seamcall(TDH_VP_ADDCX, addr, tdvpr, 0, 0, NULL);
 }
 
 static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 					struct tdx_module_output *out)
 {
-	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	tdx_clflush_page(hpa, PG_LEVEL_4K);
 	return __seamcall(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0, out);
 }
 
 static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 				   struct tdx_module_output *out)
 {
-	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	tdx_clflush_page(hpa, PG_LEVEL_4K);
 	return seamcall_sept(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
 }
 
@@ -107,13 +113,13 @@ static inline u64 tdh_mng_key_config(hpa_t tdr)
 
 static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
 {
-	clflush_cache_range(__va(tdr), PAGE_SIZE);
+	tdx_clflush_page(tdr, PG_LEVEL_4K);
 	return __seamcall(TDH_MNG_CREATE, tdr, hkid, 0, 0, NULL);
 }
 
 static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
 {
-	clflush_cache_range(__va(tdvpr), PAGE_SIZE);
+	tdx_clflush_page(tdvpr, PG_LEVEL_4K);
 	return __seamcall(TDH_VP_CREATE, tdvpr, tdr, 0, 0, NULL);
 }
 
-- 
2.25.1

