Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F642994DD
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 19:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1789232AbgJZSJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 14:09:33 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:49127 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1783424AbgJZSJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 14:09:32 -0400
Received: by mail-pl1-f202.google.com with SMTP id w16so6651317ply.15
        for <kvm@vger.kernel.org>; Mon, 26 Oct 2020 11:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=zYeU5E36ZI2chRmPSnZCOPYqmRd6q1YSpnXrtYp1BPQ=;
        b=FfTY0xzW4VWKnPUk3ml3P0e/U422vUS761R0MrlqUp5J6+E2RV8HoktdgbqHTbkR/h
         wAaGXSjrhZeOxYWxhWfyQpo2BGTSL5NZSd1So77+Pa7dP4Lg7nenTl3xbepMKwBr9qNO
         Nxru9qTyMUdJxRHcAn2TZzNm4vzOB+w9I+9/BsE/w24I2d/HFuFaSLZJmTet/6s2IA7z
         TfQLZMG61Uzvqj+knwGlDz5WZk3VP6eHxm4Y334OH089HS+GU1X/m/+vyzuOy3sDXHeq
         4fVKErKC93IOV2mPHm6tBuWNsOIJy6+RS/xf613gY5wxMwBTfv373qlVgQkeGhOsLQCD
         TL8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=zYeU5E36ZI2chRmPSnZCOPYqmRd6q1YSpnXrtYp1BPQ=;
        b=ILlNvrnHyxQKXp2cywAOfDTg/iCMF3AkTO+qsmHLd1ynKsrCdnsj+Yq081IXLw6McM
         Yc86U5pob3+YBrovzGUiB8VvgZhRBLumQ34PDl0cGR1/dLK2ze0pLULssqB8vMH3hrXU
         O3/6ZaD4QQ0CWaLjw/yWc9bdiQj6zL0kbEIgfbWxSAOM5x40cKF9U47EhYOC4m2a19v7
         3sxY9z7MTmX4GW2lBeecaFD7K7yC80bgjan7azoWg/aqrxWgzrUiWKu5YANehQXZkOOz
         VeTLQUAg14E7si/cLnW2ZvAq4EnrgJgw4462RCN5e2l1xBb0thkir/8CZ2e7Lm1AYdlK
         AgWw==
X-Gm-Message-State: AOAM531usVl3dhGIeEVHm+qJjqE26J4cWqLv+6LmPsnLUhIuy6qIh7BS
        Y2iJcMKRMfon2F6FZMZdiJcLxIIT+2rvCw6yH3QS6X0+MArym4BNHCELPdAv3Zn8OnTgUIqc6dg
        4wFwFjgo/LKUf9sWvPYQgawp1gLlw+pY15nmIucHS8sSBExt6DfSdjk4dR8aruhM=
X-Google-Smtp-Source: ABdhPJztKiTo01sBU3Q1QZvRSsc9TBaR/pfQTRtRcUNeY63pjYAQfs42JQhKBHW9FMyDGZ3F5L2iuTWU+sVIMQ==
Sender: "jmattson via sendgmr" <jmattson@turtle.sea.corp.google.com>
X-Received: from turtle.sea.corp.google.com ([2620:15c:100:202:725a:fff:fe43:64b1])
 (user=jmattson job=sendgmr) by 2002:a17:90a:d590:: with SMTP id
 v16mr17946741pju.88.1603735771282; Mon, 26 Oct 2020 11:09:31 -0700 (PDT)
Date:   Mon, 26 Oct 2020 11:09:22 -0700
Message-Id: <20201026180922.3120555-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
Subject: [PATCH] KVM: selftests: test behavior of unmapped L2 APIC-access address
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a regression test for commit 671ddc700fd0 ("KVM: nVMX: Don't leak
L1 MMIO regions to L2").

First, check to see that an L2 guest can be launched with a valid
APIC-access address that is backed by a page of L1 physical memory.

Next, set the APIC-access address to a (valid) L1 physical address
that is not backed by memory. KVM can't handle this situation, so
resuming L2 should result in a KVM exit for internal error
(emulation).

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/vmx.h        |   6 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   9 ++
 .../kvm/x86_64/vmx_apic_access_test.c         | 142 ++++++++++++++++++
 5 files changed, 159 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 307ceaadbbb9..d2c2d6205008 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -15,6 +15,7 @@
 /x86_64/vmx_preemption_timer_test
 /x86_64/svm_vmcall_test
 /x86_64/sync_regs_test
+/x86_64/vmx_apic_access_test
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_dirty_log_test
 /x86_64/vmx_set_nested_state_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 7ebe71fbca53..30afbad36cd5 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -49,6 +49,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_apic_access_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 54d624dd6c10..e78d7e26ba61 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -573,6 +573,10 @@ struct vmx_pages {
 	void *eptp_hva;
 	uint64_t eptp_gpa;
 	void *eptp;
+
+	void *apic_access_hva;
+	uint64_t apic_access_gpa;
+	void *apic_access;
 };
 
 union vmx_basic {
@@ -615,5 +619,7 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 			uint32_t memslot, uint32_t eptp_memslot);
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot);
+void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm,
+				      uint32_t eptp_memslot);
 
 #endif /* SELFTEST_KVM_VMX_H */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index f1e00d43eea2..2448b30e8efa 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -542,3 +542,12 @@ void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 	vmx->eptp_hva = addr_gva2hva(vm, (uintptr_t)vmx->eptp);
 	vmx->eptp_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->eptp);
 }
