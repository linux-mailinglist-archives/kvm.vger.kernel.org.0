Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ED27275B3
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 05:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbjFHDZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 23:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbjFHDYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 23:24:53 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590032696
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 20:24:52 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id 006d021491bc7-559b0ddcd4aso105351eaf.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 20:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686194691; x=1688786691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3v5N2Gk/tK5Dqm+6ABW1i0aRZErobVuh2y73QQLA8DA=;
        b=IZ+1xuk2Et+yIaWvje2+vuvg7PBWGy5k/xKqQk5mltdMS4ldReJ7L/8OQDFov3M6gq
         i/bOCkKzV+LVT0oG4u9Fa7oqxh4P+fio8c9cF1+blPoWf92m58X4+uj32vMBb7gpaGQs
         vl2OubVnUtr4KOW+X+S82mWkjcnxFNnF30kvduQp5w2UlMt3NB9Rrws7/cxjcZETdVbx
         c005UuAwaTUDl41AOeu1wWnwUqO81jHwnhb+z6fKGpSY8KyAA9KjqfBmu8LuOe9P35k5
         R1APwNwR6cZlTOtwYYze+aiz45G1STlj52oC86rc4hO43b5StCAowPkEoJP4VW4WcfaB
         UrXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686194691; x=1688786691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3v5N2Gk/tK5Dqm+6ABW1i0aRZErobVuh2y73QQLA8DA=;
        b=Jpi9OMWA7CWEx7jXgmZvGlcysdXXT+S2QZiEphNoo9JjrDh1DBdJV+JRQ+4QYq4hic
         uYwh6xJqZKIAAOJ0Z516Qmre+Og1tALZ4ykrCMFqwUan5SMqfJWJt/S4Vy2aXEBbcPX+
         CQ/DIRT+gN/4v7mFItTXIBZWWBhET68UQgs5ml/8JLOEO6UmGKUEZILdQWNuh7XEeesL
         LQNO6Ierxy0K9nbqXrSDCEy8reyU35GL+hVHNAkZR61MRvli7n8sgYtx7tHbTmfUGCti
         846wBK8TW7nHS+nAifQz10/ExyEhKYIWxQEKG113y+V9ktL5iUHwqbRLuNCc53HnwcHm
         AMDg==
X-Gm-Message-State: AC+VfDwwXFH9ihauIMy7ex+ZleA6R3K6O5vthjJvaRoYzSunm3zQMQoz
        SUoJ2d7HCjF9kNc9Cu7thuYRJ7BhltI=
X-Google-Smtp-Source: ACHHUZ5o+e8ue7wuHb9eVXQby1L7Zndb4Fuw4DizRxGk+rlHYuzENWN0b42aAhY3rjEHq8COTJYSUw==
X-Received: by 2002:a05:6808:11a:b0:398:132b:7462 with SMTP id b26-20020a056808011a00b00398132b7462mr6606689oie.54.1686194691127;
        Wed, 07 Jun 2023 20:24:51 -0700 (PDT)
Received: from wheely.local0.net (58-6-224-112.tpgi.com.au. [58.6.224.112])
        by smtp.gmail.com with ESMTPSA id s12-20020a17090a5d0c00b0025930e50e28sm2015629pji.41.2023.06.07.20.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 20:24:50 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v3 4/6] KVM: PPC: selftests: add selftests sanity tests
Date:   Thu,  8 Jun 2023 13:24:23 +1000
Message-Id: <20230608032425.59796-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608032425.59796-1-npiggin@gmail.com>
References: <20230608032425.59796-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests that exercise very basic functions of the kvm selftests
framework, guest creation, ucalls, hcalls, copying data between guest
and host, interrupts and page faults.

These don't stress KVM so much as being useful when developing support
for powerpc.

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/include/powerpc/hcall.h     |   2 +
 .../testing/selftests/kvm/powerpc/null_test.c | 166 ++++++++++++++++++
 .../selftests/kvm/powerpc/rtas_hcall.c        | 136 ++++++++++++++
 4 files changed, 306 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/powerpc/null_test.c
 create mode 100644 tools/testing/selftests/kvm/powerpc/rtas_hcall.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 53cd3ce63dec..efb8700b9752 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -184,6 +184,8 @@ TEST_GEN_PROGS_riscv += kvm_page_table_test
 TEST_GEN_PROGS_riscv += set_memory_region_test
 TEST_GEN_PROGS_riscv += kvm_binary_stats_test
 
+TEST_GEN_PROGS_powerpc += powerpc/null_test
+TEST_GEN_PROGS_powerpc += powerpc/rtas_hcall
 TEST_GEN_PROGS_powerpc += access_tracking_perf_test
 TEST_GEN_PROGS_powerpc += demand_paging_test
 TEST_GEN_PROGS_powerpc += dirty_log_test
