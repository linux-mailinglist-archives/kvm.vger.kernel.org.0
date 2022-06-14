Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A1B54BB34
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356528AbiFNUHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351417AbiFNUHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:34 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843C22DE8
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:24 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id h10-20020a170902f54a00b00166449db7f8so5344770plf.9
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=0JTtDUieBFaLFlQRtGbTAPlsLVfcOSXXVCv+GbCgdXE=;
        b=OU1Xu45m/J7KzT3I6oZZ3vKZFB0Myqk8L6vWUifD7R+bsK00aEjbusuJL+5ljPiAfY
         MybIX04aRAFIvpJ3eR7nV4f79Q0SfCVkk/RoBRN+YlXaDhndvq2NZMpbH+zHy5vVZuIf
         4TszjqROx+6uJqDFoiRF2J6DuO7t1b2T5uW0B2uKdnjzejP/uRmHKe03lqMmuzgAkZ3H
         xsdss/OPifd+KojsEwGJkyuzvS2uwvEVF87t9UH0C5fRcA/PYh+H/5dNddmK/aGeapEZ
         fPlFST6FLkfXXjS5owU436vELiOB5/IsAGPHeqjD+CCtvij8N+OUTNxiRUvac9usj9FP
         uNLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=0JTtDUieBFaLFlQRtGbTAPlsLVfcOSXXVCv+GbCgdXE=;
        b=ALZlpy1llj420ctmas+TjplIb5Qxo5UKliHO4AvreDBsiHM0mJJOJyyGzCxfehFc6Q
         MtxB3GIgfAnu3zM7dcfe4X7YyGd2GFp9I+E+wzGDGuF0v76ZgI0YQi27h0PjFRLtOuCE
         yBae+zmItgJfP3BtFdFxAb59OqUg1TmBnvsCapT2ceEP2g87GbtGe8leM1iHUQseJB0f
         WjxbJZXcdpSDCwNROPLiziZwD9gC8MhiyloyAszuH0y2+9AgclkYrbzwzrLwXcspKAtf
         HGI2b4EmlDemho7bn4wixMnLD/HJcwnD+lLC1TWpI7erraaP3z0JxPOntn0om/19lOQd
         O/Ng==
X-Gm-Message-State: AJIora8q2xggX2bH6KrT92elZQ5tDx2AkckByw/5dUevX44y6mcwlupU
        jjltSFMnT1+2PLd68jnBNa7Ht0la85o=
X-Google-Smtp-Source: AGRyM1sUELAlikNyS+EdWM9NJWDffUhBbDLd0ybpx8b7KtWK1+SqD/n8ej07TLnIbAhCQVdvHyFIXPyd+FY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr192524pje.0.1655237243754; Tue, 14 Jun
 2022 13:07:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:31 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 06/42] KVM: selftests: Use kvm_cpu_has() for nested VMX checks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Use kvm_cpu_has() to check for nested VMX support, and drop the helpers
now that their functionality is trivial to implement.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/vmx.h     |  2 --
 .../selftests/kvm/lib/x86_64/perf_test_util.c        |  2 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c         | 12 ------------
 tools/testing/selftests/kvm/x86_64/evmcs_test.c      |  2 +-
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c    |  4 ++--
 tools/testing/selftests/kvm/x86_64/smm_test.c        |  2 +-
 tools/testing/selftests/kvm/x86_64/state_test.c      |  2 +-
 .../selftests/kvm/x86_64/triple_fault_event_test.c   |  2 +-
 .../selftests/kvm/x86_64/vmx_apic_access_test.c      |  2 +-
 .../kvm/x86_64/vmx_close_while_nested_test.c         |  2 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c        |  2 +-
 .../kvm/x86_64/vmx_invalid_nested_guest_state.c      |  2 +-
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c         |  2 +-
 .../selftests/kvm/x86_64/vmx_preemption_timer_test.c |  2 +-
 .../selftests/kvm/x86_64/vmx_set_nested_state_test.c |  2 +-
 .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c       |  2 +-
 16 files changed, 15 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index cc3604f8f1d3..99fa1410964c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -607,8 +607,6 @@ bool prepare_for_vmx_operation(struct vmx_pages *vmx);
 void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp);
 bool load_vmcs(struct vmx_pages *vmx);
 
-bool nested_vmx_supported(void);
-void nested_vmx_check_supported(void);
 bool ept_1g_pages_supported(void);
 
 void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c b/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
index bfe85c8c2f6e..0f344a7c89c4 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
@@ -84,7 +84,7 @@ void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
 	vm_vaddr_t vmx_gva;
 	int vcpu_id;
 
-	nested_vmx_check_supported();
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 
 	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
 		vmx = vcpu_alloc_vmx(vm, &vmx_gva);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 381432741df4..80a568c439b8 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -382,18 +382,6 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 	init_vmcs_guest_state(guest_rip, guest_rsp);
 }
 