+
+void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm,
+				      uint32_t eptp_memslot)
+{
+	vmx->apic_access = (void *)vm_vaddr_alloc(vm, getpagesize(),
+						  0x10000, 0, 0);
+	vmx->apic_access_hva = addr_gva2hva(vm, (uintptr_t)vmx->apic_access);
+	vmx->apic_access_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->apic_access);
+}
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
new file mode 100644
index 000000000000..1f65342d6cb7
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vmx_apic_access_test
+ *
+ * Copyright (C) 2020, Google LLC.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ *
+ * The first subtest simply checks to see that an L2 guest can be
+ * launched with a valid APIC-access address that is backed by a
+ * page of L1 physical memory.
+ *
+ * The second subtest sets the APIC-access address to a (valid) L1
+ * physical address that is not backed by memory. KVM can't handle
+ * this situation, so resuming L2 should result in a KVM exit for
+ * internal error (emulation). This is not an architectural
+ * requirement. It is just a shortcoming of KVM. The internal error
+ * is unfortunate, but it's better than what used to happen!
+ */
+
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
+#define VCPU_ID		0
+
+/* The virtual machine object. */
+static struct kvm_vm *vm;
+
+static void l2_guest_code(void)
+{
+	/* Exit to L1 */
+	__asm__ __volatile__("vmcall");
+}
+
+static void l1_guest_code(struct vmx_pages *vmx_pages, unsigned long high_gpa)
+{
+#define L2_GUEST_STACK_SIZE 64
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	uint32_t control;
+
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+
+	/* Prepare the VMCS for L2 execution. */
+	prepare_vmcs(vmx_pages, l2_guest_code,
+		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+	control = vmreadz(CPU_BASED_VM_EXEC_CONTROL);
+	control |= CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
+	vmwrite(CPU_BASED_VM_EXEC_CONTROL, control);
+	control = vmreadz(SECONDARY_VM_EXEC_CONTROL);
+	control |= SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
+	vmwrite(SECONDARY_VM_EXEC_CONTROL, control);
+	vmwrite(APIC_ACCESS_ADDR, vmx_pages->apic_access_gpa);
+
+	/* Try to launch L2 with the memory-backed APIC-access address. */
+	GUEST_SYNC(vmreadz(APIC_ACCESS_ADDR));
+	GUEST_ASSERT(!vmlaunch());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+
+	vmwrite(APIC_ACCESS_ADDR, high_gpa);
+
+	/* Try to resume L2 with the unbacked APIC-access address. */
+	GUEST_SYNC(vmreadz(APIC_ACCESS_ADDR));
+	GUEST_ASSERT(!vmresume());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned long apic_access_addr = ~0ul;
+	unsigned int paddr_width;
+	unsigned int vaddr_width;
+	vm_vaddr_t vmx_pages_gva;
+	unsigned long high_gpa;
+	struct vmx_pages *vmx;
+	bool done = false;
+
+	nested_vmx_check_supported();
+
+	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	kvm_get_cpu_address_width(&paddr_width, &vaddr_width);
+	high_gpa = (1ul << paddr_width) - getpagesize();
+	if ((unsigned long)DEFAULT_GUEST_PHY_PAGES * getpagesize() > high_gpa) {
+		print_skip("No unbacked physical page available");
+		exit(KSFT_SKIP);
+	}
+
+	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
+	prepare_virtualize_apic_accesses(vmx, vm, 0);
+	vcpu_args_set(vm, VCPU_ID, 2, vmx_pages_gva, high_gpa);
+
+	while (!done) {
+		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+		struct ucall uc;
+
+		vcpu_run(vm, VCPU_ID);
+		if (apic_access_addr == high_gpa) {
+			TEST_ASSERT(run->exit_reason ==
+				    KVM_EXIT_INTERNAL_ERROR,
+				    "Got exit reason other than KVM_EXIT_INTERNAL_ERROR: %u (%s)\n",
+				    run->exit_reason,
+				    exit_reason_str(run->exit_reason));
+			TEST_ASSERT(run->internal.suberror ==
+				    KVM_INTERNAL_ERROR_EMULATION,
+				    "Got internal suberror other than KVM_INTERNAL_ERROR_EMULATION: %u\n",
+				    run->internal.suberror);
+			break;
+		}
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
+			    run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
+				  __FILE__, uc.args[1]);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			apic_access_addr = uc.args[1];
+			break;
+		case UCALL_DONE:
+			done = true;
+			break;
+		default:
+			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
+		}
+	}
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.29.0.rc1.297.gfa9743e501-goog

