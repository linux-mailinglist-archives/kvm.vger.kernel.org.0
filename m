Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243C051B33E
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379693AbiEDW5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357141AbiEDWz5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:55:57 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934C054F89
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:34 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id a11-20020a170902900b00b0015ebbae6dd9so1372615plp.6
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=A3AngictKVCvOwccmzZdCyAVvTQR9sel/WEjdnxWuGM=;
        b=AbcuypW/Sf0dQg3F4xR9puemy2Zvz1DZeotDpKdc1E2uGEYbJ5YlMiLOWv5nk8IeMd
         mNF5kivTTbz2v4iC3DV+ODXPYdDs+PzPqm0hJPxgGhL1BOrxCRkrfsQJOFZf4UbF/q0P
         Az9AXxWoKsfMq3jKPA/Ikm+Fhazx4ptNjqPLu7DcmHkGGSuZ1DNsOp1fSRLyX7xpqSYX
         OAKG8QIMZBTCGuERkTv3zFus4j2bTeGwsULKHNQZ5lwmqrdQNU6x3E2+hidxIT9Lvm6p
         g0Sj4tXvwNQTcYnWp0JVLAI1MNKCb8Gg/XMxJ0yV/XFJ5TJ2Zy4kj7f02OiLTML1Z6ef
         Yshg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=A3AngictKVCvOwccmzZdCyAVvTQR9sel/WEjdnxWuGM=;
        b=hzPcVVSBcLMtzV7yjluKZ0/qPEfRcjulQ80X3IDAa2tjMKOI/+RHWPY69QIX/cXmUj
         TSYzEDpQ3dMGU5Q8w4crzUMFqDa6LZyACeglbgQnPMeEPVNQmRe58Rp+Xs1GVwSOXIds
         OBHiCkQ0evDibb2DUpQOA+h0+L/h8GMwsYOPoCR3QVOYf0l9pzmr4InLR7HQhmS7BSHv
         uKZdoQbzR0simSzDdUmJbYyG+FBP1nXuRxlyeCZI09Zei58rrVnBx8zkrcpi3Kg0OFe0
         WzHqoIBW4UkXxYD3hottAaFKXzZ4RIBpu8PgFqX7EMfNNSMsXijmh3hmuBxnkx+aqqg9
         76jA==
X-Gm-Message-State: AOAM532mDRSFnB6C5AjyOT49KNDlbXYzSpE73efdT5dD9/oxFidVCYOz
        ty/G8cWI6+hgvsYzR4Ky8ILWadafnls=
X-Google-Smtp-Source: ABdhPJzrYOpXDXFYlTupvnVAOy1TTDL8jI+oMwN0m8tn+IOMKEV+CUobGCbvB1IuPYwysjf3uxZamH3aWvM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:eb87:b0:15e:be95:a3f3 with SMTP id
 q7-20020a170902eb8700b0015ebe95a3f3mr8264578plg.38.1651704694112; Wed, 04 May
 2022 15:51:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:17 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-72-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 071/128] KVM: selftests: Convert evmcs_test away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert evmcs_test to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note, this is
a "functional" change in the sense that the test now creates a vCPU with
vcpu_id==0 instead of vcpu_id==5.  The non-zero VCPU_ID was 100% arbitrary
and added little to no validation coverage.  If testing non-zero vCPU IDs
is desirable for generic tests, that can be done in the future by tweaking
the VM creation helpers.

Opportunistically use vcpu_run() instead of _vcpu_run(), the test expects
KVM_RUN to succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 51 ++++++++++---------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index f97049ab045f..dc7c1eb28fd4 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -18,7 +18,6 @@
 
 #include "vmx.h"
 
-#define VCPU_ID		5
 #define NMI_VECTOR	2
 
 static int ud_count;
@@ -160,55 +159,56 @@ void guest_code(struct vmx_pages *vmx_pages)
 	GUEST_DONE();
 }
 
-void inject_nmi(struct kvm_vm *vm)
+void inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_events events;
 
-	vcpu_events_get(vm, VCPU_ID, &events);
+	vcpu_events_get(vcpu->vm, vcpu->id, &events);
 
 	events.nmi.pending = 1;
 	events.flags |= KVM_VCPUEVENT_VALID_NMI_PENDING;
 
