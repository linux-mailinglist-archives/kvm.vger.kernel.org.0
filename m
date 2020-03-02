Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07EA21768E0
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgCCAAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:00:32 -0500
Received: from mga03.intel.com ([134.134.136.65]:17168 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727411AbgCBX51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384796"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 57/66] KVM: VMX: Directly query Intel PT mode when refreshing PMUs
Date:   Mon,  2 Mar 2020 15:57:00 -0800
Message-Id: <20200302235709.27467-58-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 --
 arch/x86/kvm/svm.c              | 7 -------
 arch/x86/kvm/vmx/pmu_intel.c    | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 6 ------
 arch/x86/kvm/x86.c              | 7 +++----
 5 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 25d9a0d45cc6..4fbff24aed8a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1168,8 +1168,6 @@ struct kvm_x86_ops {
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion *exit_fastpath);
 
-	bool (*pt_supported)(void);
-
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 692b8ffdbad3..9dc614cfd129 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6070,11 +6070,6 @@ static int svm_get_lpage_level(void)
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
@@ -7434,8 +7429,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.cpuid_update = svm_cpuid_update,
 
-	.pt_supported = svm_pt_supported,
-
 	.set_supported_cpuid = svm_set_supported_cpuid,
 
 	.has_wbinvd_exit = svm_has_wbinvd_exit,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e933541751fb..7c857737b438 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -335,7 +335,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
 			    MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD);
-	if (kvm_x86_ops->pt_supported())
+	if (vmx_pt_mode_is_host_guest())
 		pmu->global_ovf_ctrl_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bb54974f950f..836f8a8d83df 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6302,11 +6302,6 @@ static bool vmx_has_emulated_msr(int index)
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
@@ -7941,7 +7936,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
-	.pt_supported = vmx_pt_supported,
 
 	.request_immediate_exit = vmx_request_immediate_exit,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b8764255455..4fdf5b04f148 100644
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

