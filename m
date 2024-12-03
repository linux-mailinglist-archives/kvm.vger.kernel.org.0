Return-Path: <kvm+bounces-32869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 520EB9E109E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 02:04:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2770B239CF
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 01:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B5CD6F307;
	Tue,  3 Dec 2024 01:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AMOW5Pd/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662E91EA84;
	Tue,  3 Dec 2024 01:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733187819; cv=none; b=tlB9gvG+AUD1RjJGxwAfQBdIbw5y/oDX8CYM4cZ3Cn4JzOrhnRKKAwMUK2IP3W/B8KXxgwzBcv3l2KWzYlH3bQM4fhXc8mk2gLnY7klfODlZpC/8W1C2RSXgvJCvucZ1+ZIuRhHNACEO2sBg7xiplv0/cHQp4jKyug2L6B2VrUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733187819; c=relaxed/simple;
	bh=ieyTdM5YEd8wdaYMMb/q/5qT1SRj0HgLviIrFJQ4ex8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhe61QdPIQFvHUrPFZvUr1+3jVkGAijuh6aOfnr3fLDMEq+oe/VQq5wFBK1iUtdMfnZogzS9ZcQ+VnBi6TvK5had9tmcuUAjV7sEZUfSpwnCI+wiJiKKTDwISgAF6SCmS98TSqlQGhZdPddLhq36pc6PKKHqSXXWSPwjru5gas8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AMOW5Pd/; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733187818; x=1764723818;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ieyTdM5YEd8wdaYMMb/q/5qT1SRj0HgLviIrFJQ4ex8=;
  b=AMOW5Pd/0Nu/NvIJPflfBVU9vuaVSXawo/4xMJZDZigZ7gw/MNch/L1q
   01I+k5mct+0hu9+QP7WUB8tRyLBQLTSPMsirYVmtLo0KKVRs6tx1LF35t
   CruY6DGWK7wiNoqo6+NaNhBpvaZ3t2FhcvWQIWUgFkli8GFvBwycJ8irf
   Jbum8cMO7OUEnyyLXt9CxGyrBTWcaTxzFN//ErXQdYg91VeMEDZOQOK2i
   KxC2AxpBpBQwGWiWuUD2GA53l52l7xL8C1SMFSHOCA1/ZjnE6yltkvMVn
   oRyxy/S6vBja/z9CwT4Is699iDA+wRiDRDxzxMGFKPGiWC+8VMbnONyIm
   w==;
X-CSE-ConnectionGUID: q9cHnIygTAqZuCFloeo6MA==
X-CSE-MsgGUID: GnxOqJvDROOUSaan7qKhKg==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="36237958"
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="36237958"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 17:03:35 -0800
X-CSE-ConnectionGUID: pgtSBQFWRRevOIuy+a38rQ==
X-CSE-MsgGUID: 0cIFuJloTbewUq2GTV+T5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,203,1728975600"; 
   d="scan'208";a="116535793"
Received: from jairdeje-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.7])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 17:03:25 -0800
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
Subject: [RFC PATCH v2 2/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
Date: Mon,  2 Dec 2024 17:03:12 -0800
Message-ID: <20241203010317.827803-3-rick.p.edgecombe@intel.com>
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

Intel TDX protects guest VMs from malicious hosts and certain physical
attacks. It defines various control structures that hold state for things
like TDs or vCPUs. These control structures are stored in pages given to
the TDX module and encrypted with either the global KeyID or the guest
KeyIDs.

To manipulate these control structures the TDX module defines a few
SEAMCALLs. KVM will use these during the process of creating a TD as
follows:

1) Allocate a unique TDX KeyID for a new guest.

1) Call TDH.MNG.CREATE to create a "TD Root" (TDR) page, together with
   the new allocated KeyID. Unlike the rest of the TDX guest, the TDR
   page is crypto-protected by the 'global KeyID'.

2) Call the previously added TDH.MNG.KEY.CONFIG on each package to
   configure the KeyID for the guest. After this step, the KeyID to
   protect the guest is ready and the rest of the guest will be protected
   by this KeyID.

