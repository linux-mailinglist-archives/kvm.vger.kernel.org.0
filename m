Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941725098F6
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 09:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385749AbiDUH1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 03:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385775AbiDUH1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 03:27:45 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE4AFF9;
        Thu, 21 Apr 2022 00:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650525895; x=1682061895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=tK/Q9eBMuCYib5IXMrOq3jJ+HGgt3T5qhzfnCTx8v+Y=;
  b=Yzp7kM+YA/h+KuGi7YqGdlMW1fuxPBFCuQnZUkQMb1vax4ei51JzsCkQ
   lCCPeLySudGW1g4Mpwssl/hM8cbNLZBKCBPkAyzOGatI9xrkySsMSLQKs
   u9fW4a1MNskaUa+gEMLEV1hAcWCGQIk68SDYnaVOSc3Sp4ArwHgFsV9uY
   vKcP7bgBW88TrnEMb3s3iEm7dVoL9BmyUDH05W5RhS1tEwDXltNYjxvFr
   m+OTspfdaryJev2zacRNSdc0Ki5Xfvj2U5VB8w3M5M/zs5KTfVgAYWX5K
   nYgrRextT5cxSd3qgnMdnX0ICs/hG0Dw1s25logB6lNCw0tdcGxmpNvHN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="324709296"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="324709296"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 00:24:55 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="727860213"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 00:24:52 -0700
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
Subject: [PATCH v6 2/3] KVM: selftests: Add a test to get/set triple fault event
Date:   Thu, 21 Apr 2022 15:29:57 +0800
Message-Id: <20220421072958.16375-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220421072958.16375-1-chenyi.qiang@intel.com>
References: <20220421072958.16375-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a selftest to get/set triple fault event by:
  - exiting to userspace via I/O from L2;
  - using KVM_GET_VCPU_EVENTS to verify the TRIPEL_FAULT field is valid
    in flags.
  - using KVM_SET_VCPU_EVENTS to inject a triple fault event so that L1
    can see the appropriate exit.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../kvm/x86_64/triple_fault_event_test.c      | 96 +++++++++++++++++++
 3 files changed, 98 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 56140068b763..989fd4672f61 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -55,6 +55,7 @@
 /x86_64/xen_vmcall_test
 /x86_64/xss_msr_test
 /x86_64/vmx_pmu_msrs_test
+/x86_64/triple_fault_event_test
 /access_tracking_perf_test
 /demand_paging_test
 /dirty_log_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index af582d168621..ce147b50b9be 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -88,6 +88,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
+TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
new file mode 100644
index 000000000000..20bf8f9a61d7
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
@@ -0,0 +1,96 @@
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
+#ifndef __x86_64__
+# error This test is 64-bit only
+#endif
+
+#define VCPU_ID			0
+#define ARBITRARY_IO_PORT	0x2000
+
+/* The virtual machine object. */
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
+	if (!nested_vmx_supported()) {
+		print_skip("Nested VMX not supported");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+
+	vcpu_alloc_vmx(vm, &vmx_pages_gva);
+	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+
+	vcpu_run(vm, VCPU_ID);
+
+	run = vcpu_state(vm, VCPU_ID);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Expected KVM_EXIT_IO, got: %u (%s)\n",
+		    run->exit_reason, exit_reason_str(run->exit_reason));
+
+	TEST_ASSERT(run->io.port == ARBITRARY_IO_PORT,
+		    "Expected IN from port %d from L2, got port %d",
+		    ARBITRARY_IO_PORT, run->io.port);
+
+	vcpu_events_get(vm, VCPU_ID, &events);
+	TEST_ASSERT(events.flags & KVM_VCPUEVENT_VALID_TRIPLE_FAULT,
+		    "Triple fault event invalid");
+	events.triple_fault_pending = true;
+	vcpu_events_set(vm, VCPU_ID, &events);
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
+
+}
-- 
2.17.1

