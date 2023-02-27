Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7FD6A3D18
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbjB0IbV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbjB0I3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:29:48 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2631420699;
        Mon, 27 Feb 2023 00:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486379; x=1709022379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G6RRMIjkPCTN/JbwD1ITQP55obUq7fJpjFHZouRyZGQ=;
  b=cXeAbcjx35/Xj6x3Z3bIh+7FzXNkuWsaWM1vMefbTQoF0y5oyAGPYqdV
   ykZ0xXq9LFu1202/oIAhOI83nMSJMN1O8LMf5xpx5RQBg49vBiBDtqr0j
   /ovCatm3dxfTeYACm+wQoK78nq0e11l0F0LtsKyPsiFIKCWaefLKZ7q3z
   +vbf/fJSx/njVOhZY8YPYWLU2pPmewqDBsvXKNBqxUAdF5Fw0fKPY0Dj6
   7744X8V2IHzs4QBawf+5nkmNhk+3M3Ih69w/BZZQGgKPS4eQEo4nodBEV
   lWitXimJeuAsi8ay5BORY5IJhesbbWQoyNt/RcRQj+QDoepchUMuxDI3f
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317609060"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317609060"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242401"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242401"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:18 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 088/106] KVM: TDX: Implement callbacks for MSR operations for TDX
Date:   Mon, 27 Feb 2023 00:23:27 -0800
Message-Id: <b30af5432b6441bef2c42b83738fa572a8b398d0.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implements set_msr/get_msr/has_emulated_msr methods for TDX to handle
hypercall from guest TD for paravirtualized rdmsr and wrmsr.  The TDX
module virtualizes MSRs.  For some MSRs, it injects #VE to the guest TD
upon RDMSR or WRMSR.  The exact list of such MSRs are defined in the spec.

Upon #VE, the guest TD may execute hypercalls,
TDG.VP.VMCALL<INSTRUCTION.RDMSR> and TDG.VP.VMCALL<INSTRUCTION.WRMSR>,
which are defined in GHCI (Guest-Host Communication Interface) so that the
host VMM (e.g. KVM) can virtualize the MSRs.

There are three classes of MSRs virtualization.
- non-configurable: TDX module directly virtualizes it. VMM can't configure.
  the value set by KVM_SET_MSR_INDEX_LIST is ignored.
- configurable: TDX module directly virtualizes it. VMM can configure at the
  VM creation time.  The value set by KVM_SET_MSR_INDEX_LIST is used.
- #VE case
  Guest TD would issue TDG.VP.VMCALL<INSTRUCTION.{WRMSR,RDMSR> and
  VMM handles the MSR hypercall. The value set by KVM_SET_MSR_INDEX_LIST is
  used.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
Changes v10 -> v11
- added .msr_filter_changed()
---
 arch/x86/kvm/vmx/main.c    | 44 ++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx.c     | 74 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  6 ++++
 arch/x86/kvm/x86.c         |  1 -
 arch/x86/kvm/x86.h         |  2 ++
 5 files changed, 122 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index fdb016ee6848..67d565a32e96 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -237,6 +237,42 @@ static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 	vmx_handle_exit_irqoff(vcpu);
 }
 
+static int vt_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	if (unlikely(is_td_vcpu(vcpu)))
+		return tdx_set_msr(vcpu, msr_info);
+
+	return vmx_set_msr(vcpu, msr_info);
+}
+
+/*
+ * The kvm parameter can be NULL (module initialization, or invocation before
+ * VM creation). Be sure to check the kvm parameter before using it.
+ */
+static bool vt_has_emulated_msr(struct kvm *kvm, u32 index)
+{
+	if (kvm && is_td(kvm))
+		return tdx_has_emulated_msr(index, true);
+
+	return vmx_has_emulated_msr(kvm, index);
+}
+
+static int vt_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	if (unlikely(is_td_vcpu(vcpu)))
+		return tdx_get_msr(vcpu, msr_info);
+
+	return vmx_get_msr(vcpu, msr_info);
+}
+
+static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_msr_filter_changed(vcpu);
+}
+
 static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
@@ -500,7 +536,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.hardware_enable = vmx_hardware_enable,
 	.hardware_disable = vt_hardware_disable,
-	.has_emulated_msr = vmx_has_emulated_msr,
+	.has_emulated_msr = vt_has_emulated_msr,
 
 	.is_vm_type_supported = vt_is_vm_type_supported,
 	.max_vcpus = vt_max_vcpus,
