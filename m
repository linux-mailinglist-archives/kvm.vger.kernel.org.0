Return-Path: <kvm+bounces-908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E1A17E4254
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:59:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BD8A1F21CE1
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D0234CD3;
	Tue,  7 Nov 2023 14:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VGlAa/XM"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F1631A6D
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:57:52 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AD5D73;
	Tue,  7 Nov 2023 06:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369069; x=1730905069;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HEmZU+0uD2Ii1KlTe8SdiYTzJ2qOUDllFLcXOwRsVT4=;
  b=VGlAa/XMsKIJH9RRrCvZfyP6Oc25s+kzoIJE07PIjJfFniSZnNDaM2Aq
   brBGja0G6buDy9y6lJQ0oDVvG3LzV00fZDDx4uX4YZ163GR7SE3eKwlcX
   S2Oed7IzKKctJ9+Q1Af38+mg2r+aFSt8j8/EypaJkDNSK5+UqREUd6nnH
   6/fQzWxV6aLbBA4KntRZN6W3X6RL1RiGUMY4DGRy8LqLNQTWYCpjZFsog
   U4TlHgVJCUcxNeHNGfPuqg9r/s/4PGIXOZRr2gM/Ed2Mv7QfX8uOFpIyK
   fiX3hN6nhlr9r9Dw5eBYj9MA1TLmvP0aim3qQfi9IEmXvgnxv0h3Qw80t
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="374555720"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="374555720"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10443992"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:46 -0800
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
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v17 011/116] KVM: TDX: Add C wrapper functions for SEAMCALLs to the TDX module
Date: Tue,  7 Nov 2023 06:55:37 -0800
Message-Id: <27d60b4bf79499c3bcda00cdb969ea215ecf05e9.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

A VMM interacts with the TDX module using a new instruction (SEAMCALL).
For instance, a TDX VMM does not have full access to the VM control
structure corresponding to VMX VMCS.  Instead, a VMM induces the TDX module
to act on behalf via SEAMCALLs.

Export __seamcall and define C wrapper functions for SEAMCALLs for
readability.

Some SEAMCALL APIs donate host pages to TDX module or guest TD, and the
donated pages are encrypted.  Those require the VMM to flush the cache
lines to avoid cache line alias.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
v15 -> v16:
- use struct tdx_module_args instead of struct tdx_module_output
- Add tdh_mem_sept_rd() for SEPT_VE_DISABLE=1.
---
 arch/x86/include/asm/asm-prototypes.h |   1 +
 arch/x86/include/asm/tdx.h            |  12 ++
 arch/x86/kvm/vmx/tdx_ops.h            | 226 ++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/seamcall.S      |   4 +
 4 files changed, 243 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_ops.h

diff --git a/arch/x86/include/asm/asm-prototypes.h b/arch/x86/include/asm/asm-prototypes.h
index b1a98fa38828..1a8feb440252 100644
--- a/arch/x86/include/asm/asm-prototypes.h
+++ b/arch/x86/include/asm/asm-prototypes.h
@@ -6,6 +6,7 @@
 #include <asm/page.h>
 #include <asm/checksum.h>
 #include <asm/mce.h>
+#include <asm/tdx.h>
 
 #include <asm-generic/asm-prototypes.h>
 
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index b2d9d569818e..b7cfdf084860 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -115,6 +115,18 @@ int tdx_enable(void);
 void tdx_reset_memory(void);
 bool tdx_is_private_mem(unsigned long phys);
 #else
