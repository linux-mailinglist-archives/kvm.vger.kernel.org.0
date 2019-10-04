Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA4ECC1FE
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 19:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388496AbfJDRwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 13:52:14 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:40481 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388197AbfJDRwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 13:52:14 -0400
Received: by mail-pg1-f202.google.com with SMTP id w5so4823101pgp.7
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 10:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WntMB4QMmx7jpfA4AcSP9Rfh9DukEF1gUBf1ITUKNjU=;
        b=fvBbctmYoNMlKdzP+/yqeQCccZWQxUofCw8bGUWU6Fc1Dz8dBYov18n7g7DdkJnTmS
         pq8RmPWO4EbjaBTMSUfimgqDoWJDY1EReNEF1Ac1a4sO+vD/lFH2ht0JqRtq3LV5Z/Sg
         I+108O36xZrtobANf1pOkFB11bQOvYBnhlJ2+VwAYcSGWuGYi8ufb0/Nq2AYOPDsim7v
         kXRc1ATsSC/l8IL/6XhxsDRzKfzFTwF/uzc3oMZQIMelgzRZeH1zGy7U9Agl+B6ID6bS
         tr16M/e13WSfRyNmvU0ifTZMoeTCY5xLxsG4BPeDgFa+IJXhqkXfPIlBJt2h/PVHBezn
         eEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WntMB4QMmx7jpfA4AcSP9Rfh9DukEF1gUBf1ITUKNjU=;
        b=sZ62v9GspygUbRKCAFLu9cKPhZBmBk8ojqYlqIlhSCkxrhBg5/o0fWAfb96+10V2G0
         bf467DhtXPzmrvXGA6hnkwdZlWW9EZRkyumuqOYTrNtqamAX7ywiMZq1vfvoNRWtJ0BK
         Pdb8pYcQNcAuciOrriPy+xk8sVmBaxXOhIIJcwq/XteVKh3tRXfEQjjrNSVDw4GUKDQq
         HakxjVOUZBlEP4363He/jlR4XksYI5JHLK8DRuDvADDL6ZVt1NZKG8F27VYEqEV7/IHB
         YPZpUGJI7rQpw+SXO2CY9jPMm9/XmLdD/ydt3pmM11t32ncvUAKqD2rEfL7l9mxZtNxv
         0bvw==
X-Gm-Message-State: APjAAAWijOIXY+nwLXQ6Rkqd3bSwuxPHilbNEbveMxgOYWasgvKJ1Pqz
        dudoB/2MNgglHZ03qISswGwcLqwuNgLiPsL8FudySDZToQ77wkED1k364d8J5cGlx6SJeWl/S3V
        0caYWF0VOAxxNI3rDz+wS/pYh0eeCONGPb5hRmHqCJg1ylxVk2ImWKz00gLILrKk=
X-Google-Smtp-Source: APXvYqw0JiN+azKkD0VKtjYoIW4436ghFaTlNfWz/teqGIqz5MfrW/WeI5cW+7x7vB+J6wM/S24GjFFBggDTEg==
X-Received: by 2002:a63:1c48:: with SMTP id c8mr16449251pgm.342.1570211532973;
 Fri, 04 Oct 2019 10:52:12 -0700 (PDT)
Date:   Fri,  4 Oct 2019 10:52:03 -0700
Message-Id: <20191004175203.145954-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH] KVM: nVMX: Don't leak L1 MMIO regions to L2
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Dan Cross <dcross@google.com>,
        Marc Orr <marcorr@google.com>, Peter Shier <pshier@google.com>,
        Liran Alon <liran.alon@oracle.com>
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
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Dan Cross <dcross@google.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
---
v1: Same code as the RFC.

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/nested.c       | 46 ++++++++++++++++++---------------
 arch/x86/kvm/x86.c              |  9 +++++--
 3 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 50eb430b0ad8..cc4a9e90d5f8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1189,7 +1189,7 @@ struct kvm_x86_ops {
 	int (*set_nested_state)(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				struct kvm_nested_state *kvm_state);
-	void (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
+	int (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
 
 	int (*smi_allowed)(struct kvm_vcpu *vcpu);
 	int (*pre_enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 41abc62c9a8a..7d55292a3b4b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2917,7 +2917,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 						 struct vmcs12 *vmcs12);
 
-static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
+static int nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -2937,19 +2937,16 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
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
+			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+			vcpu->run->internal.suberror =
+				KVM_INTERNAL_ERROR_EMULATION;
+			vcpu->run->internal.ndata = 0;
+			return -ENOTSUPP;
 		}
 	}
 
@@ -2994,6 +2991,7 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 		exec_controls_setbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
 	else
 		exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
+	return 0;
 }
 
 /*
@@ -3032,11 +3030,12 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
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
+ *   0 - success, i.e. proceed with actual VMEnter
+ *  -EFAULT - consistency check VMExit
+ *  -EINVAL - consistency check VMFail
+ *  -ENOTSUPP - kvm internal error
  */
 int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 {
@@ -3045,6 +3044,7 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	bool evaluate_pending_interrupts;
 	u32 exit_reason = EXIT_REASON_INVALID_STATE;
 	u32 exit_qual;
+	int r;
 
 	evaluate_pending_interrupts = exec_controls_get(vmx) &
 		(CPU_BASED_VIRTUAL_INTR_PENDING | CPU_BASED_VIRTUAL_NMI_PENDING);
@@ -3081,11 +3081,13 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	prepare_vmcs02_early(vmx, vmcs12);
 
 	if (from_vmentry) {
-		nested_get_vmcs12_pages(vcpu);
+		r = nested_get_vmcs12_pages(vcpu);
+		if (unlikely(r))
+			return r;
 
 		if (nested_vmx_check_vmentry_hw(vcpu)) {
 			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
-			return -1;
+			return -EINVAL;
 		}
 
 		if (nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
@@ -3165,14 +3167,14 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
 	if (!from_vmentry)
-		return 1;
+		return -EFAULT;
 
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
 	vmcs12->exit_qualification = exit_qual;
 	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
-	return 1;
+	return -EFAULT;
 }
 
 /*
@@ -3246,11 +3248,13 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	vmx->nested.nested_run_pending = 1;
 	ret = nested_vmx_enter_non_root_mode(vcpu, true);
 	vmx->nested.nested_run_pending = !ret;
-	if (ret > 0)
-		return 1;
-	else if (ret)
+	if (ret == -EINVAL)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_ENTRY_INVALID_CONTROL_FIELD);
+	else if (ret == -ENOTSUPP)
+		return 0;
+	else if (ret)
+		return 1;
 
 	/* Hide L1D cache contents from the nested guest.  */
 	vmx->vcpu.arch.l1tf_flush_l1d = true;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e6b5cfe3c345..e8b04560f064 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7931,8 +7931,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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
2.23.0.581.g78d2f28ef7-goog

