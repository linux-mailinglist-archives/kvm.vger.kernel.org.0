Return-Path: <kvm+bounces-14110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 584D189EF42
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 11:53:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C17111F214AA
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 09:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4C8156C74;
	Wed, 10 Apr 2024 09:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="MzgsK1r5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3EC1591FF;
	Wed, 10 Apr 2024 09:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712742785; cv=none; b=TnwnumVMciZt0iMrvf25u6w/RI+qOerJYWfHOvfPBiu3n7dGBDsYZYQ9P9WnPjff3jRjlKEQabwHuXr221lpfjStYTbXdO+2Hau+6NJ3X+isZM+a+e1oPN+W8BDeV2mfqEs+TQKqdOoxObLNZSAhv43poK2s6O4vnAnTaNuleuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712742785; c=relaxed/simple;
	bh=It81dOo52cFJbkn4NDB0+r7mqrZyFVAFiA/lg+d00BQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u2WGho6dShClXbkjsCNN0i8V/spJxP9y5WDAtOiwXi4tFV8ueY/Hf+VMINVZjGcWWK8FC7SdbKtUJozvlU36zL/DWG9DNqZsUzcRcdJ+l32ChRndJmqLgusWz/XLa+hH2gOC1pGLpxr6LQ+0GWaP55X2QYIgHiqjrEg6xJDRIFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=MzgsK1r5; arc=none smtp.client-ip=207.171.188.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1712742784; x=1744278784;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nk49uWiNG81aU+f181ZTIvguocvswwWACQ+r8oTfxhM=;
  b=MzgsK1r5XFIZHuquzA4cpoPcvPJX7DZPv4/0SjovaIEd0XMYrWQ32MMz
   TWkdslQFnS4qaS4OKEDYYBooDkkzUtbg96stKjWfBVHM9RP6htl3JMiGn
   DV90m0mRIZLSL+bcxwLR5gIjERSX6eB5tx16D/8RN0XD0mvv4L8J4MCmH
   c=;
X-IronPort-AV: E=Sophos;i="6.07,190,1708387200"; 
   d="scan'208";a="718045443"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 09:52:58 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.10.100:59612]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.27.223:2525] with esmtp (Farcaster)
 id ab2b964f-2e82-492d-bcb0-d51fa296c30f; Wed, 10 Apr 2024 09:52:56 +0000 (UTC)
