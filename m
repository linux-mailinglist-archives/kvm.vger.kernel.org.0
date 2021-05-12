Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7531F37C330
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 17:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhELPRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 11:17:51 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:25570 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbhELPPI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 11:15:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620832441; x=1652368441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=uGO4mCIQH4xEGCcMeem8ddAwwkcjIQxlPW+s+OxhsrI=;
  b=HcElgUvq2Cgy4KyLhz8Dtqf6CIG4LcmI769gUfW+69bNvq/6URr7ouIX
   djZZbYHeuAIDT7vCYQsXxxf3bmDNVV/OaX/+ZjtcpVG1fQQ9InITSrhNu
   cwsV4aK5cCJIKWvTx0u778GzBy/1eZ9c5VpW6T0ic6uqITOiQPHaK4Qne
   c=;
X-IronPort-AV: E=Sophos;i="5.82,293,1613433600"; 
   d="scan'208";a="107340911"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 12 May 2021 15:13:51 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 6B0612402B9;
        Wed, 12 May 2021 15:13:47 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:13:35 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 May 2021 15:13:34 +0000
Received: from uae075a0dfd4c51.ant.amazon.com (10.106.82.24) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 12 May 2021 15:13:32 +0000
From:   Ilias Stamatis <ilstam@amazon.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <zamsden@gmail.com>, <mtosatti@redhat.com>, <dwmw@amazon.co.uk>,
        <ilstam@amazon.com>
Subject: [PATCH v2 10/10] KVM: selftests: x86: Add vmx_nested_tsc_scaling_test
Date:   Wed, 12 May 2021 16:09:45 +0100
Message-ID: <20210512150945.4591-11-ilstam@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512150945.4591-1-ilstam@amazon.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that nested TSC scaling works as expected with both L1 and L2
scaled.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  | 242 ++++++++++++++++++
 3 files changed, 244 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index bd83158e0e0b..cc02022f9951 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -29,6 +29,7 @@
 /x86_64/vmx_preemption_timer_test
 /x86_64/vmx_set_nested_state_test
 /x86_64/vmx_tsc_adjust_test
+/x86_64/vmx_nested_tsc_scaling_test
 /x86_64/xapic_ipi_test
 /x86_64/xen_shinfo_test
 /x86_64/xen_vmcall_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index e439d027939d..1078240b1313 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -60,6 +60,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
 TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
 TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
