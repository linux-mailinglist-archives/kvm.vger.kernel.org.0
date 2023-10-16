Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76857CAFBA
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbjJPQho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbjJPQhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:37:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0ABD47BA;
        Mon, 16 Oct 2023 09:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473241; x=1729009241;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zagIa7AJpDuXH7LOu3KDninTUfO9278rauMUBGVA4l8=;
  b=Ygx52uzGvRCEIwThf5zR5pfOXFxXaNGSEJgkfOKtUd9Ezt0uh5iCU6Yl
   YRAcQ5s4xPvk63nKuo60lxpOXKX6AFNplo0jVOOtQzHRJvBymcNIao/63
   WNzn5F50eGzweV+EBDEn5/yQOBv6VaeX/N23qem7EDorNJQIKovmoEPHA
   x/DQ/eciLqzKKh+EQ743Lq7rgaoC97I2U3AShO22rUCNyDUdW7AvHwhhf
   kvMPTBQqXDVn8zbZjowopilxknf4w2OZ5H5KX//q7suPfJibwlbB9fQCr
   LMbfS3QnQ26gkH1HyKuL94ZQBVY+7OKMcqcuaNTVZYXEj1/bddc7FFaJG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365825915"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365825915"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087125997"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087125997"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:25 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v16 011/116] KVM: TDX: Add C wrapper functions for SEAMCALLs to the TDX module
Date:   Mon, 16 Oct 2023 09:13:23 -0700
Message-Id: <7036702f3bb1e181ff1ee2f6a78b7ab28a770b90.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
index 9aaf40107819..ec2b8e67fe07 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -116,6 +116,18 @@ int tdx_enable(void);
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

