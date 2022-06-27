Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7284D55DA38
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241470AbiF0VzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241297AbiF0Vyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:55 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584376305;
        Mon, 27 Jun 2022 14:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366893; x=1687902893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8GfDMTsHwwGryg292MoTgp8xb4T2/mTWqYyqehU6Iqs=;
  b=lH/mF30I8NfKVl0vs0CDRYf/s3I6K0Tfj572MKt8yXgkn7uAryk0z9Qt
   uobMmSb3BPPDXz+ELWdY1BK9mK6gwDVdj42q2Sg5x5OleVBXin/5PErXQ
   h0GqLctV8AZL5t0PTXOG4feFELFAJS+MHWqx+YpwT+QQJbS1rqDIG7GjW
   78N/+4+cl5MEsD2i1E5pkloAGFrLHo3HPSPTxLptyqOFO2qNPVEFgejif
   Ey2QmQs+aeSS7/+T/Kc4pUHrcqGgA+IU/RfJ4z4+gPf6quJJ2e+9RGB9x
   qS/d9QF+EnGSj5eAnwhKE6/dJc89W3NnZf6uR4U7XqObLDI6+3YmjQs6m
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609511"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609511"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:49 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863487"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:49 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v7 017/102] KVM: TDX: Add C wrapper functions for SEAMCALLs to the TDX module
Date:   Mon, 27 Jun 2022 14:53:09 -0700
Message-Id: <aaca2f46bd81a2868f9b132769910882db12a385.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

A VMM interacts with the TDX module using a new instruction (SEAMCALL).  A
TDX VMM uses SEAMCALLs where a VMX VMM would have directly interacted with
VMX instructions.  For instance, a TDX VMM does not have full access to the
VM control structure corresponding to VMX VMCS.  Instead, a VMM induces the
TDX module to act on behalf via SEAMCALLs.

Export __seamcall and define C wrapper functions for SEAMCALLs for
readability.  Some SEAMCALL APIs donates pages to TDX module or guest TD.
The pages are encrypted with TDX private host key id set in high bits of
physical address.  If any modified cache lines may exit for these pages,
flush them to memory by clflush_cache_range().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h       |   2 +
 arch/x86/kvm/vmx/tdx_ops.h       | 185 +++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/seamcall.S |   2 +
 3 files changed, 189 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_ops.h

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index dfea0dd71bc1..c887618e3cec 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -144,6 +144,8 @@ struct tdsysinfo_struct {
 bool platform_tdx_enabled(void);
 int tdx_init(void);
 const struct tdsysinfo_struct *tdx_get_sysinfo(void);
+u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
+	       struct tdx_module_output *out);
 #else	/* !CONFIG_INTEL_TDX_HOST */
 static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_init(void)  { return -ENODEV; }
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
new file mode 100644
index 000000000000..85adbf49c277
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -0,0 +1,185 @@
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
+
+#ifdef CONFIG_INTEL_TDX_HOST
+
+static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
+{
+	clflush_cache_range(__va(addr), PAGE_SIZE);
+	return __seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
+				   struct tdx_module_output *out)
+{
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	return __seamcall(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
+}
+
+static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
+				   struct tdx_module_output *out)
+{
+	clflush_cache_range(__va(page), PAGE_SIZE);
+	return __seamcall(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, out);
+}
+
+static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
+				      struct tdx_module_output *out)
+{
+	return __seamcall(TDH_MEM_SEPT_REMOVE, gpa | level, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
+{
+	clflush_cache_range(__va(addr), PAGE_SIZE);
+	return __seamcall(TDH_VP_ADDCX, addr, tdvpr, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+					struct tdx_module_output *out)
+{
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	return __seamcall(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0, out);
+}
+
+static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+				   struct tdx_module_output *out)
+{
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	return __seamcall(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
+}
+
+static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
+				      struct tdx_module_output *out)
+{
+	return __seamcall(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_mng_key_config(hpa_t tdr)
+{
+	return __seamcall(TDH_MNG_KEY_CONFIG, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
+{
+	clflush_cache_range(__va(tdr), PAGE_SIZE);
+	return __seamcall(TDH_MNG_CREATE, tdr, hkid, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
+{
+	clflush_cache_range(__va(tdvpr), PAGE_SIZE);
+	return __seamcall(TDH_VP_CREATE, tdvpr, tdr, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct tdx_module_output *out)
+{
+	return __seamcall(TDH_MNG_RD, tdr, field, 0, 0, out);
+}
+
+static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
+				struct tdx_module_output *out)
+{
+	return __seamcall(TDH_MR_EXTEND, gpa, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_mr_finalize(hpa_t tdr)
+{
+	return __seamcall(TDH_MR_FINALIZE, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_flush(hpa_t tdvpr)
+{
+	return __seamcall(TDH_VP_FLUSH, tdvpr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_vpflushdone(hpa_t tdr)
+{
+	return __seamcall(TDH_MNG_VPFLUSHDONE, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_key_freeid(hpa_t tdr)
+{
+	return __seamcall(TDH_MNG_KEY_FREEID, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_init(hpa_t tdr, hpa_t td_params,
+			       struct tdx_module_output *out)
+{
+	return __seamcall(TDH_MNG_INIT, tdr, td_params, 0, 0, out);
+}
+
+static inline u64 tdh_vp_init(hpa_t tdvpr, u64 rcx)
+{
+	return __seamcall(TDH_VP_INIT, tdvpr, rcx, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_rd(hpa_t tdvpr, u64 field,
+			    struct tdx_module_output *out)
+{
+	return __seamcall(TDH_VP_RD, tdvpr, field, 0, 0, out);
+}
+
+static inline u64 tdh_mng_key_reclaimid(hpa_t tdr)
+{
+	return __seamcall(TDH_MNG_KEY_RECLAIMID, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_phymem_page_reclaim(hpa_t page,
+					  struct tdx_module_output *out)
+{
+	return __seamcall(TDH_PHYMEM_PAGE_RECLAIM, page, 0, 0, 0, out);
+}
+
+static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
+				      struct tdx_module_output *out)
+{
+	return __seamcall(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_sys_lp_shutdown(void)
+{
+	return __seamcall(TDH_SYS_LP_SHUTDOWN, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_track(hpa_t tdr)
+{
+	return __seamcall(TDH_MEM_TRACK, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
+					struct tdx_module_output *out)
+{
+	return __seamcall(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_phymem_cache_wb(bool resume)
+{
+	return __seamcall(TDH_PHYMEM_CACHE_WB, resume ? 1 : 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_phymem_page_wbinvd(hpa_t page)
+{
+	return __seamcall(TDH_PHYMEM_PAGE_WBINVD, page, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_wr(hpa_t tdvpr, u64 field, u64 val, u64 mask,
+			    struct tdx_module_output *out)
+{
+	return __seamcall(TDH_VP_WR, tdvpr, field, val, mask, out);
+}
+#endif /* CONFIG_INTEL_TDX_HOST */
+
+#endif /* __KVM_X86_TDX_OPS_H */
diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
index f322427e48c3..aced0ed9b76a 100644
--- a/arch/x86/virt/vmx/tdx/seamcall.S
+++ b/arch/x86/virt/vmx/tdx/seamcall.S
@@ -1,5 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/linkage.h>
+#include <asm/export.h>
 #include <asm/frame.h>
 
 #include "tdxcall.S"
@@ -50,3 +51,4 @@ SYM_FUNC_START(__seamcall)
 	FRAME_END
 	RET
 SYM_FUNC_END(__seamcall)
+EXPORT_SYMBOL_GPL(__seamcall)
-- 
2.25.1

