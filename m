Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC40AC002
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 20:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405146AbfIFS75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 14:59:57 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:45347 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729790AbfIFS75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 14:59:57 -0400
Received: by mail-pg1-f201.google.com with SMTP id i12so3870592pgm.12
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 11:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2LI5oCHBJ4+di3wYUteHFQEnU1+M8HQU/92dv+apGkM=;
        b=maT/bg7g4TtNqrIFSwhu2ZQaiiqnJMd2JWbEIbi0SMD9CSwBmMCs3tcV65BXanY+Ov
         3ExsV0RcQ8fMQXjazOavotXqTZcHnYrSC56TXwdwLk8GdM78fDYPFY+j+rW8+HrMGsNR
         /4/oYTx6cEAUgx29NpQwNo6+/DD7vqqUG8dm5jk/WtCE1UmPF7M2nx40OUXGXU/AHOFr
         qw64rRPXwBhUeoV2Zx/K5O2O8uM9Y/UYLgt7blFjHlzyUciPK5bZwHGkAqA1ukA4njcU
         wZZAOHkcM13T3brSjdQ0AV/PZvdPUh8gJHjOWcgguUsRhH+VvLqQxwT6GT3wFuNPQbnf
         OK7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2LI5oCHBJ4+di3wYUteHFQEnU1+M8HQU/92dv+apGkM=;
        b=YAixGlyY0c5HCNQNkpRi23+k4on+PHBOe0M0+osC3DIKmiQZWidUyA51znfXID07nS
         XyJ1eko6xZoWE1l9SmM9fvRZIGfCom0Bag3F+fwKKdnv11evxWVeiTyfBto9OXnLs/1S
         SRdoz/9c4yuQPTc0mkkN/R3H9k5kwWiV2mxo2nbEtwgwgbugCTRMOv/VKE70/5oD+CeS
         4xnbtQpFD0nUP00fC74vIGSLH+v7Zm2fWDF8bEODWXhsOvfRlbhxxceyPeu8BC9U4OPY
         8vWuG4vSWnDLeQtAcdksWqBeiJSoASAbQoSE2NDaWczvrIak7HjahNlkOgms2YKH59UQ
         TKFA==
X-Gm-Message-State: APjAAAVtfDg4VbnpDcBezvDVJc8xr3+v5sfDCN9bg35jSCmU5l8p4nhU
        hudoa/p/GfvKqf/dUaGbcTL3d/+X1IYc41OcgsrVJsnfrZKRoIfxcjzdAkSaPv9JrdUAD+ZGBpW
        TTeYw6sFiQD3JQF6lc8NUa064Okz/uRabCRDhLP9jUHhFTZiZVGbcvX/zbjMQbJU=
X-Google-Smtp-Source: APXvYqwGDO//F5Xovg1g38E2cBFbvHQ2Nqx67Ny5J1pbtFk5T5yuMqNwEQ0nzwj2CKMH1+Xfc9fK2Cs0RFXnag==
X-Received: by 2002:a63:1f1f:: with SMTP id f31mr9112786pgf.353.1567796395708;
 Fri, 06 Sep 2019 11:59:55 -0700 (PDT)
Date:   Fri,  6 Sep 2019 11:59:45 -0700
Message-Id: <20190906185945.230946-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [RFC][PATCH] KVM: nVMX: Don't leak L1 MMIO regions to L2
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Dan Cross <dcross@google.com>,
        Marc Orr <marcorr@google.com>, Peter Shier <pshier@google.com>
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

When L0 has no mapping whatsoever for the APIC-access address in L1,
the L2 VM just loses the intended APIC virtualization. However, when
the L2 APIC-access address is mapped to an MMIO region in L1, the L2
guest gets direct access to the L1 MMIO device. For example, if the
APIC-access address specified in the vmcs12 is 0xfee00000, then L2
gets direct access to L1's APIC.

Fixing this correctly is complicated. Since this vmcs12 configuration
is something that KVM cannot faithfully emulate, the appropriate
response is to exit to userspace with
KVM_INTERNAL_ERROR_EMULATION. Sadly, the kvm-unit-tests fail, so I'm
posting this as an RFC.

