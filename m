Return-Path: <kvm+bounces-61112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F6EC0B275
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 21:24:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 761153B7204
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 20:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C03301706;
	Sun, 26 Oct 2025 20:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="J3WuIMxs"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A3B2FDC5D;
	Sun, 26 Oct 2025 20:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510032; cv=none; b=UN/qK5AKKwPGI2ebFel5gJPTvyHOyeDERX4HtzsX+HIIJAJCyWOi4AruAZmcz5qjH8xcjHi51duYrgR3qteQLMQ/djUF/AvgDG57JuMgbn/XcNJHqsd1fCANNUxJ0sPvMFNojHcbREVcnkEyiTx3UKZRNxLVL0ujazP52TT6Gd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510032; c=relaxed/simple;
	bh=6cMgbMRTKNprYloMv3Y2b6wYWBLwTRczARGoIZ6IOMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1ogI5vbvRsinAPvLX9EMHd9SvF3IN4Q/la9XfkaUi+JevFRbh9slcKIFpL40SoaJHiXkG9NS0mg15FxI7nVy1A5OvSbt0uSjK1lhObmJaU9TERWEoVS9Q3UC4cqGTLXD9uYhGTxR9Y+jH+y+xODYGbzE9nDigHzsm+RCADFs9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=J3WuIMxs; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QKJBkb505258
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 13:19:38 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QKJBkb505258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761509979;
	bh=TGywbx3aSlh/7rYoS4NDGhwuv9c0V6GEyrwtx60PDtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3WuIMxsn7+JijZ3WieG9D+4uL86CYXGfxu5HeKzReB+MZGbTKUvIX7p+7kry5Flw
	 Cvq7C9wHwo0UvN/VDK/AXixodLA/WDgiw+daYaYA5PRPkVNduffYfbVa1CQ8ilCOvL
	 vSZkGnpR0fwOnFRQkMuYupftJ45z+1zaZa4vO094t40SvgevgbtaV36IDhanotAbyb
	 T0Ru8W7H+op9ZDrAmRdSKuyiY92aIuVPtg7P859l4e2YqdYd/UaxrWRRd2oXE6fCjh
	 BoW2h24B97FqC08odqtiqY0Ef11DRsdEJGVOKs6bguglJhGzX+vEwMWM4xBWUfpo7H
	 uqtZzSvTgiwnA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org, sohil.mehta@intel.com
Subject: [PATCH v9 20/22] KVM: nVMX: Validate FRED-related VMCS fields
Date: Sun, 26 Oct 2025 13:19:08 -0700
Message-ID: <20251026201911.505204-21-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026201911.505204-1-xin@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Extend nested VMX field validation to include FRED-specific VMCS fields,
mirroring hardware behavior.

This enables support for nested FRED by ensuring control and guest/host
state fields are properly checked.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5:
* Add TB from Xuelian Guo.
---
 arch/x86/kvm/vmx/nested.c | 117 +++++++++++++++++++++++++++++++++-----
 1 file changed, 104 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 63cdfffba58b..8682709d8759 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3030,6 +3030,8 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 					  struct vmcs12 *vmcs12)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	bool fred_enabled = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) &&
