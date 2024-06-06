Return-Path: <kvm+bounces-19031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7FF48FF3F9
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 19:43:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6916C28C97D
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 17:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B27E61993B8;
	Thu,  6 Jun 2024 17:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O16a1+/X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA31199225;
	Thu,  6 Jun 2024 17:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717695757; cv=none; b=Pslr/xHOZ23JrESSDPYyUSW1wwr3U9/StKv5NgPruY+eobVK2VYkqmm2uBOFdIbxTWZpmXiYMUMg7CG+Z0sVdJH+RTm09kEzvTPYi8EQVGqLG5G7iQlOGCg4OympsMc3VprjvjBtiefeHp6q+bFbTkpkP+IhX+bTsnxQ6Rp9icU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717695757; c=relaxed/simple;
	bh=/4Jv3hhvs8UVbSOcZbwfddeZvsZJMDoUqP6gWQb+QD4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DHsy7EptSPkGS4iCZq0z56L6d5wVg13yxdkc9eiPmFDVc+FaY7VLdJzlLfS5W+IjTzaF6ngFNlk3JS7rNIYP9xF5igSLMsT1TlRoY4a7oghnxEgMumCS18DPpHapnkLp2nCo7bj4L6nrdwXGk4iWn6kTZTXhFhy+D44/Oafs5/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O16a1+/X; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717695756; x=1749231756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/4Jv3hhvs8UVbSOcZbwfddeZvsZJMDoUqP6gWQb+QD4=;
  b=O16a1+/X4slN9TQbLY478F9oV0nrMglbBmnsqC+3gI1qbuKABY9HYG6f
   NeothPfTZdQTjUUYY3a/+sUWGE91mP5x6oIbV9uZS/kwqMEZ8EBvjwyCO
   FLPF3Z5xINrve5CmHGxO/3ZUZizB6tN1LFz/Eic5qSEh9/ud0oC2E/Vhl
   e99Pd6bcnaOkVL7EDOW0Q7OgdSWhkNO4kprf08+hUZ8mNRwwqUSamwFIH
   F3dwnXnEsfP0oaOerz5iJwF5bhI4/5Ye+J3Zt6Cz/eZKfQlyIB6Pbv7fK
   VJi03nUibqbUr5iP67DWFnLJGmW0GuVXFTRbTmf8PRB3xNOeFNkQMglCA
   g==;
X-CSE-ConnectionGUID: VRtCPFL+SYazhjh1hDt95w==
X-CSE-MsgGUID: LdFpHqMJTQ2HRwOA26UR5w==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="25792275"
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="25792275"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 10:42:32 -0700
X-CSE-ConnectionGUID: MRQNuHePQ1ea/s+CX6HZbA==
X-CSE-MsgGUID: ukI1yuUdSIeuHnsCkDJKCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="61254868"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 10:42:32 -0700
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
	rick.p.edgecombe@intel.com,
	yuan.yao@intel.com
Cc: reinette.chatre@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V7 2/2] KVM: selftests: Add test for configure of x86 APIC bus frequency
Date: Thu,  6 Jun 2024 10:42:01 -0700
Message-Id: <0f39bef6968032723866e0f38d047806839eb065.1717695426.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1717695426.git.reinette.chatre@intel.com>
References: <cover.1717695426.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Test if KVM emulates the APIC bus clock at the expected frequency when
userspace configures the frequency via KVM_CAP_X86_APIC_BUS_CYCLES_NS.

Set APIC timer's initial count to the maximum value and busy wait for 100
msec (largely arbitrary) using the TSC. Read the APIC timer's "current
count" to calculate the actual APIC bus clock frequency based on TSC
frequency.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes v7:
- Drop Maxim Levitsky's Reviewed-by because of significant changes.
- Remove redefine of _GNU_SOURCE. (kernel test robot)
- Rewrite changelog and test description. (Sean)
- Enable user space to set APIC bus frequency. (Sean)
- Use GUEST_ASSERT() from guest instead of TEST_ASSERT() from host. (Sean)
- Test xAPIC as well as x2APIC. (Sean)
- Add check that KVM_CAP_X86_APIC_BUS_CYCLES_NS cannot be set
  after vCPU created. (Sean)
