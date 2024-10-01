Return-Path: <kvm+bounces-27725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BD2A98B356
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25FF71C230BD
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E8E1BDAA4;
	Tue,  1 Oct 2024 05:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="T7a5ePra"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883B919309C;
	Tue,  1 Oct 2024 05:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758938; cv=none; b=t2XOrTS+kVhzDKlH48AFrmwqPTvHWC4pBTch0oRlSVcmopRgD5dEzdsYSJjFq21bi7UMLQuE7bmBeybrojs+gqRN2NDctVlWiCopYjsed3YXTFDDYZlsppTiWQ99jFYrkRo9V5ik+Fbc9n8ZcDpW6wMRdGh9oPpJD9+zr1XMySw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758938; c=relaxed/simple;
	bh=zvaRZRA/DRQ9xLaRnwsO3ZrZNl5ciooyMbPHWdHOw+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJXIlkWfRp+7vlNWgIrfWKof2UvozaWEpgS/Ytd20jqb1lk2VFGmiLRkyZwjt5HyTNksTWbTTlq/FOnaFQ4+sTbAkyxeRVaXZ7CAB/n5+rY6NMOGIrj2UZGCbB6+yxvdTFVLmKs6nBsr7FD/BzWJ85r2neheFetFAc1YsGX+04s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=T7a5ePra; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7l3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:37 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7l3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758898;
	bh=qzvu60W6NQb8KVFLqmCzK1DwmY79Zr7QZJjLnO14se4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7a5ePra+mmb6gkvbwl7glmEfla6+iaA7uQO/qBeQyJZR3vhUEDttPOhIPpU6Pbwp
	 VMWr1oGGxmwetHhwiv7gsOxdXHqgOwY2uQjQye87+HeKtGVkC+TJ5h4eOUl3cXgj9a
	 zzQCSb1fF2WnVbYP2dEBSFKgxMQ6AGFIscUTXvOyD9FANWsesYlzLrdxpGvAU8a8/5
	 t2t5yPjIOQbNLxFhWx5gHT6zKHSKSUuZ0TZf2+tY9pF1Yt7OHaTIo7MpbaQr/6VpKm
	 EKls8puQ+vuebIZfXThASRGflPRiy3vnW32o0F6dP1Al+dotE4ZLfs8sfNsrVURIVX
	 llU+ULS2lTKHA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 22/27] KVM: nVMX: Add support for the secondary VM exit controls
Date: Mon, 30 Sep 2024 22:01:05 -0700
Message-ID: <20241001050110.3643764-23-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
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
---

Change since v2:
* Read secondary VM exit controls from vmcs_conf insteasd of the hardware
  MSR MSR_IA32_VMX_EXIT_CTLS2 to avoid advertising features to L1 that KVM
  itself doesn't support, e.g. because the expected entry+exit pairs aren't
  supported. (Sean Christopherson)
---
 Documentation/virt/kvm/x86/nested-vmx.rst |  1 +
 arch/x86/kvm/vmx/capabilities.h           |  1 +
 arch/x86/kvm/vmx/nested.c                 | 21 ++++++++++++++++++++-
 arch/x86/kvm/vmx/vmcs12.c                 |  1 +
 arch/x86/kvm/vmx/vmcs12.h                 |  2 ++
 arch/x86/kvm/x86.h                        |  2 +-
 6 files changed, 26 insertions(+), 2 deletions(-)

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
index 2962a3bb9747..c96e6cb18c9a 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -38,6 +38,7 @@ struct nested_vmx_msrs {
 	u32 pinbased_ctls_high;
 	u32 exit_ctls_low;
 	u32 exit_ctls_high;
+	u64 secondary_exit_ctls;
 	u32 entry_ctls_low;
 	u32 entry_ctls_high;
 	u32 misc_low;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a8e7bc04d9bf..42e43eb7561f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1454,6 +1454,7 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_IA32_VMX_PINBASED_CTLS:
 	case MSR_IA32_VMX_PROCBASED_CTLS:
 	case MSR_IA32_VMX_EXIT_CTLS:
+	case MSR_IA32_VMX_EXIT_CTLS2:
 	case MSR_IA32_VMX_ENTRY_CTLS:
 		/*
 		 * The "non-true" VMX capability MSRs are generated from the
@@ -1532,6 +1533,9 @@ int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata)
 		if (msr_index == MSR_IA32_VMX_EXIT_CTLS)
 			*pdata |= VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
 		break;
+	case MSR_IA32_VMX_EXIT_CTLS2:
+		*pdata = msrs->secondary_exit_ctls;
+		break;
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
 	case MSR_IA32_VMX_ENTRY_CTLS:
 		*pdata = vmx_control_msr(
@@ -2471,6 +2475,11 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
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
@@ -6956,7 +6965,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_ACTIVATE_SECONDARY_CONTROLS;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -6965,6 +6974,16 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
 
 	/* We support free control of debug control saving. */
 	msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
+
+	if (msrs->exit_ctls_high & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS) {
+		msrs->secondary_exit_ctls = vmcs_conf->secondary_vmexit_ctrl;
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
index 106a72c923ca..98457d7b2b23 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -73,6 +73,7 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(PAGE_FAULT_ERROR_CODE_MATCH, page_fault_error_code_match),
 	FIELD(CR3_TARGET_COUNT, cr3_target_count),
 	FIELD(VM_EXIT_CONTROLS, vm_exit_controls),
+	FIELD(SECONDARY_VM_EXIT_CONTROLS, secondary_vm_exit_controls),
 	FIELD(VM_EXIT_MSR_STORE_COUNT, vm_exit_msr_store_count),
 	FIELD(VM_EXIT_MSR_LOAD_COUNT, vm_exit_msr_load_count),
 	FIELD(VM_ENTRY_CONTROLS, vm_entry_controls),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 56fd150a6f24..1fe3ed9108aa 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -185,6 +185,7 @@ struct __packed vmcs12 {
 	u16 host_gs_selector;
 	u16 host_tr_selector;
 	u16 guest_pml_index;
+	u64 secondary_vm_exit_controls;
 };
 
 /*
@@ -360,6 +361,7 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_gs_selector, 992);
 	CHECK_OFFSET(host_tr_selector, 994);
 	CHECK_OFFSET(guest_pml_index, 996);
+	CHECK_OFFSET(secondary_vm_exit_controls, 998);
 }
 
 extern const unsigned short vmcs12_field_offsets[];
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 0ed91512b757..890b7a6554d5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -66,7 +66,7 @@ void kvm_spurious_fault(void);
  * associated feature that KVM supports for nested virtualization.
  */
 #define KVM_FIRST_EMULATED_VMX_MSR	MSR_IA32_VMX_BASIC
-#define KVM_LAST_EMULATED_VMX_MSR	MSR_IA32_VMX_VMFUNC
+#define KVM_LAST_EMULATED_VMX_MSR	MSR_IA32_VMX_EXIT_CTLS2
 
 #define KVM_DEFAULT_PLE_GAP		128
 #define KVM_VMX_DEFAULT_PLE_WINDOW	4096
-- 
2.46.2


