Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BCF53C1E4
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbiFCAyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240289AbiFCApu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:50 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD66344E6
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:48 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-30026cf9af8so56554097b3.3
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=fOaDAx5wEYsGYxLsjok3SDFHhvLRfvCG3DXiFSvtghw=;
        b=ruaydMSVsUj/WLNhc4x7cSlIvqea/vc0r1rU7dEjcV0gabHzDzsisnl1HILhxY0Cst
         a4NOeY+hr2ClDpahLVopNz5sFvnum5c19KqRLEjSfEmAxp4F21GttBv9U/ww2bwiOxYw
         KHy+b0lGEYJUjSQ9WSHw9NVFJjVg7jYcrAi9yMLObivjnjQp8xQVV5QC0mvBiJJ+xl/V
         26peBvx7Dwafg53bC5xVXIOZD0wtwbwSzsIpcxuEH+7ACqKQvwaE9fRFosHPjDTxnK3M
         mnJoDqFn0F8yGJoEYL559v0USRpUh/KTvdPusxNGrehfLPaXVuYalT7sWYnY6IlLrhpP
         SzcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=fOaDAx5wEYsGYxLsjok3SDFHhvLRfvCG3DXiFSvtghw=;
        b=lz5nH2An16c+oH2yd62oo1fdeaXI1zc/HLgmK0j4ULmA5uYfK0z7rOgm3TS7WHWZr2
         nlmc3l7TnlQX1sTt1xOQIMbW7h9efKV7HXYksbLvPoPZ0Zi0tR1u1WfKph9BGcHeHAkV
         eEjUTbdMG3O54pos3LwU5K/nbon7yclN91rHwIBgXHCx0G7AikUeCOxrbWIRtpFeeXln
         HSGQxLkWSx35i5zSbMDBTog/cHfupFad/yp+CgR1m5Z48O4dsyZldIKKkW4lK2oHYl6o
         i3/Rl6+ZB1qRiwc3CyT2s+XY6XT6/8j4O1aIrXxs/nh+gl3/JxdBrsCVZG4RkWK4K0jX
         2Apw==
X-Gm-Message-State: AOAM5326mcPZZKU5BLs7JWBpNWrale3Jw7AtNX+Ba+zGDMn0HrTfI0p1
        Ln6lYq5kTviPJ2kmQKLv+YNQkRXY0W8=
X-Google-Smtp-Source: ABdhPJzQBP7i0UejbUDOEJ/PIUIna2iliySKvnSejjQJynq46nXDzpSmSDHkFEnoUjHwe36cqbrwarHmUHE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a81:5212:0:b0:30c:1a1e:45ac with SMTP id
 g18-20020a815212000000b0030c1a1e45acmr8889806ywb.93.1654217147796; Thu, 02
 Jun 2022 17:45:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:19 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-73-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 072/144] KVM: selftests: Convert userspace_msr_exit_test
 away from VCPU_ID
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
 .../kvm/x86_64/userspace_msr_exit_test.c      | 156 ++++++++----------
 1 file changed, 72 insertions(+), 84 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index 23e9292580c9..a0d35e578b25 100644
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
@@ -526,38 +516,39 @@ static uint64_t process_ucall(struct kvm_vm *vm)
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
 
 static void test_msr_filter_allow(void)
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int rc;
 
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code_filter_allow);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_filter_allow);
 
 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
 	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
@@ -569,43 +560,43 @@ static void test_msr_filter_allow(void)
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
@@ -613,16 +604,16 @@ static void test_msr_filter_allow(void)
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
@@ -672,14 +663,13 @@ static void handle_wrmsr(struct kvm_run *run)
 
 static void test_msr_filter_deny(void)
 {
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
@@ -694,9 +684,7 @@ static void test_msr_filter_deny(void)
 	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_deny);
 
 	while (1) {
-		rc = _vcpu_run(vm, VCPU_ID);
-
-		TEST_ASSERT(rc == 0, "vcpu_run failed: %d\n", rc);
+		vcpu_run(vm, vcpu->id);
 
 		switch (run->exit_reason) {
 		case KVM_EXIT_X86_RDMSR:
@@ -706,7 +694,7 @@ static void test_msr_filter_deny(void)
 			handle_wrmsr(run);
 			break;
 		case KVM_EXIT_IO:
-			if (handle_ucall(vm))
+			if (handle_ucall(vcpu))
 				goto done;
 			break;
 		}
@@ -722,12 +710,11 @@ static void test_msr_filter_deny(void)
 
 static void test_msr_permission_bitmap(void)
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int rc;
 
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code_permission_bitmap);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_permission_bitmap);
 
 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
 	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
@@ -737,11 +724,12 @@ static void test_msr_permission_bitmap(void)
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
2.36.1.255.ge46751e96f-goog

