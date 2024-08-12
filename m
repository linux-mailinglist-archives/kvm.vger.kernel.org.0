Return-Path: <kvm+bounces-23898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C85EE94F9D9
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:49:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED7621C221D0
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A60219B59F;
	Mon, 12 Aug 2024 22:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZsmDBZHy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CD919A2B7;
	Mon, 12 Aug 2024 22:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502913; cv=none; b=NiSPDHQD/UIRqjKPk5JL7MSbYqrcSKh7NT8WQypHVGVpsGhM/U9QQP0T81w0XPVfv8JhDWBRLayjho1As0fsiGlQxgnRLRF4PWDx6GE1fM4QmzNi1aZrnNx0acZHaPLB0ZuZ/KIFz1ZHOUR/CeAEPysP4XWKHoFzOc3ZfrwsApQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502913; c=relaxed/simple;
	bh=O4KNAoozn4Ay1xs1V20iKsDNVRH9VIPe+59YYboNtkg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SSvRtdN3g5nv9PrJZmTMOtYZLO0EWyGMN0yDiqbiNTu8a3SlWbQZP8+g9VeAURcUzmvB99juY3Ws64/94+6H+x2wBKbfI+Xgo/uyGaxcQDhRz8k8N/80C+lg5mTkZtdzvFS8VrASj6C2LnfqR+bjf81fLQK/SJWwAX5irVrVXU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZsmDBZHy; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502911; x=1755038911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O4KNAoozn4Ay1xs1V20iKsDNVRH9VIPe+59YYboNtkg=;
  b=ZsmDBZHyeuSm0uVk0xo9JmSUAVcCnkmmTyI6Uo5aG1spVZiG+WRXjDu2
   FkQebG2LErNJ8JkUKnIeVjPdX4ZOPDWFHHisFapZ8m4rEd0VaX+jVUrWA
   +wCzrNGfOAPLTx6OO+c+7DTQcOQuI+XC454e/U2KMIn61iujNG+lOBCZU
   RyCslMXR2gasWb6RJ2lbLnyJVV5uAI+X5l8gynCQ7ffOcDKjz39mrGeAW
   g5cS4+PGT4bDXWEby8Q28Ae261ANpwDtChP7Wvph2uJ7aNEFhO7R9V5As
   aRtjc91aLibo3W7jiBtOMKZXs1n84GltdzX97w7QKhafqehO1x0YBmxRE
   Q==;
X-CSE-ConnectionGUID: TlfJ4cpdTdGiSEEWFqOKlA==
X-CSE-MsgGUID: mrN5PzCXRoCK1HjMz2WcTQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041344"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041344"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:28 -0700
X-CSE-ConnectionGUID: HT8Ekh3nTVGgqvgp0xvFtA==
X-CSE-MsgGUID: XbajYQitRg6a2RUuMng/Vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008348"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:28 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH 04/25] KVM: TDX: Add C wrapper functions for SEAMCALLs to the TDX module
Date: Mon, 12 Aug 2024 15:47:59 -0700
Message-Id: <20240812224820.34826-5-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
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

Define C wrapper functions for SEAMCALLs for readability.

Some SEAMCALL APIs donate host pages to TDX module or guest TD, and the
donated pages are encrypted.  Those require the VMM to flush the cache
lines to avoid cache line alias.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
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

v15 -> v16:
- use struct tdx_module_args instead of struct tdx_module_output
- Add tdh_mem_sept_rd() for SEPT_VE_DISABLE=1.
---
 arch/x86/kvm/vmx/tdx.h     |  14 +-
 arch/x86/kvm/vmx/tdx_ops.h | 387 +++++++++++++++++++++++++++++++++++++
 2 files changed, 399 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/tdx_ops.h

diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index faed454385ca..78f84c53a948 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -12,12 +12,14 @@ extern bool enable_tdx;
 
 struct kvm_tdx {
 	struct kvm kvm;
-	/* TDX specific members follow. */
+
+	unsigned long tdr_pa;
 };
 
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
-	/* TDX specific members follow. */
+
+	unsigned long tdvpr_pa;
 };
 
 static inline bool is_td(struct kvm *kvm)
@@ -40,6 +42,14 @@ static __always_inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_tdx, vcpu);
 }
 
+/*
+ * SEAMCALL wrappers
+ *
+ * Put it here as most of those wrappers need declaration of
+ * 'struct kvm_tdx' and 'struct vcpu_tdx'.
+ */
+#include "tdx_ops.h"
+
 #else
 static inline void tdx_bringup(void) {}
 static inline void tdx_cleanup(void) {}
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
new file mode 100644
index 000000000000..a9b9ad15f6a8
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -0,0 +1,387 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Constants/data definitions for TDX SEAMCALLs
+ *
+ * This file is included by "tdx.h" after declarations of 'struct
+ * kvm_tdx' and 'struct vcpu_tdx'.  C file should never include
+ * this header directly.
+ */
+
+#ifndef __KVM_X86_TDX_OPS_H
+#define __KVM_X86_TDX_OPS_H
+
+#include <asm/cacheflush.h>
+#include <asm/page.h>
+#include <asm/tdx.h>
+
+#include "x86.h"
+
+static inline u64 tdh_mng_addcx(struct kvm_tdx *kvm_tdx, hpa_t addr)
+{
+	struct tdx_module_args in = {
+		.rcx = addr,
+		.rdx = kvm_tdx->tdr_pa,
+	};
+
+	clflush_cache_range(__va(addr), PAGE_SIZE);
+	return seamcall(TDH_MNG_ADDCX, &in);
+}
+
+static inline u64 tdh_mem_page_add(struct kvm_tdx *kvm_tdx, gpa_t gpa,
+				   hpa_t hpa, hpa_t source,
+				   u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa,
+		.rdx = kvm_tdx->tdr_pa,
+		.r8 = hpa,
+		.r9 = source,
+	};
+	u64 ret;
+
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	ret = seamcall_ret(TDH_MEM_PAGE_ADD, &in);
+
+	*rcx = in.rcx;
+	*rdx = in.rdx;
+
+	return ret;
+}
+
+static inline u64 tdh_mem_sept_add(struct kvm_tdx *kvm_tdx, gpa_t gpa,
+				   int level, hpa_t page,
+				   u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa | level,
+		.rdx = kvm_tdx->tdr_pa,
+		.r8 = page,
+	};
+	u64 ret;
+
+	clflush_cache_range(__va(page), PAGE_SIZE);
+
+	ret = seamcall_ret(TDH_MEM_SEPT_ADD, &in);
+
+	*rcx = in.rcx;
+	*rdx = in.rdx;
+
+	return ret;
+}
+
+static inline u64 tdh_mem_sept_remove(struct kvm_tdx *kvm_tdx, gpa_t gpa,
+				      int level, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa | level,
+		.rdx = kvm_tdx->tdr_pa,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MEM_SEPT_REMOVE, &in);
+
+	*rcx = in.rcx;
+	*rdx = in.rdx;
+
+	return ret;
+}
+
+static inline u64 tdh_vp_addcx(struct vcpu_tdx *tdx, hpa_t addr)
+{
+	struct tdx_module_args in = {
+		.rcx = addr,
+		.rdx = tdx->tdvpr_pa,
+	};
+
+	clflush_cache_range(__va(addr), PAGE_SIZE);
+	return seamcall(TDH_VP_ADDCX, &in);
+}
+
+static inline u64 tdh_mem_page_aug(struct kvm_tdx *kvm_tdx, gpa_t gpa, hpa_t hpa,
+				   u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa,
+		.rdx = kvm_tdx->tdr_pa,
+		.r8 = hpa,
+	};
+	u64 ret;
+
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &in);
+
+	*rcx = in.rcx;
+	*rdx = in.rdx;
+
+	return ret;
+}
+
+static inline u64 tdh_mem_range_block(struct kvm_tdx *kvm_tdx, gpa_t gpa,
+				      int level, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa | level,
+		.rdx = kvm_tdx->tdr_pa,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MEM_RANGE_BLOCK, &in);
+
+	*rcx = in.rcx;
+	*rdx = in.rdx;
+
+	return ret;
+}
+
+static inline u64 tdh_mng_key_config(struct kvm_tdx *kvm_tdx)
+{
+	struct tdx_module_args in = {
+		.rcx = kvm_tdx->tdr_pa,
+	};
+
+	return seamcall(TDH_MNG_KEY_CONFIG, &in);
+}
+
+static inline u64 tdh_mng_create(struct kvm_tdx *kvm_tdx, int hkid)
+{
+	struct tdx_module_args in = {
+		.rcx = kvm_tdx->tdr_pa,
+		.rdx = hkid,
+	};
+
+	clflush_cache_range(__va(kvm_tdx->tdr_pa), PAGE_SIZE);
+	return seamcall(TDH_MNG_CREATE, &in);
+}
+
+static inline u64 tdh_vp_create(struct vcpu_tdx *tdx)
+{
+	struct tdx_module_args in = {
+		.rcx = tdx->tdvpr_pa,
+		.rdx = to_kvm_tdx(tdx->vcpu.kvm)->tdr_pa,
+	};
+
+	clflush_cache_range(__va(tdx->tdvpr_pa), PAGE_SIZE);
+	return seamcall(TDH_VP_CREATE, &in);
+}
+
+static inline u64 tdh_mng_rd(struct kvm_tdx *kvm_tdx, u64 field, u64 *data)
+{
+	struct tdx_module_args in = {
+		.rcx = kvm_tdx->tdr_pa,
+		.rdx = field,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MNG_RD, &in);
+
+	*data = in.r8;
+
+	return ret;
+}
+
+static inline u64 tdh_mr_extend(struct kvm_tdx *kvm_tdx, gpa_t gpa,
+				u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa,
+		.rdx = kvm_tdx->tdr_pa,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MR_EXTEND, &in);
+
+	*rcx = in.rcx;
+	*rdx = in.rdx;
+
+	return ret;
+}
+
+static inline u64 tdh_mr_finalize(struct kvm_tdx *kvm_tdx)
+{
+	struct tdx_module_args in = {
+		.rcx = kvm_tdx->tdr_pa,
+	};
+
+	return seamcall(TDH_MR_FINALIZE, &in);
+}
+
+static inline u64 tdh_vp_flush(struct vcpu_tdx *tdx)
+{
+	struct tdx_module_args in = {
+		.rcx = tdx->tdvpr_pa,
+	};
+
+	return seamcall(TDH_VP_FLUSH, &in);
+}
+
+static inline u64 tdh_mng_vpflushdone(struct kvm_tdx *kvm_tdx)
+{
+	struct tdx_module_args in = {
+		.rcx = kvm_tdx->tdr_pa,
+	};
+
+	return seamcall(TDH_MNG_VPFLUSHDONE, &in);
+}
+
+static inline u64 tdh_mng_key_freeid(struct kvm_tdx *kvm_tdx)
+{
+	struct tdx_module_args in = {
+		.rcx = kvm_tdx->tdr_pa,
+	};
+
+	return seamcall(TDH_MNG_KEY_FREEID, &in);
+}
+
+static inline u64 tdh_mng_init(struct kvm_tdx *kvm_tdx, hpa_t td_params,
+			       u64 *rcx)
+{
+	struct tdx_module_args in = {
+		.rcx = kvm_tdx->tdr_pa,
+		.rdx = td_params,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MNG_INIT, &in);
+
+	*rcx = in.rcx;
+
+	return ret;
+}
+
+static inline u64 tdh_vp_init(struct vcpu_tdx *tdx, u64 rcx)
+{
+	struct tdx_module_args in = {
+		.rcx = tdx->tdvpr_pa,
+		.rdx = rcx,
+	};
+
+	return seamcall(TDH_VP_INIT, &in);
+}
+
+static inline u64 tdh_vp_init_apicid(struct vcpu_tdx *tdx, u64 rcx, u32 x2apicid)
+{
+	struct tdx_module_args in = {
+		.rcx = tdx->tdvpr_pa,
+		.rdx = rcx,
+		.r8 = x2apicid,
+	};
+
+	/* apicid requires version == 1. */
+	return seamcall(TDH_VP_INIT | (1ULL << TDX_VERSION_SHIFT), &in);
+}
+
+static inline u64 tdh_vp_rd(struct vcpu_tdx *tdx, u64 field, u64 *data)
+{
+	struct tdx_module_args in = {
+		.rcx = tdx->tdvpr_pa,
+		.rdx = field,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_VP_RD, &in);
+
+	*data = in.r8;
+
+	return ret;
+}
+
+static inline u64 tdh_mng_key_reclaimid(struct kvm_tdx *kvm_tdx)
+{
+	struct tdx_module_args in = {
+		.rcx = kvm_tdx->tdr_pa,
+	};
+
+	return seamcall(TDH_MNG_KEY_RECLAIMID, &in);
+}
+
+static inline u64 tdh_phymem_page_reclaim(hpa_t page, u64 *rcx, u64 *rdx,
+					  u64 *r8)
+{
+	struct tdx_module_args in = {
+		.rcx = page,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_PHYMEM_PAGE_RECLAIM, &in);
+
+	*rcx = in.rcx;
+	*rdx = in.rdx;
+	*r8 = in.r8;
+
+	return ret;
+}
+
+static inline u64 tdh_mem_page_remove(struct kvm_tdx *kvm_tdx, gpa_t gpa,
+				      int level, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa | level,
+		.rdx = kvm_tdx->tdr_pa,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MEM_PAGE_REMOVE, &in);
+
+	*rcx = in.rcx;
+	*rdx = in.rdx;
+
+	return ret;
+}
+
+static inline u64 tdh_mem_track(struct kvm_tdx *kvm_tdx)
+{
+	struct tdx_module_args in = {
+		.rcx = kvm_tdx->tdr_pa,
+	};
+
+	return seamcall(TDH_MEM_TRACK, &in);
+}
+
+static inline u64 tdh_mem_range_unblock(struct kvm_tdx *kvm_tdx, gpa_t gpa,
+					int level, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa | level,
+		.rdx = kvm_tdx->tdr_pa,
+	};
+	u64 ret;
+
+	ret = seamcall_ret(TDH_MEM_RANGE_UNBLOCK, &in);
+
+	*rcx = in.rcx;
+	*rdx = in.rdx;
+
+	return ret;
+}
+
+static inline u64 tdh_phymem_cache_wb(bool resume)
+{
+	struct tdx_module_args in = {
+		.rcx = resume ? 1 : 0,
+	};
+
+	return seamcall(TDH_PHYMEM_CACHE_WB, &in);
+}
+
+static inline u64 tdh_phymem_page_wbinvd(hpa_t page)
+{
+	struct tdx_module_args in = {
+		.rcx = page,
+	};
+
+	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &in);
+}
+
+static inline u64 tdh_vp_wr(struct vcpu_tdx *tdx, u64 field, u64 val, u64 mask)
+{
+	struct tdx_module_args in = {
+		.rcx = tdx->tdvpr_pa,
+		.rdx = field,
+		.r8 = val,
+		.r9 = mask,
+	};
+
+	return seamcall(TDH_VP_WR, &in);
+}
+
+#endif /* __KVM_X86_TDX_OPS_H */
-- 
2.34.1


