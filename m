Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F10532BAA
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 15:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237963AbiEXNu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 09:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbiEXNuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 09:50:20 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C41C9728B;
        Tue, 24 May 2022 06:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653400218; x=1684936218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=vSuLxvkz+Qo0GEW8QNsAc9oAUQcsNIRRmWiVzb6Fu1I=;
  b=m9k9xTY0AyZPlUQy9NCvneKVmZAn86xkIvxQ/HO9tJoKzEYpcSHFw/zy
   oFMH1NPPuN96bhEZxjP3N4tYIXdKNT+4aZv5a4R6JKIfSzY5LhOZcdABY
   bWBjbTdzMKWW0In746DO5i96d1prJCu+Be4F79vKJTff84DGR5+BgHCCP
   8K7EJJ5ue5jPOwpW0la+heWzDvdgcu2JqpDwLHQGy9mB6UbYpuySIg3+H
   9hcjDJkiRNgYjNxDcZF4p9XIOadZ9TlaC/eMGrmS4wzIz8Wp/1+uf2Sau
   aSF10w4wGBlOfB3y/yUAutyDb7iAlR3pu3rDJHgIUeLMcxxqU7Sxfcy7q
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="272351849"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="272351849"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:50:18 -0700
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="601312003"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:50:15 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v7 2/4] KVM: selftests: Add a test to get/set triple fault event
Date:   Tue, 24 May 2022 21:56:22 +0800
Message-Id: <20220524135624.22988-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220524135624.22988-1-chenyi.qiang@intel.com>
References: <20220524135624.22988-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a selftest for triple fault event:
  - launch the L2 and exit to userspace via I/O.
  - using KVM_SET_VCPU_EVENTS to pend a triple fault event.
  - with the immediate_exit, check the triple fault is pending.
  - run for real with pending triple fault and L1 can see the triple
    fault.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/triple_fault_event_test.c      | 101 ++++++++++++++++++
 3 files changed, 103 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 4f48f9c2411d..1cf23869b04a 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -56,6 +56,7 @@
 /x86_64/xen_vmcall_test
 /x86_64/xss_msr_test
 /x86_64/vmx_pmu_msrs_test
+/x86_64/triple_fault_event_test
 /access_tracking_perf_test
 /demand_paging_test
 /dirty_log_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 8c3db2f75315..6711cc1871f6 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -89,6 +89,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
+TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
new file mode 100644
index 000000000000..6e1de0631ce9
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
@@ -0,0 +1,101 @@
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
+#define VCPU_ID			0
+#define ARBITRARY_IO_PORT	0x2000
+
+/* The virtual machine object. */
+static struct kvm_vm *vm;
+
+static void l2_guest_code(void)
+{
+	asm volatile("inb %%dx, %%al"
+		     : : [port] "d" (ARBITRARY_IO_PORT) : "rax");
+}
+
+void l1_guest_code(struct vmx_pages *vmx)
+{
+#define L2_GUEST_STACK_SIZE 64
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+
+	GUEST_ASSERT(vmx->vmcs_gpa);
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx));
+	GUEST_ASSERT(load_vmcs(vmx));
+
+	prepare_vmcs(vmx, l2_guest_code,
+		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	GUEST_ASSERT(!vmlaunch());
+	/* L2 should triple fault after a triple fault event injected. */
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_TRIPLE_FAULT);
+	GUEST_DONE();
+}
+
+int main(void)
+{
+	struct kvm_run *run;
+	struct kvm_vcpu_events events;
+	vm_vaddr_t vmx_pages_gva;
+	struct ucall uc;
+
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_TRIPLE_FAULT_EVENT,
+		.args = {1}
+	};
+
+	if (!nested_vmx_supported()) {
+		print_skip("Nested VMX not supported");
+		exit(KSFT_SKIP);
+	}
+
+	if (!kvm_check_cap(KVM_CAP_TRIPLE_FAULT_EVENT)) {
+		print_skip("KVM_CAP_TRIPLE_FAULT_EVENT not supported");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+	vm_enable_cap(vm, &cap);
+
+	run = vcpu_state(vm, VCPU_ID);
+	vcpu_alloc_vmx(vm, &vmx_pages_gva);
+	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+	vcpu_run(vm, VCPU_ID);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Expected KVM_EXIT_IO, got: %u (%s)\n",
+		    run->exit_reason, exit_reason_str(run->exit_reason));
+	TEST_ASSERT(run->io.port == ARBITRARY_IO_PORT,
+		    "Expected IN from port %d from L2, got port %d",
+		    ARBITRARY_IO_PORT, run->io.port);
+	vcpu_events_get(vm, VCPU_ID, &events);
+	events.flags |= KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
+	events.triple_fault.pending = true;
+	vcpu_events_set(vm, VCPU_ID, &events);
+	run->immediate_exit = true;
+	vcpu_run_complete_io(vm, VCPU_ID);
+
+	vcpu_events_get(vm, VCPU_ID, &events);
+	TEST_ASSERT(events.flags & KVM_VCPUEVENT_VALID_TRIPLE_FAULT,
+		    "Triple fault event invalid");
+	TEST_ASSERT(events.triple_fault.pending,
+		    "No triple fault pending");
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
+
+}
-- 
2.17.1