-	vcpu_events_set(vm, VCPU_ID, &events);
+	vcpu_events_set(vcpu->vm, vcpu->id, &events);
 }
 
-static void save_restore_vm(struct kvm_vm *vm)
+static struct kvm_vcpu *save_restore_vm(struct kvm_vm *vm,
+					struct kvm_vcpu *vcpu)
 {
 	struct kvm_regs regs1, regs2;
 	struct kvm_x86_state *state;
 
-	state = vcpu_save_state(vm, VCPU_ID);
+	state = vcpu_save_state(vm, vcpu->id);
 	memset(&regs1, 0, sizeof(regs1));
-	vcpu_regs_get(vm, VCPU_ID, &regs1);
+	vcpu_regs_get(vm, vcpu->id, &regs1);
 
 	kvm_vm_release(vm);
 
 	/* Restore state in a new VM.  */
-	kvm_vm_restart(vm);
-	vm_vcpu_add(vm, VCPU_ID);
-	vcpu_set_hv_cpuid(vm, VCPU_ID);
-	vcpu_enable_evmcs(vm, VCPU_ID);
-	vcpu_load_state(vm, VCPU_ID, state);
+	vcpu = vm_recreate_with_one_vcpu(vm);
+	vcpu_set_hv_cpuid(vm, vcpu->id);
+	vcpu_enable_evmcs(vm, vcpu->id);
+	vcpu_load_state(vm, vcpu->id, state);
 	kvm_x86_state_cleanup(state);
 
 	memset(&regs2, 0, sizeof(regs2));
-	vcpu_regs_get(vm, VCPU_ID, &regs2);
+	vcpu_regs_get(vm, vcpu->id, &regs2);
 	TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
 		    "Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
 		    (ulong) regs2.rdi, (ulong) regs2.rsi);
+	return vcpu;
 }
 
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t vmx_pages_gva = 0;
 
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct ucall uc;
 	int stage;
 
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	if (!nested_vmx_supported() ||
 	    !kvm_check_cap(KVM_CAP_NESTED_STATE) ||
@@ -217,28 +217,29 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	vcpu_set_hv_cpuid(vm, VCPU_ID);
-	vcpu_enable_evmcs(vm, VCPU_ID);
+	vcpu_set_hv_cpuid(vm, vcpu->id);
+	vcpu_enable_evmcs(vm, vcpu->id);
 
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+	vcpu_args_set(vm, vcpu->id, 1, vmx_pages_gva);
 
 	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vcpu_init_descriptor_tables(vm, vcpu->id);
 	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
 	vm_install_exception_handler(vm, NMI_VECTOR, guest_nmi_handler);
 
 	pr_info("Running L1 which uses EVMCS to run L2\n");
 
 	for (stage = 1;; stage++) {
-		run = vcpu_state(vm, VCPU_ID);
-		_vcpu_run(vm, VCPU_ID);
+		run = vcpu->run;
+
+		vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Stage %d: unexpected exit reason: %u (%s),\n",
 			    stage, run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
 		      		  __FILE__, uc.args[1]);
@@ -256,12 +257,12 @@ int main(int argc, char *argv[])
 			    uc.args[1] == stage, "Stage %d: Unexpected register values vmexit, got %lx",
 			    stage, (ulong)uc.args[1]);
 
-		save_restore_vm(vm);
+		vcpu = save_restore_vm(vm, vcpu);
 
 		/* Force immediate L2->L1 exit before resuming */
 		if (stage == 8) {
 			pr_info("Injecting NMI into L1 before L2 had a chance to run after restore\n");
-			inject_nmi(vm);
+			inject_nmi(vcpu);
 		}
 
 		/*
@@ -271,7 +272,7 @@ int main(int argc, char *argv[])
 		 */
 		if (stage == 9) {
 			pr_info("Trying extra KVM_GET_NESTED_STATE/KVM_SET_NESTED_STATE cycle\n");
-			save_restore_vm(vm);
+			vcpu = save_restore_vm(vm, vcpu);
 		}
 	}
 
-- 
2.36.0.464.gb9c8b46e94-goog

