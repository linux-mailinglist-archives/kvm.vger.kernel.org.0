Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58DCF10F1A8
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 21:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbfLBUpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 15:45:18 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:46198 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfLBUpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 15:45:17 -0500
Received: by mail-pg1-f201.google.com with SMTP id p21so383872pgh.13
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 12:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=QYhac3r55bAEwLqoDrUzbjmy450chfvsZZ2g9rcvJrc=;
        b=qMSQaNdVGB8yVApYDZlGuMkFVrepNOumH+MCFMV1tmWZ2GhNJxnx5olgGuUkdxXPlP
         EoGxDgd8d9L6nyDWDoHD/dfkmrzdIoY88kKhZJQpjijJjQwNxxQDAs7KxskNCYJH7yOF
         +ujb0Y3TBlCRnM7qqIEQwYrGx6o0CIOUHbw7CBl9BH5hvKYFDx4oK1CmZDDo6YHqHuop
         Ox304NyiydYFATEH8VUOFxh/4qQjVdUDHwZTfPNRmP0SDZNtdmb6tC0vyX5E0BN3rGlW
         0QhsbD08zze8EpuKd6xEycGZixH9n8P2NFyOpTJ0ESuyobIW/WF2YNW3l9Rmx6Bm2dVH
         hadQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=QYhac3r55bAEwLqoDrUzbjmy450chfvsZZ2g9rcvJrc=;
        b=IyJxDkcddWOXYgNU00A6O316YMUi8bPWVFjx1hRIK4qfKgwmtnKpR3qbUpMWebz5rd
         rLqQDAHo96ljhWs1+qX3dXhrmalgiGJ2dBPiUk3WuqAtDuAEfqfgquCKKnOXFKKUgSEF
         fen58Hn2ijyVE1OzcF1jyGjaiH4rRdZwGloN7tD4mUBK40DYpOCd7GE5+MMy6wIWvOsG
         1geEUrWnGKmijL0Nj1SnbuWJdsXgTDWZNdlA65jH28eSHO2s0QIsgT7LtfSV/2GjoJB7
         WOMQsvqVHLIqhjtW5meBVIDemEQA315yfliBQcNGxvqygNMCwaD615vZq5UJk289zhGG
         NZow==
X-Gm-Message-State: APjAAAULlKk3yP17YS8olZQIIZ4fLD50BQcWehZEBhfXvyPiBRwM9Awl
        JV2nOzQB4/xCZrOiky21cPmrQgB2Cmn3Ay6UYFLzbxEtdhA3z9zGH89mUnYMGVd8r8z4H/EKhCE
        iuyFvQ+S7RXi6IInDGfulrPFUPBdZmEW5AL/78shMGt1PRjQ34hfvOyBPi8TWHKC6NXcr
X-Google-Smtp-Source: APXvYqwW55eUIQmXY1HOXBdQ+5wSfD+IYy5lIFvfsLgfmdvLs/5xkHMzMy5melgrhbVDCM/aybzuprdL2aSvLyiH
X-Received: by 2002:a63:f006:: with SMTP id k6mr1090977pgh.380.1575319516240;
 Mon, 02 Dec 2019 12:45:16 -0800 (PST)
Date:   Mon,  2 Dec 2019 12:43:57 -0800
Message-Id: <20191202204356.250357-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that the difference between a guest RDTSC instruction and the
IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12's VM-exit
MSR-store list is less than 750 cycles, 99.9% of the time.

662f1d1d1931 ("KVM: nVMX: Add support for capturing highest observable L2 T=
SC=E2=80=9D)

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 x86/vmx.h       |  1 +
 x86/vmx_tests.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+)

diff --git a/x86/vmx.h b/x86/vmx.h
index 8496be7..21ba953 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -420,6 +420,7 @@ enum Ctrl1 {
 	CPU_SHADOW_VMCS		=3D 1ul << 14,
 	CPU_RDSEED		=3D 1ul << 16,
 	CPU_PML                 =3D 1ul << 17,
+	CPU_USE_TSC_SCALING	=3D 1ul << 25,
 };
