Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5EF53C292
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240412AbiFCArD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240120AbiFCApZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:25 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29AC344C4
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:23 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h11-20020a65638b000000b003fad8e1cc9bso3057683pgv.2
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=O7b+a25lx0Dbw99w/vnZbZi9/Zb3kUTB3wWOPwdGJDs=;
        b=NHOEiCUsn4p0ioi9Q7YZkrH/GQwQ8jBWkp136Qdw1qi18fUHfVBKdgc4asAKll1ioW
         ytmoZEXEmBGv+GLyGl9wMKeokb30OnU3WOEaLwQyYdLE/yT3pi83d60NeR/MtQKK26qW
         hXVMysMXqjKMGqScEeaY1R4vXeQKngHDcbUuhF/2fy5Aeu1ulSzDeEL6QAoRBtwq6QER
         8E/lOtEFVnkLFviVwnWg0ecbG9OPmzmNk9Kzyq4bHKNZlWzBQic+zrC8UAYadBTXzK6+
         YAdwA6J0w4GMH3rdHgNaoCyTIXa2N5JLw4fg6q6SnGN8mlAZ4m2HHdkBwSQRZpe3pMlF
         ZKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=O7b+a25lx0Dbw99w/vnZbZi9/Zb3kUTB3wWOPwdGJDs=;
        b=JP7ixmBX2br06VfUDNlVYuKAfw10PU0Dbe+ySA/M0zSSarRJ/ziUFmcriLHy+lyYLf
         4WmQVS5zZpvy30KPaJne0z3dPqCkkzUXHsP/w+95AeooC8jaQTJ8nR7UDTv+SxBTC5Pp
         4uu9wEdwPj7v1YpWDKyrn+r1NKjIssiUibeFuCNLyPahchrqkwo4YY9JSYzIq/8nD9dy
         YbgAbjXYO4tcVIecWAalMIzLhfE6ObodxSEmzDYQoB+F+t5Wh4JGqTMPBv5ySeon+pmD
         pp/JHeZa7jYGbk/T4lyYcEf5u5oI0uhPDq/nVSqTe1xRHO4wYDBiSd9rdORD1rHsHjlR
         K2WQ==
X-Gm-Message-State: AOAM532U/s7QzgDr7uiQ/1LmqjGVU8sRSv7CLe4sK8OCUil9a9SBIy6M
        XVRGEBL5xOAAOti5kCGGWlVeUTNR9bg=
X-Google-Smtp-Source: ABdhPJx/UdgkafMBhagNizkk91xi3dNlem8ME6TVAJYYFreebQzjj74/4KkoADX+c8XPRbHLjs3dwGXM4b8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:10cc:b0:506:e0:d6c3 with SMTP id
 d12-20020a056a0010cc00b0050600e0d6c3mr7810323pfu.33.1654217123385; Thu, 02
 Jun 2022 17:45:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:05 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-59-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 058/144] KVM: selftests: Convert pmu_event_filter_test away
 from VCPU_ID
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

Convert pmu_event_filter_test to use vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.
Rename run_vm_to_sync() to run_vcpu_to_sync() accordingly.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 69 ++++++++++---------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 640b1a1ab3df..96455ec6ea48 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -49,7 +49,6 @@ union cpuid10_ebx {
 /* Oddly, this isn't in perf_event.h. */
 #define ARCH_PERFMON_BRANCHES_RETIRED		5
 
-#define VCPU_ID 0
 #define NUM_BRANCHES 42
 
 /*
@@ -173,17 +172,17 @@ static void amd_guest_code(void)
  * Run the VM to the next GUEST_SYNC(value), and return the value passed
  * to the sync. Any other exit from the guest is fatal.
  */
-static uint64_t run_vm_to_sync(struct kvm_vm *vm)
+static uint64_t run_vcpu_to_sync(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
-	vcpu_run(vm, VCPU_ID);
+	vcpu_run(vcpu->vm, vcpu->id);
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 		    "Exit_reason other than KVM_EXIT_IO: %u (%s)\n",
 		    run->exit_reason,
 		    exit_reason_str(run->exit_reason));
-	get_ucall(vm, VCPU_ID, &uc);
+	get_ucall(vcpu->vm, vcpu->id, &uc);
 	TEST_ASSERT(uc.cmd == UCALL_SYNC,
 		    "Received ucall other than UCALL_SYNC: %lu", uc.cmd);
 	return uc.args[1];
@@ -197,13 +196,13 @@ static uint64_t run_vm_to_sync(struct kvm_vm *vm)
  * a sanity check and then GUEST_SYNC(success). In the case of failure,
  * the behavior of the guest on resumption is undefined.
  */
-static bool sanity_check_pmu(struct kvm_vm *vm)
+static bool sanity_check_pmu(struct kvm_vcpu *vcpu)
 {
 	bool success;
 
-	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
-	success = run_vm_to_sync(vm);
-	vm_install_exception_handler(vm, GP_VECTOR, NULL);
+	vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handler);
+	success = run_vcpu_to_sync(vcpu);
+	vm_install_exception_handler(vcpu->vm, GP_VECTOR, NULL);
 
 	return success;
 }
