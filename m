Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580B530A1F8
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 07:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhBAGd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 01:33:56 -0500
Received: from mga14.intel.com ([192.55.52.115]:26665 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232142AbhBAGOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 01:14:00 -0500
IronPort-SDR: L5JEeIm/5mH8S7INYVga6ZhdtvcvpYFhjMabUJnOdzA/Q2dDAe/4qeS9l5+KW1zB5bnUpRIh3T
 P57nD5vddJ0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="179860909"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="179860909"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 22:08:33 -0800
IronPort-SDR: r1ErT8/wQkiHn/NHaR1Abc/aFAtArKTH2Czu8TnjTEMcVw27QBWL9NIJZi5UpiM0xrUejiVdHc
 BT/aandOt8qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="368980445"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga008.fm.intel.com with ESMTP; 31 Jan 2021 22:08:30 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com,
        alex.shi@linux.alibaba.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v14 11/11] selftests: kvm/x86: add test for pmu msr MSR_IA32_PERF_CAPABILITIES
Date:   Mon,  1 Feb 2021 14:01:52 +0800
Message-Id: <20210201060152.370069-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201060152.370069-1-like.xu@linux.intel.com>
References: <20210201051039.255478-1-like.xu@linux.intel.com>
 <20210201060152.370069-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test will check the effect of various CPUID settings on the
MSR_IA32_PERF_CAPABILITIES MSR, check that whatever user space writes
with KVM_SET_MSR is _not_ modified from the guest and can be retrieved
with KVM_GET_MSR, and check that invalid LBR formats are rejected.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/vmx_pmu_msrs_test.c  | 149 ++++++++++++++++++
 3 files changed, 151 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index ce8f4ad39684..28b71efe52a0 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -25,6 +25,7 @@
 /x86_64/vmx_set_nested_state_test
 /x86_64/vmx_tsc_adjust_test
 /x86_64/xss_msr_test
+/x86_64/vmx_pmu_msrs_test
 /demand_paging_test
 /dirty_log_test
 /dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index fe41c6a0fa67..cf8737828dd4 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -59,6 +59,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
 TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_msrs_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
new file mode 100644
index 000000000000..b3ad63e6ff12
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_msrs_test.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * VMX-pmu related msrs test
+ *
+ * Copyright (C) 2021 Intel Corporation
+ *
+ * Test to check the effect of various CPUID settings
+ * on the MSR_IA32_PERF_CAPABILITIES MSR, and check that
+ * whatever we write with KVM_SET_MSR is _not_ modified
+ * in the guest and test it can be retrieved with KVM_GET_MSR.
+ *
+ * Test to check that invalid LBR formats are rejected.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <sys/ioctl.h>
+
+#include "kvm_util.h"
+#include "vmx.h"
+
+#define VCPU_ID	      0
+
+#define X86_FEATURE_PDCM	(1<<15)
+#define PMU_CAP_FW_WRITES	(1ULL << 13)
+#define PMU_CAP_LBR_FMT		0x3f
+
+union cpuid10_eax {
+	struct {
+		unsigned int version_id:8;
+		unsigned int num_counters:8;
+		unsigned int bit_width:8;
+		unsigned int mask_length:8;
+	} split;
+	unsigned int full;
+};
+
+union perf_capabilities {
+	struct {
+		u64	lbr_format:6;
+		u64	pebs_trap:1;
+		u64	pebs_arch_reg:1;
+		u64	pebs_format:4;
+		u64	smm_freeze:1;
+		u64	full_width_write:1;
+		u64 pebs_baseline:1;
+		u64	perf_metrics:1;
+		u64	pebs_output_pt_available:1;
+		u64	anythread_deprecated:1;
+	};
+	u64	capabilities;
+};
+
+uint64_t rdmsr_on_cpu(uint32_t reg)
+{
+	uint64_t data;
+	int fd;
+	char msr_file[64];
+
+	sprintf(msr_file, "/dev/cpu/%d/msr", 0);
+	fd = open(msr_file, O_RDONLY);
+	if (fd < 0)
+		exit(KSFT_SKIP);
+
+	if (pread(fd, &data, sizeof(data), reg) != sizeof(data))
+		exit(KSFT_SKIP);
+
+	close(fd);
+	return data;
+}
+
+static void guest_code(void)
+{
+	wrmsr(MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_cpuid2 *cpuid;
+	struct kvm_cpuid_entry2 *entry_1_0;
+	struct kvm_cpuid_entry2 *entry_a_0;
+	bool pdcm_supported = false;
+	struct kvm_vm *vm;
+	int ret;
+	union cpuid10_eax eax;
+	union perf_capabilities host_cap;
+
+	host_cap.capabilities = rdmsr_on_cpu(MSR_IA32_PERF_CAPABILITIES);
+	host_cap.capabilities &= (PMU_CAP_FW_WRITES | PMU_CAP_LBR_FMT);
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	cpuid = kvm_get_supported_cpuid();
+
+	if (kvm_get_cpuid_max_basic() >= 0xa) {
+		entry_1_0 = kvm_get_supported_cpuid_index(1, 0);
+		entry_a_0 = kvm_get_supported_cpuid_index(0xa, 0);
+		pdcm_supported = entry_1_0 && !!(entry_1_0->ecx & X86_FEATURE_PDCM);
+		eax.full = entry_a_0->eax;
+	}
+	if (!pdcm_supported) {
+		print_skip("MSR_IA32_PERF_CAPABILITIES is not supported by the vCPU");
+		exit(KSFT_SKIP);
+	}
+	if (!eax.split.version_id) {
+		print_skip("PMU is not supported by the vCPU");
+		exit(KSFT_SKIP);
+	}
+
+	/* testcase 1, set capabilities when we have PDCM bit */
+	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_FW_WRITES);
+
+	/* check capabilities can be retrieved with KVM_GET_MSR */
+	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), PMU_CAP_FW_WRITES);
+
+	/* check whatever we write with KVM_SET_MSR is _not_ modified */
+	vcpu_run(vm, VCPU_ID);
+	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), PMU_CAP_FW_WRITES);
+
+	/* testcase 2, check valid LBR formats are accepted */
+	vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, 0);
+	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), 0);
+
+	vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, host_cap.lbr_format);
+	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), (u64)host_cap.lbr_format);
+
+	/* testcase 3, check invalid LBR format is rejected */
+	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
+	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
+
+	/* testcase 4, set capabilities when we don't have PDCM bit */
+	entry_1_0->ecx &= ~X86_FEATURE_PDCM;
+	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
+	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
+
+	/* testcase 5, set capabilities when we don't have PMU version bits */
+	entry_1_0->ecx |= X86_FEATURE_PDCM;
+	eax.split.version_id = 0;
+	entry_1_0->ecx = eax.full;
+	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_FW_WRITES);
+	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
+
+	vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, 0);
+	ASSERT_EQ(vcpu_get_msr(vm, VCPU_ID, MSR_IA32_PERF_CAPABILITIES), 0);
+
+	kvm_vm_free(vm);
+}
-- 
2.29.2

