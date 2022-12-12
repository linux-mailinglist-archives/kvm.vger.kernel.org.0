Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A878564A74E
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbiLLSio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbiLLSiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:38:13 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6246313D55
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:44 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v195-20020a252fcc000000b007125383fe0dso13733990ybv.23
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bjFV3CxThb1rgCl7W+AuaEgzSVgbJZGP2K7DQG2Zpoo=;
        b=VPcBTMhlgaljzsyXQGdizaIJ66i3k0o+mp5X7Bvh1WIhQfeSU/TNdL+GdMHBZrkBqt
         rrXYtE49j21tklfeJb5A+rha5wrzeeF+gzlIbLXL5raAfxT4cf9lT0Ku4ZJg31ODVU9E
         9ixRc1UufwgvDq1IyTxn6embSkwV4fev2xDf24Qhr2DjoNf46VlIJTLJE4sXfYOZJ/KB
         d6KaCnitfMVdeCJPw3Z2R69vFi5a4WSAT2fwx6mjFIKW1a/UB0r9y5rC9mmQvS91x1pi
         F37Xv+M6eUAqCjJidjGLdeMDRKvjrmYnvoHfL7kpv4hWxkl2s/DmeV5ol6fJQ6gtVXyB
         hAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bjFV3CxThb1rgCl7W+AuaEgzSVgbJZGP2K7DQG2Zpoo=;
        b=711q0ZtafhS4Q7tFIxBZnYUqgzAnAS5DBJLBs8UlsAXixxFX7Tr3I4+V1jFetsPeH0
         yt38oQMuIs4jOkrPJzsEon6Zi/38Y6YfZs634kXC85BNPeHQkyI/B1pszbBoXm8m265J
         zaua7xcBOyAYgLa+llJrTLcVGl/TCnPqdjGa+75UKxM2pS5Hr5gq+EzqJoYfmkulfog8
         Avp8nv5DaVpJL8F6oDovF+tWAIYydZ35zFiav93Luquvfx9hw4sBpFbZk5qSuQcKNwr7
         ERK24tMsex7y/7tTcDQ6sVasuncc2rdBR2nWpd6g3XUg6a+ct6tr3/W7N+Y2qOxIGg8m
         Y6Qw==
X-Gm-Message-State: ANoB5pn2urXNcNKPRWMIqGGA8RP/jZmkjwRJst1pOP/iWt+Lw9dlk7Yu
        FY5O77L7yfvmRk4MbOzL2jzowNISHVIW
X-Google-Smtp-Source: AA0mqf6uffNc0gtc/KZm6G8pNmy06XvSCX6G2BJEsxnmJ4Sug+NqXZ2eHqD0xpV5eqtWdcY4VFnCjFl7+gQb
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a25:cdc3:0:b0:6fc:26a5:ebd9 with SMTP id
 d186-20020a25cdc3000000b006fc26a5ebd9mr30203909ybf.69.1670870263644; Mon, 12
 Dec 2022 10:37:43 -0800 (PST)
Date:   Mon, 12 Dec 2022 10:37:19 -0800
In-Reply-To: <20221212183720.4062037-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221212183720.4062037-13-vipinsh@google.com>
Subject: [Patch v4 12/13] KVM: selftests: Make vCPU exit reason test assertion common.
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make TEST_ASSERT_KVM_EXIT_REASON() macro and replace all exit reason
test assert statements with it.

