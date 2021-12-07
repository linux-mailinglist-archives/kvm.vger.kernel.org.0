Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB4146C3A9
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 20:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbhLGTdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 14:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235211AbhLGTdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 14:33:47 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5824CC061748
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 11:30:17 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id e10-20020a17090301ca00b00141fbe2569dso2927044plh.14
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 11:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yOTsGfuBFPVTmUTAuefFnl10Yv0MH16ucMFZN1z9orU=;
        b=OMVhDdZY48D0tSmTxqFMCLIq+xtxd0M4gTwOpwfQJK3NpvP2gV4fVCy+w08G81lXk3
         TRtqmUY3MjyUNnObdWLcQcjLfkVewn/R8Bukf26WLE/al5jKOCt5xaYMFVti4muN6Mok
         0WDD4XuKHgws3NQtcpb0XTtBjtRbtfpvBMG/1USQDyOzPFNsHVRb9ZGkUEc4karBOIn0
         4VZROEl8VLWa4lk/dTC3G0D/J3RsIQcNoV64VNjVcyNisdRvuM9zKo81EWoC0mAHhvCs
         D+FBWKEXhPfIt1WBX12b+SUIjww64Nl2VVxgTZl9HB0uZuttPeidxWmRsnlvGslK+MMp
         ddEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yOTsGfuBFPVTmUTAuefFnl10Yv0MH16ucMFZN1z9orU=;
        b=BJhK2zAx9RXipWwMTEhg0UaiwKYhWQhQMlAKMcDwQcYwpEV0tfZqp6wzq8a5Fi42r4
         opsblxzn1R38lmD3ffwE6Y0hqPBKeaI4n9TC4d8b+RpohSme0KCmyneKROtrAbxKcoLZ
         sTpqhNO9hFQEyCj387P1bBqJTMdnlzOD+ptViw55J7unEyRSYfKpDVZ79n8o3RDvSEm2
         kpcJEM7QeWlRaoF5SpO6lJiv7e7XQdqzUZTHt54CUIEaMWmoqoKfrCeY9TAM9hrUm8MU
         hC6xdxq546o0Fe1BTmEq8aCR4MkKzAqJ+ciD+r0eRPnf4vHfxeAoP2l42b5HtbLbXoy1
         uCdg==
X-Gm-Message-State: AOAM530cH7PjqHeBlV1dPRbNpTXEG+rJ+ymA9U3qXLiR/7eW0/sG53SU
        AtNfoGtnAXMadceRbJU75SI592waXWQ=
X-Google-Smtp-Source: ABdhPJzS3rWwABYyFdQssPC88z/65mdB7eIwDeHGONvS9cOG6tI/geMfpQ/YiFx5zcTSuxqVfuKXfYIJRmk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:f092:b0:141:ccb6:897 with SMTP id
 p18-20020a170902f09200b00141ccb60897mr53906568pla.89.1638905416855; Tue, 07
 Dec 2021 11:30:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Dec 2021 19:30:06 +0000
In-Reply-To: <20211207193006.120997-1-seanjc@google.com>
Message-Id: <20211207193006.120997-5-seanjc@google.com>
Mime-Version: 1.0
References: <20211207193006.120997-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 4/4] KVM: selftests: Add test to verify TRIPLE_FAULT on
 invalid L2 guest state
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a selftest to attempt to enter L2 with invalid guests state by
exiting to userspace via I/O from L2, and then using KVM_SET_SREGS to set
invalid guest state (marking TR unusable is arbitrary chosen for its
relative simplicity).

