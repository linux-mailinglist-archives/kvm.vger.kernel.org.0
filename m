Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED681914A1
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 16:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgCXPhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 11:37:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:40198 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728727AbgCXPhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 11:37:39 -0400
IronPort-SDR: ouV+eJWSctd7tIduN7Yn7rezrdCJq3MGYG+8QECNUjxsmQfS0psD5jycEqX4nB8wyKCPzi4pqH
 4e6Ds107rx7A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 08:37:39 -0700
IronPort-SDR: 32hh5br9Wcvu2j1zo+TbGVXaf1FVTLtIMmdOXEqQfALQua1SlSHmHVuZFBTdevHWI/w2uvbIBk
 oUgXTawgNAVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,300,1580803200"; 
   d="scan'208";a="393319783"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.39])
  by orsmga004.jf.intel.com with ESMTP; 24 Mar 2020 08:37:34 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v6 8/8] kvm: vmx: virtualize split lock detection
Date:   Tue, 24 Mar 2020 23:18:59 +0800
Message-Id: <20200324151859.31068-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324151859.31068-1-xiaoyao.li@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Due to the fact that MSR_TEST_CTRL is per-core scope, i.e., the sibling
threads in the same physical CPU core share the same MSR, only
advertising feature split lock detection to guest when SMT is disabled
or unsupported, for simplicitly.

Below summarizing how guest behaves of different host configuration:

  sld_fatal - hardware MSR_TEST_CTRL.SLD is always on when vcpu is running,
              even though guest thinks it sets/clears MSR_TEST_CTRL.SLD
	      bit successfully. i.e., SLD is forced on for guest.

  sld_warn - hardware MSR_TEST_CTRL.SLD is left on until an #AC is
	     intercepted with MSR_TEST_CTRL.SLD=0 in the guest, at which
	     point normal sld_warn rules apply, i.e., clear
	     MSR_TEST_CTRL.SLD bit and set TIF_SLD.
	     If a vCPU associated with the task does VM-Enter with
	     virtual MSR_TEST_CTRL.SLD=1, TIF_SLD is reset, hardware
	     MSR_TEST_CTRL.SLD is re-set, and cycle begins anew.

  sld_disable - guest cannot see feature split lock detection.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/cpu.h  | 17 +++++++++++++-
 arch/x86/kernel/cpu/intel.c | 29 +++++++++++++-----------
 arch/x86/kvm/vmx/vmx.c      | 45 ++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/x86.c          | 17 +++++++++++---
 4 files changed, 86 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index d2071f6a35ac..519dd0c4c1bd 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -41,10 +41,23 @@ unsigned int x86_family(unsigned int sig);
 unsigned int x86_model(unsigned int sig);
 unsigned int x86_stepping(unsigned int sig);
 #ifdef CONFIG_CPU_SUP_INTEL
+enum split_lock_detect_state {
+	sld_off = 0,
+	sld_warn,
+	sld_fatal,
+};
+extern enum split_lock_detect_state sld_state __ro_after_init;
+
+static inline bool split_lock_detect_on(void)
+{
+	return sld_state != sld_off;
+}
+
 extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
 extern void switch_to_sld(unsigned long tifn);
 extern bool handle_user_split_lock(unsigned long ip);
-extern bool split_lock_detect_on(void);
+extern void sld_msr_set(bool on);
+extern void sld_turn_back_on(void);
 #else
 static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
 static inline void switch_to_sld(unsigned long tifn) {}
@@ -53,5 +66,7 @@ static inline bool handle_user_split_lock(unsigned long ip)
 	return false;
 }
 static inline bool split_lock_detect_on(void) { return false; }
+static inline void sld_msr_set(bool on) {}
+static inline void sld_turn_back_on(void) {}
 #endif
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index fd67be719284..8c186e8d4536 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -33,18 +33,14 @@
 #include <asm/apic.h>
 #endif
 
-enum split_lock_detect_state {
-	sld_off = 0,
-	sld_warn,
-	sld_fatal,
-};
-
 /*
  * Default to sld_off because most systems do not support split lock detection
  * split_lock_setup() will switch this to sld_warn on systems that support
  * split lock detect, unless there is a command line override.
  */
