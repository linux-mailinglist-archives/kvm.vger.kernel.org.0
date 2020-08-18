Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C83D248FFF
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 23:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgHRVQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 17:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbgHRVQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 17:16:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3866C061347
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p138so23634009yba.12
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xz5QSm61p0XjhKFcQWwjKBjXoWlaoAB1d973hg1RPr4=;
        b=wOcpFyEmJL5mkCukMfdK6Fg/ZvAvLHU3W1M5/UhCxp6D24cvjEZjPEroX4z4J3Ht5v
         m1N/IKmmAaECtaulDsnP+vfN11mvdvmjIEwvCnKDTA9m8szoMPUTf0NB97XzgIOKyd76
         GhylUZ/A2u+vjnth7hpQCUnKM0GudnnIltRmFVxXXi4pADK83HAlPtpl/Qfs2vWNfrkq
         e8nKjxl0/rZczY7wAFusLoLe+7GeLkzLfNPyM4ChYgy10swFGmk9uMsOPUiJ/MtahK74
         fzfIYXV801nOXJlrVJ3GMos71sFxXZzUiHxSHm5TVt88M6FzOXHkuSu3CEf46g9GC5QV
         lRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xz5QSm61p0XjhKFcQWwjKBjXoWlaoAB1d973hg1RPr4=;
        b=HOF8zXwhghTUH7IdvHL6CxhPFfQO/nip7QYVOvbHq6IQMm0w7zKOwWzM7SYizXh/Vr
         OI/OVBv+7uA9dwVQa81dRkceF594C7HV60Kv4v0RxMRgHQ/S6Tb7ZER5fTBCK3Q0qlKx
         3CgGxhxCrcZavS6behd4CokXEgQioRz11l29ERw51yXfFbORbD9GkOvySyAK1cWS4CJo
         ld3XnjkoAgvjQN5qmEg6X7Ry/DAYpGgPUE3VnEzth51PlmPAROTitQzlnYyq+sd4ML5C
         BC+Q2oWT60CVThTPvr0erEyEln8nlhMdVCnTkC+LFz9iEmVeE6N4uEXvUbp3wQM6cxt7
         8new==
X-Gm-Message-State: AOAM5323iBKIibJiBRoj4D5cI2m+73sFkdxS01Yz2kdHWNAF3HnCTlu2
        m2cSlZ12y4YWiT3mz3i1YLdQDZiREiaTAhj6
X-Google-Smtp-Source: ABdhPJyYtvooplOew4QwvGLehfGqeYRcdtCHQIxDIzemPp5o0BCkA46DI6bnng/9pCrAQKD4024t9yR7qAwJgN+m
X-Received: by 2002:a25:cbd6:: with SMTP id b205mr31265933ybg.137.1597785402945;
 Tue, 18 Aug 2020 14:16:42 -0700 (PDT)
Date:   Tue, 18 Aug 2020 14:15:32 -0700
In-Reply-To: <20200818211533.849501-1-aaronlewis@google.com>
Message-Id: <20200818211533.849501-11-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v3 10/12] selftests: kvm: Add exception handling to selftests
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the infrastructure needed to enable exception handling in selftests.
This allows any of the exception and interrupt vectors to be overridden
in the guest.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---

v2 -> v3

  - This commit is new to the series.  It was added to have all the
    infrastructure changes needed to support excpetion handling alone
    in one commit.  The selftest that was included with this change is now
    in another commit. 
  - Removed 'dummy' variable.  This was added to match other regs structs, but
    wasn't needed.  Removed stack adjustment for this in handlers.S as well.

---
 tools/testing/selftests/kvm/Makefile          |  19 ++--
 .../selftests/kvm/include/x86_64/processor.h  |  24 +++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  15 +++
 .../selftests/kvm/lib/kvm_util_internal.h     |   2 +
 .../selftests/kvm/lib/x86_64/handlers.S       |  81 ++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 100 +++++++++++++++++-
 6 files changed, 232 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/handlers.S

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 80d5c348354c..6ba4f61a9765 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -34,7 +34,7 @@ ifeq ($(ARCH),s390)
 endif
 
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c lib/test_util.c
-LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c
+LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
 LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
 
@@ -109,14 +109,21 @@ LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
 include ../lib.mk
 
 STATIC_LIBS := $(OUTPUT)/libkvm.a
