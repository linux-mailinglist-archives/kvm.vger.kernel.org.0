Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752EA3B0E4E
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhFVUJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbhFVUJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:09:02 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B56CC061151
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:22 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id o14-20020a05620a0d4eb02903a5eee61155so1230099qkl.9
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=QyEwXRXT2urLsHLGo2cN5dFnw8/WVT3cYfJ0isgbfF0=;
        b=PlFbL8vxU+sOB44yCowC4K/Jlcj32kbZEcyIo5LSpS0eA7SJi70wwN67NJZLWUQXHM
         72g9+CpyRo2anQtOUVWt2SaCNkeFNWvRmXvj8TIJT/3kIFA17SU6Zb0zAlH6BwT3V43J
         CeiLEJ3MDnIszFIHc1GHRLUult8sRn1Bcu9va7WCzqF7YzLNcrp+oV2DeFbGIG3Qn6ul
         Moi2oOQwg377orU2tCt0yUcXeASn6QBziXwibuj+J/hTBn5q5iE9k46oDAiV/r/5f13S
         GqBV5yQ3ADD4nwMj99MNu2L9wbtjorkvbcYT9jmy5RScQnPbthJb+CWL/iz7i+RSgko3
         6i5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=QyEwXRXT2urLsHLGo2cN5dFnw8/WVT3cYfJ0isgbfF0=;
        b=hedP7ubaDDJEv3ThHgpC/K/bLFZ1GS0hk/mw/68rd1kRqgRN/sjD0amNwvRJG0BJNY
         BNvydlPiLndHhMtWHyFeMvIj+uMfg5URM0/x7gK6QlWSY3epOYMfYoSE39kio0GEx9sa
         FahrVUnEpXeg/nBy+3GcodfZmw1GjsJaCLPcx7iXKHo8kytDSgYPpuAuo8zHZXg+Nvr4
         WZf5Mj4Qo2oJSSoO9HCz3HVNMZWS/UTeTRT9GQn7aZOAwZR9FuG4jndfKikW4swsoDIh
         Cog/2QoRtLsCORwexTV/xw3B0ACYZ9kGfLiZ+E+iNDRV061ueeZP1ecnbHc8w9Xm1KJx
         /VHw==
X-Gm-Message-State: AOAM531a59hDyQLzQg81lO30PSIiMe/r0gbqbdUjbS+jhhQ12cSfWvDO
        3GO5SCBfq+qXxdNAgcwYBv5wNISDreE=
X-Google-Smtp-Source: ABdhPJyCCOJQejZcAY35znCE45kL8yJlqS1sf7Sh9SYUamUWLhhxukO5zKwzXvgEhYuuz49tt2Dlm6PDEHM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a0c:f704:: with SMTP id w4mr558674qvn.50.1624392381729;
 Tue, 22 Jun 2021 13:06:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:29 -0700
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Message-Id: <20210622200529.3650424-20-seanjc@google.com>
Mime-Version: 1.0
References: <20210622200529.3650424-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 19/19] KVM: sefltests: Add x86-64 test to verify MMU reacts to
 CPUID updates
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an x86-only test to verify that x86's MMU reacts to CPUID updates
that impact the MMU.  KVM has had multiple bugs where it fails to
reconfigure the MMU after the guest's vCPU model changes.

Sadly, this test is effectively limited to shadow paging because the
hardware page walk handler doesn't support software disabling of GBPAGES
support, and KVM doesn't manually walk the GVA->GPA on faults for
performance reasons (doing so would large defeat the benefits of TDP).

Don't require !TDP for the tests as there is still value in running the
tests with TDP, even though the tests will fail (barring KVM hacks).
E.g. KVM should not completely explode if MAXPHYADDR results in KVM using
4-level vs. 5-level paging for the guest.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   3 +
 .../selftests/kvm/x86_64/mmu_role_test.c      | 147 ++++++++++++++++++
 4 files changed, 152 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/mmu_role_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index e0e14150744e..6ead3403eca6 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -15,6 +15,7 @@
 /x86_64/hyperv_cpuid
 /x86_64/hyperv_features
 /x86_64/mmio_warning_test
+/x86_64/mmu_role_test
 /x86_64/platform_info_test
 /x86_64/set_boot_cpu_id
 /x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 61e2accd080d..8dc007bac0fe 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -47,6 +47,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
+TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index f21126941f19..914b0d16929c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -55,6 +55,9 @@
 #define CPUID_PKU		(1ul << 3)
 #define CPUID_LA57		(1ul << 16)
 
+/* CPUID.0x8000_0001.EDX */
+#define CPUID_GBPAGES		(1ul << 26)
+
 #define UNEXPECTED_VECTOR_PORT 0xfff0u
 
 /* General Registers in 64-Bit Mode */
