Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7975071429C
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbjE2EVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjE2EUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:20:53 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C047CB1;
        Sun, 28 May 2023 21:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334050; x=1716870050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HJnAMsq6xGr2tpHM3aBYwyoRU7N0x2/vmN4pF1sVpRw=;
  b=eJoDYDBL6SLFBnGJCAomO+215RgsIKIr9ewt2haSBWOcjv8GiCyF4U7m
   t5TrdUVx4zl8FI6qtCrjFiCiGsnSAh72xDWFOjpZh1Pe/sLcUbTS5rZHp
   D1yVyYWeYycKHC70I+xzPYCoz86L5fbmOwoU+erNLK2tNqcxl2oJ8EjbN
   XLgmBo7NtipxHgttfbWUVsvd/s8Utt9wmKaSEMuEg1Ua+yvNbqSMSBmZw
   ZvqzDk56evl6L27cHH/JCAQidcFysizZZkn0DFjWOKs2tUxU1dTd+bTI5
   c56/idp6zveRkBPVugVakM+t1XS+HShtD7IeMORxkTaQEf3x3QKNbJF1a
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="418094287"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="418094287"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:20:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="683419319"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="683419319"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:20:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v14 011/113] KVM: TDX: Add C wrapper functions for SEAMCALLs to the TDX module
Date:   Sun, 28 May 2023 21:18:53 -0700
Message-Id: <37b118268ccf73d8e9cc1ef8f9fb7376fb732d60.1685333727.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

A VMM interacts with the TDX module using a new instruction (SEAMCALL).
For instance, a TDX VMM does not have full access to the VM control
structure corresponding to VMX VMCS.  Instead, a VMM induces the TDX module
to act on behalf via SEAMCALLs.

Export __seamcall and define C wrapper functions for SEAMCALLs for
readability.

Some SEAMCALL APIs donate host pages to TDX module or guest TD, and the
donated pages are encrypted.  Such SEAMCALLs flush cache lines
(typically by movdir64b instruction), but some don't.  Those that don't
clear cache lines require the VMM to flush the cache lines to avoid cache
line alias.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h       |   4 +
 arch/x86/kvm/vmx/tdx_ops.h       | 202 +++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/seamcall.S |   2 +
 arch/x86/virt/vmx/tdx/tdx.h      |   3 -
 4 files changed, 208 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/tdx_ops.h

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 112a5b9bd5cd..6c01ab572c1f 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -104,10 +104,14 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 bool platform_tdx_enabled(void);
 int tdx_cpu_enable(void);
 int tdx_enable(void);
+u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
+	       struct tdx_module_output *out);
 #else	/* !CONFIG_INTEL_TDX_HOST */
 static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_cpu_enable(void) { return -EINVAL; }
 static inline int tdx_enable(void)  { return -EINVAL; }
+static inline u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
+			     struct tdx_module_output *out) { return TDX_SEAMCALL_UD; };
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
new file mode 100644
index 000000000000..893cc6c25f3b
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -0,0 +1,202 @@
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
+static inline u64 kvm_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
+			       struct tdx_module_output *out)
+{
+	u64 ret;
+
+	ret = __seamcall(op, rcx, rdx, r8, r9, out);
+	if (unlikely(ret == TDX_SEAMCALL_UD)) {
+		/*
+		 * TDX requires VMXON or #UD.  In the case of reboot or kexec,
+		 * VMX is made off (VMXOFF) by kvm reboot notifier,
+		 * kvm_reboot(), while TDs are still running.  The callers check
+		 * the returned error and complain.  Suppress it by returning 0.
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
+	return kvm_seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
+				   struct tdx_module_output *out)
+{
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	return kvm_seamcall(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
+}
+
+static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
+				   struct tdx_module_output *out)
+{
+	clflush_cache_range(__va(page), PAGE_SIZE);
+	return kvm_seamcall(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, out);
+}
+
+static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
+				      struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MEM_SEPT_REMOVE, gpa | level, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
+{
+	clflush_cache_range(__va(addr), PAGE_SIZE);
+	return kvm_seamcall(TDH_VP_ADDCX, addr, tdvpr, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+					struct tdx_module_output *out)
+{
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	return kvm_seamcall(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0, out);
+}
+
+static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+				   struct tdx_module_output *out)
+{
+	clflush_cache_range(__va(hpa), PAGE_SIZE);
+	return kvm_seamcall(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
+}
+
+static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
+				      struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_mng_key_config(hpa_t tdr)
+{
+	return kvm_seamcall(TDH_MNG_KEY_CONFIG, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
+{
+	clflush_cache_range(__va(tdr), PAGE_SIZE);
+	return kvm_seamcall(TDH_MNG_CREATE, tdr, hkid, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
+{
+	clflush_cache_range(__va(tdvpr), PAGE_SIZE);
+	return kvm_seamcall(TDH_VP_CREATE, tdvpr, tdr, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MNG_RD, tdr, field, 0, 0, out);
+}
+
+static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
+				struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MR_EXTEND, gpa, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_mr_finalize(hpa_t tdr)
+{
+	return kvm_seamcall(TDH_MR_FINALIZE, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_flush(hpa_t tdvpr)
+{
+	return kvm_seamcall(TDH_VP_FLUSH, tdvpr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_vpflushdone(hpa_t tdr)
+{
+	return kvm_seamcall(TDH_MNG_VPFLUSHDONE, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_key_freeid(hpa_t tdr)
+{
+	return kvm_seamcall(TDH_MNG_KEY_FREEID, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_init(hpa_t tdr, hpa_t td_params,
+			       struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MNG_INIT, tdr, td_params, 0, 0, out);
+}
+
+static inline u64 tdh_vp_init(hpa_t tdvpr, u64 rcx)
+{
+	return kvm_seamcall(TDH_VP_INIT, tdvpr, rcx, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_rd(hpa_t tdvpr, u64 field,
+			    struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_VP_RD, tdvpr, field, 0, 0, out);
+}
+
+static inline u64 tdh_mng_key_reclaimid(hpa_t tdr)
+{
+	return kvm_seamcall(TDH_MNG_KEY_RECLAIMID, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_phymem_page_reclaim(hpa_t page,
+					  struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_PHYMEM_PAGE_RECLAIM, page, 0, 0, 0, out);
+}
+
+static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
+				      struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_sys_lp_shutdown(void)
+{
+	return kvm_seamcall(TDH_SYS_LP_SHUTDOWN, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_track(hpa_t tdr)
+{
+	return kvm_seamcall(TDH_MEM_TRACK, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
+					struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, out);
+}
+
+static inline u64 tdh_phymem_cache_wb(bool resume)
+{
+	return kvm_seamcall(TDH_PHYMEM_CACHE_WB, resume ? 1 : 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_phymem_page_wbinvd(hpa_t page)
+{
+	return kvm_seamcall(TDH_PHYMEM_PAGE_WBINVD, page, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_wr(hpa_t tdvpr, u64 field, u64 val, u64 mask,
+			    struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_VP_WR, tdvpr, field, val, mask, out);
+}
+
+#endif /* __KVM_X86_TDX_OPS_H */
diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
index f81be6b9c133..b90a7fe05494 100644
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
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 48f830087e7e..4e497f202586 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -144,7 +144,4 @@ struct tdmr_info_list {
 	int max_tdmrs;	/* How many 'tdmr_info's are allocated */
 };
 
-struct tdx_module_output;
-u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
-	       struct tdx_module_output *out);
 #endif
-- 
2.25.1

