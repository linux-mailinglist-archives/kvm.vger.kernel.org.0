Return-Path: <kvm+bounces-32874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 622E79E10A7
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 02:05:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BDB81650F2
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 01:05:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9448187325;
	Tue,  3 Dec 2024 01:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IDfAEfh8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F692AF05;
	Tue,  3 Dec 2024 01:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733187824; cv=none; b=rC02j9xlpJNGHLCLmU5OXk8IRJ00L85MPvIHNjzNZiNMnnKpML6osU/2CqVHA8361gYCa3tsmC8Pz7Syxh1p6UZRDTSvBhi/zFgOFcp/Hc6SGgQJQsBz1CmpganZISDoNGGotZ5MNtyQ5ZoahZ9Zc02jaNxWbidDJZsK043M+sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733187824; c=relaxed/simple;
	bh=9g4xwN8+qz3jmgOq/OwIVU+iA/OjzRKatefCc4TD1E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1F5pltK1lE+v7t2/qq2zV11fiJ6UchaP4S5ycR9svtl+Ib3ZdqvNoEbFuBa4OwAIEqPJzvKYoSsYk+PKBqdCx3MsGCx2kjmpZ0uHYreEtcdGYLni4dPXlxfEPALFYbbvLjfeTtlTyQjWqg8uMboWg8e8v3BBdqHglr4ZdArmBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IDfAEfh8; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733187820; x=1764723820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9g4xwN8+qz3jmgOq/OwIVU+iA/OjzRKatefCc4TD1E8=;
  b=IDfAEfh8NuQnOfcaf/N8pPyD5Ws3036x0XAYKS1YGlZNabC9onyHADu3
   V96RddQBIqB5WFfbz/rSnz9mxn3BlCqUZM/ZNsR3iarp7PBa5WQy0/8h8
   5QM/Gks8Or9d1mgLVV0UZDtoYr8o0GpVteKl7aV3k3weZFvrEubE0Tbn5
   mV1CUK3Qyyfmtjyk1YE5oUiJJ7SFt49BxPSiziNbcmR4R//XA4hgHUDlB
   T4RVL7vcDxSKTmrPcE4DU3vpICYPVtEB52/Krkk45gYO7BP/25EkTmi/1
   7W6hdU9VT1cvLM0ktz/Qk+dRYPAyoAIKGtswW4/UzoSZppoGI97JVIuHA
   g==;
