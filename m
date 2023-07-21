Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C481B75BE78
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 08:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjGUGJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 02:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjGUGJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 02:09:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9CA2735;
        Thu, 20 Jul 2023 23:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689919742; x=1721455742;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fx9J88O7Q3yUbtft19sTQ/HsoEJxgMzNzpONUm7yFwM=;
  b=KN5va1MZJF3+624TteJkh7VLlZrrJ1MmAXHqwYZeUoS65WGJZN6PGOPQ
   qtXxTv+EzGHPKGgAS6omAK5qOI+BqJkCZ1EakmqMEB+k9wgrlP+v7OcFJ
   3CnW8x3jcFqHzuDPrq5RIibp1gwaLoWLx3wwHbZFGKl0z1gAftRDzMqgI
   XLnPi3UYmmNFYJNTGS0RDXJmiPU+uW5Lqo0R6W8eFlO7kuAzxzXrL+sDT
   tDiOi/jWfB9DJ4bk3pDR8EynKdd3/WrQ3LZJJZerZm2sxA8MXdTtNBZj2
   uV28oiKyLnKu3ylxin2W4Oa6K3cPbH65hNtGaaTOU756cPMfyJVX1nxet
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="370547630"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="370547630"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="848721978"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="848721978"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:41 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v4 13/20] KVM:VMX: Emulate read and write to CET MSRs
Date:   Thu, 20 Jul 2023 23:03:45 -0400
Message-Id: <20230721030352.72414-14-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230721030352.72414-1-weijiang.yang@intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add VMX specific emulation for CET MSR read and write.
IBT feature is only available on Intel platforms now and the
virtualization interface to the control fields is vensor
specific, so split this part from the common code.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 40 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     |  7 -------
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c8d9870cfecb..b29817ec6f2e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2093,6 +2093,21 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		return kvm_get_msr_common(vcpu, msr_info);
+	case MSR_IA32_S_CET:
+	case MSR_KVM_GUEST_SSP:
+	case MSR_IA32_INT_SSP_TAB:
+		if (kvm_get_msr_common(vcpu, msr_info))
+			return 1;
+		if (msr_info->index == MSR_KVM_GUEST_SSP)
+			msr_info->data = vmcs_readl(GUEST_SSP);
+		else if (msr_info->index == MSR_IA32_S_CET)
+			msr_info->data = vmcs_readl(GUEST_S_CET);
+		else if (msr_info->index == MSR_IA32_INT_SSP_TAB)
+			msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
@@ -2402,6 +2417,31 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+#define VMX_CET_CONTROL_MASK		(~GENMASK_ULL(9, 6))
+#define CET_LEG_BITMAP_BASE(data)	((data) >> 12)
+#define CET_EXCLUSIVE_BITS		(CET_SUPPRESS | CET_WAIT_ENDBR)
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		return kvm_set_msr_common(vcpu, msr_info);
+		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+	case MSR_KVM_GUEST_SSP:
+	case MSR_IA32_INT_SSP_TAB:
+		if ((msr_index == MSR_IA32_U_CET ||
+		     msr_index == MSR_IA32_S_CET) &&
+		    ((data & ~VMX_CET_CONTROL_MASK) ||
+		     !IS_ALIGNED(CET_LEG_BITMAP_BASE(data), 4) ||
+		     (data & CET_EXCLUSIVE_BITS) == CET_EXCLUSIVE_BITS))
+			return 1;
+		if (kvm_set_msr_common(vcpu, msr_info))
+			return 1;
+		if (msr_index == MSR_KVM_GUEST_SSP)
+			vmcs_writel(GUEST_SSP, data);
+		else if (msr_index == MSR_IA32_S_CET)
+			vmcs_writel(GUEST_S_CET, data);
+		else if (msr_index == MSR_IA32_INT_SSP_TAB)
+			vmcs_writel(GUEST_INTR_SSP_TABLE, data);
+		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
 			return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 70d7c80889d6..e200f22cdaad 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3642,13 +3642,6 @@ static inline bool is_shadow_stack_msr(struct kvm_vcpu *vcpu,
 static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
 				      struct msr_data *msr)
 {
-
-	/*
-	 * This function cannot work without later CET MSR read/write
-	 * emulation patch.
-	 */
-	WARN_ON_ONCE(1);
-
 	if (is_shadow_stack_msr(vcpu, msr)) {
 		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
 			return false;
-- 
2.27.0

