Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647495F0872
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbiI3KUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbiI3KTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:00 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544621664AC;
        Fri, 30 Sep 2022 03:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533138; x=1696069138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8GfDMTsHwwGryg292MoTgp8xb4T2/mTWqYyqehU6Iqs=;
  b=NrvIgos6iRa2Gyd/bGunZm7m2WKPzRAp7PyRiYwSb+Uieh1ReNv1mmjm
   zzHlHZAljQIdhLc2FKtRj/c5qmyKdkJ+HlHzSdo4aquQB4Eu8s+E0UaDC
   GpqvD5953R8BRifTBgZ4kRJY77W/QIGiLiS/1NIpYk3F9IbWPpnpqDXLg
   19b4mpAdUIROgoIMcuU+k3shm+laa1Tro0DOzflh0Tg5aclzhDksnMf12
   RJ6BUKvcV4tUfsX4gIyXx7sISTTmqHqZbUEXkCFTHC+8NUfeIqPSFyDIP
   HxlVmX0vyhlZ9KfLVD5d1qF9cWaFa/bfTJRhDNmUkIko11i9Tc+wz69+D
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="366207481"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="366207481"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:53 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807538"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807538"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:53 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v9 011/105] KVM: TDX: Add C wrapper functions for SEAMCALLs to the TDX module
Date:   Fri, 30 Sep 2022 03:17:05 -0700
Message-Id: <168324cf75e978e86fc987e980e48fcb0a9cefb5.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