No functional changes intended.

Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/kvm/aarch64/psci_test.c |  4 +--
 .../testing/selftests/kvm/include/test_util.h | 10 ++++++++
 .../kvm/lib/s390x/diag318_test_handler.c      |  3 +--
 .../selftests/kvm/s390x/sync_regs_test.c      | 15 +++--------
 .../selftests/kvm/set_memory_region_test.c    |  6 +----
 tools/testing/selftests/kvm/x86_64/amx_test.c |  8 +-----
 .../kvm/x86_64/cr4_cpuid_sync_test.c          |  8 +-----
 .../testing/selftests/kvm/x86_64/debug_regs.c |  2 +-
 .../selftests/kvm/x86_64/flds_emulation.h     |  5 +---
 .../selftests/kvm/x86_64/hyperv_clock.c       |  7 +-----
 .../selftests/kvm/x86_64/hyperv_evmcs.c       |  8 +-----
 .../selftests/kvm/x86_64/hyperv_features.c    | 14 ++---------
 .../testing/selftests/kvm/x86_64/hyperv_ipi.c |  6 +----
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |  7 +-----
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c   | 14 ++---------
 .../selftests/kvm/x86_64/kvm_clock_test.c     |  5 +---
 .../selftests/kvm/x86_64/kvm_pv_test.c        |  5 +---
 .../selftests/kvm/x86_64/monitor_mwait_test.c |  9 +------
 .../kvm/x86_64/nested_exceptions_test.c       |  5 +---
 .../selftests/kvm/x86_64/platform_info_test.c | 14 +++--------
 .../kvm/x86_64/pmu_event_filter_test.c        |  6 +----
 tools/testing/selftests/kvm/x86_64/smm_test.c |  9 +------
 .../testing/selftests/kvm/x86_64/state_test.c |  8 +-----
 .../selftests/kvm/x86_64/svm_int_ctl_test.c   |  8 +-----
 .../kvm/x86_64/svm_nested_shutdown_test.c     |  7 +-----
 .../kvm/x86_64/svm_nested_soft_inject_test.c  |  6 +----
 .../selftests/kvm/x86_64/svm_vmcall_test.c    |  6 +----
 .../selftests/kvm/x86_64/sync_regs_test.c     | 25 ++++---------------
 .../kvm/x86_64/triple_fault_event_test.c      |  9 ++-----
 .../selftests/kvm/x86_64/tsc_scaling_sync.c   |  6 +----
 .../kvm/x86_64/ucna_injection_test.c          | 22 +++-------------
 .../selftests/kvm/x86_64/userspace_io_test.c  |  6 +----
 .../kvm/x86_64/userspace_msr_exit_test.c      | 22 +++-------------
 .../kvm/x86_64/vmx_apic_access_test.c         | 11 ++------
 .../kvm/x86_64/vmx_close_while_nested_test.c  |  5 +---
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c |  7 +-----
 .../vmx_exception_with_invalid_guest_state.c  |  4 +--
 .../x86_64/vmx_invalid_nested_guest_state.c   |  4 +--
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  |  6 +----
 .../kvm/x86_64/vmx_preemption_timer_test.c    |  8 +-----
 .../kvm/x86_64/vmx_tsc_adjust_test.c          |  6 +----
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |  6 +----
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  7 +-----
 .../selftests/kvm/x86_64/xen_vmcall_test.c    |  5 +---
 44 files changed, 71 insertions(+), 293 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index cfa36f387948..9b004905d1d3 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -180,9 +180,7 @@ static void host_test_system_suspend(void)
 
 	enter_guest(source);
 
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
-		    "Unhandled exit reason: %u (%s)",
-		    run->exit_reason, exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(source, KVM_EXIT_SYSTEM_EVENT);
 	TEST_ASSERT(run->system_event.type == KVM_SYSTEM_EVENT_SUSPEND,
 		    "Unhandled system event: %u (expected: %u)",
 		    run->system_event.type, KVM_SYSTEM_EVENT_SUSPEND);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 80d6416f3012..3f15f216d2a6 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -63,6 +63,16 @@ void test_assert(bool exp, const char *exp_str,
 		    #a, #b, #a, (unsigned long) __a, #b, (unsigned long) __b); \
 } while (0)
 
+#define TEST_ASSERT_KVM_EXIT_REASON(vcpu, expected_exit_reason)		\
+({									\
+	__u32 exit_reason = (vcpu)->run->exit_reason;			\
+									\
+	TEST_ASSERT(exit_reason == (expected_exit_reason),		\
+		    "Unexpected exit reason: %u (%s)",			\
+		    exit_reason,					\
+		    exit_reason_str(exit_reason));			\
+})
+
 #define TEST_FAIL(fmt, ...) do { \
 	TEST_ASSERT(false, fmt, ##__VA_ARGS__); \
 	__builtin_unreachable(); \
diff --git a/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
index cdb7daeed5fd..2c432fa164f1 100644
--- a/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
+++ b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
@@ -35,8 +35,7 @@ static uint64_t diag318_handler(void)
 	vcpu_run(vcpu);
 	run = vcpu->run;
 
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
-		    "DIAGNOSE 0x0318 instruction was not intercepted");
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
 	TEST_ASSERT(run->s390_sieic.icptcode == ICPT_INSTRUCTION,
 		    "Unexpected intercept code: 0x%x", run->s390_sieic.icptcode);
 	TEST_ASSERT((run->s390_sieic.ipa & 0xff00) == IPA0_DIAG,
diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
index 2ddde41c44ba..636a70ddac1e 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -126,10 +126,7 @@ void test_req_and_verify_all_valid_regs(struct kvm_vcpu *vcpu)
 	run->kvm_valid_regs = TEST_SYNC_FIELDS;
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
-		    "Unexpected exit reason: %u (%s)\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
 	TEST_ASSERT(run->s390_sieic.icptcode == 4 &&
 		    (run->s390_sieic.ipa >> 8) == 0x83 &&
 		    (run->s390_sieic.ipb >> 16) == 0x501,
@@ -165,10 +162,7 @@ void test_set_and_verify_various_reg_values(struct kvm_vcpu *vcpu)
 
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
-		    "Unexpected exit reason: %u (%s)\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
 	TEST_ASSERT(run->s.regs.gprs[11] == 0xBAD1DEA + 1,
 		    "r11 sync regs value incorrect 0x%llx.",
 		    run->s.regs.gprs[11]);
@@ -200,10 +194,7 @@ void test_clear_kvm_dirty_regs_bits(struct kvm_vcpu *vcpu)
 	run->s.regs.diag318 = 0x4B1D;
 	rv = _vcpu_run(vcpu);
 	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
-		    "Unexpected exit reason: %u (%s)\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
 	TEST_ASSERT(run->s.regs.gprs[11] != 0xDEADBEEF,
 		    "r11 sync regs value incorrect 0x%llx.",
 		    run->s.regs.gprs[11]);
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 2ef1d1b72ce4..a849ce23ca97 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -308,7 +308,6 @@ static void test_delete_memory_region(void)
 static void test_zero_memory_regions(void)
 {
 	struct kvm_vcpu *vcpu;
-	struct kvm_run *run;
 	struct kvm_vm *vm;
 
 	pr_info("Testing KVM_RUN with zero added memory regions\n");
@@ -318,10 +317,7 @@ static void test_zero_memory_regions(void)
 
 	vm_ioctl(vm, KVM_SET_NR_MMU_PAGES, (void *)64ul);
 	vcpu_run(vcpu);
-
-	run = vcpu->run;
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
-		    "Unexpected exit_reason = %u\n", run->exit_reason);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_INTERNAL_ERROR);
 
 	kvm_vm_free(vm);
 }
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 21de6ae42086..71e665dd0817 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -241,7 +241,6 @@ int main(int argc, char *argv[])
 	struct kvm_regs regs1, regs2;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	struct kvm_run *run;
 	struct kvm_x86_state *state;
 	int xsave_restore_size;
 	vm_vaddr_t amx_cfg, tiledata, xsavedata;
