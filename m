Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3E3714335
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjE2E3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbjE2E2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:28:39 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E741172B;
        Sun, 28 May 2023 21:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334308; x=1716870308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mQqhAi+rpi1LyKlalTXfdzWd/rzJfBxIvgfGvCwLJ5w=;
  b=N8eALJzO6hQ4cVnT7AspEaPMIdlJREh7cJ+wxP8pOngf9svG//COx+yf
   vcAEgSjbgUF5DZ2bh70Rv70Fp9k8iFnXt85Fhr2FwrQfKdnL2cAUarMIo
   PdqJPkeTzJEdFy5S6Ipy5IKIO4fLhHpF0yR/Za2k8qmohLO8mWXDqiOOw
   0LEUz8C7GoZkG2Zt4lYC9BHN4tSKphOlRtNhDRYbG2d2WuD2XA/Y2GjYD
   q15ml3Z4DloIzI/Jy/rQLk2e3GpJ+9r+0b03TwscEAbyuqczJbXYdmvC2
   0ZAs/lb5fBrdC3jTBmRLv4uf5rE64EK6T0LuS0n6f0gTolZaPCIyllzHq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="356993442"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="356993442"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="830223466"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="830223466"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:42 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 095/113] KVM: TDX: Implement callbacks for MSR operations for TDX
Date:   Sun, 28 May 2023 21:20:17 -0700
Message-Id: <3fd6a4719230b82a0bd0c84be1494c08d912b06b.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/main.c    | 44 +++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx.c     | 70 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  6 ++++
 arch/x86/kvm/x86.c         |  1 -
 arch/x86/kvm/x86.h         |  2 ++
 5 files changed, 118 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 1b7bcc67429d..3a3ef7a77047 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -258,6 +258,42 @@ static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
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
@@ -521,7 +557,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.hardware_enable = vt_hardware_enable,
 	.hardware_disable = vt_hardware_disable,
-	.has_emulated_msr = vmx_has_emulated_msr,
+	.has_emulated_msr = vt_has_emulated_msr,
 
 	.is_vm_type_supported = vt_is_vm_type_supported,
 	.max_vcpus = vt_max_vcpus,
@@ -543,8 +579,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
 	.get_msr_feature = vmx_get_msr_feature,
-	.get_msr = vmx_get_msr,
-	.set_msr = vmx_set_msr,
+	.get_msr = vt_get_msr,
+	.set_msr = vt_set_msr,
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
@@ -653,7 +689,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
-	.msr_filter_changed = vmx_msr_filter_changed,
+	.msr_filter_changed = vt_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a3ea6fe021c1..f07c5ba153ec 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1709,6 +1709,76 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
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
+	case MSR_IA32_CR_PAT:
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
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 7077ba54b304..ba5cadb0135e 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -166,6 +166,9 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 void tdx_inject_nmi(struct kvm_vcpu *vcpu);
 void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
+bool tdx_has_emulated_msr(u32 index, bool write);
+int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -204,6 +207,9 @@ static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mo
 static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
 static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
 				     u64 *info2, u32 *intr_info, u32 *error_code) {}
+static inline bool tdx_has_emulated_msr(u32 index, bool write) { return false; }
+static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
+static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8d0bc21a905a..5ba40abaf0f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -89,7 +89,6 @@
 #include "trace.h"
 
 #define MAX_IO_MSRS 256
-#define KVM_MAX_MCE_BANKS 32
 
 struct kvm_caps kvm_caps __read_mostly = {
 	.supported_mce_cap = MCG_CTL_P | MCG_SER_P,
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7d5aa8f0571a..af4970f6e692 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -9,6 +9,8 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 
+#define KVM_MAX_MCE_BANKS 32
+
 bool __kvm_is_vm_type_supported(unsigned long type);
 
 struct kvm_caps {
-- 
2.25.1

