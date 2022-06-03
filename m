Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2156053C1C1
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239654AbiFCArY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240231AbiFCAp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:26 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D9D344DE
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:25 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id z12-20020a170903018c00b001651395dcb8so3470555plg.12
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vajAbei/4C9mgrY+khRdf/uO0MSBsnVlUWjUXwWT13A=;
        b=YBqmkltO8ZZtK+njPxAFiv4uwwmyejmw9f58OdVdsGRpxHPQC2zKRN5WchZRp43HyO
         CD+a7Nmx+Mfx5s+IBgp22ieMcadRD0aQ2cOSZId3c3rveZwqa6AMI7A3MEgCQ0UVKWIq
         evAKk20wYTic48pbMoOBTkOqxo/CoaMWZZLhpfaLE5FhUMbb85x3e76S3AQJr0ooykB1
         9YRpjdDqPMOzNoVt4651LIXtUtGgMdCLDIJnHcIyHvskvQt5Q9AglEnLJegKWN/3q1g4
         P3A5BJlRLQaZUQD28xb7ywfc9j6JWRy3RqYgDuo+ZdSX/xZd+P5IBeJRLbALiepi9MtF
         fooA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vajAbei/4C9mgrY+khRdf/uO0MSBsnVlUWjUXwWT13A=;
        b=dnaTKbVsf47bHggb79/t4KTHmLSKthZRNMklwuSpv1U/P4HfM5sOw5PiZq7vXizB5d
         AkdDnTOHhm7YM1+RsLe26jmV39ZZRB67iqfo6Td8RI6seyz4GN1GX2womHJ5g0pDqMyI
         Gc7WsLqYt8Yj2EEGeequSznstdso9PTUUtP9cIOchQ1onr+JPtXkYnTj3JwBenib8Y9L
         64efAmgOGklHxLtEe343qkV+kbL0ZCa/NBhXGDkXRvLtb41PI0UTzH1+jfgJLaMyAX5W
         AnE4TXJPh/LveTGhTbmpjt5A1hjZ5GliS+G+4s/3Czt4xsVaX9IOQPUPYEk381U6vLSG
         J6eg==
X-Gm-Message-State: AOAM530EPiKj0Zd8MeCxW7h6GzinQS5j48ohtY5MyKxH1RdsfiPLlcKq
        uy7D3UbS+dmkGwX4Yqzc4bmKYKstI2o=
X-Google-Smtp-Source: ABdhPJyv4tJ6letBnTpa9q3pxcZ30aBmjpQbG1UGieNBULB12H7dmnj54b5JOSGj/rCKuh95A4buphRC/lU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:74d:0:b0:3fc:8fd3:c23b with SMTP id
 74-20020a63074d000000b003fc8fd3c23bmr6589692pgh.392.1654217124985; Thu, 02
 Jun 2022 17:45:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:06 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-60-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 059/144] KVM: selftests: Convert smm_test away from VCPU_ID
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert smm_test to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note, this
is a "functional" change in the sense that the test now creates a vCPU
with vcpu_id==0 instead of vcpu_id==1.  The non-zero VCPU_ID was 100%
arbitrary and added little to no validation coverage.  If testing
non-zero vCPU IDs is desirable for generic tests, that can be done in the
future by tweaking the VM creation helpers.

Opportunistically use vcpu_run() instead of _vcpu_run(), the test expects
KVM_RUN to succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/smm_test.c | 37 +++++++++----------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index dd2c1522ab90..36165b774a28 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -19,8 +19,6 @@
 #include "vmx.h"
 #include "svm_util.h"
 
-#define VCPU_ID	      1
-
 #define SMRAM_SIZE 65536
 #define SMRAM_MEMSLOT ((1 << 16) | 1)
 #define SMRAM_PAGES (SMRAM_SIZE / PAGE_SIZE)
@@ -116,22 +114,23 @@ static void guest_code(void *arg)
 	sync_with_host(DONE);
 }
 
-void inject_smi(struct kvm_vm *vm)
+void inject_smi(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_events events;
 
-	vcpu_events_get(vm, VCPU_ID, &events);
+	vcpu_events_get(vcpu->vm, vcpu->id, &events);
 
 	events.smi.pending = 1;
 	events.flags |= KVM_VCPUEVENT_VALID_SMM;
 
-	vcpu_events_set(vm, VCPU_ID, &events);
+	vcpu_events_set(vcpu->vm, vcpu->id, &events);
 }
 
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t nested_gva = 0;
 
+	struct kvm_vcpu *vcpu;
 	struct kvm_regs regs;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
@@ -139,9 +138,9 @@ int main(int argc, char *argv[])
 	int stage, stage_reported;
 
 	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	run = vcpu_state(vm, VCPU_ID);
+	run = vcpu->run;
 
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, SMRAM_GPA,
 				    SMRAM_MEMSLOT, SMRAM_PAGES, 0);
@@ -152,7 +151,7 @@ int main(int argc, char *argv[])
 	memcpy(addr_gpa2hva(vm, SMRAM_GPA) + 0x8000, smi_handler,
 	       sizeof(smi_handler));
 
-	vcpu_set_msr(vm, VCPU_ID, MSR_IA32_SMBASE, SMRAM_GPA);
+	vcpu_set_msr(vm, vcpu->id, MSR_IA32_SMBASE, SMRAM_GPA);
 
 	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
 		if (nested_svm_supported())
@@ -164,17 +163,17 @@ int main(int argc, char *argv[])
 	if (!nested_gva)
 		pr_info("will skip SMM test with VMX enabled\n");
 
-	vcpu_args_set(vm, VCPU_ID, 1, nested_gva);
+	vcpu_args_set(vm, vcpu->id, 1, nested_gva);
 
 	for (stage = 1;; stage++) {
-		_vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Stage %d: unexpected exit reason: %u (%s),\n",
 			    stage, run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
 		memset(&regs, 0, sizeof(regs));
-		vcpu_regs_get(vm, VCPU_ID, &regs);
+		vcpu_regs_get(vm, vcpu->id, &regs);
 
 		stage_reported = regs.rax & 0xff;
 
@@ -191,7 +190,7 @@ int main(int argc, char *argv[])
 		 * return from it. Do not perform save/restore while in SMM yet.
 		 */
 		if (stage == 8) {
-			inject_smi(vm);
+			inject_smi(vcpu);
 			continue;
 		}
 
@@ -200,15 +199,15 @@ int main(int argc, char *argv[])
 		 * during L2 execution.
 		 */
 		if (stage == 10)
-			inject_smi(vm);
+			inject_smi(vcpu);
 
-		state = vcpu_save_state(vm, VCPU_ID);
+		state = vcpu_save_state(vm, vcpu->id);
 		kvm_vm_release(vm);
-		kvm_vm_restart(vm);
-		vm_vcpu_add(vm, VCPU_ID);
-		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
-		vcpu_load_state(vm, VCPU_ID, state);
-		run = vcpu_state(vm, VCPU_ID);
+
+		vcpu = vm_recreate_with_one_vcpu(vm);
+		vcpu_set_cpuid(vm, vcpu->id, kvm_get_supported_cpuid());
+		vcpu_load_state(vm, vcpu->id, state);
+		run = vcpu->run;
 		kvm_x86_state_cleanup(state);
 	}
 
-- 
2.36.1.255.ge46751e96f-goog

