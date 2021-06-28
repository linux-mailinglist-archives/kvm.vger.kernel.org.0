Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42A13B5CAF
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 12:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhF1Kro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 06:47:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232844AbhF1Kr0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 06:47:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624877100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F0+NBW7qBQ7cBUyynW2X2gJClnPYzTrBen51EL1SI5c=;
        b=ZgKUxO8URqQYJLCf/ok185DjdEmOz8Waq1CEIjyUmDBveq8b/qcrR8H/dUp4R4v30V/Bv5
        lA8lXPMPQ/YhvINE/AwygWFzMfkDQMV5wVBWVZj0pxcr75p2AUJ7XuUoQu8stw7hO+SRnG
        Aq4QVA7G24Xz7FYbmU/ChPGUzNHNHZw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-njyxgn3AO5SBnxDZTTKO7g-1; Mon, 28 Jun 2021 06:44:58 -0400
X-MC-Unique: njyxgn3AO5SBnxDZTTKO7g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A75E4100C668;
        Mon, 28 Jun 2021 10:44:57 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8B755C1CF;
        Mon, 28 Jun 2021 10:44:54 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] KVM: selftests: smm_test: Test SMM enter from L2
Date:   Mon, 28 Jun 2021 12:44:25 +0200
Message-Id: <20210628104425.391276-7-vkuznets@redhat.com>
In-Reply-To: <20210628104425.391276-1-vkuznets@redhat.com>
References: <20210628104425.391276-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two additional tests are added:
- SMM triggered from L2 does not currupt L1 host state.
- Save/restore during SMM triggered from L2 does not corrupt guest/host
  state.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/smm_test.c | 70 +++++++++++++++++--
 1 file changed, 64 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index c1f831803ad2..d0fe2fdce58c 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -53,15 +53,28 @@ static inline void sync_with_host(uint64_t phase)
 		     : "+a" (phase));
 }
 
-void self_smi(void)
+static void self_smi(void)
 {
 	x2apic_write_reg(APIC_ICR,
 			 APIC_DEST_SELF | APIC_INT_ASSERT | APIC_DM_SMI);
 }
 
-void guest_code(void *arg)
+static void l2_guest_code(void)
 {
+	sync_with_host(8);
+
+	sync_with_host(10);
+
+	vmcall();
+}
+
+static void guest_code(void *arg)
+{
+	#define L2_GUEST_STACK_SIZE 64
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	uint64_t apicbase = rdmsr(MSR_IA32_APICBASE);
+	struct svm_test_data *svm = arg;
+	struct vmx_pages *vmx_pages = arg;
 
 	sync_with_host(1);
 
@@ -74,21 +87,50 @@ void guest_code(void *arg)
 	sync_with_host(4);
 
 	if (arg) {
-		if (cpu_has_svm())
-			generic_svm_setup(arg, NULL, NULL);
-		else
-			GUEST_ASSERT(prepare_for_vmx_operation(arg));
+		if (cpu_has_svm()) {
+			generic_svm_setup(svm, l2_guest_code,
+					  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+		} else {
+			GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+			GUEST_ASSERT(load_vmcs(vmx_pages));
+			prepare_vmcs(vmx_pages, l2_guest_code,
+				     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+		}
 
 		sync_with_host(5);
 
 		self_smi();
 
 		sync_with_host(7);
+
+		if (cpu_has_svm()) {
+			run_guest(svm->vmcb, svm->vmcb_gpa);
+			svm->vmcb->save.rip += 3;
+			run_guest(svm->vmcb, svm->vmcb_gpa);
+		} else {
+			vmlaunch();
+			vmresume();
+		}
+
+		/* Stages 8-11 are eaten by SMM (SMRAM_STAGE reported instead) */
+		sync_with_host(12);
 	}
 
 	sync_with_host(DONE);
 }
 
+void inject_smi(struct kvm_vm *vm)
+{
+	struct kvm_vcpu_events events;
+
+	vcpu_events_get(vm, VCPU_ID, &events);
+
+	events.smi.pending = 1;
+	events.flags |= KVM_VCPUEVENT_VALID_SMM;
+
+	vcpu_events_set(vm, VCPU_ID, &events);
+}
+
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t nested_gva = 0;
@@ -147,6 +189,22 @@ int main(int argc, char *argv[])
 			    "Unexpected stage: #%x, got %x",
 			    stage, stage_reported);
 
+		/*
+		 * Enter SMM during L2 execution and check that we correctly
+		 * return from it. Do not perform save/restore while in SMM yet.
+		 */
+		if (stage == 8) {
+			inject_smi(vm);
+			continue;
+		}
+
+		/*
+		 * Perform save/restore while the guest is in SMM triggered
+		 * during L2 execution.
+		 */
+		if (stage == 10)
+			inject_smi(vm);
+
 		state = vcpu_save_state(vm, VCPU_ID);
 		kvm_vm_release(vm);
 		kvm_vm_restart(vm, O_RDWR);
-- 
2.31.1

