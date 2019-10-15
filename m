Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21456D6C62
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfJOANW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:13:22 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:49492 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfJOANW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:13:22 -0400
Received: by mail-pf1-f201.google.com with SMTP id i28so14510594pfq.16
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 17:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=iGDRzknINDn0+B93DptfXcI+TwD7kEgqFN68Grd2F8Y=;
        b=hU105J9tpqf9aT0TOAEBRqoIhUmNDvDXnttHVWK11xUoDdpwHT0Tb3a+k5y8GZNB+a
         1Y7NqlGjL2iAQRyVA1+tTb6C5Zg5rA1TIMz8eHG7fjnbkmUebM2kRn+LoGoZx7Z0//tu
         o6y9gGWWxsXMEuhosWpnmvC1zONFMzQ5hQfJYnS89TE7iIXlJPMAjhcugbZzf8yKpR6K
         AkXHSm9IiEmZauYcVS2gPVpkWsV+/+Y1+MepEAm3vzAyFhUWdkxh2Mg2WUxP3eyxvD6x
         NBnCsV7vvIouFaZ746UwX7Evv1+fxg7gEtR4NP3hgCQ7FThWfTsBbFCD+kka+6xVr8SQ
         ElWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=iGDRzknINDn0+B93DptfXcI+TwD7kEgqFN68Grd2F8Y=;
        b=bhVIJ6z4dk6cn3gdzlouAs8cjv9zvikf35tr3QC23Dq7wxMk5XVzBfHcN7KiLjbD+B
         a9EcBaZ4csWenBaP2QgaCLOEdaBURNMJM1dEgovDNBVH3MAAO5Yo0hgcRM4TaftwMo5W
         1rlqT9/KpSVDb5yyqwHCBAKcorFP6f3/PzxKtm751Y8qf37/hAOYZjgcdiJU4n1PRkhN
         7s2cCzkhruYzTCDlX58g1gHSgmDJoiE3aWz0HVZu408J8DWtRnT9LNXSRocwT35GluDw
         Qjqc8ILnp7rGWlLijE3pS7UD6JneCz+T0fQWwJH/SUfNK5b96klvilndjw5GWFlvmbko
         DGKA==
X-Gm-Message-State: APjAAAXX1kLp0ehjVM/kL97EsZU9S7iNH2MfB2kF4H00+arpP2Rh/50y
        +YmFUElSBzvdpA7SS4gpQhxgT+uyVk5IK9wzAdLm/YhkXfEi0r98jNk+oO7336dK7wHxnB58UYB
        a1Sft+fWANDbTDwxww0VcNpz2W8duQuRQxpgf10o1+WKAZ63b8uvVqI2kbqpi5I0=
X-Google-Smtp-Source: APXvYqyN7Kg2qR0orsXOte5Y3fdXctBv5m74xHUd/xFHdFVLyOlPij+jzmF6FRY/G00Zu2DieBfrO4xseTbjPw==
X-Received: by 2002:a63:1511:: with SMTP id v17mr35070452pgl.34.1571098399231;
 Mon, 14 Oct 2019 17:13:19 -0700 (PDT)
Date:   Mon, 14 Oct 2019 17:13:04 -0700
Message-Id: <20191015001304.2304-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH v4] KVM: nVMX: Don't leak L1 MMIO regions to L2
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
a "struct page" in L1. If not, L0 will simply clear the "virtualize
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
v3 -> v4: Changed enum enter_vmx_status to enum nvmx_vmentry_status;
          clarified debug message in nested_get_vmcs12_pages();
          moved nested_vmx_enter_non_root_mode() error handling in
	  nested_vmx_run() out-of-line
v2 -> v3: Added default case to new switch in nested_vmx_run
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
index e76eb4f07f6c..f8e93eb9786b 100644
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
+			pr_debug_ratelimited("%s: no backing 'struct page' for APIC-access address in vmcs12\n",
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
+ *	NVMX_ENTRY_SUCCESS: Entered VMX non-root mode
+ *	NVMX_ENTRY_VMFAIL:  Consistency check VMFail
+ *	NVMX_ENTRY_VMEXIT:  Consistency check VMExit
+ *	NVMX_ENTRY_KVM_INTERNAL_ERROR: KVM internal error
  */
-int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
+enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
+							bool from_vmentry)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -3081,11 +3083,12 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	prepare_vmcs02_early(vmx, vmcs12);
 
 	if (from_vmentry) {
-		nested_get_vmcs12_pages(vcpu);
+		if (unlikely(!nested_get_vmcs12_pages(vcpu)))
+			return NVMX_VMENTRY_KVM_INTERNAL_ERROR;
 
 		if (nested_vmx_check_vmentry_hw(vcpu)) {
 			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
-			return -1;
+			return NVMX_VMENTRY_VMFAIL;
 		}
 
 		if (nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
@@ -3149,7 +3152,7 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	 * returned as far as L1 is concerned. It will only return (and set
 	 * the success flag) when L2 exits (see nested_vmx_vmexit()).
 	 */
-	return 0;
+	return NVMX_VMENTRY_SUCCESS;
 
 	/*
 	 * A failed consistency check that leads to a VMExit during L1's
@@ -3165,14 +3168,14 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
 	if (!from_vmentry)
-		return 1;
+		return NVMX_VMENTRY_VMEXIT;
 
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
 	vmcs12->exit_qualification = exit_qual;
 	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
-	return 1;
+	return NVMX_VMENTRY_VMEXIT;
 }
 
 /*
@@ -3182,9 +3185,9 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 {
 	struct vmcs12 *vmcs12;
+	enum nvmx_vmentry_status status;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 interrupt_shadow = vmx_get_interrupt_shadow(vcpu);
-	int ret;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -3244,13 +3247,9 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
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
+	if (unlikely(status != NVMX_VMENTRY_SUCCESS))
+		goto vmentry_failed;
 
 	/* Hide L1D cache contents from the nested guest.  */
 	vmx->vcpu.arch.l1tf_flush_l1d = true;
@@ -3281,6 +3280,16 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		return kvm_vcpu_halt(vcpu);
 	}
 	return 1;
+
+vmentry_failed:
+	vmx->nested.nested_run_pending = 0;
+	if (status == NVMX_VMENTRY_KVM_INTERNAL_ERROR)
+		return 0;
+	if (status == NVMX_VMENTRY_VMEXIT)
+		return 1;
+	WARN_ON_ONCE(status != NVMX_VMENTRY_VMFAIL);
+	return nested_vmx_failValid(vcpu,
+				    VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 187d39bf0bf1..6280f33e5fa6 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -6,6 +6,16 @@
 #include "vmcs12.h"
 #include "vmx.h"
 
+/*
+ * Status returned by nested_vmx_enter_non_root_mode():
+ */
+enum nvmx_vmentry_status {
+	NVMX_VMENTRY_SUCCESS,		/* Entered VMX non-root mode */
+	NVMX_VMENTRY_VMFAIL,		/* Consistency check VMFail */
+	NVMX_VMENTRY_VMEXIT,		/* Consistency check VMExit */
+	NVMX_VMENTRY_KVM_INTERNAL_ERROR,/* KVM internal error */
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
+enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
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
2.23.0.700.g56cf767bdb-goog

