Return-Path: <kvm+bounces-27719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8581F98B349
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:03:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BDB8DB22091
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FFA91BD02F;
	Tue,  1 Oct 2024 05:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JMkujZ0E"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD0C4F881;
	Tue,  1 Oct 2024 05:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758937; cv=none; b=ntnK5mDw3llvG1El7HwTpnipdJcvE+4JnY+3rPRGkqIDeYyOxcOY9Y3AdooqI0K2xRm6qu3IMS93AnAbYu5h6IQdgwgBPxqaq5b4AysvHjsGb7he4Mxftc8ZmljpkwtDzSUDe8mvNplI0d1L7OVj7Rk2/0lxL1DC84UxKqC2YoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758937; c=relaxed/simple;
	bh=rZxZItYgG7kfxoyaaKMJ5o98t4Va4yAjZu0SXMYKnLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rs1q7Oiu0u1FPt5BKMeHDuDY8A+c41P+FfqOGvKWBPW9e8LGHQj/WjwSTILGwJczTRnuU1NE2Tp49lV+AntToxD/dnehLKB7UiXETxa47r/sPuEy59u8MxVIwSjRGmJNGQyqF7bSgUAl/M0XfYaa+GuzR7VgeeEQl8wE/nnpmfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JMkujZ0E; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7p3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:41 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7p3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758902;
	bh=iM1mgYlg6p30DH2JJGY1oZ4PtPipkI4OLu6ROopnMM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMkujZ0EN1mLLl2siZGOg5JdmmZUd5yhuxvxfjzHB3wvyXa0XpBhRNNK2HTVbWUBB
	 GpebN2W6aOZN3vcsAXMDKuftnm87+F6VK4pU1vowjHSUIfeQ8LYyY4rHikuMUpfwRr
	 CqyTNxNEiUlExiL3ZVeEEPeGIwpCLZ+x4ZuMDmzldMyIxS9TOUcZpfvk2MY0pIWfTp
	 yF23wAc6Ze3XvTubr70q/hKeLJJYFL74KdNNTmFGD+o0tzQRHw8ahDDJO3lVbzsICV
	 TWNGfsOhUCdIuUlkcml6GM7E/jD1I6W6Mj49CMqwav9nmAciSwKEat36DOLNkju7x4
	 wTnVMbGGXfXQg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 26/27] KVM: nVMX: Add VMCS FRED states checking
Date: Mon, 30 Sep 2024 22:01:09 -0700
Message-ID: <20241001050110.3643764-27-xin@zytor.com>
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

