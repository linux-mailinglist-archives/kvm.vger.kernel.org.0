Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD5D396F77
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbhFAIuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:50:35 -0400
Received: from mga07.intel.com ([134.134.136.100]:45201 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233922AbhFAIuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 04:50:19 -0400
IronPort-SDR: 0BmBQhEOOB1ACZqI7ysr7E889h6gMJBXN4ow3cRa/IfZOE5Y1YBTfliOrQ6Kk4LqrLDQ9HA9wF
 iHa/q2yM0UuA==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267381405"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267381405"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:48:21 -0700
IronPort-SDR: gZGos9obolz22FwzcztTsS14KM/KJODpjvKtpIppsMoovPuaK3iYWNEinlQthuMyargxwdKBvJ
 R/t6w+pa4rvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="437967812"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2021 01:48:18 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, robert.hu@intel.com,
        robert.hu@linux.intel.com
Subject: [PATCH 08/15] kvm/vmx: Add KVM support on guest Key Locker operations
Date:   Tue,  1 Jun 2021 16:47:47 +0800
Message-Id: <1622537274-146420-9-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
References: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't clear CPU_BASED_ACTIVATE_TERTIARY_CONTROLS in vmx_exec_control(), as
we really need it now.

Enable and implement handle_loadiwkey() VM-Exit handler, which fetches
guest IWKey and do it onbehalf. Other Key Locker instructions can
execute in non-root mode.
(Note: till this patch, we haven't expose Key Locker feature
to guest yet, guest Kernel won't set CR4.KL, if guest deliberately
execute Key Locker instructions, it will get #UD, instead of VM-Exit.)

We load guest's IWKey when load vcpu, even if it is NULL (guest doesn't
support/enable Key Locker), to flush last vcpu's IWKey, which is possibly
another VM's.
We flush guest's IWKey (loadiwkey with all 0) when put vcpu.

Trap guest write on MSRs of IA32_COPY_LOCAL_TO_PLATFORM and
IA32_COPY_PLATFORM_TO_LOCAL_TO_PLATFORM, emulate IWKey save and restore
operations.

Trap guest read on MSRs of IA32_COPY_STATUS and
IA32_IWKEYBACKUP_STATUS, return their shadow values.

Analogous to adjust_vmx_controls(), we define the adjust_vmx_controls_64()
auxiliary function, for MSR_IA32_VMX_PROCBASED_CTLS3 is 64bit allow-1
semantics, different from previous VMX capability MSRs, which were 32bit
allow-0 and 32bit allow-1.

Also, define a helper get_xmm(), which per input index fetches an xmm
value. VM-Exit of LOADIWKEY saves IWKey.encryption_key in some 2 xmm regs,
and LOADIWKEY itself implicitly uses xmm0~2 as input. This helper
facilitates xmm value's save/restore.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  22 ++++
 arch/x86/include/asm/vmx.h      |   6 +
 arch/x86/include/uapi/asm/vmx.h |   2 +
 arch/x86/kvm/vmx/vmx.c          | 249 +++++++++++++++++++++++++++++++++++++++-
 4 files changed, 276 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cbbcee0..4b929dc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -558,6 +558,19 @@ struct kvm_vcpu_xen {
 	u64 runstate_times[4];
 };
 
+#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(CONFIG_CC_HAS_INT128)
+typedef unsigned __int128 u128;
+#else
+typedef struct {
+	u64 reg64[2];
+} u128;
+#endif
+
+struct iwkey {
+	u128 encryption_key[2]; /* 256bit encryption key */
+	u128 integrity_key;  /* 128bit integration key */
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -849,6 +862,11 @@ struct kvm_vcpu_arch {
 
 	/* Protected Guests */
 	bool guest_state_protected;
+
+	/* Intel KeyLocker */
+	bool iwkey_loaded;
+	struct iwkey iwkey;
+	u32 msr_ia32_copy_status;
 };
 
 struct kvm_lpage_info {
@@ -1003,6 +1021,10 @@ struct kvm_arch {
 	bool apic_access_page_done;
 	unsigned long apicv_inhibit_reasons;
 
+	bool iwkey_backup_valid;
+	u32  msr_ia32_iwkey_backup_status;
+	struct iwkey iwkey_backup;
+
 	gpa_t wall_clock;
 
 	bool mwait_in_guest;
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index dc549e3..71ac797 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -76,6 +76,12 @@
 #define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
 #define SECONDARY_EXEC_BUS_LOCK_DETECTION	VMCS_CONTROL_BIT(BUS_LOCK_DETECTION)
 
+/*
+ * Definitions of Tertiary Processor-Based VM-Execution Controls.
+ */
+#define TERTIARY_EXEC_LOADIWKEY_EXITING         VMCS_CONTROL_BIT(LOADIWKEY_EXITING)
+
+
 #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
 #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
 #define PIN_BASED_VIRTUAL_NMIS                  VMCS_CONTROL_BIT(VIRTUAL_NMIS)
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 946d761..25ab849 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -90,6 +90,7 @@
 #define EXIT_REASON_XRSTORS             64
 #define EXIT_REASON_UMWAIT              67
 #define EXIT_REASON_TPAUSE              68
+#define EXIT_REASON_LOADIWKEY           69
 #define EXIT_REASON_BUS_LOCK            74
 
 #define VMX_EXIT_REASONS \
@@ -153,6 +154,7 @@
 	{ EXIT_REASON_XRSTORS,               "XRSTORS" }, \
 	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
 	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
+	{ EXIT_REASON_LOADIWKEY,             "LOADIWKEY" }, \
 	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }
 
 #define VMX_EXIT_REASON_FLAGS \
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index afcf1e0..752b1e4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -47,6 +47,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
+#include <asm/keylocker.h>
 
 #include "capabilities.h"
 #include "cpuid.h"
@@ -1220,6 +1221,140 @@ void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 	}
 }
 
+static int get_xmm(int index, u128 *mem_ptr)
+{
+	int ret = 0;
+
+	switch (index) {
+	case 0:
+		asm ("movdqu %%xmm0, %0" : : "m"(*mem_ptr));
+		break;
+	case 1:
+		asm ("movdqu %%xmm1, %0" : : "m"(*mem_ptr));
+		break;
+	case 2:
+		asm ("movdqu %%xmm2, %0" : : "m"(*mem_ptr));
+		break;
+	case 3:
+		asm ("movdqu %%xmm3, %0" : : "m"(*mem_ptr));
+		break;
+	case 4:
+		asm ("movdqu %%xmm4, %0" : : "m"(*mem_ptr));
+		break;
+	case 5:
+		asm ("movdqu %%xmm5, %0" : : "m"(*mem_ptr));
+		break;
+	case 6:
+		asm ("movdqu %%xmm6, %0" : : "m"(*mem_ptr));
+		break;
+	case 7:
+		asm ("movdqu %%xmm7, %0" : : "m"(*mem_ptr));
+		break;
+#ifdef CONFIG_X86_64
+	case 8:
+		asm ("movdqu %%xmm8, %0" : : "m"(*mem_ptr));
+		break;
+	case 9:
+		asm ("movdqu %%xmm9, %0" : : "m"(*mem_ptr));
+		break;
+	case 10:
+		asm ("movdqu %%xmm10, %0" : : "m"(*mem_ptr));
+		break;
+	case 11:
+		asm ("movdqu %%xmm11, %0" : : "m"(*mem_ptr));
+		break;
+	case 12:
+		asm ("movdqu %%xmm12, %0" : : "m"(*mem_ptr));
+		break;
+	case 13:
+		asm ("movdqu %%xmm13, %0" : : "m"(*mem_ptr));
+		break;
+	case 14:
+		asm ("movdqu %%xmm14, %0" : : "m"(*mem_ptr));
+		break;
+	case 15:
+		asm ("movdqu %%xmm15, %0" : : "m"(*mem_ptr));
+		break;
+#endif
+	default:
+		WARN(1, "xmm index exceeds");
+		ret = -1;
+		break;
+	}
+
+	return ret;
+}
+
+static void vmx_load_guest_iwkey(struct kvm_vcpu *vcpu)
+{
+	u128 xmm[3] = {0};
+	int ret;
+
+	/*
+	 * By current design, Guest and Host can only exclusively
+	 * use Key Locker. We can assert that CR4.KL is 0 here,
+	 * otherwise, it's abnormal and worth a warn.
+	 */
+	if (cr4_read_shadow() & X86_CR4_KEYLOCKER) {
+		WARN(1, "Host is using Key Locker, "
+		     "guest should not use it");
+		return;
+	}
+
+	cr4_set_bits(X86_CR4_KEYLOCKER);
+
+	/* Save origin %xmm */
+	get_xmm(0, &xmm[0]);
+	get_xmm(1, &xmm[1]);
+	get_xmm(2, &xmm[2]);
+
+	asm ("movdqu %0, %%xmm0;"
+	     "movdqu %1, %%xmm1;"
+	     "movdqu %2, %%xmm2;"
+	     : : "m"(vcpu->arch.iwkey.integrity_key),
+	     "m"(vcpu->arch.iwkey.encryption_key[0]),
+	     "m"(vcpu->arch.iwkey.encryption_key[1]));
+
+	ret = loadiwkey(KEYSRC_SWRAND);
+	/* restore %xmm */
+	asm ("movdqu %0, %%xmm0;"
+	     "movdqu %1, %%xmm1;"
+	     "movdqu %2, %%xmm2;"
+	     : : "m"(xmm[0]),
+	     "m"(xmm[1]),
+	     "m"(xmm[2]));
+
+	cr4_clear_bits(X86_CR4_KEYLOCKER);
+}
+
+static void vmx_clear_guest_iwkey(void)
+{
+	u128 xmm[3] = {0};
+	u128 zero = 0;
+	int ret;
+
+	cr4_set_bits(X86_CR4_KEYLOCKER);
+	/* Save origin %xmm */
+	get_xmm(0, &xmm[0]);
+	get_xmm(1, &xmm[1]);
+	get_xmm(2, &xmm[2]);
+
+	asm volatile ("movdqu %0, %%xmm0; movdqu %0, %%xmm1; movdqu %0, %%xmm2;"
+		      :: "m"(zero));
+
+	ret = loadiwkey(KEYSRC_SWRAND);
+
+	/* restore %xmm */
+	asm ("movdqu %0, %%xmm0;"
+	     "movdqu %1, %%xmm1;"
+	     "movdqu %2, %%xmm2;"
+	     : : "m"(xmm[0]),
+	     "m"(xmm[1]),
+	     "m"(xmm[2]));
+
+	cr4_clear_bits(X86_CR4_KEYLOCKER);
+}
+
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1430,6 +1565,8 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	vmx_vcpu_pi_load(vcpu, cpu);
 
+	vmx_load_guest_iwkey(vcpu);
+
 	vmx->host_debugctlmsr = get_debugctlmsr();
 }
 
