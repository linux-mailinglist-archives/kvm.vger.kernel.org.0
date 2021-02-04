Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB1530A103
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 06:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhBAFGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 00:06:06 -0500
Received: from mga14.intel.com ([192.55.52.115]:45366 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhBAFGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 00:06:04 -0500
IronPort-SDR: YESUiSOQ2+KngoD0UXO+dkQf2+t+fHXK/gqEmgCsgzxM/1CFWIw5AAGZGLeZ1UJGVbiTMp+4+v
 BCXB1dsGmRfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="179856554"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="179856554"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:04:17 -0800
IronPort-SDR: C+/CQ+tbwRBl9rIFfWDsdp3NXXd+bypbJ61F8Qi7NJbqssY33aL3Ty3Ba48VhIkG5KSncwQ9hf
 HdTsuovEiKXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="368961982"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga008.fm.intel.com with ESMTP; 31 Jan 2021 21:04:16 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-test] [PATCH] x86: Add tests for Guest Last Branch Recording (LBR)
Date:   Mon,  1 Feb 2021 12:57:51 +0800
Message-Id: <20210201045751.243231-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This unit-test is intended to test the KVM's support for the
Last Branch Recording (LBR) which is a performance monitor
unit (PMU) feature on Intel processors.

If the LBR bit is set to 1 in the DEBUGCTLMSR, the processor
will record a running trace of the most recent branches guest
taken in the LBR entries for guest to read.

This is a basic check that looks for the MSR LBR (via #GP check),
does some branches, and checks that the FROM_IP/TO_IP are good.
To run this test, use the QEMU option "-cpu host,migratable=no".

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 x86/Makefile.common |   3 +-
 x86/pmu_lbr.c       | 121 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |   6 +++
 3 files changed, 129 insertions(+), 1 deletion(-)
 create mode 100644 x86/pmu_lbr.c

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 55f7f28..378a795 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -62,7 +62,8 @@ tests-common = $(TEST_DIR)/vmexit.flat $(TEST_DIR)/tsc.flat \
                $(TEST_DIR)/init.flat $(TEST_DIR)/smap.flat \
                $(TEST_DIR)/hyperv_synic.flat $(TEST_DIR)/hyperv_stimer.flat \
                $(TEST_DIR)/hyperv_connections.flat \
-               $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat
+               $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat \
+               $(TEST_DIR)/pmu_lbr.flat
 
 test_cases: $(tests-common) $(tests)
 
diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
new file mode 100644
index 0000000..3bd9e9f
--- /dev/null
+++ b/x86/pmu_lbr.c
@@ -0,0 +1,121 @@
+#include "x86/msr.h"
+#include "x86/processor.h"
+#include "x86/desc.h"
+
+#define N 1000000
+#define MAX_NUM_LBR_ENTRY	  32
+#define DEBUGCTLMSR_LBR	  (1UL <<  0)
+#define PMU_CAP_LBR_FMT	  0x3f
+
+#define MSR_LBR_NHM_FROM	0x00000680
+#define MSR_LBR_NHM_TO		0x000006c0
+#define MSR_LBR_CORE_FROM	0x00000040
+#define MSR_LBR_CORE_TO	0x00000060
+#define MSR_LBR_TOS		0x000001c9
+#define MSR_LBR_SELECT		0x000001c8
+
+volatile int count;
+
+static __attribute__((noinline)) int compute_flag(int i)
+{
+	if (i % 10 < 4)
+		return i + 1;
+	return 0;
+}
+
+static __attribute__((noinline)) int lbr_test(void)
+{
+	int i;
+	int flag;
+	volatile double x = 1212121212, y = 121212;
+
+	for (i = 0; i < 200000000; i++) {
+		flag = compute_flag(i);
+		count++;
+		if (flag)
+			x += x / y + y / x;
+	}
+	return 0;
+}
+
+union cpuid10_eax {
+	struct {
+		unsigned int version_id:8;
+		unsigned int num_counters:8;
+		unsigned int bit_width:8;
+		unsigned int mask_length:8;
+	} split;
+	unsigned int full;
+} eax;
+
+u32 lbr_from, lbr_to;
+
+static void init_lbr(void *index)
+{
+	wrmsr(lbr_from + *(int *) index, 0);
+	wrmsr(lbr_to + *(int *)index, 0);
+}
+
+static bool test_init_lbr_from_exception(u64 index)
+{
+	return test_for_exception(GP_VECTOR, init_lbr, &index);
+}
+
+int main(int ac, char **av)
+{
+	struct cpuid id = cpuid(10);
+	u64 perf_cap;
+	int max, i;
+
+	setup_vm();
+	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+	eax.full = id.a;
+
+	if (!eax.split.version_id) {
+		printf("No pmu is detected!\n");
+		return report_summary();
+	}
+	if (!(perf_cap & PMU_CAP_LBR_FMT)) {
+		printf("No LBR is detected!\n");
+		return report_summary();
+	}
+
+	printf("PMU version:		 %d\n", eax.split.version_id);
+	printf("LBR version:		 %ld\n", perf_cap & PMU_CAP_LBR_FMT);
+
+	/* Look for LBR from and to MSRs */
+	lbr_from = MSR_LBR_CORE_FROM;
+	lbr_to = MSR_LBR_CORE_TO;
+	if (test_init_lbr_from_exception(0)) {
+		lbr_from = MSR_LBR_NHM_FROM;
+		lbr_to = MSR_LBR_NHM_TO;
+	}
+
+	if (test_init_lbr_from_exception(0)) {
+		printf("LBR on this platform is not supported!\n");
+		return report_summary();
+	}
+
+	wrmsr(MSR_LBR_SELECT, 0);
+	wrmsr(MSR_LBR_TOS, 0);
+	for (max = 0; max < MAX_NUM_LBR_ENTRY; max++) {
+		if (test_init_lbr_from_exception(max))
+			break;
+	}
+
+	report(max > 0, "The number of guest LBR entries is good.");
+
+	/* Do some branch instructions. */
+	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
+	lbr_test();
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
+
+	report(rdmsr(MSR_LBR_TOS) != 0, "The guest LBR MSR_LBR_TOS value is good.");
+	for (i = 0; i < max; ++i) {
+		if (!rdmsr(lbr_to + i) || !rdmsr(lbr_from + i))
+			break;
+	}
+	report(i == max, "The guest LBR FROM_IP/TO_IP values are good.");
+
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 90e370f..d0d46c7 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -174,6 +174,12 @@ file = pmu.flat
 extra_params = -cpu max
 check = /proc/sys/kernel/nmi_watchdog=0
 
+[pmu_lbr]
+file = pmu_lbr.flat
+extra_params = -cpu host,migratable=no
+check = /sys/module/kvm/parameters/ignore_msrs=N
+check = /proc/sys/kernel/nmi_watchdog=0
+
 [vmware_backdoors]
 file = vmware_backdoors.flat
 extra_params = -machine vmport=on -cpu max
-- 
2.29.2

