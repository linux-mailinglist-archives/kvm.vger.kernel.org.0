Return-Path: <kvm+bounces-4783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A21C81837D
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 09:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B25EF1C21AA0
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 08:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D481514F7E;
	Tue, 19 Dec 2023 08:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UyvDST5G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391AB12B9E;
	Tue, 19 Dec 2023 08:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702974920; x=1734510920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sp+9xcBrDRa7FSf2M1vCbvXXsVMU/OMOwmsjWVEj29A=;
  b=UyvDST5GVlpfGzfI0Y+eovq6zTLTAkdsnEZJvZ1V5sJMW/uqPglJoCm+
   PnfciMp66NGFCw0z4c1X4faQ5kBr4oleMvTPdPQBNZnzcbFlk8Yg88mxU
   GgmtOYN4+nz5I7fzoV3G9u8S2tBoUp+zWs6Q8NpFuHDXFvs/VyT1f/ufi
   emfk0UAhs/NA6R6bKeI5OgN/52QOBNYf6BukWjxAvJjjD3EHE6nd+SUzk
   QQ1GJA+O/U4Em07gr1HvRGTPA2xJiGtPPTo8iqyuySzzUl0HJB8EhOaLQ
   rk4cu0+mosrZP8pyP0bjGaxrSqdkw225uReDkZmS1Y1zcEa2jFkWiAKrl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="395355772"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="395355772"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 00:34:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="725658911"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="725658911"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 00:34:56 -0800
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com
Subject: [PATCH v3 4/4] KVM: selftests: Add test case for x86 apic_bus_clock_frequency
Date: Tue, 19 Dec 2023 00:34:41 -0800
Message-Id: <f738cb171c6d47b72b5e608777cf64fa3958183a.1702974319.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1702974319.git.isaku.yamahata@intel.com>
References: <cover.1702974319.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test if the apic bus clock frequency is exptected to the configured value.
Set APIC TMICT to the maximum value and busy wait for 100 msec (any value
is okay) with tsc value, and read TMCCT. Calculate apic bus clock frequency
based on TSC frequency.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes v3:
- Use 1.5GHz instead of 1GHz as frequency.

Changes v2:
- Newly added.
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/apic.h       |   7 +
 .../kvm/x86_64/apic_bus_clock_test.c          | 135 ++++++++++++++++++
 3 files changed, 143 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 963435959a92..e07ec9c1dbd1 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -116,6 +116,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
+TEST_GEN_PROGS_x86_64 += x86_64/apic_bus_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
 TEST_GEN_PROGS_x86_64 += x86_64/xapic_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/xcr0_cpuid_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/apic.h b/tools/testing/selftests/kvm/include/x86_64/apic.h
index bed316fdecd5..866a58d5fa11 100644
--- a/tools/testing/selftests/kvm/include/x86_64/apic.h
+++ b/tools/testing/selftests/kvm/include/x86_64/apic.h
@@ -60,6 +60,13 @@
 #define		APIC_VECTOR_MASK	0x000FF
 #define	APIC_ICR2	0x310
 #define		SET_APIC_DEST_FIELD(x)	((x) << 24)
+#define APIC_LVT0       0x350
+#define         APIC_LVT_TIMER_ONESHOT          (0 << 17)
+#define         APIC_LVT_TIMER_PERIODIC         (1 << 17)
+#define         APIC_LVT_TIMER_TSCDEADLINE      (2 << 17)
+#define APIC_TMICT	0x380
+#define APIC_TMCCT	0x390
+#define APIC_TDCR	0x3E0
 
 void apic_disable(void);
 void xapic_enable(void);
diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
new file mode 100644
index 000000000000..e7896d703e7d
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
@@ -0,0 +1,135 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define _GNU_SOURCE /* for program_invocation_short_name */
+
+#include "apic.h"
+#include "test_util.h"
+
+/*
+ * Pick one convenient value, 1.5Ghz.  No special meaning and different from
+ * the default value, 1Ghz.
+ */
+#define TSC_HZ			(1500 * 1000 * 1000ULL)
+
+/* Wait for 100 msec, not too long, not too short value. */
+#define LOOP_MSEC		100ULL
+#define TSC_WAIT_DELTA		(TSC_HZ / 1000 * LOOP_MSEC)
+
+/* Pick up typical value.  Different enough from the default value, 1GHz.  */
+#define APIC_BUS_CLOCK_FREQ	(25 * 1000 * 1000ULL)
+
+static void guest_code(void)
+{
+	/* Possible tdcr values and its divide count. */
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
+	 * Setup one-shot timer.  Because we don't fire the interrupt, the
+	 * vector doesn't matter.
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
+		/* Read apic timer and tsc */
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
+				    "tsc cycles must not be zero.");
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
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+
+	vm = __vm_create(VM_MODE_DEFAULT, 1, 0);
+	vm_ioctl(vm, KVM_SET_TSC_KHZ, (void *) (TSC_HZ / 1000));
+	/*  KVM_CAP_X86_BUS_FREQUENCY_CONTROL requires that no vcpu is created. */
+	vm_enable_cap(vm, KVM_CAP_X86_BUS_FREQUENCY_CONTROL,
+		      APIC_BUS_CLOCK_FREQ);
+	vcpu = vm_vcpu_add(vm, 0, guest_code);
+
+	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+
+	test_apic_bus_clock(vcpu);
+	kvm_vm_free(vm);
+}
-- 
2.25.1


