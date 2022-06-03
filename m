Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8901353C24A
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241293AbiFCAuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240351AbiFCAqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:46:16 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5456E37A2E
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:01 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u8-20020a170903124800b0015195a5826cso3488182plh.4
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OFLQqpJRLs58KrhhkZb6+gQWiDmX7dNznfgAbSlqFoo=;
        b=Cbhl635RYSZVwyWEP4isXkfBfLhNsYe/YgU4FNSCGISjvDygUQvjNjjEA+l7olz8v8
         Qppi5HcDfIqa7FW6dWXnNpHLNCXyWQSPfwrk0EnUtLNVis25p2lqL6UVCz9XTth2zvMX
         7tgiQPTqmRayoAiIcdtOQg+sNqddlcuVn5laFzflA7ZkvskGeZCt1R9ukFLgSOXlZn4I
         C1X/P5XY1mqPDEFGKTLN2PBKmgmi6SuW5dGfH0st/g7agyBWml6AyVhFoCXX+Z4V0KJr
         Mc3R6gPq83Z/7ArDMdDsuvSvpr5Ayv3ioy+3lqkO2v6HSUq0L87vu6RKY7fXOwptDfnE
         EeOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OFLQqpJRLs58KrhhkZb6+gQWiDmX7dNznfgAbSlqFoo=;
        b=8D+R1sA1zxulogPEkCVSf4q333P0OxlnBBIYHBoVdTC+56vKiaRt1dDZdB/netqhxT
         KvHYj1YniEGLnzhFDb5ela0a0QnN+WJtOvZxWnv4skUvaNcfSPyBDEja33g38t4frj2h
         3/cSlQoY3cClPTs14yGmdthimgwBJkTR/daGWrkm/IPOPEZxMvpUBQz3c+Nu2QIYaXar
         srfzDfFphmQMV1tMeyJuBapHpg77JjZ+7/prHvP8PUG9ASxFnJ9TWUQHQjGp4ONsHs9m
         TsgbTImDI02t3jzTbN70mHNkwwFTHAAYuhtm/kLzeKE3Zo1trdr9iiCYMop3ugmD98W8
         Q95A==
X-Gm-Message-State: AOAM531YLVeai3KxITN1UwNnosa8qLRHrYH4ql/VhUiO0y/ixS5FPlv0
        72tI7HPIChfoqxyPWmNXC4SPS1ZcNfk=
X-Google-Smtp-Source: ABdhPJyK0JeLi4hBCaQzbT5qvjaUTc5iug1glZRlK78sCTglCK+DYjGJnR9qBSEPzE91LKAu2AfkMbTYdRg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a04:b0:51b:6ea0:43ca with SMTP id
 p4-20020a056a000a0400b0051b6ea043camr7690420pfh.78.1654217160805; Thu, 02 Jun
 2022 17:46:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:26 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-80-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 079/144] KVM: selftests: Convert evmcs_test away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 52 +++++++++----------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 78668605f673..ba39042a5d96 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -18,8 +18,6 @@
 
 #include "vmx.h"
 
-#define VCPU_ID		5
-
 static int ud_count;
 
 static void guest_ud_handler(struct ex_regs *regs)
@@ -159,55 +157,56 @@ void guest_code(struct vmx_pages *vmx_pages)
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
@@ -216,28 +215,29 @@ int main(int argc, char *argv[])
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
@@ -255,12 +255,12 @@ int main(int argc, char *argv[])
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
@@ -270,7 +270,7 @@ int main(int argc, char *argv[])
 		 */
 		if (stage == 9) {
 			pr_info("Trying extra KVM_GET_NESTED_STATE/KVM_SET_NESTED_STATE cycle\n");
-			save_restore_vm(vm);
+			vcpu = save_restore_vm(vm, vcpu);
 		}
 	}
 
-- 
2.36.1.255.ge46751e96f-goog

