Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425C41AB2C1
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 22:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371336AbgDOUfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 16:35:11 -0400
Received: from mga17.intel.com ([192.55.52.151]:20838 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S371307AbgDOUfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 16:35:01 -0400
IronPort-SDR: tcXwW5i9eNYTmJmcktL1Znqr9YECHLqKfCS3KEBfEr93Y6mQ/mxMIT5fBS0kZ/G1ykrwzSC5N/
 dR/IKkYvH5qQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 13:34:59 -0700
IronPort-SDR: V7EtECM9YPxHzjS4I9/cKGA3WMpz3PdrRPW4TlSVxrx41uizRRFmJxhjdHIMANKawU74Ywf7u2
 u5zgOa9Dzbpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="288657654"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 15 Apr 2020 13:34:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] KVM: VMX: Cache vmcs.EXIT_INTR_INFO using arch avail_reg flags
Date:   Wed, 15 Apr 2020 13:34:54 -0700
Message-Id: <20200415203454.8296-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415203454.8296-1-sean.j.christopherson@intel.com>
References: <20200415203454.8296-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new "extended register" type, EXIT_INFO_2 (to pair with the
nomenclature in .get_exit_info()), and use it to cache VMX's
vmcs.EXIT_INTR_INFO.  Drop a comment in vmx_recover_nmi_blocking() that
is obsoleted by the generic caching mechanism.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/nested.c       |  4 ++--
 arch/x86/kvm/vmx/nested.h       |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 20 ++++++++------------
 arch/x86/kvm/vmx/vmx.h          | 14 +++++++++++++-
 5 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index faec08d49e98..fc4b959e2bce 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -171,6 +171,7 @@ enum kvm_reg {
 	VCPU_EXREG_RFLAGS,
 	VCPU_EXREG_SEGMENTS,
 	VCPU_EXREG_EXIT_INFO_1,
+	VCPU_EXREG_EXIT_INFO_2,
 };
 
 enum {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8e2d86c6140e..1b9e3ffaeadb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5418,7 +5418,7 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 
 fail:
 	nested_vmx_vmexit(vcpu, vmx->exit_reason,
-			  vmcs_read32(VM_EXIT_INTR_INFO),
+			  vmx_get_intr_info(vcpu),
 			  vmx_get_exit_qual(vcpu));
 	return 1;
 }
@@ -5648,7 +5648,7 @@ static bool nested_vmx_exit_handled_mtf(struct vmcs12 *vmcs12)
  */
 bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 {
-	u32 intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+	u32 intr_info = vmx_get_intr_info(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index d81a349e7d45..04224e9c45c5 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -86,7 +86,7 @@ static inline bool nested_ept_ad_enabled(struct kvm_vcpu *vcpu)
 static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
 					    u32 exit_reason)
 {
-	u32 exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+	u32 exit_intr_info = vmx_get_intr_info(vcpu);
 
 	/*
 	 * At this point, the exit interruption info in exit_intr_info
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 106761fde58c..9405639b11d1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5635,7 +5635,7 @@ static const int kvm_vmx_max_exit_handlers =
 static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
 {
 	*info1 = vmx_get_exit_qual(vcpu);
-	*info2 = vmcs_read32(VM_EXIT_INTR_INFO);
+	*info2 = vmx_get_intr_info(vcpu);
 }
 
 static void vmx_destroy_pml_buffer(struct vcpu_vmx *vmx)
@@ -6298,16 +6298,16 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 
 static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 {
-	vmx->exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
 
 	/* if exit due to PF check for async PF */
-	if (is_page_fault(vmx->exit_intr_info)) {
+	if (is_page_fault(intr_info)) {
 		vmx->vcpu.arch.apf.host_apf_reason = kvm_read_and_reset_pf_reason();
 	/* Handle machine checks before interrupts are enabled */
-	} else if (is_machine_check(vmx->exit_intr_info)) {
+	} else if (is_machine_check(intr_info)) {
 		kvm_machine_check();
 	/* We need to handle NMIs before interrupts are enabled */
-	} else if (is_nmi(vmx->exit_intr_info)) {
+	} else if (is_nmi(intr_info)) {
 		kvm_before_interrupt(&vmx->vcpu);
 		asm("int $2");
 		kvm_after_interrupt(&vmx->vcpu);
@@ -6322,9 +6322,8 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 	unsigned long tmp;
 #endif
 	gate_desc *desc;
-	u32 intr_info;
+	u32 intr_info = vmx_get_intr_info(vcpu);
 
-	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 	if (WARN_ONCE(!is_external_intr(intr_info),
 	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
@@ -6405,11 +6404,8 @@ static void vmx_recover_nmi_blocking(struct vcpu_vmx *vmx)
 	if (enable_vnmi) {
 		if (vmx->loaded_vmcs->nmi_known_unmasked)
 			return;
-		/*
-		 * Can't use vmx->exit_intr_info since we're not sure what
-		 * the exit reason is.
-		 */
-		exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+
+		exit_intr_info = vmx_get_intr_info(&vmx->vcpu);
 		unblock_nmi = (exit_intr_info & INTR_INFO_UNBLOCK_NMI) != 0;
 		vector = exit_intr_info & INTR_INFO_VECTOR_MASK;
 		/*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a13eafec67fc..edfb739e5907 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -451,7 +451,8 @@ static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
 				  | (1 << VCPU_EXREG_PDPTR)
 				  | (1 << VCPU_EXREG_SEGMENTS)
 				  | (1 << VCPU_EXREG_CR3)
-				  | (1 << VCPU_EXREG_EXIT_INFO_1));
+				  | (1 << VCPU_EXREG_EXIT_INFO_1)
+				  | (1 << VCPU_EXREG_EXIT_INFO_2));
 	vcpu->arch.regs_dirty = 0;
 }
 
@@ -506,6 +507,17 @@ static inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
 	return vmx->exit_qualification;
 }
 
+static inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (!kvm_register_is_available(vcpu, VCPU_EXREG_EXIT_INFO_2)) {
+		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_2);
+		vmx->exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+	}
+	return vmx->exit_intr_info;
+}
+
 struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
 void free_vmcs(struct vmcs *vmcs);
 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
-- 
2.26.0