=20
 enum Intr_type {
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 1d8932f..6ceaf9a 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8790,7 +8790,99 @@ static void vmx_vmcs_shadow_test(void)
 	enter_guest();
 }
=20
+/*
+ * This test monitors the difference between a guest RDTSC instruction
+ * and the IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12
+ * VM-exit MSR-store list when taking a VM-exit on the instruction
+ * following RDTSC.
+ */
+#define RDTSC_DIFF_ITERS 100000
+#define RDTSC_DIFF_FAILS 100
+#define HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD 750
+
+/*
+ * Set 'use TSC offsetting' and set the guest offset to the
+ * inverse of the host's current TSC value, so that the guest starts runni=
ng
+ * with an effective TSC value of 0.
+ */
+static void reset_guest_tsc_to_zero(void)
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
+	for (i =3D 0; i < RDTSC_DIFF_ITERS; i++)
+		/* Ensure rdtsc is the last instruction before the vmcall. */
+		asm volatile("rdtsc; vmcall" : : : "eax", "edx");
+}
=20
+/*
+ * This function only considers the "use TSC offsetting" VM-execution
+ * control.  It does not handle "use TSC scaling" (because the latter
+ * isn't available to the host today.)
+ */
+static unsigned long long host_time_to_guest_time(unsigned long long t)
+{
+	TEST_ASSERT(!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
+		    !(vmcs_read(CPU_EXEC_CTRL1) & CPU_USE_TSC_SCALING));
+
+	if (vmcs_read(CPU_EXEC_CTRL0) & CPU_USE_TSC_OFFSET)
+		t +=3D vmcs_read(TSC_OFFSET);
+
+	return t;
+}
+
+static unsigned long long rdtsc_vmexit_diff_test_iteration(void)
+{
+	unsigned long long guest_tsc, host_to_guest_tsc;
+
+	enter_guest();
+	skip_exit_vmcall();
+	guest_tsc =3D (u32) regs.rax + (regs.rdx << 32);
+	host_to_guest_tsc =3D host_time_to_guest_time(exit_msr_store[0].value);
+
+	return host_to_guest_tsc - guest_tsc;
+}
+
+static void rdtsc_vmexit_diff_test(void)
+{
+	int fail =3D 0;
+	int i;
+
+	test_set_guest(rdtsc_vmexit_diff_test_guest);
+
+	reset_guest_tsc_to_zero();
+
+	/*
+	 * Set up the VMCS12 VM-exit MSR-store list to store just one
+	 * MSR: IA32_TIME_STAMP_COUNTER. Note that the value stored is
+	 * in the host time domain (i.e., it is not adjusted according
+	 * to the TSC multiplier and TSC offset fields in the VMCS12,
+	 * as a guest RDTSC would be.)
+	 */
+	exit_msr_store =3D alloc_page();
+	exit_msr_store[0].index =3D MSR_IA32_TSC;
+	vmcs_write(EXI_MSR_ST_CNT, 1);
+	vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(exit_msr_store));
+
+	for (i =3D 0; i < RDTSC_DIFF_ITERS; i++) {
+		if (rdtsc_vmexit_diff_test_iteration() >=3D
+		    HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD)
+			fail++;
+	}
+
+	enter_guest();
+
+	report("RDTSC to VM-exit delta too high in %d of %d iterations",
+	       fail < RDTSC_DIFF_FAILS, fail, RDTSC_DIFF_ITERS);
+}
=20
 static int invalid_msr_init(struct vmcs *vmcs)
 {
@@ -9056,5 +9148,6 @@ struct vmx_test vmx_tests[] =3D {
 	/* Atomic MSR switch tests. */
 	TEST(atomic_switch_max_msrs_test),
 	TEST(atomic_switch_overflow_msrs_test),
+	TEST(rdtsc_vmexit_diff_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
--=20
2.24.0.393.g34dc348eaf-goog

