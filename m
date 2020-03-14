Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D0F18588E
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 03:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgCOCN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 22:13:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:41896 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbgCOCNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 22:13:40 -0400
IronPort-SDR: oJJ/f+jdKWjiRk7IIJZvT5KZnFT3Jl6IfgpRpIpWu+ZdkpcXGWnOItn60oBUGUuX5dKqXzkqf+
 a9qnEexyfEdg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2020 00:52:29 -0700
IronPort-SDR: 8rOke19cLw6C9Xawh4pfWyou2nS8E9J7f0lqt1yRlMBfjdGJRWiKE4IkQfGDD3j95Cwioylc8q
 xpP59Rra3jZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,551,1574150400"; 
   d="scan'208";a="416537662"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.160])
  by orsmga005.jf.intel.com with ESMTP; 14 Mar 2020 00:52:25 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com
Cc:     peterz@infradead.org, fenghua.yu@intel.com,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v4 10/10] x86: vmx: virtualize split lock detection
Date:   Sat, 14 Mar 2020 15:34:14 +0800
Message-Id: <20200314073414.184213-11-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200314073414.184213-1-xiaoyao.li@intel.com>
References: <20200314073414.184213-1-xiaoyao.li@intel.com>
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

  sld_kvm_only - hardware MSR_TEST_CTRL.SLD is set on VM-Entry and cleared
		 onVM-Exit if guest enables SLD, i.e., guest's virtual
	         MSR_TEST_CTRL.SLD is set.

  sld_disable - guest cannot see feature split lock detection.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/cpu.h  |  2 ++
 arch/x86/kernel/cpu/intel.c |  7 ++++++
 arch/x86/kvm/vmx/vmx.c      | 45 ++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/x86.c          | 17 +++++++++++---
 4 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 2e17315b1fed..284be32aaf87 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -64,6 +64,7 @@ extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
 extern void switch_to_sld(unsigned long tifn);
 extern bool handle_user_split_lock(unsigned long ip);
 extern void sld_msr_set(bool on);
+extern void sld_turn_back_on(void);
 #else
 static inline bool split_lock_detect_on(void) { return false; }
 static inline bool split_lock_detect_disabled(void) { return true; }
@@ -74,5 +75,6 @@ static inline bool handle_user_split_lock(unsigned long ip)
 	return false;
 }
 static inline void sld_msr_set(bool on) {}
+static inline void sld_turn_back_on(void) {}
 #endif
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8bfe8b07e06e..de46e1d3f1c7 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1120,6 +1120,13 @@ void sld_msr_set(bool on)
 }
 EXPORT_SYMBOL_GPL(sld_msr_set);
 
+void sld_turn_back_on(void)
+{
+	__sld_msr_set(true);
+	clear_tsk_thread_flag(current, TIF_SLD);
+}
+EXPORT_SYMBOL_GPL(sld_turn_back_on);
+
 /*
  * This function is called only when switching between tasks with
  * different split-lock detection modes. It sets the MSR for the
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 107c873b23c2..058dc6c478bd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1819,6 +1819,22 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
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
@@ -1988,7 +2004,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr_index) {
 	case MSR_TEST_CTRL:
-		if (data)
+		if (data & ~vmx_msr_test_ctrl_valid_bits(vcpu))
 			return 1;
 
 		vmx->msr_test_ctrl = data;
@@ -4625,6 +4641,11 @@ static inline bool guest_cpu_alignment_check_enabled(struct kvm_vcpu *vcpu)
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
@@ -4721,12 +4742,13 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
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
@@ -6619,6 +6641,14 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
 
+	if (!split_lock_detect_disabled() &&
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
@@ -6653,6 +6683,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
 
+	if (!split_lock_detect_disabled() &&
+	    guest_cpu_split_lock_detect_on(vmx) &&
+	    !split_lock_detect_on())
+		sld_msr_set(false);
+
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs))
 		current_evmcs->hv_clean_fields |=
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 72d4bfea8864..c956aa180253 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1162,7 +1162,7 @@ static const u32 msrs_to_save_all[] = {
 #endif
 	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
 	MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
-	MSR_IA32_SPEC_CTRL,
+	MSR_IA32_SPEC_CTRL, MSR_TEST_CTRL,
 	MSR_IA32_RTIT_CTL, MSR_IA32_RTIT_STATUS, MSR_IA32_RTIT_CR3_MATCH,
 	MSR_IA32_RTIT_OUTPUT_BASE, MSR_IA32_RTIT_OUTPUT_MASK,
 	MSR_IA32_RTIT_ADDR0_A, MSR_IA32_RTIT_ADDR0_B,
@@ -1344,7 +1344,12 @@ static u64 kvm_get_arch_capabilities(void)
 
 static u64 kvm_get_core_capabilities(void)
 {
-	return 0;
+	u64 data = 0;
+
+	if (!split_lock_detect_disabled() && !cpu_smt_possible())
+		data |= MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT;
+
+	return data;
 }
 
 static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
@@ -2729,7 +2734,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.arch_capabilities = data;
 		break;
 	case MSR_IA32_CORE_CAPS:
-		if (!msr_info->host_initiated)
+		if (!msr_info->host_initiated ||
+		    data & ~kvm_get_core_capabilities())
 			return 1;
 		vcpu->arch.core_capabilities = data;
 		break;
@@ -5276,6 +5282,11 @@ static void kvm_init_msr_list(void)
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

