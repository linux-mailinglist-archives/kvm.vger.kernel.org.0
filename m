Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EFB3A0669
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbhFHVvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:51:04 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:50960 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbhFHVvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 17:51:03 -0400
Received: by mail-qk1-f202.google.com with SMTP id n3-20020a378b030000b02903a624ca95adso15925944qkd.17
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=p0iXV74EOKOaRQh7Ns0atnVcsDIwc2nUiv6QHU1ihI8=;
        b=IsOx3E0B1JEQxQJinZeEfDucbClCYwUTsO/vTYI2y5XpQnzMpN6YRzuuHdgKIYRXXM
         XOF4MGwTGoUXk8eucXgEmq9FGfuYsXmJrfog4fE5WXSKk9MKPgfEux5jIQmZ3HP1PEc9
         pivjPO8RaqyBwXKY/q1wf200QbNBJ9H5/05RnmbBzTtQYBRwP7C5Q+Ik+XuhpCFNTIO6
         InSW4Le6iK2rTy+FwpGweaGXAf7EpWA8WuNL9RMTu4uIDnJGKcHiw/aCoaZeAKZEV/A7
         L5j43e64FDVmYM1cF+zlnL0furxW2Mnf+0GA0WZtP7E8X18qBt1bwdeuNk+DbLeQXrU5
         eKZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=p0iXV74EOKOaRQh7Ns0atnVcsDIwc2nUiv6QHU1ihI8=;
        b=VA6KDyEhb1HeQp41R4EjjkTIqZOrxBTfu9ZhKJEosNPfEZktJxg9TS3bPFgqVCzPQP
         Q9qYWzNDHijbWjchg5HMJCl+qvtWuphO27Z85nGW/foodyWqXGFr979s3KNyDh4Kys1j
         Pcx7nat6rPZKOuii6KNcotIo/cZeLmlY+bJdwAaf1s4sFDCHtjYYIyM1dI79kws40hME
         bJ0Wn5AePT2LFFJQoh6uzvTahaqS+aLXaAx180Ru0W5Rqt8Sd16t6Fn3k7u5ExN6+Nk+
         euXmj7kzgaiIVOecJlyK+KS5TJ3wRgR0XLRM0TzbDfPbpBsOVcJlZ3HVXngxBei6yxrg
         AMmg==
X-Gm-Message-State: AOAM530aUbSMDRiTznFkwiPJd3+SVuPVO+Be/vOcmP4cOJCFI6db3OH/
        nfnQWTwQS4BMv3i2XivoyoXazKqdBMs9fOVr2v9coE1C9ZQJwgIyHIrB3zYvWLDoExxBEuxEQTx
        g6zuZzY3k4xHAASbh9KwQzUKlzbZJ9AfGDrSjfnRPUuksiBFgPpbLNgrIqg==
X-Google-Smtp-Source: ABdhPJyDITlUaxD6OVnwR4PjuvS3tM8g/BFPOp78Wn37AtDQoat5Mk9tWPfrM3ukQg1KRwHPERtgtoaZTiY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0c:b911:: with SMTP id u17mr2201627qvf.14.1623188889690;
 Tue, 08 Jun 2021 14:48:09 -0700 (PDT)
Date:   Tue,  8 Jun 2021 21:47:35 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-4-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 03/10] selftests: KVM: Introduce system_counter_state_test
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that the KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls correctly
configure the guest's view of the virtual counter-timer (CNTVCT_EL0).

Reviewed-by: Jing Zhang <jingzhangos@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/aarch64/processor.h |  24 +++
 .../selftests/kvm/system_counter_state_test.c | 199 ++++++++++++++++++
 4 files changed, 225 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/system_counter_state_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index bd83158e0e0b..1a5782d8a0d4 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -34,6 +34,7 @@
 /x86_64/xen_vmcall_test
 /x86_64/xss_msr_test
 /x86_64/vmx_pmu_msrs_test
+/system_counter_state_test
 /demand_paging_test
 /dirty_log_test
 /dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index e439d027939d..b14f16dc954a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -80,6 +80,7 @@ TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
+TEST_GEN_PROGS_aarch64 += system_counter_state_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index b7fa0c8551db..48c964ce62ff 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -52,6 +52,30 @@ static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id, uint
 	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &reg);
 }
 
+static inline uint64_t read_cntpct_ordered(void)
+{
+	uint64_t r;
+
+	asm volatile("isb\n\t"
+		     "mrs %0, cntpct_el0\n\t"
+		     "isb\n\t"
+		     : "=r"(r));
+
+	return r;
+}
+
+static inline uint64_t read_cntvct_ordered(void)
+{
+	uint64_t r;
+
+	asm volatile("isb\n\t"
+		     "mrs %0, cntvct_el0\n\t"
+		     "isb\n\t"
+		     : "=r"(r));
+
+	return r;
+}
+
 void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *init);
 void aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
 			      struct kvm_vcpu_init *init, void *guest_code);
