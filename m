Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8691C6F07
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 13:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgEFLLE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 07:11:04 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57619 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728304AbgEFLKx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 07:10:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588763451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=npOpt8oHol9rhjiongSdF0I22b9oFIvkhMSQyGULjb4=;
        b=N96f/5dqF9uOvfEfmrUUBvoJZuQXNOpg6GvSHg9D2iF9tCwc5qK1y8bjjnolTBYWgVNi+I
        5pdDAQX4FvgeaX5dQazq4Q/UhBvM18oMuXU1HooYIQUqhSZhHqI1hS9t/Sa4hmpOIPpWYR
        LUrvqHrR2KQ/YEqTSlbRP5ReifIvC2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-YPcx_xtQPGe-22HZAwZx5g-1; Wed, 06 May 2020 07:10:46 -0400
X-MC-Unique: YPcx_xtQPGe-22HZAwZx5g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 802C91899520;
        Wed,  6 May 2020 11:10:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBE745C1D6;
        Wed,  6 May 2020 11:10:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 5/9] KVM: selftests: Add KVM_SET_GUEST_DEBUG test
Date:   Wed,  6 May 2020 07:10:30 -0400
Message-Id: <20200506111034.11756-6-pbonzini@redhat.com>
In-Reply-To: <20200506111034.11756-1-pbonzini@redhat.com>
References: <20200506111034.11756-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

Covers fundamental tests for KVM_SET_GUEST_DEBUG. It is very close to the debug
test in kvm-unit-test, but doing it from outside the guest.

Signed-off-by: Peter Xu <peterx@redhat.com>
Message-Id: <20200505205000.188252-4-peterx@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   9 +
 .../testing/selftests/kvm/x86_64/debug_regs.c | 180 ++++++++++++++++++
 4 files changed, 192 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/debug_regs.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 712a2ddd2a27..44b6ef513164 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -28,6 +28,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
+TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
 TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a99b875f50d2..92e184a422ee 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -143,6 +143,8 @@ struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid);
+void vcpu_set_guest_debug(struct kvm_vm *vm, uint32_t vcpuid,
+			  struct kvm_guest_debug *debug);
 void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
 		       struct kvm_mp_state *mp_state);
 void vcpu_regs_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *regs);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8a3523d4434f..9622431069bc 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1201,6 +1201,15 @@ void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
 		    ret, errno);
 }
 
