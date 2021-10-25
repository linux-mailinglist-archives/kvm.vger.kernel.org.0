Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FC543A496
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 22:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbhJYU1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 16:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235388AbhJYU1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 16:27:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D067C069662
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 13:13:19 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a20-20020a25ae14000000b005c1961310aeso2940535ybj.3
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 13:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WT2FUqpTjJpqqDcLvsyDTMaTG3w5Wil3Dn+SC0moScM=;
        b=a75Kgfjv2TPAV9RjQ2s2XNJGt8nF3ljPUvsp+/k/vtSfmH80y24sfhjyI9OQkGUPkp
         C5Hq+tL45dWIq+DAhjBst38JWj7GdtnrToXRkw0Xpjoj5vGe7LovgANzWFTTjoo/gxxv
         IOov4bTo0CbG0uJRI1xhs4ALrXT3het05GyGoCjh8zWsmWEau2T8FseVCKdULSwlN2xR
         2VLFUsS003qbzT+teL4ndL9s9dNC/hyWwr5T/B0u5ZwOObSMPEjGK6suhPpG0cMoX0FA
         0Lj6viUMtpJUN7a2dpSX06ducs7cPb1EM38+EB4i0k2BhX/jMZc8dsFhSgVTcxBtBXP/
         FAPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WT2FUqpTjJpqqDcLvsyDTMaTG3w5Wil3Dn+SC0moScM=;
        b=IoGQ5EnRr8YHFqtgns29GLDq8jPI/fHXmPNiMo34mai2bTvcx45JdrsH0Nf5Uc5oFm
         te0rxn6DFJmH0D1m/BKk/6XPBIVQ2rPbQbnU7MWD3O2bycH9vSS+p3/TzSgdqSqoofMi
         knB8XFXjK71GIo3R9BIgK8DWjcaybqwdyh56nHXEwpWj463A5Re6bVYUBTHQQktj3gjw
         x2C4VgARrazlF1+SrjBMIg4amLY7IecTG3hzVNP2RnoYJZDprbHvgNzfneTQfY7HCwIq
         l2J/Tqr5+gHpGddhXm9rdg5K3oJd64d6Wohy9oNQ5gNBJORAIgrktrSjAX9Php7174Wf
         Tv/Q==
X-Gm-Message-State: AOAM5336MGIsqQHGRzcy7tJJMrf2NilIvG5FA1ju/nImButummzdAA6M
        U1jJ3pXgKFZuaf8QLtdPFLUwXXLFC5U=
X-Google-Smtp-Source: ABdhPJwmrxYKbZaZpjbK4FHOL9LJURoUqAEjHP7X6KNVoCB/s+b/txvdyiSvR3NxNRCL1+BMoy4HQCxD6DA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:ffbb:dc28:15d8:6cdc])
 (user=seanjc job=sendgmr) by 2002:a25:a169:: with SMTP id z96mr20186749ybh.491.1635192798506;
 Mon, 25 Oct 2021 13:13:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 25 Oct 2021 13:13:11 -0700
In-Reply-To: <20211025201311.1881846-1-seanjc@google.com>
Message-Id: <20211025201311.1881846-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211025201311.1881846-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH 2/2] KVM: selftests: Add test to verify KVM doesn't explode on
 "bad" I/O
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an x86 selftest to verify that KVM doesn't WARN or otherwise explode
if userspace modifies RCX during a userspace exit to handle string I/O.
This is a regression test for a user-triggerable WARN introduced by
commit 3b27de271839 ("KVM: x86: split the two parts of emulator_pio_in").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/userspace_io_test.c  | 114 ++++++++++++++++++
 3 files changed, 116 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_io_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index b8dbabe24ac2..691262c7b122 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -27,6 +27,7 @@
 /x86_64/svm_int_ctl_test
 /x86_64/sync_regs_test
 /x86_64/tsc_msrs_test
+/x86_64/userspace_io_test
 /x86_64/userspace_msr_exit_test
 /x86_64/vmx_apic_access_test
 /x86_64/vmx_close_while_nested_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index d1774f461393..1a611cb80c4e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -58,6 +58,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_int_ctl_test
 TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
+TEST_GEN_PROGS_x86_64 += x86_64/userspace_io_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_apic_access_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_io_test.c b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
new file mode 100644
index 000000000000..e4bef2e05686
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/userspace_io_test.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
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
+#define VCPU_ID			1
+
+static void guest_ins_port80(uint8_t *buffer, unsigned int count)
+{
+	unsigned long end;
+
+	if (count == 2)
+		end = (unsigned long)buffer + 1;
+	else
+		end = (unsigned long)buffer + 8192;
+
+	asm volatile("cld; rep; insb" : "+D"(buffer), "+c"(count) : "d"(0x80) : "memory");
+	GUEST_ASSERT_1(count == 0, count);
+	GUEST_ASSERT_2((unsigned long)buffer == end, buffer, end);
+}
+
+static void guest_code(void)
+{
+	uint8_t buffer[8192];
+	int i;
+
+	/*
+	 * Special case tests.  main() will adjust RCX 2 => 1 and 3 => 8192 to
+	 * test that KVM doesn't explode when userspace modifies the "count" on
+	 * a userspace I/O exit.  KVM isn't required to play nice with the I/O
+	 * itself as KVM doesn't support manipulating the count, it just needs
+	 * to not explode or overflow a buffer.
+	 */
+	guest_ins_port80(buffer, 2);
+	guest_ins_port80(buffer, 3);
+
+	/* Verify KVM fills the buffer correctly when not stuffing RCX. */
+	memset(buffer, 0, sizeof(buffer));
+	guest_ins_port80(buffer, 8192);
+	for (i = 0; i < 8192; i++)
+		GUEST_ASSERT_2(buffer[i] == 0xaa, i, buffer[i]);
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_regs regs;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	int rc;
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	run = vcpu_state(vm, VCPU_ID);
+
+	memset(&regs, 0, sizeof(regs));
+
+	while (1) {
+		rc = _vcpu_run(vm, VCPU_ID);
+
+		TEST_ASSERT(rc == 0, "vcpu_run failed: %d\n", rc);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Unexpected exit reason: %u (%s),\n",
+			    run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		if (get_ucall(vm, VCPU_ID, &uc))
+			break;
+
+		TEST_ASSERT(run->io.port == 0x80,
+			    "Expected I/O at port 0x80, got port 0x%x\n", run->io.port);
+
+		/*
+		 * Modify the rep string count in RCX: 2 => 1 and 3 => 8192.
+		 * Note, this abuses KVM's batching of rep string I/O to avoid
+		 * getting stuck in an infinite loop.  That behavior isn't in
+		 * scope from a testing perspective as it's not ABI in any way,
+		 * i.e. it really is abusing internal KVM knowledge.
+		 */
+		vcpu_regs_get(vm, VCPU_ID, &regs);
+		if (regs.rcx == 2)
+			regs.rcx = 1;
+		if (regs.rcx == 3)
+			regs.rcx = 8192;
+		memset((void *)run + run->io.data_offset, 0xaa, 4096);
+		vcpu_regs_set(vm, VCPU_ID, &regs);
+	}
+
+	switch (uc.cmd) {
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		TEST_FAIL("%s at %s:%ld : argN+1 = 0x%lx, argN+2 = 0x%lx",
+			  (const char *)uc.args[0], __FILE__, uc.args[1],
+			  uc.args[2], uc.args[3]);
+	default:
+		TEST_FAIL("Unknown ucall %lu", uc.cmd);
+	}
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.33.0.1079.g6e70778dc9-goog

