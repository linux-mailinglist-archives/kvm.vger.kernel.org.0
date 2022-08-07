Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C8D58BD58
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbiHGWDR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiHGWCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:02:36 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F766559;
        Sun,  7 Aug 2022 15:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909755; x=1691445755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dkyGueQFkeyCNCcuHQ4HyYP9QzPEHcqXig5YrBx0PVE=;
  b=O6bdZ2+6ovfMB8va9G90b/7gkOCq8J379fGVPdHtyQw5czKd+4yqp6Za
   WvYmlVWpY7smyhYBS/sp3lKZof3cQTZ/UIXx5WjyU33npsp5ORk94HKam
   KqHJNV6dg8hWzn2Wcw88HU5B3EtPICZj+yshqZhqQZuhS+pZCcVedrx7S
   oNKh8wAKqsuoDs4oHCEEDKY8eZnNq+SYwjSTdYDU9Gq8VRDI3KTJVA3SK
   netfj2jTj/HSIyehEVnnhAai9PKQNKdT4SrHbBtdXQU0SLeTOoXIFjZ/T
   VNjNVcOAgF/JM0wq/EHqQQygTkGP9lYLNz7zYLf5Sr+mdb846EGHAdCQC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224079"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224079"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:31 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682493"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:31 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 018/103] KVM: TDX: Stub in tdx.h with structs, accessors, and VMCS helpers
Date:   Sun,  7 Aug 2022 15:01:03 -0700
Message-Id: <d88e0cee35b70d86493d5a71becffa4ab5c5d97c.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

