Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB5A14D3C7
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgA2Xqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:46:53 -0500
Received: from mga06.intel.com ([134.134.136.31]:46692 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbgA2Xqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551770"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 29 Jan 2020 15:46:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 26/26] KVM: VMX: Directly query Intel PT mode when refreshing PMUs
Date:   Wed, 29 Jan 2020 15:46:40 -0800
Message-Id: <20200129234640.8147-27-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vmx_pt_mode_is_host_guest() in intel_pmu_refresh() instead of
bouncing through kvm_x86_ops->pt_supported and remove ->pt_supported()
as the PMU code was the last remaining user.

Opportunistically clean up the wording of a comment that referenced
kvm_x86_ops->pt_supported().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/svm.c              | 6 ------
 arch/x86/kvm/vmx/pmu_intel.c    | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 6 ------
 arch/x86/kvm/x86.c              | 7 +++----
 5 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ea076debe6f8..3106abbf5ac2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1164,7 +1164,6 @@ struct kvm_x86_ops {
 		enum exit_fastpath_completion *exit_fastpath);
 
 	bool (*umip_emulated)(void);
-	bool (*pt_supported)(void);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a08ee7b2dddb..dd616cac6e67 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6108,11 +6108,6 @@ static bool svm_umip_emulated(void)
 	return false;
 }
 
-static bool svm_pt_supported(void)
-{
-	return false;
-}
-
 static bool svm_has_wbinvd_exit(void)
 {
 	return true;
@@ -7474,7 +7469,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpuid_update = svm_cpuid_update,
 
 	.umip_emulated = svm_umip_emulated,
-	.pt_supported = svm_pt_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 34a3a17bb6d7..d8f5cb312b9d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -330,7 +330,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
 			    MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD);
-	if (kvm_x86_ops->pt_supported())
+	if (vmx_pt_mode_is_host_guest())
 		pmu->global_ovf_ctrl_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 10c31aa40730..75842b574e26 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6318,11 +6318,6 @@ static bool vmx_has_emulated_msr(u32 index)
 	}
 }
 
-static bool vmx_pt_supported(void)
-{
-	return vmx_pt_mode_is_host_guest();
-}
-
 static void vmx_recover_nmi_blocking(struct vcpu_vmx *vmx)
 {
 	u32 exit_intr_info;
@@ -7914,7 +7909,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 	.umip_emulated = vmx_umip_emulated,
-	.pt_supported = vmx_pt_supported,
 
 	.request_immediate_exit = vmx_request_immediate_exit,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 03e656d05c15..e889e83dbb78 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2805,10 +2805,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
 			return 1;
 		/*
-		 * We do support PT if kvm_x86_ops->pt_supported(), but we do
-		 * not support IA32_XSS[bit 8]. Guests will have to use
-		 * RDMSR/WRMSR rather than XSAVES/XRSTORS to save/restore PT
-		 * MSRs.
+		 * KVM supports exposing PT to the guest, but does not support
+		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
+		 * XSAVES/XRSTORS to save/restore PT MSRs.
 		 */
 		if (data != 0)
 			return 1;
-- 
2.24.1