This is a regression test for a bug introduced by commit c8607e4a086f
("KVM: x86: nVMX: don't fail nested VM entry on invalid guest state if
!from_vmentry"), which incorrectly set vmx->fail=true when L2 had invalid
guest state and ultimately triggered a WARN due to nested_vmx_vmexit()
seeing vmx->fail==true while attempting to synthesize a nested VM-Exit.

The is also a functional test to verify that KVM sythesizes TRIPLE_FAULT
for L2, which is somewhat arbitrary behavior, instead of emulating L2.
KVM should never emulate L2 due to invalid guest state, as it's
architecturally impossible for L1 to run an L2 guest with invalid state
as nested VM-Enter should always fail, i.e. L1 needs to do the emulation.
Stuffing state via KVM ioctl() is a non-architctural, out-of-band case,
hence the TRIPLE_FAULT being rather arbitrary.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../x86_64/vmx_invalid_nested_guest_state.c   | 105 ++++++++++++++++++
 3 files changed, 107 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 3763105029fb..de41afb01a77 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -34,6 +34,7 @@
 /x86_64/vmx_apic_access_test
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_dirty_log_test
+/x86_64/vmx_invalid_nested_guest_state
 /x86_64/vmx_preemption_timer_test
 /x86_64/vmx_set_nested_state_test
 /x86_64/vmx_tsc_adjust_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c4e34717826a..6be4144c8d25 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -63,6 +63,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_apic_access_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c b/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
new file mode 100644
index 000000000000..489fbed4ca6f
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vmx.h"
+
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "kselftest.h"
+
+#define VCPU_ID	0
+#define ARBITRARY_IO_PORT 0x2000
+
+static struct kvm_vm *vm;
+
+static void l2_guest_code(void)
+{
+	/*
+	 * Generate an exit to L0 userspace, i.e. main(), via I/O to an
+	 * arbitrary port.
+	 */
+	asm volatile("inb %%dx, %%al"
+		     : : [port] "d" (ARBITRARY_IO_PORT) : "rax");
+}
+
+static void l1_guest_code(struct vmx_pages *vmx_pages)
+{
+#define L2_GUEST_STACK_SIZE 64
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+
+	/* Prepare the VMCS for L2 execution. */
+	prepare_vmcs(vmx_pages, l2_guest_code,
+		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	/*
+	 * L2 must be run without unrestricted guest, verify that the selftests
+	 * library hasn't enabled it.  Because KVM selftests jump directly to
+	 * 64-bit mode, unrestricted guest support isn't required.
+	 */
+	GUEST_ASSERT(!(vmreadz(CPU_BASED_VM_EXEC_CONTROL) & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) ||
+		     !(vmreadz(SECONDARY_VM_EXEC_CONTROL) & SECONDARY_EXEC_UNRESTRICTED_GUEST));
+
+	GUEST_ASSERT(!vmlaunch());
+
+	/* L2 should triple fault after main() stuffs invalid guest state. */
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_TRIPLE_FAULT);
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	vm_vaddr_t vmx_pages_gva;
+	struct kvm_sregs sregs;
+	struct kvm_run *run;
+	struct ucall uc;
+
+	nested_vmx_check_supported();
+
+	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+
+	/* Allocate VMX pages and shared descriptors (vmx_pages). */
+	vcpu_alloc_vmx(vm, &vmx_pages_gva);
+	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+
+	vcpu_run(vm, VCPU_ID);
+
+	run = vcpu_state(vm, VCPU_ID);
+
+	/*
+	 * The first exit to L0 userspace should be an I/O access from L2.
+	 * Running L1 should launch L2 without triggering an exit to userspace.
+	 */
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Expected KVM_EXIT_IO, got: %u (%s)\n",
+		    run->exit_reason, exit_reason_str(run->exit_reason));
+
+	TEST_ASSERT(run->io.port == ARBITRARY_IO_PORT,
+		    "Expected IN from port %d from L2, got port %d",
+		    ARBITRARY_IO_PORT, run->io.port);
+
+	/*
+	 * Stuff invalid guest state for L2 by making TR unusuable.  The next
+	 * KVM_RUN should induce a TRIPLE_FAULT in L2 as KVM doesn't support
+	 * emulating invalid guest state for L2.
+	 */
+	memset(&sregs, 0, sizeof(sregs));
+	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	sregs.tr.unusable = 1;
+	vcpu_sregs_set(vm, VCPU_ID, &sregs);
+
+	vcpu_run(vm, VCPU_ID);
+
+	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		TEST_FAIL("%s", (const char *)uc.args[0]);
+	default:
+		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+	}
+}
-- 
2.34.1.400.ga245620fadb-goog

