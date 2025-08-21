Return-Path: <kvm+bounces-55423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74715B30964
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:41:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D76E51CE0D6E
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902EA2F5334;
	Thu, 21 Aug 2025 22:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="VnqxpXi7"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80F62EA74F;
	Thu, 21 Aug 2025 22:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815880; cv=none; b=dIqomAgZrWFvhMe4DPRBBmucUU6J19MIK9AaUvue2XbsomvTFR+OuhOPn9HKwUEGhyxJe7CIEEhrV+zVdNkyLIYCfzksm3GM4ZSEeuWk/Xo9YM4KMtJzkjrMZr35WV8roLS2kk5JsmocoxtpGpP+zV/nB3CTQHPw7IpPy5i5V3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815880; c=relaxed/simple;
	bh=5aCYud04czTgnZX7fl3aVBxvmdv71u4qXcyjQhy3dIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crpyvCS3q/5ey8SZv9ulKVLV9IhASWG/B+NCAcuygePOOU860W64yRYHIwpKwKP4DqYkXLfIrIsGbPSi30t19xfqXLvN+wtlYlC+To17whYr9zgBYCQfSaHmGymxJqVRchFSggO5X/NowVbA5aBJNHNuAkHJ+ZuZwLndKDgaA7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=VnqxpXi7; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57LMaUOg984441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 21 Aug 2025 15:36:58 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57LMaUOg984441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755815818;
	bh=usYu2yzXDVfsRWQrNwNVZn22SJisujKsbnlmBRJ6wJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VnqxpXi7+77ovWTzq8bcVMnMwXs7FmHxU0DHsxykc7pIaeb7uGtBS0B/Aor12s6Uq
	 SrZ5LvBDpFPqzaOWbAKdXF2/KD/BPfd3IQBGz8g5/28RI8oMINWiX+/Rluq5/ao39a
	 N9dVhdMEB14Uiw61fnLAM6gOQDrZ/tGvixtY2IFwwoam3NDGg1OI8TmLJL79oUH6ik
	 t1CPBRUg/O5OUXvGFucTdY2Sy0bieZVfL1/z80Q3cFWZxajEky2bcSIHFlZcXeLnHQ
	 q14Gsv1l7zMp0jg6Yp28Voh4tquOJA7kilvjiDElaOZ5ELzoXr8dZSgkJSmkbT/jyt
	 QnfyGkAIF3PaA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v6 18/20] KVM: nVMX: Add FRED-related VMCS field checks
Date: Thu, 21 Aug 2025 15:36:27 -0700
Message-ID: <20250821223630.984383-19-xin@zytor.com>
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

As with real hardware, nested VMX validates various VMCS fields, including
control and guest/host state fields.  This patch adds checks for FRED-related
VMCS fields to support nested FRED functionality.

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
index 0cb9a2e43ad2..b56bbac36749 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3031,6 +3031,8 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 					  struct vmcs12 *vmcs12)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	bool fred_enabled = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) &&
+			    (vmcs12->guest_cr4 & X86_CR4_FRED);
 
 	if (CC(!vmx_control_verify(vmcs12->vm_entry_controls,
 				    vmx->nested.msrs.entry_ctls_low,
@@ -3048,22 +3050,11 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
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
@@ -3088,8 +3079,28 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
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
@@ -3097,6 +3108,24 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
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
 
@@ -3184,9 +3213,29 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
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
@@ -3354,6 +3403,48 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
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
 		if (CC(!is_valid_cet_state(vcpu, vmcs12->guest_s_cet, vmcs12->guest_ssp,
 					   vmcs12->guest_ssp_tbl)))
-- 
2.50.1