@@ -1437,6 +1574,8 @@ static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	vmx_vcpu_pi_put(vcpu);
 
+	vmx_clear_guest_iwkey();
+
 	vmx_prepare_switch_to_host(to_vmx(vcpu));
 }
 
@@ -2001,6 +2140,19 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
+	case MSR_IA32_COPY_STATUS:
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_KEYLOCKER))
+			return 1;
+
+		msr_info->data = vcpu->arch.msr_ia32_copy_status;
+	break;
+
+	case MSR_IA32_IWKEYBACKUP_STATUS:
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_KEYLOCKER))
+			return 1;
+
+		msr_info->data = vcpu->kvm->arch.msr_ia32_iwkey_backup_status;
+	break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2313,6 +2465,36 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_IA32_COPY_LOCAL_TO_PLATFORM:
+		if (msr_info->data != 1)
+			return 1;
+
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_KEYLOCKER))
+			return 1;
+
+		if (!vcpu->arch.iwkey_loaded)
+			return 1;
+
+		if (!vcpu->kvm->arch.iwkey_backup_valid) {
+			vcpu->kvm->arch.iwkey_backup = vcpu->arch.iwkey;
+			vcpu->kvm->arch.iwkey_backup_valid = true;
+			vcpu->kvm->arch.msr_ia32_iwkey_backup_status = 0x9;
+		}
+		vcpu->arch.msr_ia32_copy_status = 1;
+		break;
+
+	case MSR_IA32_COPY_PLATFORM_TO_LOCAL:
+		if (msr_info->data != 1)
+			return 1;
+
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_KEYLOCKER))
+			return 1;
+		if (!vcpu->kvm->arch.iwkey_backup_valid)
+			return 1;
+		vcpu->arch.iwkey = vcpu->kvm->arch.iwkey_backup;
+		vcpu->arch.msr_ia32_copy_status = 1;
+		break;
+
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
@@ -2498,6 +2680,23 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 	return 0;
 }
 