3) Call TDH.MNG.ADDCX to add TD Control Structure (TDCS) pages.

4) Call TDH.MNG.INIT to initialize the TDCS.

To reclaim these pages for use by the kernel other SEAMCALLs are needed,
which will be added in future patches.

Add tdh_mng_addcx(), tdh_mng_create() and tdh_mng_init() to export these
SEAMCALLs so that KVM can use them to create TDs.

For SEAMCALLs that give a page to the TDX module to be encrypted, CLFLUSH
the page mapped with KeyID 0, such that any dirty cache lines don't write
back later and clobber TD memory or control structures. Don't worry about
the other MK-TME KeyIDs because the kernel doesn't use them. The TDX docs
specify that this flush is not needed unless the TDX module exposes the
CLFLUSH_BEFORE_ALLOC feature bit. Be conservative and always flush. Add a
helper function to facilitate this.

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
 - Fix wrongly named arg in tdh_mng_init()
 - Fix type of hkid in tdh_mng_create()

SEAMCALL RFC:
 - Use struct tdx_td
 - Introduce tdx_clflush_page() to hold CLFLUSH_BEFORE_ALLOC
   explanation

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
 arch/x86/virt/vmx/tdx/tdx.c | 51 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  3 +++
 3 files changed, 57 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 139c003acd1b..a4360a71dbdd 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -131,8 +131,11 @@ struct tdx_td {
 	struct page **tdcs_pages;
 };
 
+u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
 u64 tdh_mng_key_config(struct tdx_td *td);
+u64 tdh_mng_create(struct tdx_td *td, u64 hkid);
 u64 tdh_mng_key_freeid(struct tdx_td *td);
+u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2d1cebce8c07..605eb9bd81d3 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1568,6 +1568,29 @@ static inline u64 tdx_tdr_pa(struct tdx_td *td)
 	return page_to_pfn(td->tdr_page) << PAGE_SHIFT;
 }
 
+/*
+ * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
+ * a CLFLUSH of pages is required before handing them to the TDX module.
+ * Be conservative and make the code simpler by doing the CLFLUSH
+ * unconditionally.
+ */
+static void tdx_clflush_page(struct page *tdr)
+{
+	clflush_cache_range(page_to_virt(tdr), PAGE_SIZE);
+}
+
+u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
+{
+	struct tdx_module_args args = {
+		.rcx = page_to_pfn(tdcs_page) << PAGE_SHIFT,
+		.rdx = tdx_tdr_pa(td),
+	};
+
+	tdx_clflush_page(tdcs_page);
+	return seamcall(TDH_MNG_ADDCX, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_addcx);
+
 u64 tdh_mng_key_config(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1578,6 +1601,18 @@ u64 tdh_mng_key_config(struct tdx_td *td)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_key_config);
 
+u64 tdh_mng_create(struct tdx_td *td, u64 hkid)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdr_pa(td),
+		.rdx = hkid,
+	};
+
+	tdx_clflush_page(td->tdr_page);
+	return seamcall(TDH_MNG_CREATE, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_create);
+
 u64 tdh_mng_key_freeid(struct tdx_td *td)
 {
 	struct tdx_module_args args = {
@@ -1588,3 +1623,19 @@ u64 tdh_mng_key_freeid(struct tdx_td *td)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_key_freeid);
 
+u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdr_pa(td),
+		.rdx = td_params,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MNG_INIT, &args);
+
+	*extended_err = args.rcx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mng_init);
+
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 95002e7ff4c5..b9287304f372 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -17,8 +17,11 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_MNG_ADDCX			1
 #define TDH_MNG_KEY_CONFIG		8
+#define TDH_MNG_CREATE			9
 #define TDH_MNG_KEY_FREEID		20
+#define TDH_MNG_INIT			21
 #define TDH_PHYMEM_PAGE_RDMD		24
 #define TDH_SYS_KEY_CONFIG		31
 #define TDH_SYS_INIT			33
-- 
2.47.1


