Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AB5375279
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 12:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbhEFKh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 06:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbhEFKhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 06:37:25 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B977AC061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 03:36:24 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4FbVP32gXlzQk2Y;
        Thu,  6 May 2021 12:36:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        references:in-reply-to:message-id:date:date:subject:subject:from
        :from:received; s=mail20150812; t=1620297379; bh=45gtSm1dgAXbP3Y
        jiG36F6NzSBlsaeeLThwda2iPBnk=; b=XyDU13X5ualTZ0zHJ5XECPHbC02YlCn
        gP1lIuBoUQS/GDcCs5CE4gtLGLyw2iYh+O1GLCSEb0+IzQdenb1lrIJefQg26SXh
        VRbjC3bB5HzFy3xfiqSQKC7/eLV/AsYoNuFjoN/51a0ipwyIjSbj8BUTNx2BKg5W
        zfzFLN+rWQzjatVtHCWCjMaKWiLVj04W6HJqpxZ9e8Jjwu945RZorgULDKYbpVOG
        sWM4H3yve0pq3h1gywgsjoxZjCHYqfCKg2Ns8nJKyVUzO2NtbEE8NJ5YOAOaYDp4
        pd3Bz76N7hD91PVMl26B7/2mc2c2snAEgpebiVHavInU3MNVruX80xA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1620297380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=MI7PoD1ynMTevjU0T40MNIWy/GF2BkKWZFlCZ+7AR28=;
        b=bK8iB1DFLjvCk8J4bcvsK15neSv9eZoscwZYIOtBYPnca3D5hwflb99IbOBplXhtf0thW/
        quhSSazc1FCToFVV4OFC159Q8epQEGABRKqJAk0hgPN7e7NAO6X7mECk1m0DV3GJtPqHDD
        14kiJP4C9b9Ks9gX9Z+kS1UOTzIjuZ+EyvmCkg0rk2ImqzVBaowMxBaZixd1S2kFXdCZdo
        /AqcL5gF5JJwVXdbM66qO1egq208dGa/XxSP48/W8CBM3MQxyBGcAmmUYGXygq11etG6bD
        MzIe2M+3gN4x1exabY/EZo0pI5h/9ysnVwu27of4MJquiMs7T9k33JNM0SWDcA==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id 9FegUJGspW5b; Thu,  6 May 2021 12:36:19 +0200 (CEST)
From:   ilstam@mailbox.org
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Subject: [PATCH 8/8] KVM: selftests: x86: Add vmx_nested_tsc_scaling_test
Date:   Thu,  6 May 2021 10:32:28 +0000
Message-Id: <20210506103228.67864-9-ilstam@mailbox.org>
In-Reply-To: <20210506103228.67864-1-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.55 / 15.00 / 15.00
X-Rspamd-Queue-Id: A5B6B1893
X-Rspamd-UID: 8ec50b
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilias Stamatis <ilstam@amazon.com>

Test that nested TSC scaling works as expected with both L1 and L2
scaled.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  | 209 ++++++++++++++++++
 3 files changed, 211 insertions(+)
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
index 000000000000..b05f5151ecbe
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
@@ -0,0 +1,209 @@
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
+
+#include "kvm_util.h"
+#include "vmx.h"
+#include "kselftest.h"
+
+
+#define VCPU_ID 0
+
+/* L1 is scaled down by this factor */
+#define L1_SCALE_FACTOR 2ULL
+/* L2 is scaled up (from L1's perspective) by this factor */
+#define L2_SCALE_FACTOR 4ULL
+
+#define TSC_OFFSET_L2 (1UL << 32)
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
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	vm_vaddr_t vmx_pages_gva;
+
+	uint64_t tsc_start, tsc_end;
+	uint64_t tsc_khz;
+	uint64_t l0_tsc_freq = 0;
+	uint64_t l1_tsc_freq = 0;
+	uint64_t l2_tsc_freq = 0;
+
+	nested_vmx_check_supported();
+	tsc_scaling_check_supported();
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
+		  (void *) (tsc_khz / L1_SCALE_FACTOR));
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
+						 l0_tsc_freq / L1_SCALE_FACTOR);
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

