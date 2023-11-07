Return-Path: <kvm+bounces-1000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56C587E42C9
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:08:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87E7F1C212EE
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B9231A6D;
	Tue,  7 Nov 2023 15:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l32Ees4V"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2125338DFE
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:05:09 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113545FC4;
	Tue,  7 Nov 2023 07:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369319; x=1730905319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mDyKKLtldjXHa72w/7rjtP4b1miz0xjRHML4kod9w+Q=;
  b=l32Ees4V6Xp/oAPyMKcil+zxOE3jLEsjDLAHg0mqxb+9MZIhj5jW6JVZ
   v+Ii/1uoAUCxJOoDu8+4QWk2DUjM/9NU+q3DFeJX8dfFbstDNgAhSLYkD
   U/jRdeRKx6IQnbPoBpmDe2cbftSloZD9vPX0RkdAB3j3vppQPIlVfgqP6
   prLn+T391CM72RDseTNjUQQbGFGMo6ih+H6OF5oQw8PLJlaHhNHV8WVGA
   naXsEUfNR/7q2h8JGyOAbMAUM6dH3p7kKUoh2QBAkzSvayNd5iFqGXUDM
   fHD9kLaPXwvS/pWOMcROFXilDHl3jbYW7YjbBkwNFIB8wvK+PcUderohi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="388397511"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="388397511"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:00:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10446507"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:00:52 -0800
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
Subject: [PATCH v6 03/16] KVM: TDX: Pass KVM page level to tdh_mem_page_add() and tdh_mem_page_aug()
Date: Tue,  7 Nov 2023 07:00:30 -0800
Message-Id: <d3b140b63e0dc9773475724d97d566917d444791.1699368363.git.isaku.yamahata@intel.com>
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
index 8b58d91bda4e..2d5c86e06c5f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1468,7 +1468,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 	union tdx_sept_entry entry;
 	u64 err;
 
-	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, hpa, &out);
+	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
 	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
 		tdx_unpin(kvm, pfn);
 		return -EAGAIN;
@@ -1497,6 +1497,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
 static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
 			     enum pg_level level, kvm_pfn_t pfn)
 {
+	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	hpa_t hpa = pfn_to_hpa(pfn);
 	gpa_t gpa = gfn_to_gpa(gfn);
@@ -1531,8 +1532,8 @@ static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
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
index e726102d3523..0f2df7198bde 100644
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


