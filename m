Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87435303404
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbhAZFMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:12:16 -0500
Received: from mga14.intel.com ([192.55.52.115]:22894 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbhAYJPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:15:23 -0500
IronPort-SDR: AhLtlsn/xLXvbzYQiGwP/S80szn8cQqKdNW0BfmxaQgYJ1ajuuJaG/9Wq9fZTTULhxdNHl9mYm
 unMQ0NR1y/Ug==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="178915795"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="178915795"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:07:11 -0800
IronPort-SDR: 1IpE4DRsdRIrpVeGyrp262CYRHQ8Qlu3vD47nBx1ApFJajCJvJhRL2V4+1RmBAzX3ms9V0xXcy
 9356pH//dQHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="402223871"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2021 01:07:09 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 05/12] kvm/vmx: Add KVM support on KeyLocker operations
Date:   Mon, 25 Jan 2021 17:06:13 +0800
Message-Id: <1611565580-47718-6-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define handle_loadiwkey() VM-Exit handler, which fetch the IWKey guest's
setting and do it onbehalf. Note LOADIWKEY needs CR4.KeyLocker set.
Trap guest write on MSRs of IA32_COPY_LOCAL_TO_PLATFORM and
IA32_COPY_PLATFORM_TO_LOCAL_TO_PLATFORM, emulate IWKey save and restore
operations.
Trap guest read on MSRs of IA32_COPY_STATUS and IA32_IWKEYBACKUP_STATUS,
return their shadow values stored in kvm_vcpu_arch and kvm_arch.
Also, guest CPUID.0x19:EBX[0] is dynamic, its status changes as CR4.KL
changes.
On each VM-Entry, we need to resotre vCPU's IWKey, stored in kvm_vcpu_arch.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  24 ++++-
 arch/x86/kvm/cpuid.c            |  11 +++
 arch/x86/kvm/cpuid.h            |   2 +
 arch/x86/kvm/vmx/vmx.c          | 189 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |   4 +-
 arch/x86/kvm/x86.h              |   2 +
 6 files changed, 229 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7e5f33a..dc09142 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -100,7 +100,7 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP | X86_CR4_KEYLOCKER))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
