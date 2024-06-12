Return-Path: <kvm+bounces-19492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BFBC905A92
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 20:17:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D6EAB22DDF
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 18:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F07FA48CC6;
	Wed, 12 Jun 2024 18:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dam1wTuQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F113F9D2;
	Wed, 12 Jun 2024 18:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718216185; cv=none; b=KPSzki+r/2kYCvFnyIU2us45HX09xE1BaScPNljw3k+bOP/VGNmLgExz3PaCmD7xSiN3QUKO2RYFUCN3bM1X1x3xW4QQmApj+S1Pp0jCNdAvfSum9hHzaemGlPRleCnv6AJC9XGV8K/DqfLXDu+LbFRhOr7kAYyxt2/OE36ddF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718216185; c=relaxed/simple;
	bh=dRAfO7PWpI+bctIODDyAWU5ZGNHjdHebE3Cvrp39KMA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sZrs8EEigDgLqmsb6tZK/lLxkZuNQh2Er1one9befR9CwPkFFcOEtzDlGAkPW+ouRQHRrSwMZm+7LBmxSKZbLJzkszBWBqZcGbrC3/Til02H6W3lI+eeFfhBebLW+e5Uvi514RGQGo3XpQ1f5ql0Q93KeUid3diAUn3qzhkh4r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dam1wTuQ; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718216183; x=1749752183;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dRAfO7PWpI+bctIODDyAWU5ZGNHjdHebE3Cvrp39KMA=;
  b=Dam1wTuQMv9kGj9ST0YffivlnKIrskUPn1eog/xI95ko6nl0UsODD+mb
   DoN95cP+L4sOp8x88swpI5Nw5NMv5MUNG3eGFgR97mI7jmnaSUMO12EXS
   yXahNnWMVRcLkqsQ62AtBOvLdGj7+hFRrZWiER3upkIBRQcQxPFnZCjKp
   vGF4yEF32gM2YpINvv2jnjaxTH+5D061i7qjJs5ECBSuPG1lHbBxaXpiF
   A26rY19wInZ2ldxVudW+i09nRCu0AYh5H0AcI5GA3kvJFN/fciPLU1rVe
   N82oQqmDkhwv5xs4jjJpYPwZhBVvzRZRjnSVI8uT+DZjrdVO11hxj3p77
   A==;
X-CSE-ConnectionGUID: IZOSLNJlS6+nkjRbdCoQ6Q==
X-CSE-MsgGUID: 3HH/dWz+Sue/5RkEslujaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="14875091"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="14875091"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 11:16:19 -0700
X-CSE-ConnectionGUID: KyZjubziR36XDE7VK38CyQ==
X-CSE-MsgGUID: mPIG0bvNSgqbHrbrPb+lHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="39823179"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 11:16:19 -0700
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
Subject: [PATCH V9 2/2] KVM: selftests: Add test for configure of x86 APIC bus frequency
Date: Wed, 12 Jun 2024 11:16:12 -0700
Message-Id: <2fccf35715b5ba8aec5e5708d86ad7015b8d74e6.1718214999.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1718214999.git.reinette.chatre@intel.com>
References: <cover.1718214999.git.reinette.chatre@intel.com>
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
Changes v9:
- Use uint64_t to store APIC frequency (was unsigned long). (Sean)
- Introduce new helpers (apic_enable(), apic_read_reg(), and
  apic_write_reg()) that runs appropriate xAPIC or x2APIC functions
  based on new is_x2apic global. (Sean)
- Use new apic_* helpers in guest test code to eliminate duplicate
  code. (Sean)
- Use constant defined at beginning of function for ICR register
  value. (Sean)
- Drop unnecessary GUEST_ASSERT(tsc_cycles > 0). (Sean)
- Drop unnecessary comments, use provided comments. (Sean)
- Change APIC frequency command line option to "-f" (was "-a"). (Sean)
- Enable user to override delay used in guest with new "-d" command
  line option. (Sean)
- Open code test checks in what is now single guest test function.

