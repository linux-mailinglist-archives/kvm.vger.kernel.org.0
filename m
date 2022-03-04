Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015C04CDEB8
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiCDUHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiCDUGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:06:39 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332B3A76E0;
        Fri,  4 Mar 2022 12:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424088; x=1677960088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F5m7BcH2I4LIYbZyCe8ZIRQ7zDSIomuzez9uQa0XnI8=;
  b=FXIyfLN4kTGEleox2RMG2tRBqkwmwNsySiSOXNsr6MKOCrYbYB2+9tFF
   Su09PBIJit3EM/Z7kkdd/RFEDaHJ8nB0acSqwvge72EFcPZvO8SlKm9Q4
   EjSQJTg2wWILC4+kDtIqhELeGKahfbWUJjEYE0oqJzGHKNnEUqYtxhh+O
   2PRDWKREgIcqD9Mu0tPMAu54JiaYT4/Lfss2vQtuX1ZdfcWnx3WpzHnUW
   4ajtCgSaGcfd5WAzVAs36VCpfK9MRgGXXb/jMn82G92u3mC4RGTd8nA/q
   +bfn+qWn+XjNrAIK1qLu4F29nlyMqF1GZtRzeSYZ3Ph1iceQIArl0tIFC
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983352"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983352"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:10 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344167"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:10 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 016/104] KVM: TDX: Add C wrapper functions for SEAMCALLs to the TDX module
Date:   Fri,  4 Mar 2022 11:48:32 -0800
Message-Id: <8b2eecc642ee34815312baf97db3a8a05f7738af.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX SEAMCALL interface is defined in the TDX module specification.  Define
C wrapper functions for SEAMCALLs for readability.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx_ops.h | 161 +++++++++++++++++++++++++++++++++++++
 1 file changed, 161 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_ops.h

diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
new file mode 100644
index 000000000000..0bed43879b82
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -0,0 +1,161 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* constants/data definitions for TDX SEAMCALLs */
+
+#ifndef __KVM_X86_TDX_OPS_H
+#define __KVM_X86_TDX_OPS_H
+
+#include <linux/compiler.h>
+
+#include <asm/asm.h>
+#include <asm/kvm_host.h>
+
+#include "tdx_errno.h"
+#include "tdx_arch.h"
+#include "seamcall.h"
+
+#ifdef CONFIG_INTEL_TDX_HOST
+
+static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
+{
+	return kvm_seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
+				struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, 0, out);
+}
+
+static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
+				struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, 0, out);
+}
+
+static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
+{
+	return kvm_seamcall(TDH_VP_ADDCX, addr, tdvpr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+				struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, 0, out);
+}
+
+static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
+				struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0, 0, out);
+}
+
+static inline u64 tdh_mng_key_config(hpa_t tdr)
+{
+	return kvm_seamcall(TDH_MNG_KEY_CONFIG, tdr, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
+{
+	return kvm_seamcall(TDH_MNG_CREATE, tdr, hkid, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
+{
+	return kvm_seamcall(TDH_VP_CREATE, tdvpr, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MNG_RD, tdr, field, 0, 0, 0, out);
+}
+
+static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa, struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MR_EXTEND, gpa, tdr, 0, 0, 0, out);
+}
+
+static inline u64 tdh_mr_finalize(hpa_t tdr)
+{
+	return kvm_seamcall(TDH_MR_FINALIZE, tdr, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_flush(hpa_t tdvpr)
+{
+	return kvm_seamcall(TDH_VP_FLUSH, tdvpr, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_vpflushdone(hpa_t tdr)
+{
+	return kvm_seamcall(TDH_MNG_VPFLUSHDONE, tdr, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_key_freeid(hpa_t tdr)
+{
+	return kvm_seamcall(TDH_MNG_KEY_FREEID, tdr, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_init(hpa_t tdr, hpa_t td_params, struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MNG_INIT, tdr, td_params, 0, 0, 0, out);
+}
+
+static inline u64 tdh_vp_init(hpa_t tdvpr, u64 rcx)
+{
+	return kvm_seamcall(TDH_VP_INIT, tdvpr, rcx, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_rd(hpa_t tdvpr, u64 field, struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_VP_RD, tdvpr, field, 0, 0, 0, out);
+}
+
+static inline u64 tdh_mng_key_reclaimid(hpa_t tdr)
+{
+	return kvm_seamcall(TDH_MNG_KEY_RECLAIMID, tdr, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_phymem_page_reclaim(hpa_t page, struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_PHYMEM_PAGE_RECLAIM, page, 0, 0, 0, 0, out);
+}
+
+static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
+				struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, 0, out);
+}
+
+static inline u64 tdh_sys_lp_shutdown(void)
+{
+	return kvm_seamcall(TDH_SYS_LP_SHUTDOWN, 0, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_track(hpa_t tdr)
+{
+	return kvm_seamcall(TDH_MEM_TRACK, tdr, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
+					struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, 0, out);
+}
+
+static inline u64 tdh_phymem_cache_wb(bool resume)
+{
+	return kvm_seamcall(TDH_PHYMEM_CACHE_WB, resume ? 1 : 0, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_phymem_page_wbinvd(hpa_t page)
+{
+	return kvm_seamcall(TDH_PHYMEM_PAGE_WBINVD, page, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_wr(hpa_t tdvpr, u64 field, u64 val, u64 mask,
+			struct tdx_module_output *out)
+{
+	return kvm_seamcall(TDH_VP_WR, tdvpr, field, val, mask, 0, out);
+}
+#endif /* CONFIG_INTEL_TDX_HOST */
+
+#endif /* __KVM_X86_TDX_OPS_H */
-- 
2.25.1

