Return-Path: <kvm+bounces-27733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48AB298B362
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CD301C230CC
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8627E1BF324;
	Tue,  1 Oct 2024 05:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="ALoL9fAy"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CAD19258C;
	Tue,  1 Oct 2024 05:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758939; cv=none; b=cRUth4AXG8doeCpsYVIYZO5Izp4zC5dtTEMJ01uBqGqBKsjyy7X83U09EK1QoXUdD1S/fzN6349Hu3bMta9v56s60UEgy0OOJd/JAu9mDiB3a5jNeQSLwlcOqJuVpjBMqtcwMiGdAACRpcRqiUqqp23yj6a1by3pKU6KXj9cnU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758939; c=relaxed/simple;
	bh=BYP7dppUvcpso1fpT9aeTu3FRv6XtV3QfXbCxS4dT04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuAQWoeiFAQHwEp7I4AR/sAlohdZALThzdluHn+cqEqiJ5/AMJGXmbbQOn8j7zHYddNMGT1Csmx1O1gZLE7KycmJUUI7JOIiiywLrPZbZ5oNsizhcGIdiCRdpi4whweqvLYkOs2Pih05cvZiHyH1GyWvlvgw1iKWXmqCipMv1R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=ALoL9fAy; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7o3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:40 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7o3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758901;
	bh=Qri2p8/HmUrshvMeaSaTaHtV42yUJ+VhDEmxNNA1YXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALoL9fAySHX8I0o5ltLzC35S0/FCOHlpkkaWxP32KHMgutiJ3rFkOjKnoJe2TgMuK
	 Ctfmew+HhwG9W3x10Gs0peaDudW4oDtpyDXYo+UBIfUBkMKw08XIXbss7FgZJDHPS1
	 RO6urC2URZhwBimc2GEdUzz4PYTPVi2E1V/766UKDoZtXJ2jc4NLCEg8mupPXoXd9K
	 M01BKgfoyJnFyMQYWgBOV+MP7aMiZQCsMEiB3Dfp+JHVarUDpgAI3Yy0Q8kHpsSbqB
	 g6j74GX9c1kZFXYHwJeBnHKi7Gf7lpxNath5FYqb7hP63qrgXCSzuXc0p9cegmx37N
	 ez8cPTgCS03pw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 25/27] KVM: nVMX: Add FRED VMCS fields
Date: Mon, 30 Sep 2024 22:01:08 -0700
Message-ID: <20241001050110.3643764-26-xin@zytor.com>
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

Add FRED VMCS fields to nested VMX context management.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---

Change since v2:
* Add and use nested_cpu_has_fred(vmcs12) because vmcs02 should be set
  from vmcs12 if and only if the field is enabled in L1's VMX config
  (Sean Christopherson).
* Fix coding style (Sean Christopherson).

Change since v1:
* Remove hyperv TLFS related changes (Jeremi Piotrowski).
* Use kvm_cpu_cap_has() instead of cpu_feature_enabled() (Chao Gao).
---
 Documentation/virt/kvm/x86/nested-vmx.rst | 18 +++++
 arch/x86/kvm/vmx/nested.c                 | 88 ++++++++++++++++++-----
 arch/x86/kvm/vmx/nested.h                 |  8 +++
 arch/x86/kvm/vmx/nested_vmcs_fields.h     | 12 ++++
 arch/x86/kvm/vmx/vmcs12.c                 | 18 +++++
 arch/x86/kvm/vmx/vmcs12.h                 | 36 ++++++++++
 arch/x86/kvm/vmx/vmcs_shadow_fields.h     |  4 ++
 7 files changed, 168 insertions(+), 16 deletions(-)

diff --git a/Documentation/virt/kvm/x86/nested-vmx.rst b/Documentation/virt/kvm/x86/nested-vmx.rst
index e64ef231f310..87fa9f3877ab 100644
--- a/Documentation/virt/kvm/x86/nested-vmx.rst
+++ b/Documentation/virt/kvm/x86/nested-vmx.rst
@@ -218,6 +218,24 @@ struct shadow_vmcs is ever changed.
 		u16 host_gs_selector;
 		u16 host_tr_selector;
 		u64 secondary_vm_exit_controls;