diff --git a/tools/testing/selftests/kvm/include/powerpc/hcall.h b/tools/testing/selftests/kvm/include/powerpc/hcall.h
index ba119f5a3fef..04c7d2d13020 100644
--- a/tools/testing/selftests/kvm/include/powerpc/hcall.h
+++ b/tools/testing/selftests/kvm/include/powerpc/hcall.h
@@ -12,6 +12,8 @@
 #define UCALL_R4_UCALL	0x5715 // regular ucall, r5 contains ucall pointer
 #define UCALL_R4_SIMPLE	0x0000 // simple exit usable by asm with no ucall data
 
+#define H_RTAS		0xf000
+
 int64_t hcall0(uint64_t token);
 int64_t hcall1(uint64_t token, uint64_t arg1);
 int64_t hcall2(uint64_t token, uint64_t arg1, uint64_t arg2);
diff --git a/tools/testing/selftests/kvm/powerpc/null_test.c b/tools/testing/selftests/kvm/powerpc/null_test.c
new file mode 100644
index 000000000000..31db0b6becd6
--- /dev/null
+++ b/tools/testing/selftests/kvm/powerpc/null_test.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Tests for guest creation, run, ucall, interrupt, and vm dumping.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "kselftest.h"
+#include "processor.h"
+#include "helpers.h"
+
+extern void guest_code_asm(void);
+asm(".global guest_code_asm");
+asm(".balign 4");
+asm("guest_code_asm:");
+asm("li 3,0"); // H_UCALL
+asm("li 4,0"); // UCALL_R4_SIMPLE
+asm("sc 1");
+
+static void test_asm(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_asm);
+
+	vcpu_run(vcpu);
+	handle_ucall(vcpu, UCALL_NONE);
+
+	kvm_vm_free(vm);
+}
+
+static void guest_code_ucall(void)
+{
+	GUEST_DONE();
+}
+
+static void test_ucall(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_ucall);
+
+	vcpu_run(vcpu);
+	handle_ucall(vcpu, UCALL_DONE);
+
+	kvm_vm_free(vm);
+}
+
+static void trap_handler(struct ex_regs *regs)
+{
+	GUEST_SYNC(1);
+	regs->nia += 4;
+}
+
+static void guest_code_trap(void)
+{
+	GUEST_SYNC(0);
+	asm volatile("trap");
+	GUEST_DONE();
+}
+
+static void test_trap(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_trap);
+	vm_install_exception_handler(vm, 0x700, trap_handler);
+
+	vcpu_run(vcpu);
+	host_sync(vcpu, 0);
+	vcpu_run(vcpu);
+	host_sync(vcpu, 1);
+	vcpu_run(vcpu);
+	handle_ucall(vcpu, UCALL_DONE);
+
+	vm_install_exception_handler(vm, 0x700, NULL);
+
+	kvm_vm_free(vm);
+}
+
+static void dsi_handler(struct ex_regs *regs)
+{
+	GUEST_SYNC(1);
+	regs->nia += 4;
+}
+
+static void guest_code_dsi(void)
+{
+	GUEST_SYNC(0);
+	asm volatile("stb %r0,0(0)");
+	GUEST_DONE();
+}
+
+static void test_dsi(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_dsi);
+	vm_install_exception_handler(vm, 0x300, dsi_handler);
+
+	vcpu_run(vcpu);
+	host_sync(vcpu, 0);
+	vcpu_run(vcpu);
+	host_sync(vcpu, 1);
+	vcpu_run(vcpu);
+	handle_ucall(vcpu, UCALL_DONE);
+
+	vm_install_exception_handler(vm, 0x300, NULL);
+
+	kvm_vm_free(vm);
+}
+
+static void test_dump(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_ucall);
+
+	vcpu_run(vcpu);
+	handle_ucall(vcpu, UCALL_DONE);
+
+	printf("Testing vm_dump...\n");
+	vm_dump(stderr, vm, 2);
+
+	kvm_vm_free(vm);
+}
+
+
+struct testdef {
+	const char *name;
+	void (*test)(void);
+} testlist[] = {
+	{ "null asm test", test_asm},
+	{ "null ucall test", test_ucall},
+	{ "trap test", test_trap},
+	{ "page fault test", test_dsi},
+	{ "vm dump test", test_dump},
+};
+
+int main(int argc, char *argv[])
+{
+	int idx;
+
+	ksft_print_header();
+
+	ksft_set_plan(ARRAY_SIZE(testlist));
+
+	for (idx = 0; idx < ARRAY_SIZE(testlist); idx++) {
+		testlist[idx].test();
+		ksft_test_result_pass("%s\n", testlist[idx].name);
+	}
+
+	ksft_finished();	/* Print results and exit() accordingly */
+}
diff --git a/tools/testing/selftests/kvm/powerpc/rtas_hcall.c b/tools/testing/selftests/kvm/powerpc/rtas_hcall.c
new file mode 100644
index 000000000000..05af22c711cb
--- /dev/null
+++ b/tools/testing/selftests/kvm/powerpc/rtas_hcall.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test the KVM H_RTAS hcall and copying buffers between guest and host.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "kselftest.h"
+#include "hcall.h"
+
+struct rtas_args {
+	__be32 token;
+	__be32 nargs;
+	__be32 nret;
+	__be32 args[16];
+        __be32 *rets;     /* Pointer to return values in args[]. */
+};
+
+static void guest_code(void)
+{
+	struct rtas_args r;
+	int64_t rc;
+
+	r.token = cpu_to_be32(0xdeadbeef);
+	r.nargs = cpu_to_be32(3);
+	r.nret = cpu_to_be32(2);
+	r.rets = &r.args[3];
+	r.args[0] = cpu_to_be32(0x1000);
+	r.args[1] = cpu_to_be32(0x1001);
+	r.args[2] = cpu_to_be32(0x1002);
+	rc = hcall1(H_RTAS, (uint64_t)&r);
+	GUEST_ASSERT(rc == 0);
+	GUEST_ASSERT_1(be32_to_cpu(r.rets[0]) == 0xabc, be32_to_cpu(r.rets[0]));
+	GUEST_ASSERT_1(be32_to_cpu(r.rets[1]) == 0x123, be32_to_cpu(r.rets[1]));
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_regs regs;
+	struct rtas_args *r;
+	vm_vaddr_t rtas_vaddr;
+	struct ucall uc;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint64_t tmp;
+	int ret;
+
+	ksft_print_header();
+
+	ksft_set_plan(1);
+
+	/* Create VM */
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	ret = _vcpu_run(vcpu);
+	TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
+	switch ((tmp = get_ucall(vcpu, &uc))) {
+	case UCALL_NONE:
+		break; // good
+	case UCALL_DONE:
+		TEST_FAIL("Unexpected final guest exit %lu\n", tmp);
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT_N(uc, "values: %lu (0x%lx)\n",
+				      GUEST_ASSERT_ARG(uc, 0),
+				      GUEST_ASSERT_ARG(uc, 0));
+		break;
+	default:
+		TEST_FAIL("Unexpected guest exit %lu\n", tmp);
+	}
+
+	TEST_ASSERT(vcpu->run->exit_reason == KVM_EXIT_PAPR_HCALL,
+		    "Expected PAPR_HCALL exit, got %s\n",
+		    exit_reason_str(vcpu->run->exit_reason));
+	TEST_ASSERT(vcpu->run->papr_hcall.nr == H_RTAS,
+		    "Expected H_RTAS exit, got %lld\n",
+		    vcpu->run->papr_hcall.nr);
+
+	vcpu_regs_get(vcpu, &regs);
+	rtas_vaddr = regs.gpr[4];
+
+	r = addr_gva2hva(vm, rtas_vaddr);
+
+	TEST_ASSERT(r->token == cpu_to_be32(0xdeadbeef),
+		    "Expected RTAS token 0xdeadbeef, got 0x%x\n",
+		    be32_to_cpu(r->token));
+	TEST_ASSERT(r->nargs == cpu_to_be32(3),
+		    "Expected RTAS nargs 3, got %u\n",
+		    be32_to_cpu(r->nargs));
+	TEST_ASSERT(r->nret == cpu_to_be32(2),
+		    "Expected RTAS nret 2, got %u\n",
+		    be32_to_cpu(r->nret));
+	TEST_ASSERT(r->args[0] == cpu_to_be32(0x1000),
+		    "Expected args[0] to be 0x1000, got 0x%x\n",
+		    be32_to_cpu(r->args[0]));
+	TEST_ASSERT(r->args[1] == cpu_to_be32(0x1001),
+		    "Expected args[1] to be 0x1001, got 0x%x\n",
+		    be32_to_cpu(r->args[1]));
+	TEST_ASSERT(r->args[2] == cpu_to_be32(0x1002),
+		    "Expected args[2] to be 0x1002, got 0x%x\n",
+		    be32_to_cpu(r->args[2]));
+
+	r->args[3] = cpu_to_be32(0xabc);
+	r->args[4] = cpu_to_be32(0x123);
+
+	regs.gpr[3] = 0;
+	vcpu_regs_set(vcpu, &regs);
+
+	ret = _vcpu_run(vcpu);
+	TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
+	switch ((tmp = get_ucall(vcpu, &uc))) {
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT_N(uc, "values: %lu (0x%lx)\n",
+				      GUEST_ASSERT_ARG(uc, 0),
+				      GUEST_ASSERT_ARG(uc, 0));
+		break;
+	default:
+		TEST_FAIL("Unexpected guest exit %lu\n", tmp);
+	}
+
+	kvm_vm_free(vm);
+
+	ksft_test_result_pass("%s\n", "rtas buffer copy test");
+	ksft_finished();	/* Print results and exit() accordingly */
+}
-- 
2.40.1

