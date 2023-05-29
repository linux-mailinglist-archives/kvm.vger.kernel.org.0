Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555697142F0
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbjE2E0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbjE2EZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:25:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6565E41;
        Sun, 28 May 2023 21:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334215; x=1716870215;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kcN0sh5u0GjherE8wd3XD0GFtCM4wz9n5VCD6qLEbec=;
  b=I4xKYUFua9/+ythFyPRjzddc9vKWTVOmBMFQ2/alBff8ghU61yuBEgMz
   rw9X06/MtoM3bEDDOcA1+zoHa9TGlebEJ2vawy7Ccl212Ia19resgrhUM
   3DFH7skQ4KmRf9WwWanUv3qBP9r/w7yULoyO/I50sH7u6gBbmLB/wLhBj
   IMrJzo6yqOzupaBz+CEsPri5NUOSAnSxQqlplucXbZvJnHARkMPkWZErR
   2wakbIgl46AJUP6Cwz2Z8ZWo2fEkTDiOnyg9CCTjMwvF02BVFgUp27G2Z
   hLR0JIqZT8VDS4cvCipKY0yEKi7inTjrxOOGsMm68ZFjyPlmFN7Y1uHkD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334966025"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334966025"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784338"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784338"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:17 -0700
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
Subject: [PATCH v14 051/113] KVM: TDX: Add accessors VMX VMCS helpers
Date:   Sun, 28 May 2023 21:19:33 -0700
Message-Id: <a742a2215092c862951dab963bc773b63589745a.1685333728.git.isaku.yamahata@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX defines SEAMCALL APIs to access TDX control structures corresponding to
the VMX VMCS.  Introduce helper accessors to hide its SEAMCALL ABI details.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.h | 95 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 5fa4d3198873..7c8f5880d104 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -57,6 +57,101 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_tdx, vcpu);
 }
 
+static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
+{
+#define VMCS_ENC_ACCESS_TYPE_MASK	0x1UL
+#define VMCS_ENC_ACCESS_TYPE_FULL	0x0UL
+#define VMCS_ENC_ACCESS_TYPE_HIGH	0x1UL
+#define VMCS_ENC_ACCESS_TYPE(field)	((field) & VMCS_ENC_ACCESS_TYPE_MASK)
+
+	/* TDX is 64bit only.  HIGH field isn't supported. */
+	BUILD_BUG_ON_MSG(__builtin_constant_p(field) &&
+			 VMCS_ENC_ACCESS_TYPE(field) == VMCS_ENC_ACCESS_TYPE_HIGH,
+			 "Read/Write to TD VMCS *_HIGH fields not supported");
+
+	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
+
+#define VMCS_ENC_WIDTH_MASK	GENMASK(14, 13)
+#define VMCS_ENC_WIDTH_16BIT	(0UL << 13)
+#define VMCS_ENC_WIDTH_64BIT	(1UL << 13)
+#define VMCS_ENC_WIDTH_32BIT	(2UL << 13)
+#define VMCS_ENC_WIDTH_NATURAL	(3UL << 13)
+#define VMCS_ENC_WIDTH(field)	((field) & VMCS_ENC_WIDTH_MASK)
+
+	/* TDX is 64bit only.  i.e. natural width = 64bit. */
+	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
+			 (VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_64BIT ||
+			  VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_NATURAL),
+			 "Invalid TD VMCS access for 64-bit field");
+	BUILD_BUG_ON_MSG(bits != 32 && __builtin_constant_p(field) &&
+			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_32BIT,
+			 "Invalid TD VMCS access for 32-bit field");
+	BUILD_BUG_ON_MSG(bits != 16 && __builtin_constant_p(field) &&
+			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_16BIT,
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
+	err = tdh_vp_rd(tdx->tdvpr_pa, TDVPS_##uclass(field), &out);		\
+	if (KVM_BUG_ON(err, tdx->vcpu.kvm)) {					\
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
+	err = tdh_vp_wr(tdx->tdvpr_pa, TDVPS_##uclass(field), val,		\
+		      GENMASK_ULL(bits - 1, 0), &out);				\
+	if (KVM_BUG_ON(err, tdx->vcpu.kvm))					\
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
+	err = tdh_vp_wr(tdx->tdvpr_pa, TDVPS_##uclass(field), bit, bit, &out);	\
+	if (KVM_BUG_ON(err, tdx->vcpu.kvm))					\
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
+	err = tdh_vp_wr(tdx->tdvpr_pa, TDVPS_##uclass(field), 0, bit, &out);	\
+	if (KVM_BUG_ON(err, tdx->vcpu.kvm))					\
+		pr_err("TDH_VP_WR["#uclass".0x%x] &= ~0x%llx failed: 0x%llx\n",	\
+		       field, bit,  err);					\
+}
+
+TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
+TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
+TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
+
 static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
 {
 	struct tdx_module_output out;
-- 
2.25.1