X-Farcaster-Flow-ID: ab2b964f-2e82-492d-bcb0-d51fa296c30f
Received: from EX19D033EUC001.ant.amazon.com (10.252.61.132) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Wed, 10 Apr 2024 09:52:56 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D033EUC001.ant.amazon.com (10.252.61.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Wed, 10 Apr 2024 09:52:55 +0000
Received: from dev-dsk-jalliste-1c-e3349c3e.eu-west-1.amazon.com
 (10.13.244.142) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28 via Frontend Transport; Wed, 10 Apr 2024 09:52:54 +0000
From: Jack Allister <jalliste@amazon.com>
To: <jalliste@amazon.com>
CC: <bp@alien8.de>, <corbet@lwn.net>, <dave.hansen@linux.intel.com>,
	<dwmw2@infradead.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<mingo@redhat.com>, <paul@xen.org>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <tglx@linutronix.de>, <x86@kernel.org>, Dongli Zhang
	<dongli.zhang@oracle.com>
Subject: [PATCH v2 2/2] KVM: selftests: Add KVM/PV clock selftest to prove timer correction
Date: Wed, 10 Apr 2024 09:52:44 +0000
Message-ID: <20240410095244.77109-3-jalliste@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240410095244.77109-1-jalliste@amazon.com>
References: <20240408220705.7637-1-jalliste@amazon.com>
 <20240410095244.77109-1-jalliste@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

A VM's KVM/PV clock has an inherent relationship to it's TSC (guest). When
either the host system live-updates or the VM is live-migrated this pairing
of the two clock sources should stay the same.

In reality this is not the case without some correction taking place. Two
new IOCTLs (KVM_GET_CLOCK_GUEST/KVM_SET_CLOCK_GUEST) can be utilized to
perform a correction on the PVTI (PV time information) structure held by
KVM to effectively fixup the kvmclock_offset prior to the guest VM resuming
in either a live-update/migration scenario.

This test proves that without the necessary fixup there is a perceived
change in the guest TSC & KVM/PV clock relationship before and after a LU/
LM takes place.

The following steps are made to verify there is a delta in the relationship
and that it can be corrected:

1. PVTI is sampled by guest at boot (let's call this PVTI0).
2. Induce a change in PVTI data (KVM_REQ_MASTERCLOCK_UPDATE).
3. PVTI is sampled by guest after change (PVTI1).
4. Correction is requested by usermode to KVM using PVTI0.
5. PVTI is sampled by guest after correction (PVTI2).

The guest the records a singular TSC reference point in time and uses it to
calculate 3 KVM clock values utilizing the 3 recorded PVTI prior. Let's
call each clock value CLK[0-2].

In a perfect world CLK[0-2] should all be the same value if the KVM clock
& TSC relationship is preserved across the LU/LM (or faked in this test),
however it is not.

A delta can be observed between CLK0-CLK1 due to KVM recalculating the PVTI
(and the inaccuracies associated with that). A delta of ~3500ns can be
observed if guest TSC scaling to half host TSC frequency is also enabled,
where as without scaling this is observed at ~180ns.

With the correction it should be possible to achieve a delta of ±1ns.

An option to enable guest TSC scaling is available via invoking the tester
with -s/--scale-tsc.

Example of the test output below:
* selftests: kvm: pvclock_test
* scaling tsc from 2999999KHz to 1499999KHz
* before=5038374946 uncorrected=5038371437 corrected=5038374945
* delta_uncorrected=3509 delta_corrected=1

Signed-off-by: Jack Allister <jalliste@amazon.com>
CC: David Woodhouse <dwmw2@infradead.org>
CC: Paul Durrant <paul@xen.org>
CC: Dongli Zhang <dongli.zhang@oracle.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/pvclock_test.c       | 192 ++++++++++++++++++
 2 files changed, 193 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pvclock_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 741c7dc16afc..02ee1205bbed 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -87,6 +87,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/pmu_counters_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/private_mem_conversions_test
 TEST_GEN_PROGS_x86_64 += x86_64/private_mem_kvm_exits_test
+TEST_GEN_PROGS_x86_64 += x86_64/pvclock_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
 TEST_GEN_PROGS_x86_64 += x86_64/smaller_maxphyaddr_emulation_test
diff --git a/tools/testing/selftests/kvm/x86_64/pvclock_test.c b/tools/testing/selftests/kvm/x86_64/pvclock_test.c
new file mode 100644
index 000000000000..376ffb730a53
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/pvclock_test.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright © 2024, Amazon.com, Inc. or its affiliates.
+ *
+ * Tests for pvclock API
+ * KVM_SET_CLOCK_GUEST/KVM_GET_CLOCK_GUEST
+ */
+#include <asm/pvclock.h>
+#include <asm/pvclock-abi.h>
+#include <sys/stat.h>
+#include <stdint.h>
+#include <stdio.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+enum {
+	STAGE_FIRST_BOOT,
+	STAGE_UNCORRECTED,
+	STAGE_CORRECTED
+};
+
+#define KVMCLOCK_GPA 0xc0000000ull
+#define KVMCLOCK_SIZE sizeof(struct pvclock_vcpu_time_info)
+
+static void trigger_pvti_update(vm_paddr_t pvti_pa)
+{
+	/*
+	 * We need a way to trigger KVM to update the fields
+	 * in the PV time info. The easiest way to do this is
+	 * to temporarily switch to the old KVM system time
+	 * method and then switch back to the new one.
+	 */
+	wrmsr(MSR_KVM_SYSTEM_TIME, pvti_pa | KVM_MSR_ENABLED);
+	wrmsr(MSR_KVM_SYSTEM_TIME_NEW, pvti_pa | KVM_MSR_ENABLED);
+}
+
+static void guest_code(vm_paddr_t pvti_pa)
+{
+	struct pvclock_vcpu_time_info *pvti_va =
+		(struct pvclock_vcpu_time_info *)pvti_pa;
+
+	struct pvclock_vcpu_time_info pvti_boot;
+	struct pvclock_vcpu_time_info pvti_uncorrected;
+	struct pvclock_vcpu_time_info pvti_corrected;
+	uint64_t cycles_boot;
+	uint64_t cycles_uncorrected;
+	uint64_t cycles_corrected;
+	uint64_t tsc_guest;
+
+	/*
+	 * Setup the KVMCLOCK in the guest & store the original
+	 * PV time structure that is used.
+	 */
+	wrmsr(MSR_KVM_SYSTEM_TIME_NEW, pvti_pa | KVM_MSR_ENABLED);
+	pvti_boot = *pvti_va;
+	GUEST_SYNC(STAGE_FIRST_BOOT);
+
+	/*
+	 * Trigger an update of the PVTI, if we calculate
+	 * the KVM clock using this structure we'll see
+	 * a delta from the TSC.
+	 */
+	trigger_pvti_update(pvti_pa);
+	pvti_uncorrected = *pvti_va;
+	GUEST_SYNC(STAGE_UNCORRECTED);
+
+	/*
+	 * The test should have triggered the correction by this
+	 * point in time. We have a copy of each of the PVTI structs
+	 * at each stage now.
+	 *
+	 * Let's sample the timestamp at a SINGLE point in time and
+	 * then calculate what the KVM clock would be using the PVTI
+	 * from each stage.
+	 *
+	 * Then return each of these values to the tester.
+	 */
+	pvti_corrected = *pvti_va;
+	tsc_guest = rdtsc();
+
+	cycles_boot = __pvclock_read_cycles(&pvti_boot, tsc_guest);
+	cycles_uncorrected = __pvclock_read_cycles(&pvti_uncorrected, tsc_guest);
+	cycles_corrected = __pvclock_read_cycles(&pvti_corrected, tsc_guest);
+
+	GUEST_SYNC_ARGS(STAGE_CORRECTED, cycles_boot, cycles_uncorrected,
+			cycles_corrected, 0);
+}
+
+static void run_test(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	struct pvclock_vcpu_time_info pvti_before;
+	uint64_t before, uncorrected, corrected;
+	int64_t delta_uncorrected, delta_corrected;
+	struct ucall uc;
+	uint64_t ucall_reason;
+
+	/* Loop through each stage of the test. */
+	while (true) {
+
+		/* Start/restart the running vCPU code. */
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		/* Retrieve and verify our stage. */
+		ucall_reason = get_ucall(vcpu, &uc);
+		TEST_ASSERT(ucall_reason == UCALL_SYNC,
+			    "Unhandled ucall reason=%lu",
+			    ucall_reason);
+
+		/* Run host specific code relating to stage. */
+		switch (uc.args[1]) {
+		case STAGE_FIRST_BOOT:
+			/* Store the KVM clock values before an update. */
+			vcpu_ioctl(vcpu, KVM_GET_CLOCK_GUEST, &pvti_before);
+
+			/* Sleep for a set amount of time to increase delta. */
+			sleep(5);
+			break;
+
+		case STAGE_UNCORRECTED:
+			/* Restore the KVM clock values. */
+			vcpu_ioctl(vcpu, KVM_SET_CLOCK_GUEST, &pvti_before);
+			break;
+
+		case STAGE_CORRECTED:
+			/* Query the clock information and verify delta. */
+			before = uc.args[2];
+			uncorrected = uc.args[3];
+			corrected = uc.args[4];
+
+			delta_uncorrected = before - uncorrected;
+			delta_corrected = before - corrected;
+
+			pr_info("before=%lu uncorrected=%lu corrected=%lu\n",
+				before, uncorrected, corrected);
+
+			pr_info("delta_uncorrected=%ld delta_corrected=%ld\n",
+				delta_uncorrected, delta_corrected);
+
+			TEST_ASSERT((delta_corrected <= 1) && (delta_corrected >= -1),
+				    "larger than expected delta detected = %ld", delta_corrected);
+			return;
+		}
+	}
+}
+
+static void configure_pvclock(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	unsigned int gpages;
+
+	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, KVMCLOCK_SIZE);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    KVMCLOCK_GPA, 1, gpages, 0);
+	virt_map(vm, KVMCLOCK_GPA, KVMCLOCK_GPA, gpages);
+
+	vcpu_args_set(vcpu, 1, KVMCLOCK_GPA);
+}
+
+static void configure_scaled_tsc(struct kvm_vcpu *vcpu)
+{
+	uint64_t tsc_khz;
+
+	tsc_khz =  __vcpu_ioctl(vcpu, KVM_GET_TSC_KHZ, NULL);
+	pr_info("scaling tsc from %ldKHz to %ldKHz\n", tsc_khz, tsc_khz / 2);
+	tsc_khz /= 2;
+	vcpu_ioctl(vcpu, KVM_SET_TSC_KHZ, (void *)tsc_khz);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	bool scale_tsc;
+
+	scale_tsc = argc > 1 && (!strncmp(argv[1], "-s", 3) ||
+				 !strncmp(argv[1], "--scale-tsc", 10));
+
+	TEST_REQUIRE(sys_clocksource_is_based_on_tsc());
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	configure_pvclock(vm, vcpu);
+
+	if (scale_tsc)
+		configure_scaled_tsc(vcpu);
+
+	run_test(vm, vcpu);
+
+	return 0;
+}
-- 
2.40.1


