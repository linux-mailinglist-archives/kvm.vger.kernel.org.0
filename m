Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19732373E55
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 17:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbhEEPTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 11:19:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25913 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233518AbhEEPTb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 11:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620227914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2cjee6yQu7vV7qJHRoncxYttHg8xImu02njEOaTK0X0=;
        b=djuSnTJ6wrRuQq38LpYYe27DffDe3PU5beuKAB08PWVC9ViktNdK+JnV17oWhjQ4ftvAif
        zLHsr5j17VogMIV245ODiFpeGPGQ0EOM9/pofGj2NP9wWENEqOkvrrcL8v5JDTPFejV3Nz
        Pb4flIzbxAviQ47JbsroN6qWIhE1bGk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-kuEzN2QmNOywIhdM_L1GXw-1; Wed, 05 May 2021 11:18:31 -0400
X-MC-Unique: kuEzN2QmNOywIhdM_L1GXw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 373F810066E7;
        Wed,  5 May 2021 15:18:30 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72ECA5C1A3;
        Wed,  5 May 2021 15:18:28 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: selftests: evmcs_test: Check that VMCS12 is alway properly synced to eVMCS after restore
Date:   Wed,  5 May 2021 17:18:22 +0200
Message-Id: <20210505151823.1341678-3-vkuznets@redhat.com>
In-Reply-To: <20210505151823.1341678-1-vkuznets@redhat.com>
References: <20210505151823.1341678-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test for the regression, introduced by commit f2c7ef3ba955
("KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit"). When
L2->L1 exit is forced immediately after restoring nested state,
KVM_REQ_GET_NESTED_STATE_PAGES request is cleared and VMCS12 changes
(e.g. fresh RIP) are not reflected to eVMCS. The consequent nested
vCPU run gets broken.

Utilize NMI injection to do the job.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 66 +++++++++++++++----
 1 file changed, 55 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index b01f64ac6ce3..63096cea26c6 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -18,30 +18,52 @@
 #include "vmx.h"
 
 #define VCPU_ID		5
+#define NMI_VECTOR	2
 
 static int ud_count;
 
+void enable_x2apic(void)
+{
+	uint32_t spiv_reg = APIC_BASE_MSR + (APIC_SPIV >> 4);
+
+	wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) |
+	      MSR_IA32_APICBASE_ENABLE | MSR_IA32_APICBASE_EXTD);
+	wrmsr(spiv_reg, rdmsr(spiv_reg) | APIC_SPIV_APIC_ENABLED);
+}
+
 static void guest_ud_handler(struct ex_regs *regs)
 {
 	ud_count++;
 	regs->rip += 3; /* VMLAUNCH */
 }
 
+static void guest_nmi_handler(struct ex_regs *regs)
+{
+}
+
 void l2_guest_code(void)
 {
 	GUEST_SYNC(7);
 
 	GUEST_SYNC(8);
 
+	/* Forced exit to L1 upon restore */
+	GUEST_SYNC(9);
+
 	/* Done, exit to L1 and never come back.  */
 	vmcall();
 }
 
-void l1_guest_code(struct vmx_pages *vmx_pages)
+void guest_code(struct vmx_pages *vmx_pages)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 
+	enable_x2apic();
+
+	GUEST_SYNC(1);
+	GUEST_SYNC(2);
+
 	enable_vp_assist(vmx_pages->vp_assist_gpa, vmx_pages->vp_assist);
 
 	GUEST_ASSERT(vmx_pages->vmcs_gpa);
@@ -63,21 +85,22 @@ void l1_guest_code(struct vmx_pages *vmx_pages)
 	current_evmcs->revision_id = EVMCS_VERSION;
 	GUEST_SYNC(6);
 
+	current_evmcs->pin_based_vm_exec_control |=
+		PIN_BASED_NMI_EXITING;
 	GUEST_ASSERT(!vmlaunch());
 	GUEST_ASSERT(vmptrstz() == vmx_pages->enlightened_vmcs_gpa);
-	GUEST_SYNC(9);
+
+	/*
+	 * NMI forces L2->L1 exit, resuming L2 and hope that EVMCS is
+	 * up-to-date (RIP points where it should and not at the beginning
+	 * of l2_guest_code(). GUEST_SYNC(9) checkes that.
+	 */
 	GUEST_ASSERT(!vmresume());
-	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
-	GUEST_SYNC(10);
-}
 
-void guest_code(struct vmx_pages *vmx_pages)
-{
-	GUEST_SYNC(1);
-	GUEST_SYNC(2);
+	GUEST_SYNC(10);
 
-	if (vmx_pages)
-		l1_guest_code(vmx_pages);
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	GUEST_SYNC(11);
 
 	/* Try enlightened vmptrld with an incorrect GPA */
 	evmcs_vmptrld(0xdeadbeef, vmx_pages->enlightened_vmcs);
@@ -86,6 +109,18 @@ void guest_code(struct vmx_pages *vmx_pages)
 	GUEST_DONE();
 }
 
+void inject_nmi(struct kvm_vm *vm)
+{
+	struct kvm_vcpu_events events;
+
+	vcpu_events_get(vm, VCPU_ID, &events);
+
+	events.nmi.pending = 1;
+	events.flags |= KVM_VCPUEVENT_VALID_NMI_PENDING;
+
+	vcpu_events_set(vm, VCPU_ID, &events);
+}
+
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t vmx_pages_gva = 0;
@@ -120,6 +155,9 @@ int main(int argc, char *argv[])
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
 	vm_handle_exception(vm, UD_VECTOR, guest_ud_handler);
+	vm_handle_exception(vm, NMI_VECTOR, guest_nmi_handler);
+
+	pr_info("Running L1 which uses EVMCS to run L2\n");
 
 	for (stage = 1;; stage++) {
 		_vcpu_run(vm, VCPU_ID);
@@ -166,6 +204,12 @@ int main(int argc, char *argv[])
 		TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
 			    "Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
 			    (ulong) regs2.rdi, (ulong) regs2.rsi);
+
+		/* Force immediate L2->L1 exit before resuming */
+		if (stage == 8) {
+			pr_info("Injecting NMI into L1 before L2 had a chance to run after restore\n");
+			inject_nmi(vm);
+		}
 	}
 
 done:
-- 
2.30.2