+static __init int adjust_vmx_controls_64(u64 ctl_min, u64 ctl_opt,
+					  u32 msr, u64 *result)
+{
+	u64 vmx_msr;
+	u64 ctl = ctl_min | ctl_opt;
+
+	rdmsrl(msr, vmx_msr);
+	ctl &= vmx_msr; /* bit == 1 means it can be set */
+
+	/* Ensure minimum (required) set of control bits are supported. */
+	if (ctl_min & ~ctl)
+		return -EIO;
+
+	*result = ctl;
+	return 0;
+}
+
 static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				    struct vmx_capability *vmx_cap)
 {
@@ -2603,6 +2802,16 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				"1-setting enable VPID VM-execution control\n");
 	}
 
+	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
+		u64 opt3 = TERTIARY_EXEC_LOADIWKEY_EXITING;
+		u64 min3 = 0;
+
+		if (adjust_vmx_controls_64(min3, opt3,
+					   MSR_IA32_VMX_PROCBASED_CTLS3,
+					   &_cpu_based_3rd_exec_control))
+			return -EIO;
+	}
+
 	min = VM_EXIT_SAVE_DEBUG_CONTROLS | VM_EXIT_ACK_INTR_ON_EXIT;
 #ifdef CONFIG_X86_64
 	min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