@@ -254,9 +253,9 @@ static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
 	return f;
 }
 
-static void test_without_filter(struct kvm_vm *vm)
+static void test_without_filter(struct kvm_vcpu *vcpu)
 {
-	uint64_t count = run_vm_to_sync(vm);
+	uint64_t count = run_vcpu_to_sync(vcpu);
 
 	if (count != NUM_BRANCHES)
 		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
@@ -264,17 +263,17 @@ static void test_without_filter(struct kvm_vm *vm)
 	TEST_ASSERT(count, "Allowed PMU event is not counting");
 }
 
-static uint64_t test_with_filter(struct kvm_vm *vm,
+static uint64_t test_with_filter(struct kvm_vcpu *vcpu,
 				 struct kvm_pmu_event_filter *f)
 {
-	vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
-	return run_vm_to_sync(vm);
+	vm_ioctl(vcpu->vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
+	return run_vcpu_to_sync(vcpu);
 }
 
-static void test_member_deny_list(struct kvm_vm *vm)
+static void test_member_deny_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
-	uint64_t count = test_with_filter(vm, f);
+	uint64_t count = test_with_filter(vcpu, f);
 
 	free(f);
 	if (count)
@@ -283,10 +282,10 @@ static void test_member_deny_list(struct kvm_vm *vm)
 	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
 }
 
-static void test_member_allow_list(struct kvm_vm *vm)
+static void test_member_allow_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_ALLOW);
-	uint64_t count = test_with_filter(vm, f);
+	uint64_t count = test_with_filter(vcpu, f);
 
 	free(f);
 	if (count != NUM_BRANCHES)
@@ -295,14 +294,14 @@ static void test_member_allow_list(struct kvm_vm *vm)
 	TEST_ASSERT(count, "Allowed PMU event is not counting");
 }
 
-static void test_not_member_deny_list(struct kvm_vm *vm)
+static void test_not_member_deny_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
 	uint64_t count;
 
 	remove_event(f, INTEL_BR_RETIRED);
 	remove_event(f, AMD_ZEN_BR_RETIRED);
-	count = test_with_filter(vm, f);
+	count = test_with_filter(vcpu, f);
 	free(f);
 	if (count != NUM_BRANCHES)
 		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
@@ -310,14 +309,14 @@ static void test_not_member_deny_list(struct kvm_vm *vm)
 	TEST_ASSERT(count, "Allowed PMU event is not counting");
 }
 
-static void test_not_member_allow_list(struct kvm_vm *vm)
+static void test_not_member_allow_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_ALLOW);
 	uint64_t count;
 
 	remove_event(f, INTEL_BR_RETIRED);
 	remove_event(f, AMD_ZEN_BR_RETIRED);
-	count = test_with_filter(vm, f);
+	count = test_with_filter(vcpu, f);
 	free(f);
 	if (count)
 		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",
@@ -332,6 +331,7 @@ static void test_not_member_allow_list(struct kvm_vm *vm)
  */
 static void test_pmu_config_disable(void (*guest_code)(void))
 {
+	struct kvm_vcpu *vcpu;
 	int r;
 	struct kvm_vm *vm;
 
@@ -343,11 +343,13 @@ static void test_pmu_config_disable(void (*guest_code)(void))
 
 	vm_enable_cap(vm, KVM_CAP_PMU_CAPABILITY, KVM_PMU_CAP_DISABLE);
 
-	vm_vcpu_add_default(vm, VCPU_ID, guest_code);
+	vm_vcpu_add_default(vm, 0, guest_code);
 	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
 
-	TEST_ASSERT(!sanity_check_pmu(vm),
+	vcpu = vcpu_get(vm, 0);
+	vcpu_init_descriptor_tables(vm, vcpu->id);
+
+	TEST_ASSERT(!sanity_check_pmu(vcpu),
 		    "Guest should not be able to use disabled PMU.");
 
 	kvm_vm_free(vm);
@@ -418,6 +420,7 @@ static bool use_amd_pmu(void)
 int main(int argc, char *argv[])
 {
 	void (*guest_code)(void) = NULL;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int r;
 
@@ -440,21 +443,21 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vcpu_init_descriptor_tables(vm, vcpu->id);
 
-	if (!sanity_check_pmu(vm)) {
+	if (!sanity_check_pmu(vcpu)) {
 		print_skip("Guest PMU is not functional");
 		exit(KSFT_SKIP);
 	}
 
-	test_without_filter(vm);
-	test_member_deny_list(vm);
-	test_member_allow_list(vm);
-	test_not_member_deny_list(vm);
-	test_not_member_allow_list(vm);
+	test_without_filter(vcpu);
+	test_member_deny_list(vcpu);
+	test_member_allow_list(vcpu);
+	test_not_member_deny_list(vcpu);
+	test_not_member_allow_list(vcpu);
 
 	kvm_vm_free(vm);
 
-- 
2.36.1.255.ge46751e96f-goog

