Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CA24A82A2
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 11:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350123AbiBCKqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 05:46:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347371AbiBCKqm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 05:46:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643885201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/aSdBgMHMlRkpYdCMZrpblQDQM+JHgpguiGW03OSIJM=;
        b=jOy6sx6JibOys7fhz35L8xHR85+RfwGRJo3pVDoeuB0T0Mtg4nbM79Bx1qziFcePFXfazC
        rae5rRskPjLGuv89vyg8UsY5uOvtORxvGa/kaXNpTXeDgrxQGJZuGFIFokGvu533OVJNB3
        QwyxwRB6u9fM6YrSjakXpMHzIJt2J9Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-A6RSlhROMpiiUG70xFEruw-1; Thu, 03 Feb 2022 05:46:38 -0500
X-MC-Unique: A6RSlhROMpiiUG70xFEruw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9133E81433D;
        Thu,  3 Feb 2022 10:46:37 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 985CF108B8;
        Thu,  3 Feb 2022 10:46:35 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] KVM: selftests: nSVM: Add enlightened MSR-Bitmap selftest
Date:   Thu,  3 Feb 2022 11:46:20 +0100
Message-Id: <20220203104620.277031-7-vkuznets@redhat.com>
In-Reply-To: <20220203104620.277031-1-vkuznets@redhat.com>
References: <20220203104620.277031-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new test for Hyper-V nSVM extensions (Hyper-V on KVM) and add
a test for enlightened MSR-Bitmap feature:

- Intercept access to MSR_FS_BASE in L1 and check that this works
  with enlightened MSR-Bitmap disabled.
- Enabled enlightened MSR-Bitmap and check that the intercept still works
  as expected.
- Intercept access to MSR_GS_BASE but don't clear the corresponding bit
  from clean fields mask, KVM is supposed to skip updating MSR-Bitmap02 and
  thus the consequent access to the MSR from L2 will not get intercepted.
- Finally, clear the corresponding bit from clean fields mask and check
  that access to MSR_GS_BASE is now intercepted.

The test works with the assumption, that access to MSR_FS_BASE/MSR_GS_BASE
is not intercepted for L1. If this ever becomes not true the test will
fail as nested_svm_exit_handled_msr() always checks L1's MSR-Bitmap for
L2 irrespective of clean fields. The behavior is correct as enlightened
MSR-Bitmap feature is just an optimization, KVM is not obliged to ignore
updates when the corresponding bit in clean fields stays clear.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   1 +
 .../selftests/kvm/x86_64/hyperv_svm_test.c    | 175 ++++++++++++++++++
 3 files changed, 177 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 81ebf99d6ff0..ce0f19997597 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -51,6 +51,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/emulator_error_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
+TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index e23c8a3e8a66..a25aabd8f5e7 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -16,6 +16,7 @@
 #define CPUID_SVM_BIT		2
 #define CPUID_SVM		BIT_ULL(CPUID_SVM_BIT)
 