diff --git a/tools/testing/selftests/kvm/system_counter_state_test.c b/tools/testing/selftests/kvm/system_counter_state_test.c
new file mode 100644
index 000000000000..059971f6cb87
--- /dev/null
+++ b/tools/testing/selftests/kvm/system_counter_state_test.c
@@ -0,0 +1,199 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * system_counter_state_test.c -- suite of tests for correctness of
+ * KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls.
+ *
+ * Copyright (c) 2021, Google LLC.
+ */
+#define _GNU_SOURCE
+#include <asm/kvm.h>
+#include <linux/kvm.h>
+#include <stdint.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
+#define VCPU_ID 0
+
+#ifdef __aarch64__
+
+enum counter {
+	VIRTUAL,
+	PHYSICAL,
+};
+
+static char *counter_name(enum counter counter)
+{
+	switch (counter) {
+	case VIRTUAL:
+		return "virtual";
+	case PHYSICAL:
+		return "physical";
+	default:
+		TEST_ASSERT(false, "unrecognized counter: %d", counter);
+	}
+
+	/* never reached */
+	return NULL;
+}
+
+struct system_counter_state_test {
+	enum counter counter;
+	struct kvm_system_counter_state state;
+};
+
+static struct system_counter_state_test test_cases[] = {
+	{
+		.counter = VIRTUAL,
+		.state = {
+			.cntvoff = 0
+		}
+	},
+	{
+		.counter = VIRTUAL,
+		.state = {
+			.cntvoff = 1000000
+		}
+	},
+	{
+		.counter = VIRTUAL,
+		.state = {
+			.cntvoff = -1
+		}
+	},
+};
+
+static void pr_test(struct system_counter_state_test *test)
+{
+	pr_info("counter: %s, cntvoff: %lld\n", counter_name(test->counter), test->state.cntvoff);
+}
+
+static struct kvm_system_counter_state *
+get_system_counter_state(struct system_counter_state_test *test)
+{
+	return &test->state;
+}
+
+/*
+ * Reads the guest counter-timer under test.
+ */
+static uint64_t guest_read_counter(struct system_counter_state_test *test)
+{
+	switch (test->counter) {
+	case PHYSICAL:
+		return read_cntpct_ordered();
+	case VIRTUAL:
+		return read_cntvct_ordered();
+	default:
+		GUEST_ASSERT(0);
+	}
+
+	/* never reached */
+	return -1;
+}
+
+/*
+ * Reads the host physical counter-timer and transforms it into a guest value
+ * according to the kvm_system_counter_state structure.
+ */
+static uint64_t host_read_guest_counter(struct system_counter_state_test *test)
+{
+	uint64_t r;
+
+	r = read_cntvct_ordered();
+	switch (test->counter) {
+	case VIRTUAL:
+		r -= test->state.cntvoff;
+		break;
+	default:
+		TEST_ASSERT(false, "unrecognized counter: %d", test->counter);
+	}
+
+	return r;
+}
+
+#else
+#error test not implemented for architecture being built!
+#endif
+
+static void guest_main(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		struct system_counter_state_test *test = &test_cases[i];
+
+		GUEST_SYNC(guest_read_counter(test));
+	}
+
+	GUEST_DONE();
+}
+
+static bool enter_guest(struct kvm_vm *vm, uint64_t *guest_counter)
+{
+	struct ucall uc;
+
+	vcpu_ioctl(vm, VCPU_ID, KVM_RUN, NULL);
+
+	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	case UCALL_DONE:
+		return true;
+	case UCALL_SYNC:
+		if (guest_counter)
+			*guest_counter = uc.args[1];
+		break;
+	case UCALL_ABORT:
+		TEST_ASSERT(false, "%s at %s:%ld", (const char *)uc.args[0],
+			    __FILE__, uc.args[1]);
+		break;
+	default:
+		TEST_ASSERT(false, "unexpected exit: %s",
+			    exit_reason_str(vcpu_state(vm, VCPU_ID)->exit_reason));
+		break;
+	}
+
+	/* more work to do in the guest */
+	return false;
+}
+
+static void run_tests(struct kvm_vm *vm)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		struct system_counter_state_test *test = &test_cases[i];
+		uint64_t start, end, obs;
+
+		pr_info("test %d: ", i);
+		pr_test(test);
+
+		vcpu_ioctl(vm, VCPU_ID, KVM_SET_SYSTEM_COUNTER_STATE,
+			   get_system_counter_state(test));
+
+		start = host_read_guest_counter(test);
+		TEST_ASSERT(!enter_guest(vm, &obs), "guest completed unexpectedly");
+		end = host_read_guest_counter(test);
+
+		TEST_ASSERT(start < obs && obs < end,
+			    "guest counter value (%ld) outside expected bounds: (%ld, %ld)",
+			    obs, start, end);
+	}
+
+	TEST_ASSERT(enter_guest(vm, NULL), "guest didn't run to completion");
+}
+
+int main(void)
+{
+	struct kvm_vm *vm;
+
+	if (!kvm_check_cap(KVM_CAP_SYSTEM_COUNTER_STATE)) {
+		print_skip("KVM_CAP_SYSTEM_COUNTER_STATE not supported");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default(0, 0, guest_main);
+	ucall_init(vm, NULL);
+	run_tests(vm);
+	kvm_vm_free(vm);
+}
-- 
2.32.0.rc1.229.g3e70b5a671-goog

