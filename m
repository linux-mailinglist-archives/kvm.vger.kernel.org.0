Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B931D0490
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 02:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbfJIAD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 20:03:59 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:45011 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfJIAD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 20:03:59 -0400
Received: by mail-pf1-f201.google.com with SMTP id b204so448991pfb.11
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 17:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DBDb8BfaknlNbargZmd/ZeQvvg2C+ScBJir7YYzrA3A=;
        b=Ov5hRXOp8JezlYy2XfVC13k85lvlRmOvrkPRZx5+aN9h4UMwPwcilkS9MrOzKLTpjR
         DHwTKrDZLVTtsoDo+pMukDIJwZcJ8Rh7dCFDNdYMt0CvRnaToVvomK1JhDKi62ti6OmP
         D8hMskJoawY4Bt1oMOuelkjHDqhNB/0BgU6hZYjnsmiF+dazIm10ZHQ9gBGJ4C9WW8dl
         n8Bp4swvrJOX8IntZTVYrj62ObLnqdq6EgQSlNB9vasTWAztyukxFeZYCirCFOUGgcdr
         fn50scQVi5IcA2WE/Eeg1ZpnVW2DsBErXRO81LyTLlMf/1lTtR9BA7JIfkTTLUJ5oXt8
         Z16A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DBDb8BfaknlNbargZmd/ZeQvvg2C+ScBJir7YYzrA3A=;
        b=CA9opw/XfDmod0E1xN+mPgbpt81C+dNF+4eX7Z6/cyCEthWM9b39srB9G4Mm25y0qh
         ibFaiWwe1Cbi9s84FoFFLM2HrSi4DltE0+3H9lQJTKUZGEkOFE/6ncBwFttf9HVz+Bn7
         9PHNhSDyZjLlq2y9D3DP3FaP0Q6jqga4arHBl2Iq2Te8/BGdEaGyhwsQ8AJsP9OuQ2hv
         QN5h1WZq51rxWJR1F/JzK39O+g8Kj8DR3ZXSK7Bv/oHcUVpwRYFh04b1HqWJQCTAZTa7
         B4dHxOTnilT6z+aLEn5OHlbnsKRqRiwW4emIz07xGbyhbqyjHr1/VfPM0uH59Yx4LbQ+
         CL3Q==
X-Gm-Message-State: APjAAAVuyvA/fn9cNcY7WxXy548BodYbpYd1/erE8/USmxpwrJ6l/s9E
        mvyJKUA+d9eTtyj3S6UEa533PkPJVrYiftyZmjimxq2rhCvGVqbt+9Ywmu9GGi3pfxZ511pk/nv
        RjNCa2FvxUob7I/MPozeY4AD7L5mku+gKTcntRAvpVcrPOtOYdCMVwdd4it997uM=
X-Google-Smtp-Source: APXvYqxFeZ1joLfl36DQgk6mr/O1kki+ykH+SEZeS7vZ8iyBWu+mq5a5Wze897RxbtB5xbrfK4c99vgvCLXdmQ==
X-Received: by 2002:a63:e013:: with SMTP id e19mr1246596pgh.274.1570579435580;
 Tue, 08 Oct 2019 17:03:55 -0700 (PDT)
Date:   Tue,  8 Oct 2019 17:03:43 -0700
Message-Id: <20191009000343.13495-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH v2] KVM: nVMX: Don't leak L1 MMIO regions to L2
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the "virtualize APIC accesses" VM-execution control is set in the
VMCS, the APIC virtualization hardware is triggered when a page walk
in VMX non-root mode terminates at a PTE wherein the address of the 4k
page frame matches the APIC-access address specified in the VMCS. On
hardware, the APIC-access address may be any valid 4k-aligned physical
address.

KVM's nVMX implementation enforces the additional constraint that the
APIC-access address specified in the vmcs12 must be backed by
cacheable memory in L1. If not, L0 will simply clear the "virtualize
APIC accesses" VM-execution control in the vmcs02.

