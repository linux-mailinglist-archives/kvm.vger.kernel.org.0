Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D7551B2B0
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiEDW5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379421AbiEDWzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:55:14 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB28F53B71
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:51:22 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id v10-20020a17090a0c8a00b001c7a548e4f7so3575745pja.2
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qKw4Ti9nW07pbD2l/E1MeddYDwfHdD7IGfce1L1a7hk=;
        b=iJ8wwoUr9PEQS6y/cOFupgX34pu04rHoH/DloUUTlZtbRyLiksG+ldd56yze90AZA/
         IjBBIQbsn73D+Pg+w4RCXsGAJurXb+LNgg2pqGGSUKe4nZFvyxmmCk/bPPMvMar0KZVu
         MNxnm1UGyLLlLAj3NBCV9YvarFIQRMdD4F3rk6BLXe4t2IgDBJ7J4aCPDJAMJ3YdIb6/
         YEyo06tWgBEfIkkAbLMRRorBzmB/A3ZIT3U2Ml5Nv81mOxcAVttp4j6mvCuq4hKgomW2
         +gKxN7TBggBpdLud3XItly4Jsa0M2rPMRYwINbY5yEtR/JTrkbfeN0OUz+xGxHTIE9Wg
         HnyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qKw4Ti9nW07pbD2l/E1MeddYDwfHdD7IGfce1L1a7hk=;
        b=yGWfcXVYwhlwtS1njShTeyKLtTax/0KQ6pgYQBzDJQjdmIaYdlouH6m85PeXjeoJam
         0QSY/vn03EEZczen0pu3OhqpjnwA4X4y5UFPwrkvZZrmZmMudzoZPkwh2DiO0GU3RsFM
         ADqT5GskWt6F8upOt4pkOO+tyNIpkYkvd3CKxcXtn7W4MQDDyS8/xVhcY3wjVXghsXru
         /eIKdmcquRlxKQCtvzctiOrbz21k+Fg9rZZM28fniK1B74JemwlR3EVJ4SjNS8pwRCtk
         CyAfmbyzy+kiwJCIeCrku1xf8Qv/X3BIY51NDTn3wamXiB0uoVn9OUIu9t7dXg2LK7jO
         7uzw==
X-Gm-Message-State: AOAM5332tK8OkuwF99v0mKtdCclW20dd8CmOKc1SReqMng3WN4HWpzgM
        85rMzHsFHdx+2cMMl0hVMZytGea+ID4=
X-Google-Smtp-Source: ABdhPJxZagYHjZNGBe5UXGJ8JD83FWCEHpdVseszlfDm2OJSVXfvmDQYowKrpmmZjf+WdGxH3Sh4lXRVHbg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1145:b0:4f6:3ebc:a79b with SMTP id
 b5-20020a056a00114500b004f63ebca79bmr22737083pfm.41.1651704681996; Wed, 04
 May 2022 15:51:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:10 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-65-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 064/128] KVM: selftests: Convert userspace_msr_exit_test away
 from VCPU_ID
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

Convert userspace_msr_exit_test to use vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.
Note, this is a "functional" change in the sense that the test now
creates a vCPU with vcpu_id==0 instead of vcpu_id==1.  The non-zero
VCPU_ID was 100% arbitrary and added little to no validation coverage.
If testing non-zero vCPU IDs is desirable for generic tests, that can be
done in the future by tweaking the VM creation helpers.

Opportunistically use vcpu_run() instead of _vcpu_run() with an open
coded assert that KVM_RUN succeeded.  Fix minor coding style violations
too.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/userspace_msr_exit_test.c      | 165 +++++++++---------
 1 file changed, 78 insertions(+), 87 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index e3e20e8848d0..e261c50fac5c 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -17,7 +17,6 @@
 #define KVM_FEP_LENGTH 5
 static int fep_available = 1;
 
-#define VCPU_ID	      1
 #define MSR_NON_EXISTENT 0x474f4f00
 
 static u64 deny_bits = 0;
@@ -395,31 +394,22 @@ static void guest_ud_handler(struct ex_regs *regs)
 	regs->rip += KVM_FEP_LENGTH;
 }
 
