Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A10757EA26
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 01:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiGVXDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 19:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237040AbiGVXDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 19:03:03 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A358A896E
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:03:00 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id p10-20020a170902e74a00b0016c3f3acb51so3282066plf.16
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ohjmvic4E29z52GxL81iJJ/NoT9cQn3Y4MQIK9DNO8c=;
        b=NUPStMJh9IgIejquXH41dWpPzb0keBnwKYv/YW8pfw5tOHeupTpouxU7AoPrEITB+l
         vNcaNvL+2+sjkec80bqYbPcI9dy4syJ0u7saxw8sIFI6mmNy68pkpcr/P3WesShFzO6/
         3QCbtoKA8mfc2zzeMa7JVT75czfnmJejoWd2iIGQiYUGJWQfXX6ahwwZoyd3PpJQ2hS8
         N/BGy3AwdK+1zeIIPoghK96lusqX0lMGsYPJoOybcjl2A+VUVjVr4JRgoAhKz1DElQHO
         GJoToXM2Q9s9MWEmr3E5U/MdvlCXqTBRWfscu+Dqkuwf+lreJM5wnjvyb/Jc4jYcoHzv
         NLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ohjmvic4E29z52GxL81iJJ/NoT9cQn3Y4MQIK9DNO8c=;
        b=q2S9w42OQ8iBUi5Gt1pEpfINt3NyptISatwKqQKq7rsnRVuq8KjQDlsGGaWWTAaIX/
         jFzOgAkLVo/8jmGDWu7NMK35xNiju7OJyKxrVljyQbwuwv0Zq18fyxxymkbjXtvrIFlR
         phBIMO9eLmqLRzVZh2wk6ebFRWOsv0Udlw2q23DuMvc6r9+lL3uTX3YYpJ9T7Q9eQHDh
         6sXgz1WrxVD+u5BC1GF8p+71ACF72BvEg+n2YubQGxCTL6UjNayrT0En2mL4/Ix2rrzd
         T2Agbwu5MPs0fvz7jCKX4xJP4b0gZDE2X4ReFL3xtgoBJHPBUua4OuTczI0LBUMTOjuu
         0tnw==
X-Gm-Message-State: AJIora+7y4vkwrbr2h6KLOwUpFnVDgm0/80OLrV88y7VBdL2f50RVavh
        WSKU7MaMVIS5aw9IT9mbYT8xsEJCQdg=
X-Google-Smtp-Source: AGRyM1vzNfKx1ntihwPeEq0EYbJkTHi1QJ88thF08Vd6neFyCEJbIjBBCh8im7RSQIkoT/hFtNaXPTG+FJo=
X-Received: from avagin.kir.corp.google.com ([2620:15c:29:204:5863:d08b:b2f8:4a3e])
 (user=avagin job=sendgmr) by 2002:a05:6a00:17aa:b0:52a:e94b:67e5 with SMTP id
 s42-20020a056a0017aa00b0052ae94b67e5mr2199067pfg.76.1658530980244; Fri, 22
 Jul 2022 16:03:00 -0700 (PDT)
Date:   Fri, 22 Jul 2022 16:02:41 -0700
In-Reply-To: <20220722230241.1944655-1-avagin@google.com>
Message-Id: <20220722230241.1944655-6-avagin@google.com>
Mime-Version: 1.0
References: <20220722230241.1944655-1-avagin@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 5/5] selftests/kvm/x86_64: add tests for KVM_HC_HOST_SYSCALL
From:   Andrei Vagin <avagin@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrei Vagin <avagin@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* check that syscall are executed.
* check that non-existing syscalls return ENOSYS.

Signed-off-by: Andrei Vagin <avagin@google.com>
---
 0000-kvm-host-syscall.patch                   |   7 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   4 +
 .../kvm/x86_64/kvm_pv_syscall_test.c          | 145 ++++++++++++++++++
 5 files changed, 158 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_pv_syscall_test.c

diff --git a/0000-kvm-host-syscall.patch b/0000-kvm-host-syscall.patch
index 364db7471abc..653430d57c62 100644
--- a/0000-kvm-host-syscall.patch
+++ b/0000-kvm-host-syscall.patch
@@ -57,6 +57,13 @@ In the Google kernel, we have a kvm-like subsystem designed especially
 for gVisor. This change is the first step of integrating it into the KVM
 code base and making it available to all Linux users.
 
+Cc: Paolo Bonzini <pbonzini@redhat.com>
+Cc: Sean Christopherson <seanjc@google.com>
+Cc: Wanpeng Li <wanpengli@tencent.com>
+Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
+Cc: Jianfeng Tan <henry.tjf@antfin.com>
+Cc: Adin Scannell <ascannell@google.com>
+
 Andrei Vagin (5):
   kernel: add a new helper to execute system calls from kernel code
   kvm: add controls to enable/disable paravirtualized system calls
diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 4509a3a7eeae..57d39fec6fdd 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -21,6 +21,7 @@
 /x86_64/get_msr_index_features
 /x86_64/kvm_clock_test
 /x86_64/kvm_pv_test
+/x86_64/kvm_pv_syscall_test
 /x86_64/hyperv_clock
 /x86_64/hyperv_cpuid
 /x86_64/hyperv_features
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 22423c871ed6..e6459f3e5318 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -82,6 +82,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
+TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_syscall_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 6ce185449259..4503e9556279 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -17,6 +17,7 @@
 
 #include "../kvm_util.h"
 
+#ifndef X86_EFLAGS_FIXED
 #define X86_EFLAGS_FIXED	 (1u << 1)
 
 #define X86_CR4_VME		(1ul << 0)
