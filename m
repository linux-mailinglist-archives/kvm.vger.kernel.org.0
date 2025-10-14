Return-Path: <kvm+bounces-59970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 862C9BD6F45
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 03:15:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E69E740A2C3
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2AC92FFFB1;
	Tue, 14 Oct 2025 01:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="EH5JNG3z"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA042FF66B;
	Tue, 14 Oct 2025 01:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760404275; cv=none; b=g1w6WT4/43xtmrGNBChrqEC+J8jjp7p8E1wqxy2yiK0/nYfV0wPkvGYQ2hU4Lhv/CDq8ye8Ikc6/nQjnIF7TxEHr1q9/Yh4VVUncOL/x0GOb0l9SwsZLaHhTzjdHtQ41EfggLr1nHuxy+6Z1xFrpjTGmEBCTDTdHO80kZu/a2Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760404275; c=relaxed/simple;
	bh=ay3bzl+C2z83zwcgahriItnEGLRFMbZ2OoFbXr1YsiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iix3rPNb7ROCgDGszTNWPWyZttxLpo0H2Lk/E/2hURndKCpW0pF/BI44NJvPoRx81mZGtNwFeirAbhNtWWiCZgDufCd4MyXwbPkwhLlvtOzGB+LlI5cdXlT9shEuq6ckUn097tDvKaPCIMWS7ViUYwvbipldoPp4Pj8KVAzE8lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=EH5JNG3z; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59E19p1g1568441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 13 Oct 2025 18:10:12 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59E19p1g1568441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1760404213;
	bh=k5K1u+o4NEht044hHr1g8B5khAn5ivZkxqt72NwSpNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EH5JNG3zMpBufCu5X+RAJw/vU7RZvGtnMxyEvUJ6rnYjXNK9jXXPb5FpBivIOjSYH
	 mjxFkW2wNJgzMUjvnQ0ogZQ3cgqUMjztbm9yUztJgNG6Lku6CY7XnMoTahlyPM87KA
	 Vq9XXm3yGGhgwBnkP3seKx90C8gmg971zpHlU2A13uLbTmGKA0SUMRfAwglqC+g4uK
	 B1XFAbCxTZh+bKHyFML82I8K6OaYyB2kiEVVO6dWLWiKP0PlxYatO1FjnH3s7FBDPD
	 QNIQNrNZwBAdQ7v8BEsOhhESqBccH91xfXDP9GfsPfknGxXiIYuN8X6/7zFRA4y36A
	 FHnMpSzke0SUA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v8 19/21] KVM: nVMX: Add FRED-related VMCS field checks
Date: Mon, 13 Oct 2025 18:09:48 -0700
Message-ID: <20251014010950.1568389-20-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251014010950.1568389-1-xin@zytor.com>
References: <20251014010950.1568389-1-xin@zytor.com>
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
index aba2800b4012..bffd10b6fe25 100644
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
@@ -3087,8 +3078,28 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
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
@@ -3096,6 +3107,24 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
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
 
@@ -3182,9 +3211,29 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
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
@@ -3353,6 +3402,48 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
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