As real hardware, nested VMX performs checks on various VMCS fields,
including both controls and guest/host states.  Add FRED related VMCS
field checkings with the addition of nested FRED.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 80 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 45a5ffa51e60..1fbdeea32c98 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2975,6 +2975,8 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 					  struct vmcs12 *vmcs12)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	bool fred_enabled = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) &&
+			    (vmcs12->guest_cr4 & X86_CR4_FRED);
 
 	if (CC(!vmx_control_verify(vmcs12->vm_entry_controls,
 				    vmx->nested.msrs.entry_ctls_low,
@@ -2993,6 +2995,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		u32 intr_type = intr_info & INTR_INFO_INTR_TYPE_MASK;
 		bool has_error_code = intr_info & INTR_INFO_DELIVER_CODE_MASK;
 		bool should_have_error_code;
+		bool has_nested_exception = vmx->nested.msrs.basic & VMX_BASIC_NESTED_EXCEPTION;
 		bool urg = nested_cpu_has2(vmcs12,
 					   SECONDARY_EXEC_UNRESTRICTED_GUEST);
 		bool prot_mode = !urg || vmcs12->guest_cr0 & X86_CR0_PE;
@@ -3006,7 +3009,9 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		/* VM-entry interruption-info field: vector */
 		if (CC(intr_type == INTR_TYPE_NMI_INTR && vector != NMI_VECTOR) ||
 		    CC(intr_type == INTR_TYPE_HARD_EXCEPTION && vector > 31) ||
-		    CC(intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
+		    CC(intr_type == INTR_TYPE_OTHER_EVENT &&
+		       ((!fred_enabled && vector > 0) ||
+		        (fred_enabled && vector > 2))))
 			return -EINVAL;
 
 		/* VM-entry interruption-info field: deliver error code */
@@ -3025,6 +3030,15 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		if (CC(intr_info & INTR_INFO_RESVD_BITS_MASK))
 			return -EINVAL;
 
+		/*
+		 * When the CPU enumerates VMX nested-exception support, bit 13
+		 * (set to indicate a nested exception) of the intr info field
+		 * may have value 1. Otherwise bit 13 is reserved.
+		 */
+		if (CC(!has_nested_exception &&
+		       (intr_info & INTR_INFO_NESTED_EXCEPTION_MASK)))
+			return -EINVAL;
+
 		/* VM-entry instruction length */
 		switch (intr_type) {
 		case INTR_TYPE_SOFT_EXCEPTION:
@@ -3034,6 +3048,12 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 			    CC(vmcs12->vm_entry_instruction_len == 0 &&
 			    CC(!nested_cpu_has_zero_length_injection(vcpu))))
 				return -EINVAL;
+			break;
+		case INTR_TYPE_OTHER_EVENT:
+			if (fred_enabled && (vector == 1 || vector == 2))
+				if (CC(vmcs12->vm_entry_instruction_len > 15))
+					return -EINVAL;
+			break;
 		}
 	}
 
@@ -3096,9 +3116,30 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	if (ia32e) {
 		if (CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
 			return -EINVAL;
+		if (vmcs12->vm_exit_controls & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS &&
+		    vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_LOAD_IA32_FRED) {
+			/* Bit 11, bits 5:4, and bit 2 of the IA32_FRED_CONFIG must be zero */
+			if (CC(vmcs12->host_ia32_fred_config &
+			       (BIT_ULL(11) | GENMASK_ULL(5, 4) | BIT_ULL(2))) ||
+			    CC(vmcs12->host_ia32_fred_rsp1 & GENMASK_ULL(5, 0)) ||
+			    CC(vmcs12->host_ia32_fred_rsp2 & GENMASK_ULL(5, 0)) ||
+			    CC(vmcs12->host_ia32_fred_rsp3 & GENMASK_ULL(5, 0)) ||
+			    CC(vmcs12->host_ia32_fred_ssp1 & GENMASK_ULL(2, 0)) ||
+			    CC(vmcs12->host_ia32_fred_ssp2 & GENMASK_ULL(2, 0)) ||
+			    CC(vmcs12->host_ia32_fred_ssp3 & GENMASK_ULL(2, 0)) ||
+			    CC(is_noncanonical_address(vmcs12->host_ia32_fred_config & PAGE_MASK, vcpu)) ||
+			    CC(is_noncanonical_address(vmcs12->host_ia32_fred_rsp1, vcpu)) ||
+			    CC(is_noncanonical_address(vmcs12->host_ia32_fred_rsp2, vcpu)) ||
+			    CC(is_noncanonical_address(vmcs12->host_ia32_fred_rsp3, vcpu)) ||
+			    CC(is_noncanonical_address(vmcs12->host_ia32_fred_ssp1, vcpu)) ||
+			    CC(is_noncanonical_address(vmcs12->host_ia32_fred_ssp2, vcpu)) ||
+			    CC(is_noncanonical_address(vmcs12->host_ia32_fred_ssp3, vcpu)))
+				return -EINVAL;
+		}
 	} else {
 		if (CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
 		    CC(vmcs12->host_cr4 & X86_CR4_PCIDE) ||
+		    CC(vmcs12->host_cr4 & X86_CR4_FRED) ||
 		    CC((vmcs12->host_rip) >> 32))
 			return -EINVAL;
 	}
@@ -3242,6 +3283,43 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	     CC((vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD))))
 		return -EINVAL;
 
+	if (ia32e) {
+		if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_FRED) {
+			/* Bit 11, bits 5:4, and bit 2 of the IA32_FRED_CONFIG must be zero */
+			if (CC(vmcs12->guest_ia32_fred_config &
+			       (BIT_ULL(11) | GENMASK_ULL(5, 4) | BIT_ULL(2))) ||
+			    CC(vmcs12->guest_ia32_fred_rsp1 & GENMASK_ULL(5, 0)) ||
+			    CC(vmcs12->guest_ia32_fred_rsp2 & GENMASK_ULL(5, 0)) ||
+			    CC(vmcs12->guest_ia32_fred_rsp3 & GENMASK_ULL(5, 0)) ||
+			    CC(vmcs12->guest_ia32_fred_ssp1 & GENMASK_ULL(2, 0)) ||
+			    CC(vmcs12->guest_ia32_fred_ssp2 & GENMASK_ULL(2, 0)) ||
+			    CC(vmcs12->guest_ia32_fred_ssp3 & GENMASK_ULL(2, 0)) ||
+			    CC(is_noncanonical_address(vmcs12->guest_ia32_fred_config & PAGE_MASK, vcpu)) ||
+			    CC(is_noncanonical_address(vmcs12->guest_ia32_fred_rsp1, vcpu)) ||
+			    CC(is_noncanonical_address(vmcs12->guest_ia32_fred_rsp2, vcpu)) ||
+			    CC(is_noncanonical_address(vmcs12->guest_ia32_fred_rsp3, vcpu)) ||
+			    CC(is_noncanonical_address(vmcs12->guest_ia32_fred_ssp1, vcpu)) ||
+			    CC(is_noncanonical_address(vmcs12->guest_ia32_fred_ssp2, vcpu)) ||
+			    CC(is_noncanonical_address(vmcs12->guest_ia32_fred_ssp3, vcpu)))
+				return -EINVAL;
+		}
+		if (vmcs12->guest_cr4 & X86_CR4_FRED) {
+			unsigned int ss_dpl = VMX_AR_DPL(vmcs12->guest_ss_ar_bytes);
+			if (CC(ss_dpl == 1 || ss_dpl == 2))
+				return -EINVAL;
+			if (ss_dpl == 0 &&
+			    CC(!(vmcs12->guest_cs_ar_bytes & VMX_AR_L_MASK)))
+				return -EINVAL;
+			if (ss_dpl == 3 &&
+			    (CC(vmcs12->guest_rflags & X86_EFLAGS_IOPL) ||
+			     CC(vmcs12->guest_interruptibility_info & GUEST_INTR_STATE_STI)))
+				return -EINVAL;
+		}
+	} else {
+		if (CC(vmcs12->guest_cr4 & X86_CR4_FRED))
+			return -EINVAL;
+	}
+
 	if (nested_check_guest_non_reg_state(vmcs12))
 		return -EINVAL;
 
-- 
2.46.2


