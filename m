Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01CA29CD5B
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 02:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgJ1BiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 21:38:19 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:54066 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832974AbgJ0XLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 19:11:17 -0400
Received: by mail-pg1-f201.google.com with SMTP id r4so1542881pgl.20
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 16:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=KOAF+QiKhSZYVZbSN8EPg1nH9XHSy1gCtbOyRwkqkHQ=;
        b=lyELrqZhmVNIJM5QJ1ZDxswpI4Ksd3gS4kw/Rg3MOzZWCgcKYTGf6mz0tO5AL8kbSJ
         2Rq7FUg9HpN0od1pd9otIgOICqOY7kpTTDLOWG+hurB1pCWcDDzW8Dc7p6H1+dRQJg2s
         sMpRVROeA2prT4KAmfg+GOMPfY+AKO1XHI1lrbauUrCUhSExbq2hfHNomIFHR8qcsH8R
         opfAIpk0VZ80aP4HL9W+wZBW/q/GEI/9xsDpHPI6Th+ZssKNROCGez6G7eMKudcJyb+I
         L0O1cMDyhK/+m1VjYN8StFtx+2KiWxlYRB3m9qJG1kyfLiqxgnr0wA9XuzfiZ4+WlXMb
         J6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KOAF+QiKhSZYVZbSN8EPg1nH9XHSy1gCtbOyRwkqkHQ=;
        b=Xg9vG3Ugk7MJaojFH9M07Z6YLW2IXStDHVyHLXx3XvBts85nP5DP9kj0MJQfdYJzbj
         xmUL7trhUdGWmFPW9rT67dWXzyZmG3FF+qBDjIGU+nwpZQZIH6XmBg+JOAnMErGGFJ16
         AJ58xxlHQEyGGfVvtTxMv+Er9iT4nUVdiAzwe9P/2F1NZmmy4MpV8//4F8VI58cdNI83
         Nr3592ppGhddJYbdUxBoyAzv2iVq0IFGHWKk3G8QxOG7YyuyytW4UKCmyJLNmhPYdojj
         wtr83v/MXuFSjlN2Jg1HSEQHSDd4d1ExZYWLwQrbCO+zgfQMnJcaQre6pCILBggsQYPs
         Ru3Q==
X-Gm-Message-State: AOAM5339N07/zPLqUkSS7vqK1XjSnbZBJuNQlfwMNYBTinH+KRCvMp3F
        Bx0bDCBiOwo88hAYqMhIsqkwGSbZjWgvELeXSmL+nJQAyHiRaqb6qMpmFMlCPwPMvaCW/vTPWo2
        /yG1wQlKibhmUFMQfDg/qPX+O9g0T7M1WxT0ee0VQ6DXU4QwXNoVwKmRR+A==
X-Google-Smtp-Source: ABdhPJwWDSsbGtn+Cec5IUGVwd7M7WxnUC2bXnyCX3npmFkgdTPsLNO4OaHE+JPLWmKwVonStAkTvoG0AtA=
Sender: "oupton via sendgmr" <oupton@oupton.sea.corp.google.com>
X-Received: from oupton.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef5:7be1])
 (user=oupton job=sendgmr) by 2002:a65:6493:: with SMTP id e19mr3726750pgv.276.1603840275388;
 Tue, 27 Oct 2020 16:11:15 -0700 (PDT)
Date:   Tue, 27 Oct 2020 16:10:44 -0700
In-Reply-To: <20201027231044.655110-1-oupton@google.com>
Message-Id: <20201027231044.655110-7-oupton@google.com>
Mime-Version: 1.0
References: <20201027231044.655110-1-oupton@google.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 6/6] selftests: kvm: test enforcement of paravirtual cpuid features
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a set of tests that ensure the guest cannot access paravirtual msrs
and hypercalls that have been disabled in the KVM_CPUID_FEATURES leaf.
Expect a #GP in the case of msr accesses and -KVM_ENOSYS from
hypercalls.

Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/include/x86_64/processor.h  |  12 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  28 +++
 .../selftests/kvm/lib/x86_64/processor.c      |  29 +++
 .../selftests/kvm/x86_64/kvm_pv_test.c        | 234 ++++++++++++++++++
 7 files changed, 307 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 0f19f5999b88..a10f58a94ff4 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -5,6 +5,7 @@
 /x86_64/cr4_cpuid_sync_test
 /x86_64/debug_regs
 /x86_64/evmcs_test