+		u64 guest_ia32_fred_config;
+		u64 guest_ia32_fred_rsp1;
+		u64 guest_ia32_fred_rsp2;
+		u64 guest_ia32_fred_rsp3;
+		u64 guest_ia32_fred_stklvls;
+		u64 guest_ia32_fred_ssp1;
+		u64 guest_ia32_fred_ssp2;
+		u64 guest_ia32_fred_ssp3;
+		u64 host_ia32_fred_config;
+		u64 host_ia32_fred_rsp1;
+		u64 host_ia32_fred_rsp2;
+		u64 host_ia32_fred_rsp3;
+		u64 host_ia32_fred_stklvls;
+		u64 host_ia32_fred_ssp1;
+		u64 host_ia32_fred_ssp2;
+		u64 host_ia32_fred_ssp3;
+		u64 injected_event_data;
+		u64 original_event_data;
 	};
 
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4529fd635385..45a5ffa51e60 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -719,6 +719,12 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_FRED_RSP0, MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_FRED_SSP0, MSR_TYPE_RW);
 #endif
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
@@ -1268,9 +1274,11 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 {
 	const u64 feature_bits = VMX_BASIC_DUAL_MONITOR_TREATMENT |
 				 VMX_BASIC_INOUT |
-				 VMX_BASIC_TRUE_CTLS;
+				 VMX_BASIC_TRUE_CTLS |
+				 VMX_BASIC_NESTED_EXCEPTION;
 
-	const u64 reserved_bits = GENMASK_ULL(63, 56) |
+	const u64 reserved_bits = GENMASK_ULL(63, 59) |
+				  GENMASK_ULL(57, 56) |
 				  GENMASK_ULL(47, 45) |
 				  BIT_ULL(31);
 
@@ -2536,6 +2544,8 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 			     vmcs12->vm_entry_instruction_len);
 		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
 			     vmcs12->guest_interruptibility_info);
+		if (nested_cpu_has_fred(vmcs12))
+			vmcs_write64(INJECTED_EVENT_DATA, vmcs12->injected_event_data);
 		vmx->loaded_vmcs->nmi_known_unmasked =
 			!(vmcs12->guest_interruptibility_info & GUEST_INTR_STATE_NMI);
 	} else {
@@ -2588,6 +2598,17 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_writel(GUEST_IDTR_BASE, vmcs12->guest_idtr_base);
 
 		vmx_segment_cache_clear(vmx);
+
+		if (nested_cpu_has_fred(vmcs12)) {
+			vmcs_write64(GUEST_IA32_FRED_CONFIG, vmcs12->guest_ia32_fred_config);
+			vmcs_write64(GUEST_IA32_FRED_RSP1, vmcs12->guest_ia32_fred_rsp1);
+			vmcs_write64(GUEST_IA32_FRED_RSP2, vmcs12->guest_ia32_fred_rsp2);
+			vmcs_write64(GUEST_IA32_FRED_RSP3, vmcs12->guest_ia32_fred_rsp3);
+			vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmcs12->guest_ia32_fred_stklvls);
+			vmcs_write64(GUEST_IA32_FRED_SSP1, vmcs12->guest_ia32_fred_ssp1);
+			vmcs_write64(GUEST_IA32_FRED_SSP2, vmcs12->guest_ia32_fred_ssp2);
+			vmcs_write64(GUEST_IA32_FRED_SSP3, vmcs12->guest_ia32_fred_ssp3);
+		}
 	}
 
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
@@ -3881,6 +3902,8 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
 	u32 idt_vectoring;
 	unsigned int nr;
 