- Use new udelay() utility. (Sean)
- Drop CLI. Mask LVT timer independently. (Sean)
- Use correct LVT timer entry (0x350 -> 0x320) to enable oneshot operation.
- Remove unnecessary static functions from single file test.
- Be consistent in types by using uint32_t/uint64_t instead of
  u32/u64.

Changes v6:
- Use vm_create() wrapper instead of open coding it. (Zide)
- Improve grammar of test description. (Zide)

Changes v5:
- Update to new name of capability KVM_CAP_X86_APIC_BUS_FREQUENCY ->
  KVM_CAP_X86_APIC_BUS_CYCLES_NS. (Xiaoyao Li)

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
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/apic.h       |   8 +
 .../kvm/x86_64/apic_bus_clock_test.c          | 218 ++++++++++++++++++
 3 files changed, 227 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ce8ff8e8ce3a..ad8b5d15f2bd 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -112,6 +112,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
+TEST_GEN_PROGS_x86_64 += x86_64/apic_bus_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
 TEST_GEN_PROGS_x86_64 += x86_64/xapic_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/xcr0_cpuid_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/apic.h b/tools/testing/selftests/kvm/include/x86_64/apic.h
index bed316fdecd5..0f268b55fa06 100644
--- a/tools/testing/selftests/kvm/include/x86_64/apic.h
+++ b/tools/testing/selftests/kvm/include/x86_64/apic.h
@@ -60,6 +60,14 @@
 #define		APIC_VECTOR_MASK	0x000FF
 #define	APIC_ICR2	0x310
 #define		SET_APIC_DEST_FIELD(x)	((x) << 24)
+#define APIC_LVTT	0x320
+#define		APIC_LVT_TIMER_ONESHOT		(0 << 17)
+#define		APIC_LVT_TIMER_PERIODIC		(1 << 17)
+#define		APIC_LVT_TIMER_TSCDEADLINE	(2 << 17)
+#define		APIC_LVT_MASKED			(1 << 16)
+#define	APIC_TMICT	0x380
+#define	APIC_TMCCT	0x390
+#define	APIC_TDCR	0x3E0
 
 void apic_disable(void);
 void xapic_enable(void);
diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
new file mode 100644
index 000000000000..12845c5378d1
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
@@ -0,0 +1,218 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024 Intel Corporation
+ *
+ * Verify KVM correctly emulates the APIC bus frequency when the VMM configures
+ * the frequency via KVM_CAP_X86_APIC_BUS_CYCLES_NS.  Start the APIC timer by
+ * programming TMICT (timer initial count) to the largest value possible (so
+ * that the timer will not expire during the test).  Then, after an arbitrary
+ * amount of time has elapsed, verify TMCCT (timer current count) is within 1%
+ * of the expected value based on the time elapsed, the APIC bus frequency, and
+ * the programmed TDCR (timer divide configuration register).
+ */
+
+#include "apic.h"
+#include "test_util.h"
+
+/*
+ * Pick 25MHz for APIC bus frequency. Different enough from the default 1GHz.
+ * User can override via command line.
+ */
+unsigned long apic_hz = 25 * 1000 * 1000;
+
+/*
+ * Possible TDCR values with matching divide count. Used to modify APIC
+ * timer frequency.
+ */
+struct {
+	uint32_t tdcr;
+	uint32_t divide_count;
+} tdcrs[] = {
+	{0x0, 2},
+	{0x1, 4},
+	{0x2, 8},
+	{0x3, 16},
+	{0x8, 32},
+	{0x9, 64},
+	{0xa, 128},
+	{0xb, 1},
+};
+
+void guest_verify(uint64_t tsc_cycles, uint32_t apic_cycles, uint32_t divide_count)
+{
+	uint64_t freq;
+
+	GUEST_ASSERT(tsc_cycles > 0);
+	freq = apic_cycles * divide_count * (tsc_khz * 1000) / tsc_cycles;
+	/* Check if measured frequency is within 1% of configured frequency. */
+	GUEST_ASSERT(freq < apic_hz * 101 / 100);
+	GUEST_ASSERT(freq > apic_hz * 99 / 100);
+}
+
+void x2apic_guest_code(void)
+{
+	uint32_t tmict, tmcct;
+	uint64_t tsc0, tsc1;
+	int i;
+
+	x2apic_enable();
+
+	/*
+	 * Setup one-shot timer.  The vector does not matter because the
+	 * interrupt should not fire.
+	 */
+	x2apic_write_reg(APIC_LVTT, APIC_LVT_TIMER_ONESHOT | APIC_LVT_MASKED);
+
+	for (i = 0; i < ARRAY_SIZE(tdcrs); i++) {
+		x2apic_write_reg(APIC_TDCR, tdcrs[i].tdcr);
+
+		/* Set the largest value to not trigger the interrupt. */
+		tmict = ~0;
+		x2apic_write_reg(APIC_TMICT, tmict);
+
+		/* Busy wait for 100 msec. */
+		tsc0 = rdtsc();
+		udelay(100000);
+		/* Read APIC timer and TSC. */
+		tmcct = x2apic_read_reg(APIC_TMCCT);
+		tsc1 = rdtsc();
+
+		/* Stop timer. */
+		x2apic_write_reg(APIC_TMICT, 0);
+
+		guest_verify(tsc1 - tsc0, tmict - tmcct, tdcrs[i].divide_count);
+	}
+
+	GUEST_DONE();
+}
+
+void xapic_guest_code(void)
+{
+	uint32_t tmict, tmcct;
+	uint64_t tsc0, tsc1;
+	int i;
+
+	xapic_enable();
+
+	/*
+	 * Setup one-shot timer.  The vector does not matter because the
+	 * interrupt should not fire.
+	 */
+	xapic_write_reg(APIC_LVTT, APIC_LVT_TIMER_ONESHOT | APIC_LVT_MASKED);
+
+	for (i = 0; i < ARRAY_SIZE(tdcrs); i++) {
+		xapic_write_reg(APIC_TDCR, tdcrs[i].tdcr);
+
+		/* Set the largest value to not trigger the interrupt. */
+		tmict = ~0;
+		xapic_write_reg(APIC_TMICT, tmict);
+
+		/* Busy wait for 100 msec. */
+		tsc0 = rdtsc();
+		udelay(100000);
+		/* Read APIC timer and TSC. */
+		tmcct = xapic_read_reg(APIC_TMCCT);
+		tsc1 = rdtsc();
+
+		/* Stop timer. */
+		xapic_write_reg(APIC_TMICT, 0);
+
+		guest_verify(tsc1 - tsc0, tmict - tmcct, tdcrs[i].divide_count);
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
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+			break;
+		}
+	}
+}
+
+void run_apic_bus_clock_test(bool xapic)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int ret;
+
+	vm = vm_create(1);
+
+	sync_global_to_guest(vm, apic_hz);
+
+	vm_enable_cap(vm, KVM_CAP_X86_APIC_BUS_CYCLES_NS,
+		      NSEC_PER_SEC / apic_hz);
+
+	vcpu = vm_vcpu_add(vm, 0, xapic ? xapic_guest_code : x2apic_guest_code);
+
+	ret = __vm_enable_cap(vm, KVM_CAP_X86_APIC_BUS_CYCLES_NS,
+			      NSEC_PER_SEC / apic_hz);
+	TEST_ASSERT(ret < 0 && errno == EINVAL,
+		    "Setting of APIC bus frequency after vCPU is created should fail.");
+
+	if (xapic)
+		virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+
+	test_apic_bus_clock(vcpu);
+	kvm_vm_free(vm);
+}
+
+void run_xapic_bus_clock_test(void)
+{
+	run_apic_bus_clock_test(true);
+}
+
+void run_x2apic_bus_clock_test(void)
+{
+	run_apic_bus_clock_test(false);
+}
+
+void help(char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-a APIC bus freq]\n", name);
+	puts("");
+	printf("-a: The APIC bus frequency (in Hz) to be configured for the guest.\n");
+	puts("");
+}
+
+int main(int argc, char *argv[])
+{
+	int opt;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_APIC_BUS_CYCLES_NS));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GET_TSC_KHZ));
+
+	while ((opt = getopt(argc, argv, "a:h")) != -1) {
+		switch (opt) {
+		case 'a':
+			apic_hz = atol(optarg);
+			break;
+		case 'h':
+			help(argv[0]);
+			exit(0);
+		default:
+			help(argv[0]);
+			exit(1);
+		}
+	}
+
+	run_xapic_bus_clock_test();
+	run_x2apic_bus_clock_test();
+}
-- 
2.34.1


