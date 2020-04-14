Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08C01A73E2
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 08:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406137AbgDNGuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 02:50:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:58687 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406141AbgDNGuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 02:50:37 -0400
IronPort-SDR: q1dc8ySF3THGnnvppSvObwifJRqQpGybvrhMQmrrqqloPsUnxeIUf+QRnrbgUu/4Na2lucbWiQ
 sXOMFl6LgNCQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 23:50:36 -0700
IronPort-SDR: iJq4LJ78HrawWYBucTTooYa+ir1LIfUCukNGl5RHtNcX24Rwdo6aCivfVdTjqEQWDMky6rK/oV
 IhtJzPnUz57Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="scan'208";a="277158388"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.132])
  by fmsmga004.fm.intel.com with ESMTP; 13 Apr 2020 23:50:32 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v8 4/4] kvm: vmx: virtualize split lock detection
Date:   Tue, 14 Apr 2020 14:31:29 +0800
Message-Id: <20200414063129.133630-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414063129.133630-1-xiaoyao.li@intel.com>
References: <20200414063129.133630-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Due to the fact that TEST_CTRL MSR is per-core scope, i.e., the sibling
threads in the same physical CPU core share the same MSR, only
advertising feature split lock detection to guest when SMT is disabled
or unsupported, for simplicitly.

1) When host sld_state is sld_off, feature split lock detection is
   unsupported/disabled. Cannot expose it to guest in this case.

2) When host sld_state is sld_warn, feature split lock detection can be
   exposed to guest if nosmt. Further, to avoid the potential
   MSR_TEST_CTRL.SLD toggling overhead during every vm-enter/-exit,
   loading guest's SLD setting when in KVM context.

3) When host sld_state is sld_fatal, feature split lock detection can also
   be exposed to guest if nosmt. But the feature is forced on for
   guest, i.e., the hardware MSR_TEST_CTRL.SLD bit is always set even if
   guest clears the SLD bit.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 79 +++++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.h |  2 ++
 arch/x86/kvm/x86.c     | 17 +++++++--
 3 files changed, 86 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ae394ed174cd..2077abe4edf9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1120,6 +1120,35 @@ void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 	}
 }
 
+/*
+ * Note: for guest, feature split lock detection can only be enumerated through
+ * MSR_IA32_CORE_CAPABILITIES bit. The FMS enumeration is unsupported.
+ */
+static inline bool guest_cpu_has_feature_sld(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.core_capabilities &
+	       MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT;
+}
+
+static inline bool guest_cpu_sld_on(struct vcpu_vmx *vmx)
+{
+	return vmx->msr_test_ctrl & MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+}
+
+static inline void vmx_update_sld(struct kvm_vcpu *vcpu, bool on)
+{
+	/*
+	 * Toggle SLD if the guest wants it enabled but its been disabled for
+	 * the userspace VMM, and vice versa.  Note, TIF_SLD is true if SLD has
+	 * been turned off.  Yes, it's a terrible name.
+	 */
+	if (sld_state == sld_warn && guest_cpu_has_feature_sld(vcpu) &&
+	    on == test_thread_flag(TIF_SLD)) {
+		    sld_update_msr(on);
+		    update_thread_flag(TIF_SLD, !on);
+	}
+}
+
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1188,6 +1217,10 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 #endif
 
 	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
+
+	vmx->host_sld_on = !test_thread_flag(TIF_SLD);
+	vmx_update_sld(vcpu, guest_cpu_sld_on(vmx));
+
 	vmx->guest_state_loaded = true;
 }
 
@@ -1226,6 +1259,9 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 #endif
 	load_fixmap_gdt(raw_smp_processor_id());
+
+	vmx_update_sld(&vmx->vcpu, vmx->host_sld_on);
+
 	vmx->guest_state_loaded = false;
 	vmx->guest_msrs_ready = false;
 }
@@ -1777,6 +1813,16 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 	}
 }
 
+static inline u64 vmx_msr_test_ctrl_valid_bits(struct kvm_vcpu *vcpu)
+{
+	u64 valid_bits = 0;
+
+	if (guest_cpu_has_feature_sld(vcpu))
+		valid_bits |= MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
+
+	return valid_bits;
+}
+
 /*
  * Reads an msr value (of 'msr_index') into 'pdata'.
  * Returns 0 on success, non-0 otherwise.
@@ -1790,7 +1836,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr_info->index) {
 	case MSR_TEST_CTRL:
-		msr_info->data = 0;
+		msr_info->data = vmx->msr_test_ctrl;
 		break;
 #ifdef CONFIG_X86_64
 	case MSR_FS_BASE:
@@ -1946,9 +1992,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr_index) {
 	case MSR_TEST_CTRL:
-		if (data)
+		if (data & ~vmx_msr_test_ctrl_valid_bits(vcpu))
 			return 1;
 
+		vmx->msr_test_ctrl = data;
+
+		preempt_disable();
+		if (vmx->guest_state_loaded)
+			vmx_update_sld(vcpu, guest_cpu_sld_on(vmx));
+		preempt_enable();
 		break;
 	case MSR_EFER:
 		ret = kvm_set_msr_common(vcpu, msr_info);
@@ -4266,7 +4318,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmx->rmode.vm86_active = 0;
 	vmx->spec_ctrl = 0;
-
+	vmx->msr_test_ctrl = 0;
 	vmx->msr_ia32_umwait_control = 0;
 
 	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
@@ -4596,24 +4648,33 @@ static int handle_machine_check(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static inline bool guest_cpu_alignment_check_enabled(struct kvm_vcpu *vcpu)
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
+	 * guest_cpu_alignment_check_enabled() first.
+	 */
+	return guest_cpu_alignment_check_enabled(vcpu) ||
+	       guest_cpu_sld_on(to_vmx(vcpu));
 }
 
 static int handle_exception_nmi(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index aab9df55336e..b3c5be90b023 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -216,12 +216,14 @@ struct vcpu_vmx {
 	int                   nmsrs;
 	int                   save_nmsrs;
 	bool                  guest_msrs_ready;
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
index adfd4d74ea53..8c8f5ccfd98b 100644
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
@@ -2764,7 +2769,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.arch_capabilities = data;
 		break;
 	case MSR_IA32_CORE_CAPS:
-		if (!msr_info->host_initiated)
+		if (!msr_info->host_initiated ||
+		    data & ~kvm_get_core_capabilities())
 			return 1;
 		vcpu->arch.core_capabilities = data;
 		break;
@@ -5243,6 +5249,11 @@ static void kvm_init_msr_list(void)
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