+			    (vmcs12->guest_cr4 & X86_CR4_FRED);
 
 	if (CC(!vmx_control_verify(vmcs12->vm_entry_controls,
 				    vmx->nested.msrs.entry_ctls_low,
@@ -3047,22 +3049,11 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		u8 vector = intr_info & INTR_INFO_VECTOR_MASK;
 		u32 intr_type = intr_info & INTR_INFO_INTR_TYPE_MASK;
 		bool has_error_code = intr_info & INTR_INFO_DELIVER_CODE_MASK;
+		bool has_nested_exception = vmx->nested.msrs.basic & VMX_BASIC_NESTED_EXCEPTION;
 		bool urg = nested_cpu_has2(vmcs12,
 					   SECONDARY_EXEC_UNRESTRICTED_GUEST);
 		bool prot_mode = !urg || vmcs12->guest_cr0 & X86_CR0_PE;
 
-		/* VM-entry interruption-info field: interruption type */
-		if (CC(intr_type == INTR_TYPE_RESERVED) ||
-		    CC(intr_type == INTR_TYPE_OTHER_EVENT &&
-		       !nested_cpu_supports_monitor_trap_flag(vcpu)))
-			return -EINVAL;
-
-		/* VM-entry interruption-info field: vector */
-		if (CC(intr_type == INTR_TYPE_NMI_INTR && vector != NMI_VECTOR) ||
-		    CC(intr_type == INTR_TYPE_HARD_EXCEPTION && vector > 31) ||
-		    CC(intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
-			return -EINVAL;
-
 		/*
 		 * Cannot deliver error code in real mode or if the interrupt
 		 * type is not hardware exception. For other cases, do the
@@ -3086,8 +3077,28 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		if (CC(intr_info & INTR_INFO_RESVD_BITS_MASK))
 			return -EINVAL;
 
-		/* VM-entry instruction length */
+		/*
+		 * When the CPU enumerates VMX nested-exception support, bit 13
+		 * (set to indicate a nested exception) of the intr info field
+		 * may have value 1.  Otherwise bit 13 is reserved.
+		 */
+		if (CC(!(has_nested_exception && intr_type == INTR_TYPE_HARD_EXCEPTION) &&
+		       intr_info & INTR_INFO_NESTED_EXCEPTION_MASK))
+			return -EINVAL;
+
 		switch (intr_type) {
+		case INTR_TYPE_EXT_INTR:
+			break;
+		case INTR_TYPE_RESERVED:
+			return -EINVAL;
+		case INTR_TYPE_NMI_INTR:
+			if (CC(vector != NMI_VECTOR))
+				return -EINVAL;
+			break;
+		case INTR_TYPE_HARD_EXCEPTION:
+			if (CC(vector > 31))
+				return -EINVAL;
+			break;
 		case INTR_TYPE_SOFT_EXCEPTION:
 		case INTR_TYPE_SOFT_INTR:
 		case INTR_TYPE_PRIV_SW_EXCEPTION:
@@ -3095,6 +3106,24 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 			    CC(vmcs12->vm_entry_instruction_len == 0 &&
 			    CC(!nested_cpu_has_zero_length_injection(vcpu))))
 				return -EINVAL;
+			break;
+		case INTR_TYPE_OTHER_EVENT:
+			switch (vector) {
+			case 0:
+				if (CC(!nested_cpu_supports_monitor_trap_flag(vcpu)))
+					return -EINVAL;
+				break;
+			case 1:
+			case 2:
+				if (CC(!fred_enabled))
+					return -EINVAL;
+				if (CC(vmcs12->vm_entry_instruction_len > X86_MAX_INSTRUCTION_LENGTH))
+					return -EINVAL;
+				break;
+			default:
+				return -EINVAL;
+			}
+			break;
 		}
 	}
 
@@ -3213,9 +3242,29 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	if (ia32e) {
 		if (CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
 			return -EINVAL;
+		if (vmcs12->vm_exit_controls & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS &&
+		    vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_LOAD_IA32_FRED) {
+			if (CC(vmcs12->host_ia32_fred_config &
+			       (BIT_ULL(11) | GENMASK_ULL(5, 4) | BIT_ULL(2))) ||
+			    CC(vmcs12->host_ia32_fred_rsp1 & GENMASK_ULL(5, 0)) ||
+			    CC(vmcs12->host_ia32_fred_rsp2 & GENMASK_ULL(5, 0)) ||
+			    CC(vmcs12->host_ia32_fred_rsp3 & GENMASK_ULL(5, 0)) ||
+			    CC(vmcs12->host_ia32_fred_ssp1 & GENMASK_ULL(2, 0)) ||
+			    CC(vmcs12->host_ia32_fred_ssp2 & GENMASK_ULL(2, 0)) ||
+			    CC(vmcs12->host_ia32_fred_ssp3 & GENMASK_ULL(2, 0)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_config & PAGE_MASK, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_rsp1, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_rsp2, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_rsp3, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_ssp1, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_ssp2, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_ssp3, vcpu)))
+				return -EINVAL;
+		}
 	} else {
 		if (CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
 		    CC(vmcs12->host_cr4 & X86_CR4_PCIDE) ||
+		    CC(vmcs12->host_cr4 & X86_CR4_FRED) ||
 		    CC((vmcs12->host_rip) >> 32))
 			return -EINVAL;
 	}
@@ -3384,6 +3433,48 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	     CC((vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD))))
 		return -EINVAL;
 
+	if (ia32e) {
+		if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_FRED) {
+			if (CC(vmcs12->guest_ia32_fred_config &
+			       (BIT_ULL(11) | GENMASK_ULL(5, 4) | BIT_ULL(2))) ||
+			    CC(vmcs12->guest_ia32_fred_rsp1 & GENMASK_ULL(5, 0)) ||
+			    CC(vmcs12->guest_ia32_fred_rsp2 & GENMASK_ULL(5, 0)) ||
+			    CC(vmcs12->guest_ia32_fred_rsp3 & GENMASK_ULL(5, 0)) ||
+			    CC(vmcs12->guest_ia32_fred_ssp1 & GENMASK_ULL(2, 0)) ||
+			    CC(vmcs12->guest_ia32_fred_ssp2 & GENMASK_ULL(2, 0)) ||
+			    CC(vmcs12->guest_ia32_fred_ssp3 & GENMASK_ULL(2, 0)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_config & PAGE_MASK, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_rsp1, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_rsp2, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_rsp3, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_ssp1, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_ssp2, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_ssp3, vcpu)))
+				return -EINVAL;
+		}
+		if (vmcs12->guest_cr4 & X86_CR4_FRED) {
+			unsigned int ss_dpl = VMX_AR_DPL(vmcs12->guest_ss_ar_bytes);
+			switch (ss_dpl) {
+			case 0:
+				if (CC(!(vmcs12->guest_cs_ar_bytes & VMX_AR_L_MASK)))
+					return -EINVAL;
+				break;
+			case 1:
+			case 2:
+				return -EINVAL;
+			case 3:
+				if (CC(vmcs12->guest_rflags & X86_EFLAGS_IOPL))
+					return -EINVAL;
+				if (CC(vmcs12->guest_interruptibility_info & GUEST_INTR_STATE_STI))
+					return -EINVAL;
+				break;
+			}
+		}
+	} else {
+		if (CC(vmcs12->guest_cr4 & X86_CR4_FRED))
+			return -EINVAL;
+	}
+
 	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE) {
 		if (nested_vmx_check_cet_state_common(vcpu, vmcs12->guest_s_cet,
 						      vmcs12->guest_ssp,
-- 
2.51.0


