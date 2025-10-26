Return-Path: <kvm+bounces-61121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34861C0B2AB
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 21:26:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 331803B9B84
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 20:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A808A303C97;
	Sun, 26 Oct 2025 20:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Q8XqUnx7"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245232EBDF4;
	Sun, 26 Oct 2025 20:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510034; cv=none; b=l35LAPFefJGL2/piX6IM+HUTxz0zBhWmTrFCLOoZlSW0g3ZeWU/Z/1GRzm/2TQJ79nuE8GwV0yp0xGocjNynSDXa18HFmFvdbFKRMiQOy/zvjqJRqUmYJ41vrpepWAiAwpSkaIxx8NyuAwXyEaANRl3Y7BykISIbgYThtF04Cps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510034; c=relaxed/simple;
	bh=usATtJoAW2DjYy4WMdxPU58cZPLHa4pNtDH3XhomhTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqwgcTWTxYru6jJYBMfsvh6LABXc5XKU5jCBirSnqXqmnLacblE1PNFARHxSnDg76a/l2Mo5b1TUaiOAfTO9PvMAk7SmjXA6spt9u4EeIROhJFi6PTIJuT/c2GNNxVkJhklDZ9jner225LymJyv80BSk5faY0/S057tu4Xe4oQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Q8XqUnx7; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QKJBkI505258
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 13:19:20 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QKJBkI505258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761509960;
	bh=Oxf/C0ceWCqTmwQQ6Icav1Tcjem/oXFszHXOadP+T0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8XqUnx79hNeGx6z7Ob9gE7c0JWJxA0kvsNrVUTrTHd4E+SW0P+R7EsQCOUFheCFZ
	 ogk0Ibrj6ZvvQ55ABfQfwzMm59LVm+tim2IRO1W9aZvdu1SqBTd2D2nWp+nnv/jt1s
	 nAVnNNj1b08pekgBbemHWLegKSQ7RuSv+vnqKfScyDaSqztZ5fiwEO1uEf0VJbLazO
	 HwMAOWspuJIKqfO0w5RrECi4t/zJXR6LGCj66AnkO5Z3RqdKCGnLvJFuGUwTpFzN27
	 IHAG43g68da7AMp6oTFEfnYb8vRoQE1mbVfysv0PflYO2PS7JbSBcTTFQyiRQWJvim
	 1FJGZyRzJ6/fg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org, sohil.mehta@intel.com
Subject: [PATCH v9 01/22] KVM: VMX: Enable support for secondary VM exit controls
Date: Sun, 26 Oct 2025 13:18:49 -0700
Message-ID: <20251026201911.505204-2-xin@zytor.com>
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

Introduce infrastructure to support secondary VM exit controls.

Always load the controls when supported by hardware, though all control
bits remain clear in this patch.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5:
* Add TB from Xuelian Guo.

Changes in v4:
* Fix clearing VM_EXIT_ACTIVATE_SECONDARY_CONTROLS (Chao Gao).
* Check VM exit/entry consistency based on the new macro from Sean
  Christopherson.

Change in v3:
* Do FRED controls consistency checks in the VM exit/entry consistency
  check framework (Sean Christopherson).

Change in v2:
* Always load the secondary VM exit controls (Sean Christopherson).
---
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/include/asm/vmx.h       |  3 +++
 arch/x86/kvm/vmx/capabilities.h  |  9 ++++++++-
 arch/x86/kvm/vmx/vmcs.h          |  1 +
 arch/x86/kvm/vmx/vmx.c           | 29 +++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h           |  7 ++++++-
 6 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 9e1720d73244..baf5e1648418 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1225,6 +1225,7 @@
 #define MSR_IA32_VMX_TRUE_ENTRY_CTLS     0x00000490
 #define MSR_IA32_VMX_VMFUNC             0x00000491
 #define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
+#define MSR_IA32_VMX_EXIT_CTLS2		0x00000493
 
 /* Resctrl MSRs: */
 /* - Intel: */
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index c85c50019523..1f60c04d11fb 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -107,6 +107,7 @@
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
 #define VM_EXIT_LOAD_CET_STATE                  0x10000000
+#define VM_EXIT_ACTIVATE_SECONDARY_CONTROLS	0x80000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -262,6 +263,8 @@ enum vmcs_field {
 	SHARED_EPT_POINTER		= 0x0000203C,
 	PID_POINTER_TABLE		= 0x00002042,
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
+	SECONDARY_VM_EXIT_CONTROLS	= 0x00002044,
+	SECONDARY_VM_EXIT_CONTROLS_HIGH	= 0x00002045,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
 	VMCS_LINK_POINTER               = 0x00002800,
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 02aadb9d730e..6bd67c40ca3b 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -55,8 +55,9 @@ struct vmcs_config {
 	u32 cpu_based_exec_ctrl;
 	u32 cpu_based_2nd_exec_ctrl;
 	u64 cpu_based_3rd_exec_ctrl;
-	u32 vmexit_ctrl;
 	u32 vmentry_ctrl;
+	u32 vmexit_ctrl;
+	u64 vmexit_2nd_ctrl;
 	u64 misc;
 	struct nested_vmx_msrs nested;
 };