-LIBKVM_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM))
-EXTRA_CLEAN += $(LIBKVM_OBJ) $(STATIC_LIBS) cscope.*
+LIBKVM_C := $(filter %.c,$(LIBKVM))
+LIBKVM_S := $(filter %.S,$(LIBKVM))
+LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
+LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
+EXTRA_CLEAN += $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(STATIC_LIBS) cscope.*
+
+x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
+$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-x := $(shell mkdir -p $(sort $(dir $(LIBKVM_OBJ))))
-$(LIBKVM_OBJ): $(OUTPUT)/%.o: %.c
+$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-$(OUTPUT)/libkvm.a: $(LIBKVM_OBJ)
+LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ)
+$(OUTPUT)/libkvm.a: $(LIBKVM_OBJS)
 	$(AR) crs $@ $^
 
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0a65e7bb5249..02530dc6339b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -36,6 +36,8 @@
 #define X86_CR4_SMAP		(1ul << 21)
 #define X86_CR4_PKE		(1ul << 22)
 
+#define UNEXPECTED_VECTOR_PORT 0xfff0u
+
 /* General Registers in 64-Bit Mode */
 struct gpr64_regs {
 	u64 rax;
@@ -239,6 +241,11 @@ static inline struct desc_ptr get_idt(void)
 	return idt;
 }
 
+static inline void outl(uint16_t port, uint32_t value)
+{
+	__asm__ __volatile__("outl %%eax, %%dx" : : "d"(port), "a"(value));
+}
+
 #define SET_XMM(__var, __xmm) \
 	asm volatile("movq %0, %%"#__xmm : : "r"(__var) : #__xmm)
 
@@ -338,6 +345,23 @@ uint32_t kvm_get_cpuid_max_basic(void);
 uint32_t kvm_get_cpuid_max_extended(void);
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
 
+struct ex_regs {
+	uint64_t rax, rcx, rdx, rbx;
+	uint64_t rbp, rsi, rdi;
+	uint64_t r8, r9, r10, r11;
+	uint64_t r12, r13, r14, r15;
+	uint64_t vector;
+	uint64_t error_code;
+	uint64_t rip;
+	uint64_t cs;
+	uint64_t rflags;
+};
+
+void vm_init_descriptor_tables(struct kvm_vm *vm);
+void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
+void vm_handle_exception(struct kvm_vm *vm, int vector,
+			void (*handler)(struct ex_regs *));
+
 /*
  * Basic CPU control in CR0
  */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 74776ee228f2..9eed3fc21c39 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1195,6 +1195,21 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 	do {
 		rc = ioctl(vcpu->fd, KVM_RUN, NULL);
 	} while (rc == -1 && errno == EINTR);
+
+#ifdef __x86_64__
+	if (vcpu_state(vm, vcpuid)->exit_reason == KVM_EXIT_IO
+		&& vcpu_state(vm, vcpuid)->io.port == UNEXPECTED_VECTOR_PORT
+		&& vcpu_state(vm, vcpuid)->io.size == 4) {
+		/* Grab pointer to io data */
+		uint32_t *data = (void *)vcpu_state(vm, vcpuid)
+			+ vcpu_state(vm, vcpuid)->io.data_offset;
+
+		TEST_ASSERT(false,
+			    "Unexpected vectored event in guest (vector:0x%x)",
+			    *data);
+	}
+#endif
+
 	return rc;
 }
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
index 2ef446520748..f07d383d03a1 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -50,6 +50,8 @@ struct kvm_vm {
 	vm_paddr_t pgd;
 	vm_vaddr_t gdt;
 	vm_vaddr_t tss;
+	vm_vaddr_t idt;
+	vm_vaddr_t handlers;
 };
 
 struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/handlers.S b/tools/testing/selftests/kvm/lib/x86_64/handlers.S
new file mode 100644
index 000000000000..aaf7bc7d2ce1
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86_64/handlers.S
@@ -0,0 +1,81 @@
+handle_exception:
+	push %r15
+	push %r14
+	push %r13
+	push %r12
+	push %r11
+	push %r10
+	push %r9
+	push %r8
+
+	push %rdi
+	push %rsi
+	push %rbp
+	push %rbx
+	push %rdx
+	push %rcx
+	push %rax
+	mov %rsp, %rdi
+
+	call route_exception
+
+	pop %rax
+	pop %rcx
+	pop %rdx
+	pop %rbx
+	pop %rbp
+	pop %rsi
+	pop %rdi
+	pop %r8
+	pop %r9
+	pop %r10
+	pop %r11
+	pop %r12
+	pop %r13
+	pop %r14
+	pop %r15
+
+	/* Discard vector and error code. */
+	add $16, %rsp
+	iretq
+
+/*
+ * Build the handle_exception wrappers which push the vector/error code on the
+ * stack and an array of pointers to those wrappers.
+ */
+.pushsection .rodata
+.globl idt_handlers
+idt_handlers:
+.popsection
+
+.macro HANDLERS has_error from to
+	vector = \from
+	.rept \to - \from + 1
+	.align 8
+
+	/* Fetch current address and append it to idt_handlers. */
+	current_handler = .
+.pushsection .rodata
+.quad current_handler
+.popsection
+
+	.if ! \has_error
+	pushq $0
+	.endif
+	pushq $vector
+	jmp handle_exception
+	vector = vector + 1
+	.endr
+.endm
+
+.global idt_handler_code
+idt_handler_code:
+	HANDLERS has_error=0 from=0  to=7
+	HANDLERS has_error=1 from=8  to=8
+	HANDLERS has_error=0 from=9  to=9
+	HANDLERS has_error=1 from=10 to=14
+	HANDLERS has_error=0 from=15 to=16
+	HANDLERS has_error=1 from=17 to=17
+	HANDLERS has_error=0 from=18 to=255
+
+.section        .note.GNU-stack, "", %progbits
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 1ccf6c9b3476..c15817b36267 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -12,6 +12,13 @@
 #include "../kvm_util_internal.h"
 #include "processor.h"
 
