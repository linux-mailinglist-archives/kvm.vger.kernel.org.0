Return-Path: <kvm+bounces-55427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 82864B30968
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:41:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 836B5AA10A3
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC2F2FC009;
	Thu, 21 Aug 2025 22:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="YzqPBV/J"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8342EAB84;
	Thu, 21 Aug 2025 22:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815882; cv=none; b=AMsYuRXp2UOt6aEzgInbrmRN9aY1HxhrhAwVncqsjn8bcopHPPPF8dwVQxL+ks6uFl6GqYAddC+tDIWVAmWG7FPtOzuj4eiWjjEX4KicoBTCB8ymQVJEY5jWPzSPqL1XubMqLyNxy6qa1nrvkOYIOPUbEPMlEPIkFqM+uGSla/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815882; c=relaxed/simple;
	bh=9yKARAhHQ299oarF8Q6B4prpM5j9324F4HLiKPSgY04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4ag9tCep7p2CZoSFZ77J4jE0TL2RL9/Y8TmIRmaYjRQVhHgHKbXoNtMNC2PNRhmH7kvG/G1fzOypiThTJvJm4qQM73IttLCA4VEjO57dVAwLxY0q3zNLDt13ZqCSuj6MR2JxA98kmrnIEBlGVQ6ID3rRLHS6kXC+e7RFOcD4BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=YzqPBV/J; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57LMaUOe984441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 21 Aug 2025 15:36:56 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57LMaUOe984441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755815817;
	bh=jI3Q7dsqV96opnqgoGqxaK2KfL1jlGscPr2zgHW1VEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzqPBV/JOV5YOA++cBimIXA7p3zG+avfz2sSGYKyWkX5xP+IFqL0Q7wSp8cHyv7RS
	 I7ULT4SIUb/NEM8/BpQCuXHI8A51xI0Aiay7dtrH9PvyabFJ/IhgLBPzcXTAvv5Q9Y
	 t84h7ZXNy5TcWxInKHddLCZuJE4gdxYx1voiJ3cHIJBSuuckBh8nxQxLnqLe9OMQ6G
	 QJ6EmhIbCcWmXd5vbiYa0APGInxV/i4lpu/DGo3ICNvs7m3pS9H4WjjQQLWnFVHfZB
	 vPbhF1ssiA/VpuWEmwvTd9Da/brNETsdz3qsdJZ44tJLQ8yF7cQgfrb61kPUFtnS8i
	 kJ5wCQVuWt0NA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v6 16/20] KVM: nVMX: Add support for the secondary VM exit controls
Date: Thu, 21 Aug 2025 15:36:25 -0700
Message-ID: <20250821223630.984383-17-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821223630.984383-1-xin@zytor.com>
References: <20250821223630.984383-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Enable the secondary VM exit controls to prepare for nested FRED.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Changes in v5:
* Allow writing MSR_IA32_VMX_EXIT_CTLS2 (Sean).
* Add TB from Xuelian Guo.

Change in v3:
* Read secondary VM exit controls from vmcs_conf insteasd of the hardware
  MSR MSR_IA32_VMX_EXIT_CTLS2 to avoid advertising features to L1 that KVM
  itself doesn't support, e.g. because the expected entry+exit pairs aren't
  supported. (Sean Christopherson)
---
 Documentation/virt/kvm/x86/nested-vmx.rst |  1 +
 arch/x86/kvm/vmx/capabilities.h           |  1 +
 arch/x86/kvm/vmx/nested.c                 | 26 ++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmcs12.c                 |  1 +
 arch/x86/kvm/vmx/vmcs12.h                 |  2 ++
 arch/x86/kvm/x86.h                        |  2 +-
 6 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/x86/nested-vmx.rst b/Documentation/virt/kvm/x86/nested-vmx.rst
index ac2095d41f02..e64ef231f310 100644
--- a/Documentation/virt/kvm/x86/nested-vmx.rst
+++ b/Documentation/virt/kvm/x86/nested-vmx.rst
@@ -217,6 +217,7 @@ struct shadow_vmcs is ever changed.
 		u16 host_fs_selector;
 		u16 host_gs_selector;
 		u16 host_tr_selector;