+	vmcs12->original_event_data = 0;
+
 	/*
 	 * Per the SDM, VM-Exits due to double and triple faults are never
 	 * considered to occur during event delivery, even if the double/triple
@@ -3919,6 +3942,11 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
 				vcpu->arch.exception.error_code;
 		}
 
+		if (vcpu->arch.exception.nested)
+			idt_vectoring |= INTR_INFO_NESTED_EXCEPTION_MASK;
+
+		vmcs12->original_event_data = vcpu->arch.exception.event_data;
+
 		vmcs12->idt_vectoring_info_field = idt_vectoring;
 	} else if (vcpu->arch.nmi_injected) {
 		vmcs12->idt_vectoring_info_field =
@@ -4009,19 +4037,10 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu)
 	struct kvm_queued_exception *ex = &vcpu->arch.exception_vmexit;
 	u32 intr_info = ex->vector | INTR_INFO_VALID_MASK;
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-	unsigned long exit_qual;
+	unsigned long exit_qual = 0;
 
-	if (ex->has_payload) {
-		exit_qual = ex->payload;
-	} else if (ex->vector == PF_VECTOR) {
-		exit_qual = vcpu->arch.cr2;
-	} else if (ex->vector == DB_VECTOR) {
-		exit_qual = vcpu->arch.dr6;
-		exit_qual &= ~DR6_BT;
-		exit_qual ^= DR6_ACTIVE_LOW;
-	} else {
-		exit_qual = 0;
-	}
+	if (ex->vector != NM_VECTOR)
+		exit_qual = ex->event_data;
 
 	/*
 	 * Unlike AMD's Paged Real Mode, which reports an error code on #PF
@@ -4042,10 +4061,13 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu)
 		intr_info |= INTR_INFO_DELIVER_CODE_MASK;
 	}
 
-	if (kvm_exception_is_soft(ex->vector))
+	if (kvm_exception_is_soft(ex->vector)) {
 		intr_info |= INTR_TYPE_SOFT_EXCEPTION;
-	else
+	} else {
 		intr_info |= INTR_TYPE_HARD_EXCEPTION;
+		if (ex->nested)
+			intr_info |= INTR_INFO_NESTED_EXCEPTION_MASK;
+	}
 
 	if (!(vmcs12->idt_vectoring_info_field & VECTORING_INFO_VALID_MASK) &&
 	    vmx_get_nmi_mask(vcpu))
@@ -4468,6 +4490,14 @@ static bool is_vmcs12_ext_field(unsigned long field)
 	case GUEST_TR_BASE:
 	case GUEST_GDTR_BASE:
 	case GUEST_IDTR_BASE:
+	case GUEST_IA32_FRED_CONFIG:
+	case GUEST_IA32_FRED_RSP1:
+	case GUEST_IA32_FRED_RSP2:
+	case GUEST_IA32_FRED_RSP3:
+	case GUEST_IA32_FRED_STKLVLS:
+	case GUEST_IA32_FRED_SSP1:
+	case GUEST_IA32_FRED_SSP2:
+	case GUEST_IA32_FRED_SSP3:
 	case GUEST_PENDING_DBG_EXCEPTIONS:
 	case GUEST_BNDCFGS:
 		return true;
@@ -4517,6 +4547,18 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 	vmcs12->guest_tr_base = vmcs_readl(GUEST_TR_BASE);
 	vmcs12->guest_gdtr_base = vmcs_readl(GUEST_GDTR_BASE);
 	vmcs12->guest_idtr_base = vmcs_readl(GUEST_IDTR_BASE);
+
+	if (nested_cpu_has_fred(vmcs12)) {
+		vmcs12->guest_ia32_fred_config = vmcs_read64(GUEST_IA32_FRED_CONFIG);
+		vmcs12->guest_ia32_fred_rsp1 = vmcs_read64(GUEST_IA32_FRED_RSP1);
+		vmcs12->guest_ia32_fred_rsp2 = vmcs_read64(GUEST_IA32_FRED_RSP2);
+		vmcs12->guest_ia32_fred_rsp3 = vmcs_read64(GUEST_IA32_FRED_RSP3);
+		vmcs12->guest_ia32_fred_stklvls = vmcs_read64(GUEST_IA32_FRED_STKLVLS);
+		vmcs12->guest_ia32_fred_ssp1 = vmcs_read64(GUEST_IA32_FRED_SSP1);
+		vmcs12->guest_ia32_fred_ssp2 = vmcs_read64(GUEST_IA32_FRED_SSP2);
+		vmcs12->guest_ia32_fred_ssp3 = vmcs_read64(GUEST_IA32_FRED_SSP3);
+	}
+
 	vmcs12->guest_pending_dbg_exceptions =
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
 
@@ -4741,6 +4783,17 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	vmcs_write32(GUEST_IDTR_LIMIT, 0xFFFF);
 	vmcs_write32(GUEST_GDTR_LIMIT, 0xFFFF);
 
+	if (nested_cpu_has_fred(vmcs12)) {
+		vmcs_write64(GUEST_IA32_FRED_CONFIG, vmcs12->host_ia32_fred_config);
+		vmcs_write64(GUEST_IA32_FRED_RSP1, vmcs12->host_ia32_fred_rsp1);
+		vmcs_write64(GUEST_IA32_FRED_RSP2, vmcs12->host_ia32_fred_rsp2);
+		vmcs_write64(GUEST_IA32_FRED_RSP3, vmcs12->host_ia32_fred_rsp3);
+		vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmcs12->host_ia32_fred_stklvls);
+		vmcs_write64(GUEST_IA32_FRED_SSP1, vmcs12->host_ia32_fred_ssp1);
+		vmcs_write64(GUEST_IA32_FRED_SSP2, vmcs12->host_ia32_fred_ssp2);
+		vmcs_write64(GUEST_IA32_FRED_SSP3, vmcs12->host_ia32_fred_ssp3);
+	}
+
 	/* If not VM_EXIT_CLEAR_BNDCFGS, the L2 value propagates to L1.  */
 	if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
 		vmcs_write64(GUEST_BNDCFGS, 0);
