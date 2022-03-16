Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D7C4DA724
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 01:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352881AbiCPA5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 20:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352877AbiCPA5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 20:57:01 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7DB5DE5E
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 17:55:48 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id e23-20020a6b6917000000b006406b9433d6so383327ioc.14
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 17:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bycAaiF5EsaFu8w+wQH4Es5PJ71+HV/1nI3V1km7Z5k=;
        b=ewp22yR8J5SMj+k7ktU5S/hjjjcgAy13fWHJczV26Jd9dGvMwDq8zRvkfbMfxMLRiO
         uSpu464o1th3V3paeGXGU5lsTgVv/xEx9SCy2sDhwu2DFkVjigh3IElxyiqcqMzLkgms
         4gFt/ufWFtt6HtAbxVv3IPukhgfOuXijer5geVk/PAtwZsC3Zw5nFPU7q5bLp11ezHzD
         fRKJuy0SONbI+ZeUTna7ajiMK/mXeK3WSqBXRIF7EotEU/knp9LfuOAL5DzqdLIwcquS
         QC/MPPAtf+uQC05BFkoHwaTOfRlzW9e/XUam+qrABPENDngC1uYWsrNtHBhRBFimdAVA
         0p+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bycAaiF5EsaFu8w+wQH4Es5PJ71+HV/1nI3V1km7Z5k=;
        b=AZH9zmJ9PtM6PpCqgqSt5BxZ56KYo5noUZAYJtSM6aK+xDVlPgTVYBpsdHAzy3N1J6
         caSHrZqkomXFczIGvSK9dRy7JruINtCIxAvrkvhVXu0I+igGbBXkh9gcS33njhNdoDFj
         NXIoHv+4hiD8ZNlvgwCk7f+tVKcrV4Q838BEJi2N8M7o+ZbxBmstZ37IFFVGINo8VMsI
         bTfV+f1jMHlyII922K9sBxwZNdkhpzJTLGrNt4+rMuqnQf6OnV+b/0ZSvAjHnU+5Cisz
         Z4+qyyy4OCyWo4w0f+cwcCUJVAjrrK3zbAKgnHoG9lgPOMjBSMiCWUAElLKBPiPve0GF
         oa/g==
X-Gm-Message-State: AOAM533H1CvwATYjXMBqyfh0G02OqRUAYYRL6aPTq5GjM1Y1rQpg37Ni
        iMC09/lmpYXbv+RDopMOffh/IhJS+osEKBJeUponJlSOrdRLlwjCJaB1a7dUJd6XN1yk+w1+yai
        nRmSdQs7OJ5tqqgLezOnw+C0ShCGRv/A6DVag3NZneaMwQJfyGOo3Er0zjg==
X-Google-Smtp-Source: ABdhPJyWSua1+C6+8kB1YkbF9ExvEOo07TsD+k9MrdKAQj+XCKR5sbsDMDGO5J9jPElSD4tC5WPBmDifSkE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1ca5:b0:2c6:68c8:e44e with SMTP id
 x5-20020a056e021ca500b002c668c8e44emr22684824ill.79.1647392147789; Tue, 15
 Mar 2022 17:55:47 -0700 (PDT)
Date:   Wed, 16 Mar 2022 00:55:38 +0000
In-Reply-To: <20220316005538.2282772-1-oupton@google.com>
Message-Id: <20220316005538.2282772-3-oupton@google.com>
Mime-Version: 1.0
References: <20220316005538.2282772-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 2/2] selftests: KVM: Test KVM_X86_QUIRK_FIX_HYPERCALL_INSN
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
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

Add a test that asserts KVM rewrites guest hypercall instructions to
match the running architecture (VMCALL on VMX, VMMCALL on SVM).
Additionally, test that with the quirk disabled, KVM no longer rewrites
guest instructions and instead injects a #UD.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/fix_hypercall_test.c | 170 ++++++++++++++++++
 3 files changed, 172 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 9b67343dc4ab..1f1b6c978bf7 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -15,6 +15,7 @@
 /x86_64/debug_regs
 /x86_64/evmcs_test
 /x86_64/emulator_error_test
+/x86_64/fix_hypercall_test
 /x86_64/get_msr_index_features
 /x86_64/kvm_clock_test
 /x86_64/kvm_pv_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 6d69e196f1b7..c9cdbd248727 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -48,6 +48,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/emulator_error_test
+TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
new file mode 100644
index 000000000000..1f5c32146f3d
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020, Google LLC.
+ *
+ * Tests for KVM paravirtual feature disablement
+ */
+#include <asm/kvm_para.h>
+#include <linux/kvm_para.h>
+#include <linux/stringify.h>
+#include <stdint.h>
+
+#include "apic.h"
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#define VCPU_ID 0
+
+static bool ud_expected;
+
+static void guest_ud_handler(struct ex_regs *regs)
+{
+	GUEST_ASSERT(ud_expected);
+	GUEST_DONE();
+}
+
+extern unsigned char svm_hypercall_insn;
+static uint64_t svm_do_sched_yield(uint8_t apic_id)
+{
+	uint64_t ret;
+
+	asm volatile("mov %1, %%rax\n\t"
+		     "mov %2, %%rbx\n\t"
+		     "svm_hypercall_insn:\n\t"
+		     "vmmcall\n\t"
+		     "mov %%rax, %0\n\t"
+		     : "=r"(ret)
+		     : "r"((uint64_t)KVM_HC_SCHED_YIELD), "r"((uint64_t)apic_id)
+		     : "rax", "rbx", "memory");
+
+	return ret;
+}
+
+extern unsigned char vmx_hypercall_insn;
+static uint64_t vmx_do_sched_yield(uint8_t apic_id)
+{
+	uint64_t ret;
+
+	asm volatile("mov %1, %%rax\n\t"
+		     "mov %2, %%rbx\n\t"
+		     "vmx_hypercall_insn:\n\t"
+		     "vmcall\n\t"
+		     "mov %%rax, %0\n\t"
+		     : "=r"(ret)
+		     : "r"((uint64_t)KVM_HC_SCHED_YIELD), "r"((uint64_t)apic_id)
+		     : "rax", "rbx", "memory");
+
+	return ret;
+}
+
+static void assert_hypercall_insn(unsigned char *exp_insn, unsigned char *obs_insn)
+{
+	uint32_t exp = 0, obs = 0;
+
+	memcpy(&exp, exp_insn, sizeof(exp));
+	memcpy(&obs, obs_insn, sizeof(obs));
+
+	GUEST_ASSERT_EQ(exp, obs);
+}
+
+static void guest_main(void)
+{
+	unsigned char *native_hypercall_insn, *hypercall_insn;
+	uint8_t apic_id;
+
+	apic_id = GET_APIC_ID_FIELD(xapic_read_reg(APIC_ID));
+
+	if (is_intel_cpu()) {
+		native_hypercall_insn = &vmx_hypercall_insn;
+		hypercall_insn = &svm_hypercall_insn;
+		svm_do_sched_yield(apic_id);
+	} else if (is_amd_cpu()) {
+		native_hypercall_insn = &svm_hypercall_insn;
+		hypercall_insn = &vmx_hypercall_insn;
+		vmx_do_sched_yield(apic_id);
+	} else {
+		GUEST_ASSERT(0);
+		/* unreachable */
+		return;
+	}
+
+	GUEST_ASSERT(!ud_expected);
+	assert_hypercall_insn(native_hypercall_insn, hypercall_insn);
+	GUEST_DONE();
+}
+
+static void setup_ud_vector(struct kvm_vm *vm)
+{
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
+}
+
+static void enter_guest(struct kvm_vm *vm)
+{
+	struct kvm_run *run;
+	struct ucall uc;
+
+	run = vcpu_state(vm, VCPU_ID);
+
+	vcpu_run(vm, VCPU_ID);
+	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	case UCALL_SYNC:
+		pr_info("%s: %016lx\n", (const char *)uc.args[2], uc.args[3]);
+		break;
+	case UCALL_DONE:
+		return;
+	case UCALL_ABORT:
+		TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0], __FILE__, uc.args[1]);
+	default:
+		TEST_FAIL("Unhandled ucall: %ld\nexit_reason: %u (%s)",
+			  uc.cmd, run->exit_reason, exit_reason_str(run->exit_reason));
+	}
+}
+
+static void test_fix_hypercall(void)
+{
+	struct kvm_vm *vm;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_main);
+	setup_ud_vector(vm);
+
+	ud_expected = false;
+	sync_global_to_guest(vm, ud_expected);
+
+	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+
+	enter_guest(vm);
+}
+
+static void test_fix_hypercall_disabled(void)
+{
+	struct kvm_enable_cap cap = {0};
+	struct kvm_vm *vm;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_main);
+	setup_ud_vector(vm);
+
+	cap.cap = KVM_CAP_DISABLE_QUIRKS2;
+	cap.args[0] = KVM_X86_QUIRK_FIX_HYPERCALL_INSN;
+	vm_enable_cap(vm, &cap);
+
+	ud_expected = true;
+	sync_global_to_guest(vm, ud_expected);
+
+	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+
+	enter_guest(vm);
+}
+
+int main(void)
+{
+	if (!(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) & KVM_X86_QUIRK_FIX_HYPERCALL_INSN)) {
+		print_skip("KVM_X86_QUIRK_HYPERCALL_INSN not supported");
+		exit(KSFT_SKIP);
+	}
+
+	test_fix_hypercall();
+	test_fix_hypercall_disabled();
+}
-- 
2.35.1.723.g4982287a31-goog

