Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56AD9AE103
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 00:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbfIIW21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 18:28:27 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:33148 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbfIIW20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 18:28:26 -0400
Received: by mail-pf1-f201.google.com with SMTP id z23so11554404pfn.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 15:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ksf47/iLkihsux2J4E043zbaHGjc5d9ygBfagTOkxzs=;
        b=UJs2of+LVQFrkmM2qFuN0+WXpGF4L/f2arTvfHNSVXWkKY42dv0zs5ZprRP6suC0PI
         J9IicgRdtfDD1mNsm95ypCfBMHdp9PWJHoETxHFOJT9sU5h6+XFymqbR3KYpLXaY2/CQ
         QycPmCKySCc+YBPPQpa3LVUneVuj9+92X8lSu3nKYyNsdLMqUPAhi75OedPJ2y/3KtRc
         tmYjUf2jaGhfWGu5zVLE4hNLtjVRadFwZ+hLu1IeO3YMjyqz8jw92sEJxbhuYJ4wdBKi
         H7bBIdP6i2beryTTFn82u6N6L5PUDCt8t4e01vHWSalBBYnUd6M10COqZjjvAxj9ze6Y
         Ol1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ksf47/iLkihsux2J4E043zbaHGjc5d9ygBfagTOkxzs=;
        b=ewpg0klkYBZwcX0hTJwxV62zR3jb8ln1f3Oz40g5tcjyc3YJQCros1HmCCMYVpsKhl
         /0lyEBQZQlMgYW3EK16QX43fOMrebgbrbgx99NsP9mJZC5i/J7G4hxjsERysbft/P7g/
         Rc5uku/SI5xmN7fgS0li7baUhUtrn6rUP0VVhV4Ehbt+mjXKHV68YfEEpXqAI+rNa1Ii
         dreZfSVqmTD5XP2DFYuAHyH3J0uXkhY1OyaiFDri3uDCGoBYe5sjdtJVavcrwQGioKtL
         hG+8iTbLZuGQhokXYbheu5Ls6BOaI668GJGWWDAER/P+lb4dUFinFCtXvE5BCgV4MYzR
         uuYw==
X-Gm-Message-State: APjAAAULL29TqjPSSN1gnqKqgRSAB4MVdYlqw3qzrwslE/+Gy8njLhvG
        KOQTIbHCpktgAFtUaQWVxFS0lENxZl3HWGtGJnzghvBkOHlpk8CmZy9cNb6RL0wzvGFsk5NelNK
        5rwUSYqnNbtQovlmH4Sl3qOlb3FcIIfiOD2gkORueIOqKFauXuU+OLlDIOkCrIu0=
X-Google-Smtp-Source: APXvYqzeIE8yQzHbLFP/6QbSUhVqDL9z6HVnglkqfSro6rWzrvMgf4rdL2sgr2mw1BQyO0uBsvvVbeC0Mmd52Q==
X-Received: by 2002:a63:e14d:: with SMTP id h13mr24116867pgk.431.1568068103715;
 Mon, 09 Sep 2019 15:28:23 -0700 (PDT)
Date:   Mon,  9 Sep 2019 15:28:12 -0700
In-Reply-To: <20190909222812.232690-1-jmattson@google.com>
Message-Id: <20190909222812.232690-2-jmattson@google.com>
Mime-Version: 1.0
References: <20190909222812.232690-1-jmattson@google.com>
X-Mailer: git-send-email 2.23.0.162.g0b9fbb3734-goog
Subject: [RFC][PATCH v2 1/1] KVM: nVMX: Don't leak L1 MMIO regions to L2
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
 arch/x86/kvm/vmx/nested.c       | 65 +++++++++++++++++++++------------
 arch/x86/kvm/x86.c              |  9 ++++-
 3 files changed, 49 insertions(+), 27 deletions(-)

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
index ced9fba32598d..04b5069d4a9b3 100644
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
@@ -2891,19 +2891,33 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 			vmx->nested.apic_access_page = NULL;
 		}
 		page = kvm_vcpu_gpa_to_page(vcpu, vmcs12->apic_access_addr);
-		/*
-		 * If translation failed, no matter: This feature asks
-		 * to exit when accessing the given address, and if it
-		 * can never be accessed, this feature won't do
-		 * anything anyway.
-		 */
-		if (!is_error_page(page)) {
+		if (likely(!is_error_page(page))) {
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
+			pr_warn_ratelimited("Unsupported vmcs12 APIC-access address 0x%llx\n",
+				vmcs12->apic_access_addr);
+			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+			vcpu->run->internal.suberror =
+				KVM_INTERNAL_ERROR_EMULATION;
+			vcpu->run->internal.ndata = 1;
+			vcpu->run->internal.data[0] = vmcs12->apic_access_addr;
+			return -EINTR;
 		}
 	}
 
@@ -2948,6 +2962,7 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 		exec_controls_setbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
 	else
 		exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
+	return 0;
 }
 
 /*
@@ -2986,11 +3001,11 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
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
+ * -EINTR  - exit to userspace
+ * -EINVAL - VMentry failure; continue
+ *  0      - success, i.e. proceed with actual VMEnter
  */
 int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 {
@@ -2999,6 +3014,7 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	bool evaluate_pending_interrupts;
 	u32 exit_reason = EXIT_REASON_INVALID_STATE;
 	u32 exit_qual;
+	int r;
 
 	evaluate_pending_interrupts = exec_controls_get(vmx) &
 		(CPU_BASED_VIRTUAL_INTR_PENDING | CPU_BASED_VIRTUAL_NMI_PENDING);
@@ -3035,11 +3051,15 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	prepare_vmcs02_early(vmx, vmcs12);
 
 	if (from_vmentry) {
-		nested_get_vmcs12_pages(vcpu);
+		r = nested_get_vmcs12_pages(vcpu);
+		if (unlikely(r))
+			return r;
 
 		if (nested_vmx_check_vmentry_hw(vcpu)) {
 			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
-			return -1;
+			r = nested_vmx_failValid(vcpu,
+						 VMXERR_ENTRY_INVALID_CONTROL_FIELD);
+			return r ? -EINVAL : -EINTR;
 		}
 
 		if (nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
@@ -3119,14 +3139,14 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry)
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
 	if (!from_vmentry)
-		return 1;
+		return -EINVAL;
 
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
 	vmcs12->exit_qualification = exit_qual;
 	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
-	return 1;
+	return -EINVAL;
 }
 
 /*
@@ -3200,11 +3220,8 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	vmx->nested.nested_run_pending = 1;
 	ret = nested_vmx_enter_non_root_mode(vcpu, true);
 	vmx->nested.nested_run_pending = !ret;
-	if (ret > 0)
-		return 1;
-	else if (ret)
-		return nested_vmx_failValid(vcpu,
-			VMXERR_ENTRY_INVALID_CONTROL_FIELD);
+	if (ret)
+		return ret != -EINTR;
 
 	/* Hide L1D cache contents from the nested guest.  */
 	vmx->vcpu.arch.l1tf_flush_l1d = true;
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
2.23.0.162.g0b9fbb3734-goog

