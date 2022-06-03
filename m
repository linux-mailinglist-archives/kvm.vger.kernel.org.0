Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D0F53C24D
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241092AbiFCAz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241494AbiFCAvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:51:12 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B9C37BE5
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:53 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id u67-20020a627946000000b0051b9c1256b0so3500111pfc.9
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Xpy9nxWW290N6cNkcKM7VO2ugdfUgHDgcSvxHbiKmbc=;
        b=Ql1pO7Y2uOl0ElaLdY9nKkwij0Y78BTAVvTsnYlOWeK/9TgNjq7OOaPZMMX+WEYbWR
         LGXyZWAVlQisuv8ML1iLjnYXobZWKXqR/zpOLAamlx5lxYs/XBBvlpw7eE0roVlz0rE7
         UaP5B7JS0UL5gc6RQpM2Ch56OjyKokublz0bOXcQITSXky4gRGzs4uyG67bOGQxRxyqM
         BSlN7W+KIsUpQ4z3KVwpjr/FKtdrE+x5lQGqb0NXRCrGHAf+ASoxk2wD/gDwZovIqkRW
         TQdKZ8m9e1+urko5F2Z0SoEESH02sYFkvHI7VnXBlxwnp7jDCUFEDb31+T3Ti9yahlst
         CMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Xpy9nxWW290N6cNkcKM7VO2ugdfUgHDgcSvxHbiKmbc=;
        b=f7yCKK90FyCgsJ/Jtxe64yf/hT+BDzOs+EvsXeD0GEbK8liwu6NdPvtkw/2kchhobd
         Jtux+1Ui/gl35+jQL/Ei5VoIPOqjIO/FeMph03AaEkK84w2fQswowJyqzZZnm2NObFR1
         lRf8PIxsFNwIXAm1sS9x4qyglYeRCGqL2sacmqaRSQFW4ya6IXRetJakE4lLx7vvrr+M
         pUNt8M/DdWq9mGZOTeRhDpdWC16laN+QQ5zjD3rP2D4fySSUma0ycKD+lwXy2RReQmXm
         RCgENgaGAjVcTHqr88+HAw8xuBrttmeFRPYW9RJ/4pTE1T9rgpDTVypYAnuuM7Boyspw
         vA9A==
X-Gm-Message-State: AOAM533y3qNbZUzAMYJ+r5XNmnE4mdDvIDnLaYp5XT48NTtxucxRAGY8
        wMcPaXIdwk931omkAY2LGvoe3UP7Zk8=
X-Google-Smtp-Source: ABdhPJySkzx+BXxY1IJPMt36dPS4VVIgN/wvjrbVmG4g5zzSOcNbjjxX2JFDEtWtCvzuCm/BHnDFDGyUTbI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:6b83:b0:15d:1ea2:4f80 with SMTP id
 p3-20020a1709026b8300b0015d1ea24f80mr7439717plk.41.1654217272524; Thu, 02 Jun
 2022 17:47:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:29 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-143-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 142/144] KVM: selftests: Add kvm_has_cap() to provide
 syntactic sugar
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