@@ -7197,6 +7250,9 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
 	msrs->basic |= VMX_BASIC_TRUE_CTLS;
 	if (cpu_has_vmx_basic_inout())
 		msrs->basic |= VMX_BASIC_INOUT;
+
+	if (cpu_has_vmx_fred())
+		msrs->basic |= VMX_BASIC_NESTED_EXCEPTION;
 }
 
 static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 2c296b6abb8c..5272f617fcef 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -251,6 +251,14 @@ static inline bool nested_cpu_has_encls_exit(struct vmcs12 *vmcs12)
 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING);
 }
 
+static inline bool nested_cpu_has_fred(struct vmcs12 *vmcs12)
+{
+	return vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_FRED &&
+	       vmcs12->vm_exit_controls & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS &&
+	       vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_SAVE_IA32_FRED &&
+	       vmcs12->secondary_vm_exit_controls & SECONDARY_VM_EXIT_LOAD_IA32_FRED;
+}
+
 /*
  * if fixed0[i] == 1: val[i] must be 1
  * if fixed1[i] == 0: val[i] must be 0
diff --git a/arch/x86/kvm/vmx/nested_vmcs_fields.h b/arch/x86/kvm/vmx/nested_vmcs_fields.h
index fcd6c32dce31..dea22279d008 100644
--- a/arch/x86/kvm/vmx/nested_vmcs_fields.h
+++ b/arch/x86/kvm/vmx/nested_vmcs_fields.h
@@ -9,5 +9,17 @@ BUILD_BUG_ON(1)
 #define HAS_VMCS_FIELD_RANGE(x, y, c)
 #endif
 
+HAS_VMCS_FIELD(SECONDARY_VM_EXIT_CONTROLS, guest_can_use(vcpu, X86_FEATURE_FRED))
+HAS_VMCS_FIELD(SECONDARY_VM_EXIT_CONTROLS_HIGH, guest_can_use(vcpu, X86_FEATURE_FRED))
+
+HAS_VMCS_FIELD_RANGE(GUEST_IA32_FRED_CONFIG, GUEST_IA32_FRED_SSP3, guest_can_use(vcpu, X86_FEATURE_FRED))
+HAS_VMCS_FIELD_RANGE(HOST_IA32_FRED_CONFIG, HOST_IA32_FRED_SSP3, guest_can_use(vcpu, X86_FEATURE_FRED))
+
+HAS_VMCS_FIELD(INJECTED_EVENT_DATA, guest_can_use(vcpu, X86_FEATURE_FRED))
+HAS_VMCS_FIELD(INJECTED_EVENT_DATA_HIGH, guest_can_use(vcpu, X86_FEATURE_FRED))
+
+HAS_VMCS_FIELD(ORIGINAL_EVENT_DATA, guest_can_use(vcpu, X86_FEATURE_FRED))
+HAS_VMCS_FIELD(ORIGINAL_EVENT_DATA_HIGH, guest_can_use(vcpu, X86_FEATURE_FRED))
+
 #undef HAS_VMCS_FIELD
 #undef HAS_VMCS_FIELD_RANGE
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 98457d7b2b23..59f17fdfad11 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -80,6 +80,7 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(VM_ENTRY_MSR_LOAD_COUNT, vm_entry_msr_load_count),
 	FIELD(VM_ENTRY_INTR_INFO_FIELD, vm_entry_intr_info_field),
 	FIELD(VM_ENTRY_EXCEPTION_ERROR_CODE, vm_entry_exception_error_code),
+	FIELD(INJECTED_EVENT_DATA, injected_event_data),
 	FIELD(VM_ENTRY_INSTRUCTION_LEN, vm_entry_instruction_len),
 	FIELD(TPR_THRESHOLD, tpr_threshold),
 	FIELD(SECONDARY_VM_EXEC_CONTROL, secondary_vm_exec_control),
@@ -89,6 +90,7 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(VM_EXIT_INTR_ERROR_CODE, vm_exit_intr_error_code),
 	FIELD(IDT_VECTORING_INFO_FIELD, idt_vectoring_info_field),
 	FIELD(IDT_VECTORING_ERROR_CODE, idt_vectoring_error_code),
+	FIELD(ORIGINAL_EVENT_DATA, original_event_data),
 	FIELD(VM_EXIT_INSTRUCTION_LEN, vm_exit_instruction_len),
 	FIELD(VMX_INSTRUCTION_INFO, vmx_instruction_info),
 	FIELD(GUEST_ES_LIMIT, guest_es_limit),
@@ -152,5 +154,21 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip),
 	FIELD(HOST_RSP, host_rsp),
 	FIELD(HOST_RIP, host_rip),
+	FIELD(GUEST_IA32_FRED_CONFIG, guest_ia32_fred_config),
+	FIELD(GUEST_IA32_FRED_RSP1, guest_ia32_fred_rsp1),
+	FIELD(GUEST_IA32_FRED_RSP2, guest_ia32_fred_rsp2),
+	FIELD(GUEST_IA32_FRED_RSP3, guest_ia32_fred_rsp3),
+	FIELD(GUEST_IA32_FRED_STKLVLS, guest_ia32_fred_stklvls),
+	FIELD(GUEST_IA32_FRED_SSP1, guest_ia32_fred_ssp1),
+	FIELD(GUEST_IA32_FRED_SSP2, guest_ia32_fred_ssp2),
+	FIELD(GUEST_IA32_FRED_SSP3, guest_ia32_fred_ssp3),
+	FIELD(HOST_IA32_FRED_CONFIG, host_ia32_fred_config),
+	FIELD(HOST_IA32_FRED_RSP1, host_ia32_fred_rsp1),
+	FIELD(HOST_IA32_FRED_RSP2, host_ia32_fred_rsp2),
+	FIELD(HOST_IA32_FRED_RSP3, host_ia32_fred_rsp3),
+	FIELD(HOST_IA32_FRED_STKLVLS, host_ia32_fred_stklvls),
+	FIELD(HOST_IA32_FRED_SSP1, host_ia32_fred_ssp1),
+	FIELD(HOST_IA32_FRED_SSP2, host_ia32_fred_ssp2),
+	FIELD(HOST_IA32_FRED_SSP3, host_ia32_fred_ssp3),
 };
 const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs12_field_offsets);
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 1fe3ed9108aa..f2a33d7007c9 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -186,6 +186,24 @@ struct __packed vmcs12 {
 	u16 host_tr_selector;
 	u16 guest_pml_index;
 	u64 secondary_vm_exit_controls;
+	u64 guest_ia32_fred_config;
+	u64 guest_ia32_fred_rsp1;
+	u64 guest_ia32_fred_rsp2;
+	u64 guest_ia32_fred_rsp3;
+	u64 guest_ia32_fred_stklvls;
+	u64 guest_ia32_fred_ssp1;
+	u64 guest_ia32_fred_ssp2;
+	u64 guest_ia32_fred_ssp3;
+	u64 host_ia32_fred_config;
+	u64 host_ia32_fred_rsp1;
+	u64 host_ia32_fred_rsp2;
+	u64 host_ia32_fred_rsp3;
+	u64 host_ia32_fred_stklvls;
+	u64 host_ia32_fred_ssp1;
+	u64 host_ia32_fred_ssp2;
+	u64 host_ia32_fred_ssp3;
+	u64 injected_event_data;
+	u64 original_event_data;
 };
 
 /*
@@ -362,6 +380,24 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_tr_selector, 994);
 	CHECK_OFFSET(guest_pml_index, 996);
 	CHECK_OFFSET(secondary_vm_exit_controls, 998);
+	CHECK_OFFSET(guest_ia32_fred_config, 1006);
+	CHECK_OFFSET(guest_ia32_fred_rsp1, 1014);
+	CHECK_OFFSET(guest_ia32_fred_rsp2, 1022);
+	CHECK_OFFSET(guest_ia32_fred_rsp3, 1030);
+	CHECK_OFFSET(guest_ia32_fred_stklvls, 1038);
+	CHECK_OFFSET(guest_ia32_fred_ssp1, 1046);
+	CHECK_OFFSET(guest_ia32_fred_ssp2, 1054);
+	CHECK_OFFSET(guest_ia32_fred_ssp3, 1062);
+	CHECK_OFFSET(host_ia32_fred_config, 1070);
+	CHECK_OFFSET(host_ia32_fred_rsp1, 1078);
+	CHECK_OFFSET(host_ia32_fred_rsp2, 1086);
+	CHECK_OFFSET(host_ia32_fred_rsp3, 1094);
+	CHECK_OFFSET(host_ia32_fred_stklvls, 1102);
+	CHECK_OFFSET(host_ia32_fred_ssp1, 1110);
+	CHECK_OFFSET(host_ia32_fred_ssp2, 1118);
+	CHECK_OFFSET(host_ia32_fred_ssp3, 1126);
+	CHECK_OFFSET(injected_event_data, 1134);
+	CHECK_OFFSET(original_event_data, 1142);
 }
 
 extern const unsigned short vmcs12_field_offsets[];
diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index 53b64dce1309..607945ada35f 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -86,6 +86,10 @@ SHADOW_FIELD_RW(HOST_GS_BASE, host_gs_base)
 /* 64-bit */
 SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS, guest_physical_address)
 SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS_HIGH, guest_physical_address)
+__SHADOW_FIELD_RO(ORIGINAL_EVENT_DATA, original_event_data, cpu_has_vmx_fred())
+__SHADOW_FIELD_RO(ORIGINAL_EVENT_DATA_HIGH, original_event_data, cpu_has_vmx_fred())
+__SHADOW_FIELD_RW(INJECTED_EVENT_DATA, injected_event_data, cpu_has_vmx_fred())
+__SHADOW_FIELD_RW(INJECTED_EVENT_DATA_HIGH, injected_event_data, cpu_has_vmx_fred())
 
 #undef SHADOW_FIELD_RO
 #undef SHADOW_FIELD_RW
-- 
2.46.2