@@ -522,8 +558,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
 	.get_msr_feature = vmx_get_msr_feature,
-	.get_msr = vmx_get_msr,
-	.set_msr = vmx_set_msr,
+	.get_msr = vt_get_msr,
+	.set_msr = vt_set_msr,
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
@@ -632,7 +668,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
-	.msr_filter_changed = vmx_msr_filter_changed,
+	.msr_filter_changed = vt_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6d1100a2de7c..4455bf5ae1ac 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1673,6 +1673,80 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 	*error_code = 0;
 }
 
+static bool tdx_is_emulated_kvm_msr(u32 index, bool write)
+{
+	switch (index) {
+	case MSR_KVM_POLL_CONTROL:
+		return true;
+	default:
+		return false;
+	}
+}
+
+bool tdx_has_emulated_msr(u32 index, bool write)
+{
+	switch (index) {
+	case MSR_IA32_UCODE_REV:
+	case MSR_IA32_ARCH_CAPABILITIES:
+	case MSR_IA32_POWER_CTL:
+	case MSR_MTRRcap:
+	case 0x200 ... 0x26f:
+		/* IA32_MTRR_PHYS{BASE, MASK}, IA32_MTRR_FIX*_* */
+	case MSR_IA32_CR_PAT:
+	case MSR_MTRRdefType:
+	case MSR_IA32_TSC_DEADLINE:
+	case MSR_IA32_MISC_ENABLE:
+	case MSR_PLATFORM_INFO:
+	case MSR_MISC_FEATURES_ENABLES:
+	case MSR_IA32_MCG_CAP:
+	case MSR_IA32_MCG_STATUS:
+	case MSR_IA32_MCG_CTL:
+	case MSR_IA32_MCG_EXT_CTL:
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
+		/* MSR_IA32_MCx_{CTL, STATUS, ADDR, MISC, CTL2} */
+		return true;
+	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
+		/*
+		 * x2APIC registers that are virtualized by the CPU can't be
+		 * emulated, KVM doesn't have access to the virtual APIC page.
+		 */
+		switch (index) {
+		case X2APIC_MSR(APIC_TASKPRI):
+		case X2APIC_MSR(APIC_PROCPRI):
+		case X2APIC_MSR(APIC_EOI):
+		case X2APIC_MSR(APIC_ISR) ... X2APIC_MSR(APIC_ISR + APIC_ISR_NR):
+		case X2APIC_MSR(APIC_TMR) ... X2APIC_MSR(APIC_TMR + APIC_ISR_NR):
+		case X2APIC_MSR(APIC_IRR) ... X2APIC_MSR(APIC_IRR + APIC_ISR_NR):
+			return false;
+		default:
+			return true;
+		}
+	case MSR_IA32_APICBASE:
+	case MSR_EFER:
+		return !write;
+	case 0x4b564d00 ... 0x4b564dff:
+		/* KVM custom MSRs */
+		return tdx_is_emulated_kvm_msr(index, write);
+	default:
+		return false;
+	}
+}
+
+int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	if (tdx_has_emulated_msr(msr->index, false))
+		return kvm_get_msr_common(vcpu, msr);
+	return 1;
+}
+
+int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	if (tdx_has_emulated_msr(msr->index, true))
+		return kvm_set_msr_common(vcpu, msr);
+	return 1;
+}
+
 int tdx_dev_ioctl(void __user *argp)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index ac08f45d8c9e..26d07514f6a4 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -171,6 +171,9 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 void tdx_inject_nmi(struct kvm_vcpu *vcpu);
 void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
+bool tdx_has_emulated_msr(u32 index, bool write);
+int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -212,6 +215,9 @@ static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mo
 static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
 static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
 				     u64 *info2, u32 *intr_info, u32 *error_code) {}
+static inline bool tdx_has_emulated_msr(u32 index, bool write) { return false; }
+static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
+static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4ec246c88e41..7530efce6810 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -87,7 +87,6 @@
 #include "trace.h"
 
 #define MAX_IO_MSRS 256
-#define KVM_MAX_MCE_BANKS 32
 
 struct kvm_caps kvm_caps __read_mostly = {
 	.supported_mce_cap = MCG_CTL_P | MCG_SER_P,
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 888f34224bba..2608432fe524 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -8,6 +8,8 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 
+#define KVM_MAX_MCE_BANKS 32
+
 bool __kvm_is_vm_type_supported(unsigned long type);
 
 struct kvm_caps {
-- 
2.25.1