+/x86_64/kvm_pv_test
 /x86_64/hyperv_cpuid
 /x86_64/mmio_warning_test
 /x86_64/platform_info_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 7ebe71fbca53..23f51e1c21be 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -41,6 +41,7 @@ LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
+TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 919e161dd289..a288afefde56 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -63,6 +63,8 @@ enum vm_mem_backing_src_type {
 
 int kvm_check_cap(long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
+int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
+		    struct kvm_enable_cap *cap);
 
 struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
 struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 82b7fe16a824..936380e1c590 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -338,6 +338,18 @@ uint32_t kvm_get_cpuid_max_basic(void);
 uint32_t kvm_get_cpuid_max_extended(void);
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
 
+/*
+ * set_cpuid() - overwrites a matching cpuid entry with the provided value.
+ *		 matches based on ent->function && ent->index. returns true
+ *		 if a match was found and successfully overwritten.
+ * @cpuid: the kvm cpuid list to modify.
+ * @ent: cpuid entry to insert
+ */
+bool set_cpuid(struct kvm_cpuid2 *cpuid, struct kvm_cpuid_entry2 *ent);
+
+uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
+		       uint64_t a3);
+
 /*
  * Basic CPU control in CR0
  */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 74776ee228f2..706b19445acc 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -85,6 +85,34 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
 	return ret;
 }
 
+/* VCPU Enable Capability
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vcpu_id - VCPU
+ *   cap - Capability
+ *
+ * Output Args: None
+ *
+ * Return: On success, 0. On failure a TEST_ASSERT failure is produced.
+ *
+ * Enables a capability (KVM_CAP_*) on the VCPU.
+ */
+int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
+		    struct kvm_enable_cap *cap)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpu_id);
+	int r;
+
+	TEST_ASSERT(vcpu, "cannot find vcpu %d", vcpu_id);
+
+	r = ioctl(vcpu->fd, KVM_ENABLE_CAP, cap);
+	TEST_ASSERT(!r, "KVM_ENABLE_CAP vCPU ioctl failed,\n"
+			"  rc: %i, errno: %i", r, errno);
+
+	return r;
+}
+
 static void vm_open(struct kvm_vm *vm, int perm)
 {
 	vm->kvm_fd = open(KVM_DEV_PATH, perm);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index f6eb34eaa0d2..a20bdc6b1228 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1118,3 +1118,32 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 		*va_bits = (entry->eax >> 8) & 0xff;
 	}
 }
