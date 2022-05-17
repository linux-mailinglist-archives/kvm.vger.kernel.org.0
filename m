Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1B452A72E
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350451AbiEQPmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350537AbiEQPll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:41:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E20541312;
        Tue, 17 May 2022 08:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652802100; x=1684338100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=STQFum0/F5thK1+ZnYkq73Joe3larBz4vqtOK4/IDZk=;
  b=nbQKXlqstyZCw+wIilutWOUIa0VNdmGmK/HYgGuzE4BxEY+v4M6NS20e
   Igk3pu5tK7P/CRg7EaK+vi0vFy4ORbXulsQv8bB8MrS5yjT3jeSVpY7Ua
   WvsPr7DMVJcAWbW7M7+4Age3TUjFj+VY3Vcan8UcE6YBIr4QsgTJTPRWK
   e5MBPS+mOyXcc5BtyPY0Cc0ZsRniObCnt9nJK2/Q4yuoeWsVzdqpMtIws
   TFXgkYgAuc2DI2H23VJGnK3iBkEhiDsEfRsg3f5ES8sFE1LG6OTOUla02
   aTwMs5qpuVURPXswaXujUjxZWNflQ5jBA/FfOtO4Ut91clqvnNCs2nf3+
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="357632116"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357632116"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:36 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="626533607"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:35 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 14/16] KVM: x86/vmx: Flip Arch LBREn bit on guest state change
Date:   Tue, 17 May 2022 11:40:58 -0400
Message-Id: <20220517154100.29983-15-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220517154100.29983-1-weijiang.yang@intel.com>
References: <20220517154100.29983-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per spec:"IA32_LBR_CTL.LBREn is saved and cleared on #SMI, and restored
on RSM. On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have their
values preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling
LBRs." At guest SMM entry, store guest IA32_LBR_CTL in SMRAM and clear LBREn
in VMCS, do reverse things at SMM exit. Also clear LBREn at warm reset.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7dfa961d6829..9b2f84998b45 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4674,6 +4674,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (!init_event) {
 		if (static_cpu_has(X86_FEATURE_ARCH_LBR))
 			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
+	} else {
+		disable_arch_lbr_ctl(vcpu);
 	}
 }
 
@@ -7796,6 +7798,8 @@ static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 
 static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 {
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	vmx->nested.smm.guest_mode = is_guest_mode(vcpu);
@@ -7805,11 +7809,22 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	vmx->nested.smm.vmxon = vmx->nested.vmxon;
 	vmx->nested.vmxon = false;
 	vmx_clear_hlt(vcpu);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+	    test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use) &&
+	    lbr_desc->event && guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
+		u64 ctl = vmcs_read64(GUEST_IA32_LBR_CTL);
+
+		put_smstate(u64, smstate, 0x7f10, ctl);
+		vmcs_write64(GUEST_IA32_LBR_CTL, ctl & ~ARCH_LBR_CTL_LBREN);
+	}
+
 	return 0;
 }
 
 static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 {
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int ret;
 
@@ -7826,6 +7841,17 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 		vmx->nested.nested_run_pending = 1;
 		vmx->nested.smm.guest_mode = false;
 	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
+		u64 ctl = GET_SMSTATE(u64, smstate, 0x7f10);
+
+		vmcs_write64(GUEST_IA32_LBR_CTL, ctl | ARCH_LBR_CTL_LBREN);
+
+		if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event)
+			intel_pmu_create_guest_lbr_event(vcpu);
+	}
+
 	return 0;
 }
 
-- 
2.27.0

