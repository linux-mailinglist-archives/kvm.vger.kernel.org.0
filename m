Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D927E4EFDA9
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 03:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353654AbiDBBLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 21:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353623AbiDBBLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 21:11:13 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1C5A0BF0
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 18:09:19 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id z132-20020a63338a000000b003844e317066so2342537pgz.19
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 18:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OExX1Igb+SEI7PdUVeKXKi/G1aHbfTSQe6uvI8ZE66s=;
        b=QoWYxsIze+C3Ee47cmi+k5goTPGx2Io4H2IyLGbi5BL+YuSOtk8JZB9VbBiKfn+5KE
         tyrkF6Zyy4naj8XbTkWvhkg/sFU+thgF+DR7zGxHaU0Zufu1ol74uxq4AXOtb0GAHX2+
         RCwbWhRxvZMYnWlv5Pel0agogKAldZa+yRq1pBY6qslSIaYI1EsqNARyskD1VinUqj37
         0o4B7ukkXknlytvlvFrKfIN3Log0v9sa7s+sDwVihw3X5My32CK4QQgkdwX9QMxI0OCg
         rolELI0I7ldjj+6WJTt4XTF7oYy1R+nt/GzVXksOb23zb7L7SLrRPoB+qBeferqjl3zT
         i/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OExX1Igb+SEI7PdUVeKXKi/G1aHbfTSQe6uvI8ZE66s=;
        b=HnZcxJDQbufhMX5sc07BrIeRVoNc2vWa5AKhXUWjb90m0odlGXAcXdWRdeYsVrqJRA
         ejou8ulPgE4adZmakpRo4icmV4KboPhVZg0EbO19mOyNbkHkhdWkHqfXdjDnpeFmmFSb
         4sjfcqp9553Uw4VrXtbdWxPzT0ADQpT96Yuc51OPQnFyW/aAPtjCSZlEF0NAiFN8qWZT
         VYxak3AVDk+VEN9O8EWHTLCHjN2hs/ueVy0rS6BxDEFsUn94FquIySvZgbpqW09zFRjW
         k2jhwNiu3tCSxdXhAf8kwq7ZEJK4J6pX5xg1MjeWgtZdKsAkRL8vxBNjsjpnlg1lL1cW
         e0Mg==
X-Gm-Message-State: AOAM531iT5fUatJSiaSbhgioGT4wPYpZM4epNL9VE8hwSEsIMnrf3XYx
        OG0fZEq0Y4nGL563aWEOUsxuB6akubY=
X-Google-Smtp-Source: ABdhPJySbHKlONilMxgSTz0tRz1iIrI+IQGst6MP1o+Dhm9cpdIUyvg75yFzuaUSapncQePMHGO9Y0zty3A=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:6d4c:0:b0:398:7c40:c160 with SMTP id
 i73-20020a636d4c000000b003987c40c160mr17309928pgc.109.1648861758524; Fri, 01
 Apr 2022 18:09:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  2 Apr 2022 01:09:03 +0000
In-Reply-To: <20220402010903.727604-1-seanjc@google.com>
Message-Id: <20220402010903.727604-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220402010903.727604-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 8/8] KVM: selftests: nSVM: Add svm_nested_soft_inject_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Add a KVM self-test that checks whether a nSVM L1 is able to successfully
inject a software interrupt and a soft exception into its L2 guest.

