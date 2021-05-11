Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB1837A5A1
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 13:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhEKLVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 07:21:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34449 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231560AbhEKLVk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 07:21:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620732034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jgezwu+Ka/2x1z5dm2QC7G75OxkPVMK5k1J0nHkF7Ds=;
        b=PNPpOuqkAmZUdhPZsWbxH7VwBM6pgK3ET4nhLX1XJk28m+5y4SS1vy/CZHMB0vOZ4YEy6/
        W3D3332bHIj5aKHcpHBZUDwv9ckmbagfsCah6f4GnvkCZRtsI7ABeLSXhdE6I0b6TpmctN
        V5E4gFmBZF+V5rte/PNLhLrjX0SZcE4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-UVUDOauwOq-nIxbW-5YncQ-1; Tue, 11 May 2021 07:20:31 -0400
X-MC-Unique: UVUDOauwOq-nIxbW-5YncQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 393831922038;
        Tue, 11 May 2021 11:20:29 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 286D463C40;
        Tue, 11 May 2021 11:20:26 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 7/7] KVM: selftests: evmcs_test: Test that KVM_STATE_NESTED_EVMCS is never lost
Date:   Tue, 11 May 2021 13:19:56 +0200
Message-Id: <20210511111956.1555830-8-vkuznets@redhat.com>
In-Reply-To: <20210511111956.1555830-1-vkuznets@redhat.com>
References: <20210511111956.1555830-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do KVM_GET_NESTED_STATE/KVM_SET_NESTED_STATE for a freshly restored VM
(before the first KVM_RUN) to check that KVM_STATE_NESTED_EVMCS is not
lost.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 64 +++++++++++--------
 1 file changed, 38 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 63096cea26c6..fcef347a681a 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -121,14 +121,38 @@ void inject_nmi(struct kvm_vm *vm)
 	vcpu_events_set(vm, VCPU_ID, &events);
 }
 
+static void save_restore_vm(struct kvm_vm *vm)
+{
+	struct kvm_regs regs1, regs2;
+	struct kvm_x86_state *state;
+
+	state = vcpu_save_state(vm, VCPU_ID);
+	memset(&regs1, 0, sizeof(regs1));
+	vcpu_regs_get(vm, VCPU_ID, &regs1);
+
+	kvm_vm_release(vm);
+
+	/* Restore state in a new VM.  */
+	kvm_vm_restart(vm, O_RDWR);
+	vm_vcpu_add(vm, VCPU_ID);
+	vcpu_set_hv_cpuid(vm, VCPU_ID);
+	vcpu_enable_evmcs(vm, VCPU_ID);
+	vcpu_load_state(vm, VCPU_ID, state);
+	free(state);
+
+	memset(&regs2, 0, sizeof(regs2));
+	vcpu_regs_get(vm, VCPU_ID, &regs2);
+	TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
+		    "Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
+		    (ulong) regs2.rdi, (ulong) regs2.rsi);
+}
+
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t vmx_pages_gva = 0;
 
-	struct kvm_regs regs1, regs2;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
-	struct kvm_x86_state *state;
 	struct ucall uc;
 	int stage;
 
@@ -145,10 +169,6 @@ int main(int argc, char *argv[])
 	vcpu_set_hv_cpuid(vm, VCPU_ID);
 	vcpu_enable_evmcs(vm, VCPU_ID);
 
-	run = vcpu_state(vm, VCPU_ID);
-
-	vcpu_regs_get(vm, VCPU_ID, &regs1);
-
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
 	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
 
@@ -160,6 +180,7 @@ int main(int argc, char *argv[])
 	pr_info("Running L1 which uses EVMCS to run L2\n");
 
 	for (stage = 1;; stage++) {
+		run = vcpu_state(vm, VCPU_ID);
 		_vcpu_run(vm, VCPU_ID);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Stage %d: unexpected exit reason: %u (%s),\n",
@@ -184,32 +205,23 @@ int main(int argc, char *argv[])
 			    uc.args[1] == stage, "Stage %d: Unexpected register values vmexit, got %lx",
 			    stage, (ulong)uc.args[1]);
 
-		state = vcpu_save_state(vm, VCPU_ID);
-		memset(&regs1, 0, sizeof(regs1));
-		vcpu_regs_get(vm, VCPU_ID, &regs1);
-
-		kvm_vm_release(vm);
-
-		/* Restore state in a new VM.  */
-		kvm_vm_restart(vm, O_RDWR);
-		vm_vcpu_add(vm, VCPU_ID);
-		vcpu_set_hv_cpuid(vm, VCPU_ID);
-		vcpu_enable_evmcs(vm, VCPU_ID);
-		vcpu_load_state(vm, VCPU_ID, state);
-		run = vcpu_state(vm, VCPU_ID);
-		free(state);
-
-		memset(&regs2, 0, sizeof(regs2));
-		vcpu_regs_get(vm, VCPU_ID, &regs2);
-		TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
-			    "Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
-			    (ulong) regs2.rdi, (ulong) regs2.rsi);
+		save_restore_vm(vm);
 
 		/* Force immediate L2->L1 exit before resuming */
 		if (stage == 8) {
 			pr_info("Injecting NMI into L1 before L2 had a chance to run after restore\n");
 			inject_nmi(vm);
 		}
+
+		/*
+		 * Do KVM_GET_NESTED_STATE/KVM_SET_NESTED_STATE for a freshly
+		 * restored VM (before the first KVM_RUN) to check that
+		 * KVM_STATE_NESTED_EVMCS is not lost.
+		 */
+		if (stage == 9) {
+			pr_info("Trying extra KVM_GET_NESTED_STATE/KVM_SET_NESTED_STATE cycle\n");
+			save_restore_vm(vm);
+		}
 	}
 
 done:
-- 
2.30.2