+#ifndef NUM_INTERRUPTS
+#define NUM_INTERRUPTS 256
+#endif
+
+#define DEFAULT_CODE_SELECTOR 0x8
+#define DEFAULT_DATA_SELECTOR 0x10
+
 /* Minimum physical address used for virtual translation tables. */
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
 
@@ -557,9 +564,9 @@ static void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_m
 		sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
 
 		kvm_seg_set_unusable(&sregs.ldt);
-		kvm_seg_set_kernel_code_64bit(vm, 0x8, &sregs.cs);
-		kvm_seg_set_kernel_data_64bit(vm, 0x10, &sregs.ds);
-		kvm_seg_set_kernel_data_64bit(vm, 0x10, &sregs.es);
+		kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
+		kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
+		kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
 		kvm_setup_tss_64bit(vm, &sregs.tr, 0x18, gdt_memslot, pgd_memslot);
 		break;
 
@@ -1119,3 +1126,90 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 		*va_bits = (entry->eax >> 8) & 0xff;
 	}
 }
+
+struct idt_entry {
+	uint16_t offset0;
+	uint16_t selector;
+	uint16_t ist : 3;
+	uint16_t : 5;
+	uint16_t type : 4;
+	uint16_t : 1;
+	uint16_t dpl : 2;
+	uint16_t p : 1;
+	uint16_t offset1;
+	uint32_t offset2; uint32_t reserved;
+};
+
+static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
+			  int dpl, unsigned short selector)
+{
+	struct idt_entry *base =
+		(struct idt_entry *)addr_gva2hva(vm, vm->idt);
+	struct idt_entry *e = &base[vector];
+
+	memset(e, 0, sizeof(*e));
+	e->offset0 = addr;
+	e->selector = selector;
+	e->ist = 0;
+	e->type = 14;
+	e->dpl = dpl;
+	e->p = 1;
+	e->offset1 = addr >> 16;
+	e->offset2 = addr >> 32;
+}
+
+void kvm_exit_unexpected_vector(uint32_t value)
+{
+	outl(UNEXPECTED_VECTOR_PORT, value);
+}
+
+void route_exception(struct ex_regs *regs)
+{
+	typedef void(*handler)(struct ex_regs *);
+	handler *handlers;
+
+	handlers = (handler *)rdmsr(MSR_GS_BASE);
+
+	if (handlers[regs->vector]) {
+		handlers[regs->vector](regs);
+		return;
+	}
+
+	kvm_exit_unexpected_vector(regs->vector);
+}
+
+void vm_init_descriptor_tables(struct kvm_vm *vm)
+{
+	extern void *idt_handlers;
+	int i;
+
+	vm->idt = vm_vaddr_alloc(vm, getpagesize(), 0x2000, 0, 0);
+	vm->handlers = vm_vaddr_alloc(vm, 256 * sizeof(void *), 0x2000, 0, 0);
+	/* Handlers have the same address in both address spaces.*/
+	for (i = 0; i < NUM_INTERRUPTS; i++)
+		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
+			DEFAULT_CODE_SELECTOR);
+}
+
+void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct kvm_sregs sregs;
+
+	vcpu_sregs_get(vm, vcpuid, &sregs);
+	sregs.idt.base = vm->idt;
+	sregs.idt.limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
+	sregs.gdt.base = vm->gdt;
+	sregs.gdt.limit = getpagesize() - 1;
+	/* Use GS Base to pass the pointer to the handlers to the guest.*/
+	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
+	sregs.gs.base = (unsigned long) vm->handlers;
+	vcpu_sregs_set(vm, vcpuid, &sregs);
+}
+
+void vm_handle_exception(struct kvm_vm *vm, int vector,
+			 void (*handler)(struct ex_regs *))
+{
+	vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
+
+	handlers[vector] = (vm_vaddr_t)handler;
+}
-- 
2.28.0.220.ged08abb693-goog

