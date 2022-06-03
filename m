Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1700A53C278
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241391AbiFCAvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240596AbiFCAra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:30 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B89E3819F
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:45 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id p2-20020a170902e74200b00164081f682cso3464547plf.16
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=caX/Iwva7KZjPf9D4zGbZUtTlsxAdWPspT3KNS02YNc=;
        b=iqN4A3YbUmgT9VeFBFw9qZJ/KLrlJwkaMoXIGyH1AbPVxkzbiyO5/di/EdcdkT+wID
         zjGUV4PQLtBZyOBWeVek0rI1fhpp127fhXnYlqKe7PFnEEib3IcB+YJQdcMG2PhzxBF7
         eLPgeNaRLvmPq3ebhnp3RneDSskuipXsE7BtWclW9E48SqGJqVV98HMu04SD2nnlLUm7
         z1cYq5buYfKII2e2clWOIKO1tuQ9YySx8f/zJk0jcSd727BgW5asrWQvmjztPJl1lNt4
         pgya/QaVr6a8KQLKOFZlyAf8eIbxsPRAY1lKHIS/25dqGueuu4CiPF9014a7qe/5bmjf
         He6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=caX/Iwva7KZjPf9D4zGbZUtTlsxAdWPspT3KNS02YNc=;
        b=6BATlhNRPC9cn5KSt70TfNp5dnw6GInYC79/ZfluRBQaJH6Fd78aIXRXbk9G0VOnSB
         x6cNx9zbquyKdzttUx6BBfRayo3m5iQyfUnn70MFGOnzYrvJZSrQ/c1EO1DCzL+oKS8M
         u3aqc4FZvXlKIDhQCrbG1VcnIPdvlDlg1cVnjm2yRH7cq/2m3OccAimd+Z43zuJgtP6J
         /1IRktPFioBTRpmokaOhIzXMi4Xy8sltCjD7EJJF7QrPGNPag2L8joYhWplfMbxhkHkc
         7z5CCNfaMgff/q9oKdZWGg1Y6ve29jH3FRazIipO8KCHFZQvqvFxJXRIWGc5XY/25itx
         kVjA==
X-Gm-Message-State: AOAM531bttjZjErUSrXd+LTVO4wOp5h1ZV1cfwlN751H7mwbeSiWv70x
        gR8TqK+bsYz3RHRczFu2yXLu55wycUA=
X-Google-Smtp-Source: ABdhPJyCTa+Fvtw58OYPuRxxwE4mQD/9HU8NkhcWBLMv1zyCAc7pwvK8LE+HwoUeNjvv0AaQkHN0tM1lxN8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:84c:b0:519:1f69:2224 with SMTP id
 q12-20020a056a00084c00b005191f692224mr7659832pfk.13.1654217204466; Thu, 02
 Jun 2022 17:46:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:51 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-105-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 104/144] KVM: selftests: Convert psci_test away from VCPU_ID
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

Pass around 'struct kvm_vcpu' objects in psci_test instead of relying on
global VCPU_IDs.  Ideally, the test wouldn't have to manually create
vCPUs and thus care about vCPU IDs, but it's not the end of the world and
avoiding that behavior isn't guaranteed to be a net positive (an attempt
at macro shenanigans did not go very well).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c | 50 +++++++++----------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 347cb5c130e2..d9695a939cc9 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -17,9 +17,6 @@
 #include "processor.h"
 #include "test_util.h"
 
-#define VCPU_ID_SOURCE 0
-#define VCPU_ID_TARGET 1
-
 #define CPU_ON_ENTRY_ADDR 0xfeedf00dul
 #define CPU_ON_CONTEXT_ID 0xdeadc0deul
 
@@ -64,16 +61,17 @@ static uint64_t psci_features(uint32_t func_id)
 	return res.a0;
 }
 
-static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
+static void vcpu_power_off(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mp_state mp_state = {
 		.mp_state = KVM_MP_STATE_STOPPED,
 	};
 
-	vcpu_mp_state_set(vm, vcpuid, &mp_state);
+	vcpu_mp_state_set(vcpu->vm, vcpu->id, &mp_state);
 }
 