-bool nested_vmx_supported(void)
-{
-	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(1);
-
-	return entry->ecx & CPUID_VMX;
-}
-
-void nested_vmx_check_supported(void)
-{
-	TEST_REQUIRE(nested_vmx_supported());
-}
-
 static void nested_create_pte(struct kvm_vm *vm,
 			      struct eptPageTableEntry *pte,
 			      uint64_t nested_paddr,
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 8dda527cc080..d762cadb0ee9 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -208,7 +208,7 @@ int main(int argc, char *argv[])
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	TEST_REQUIRE(nested_vmx_supported());
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS));
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index cbd4a7d36189..c406b95cba9b 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -148,7 +148,7 @@ int main(int argc, char *argv[])
 	test_hv_cpuid(hv_cpuid_entries, false);
 	free(hv_cpuid_entries);
 
-	if (!nested_vmx_supported() ||
+	if (!kvm_cpu_has(X86_FEATURE_VMX) ||
 	    !kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
 		print_skip("Enlightened VMCS is unsupported");
 		goto do_sys;
@@ -168,7 +168,7 @@ int main(int argc, char *argv[])
 	test_hv_cpuid_e2big(vm, NULL);
 
 	hv_cpuid_entries = kvm_get_supported_hv_cpuid();
-	test_hv_cpuid(hv_cpuid_entries, nested_vmx_supported());
+	test_hv_cpuid(hv_cpuid_entries, kvm_cpu_has(X86_FEATURE_VMX));
 
 out:
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index 6b8108bdcead..40581704f129 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -156,7 +156,7 @@ int main(int argc, char *argv[])
 	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
 		if (kvm_cpu_has(X86_FEATURE_SVM))
 			vcpu_alloc_svm(vm, &nested_gva);
-		else if (nested_vmx_supported())
+		else if (kvm_cpu_has(X86_FEATURE_VMX))
 			vcpu_alloc_vmx(vm, &nested_gva);
 	}
 
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index fe110ce31106..35e96d7a6ba1 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -172,7 +172,7 @@ int main(int argc, char *argv[])
 	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
 		if (kvm_cpu_has(X86_FEATURE_SVM))
 			vcpu_alloc_svm(vm, &nested_gva);
-		else if (nested_vmx_supported())
+		else if (kvm_cpu_has(X86_FEATURE_VMX))
 			vcpu_alloc_vmx(vm, &nested_gva);
 	}
 
diff --git a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
index 5a202ecb8ea0..af68f60a51e8 100644
--- a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
+++ b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
@@ -46,7 +46,7 @@ int main(void)
 	vm_vaddr_t vmx_pages_gva;
 	struct ucall uc;
 
-	nested_vmx_check_supported();
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_TRIPLE_FAULT_EVENT));
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
index ccb05ef7234e..59e8e8c8a8f5 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
@@ -80,7 +80,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	nested_vmx_check_supported();
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
index 40c77bb706a1..92760eeeee97 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
@@ -51,7 +51,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	nested_vmx_check_supported();
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
index 215ffa0589d4..a81964c85747 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -77,7 +77,7 @@ int main(int argc, char *argv[])
 	struct ucall uc;
 	bool done = false;
 
-	nested_vmx_check_supported();
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c b/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
index 683f4f0a1616..a714c260481f 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
@@ -58,7 +58,7 @@ int main(int argc, char *argv[])
 	struct kvm_run *run;
 	struct ucall uc;
 
-	nested_vmx_check_supported();
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
index ff4644038c55..8edba1eee889 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
@@ -150,7 +150,7 @@ int main(int argc, char *argv[])
 	uint64_t l1_tsc_freq = 0;
 	uint64_t l2_tsc_freq = 0;
 
-	nested_vmx_check_supported();
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_TSC_CONTROL));
 	stable_tsc_check_supported();
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
index 771b54b227d5..afae65249bc5 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
@@ -167,7 +167,7 @@ int main(int argc, char *argv[])
 	 * AMD currently does not implement any VMX features, so for now we
 	 * just early out.
 	 */
-	nested_vmx_check_supported();
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index b564b86dfc1d..66cb2d0054e6 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -273,7 +273,7 @@ int main(int argc, char *argv[])
 	 * AMD currently does not implement set_nested_state, so for now we
 	 * just early out.
 	 */
-	nested_vmx_check_supported();
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 
 	vm = vm_create_with_one_vcpu(&vcpu, NULL);
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
index e32bfb102699..2aecb21d4bda 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
@@ -127,7 +127,7 @@ int main(int argc, char *argv[])
 	vm_vaddr_t vmx_pages_gva;
 	struct kvm_vcpu *vcpu;
 
-	nested_vmx_check_supported();
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 
 	vm = vm_create_with_one_vcpu(&vcpu, (void *) l1_guest_code);
 
-- 
2.36.1.476.g0c4daa206d-goog

