Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 613441095B8
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 23:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfKYWpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 17:45:54 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:44279 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfKYWpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 17:45:53 -0500
Received: by mail-pf1-f201.google.com with SMTP id 2so10644490pfx.11
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2019 14:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=swz/sjYKb6g3M40/hztc/tyAihR4u+28ellm/nQF/QM=;
        b=vhMiTCmQBcovEk45MSKnaR63E74jfHw/feAR7qBaPHmmJ0P4nu0KJClcbZ7wD0BQVa
         oBsdSgyld41ekvGr+x3M5HyMBCI2Cl9JZs+ZO7zNfGgFZffxZMCjdG3ehuWoY28GeQHD
         KH+2hFPVGPSdA2r5xfVHYaz8yGvMeGwB0gdrk4k7Y/bQYR20qcZ6UqvnVDFKMjJ9w8SJ
         IJ/QxDIVMMTQ7ThrRLA6yTrFSqEoSAvL45kaHlB0JlhPlOiewyM3m1mC5ymBPDHacddi
         V37HDrsCxGIqets9+f9Z2DCav3qDIVv8DJXduglAYMWbkW6vKb6WsXuYJX/kXOIBVp34
         SJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=swz/sjYKb6g3M40/hztc/tyAihR4u+28ellm/nQF/QM=;
        b=VHlHfMvRzvs00t+MyXoy0ckf05jRejv93SVFQv4HdlEJSFYa8ZkjLRduf3yWOwJwPs
         0GP8Yh1Rnjszm6Sja9G+zZrfR6TynGgXOEhDNPrhI//EieD+zzvjlWRX4McoHMG59fNs
         XwiHBuR+zjjpurQggfkzQwLsYxOciehFl29VlmvuaREacV3IK/PiLLhIogYs57yBWGL3
         7xtU4XDH4XTCaqWPeiMzanzSqZUnDrAZxJnXIHEkDRHMxMkca4YYRjKHzPSSvVgl/Ggb
         diQmpvPuAAjSdR2mypivuNIDVQ9+CZEU2vV8xzN3cJ7hsvH28LSVc6rOqEqCjDSQjqsv
         WKgg==
X-Gm-Message-State: APjAAAWT0RrKzAQmM/2JhUymeFswiAL+K2C+pbPp58+qPIw7C/aQ158J
        qXJUVLH8XrseM7weeWuVJeBogKV22UcVEBV/
X-Google-Smtp-Source: APXvYqxM2JCnCwfekVNgzOEeFllNWJCuRATX0bZ5W1OhrqHWMmoi/HLhuhS7ZWsPK80pbfnPMQ0eGB5XuOFf2JX7
X-Received: by 2002:a63:750f:: with SMTP id q15mr35303993pgc.422.1574721951113;
 Mon, 25 Nov 2019 14:45:51 -0800 (PST)
Date:   Mon, 25 Nov 2019 14:44:29 -0800
Message-Id: <20191125224428.77547-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [kvm-unit-tests PATCH] x86: Add RDTSC test
From:   Aaron Lewis <aaronlewis@google.com>
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that the difference between an L2 RDTSC instruction and the
IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12's VM-exit
MSR-store list is less than 750 cycles, 99.9% of the time.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 x86/unittests.cfg |  6 ++++
 x86/vmx_tests.c   | 89 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index b4865ac..5291d96 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -284,6 +284,12 @@ extra_params = -cpu host,+vmx -append vmx_vmcs_shadow_test
 arch = x86_64
 groups = vmx
 
+[vmx_rdtsc_vmexit_diff_test]
+file = vmx.flat
+extra_params = -cpu host,+vmx -append rdtsc_vmexit_diff_test
+arch = x86_64
+groups = vmx
+
 [debug]
 file = debug.flat
 arch = x86_64
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 1d8932f..f42ae2c 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8790,7 +8790,94 @@ static void vmx_vmcs_shadow_test(void)
 	enter_guest();
 }
 
+/*
+ * This test monitors the difference between an L2 RDTSC instruction
+ * and the IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12
+ * VM-exit MSR-store list when taking a VM-exit on the instruction
+ * following RDTSC.
+ */
+#define RDTSC_DIFF_ITERS 100000
+#define RDTSC_DIFF_FAILS 100
+#define L1_RDTSC_LIMIT 750
+
+/*
+ * Set 'use TSC offsetting' and set the L2 offset to the
+ * inverse of L1's current TSC value, so that L2 starts running
+ * with an effective TSC value of 0.
+ */
+static void reset_l2_tsc_to_zero(void)
+{
+	TEST_ASSERT_MSG(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET,
+			"Expected support for 'use TSC offsetting'");
+
+	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_USE_TSC_OFFSET);
+	vmcs_write(TSC_OFFSET, -rdtsc());
+}
+
+static void rdtsc_vmexit_diff_test_guest(void)
+{
+	int i;
+
+	for (i = 0; i < RDTSC_DIFF_ITERS; i++)
+		asm volatile("rdtsc; vmcall" : : : "eax", "edx");
+}
+
+/*
+ * This function only considers the "use TSC offsetting" VM-execution
+ * control.  It does not handle "use TSC scaling" (because the latter
+ * isn't available to L1 today.)
+ */
+static unsigned long long l1_time_to_l2_time(unsigned long long t)
+{
+	if (vmcs_read(CPU_EXEC_CTRL0) & CPU_USE_TSC_OFFSET)
+		t += vmcs_read(TSC_OFFSET);
+
+	return t;
+}
+
+static unsigned long long get_tsc_diff(void)
+{
+	unsigned long long l2_tsc, l1_to_l2_tsc;
+
+	enter_guest();
+	skip_exit_vmcall();
+	l2_tsc = (u32) regs.rax + (regs.rdx << 32);
+	l1_to_l2_tsc = l1_time_to_l2_time(exit_msr_store[0].value);
+
+	return l1_to_l2_tsc - l2_tsc;
+}
+
+static void rdtsc_vmexit_diff_test(void)
+{
+	int fail = 0;
+	int i;
+
+	test_set_guest(rdtsc_vmexit_diff_test_guest);
+
+	reset_l2_tsc_to_zero();
 
+	/*
+	 * Set up the VMCS12 VM-exit MSR-store list to store just one
+	 * MSR: IA32_TIME_STAMP_COUNTER. Note that the value stored is
+	 * in the L1 time domain (i.e., it is not adjusted according
+	 * to the TSC multiplier and TSC offset fields in the VMCS12,
+	 * as an L2 RDTSC would be.)
+	 */
+	exit_msr_store = alloc_page();
+	exit_msr_store[0].index = MSR_IA32_TSC;
+	vmcs_write(EXI_MSR_ST_CNT, 1);
+	vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(exit_msr_store));
+
+	for (i = 0; i < RDTSC_DIFF_ITERS; i++) {
+		if (get_tsc_diff() < L1_RDTSC_LIMIT)
+			fail++;
+	}
+
+	enter_guest();
+
+	report("RDTSC to VM-exit delta too high in %d of %d iterations",
+	       fail < RDTSC_DIFF_FAILS, fail, RDTSC_DIFF_ITERS);
+}
 
 static int invalid_msr_init(struct vmcs *vmcs)
 {
@@ -9056,5 +9143,7 @@ struct vmx_test vmx_tests[] = {
 	/* Atomic MSR switch tests. */
 	TEST(atomic_switch_max_msrs_test),
 	TEST(atomic_switch_overflow_msrs_test),
+	/* Miscellaneous tests */
+	TEST(rdtsc_vmexit_diff_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.24.0.432.g9d3f5f5b63-goog