diff --git a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
new file mode 100644
index 000000000000..523371cf8e8f
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "kvm_util.h"
+#include "processor.h"
+
+#define VCPU_ID			1
+
+#define MMIO_GPA	0x100000000ull
+
+static void guest_code(void)
+{
+	(void)READ_ONCE(*((uint64_t *)MMIO_GPA));
+	(void)READ_ONCE(*((uint64_t *)MMIO_GPA));
+
+	GUEST_ASSERT(0);
+}
+
+static void guest_pf_handler(struct ex_regs *regs)
+{
+	/* PFEC == RSVD | PRESENT (read, kernel). */
+	GUEST_ASSERT(regs->error_code == 0x9);
+	GUEST_DONE();
+}
+
+static void mmu_role_test(u32 *cpuid_reg, u32 evil_cpuid_val)
+{
+	u32 good_cpuid_val = *cpuid_reg;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	uint64_t cmd;
+	int r;
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	run = vcpu_state(vm, VCPU_ID);
+
+	/* Map 1gb page without a backing memlot. */
+	__virt_pg_map(vm, MMIO_GPA, MMIO_GPA, X86_PAGE_SIZE_1G);
+
+	r = _vcpu_run(vm, VCPU_ID);
+
+	/* Guest access to the 1gb page should trigger MMIO. */
+	TEST_ASSERT(r == 0, "vcpu_run failed: %d\n", r);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_MMIO,
+		    "Unexpected exit reason: %u (%s), expected MMIO exit (1gb page w/o memslot)\n",
+		    run->exit_reason, exit_reason_str(run->exit_reason));
+
+	TEST_ASSERT(run->mmio.len == 8, "Unexpected exit mmio size = %u", run->mmio.len);
+
+	TEST_ASSERT(run->mmio.phys_addr == MMIO_GPA,
+		    "Unexpected exit mmio address = 0x%llx", run->mmio.phys_addr);
+
+	/*
+	 * Effect the CPUID change for the guest and re-enter the guest.  Its
+	 * access should now #PF due to the PAGE_SIZE bit being reserved or
+	 * the resulting GPA being invalid.  Note, kvm_get_supported_cpuid()
+	 * returns the struct that contains the entry being modified.  Eww.
+	 */
+	*cpuid_reg = evil_cpuid_val;
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	/*
+	 * Add a dummy memslot to coerce KVM into bumping the MMIO generation.
+	 * KVM does not "officially" support mucking with CPUID after KVM_RUN,
+	 * and will incorrectly reuse MMIO SPTEs.  Don't delete the memslot!
+	 * KVM x86 zaps all shadow pages on memslot deletion.
+	 */
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    MMIO_GPA << 1, 10, 1, 0);
+
+	/* Set up a #PF handler to eat the RSVD #PF and signal all done! */
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vm_handle_exception(vm, PF_VECTOR, guest_pf_handler);
+
+	r = _vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(r == 0, "vcpu_run failed: %d\n", r);
+
+	cmd = get_ucall(vm, VCPU_ID, NULL);
+	TEST_ASSERT(cmd == UCALL_DONE,
+		    "Unexpected guest exit, exit_reason=%s, ucall.cmd = %lu\n",
+		    exit_reason_str(run->exit_reason), cmd);
+
+	/*
+	 * Restore the happy CPUID value for the next test.  Yes, changes are
+	 * indeed persistent across VM destruction.
+	 */
+	*cpuid_reg = good_cpuid_val;
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_cpuid_entry2 *entry;
+	int opt;
+
+	/*
+	 * All tests are opt-in because TDP doesn't play nice with reserved #PF
+	 * in the GVA->GPA translation.  The hardware page walker doesn't let
+	 * software change GBPAGES or MAXPHYADDR, and KVM doesn't manually walk
+	 * the GVA on fault for performance reasons.
+	 */
+	bool do_gbpages = false;
+	bool do_maxphyaddr = false;
+
+	setbuf(stdout, NULL);
+
+	while ((opt = getopt(argc, argv, "gm")) != -1) {
+		switch (opt) {
+		case 'g':
+			do_gbpages = true;
+			break;
+		case 'm':
+			do_maxphyaddr = true;
+			break;
+		case 'h':
+		default:
+			printf("usage: %s [-g (GBPAGES)] [-m (MAXPHYADDR)]\n", argv[0]);
+			break;
+		}
+	}
+
+	if (!do_gbpages && !do_maxphyaddr) {
+		print_skip("No sub-tests selected");
+		return 0;
+	}
+
+	entry = kvm_get_supported_cpuid_entry(0x80000001);
+	if (!(entry->edx & CPUID_GBPAGES)) {
+		print_skip("1gb hugepages not supported");
+		return 0;
+	}
+
+	if (do_gbpages) {
+		pr_info("Test MMIO after toggling CPUID.GBPAGES\n\n");
+		mmu_role_test(&entry->edx, entry->edx & ~CPUID_GBPAGES);
+	}
+
+	if (do_maxphyaddr) {
+		pr_info("Test MMIO after changing CPUID.MAXPHYADDR\n\n");
+		entry = kvm_get_supported_cpuid_entry(0x80000008);
+		mmu_role_test(&entry->eax, (entry->eax & ~0xff) | 0x20);
+	}
+
+	return 0;
+}
-- 
2.32.0.288.g62a8d224e6-goog