In practice, this tests both the next_rip field consistency and
L1-injected event with intervening L0 VMEXIT during its delivery:
the first nested VMRUN (that's also trying to inject a software interrupt)
will immediately trigger a L0 NPF.
This L0 NPF will have zero in its CPU-returned next_rip field, which if
incorrectly reused by KVM will trigger a #PF when trying to return to
such address 0 from the interrupt handler.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   2 +
 .../kvm/x86_64/svm_nested_soft_inject_test.c  | 147 ++++++++++++++++++
 4 files changed, 151 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 1f1b6c978bf7..1354d3f4a362 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -33,6 +33,7 @@
 /x86_64/state_test
 /x86_64/svm_vmcall_test
 /x86_64/svm_int_ctl_test
+/x86_64/svm_nested_soft_inject_test
 /x86_64/sync_regs_test
 /x86_64/tsc_msrs_test
 /x86_64/userspace_io_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c9cdbd248727..cef6d583044b 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -66,6 +66,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_int_ctl_test
+TEST_GEN_PROGS_x86_64 += x86_64/svm_nested_soft_inject_test
 TEST_GEN_PROGS_x86_64 += x86_64/tsc_scaling_sync
 TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_io_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index a25aabd8f5e7..d49f7c9b4564 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -16,6 +16,8 @@
 #define CPUID_SVM_BIT		2
 #define CPUID_SVM		BIT_ULL(CPUID_SVM_BIT)
 
+#define SVM_EXIT_EXCP_BASE	0x040
+#define SVM_EXIT_HLT		0x078
 #define SVM_EXIT_MSR		0x07c
 #define SVM_EXIT_VMMCALL	0x081
 
diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
new file mode 100644
index 000000000000..d39be5d885c1
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 Oracle and/or its affiliates.
+ *
+ * Based on:
+ *   svm_int_ctl_test
+ *
+ *   Copyright (C) 2021, Red Hat, Inc.
+ *
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+
+#define VCPU_ID		0
+#define INT_NR			0x20
+#define X86_FEATURE_NRIPS	BIT(3)
+
+#define vmcall()		\
+	__asm__ __volatile__(	\
+		"vmmcall\n"	\
+		)
+
+#define ud2()			\
+	__asm__ __volatile__(	\
+		"ud2\n"	\
+		)
+
+#define hlt()			\
+	__asm__ __volatile__(	\
+		"hlt\n"	\
+		)
+
+static unsigned int bp_fired;
+static void guest_bp_handler(struct ex_regs *regs)
+{
+	bp_fired++;
+}
+
+static unsigned int int_fired;
+static void guest_int_handler(struct ex_regs *regs)
+{
+	int_fired++;
+}
+
+static void l2_guest_code(void)
+{
+	GUEST_ASSERT(int_fired == 1);
+	vmcall();
+	ud2();
+
+	GUEST_ASSERT(bp_fired == 1);
+	hlt();
+}
+
+static void l1_guest_code(struct svm_test_data *svm)
+{
+	#define L2_GUEST_STACK_SIZE 64
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb = svm->vmcb;
+
+	/* Prepare for L2 execution. */
+	generic_svm_setup(svm, l2_guest_code,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	vmcb->control.intercept_exceptions |= BIT(PF_VECTOR) | BIT(UD_VECTOR);
+	vmcb->control.intercept |= BIT(INTERCEPT_HLT);
+
+	vmcb->control.event_inj = INT_NR | SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_SOFT;
+	/* The return address pushed on stack */
+	vmcb->control.next_rip = vmcb->save.rip;
+
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT_3(vmcb->control.exit_code == SVM_EXIT_VMMCALL,
+		       vmcb->control.exit_code,
+		       vmcb->control.exit_info_1, vmcb->control.exit_info_2);
+
+	/* Skip over VMCALL */
+	vmcb->save.rip += 3;
+
+	vmcb->control.event_inj = BP_VECTOR | SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT;
+	/* The return address pushed on stack, skip over UD2 */
+	vmcb->control.next_rip = vmcb->save.rip + 2;
+
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT_3(vmcb->control.exit_code == SVM_EXIT_HLT,
+		       vmcb->control.exit_code,
+		       vmcb->control.exit_info_1, vmcb->control.exit_info_2);
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_cpuid_entry2 *cpuid;
+	struct kvm_vm *vm;
+	vm_vaddr_t svm_gva;
+	struct kvm_guest_debug debug;
+
+	nested_svm_check_supported();
+
+	cpuid = kvm_get_supported_cpuid_entry(0x8000000a);
+	if (!(cpuid->edx & X86_FEATURE_NRIPS)) {
+		print_skip("nRIP Save unavailable");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	vm_install_exception_handler(vm, BP_VECTOR, guest_bp_handler);
+	vm_install_exception_handler(vm, INT_NR, guest_int_handler);
+
+	vcpu_alloc_svm(vm, &svm_gva);
+	vcpu_args_set(vm, VCPU_ID, 1, svm_gva);
+
+	memset(&debug, 0, sizeof(debug));
+	vcpu_set_guest_debug(vm, VCPU_ID, &debug);
+
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct ucall uc;
+
+	vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+
+	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	case UCALL_ABORT:
+		TEST_FAIL("%s at %s:%ld, vals = 0x%lx 0x%lx 0x%lx", (const char *)uc.args[0],
+			  __FILE__, uc.args[1], uc.args[2], uc.args[3], uc.args[4]);
+		break;
+		/* NOT REACHED */
+	case UCALL_DONE:
+		goto done;
+	default:
+		TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
+	}
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.35.1.1094.g7c7d902a7c-goog

