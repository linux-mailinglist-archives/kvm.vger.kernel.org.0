Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44BB45D195
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352855AbhKYAYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:21 -0500
Received: from mga18.intel.com ([134.134.136.126]:32610 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352718AbhKYAYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="222281271"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="222281271"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:02 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042093"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:01 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v3 06/59] KVM: TDX: Add C wrapper functions for TDX SEAMCALLs
Date:   Wed, 24 Nov 2021 16:19:49 -0800
Message-Id: <cf3704d32f204fd43de6c4c7708cb0ae5c1046f5.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX SEAMCALL interface is defined in the TDX module specification.  Define
C wrapper functions for SEAMCALLs which the later patches will use.

Co-developed-by: Kai Huang <kai.huang@linux.intel.com>
Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx_ops.h | 210 +++++++++++++++++++++++++++++++++++++
 1 file changed, 210 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_ops.h

diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
new file mode 100644
index 000000000000..87ed67fd2715
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -0,0 +1,210 @@
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
+#include "seamcall.h"
+
+#ifdef CONFIG_INTEL_TDX_HOST
+
+static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
+{
+	return seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
+			    struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, 0, ex);
+}
+
+static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
+			    struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, 0, ex);
+}
+
+static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
+{
+	return seamcall(TDH_VP_ADDCX, addr, tdvpr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
+			    struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, 0, ex);
+}
+
+static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
+			  struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0, 0, ex);
+}
+
+static inline u64 tdh_mng_key_config(hpa_t tdr)
+{
+	return seamcall(TDH_MNG_KEY_CONFIG, tdr, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
+{
+	return seamcall(TDH_MNG_CREATE, tdr, hkid, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
+{
+	return seamcall(TDH_VP_CREATE, tdvpr, tdr, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MNG_RD, tdr, field, 0, 0, 0, ex);
+}
+
+static inline u64 tdh_mng_wr(hpa_t tdr, u64 field, u64 val, u64 mask,
+			  struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MNG_WR, tdr, field, val, mask, 0, ex);
+}
+
+static inline u64 tdh_mem_rd(hpa_t addr, struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MEM_RD, addr, 0, 0, 0, 0, ex);
+}
+
+static inline u64 tdh_mem_wr(hpa_t addr, u64 val, struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MEM_WR, addr, val, 0, 0, 0, ex);
+}
+
+static inline u64 tdh_mem_page_demote(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
+			       struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MEM_PAGE_DEMOTE, gpa | level, tdr, page, 0, 0, ex);
+}
+
+static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa, struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MR_EXTEND, gpa, tdr, 0, 0, 0, ex);
+}
+
+static inline u64 tdh_mr_finalize(hpa_t tdr)
+{
+	return seamcall(TDH_MR_FINALIZE, tdr, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_vp_flush(hpa_t tdvpr)
+{
+	return seamcall(TDH_VP_FLUSH, tdvpr, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_vpflushdone(hpa_t tdr)
+{
+	return seamcall(TDH_MNG_VPFLUSHDONE, tdr, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_key_freeid(hpa_t tdr)
+{
+	return seamcall(TDH_MNG_KEY_FREEID, tdr, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mng_init(hpa_t tdr, hpa_t td_params, struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MNG_INIT, tdr, td_params, 0, 0, 0, ex);
+}
+
+static inline u64 tdh_vp_init(hpa_t tdvpr, u64 rcx)
+{
+	return seamcall(TDH_VP_INIT, tdvpr, rcx, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_page_promote(hpa_t tdr, gpa_t gpa, int level,
+				struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MEM_PAGE_PROMOTE, gpa | level, tdr, 0, 0, 0, ex);
+}
+
+static inline u64 tdh_phymem_page_rdmd(hpa_t page, struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_PHYMEM_PAGE_RDMD, page, 0, 0, 0, 0, ex);
+}
+
+static inline u64 tdh_mem_sept_rd(hpa_t tdr, gpa_t gpa, int level,
+			   struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MEM_SEPT_RD, gpa | level, tdr, 0, 0, 0, ex);
+}
+
+static inline u64 tdh_vp_rd(hpa_t tdvpr, u64 field, struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_VP_RD, tdvpr, field, 0, 0, 0, ex);
+}
+
+static inline u64 tdh_mng_key_reclaimid(hpa_t tdr)
+{
+	return seamcall(TDH_MNG_KEY_RECLAIMID, tdr, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_phymem_page_reclaim(hpa_t page, struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_PHYMEM_PAGE_RECLAIM, page, 0, 0, 0, 0, ex);
+}
+
+static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
+				struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, 0, ex);
+}
+
+static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
+			       struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MEM_SEPT_REMOVE, gpa | level, tdr, 0, 0, 0, ex);
+}
+
+static inline u64 tdh_sys_lp_shutdown(void)
+{
+	return seamcall(TDH_SYS_LP_SHUTDOWN, 0, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_track(hpa_t tdr)
+{
+	return seamcall(TDH_MEM_TRACK, tdr, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
+			    struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, 0, ex);
+}
+
+static inline u64 tdh_phymem_cache_wb(bool resume)
+{
+	return seamcall(TDH_PHYMEM_CACHE_WB, resume ? 1 : 0, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_phymem_page_wbinvd(hpa_t page)
+{
+	return seamcall(TDH_PHYMEM_PAGE_WBINVD, page, 0, 0, 0, 0, NULL);
+}
+
+static inline u64 tdh_mem_sept_wr(hpa_t tdr, gpa_t gpa, int level, u64 val,
+			   struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_MEM_SEPT_WR, gpa | level, tdr, val, 0, 0, ex);
+}
+
+static inline u64 tdh_vp_wr(hpa_t tdvpr, u64 field, u64 val, u64 mask,
+			  struct tdx_ex_ret *ex)
+{
+	return seamcall(TDH_VP_WR, tdvpr, field, val, mask, 0, ex);
+}
+#endif /* CONFIG_INTEL_TDX_HOST */
+
+#endif /* __KVM_X86_TDX_OPS_H */
-- 
2.25.1