@@ -263,7 +262,6 @@ int main(int argc, char *argv[])
 		    "KVM should enumerate max XSAVE size when XSAVE is supported");
 	xsave_restore_size = kvm_cpu_property(X86_PROPERTY_XSTATE_MAX_SIZE);
 
-	run = vcpu->run;
 	vcpu_regs_get(vcpu, &regs1);
 
 	/* Register #NM handler */
@@ -286,10 +284,7 @@ int main(int argc, char *argv[])
 
 	for (stage = 1; ; stage++) {
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Stage %d: unexpected exit reason: %u (%s),\n",
-			    stage, run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
@@ -345,7 +340,6 @@ int main(int argc, char *argv[])
 		/* Restore state in a new VM.  */
 		vcpu = vm_recreate_with_one_vcpu(vm);
 		vcpu_load_state(vcpu, state);
-		run = vcpu->run;
 		kvm_x86_state_cleanup(state);
 
 		memset(&regs2, 0, sizeof(regs2));
diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index 1027a671c7d3..624dc725e14d 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -50,7 +50,6 @@ static void guest_code(void)
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
-	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct kvm_sregs sregs;
 	struct ucall uc;
@@ -58,15 +57,10 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVE));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	run = vcpu->run;
 
 	while (1) {
 		vcpu_run(vcpu);
-
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Unexpected exit reason: %u (%s),\n",
-			    run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_SYNC:
diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86_64/debug_regs.c
index 7ef99c3359a0..f6b295e0b2d2 100644
--- a/tools/testing/selftests/kvm/x86_64/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86_64/debug_regs.c
@@ -204,7 +204,7 @@ int main(void)
 	vcpu_guest_debug_set(vcpu, &debug);
 
 	vcpu_run(vcpu);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO, "KVM_EXIT_IO");
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 	cmd = get_ucall(vcpu, &uc);
 	TEST_ASSERT(cmd == UCALL_DONE, "UCALL_DONE");
 
