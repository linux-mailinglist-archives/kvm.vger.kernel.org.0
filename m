Return-Path: <kvm+bounces-1002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 197A07E42CD
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:08:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9810282893
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CF09321AF;
	Tue,  7 Nov 2023 15:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FLiAjDwN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4278038F96
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:05:11 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0535BBF;
	Tue,  7 Nov 2023 07:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369319; x=1730905319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bcd5Hg5bG1RMZIsJP60JxxJf7hZanQ3sSPGs+CnvT3Q=;
  b=FLiAjDwN0lpxxFwlq6+xzrjozdLRE7b3U2n8dxrDKt+psh4mXpH6j3xf
   qGp7ucCNrm1IvGz+azgGuC1tc6Bmb/XDRcgRIIC19FaNy4VM0+QsmjYvY
   qGQyjz1aQR5hb2241fpnhqfWWLAqbIPsmr+aG7svs53AW2EpyY+I8CGzO
   N30QXbYijYt8JwpOeeJbcqESolD2JmjmPLbMNIdvIubvs+Ie6+NkacVYy
   q+HteMx8/UDenM6T4cNynAaNduFCrXA3xcS8QpLNGeMcPQ+ZztkmWR0vW
   wP+gr/FPGvD7SG1Cb6h9M3f6Kb1GhaDXehuYNBuCUCxgk2jB1otE8vtXh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="388397497"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="388397497"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:00:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10446479"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:00:51 -0800
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
	tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v6 02/16] KVM: TDX: Pass page level to cache flush before TDX SEAMCALL
Date: Tue,  7 Nov 2023 07:00:29 -0800
Message-Id: <c73b5d5f902bb6d21a784bed2904fc1860aaf571.1699368363.git.isaku.yamahata@intel.com>
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
index fd73a1731bf8..e726102d3523 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -6,6 +6,7 @@
 
 #include <linux/compiler.h>
 
+#include <asm/pgtable_types.h>
 #include <asm/archrandom.h>
 #include <asm/cacheflush.h>
 #include <asm/asm.h>
@@ -62,6 +63,11 @@ static inline u64 tdx_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out);
 #endif
 
+static inline void tdx_clflush_page(hpa_t addr, enum pg_level level)
+{
+	clflush_cache_range(__va(addr), KVM_HPAGE_SIZE(level));
+}
+
 /*
  * TDX module acquires its internal lock for resources.  It doesn't spin to get
  * locks because of its restrictions of allowed execution time.  Instead, it
@@ -94,21 +100,21 @@ static inline u64 tdx_seamcall_sept(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 
 static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 {
-	clflush_cache_range(__va(addr), PAGE_SIZE);
+	tdx_clflush_page(addr, PG_LEVEL_4K);
 	return tdx_seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, NULL);
 }
 
 static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
 				   struct tdx_module_args *out)
 {
-	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	tdx_clflush_page(hpa, PG_LEVEL_4K);
 	return tdx_seamcall_sept(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
 }
 
 static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
 				   struct tdx_module_args *out)
 {
-	clflush_cache_range(__va(page), PAGE_SIZE);
+	tdx_clflush_page(page, PG_LEVEL_4K);
 	return tdx_seamcall_sept(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, out);
 }
 
@@ -126,21 +132,21 @@ static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
 
 static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
 {
-	clflush_cache_range(__va(addr), PAGE_SIZE);
+	tdx_clflush_page(addr, PG_LEVEL_4K);
 	return tdx_seamcall(TDH_VP_ADDCX, addr, tdvpr, 0, 0, NULL);
 }
 
 static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 					struct tdx_module_args *out)
 {
-	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	tdx_clflush_page(hpa, PG_LEVEL_4K);
 	return tdx_seamcall_sept(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0, out);
 }
 
 static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 				   struct tdx_module_args *out)
 {
-	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	tdx_clflush_page(hpa, PG_LEVEL_4K);
 	return tdx_seamcall_sept(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
 }
 
@@ -157,13 +163,13 @@ static inline u64 tdh_mng_key_config(hpa_t tdr)
 
 static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
 {
-	clflush_cache_range(__va(tdr), PAGE_SIZE);
+	tdx_clflush_page(tdr, PG_LEVEL_4K);
 	return tdx_seamcall(TDH_MNG_CREATE, tdr, hkid, 0, 0, NULL);
 }
 
 static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
 {
-	clflush_cache_range(__va(tdvpr), PAGE_SIZE);
+	tdx_clflush_page(tdvpr, PG_LEVEL_4K);
 	return tdx_seamcall(TDH_VP_CREATE, tdvpr, tdr, 0, 0, NULL);
 }
 
-- 
2.25.1


