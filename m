Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6463C25ABAD
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 15:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgIBNEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 09:04:34 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:24405 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgIBNAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 09:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599051623; x=1630587623;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k+hug0ZlhKqMxA8EVU4e5NA4JdPsxoa0Hicghm7CCIQ=;
  b=DLUyT/RM+0hSr9xT8KsSIAMliJyqX1hxviNr+eStr7kXSMaIjSdHSWyQ
   o6VLkFE9Eee8GiU1ypEpzXzclyqL70/TyIfm2zxTQ3Gws9O6oU0kifJC9
   5Wxpjt+fVKpfcc+LofsVJVCGBVEIkaT+1Ak4wHHf52+3GzG26EI7jGGlu
   s=;
X-IronPort-AV: E=Sophos;i="5.76,383,1592870400"; 
   d="scan'208";a="51551987"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 02 Sep 2020 13:00:20 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id 63DD3A1833;
        Wed,  2 Sep 2020 13:00:18 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Sep 2020 13:00:17 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.160.215) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Sep 2020 13:00:14 +0000
From:   Alexander Graf <graf@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 7/7] KVM: selftests: Add test for user space MSR handling
Date:   Wed, 2 Sep 2020 14:59:35 +0200
Message-ID: <20200902125935.20646-8-graf@amazon.com>
X-Mailer: git-send-email 2.28.0.394.ge197136389
In-Reply-To: <20200902125935.20646-1-graf@amazon.com>
References: <20200902125935.20646-1-graf@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.215]
X-ClientProxiedBy: EX13D05UWC004.ant.amazon.com (10.43.162.223) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have the ability to handle MSRs from user space and also to
select which ones we do want to prevent in-kernel KVM code from handling,
let's add a selftest to show case and verify the API.

Signed-off-by: Alexander Graf <graf@amazon.com>

---

v2 -> v3:

  - s/KVM_CAP_ADD_MSR_ALLOWLIST/KVM_CAP_X86_MSR_ALLOWLIST/g
  - Add test to clear whitelist
  - Adjust to reply-less API
  - Fix asserts
  - Actually trap on MSR_IA32_POWER_CTL writes

v5 -> v6:

  - Adapt to new ioctl API
  - Check for passthrough MSRs
  - Check for filter exit reason
  - Add .gitignore
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/user_msr_test.c      | 224 ++++++++++++++++++
 3 files changed, 226 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/user_msr_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 452787152748..307ceaadbbb9 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -11,6 +11,7 @@
 /x86_64/set_sregs_test
 /x86_64/smm_test
 /x86_64/state_test
+/x86_64/user_msr_test
 /x86_64/vmx_preemption_timer_test
 /x86_64/svm_vmcall_test
 /x86_64/sync_regs_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4a166588d99f..80d5c348354c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -55,6 +55,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
+TEST_GEN_PROGS_x86_64 += x86_64/user_msr_test
 TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/user_msr_test.c b/tools/testing/selftests/kvm/x86_64/user_msr_test.c
