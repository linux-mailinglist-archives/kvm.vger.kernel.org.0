Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45322732FF5
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 13:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344974AbjFPLfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 07:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344428AbjFPLfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 07:35:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7542330C6;
        Fri, 16 Jun 2023 04:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686915306; x=1718451306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d11C85anzJrQsnoOC+MkHmFIOWsBGErCjceGs/poHZk=;
  b=g+Ppoh+CqYsT6G8aHKE6UcXUYXLjPKtHZo5erlwVv/FXaY0zTlrjvGzc
   J4YerbEh/5erUGO3f/kKhoKoQGiHiVXeW008BuTddcmuj+yPoFITdKqwH
   JAya3G1ZiG+XlE1wXKIcbU+nTH4rYhVVIzap783pTleKHXowg/Yp87roN
   iRSSc6UrHwGKGvmh/XejLTQDmYuYAtBcVl+R3qy4SOapy70vJLbSO9qzz
   1LAzvmf2UTnnkeCeoiLoqFSj4SeSg/dLh1KT8Y6nfvBC4tTGcBZfHPuBb
   7ggem1Mwayc/RkihfzidjWUmWxyQvo6PZzRlL8eunOk0dRy4HuyUZqF2d
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="445574807"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="445574807"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 04:35:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="782872388"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="782872388"
Received: from youzhiji-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.249.173.213])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 04:35:03 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH 4/4] KVM: selftests: Add test case for guest and host LBR preemption
Date:   Fri, 16 Jun 2023 19:33:53 +0800
Message-Id: <20230616113353.45202-5-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230616113353.45202-1-xiong.y.zhang@intel.com>
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When guest access LBR msr at the first time, kvm will create a vLBR event,
vLBR event joins perf scheduler and occupy physical LBR for guest usage.
Once vLBR event is active and own LBR, guest could access LBR msr.

But vLBR event is per process pinned event, perf has higher priority event:
per cpu pinned LBR event, perf has lower priority events also: per cpu LBR
event and per process LBR event.
So if host doesn't have higher priority per cpu pinned LBR event, vLBR
event could occupy physical LBR always. But once per cpu pinned LBR event
is active, vLBR event couldn't be active anymore, then guest couldn't
access LBR msr.