-static void run_guest(struct kvm_vm *vm)
+static void check_for_guest_assert(struct kvm_vcpu *vcpu)
 {
-	int rc;
-
-	rc = _vcpu_run(vm, VCPU_ID);
-	TEST_ASSERT(rc == 0, "vcpu_run failed: %d\n", rc);
-}
-
-static void check_for_guest_assert(struct kvm_vm *vm)
-{
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
 	struct ucall uc;
 
-	if (run->exit_reason == KVM_EXIT_IO &&
-		get_ucall(vm, VCPU_ID, &uc) == UCALL_ABORT) {
-			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
-				__FILE__, uc.args[1]);
+	if (vcpu->run->exit_reason == KVM_EXIT_IO &&
+	    get_ucall(vcpu->vm, vcpu->id, &uc) == UCALL_ABORT) {
+		TEST_FAIL("%s at %s:%ld",
+			  (const char *)uc.args[0], __FILE__, uc.args[1]);
 	}
 }
 
-static void process_rdmsr(struct kvm_vm *vm, uint32_t msr_index)
+static void process_rdmsr(struct kvm_vcpu *vcpu, uint32_t msr_index)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu->run;
 
-	check_for_guest_assert(vm);
+	check_for_guest_assert(vcpu);
 
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_X86_RDMSR,
 		    "Unexpected exit reason: %u (%s),\n",
@@ -450,11 +440,11 @@ static void process_rdmsr(struct kvm_vm *vm, uint32_t msr_index)
 	}
 }
 
-static void process_wrmsr(struct kvm_vm *vm, uint32_t msr_index)
+static void process_wrmsr(struct kvm_vcpu *vcpu, uint32_t msr_index)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu->run;
 
-	check_for_guest_assert(vm);
+	check_for_guest_assert(vcpu);
 
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_X86_WRMSR,
 		    "Unexpected exit reason: %u (%s),\n",
@@ -481,43 +471,43 @@ static void process_wrmsr(struct kvm_vm *vm, uint32_t msr_index)
 	}
 }
 
-static void process_ucall_done(struct kvm_vm *vm)
+static void process_ucall_done(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
-	check_for_guest_assert(vm);
+	check_for_guest_assert(vcpu);
 
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 		    "Unexpected exit reason: %u (%s)",
 		    run->exit_reason,
 		    exit_reason_str(run->exit_reason));
 
-	TEST_ASSERT(get_ucall(vm, VCPU_ID, &uc) == UCALL_DONE,
+	TEST_ASSERT(get_ucall(vcpu->vm, vcpu->id, &uc) == UCALL_DONE,
 		    "Unexpected ucall command: %lu, expected UCALL_DONE (%d)",
 		    uc.cmd, UCALL_DONE);
 }
 
-static uint64_t process_ucall(struct kvm_vm *vm)
+static uint64_t process_ucall(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu->run;
 	struct ucall uc = {};
 
-	check_for_guest_assert(vm);
+	check_for_guest_assert(vcpu);
 
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 		    "Unexpected exit reason: %u (%s)",
 		    run->exit_reason,
 		    exit_reason_str(run->exit_reason));
 
-	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	switch (get_ucall(vcpu->vm, vcpu->id, &uc)) {
 	case UCALL_SYNC:
 		break;
 	case UCALL_ABORT:
-		check_for_guest_assert(vm);
+		check_for_guest_assert(vcpu);
 		break;
 	case UCALL_DONE:
-		process_ucall_done(vm);
+		process_ucall_done(vcpu);
 		break;
 	default:
 		TEST_ASSERT(false, "Unexpected ucall");
@@ -526,41 +516,43 @@ static uint64_t process_ucall(struct kvm_vm *vm)
 	return uc.cmd;
 }
 
-static void run_guest_then_process_rdmsr(struct kvm_vm *vm, uint32_t msr_index)
+static void run_guest_then_process_rdmsr(struct kvm_vcpu *vcpu,
+					 uint32_t msr_index)
 {
-	run_guest(vm);
-	process_rdmsr(vm, msr_index);
+	vcpu_run(vcpu->vm, vcpu->id);
+	process_rdmsr(vcpu, msr_index);
 }
 
-static void run_guest_then_process_wrmsr(struct kvm_vm *vm, uint32_t msr_index)
+static void run_guest_then_process_wrmsr(struct kvm_vcpu *vcpu,
+					 uint32_t msr_index)
 {
-	run_guest(vm);
-	process_wrmsr(vm, msr_index);
+	vcpu_run(vcpu->vm, vcpu->id);
+	process_wrmsr(vcpu, msr_index);
 }
 