Note that the 'Code' line emitted by qemu in response to this error
shows the guest %rip two instructions after the
vmlaunch/vmresume. Hmmm.

Fixes: fe3ef05c7572 ("KVM: nVMX: Prepare vmcs02 from vmcs01 and vmcs12")
Reported-by: Dan Cross <dcross@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Dan Cross <dcross@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/nested.c       | 55 ++++++++++++++++++++++-----------
 arch/x86/kvm/x86.c              |  9 ++++--
 3 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 74e88e5edd9cf..e95acf8c82b47 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1191,7 +1191,7 @@ struct kvm_x86_ops {
 	int (*set_nested_state)(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				struct kvm_nested_state *kvm_state);
-	void (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
+	int (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
 
 	int (*smi_allowed)(struct kvm_vcpu *vcpu);
 	int (*pre_enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ced9fba32598d..bdf5a11816fa4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2871,7 +2871,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 						 struct vmcs12 *vmcs12);
 
-static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
+static int nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -2891,19 +2891,31 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
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
+			/*
+			 * Since there is no backing page, we can't
+			 * just rely on the usual L1 GPA -> HPA
+			 * translation mechanism to do the right
+			 * thing. We'd have to assign an appropriate
+			 * HPA for the L1 APIC-access address, and
+			 * then we'd have to modify the MMU to ensure
+			 * that the L1 APIC-access address is mapped
+			 * to the assigned HPA if and only if an L2 VM
+			 * with that APIC-access address and the
+			 * "virtualize APIC accesses" VM-execution
+			 * control set in the vmcs12 is running. For
+			 * now, just admit defeat.
+			 */
+			pr_warn_ratelimited("Unsupported vmcs12 APIC-access address\n");
+			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+			vcpu->run->internal.suberror =
+				KVM_INTERNAL_ERROR_EMULATION;
+			vcpu->run->internal.ndata = 0;
+			return -ENOTSUPP;
 		}
 	}
 
@@ -2948,6 +2960,7 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 		exec_controls_setbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
 	else
 		exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
+	return 0;
 }
 
 /*
@@ -2986,11 +2999,12 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
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
+ * < 0 - error
+ *   0 - success, i.e. proceed with actual VMEnter
+ *   1 - consistency check VMExit
+ *   2 - consistency check VMFail
  */
 int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 {
@@ -2999,6 +3013,7 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	bool evaluate_pending_interrupts;
 	u32 exit_reason = EXIT_REASON_INVALID_STATE;
 	u32 exit_qual;
+	int r;
 
 	evaluate_pending_interrupts = exec_controls_get(vmx) &
 		(CPU_BASED_VIRTUAL_INTR_PENDING | CPU_BASED_VIRTUAL_NMI_PENDING);
@@ -3035,11 +3050,13 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	prepare_vmcs02_early(vmx, vmcs12);
 
 	if (from_vmentry) {
-		nested_get_vmcs12_pages(vcpu);
+		r = nested_get_vmcs12_pages(vcpu);
+		if (unlikely(r))
+			return r;
 
 		if (nested_vmx_check_vmentry_hw(vcpu)) {
 			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
-			return -1;
+			return 2;
 		}
 
 		if (nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
@@ -3200,9 +3217,11 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	vmx->nested.nested_run_pending = 1;
 	ret = nested_vmx_enter_non_root_mode(vcpu, true);
 	vmx->nested.nested_run_pending = !ret;
-	if (ret > 0)
+	if (ret < 0)
+		return 0;
+	if (ret == 1)
 		return 1;
-	else if (ret)
+	if (ret)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 290c3c3efb877..5ddbf16c8b108 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7803,8 +7803,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	bool req_immediate_exit = false;
 
 	if (kvm_request_pending(vcpu)) {
-		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu))
-			kvm_x86_ops->get_vmcs12_pages(vcpu);
+		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
+			r = kvm_x86_ops->get_vmcs12_pages(vcpu);
+			if (unlikely(r)) {
+				r = 0;
+				goto out;
+			}
+		}
 		if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
 			kvm_mmu_unload(vcpu);
 		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
-- 
2.23.0.187.g17f5b7556c-goog