Add kvm_has_cap() to wrap kvm_check_cap() and return a bool for the use
cases where the caller only wants check if a capability is supported,
i.e. doesn't care about the value beyond whether or not it's non-zero.
The "check" terminology is somewhat ambiguous as the non-boolean return
suggests that '0' might mean "success", i.e. suggests that the ioctl uses
the 0/-errno pattern.  Provide a wrapper instead of trying to find a new
name for the raw helper; the "check" terminology is derived from the name
of the ioctl, so using e.g. "get" isn't a clear win.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c          | 2 +-
 tools/testing/selftests/kvm/aarch64/vcpu_width_config.c     | 2 +-
 tools/testing/selftests/kvm/dirty_log_test.c                | 4 ++--
 tools/testing/selftests/kvm/include/kvm_util_base.h         | 5 +++++
 tools/testing/selftests/kvm/kvm_binary_stats_test.c         | 2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c                  | 4 ++--
 .../testing/selftests/kvm/lib/s390x/diag318_test_handler.c  | 2 +-
 tools/testing/selftests/kvm/x86_64/debug_regs.c             | 2 +-
 tools/testing/selftests/kvm/x86_64/emulator_error_test.c    | 2 +-
 tools/testing/selftests/kvm/x86_64/evmcs_test.c             | 4 ++--
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c           | 6 +++---
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c            | 2 +-
 tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c        | 2 +-
 tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c      | 4 ++--
 .../testing/selftests/kvm/x86_64/triple_fault_event_test.c  | 2 +-
 tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c       | 2 +-
 .../selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c      | 2 +-
 .../selftests/kvm/x86_64/vmx_preemption_timer_test.c        | 2 +-
 .../selftests/kvm/x86_64/vmx_set_nested_state_test.c        | 2 +-
 19 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index d606d64a2ff5..013bf0f54580 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -395,7 +395,7 @@ static void check_supported(struct vcpu_config *c)
 	struct reg_sublist *s;
 
 	for_each_sublist(c, s) {
-		if (s->capability && !kvm_check_cap(s->capability)) {
+		if (s->capability && !kvm_has_cap(s->capability)) {
 			fprintf(stderr, "%s: %s not available, skipping tests\n", config_name(c), s->name);
 			exit(KSFT_SKIP);
 		}
diff --git a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
index dd5a1c4b49e0..fff02c442610 100644
--- a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
+++ b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
@@ -82,7 +82,7 @@ int main(void)
 	struct kvm_vm *vm;
 	int ret;
 
-	if (!kvm_check_cap(KVM_CAP_ARM_EL1_32BIT)) {
+	if (!kvm_has_cap(KVM_CAP_ARM_EL1_32BIT)) {
 		print_skip("KVM_CAP_ARM_EL1_32BIT is not supported");
 		exit(KSFT_SKIP);
 	}
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 8542f713a101..9c883c94d478 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -210,7 +210,7 @@ static void sem_wait_until(sem_t *sem)
 
 static bool clear_log_supported(void)
 {
-	return kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
+	return kvm_has_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
 }
 
 static void clear_log_create_vm_done(struct kvm_vm *vm)
@@ -264,7 +264,7 @@ static void default_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 
 static bool dirty_ring_supported(void)
 {
-	return kvm_check_cap(KVM_CAP_DIRTY_LOG_RING);
+	return kvm_has_cap(KVM_CAP_DIRTY_LOG_RING);
 }
 
 static void dirty_ring_create_vm_done(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 72cc0ecda067..04ddab322b6b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -169,6 +169,11 @@ int open_path_or_exit(const char *path, int flags);
 int open_kvm_dev_path_or_exit(void);
 unsigned int kvm_check_cap(long cap);
 
+static inline bool kvm_has_cap(long cap)
+{
+	return kvm_check_cap(cap);
+}
+
 #define __KVM_SYSCALL_ERROR(_name, _ret) \
 	"%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(errno)
 
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 982bf3f7d9c5..8754b78ae785 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -213,7 +213,7 @@ int main(int argc, char *argv[])
 	}
 
 	/* Check the extension for binary stats */
-	if (!kvm_check_cap(KVM_CAP_BINARY_STATS_FD)) {
+	if (!kvm_has_cap(KVM_CAP_BINARY_STATS_FD)) {
 		print_skip("Binary form statistics interface is not supported");
 		exit(KSFT_SKIP);
 	}
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8f7ee9cb551c..12b7c40542df 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -80,7 +80,7 @@ unsigned int kvm_check_cap(long cap)
 
 	close(kvm_fd);
 
-	return ret;
+	return (unsigned int)ret;
 }
 
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
@@ -93,7 +93,7 @@ static void vm_open(struct kvm_vm *vm)
 {
 	vm->kvm_fd = _open_kvm_dev_path_or_exit(O_RDWR);
 
-	if (!kvm_check_cap(KVM_CAP_IMMEDIATE_EXIT)) {
+	if (!kvm_has_cap(KVM_CAP_IMMEDIATE_EXIT)) {
 		print_skip("immediate_exit not available");
 		exit(KSFT_SKIP);
 	}
diff --git a/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
index 05283f8c9948..cdb7daeed5fd 100644
--- a/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
+++ b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
@@ -61,7 +61,7 @@ uint64_t get_diag318_info(void)
 	 * If KVM does not support diag318, then return 0 to
 	 * ensure tests do not break.
 	 */
-	if (!kvm_check_cap(KVM_CAP_S390_DIAG318)) {
+	if (!kvm_has_cap(KVM_CAP_S390_DIAG318)) {
 		if (!printed_skip) {
 			fprintf(stdout, "KVM_CAP_S390_DIAG318 not supported. "
 				"Skipping diag318 test.\n");
diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86_64/debug_regs.c
index c16799b616e0..bba811edef96 100644
--- a/tools/testing/selftests/kvm/x86_64/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86_64/debug_regs.c
@@ -95,7 +95,7 @@ int main(void)
 		1,		/* cli */
 	};
 
-	if (!kvm_check_cap(KVM_CAP_SET_GUEST_DEBUG)) {
+	if (!kvm_has_cap(KVM_CAP_SET_GUEST_DEBUG)) {
 		print_skip("KVM_CAP_SET_GUEST_DEBUG not supported");
 		return 0;
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index fb2a2390b4af..119bcb1158d5 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -162,7 +162,7 @@ int main(int argc, char *argv[])
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	if (!kvm_check_cap(KVM_CAP_SMALLER_MAXPHYADDR)) {
+	if (!kvm_has_cap(KVM_CAP_SMALLER_MAXPHYADDR)) {
 		printf("module parameter 'allow_smaller_maxphyaddr' is not set.  Skipping test.\n");
 		return 0;
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 6c4e728d2d85..a6da1ccbee4e 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -209,8 +209,8 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	if (!nested_vmx_supported() ||
-	    !kvm_check_cap(KVM_CAP_NESTED_STATE) ||
-	    !kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
+	    !kvm_has_cap(KVM_CAP_NESTED_STATE) ||
+	    !kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
 		print_skip("Enlightened VMCS is unsupported");
 		exit(KSFT_SKIP);
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 6df5a6356181..e2fac752d354 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -137,7 +137,7 @@ int main(int argc, char *argv[])
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	if (!kvm_check_cap(KVM_CAP_HYPERV_CPUID)) {
+	if (!kvm_has_cap(KVM_CAP_HYPERV_CPUID)) {
 		print_skip("KVM_CAP_HYPERV_CPUID not supported");
 		exit(KSFT_SKIP);
 	}
@@ -152,7 +152,7 @@ int main(int argc, char *argv[])
 	free(hv_cpuid_entries);
 
 	if (!nested_vmx_supported() ||
-	    !kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
+	    !kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
 		print_skip("Enlightened VMCS is unsupported");
 		goto do_sys;
 	}
@@ -163,7 +163,7 @@ int main(int argc, char *argv[])
 
 do_sys:
 	/* Test system ioctl version */
-	if (!kvm_check_cap(KVM_CAP_SYS_HYPERV_CPUID)) {
+	if (!kvm_has_cap(KVM_CAP_SYS_HYPERV_CPUID)) {
 		print_skip("KVM_CAP_SYS_HYPERV_CPUID not supported");
 		goto out;
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index f497d6ecec25..24dad3a47206 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -204,7 +204,7 @@ int main(void)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	if (!kvm_check_cap(KVM_CAP_ENFORCE_PV_FEATURE_CPUID)) {
+	if (!kvm_has_cap(KVM_CAP_ENFORCE_PV_FEATURE_CPUID)) {
 		print_skip("KVM_CAP_ENFORCE_PV_FEATURE_CPUID not supported");
 		exit(KSFT_SKIP);
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index 8bcaf4421dc5..abf740f08d68 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -123,7 +123,7 @@ static void check_set_bsp_busy(void)
 
 int main(int argc, char *argv[])
 {
-	if (!kvm_check_cap(KVM_CAP_SET_BOOT_CPU_ID)) {
+	if (!kvm_has_cap(KVM_CAP_SET_BOOT_CPU_ID)) {
 		print_skip("set_boot_cpu_id not available");
 		return 0;
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index ec418b823273..ffd8613987ae 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -400,8 +400,8 @@ int main(int argc, char *argv[])
 {
 	struct kvm_cpuid_entry2 *cpuid;
 
-	if (!kvm_check_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM) &&
-	    !kvm_check_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM)) {
+	if (!kvm_has_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM) &&
+	    !kvm_has_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM)) {
 		print_skip("Capabilities not available");
 		exit(KSFT_SKIP);
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
index 01d491f849c2..078bd7a0bbb1 100644
--- a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
+++ b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
@@ -51,7 +51,7 @@ int main(void)
 		exit(KSFT_SKIP);
 	}
 
-	if (!kvm_check_cap(KVM_CAP_X86_TRIPLE_FAULT_EVENT)) {
+	if (!kvm_has_cap(KVM_CAP_X86_TRIPLE_FAULT_EVENT)) {
 		print_skip("KVM_CAP_X86_TRIPLE_FAULT_EVENT not supported");
 		exit(KSFT_SKIP);
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
index 4a962952212e..fcc713ff75ff 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
@@ -93,7 +93,7 @@ static void *run_vcpu(void *_cpu_nr)
 
 int main(int argc, char *argv[])
 {
-        if (!kvm_check_cap(KVM_CAP_VM_TSC_CONTROL)) {
+	if (!kvm_has_cap(KVM_CAP_VM_TSC_CONTROL)) {
 		print_skip("KVM_CAP_VM_TSC_CONTROL not available");
 		exit(KSFT_SKIP);
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
index 647a4320d3bc..190af8124677 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
@@ -118,7 +118,7 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 
 static void tsc_scaling_check_supported(void)
 {
-	if (!kvm_check_cap(KVM_CAP_TSC_CONTROL)) {
+	if (!kvm_has_cap(KVM_CAP_TSC_CONTROL)) {
 		print_skip("TSC scaling not supported by the HW");
 		exit(KSFT_SKIP);
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
index b775a11ec08b..7438258511da 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
@@ -169,7 +169,7 @@ int main(int argc, char *argv[])
 	 */
 	nested_vmx_check_supported();
 
-	if (!kvm_check_cap(KVM_CAP_NESTED_STATE)) {
+	if (!kvm_has_cap(KVM_CAP_NESTED_STATE)) {
 		print_skip("KVM_CAP_NESTED_STATE not supported");
 		exit(KSFT_SKIP);
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index ba783ceb007f..21f280a7c5e1 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -267,7 +267,7 @@ int main(int argc, char *argv[])
 
 	have_evmcs = kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS);
 
-	if (!kvm_check_cap(KVM_CAP_NESTED_STATE)) {
+	if (!kvm_has_cap(KVM_CAP_NESTED_STATE)) {
 		print_skip("KVM_CAP_NESTED_STATE not available");
 		exit(KSFT_SKIP);
 	}
-- 
2.36.1.255.ge46751e96f-goog

