Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 852EC14F9AD
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbgBASx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:53:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:11294 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbgBASwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075595"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 55/61] KVM: VMX: Directly query Intel PT mode when refreshing PMUs
Date:   Sat,  1 Feb 2020 10:52:12 -0800
Message-Id: <20200201185218.24473-56-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vmx_pt_mode_is_host_guest() in intel_pmu_refresh() instead of
bouncing through kvm_x86_ops->pt_supported, and remove ->pt_supported()
as the PMU code was the last remaining user.

Opportunistically clean up the wording of a comment that referenced
kvm_x86_ops->pt_supported().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 --
 arch/x86/kvm/svm.c              | 7 -------
 arch/x86/kvm/vmx/pmu_intel.c    | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 6 ------
 arch/x86/kvm/x86.c              | 7 +++----
 5 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1dd5ac8a2136..a8bae9d88bce 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1162,8 +1162,6 @@ struct kvm_x86_ops {
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion *exit_fastpath);
 
-	bool (*pt_supported)(void);
-
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6dd9c810c0dc..a27f83f7521c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6074,11 +6074,6 @@ static int svm_get_lpage_level(void)
 	return PT_PDPE_LEVEL;
 }
 
-static bool svm_pt_supported(void)
-{
-	return false;
-}
-
 static bool svm_has_wbinvd_exit(void)
 {
 	return true;
@@ -7438,8 +7433,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.cpuid_update = svm_cpuid_update,
 
-	.pt_supported = svm_pt_supported,
-
 	.set_supported_cpuid = svm_set_supported_cpuid,
 
 	.has_wbinvd_exit = svm_has_wbinvd_exit,
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
index 98d54cfa0cbe..e6284b6aac56 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6283,11 +6283,6 @@ static bool vmx_has_emulated_msr(int index)
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
@@ -7876,7 +7871,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
-	.pt_supported = vmx_pt_supported,
 
 	.request_immediate_exit = vmx_request_immediate_exit,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9d38dcdbb613..144143a57d0b 100644
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