+#define SVM_EXIT_MSR		0x07c
 #define SVM_EXIT_VMMCALL	0x081
 
 struct svm_test_data {
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
new file mode 100644
index 000000000000..21f5ca9197da
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM_GET/SET_* tests
+ *
+ * Copyright (C) 2022, Red Hat, Inc.
+ *
+ * Tests for Hyper-V extensions to SVM.
+ */
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <linux/bitmap.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+#include "hyperv.h"
+
+#define VCPU_ID		1
+#define L2_GUEST_STACK_SIZE 256
+
+struct hv_enlightenments {
+	struct __packed hv_enlightenments_control {
+		u32 nested_flush_hypercall:1;
+		u32 msr_bitmap:1;
+		u32 enlightened_npt_tlb: 1;
+		u32 reserved:29;
+	} __packed hv_enlightenments_control;
+	u32 hv_vp_id;
+	u64 hv_vm_id;
+	u64 partition_assist_page;
+	u64 reserved;
+} __packed;
+
+/*
+ * Hyper-V uses the software reserved clean bit in VMCB
+ */
+#define VMCB_HV_NESTED_ENLIGHTENMENTS (1U << 31)
+
+static inline void vmmcall(void)
+{
+	__asm__ __volatile__("vmmcall");
+}
+
+void l2_guest_code(void)
+{
+	GUEST_SYNC(3);
+	/* Exit to L1 */
+	vmmcall();
+
+	/* MSR-Bitmap tests */
+	rdmsr(MSR_FS_BASE); /* intercepted */
+	rdmsr(MSR_FS_BASE); /* intercepted */
+	rdmsr(MSR_GS_BASE); /* not intercepted */
+	vmmcall();
+	rdmsr(MSR_GS_BASE); /* intercepted */
+
+	GUEST_SYNC(5);
+
+	/* Done, exit to L1 and never come back.  */
+	vmmcall();
+}
+
+static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb = svm->vmcb;
+	struct hv_enlightenments *hve =
+		(struct hv_enlightenments *)vmcb->control.reserved_sw;
+
+	GUEST_SYNC(1);
+
+	wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
+
+	GUEST_ASSERT(svm->vmcb_gpa);
+	/* Prepare for L2 execution. */
+	generic_svm_setup(svm, l2_guest_code,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	GUEST_SYNC(2);
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+	GUEST_SYNC(4);
+	vmcb->save.rip += 3;
+
+	/* Intercept RDMSR 0xc0000100 */
+	vmcb->control.intercept |= 1ULL << INTERCEPT_MSR_PROT;
+	set_bit(2 * (MSR_FS_BASE & 0x1fff), svm->msr + 0x800);
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
+	vmcb->save.rip += 2; /* rdmsr */
+
+	/* Enable enlightened MSR bitmap */
+	hve->hv_enlightenments_control.msr_bitmap = 1;
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
+	vmcb->save.rip += 2; /* rdmsr */
+
+	/* Intercept RDMSR 0xc0000101 without telling KVM about it */
+	set_bit(2 * (MSR_GS_BASE & 0x1fff), svm->msr + 0x800);
+	/* Make sure HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP is set */
+	vmcb->control.clean |= VMCB_HV_NESTED_ENLIGHTENMENTS;
+	run_guest(vmcb, svm->vmcb_gpa);
+	/* Make sure we don't see SVM_EXIT_MSR here so eMSR bitmap works */
+	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+	vmcb->save.rip += 3; /* vmcall */
+
+	/* Now tell KVM we've changed MSR-Bitmap */
+	vmcb->control.clean &= ~VMCB_HV_NESTED_ENLIGHTENMENTS;
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
+	vmcb->save.rip += 2; /* rdmsr */
+
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+	GUEST_SYNC(6);
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	vm_vaddr_t nested_gva = 0;
+
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	struct ucall uc;
+	int stage;
+
+	if (!nested_svm_supported()) {
+		print_skip("Nested SVM not supported");
+		exit(KSFT_SKIP);
+	}
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vcpu_set_hv_cpuid(vm, VCPU_ID);
+	run = vcpu_state(vm, VCPU_ID);
+	vcpu_alloc_svm(vm, &nested_gva);
+	vcpu_args_set(vm, VCPU_ID, 1, nested_gva);
+
+	for (stage = 1;; stage++) {
+		_vcpu_run(vm, VCPU_ID);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Stage %d: unexpected exit reason: %u (%s),\n",
+			    stage, run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
+				  __FILE__, uc.args[1]);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+
+		/* UCALL_SYNC is handled here.  */
+		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
+			    uc.args[1] == stage, "Stage %d: Unexpected register values vmexit, got %lx",
+			    stage, (ulong)uc.args[1]);
+
+	}
+
+done:
+	kvm_vm_free(vm);
+}
-- 
2.34.1

