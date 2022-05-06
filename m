Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B3051CFA8
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 05:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388798AbiEFDhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 23:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388674AbiEFDhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 23:37:17 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DC06471B;
        Thu,  5 May 2022 20:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651808016; x=1683344016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J4Wo4KbtIWkpvNlI+mhsKKA/WAYB5Q4djruxL2vzwSM=;
  b=MgrAZBqBmOYjWWGolny/fif6rIj6l65mKNcwVeP0x3lMW2GwEa8UZ2An
   RqUOnvKnJX/1sQ5mMwai0W7WI7oCOoRXyWsPmD7YICXVlW+fC7RHeA5V1
   fVzxWagl7MaK14M+hdR3/DHBUKb5s3rZgtHnsZUP1AxRtkwaaybmVCvws
   rnJtvn/usJdUOAAkdpbYurMGYhrgmofJToUhuLwQmf61OiIm7d+atVU8u
   CDGNgZnJhilXvQoGZ5hMLf4R8MnckP0uXqgK9Jy+fl2KfJtL0Buvax1nu
   Us1BlVRPmKqYfsrC4aZqpOPn1Qi64Tc/7dacKY3zWRWNUTz7+35Zslhki
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248241447"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248241447"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:36 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="632745212"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:36 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kan.liang@linux.intel.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 15/16] KVM: x86: Add Arch LBR data MSR access interface
Date:   Thu,  5 May 2022 23:33:04 -0400
Message-Id: <20220506033305.5135-16-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220506033305.5135-1-weijiang.yang@intel.com>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Arch LBR MSRs are xsave-supported, but they're operated as "independent"
xsave feature by PMU code, i.e., during thread/process context switch,
the MSRs are saved/restored with perf_event_task_sched_{in|out} instead
of generic kernel fpu switch code, i.e.,save_fpregs_to_fpstate() and
restore_fpregs_from_fpstate(). When vcpu guest/host fpu state swap happens,
Arch LBR MSRs are retained so they can be accessed directly.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3adc8f28d142..c2eab6272b35 100644
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