Changes v8:
- With TSC frequency switching to unsigned int type the implicit
  type promotion during bus frequency computation results in
  overflow. Use explicit unsigned long type within computation to
  avoid overflow.

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
 .../kvm/x86_64/apic_bus_clock_test.c          | 202 ++++++++++++++++++
 3 files changed, 211 insertions(+)
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
index 000000000000..bff3cd95134f
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
@@ -0,0 +1,202 @@
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
+static uint64_t apic_hz = 25 * 1000 * 1000;
+
+/*
+ * Delay in msec that guest uses to determine APIC bus frequency.
+ * User can override via command line.
+ */
+static unsigned long delay_ms = 100;
+
+/*
+ * Possible TDCR values with matching divide count. Used to modify APIC
+ * timer frequency.
+ */
+static struct {
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
+/* true if x2APIC test is running, false if xAPIC test is running. */
+static bool is_x2apic;
+
+static void apic_enable(void)
+{
+	if (is_x2apic)
+		x2apic_enable();
+	else
+		xapic_enable();
+}
+
+static uint32_t apic_read_reg(unsigned int reg)
+{
+	return is_x2apic ? x2apic_read_reg(reg) : xapic_read_reg(reg);
+}
+
+static void apic_write_reg(unsigned int reg, uint32_t val)
+{
+	if (is_x2apic)
+		x2apic_write_reg(reg, val);
+	else
+		xapic_write_reg(reg, val);
+}
+
+static void apic_guest_code(void)
+{
+	uint64_t tsc_hz = (uint64_t)tsc_khz * 1000;
+	const uint32_t tmict = ~0u;
+	uint64_t tsc0, tsc1, freq;
+	uint32_t tmcct;
+	int i;
+
+	apic_enable();
+
+	/*
+	 * Setup one-shot timer.  The vector does not matter because the
+	 * interrupt should not fire.
+	 */
+	apic_write_reg(APIC_LVTT, APIC_LVT_TIMER_ONESHOT | APIC_LVT_MASKED);
+
+	for (i = 0; i < ARRAY_SIZE(tdcrs); i++) {
+
+		apic_write_reg(APIC_TDCR, tdcrs[i].tdcr);
+		apic_write_reg(APIC_TMICT, tmict);
+
+		tsc0 = rdtsc();
+		udelay(delay_ms * 1000);
+		tmcct = apic_read_reg(APIC_TMCCT);
+		tsc1 = rdtsc();
+
+		/*
+		 * Stop the timer _after_ reading the current, final count, as
+		 * writing the initial counter also modifies the current count.
+		 */
+		apic_write_reg(APIC_TMICT, 0);
+
+		freq = (tmict - tmcct) * tdcrs[i].divide_count * tsc_hz / (tsc1 - tsc0);
+		/* Check if measured frequency is within 1% of configured frequency. */
+		GUEST_ASSERT(freq < apic_hz * 101 / 100);
+		GUEST_ASSERT(freq > apic_hz * 99 / 100);
+	}
+
+	GUEST_DONE();
+}
+
+static void test_apic_bus_clock(struct kvm_vcpu *vcpu)
+{
+	bool done = false;
+	struct ucall uc;
+
+	while (!done) {
+		vcpu_run(vcpu);
+
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
+static void run_apic_bus_clock_test(bool x2apic)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int ret;
+
+	is_x2apic = x2apic;
+
+	vm = vm_create(1);
+
+	sync_global_to_guest(vm, apic_hz);
+	sync_global_to_guest(vm, delay_ms);
+	sync_global_to_guest(vm, is_x2apic);
+
+	vm_enable_cap(vm, KVM_CAP_X86_APIC_BUS_CYCLES_NS,
+		      NSEC_PER_SEC / apic_hz);
+
+	vcpu = vm_vcpu_add(vm, 0, apic_guest_code);
+
+	ret = __vm_enable_cap(vm, KVM_CAP_X86_APIC_BUS_CYCLES_NS,
+			      NSEC_PER_SEC / apic_hz);
+	TEST_ASSERT(ret < 0 && errno == EINVAL,
+		    "Setting of APIC bus frequency after vCPU is created should fail.");
+
+	if (!is_x2apic)
+		virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+
+	test_apic_bus_clock(vcpu);
+	kvm_vm_free(vm);
+}
+
+static void help(char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-d delay] [-f APIC bus freq]\n", name);
+	puts("");
+	printf("-d: Delay (in msec) guest uses to measure APIC bus frequency.\n");
+	printf("-f: The APIC bus frequency (in Hz) to be configured for the guest.\n");
+	puts("");
+}
+
+int main(int argc, char *argv[])
+{
+	int opt;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_APIC_BUS_CYCLES_NS));
+
+	while ((opt = getopt(argc, argv, "d:f:h")) != -1) {
+		switch (opt) {
+		case 'f':
+			apic_hz = atol(optarg);
+			break;
+		case 'd':
+			delay_ms = atol(optarg);
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
+	run_apic_bus_clock_test(false);
+	run_apic_bus_clock_test(true);
+}
-- 
2.34.1


