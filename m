Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAC93A392E
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 03:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhFKBNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 21:13:40 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:55225 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbhFKBNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 21:13:40 -0400
Received: by mail-pg1-f201.google.com with SMTP id 69-20020a6306480000b0290220eca74596so761896pgg.21
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 18:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0Vy3Nwd1GGBkUdTlJuaw+dsnK7ZapPt/01OA/6ek0bg=;
        b=JEvfM2CCTThl6vpGEbuvbKc6oVnIbGNxg+xGDLu0LJEZefpRe8BSJOUoWgtIxsrcs1
         jm9hNz5XZ8bJd+y8e4hFw6FWqn2FSbnsNvnnfWLlqLvbF4g8QxXYGqHFqTefmEJ60n7i
         +kQpQ/3IhxMXweMj9OkddfeVi/aQIn+Jk1rH8D0BgaRk3d3mj7he3BstXps5bWQ4nx/R
         xRIQw5a2dmWBV5AcI2YS8roovEBMHsT4AdKEiEYg0U8fGVzV1rMgEnES6sxuUhN+WhAW
         SIoeOG98c5CRx36pAZHHmB1IjQsIk48qOLmTbaqnsRIh2BV1/SB+9hX2V32Rsgm/StSa
         9mPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0Vy3Nwd1GGBkUdTlJuaw+dsnK7ZapPt/01OA/6ek0bg=;
        b=ha7+u8hM/Uepr6Gg9AusoZm3AKzqyTno1eT+sX8+fXeawmNnaJfRXGCPcd2HNB5NC8
         vB0XY4Kh9slmYQqlRcp2pR7w4AAcdRxekxQiYXTh7zv2hUQeHzwPvzfC48WhSrEiGFmz
         GSHli1MYDRmHolB82+S448lvsIbexDJtYPzwzHvV5pdn+MemnD/02u1jOLm5AYKXtUJ5
         myL7kLkvjGXfF9yR/eBygErWb7flErNJDkO5KXnolkUH3EYI9j793KyF0HZaNq7rAhWV
         qGBlnVKwUi8ncR+l5AokTgdhO8SAdny5/b4polJoBpaPiewmjGsHElAdSvtQ6lm0QqhW
         gZIA==
X-Gm-Message-State: AOAM5301fZL9fkAvdBTFMT1ZVQ369RsOedJg0fRUehygqtAMr8cefZJT
        1UETE2nWkvJeiZ7rCbbffDUeXIzz5s6nhMRDoy5kuPOlnIL61M1Z99yMrsRy0BW8eRcUe3uFcqQ
        APHFdUz/JjAPRDT4r1RSlesBI64EOe8AtNdsFdtBWi9XSXxqoBDMsS1Z7oR4aKeo=
X-Google-Smtp-Source: ABdhPJxBM0w/mm0SfnxVO0krsNLHhjwCqXaLhQOQr4Jli+fhlSOym2csEL/URZjoO3GnpKJl6qWiFbypMw+SJg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:2112:: with SMTP id
 kz18mr6052597pjb.58.1623373831322; Thu, 10 Jun 2021 18:10:31 -0700 (PDT)
Date:   Thu, 10 Jun 2021 18:10:19 -0700
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
Message-Id: <20210611011020.3420067-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20210611011020.3420067-1-ricarkol@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v4 5/6] KVM: selftests: Add exception handling support for aarch64
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com, vkuznets@redhat.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the infrastructure needed to enable exception handling in aarch64
selftests. The exception handling defaults to an unhandled-exception
handler which aborts the test, just like x86. These handlers can be
overridden by calling vm_install_exception_handler(vector) or
vm_install_sync_handler(vector, ec). The unhandled exception reporting
from the guest is done using the ucall type introduced in a previous
commit, UCALL_UNHANDLED.

The exception handling code is inspired on kvm-unit-tests.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/include/aarch64/processor.h |  63 +++++++++
 .../selftests/kvm/lib/aarch64/handlers.S      | 126 ++++++++++++++++++
 .../selftests/kvm/lib/aarch64/processor.c     |  97 ++++++++++++++
 4 files changed, 287 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index daaee1888b12..a77e6063f7e9 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -35,7 +35,7 @@ endif
 
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
 LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
-LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
+LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index b7fa0c8551db..b2b3e9d626cb 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -8,6 +8,7 @@
 #define SELFTEST_KVM_PROCESSOR_H
 
 #include "kvm_util.h"
+#include <linux/stringify.h>
 
 
 #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
@@ -18,6 +19,7 @@
 #define MAIR_EL1	3, 0, 10, 2, 0
 #define TTBR0_EL1	3, 0,  2, 0, 0
 #define SCTLR_EL1	3, 0,  1, 0, 0
+#define VBAR_EL1	3, 0, 12, 0, 0
 
 /*
  * Default MAIR
@@ -56,4 +58,65 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
 void aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
 			      struct kvm_vcpu_init *init, void *guest_code);
 
+struct ex_regs {
+	u64 regs[31];
+	u64 sp;
+	u64 pc;
+	u64 pstate;
+};
+
+#define VECTOR_NUM	16
+
+enum {
+	VECTOR_SYNC_CURRENT_SP0,
+	VECTOR_IRQ_CURRENT_SP0,
+	VECTOR_FIQ_CURRENT_SP0,
+	VECTOR_ERROR_CURRENT_SP0,
+
+	VECTOR_SYNC_CURRENT,
+	VECTOR_IRQ_CURRENT,
+	VECTOR_FIQ_CURRENT,
+	VECTOR_ERROR_CURRENT,
+
+	VECTOR_SYNC_LOWER_64,
+	VECTOR_IRQ_LOWER_64,
+	VECTOR_FIQ_LOWER_64,
+	VECTOR_ERROR_LOWER_64,
+
+	VECTOR_SYNC_LOWER_32,
+	VECTOR_IRQ_LOWER_32,
+	VECTOR_FIQ_LOWER_32,
+	VECTOR_ERROR_LOWER_32,
+};
+
+#define VECTOR_IS_SYNC(v) ((v) == VECTOR_SYNC_CURRENT_SP0 || \
+			   (v) == VECTOR_SYNC_CURRENT     || \
+			   (v) == VECTOR_SYNC_LOWER_64    || \
+			   (v) == VECTOR_SYNC_LOWER_32)
+
+#define ESR_EC_NUM		64
+#define ESR_EC_SHIFT		26
+#define ESR_EC_MASK		(ESR_EC_NUM - 1)
+
+void vm_init_descriptor_tables(struct kvm_vm *vm);
+void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
+
+typedef void(*handler_fn)(struct ex_regs *);
+void vm_install_exception_handler(struct kvm_vm *vm,
+		int vector, handler_fn handler);
+void vm_install_sync_handler(struct kvm_vm *vm,
+		int vector, int ec, handler_fn handler);
+
+#define write_sysreg(reg, val)						  \
+({									  \
+	u64 __val = (u64)(val);						  \
+	asm volatile("msr " __stringify(reg) ", %x0" : : "rZ" (__val));	  \
+})
+
+#define read_sysreg(reg)						  \
+({	u64 val;							  \
+	asm volatile("mrs %0, "__stringify(reg) : "=r"(val) : : "memory");\
+	val;								  \
+})
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/handlers.S b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
new file mode 100644
index 000000000000..0e443eadfac6
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
@@ -0,0 +1,126 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+.macro save_registers
+	add	sp, sp, #-16 * 17
+
+	stp	x0, x1, [sp, #16 * 0]
+	stp	x2, x3, [sp, #16 * 1]
+	stp	x4, x5, [sp, #16 * 2]
+	stp	x6, x7, [sp, #16 * 3]
+	stp	x8, x9, [sp, #16 * 4]
+	stp	x10, x11, [sp, #16 * 5]
+	stp	x12, x13, [sp, #16 * 6]
+	stp	x14, x15, [sp, #16 * 7]
+	stp	x16, x17, [sp, #16 * 8]
+	stp	x18, x19, [sp, #16 * 9]
+	stp	x20, x21, [sp, #16 * 10]
+	stp	x22, x23, [sp, #16 * 11]
+	stp	x24, x25, [sp, #16 * 12]
+	stp	x26, x27, [sp, #16 * 13]
+	stp	x28, x29, [sp, #16 * 14]
+
+	/*
+	 * This stores sp_el1 into ex_regs.sp so exception handlers can "look"
+	 * at it. It will _not_ be used to restore the sp on return from the
+	 * exception so handlers can not update it.
+	 */
+	add	x1, sp, #16 * 17
+	stp	x30, x1, [sp, #16 * 15] /* x30, SP */
+
+	mrs	x1, elr_el1
+	mrs	x2, spsr_el1
+	stp	x1, x2, [sp, #16 * 16] /* PC, PSTATE */
+.endm
+
+.macro restore_registers
+	ldp	x1, x2, [sp, #16 * 16] /* PC, PSTATE */
+	msr	elr_el1, x1
+	msr	spsr_el1, x2
+
+	/* sp is not restored */
+	ldp	x30, xzr, [sp, #16 * 15] /* x30, SP */
+
+	ldp	x28, x29, [sp, #16 * 14]
+	ldp	x26, x27, [sp, #16 * 13]
+	ldp	x24, x25, [sp, #16 * 12]
+	ldp	x22, x23, [sp, #16 * 11]
+	ldp	x20, x21, [sp, #16 * 10]
+	ldp	x18, x19, [sp, #16 * 9]
+	ldp	x16, x17, [sp, #16 * 8]
+	ldp	x14, x15, [sp, #16 * 7]
+	ldp	x12, x13, [sp, #16 * 6]
+	ldp	x10, x11, [sp, #16 * 5]
+	ldp	x8, x9, [sp, #16 * 4]
+	ldp	x6, x7, [sp, #16 * 3]
+	ldp	x4, x5, [sp, #16 * 2]
+	ldp	x2, x3, [sp, #16 * 1]
+	ldp	x0, x1, [sp, #16 * 0]
+
+	add	sp, sp, #16 * 17
+
+	eret
+.endm
+
+.pushsection ".entry.text", "ax"
+.balign 0x800
+.global vectors
+vectors:
+.popsection
+
+.set	vector, 0
+
+/*
+ * Build an exception handler for vector and append a jump to it into
+ * vectors (while making sure that it's 0x80 aligned).
+ */
+.macro HANDLER, label
+handler_\label:
+	save_registers
+	mov	x0, sp
+	mov	x1, #vector
+	bl	route_exception
+	restore_registers
+
+.pushsection ".entry.text", "ax"
+.balign 0x80
+	b	handler_\label
+.popsection
+
+.set	vector, vector + 1
+.endm
+
+.macro HANDLER_INVALID
+.pushsection ".entry.text", "ax"
+.balign 0x80
+/* This will abort so no need to save and restore registers. */
+	mov	x0, #vector
+	mov	x1, #0 /* ec */
+	mov	x2, #0 /* valid_ec */
+	b	kvm_exit_unexpected_exception
+.popsection
+
+.set	vector, vector + 1
+.endm
+
+/*
+ * Caution: be sure to not add anything between the declaration of vectors
+ * above and these macro calls that will build the vectors table below it.
+ */
+	HANDLER_INVALID                         // Synchronous EL1t
+	HANDLER_INVALID                         // IRQ EL1t
+	HANDLER_INVALID                         // FIQ EL1t
+	HANDLER_INVALID                         // Error EL1t
+
+	HANDLER	el1h_sync                       // Synchronous EL1h
+	HANDLER	el1h_irq                        // IRQ EL1h
+	HANDLER el1h_fiq                        // FIQ EL1h
+	HANDLER	el1h_error                      // Error EL1h
+
+	HANDLER	el0_sync_64                     // Synchronous 64-bit EL0
+	HANDLER	el0_irq_64                      // IRQ 64-bit EL0
+	HANDLER	el0_fiq_64                      // FIQ 64-bit EL0
+	HANDLER	el0_error_64                    // Error 64-bit EL0
+
+	HANDLER	el0_sync_32                     // Synchronous 32-bit EL0
+	HANDLER	el0_irq_32                      // IRQ 32-bit EL0
+	HANDLER	el0_fiq_32                      // FIQ 32-bit EL0
+	HANDLER	el0_error_32                    // Error 32-bit EL0
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index cee92d477dc0..48b55c93f858 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/compiler.h>
+#include <assert.h>
 
 #include "kvm_util.h"
 #include "../kvm_util_internal.h"
@@ -14,6 +15,8 @@
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR		0x180000
 #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
 
+static vm_vaddr_t exception_handlers;
+
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
 	return (v + vm->page_size) & ~(vm->page_size - 1);
@@ -334,6 +337,100 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
 	va_end(ap);
 }
 
+void kvm_exit_unexpected_exception(int vector, uint64_t ec, bool valid_ec)
+{
+	ucall(UCALL_UNHANDLED, 3, vector, ec, valid_ec);
+	while (1)
+		;
+}
+
 void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
 {
+	struct ucall uc;
+
+	if (get_ucall(vm, vcpuid, &uc) != UCALL_UNHANDLED)
+		return;
+
+	if (uc.args[2]) /* valid_ec */ {
+		assert(VECTOR_IS_SYNC(uc.args[0]));
+		TEST_FAIL("Unexpected exception (vector:0x%lx, ec:0x%lx)",
+			  uc.args[0], uc.args[1]);
+	} else {
+		assert(!VECTOR_IS_SYNC(uc.args[0]));
+		TEST_FAIL("Unexpected exception (vector:0x%lx)",
+			  uc.args[0]);
+	}
+}
+
+struct handlers {
+	handler_fn exception_handlers[VECTOR_NUM][ESR_EC_NUM];
+};
+
+void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	extern char vectors;
+
+	set_reg(vm, vcpuid, ARM64_SYS_REG(VBAR_EL1), (uint64_t)&vectors);
+}
+
+void route_exception(struct ex_regs *regs, int vector)
+{
+	struct handlers *handlers = (struct handlers *)exception_handlers;
+	bool valid_ec;
+	int ec = 0;
+
+	switch (vector) {
+	case VECTOR_SYNC_CURRENT:
+	case VECTOR_SYNC_LOWER_64:
+		ec = (read_sysreg(esr_el1) >> ESR_EC_SHIFT) & ESR_EC_MASK;
+		valid_ec = true;
+		break;
+	case VECTOR_IRQ_CURRENT:
+	case VECTOR_IRQ_LOWER_64:
+	case VECTOR_FIQ_CURRENT:
+	case VECTOR_FIQ_LOWER_64:
+	case VECTOR_ERROR_CURRENT:
+	case VECTOR_ERROR_LOWER_64:
+		ec = 0;
+		valid_ec = false;
+		break;
+	default:
+		valid_ec = false;
+		goto unexpected_exception;
+	}
+
+	if (handlers && handlers->exception_handlers[vector][ec])
+		return handlers->exception_handlers[vector][ec](regs);
+
+unexpected_exception:
+	kvm_exit_unexpected_exception(vector, ec, valid_ec);
+}
+
+void vm_init_descriptor_tables(struct kvm_vm *vm)
+{
+	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
+			vm->page_size, 0, 0);
+
+	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+}
+
+void vm_install_sync_handler(struct kvm_vm *vm, int vector, int ec,
+			 void (*handler)(struct ex_regs *))
+{
+	struct handlers *handlers = addr_gva2hva(vm, vm->handlers);
+
+	assert(VECTOR_IS_SYNC(vector));
+	assert(vector < VECTOR_NUM);
+	assert(ec < ESR_EC_NUM);
+	handlers->exception_handlers[vector][ec] = handler;
+}
+
+void vm_install_exception_handler(struct kvm_vm *vm, int vector,
+			 void (*handler)(struct ex_regs *))
+{
+	struct handlers *handlers = addr_gva2hva(vm, vm->handlers);
+
+	assert(!VECTOR_IS_SYNC(vector));
+	assert(vector < VECTOR_NUM);
+	handlers->exception_handlers[vector][0] = handler;
 }
-- 
2.32.0.272.g935e593368-goog