This commit adds test case to cover guest and host lbr contend.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/ucall_common.h      |  17 ++
 .../kvm/x86_64/pmu_event_filter_test.c        |  16 --
 .../kvm/x86_64/vmx_pmu_lbr_contend.c          | 171 ++++++++++++++++++
 4 files changed, 189 insertions(+), 16 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_pmu_lbr_contend.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4761b768b773..422bbc16ba2a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -100,6 +100,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_exception_with_invalid_guest_state
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_lbr_contend
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 1a6aaef5ccae..c1bb0cacf390 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -35,6 +35,23 @@ void ucall(uint64_t cmd, int nargs, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
 
+/*
+ * Run the VM to the next GUEST_SYNC(value), and return the value passed
+ * to the sync. Any other exit from the guest is fatal.
+ */
+static inline uint64_t run_vcpu_to_sync(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+	get_ucall(vcpu, &uc);
+	TEST_ASSERT(uc.cmd == UCALL_SYNC,
+		    "Received ucall other than UCALL_SYNC: %lu", uc.cmd);
+
+	return uc.args[1];
+}
+
 /*
  * Perform userspace call without any associated data.  This bare call avoids
  * allocating a ucall struct, which can be useful if the atomic operations in
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 40507ed9fe8a..8c68029cfb4b 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -177,22 +177,6 @@ static void amd_guest_code(void)
 	}
 }
 
-/*
- * Run the VM to the next GUEST_SYNC(value), and return the value passed
- * to the sync. Any other exit from the guest is fatal.
- */
-static uint64_t run_vcpu_to_sync(struct kvm_vcpu *vcpu)
-{
-	struct ucall uc;
-
-	vcpu_run(vcpu);
-	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
-	get_ucall(vcpu, &uc);
-	TEST_ASSERT(uc.cmd == UCALL_SYNC,
-		    "Received ucall other than UCALL_SYNC: %lu", uc.cmd);
-	return uc.args[1];
-}
-
 static void run_vcpu_and_sync_pmc_results(struct kvm_vcpu *vcpu)
 {
 	uint64_t r;
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_lbr_contend.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_lbr_contend.c
new file mode 100644
index 000000000000..a6a793f08515
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_lbr_contend.c
@@ -0,0 +1,171 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test for host and guest LBR preemption
+ *
+ * Copyright (C) 2021 Intel Corporation
+ *
+ */
+
+#define _GNU_SOURCEGG
+
+#include <linux/perf_event.h>
+#include <sys/syscall.h>
+#include <sys/sysinfo.h>
+#include <unistd.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+static void create_perf_events(int *fds, int cpu_num, bool pinned)
+{
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_HARDWARE,
+		.size = sizeof(attr),
+		.config = PERF_COUNT_HW_CPU_CYCLES,
+		.sample_type = PERF_SAMPLE_BRANCH_STACK,
+		.sample_period = 1000,
+		.pinned = pinned,
+		.branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
+				      PERF_SAMPLE_BRANCH_USER |
+				      PERF_SAMPLE_BRANCH_KERNEL,
+	};
+	int i;
+
+	for (i = 0; i < cpu_num; i++) {
+		fds[i] = syscall(__NR_perf_event_open, &attr, -1, i, -1, PERF_FLAG_FD_CLOEXEC);
+		TEST_ASSERT(fds[i] != -1, "Failed to create lbr event on cpu%d", i);
+	}
+}
+
+static void release_perf_events(int *fds, int cpu_num)
+{
+	int i;
+
+	for (i = 0; i < cpu_num; i++)
+		close(fds[i]);
+}
+
+#define PERF_CAP_LBR_FMT_MASK  0x1F
+
+#define LBR_NOT_SUPPORTED  0xFFFE
+#define LBR_MSR_WRITE_ERROR 0xFFFD
+
+#define LBR_MODE_CHECK_PASS 0x0
+#define LBR_MSR_WRITE_SUCC  0x1
+
+static bool check_lbr_msr(void)
+{
+	uint64_t v, old_val;
+
+	old_val = rdmsr(MSR_LBR_TOS);
+
+	v  = old_val ^ 0x3UL;
+
+	wrmsr(MSR_LBR_TOS, v);
+	if (rdmsr(MSR_LBR_TOS) != v)
+		return false;
+
+	wrmsr(MSR_LBR_TOS, old_val);
+	if (rdmsr(MSR_LBR_TOS) != old_val)
+		return false;
+
+	return true;
+}
+
+static void guest_code(void)
+{
+	uint64_t v;
+
+	v = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+	if ((v & PERF_CAP_LBR_FMT_MASK) == 0)
+		GUEST_SYNC(LBR_NOT_SUPPORTED);
+
+	GUEST_SYNC(LBR_MODE_CHECK_PASS);
+
+	while (1) {
+		if (!check_lbr_msr()) {
+			GUEST_SYNC(LBR_MSR_WRITE_ERROR);
+			continue;
+		}
+
+		/* Enable LBR to avoid KVM recyling LBR. */
+		 v = rdmsr(MSR_IA32_DEBUGCTLMSR);
+		 v |= DEBUGCTLMSR_LBR;
+		 wrmsr(MSR_IA32_DEBUGCTLMSR, v);
+
+		GUEST_SYNC(LBR_MSR_WRITE_SUCC);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	int *fds, ncpus;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint64_t r;
+
+	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
+	TEST_REQUIRE(host_cpu_is_intel);
+	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION));
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	r = run_vcpu_to_sync(vcpu);
+	TEST_ASSERT(r == LBR_MODE_CHECK_PASS,
+		    "LBR format in guest PERF_CAP msr isn't correct");
+
+	ncpus = get_nprocs();
+	fds = malloc(sizeof(int) * ncpus);
+	TEST_ASSERT(fds != NULL, "Failed to create fds for all cpus");
+
+	/* Create per cpu pinned LBR event, then it will own LBR. */
+	create_perf_events(fds, ncpus, true);
+
+	/* Since LBR is owned by per cpu pinned LBR event, guest couldn't get it,
+	 * so guest couldn't access LBR_TOS msr.
+	 */
+	r = run_vcpu_to_sync(vcpu);
+	TEST_ASSERT(r == LBR_MSR_WRITE_ERROR,
+		    "1. Unexpected successfully read/write guest LBR_TO msr");
+
+	release_perf_events(fds, ncpus);
+
+	/* Since per cpu pinned event is closed and LBR is free, guest could get it,
+	 * so guest could access LBR_TOS msr.
+	 */
+	r = run_vcpu_to_sync(vcpu);
+	TEST_ASSERT(r == LBR_MSR_WRITE_SUCC,
+		    "2. Failed to read/write guest LBR_TO msr");
+
+	/* Create per cpu LBR event, its priority is lower than vLBR event, and it
+	 *  couldn't get LBR back from vLBR
+	 */
+	create_perf_events(fds, ncpus, false);
+
+	/* LBR is still owned by guest, So guest could access LBR_TOS successfully. */
+	r = run_vcpu_to_sync(vcpu);
+	TEST_ASSERT(r == LBR_MSR_WRITE_SUCC,
+		    "3. Failed read/write guest LBR_TO msr");
+
+	release_perf_events(fds, ncpus);
+
+	/* Create per cpu pinned LBR event, its priority is higher than vLBR event,
+	 * so it will get LBR back from vLBR.
+	 */
+	create_perf_events(fds, ncpus, true);
+
+	/* LBR is preepmted by per cpu pinned LBR event, guest couldn't access
+	 * LBR_TOS msr.
+	 */
+	r = run_vcpu_to_sync(vcpu);
+	TEST_ASSERT(r == LBR_MSR_WRITE_ERROR,
+		    "4. Unexpected successfully read/write guest LBR_TO msr");
+
+	release_perf_events(fds, ncpus);
+
+	kvm_vm_free(vm);
+
+	free(fds);
+
+	return 0;
+}
-- 
2.25.1