+void vcpu_set_guest_debug(struct kvm_vm *vm, uint32_t vcpuid,
+			  struct kvm_guest_debug *debug)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+	int ret = ioctl(vcpu->fd, KVM_SET_GUEST_DEBUG, debug);
+
+	TEST_ASSERT(ret == 0, "KVM_SET_GUEST_DEBUG failed: %d", ret);
+}
+
 /*
  * VM VCPU Set MP State
  *
diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86_64/debug_regs.c
new file mode 100644
index 000000000000..077f25d61d1a
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/debug_regs.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM guest debug register tests
+ *
+ * Copyright (C) 2020, Red Hat, Inc.
+ */
+#include <stdio.h>
+#include <string.h>
+#include "kvm_util.h"
+#include "processor.h"
+
+#define VCPU_ID 0
+
+/* For testing data access debug BP */
+uint32_t guest_value;
+
+extern unsigned char sw_bp, hw_bp, write_data, ss_start;
+
+static void guest_code(void)
+{
+	/*
+	 * Software BP tests.
+	 *
+	 * NOTE: sw_bp need to be before the cmd here, because int3 is an
+	 * exception rather than a normal trap for KVM_SET_GUEST_DEBUG (we
+	 * capture it using the vcpu exception bitmap).
+	 */
+	asm volatile("sw_bp: int3");
+
+	/* Hardware instruction BP test */
+	asm volatile("hw_bp: nop");
+
+	/* Hardware data BP test */
+	asm volatile("mov $1234,%%rax;\n\t"
+		     "mov %%rax,%0;\n\t write_data:"
+		     : "=m" (guest_value) : : "rax");
+
+	/* Single step test, covers 2 basic instructions and 2 emulated */
+	asm volatile("ss_start: "
+		     "xor %%rax,%%rax\n\t"
+		     "cpuid\n\t"
+		     "movl $0x1a0,%%ecx\n\t"
+		     "rdmsr\n\t"
+		     : : : "rax", "ecx");
+
+	GUEST_DONE();
+}
+
+#define  CLEAR_DEBUG()  memset(&debug, 0, sizeof(debug))
+#define  APPLY_DEBUG()  vcpu_set_guest_debug(vm, VCPU_ID, &debug)
+#define  CAST_TO_RIP(v)  ((unsigned long long)&(v))
+#define  SET_RIP(v)  do {				\
+		vcpu_regs_get(vm, VCPU_ID, &regs);	\
+		regs.rip = (v);				\
+		vcpu_regs_set(vm, VCPU_ID, &regs);	\
+	} while (0)
+#define  MOVE_RIP(v)  SET_RIP(regs.rip + (v));
+
+int main(void)
+{
+	struct kvm_guest_debug debug;
+	unsigned long long target_dr6, target_rip;
+	struct kvm_regs regs;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	uint64_t cmd;
+	int i;
+	/* Instruction lengths starting at ss_start */
+	int ss_size[4] = {
+		3,		/* xor */
+		2,		/* cpuid */
+		5,		/* mov */
+		2,		/* rdmsr */
+	};
+
+	if (!kvm_check_cap(KVM_CAP_SET_GUEST_DEBUG)) {
+		print_skip("KVM_CAP_SET_GUEST_DEBUG not supported");
+		return 0;
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+	run = vcpu_state(vm, VCPU_ID);
+
+	/* Test software BPs - int3 */
+	CLEAR_DEBUG();
+	debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
+	APPLY_DEBUG();
+	vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
+		    run->debug.arch.exception == BP_VECTOR &&
+		    run->debug.arch.pc == CAST_TO_RIP(sw_bp),
+		    "INT3: exit %d exception %d rip 0x%llx (should be 0x%llx)",
+		    run->exit_reason, run->debug.arch.exception,
+		    run->debug.arch.pc, CAST_TO_RIP(sw_bp));
+	MOVE_RIP(1);
+
+	/* Test instruction HW BP over DR[0-3] */
+	for (i = 0; i < 4; i++) {
+		CLEAR_DEBUG();
+		debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW_BP;
+		debug.arch.debugreg[i] = CAST_TO_RIP(hw_bp);
+		debug.arch.debugreg[7] = 0x400 | (1UL << (2*i+1));
+		APPLY_DEBUG();
+		vcpu_run(vm, VCPU_ID);
+		target_dr6 = 0xffff0ff0 | (1UL << i);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
+			    run->debug.arch.exception == DB_VECTOR &&
+			    run->debug.arch.pc == CAST_TO_RIP(hw_bp) &&
+			    run->debug.arch.dr6 == target_dr6,
+			    "INS_HW_BP (DR%d): exit %d exception %d rip 0x%llx "
+			    "(should be 0x%llx) dr6 0x%llx (should be 0x%llx)",
+			    i, run->exit_reason, run->debug.arch.exception,
+			    run->debug.arch.pc, CAST_TO_RIP(hw_bp),
+			    run->debug.arch.dr6, target_dr6);
+	}
+	/* Skip "nop" */
+	MOVE_RIP(1);
+
+	/* Test data access HW BP over DR[0-3] */
+	for (i = 0; i < 4; i++) {
+		CLEAR_DEBUG();
+		debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW_BP;
+		debug.arch.debugreg[i] = CAST_TO_RIP(guest_value);
+		debug.arch.debugreg[7] = 0x00000400 | (1UL << (2*i+1)) |
+		    (0x000d0000UL << (4*i));
+		APPLY_DEBUG();
+		vcpu_run(vm, VCPU_ID);
+		target_dr6 = 0xffff0ff0 | (1UL << i);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
+			    run->debug.arch.exception == DB_VECTOR &&
+			    run->debug.arch.pc == CAST_TO_RIP(write_data) &&
+			    run->debug.arch.dr6 == target_dr6,
+			    "DATA_HW_BP (DR%d): exit %d exception %d rip 0x%llx "
+			    "(should be 0x%llx) dr6 0x%llx (should be 0x%llx)",
+			    i, run->exit_reason, run->debug.arch.exception,
+			    run->debug.arch.pc, CAST_TO_RIP(write_data),
+			    run->debug.arch.dr6, target_dr6);
+		/* Rollback the 4-bytes "mov" */
+		MOVE_RIP(-7);
+	}
+	/* Skip the 4-bytes "mov" */
+	MOVE_RIP(7);
+
+	/* Test single step */
+	target_rip = CAST_TO_RIP(ss_start);
+	target_dr6 = 0xffff4ff0ULL;
+	vcpu_regs_get(vm, VCPU_ID, &regs);
+	for (i = 0; i < (sizeof(ss_size) / sizeof(ss_size[0])); i++) {
+		target_rip += ss_size[i];
+		CLEAR_DEBUG();
+		debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLESTEP;
+		debug.arch.debugreg[7] = 0x00000400;
+		APPLY_DEBUG();
+		vcpu_run(vm, VCPU_ID);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
+			    run->debug.arch.exception == DB_VECTOR &&
+			    run->debug.arch.pc == target_rip &&
+			    run->debug.arch.dr6 == target_dr6,
+			    "SINGLE_STEP[%d]: exit %d exception %d rip 0x%llx "
+			    "(should be 0x%llx) dr6 0x%llx (should be 0x%llx)",
+			    i, run->exit_reason, run->debug.arch.exception,
+			    run->debug.arch.pc, target_rip, run->debug.arch.dr6,
+			    target_dr6);
+	}
+
+	/* Disable all debug controls, run to the end */
+	CLEAR_DEBUG();
+	APPLY_DEBUG();
+
+	vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO, "KVM_EXIT_IO");
+	cmd = get_ucall(vm, VCPU_ID, &uc);
+	TEST_ASSERT(cmd == UCALL_DONE, "UCALL_DONE");
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.18.2