new file mode 100644
index 000000000000..5882cf032c97
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/user_msr_test.c
@@ -0,0 +1,224 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * tests for KVM_CAP_X86_USER_SPACE_MSR and KVM_X86_SET_MSR_FILTER
+ *
+ * Copyright (C) 2020, Amazon Inc.
+ *
+ * This is a functional test to verify that we can deflect MSR events
+ * into user space.
+ */
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "processor.h"
+
+#define VCPU_ID                  5
+
+static u32 msr_reads, msr_writes;
+
+static u8 bitmap_00000000[KVM_MSR_FILTER_MAX_BITMAP_SIZE];
+static u8 bitmap_00000000_write[KVM_MSR_FILTER_MAX_BITMAP_SIZE];
+static u8 bitmap_40000000[KVM_MSR_FILTER_MAX_BITMAP_SIZE];
+static u8 bitmap_c0000000[KVM_MSR_FILTER_MAX_BITMAP_SIZE];
+static u8 bitmap_c0000000_read[KVM_MSR_FILTER_MAX_BITMAP_SIZE];
+
+static void deny_msr(uint8_t *bitmap, u32 msr)
+{
+	u32 idx = msr & (KVM_MSR_FILTER_MAX_BITMAP_SIZE - 1);
+
+	bitmap[idx / 8] &= ~(1 << (idx % 8));
+}
+
+static void prepare_bitmaps(void)
+{
+	memset(bitmap_00000000, 0xff, sizeof(bitmap_00000000));
+	memset(bitmap_00000000_write, 0xff, sizeof(bitmap_00000000_write));
+	memset(bitmap_40000000, 0xff, sizeof(bitmap_40000000));
+	memset(bitmap_c0000000, 0xff, sizeof(bitmap_c0000000));
+	memset(bitmap_c0000000_read, 0xff, sizeof(bitmap_c0000000_read));
+
+	deny_msr(bitmap_00000000_write, MSR_IA32_POWER_CTL);
+	deny_msr(bitmap_c0000000_read, MSR_SYSCALL_MASK);
+	deny_msr(bitmap_c0000000_read, MSR_GS_BASE);
+}
+
+struct kvm_msr_filter filter = {
+	.flags = KVM_MSR_FILTER_DEFAULT_DENY,
+	.ranges = {
+		{
+			.flags = KVM_MSR_FILTER_READ,
+			.base = 0x00000000,
+			.nmsrs = KVM_MSR_FILTER_MAX_BITMAP_SIZE * BITS_PER_BYTE,
+			.bitmap = bitmap_00000000,
+		}, {
+			.flags = KVM_MSR_FILTER_WRITE,
+			.base = 0x00000000,
+			.nmsrs = KVM_MSR_FILTER_MAX_BITMAP_SIZE * BITS_PER_BYTE,
+			.bitmap = bitmap_00000000_write,
+		}, {
+			.flags = KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE,
+			.base = 0x40000000,
+			.nmsrs = KVM_MSR_FILTER_MAX_BITMAP_SIZE * BITS_PER_BYTE,
+			.bitmap = bitmap_40000000,
+		}, {
+			.flags = KVM_MSR_FILTER_READ,
+			.base = 0xc0000000,
+			.nmsrs = KVM_MSR_FILTER_MAX_BITMAP_SIZE * BITS_PER_BYTE,
+			.bitmap = bitmap_c0000000_read,
+		}, {
+			.flags = KVM_MSR_FILTER_WRITE,
+			.base = 0xc0000000,
+			.nmsrs = KVM_MSR_FILTER_MAX_BITMAP_SIZE * BITS_PER_BYTE,
+			.bitmap = bitmap_c0000000,
+		},
+	},
+};
+
+struct kvm_msr_filter no_filter = {
+	.flags = KVM_MSR_FILTER_DEFAULT_ALLOW,
+};
+
+static void guest_msr_calls(bool trapped)
+{
+	/* This goes into the in-kernel emulation */
+	wrmsr(MSR_SYSCALL_MASK, 0);
+
+	if (trapped) {
+		/* This goes into user space emulation */
+		GUEST_ASSERT(rdmsr(MSR_SYSCALL_MASK) == MSR_SYSCALL_MASK);
+		GUEST_ASSERT(rdmsr(MSR_GS_BASE) == MSR_GS_BASE);
+	} else {
+		GUEST_ASSERT(rdmsr(MSR_SYSCALL_MASK) != MSR_SYSCALL_MASK);
+		GUEST_ASSERT(rdmsr(MSR_GS_BASE) != MSR_GS_BASE);
+	}
+
+	/* If trapped == true, this goes into user space emulation */
+	wrmsr(MSR_IA32_POWER_CTL, 0x1234);
+
+	/* This goes into the in-kernel emulation */
+	rdmsr(MSR_IA32_POWER_CTL);
+}
+
+static void guest_code(void)
+{
+	guest_msr_calls(true);
+
+	/*
+	 * Disable msr filtering, so that the kernel
+	 * handles everything in the next round
+	 */
+	GUEST_SYNC(0);
+
+	guest_msr_calls(false);
+
+	GUEST_DONE();
+}
+
+static int handle_ucall(struct kvm_vm *vm)
+{
+	struct ucall uc;
+
+	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	case UCALL_ABORT:
+		TEST_FAIL("Guest assertion not met");
+		break;
+	case UCALL_SYNC:
+		vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &no_filter);
+		break;
+	case UCALL_DONE:
+		return 1;
+	default:
+		TEST_FAIL("Unknown ucall %lu", uc.cmd);
+	}
+
+	return 0;
+}
+
+static void handle_rdmsr(struct kvm_run *run)
+{
+	run->msr.data = run->msr.index;
+	msr_reads++;
+
+	if (run->msr.index == MSR_SYSCALL_MASK ||
+	    run->msr.index == MSR_GS_BASE) {
+		TEST_ASSERT(run->msr.reason != KVM_MSR_EXIT_REASON_FILTER,
+			    "MSR read trap w/o access fault");
+	}
+}
+
+static void handle_wrmsr(struct kvm_run *run)
+{
+	/* ignore */
+	msr_writes++;
+
+	if (run->msr.index == MSR_IA32_POWER_CTL) {
+		TEST_ASSERT(run->msr.data != 0x1234,
+			    "MSR data for MSR_IA32_POWER_CTL incorrect");
+		TEST_ASSERT(run->msr.reason != KVM_MSR_EXIT_REASON_FILTER,
+			    "MSR_IA32_POWER_CTL trap w/o access fault");
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_X86_USER_SPACE_MSR,
+		.args[0] = 1,
+	};
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	int rc;
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+	run = vcpu_state(vm, VCPU_ID);
+
+	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
+	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
+	vm_enable_cap(vm, &cap);
+
+	rc = kvm_check_cap(KVM_CAP_X86_MSR_FILTER);
+	TEST_ASSERT(rc, "KVM_CAP_X86_MSR_FILTER is available");
+
+	prepare_bitmaps();
+	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter);
+
+	while (1) {
+		rc = _vcpu_run(vm, VCPU_ID);
+
+		TEST_ASSERT(rc == 0, "vcpu_run failed: %d\n", rc);
+
+		switch (run->exit_reason) {
+		case KVM_EXIT_X86_RDMSR:
+			handle_rdmsr(run);
+			break;
+		case KVM_EXIT_X86_WRMSR:
+			handle_wrmsr(run);
+			break;
+		case KVM_EXIT_IO:
+			if (handle_ucall(vm))
+				goto done;
+			break;
+		}
+
+	}
+
+done:
+	TEST_ASSERT(msr_reads == 2, "Handled 2 rdmsr in user space");
+	TEST_ASSERT(msr_writes == 1, "Handled 1 wrmsr in user space");
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



