Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AE623287A
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 02:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgG2X76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 19:59:58 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:35627 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbgG2X75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 19:59:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596067196; x=1627603196;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=lrgnz6hyzN61qfGpHESjCS1jOwC7pzfoZv/D3lwic2M=;
  b=KKznMBlvaux2WuEC8WQtS8qX1Si+XJyfHUcJ1re3jfrbQToguhfPNVPM
   BwEvv72cP/yfKWrN6vhAqbqg2QL4GtPhD5J7I07f7rCOFC87NQhlBvCuJ
   Tp0H/fcLpMOHAFFMgRIoR2nKd8BwIb5zOlA9jTO1lOAmYlTcifWy2AkJ1
   M=;
IronPort-SDR: DYXJMcqLW6N0CCV1a4y0cF1UgSaH2Yq0zDlKZZsG3uj+ukerwya5oVl4DPAFo6k5Ou7HYmmn5p
 dez3w52zJPvw==
X-IronPort-AV: E=Sophos;i="5.75,412,1589241600"; 
   d="scan'208";a="45045494"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 29 Jul 2020 23:59:54 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 73ECAA2D9C;
        Wed, 29 Jul 2020 23:59:50 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 29 Jul 2020 23:59:49 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.162.109) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 29 Jul 2020 23:59:46 +0000
From:   Alexander Graf <graf@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3] KVM: selftests: Add test for user space MSR handling
Date:   Thu, 30 Jul 2020 01:59:29 +0200
Message-ID: <20200729235929.379-4-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200729235929.379-1-graf@amazon.com>
References: <20200729235929.379-1-graf@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.109]
X-ClientProxiedBy: EX13D04UWA002.ant.amazon.com (10.43.160.31) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have the ability to handle MSRs from user space and also to
select which ones we do want to prevent in-kernel KVM code from handling,
let's add a selftest to show case and verify the API.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/user_msr_test.c      | 199 ++++++++++++++++++
 2 files changed, 200 insertions(+)
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
index 000000000000..304a534e75c7
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/user_msr_test.c
@@ -0,0 +1,199 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * tests for KVM_CAP_X86_USER_SPACE_MSR and KVM_ADD_MSR_ALLOWLIST
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
+static void populate_c0000000_write(struct kvm_msr_allowlist *range)
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
+			.flags = KVM_MSR_ALLOW_READ | KVM_MSR_ALLOW_WRITE,
+			.base = 0x00000000,
+			.nmsrs = KVM_MSR_ALLOWLIST_MAX_LEN * BITS_PER_BYTE,
+		},
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
+		.populate = populate_c0000000_write,
+	},
+};
+
+static void guest_code(void)
+{
+	/* This goes into the in-kernel emulation */
+	wrmsr(MSR_SYSCALL_MASK, 0);
+
+	/* This goes into user space emulation */
+	GUEST_ASSERT(rdmsr(MSR_SYSCALL_MASK) == MSR_SYSCALL_MASK);
+
+	/* This goes into user space emulation */
+	wrmsr(MSR_IA32_POWER_CTL, 0x1234);
+
+	/* This goes into the in-kernel emulation */
+	rdmsr(MSR_IA32_POWER_CTL);
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
+	run->msr.reply = 1;
+
+	msr_reads++;
+}
+
+static void handle_wrmsr(struct kvm_run *run)
+{
+	/* ignore */
+	run->msr.reply = 1;
+
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
+	rc = kvm_check_cap(KVM_CAP_ADD_MSR_ALLOWLIST);
+	TEST_ASSERT(rc, "KVM_CAP_ADD_MSR_ALLOWLIST is available");
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
+		vm_ioctl(vm, KVM_ADD_MSR_ALLOWLIST, range);
+	}
+
+	while (1) {
+		rc = _vcpu_run(vm, VCPU_ID);
+
+		TEST_ASSERT(rc == 0, "vcpu_run failed: %d\n", rc);
+
+		switch (run->exit_reason) {
+		case KVM_EXIT_RDMSR:
+			handle_rdmsr(run);
+			break;
+		case KVM_EXIT_WRMSR:
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
+	TEST_ASSERT(msr_reads == 1, "Handled 1 rdmsr in user space");
+	TEST_ASSERT(msr_writes == 1, "Handled 1 wrmsr in user space");
+
+done:
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



