Return-Path: <kvm+bounces-12425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B3FB885E68
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 17:48:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D50112825B2
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 16:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2386813F45C;
	Thu, 21 Mar 2024 16:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FDdqjMCl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B74A13B7A6;
	Thu, 21 Mar 2024 16:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711039087; cv=none; b=Q8L6TxvArGj/b9V+n7uQelnJxnDBmzKaVHOF2QF5SG6/RypYQkzruzi8GXmKr8SsYSncx7oc/VPFztcJ++0iIDNen2LxcEK9hJ0R0aHw+8thnWX7T3eo08tSiusf2fX4lSyNiaUy0ZYp3eayI/F582zsaBXRpGRkqSGbw/b/TkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711039087; c=relaxed/simple;
	bh=VRSMWFCZT0oWTvcVrVc6zm0WXxmKtdud0NjIamWAcNM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oHaKZzjtC+5guoFPDbnAG5LLVOhQnEXtEh8cexgPU/Yf28pzLP2NRKYo5wURaWUtcLDUgadmwY7LyTXUH3/+PKmnACMGvErcKbv4KonwqlD8/Ig+WLDX8qPvlJgZjQxfM8XoRfGQRaNWokiziKSIz7oo/1MFIz28L8RsBbs53Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FDdqjMCl; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711039085; x=1742575085;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VRSMWFCZT0oWTvcVrVc6zm0WXxmKtdud0NjIamWAcNM=;
  b=FDdqjMClR6UgoL7iorUdaqKqdCzNeF/VKUN6ku428cXHBMuxyqpN5GXC
   Eb3r/gnAE9yI4i7TO9b/zm/6XWQWAYpk65oFuRMUCgFzLenyShAORYArG
   xL6pj1jyUzJVKp8LDKyrIh62x/fuhNKfHnxAEbiOjzsnyE/AUw1IddyFa
   1Hl94IGyEGEJRE6xodsUQAA3iQ60uqG8A2XxV8YoiGZf51hfAgPcgU/gh
   wQUZ8/GYyWV7oUdHyHDBcO/wOLa5jf/ubs2AAQaSlrWC5iWqrP01eFKN3
   NgqgqIDtlrFnGoaKD/5qDBNUulRG6C7Szyu8Kxd0b60ystfOglhCQuIgL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="31477564"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="31477564"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 09:37:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="19280019"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 09:37:58 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: isaku.yamahata@intel.com,
	pbonzini@redhat.com,
	erdemaktas@google.com,
	vkuznets@redhat.com,
	seanjc@google.com,
	vannapurve@google.com,
	jmattson@google.com,
	mlevitsk@redhat.com,
	xiaoyao.li@intel.com,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com
Cc: reinette.chatre@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V4 4/4] KVM: selftests: Add test for configure of x86 APIC bus frequency
Date: Thu, 21 Mar 2024 09:37:44 -0700
Message-Id: <731f6bd293d298f8cbd313d1e8e7d472d6d6d8e6.1711035400.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1711035400.git.reinette.chatre@intel.com>
References: <cover.1711035400.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Test if the APIC bus clock frequency is the expected configured value.

Set APIC timer's initial count to the maximum value and busy wait for 100
msec (any value is okay) with TSC value. Read the APIC timer's "current
count" to calculate the actual APIC bus clock frequency based on TSC
frequency.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

Changes v4:
- Rework changelog.
- Add Sean's "Suggested-by" to acknowledge guidance received in
  https://lore.kernel.org/all/ZU0BASXWcck85r90@google.com/
- Add copyright.
- Add test description to file header.
- Consistent capitalization for acronyms.
- Rebase to kvm-x86/next.
- Update to v4 change of providing bus clock rate in nanoseconds.
- Add a "TEST_REQUIRE()" for the new capability so that the test can
  work on kernels that do not support the new capability.
- Address checkpatch warnings and use tabs instead of spaces in header
  file to match existing code.

Changes v3:
- Use 1.5GHz instead of 1GHz as frequency.

Changes v2:
- Newly added.

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/apic.h       |   7 +
 .../kvm/x86_64/apic_bus_clock_test.c          | 166 ++++++++++++++++++
 3 files changed, 174 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index da20e6bb43ed..05b9a942a878 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -110,6 +110,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
+TEST_GEN_PROGS_x86_64 += x86_64/apic_bus_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
 TEST_GEN_PROGS_x86_64 += x86_64/xapic_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/xcr0_cpuid_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/apic.h b/tools/testing/selftests/kvm/include/x86_64/apic.h
index bed316fdecd5..b0d2fc62e172 100644
--- a/tools/testing/selftests/kvm/include/x86_64/apic.h
+++ b/tools/testing/selftests/kvm/include/x86_64/apic.h
@@ -60,6 +60,13 @@
 #define		APIC_VECTOR_MASK	0x000FF
 #define	APIC_ICR2	0x310
 #define		SET_APIC_DEST_FIELD(x)	((x) << 24)
+#define APIC_LVT0	0x350
+#define		APIC_LVT_TIMER_ONESHOT		(0 << 17)
+#define		APIC_LVT_TIMER_PERIODIC		(1 << 17)
+#define		APIC_LVT_TIMER_TSCDEADLINE	(2 << 17)
+#define	APIC_TMICT	0x380
+#define	APIC_TMCCT	0x390
+#define	APIC_TDCR	0x3E0
 
 void apic_disable(void);
 void xapic_enable(void);
diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
new file mode 100644
index 000000000000..ee0cae056827
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test configure of APIC bus frequency.
+ *
+ * Copyright (c) 2024 Intel Corporation
+ *
+ * To verify if the APIC bus frequency can be configured this test starts
+ * by setting the TSC frequency in KVM, and then:
+ * For every APIC timer frequency supported:
+ * * In the guest:
+ * * * Start the APIC timer by programming the APIC TMICT (initial count
+ *       register) to the largest value possible to guarantee that it will
+ *       not expire during the test,
+ * * * Wait for a known duration based on previously set TSC frequency,
+ * * * Stop the timer and read the APIC TMCCT (current count) register to
+ *       determine the count at that time (TMCCT is loaded from TMICT when
+ *       TMICT is programmed and then starts counting down).
+ * * In the host:
+ * * * Determine if the APIC counts close to configured APIC bus frequency
+ *     while taking into account how the APIC timer frequency was modified
+ *     using the APIC TDCR (divide configuration register).
+ */
+#define _GNU_SOURCE /* for program_invocation_short_name */
+
+#include "apic.h"
+#include "test_util.h"
+
+/*
+ * Pick one convenient value, 1.5GHz. No special meaning and different from
+ * the default value, 1GHz.
+ */
+#define TSC_HZ			(1500 * 1000 * 1000ULL)
+
+/* Wait for 100 msec, not too long, not too short value. */
+#define LOOP_MSEC		100ULL
+#define TSC_WAIT_DELTA		(TSC_HZ / 1000 * LOOP_MSEC)
+
+/*
+ * Pick a typical value, 25MHz. Different enough from the default value, 1GHz.
+ */
+#define APIC_BUS_CLOCK_FREQ	(25 * 1000 * 1000ULL)
+
+static void guest_code(void)
+{
+	/*
+	 * Possible TDCR values and its divide count. Used to modify APIC
+	 * timer frequency.
+	 */
+	struct {
+		u32 tdcr;
+		u32 divide_count;
+	} tdcrs[] = {
+		{0x0, 2},
+		{0x1, 4},
+		{0x2, 8},
+		{0x3, 16},
+		{0x8, 32},
+		{0x9, 64},
+		{0xa, 128},
+		{0xb, 1},
+	};
+
+	u32 tmict, tmcct;
+	u64 tsc0, tsc1;
+	int i;
+
+	asm volatile("cli");
+
+	xapic_enable();
+
+	/*
+	 * Setup one-shot timer.  The vector does not matter because the
+	 * interrupt does not fire.
+	 */
+	xapic_write_reg(APIC_LVT0, APIC_LVT_TIMER_ONESHOT);
+
+	for (i = 0; i < ARRAY_SIZE(tdcrs); i++) {
+		xapic_write_reg(APIC_TDCR, tdcrs[i].tdcr);
+
+		/* Set the largest value to not trigger the interrupt. */
+		tmict = ~0;
+		xapic_write_reg(APIC_TMICT, tmict);
+
+		/* Busy wait for LOOP_MSEC */
+		tsc0 = rdtsc();
+		tsc1 = tsc0;
+		while (tsc1 - tsc0 < TSC_WAIT_DELTA)
+			tsc1 = rdtsc();
+
+		/* Read APIC timer and TSC */
+		tmcct = xapic_read_reg(APIC_TMCCT);
+		tsc1 = rdtsc();
+
+		/* Stop timer */
+		xapic_write_reg(APIC_TMICT, 0);
+
+		/* Report it. */
+		GUEST_SYNC_ARGS(tdcrs[i].divide_count, tmict - tmcct,
+				tsc1 - tsc0, 0, 0);
+	}
+
+	GUEST_DONE();
+}
+
+void test_apic_bus_clock(struct kvm_vcpu *vcpu)
+{
+	bool done = false;
+	struct ucall uc;
+
+	while (!done) {
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_DONE:
+			done = true;
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_SYNC: {
+			u32 divide_counter = uc.args[1];
+			u32 apic_cycles = uc.args[2];
+			u64 tsc_cycles = uc.args[3];
+			u64 freq;
+
+			TEST_ASSERT(tsc_cycles > 0,
+				    "TSC cycles must not be zero.");
+
+			/* Allow 1% slack. */
+			freq = apic_cycles * divide_counter * TSC_HZ / tsc_cycles;
+			TEST_ASSERT(freq < APIC_BUS_CLOCK_FREQ * 101 / 100,
+				    "APIC bus clock frequency is too large");
+			TEST_ASSERT(freq > APIC_BUS_CLOCK_FREQ * 99 / 100,
+				    "APIC bus clock frequency is too small");
+			break;
+		}
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+			break;
+		}
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_APIC_BUS_FREQUENCY));
+
+	vm = __vm_create(VM_SHAPE_DEFAULT, 1, 0);
+	vm_ioctl(vm, KVM_SET_TSC_KHZ, (void *)(TSC_HZ / 1000));
+	/*
+	 * KVM_CAP_X86_APIC_BUS_FREQUENCY expects APIC bus clock rate in
+	 * nanoseconds and requires that no vCPU is created.
+	 */
+	vm_enable_cap(vm, KVM_CAP_X86_APIC_BUS_FREQUENCY,
+		      NSEC_PER_SEC / APIC_BUS_CLOCK_FREQ);
+	vcpu = vm_vcpu_add(vm, 0, guest_code);
+
+	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+
+	test_apic_bus_clock(vcpu);
+	kvm_vm_free(vm);
+}
-- 
2.34.1


