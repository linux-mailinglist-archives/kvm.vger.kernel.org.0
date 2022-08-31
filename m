Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84365A8AFB
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 03:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbiIABhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 21:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbiIABhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 21:37:12 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2649B15C37C;
        Wed, 31 Aug 2022 18:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661996231; x=1693532231;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pu6GAly0WQNL74xThNkU5xmsmi0AMcL08bsVVhe9hqE=;
  b=BjY8LYM34CwqB6xhqWkD+UkZsOsNDPlbA3RkwDWG0VpdHO0Trqbw8+OD
   URHcf0tEF6meAGgofUM65+miooMT9NdZYOsK/0IDvp+uWf8kgUwGd5q3x
   xBLScNNXfESysVHjcO9t0/N1h04uO5RUUjx+XGcOBUVyXG4iP6RcQkftw
   5MndQepAcdl0M1RNIgIFZxG2o7cZs+I6RkreWxHBmAqJJ+5Ta19tpa1t6
   u5UJzLe7aeYZ9KTkNJ4JtmzjHFT6oNdElcdGp4GUYqQzLouICETm0ILoV
   4uS7XBrCW4MieLoxB81h7jB1wB3lmPIRCiExvsSpP/0lzzMb4ACIuOgt0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321735104"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="321735104"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="754626044"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:03 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] KVM: x86/vmx: Flip Arch LBREn bit on guest state change
Date:   Wed, 31 Aug 2022 18:34:36 -0400
Message-Id: <20220831223438.413090-14-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220831223438.413090-1-weijiang.yang@intel.com>
References: <20220831223438.413090-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Message-Id: <20220517154100.29983-15-weijiang.yang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dddba2a48542..82b1bde382bb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4827,6 +4827,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (!init_event) {
 		if (cpu_has_vmx_arch_lbr())
 			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
+	} else {
+		disable_arch_lbr_ctl(vcpu);
 	}
 }
 
@@ -7967,6 +7969,8 @@ static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 
 static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 {
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	/*
@@ -7983,11 +7987,22 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
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
 
@@ -8004,6 +8019,17 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
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