diff --git a/tools/testing/selftests/kvm/x86_64/flds_emulation.h b/tools/testing/selftests/kvm/x86_64/flds_emulation.h
index e43a7df25f2c..0a1573d52882 100644
--- a/tools/testing/selftests/kvm/x86_64/flds_emulation.h
+++ b/tools/testing/selftests/kvm/x86_64/flds_emulation.h
@@ -24,10 +24,7 @@ static inline void handle_flds_emulation_failure_exit(struct kvm_vcpu *vcpu)
 	uint8_t *insn_bytes;
 	uint64_t flags;
 
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
-		    "Unexpected exit reason: %u (%s)",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_INTERNAL_ERROR);
 
 	TEST_ASSERT(run->emulation_failure.suberror == KVM_INTERNAL_ERROR_EMULATION,
 		    "Unexpected suberror: %u",
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index 2ee0af0d449e..f25749eaa6a8 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -207,13 +207,11 @@ int main(void)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	struct kvm_run *run;
 	struct ucall uc;
 	vm_vaddr_t tsc_page_gva;
 	int stage;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
-	run = vcpu->run;
 
 	vcpu_set_hv_cpuid(vcpu);
 
@@ -227,10 +225,7 @@ int main(void)
 
 	for (stage = 1;; stage++) {
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Stage %d: unexpected exit reason: %u (%s),\n",
-			    stage, run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
index ba09d300c953..54991959e3f1 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
@@ -237,7 +237,6 @@ int main(int argc, char *argv[])
 
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	struct kvm_run *run;
 	struct ucall uc;
 	int stage;
 
@@ -266,13 +265,8 @@ int main(int argc, char *argv[])
 	pr_info("Running L1 which uses EVMCS to run L2\n");
 
 	for (stage = 1;; stage++) {
-		run = vcpu->run;
-
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Stage %d: unexpected exit reason: %u (%s),\n",
-			    stage, run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index c5e3b39edd07..78606de9385d 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -122,7 +122,6 @@ static void guest_test_msrs_access(void)
 {
 	struct kvm_cpuid2 *prev_cpuid = NULL;
 	struct kvm_vcpu *vcpu;
-	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage = 0;
@@ -151,8 +150,6 @@ static void guest_test_msrs_access(void)
 		vm_init_descriptor_tables(vm);
 		vcpu_init_descriptor_tables(vcpu);
 
-		run = vcpu->run;
-
 		/* TODO: Make this entire test easier to maintain. */
 		if (stage >= 21)
 			vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_SYNIC2, 0);
@@ -494,9 +491,7 @@ static void guest_test_msrs_access(void)
 			 msr->idx, msr->write ? "write" : "read");
 
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "unexpected exit reason: %u (%s)",
-			    run->exit_reason, exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
@@ -518,7 +513,6 @@ static void guest_test_hcalls_access(void)
 {
 	struct kvm_cpuid2 *prev_cpuid = NULL;
 	struct kvm_vcpu *vcpu;
-	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage = 0;
@@ -550,8 +544,6 @@ static void guest_test_hcalls_access(void)
 			vcpu_init_cpuid(vcpu, prev_cpuid);
 		}
 
-		run = vcpu->run;
-
 		switch (stage) {
 		case 0:
 			vcpu_set_cpuid_feature(vcpu, HV_MSR_HYPERCALL_AVAILABLE);
@@ -669,9 +661,7 @@ static void guest_test_hcalls_access(void)
 		pr_debug("Stage %d: testing hcall: 0x%lx\n", stage, hcall->control);
 
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "unexpected exit reason: %u (%s)",
-			    run->exit_reason, exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
index 8b791eac7d5a..e4b700de4b44 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_ipi.c
@@ -242,7 +242,6 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu[3];
-	unsigned int exit_reason;
 	vm_vaddr_t hcall_page;
 	pthread_t threads[2];
 	int stage = 1, r;
@@ -282,10 +281,7 @@ int main(int argc, char *argv[])
 	while (true) {
 		vcpu_run(vcpu[0]);
 
-		exit_reason = vcpu[0]->run->exit_reason;
-		TEST_ASSERT(exit_reason == KVM_EXIT_IO,
-			    "unexpected exit reason: %u (%s)",
-			    exit_reason, exit_reason_str(exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu[0], KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu[0], &uc)) {
 		case UCALL_SYNC:
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index 3b3cc94ba8e4..2fce3fc43f3f 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -156,7 +156,6 @@ int main(int argc, char *argv[])
 	vm_vaddr_t hcall_page;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	struct kvm_run *run;
 	struct ucall uc;
 	int stage;
 
@@ -165,7 +164,6 @@ int main(int argc, char *argv[])
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	vcpu_set_hv_cpuid(vcpu);
-	run = vcpu->run;
 	vcpu_alloc_svm(vm, &nested_gva);
 	vcpu_alloc_hyperv_test_pages(vm, &hv_pages_gva);
 
@@ -177,10 +175,7 @@ int main(int argc, char *argv[])
 
 	for (stage = 1;; stage++) {
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Stage %d: unexpected exit reason: %u (%s),\n",
-			    stage, run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
index 68f97ff720a7..4758b6ef5618 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
@@ -542,18 +542,13 @@ static void *vcpu_thread(void *arg)
 	struct ucall uc;
 	int old;
 	int r;
-	unsigned int exit_reason;
 
 	r = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
 	TEST_ASSERT(!r, "pthread_setcanceltype failed on vcpu_id=%u with errno=%d",
 		    vcpu->id, r);
 
 	vcpu_run(vcpu);
-	exit_reason = vcpu->run->exit_reason;
-
-	TEST_ASSERT(exit_reason == KVM_EXIT_IO,
-		    "vCPU %u exited with unexpected exit reason %u-%s, expected KVM_EXIT_IO",
-		    vcpu->id, exit_reason, exit_reason_str(exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
@@ -587,7 +582,6 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu[3];
-	unsigned int exit_reason;
 	pthread_t threads[2];
 	vm_vaddr_t test_data_page, gva;
 	vm_paddr_t gpa;
@@ -657,11 +651,7 @@ int main(int argc, char *argv[])
 
 	while (true) {
 		vcpu_run(vcpu[0]);
-		exit_reason = vcpu[0]->run->exit_reason;
-
-		TEST_ASSERT(exit_reason == KVM_EXIT_IO,
-			    "unexpected exit reason: %u (%s)",
-			    exit_reason, exit_reason_str(exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu[0], KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu[0], &uc)) {
 		case UCALL_SYNC:
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
index 813ce282cf56..1778704360a6 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
@@ -105,7 +105,6 @@ static void setup_clock(struct kvm_vm *vm, struct test_case *test_case)
 static void enter_guest(struct kvm_vcpu *vcpu)
 {
 	struct kvm_clock_data start, end;
-	struct kvm_run *run = vcpu->run;
 	struct kvm_vm *vm = vcpu->vm;
 	struct ucall uc;
 	int i;
@@ -118,9 +117,7 @@ static void enter_guest(struct kvm_vcpu *vcpu)
 		vcpu_run(vcpu);
 		vm_ioctl(vm, KVM_GET_CLOCK, &end);
 
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "unexpected exit reason: %u (%s)",
-			    run->exit_reason, exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_SYNC:
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 619655c1a1f3..f774a9e62858 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -111,14 +111,11 @@ static void pr_hcall(struct ucall *uc)
 
 static void enter_guest(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
 	while (true) {
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "unexpected exit reason: %u (%s)",
-			    run->exit_reason, exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_PR_MSR:
diff --git a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
index 016070cad36e..72812644d7f5 100644
--- a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
+++ b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
@@ -64,7 +64,6 @@ int main(int argc, char *argv[])
 {
 	uint64_t disabled_quirks;
 	struct kvm_vcpu *vcpu;
-	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int testcase;
@@ -74,18 +73,12 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_MWAIT);
 
-	run = vcpu->run;
-
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
 
 	while (1) {
 		vcpu_run(vcpu);
-
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Unexpected exit reason: %u (%s),\n",
-			    run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_SYNC:
diff --git a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
index ac33835f78f4..6502aa23c2f8 100644
--- a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
@@ -166,12 +166,9 @@ static void __attribute__((__flatten__)) l1_guest_code(void *test_data)
 
 static void assert_ucall_vector(struct kvm_vcpu *vcpu, int vector)
 {
-	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Unexpected exit reason: %u (%s),\n",
-		    run->exit_reason, exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_SYNC:
diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
index 310a104d94f0..c9a07963d68a 100644
--- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
@@ -36,15 +36,12 @@ static void guest_code(void)
 
 static void test_msr_platform_info_enabled(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
 	vm_enable_cap(vcpu->vm, KVM_CAP_MSR_PLATFORM_INFO, true);
 	vcpu_run(vcpu);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			"Exit_reason other than KVM_EXIT_IO: %u (%s),\n",
-			run->exit_reason,
-			exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
 	get_ucall(vcpu, &uc);
 	TEST_ASSERT(uc.cmd == UCALL_SYNC,
 			"Received ucall other than UCALL_SYNC: %lu\n", uc.cmd);
@@ -56,14 +53,9 @@ static void test_msr_platform_info_enabled(struct kvm_vcpu *vcpu)
 
 static void test_msr_platform_info_disabled(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
-
 	vm_enable_cap(vcpu->vm, KVM_CAP_MSR_PLATFORM_INFO, false);
 	vcpu_run(vcpu);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
-			"Exit_reason other than KVM_EXIT_SHUTDOWN: %u (%s)\n",
-			run->exit_reason,
-			exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_SHUTDOWN);
 }
 
 int main(int argc, char *argv[])
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 2de98fce7edd..c2d89e7833df 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -151,14 +151,10 @@ static void amd_guest_code(void)
  */
 static uint64_t run_vcpu_to_sync(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
 	vcpu_run(vcpu);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Exit_reason other than KVM_EXIT_IO: %u (%s)\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 	get_ucall(vcpu, &uc);
 	TEST_ASSERT(uc.cmd == UCALL_SYNC,
 		    "Received ucall other than UCALL_SYNC: %lu", uc.cmd);
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index cb38a478e1f6..e18b86666e1f 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -133,7 +133,6 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_regs regs;
 	struct kvm_vm *vm;
-	struct kvm_run *run;
 	struct kvm_x86_state *state;
 	int stage, stage_reported;
 
@@ -142,8 +141,6 @@ int main(int argc, char *argv[])
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	run = vcpu->run;
-
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, SMRAM_GPA,
 				    SMRAM_MEMSLOT, SMRAM_PAGES, 0);
 	TEST_ASSERT(vm_phy_pages_alloc(vm, SMRAM_PAGES, SMRAM_GPA, SMRAM_MEMSLOT)
@@ -169,10 +166,7 @@ int main(int argc, char *argv[])
 
 	for (stage = 1;; stage++) {
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Stage %d: unexpected exit reason: %u (%s),\n",
-			    stage, run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		memset(&regs, 0, sizeof(regs));
 		vcpu_regs_get(vcpu, &regs);
@@ -208,7 +202,6 @@ int main(int argc, char *argv[])
 
 		vcpu = vm_recreate_with_one_vcpu(vm);
 		vcpu_load_state(vcpu, state);
-		run = vcpu->run;
 		kvm_x86_state_cleanup(state);
 	}
 
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index ea578971fb9f..4c4925a8ab45 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -158,14 +158,12 @@ int main(int argc, char *argv[])
 	struct kvm_regs regs1, regs2;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	struct kvm_run *run;
 	struct kvm_x86_state *state;
 	struct ucall uc;
 	int stage;
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	run = vcpu->run;
 
 	vcpu_regs_get(vcpu, &regs1);
 
@@ -183,10 +181,7 @@ int main(int argc, char *argv[])
 
 	for (stage = 1;; stage++) {
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Stage %d: unexpected exit reason: %u (%s),\n",
-			    stage, run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
@@ -214,7 +209,6 @@ int main(int argc, char *argv[])
 		/* Restore state in a new VM.  */
 		vcpu = vm_recreate_with_one_vcpu(vm);
 		vcpu_load_state(vcpu, state);
-		run = vcpu->run;
 		kvm_x86_state_cleanup(state);
 
 		memset(&regs2, 0, sizeof(regs2));
diff --git a/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c b/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c
index 4a07ba227b99..32bef39bec21 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_int_ctl_test.c
@@ -85,7 +85,6 @@ static void l1_guest_code(struct svm_test_data *svm)
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
-	struct kvm_run *run;
 	vm_vaddr_t svm_gva;
 	struct kvm_vm *vm;
 	struct ucall uc;
@@ -103,13 +102,8 @@ int main(int argc, char *argv[])
 	vcpu_alloc_svm(vm, &svm_gva);
 	vcpu_args_set(vcpu, 1, svm_gva);
 
-	run = vcpu->run;
-
 	vcpu_run(vcpu);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c
index e73fcdef47bb..d6fcdcc3af31 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_shutdown_test.c
@@ -42,7 +42,6 @@ static void l1_guest_code(struct svm_test_data *svm, struct idt_entry *idt)
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
-	struct kvm_run *run;
 	vm_vaddr_t svm_gva;
 	struct kvm_vm *vm;
 
@@ -55,13 +54,9 @@ int main(int argc, char *argv[])
 	vcpu_alloc_svm(vm, &svm_gva);
 
 	vcpu_args_set(vcpu, 2, svm_gva, vm->idt);
-	run = vcpu->run;
 
 	vcpu_run(vcpu);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
-		    "Got exit_reason other than KVM_EXIT_SHUTDOWN: %u (%s)\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_SHUTDOWN);
 
 	kvm_vm_free(vm);
 }
diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
index e497ace629c1..649cdd7b7425 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -167,16 +167,12 @@ static void run_test(bool is_nmi)
 	memset(&debug, 0, sizeof(debug));
 	vcpu_guest_debug_set(vcpu, &debug);
 
-	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
 	alarm(2);
 	vcpu_run(vcpu);
 	alarm(0);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
index c3ac45df7483..8a62cca28cfb 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
@@ -47,14 +47,10 @@ int main(int argc, char *argv[])
 	vcpu_args_set(vcpu, 1, svm_gva);
 
 	for (;;) {
-		volatile struct kvm_run *run = vcpu->run;
 		struct ucall uc;
 
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
-			    run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index d2f9b5bdfab2..2da89fdc2471 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -132,10 +132,7 @@ int main(int argc, char *argv[])
 	/* TODO: BUILD TIME CHECK: TEST_ASSERT(KVM_SYNC_X86_NUM_FIELDS != 3); */
 	run->kvm_valid_regs = TEST_SYNC_FIELDS;
 	rv = _vcpu_run(vcpu);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Unexpected exit reason: %u (%s),\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 	vcpu_regs_get(vcpu, &regs);
 	compare_regs(&regs, &run->s.regs.regs);
@@ -154,10 +151,7 @@ int main(int argc, char *argv[])
 	run->kvm_valid_regs = TEST_SYNC_FIELDS;
 	run->kvm_dirty_regs = KVM_SYNC_X86_REGS | KVM_SYNC_X86_SREGS;
 	rv = _vcpu_run(vcpu);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Unexpected exit reason: %u (%s),\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 	TEST_ASSERT(run->s.regs.regs.rbx == 0xBAD1DEA + 1,
 		    "rbx sync regs value incorrect 0x%llx.",
 		    run->s.regs.regs.rbx);
@@ -181,10 +175,7 @@ int main(int argc, char *argv[])
 	run->kvm_dirty_regs = 0;
 	run->s.regs.regs.rbx = 0xDEADBEEF;
 	rv = _vcpu_run(vcpu);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Unexpected exit reason: %u (%s),\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 	TEST_ASSERT(run->s.regs.regs.rbx != 0xDEADBEEF,
 		    "rbx sync regs value incorrect 0x%llx.",
 		    run->s.regs.regs.rbx);
@@ -199,10 +190,7 @@ int main(int argc, char *argv[])
 	regs.rbx = 0xBAC0;
 	vcpu_regs_set(vcpu, &regs);
 	rv = _vcpu_run(vcpu);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Unexpected exit reason: %u (%s),\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 	TEST_ASSERT(run->s.regs.regs.rbx == 0xAAAA,
 		    "rbx sync regs value incorrect 0x%llx.",
 		    run->s.regs.regs.rbx);
@@ -219,10 +207,7 @@ int main(int argc, char *argv[])
 	run->kvm_dirty_regs = TEST_SYNC_FIELDS;
 	run->s.regs.regs.rbx = 0xBBBB;
 	rv = _vcpu_run(vcpu);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Unexpected exit reason: %u (%s),\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 	TEST_ASSERT(run->s.regs.regs.rbx == 0xBBBB,
 		    "rbx sync regs value incorrect 0x%llx.",
 		    run->s.regs.regs.rbx);
diff --git a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
index ead5d878a71c..56306a19144a 100644
--- a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
+++ b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
@@ -89,9 +89,7 @@ int main(void)
 	run = vcpu->run;
 	vcpu_run(vcpu);
 
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Expected KVM_EXIT_IO, got: %u (%s)\n",
-		    run->exit_reason, exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 	TEST_ASSERT(run->io.port == ARBITRARY_IO_PORT,
 		    "Expected IN from port %d from L2, got port %d",
 		    ARBITRARY_IO_PORT, run->io.port);
@@ -111,10 +109,7 @@ int main(void)
 
 
 	if (has_svm) {
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
-			    "Got exit_reason other than KVM_EXIT_SHUTDOWN: %u (%s)\n",
-			    run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_SHUTDOWN);
 	} else {
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_DONE:
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
index 47139aab7408..5b669818e39a 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
@@ -64,14 +64,10 @@ static void *run_vcpu(void *_cpu_nr)
 	pthread_spin_unlock(&create_lock);
 
 	for (;;) {
-		volatile struct kvm_run *run = vcpu->run;
                 struct ucall uc;
 
 		vcpu_run(vcpu);
-                TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-                            "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
-                            run->exit_reason,
-                            exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
                 case UCALL_DONE:
diff --git a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
index a897c7fd8abe..85f34ca7e49e 100644
--- a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
+++ b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
@@ -137,15 +137,11 @@ static void guest_gp_handler(struct ex_regs *regs)
 
 static void run_vcpu_expect_gp(struct kvm_vcpu *vcpu)
 {
-	unsigned int exit_reason;
 	struct ucall uc;
 
 	vcpu_run(vcpu);
 
-	exit_reason = vcpu->run->exit_reason;
-	TEST_ASSERT(exit_reason == KVM_EXIT_IO,
-		    "exited with unexpected exit reason %u-%s, expected KVM_EXIT_IO",
-		    exit_reason, exit_reason_str(exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC,
 		    "Expect UCALL_SYNC\n");
 	TEST_ASSERT(uc.args[1] == SYNC_GP, "#GP is expected.");
@@ -182,7 +178,6 @@ static void *run_ucna_injection(void *arg)
 	struct ucall uc;
 	int old;
 	int r;
-	unsigned int exit_reason;
 
 	r = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
 	TEST_ASSERT(r == 0,
@@ -191,10 +186,7 @@ static void *run_ucna_injection(void *arg)
 
 	vcpu_run(params->vcpu);
 
-	exit_reason = params->vcpu->run->exit_reason;
-	TEST_ASSERT(exit_reason == KVM_EXIT_IO,
-		    "unexpected exit reason %u-%s, expected KVM_EXIT_IO",
-		    exit_reason, exit_reason_str(exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(params->vcpu, KVM_EXIT_IO);
 	TEST_ASSERT(get_ucall(params->vcpu, &uc) == UCALL_SYNC,
 		    "Expect UCALL_SYNC\n");
 	TEST_ASSERT(uc.args[1] == SYNC_FIRST_UCNA, "Injecting first UCNA.");
@@ -204,10 +196,7 @@ static void *run_ucna_injection(void *arg)
 	inject_ucna(params->vcpu, FIRST_UCNA_ADDR);
 	vcpu_run(params->vcpu);
 
-	exit_reason = params->vcpu->run->exit_reason;
-	TEST_ASSERT(exit_reason == KVM_EXIT_IO,
-		    "unexpected exit reason %u-%s, expected KVM_EXIT_IO",
-		    exit_reason, exit_reason_str(exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(params->vcpu, KVM_EXIT_IO);
 	TEST_ASSERT(get_ucall(params->vcpu, &uc) == UCALL_SYNC,
 		    "Expect UCALL_SYNC\n");
 	TEST_ASSERT(uc.args[1] == SYNC_SECOND_UCNA, "Injecting second UCNA.");
@@ -217,10 +206,7 @@ static void *run_ucna_injection(void *arg)
 	inject_ucna(params->vcpu, SECOND_UCNA_ADDR);
 	vcpu_run(params->vcpu);
 
-	exit_reason = params->vcpu->run->exit_reason;
-	TEST_ASSERT(exit_reason == KVM_EXIT_IO,
-		    "unexpected exit reason %u-%s, expected KVM_EXIT_IO",
-		    exit_reason, exit_reason_str(exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(params->vcpu, KVM_EXIT_IO);
 	if (get_ucall(params->vcpu, &uc) == UCALL_ABORT) {
 		TEST_ASSERT(false, "vCPU assertion failure: %s.\n",
 			    (const char *)uc.args[0]);
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
index 91076c9787b4..0cb51fa42773 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
@@ -63,11 +63,7 @@ int main(int argc, char *argv[])
 
 	while (1) {
 		vcpu_run(vcpu);
-
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Unexpected exit reason: %u (%s),\n",
-			    run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		if (get_ucall(vcpu, &uc))
 			break;
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index 25fa55344a10..3533dc2fbfee 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -410,10 +410,7 @@ static void process_rdmsr(struct kvm_vcpu *vcpu, uint32_t msr_index)
 
 	check_for_guest_assert(vcpu);
 
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_X86_RDMSR,
-		    "Unexpected exit reason: %u (%s),\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_X86_RDMSR);
 	TEST_ASSERT(run->msr.index == msr_index,
 			"Unexpected msr (0x%04x), expected 0x%04x",
 			run->msr.index, msr_index);
@@ -445,10 +442,7 @@ static void process_wrmsr(struct kvm_vcpu *vcpu, uint32_t msr_index)
 
 	check_for_guest_assert(vcpu);
 
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_X86_WRMSR,
-		    "Unexpected exit reason: %u (%s),\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_X86_WRMSR);
 	TEST_ASSERT(run->msr.index == msr_index,
 			"Unexpected msr (0x%04x), expected 0x%04x",
 			run->msr.index, msr_index);
@@ -472,15 +466,11 @@ static void process_wrmsr(struct kvm_vcpu *vcpu, uint32_t msr_index)
 
 static void process_ucall_done(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
 	struct ucall uc;
 
 	check_for_guest_assert(vcpu);
 
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Unexpected exit reason: %u (%s)",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_DONE,
 		    "Unexpected ucall command: %lu, expected UCALL_DONE (%d)",
@@ -489,15 +479,11 @@ static void process_ucall_done(struct kvm_vcpu *vcpu)
 
 static uint64_t process_ucall(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
 	struct ucall uc = {};
 
 	check_for_guest_assert(vcpu);
 
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Unexpected exit reason: %u (%s)",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_SYNC:
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
index 5abecf06329e..2bed5fb3a0d6 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
@@ -96,21 +96,14 @@ int main(int argc, char *argv[])
 
 		vcpu_run(vcpu);
 		if (apic_access_addr == high_gpa) {
-			TEST_ASSERT(run->exit_reason ==
-				    KVM_EXIT_INTERNAL_ERROR,
-				    "Got exit reason other than KVM_EXIT_INTERNAL_ERROR: %u (%s)\n",
-				    run->exit_reason,
-				    exit_reason_str(run->exit_reason));
+			TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_INTERNAL_ERROR);
 			TEST_ASSERT(run->internal.suberror ==
 				    KVM_INTERNAL_ERROR_EMULATION,
 				    "Got internal suberror other than KVM_INTERNAL_ERROR_EMULATION: %u\n",
 				    run->internal.suberror);
 			break;
 		}
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
-			    run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
index d79651b02740..dad988351493 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_close_while_nested_test.c
@@ -64,10 +64,7 @@ int main(int argc, char *argv[])
 		struct ucall uc;
 
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
-			    run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		if (run->io.port == PORT_L0_EXIT)
 			break;
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
index f0456fb031b1..e4ad5fef52ff 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -73,7 +73,6 @@ int main(int argc, char *argv[])
 
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	struct kvm_run *run;
 	struct ucall uc;
 	bool done = false;
 
@@ -84,7 +83,6 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
 	vcpu_args_set(vcpu, 1, vmx_pages_gva);
-	run = vcpu->run;
 
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
@@ -117,10 +115,7 @@ int main(int argc, char *argv[])
 	while (!done) {
 		memset(host_test_mem, 0xaa, TEST_MEM_PAGES * 4096);
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Unexpected exit reason: %u (%s),\n",
-			    run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c b/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
index 2641b286b4ed..e940fa570ab2 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
@@ -26,9 +26,7 @@ static void __run_vcpu_with_invalid_state(struct kvm_vcpu *vcpu)
 
 	vcpu_run(vcpu);
 
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
-		    "Expected KVM_EXIT_INTERNAL_ERROR, got %d (%s)\n",
-		    run->exit_reason, exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_INTERNAL_ERROR);
 	TEST_ASSERT(run->emulation_failure.suberror == KVM_INTERNAL_ERROR_EMULATION,
 		    "Expected emulation failure, got %d\n",
 		    run->emulation_failure.suberror);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c b/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
index 6bfb4bb471ca..a100ee5f0009 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
@@ -74,9 +74,7 @@ int main(int argc, char *argv[])
 	 * The first exit to L0 userspace should be an I/O access from L2.
 	 * Running L1 should launch L2 without triggering an exit to userspace.
 	 */
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Expected KVM_EXIT_IO, got: %u (%s)\n",
-		    run->exit_reason, exit_reason_str(run->exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 	TEST_ASSERT(run->io.port == ARBITRARY_IO_PORT,
 		    "Expected IN from port %d from L2, got port %d",
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
index 465a9434d61c..d427eb146bc5 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
@@ -183,14 +183,10 @@ int main(int argc, char *argv[])
 	vcpu_ioctl(vcpu, KVM_SET_TSC_KHZ, (void *) (tsc_khz / l1_scale_factor));
 
 	for (;;) {
-		volatile struct kvm_run *run = vcpu->run;
 		struct ucall uc;
 
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
-			    run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
index 0efdc05969a5..affc32800158 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
@@ -157,7 +157,6 @@ int main(int argc, char *argv[])
 
 	struct kvm_regs regs1, regs2;
 	struct kvm_vm *vm;
-	struct kvm_run *run;
 	struct kvm_vcpu *vcpu;
 	struct kvm_x86_state *state;
 	struct ucall uc;
@@ -173,7 +172,6 @@ int main(int argc, char *argv[])
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	run = vcpu->run;
 
 	vcpu_regs_get(vcpu, &regs1);
 
@@ -182,10 +180,7 @@ int main(int argc, char *argv[])
 
 	for (stage = 1;; stage++) {
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Stage %d: unexpected exit reason: %u (%s),\n",
-			    stage, run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
@@ -237,7 +232,6 @@ int main(int argc, char *argv[])
 		/* Restore state in a new VM.  */
 		vcpu = vm_recreate_with_one_vcpu(vm);
 		vcpu_load_state(vcpu, state);
-		run = vcpu->run;
 		kvm_x86_state_cleanup(state);
 
 		memset(&regs2, 0, sizeof(regs2));
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
index 5943187e8594..57a3a11e1573 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_tsc_adjust_test.c
@@ -136,14 +136,10 @@ int main(int argc, char *argv[])
 	vcpu_args_set(vcpu, 1, vmx_pages_gva);
 
 	for (;;) {
-		volatile struct kvm_run *run = vcpu->run;
 		struct ucall uc;
 
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
-			    run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
index 3d272d7f961e..67ac2a3292ef 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
@@ -198,7 +198,6 @@ static void *vcpu_thread(void *arg)
 	struct ucall uc;
 	int old;
 	int r;
-	unsigned int exit_reason;
 
 	r = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
 	TEST_ASSERT(r == 0,
@@ -207,11 +206,8 @@ static void *vcpu_thread(void *arg)
 
 	fprintf(stderr, "vCPU thread running vCPU %u\n", vcpu->id);
 	vcpu_run(vcpu);
-	exit_reason = vcpu->run->exit_reason;
 
-	TEST_ASSERT(exit_reason == KVM_EXIT_IO,
-		    "vCPU %u exited with unexpected exit reason %u-%s, expected KVM_EXIT_IO",
-		    vcpu->id, exit_reason, exit_reason_str(exit_reason));
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 	if (get_ucall(vcpu, &uc) == UCALL_ABORT) {
 		TEST_ASSERT(false,
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 721f6a693799..e7c0753843ef 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -625,15 +625,10 @@ int main(int argc, char *argv[])
 	bool evtchn_irq_expected = false;
 
 	for (;;) {
-		volatile struct kvm_run *run = vcpu->run;
 		struct ucall uc;
 
 		vcpu_run(vcpu);
-
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
-			    run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
index 88914d48c65e..c94cde3b523f 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -122,10 +122,7 @@ int main(int argc, char *argv[])
 			continue;
 		}
 
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
-			    run->exit_reason,
-			    exit_reason_str(run->exit_reason));
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
-- 
2.39.0.rc1.256.g54fd8350bd-goog