-static uint64_t run_guest_then_process_ucall(struct kvm_vm *vm)
+static uint64_t run_guest_then_process_ucall(struct kvm_vcpu *vcpu)
 {
-	run_guest(vm);
-	return process_ucall(vm);
+	vcpu_run(vcpu->vm, vcpu->id);
+	return process_ucall(vcpu);
 }
 
-static void run_guest_then_process_ucall_done(struct kvm_vm *vm)
+static void run_guest_then_process_ucall_done(struct kvm_vcpu *vcpu)
 {
-	run_guest(vm);
-	process_ucall_done(vm);
+	vcpu_run(vcpu->vm, vcpu->id);
+	process_ucall_done(vcpu);
 }
 
-static void test_msr_filter_allow(void) {
+static void test_msr_filter_allow(void)
+{
 	struct kvm_enable_cap cap = {
 		.cap = KVM_CAP_X86_USER_SPACE_MSR,
 		.args[0] = KVM_MSR_EXIT_REASON_FILTER,
 	};
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int rc;
 
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code_filter_allow);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_filter_allow);
 
 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
 	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
@@ -572,43 +564,43 @@ static void test_msr_filter_allow(void) {
 	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_allow);
 
 	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vcpu_init_descriptor_tables(vm, vcpu->id);
 
 	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
 
 	/* Process guest code userspace exits. */
-	run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
-	run_guest_then_process_wrmsr(vm, MSR_IA32_XSS);
-	run_guest_then_process_wrmsr(vm, MSR_IA32_XSS);
+	run_guest_then_process_rdmsr(vcpu, MSR_IA32_XSS);
+	run_guest_then_process_wrmsr(vcpu, MSR_IA32_XSS);
+	run_guest_then_process_wrmsr(vcpu, MSR_IA32_XSS);
 
-	run_guest_then_process_rdmsr(vm, MSR_IA32_FLUSH_CMD);
-	run_guest_then_process_wrmsr(vm, MSR_IA32_FLUSH_CMD);
-	run_guest_then_process_wrmsr(vm, MSR_IA32_FLUSH_CMD);
+	run_guest_then_process_rdmsr(vcpu, MSR_IA32_FLUSH_CMD);
+	run_guest_then_process_wrmsr(vcpu, MSR_IA32_FLUSH_CMD);
+	run_guest_then_process_wrmsr(vcpu, MSR_IA32_FLUSH_CMD);
 
-	run_guest_then_process_wrmsr(vm, MSR_NON_EXISTENT);
-	run_guest_then_process_rdmsr(vm, MSR_NON_EXISTENT);
+	run_guest_then_process_wrmsr(vcpu, MSR_NON_EXISTENT);
+	run_guest_then_process_rdmsr(vcpu, MSR_NON_EXISTENT);
 
 	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
-	run_guest(vm);
+	vcpu_run(vm, vcpu->id);
 	vm_install_exception_handler(vm, UD_VECTOR, NULL);
 
-	if (process_ucall(vm) != UCALL_DONE) {
+	if (process_ucall(vcpu) != UCALL_DONE) {
 		vm_install_exception_handler(vm, GP_VECTOR, guest_fep_gp_handler);
 
 		/* Process emulated rdmsr and wrmsr instructions. */
-		run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
-		run_guest_then_process_wrmsr(vm, MSR_IA32_XSS);
-		run_guest_then_process_wrmsr(vm, MSR_IA32_XSS);
+		run_guest_then_process_rdmsr(vcpu, MSR_IA32_XSS);
+		run_guest_then_process_wrmsr(vcpu, MSR_IA32_XSS);
+		run_guest_then_process_wrmsr(vcpu, MSR_IA32_XSS);
 
-		run_guest_then_process_rdmsr(vm, MSR_IA32_FLUSH_CMD);
-		run_guest_then_process_wrmsr(vm, MSR_IA32_FLUSH_CMD);
-		run_guest_then_process_wrmsr(vm, MSR_IA32_FLUSH_CMD);
+		run_guest_then_process_rdmsr(vcpu, MSR_IA32_FLUSH_CMD);
+		run_guest_then_process_wrmsr(vcpu, MSR_IA32_FLUSH_CMD);
+		run_guest_then_process_wrmsr(vcpu, MSR_IA32_FLUSH_CMD);
 
-		run_guest_then_process_wrmsr(vm, MSR_NON_EXISTENT);
-		run_guest_then_process_rdmsr(vm, MSR_NON_EXISTENT);
+		run_guest_then_process_wrmsr(vcpu, MSR_NON_EXISTENT);
+		run_guest_then_process_rdmsr(vcpu, MSR_NON_EXISTENT);
 
 		/* Confirm the guest completed without issues. */
-		run_guest_then_process_ucall_done(vm);
+		run_guest_then_process_ucall_done(vcpu);
 	} else {
 		printf("To run the instruction emulated tests set the module parameter 'kvm.force_emulation_prefix=1'\n");
 	}
@@ -616,16 +608,16 @@ static void test_msr_filter_allow(void) {
 	kvm_vm_free(vm);
 }
 
-static int handle_ucall(struct kvm_vm *vm)
+static int handle_ucall(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc;
 
-	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	switch (get_ucall(vcpu->vm, vcpu->id, &uc)) {
 	case UCALL_ABORT:
 		TEST_FAIL("Guest assertion not met");
 		break;
 	case UCALL_SYNC:
-		vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &no_filter_deny);
+		vm_ioctl(vcpu->vm, KVM_X86_SET_MSR_FILTER, &no_filter_deny);
 		break;
 	case UCALL_DONE:
 		return 1;
@@ -673,21 +665,21 @@ static void handle_wrmsr(struct kvm_run *run)
 	}
 }
 