-static struct kvm_vm *setup_vm(void *guest_code)
+static struct kvm_vm *setup_vm(void *guest_code, struct kvm_vcpu **source,
+			       struct kvm_vcpu **target)
 {
 	struct kvm_vcpu_init init;
 	struct kvm_vm *vm;
@@ -84,28 +82,28 @@ static struct kvm_vm *setup_vm(void *guest_code)
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
 
-	aarch64_vcpu_add(vm, VCPU_ID_SOURCE, &init, guest_code);
-	aarch64_vcpu_add(vm, VCPU_ID_TARGET, &init, guest_code);
+	*source = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	*target = aarch64_vcpu_add(vm, 1, &init, guest_code);
 
 	return vm;
 }
 
-static void enter_guest(struct kvm_vm *vm, uint32_t vcpuid)
+static void enter_guest(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc;
 
-	vcpu_run(vm, vcpuid);
-	if (get_ucall(vm, vcpuid, &uc) == UCALL_ABORT)
+	vcpu_run(vcpu->vm, vcpu->id);
+	if (get_ucall(vcpu->vm, vcpu->id, &uc) == UCALL_ABORT)
 		TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0], __FILE__,
 			  uc.args[1]);
 }
 
-static void assert_vcpu_reset(struct kvm_vm *vm, uint32_t vcpuid)
+static void assert_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	uint64_t obs_pc, obs_x0;
 
-	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), &obs_pc);
-	get_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
+	get_reg(vcpu->vm, vcpu->id, ARM64_CORE_REG(regs.pc), &obs_pc);
+	get_reg(vcpu->vm, vcpu->id, ARM64_CORE_REG(regs.regs[0]), &obs_x0);
 
 	TEST_ASSERT(obs_pc == CPU_ON_ENTRY_ADDR,
 		    "unexpected target cpu pc: %lx (expected: %lx)",
@@ -133,25 +131,26 @@ static void guest_test_cpu_on(uint64_t target_cpu)
 
 static void host_test_cpu_on(void)
 {
+	struct kvm_vcpu *source, *target;
 	uint64_t target_mpidr;
 	struct kvm_vm *vm;
 	struct ucall uc;
 
-	vm = setup_vm(guest_test_cpu_on);
+	vm = setup_vm(guest_test_cpu_on, &source, &target);
 
 	/*
 	 * make sure the target is already off when executing the test.
 	 */
-	vcpu_power_off(vm, VCPU_ID_TARGET);
+	vcpu_power_off(target);
 
-	get_reg(vm, VCPU_ID_TARGET, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
-	vcpu_args_set(vm, VCPU_ID_SOURCE, 1, target_mpidr & MPIDR_HWID_BITMASK);
-	enter_guest(vm, VCPU_ID_SOURCE);
+	get_reg(vm, target->id, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &target_mpidr);
+	vcpu_args_set(vm, source->id, 1, target_mpidr & MPIDR_HWID_BITMASK);
+	enter_guest(source);
 
-	if (get_ucall(vm, VCPU_ID_SOURCE, &uc) != UCALL_DONE)
+	if (get_ucall(vm, source->id, &uc) != UCALL_DONE)
 		TEST_FAIL("Unhandled ucall: %lu", uc.cmd);
 
-	assert_vcpu_reset(vm, VCPU_ID_TARGET);
+	assert_vcpu_reset(target);
 	kvm_vm_free(vm);
 }
 
@@ -169,16 +168,17 @@ static void guest_test_system_suspend(void)
 
 static void host_test_system_suspend(void)
 {
+	struct kvm_vcpu *source, *target;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 
-	vm = setup_vm(guest_test_system_suspend);
+	vm = setup_vm(guest_test_system_suspend, &source, &target);
 	vm_enable_cap(vm, KVM_CAP_ARM_SYSTEM_SUSPEND, 0);
 
-	vcpu_power_off(vm, VCPU_ID_TARGET);
-	run = vcpu_state(vm, VCPU_ID_SOURCE);
+	vcpu_power_off(target);
+	run = source->run;
 
-	enter_guest(vm, VCPU_ID_SOURCE);
+	enter_guest(source);
 
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
 		    "Unhandled exit reason: %u (%s)",
-- 
2.36.1.255.ge46751e96f-goog