@@ -520,6 +520,19 @@ struct kvm_vcpu_hv {
 	cpumask_t tlb_flush;
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
@@ -805,6 +818,11 @@ struct kvm_vcpu_arch {
 		 */
 		bool enforce;
 	} pv_cpuid;
+
+	/* Intel KeyLocker */
+	bool iwkey_loaded;
+	struct iwkey iwkey;
+	u32 msr_ia32_copy_status;
 };
 
 struct kvm_lpage_info {
@@ -931,6 +949,10 @@ struct kvm_arch {
 	bool apic_access_page_done;
 	unsigned long apicv_inhibit_reasons;
 
+	bool iwkey_backup_valid;
+	u32  msr_ia32_iwkey_backup_status;
+	struct iwkey iwkey_backup;
+
 	gpa_t wall_clock;
 
 	bool mwait_in_guest;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 83637a2..2fbf4af 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -133,6 +133,12 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
+	/* update CPUID.0x19.EBX[0], depends on CR4.KL */
+	best = kvm_find_cpuid_entry(vcpu, 0x19, 0);
+	if (best)
+		cpuid_entry_change(best, X86_FEATURE_KL_INS_ENABLED,
+					kvm_read_cr4_bits(vcpu, X86_CR4_KEYLOCKER));
+
 	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
@@ -407,6 +413,11 @@ void kvm_set_cpu_caps(void)
 	if (cpuid_ecx(7) & F(LA57))
 		kvm_cpu_cap_set(X86_FEATURE_LA57);
 
+	/* At present, host and guest can only exclusively use KeyLocker */
+	if (!boot_cpu_has(X86_FEATURE_KEYLOCKER) && (cpuid_ecx(0x7) &
+		feature_bit(KEYLOCKER)))
+		kvm_cpu_cap_set(X86_FEATURE_KEYLOCKER);
+
 	/*
 	 * PKU not yet implemented for shadow paging and requires OSPKE
 	 * to be set on the host. Clear it if that is not the case
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index f7a6e8f..639c647 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -63,6 +63,8 @@ struct cpuid_reg {
 	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
+	[CPUID_19_EBX]	      = {      0x19, 0, CPUID_EBX},
+	[CPUID_19_ECX]	      = {      0x19, 0, CPUID_ECX},
 };
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d01bbb4..6be6d87 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -47,6 +47,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
+#include <asm/keylocker.h>
 
 #include "capabilities.h"
 #include "cpuid.h"
@@ -1192,6 +1193,106 @@ void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 	}
 }
 
+static int get_xmm(int index, u128 *mem_ptr)
+{
+	int ret = 0;
+
+	asm ("cli");
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
+		pr_err_once("xmm index exceeds");
+		ret = -1;
+		break;
+	}
+	asm ("sti");
+
+	return ret;
+}
+
+static void vmx_load_guest_iwkey(struct kvm_vcpu *vcpu)
+{
+	u128 xmm[3] = {0};
+
+	if (vcpu->arch.iwkey_loaded) {
+		bool clear_cr4 = false;
+		/* Save origin %xmm */
+		get_xmm(0, &xmm[0]);
+		get_xmm(1, &xmm[1]);
+		get_xmm(2, &xmm[2]);
+
+		asm ("movdqu %0, %%xmm0;"
+		     "movdqu %1, %%xmm1;"
+		     "movdqu %2, %%xmm2;"
+		     : : "m"(vcpu->arch.iwkey.integrity_key),
+		     "m"(vcpu->arch.iwkey.encryption_key[0]),
+		     "m"(vcpu->arch.iwkey.encryption_key[1]));
+		if (!(cr4_read_shadow() & X86_CR4_KEYLOCKER)) {
+			cr4_set_bits(X86_CR4_KEYLOCKER);
+			clear_cr4 = true;
+		}
+		asm volatile(LOADIWKEY : : "a" (0x0));
+		if (clear_cr4)
+			cr4_clear_bits(X86_CR4_KEYLOCKER);
+		/* restore %xmm */
+		asm ("movdqu %0, %%xmm0;"
+		     "movdqu %1, %%xmm1;"
+		     "movdqu %2, %%xmm2;"
+		     : : "m"(xmm[0]),
+		     "m"(xmm[1]),
+		     "m"(xmm[2]));
+	}
+}
+
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1260,6 +1361,9 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 #endif
 
 	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
+
+	vmx_load_guest_iwkey(vcpu);
+
 	vmx->guest_state_loaded = true;
 }
 
@@ -1925,6 +2029,19 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
 			return 1;
 		goto find_uret_msr;
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
@@ -2189,6 +2306,36 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -5659,6 +5806,47 @@ static int handle_encls(struct kvm_vcpu *vcpu)
 	return 1;
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
+	/*
+	 * vmx instruction info on Current TGL is broken.
+	 * Before the microcode fix, we hardcode XMM1 & XMM2 holding
+	 * IWKey.encryption_key.
+	 */
+	reg1 = 1;
+	reg2 = 2;
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
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5715,6 +5903,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
+	[EXIT_REASON_LOADIWKEY]               = handle_loadiwkey,
 };
 
 static const int kvm_vmx_max_exit_handlers =
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e545a8a..fbc839a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1013,7 +1013,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
 		kvm_mmu_reset_context(vcpu);
 
-	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
+	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE | X86_CR4_KEYLOCKER))
 		kvm_update_cpuid_runtime(vcpu);
 
 	return 0;
@@ -9598,7 +9598,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 
 	mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
 	cpuid_update_needed |= ((kvm_read_cr4(vcpu) ^ sregs->cr4) &
-				(X86_CR4_OSXSAVE | X86_CR4_PKE));
+				(X86_CR4_OSXSAVE | X86_CR4_PKE | X86_CR4_KEYLOCKER));
 	kvm_x86_ops.set_cr4(vcpu, sregs->cr4);
 	if (cpuid_update_needed)
 		kvm_update_cpuid_runtime(vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e7ca622..0e6b826 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -404,6 +404,8 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 		__reserved_bits |= X86_CR4_UMIP;        \
 	if (!__cpu_has(__c, X86_FEATURE_VMX))           \
 		__reserved_bits |= X86_CR4_VMXE;        \
+	if (!__cpu_has(__c, X86_FEATURE_KEYLOCKER))		\
+		__reserved_bits |= X86_CR4_KEYLOCKER;	\
 	__reserved_bits;                                \
 })
 
-- 
1.8.3.1