-static void test_msr_filter_deny(void) {
+static void test_msr_filter_deny(void)
+{
 	struct kvm_enable_cap cap = {
 		.cap = KVM_CAP_X86_USER_SPACE_MSR,
 		.args[0] = KVM_MSR_EXIT_REASON_INVAL |
 			   KVM_MSR_EXIT_REASON_UNKNOWN |
 			   KVM_MSR_EXIT_REASON_FILTER,
 	};
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	int rc;
 
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code_filter_deny);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
-	run = vcpu_state(vm, VCPU_ID);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_filter_deny);
+	run = vcpu->run;
 
 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
 	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
@@ -700,9 +692,7 @@ static void test_msr_filter_deny(void) {
 	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_deny);
 
 	while (1) {
-		rc = _vcpu_run(vm, VCPU_ID);
-
-		TEST_ASSERT(rc == 0, "vcpu_run failed: %d\n", rc);
+		vcpu_run(vm, vcpu->id);
 
 		switch (run->exit_reason) {
 		case KVM_EXIT_X86_RDMSR:
@@ -712,7 +702,7 @@ static void test_msr_filter_deny(void) {
 			handle_wrmsr(run);
 			break;
 		case KVM_EXIT_IO:
-			if (handle_ucall(vm))
+			if (handle_ucall(vcpu))
 				goto done;
 			break;
 		}
@@ -726,17 +716,17 @@ static void test_msr_filter_deny(void) {
 	kvm_vm_free(vm);
 }
 
-static void test_msr_permission_bitmap(void) {
+static void test_msr_permission_bitmap(void)
+{
 	struct kvm_enable_cap cap = {
 		.cap = KVM_CAP_X86_USER_SPACE_MSR,
 		.args[0] = KVM_MSR_EXIT_REASON_FILTER,
 	};
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int rc;
 
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code_permission_bitmap);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_permission_bitmap);
 
 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
 	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
@@ -746,11 +736,12 @@ static void test_msr_permission_bitmap(void) {
 	TEST_ASSERT(rc, "KVM_CAP_X86_MSR_FILTER is available");
 
 	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_fs);
-	run_guest_then_process_rdmsr(vm, MSR_FS_BASE);
-	TEST_ASSERT(run_guest_then_process_ucall(vm) == UCALL_SYNC, "Expected ucall state to be UCALL_SYNC.");
+	run_guest_then_process_rdmsr(vcpu, MSR_FS_BASE);
+	TEST_ASSERT(run_guest_then_process_ucall(vcpu) == UCALL_SYNC,
+		    "Expected ucall state to be UCALL_SYNC.");
 	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_gs);
-	run_guest_then_process_rdmsr(vm, MSR_GS_BASE);
-	run_guest_then_process_ucall_done(vm);
+	run_guest_then_process_rdmsr(vcpu, MSR_GS_BASE);
+	run_guest_then_process_ucall_done(vcpu);
 
 	kvm_vm_free(vm);
 }
-- 
2.36.0.464.gb9c8b46e94-goog

