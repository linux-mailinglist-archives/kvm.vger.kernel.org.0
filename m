Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578A96383E1
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 07:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiKYGKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 01:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiKYGK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 01:10:27 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E612F22BCD;
        Thu, 24 Nov 2022 22:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669356613; x=1700892613;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZRezuqpS1DNAdKTjqyDv8lThqt77vwERhvQMC7EhTww=;
  b=PfhLpw6OxcCqKtAU/iISkmt6pRayg3b8VWuktnaaOYy5bHc4aJUev5lj
   DNeVpvN4lNRnt06l2eijMM9dRZoY07w+na2m13SxCrkY92zoJzhDszB9o
   L0LRTO83XfNrwDKT/+ytX103SxjIDz4S7/QbC2AhoXbByDBXxMWf7hKx9
   0KrFHKy5uReZGleu7o0sPVW3ApptntDblqGmCQ8dDuER67F24prd2O4Z8
   IgDYKajv/V2Kv1OxPo6rvkCsEUlBJqHQbGy23o5qpU7hh1ZT+4LNzI7/X
   /lv4K32hiOMve15SEHnmQPW+Ib+RpYmrLkAEdyFVeGZXDvpg0r8KN+E5Z
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313116836"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="313116836"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:09 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="784838509"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="784838509"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:08 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, weijiang.yang@intel.com
Subject: [PATCH v2 13/15] KVM: x86/vmx: Save/Restore guest Arch LBR Ctrl msr at SMM entry/exit
Date:   Thu, 24 Nov 2022 23:06:02 -0500
Message-Id: <20221125040604.5051-14-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221125040604.5051-1-weijiang.yang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per SDM 3B Chapter 18: "IA32_LBR_CTL.LBREn is saved and cleared on #SMI,
and restored on RSM", store guest IA32_LBR_CTL in SMRAM and clear LBREn
in VMCS at SMM entry, and do reverse things at SMM exit.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/smm.c     |  1 +
 arch/x86/kvm/smm.h     |  3 ++-
 arch/x86/kvm/vmx/vmx.c | 22 ++++++++++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index a9c1c2af8d94..5987090b440f 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -86,6 +86,7 @@ static void check_smram_offsets(void)
 	CHECK_SMRAM64_OFFSET(smm_revison,		0xFEFC);
 	CHECK_SMRAM64_OFFSET(smbase,			0xFF00);
 	CHECK_SMRAM64_OFFSET(reserved4,			0xFF04);
+	CHECK_SMRAM64_OFFSET(arch_lbr_ctl,		0xFF10);
 	CHECK_SMRAM64_OFFSET(ssp,			0xFF18);
 	CHECK_SMRAM64_OFFSET(svm_guest_pat,		0xFF20);
 	CHECK_SMRAM64_OFFSET(svm_host_efer,		0xFF28);
diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index a1cf2ac5bd78..5a6479205d91 100644
--- a/arch/x86/kvm/smm.h
+++ b/arch/x86/kvm/smm.h
@@ -114,7 +114,8 @@ struct kvm_smram_state_64 {
 	u32 reserved3[3];
 	u32 smm_revison;
 	u32 smbase;
-	u32 reserved4[5];
+	u32 reserved4[3];
+	u64 arch_lbr_ctl;
 
 	/* ssp and svm_* fields below are not implemented by KVM */
 	u64 ssp;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6ad765ea4059..cc782233c075 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8006,11 +8006,21 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 	vmx->nested.smm.vmxon = vmx->nested.vmxon;
 	vmx->nested.vmxon = false;
 	vmx_clear_hlt(vcpu);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
+		u64 ctl = vmcs_read64(GUEST_IA32_LBR_CTL);
+
+		smram->smram64.arch_lbr_ctl = ctl;
+		vmcs_write64(GUEST_IA32_LBR_CTL, ctl & ~ARCH_LBR_CTL_LBREN);
+	}
+
 	return 0;
 }
 
 static int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 {
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int ret;
 
@@ -8027,6 +8037,18 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 		vmx->nested.nested_run_pending = 1;
 		vmx->nested.smm.guest_mode = false;
 	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
+		u64 ctl = smram->smram64.arch_lbr_ctl;
+
+		vmcs_write64(GUEST_IA32_LBR_CTL, ctl & ARCH_LBR_CTL_LBREN);
+
+		if (intel_pmu_lbr_is_enabled(vcpu) &&
+		    (ctl & ARCH_LBR_CTL_LBREN) && !lbr_desc->event)
+			intel_pmu_create_guest_lbr_event(vcpu);
+	}
+
 	return 0;
 }
 
-- 
2.27.0

