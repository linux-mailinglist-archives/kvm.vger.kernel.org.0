Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA04450B258
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 09:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445313AbiDVH7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 03:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445240AbiDVH6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 03:58:30 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A831D35A92;
        Fri, 22 Apr 2022 00:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650614138; x=1682150138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fAwEQsR2Y9I/y2lDBdp9QP33v99ZkHOcVmjy9v5r4JI=;
  b=FNhRR/+HRt+SYBxaTmJuxQzt5qmcnHzA7j+c1/dmRJt4Zh72oRxk0+Fi
   Ky6AEtQT/GwX53LcKp+u10uPmacKJc9KzmhvWRDjk/Px/EfEBF4Fu/yft
   o6nq0KjYskpWMH3FAORYo89nCNO4mFzexXeKtbeOYfIqzhvliZZpQDt9C
   74u246l2dnbaHAVjSF8fGsPXdBTe7obontBRtV4EQhtIYx/uEIFiZFTFF
   uDGFYc1hHrRGe7G2AC6/5zlOGp3gVrE7jBWa/kXHbP54yudCFWP1+zm9Z
   g3HXn7BGNtFINKFT8SM3csHRb/gqgR/SVmSJmE2tpDLRo9/nMkis4R8/N
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264384838"
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="264384838"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:55:30 -0700
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="577741371"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:55:30 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v10 15/16] KVM: x86: Add Arch LBR data MSR access interface
Date:   Fri, 22 Apr 2022 03:55:08 -0400
Message-Id: <20220422075509.353942-16-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220422075509.353942-1-weijiang.yang@intel.com>
References: <20220422075509.353942-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Arch LBR MSRs are xsave-supported, but they're operated as "independent"
xsave feature by PMU code, i.e., during thread/process context switch,
the MSRs are saved/restored with PMU specific code instead of generic
kernel fpu XSAVES/XRSTORS operation. When vcpu guest/host fpu state swap
happens, Arch LBR MSRs won't be touched so access them directly.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 79eecbffa07b..5f81644c4612 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -431,6 +431,11 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_ARCH_LBR_CTL:
 		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
 		return 0;
+	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
+	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
+	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
+		rdmsrl(msr_info->index, msr_info->data);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -512,6 +517,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    (data & ARCH_LBR_CTL_LBREN))
 			intel_pmu_create_guest_lbr_event(vcpu);
 		return 0;
+	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
+	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
+	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
+		wrmsrl(msr_info->index, msr_info->data);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
-- 
2.27.0