X-CSE-ConnectionGUID: 4oih4AwCTPOrt8Zk5EZmjQ==
X-CSE-MsgGUID: rVb/60btRvOOPY4RNpyMcQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="36237981"
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="36237981"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 17:03:35 -0800
X-CSE-ConnectionGUID: eAqRcyLNSkWByGAW/nJTWg==
X-CSE-MsgGUID: iCD5sEtQQi6D7nCBjrQ8TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="116535799"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.7])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 17:03:27 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: kvm@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@intel.com
Cc: isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com,
	x86@kernel.org,
	adrian.hunter@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [RFC PATCH v2 4/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX page cache management
Date: Mon,  2 Dec 2024 17:03:14 -0800
Message-ID: <20241203010317.827803-5-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
References: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel TDX protects guest VMs from malicious host and certain physical
attacks. The TDX module uses pages provided by the host for both control
structures and for TD guest pages. These pages are encrypted using the
MK-TME encryption engine, with its special requirements around cache
invalidation. For its own security, the TDX module ensures pages are
flushed properly and track which usage they are currently assigned. For
creating and tearing down TD VMs and vCPUs KVM will need to use the
TDH.PHYMEM.PAGE.RECLAIM, TDH.PHYMEM.CACHE.WB, and TDH.PHYMEM.PAGE.WBINVD
SEAMCALLs.

Add tdh_phymem_page_reclaim() to enable KVM to call
TDH.PHYMEM.PAGE.RECLAIM to reclaim the page for use by the host kernel.
This effectively resets its state in the TDX module's page tracking
(PAMT), if the page is available to be reclaimed. This will be used by KVM
to reclaim the various types of pages owned by the TDX module. It will
have a small wrapper in KVM that retries in the case of a relevant error
code. Don't implement this wrapper in arch/x86 because KVM's solution
around retrying SEAMCALLs will be better located in a single place.

Add tdh_phymem_cache_wb() to enable KVM to call TDH.PHYMEM.CACHE.WB to do
a cache write back in a way that the TDX module can verify, before it
allows a KeyID to be freed. The KVM code will use this to have a small
wrapper that handles retries. Since the TDH.PHYMEM.CACHE.WB operation is
interruptible, have tdh_phymem_cache_wb() take a resume argument to pass
this info to the TDX module for restarts. It is worth noting that this
SEAMCALL uses a SEAM specific MSR to do the write back in sections. In
this way it does export some new functionality that affects CPU state.

Add tdh_phymem_page_wbinvd_tdr() to enable KVM to call
TDH.PHYMEM.PAGE.WBINVD to do a cache write back and invalidate of a TDR,
using the global KeyID. The underlying TDH.PHYMEM.PAGE.WBINVD SEAMCALL
requires the related KeyID to be encoded into the SEAMCALL args. Since the
global KeyID is not exposed to KVM, a dedicated wrapper is needed for TDR
focused TDH.PHYMEM.PAGE.WBINVD operations.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
SEAMCALL RFC v2:
 - Use struct page (Dave)
 - Rename out args for tdh_phymem_page_reclaim() to make it clear these
   are TDX specific values, and not to be interpreted normally. Also,
   add a comment about this.

SEAMCALL RFC:
 - Use struct tdx_td
 - Use arg names with meaning for tdh_phymem_page_reclaim() for out args

uAPI breakout v2:
 - Change to use 'u64' as function parameter to prepare to move
   SEAMCALL wrappers to arch/x86. (Kai)
 - Split to separate patch
 - Move SEAMCALL wrappers from KVM to x86 core;
 - Move TDH_xx macros from KVM to x86 core;
 - Re-write log

uAPI breakout v1:
 - Make argument to C wrapper function struct kvm_tdx * or
   struct vcpu_tdx * .(Sean)
 - Drop unused helpers (Kai)
 - Fix bisectability issues in headers (Kai)
 - Updates from seamcall overhaul (Kai)

v19:
 - Update the commit message to match the patch by Yuan
 - Use seamcall() and seamcall_ret() by paolo

v18:
 - removed stub functions for __seamcall{,_ret}()
 - Added Reviewed-by Binbin
 - Make tdx_seamcall() use struct tdx_module_args instead of taking
   each inputs.
---
 arch/x86/include/asm/tdx.h  |  3 +++
 arch/x86/virt/vmx/tdx/tdx.c | 43 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  3 +++
 3 files changed, 49 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 018bbabf8639..f6ab8a9ea46b 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -151,6 +151,9 @@ u64 tdh_mng_key_freeid(struct tdx_td *td);
 u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx);
 u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
+u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
+u64 tdh_phymem_cache_wb(bool resume);
+u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index d71656868fe4..b2a1ed13d0da 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1692,3 +1692,46 @@ u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid)
 	return seamcall(TDH_VP_INIT | (1ULL << TDX_VERSION_SHIFT), &args);
 }
 EXPORT_SYMBOL_GPL(tdh_vp_init_apicid);
+
+/*
+ * TDX ABI defines output operands as PT, OWNER and SIZE. These are TDX defined fomats.
+ * So despite the names, they must be interpted specially as described by the spec. Return
+ * them only for error reporting purposes.
+ */
+u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size)
+{
+	struct tdx_module_args args = {
+		.rcx = page_to_pfn(page) << PAGE_SHIFT,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_PHYMEM_PAGE_RECLAIM, &args);
+
+	*tdx_pt = args.rcx;
+	*tdx_owner = args.rdx;
+	*tdx_size = args.r8;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);
+
+u64 tdh_phymem_cache_wb(bool resume)
+{
+	struct tdx_module_args args = {
+		.rcx = resume ? 1 : 0,
+	};
+
+	return seamcall(TDH_PHYMEM_CACHE_WB, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_cache_wb);
+
+u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
+{
+	struct tdx_module_args args = {};
+
+	args.rcx = tdx_tdr_pa(td) | ((u64)tdx_global_keyid << boot_cpu_data.x86_phys_bits);
+
+	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
+
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 3663971a3669..191bdd1e571d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -26,11 +26,14 @@
 #define TDH_MNG_INIT			21
 #define TDH_VP_INIT			22
 #define TDH_PHYMEM_PAGE_RDMD		24
+#define TDH_PHYMEM_PAGE_RECLAIM		28
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
 #define TDH_SYS_RD			34
 #define TDH_SYS_LP_INIT			35
 #define TDH_SYS_TDMR_INIT		36
+#define TDH_PHYMEM_CACHE_WB		40
+#define TDH_PHYMEM_PAGE_WBINVD		41
 #define TDH_SYS_CONFIG			45
 
 /*
-- 
2.47.1