+
+bool set_cpuid(struct kvm_cpuid2 *cpuid,
+	       struct kvm_cpuid_entry2 *ent)
+{
+	int i;
+
+	for (i = 0; i < cpuid->nent; i++) {
+		struct kvm_cpuid_entry2 *cur = &cpuid->entries[i];
+
+		if (cur->function != ent->function || cur->index != ent->index)
+			continue;
+
+		memcpy(cur, ent, sizeof(struct kvm_cpuid_entry2));
+		return true;
+	}
+
+	return false;
+}
+
+uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
+		       uint64_t a3)
+{
+	uint64_t r;
+
+	asm volatile("vmcall"
+		     : "=a"(r)
+		     : "b"(a0), "c"(a1), "d"(a2), "S"(a3));
+	return r;
+}
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
new file mode 100644
index 000000000000..b10a27485bad
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -0,0 +1,234 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020, Google LLC.
+ *
+ * Tests for KVM paravirtual feature disablement
+ */
+#include <asm/kvm_para.h>
+#include <linux/kvm_para.h>
+#include <stdint.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+extern unsigned char rdmsr_start;
+extern unsigned char rdmsr_end;
+
+static u64 do_rdmsr(u32 idx)
+{
+	u32 lo, hi;
+
+	asm volatile("rdmsr_start: rdmsr;"
+		     "rdmsr_end:"
+		     : "=a"(lo), "=c"(hi)
+		     : "c"(idx));
+
+	return (((u64) hi) << 32) | lo;
+}
+
+extern unsigned char wrmsr_start;
+extern unsigned char wrmsr_end;
+
+static void do_wrmsr(u32 idx, u64 val)
+{
+	u32 lo, hi;
+
+	lo = val;
+	hi = val >> 32;
+
+	asm volatile("wrmsr_start: wrmsr;"
+		     "wrmsr_end:"
+		     : : "a"(lo), "c"(idx), "d"(hi));
+}
+
+static int nr_gp;
+
+static void guest_gp_handler(struct ex_regs *regs)
+{
+	unsigned char *rip = (unsigned char *)regs->rip;
+	bool r, w;
+
+	r = rip == &rdmsr_start;
+	w = rip == &wrmsr_start;
+	GUEST_ASSERT(r || w);
+
+	nr_gp++;
+
+	if (r)
+		regs->rip = (uint64_t)&rdmsr_end;
+	else
+		regs->rip = (uint64_t)&wrmsr_end;
+}
+
+struct msr_data {
+	uint32_t idx;
+	const char *name;
+};
+
+#define TEST_MSR(msr) { .idx = msr, .name = #msr }
+#define UCALL_PR_MSR 0xdeadbeef
+#define PR_MSR(msr) ucall(UCALL_PR_MSR, 1, msr)
+
+/*
+ * KVM paravirtual msrs to test. Expect a #GP if any of these msrs are read or
+ * written, as the KVM_CPUID_FEATURES leaf is cleared.
+ */
+static struct msr_data msrs_to_test[] = {
+	TEST_MSR(MSR_KVM_SYSTEM_TIME),
+	TEST_MSR(MSR_KVM_SYSTEM_TIME_NEW),
+	TEST_MSR(MSR_KVM_WALL_CLOCK),
+	TEST_MSR(MSR_KVM_WALL_CLOCK_NEW),
+	TEST_MSR(MSR_KVM_ASYNC_PF_EN),
+	TEST_MSR(MSR_KVM_STEAL_TIME),
+	TEST_MSR(MSR_KVM_PV_EOI_EN),
+	TEST_MSR(MSR_KVM_POLL_CONTROL),
+	TEST_MSR(MSR_KVM_ASYNC_PF_INT),
+	TEST_MSR(MSR_KVM_ASYNC_PF_ACK),
+};
+
+static void test_msr(struct msr_data *msr)
+{
+	PR_MSR(msr);
+	do_rdmsr(msr->idx);
+	GUEST_ASSERT(READ_ONCE(nr_gp) == 1);
+
+	nr_gp = 0;
+	do_wrmsr(msr->idx, 0);
+	GUEST_ASSERT(READ_ONCE(nr_gp) == 1);
+	nr_gp = 0;
+}
+
+struct hcall_data {
+	uint64_t nr;
+	const char *name;
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
+	TEST_HCALL(KVM_HC_KICK_CPU),
+	TEST_HCALL(KVM_HC_SEND_IPI),
+	TEST_HCALL(KVM_HC_SCHED_YIELD),
+};
+
+static void test_hcall(struct hcall_data *hc)
+{
+	uint64_t r;
+
+	PR_HCALL(hc);
+	r = kvm_hypercall(hc->nr, 0, 0, 0, 0);
+	GUEST_ASSERT(r == -KVM_ENOSYS);
+}
+
+static void guest_main(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(msrs_to_test); i++) {
+		test_msr(&msrs_to_test[i]);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(hcalls_to_test); i++) {
+		test_hcall(&hcalls_to_test[i]);
+	}
+
+	GUEST_DONE();
+}
+
+static void clear_kvm_cpuid_features(struct kvm_cpuid2 *cpuid)
+{
+	struct kvm_cpuid_entry2 ent = {0};
+
+	ent.function = KVM_CPUID_FEATURES;
+	TEST_ASSERT(set_cpuid(cpuid, &ent),
+		    "failed to clear KVM_CPUID_FEATURES leaf");
+}
+
+static void pr_msr(struct ucall *uc)
+{
+	struct msr_data *msr = (struct msr_data *)uc->args[0];
+
+	pr_info("testing msr: %s (%#x)\n", msr->name, msr->idx);
+}
+
+static void pr_hcall(struct ucall *uc)
+{
+	struct hcall_data *hc = (struct hcall_data *)uc->args[0];
+
+	pr_info("testing hcall: %s (%lu)\n", hc->name, hc->nr);
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
+	int r;
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
+		case UCALL_PR_MSR:
+			pr_msr(&uc);
+			break;
+		case UCALL_PR_HCALL:
+			pr_hcall(&uc);
+			break;
+		case UCALL_ABORT:
+			handle_abort(&uc);
+			return;
+		case UCALL_DONE:
+			return;
+		}
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
+	clear_kvm_cpuid_features(best);
+	vcpu_set_cpuid(vm, VCPU_ID, best);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
+
+	enter_guest(vm);
+	kvm_vm_free(vm);
+}
-- 
2.29.0.rc2.309.g374f81d7ae-goog

