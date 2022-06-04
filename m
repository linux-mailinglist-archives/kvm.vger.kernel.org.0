Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A7153D447
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350007AbiFDBVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349958AbiFDBVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:21:13 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C9B56767
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:11 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x11-20020aa79acb000000b0051b9d3136fdso4726973pfp.1
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+jT04UMM2+8DeMl3bML3CIzXE/iqEmlJ78JJb5NF3co=;
        b=DX/Xg+K+dHp3epVqcNgGy8QkmMVAfJyZFm7N0b/6xAdj/8rZWJt2OXkMVasGJpyvSa
         9Y7tCxPr3dlpflxsiMKK+il1oTr0b9smUFE7sEn2U3tDDslrXoQKEng0dnIEeFdDd7wq
         HqpH2BDWmBESLicd8x8WwIELbicOavyg89c0+CJl9RqDxhpVkjlIyAPOwL574k5fNcs8
         1SDqlo0l49EpFo4ei4h3dYgq8MWkHxCmoENhgBJtl2xR3N8gLY+jz9UuA1qttRW732hl
         kRZJg/Vvxan1oTIaUbT2IIDpKsco5CsTni6iPbjADpkp+vLX0vnYgXy8xpX88dulo+z9
         7WSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+jT04UMM2+8DeMl3bML3CIzXE/iqEmlJ78JJb5NF3co=;
        b=ayguRf+lKf0G5/nCHHj9qEXoAxHbqmrLE7T4GHaTCXW7cixi5OkaDbl49UP9dueLuY
         OPcB5LtHEtvffIB/LbyP80qMe4F1URyry78iNKTQ7XJG0jyvfCG4r5rQchmTxJ9qxKyn
         OyGn9t9i7SSuxS/zwPd/YYDuD3b3F7k3+aK9JZK9OcKX+xLyxERBxCLKRt6AbFF0VEy6
         f4lm8gYt9Vhye4Dt1wUzSdQUYh+jpnPu3Gp0SiFBwoC2t8oAkyGT3uFI6r2gjvhxNbv4
         3eDbOzpcrGB7xif1088wREv5fxNUN6s7EfAvvA3ch5rq+kj2JlK5w22iolkn17TJDWkf
         UZdg==
X-Gm-Message-State: AOAM531NL7H4JSGWAyOYXvN8A26+7iPCiBJg6qjtM01O3TviAtR3Vomn
        NYzbmec8b9fWbyPOsIcqTHypfgOzC+4=
X-Google-Smtp-Source: ABdhPJx3we3tRlTMsPFNwBMofFlvHEJoG6Kntis8HGldiQSu2dqM/ztME4yqJyr+iMsRTTgkr7hJxt8bSpk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:f54c:b0:163:f64a:612c with SMTP id
 h12-20020a170902f54c00b00163f64a612cmr12828546plf.22.1654305670879; Fri, 03
 Jun 2022 18:21:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:22 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 06/42] KVM: selftests: Use kvm_cpu_has() for nested VMX checks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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

Use kvm_cpu_has() to check for nested VMX support, and drop the helpers
now that their functionality is trivial to implement.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/vmx.h     |  3 ---
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
 15 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 583ceb0d1457..fe0ebb790b49 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -604,9 +604,6 @@ bool prepare_for_vmx_operation(struct vmx_pages *vmx);
 void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp);
 bool load_vmcs(struct vmx_pages *vmx);
 
-bool nested_vmx_supported(void);
-void nested_vmx_check_supported(void);
-
 void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		   uint64_t nested_paddr, uint64_t paddr);
 void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 3ba8278c5086..6d4dee220fbf 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -372,18 +372,6 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
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
 void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		   uint64_t nested_paddr, uint64_t paddr)
 {
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
2.36.1.255.ge46751e96f-goog