new file mode 100644
index 000000000000..f4a8f426281a
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
@@ -0,0 +1,242 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vmx_nested_tsc_scaling_test
+ *
+ * Copyright (C) 2021 Amazon.com, Inc. or its affiliates.
+ *
+ * This test case verifies that nested TSC scaling behaves as expected when
+ * both L1 and L2 are scaled using different ratios. For this test we scale
+ * L1 down and scale L2 up.
+ */
+
+#include <time.h>
+
+#include "kvm_util.h"
+#include "vmx.h"
+#include "kselftest.h"
+
+
+#define VCPU_ID 0
+
+/* L2 is scaled up (from L1's perspective) by this factor */
+#define L2_SCALE_FACTOR 4ULL
+
+#define TSC_OFFSET_L2 ((uint64_t) -33125236320908)
+#define TSC_MULTIPLIER_L2 (L2_SCALE_FACTOR << 48)
+
+#define L2_GUEST_STACK_SIZE 64
+
+enum { USLEEP, UCHECK_L1, UCHECK_L2 };
+#define GUEST_SLEEP(sec)         ucall(UCALL_SYNC, 2, USLEEP, sec)
+#define GUEST_CHECK(level, freq) ucall(UCALL_SYNC, 2, level, freq)
+
+
+/*
+ * This function checks whether the "actual" TSC frequency of a guest matches
+ * its expected frequency. In order to account for delays in taking the TSC
+ * measurements, a difference of 1% between the actual and the expected value
+ * is tolerated.
+ */
+static void compare_tsc_freq(uint64_t actual, uint64_t expected)
+{
+	uint64_t tolerance, thresh_low, thresh_high;
+
+	tolerance = expected / 100;
+	thresh_low = expected - tolerance;
+	thresh_high = expected + tolerance;
+
+	TEST_ASSERT(thresh_low < actual,
+		"TSC freq is expected to be between %"PRIu64" and %"PRIu64
+		" but it actually is %"PRIu64,
+		thresh_low, thresh_high, actual);
+	TEST_ASSERT(thresh_high > actual,
+		"TSC freq is expected to be between %"PRIu64" and %"PRIu64
+		" but it actually is %"PRIu64,
+		thresh_low, thresh_high, actual);
+}
+
+static void check_tsc_freq(int level)
+{
+	uint64_t tsc_start, tsc_end, tsc_freq;
+
+	/*
+	 * Reading the TSC twice with about a second's difference should give
+	 * us an approximation of the TSC frequency from the guest's
+	 * perspective. Now, this won't be completely accurate, but it should
+	 * be good enough for the purposes of this test.
+	 */
+	tsc_start = rdmsr(MSR_IA32_TSC);
+	GUEST_SLEEP(1);
+	tsc_end = rdmsr(MSR_IA32_TSC);
+
+	tsc_freq = tsc_end - tsc_start;
+
+	GUEST_CHECK(level, tsc_freq);
+}
+
+static void l2_guest_code(void)
+{
+	check_tsc_freq(UCHECK_L2);
+
+	/* exit to L1 */
+	__asm__ __volatile__("vmcall");
+}
+
+static void l1_guest_code(struct vmx_pages *vmx_pages)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	uint32_t control;
+
+	/* check that L1's frequency looks alright before launching L2 */
+	check_tsc_freq(UCHECK_L1);
+
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+
+	/* prepare the VMCS for L2 execution */
+	prepare_vmcs(vmx_pages, l2_guest_code, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	/* enable TSC offsetting and TSC scaling for L2 */
+	control = vmreadz(CPU_BASED_VM_EXEC_CONTROL);
+	control |= CPU_BASED_USE_MSR_BITMAPS | CPU_BASED_USE_TSC_OFFSETTING;
+	vmwrite(CPU_BASED_VM_EXEC_CONTROL, control);
+
+	control = vmreadz(SECONDARY_VM_EXEC_CONTROL);
+	control |= SECONDARY_EXEC_TSC_SCALING;
+	vmwrite(SECONDARY_VM_EXEC_CONTROL, control);
+
+	vmwrite(TSC_OFFSET, TSC_OFFSET_L2);
+	vmwrite(TSC_MULTIPLIER, TSC_MULTIPLIER_L2);
+	vmwrite(TSC_MULTIPLIER_HIGH, TSC_MULTIPLIER_L2 >> 32);
+
+	/* launch L2 */
+	GUEST_ASSERT(!vmlaunch());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+
+	/* check that L1's frequency still looks good */
+	check_tsc_freq(UCHECK_L1);
+
+	GUEST_DONE();
+}
+
+static void tsc_scaling_check_supported(void)
+{
+	if (!kvm_check_cap(KVM_CAP_TSC_CONTROL)) {
+		print_skip("TSC scaling not supported by the HW");
+		exit(KSFT_SKIP);
+	}
+}
+
+static void stable_tsc_check_supported(void)
+{
+	FILE *fp;
+	char buf[4];
+
+	fp = fopen("/sys/devices/system/clocksource/clocksource0/current_clocksource", "r");
+	if (fp == NULL)
+		goto skip_test;
+
+	if (fgets(buf, sizeof(buf), fp) == NULL)
+		goto skip_test;
+
+	if (strncmp(buf, "tsc", sizeof(buf)))
+		goto skip_test;
+
+	return;
+skip_test:
+	print_skip("TSC is not stable");
+	exit(KSFT_SKIP);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	vm_vaddr_t vmx_pages_gva;
+
+	uint64_t tsc_start, tsc_end;
+	uint64_t tsc_khz;
+	uint64_t l1_scale_factor;
+	uint64_t l0_tsc_freq = 0;
+	uint64_t l1_tsc_freq = 0;
+	uint64_t l2_tsc_freq = 0;
+
+	nested_vmx_check_supported();
+	tsc_scaling_check_supported();
+	stable_tsc_check_supported();
+
+	/*
+	 * We set L1's scale factor to be a random number from 2 to 10.
+	 * Ideally we would do the same for L2's factor but that one is
+	 * referenced by both main() and l1_guest_code() and using a global
+	 * variable does not work.
+	 */
+	srand(time(NULL));
+	l1_scale_factor = (rand() % 9) + 2;
+	printf("L1's scale factor is: %"PRIu64"\n", l1_scale_factor);
+	printf("L2's scale factor is: %llu\n", L2_SCALE_FACTOR);
+
+	tsc_start = rdtsc();
+	sleep(1);
+	tsc_end = rdtsc();
+
+	l0_tsc_freq = tsc_end - tsc_start;
+	printf("real TSC frequency is around: %"PRIu64"\n", l0_tsc_freq);
+
+	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+	vcpu_alloc_vmx(vm, &vmx_pages_gva);
+	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+
+	tsc_khz = _vcpu_ioctl(vm, VCPU_ID, KVM_GET_TSC_KHZ, NULL);
+	TEST_ASSERT(tsc_khz != -1, "vcpu ioctl KVM_GET_TSC_KHZ failed");
+
+	/* scale down L1's TSC frequency */
+	vcpu_ioctl(vm, VCPU_ID, KVM_SET_TSC_KHZ,
+		  (void *) (tsc_khz / l1_scale_factor));
+
+	for (;;) {
+		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+		struct ucall uc;
+
+		vcpu_run(vm, VCPU_ID);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
+			    run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_ABORT:
+			TEST_FAIL("%s", (const char *) uc.args[0]);
+		case UCALL_SYNC:
+			switch (uc.args[0]) {
+			case USLEEP:
+				sleep(uc.args[1]);
+				break;
+			case UCHECK_L1:
+				l1_tsc_freq = uc.args[1];
+				printf("L1's TSC frequency is around: %"PRIu64
+				       "\n", l1_tsc_freq);
+
+				compare_tsc_freq(l1_tsc_freq,
+						 l0_tsc_freq / l1_scale_factor);
+				break;
+			case UCHECK_L2:
+				l2_tsc_freq = uc.args[1];
+				printf("L2's TSC frequency is around: %"PRIu64
+				       "\n", l2_tsc_freq);
+
+				compare_tsc_freq(l2_tsc_freq,
+						 l1_tsc_freq * L2_SCALE_FACTOR);
+				break;
+			}
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.17.1

