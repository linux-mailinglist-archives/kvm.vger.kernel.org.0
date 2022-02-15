Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEFFE4B8597
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 11:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiBPK10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 05:27:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbiBPK1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 05:27:12 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0CA206995;
        Wed, 16 Feb 2022 02:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645007216; x=1676543216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XvK9OBulcgtqEG62zAIsUOIB2UsfSg157Qgvz0h9v6Y=;
  b=K8ZFDT3ksTKR42wSIUJSiYb5H/Y0lce2A+xL65Y59Fu0gN9n9H8H+wky
   UP+p5QQg4T+FZclo1WR8rHh6X4kuiJYO9e1CjBoI03a4w/DJuU4E3hO6H
   VR4CULjLKSV9aUhgtz51POw2UYdzjoNBGwpg178Yq5y5k+XpvkkMcBYY7
   4COLxwqdrY5ZgYJQpzUS8dwpsl9xd3pB9iceuQVuNVKN0dENq9sIgO0JT
   hPLlBO3J35T3s+65x5dnaszJZKrhqlufp3w0S2dydx1dK5YsEImXMaxNL
   3OxCc8ksVI5rS2VNG1SAv+0SergyeUylOjKHY5RHrWHlxiVkvmVxHhHK5
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="250312482"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="250312482"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="498708644"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:51 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v9 16/17] KVM: x86: Add Arch LBR MSR access interface
Date:   Tue, 15 Feb 2022 16:25:43 -0500
Message-Id: <20220215212544.51666-17-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220215212544.51666-1-weijiang.yang@intel.com>
References: <20220215212544.51666-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When userspace wants to access guest Arch LBR data MSRs, these
MSRs actually reside in guest FPU area, so need to load them to
HW before RDMSR and save them back into FPU area after WRMSR.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++++++
 arch/x86/kvm/x86.c           |  9 ++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e2cae30614b1..976789245917 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -431,6 +431,11 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_ARCH_LBR_CTL:
 		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
 		return 0;
+	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
+	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
+	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
+		kvm_get_xsave_msr(msr_info);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -511,6 +516,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    (data & ARCH_LBR_CTL_LBREN))
 			intel_pmu_create_guest_lbr_event(vcpu);
 		return 0;
+	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
+	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
+	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
+		kvm_set_xsave_msr(msr_info);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 64de3ed2cd74..de6fc8d4b500 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4105,7 +4105,14 @@ EXPORT_SYMBOL_GPL(kvm_set_xsave_msr);
  */
 static bool is_xsaves_msr(u32 index)
 {
-	return false;
+	bool xsaves_msr = (index >= MSR_ARCH_LBR_FROM_0 &&
+			   index <= MSR_ARCH_LBR_FROM_0 + 31) ||
+			  (index >= MSR_ARCH_LBR_TO_0 &&
+			   index <= MSR_ARCH_LBR_TO_0 + 31) ||
+			  (index >= MSR_ARCH_LBR_INFO_0 &&
+			   index <= MSR_ARCH_LBR_INFO_0 + 31);
+
+	return xsaves_msr;
 }
 
 /*
-- 
2.27.0

