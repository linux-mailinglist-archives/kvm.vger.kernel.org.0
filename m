Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B211E58BDD1
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241984AbiHGWJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241981AbiHGWII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:08:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08664959E;
        Sun,  7 Aug 2022 15:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909806; x=1691445806;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kcroO2JQ9NdtVspHrSsLOZRoTe0+5d0A/HBDmDYVTkg=;
  b=bc6tQdmieQ/7DBalT6cfQ/drJjhWmuO0gTm5IxF+9LZYXml062nyLbFr
   8MpieCFafuohn4SKU6ymIlidenuBWrcCSMUJP53/dQhZSY0WhwBXvYg2/
   Ieb4JJy0CMBIUF5b3/4yrTIpZurIjldWKSSujBd+WKzXMCW81+q1SNI9F
   u9x/XVT2lsz5LO0ffud7JBnVIq6oh7zRExlZI1sDpe1mQhsD/mnPF92qg
   dzdHOUyECThjHIsASSOabeznE879MJTwSSWqeMcGTWQiuboKleKYKKiQb
   Bet/ckw0zpUmPwc/SJscy/VhC8klrA3r+SuJvpds6fat45t61ouIC/bmt
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270240410"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="270240410"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682755"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:44 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 094/103] KVM: TDX: Implement callbacks for MSR operations for TDX
Date:   Sun,  7 Aug 2022 15:02:19 -0700
Message-Id: <820c1fb0684b95fa45db15512ecdb4ee22743647.1659854791.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
host VMM (e.g. KVM) can virtualizes the MSRs.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c    | 34 +++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 68 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  6 ++++
 3 files changed, 105 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 131e431e7e52..2ffe9fbd7359 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -205,6 +205,34 @@ static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
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
+		return tdx_is_emulated_msr(index, true);
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
 static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
@@ -439,7 +467,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.hardware_enable = vt_hardware_enable,
 	.hardware_disable = vt_hardware_disable,
-	.has_emulated_msr = vmx_has_emulated_msr,
+	.has_emulated_msr = vt_has_emulated_msr,
 
 	.is_vm_type_supported = vt_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
@@ -459,8 +487,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
 	.get_msr_feature = vmx_get_msr_feature,
-	.get_msr = vmx_get_msr,
-	.set_msr = vmx_set_msr,
+	.get_msr = vt_get_msr,
+	.set_msr = vt_set_msr,
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 84bf9cc8469c..341c29385544 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1624,6 +1624,74 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 	*error_code = 0;
 }
 
+bool tdx_is_emulated_msr(u32 index, bool write)
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
+	case MSR_KVM_STEAL_TIME:
+	case MSR_KVM_POLL_CONTROL:
+	case MSR_PLATFORM_INFO:
+	case MSR_MISC_FEATURES_ENABLES:
+	case MSR_IA32_MCG_CAP:
+	case MSR_IA32_MCG_STATUS:
+	case MSR_IA32_MCG_CTL:
+	case MSR_IA32_MCG_EXT_CTL:
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_MISC(28) - 1:
+		/* MSR_IA32_MCx_{CTL, STATUS, ADDR, MISC} */
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
+	case MSR_IA32_MCx_CTL2(0) ... MSR_IA32_MCx_CTL2(31):
+		/*
+		 * 0x280 - 0x29f: The x86 common code doesn't emulate MCx_CTL2.
+		 * Refer to kvm_{get,set}_msr_common(),
+		 * kvm_mtrr_{get, set}_msr(), and msr_mtrr_valid().
+		 */
+	default:
+		return false;
+	}
+}
+
+int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	if (tdx_is_emulated_msr(msr->index, false))
+		return kvm_get_msr_common(vcpu, msr);
+	return 1;
+}
+
+int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	if (tdx_is_emulated_msr(msr->index, true))
+		return kvm_set_msr_common(vcpu, msr);
+	return 1;
+}
+
 int tdx_dev_ioctl(void __user *argp)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 93fcd02933e6..d5c47172eba9 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -159,6 +159,9 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 void tdx_inject_nmi(struct kvm_vcpu *vcpu);
 void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
+bool tdx_is_emulated_msr(u32 index, bool write);
+int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -197,6 +200,9 @@ static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
 static inline void tdx_get_exit_info(
 	struct kvm_vcpu *vcpu, u32 *reason, u64 *info1, u64 *info2,
 	u32 *intr_info, u32 *error_code) {}
+static inline bool tdx_is_emulated_msr(u32 index, bool write) { return false; }
+static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
+static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
-- 
2.25.1

