Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAA41CBCBC
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 05:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgEIDEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 23:04:08 -0400
Received: from mga12.intel.com ([192.55.52.136]:55134 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728802AbgEIDED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 23:04:03 -0400
IronPort-SDR: joa51eO9fAD6H/sThBE8+JHYjhT+Q8zTwb6iqbKmCSTzrQ9tamnXi/+V4P0TJAmK2EBPg6u28U
 6t16k2Eho31Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 20:04:03 -0700
IronPort-SDR: vZ6cOC3RE6+a2TMull6WB4mp3ijT1dgtXYiWb2SVWaHHNPzG6k4B14lnPs1PPieRlJYYn1gBkk
 ZvV3ByEm8ppw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,370,1583222400"; 
   d="scan'208";a="408311104"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga004.jf.intel.com with ESMTP; 08 May 2020 20:03:59 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 7/8] KVM: VMX: virtualize split lock detection
Date:   Sat,  9 May 2020 19:05:41 +0800
Message-Id: <20200509110542.8159-8-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200509110542.8159-1-xiaoyao.li@intel.com>
References: <20200509110542.8159-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TEST_CTRL MSR is per-core scope, i.e., the sibling threads in the same
physical core share the same MSR. This requires additional constraint
when exposing it to guest.

1) When host SLD state is sld_off (no X86_FEATURE_SPLIT_LOCK_DETECT),
   feature split lock detection is unsupported/disabled.
   Cannot expose it to guest.

2) When host SLD state is sld_warn (has X86_FEATURE_SPLIT_LOCK_DETECT
   but no X86_FEATURE_SLD_FATAL), feature split lock detection can be
   exposed to guest only when nosmt due to the per-core scope.

   In this case, guest's setting can be propagated into real hardware
   MSR. Further, to avoid the potiential MSR_TEST_CTRL.SLD toggling
   overhead during every vm-enter and vm-exit, it loads and keeps
   guest's SLD setting when in vcpu run loop and guest_state_loaded,
   i.e., betweer vmx_prepare_switch_to_guest() and
   vmx_prepare_switch_to_host().

3) when host SLD state is sld_fatal (has X86_FEATURE_SLD_FATAL),
   feature split lock detection can be exposed to guest regardless of
   SMT but KVM_HINTS_SLD_FATAL needs to be set.

   In this case, guest can still set and clear MSR_TEST_CTRL.SLD bit,
   but the bit value never be propagated to real MSR. KVM always keeps
   SLD bit turned on for guest vcpu. The reason why not force guest
   MSR_CTRL.SLD bit to 1 is that guest needs to set this bit to 1 itself
   to tell KVM it's SLD-aware.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c   |  6 ++++
 arch/x86/kvm/vmx/vmx.c | 68 ++++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.h |  3 ++
 arch/x86/kvm/x86.c     |  6 +++-
 arch/x86/kvm/x86.h     |  7 +++++
 5 files changed, 80 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 901cd1fdecd9..7d9f2daddaf3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -717,9 +717,15 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
 
+		if (kvm_split_lock_detect_supported())
+			entry->eax |= (1 << KVM_FEATURE_SPLIT_LOCK_DETECT);
+
 		entry->ebx = 0;
 		entry->ecx = 0;
 		entry->edx = 0;
+
+		if (boot_cpu_has(X86_FEATURE_SLD_FATAL))
+			entry->edx |= (1 << KVM_HINTS_SLD_FATAL);
 		break;
 	case 0x80000000:
 		entry->eax = min(entry->eax, 0x8000001f);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dbec38ad5035..1cc386c5801d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1120,6 +1120,29 @@ void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 	}
 }
 
+static inline u64 vmx_msr_test_ctrl_valid_bits(struct vcpu_vmx *vmx)
+{
+	u64 valid_bits = 0;
+
+	if (vmx->guest_has_sld)
+		valid_bits |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+
+	return valid_bits;
+}
+
+static inline bool guest_sld_on(struct vcpu_vmx *vmx)
+{
+	return vmx->msr_test_ctrl & MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+}
+
+static inline void vmx_update_guest_sld(struct vcpu_vmx *vmx)
+{
+	preempt_disable();
+	if (vmx->guest_state_loaded)
+		split_lock_set_guest(guest_sld_on(vmx));
+	preempt_enable();
+}
+
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1188,6 +1211,10 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 #endif
 
 	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
+
+	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) && vmx->guest_has_sld)
+		vmx->host_sld_on = split_lock_set_guest(guest_sld_on(vmx));
+
 	vmx->guest_state_loaded = true;
 }
 
@@ -1226,6 +1253,10 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 #endif
 	load_fixmap_gdt(raw_smp_processor_id());
+
+	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) && vmx->guest_has_sld)
+		split_lock_restore_host(vmx->host_sld_on);
+
 	vmx->guest_state_loaded = false;
 	vmx->guest_msrs_ready = false;
 }
