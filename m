Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE87951B312
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351347AbiEDW4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379298AbiEDWyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:35 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4588153726
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:58 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 16-20020a17090a0a9000b001d48f5547fbso1074257pjw.9
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=mMUKfkcQC6L2kdy7xknNE50/OMw8bniryDEa4z4qs9I=;
        b=fdx3M/7h7rkKdXdafQub7PqbXrtTqfTizk3A2viNauhZy47P+qkfQ8R2DMgP9BcCSO
         ayKId/0ecnEfanpZXRo73yGeoyYJOa8n98JXTjiLspPc0bHLCu5owMfIlEBKfaESxvxV
         VgjmIRK2T9wqT4Cy+pnsos1VW3F+vQWrOpA5604jKuikkkCP7GwhN47gQJv+AjdANhBI
         bvEpVf8L8EcRK34TdKBhzjZk/gqpqpDf6KjcUbFLAhXsROeWapc6yc8VDL7VZHsv6vx1
         NHtv0+PaCIV+qRnKjwPOv14GRNAZpCpXdtopryDdX9GSMn9zlBsFTk8EyrpmzutnkcPv
         Rujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=mMUKfkcQC6L2kdy7xknNE50/OMw8bniryDEa4z4qs9I=;
        b=BHC19rGc3mCazWajHAX1C8EvVF3bZHEVO4WxLI0veo9vTK2Tyn/0EHq3tW5m4MHD9s
         DHJUoS0vdeBwSxQRF8EP+Z17J5HOnB5WswroyKYmi5Hc0BcuuoR+Q7tdB9ICLY/v27o3
         41A1yXujK3Q4dR5X5MleVsEiTsQQ0YNK7MCbw0xb0bLVwAvA3c63IJHqnRblXyXLk/BN
         HVaykiR0eo4mngnog25HxUjA6/JwRdiSvyMTHcYwH1PfyiO0F1LRolHmHtv7KJLERNhB
         ayu9sdKAO4KuA7Nyhtb9B53l1Bupd/EVNSNv7DfaWvTZuB1rsbRjCRQd5d8odg44Wqha
         irHQ==
X-Gm-Message-State: AOAM531IEQ9YADJCPIdV25+AouIyJC3/OudAbVdd4zyVDLSuBn8TOwml
        mqevA5RLCNCuoWY/WW9zWfyHbi4Zk5U=
X-Google-Smtp-Source: ABdhPJyFxNz4GZ9ZUvS+BVWwN7Twas5+Rzy0ZUqZiCQgzx8MTRo31AnX4dAZ616o1972u9HeX7D0wTFNVCo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:1105:b0:154:c850:860b with SMTP id
 n5-20020a170903110500b00154c850860bmr24320747plh.12.1651704657767; Wed, 04
 May 2022 15:50:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:56 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-51-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 050/128] KVM: selftests: Convert pmu_event_filter_test away
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

Convert pmu_event_filter_test to use vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.
Rename run_vm_to_sync() to run_vcpu_to_sync() accordingly.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 69 ++++++++++---------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 93af4ad728d8..535af2d2ad59 100644
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
 	struct kvm_enable_cap cap = { 0 };
@@ -346,11 +346,13 @@ static void test_pmu_config_disable(void (*guest_code)(void))
 	cap.args[0] = KVM_PMU_CAP_DISABLE;
 	vm_enable_cap(vm, &cap);
 
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
@@ -421,6 +423,7 @@ static bool use_amd_pmu(void)
 int main(int argc, char *argv[])
 {
 	void (*guest_code)(void) = NULL;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int r;
 
@@ -443,21 +446,21 @@ int main(int argc, char *argv[])
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
2.36.0.464.gb9c8b46e94-goog

