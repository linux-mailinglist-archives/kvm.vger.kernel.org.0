Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE3C26A285
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 08:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbfGPG6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 02:58:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:51761 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbfGPG6p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 02:58:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 23:58:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,496,1557212400"; 
   d="scan'208";a="366116058"
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jul 2019 23:58:43 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com, tao3.xu@intel.com
Subject: [PATCH v8 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
Date:   Tue, 16 Jul 2019 14:55:50 +0800
Message-Id: <20190716065551.27264-3-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190716065551.27264-1-tao3.xu@intel.com>
References: <20190716065551.27264-1-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UMWAIT and TPAUSE instructions use 32bit IA32_UMWAIT_CONTROL at MSR index
E1H to determines the maximum time in TSC-quanta that the processor can
reside in either C0.1 or C0.2.

This patch emulates MSR IA32_UMWAIT_CONTROL in guest and differentiate
IA32_UMWAIT_CONTROL between host and guest. The variable
mwait_control_cached in arch/x86/kernel/cpu/umwait.c caches the MSR value,
so this patch uses it to avoid frequently rdmsr of IA32_UMWAIT_CONTROL.

Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
---

Changes in v8:
    - Add an accessor to expose umwait_control_cached (Sean)
    - Set msr_ia32_umwait_control in vcpu_vmx u32 and raise #GP when
      [63:32] is set when rdmsr. (Sean)
---
 arch/x86/kernel/cpu/umwait.c |  6 ++++++
 arch/x86/kvm/vmx/vmx.c       | 37 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h       |  9 +++++++++
 arch/x86/kvm/x86.c           |  1 +
 4 files changed, 53 insertions(+)

diff --git a/arch/x86/kernel/cpu/umwait.c b/arch/x86/kernel/cpu/umwait.c
index 6a204e7336c1..e7344be24a74 100644
--- a/arch/x86/kernel/cpu/umwait.c
+++ b/arch/x86/kernel/cpu/umwait.c
@@ -17,6 +17,12 @@
  */
 static u32 umwait_control_cached = UMWAIT_CTRL_VAL(100000, UMWAIT_C02_ENABLE);
 
+u32 get_umwait_control_msr(void)
+{
+	return umwait_control_cached;
+}
+EXPORT_SYMBOL_GPL(get_umwait_control_msr);
+
 /*
  * Serialize access to umwait_control_cached and IA32_UMWAIT_CONTROL MSR in
  * the sysfs write functions.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d4ee22ff7ccc..0224b087aad3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1676,6 +1676,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 #endif
 	case MSR_EFER:
 		return kvm_get_msr_common(vcpu, msr_info);
+	case MSR_IA32_UMWAIT_CONTROL:
+		if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
+			return 1;
+
+		msr_info->data = vmx->msr_ia32_umwait_control;
+		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
@@ -1838,6 +1844,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vmcs_write64(GUEST_BNDCFGS, data);
 		break;
+	case MSR_IA32_UMWAIT_CONTROL:
+		if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
+			return 1;
+
+		/* The reserved bit 1 and non-32 bit [63:32] should be zero */
+		if (data & (BIT_ULL(1) | GENMASK_ULL(63, 32)))
+			return 1;
+
+		vmx->msr_ia32_umwait_control = data;
+		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
@@ -4137,6 +4153,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx->rmode.vm86_active = 0;
 	vmx->spec_ctrl = 0;
 
+	vmx->msr_ia32_umwait_control = 0;
+
 	vcpu->arch.microcode_version = 0x100000000ULL;
 	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
 	kvm_set_cr8(vcpu, 0);
@@ -6350,6 +6368,23 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 					msrs[i].host, false);
 }
 
+static void atomic_switch_umwait_control_msr(struct vcpu_vmx *vmx)
+{
+	u32 host_umwait_control;
+
+	if (!vmx_has_waitpkg(vmx))
+		return;
+
+	host_umwait_control = get_umwait_control_msr();
+
+	if (vmx->msr_ia32_umwait_control != host_umwait_control)
+		add_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL,
+			vmx->msr_ia32_umwait_control,
+			host_umwait_control, false);
+	else
+		clear_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL);
+}
+
 static void vmx_arm_hv_timer(struct vcpu_vmx *vmx, u32 val)
 {
 	vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, val);
@@ -6458,6 +6493,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	atomic_switch_perf_msrs(vmx);
 
+	atomic_switch_umwait_control_msr(vmx);
+
 	vmx_update_hv_timer(vcpu);
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 61128b48c503..8e4869322eff 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -14,6 +14,8 @@
 extern const u32 vmx_msr_index[];
 extern u64 host_efer;
 
+extern u32 get_umwait_control_msr(void);
+
 #define MSR_TYPE_R	1
 #define MSR_TYPE_W	2
 #define MSR_TYPE_RW	3
@@ -194,6 +196,7 @@ struct vcpu_vmx {
 #endif
 
 	u64		      spec_ctrl;
+	u32		      msr_ia32_umwait_control;
 
 	u32 vm_entry_controls_shadow;
 	u32 vm_exit_controls_shadow;
@@ -523,6 +526,12 @@ static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
 	vmcs_write64(TSC_MULTIPLIER, vmx->current_tsc_ratio);
 }
 
+static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
+{
+	return vmx->secondary_exec_control &
+		SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
+}
+
 void dump_vmcs(void);
 
 #endif /* __KVM_X86_VMX_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 63bb1ee8258e..e914e4d03cce 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1136,6 +1136,7 @@ static u32 msrs_to_save[] = {
 	MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
 	MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
 	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
+	MSR_IA32_UMWAIT_CONTROL,
 };
 
 static unsigned num_msrs_to_save;
-- 
2.20.1

