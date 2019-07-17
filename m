Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D686BD28
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 15:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfGQNgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 09:36:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:36160 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727726AbfGQNgo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 09:36:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 06:36:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,274,1559545200"; 
   d="scan'208";a="191261885"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jul 2019 06:36:42 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v4 7/9] KVM: VMX: Handle SPP induced vmexit and page fault
Date:   Wed, 17 Jul 2019 21:37:49 +0800
Message-Id: <20190717133751.12910-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190717133751.12910-1-weijiang.yang@intel.com>
References: <20190717133751.12910-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If write to subpage is not allowed, EPT violation is generated,
it's propagated to QEMU or VMI to handle.

If the target page is SPP protected, however SPPT missing is
encoutered while traversing with gfn, vmexit is generated so
that KVM can handle the issue. Any SPPT misconfig will be
propagated to QEMU or VMI.

A SPP specific bit(11) is added to exit_qualification and a new
exit reason(66) is introduced for SPP.

Co-developed-by: He Chen <he.chen@linux.intel.com>
Signed-off-by: He Chen <he.chen@linux.intel.com>
Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/vmx.h      |  7 ++++
 arch/x86/include/uapi/asm/vmx.h |  2 +
 arch/x86/kvm/mmu.c              | 17 ++++++++
 arch/x86/kvm/vmx/vmx.c          | 71 +++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  5 +++
 5 files changed, 102 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 6cb05ac07453..11ca64ced578 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -547,6 +547,13 @@ struct vmx_msr_entry {
 #define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
 #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
 
+/*
+ * Exit Qualifications for SPPT-Induced vmexits
+ */
+#define SPPT_INDUCED_EXIT_TYPE_BIT     11
+#define SPPT_INDUCED_EXIT_TYPE         (1 << SPPT_INDUCED_EXIT_TYPE_BIT)
+#define SPPT_INTR_INFO_UNBLOCK_NMI     INTR_INFO_UNBLOCK_NMI
+
 /*
  * VM-instruction error numbers
  */
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index d213ec5c3766..fd89ebf321c9 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -85,6 +85,7 @@
 #define EXIT_REASON_PML_FULL            62
 #define EXIT_REASON_XSAVES              63
 #define EXIT_REASON_XRSTORS             64
+#define EXIT_REASON_SPP                 66
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -141,6 +142,7 @@
 	{ EXIT_REASON_ENCLS,                 "ENCLS" }, \
 	{ EXIT_REASON_RDSEED,                "RDSEED" }, \
 	{ EXIT_REASON_PML_FULL,              "PML_FULL" }, \
+	{ EXIT_REASON_SPP,                   "SPP" }, \
 	{ EXIT_REASON_XSAVES,                "XSAVES" }, \
 	{ EXIT_REASON_XRSTORS,               "XRSTORS" }
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 16d3ca544b67..419878301375 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3602,6 +3602,19 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 		if ((error_code & PFERR_WRITE_MASK) &&
 		    spte_can_locklessly_be_made_writable(spte))
 		{
+			/*
+			 * Record write protect fault caused by
+			 * Sub-page Protection, let VMI decide
+			 * the next step.
+			 */
+			if (spte & PT_SPP_MASK) {
+				fault_handled = true;
+				vcpu->run->exit_reason = KVM_EXIT_SPP;
+				vcpu->run->spp.addr = gva;
+				kvm_skip_emulated_instruction(vcpu);
+				break;
+			}
+
 			new_spte |= PT_WRITABLE_MASK;
 
 			/*
@@ -5786,6 +5799,10 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 		r = vcpu->arch.mmu->page_fault(vcpu, cr2,
 					       lower_32_bits(error_code),
 					       false);
+
+		if (vcpu->run->exit_reason == KVM_EXIT_SPP)
+			return 0;
+
 		WARN_ON(r == RET_PF_INVALID);
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 855d02dd94c7..2506ca958277 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5327,6 +5327,76 @@ static int handle_monitor(struct kvm_vcpu *vcpu)
 	return handle_nop(vcpu);
 }
 
+static int handle_spp(struct kvm_vcpu *vcpu)
+{
+	unsigned long exit_qualification;
+	struct kvm_memory_slot *slot;
+	gpa_t gpa;
+	gfn_t gfn;
+
+	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+
+	/*
+	 * SPP VM exit happened while executing iret from NMI,
+	 * "blocked by NMI" bit has to be set before next VM entry.
+	 * There are errata that may cause this bit to not be set:
+	 * AAK134, BY25.
+	 */
+	if (!(to_vmx(vcpu)->idt_vectoring_info & VECTORING_INFO_VALID_MASK) &&
+	    (exit_qualification & SPPT_INTR_INFO_UNBLOCK_NMI))
+		vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
+			      GUEST_INTR_STATE_NMI);
+
+	vcpu->arch.exit_qualification = exit_qualification;
+	if (exit_qualification & SPPT_INDUCED_EXIT_TYPE) {
+		struct kvm_subpage spp_info = {0};
+		int ret;
+
+		/*
+		 * SPPT missing
+		 * We don't set SPP write access for the corresponding
+		 * GPA, if we haven't setup, we need to construct
+		 * SPP table here.
+		 */
+		pr_info("SPP - SPPT entry missing!\n");
+		gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
+		gfn = gpa >> PAGE_SHIFT;
+		slot = gfn_to_memslot(vcpu->kvm, gfn);
+		if (!slot)
+		      return -EFAULT;
+
+		/*
+		 * if the target gfn is not protected, but SPPT is
+		 * traversed now, regard this as some kind of fault.
+		 */
+		spp_info.base_gfn = gfn;
+		spp_info.npages = 1;
+
+		spin_lock(&(vcpu->kvm->mmu_lock));
+		ret = kvm_mmu_get_subpages(vcpu->kvm, &spp_info, true);
+		if (ret == 1) {
+			kvm_mmu_setup_spp_structure(vcpu,
+				spp_info.access_map[0], gfn);
+		}
+		spin_unlock(&(vcpu->kvm->mmu_lock));
+
+		return 1;
+
+	}
+
+	/*
+	 * SPPT Misconfig
+	 * This is probably caused by some mis-configuration in SPPT
+	 * entries, cannot handle it here, escalate the fault to
+	 * emulator.
+	 */
+	WARN_ON(1);
+	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
+	vcpu->run->hw.hardware_exit_reason = EXIT_REASON_SPP;
+	pr_alert("SPP - SPPT Misconfiguration!\n");
+	return 0;
+}
+
 static int handle_invpcid(struct kvm_vcpu *vcpu)
 {
 	u32 vmx_instruction_info;
@@ -5530,6 +5600,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_INVVPID]                 = handle_vmx_instruction,
 	[EXIT_REASON_RDRAND]                  = handle_invalid_op,
 	[EXIT_REASON_RDSEED]                  = handle_invalid_op,
+	[EXIT_REASON_SPP]                     = handle_spp,
 	[EXIT_REASON_XSAVES]                  = handle_xsaves,
 	[EXIT_REASON_XRSTORS]                 = handle_xrstors,
 	[EXIT_REASON_PML_FULL]		      = handle_pml_full,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5754f8d21e7d..caff0ed1eeaf 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -244,6 +244,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_SPP              28
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -399,6 +400,10 @@ struct kvm_run {
 		struct {
 			__u8 vector;
 		} eoi;
+		/* KVM_EXIT_SPP */
+		struct {
+			__u64 addr;
+		} spp;
 		/* KVM_EXIT_HYPERV */
 		struct kvm_hyperv_exit hyperv;
 		/* Fix the size of the union. */
-- 
2.17.2

