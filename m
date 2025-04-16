Return-Path: <kvm+bounces-43381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD149A8ACAE
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 02:26:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA46217DEF0
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 00:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 665911BEF97;
	Wed, 16 Apr 2025 00:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b8FZZQoL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F14A1AAA1C
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 00:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744763165; cv=none; b=hmMIcORmESh0TDU7behPyz79RDTYYWF+RgYZlhGmWm09gn/NTD1E7OpgRxcqPWF8peCoEJPSC3BSA/5F8q0dUDhxNXbW2ZffDsVQphmpiN9a1yc/kVvwN1ZcoO3n7nqxuOB+6j0+fuQQE9D+eUwLXMDvjkRNAAI2lMj9CHhxlq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744763165; c=relaxed/simple;
	bh=70FAViXWmnbwDOtjzEpnpC0V91z88QvDpzhho4krcDo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lCRhk6kxj5POqAJ9xMGBqp+7crxco2iykBMNgFw3EUomfVl8CAXC74C0dA3MfwGDcsYXcBQxKag5yXSWQlIWjOQcgiWW8SzsjNgTMgf6nG3rbt9YP7SKJ5dyfaqTh5rVsrusNGHj8ACpBSunBBpDbjKN24kRCbpiGH/1ZMEa5PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b8FZZQoL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744763162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/EKClfzEXXt4fU+dk36Jj1WcBll4GrXAEqIzEqoykxA=;
	b=b8FZZQoLfAx0vgAVEYIJ2YKVq0NncaT8VrMp9M3DlR+jgEwGp8PlhTfM4utvSVbVgCL5jN
	nm7I2m/UWLx6WivqVlXM04Jkiimm1m5F6CXZXiRw/Nxj46Mzj2CL5XCBKuxq51dUCTcaRF
	uFRTo5Nx4tSewtLUUQSazz2T935resY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-359-h-YLvtZ8PVa9THiUafALMA-1; Tue,
 15 Apr 2025 20:25:54 -0400
X-MC-Unique: h-YLvtZ8PVa9THiUafALMA-1
X-Mimecast-MFC-AGG-ID: h-YLvtZ8PVa9THiUafALMA_1744763152
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 984111801A06;
	Wed, 16 Apr 2025 00:25:52 +0000 (UTC)
Received: from starship.lan (unknown [10.22.82.37])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7E3181828A99;
	Wed, 16 Apr 2025 00:25:50 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/3] x86: KVM: VMX: Wrap GUEST_IA32_DEBUGCTL read/write with access functions
Date: Tue, 15 Apr 2025 20:25:44 -0400
Message-Id: <20250416002546.3300893-2-mlevitsk@redhat.com>
In-Reply-To: <20250416002546.3300893-1-mlevitsk@redhat.com>
References: <20250416002546.3300893-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Instead of reading and writing GUEST_IA32_DEBUGCTL vmcs field directly,
wrap the logic with get/set functions.

Also move the checks that the guest's supplied value is valid to the new
'set' function.

In particular, the above change fixes a minor security issue in which L1
hypervisor could set the GUEST_IA32_DEBUGCTL, and eventually the host's
MSR_IA32_DEBUGCTL to any value by performing a VM entry to L2 with
VM_ENTRY_LOAD_DEBUG_CONTROLS set.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c    | 15 +++++++---
 arch/x86/kvm/vmx/pmu_intel.c |  9 +++---
 arch/x86/kvm/vmx/vmx.c       | 58 +++++++++++++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h       |  3 ++
 4 files changed, 57 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e073e3008b16..b7686569ee09 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2641,6 +2641,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 	bool load_guest_pdptrs_vmcs12 = false;
+	u64 new_debugctl;
 
 	if (vmx->nested.dirty_vmcs12 || nested_vmx_is_evmptr12_valid(vmx)) {
 		prepare_vmcs02_rare(vmx, vmcs12);
@@ -2653,11 +2654,17 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (vmx->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
 		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
-		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl);
+		new_debugctl = vmcs12->guest_ia32_debugctl;
 	} else {
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
-		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugctl);
+		new_debugctl = vmx->nested.pre_vmenter_debugctl;
 	}
+
+	if (CC(!vmx_set_guest_debugctl(vcpu, new_debugctl, false))) {
+		*entry_failure_code = ENTRY_FAIL_DEFAULT;
+		return -EINVAL;
+	}
+
 	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmcs_write64(GUEST_BNDCFGS, vmx->nested.pre_vmenter_bndcfgs);