@@ -40,6 +41,7 @@
 #define X86_CR4_SMEP		(1ul << 20)
 #define X86_CR4_SMAP		(1ul << 21)
 #define X86_CR4_PKE		(1ul << 22)
+#endif
 
 /* CPUID.1.ECX */
 #define CPUID_VMX		(1ul << 5)
@@ -503,6 +505,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 /*
  * Basic CPU control in CR0
  */
+#ifndef X86_CR0_PE
 #define X86_CR0_PE          (1UL<<0) /* Protection Enable */
 #define X86_CR0_MP          (1UL<<1) /* Monitor Coprocessor */
 #define X86_CR0_EM          (1UL<<2) /* Emulation */
@@ -514,6 +517,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 #define X86_CR0_NW          (1UL<<29) /* Not Write-through */
 #define X86_CR0_CD          (1UL<<30) /* Cache Disable */
 #define X86_CR0_PG          (1UL<<31) /* Paging */
+#endif
 
 #define XSTATE_XTILE_CFG_BIT		17
 #define XSTATE_XTILE_DATA_BIT		18
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_syscall_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_syscall_test.c
new file mode 100644
index 000000000000..601f84b11711
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_syscall_test.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020, Google LLC.
+ *
+ * Tests for KVM paravirtual feature disablement
+ */
+#include <asm/kvm_para.h>
+#include <asm/ptrace.h>
+#include <linux/kvm_para.h>
+#include <stdint.h>
+
+#include <linux/unistd.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+struct pt_regs regs_dup = {
+	.rax = __NR_dup,
+	.rdi = -1,
+};
+
+struct pt_regs regs_nosys = {
+	.rax = -1,
+};
+
+struct hcall_data {
+	const char *name;
+	struct pt_regs *regs;
+	long ret;
+};
+
+#define TEST_HCALL(hc) { .nr = hc, .name = #hc }
+#define UCALL_PR_HCALL 0xdeadc0de
+#define PR_HCALL(hc) ucall(UCALL_PR_HCALL, 1, hc)
+
+/*
+ * KVM hypercalls to test. Expect -KVM_ENOSYS when called, as the corresponding
+ * features have been cleared in KVM_CPUID_FEATURES.
+ */
+static struct hcall_data hcalls_to_test[] = {
+	{.name = "dup",    .regs = &regs_dup,   .ret = -EBADF},
+	{.name = "enosys", .regs = &regs_nosys, .ret = -ENOSYS},
+};
+
+static void test_hcall(struct hcall_data *hc)
+{
+	uint64_t r;
+
+	PR_HCALL(hc);
+	r = kvm_hypercall(KVM_HC_HOST_SYSCALL, (unsigned long)hc->regs, 0, 0, 0);
+	GUEST_ASSERT(r == 0);
+}
+
+static void guest_main(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hcalls_to_test); i++)
+		test_hcall(&hcalls_to_test[i]);
+
+	GUEST_DONE();
+}
+
+static void pr_hcall(struct ucall *uc)
+{
+	struct hcall_data *hc = (struct hcall_data *)uc->args[0];
+
+	pr_info("testing hcall: %s\n", hc->name);
+}
+
+static void handle_abort(struct ucall *uc)
+{
+	TEST_FAIL("%s at %s:%ld", (const char *)uc->args[0],
+		  __FILE__, uc->args[1]);
+}
+
+#define VCPU_ID 0
+
+static void enter_guest(struct kvm_vm *vm)
+{
+	struct kvm_run *run;
+	struct ucall uc;
+	int r, i;
+
+	run = vcpu_state(vm, VCPU_ID);
+
+	while (true) {
+		r = _vcpu_run(vm, VCPU_ID);
+		TEST_ASSERT(!r, "vcpu_run failed: %d\n", r);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "unexpected exit reason: %u (%s)",
+			    run->exit_reason, exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_PR_HCALL:
+			pr_hcall(&uc);
+			break;
+		case UCALL_ABORT:
+			handle_abort(&uc);
+			return;
+		case UCALL_DONE:
+			goto out;
+		}
+	}
+
+out:
+	for (i = 0; i < ARRAY_SIZE(hcalls_to_test); i++) {
+		struct hcall_data *hc = &hcalls_to_test[i];
+
+		TEST_ASSERT(hc->ret == hc->regs->rax, "%s: ret %ld (expected %ld)",
+				hc->name, hc->ret, hc->regs->rax);
+	}
+}
+
+int main(void)
+{
+	struct kvm_enable_cap cap = {0};
+	struct kvm_cpuid2 *best;
+	struct kvm_vm *vm;
+
+	if (!kvm_check_cap(KVM_CAP_ENFORCE_PV_FEATURE_CPUID)) {
+		pr_info("will skip kvm paravirt restriction tests.\n");
+		return 0;
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, guest_main);
+
+	cap.cap = KVM_CAP_ENFORCE_PV_FEATURE_CPUID;
+	cap.args[0] = 1;
+	vcpu_enable_cap(vm, VCPU_ID, &cap);
+
+	best = kvm_get_supported_cpuid();
+	vcpu_set_cpuid(vm, VCPU_ID, best);
+
+	cap.cap = KVM_CAP_PV_HOST_SYSCALL;
+	cap.args[0] = 1;
+	vcpu_enable_cap(vm, VCPU_ID, &cap);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	enter_guest(vm);
+	kvm_vm_free(vm);
+}
-- 
2.37.1.359.gd136c6c3e2-goog

