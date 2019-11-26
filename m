Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D413D10A625
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 22:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfKZVqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 16:46:39 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:41588 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZVqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 16:46:39 -0500
Received: by mail-pj1-f74.google.com with SMTP id h11so9905353pjq.8
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2019 13:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kgrb4wy/9+Q5wK6RZmvuK7OIH9bJhLzwwghsOTMvclU=;
        b=fPLlBo14xmZmR7d5P+QcQ9UuLflFTMtxMRERTcDkubKoPxoTGSNqRPQecufChKfyee
         1OyWDvmDJQIesQ7gjuJIEeQuZ6rA0SgWFGevuQ+nI3rqE/co1zyCWfESrRS/ib4CJEUf
         NjZ0U+KRJxHD2FNZM92nb2ULsHMwKy0y9g7d2NC241gYGcKdWix70ytMW2+f1vQSzp7J
         vpxmcNM4gu8XVNw2UzostTTLTp+YvI4vDj5vQJf/2Z8GplHASAOywmaLnNt6PWwETltZ
         bd1i/v6rpYDKDsFrt7LacQLF2SfTog1mFqfSJps0ogsxyunqDMcuMaNlY1FgB0v8vv6A
         cuFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kgrb4wy/9+Q5wK6RZmvuK7OIH9bJhLzwwghsOTMvclU=;
        b=iXgKQInIrhpVIbgPq6YvprHiSFbeLDThcwTGzrOXzRJVLGBEj6NfVz7k9SH/ijmLnr
         ansKe2EvixitZBug8mliLyjgSDqFEBLSkomtDhlbwzSZNN4HkHAcQenHGE+3ROLxWiAT
         /k3oovffMrhHdCKihiS6H0dWPgzktbB5R2pBkoVBnLCFtngiWI9jr19iH3RoKK5pq9cl
         Elhyv13drBPbkoneq6dr1hijqH5YfYBM9U1nnTEBb4SObHaVwXUVzEcxOqRSaf592UNN
         /S9LdKLPECoqjSjGRFGaUScjGn4vd/6cQlewx5tW4IDySd4iXhGt+YsYj49CxgsAXX/w
         KQEw==
X-Gm-Message-State: APjAAAUfYb7qD+E8dvLEG+9U4GiuI8tD0PVEI5y1j6ocyKk9fWD3nvez
        0+bvC+KCQ4XBbQ58qMmzu2HDV9whU3W4uudr
X-Google-Smtp-Source: APXvYqzopno2M5Eo/eSSKW7+KBZOw0QpbZLrQkz+NCwSa0WLY779OnlNBnO9ZbgFov3Tyd6IXMGzI+ovWOO1/vhc
X-Received: by 2002:a63:d70f:: with SMTP id d15mr794420pgg.424.1574804796692;
 Tue, 26 Nov 2019 13:46:36 -0800 (PST)
Date:   Tue, 26 Nov 2019 13:44:44 -0800
Message-Id: <20191126214443.99189-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [kvm-unit-tests PATCH v2] x86: Add RDTSC test
From:   Aaron Lewis <aaronlewis@google.com>
To:     Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that the difference between a guest RDTSC instruction and the
IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12's VM-exit
MSR-store list is less than 750 cycles, 99.9% of the time.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 x86/unittests.cfg |  6 ++++
 x86/vmx.h         |  1 +
 x86/vmx_tests.c   | 91 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)

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
diff --git a/x86/vmx.h b/x86/vmx.h
index 8496be7..21ba953 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -420,6 +420,7 @@ enum Ctrl1 {
 	CPU_SHADOW_VMCS		= 1ul << 14,
 	CPU_RDSEED		= 1ul << 16,
 	CPU_PML                 = 1ul << 17,
+	CPU_USE_TSC_SCALING	= 1ul << 25,
 };
 
 enum Intr_type {
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 1d8932f..fcf71e7 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8790,7 +8790,97 @@ static void vmx_vmcs_shadow_test(void)
 	enter_guest();
 }
 
+/*
+ * This test monitors the difference between a guest RDTSC instruction
+ * and the IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12
+ * VM-exit MSR-store list when taking a VM-exit on the instruction
+ * following RDTSC.
+ */
+#define RDTSC_DIFF_ITERS 100000
+#define RDTSC_DIFF_FAILS 100
+#define HOST_RDTSC_LIMIT 750
+
+/*
+ * Set 'use TSC offsetting' and set the guest offset to the
+ * inverse of the host's current TSC value, so that the guest starts running
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
+	for (i = 0; i < RDTSC_DIFF_ITERS; i++)
+		/* Ensure rdtsc is the last instruction before the vmcall. */
+		asm volatile("rdtsc; vmcall" : : : "eax", "edx");
+}
 
+/*
+ * This function only considers the "use TSC offsetting" VM-execution
+ * control.  It does not handle "use TSC scaling" (because the latter
+ * isn't available to the host today.)
+ */
+static unsigned long long host_time_to_guest_time(unsigned long long t)
+{
+	TEST_ASSERT((vmcs_read(CPU_EXEC_CTRL1) & CPU_USE_TSC_SCALING) == 0);
+
+	if (vmcs_read(CPU_EXEC_CTRL0) & CPU_USE_TSC_OFFSET)
+		t += vmcs_read(TSC_OFFSET);
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
+	guest_tsc = (u32) regs.rax + (regs.rdx << 32);
+	host_to_guest_tsc = host_time_to_guest_time(exit_msr_store[0].value);
+
+	return host_to_guest_tsc - guest_tsc;
+}
+
+static void rdtsc_vmexit_diff_test(void)
+{
+	int fail = 0;
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
+	exit_msr_store = alloc_page();
+	exit_msr_store[0].index = MSR_IA32_TSC;
+	vmcs_write(EXI_MSR_ST_CNT, 1);
+	vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(exit_msr_store));
+
+	for (i = 0; i < RDTSC_DIFF_ITERS; i++) {
+		if (rdtsc_vmexit_diff_test_iteration() >= HOST_RDTSC_LIMIT)
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
@@ -9056,5 +9146,6 @@ struct vmx_test vmx_tests[] = {
 	/* Atomic MSR switch tests. */
 	TEST(atomic_switch_max_msrs_test),
 	TEST(atomic_switch_overflow_msrs_test),
+	TEST(rdtsc_vmexit_diff_test),
 	{ NULL, NULL, NULL, NULL, NULL, {0} },
 };
-- 
2.24.0.432.g9d3f5f5b63-goog