@@ -4255,9 +4464,6 @@ u32 vmx_exec_control(struct vcpu_vmx *vmx)
 				CPU_BASED_MONITOR_EXITING);
 	if (kvm_hlt_in_guest(vmx->vcpu.kvm))
 		exec_control &= ~CPU_BASED_HLT_EXITING;
-
-	/* Disable Tertiary-Exec Control at this moment, as no feature used yet */
-	exec_control &= ~CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 	return exec_control;
 }
 
@@ -5656,6 +5862,42 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int handle_loadiwkey(struct kvm_vcpu *vcpu)
+{
+	u128 xmm[3] = {0};
+	u32 vmx_instruction_info;
+	int reg1, reg2;
+	int r;
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_KEYLOCKER)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	reg1 = (vmx_instruction_info & 0x78) >> 3;
+	reg2 = (vmx_instruction_info >> 28) & 0xf;
+
+	r = get_xmm(0, &xmm[0]);
+	if (r)
+		return 0;
+	r = get_xmm(reg1, &xmm[1]);
+	if (r)
+		return 0;
+	r = get_xmm(reg2, &xmm[2]);
+	if (r)
+		return 0;
+
+	vcpu->arch.iwkey.integrity_key = xmm[0];
+	vcpu->arch.iwkey.encryption_key[0] = xmm[1];
+	vcpu->arch.iwkey.encryption_key[1] = xmm[2];
+	vcpu->arch.iwkey_loaded = true;
+
+	vmx_load_guest_iwkey(vcpu);
+
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5713,6 +5955,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
 	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
+	[EXIT_REASON_LOADIWKEY]               = handle_loadiwkey,
 };
 
 static const int kvm_vmx_max_exit_handlers =
-- 
1.8.3.1