+		u64 secondary_vm_exit_controls;
 	};
 
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 7fe95a601c9f..c9f00b6594d9 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -37,6 +37,7 @@ struct nested_vmx_msrs {
 	u32 pinbased_ctls_high;
 	u32 exit_ctls_low;
 	u32 exit_ctls_high;
+	u64 secondary_exit_ctls;
 	u32 entry_ctls_low;
 	u32 entry_ctls_high;
 	u32 misc_low;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d7e2fb30fc1a..e4de8372b9f9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1531,6 +1531,11 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 			return -EINVAL;
 		vmx->nested.msrs.vmfunc_controls = data;
 		return 0;
+	case MSR_IA32_VMX_EXIT_CTLS2:
+		if (data & ~vmcs_config.nested.secondary_exit_ctls)
+			return -EINVAL;
+		vmx->nested.msrs.secondary_exit_ctls = data;
+		return 0;
 	default:
 		/*
 		 * The rest of the VMX capability MSRs do not support restore.
@@ -1570,6 +1575,9 @@ int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata)
 		if (msr_index == MSR_IA32_VMX_EXIT_CTLS)
 			*pdata |= VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
 		break;
+	case MSR_IA32_VMX_EXIT_CTLS2:
+		*pdata = msrs->secondary_exit_ctls;
+		break;
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
 	case MSR_IA32_VMX_ENTRY_CTLS:
 		*pdata = vmx_control_msr(
@@ -2520,6 +2528,11 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 		exec_control &= ~VM_EXIT_LOAD_IA32_EFER;
 	vm_exit_controls_set(vmx, exec_control);
 
+	if (exec_control & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS) {
+		exec_control = __secondary_vm_exit_controls_get(vmcs01);
+		secondary_vm_exit_controls_set(vmx, exec_control);
+	}
+
 	/*
 	 * Interrupt/Exception Fields
 	 */
@@ -7176,7 +7189,8 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE |
+		VM_EXIT_ACTIVATE_SECONDARY_CONTROLS;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -7185,6 +7199,16 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 
 	/* We support free control of debug control saving. */
 	msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
+
+	if (msrs->exit_ctls_high & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS) {
+		msrs->secondary_exit_ctls = vmcs_conf->vmexit_2nd_ctrl;
+		/*
+		 * As the secondary VM exit control is always loaded, do not
+		 * advertise any feature in it to nVMX until its nVMX support
+		 * is ready.
+		 */
+		msrs->secondary_exit_ctls &= 0;
+	}
 }
 
 static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 4233b5ca9461..3b01175f392a 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -66,6 +66,7 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD64(HOST_IA32_PAT, host_ia32_pat),
 	FIELD64(HOST_IA32_EFER, host_ia32_efer),
 	FIELD64(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl),
+	FIELD64(SECONDARY_VM_EXIT_CONTROLS, secondary_vm_exit_controls),
 	FIELD(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control),
 	FIELD(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control),
 	FIELD(EXCEPTION_BITMAP, exception_bitmap),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 4ad6b16525b9..7866fdce7a23 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -191,6 +191,7 @@ struct __packed vmcs12 {
 	u16 host_gs_selector;
 	u16 host_tr_selector;
 	u16 guest_pml_index;
+	u64 secondary_vm_exit_controls;
 };
 
 /*
@@ -372,6 +373,7 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_gs_selector, 992);
 	CHECK_OFFSET(host_tr_selector, 994);
 	CHECK_OFFSET(guest_pml_index, 996);
+	CHECK_OFFSET(secondary_vm_exit_controls, 998);
 }
 
 extern const unsigned short vmcs12_field_offsets[];
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c9f010862b2a..88a4eaafc81b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -95,7 +95,7 @@ do {											\
  * associated feature that KVM supports for nested virtualization.
  */
 #define KVM_FIRST_EMULATED_VMX_MSR	MSR_IA32_VMX_BASIC
-#define KVM_LAST_EMULATED_VMX_MSR	MSR_IA32_VMX_VMFUNC
+#define KVM_LAST_EMULATED_VMX_MSR	MSR_IA32_VMX_EXIT_CTLS2
 
 #define KVM_DEFAULT_PLE_GAP		128
 #define KVM_VMX_DEFAULT_PLE_WINDOW	4096
-- 
2.50.1