@@ -141,6 +142,12 @@ static inline bool cpu_has_tertiary_exec_ctrls(void)
 		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 }
 
+static inline bool cpu_has_secondary_vmexit_ctrls(void)
+{
+	return vmcs_config.vmexit_ctrl &
+		VM_EXIT_ACTIVATE_SECONDARY_CONTROLS;
+}
+
 static inline bool cpu_has_vmx_virtualize_apic_accesses(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index b25625314658..ae152a9d1963 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -47,6 +47,7 @@ struct vmcs_host_state {
 struct vmcs_controls_shadow {
 	u32 vm_entry;
 	u32 vm_exit;
+	u64 secondary_vm_exit;
 	u32 pin;
 	u32 exec;
 	u32 secondary_exec;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1021d3b65ea0..8de841c9c905 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2595,8 +2595,9 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	u32 _cpu_based_exec_control = 0;
 	u32 _cpu_based_2nd_exec_control = 0;
 	u64 _cpu_based_3rd_exec_control = 0;
-	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
+	u32 _vmexit_control = 0;
+	u64 _vmexit2_control = 0;
 	u64 basic_msr;
 	u64 misc_msr;
 
@@ -2617,6 +2618,12 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
 	};
 
+	struct {
+		u32 entry_control;
+		u64 exit_control;
+	} const vmcs_entry_exit2_pairs[] = {
+	};
+
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
 
 	if (adjust_vmx_controls(KVM_REQUIRED_VMX_CPU_BASED_VM_EXEC_CONTROL,
@@ -2703,10 +2710,19 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				&_vmentry_control))
 		return -EIO;
 
+	if (_vmexit_control & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS)
+		_vmexit2_control =
+			adjust_vmx_controls64(KVM_OPTIONAL_VMX_SECONDARY_VM_EXIT_CONTROLS,
+					      MSR_IA32_VMX_EXIT_CTLS2);
+
 	if (vmx_check_entry_exit_pairs(vmcs_entry_exit_pairs,
 				       _vmentry_control, _vmexit_control))
 		return -EIO;
 
+	if (vmx_check_entry_exit_pairs(vmcs_entry_exit2_pairs,
+				       _vmentry_control, _vmexit2_control))
+		return -EIO;
+
 	/*
 	 * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
 	 * can't be used due to an errata where VM Exit may incorrectly clear
@@ -2755,8 +2771,9 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
 	vmcs_conf->cpu_based_2nd_exec_ctrl = _cpu_based_2nd_exec_control;
 	vmcs_conf->cpu_based_3rd_exec_ctrl = _cpu_based_3rd_exec_control;
-	vmcs_conf->vmexit_ctrl         = _vmexit_control;
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
+	vmcs_conf->vmexit_ctrl         = _vmexit_control;
+	vmcs_conf->vmexit_2nd_ctrl     = _vmexit2_control;
 	vmcs_conf->misc	= misc_msr;
 
 #if IS_ENABLED(CONFIG_HYPERV)
@@ -4429,6 +4446,11 @@ static u32 vmx_get_initial_vmexit_ctrl(void)
 		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
 }
 
+static u64 vmx_secondary_vmexit_ctrl(void)
+{
+	return vmcs_config.vmexit_2nd_ctrl;
+}
+
 void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -4771,6 +4793,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 
 	vm_exit_controls_set(vmx, vmx_get_initial_vmexit_ctrl());
 
+	if (cpu_has_secondary_vmexit_ctrls())
+		secondary_vm_exit_controls_set(vmx, vmx_secondary_vmexit_ctrl());
+
 	/* 22.2.1, 20.8.1 */
 	vm_entry_controls_set(vmx, vmx_get_initial_vmentry_ctrl());
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6cb04a6afeef..349d96e68f96 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -510,7 +510,11 @@ static inline u8 vmx_get_rvi(void)
 	       VM_EXIT_CLEAR_BNDCFGS |					\
 	       VM_EXIT_PT_CONCEAL_PIP |					\
 	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
-	       VM_EXIT_LOAD_CET_STATE)
+	       VM_EXIT_LOAD_CET_STATE |					\
+	       VM_EXIT_ACTIVATE_SECONDARY_CONTROLS)
+
+#define KVM_REQUIRED_VMX_SECONDARY_VM_EXIT_CONTROLS (0)
+#define KVM_OPTIONAL_VMX_SECONDARY_VM_EXIT_CONTROLS (0)
 
 #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
 	(PIN_BASED_EXT_INTR_MASK |					\
@@ -623,6 +627,7 @@ static __always_inline void lname##_controls_changebit(struct vcpu_vmx *vmx, u##
 }
 BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
 BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS, 32)
+BUILD_CONTROLS_SHADOW(secondary_vm_exit, SECONDARY_VM_EXIT_CONTROLS, 64)
 BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL, 32)
 BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL, 32)
 BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL, 32)
-- 
2.51.0


