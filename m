Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B1A23AF90
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 23:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgHCVOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 17:14:50 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:8711 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728662AbgHCVOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 17:14:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596489289; x=1628025289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=PqaES98GuoN0EaWLewBLTQukteeJnUgWf94ImTbzG/g=;
  b=DL7tWfkv+2IOQohHrPZBF21WDi2QwUGTj18XekMEFynqnYpmOMSJAmsy
   p0mhka+wq92mcwoqnG8WzM3ZPo1LtR/3WlJ/evZfUwSFzNnwUoPGC9Kw1
   HkWjzfg0CQCsUzPajJ/ek9o5RKVN2CajO9RxvIbr7yHXph9iU2XL86vGy
   M=;
IronPort-SDR: r2vLdBlFh+RGZr8Lt3n0XnEBBRXR7n8a82PI+BoMqpjujuFgKi74vIi2aBMR8xe8nQDDFJltZ6
 PwH+I9psYXJw==
X-IronPort-AV: E=Sophos;i="5.75,431,1589241600"; 
   d="scan'208";a="45777061"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 03 Aug 2020 21:14:47 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id 2AA30A1836;
        Mon,  3 Aug 2020 21:14:45 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 3 Aug 2020 21:14:44 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.161.145) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 3 Aug 2020 21:14:41 +0000
From:   Alexander Graf <graf@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 3/3] KVM: selftests: Add test for user space MSR handling
Date:   Mon, 3 Aug 2020 23:14:23 +0200
Message-ID: <20200803211423.29398-4-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200803211423.29398-1-graf@amazon.com>
References: <20200803211423.29398-1-graf@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D36UWB001.ant.amazon.com (10.43.161.84) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
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
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/user_msr_test.c      | 221 ++++++++++++++++++
 2 files changed, 222 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/user_msr_test.c

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
index 000000000000..7b149424690d
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/user_msr_test.c
@@ -0,0 +1,221 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * tests for KVM_CAP_X86_USER_SPACE_MSR and KVM_X86_ADD_MSR_ALLOWLIST
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
+u32 msr_reads, msr_writes;
+
+struct range_desc {
+	struct kvm_msr_allowlist allow;
+	void (*populate)(struct kvm_msr_allowlist *range);
+};
+
+static void populate_c0000000_read(struct kvm_msr_allowlist *range)
+{
+	u8 *bitmap = range->bitmap;
+	u32 idx = MSR_SYSCALL_MASK & (KVM_MSR_ALLOWLIST_MAX_LEN - 1);
+
+	bitmap[idx / 8] &= ~(1 << (idx % 8));
+}
+
+static void populate_00000000_write(struct kvm_msr_allowlist *range)
+{
+	u8 *bitmap = range->bitmap;
+	u32 idx = MSR_IA32_POWER_CTL & (KVM_MSR_ALLOWLIST_MAX_LEN - 1);
+
+	bitmap[idx / 8] &= ~(1 << (idx % 8));
+}
+
+struct range_desc ranges[] = {
+	{
+		.allow = {
+			.flags = KVM_MSR_ALLOW_READ,
+			.base = 0x00000000,
+			.nmsrs = KVM_MSR_ALLOWLIST_MAX_LEN * BITS_PER_BYTE,
+		},
+	}, {
+		.allow = {
+			.flags = KVM_MSR_ALLOW_WRITE,
+			.base = 0x00000000,
+			.nmsrs = KVM_MSR_ALLOWLIST_MAX_LEN * BITS_PER_BYTE,
+		},
+		.populate = populate_00000000_write,
+	}, {
+		.allow = {
+			.flags = KVM_MSR_ALLOW_READ | KVM_MSR_ALLOW_WRITE,
+			.base = 0x40000000,
+			.nmsrs = KVM_MSR_ALLOWLIST_MAX_LEN * BITS_PER_BYTE,
+		},
+	}, {
+		.allow = {
+			.flags = KVM_MSR_ALLOW_READ,
+			.base = 0xc0000000,
+			.nmsrs = KVM_MSR_ALLOWLIST_MAX_LEN * BITS_PER_BYTE,
+		},
+		.populate = populate_c0000000_read,
+	}, {
+		.allow = {
+			.flags = KVM_MSR_ALLOW_WRITE,
+			.base = 0xc0000000,
+			.nmsrs = KVM_MSR_ALLOWLIST_MAX_LEN * BITS_PER_BYTE,
+		},
+	},
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
+	} else {
+		GUEST_ASSERT(rdmsr(MSR_SYSCALL_MASK) != MSR_SYSCALL_MASK);
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
+	 * Disable allow listing, so that the kernel
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
+		vm_ioctl(vm, KVM_X86_CLEAR_MSR_ALLOWLIST, NULL);
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
+}
+
+static void handle_wrmsr(struct kvm_run *run)
+{
+	/* ignore */
+	msr_writes++;
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
+	int i;
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
+	rc = kvm_check_cap(KVM_CAP_X86_MSR_ALLOWLIST);
+	TEST_ASSERT(rc, "KVM_CAP_X86_MSR_ALLOWLIST is available");
+
+	/* Set up MSR allowlist */
+	for (i = 0; i < ARRAY_SIZE(ranges); i++) {
+		struct kvm_msr_allowlist *a = &ranges[i].allow;
+		u32 bitmap_size = a->nmsrs / BITS_PER_BYTE;
+		struct kvm_msr_allowlist *range = malloc(sizeof(*a) + bitmap_size);
+
+		TEST_ASSERT(range, "range alloc failed (%ld bytes)\n", sizeof(*a) + bitmap_size);
+
+		*range = *a;
+
+		/* Allow everything by default */
+		memset(range->bitmap, 0xff, bitmap_size);
+
+		if (ranges[i].populate)
+			ranges[i].populate(range);
+
+		vm_ioctl(vm, KVM_X86_ADD_MSR_ALLOWLIST, range);
+	}
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
+	TEST_ASSERT(msr_reads == 1, "Handled 1 rdmsr in user space");
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