+static inline u64 __seamcall(u64 fn, struct tdx_module_args *args)
+{
+	return TDX_SEAMCALL_UD;
+}
+static inline u64 __seamcall_ret(u64 fn, struct tdx_module_args *args)
+{
+	return TDX_SEAMCALL_UD;
+}
+static inline u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args)
+{
+	return TDX_SEAMCALL_UD;
+}
 static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
 static inline int tdx_enable(void)  { return -ENODEV; }
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
new file mode 100644
index 000000000000..12fd6b8d49e0
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -0,0 +1,226 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* constants/data definitions for TDX SEAMCALLs */
+
+#ifndef __KVM_X86_TDX_OPS_H
+#define __KVM_X86_TDX_OPS_H
+
+#include <linux/compiler.h>
+
+#include <asm/cacheflush.h>
+#include <asm/asm.h>
+#include <asm/kvm_host.h>
+
+#include "tdx_errno.h"
+#include "tdx_arch.h"
+#include "x86.h"
+
+static inline u64 tdx_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
+			       struct tdx_module_args *out)
+{
+	u64 ret;
+
+	if (out) {
+		*out = (struct tdx_module_args) {
+			.rcx = rcx,
+			.rdx = rdx,
+			.r8 = r8,
+			.r9 = r9,
+		};
+		ret = __seamcall_ret(op, out);
+	} else {
+		struct tdx_module_args args = {
+			.rcx = rcx,
+			.rdx = rdx,
+			.r8 = r8,
+			.r9 = r9,
+		};
+		ret = __seamcall(op, &args);
+	}
+	if (unlikely(ret == TDX_SEAMCALL_UD)) {
+		/*
+		 * SEAMCALLs fail with TDX_SEAMCALL_UD returned when VMX is off.
+		 * This can happen when the host gets rebooted or live
+		 * updated. In this case, the instruction execution is ignored
+		 * as KVM is shut down, so the error code is suppressed. Other
+		 * than this, the error is unexpected and the execution can't
+		 * continue as the TDX features reply on VMX to be on.
+		 */
+		kvm_spurious_fault();
+		return 0;
+	}
+	return ret;
+}
+
+static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
+{
+	clflush_cache_range(__va(addr), PAGE_SIZE);
+	return tdx_seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
+				   struct tdx_module_args *out)
+{
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	return tdx_seamcall(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
+}
+
+static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
+				   struct tdx_module_args *out)
+{
+	clflush_cache_range(__va(page), PAGE_SIZE);
+	return tdx_seamcall(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, out);
+}
+
+static inline u64 tdh_mem_sept_rd(hpa_t tdr, gpa_t gpa, int level,
+				  struct tdx_module_args *out)
+{
+	return tdx_seamcall(TDH_MEM_SEPT_RD, gpa | level, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
+				      struct tdx_module_args *out)
+{
+	return tdx_seamcall(TDH_MEM_SEPT_REMOVE, gpa | level, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
+{
+	clflush_cache_range(__va(addr), PAGE_SIZE);
+	return tdx_seamcall(TDH_VP_ADDCX, addr, tdvpr, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+					struct tdx_module_args *out)
+{
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	return tdx_seamcall(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0, out);
+}
+
+static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+				   struct tdx_module_args *out)
+{
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	return tdx_seamcall(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
+}
+
+static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
+				      struct tdx_module_args *out)
+{
+	return tdx_seamcall(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_mng_key_config(hpa_t tdr)
+{
+	return tdx_seamcall(TDH_MNG_KEY_CONFIG, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
+{
+	clflush_cache_range(__va(tdr), PAGE_SIZE);
+	return tdx_seamcall(TDH_MNG_CREATE, tdr, hkid, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
+{
+	clflush_cache_range(__va(tdvpr), PAGE_SIZE);
+	return tdx_seamcall(TDH_VP_CREATE, tdvpr, tdr, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct tdx_module_args *out)
+{
+	return tdx_seamcall(TDH_MNG_RD, tdr, field, 0, 0, out);
+}
+
+static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
+				struct tdx_module_args *out)
+{
+	return tdx_seamcall(TDH_MR_EXTEND, gpa, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_mr_finalize(hpa_t tdr)
+{
+	return tdx_seamcall(TDH_MR_FINALIZE, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_flush(hpa_t tdvpr)
+{
+	return tdx_seamcall(TDH_VP_FLUSH, tdvpr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_vpflushdone(hpa_t tdr)
+{
+	return tdx_seamcall(TDH_MNG_VPFLUSHDONE, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_key_freeid(hpa_t tdr)
+{
+	return tdx_seamcall(TDH_MNG_KEY_FREEID, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_init(hpa_t tdr, hpa_t td_params,
+			       struct tdx_module_args *out)
+{
+	return tdx_seamcall(TDH_MNG_INIT, tdr, td_params, 0, 0, out);
+}
+
+static inline u64 tdh_vp_init(hpa_t tdvpr, u64 rcx)
+{
+	return tdx_seamcall(TDH_VP_INIT, tdvpr, rcx, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_rd(hpa_t tdvpr, u64 field,
+			    struct tdx_module_args *out)
+{
+	return tdx_seamcall(TDH_VP_RD, tdvpr, field, 0, 0, out);
+}
+
+static inline u64 tdh_mng_key_reclaimid(hpa_t tdr)
+{
+	return tdx_seamcall(TDH_MNG_KEY_RECLAIMID, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_phymem_page_reclaim(hpa_t page,
+					  struct tdx_module_args *out)
+{
+	return tdx_seamcall(TDH_PHYMEM_PAGE_RECLAIM, page, 0, 0, 0, out);
+}
+
+static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
+				      struct tdx_module_args *out)
+{
+	return tdx_seamcall(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_sys_lp_shutdown(void)
+{
+	return tdx_seamcall(TDH_SYS_LP_SHUTDOWN, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_track(hpa_t tdr)
+{
+	return tdx_seamcall(TDH_MEM_TRACK, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
+					struct tdx_module_args *out)
+{
+	return tdx_seamcall(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_phymem_cache_wb(bool resume)
+{
+	return tdx_seamcall(TDH_PHYMEM_CACHE_WB, resume ? 1 : 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_phymem_page_wbinvd(hpa_t page)
+{
+	return tdx_seamcall(TDH_PHYMEM_PAGE_WBINVD, page, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_wr(hpa_t tdvpr, u64 field, u64 val, u64 mask,
+			    struct tdx_module_args *out)
+{
+	return tdx_seamcall(TDH_VP_WR, tdvpr, field, val, mask, out);
+}
+
+#endif /* __KVM_X86_TDX_OPS_H */
diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
index 5b1f2286aea9..73042f7f23be 100644
--- a/arch/x86/virt/vmx/tdx/seamcall.S
+++ b/arch/x86/virt/vmx/tdx/seamcall.S
@@ -1,5 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/linkage.h>
+#include <asm/export.h>
 #include <asm/frame.h>
 
 #include "tdxcall.S"
@@ -21,6 +22,7 @@
 SYM_FUNC_START(__seamcall)
 	TDX_MODULE_CALL host=1
 SYM_FUNC_END(__seamcall)
+EXPORT_SYMBOL_GPL(__seamcall)
 
 /*
  * __seamcall_ret() - Host-side interface functions to SEAM software
@@ -40,6 +42,7 @@ SYM_FUNC_END(__seamcall)
 SYM_FUNC_START(__seamcall_ret)
 	TDX_MODULE_CALL host=1 ret=1
 SYM_FUNC_END(__seamcall_ret)
+EXPORT_SYMBOL_GPL(__seamcall_ret)
 
 /*
  * __seamcall_saved_ret() - Host-side interface functions to SEAM software
@@ -59,3 +62,4 @@ SYM_FUNC_END(__seamcall_ret)
 SYM_FUNC_START(__seamcall_saved_ret)
 	TDX_MODULE_CALL host=1 ret=1 saved=1
 SYM_FUNC_END(__seamcall_saved_ret)
+EXPORT_SYMBOL_GPL(__seamcall_saved_ret)
-- 
2.25.1


