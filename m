Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34E551C752
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383896AbiEESZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383122AbiEEST3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:29 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFF019027;
        Thu,  5 May 2022 11:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774548; x=1683310548;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dkyGueQFkeyCNCcuHQ4HyYP9QzPEHcqXig5YrBx0PVE=;
  b=VcMhGHnDmw2P4dkWynuWfO8b5LgjzqYBxdCpPebvDwN8TVVG5zhaz/0z
   WlcTiNcuYNPZs8D+TN9o9dOPtGtEVor+NECm+CHeTQvdZghTf1XvbltiN
   xiQpn7WcidGoL65YvXX3SE1m7KVaiFAqU0dFqioxDup6SRbZ7dNY13hJ4
   xMdVFVTn9Fw0wdRfemFmxl04dm0ufB0OTqTgtLUicnybyfT2Pi1tN98LS
   imvqcg42my5K/zsA2tnquHMzbh0vk+ZZpcRn10UGqhL6CMSdzHHQb2ofE
   AUesfyhcIHenv7WLr7WyLdBaeqHydFiQ2vDeg5tLixNpaiwM+6rViB66C
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328746249"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="328746249"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:42 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083194"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:42 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 020/104] KVM: TDX: Stub in tdx.h with structs, accessors, and VMCS helpers
Date:   Thu,  5 May 2022 11:14:14 -0700
Message-Id: <4b4e573dc15d50ce28645558b2610bf7a6effe5a.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Stub in kvm_tdx, vcpu_tdx, and their various accessors.  TDX defines
SEAMCALL APIs to access TDX control structures corresponding to the VMX
VMCS.  Introduce helper accessors to hide its SEAMCALL ABI details.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.h | 103 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 101 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 2f43db5bbefb..f50d37f3fc9c 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -3,16 +3,29 @@
 #define __KVM_X86_TDX_H
 
 #ifdef CONFIG_INTEL_TDX_HOST
+
+#include "tdx_ops.h"
+
 int tdx_module_setup(void);
 
+struct tdx_td_page {
+	unsigned long va;
+	hpa_t pa;
+	bool added;
+};
+
 struct kvm_tdx {
 	struct kvm kvm;
-	/* TDX specific members follow. */
+
+	struct tdx_td_page tdr;
+	struct tdx_td_page *tdcs;
 };
 
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
-	/* TDX specific members follow. */
+
+	struct tdx_td_page tdvpr;
+	struct tdx_td_page *tdvpx;
 };
 
 static inline bool is_td(struct kvm *kvm)
@@ -34,6 +47,92 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_tdx, vcpu);
 }
+
+static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
+{
+	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && (field) & 0x1,
+			 "Read/Write to TD VMCS *_HIGH fields not supported");
+
+	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
+
+	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
+			 (((field) & 0x6000) == 0x2000 ||
+			  ((field) & 0x6000) == 0x6000),
+			 "Invalid TD VMCS access for 64-bit field");
+	BUILD_BUG_ON_MSG(bits != 32 && __builtin_constant_p(field) &&
+			 ((field) & 0x6000) == 0x4000,
+			 "Invalid TD VMCS access for 32-bit field");
+	BUILD_BUG_ON_MSG(bits != 16 && __builtin_constant_p(field) &&
+			 ((field) & 0x6000) == 0x0000,
+			 "Invalid TD VMCS access for 16-bit field");
+}
+
+static __always_inline void tdvps_state_non_arch_check(u64 field, u8 bits) {}
+static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
+
+#define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
+static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
+							u32 field)		\
+{										\
+	struct tdx_module_output out;						\
+	u64 err;								\
+										\
+	tdvps_##lclass##_check(field, bits);					\
+	err = tdh_vp_rd(tdx->tdvpr.pa, TDVPS_##uclass(field), &out);		\
+	if (unlikely(err)) {							\
+		pr_err("TDH_VP_RD["#uclass".0x%x] failed: 0x%llx\n",		\
+		       field, err);						\
+		return 0;							\
+	}									\
+	return (u##bits)out.r8;							\
+}										\
+static __always_inline void td_##lclass##_write##bits(struct vcpu_tdx *tdx,	\
+						      u32 field, u##bits val)	\
+{										\
+	struct tdx_module_output out;						\
+	u64 err;								\
+										\
+	tdvps_##lclass##_check(field, bits);					\
+	err = tdh_vp_wr(tdx->tdvpr.pa, TDVPS_##uclass(field), val,		\
+		      GENMASK_ULL(bits - 1, 0), &out);				\
+	if (unlikely(err))							\
+		pr_err("TDH_VP_WR["#uclass".0x%x] = 0x%llx failed: 0x%llx\n",	\
+		       field, (u64)val, err);					\
+}										\
+static __always_inline void td_##lclass##_setbit##bits(struct vcpu_tdx *tdx,	\
+						       u32 field, u64 bit)	\
+{										\
+	struct tdx_module_output out;						\
+	u64 err;								\
+										\
+	tdvps_##lclass##_check(field, bits);					\
+	err = tdh_vp_wr(tdx->tdvpr.pa, TDVPS_##uclass(field), bit, bit,		\
+			&out);							\
+	if (unlikely(err))							\
+		pr_err("TDH_VP_WR["#uclass".0x%x] |= 0x%llx failed: 0x%llx\n",	\
+		       field, bit, err);					\
+}										\
+static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx,	\
+							 u32 field, u64 bit)	\
+{										\
+	struct tdx_module_output out;						\
+	u64 err;								\
+										\
+	tdvps_##lclass##_check(field, bits);					\
+	err = tdh_vp_wr(tdx->tdvpr.pa, TDVPS_##uclass(field), 0, bit,		\
+			&out);							\
+	if (unlikely(err))							\
+		pr_err("TDH_VP_WR["#uclass".0x%x] &= ~0x%llx failed: 0x%llx\n",	\
+		       field, bit,  err);					\
+}
+
+TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
+TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
+TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
+
+TDX_BUILD_TDVPS_ACCESSORS(64, STATE_NON_ARCH, state_non_arch);
+TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
+
 #else
 static inline int tdx_module_setup(void) { return -ENODEV; };
 
-- 
2.25.1

