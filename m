Return-Path: <kvm+bounces-6587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A49D38379A3
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1990A1F278A6
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F185156462;
	Mon, 22 Jan 2024 23:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BsvB2e/+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D957752F8A;
	Mon, 22 Jan 2024 23:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967704; cv=none; b=brKjxerFPfdRhPEpWyi7TgKoJgOuk/KR6c4iP1hfEVl6gueheN0h1ysSVkk8FFUeckT2WyviFCynzYt+UvQWPaTKiN8Kh9PBiEAn2LfyfVbGFgtGLb4LZAqRYgCFcQGo2RM2TIm7EadQS28le9Rr3S2hP7tgJYUKmKdL7trZakU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967704; c=relaxed/simple;
	bh=MGTpHxY3pub38AXkE0bJhmtexOzagYYNALQL5mg/MCE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZDifx2sIrqgYVUcL62mVt0H1X5F6HUzsigmzwnU4ASHK4wpSd3Xp1+PqqXnD34x5i4dRVgEtOba0n43y+sYfKlBOjX2L0UH1R3GxU18FXyavLmXS3MgMWKZWqjOp28f3s10x6QhSSxlZ8MEknSjlEZj2wB5V/+mwgYgsMaORyWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BsvB2e/+; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967702; x=1737503702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MGTpHxY3pub38AXkE0bJhmtexOzagYYNALQL5mg/MCE=;
  b=BsvB2e/+LgLqDhEUVMpQ5BHhxkv6XK07fHCi89Tk+jF9n1O868o1O8np
   ZdBQoXEvuONbeUWUzPzq4Qi0d8gqRvSzSf9xt21BBFi9qpQEYeA9uSK9M
   ZgwIzaAHL4FxLDtAOmT8tRAi6bmK8Or0OG9CXTipvYwEoundAAk7Hgpnq
   vCYAEPZ4xmNXG7RHnZvvmG+c6vxWqut/tJLftT+mnUNR1TEHVRFfMxrP1
   kad4PHHuhPESLsgxpe4hNb9UVmEx9sVfnG+5tsYZNCap9PeDP9QugEFxZ
   7l3MO/Lt7rV8sBVdZu0bLzaOQL+U2dzkboIYVGdLuFZMHRMbLeyX8u0mn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1217869"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1217869"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1350166"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:01 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v18 014/121] KVM: TDX: Add C wrapper functions for SEAMCALLs to the TDX module
Date: Mon, 22 Jan 2024 15:52:50 -0800
Message-Id: <15ecf723535623fd99b6f9e5101b545b2f6e98be.1705965634.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

---
Changes
v18:
- removed stub functions for __seamcall{,_ret}()
- Added Reviewed-by Binbin
- Make tdx_seamcall() use struct tdx_module_args instead of taking
  each inputs.

v15 -> v16:
- use struct tdx_module_args instead of struct tdx_module_output
- Add tdh_mem_sept_rd() for SEPT_VE_DISABLE=1.
---
 arch/x86/kvm/vmx/tdx_ops.h | 360 +++++++++++++++++++++++++++++++++++++
 1 file changed, 360 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_ops.h

diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
new file mode 100644
index 000000000000..0e26cf22240e
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -0,0 +1,360 @@
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
+static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
+			       struct tdx_module_args *out)
+{
+	u64 ret;
+
+	if (out) {
+		*out = *in;
+		ret = __seamcall_ret(op, out);
+	} else
+		ret = __seamcall(op, in);
+
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
+	struct tdx_module_args in = {
+		.rcx = addr,
+		.rdx = tdr,
+	};
+
+	clflush_cache_range(__va(addr), PAGE_SIZE);
+	return tdx_seamcall(TDH_MNG_ADDCX, &in, NULL);
+}
+
+static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
+				   struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa,
+		.rdx = tdr,
+		.r8 = hpa,
+		.r9 = source,
+	};
+
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	return tdx_seamcall(TDH_MEM_PAGE_ADD, &in, out);
+}
+
+static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
+				   struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa | level,
+		.rdx = tdr,
+		.r8 = page,
+	};
+
+	clflush_cache_range(__va(page), PAGE_SIZE);
+	return tdx_seamcall(TDH_MEM_SEPT_ADD, &in, out);
+}
+
+static inline u64 tdh_mem_sept_rd(hpa_t tdr, gpa_t gpa, int level,
+				  struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa | level,
+		.rdx = tdr,
+	};
+
+	return tdx_seamcall(TDH_MEM_SEPT_RD, &in, out);
+}
+
+static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
+				      struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa | level,
+		.rdx = tdr,
+	};
+
+	return tdx_seamcall(TDH_MEM_SEPT_REMOVE, &in, out);
+}
+
+static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
+{
+	struct tdx_module_args in = {
+		.rcx = addr,
+		.rdx = tdvpr,
+	};
+
+	clflush_cache_range(__va(addr), PAGE_SIZE);
+	return tdx_seamcall(TDH_VP_ADDCX, &in, NULL);
+}
+
+static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+					struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa,
+		.rdx = tdr,
+		.r8 = hpa,
+	};
+
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	return tdx_seamcall(TDH_MEM_PAGE_RELOCATE, &in, out);
+}
+
+static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+				   struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa,
+		.rdx = tdr,
+		.r8 = hpa,
+	};
+
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	return tdx_seamcall(TDH_MEM_PAGE_AUG, &in, out);
+}
+
+static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
+				      struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa | level,
+		.rdx = tdr,
+	};
+
+	return tdx_seamcall(TDH_MEM_RANGE_BLOCK, &in, out);
+}
+
+static inline u64 tdh_mng_key_config(hpa_t tdr)
+{
+	struct tdx_module_args in = {
+		.rcx = tdr,
+	};
+
+	return tdx_seamcall(TDH_MNG_KEY_CONFIG, &in, NULL);
+}
+
+static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
+{
+	struct tdx_module_args in = {
+		.rcx = tdr,
+		.rdx = hkid,
+	};
+
+	clflush_cache_range(__va(tdr), PAGE_SIZE);
+	return tdx_seamcall(TDH_MNG_CREATE, &in, NULL);
+}
+
+static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
+{
+	struct tdx_module_args in = {
+		.rcx = tdvpr,
+		.rdx = tdr,
+	};
+
+	clflush_cache_range(__va(tdvpr), PAGE_SIZE);
+	return tdx_seamcall(TDH_VP_CREATE, &in, NULL);
+}
+
+static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = tdr,
+		.rdx = field,
+	};
+
+	return tdx_seamcall(TDH_MNG_RD, &in, out);
+}
+
+static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
+				struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa,
+		.rdx = tdr,
+	};
+
+	return tdx_seamcall(TDH_MR_EXTEND, &in, out);
+}
+
+static inline u64 tdh_mr_finalize(hpa_t tdr)
+{
+	struct tdx_module_args in = {
+		.rcx = tdr,
+	};
+
+	return tdx_seamcall(TDH_MR_FINALIZE, &in, NULL);
+}
+
+static inline u64 tdh_vp_flush(hpa_t tdvpr)
+{
+	struct tdx_module_args in = {
+		.rcx = tdvpr,
+	};
+
+	return tdx_seamcall(TDH_VP_FLUSH, &in, NULL);
+}
+
+static inline u64 tdh_mng_vpflushdone(hpa_t tdr)
+{
+	struct tdx_module_args in = {
+		.rcx = tdr,
+	};
+
+	return tdx_seamcall(TDH_MNG_VPFLUSHDONE, &in, NULL);
+}
+
+static inline u64 tdh_mng_key_freeid(hpa_t tdr)
+{
+	struct tdx_module_args in = {
+		.rcx = tdr,
+	};
+
+	return tdx_seamcall(TDH_MNG_KEY_FREEID, &in, NULL);
+}
+
+static inline u64 tdh_mng_init(hpa_t tdr, hpa_t td_params,
+			       struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = tdr,
+		.rdx = td_params,
+	};
+
+	return tdx_seamcall(TDH_MNG_INIT, &in, out);
+}
+
+static inline u64 tdh_vp_init(hpa_t tdvpr, u64 rcx)
+{
+	struct tdx_module_args in = {
+		.rcx = tdvpr,
+		.rdx = rcx,
+	};
+
+	return tdx_seamcall(TDH_VP_INIT, &in, NULL);
+}
+
+static inline u64 tdh_vp_rd(hpa_t tdvpr, u64 field,
+			    struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = tdvpr,
+		.rdx = field,
+	};
+
+	return tdx_seamcall(TDH_VP_RD, &in, out);
+}
+
+static inline u64 tdh_mng_key_reclaimid(hpa_t tdr)
+{
+	struct tdx_module_args in = {
+		.rcx = tdr,
+	};
+
+	return tdx_seamcall(TDH_MNG_KEY_RECLAIMID, &in, NULL);
+}
+
+static inline u64 tdh_phymem_page_reclaim(hpa_t page,
+					  struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = page,
+	};
+
+	return tdx_seamcall(TDH_PHYMEM_PAGE_RECLAIM, &in, out);
+}
+
+static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
+				      struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa | level,
+		.rdx = tdr,
+	};
+
+	return tdx_seamcall(TDH_MEM_PAGE_REMOVE, &in, out);
+}
+
+static inline u64 tdh_sys_lp_shutdown(void)
+{
+	struct tdx_module_args in = {
+	};
+
+	return tdx_seamcall(TDH_SYS_LP_SHUTDOWN, &in, NULL);
+}
+
+static inline u64 tdh_mem_track(hpa_t tdr)
+{
+	struct tdx_module_args in = {
+		.rcx = tdr,
+	};
+
+	return tdx_seamcall(TDH_MEM_TRACK, &in, NULL);
+}
+
+static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
+					struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = gpa | level,
+		.rdx = tdr,
+	};
+
+	return tdx_seamcall(TDH_MEM_RANGE_UNBLOCK, &in, out);
+}
+
+static inline u64 tdh_phymem_cache_wb(bool resume)
+{
+	struct tdx_module_args in = {
+		.rcx = resume ? 1 : 0,
+	};
+
+	return tdx_seamcall(TDH_PHYMEM_CACHE_WB, &in, NULL);
+}
+
+static inline u64 tdh_phymem_page_wbinvd(hpa_t page)
+{
+	struct tdx_module_args in = {
+		.rcx = page,
+	};
+
+	return tdx_seamcall(TDH_PHYMEM_PAGE_WBINVD, &in, NULL);
+}
+
+static inline u64 tdh_vp_wr(hpa_t tdvpr, u64 field, u64 val, u64 mask,
+			    struct tdx_module_args *out)
+{
+	struct tdx_module_args in = {
+		.rcx = tdvpr,
+		.rdx = field,
+		.r8 = val,
+		.r9 = mask,
+	};
+
+	return tdx_seamcall(TDH_VP_WR, &in, out);
+}
+
+#endif /* __KVM_X86_TDX_OPS_H */
-- 
2.25.1