The problem with this approach is that the L1 guest has arranged the
vmcs12 EPT tables--or shadow page tables, if the "enable EPT"
VM-execution control is clear in the vmcs12--so that the L2 guest
physical address(es)--or L2 guest linear address(es)--that reference
the L2 APIC map to the APIC-access address specified in the
vmcs12. Without the "virtualize APIC accesses" VM-execution control in
the vmcs02, the APIC accesses in the L2 guest will directly access the
APIC-access page in L1.

When there is no mapping whatsoever for the APIC-access address in L1,
the L2 VM just loses the intended APIC virtualization. However, when
the APIC-access address is mapped to an MMIO region in L1, the L2
guest gets direct access to the L1 MMIO device. For example, if the
APIC-access address specified in the vmcs12 is 0xfee00000, then L2
gets direct access to L1's APIC.

Since this vmcs12 configuration is something that KVM cannot
faithfully emulate, the appropriate response is to exit to userspace
with KVM_INTERNAL_ERROR_EMULATION.

Fixes: fe3ef05c7572 ("KVM: nVMX: Prepare vmcs02 from vmcs01 and vmcs12")
Reported-by: Dan Cross <dcross@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 v1 -> v2: Added enum enter_vmx_status
 
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/nested.c       | 65 +++++++++++++++++++--------------
 arch/x86/kvm/vmx/nested.h       | 13 ++++++-
 arch/x86/kvm/x86.c              |  8 +++-
 4 files changed, 56 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 50eb430b0ad8..24d6598dea29 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1189,7 +1189,7 @@ struct kvm_x86_ops {
 	int (*set_nested_state)(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				struct kvm_nested_state *kvm_state);
-	void (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
+	bool (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
 
 	int (*smi_allowed)(struct kvm_vcpu *vcpu);
 	int (*pre_enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e76eb4f07f6c..626539d06311 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2917,7 +2917,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 						 struct vmcs12 *vmcs12);
 
-static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
+static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -2937,19 +2937,18 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 			vmx->nested.apic_access_page = NULL;
 		}
 		page = kvm_vcpu_gpa_to_page(vcpu, vmcs12->apic_access_addr);
-		/*
-		 * If translation failed, no matter: This feature asks
-		 * to exit when accessing the given address, and if it
-		 * can never be accessed, this feature won't do
-		 * anything anyway.
-		 */
 		if (!is_error_page(page)) {
 			vmx->nested.apic_access_page = page;
 			hpa = page_to_phys(vmx->nested.apic_access_page);
 			vmcs_write64(APIC_ACCESS_ADDR, hpa);
 		} else {
-			secondary_exec_controls_clearbit(vmx,
-				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
+			pr_debug_ratelimited("%s: non-cacheable APIC-access address in vmcs12\n",
+					     __func__);
+			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+			vcpu->run->internal.suberror =
+				KVM_INTERNAL_ERROR_EMULATION;
+			vcpu->run->internal.ndata = 0;
+			return false;
 		}
 	}
 
@@ -2994,6 +2993,7 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 		exec_controls_setbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
 	else
 		exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
+	return true;
 }
 
 /*
@@ -3032,13 +3032,15 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 /*
  * If from_vmentry is false, this is being called from state restore (either RSM
  * or KVM_SET_NESTED_STATE).  Otherwise it's called from vmlaunch/vmresume.
-+ *
-+ * Returns:
-+ *   0 - success, i.e. proceed with actual VMEnter
-+ *   1 - consistency check VMExit
-+ *  -1 - consistency check VMFail
+ *
+ * Returns:
+ *	ENTER_VMX_SUCCESS: Successfully entered VMX non-root mode
+ *	ENTER_VMX_VMFAIL:  Consistency check VMFail
+ *	ENTER_VMX_VMEXIT:  Consistency check VMExit
+ *	ENTER_VMX_ERROR:   KVM internal error
  */
-int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
+enum enter_vmx_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
+						     bool from_vmentry)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -3081,11 +3083,12 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	prepare_vmcs02_early(vmx, vmcs12);
 
 	if (from_vmentry) {
-		nested_get_vmcs12_pages(vcpu);
+		if (unlikely(!nested_get_vmcs12_pages(vcpu)))
+			return ENTER_VMX_ERROR;
 
 		if (nested_vmx_check_vmentry_hw(vcpu)) {
 			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
-			return -1;
+			return ENTER_VMX_VMFAIL;
 		}
 
 		if (nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
@@ -3149,7 +3152,7 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	 * returned as far as L1 is concerned. It will only return (and set
 	 * the success flag) when L2 exits (see nested_vmx_vmexit()).
 	 */
-	return 0;
+	return ENTER_VMX_SUCCESS;
 
 	/*
 	 * A failed consistency check that leads to a VMExit during L1's
@@ -3165,14 +3168,14 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
 	if (!from_vmentry)
-		return 1;
+		return ENTER_VMX_VMEXIT;
 
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
 	vmcs12->exit_qualification = exit_qual;
 	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
-	return 1;
+	return ENTER_VMX_VMEXIT;
 }
 
 /*
@@ -3182,9 +3185,9 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 {
 	struct vmcs12 *vmcs12;
+	enum enter_vmx_status status;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 interrupt_shadow = vmx_get_interrupt_shadow(vcpu);
-	int ret;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -3244,13 +3247,19 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	 * the nested entry.
 	 */
 	vmx->nested.nested_run_pending = 1;
-	ret = nested_vmx_enter_non_root_mode(vcpu, true);
-	vmx->nested.nested_run_pending = !ret;
-	if (ret > 0)
-		return 1;
-	else if (ret)
-		return nested_vmx_failValid(vcpu,
-			VMXERR_ENTRY_INVALID_CONTROL_FIELD);
+	status = nested_vmx_enter_non_root_mode(vcpu, true);
+	if (status != ENTER_VMX_SUCCESS) {
+		vmx->nested.nested_run_pending = 0;
+		switch (status) {
+		case ENTER_VMX_VMFAIL:
+			return nested_vmx_failValid(vcpu,
+				VMXERR_ENTRY_INVALID_CONTROL_FIELD);
+		case ENTER_VMX_VMEXIT:
+			return 1;
+		case ENTER_VMX_ERROR:
+			return 0;
+		}
+	}
 
 	/* Hide L1D cache contents from the nested guest.  */
 	vmx->vcpu.arch.l1tf_flush_l1d = true;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 187d39bf0bf1..07cf5cef86f6 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -6,6 +6,16 @@
 #include "vmcs12.h"
 #include "vmx.h"
 
+/*
+ * Status returned by nested_vmx_enter_non_root_mode():
+ */
+enum enter_vmx_status {
+	ENTER_VMX_SUCCESS,	/* Successfully entered VMX non-root mode */
+	ENTER_VMX_VMFAIL,	/* Consistency check VMFail */
+	ENTER_VMX_VMEXIT,	/* Consistency check VMExit */
+	ENTER_VMX_ERROR,	/* KVM internal error */
+};
+
 void vmx_leave_nested(struct kvm_vcpu *vcpu);
 void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
 				bool apicv);
@@ -13,7 +23,8 @@ void nested_vmx_hardware_unsetup(void);
 __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
 void nested_vmx_vcpu_setup(void);
 void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
-int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry);
+enum enter_vmx_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
+						     bool from_vmentry);
 bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason);
 void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 		       u32 exit_intr_info, unsigned long exit_qualification);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 661e2bf38526..2cf26f159071 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7941,8 +7941,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	bool req_immediate_exit = false;
 
 	if (kvm_request_pending(vcpu)) {
-		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu))
-			kvm_x86_ops->get_vmcs12_pages(vcpu);
+		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
+			if (unlikely(!kvm_x86_ops->get_vmcs12_pages(vcpu))) {
+				r = 0;
+				goto out;
+			}
+		}
 		if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
 			kvm_mmu_unload(vcpu);
 		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
-- 
2.23.0.581.g78d2f28ef7-goog

