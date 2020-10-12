Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBE828C1A0
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 21:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391347AbgJLTro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 15:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391478AbgJLTrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 15:47:43 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790E7C0613D1
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 12:47:43 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id w11so3061192pgf.18
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 12:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=fcHsD/Mg51qiV+MYCCs5Pufq2WHVlY4bU+bl6w+GYtI=;
        b=Xy/dPTlecfeeKwxFw09U+fPxlHxREDAJtvk1LjrlzFePewCkfyj4QaOAdMPR0k+ceX
         4WbFH//8GPUJ35JIfy8P/JdXzJgDEqz5RwiWcPrHznuuGP9I7asGo8g5zAxseRgqrYDM
         aW7n3K0JBp23Um40LX05w7rWlXqdr7kOU6Dpn9qINMIQvXsNpn+yBhJaIwDzlMI3Gv6E
         d4w+CueMiO9s8yO8Nnle76Gsy5MpWcmYdw7gwYGmdqR4+Xe9RBU6iOia4jT3h86tU5Aa
         y0xZn5ayvQ0efchJuLR3gdYVv58FmaDoGcoKlGewm9fPSGQiye0z2dOOQvBrCPDxYmwU
         lAuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fcHsD/Mg51qiV+MYCCs5Pufq2WHVlY4bU+bl6w+GYtI=;
        b=OoA5T1MTbUA0DqwRomynJVCrPhZTv2JBwebvl+ec0dlX2xufnonHZINsb2AYk6EIDJ
         tFz8AHEGfGpN30ASdM/9mse8tll5+YqKZBSJlgOAESe2xC01U3UxsYw+OwKz+//jMzfo
         TwFokrkGQXAY2bfdgIg1DQBD9oqH3vj5M+johalYC2oBjRlAJIEBT6W0jLiFvXsA7CWH
         1SDxK7S5Y36LhhLdtNQkULjD3fRjxiIvNSJNkELyH4Ch1qv3x5cE4e9YHgWzz/J1PvJ0
         CKuGBAEBFZoPovEGIMFMDd4WSZKb8lZhZWwIbuus5HCIO92tZz2lDpJGwRSr2zbXLkks
         IvJA==
X-Gm-Message-State: AOAM531PJzS9ltc8f7taDSiLiKMRlZpByReAN2mua3tu5fJaGvwIC4Yj
        F2G3phm3xio4f8rEJmjvwrGvbB2xn/Dk/yFQ
X-Google-Smtp-Source: ABdhPJyrGYzE5MRpSq9h45ahvEP3lOScv6gqTWAQZJJ78ksqcHHlcexaAbbWAZ/nEDzZX0HP3nFVImApITaj23ww
Sender: "aaronlewis via sendgmr" <aaronlewis@aaronlewis1.sea.corp.google.com>
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:940c:: with SMTP id
 r12mr3123638pjo.1.1602532062639; Mon, 12 Oct 2020 12:47:42 -0700 (PDT)
Date:   Mon, 12 Oct 2020 12:47:15 -0700
In-Reply-To: <20201012194716.3950330-1-aaronlewis@google.com>
Message-Id: <20201012194716.3950330-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20201012194716.3950330-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v3 3/4] selftests: kvm: Add exception handling to selftests
From:   Aaron Lewis <aaronlewis@google.com>
To:     graf@amazon.com
Cc:     pshier@google.com, jmattson@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the infrastructure needed to enable exception handling in selftests.
This allows any of the exception and interrupt vectors to be overridden
in the guest.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---

v1 -> v2:

  - Use exception_handlers instead of gs base to pass table to the guest.
  - Move unexpected vector assert to processor.c.

v2 -> v3:

  - Add stubs for assert_on_unhandled_exception() in aarch64 and s390x.

---
 tools/testing/selftests/kvm/Makefile          |  19 ++-
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/include/x86_64/processor.h  |  24 ++++
 .../selftests/kvm/lib/aarch64/processor.c     |   4 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   3 +
 .../selftests/kvm/lib/kvm_util_internal.h     |   2 +
 .../selftests/kvm/lib/s390x/processor.c       |   4 +
 .../selftests/kvm/lib/x86_64/handlers.S       |  81 +++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 114 +++++++++++++++++-
 9 files changed, 244 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/handlers.S

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 7ebe71fbca53..aaaf992faf87 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -34,7 +34,7 @@ ifeq ($(ARCH),s390)
 endif
 
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c lib/test_util.c
-LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c
+LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
 LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
 
@@ -110,14 +110,21 @@ LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
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
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 919e161dd289..356930690bea 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -294,6 +294,8 @@ int vm_create_device(struct kvm_vm *vm, struct kvm_create_device *cd);
 	memcpy(&(g), _p, sizeof(g));				\
 })
 
+void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
+
 /* Common ucalls */
 enum {
 	UCALL_NONE,
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
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 2afa6618b396..d6c32c328e9a 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -350,3 +350,7 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
 
 	va_end(ap);
 }
+
+void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
+{
+}
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 74776ee228f2..9a7115071c66 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1195,6 +1195,9 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 	do {
 		rc = ioctl(vcpu->fd, KVM_RUN, NULL);
 	} while (rc == -1 && errno == EINTR);
+
+	assert_on_unhandled_exception(vm, vcpuid);
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
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index a88c5d665725..7349bb2e1a24 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -241,3 +241,7 @@ void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 	fprintf(stream, "%*spstate: psw: 0x%.16llx:0x%.16llx\n",
 		indent, "", vcpu->state->psw_mask, vcpu->state->psw_addr);
 }
+
+void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
+{
+}
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
index 1ccf6c9b3476..66228297ac03 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -12,9 +12,18 @@
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
 
+vm_vaddr_t exception_handlers;
+
 /* Virtual translation table structure declarations */
 struct pageMapL4Entry {
 	uint64_t present:1;
@@ -557,9 +566,9 @@ static void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_m
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
 
@@ -1119,3 +1128,102 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
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
+	handler *handlers = (handler *)exception_handlers;
+
+	if (handlers && handlers[regs->vector]) {
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
+	kvm_seg_set_kernel_data_64bit(NULL, DEFAULT_DATA_SELECTOR, &sregs.gs);
+	vcpu_sregs_set(vm, vcpuid, &sregs);
+	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+}
+
+void vm_handle_exception(struct kvm_vm *vm, int vector,
+			 void (*handler)(struct ex_regs *))
+{
+	vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
+
+	handlers[vector] = (vm_vaddr_t)handler;
+}
+
+void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
+{
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
+}
-- 
2.28.0.1011.ga647a8990f-goog