@@ -3520,7 +3527,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 	if (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
-		vmx->nested.pre_vmenter_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		vmx->nested.pre_vmenter_debugctl = vmx_get_guest_debugctl(vcpu);
 	if (kvm_mpx_supported() &&
 	    (!vmx->nested.nested_run_pending ||
 	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
@@ -4788,7 +4795,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	__vmx_set_segment(vcpu, &seg, VCPU_SREG_LDTR);
 
 	kvm_set_dr(vcpu, 7, 0x400);
-	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
+	vmx_set_guest_debugctl(vcpu, 0, false);
 
 	if (nested_vmx_load_msr(vcpu, vmcs12->vm_exit_msr_load_addr,
 				vmcs12->vm_exit_msr_load_count))
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8a94b52c5731..f6f448adfb80 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -19,6 +19,7 @@
 #include "lapic.h"
 #include "nested.h"
 #include "pmu.h"
+#include "vmx.h"
 #include "tdx.h"
 
 /*
@@ -652,11 +653,11 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
  */
 static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
 {
-	u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+	u64 data = vmx_get_guest_debugctl(vcpu);
 
 	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
 		data &= ~DEBUGCTLMSR_LBR;
-		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		vmx_set_guest_debugctl(vcpu, data, true);
 	}
 }
 
@@ -729,7 +730,7 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 
 	if (!lbr_desc->event) {
 		vmx_disable_lbr_msrs_passthrough(vcpu);
-		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
+		if (vmx_get_guest_debugctl(vcpu) & DEBUGCTLMSR_LBR)
 			goto warn;
 		if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
 			goto warn;
@@ -751,7 +752,7 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 
 static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
-	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
+	if (!(vmx_get_guest_debugctl(vcpu) & DEBUGCTLMSR_LBR))
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ef2d7208dd20..4237422dc4ed 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2154,7 +2154,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
-		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		msr_info->data = vmx_get_guest_debugctl(vcpu);
 		break;
 	default:
 	find_uret_msr:
@@ -2194,6 +2194,41 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	return debugctl;
 }
 
+u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
+{
+	return vmcs_read64(GUEST_IA32_DEBUGCTL);
+}
+
+static void __vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data)
+{
+	vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+}
+
+bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated)
+{
+	u64 invalid = data & ~vmx_get_supported_debugctl(vcpu, host_initiated);
+
+	if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
+		kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
+		data &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
+		invalid &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
+	}
+
+	if (invalid)
+		return false;
+
+	if (is_guest_mode(vcpu) && (get_vmcs12(vcpu)->vm_exit_controls &
+					VM_EXIT_SAVE_DEBUG_CONTROLS))
+		get_vmcs12(vcpu)->guest_ia32_debugctl = data;
+
+	if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
+	    (data & DEBUGCTLMSR_LBR))
+		intel_pmu_create_guest_lbr_event(vcpu);
+
+	__vmx_set_guest_debugctl(vcpu, data);
+	return true;
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -2263,26 +2298,9 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
 	case MSR_IA32_DEBUGCTLMSR: {
-		u64 invalid;
-
-		invalid = data & ~vmx_get_supported_debugctl(vcpu, msr_info->host_initiated);
-		if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
-			kvm_pr_unimpl_wrmsr(vcpu, msr_index, data);
-			data &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
-			invalid &= ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
-		}
-
-		if (invalid)
+		if (!vmx_set_guest_debugctl(vcpu, data, msr_info->host_initiated))
 			return 1;
 
-		if (is_guest_mode(vcpu) && get_vmcs12(vcpu)->vm_exit_controls &
-						VM_EXIT_SAVE_DEBUG_CONTROLS)
-			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
-
-		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
-		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
-		    (data & DEBUGCTLMSR_LBR))
-			intel_pmu_create_guest_lbr_event(vcpu);
 		return 0;
 	}
 	case MSR_IA32_BNDCFGS:
@@ -4795,7 +4813,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	vmcs_write32(GUEST_SYSENTER_CS, 0);
 	vmcs_writel(GUEST_SYSENTER_ESP, 0);
 	vmcs_writel(GUEST_SYSENTER_EIP, 0);
-	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
+	__vmx_set_guest_debugctl(&vmx->vcpu, 0);
 
 	if (cpu_has_vmx_tpr_shadow()) {
 		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6d1e40ecc024..8ac46fb47abd 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -404,6 +404,9 @@ u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 
 gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 
+bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 value, bool host_initiated);
+u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu);
+
 static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 					     int type, bool value)
 {
-- 
2.26.3