@@ -1790,7 +1821,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr_info->index) {
 	case MSR_TEST_CTRL:
-		msr_info->data = 0;
+		msr_info->data = vmx->msr_test_ctrl;
 		break;
 #ifdef CONFIG_X86_64
 	case MSR_FS_BASE:
@@ -1946,9 +1977,12 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr_index) {
 	case MSR_TEST_CTRL:
-		if (data)
+		if (data & ~vmx_msr_test_ctrl_valid_bits(vmx))
 			return 1;
 
+		vmx->msr_test_ctrl = data;
+		vmx_update_guest_sld(vmx);
+
 		break;
 	case MSR_EFER:
 		ret = kvm_set_msr_common(vcpu, msr_info);
@@ -4266,7 +4300,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmx->rmode.vm86_active = 0;
 	vmx->spec_ctrl = 0;
-
+	vmx->msr_test_ctrl = 0;
 	vmx->msr_ia32_umwait_control = 0;
 
 	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
@@ -4596,24 +4630,32 @@ static int handle_machine_check(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static inline bool guest_alignment_check_enabled(struct kvm_vcpu *vcpu)
+{
+	return vmx_get_cpl(vcpu) == 3 && kvm_read_cr0_bits(vcpu, X86_CR0_AM) &&
+	       (kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
+}
+
 /*
  * If the host has split lock detection disabled, then #AC is
  * unconditionally injected into the guest, which is the pre split lock
  * detection behaviour.
  *
  * If the host has split lock detection enabled then #AC is
- * only injected into the guest when:
- *  - Guest CPL == 3 (user mode)
- *  - Guest has #AC detection enabled in CR0
- *  - Guest EFLAGS has AC bit set
+ * injected into the guest when:
+ * 1) guest has alignment check enabled;
+ * or 2) guest has split lock detection enabled;
  */
 static inline bool guest_inject_ac(struct kvm_vcpu *vcpu)
 {
 	if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
 		return true;
 
-	return vmx_get_cpl(vcpu) == 3 && kvm_read_cr0_bits(vcpu, X86_CR0_AM) &&
-	       (kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
+	/*
+	 * A split lock access must be an unaligned access, so we should check
+	 * guest_cpu_alignent_check_enabled() fisrt.
+	 */
+	return guest_alignment_check_enabled(vcpu) || guest_sld_on(to_vmx(vcpu));
 }
 
 static int handle_exception_nmi(struct kvm_vcpu *vcpu)
@@ -7109,6 +7151,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct kvm_cpuid_entry2 *best;
 
 	/* xsaves_enabled is recomputed in vmx_compute_secondary_exec_control(). */
 	vcpu->arch.xsaves_enabled = false;
@@ -7144,6 +7187,13 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 			vmx_set_guest_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
 		}
 	}
+
+	vmx->guest_has_sld = false;
+	if (kvm_split_lock_detect_supported()) {
+		best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
+		if (best && (best->eax & 1 << KVM_FEATURE_SPLIT_LOCK_DETECT))
+			vmx->guest_has_sld = true;
+	}
 }
 
 static __init void vmx_set_cpu_caps(void)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index aab9df55336e..aa58fb50081e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -216,12 +216,15 @@ struct vcpu_vmx {
 	int                   nmsrs;
 	int                   save_nmsrs;
 	bool                  guest_msrs_ready;
+	bool                  guest_has_sld;
+	bool                  host_sld_on;
 #ifdef CONFIG_X86_64
 	u64		      msr_host_kernel_gs_base;
 	u64		      msr_guest_kernel_gs_base;
 #endif
 
 	u64		      spec_ctrl;
+	u64                   msr_test_ctrl;
 	u32		      msr_ia32_umwait_control;
 
 	u32 secondary_exec_control;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5835f9cb9ad..f04ed46c433e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1189,7 +1189,7 @@ static const u32 msrs_to_save_all[] = {
 #endif
 	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
 	MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
-	MSR_IA32_SPEC_CTRL,
+	MSR_IA32_SPEC_CTRL, MSR_TEST_CTRL,
 	MSR_IA32_RTIT_CTL, MSR_IA32_RTIT_STATUS, MSR_IA32_RTIT_CR3_MATCH,
 	MSR_IA32_RTIT_OUTPUT_BASE, MSR_IA32_RTIT_OUTPUT_MASK,
 	MSR_IA32_RTIT_ADDR0_A, MSR_IA32_RTIT_ADDR0_B,
@@ -5239,6 +5239,10 @@ static void kvm_init_msr_list(void)
 		 * to the guests in some cases.
 		 */
 		switch (msrs_to_save_all[i]) {
+		case MSR_TEST_CTRL:
+			if (!kvm_split_lock_detect_supported())
+				continue;
+			break;
 		case MSR_IA32_BNDCFGS:
 			if (!kvm_mpx_supported())
 				continue;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b968acc0516f..346a7527c2c6 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -355,6 +355,13 @@ static inline bool kvm_dr7_valid(u64 data)
 	return !(data >> 32);
 }
 
+static inline bool kvm_split_lock_detect_supported(void)
+{
+	return boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
+	       (boot_cpu_has(X86_FEATURE_SLD_FATAL) ||
+		!cpu_smt_possible());
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
-- 
2.18.2