-static enum split_lock_detect_state sld_state __ro_after_init = sld_off;
+enum split_lock_detect_state sld_state __ro_after_init = sld_off;
+EXPORT_SYMBOL_GPL(sld_state);
+
 static u64 msr_test_ctrl_cache __ro_after_init;
 
 /*
@@ -1070,12 +1066,6 @@ static void split_lock_init(void)
 		sld_update_msr(sld_state != sld_off);
 }
 
-bool split_lock_detect_on(void)
-{
-	return sld_state != sld_off;
-}
-EXPORT_SYMBOL_GPL(split_lock_detect_on);
-
 bool handle_user_split_lock(unsigned long ip)
 {
 	if (sld_state == sld_fatal)
@@ -1095,6 +1085,19 @@ bool handle_user_split_lock(unsigned long ip)
 }
 EXPORT_SYMBOL_GPL(handle_user_split_lock);
 
+void sld_msr_set(bool on)
+{
+	sld_update_msr(on);
+}
+EXPORT_SYMBOL_GPL(sld_msr_set);
+
+void sld_turn_back_on(void)
+{
+	sld_update_msr(true);
+	clear_tsk_thread_flag(current, TIF_SLD);
+}
+EXPORT_SYMBOL_GPL(sld_turn_back_on);
+
 /*
  * This function is called only when switching between tasks with
  * different split-lock detection modes. It sets the MSR for the
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a302027f7e56..2adf326d433f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1808,6 +1808,22 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 	}
 }
 
+static inline u64 vmx_msr_test_ctrl_valid_bits(struct kvm_vcpu *vcpu)
+{
+	u64 valid_bits = 0;
+
+	/*
+	 * Note: for guest, feature split lock detection can only be enumerated
+	 * through MSR_IA32_CORE_CAPABILITIES bit.
+	 * The FMS enumeration is invalid.
+	 */
+	if (vcpu->arch.core_capabilities &
+	    MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT)
+		valid_bits |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+
+	return valid_bits;
+}
+
 /*
  * Reads an msr value (of 'msr_index') into 'pdata'.
  * Returns 0 on success, non-0 otherwise.
@@ -1977,7 +1993,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr_index) {
 	case MSR_TEST_CTRL:
-		if (data)
+		if (data & ~vmx_msr_test_ctrl_valid_bits(vcpu))
 			return 1;
 
 		vmx->msr_test_ctrl = data;
@@ -4629,6 +4645,11 @@ static inline bool guest_cpu_alignment_check_enabled(struct kvm_vcpu *vcpu)
 	       (kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
 }
 
+static inline bool guest_cpu_split_lock_detect_on(struct vcpu_vmx *vmx)
+{
+	return vmx->msr_test_ctrl & MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+}
+
 static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -4725,12 +4746,13 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	case AC_VECTOR:
 		/*
 		 * Reflect #AC to the guest if it's expecting the #AC, i.e. has
-		 * legacy alignment check enabled.  Pre-check host split lock
-		 * support to avoid the VMREADs needed to check legacy #AC,
-		 * i.e. reflect the #AC if the only possible source is legacy
-		 * alignment checks.
+		 * legacy alignment check enabled or split lock detect enabled.
+		 * Pre-check host split lock support to avoid further check of
+		 * guest, i.e. reflect the #AC if host doesn't enable split lock
+		 * detection.
 		 */
 		if (!split_lock_detect_on() ||
+		    guest_cpu_split_lock_detect_on(vmx) ||
 		    guest_cpu_alignment_check_enabled(vcpu)) {
 			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
 			return 1;
@@ -6631,6 +6653,14 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
 
+	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
+	    guest_cpu_split_lock_detect_on(vmx)) {
+		if (test_thread_flag(TIF_SLD))
+			sld_turn_back_on();
+		else if (!split_lock_detect_on())
+			sld_msr_set(true);
+	}
+
 	/* L1D Flush includes CPU buffer clear to mitigate MDS */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
@@ -6665,6 +6695,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
 
+	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
+	    guest_cpu_split_lock_detect_on(vmx) &&
+	    !split_lock_detect_on())
+		sld_msr_set(false);
+
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs))
 		current_evmcs->hv_clean_fields |=
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fc1a4e9e5659..58abfdf67b60 100644
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
@@ -1371,7 +1371,12 @@ static u64 kvm_get_arch_capabilities(void)
 
 static u64 kvm_get_core_capabilities(void)
 {
-	return 0;
+	u64 data = 0;
+
+	if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) && !cpu_smt_possible())
+		data |= MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT;
+
+	return data;
 }
 
 static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
@@ -2756,7 +2761,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.arch_capabilities = data;
 		break;
 	case MSR_IA32_CORE_CAPS:
-		if (!msr_info->host_initiated)
+		if (!msr_info->host_initiated ||
+		    data & ~kvm_get_core_capabilities())
 			return 1;
 		vcpu->arch.core_capabilities = data;
 		break;
@@ -5235,6 +5241,11 @@ static void kvm_init_msr_list(void)
 		 * to the guests in some cases.
 		 */
 		switch (msrs_to_save_all[i]) {
+		case MSR_TEST_CTRL:
+			if (!(kvm_get_core_capabilities() &
+			      MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT))
+				continue;
+			break;
 		case MSR_IA32_BNDCFGS:
 			if (!kvm_mpx_supported())
 				continue;
-- 
2.20.1

