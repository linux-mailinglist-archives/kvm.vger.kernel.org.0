Return-Path: <kvm+bounces-2070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CB6647F134D
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:30:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3149FB21A43
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 12:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C89E01B274;
	Mon, 20 Nov 2023 12:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CzQiRVCg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC3D106
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 04:29:43 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6c3363a2b93so4131351b3a.3
        for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 04:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700483383; x=1701088183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v/dv+m1OP4SpOwophIIrw7mc0OQmATSGByhT1V5rbbI=;
        b=CzQiRVCggeMpG+l0l6Q2pWERL7QVtvAmhBNe4PJ5IGzF/r2JVyEZaCylbpucJjj1fT
         yxc2/MFkbnoIqIabIjJNytyaJIsaTkrHUG13I3B+UOpQwoMWdT2q/XULGiZ5XooWD2qX
         hfJLpOt3f9LV3xISyrE2z/izsJ34zNTeNXeW3MEU2KMt22S2fYWgVVLzy/Qo1JzpZ/g6
         isAEkl/tEZ8ke56g5+bSIz3nVAk3kNHnJ/5sXx0AfsEpQyVfeE7gFLs8Rk+PraoxB/0e
         47yLzXeR+zAdIGspkGUgjoxWt4ZD9xab4WMWE33+9RUsZgFw8RR1Gfl1X6yfQkugzyAm
         xIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700483383; x=1701088183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v/dv+m1OP4SpOwophIIrw7mc0OQmATSGByhT1V5rbbI=;
        b=l3SmJQ+QfgQxZqDLTHbX4K/8P5k61dJoWNl3Usfxde6PVLi1BxjrwrO/n5xIJoudLQ
         F8VnIu5em1CzgWl1nGNz8fWQqT6O2W6MFVieC7inabp2FceIvLgjhIUdfV+B0xldxH9a
         YvuS+Wrg/3hhtnz1+YwipA/vXaYvFtSDHkMOwn2AlWfd0mOvQXOdhjZCquvjCPRNJ0gQ
         QQCDF5g+EkV0iue1HHij5PnxHc6Lhi0FgIOX0GUpmnMFsRb/JpwMNLIegi96S8MbkQL7
         EhUD1CxNj5QkOATy2zI48/IWzXbfeICKlYC/rS1KNJpJV2SP5QPXeu9/2ce5hlCLyr1j
         EhtQ==
X-Gm-Message-State: AOJu0Yx4vmKednvsBxdWO0TYVnqe4EgF8Hyi/IRRFRPgRPFmiTpdz1fJ
	DGwo6XwMzIJi05j80o+f1fGkgbGjhAw=
X-Google-Smtp-Source: AGHT+IFUElbJUdhKCO76vx8eTkGYMuX9+4CExFdFYaUf8zqqmJgrknDWCx0vYm3fNYrIpxKzatbqmg==
X-Received: by 2002:a05:6a00:ad4:b0:6c4:e7a0:af4a with SMTP id c20-20020a056a000ad400b006c4e7a0af4amr10359075pfl.32.1700483382719;
        Mon, 20 Nov 2023 04:29:42 -0800 (PST)
Received: from wheely.local0.net (203-219-179-16.tpgi.com.au. [203.219.179.16])
        by smtp.gmail.com with ESMTPSA id d13-20020a056a00244d00b00690fe1c928csm6047477pfj.147.2023.11.20.04.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 04:29:42 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org,
	Sean Christopherson <seanjc@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v4 3/4] KVM: PPC: selftests: add support for powerpc
Date: Mon, 20 Nov 2023 22:29:19 +1000
Message-ID: <20231120122920.293076-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231120122920.293076-1-npiggin@gmail.com>
References: <20231120122920.293076-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement KVM selftests support for powerpc (Book3S-64).

ucalls are implemented with an unsuppored PAPR hcall number which will
always cause KVM to exit to userspace.

Virtual memory is implemented for the radix MMU, and only a base page
size is supported (both 4K and 64K).

Guest interrupts are taken in real-mode, so require a page allocated at
gRA 0x0. Interrupt entry is complicated because gVA:gRA is not 1:1 mapped
(like the kernel is), so the MMU can not just just be switched on and
off.

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 MAINTAINERS                                   |   2 +
 tools/testing/selftests/kvm/Makefile          |  19 +
 .../selftests/kvm/include/kvm_util_base.h     |  24 +
 .../selftests/kvm/include/powerpc/hcall.h     |  17 +
 .../selftests/kvm/include/powerpc/ppc_asm.h   |  32 ++
 .../selftests/kvm/include/powerpc/processor.h |  39 ++
 .../selftests/kvm/include/powerpc/ucall.h     |  21 +
 tools/testing/selftests/kvm/lib/guest_modes.c |  27 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  12 +
 .../selftests/kvm/lib/powerpc/handlers.S      |  93 ++++
 .../testing/selftests/kvm/lib/powerpc/hcall.c |  45 ++
 .../selftests/kvm/lib/powerpc/processor.c     | 468 ++++++++++++++++++
 .../testing/selftests/kvm/lib/powerpc/ucall.c |  21 +
 tools/testing/selftests/kvm/powerpc/helpers.h |  46 ++
 14 files changed, 862 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/powerpc/hcall.h
 create mode 100644 tools/testing/selftests/kvm/include/powerpc/ppc_asm.h
 create mode 100644 tools/testing/selftests/kvm/include/powerpc/processor.h
 create mode 100644 tools/testing/selftests/kvm/include/powerpc/ucall.h
 create mode 100644 tools/testing/selftests/kvm/lib/powerpc/handlers.S
 create mode 100644 tools/testing/selftests/kvm/lib/powerpc/hcall.c
 create mode 100644 tools/testing/selftests/kvm/lib/powerpc/processor.c
 create mode 100644 tools/testing/selftests/kvm/lib/powerpc/ucall.c
 create mode 100644 tools/testing/selftests/kvm/powerpc/helpers.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 97f51d5ec1cf..3f430d517462 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11705,6 +11705,8 @@ F:	arch/powerpc/include/asm/kvm*
 F:	arch/powerpc/include/uapi/asm/kvm*
 F:	arch/powerpc/kernel/kvm*
 F:	arch/powerpc/kvm/
+F:	tools/testing/selftests/kvm/*/powerpc/
+F:	tools/testing/selftests/kvm/powerpc/
 
 KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
 M:	Anup Patel <anup@brainfault.org>
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a5963ab9215b..a198fe6136c8 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -65,6 +65,11 @@ LIBKVM_s390x += lib/s390x/ucall.c
 LIBKVM_riscv += lib/riscv/processor.c
 LIBKVM_riscv += lib/riscv/ucall.c
 
+LIBKVM_powerpc += lib/powerpc/handlers.S
+LIBKVM_powerpc += lib/powerpc/processor.c
+LIBKVM_powerpc += lib/powerpc/ucall.c
+LIBKVM_powerpc += lib/powerpc/hcall.c
+
 # Non-compiled test targets
 TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
 
@@ -200,6 +205,20 @@ TEST_GEN_PROGS_riscv += kvm_page_table_test
 TEST_GEN_PROGS_riscv += set_memory_region_test
 TEST_GEN_PROGS_riscv += kvm_binary_stats_test
 
+TEST_GEN_PROGS_powerpc += access_tracking_perf_test
+TEST_GEN_PROGS_powerpc += demand_paging_test
+TEST_GEN_PROGS_powerpc += dirty_log_test
+TEST_GEN_PROGS_powerpc += dirty_log_perf_test
+TEST_GEN_PROGS_powerpc += guest_print_test
+TEST_GEN_PROGS_powerpc += hardware_disable_test
+TEST_GEN_PROGS_powerpc += kvm_page_table_test
+TEST_GEN_PROGS_powerpc += max_guest_memory_test
+TEST_GEN_PROGS_powerpc += memslot_modification_stress_test
+TEST_GEN_PROGS_powerpc += memslot_perf_test
+TEST_GEN_PROGS_powerpc += rseq_test
+TEST_GEN_PROGS_powerpc += set_memory_region_test
+TEST_GEN_PROGS_powerpc += kvm_binary_stats_test
+
 SPLIT_TESTS += get-reg-list
 
 TEST_PROGS += $(TEST_PROGS_$(ARCH_DIR))
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 46edefabac85..3ce0bd0299fa 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -87,6 +87,12 @@ enum kvm_mem_region_type {
 	NR_MEM_REGIONS,
 };
 
+/* Page table fragment cache for guest page table < page size */
+struct vm_pt_frag_cache {
+	vm_paddr_t page;
+	size_t page_nr_used;
+};
+
 struct kvm_vm {
 	int mode;
 	unsigned long type;
@@ -106,6 +112,10 @@ struct kvm_vm {
 	bool pgd_created;
 	vm_paddr_t ucall_mmio_addr;
 	vm_paddr_t pgd;
+#if defined(__powerpc64__)
+	vm_paddr_t prtb; // process table
+	struct vm_pt_frag_cache pt_frag_cache[2]; // 256B and 4KB PT caches
+#endif
 	vm_vaddr_t gdt;
 	vm_vaddr_t tss;
 	vm_vaddr_t idt;
@@ -181,6 +191,8 @@ enum vm_guest_mode {
 	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
 	VM_MODE_P47V64_4K,
 	VM_MODE_P44V64_4K,
+	VM_MODE_P52V52_4K,
+	VM_MODE_P52V52_64K,
 	VM_MODE_P36V48_4K,
 	VM_MODE_P36V48_16K,
 	VM_MODE_P36V48_64K,
@@ -218,6 +230,18 @@ extern enum vm_guest_mode vm_mode_default;
 #define MIN_PAGE_SHIFT			12U
 #define ptes_per_page(page_size)	((page_size) / 8)
 
+#elif defined(__powerpc64__)
+
+extern enum vm_guest_mode vm_mode_default;
+
+#define VM_MODE_DEFAULT			vm_mode_default
+#define MIN_PAGE_SHIFT			12U
+#define ptes_per_page(page_size)	((page_size) / 8)
+
+#else
+
+#error "KVM selftests not implemented for architecture"
+
 #endif
 
 #define MIN_PAGE_SIZE		(1U << MIN_PAGE_SHIFT)
diff --git a/tools/testing/selftests/kvm/include/powerpc/hcall.h b/tools/testing/selftests/kvm/include/powerpc/hcall.h
new file mode 100644
index 000000000000..4028baa6c5d8
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/powerpc/hcall.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * powerpc hcall defines
+ */
+#ifndef SELFTEST_KVM_HCALL_H
+#define SELFTEST_KVM_HCALL_H
+
+#include <linux/compiler.h>
+
+/* Ucalls use unimplemented PAPR hcall 0 which exits KVM */
+#define H_UCALL	0
+
+int64_t hcall0(uint64_t token);
+int64_t hcall1(uint64_t token, uint64_t arg1);
+int64_t hcall2(uint64_t token, uint64_t arg1, uint64_t arg2);
+
+#endif
diff --git a/tools/testing/selftests/kvm/include/powerpc/ppc_asm.h b/tools/testing/selftests/kvm/include/powerpc/ppc_asm.h
new file mode 100644
index 000000000000..b9df64659792
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/powerpc/ppc_asm.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * powerpc asm specific defines
+ */
+#ifndef SELFTEST_KVM_PPC_ASM_H
+#define SELFTEST_KVM_PPC_ASM_H
+
+#define STACK_FRAME_MIN_SIZE	112 /* Could be 32 on ELFv2 */
+#define STACK_REDZONE_SIZE	512
+
+#define INT_FRAME_SIZE		(STACK_FRAME_MIN_SIZE + STACK_REDZONE_SIZE)
+
+#define SPR_SRR0	0x01a
+#define SPR_SRR1	0x01b
+#define SPR_CFAR	0x01c
+
+#define MSR_SF		0x8000000000000000ULL
+#define MSR_HV		0x1000000000000000ULL
+#define MSR_VEC		0x0000000002000000ULL
+#define MSR_VSX		0x0000000000800000ULL
+#define MSR_EE		0x0000000000008000ULL
+#define MSR_PR		0x0000000000004000ULL
+#define MSR_FP		0x0000000000002000ULL
+#define MSR_ME		0x0000000000001000ULL
+#define MSR_IR		0x0000000000000020ULL
+#define MSR_DR		0x0000000000000010ULL
+#define MSR_RI		0x0000000000000002ULL
+#define MSR_LE		0x0000000000000001ULL
+
+#define LPCR_ILE	0x0000000002000000ULL
+
+#endif
diff --git a/tools/testing/selftests/kvm/include/powerpc/processor.h b/tools/testing/selftests/kvm/include/powerpc/processor.h
new file mode 100644
index 000000000000..ce5a23525dbd
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/powerpc/processor.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * powerpc processor specific defines
+ */
+#ifndef SELFTEST_KVM_PROCESSOR_H
+#define SELFTEST_KVM_PROCESSOR_H
+
+#include <linux/compiler.h>
+#include "ppc_asm.h"
+
+extern unsigned char __interrupts_start[];
+extern unsigned char __interrupts_end[];
+
+struct kvm_vm;
+struct kvm_vcpu;
+extern bool (*interrupt_handler)(struct kvm_vcpu *vcpu, unsigned trap);
+
+struct ex_regs {
+	uint64_t	gprs[32];
+	uint64_t	nia;
+	uint64_t	msr;
+	uint64_t	cfar;
+	uint64_t	lr;
+	uint64_t	ctr;
+	uint64_t	xer;
+	uint32_t	cr;
+	uint32_t	trap;
+	uint64_t	vaddr; /* vaddr of this struct */
+};
+
+void vm_install_exception_handler(struct kvm_vm *vm, int vector,
+			void (*handler)(struct ex_regs *));
+
+static inline void cpu_relax(void)
+{
+	asm volatile("" ::: "memory");
+}
+
+#endif
diff --git a/tools/testing/selftests/kvm/include/powerpc/ucall.h b/tools/testing/selftests/kvm/include/powerpc/ucall.h
new file mode 100644
index 000000000000..6b1a40997f41
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/powerpc/ucall.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SELFTEST_KVM_UCALL_H
+#define SELFTEST_KVM_UCALL_H
+
+#include "hcall.h"
+
+#define UCALL_EXIT_REASON	KVM_EXIT_PAPR_HCALL
+
+#define UCALL_R4_UCALL	0x5715 // regular ucall, r5 contains ucall pointer
+#define UCALL_R4_SIMPLE	0x0000 // simple exit usable by asm with no ucall data
+
+static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+{
+}
+
+static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+{
+	hcall2(H_UCALL, UCALL_R4_UCALL, (uintptr_t)(uc));
+}
+
+#endif
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index 1df3ce4b16fd..4dfaed1706d9 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -4,7 +4,11 @@
  */
 #include "guest_modes.h"
 
-#ifdef __aarch64__
+#if defined(__powerpc__)
+#include <unistd.h>
+#endif
+
+#if defined(__aarch64__) || defined(__powerpc__)
 #include "processor.h"
 enum vm_guest_mode vm_mode_default;
 #endif
@@ -13,9 +17,7 @@ struct guest_mode guest_modes[NUM_VM_MODES];
 
 void guest_modes_append_default(void)
 {
-#ifndef __aarch64__
-	guest_mode_append(VM_MODE_DEFAULT, true, true);
-#else
+#ifdef __aarch64__
 	{
 		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
 		bool ps4k, ps16k, ps64k;
@@ -70,6 +72,8 @@ void guest_modes_append_default(void)
 				    KVM_S390_VM_CPU_PROCESSOR, &info);
 		close(vm_fd);
 		close(kvm_fd);
+
+		guest_mode_append(VM_MODE_DEFAULT, true, true);
 		/* Starting with z13 we have 47bits of physical address */
 		if (info.ibc >= 0x30)
 			guest_mode_append(VM_MODE_P47V64_4K, true, true);
@@ -79,12 +83,27 @@ void guest_modes_append_default(void)
 	{
 		unsigned int sz = kvm_check_cap(KVM_CAP_VM_GPA_BITS);
 
+		guest_mode_append(VM_MODE_DEFAULT, true, true);
 		if (sz >= 52)
 			guest_mode_append(VM_MODE_P52V48_4K, true, true);
 		if (sz >= 48)
 			guest_mode_append(VM_MODE_P48V48_4K, true, true);
 	}
 #endif
+#ifdef __powerpc__
+	{
+		TEST_ASSERT(kvm_check_cap(KVM_CAP_PPC_MMU_RADIX),
+			    "Radix MMU not available, KVM selftests "
+			    "does not support Hash MMU!");
+		/* Radix guest EA and RA are 52-bit on POWER9 and POWER10 */
+		if (sysconf(_SC_PAGESIZE) == 4096)
+			vm_mode_default = VM_MODE_P52V52_4K;
+		else
+			vm_mode_default = VM_MODE_P52V52_64K;
+		guest_mode_append(VM_MODE_P52V52_4K, true, true);
+		guest_mode_append(VM_MODE_P52V52_64K, true, true);
+	}
+#endif
 }
 
 void for_each_guest_mode(void (*func)(enum vm_guest_mode, void *), void *arg)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 22cf6c0ca89f..db49abbc1918 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -158,6 +158,8 @@ const char *vm_guest_mode_string(uint32_t i)
 		[VM_MODE_PXXV48_4K]	= "PA-bits:ANY, VA-bits:48,  4K pages",
 		[VM_MODE_P47V64_4K]	= "PA-bits:47,  VA-bits:64,  4K pages",
 		[VM_MODE_P44V64_4K]	= "PA-bits:44,  VA-bits:64,  4K pages",
+		[VM_MODE_P52V52_4K]	= "PA-bits:52,  VA-bits:52,  4K pages",
+		[VM_MODE_P52V52_64K]	= "PA-bits:52,  VA-bits:52, 64K pages",
 		[VM_MODE_P36V48_4K]	= "PA-bits:36,  VA-bits:48,  4K pages",
 		[VM_MODE_P36V48_16K]	= "PA-bits:36,  VA-bits:48, 16K pages",
 		[VM_MODE_P36V48_64K]	= "PA-bits:36,  VA-bits:48, 64K pages",
@@ -183,6 +185,8 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 	[VM_MODE_PXXV48_4K]	= {  0,  0,  0x1000, 12 },
 	[VM_MODE_P47V64_4K]	= { 47, 64,  0x1000, 12 },
 	[VM_MODE_P44V64_4K]	= { 44, 64,  0x1000, 12 },
+	[VM_MODE_P52V52_4K]	= { 52, 52,  0x1000, 12 },
+	[VM_MODE_P52V52_64K]	= { 52, 52, 0x10000, 16 },
 	[VM_MODE_P36V48_4K]	= { 36, 48,  0x1000, 12 },
 	[VM_MODE_P36V48_16K]	= { 36, 48,  0x4000, 14 },
 	[VM_MODE_P36V48_64K]	= { 36, 48, 0x10000, 16 },
@@ -284,6 +288,14 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 	case VM_MODE_P44V64_4K:
 		vm->pgtable_levels = 5;
 		break;
+#ifdef __powerpc__
+	case VM_MODE_P52V52_64K:
+		vm->pgtable_levels = 4;
+		break;
+	case VM_MODE_P52V52_4K:
+		vm->pgtable_levels = 4;
+		break;
+#endif
 	default:
 		TEST_FAIL("Unknown guest mode, mode: 0x%x", mode);
 	}
diff --git a/tools/testing/selftests/kvm/lib/powerpc/handlers.S b/tools/testing/selftests/kvm/lib/powerpc/handlers.S
new file mode 100644
index 000000000000..a68c187b835f
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/powerpc/handlers.S
@@ -0,0 +1,93 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <ppc_asm.h>
+
+.macro INTERRUPT vec
+. = __interrupts_start + \vec
+	std	%r0,(0*8)(%r13)
+	std	%r3,(3*8)(%r13)
+	mfspr	%r0,SPR_CFAR
+	li	%r3,\vec
+	b	handle_interrupt
+.endm
+
+.balign 0x1000
+.global __interrupts_start
+__interrupts_start:
+INTERRUPT 0x100
+INTERRUPT 0x200
+INTERRUPT 0x300
+INTERRUPT 0x380
+INTERRUPT 0x400
+INTERRUPT 0x480
+INTERRUPT 0x500
+INTERRUPT 0x600
+INTERRUPT 0x700
+INTERRUPT 0x800
+INTERRUPT 0x900
+INTERRUPT 0xa00
+INTERRUPT 0xc00
+INTERRUPT 0xd00
+INTERRUPT 0xf00
+INTERRUPT 0xf20
+INTERRUPT 0xf40
+INTERRUPT 0xf60
+
+virt_handle_interrupt:
+	stdu	%r1,-INT_FRAME_SIZE(%r1)
+	mr	%r3,%r31
+	bl	route_interrupt
+	ld	%r4,(32*8)(%r31) /* NIA */
+	ld	%r5,(33*8)(%r31) /* MSR */
+	ld	%r6,(35*8)(%r31) /* LR */
+	ld	%r7,(36*8)(%r31) /* CTR */
+	ld	%r8,(37*8)(%r31) /* XER */
+	lwz	%r9,(38*8)(%r31) /* CR */
+	mtspr	SPR_SRR0,%r4
+	mtspr	SPR_SRR1,%r5
+	mtlr	%r6
+	mtctr	%r7
+	mtxer	%r8
+	mtcr	%r9
+reg=4
+	ld	%r0,(0*8)(%r31)
+	ld	%r3,(3*8)(%r31)
+.rept 28
+	ld	reg,(reg*8)(%r31)
+	reg=reg+1
+.endr
+	addi	%r1,%r1,INT_FRAME_SIZE
+	rfid
+
+virt_handle_interrupt_p:
+	.llong virt_handle_interrupt
+
+handle_interrupt:
+reg=4
+.rept 28
+	std	reg,(reg*8)(%r13)
+	reg=reg+1
+.endr
+	mfspr	%r4,SPR_SRR0
+	mfspr	%r5,SPR_SRR1
+	mflr	%r6
+	mfctr	%r7
+	mfxer	%r8
+	mfcr	%r9
+	std	%r4,(32*8)(%r13) /* NIA */
+	std	%r5,(33*8)(%r13) /* MSR */
+	std	%r0,(34*8)(%r13) /* CFAR */
+	std	%r6,(35*8)(%r13) /* LR */
+	std	%r7,(36*8)(%r13) /* CTR */
+	std	%r8,(37*8)(%r13) /* XER */
+	stw	%r9,(38*8)(%r13) /* CR */
+	stw	%r3,(38*8 + 4)(%r13) /* TRAP */
+
+	ld	%r31,(39*8)(%r13) /* vaddr */
+	ld	%r4,virt_handle_interrupt_p - __interrupts_start(0)
+	mtspr	SPR_SRR0,%r4
+	/* Reuse SRR1 */
+
+	rfid
+.global __interrupts_end
+__interrupts_end:
diff --git a/tools/testing/selftests/kvm/lib/powerpc/hcall.c b/tools/testing/selftests/kvm/lib/powerpc/hcall.c
new file mode 100644
index 000000000000..23a56aabad42
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/powerpc/hcall.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * PAPR (pseries) hcall support.
+ */
+#include "kvm_util.h"
+#include "hcall.h"
+
+int64_t hcall0(uint64_t token)
+{
+	register uintptr_t r3 asm ("r3") = token;
+
+	asm volatile("sc 1" : "+r"(r3) :
+			    : "r0", "r4", "r5", "r6", "r7", "r8", "r9",
+			      "r10","r11", "r12", "ctr", "xer",
+			      "memory");
+
+	return r3;
+}
+
+int64_t hcall1(uint64_t token, uint64_t arg1)
+{
+	register uintptr_t r3 asm ("r3") = token;
+	register uintptr_t r4 asm ("r4") = arg1;
+
+	asm volatile("sc 1" : "+r"(r3), "+r"(r4) :
+			    : "r0", "r5", "r6", "r7", "r8", "r9",
+			      "r10","r11", "r12", "ctr", "xer",
+			      "memory");
+
+	return r3;
+}
+
+int64_t hcall2(uint64_t token, uint64_t arg1, uint64_t arg2)
+{
+	register uintptr_t r3 asm ("r3") = token;
+	register uintptr_t r4 asm ("r4") = arg1;
+	register uintptr_t r5 asm ("r5") = arg2;
+
+	asm volatile("sc 1" : "+r"(r3), "+r"(r4), "+r"(r5) :
+			    : "r0", "r6", "r7", "r8", "r9",
+			      "r10","r11", "r12", "ctr", "xer",
+			      "memory");
+
+	return r3;
+}
diff --git a/tools/testing/selftests/kvm/lib/powerpc/processor.c b/tools/testing/selftests/kvm/lib/powerpc/processor.c
new file mode 100644
index 000000000000..8f176cad3c7d
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/powerpc/processor.c
@@ -0,0 +1,468 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM selftest powerpc library code - CPU-related functions (page tables...)
+ */
+
+#include <linux/sizes.h>
+
+#include "processor.h"
+#include "kvm_util.h"
+#include "kvm_util_base.h"
+#include "guest_modes.h"
+#include "hcall.h"
+
+#define RADIX_TREE_SIZE ((0x2UL << 61) | (0x5UL << 5)) // 52-bits
+#define RADIX_PGD_INDEX_SIZE 13
+
+static void set_proc_table(struct kvm_vm *vm, int pid, uint64_t dw0, uint64_t dw1)
+{
+	uint64_t *proc_table;
+
+	proc_table = addr_gpa2hva(vm, vm->prtb);
+	proc_table[pid * 2 + 0] = cpu_to_be64(dw0);
+	proc_table[pid * 2 + 1] = cpu_to_be64(dw1);
+}
+
+static void set_radix_proc_table(struct kvm_vm *vm, int pid, vm_paddr_t pgd)
+{
+	set_proc_table(vm, pid, pgd | RADIX_TREE_SIZE | RADIX_PGD_INDEX_SIZE, 0);
+}
+
+void virt_arch_pgd_alloc(struct kvm_vm *vm)
+{
+	struct kvm_ppc_mmuv3_cfg mmu_cfg;
+	vm_paddr_t prtb, pgtb;
+	size_t pgd_pages;
+
+	TEST_ASSERT((vm->mode == VM_MODE_P52V52_4K) ||
+		    (vm->mode == VM_MODE_P52V52_64K),
+		    "Unsupported guest mode, mode: 0x%x", vm->mode);
+
+	prtb = vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+				 vm->memslots[MEM_REGION_PT]);
+	vm->prtb = prtb;
+
+	pgd_pages = (1UL << (RADIX_PGD_INDEX_SIZE + 3)) >> vm->page_shift;
+	if (!pgd_pages)
+		pgd_pages = 1;
+	pgtb = vm_phy_pages_alloc_align(vm, pgd_pages, pgd_pages,
+					KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+					vm->memslots[MEM_REGION_PT]);
+	vm->pgd = pgtb;
+
+	/* Set the base page directory in the proc table */
+	set_radix_proc_table(vm, 0, pgtb);
+
+	if (vm->mode == VM_MODE_P52V52_4K)
+		mmu_cfg.process_table = prtb | 0x8000000000000000UL | 0x0; // 4K size
+	else /* vm->mode == VM_MODE_P52V52_64K */
+		mmu_cfg.process_table = prtb | 0x8000000000000000UL | 0x4; // 64K size
+	mmu_cfg.flags = KVM_PPC_MMUV3_RADIX | KVM_PPC_MMUV3_GTSE;
+
+	vm_ioctl(vm, KVM_PPC_CONFIGURE_V3_MMU, &mmu_cfg);
+}
+
+static int pt_shift(struct kvm_vm *vm, int level)
+{
+	switch (level) {
+	case 1:
+		return 13;
+	case 2:
+	case 3:
+		return 9;
+	case 4:
+		if (vm->mode == VM_MODE_P52V52_4K)
+			return 9;
+		else /* vm->mode == VM_MODE_P52V52_64K */
+			return 5;
+	default:
+		TEST_ASSERT(false, "Invalid page table level %d\n", level);
+		return 0;
+	}
+}
+
+static uint64_t pt_entry_coverage(struct kvm_vm *vm, int level)
+{
+	uint64_t size = vm->page_size;
+
+	if (level == 4)
+		return size;
+	size <<= pt_shift(vm, 4);
+	if (level == 3)
+		return size;
+	size <<= pt_shift(vm, 3);
+	if (level == 2)
+		return size;
+	size <<= pt_shift(vm, 2);
+	return size;
+}
+
+static int pt_idx(struct kvm_vm *vm, uint64_t vaddr, int level, uint64_t *nls)
+{
+	switch (level) {
+	case 1:
+		*nls = 0x9;
+		return (vaddr >> 39) & 0x1fff;
+	case 2:
+		*nls = 0x9;
+		return (vaddr >> 30) & 0x1ff;
+	case 3:
+		if (vm->mode == VM_MODE_P52V52_4K)
+			*nls = 0x9;
+		else /* vm->mode == VM_MODE_P52V52_64K */
+			*nls = 0x5;
+		return (vaddr >> 21) & 0x1ff;
+	case 4:
+		if (vm->mode == VM_MODE_P52V52_4K)
+			return (vaddr >> 12) & 0x1ff;
+		else /* vm->mode == VM_MODE_P52V52_64K */
+			return (vaddr >> 16) & 0x1f;
+	default:
+		TEST_ASSERT(false, "Invalid page table level %d\n", level);
+		return 0;
+	}
+}
+
+static uint64_t *virt_get_pte(struct kvm_vm *vm, vm_paddr_t pt,
+			  uint64_t vaddr, int level, uint64_t *nls)
+{
+	int idx = pt_idx(vm, vaddr, level, nls);
+	uint64_t *ptep = addr_gpa2hva(vm, pt + idx*8);
+
+	return ptep;
+}
+
+#define PTE_VALID	0x8000000000000000ull
+#define PTE_LEAF	0x4000000000000000ull
+#define PTE_REFERENCED	0x0000000000000100ull
+#define PTE_CHANGED	0x0000000000000080ull
+#define PTE_PRIV	0x0000000000000008ull
+#define PTE_READ	0x0000000000000004ull
+#define PTE_RW		0x0000000000000002ull
+#define PTE_EXEC	0x0000000000000001ull
+#define PTE_PAGE_MASK	0x01fffffffffff000ull
+
+#define PDE_VALID	PTE_VALID
+#define PDE_NLS		0x0000000000000011ull
+#define PDE_PT_MASK	0x0fffffffffffff00ull
+
+static vm_paddr_t __vm_alloc_pt(struct kvm_vm *vm, uint64_t pt_shift)
+{
+	vm_paddr_t pt;
+
+	if (pt_shift >= vm->page_shift) {
+		size_t pt_pages = 1ULL << (pt_shift - vm->page_shift);
+		pt = vm_phy_pages_alloc_align(vm, pt_pages, pt_pages,
+					KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+					vm->memslots[MEM_REGION_PT]);
+	} else {
+		struct vm_pt_frag_cache *pt_frag_cache;
+
+		if (pt_shift == 8) {
+			pt_frag_cache = &vm->pt_frag_cache[0];
+		} else if (pt_shift == 12) {
+			pt_frag_cache = &vm->pt_frag_cache[1];
+		} else {
+			TEST_ASSERT(0, "Invalid pt_shift:%lu\n", pt_shift);
+			return 0;
+		}
+
+		if (!pt_frag_cache->page) {
+			pt_frag_cache->page = vm_phy_pages_alloc_align(vm, 1, 1,
+						KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+						vm->memslots[MEM_REGION_PT]);
+		}
+		pt = pt_frag_cache->page + pt_frag_cache->page_nr_used;
+		pt_frag_cache->page_nr_used += (1 << pt_shift);
+		if (pt_frag_cache->page_nr_used == vm->page_size) {
+			pt_frag_cache->page = 0;
+			pt_frag_cache->page_nr_used = 0;
+		}
+	}
+
+	return pt;
+}
+
+void virt_arch_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
+{
+	vm_paddr_t pt = vm->pgd;
+	uint64_t *ptep, pte;
+	int level;
+
+	for (level = 1; level <= 3; level++) {
+		uint64_t nls;
+		uint64_t *pdep = virt_get_pte(vm, pt, gva, level, &nls);
+		uint64_t pde = be64_to_cpu(*pdep);
+
+		if (pde) {
+			TEST_ASSERT((pde & PDE_VALID) && !(pde & PTE_LEAF),
+				    "Invalid PDE at level: %u gva: 0x%lx pde:0x%lx\n",
+				    level, gva, pde);
+			pt = pde & PDE_PT_MASK;
+			continue;
+		}
+
+		pt = __vm_alloc_pt(vm, nls + 3);
+		pde = PDE_VALID | nls | pt;
+		*pdep = cpu_to_be64(pde);
+	}
+
+	ptep = virt_get_pte(vm, pt, gva, level, NULL);
+	pte = be64_to_cpu(*ptep);
+
+	TEST_ASSERT(!pte, "PTE already present at level: %u gva: 0x%lx pte:0x%lx\n",
+		    level, gva, pte);
+
+	pte = PTE_VALID | PTE_LEAF | PTE_REFERENCED | PTE_CHANGED |PTE_PRIV |
+	      PTE_READ | PTE_RW | PTE_EXEC | (gpa & PTE_PAGE_MASK);
+	*ptep = cpu_to_be64(pte);
+}
+
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	vm_paddr_t pt = vm->pgd;
+	uint64_t *ptep, pte;
+	int level;
+
+	for (level = 1; level <= 3; level++) {
+		uint64_t nls;
+		uint64_t *pdep = virt_get_pte(vm, pt, gva, level, &nls);
+		uint64_t pde = be64_to_cpu(*pdep);
+
+		TEST_ASSERT((pde & PDE_VALID) && !(pde & PTE_LEAF),
+			"PDE not present at level: %u gva: 0x%lx pde:0x%lx\n",
+			level, gva, pde);
+		pt = pde & PDE_PT_MASK;
+	}
+
+	ptep = virt_get_pte(vm, pt, gva, level, NULL);
+	pte = be64_to_cpu(*ptep);
+
+	TEST_ASSERT(pte,
+		"PTE not present at level: %u gva: 0x%lx pte:0x%lx\n",
+		level, gva, pte);
+
+	TEST_ASSERT((pte & PTE_VALID) && (pte & PTE_LEAF) &&
+		    (pte & PTE_READ) && (pte & PTE_RW) && (pte & PTE_EXEC),
+		    "PTE not valid at level: %u gva: 0x%lx pte:0x%lx\n",
+		    level, gva, pte);
+
+	return (pte & PTE_PAGE_MASK) + (gva & (vm->page_size - 1));
+}
+
+static void virt_dump_pt(FILE *stream, struct kvm_vm *vm, vm_paddr_t pt,
+			 vm_vaddr_t va, int level, uint8_t indent)
+{
+	int size, idx;
+
+	size = 1U << (pt_shift(vm, level) + 3);
+
+	for (idx = 0; idx < size; idx += 8, va += pt_entry_coverage(vm, level)) {
+		uint64_t *page_table = addr_gpa2hva(vm, pt + idx);
+		uint64_t pte = be64_to_cpu(*page_table);
+
+		if (!(pte & PTE_VALID))
+			continue;
+
+		if (pte & PTE_LEAF) {
+			fprintf(stream,
+				"%*s PTE[%d] gVA:0x%016lx -> gRA:0x%016llx\n",
+				indent, "", idx/8, va, pte & PTE_PAGE_MASK);
+		} else {
+			fprintf(stream, "%*sPDE%d[%d] gVA:0x%016lx\n",
+				indent, "", level, idx/8, va);
+			virt_dump_pt(stream, vm, pte & PDE_PT_MASK, va,
+				     level + 1, indent + 2);
+		}
+	}
+
+}
+
+void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+{
+	vm_paddr_t pt = vm->pgd;
+
+	if (!vm->pgd_created)
+		return;
+
+	virt_dump_pt(stream, vm, pt, 0, 1, indent);
+}
+
+static unsigned long get_r2(void)
+{
+	unsigned long r2;
+
+	asm("mr %0,%%r2" : "=r"(r2));
+
+	return r2;
+}
+
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+				  void *guest_code)
+{
+	const size_t stack_size =  SZ_64K;
+	vm_vaddr_t stack_vaddr, ex_regs_vaddr;
+	vm_paddr_t ex_regs_paddr;
+	struct ex_regs *ex_regs;
+	struct kvm_regs regs;
+	struct kvm_vcpu *vcpu;
+	uint64_t lpcr;
+
+	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
+				       DEFAULT_GUEST_STACK_VADDR_MIN,
+				       MEM_REGION_DATA);
+
+	ex_regs_vaddr = __vm_vaddr_alloc(vm, stack_size,
+				       DEFAULT_GUEST_STACK_VADDR_MIN,
+				       MEM_REGION_DATA);
+	ex_regs_paddr = addr_gva2gpa(vm, ex_regs_vaddr);
+	ex_regs = addr_gpa2hva(vm, ex_regs_paddr);
+	ex_regs->vaddr = ex_regs_vaddr;
+
+	vcpu = __vm_vcpu_add(vm, vcpu_id);
+
+	vcpu_enable_cap(vcpu, KVM_CAP_PPC_PAPR, 1);
+
+	/* Setup guest registers */
+	vcpu_regs_get(vcpu, &regs);
+	vcpu_get_reg(vcpu, KVM_REG_PPC_LPCR_64, &lpcr);
+
+	regs.pc = (uintptr_t)guest_code;
+	regs.gpr[1] = stack_vaddr + stack_size - 256;
+	regs.gpr[2] = (uintptr_t)get_r2();
+	regs.gpr[12] = (uintptr_t)guest_code;
+	regs.gpr[13] = (uintptr_t)ex_regs_paddr;
+
+	regs.msr = MSR_SF | MSR_VEC | MSR_VSX | MSR_FP |
+		   MSR_ME | MSR_IR | MSR_DR | MSR_RI;
+
+	if (BYTE_ORDER == LITTLE_ENDIAN) {
+		regs.msr |= MSR_LE;
+		lpcr |= LPCR_ILE;
+	} else {
+		lpcr &= ~LPCR_ILE;
+	}
+
+	vcpu_regs_set(vcpu, &regs);
+	vcpu_set_reg(vcpu, KVM_REG_PPC_LPCR_64, lpcr);
+
+	return vcpu;
+}
+
+void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
+{
+	va_list ap;
+	struct kvm_regs regs;
+	int i;
+
+	TEST_ASSERT(num >= 1 && num <= 5, "Unsupported number of args: %u\n",
+		    num);
+
+	va_start(ap, num);
+	vcpu_regs_get(vcpu, &regs);
+
+	for (i = 0; i < num; i++)
+		regs.gpr[i + 3] = va_arg(ap, uint64_t);
+
+	vcpu_regs_set(vcpu, &regs);
+	va_end(ap);
+}
+
+void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
+{
+	struct kvm_regs regs;
+
+	vcpu_regs_get(vcpu, &regs);
+
+	fprintf(stream, "%*sNIA: 0x%016llx  MSR: 0x%016llx\n",
+			indent, "", regs.pc, regs.msr);
+	fprintf(stream, "%*sLR:  0x%016llx  CTR :0x%016llx\n",
+			indent, "", regs.lr, regs.ctr);
+	fprintf(stream, "%*sCR:  0x%08llx          XER :0x%016llx\n",
+			indent, "", regs.cr, regs.xer);
+}
+
+void kvm_arch_vm_post_create(struct kvm_vm *vm)
+{
+	vm_paddr_t excp_paddr;
+	void *mem;
+
+	excp_paddr = vm_phy_page_alloc(vm, 0, vm->memslots[MEM_REGION_DATA]);
+
+	TEST_ASSERT(excp_paddr == 0,
+		    "Interrupt vectors not allocated at gPA address 0: (0x%lx)",
+		    excp_paddr);
+
+	mem = addr_gpa2hva(vm, excp_paddr);
+	memcpy(mem, __interrupts_start, __interrupts_end - __interrupts_start);
+}
+
+void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	if (get_ucall(vcpu, &uc) == UCALL_UNHANDLED) {
+		vm_paddr_t ex_regs_paddr;
+		struct ex_regs *ex_regs;
+		struct kvm_regs regs;
+
+		vcpu_regs_get(vcpu, &regs);
+		ex_regs_paddr = (vm_paddr_t)regs.gpr[13];
+		ex_regs = addr_gpa2hva(vcpu->vm, ex_regs_paddr);
+
+		TEST_FAIL("Unexpected interrupt in guest NIA:0x%016lx MSR:0x%016lx TRAP:0x%04x",
+			  ex_regs->nia, ex_regs->msr, ex_regs->trap);
+	}
+}
+
+struct handler {
+	void (*fn)(struct ex_regs *regs);
+	int trap;
+};
+
+#define NR_HANDLERS	10
+static struct handler handlers[NR_HANDLERS];
+
+void route_interrupt(struct ex_regs *regs)
+{
+	int i;
+
+	for (i = 0; i < NR_HANDLERS; i++) {
+		if (handlers[i].trap == regs->trap) {
+			handlers[i].fn(regs);
+			return;
+		}
+	}
+
+	ucall(UCALL_UNHANDLED, 0);
+}
+
+void vm_install_exception_handler(struct kvm_vm *vm, int trap,
+			       void (*fn)(struct ex_regs *))
+{
+	int i;
+
+	for (i = 0; i < NR_HANDLERS; i++) {
+		if (!handlers[i].trap || handlers[i].trap == trap) {
+			if (fn == NULL)
+				trap = 0; /* Clear handler */
+			handlers[i].trap = trap;
+			handlers[i].fn = fn;
+			sync_global_to_guest(vm, handlers[i]);
+			return;
+		}
+	}
+
+	TEST_FAIL("Out of exception handlers");
+}
+
+void kvm_selftest_arch_init(void)
+{
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PPC_MMU_RADIX));
+
+	/*
+	 * powerpc default mode is set by host page size and not static,
+	 * so start by computing that early.
+	 */
+	guest_modes_append_default();
+}
diff --git a/tools/testing/selftests/kvm/lib/powerpc/ucall.c b/tools/testing/selftests/kvm/lib/powerpc/ucall.c
new file mode 100644
index 000000000000..3cb598a8b743
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/powerpc/ucall.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ucall support. A ucall is a "hypercall to host userspace".
+ */
+#include "kvm_util.h"
+#include "hcall.h"
+
+void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+
+	if (run->exit_reason == UCALL_EXIT_REASON &&
+	    run->papr_hcall.nr == H_UCALL) {
+		struct kvm_regs regs;
+
+		vcpu_regs_get(vcpu, &regs);
+		if (regs.gpr[4] == UCALL_R4_UCALL)
+			return (void *)regs.gpr[5];
+	}
+	return NULL;
+}
diff --git a/tools/testing/selftests/kvm/powerpc/helpers.h b/tools/testing/selftests/kvm/powerpc/helpers.h
new file mode 100644
index 000000000000..8f60bb826830
--- /dev/null
+++ b/tools/testing/selftests/kvm/powerpc/helpers.h
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#ifndef SELFTEST_KVM_HELPERS_H
+#define SELFTEST_KVM_HELPERS_H
+
+#include "kvm_util.h"
+#include "processor.h"
+
+static inline void __handle_ucall(struct kvm_vcpu *vcpu, uint64_t expect, struct ucall *uc)
+{
+	uint64_t ret;
+	struct kvm_regs regs;
+
+	ret = get_ucall(vcpu, uc);
+	if (ret == expect)
+		return;
+
+	vcpu_regs_get(vcpu, &regs);
+	fprintf(stderr, "Guest failure at NIA:0x%016llx MSR:0x%016llx\n", regs.pc, regs.msr);
+	fprintf(stderr, "Expected ucall: %lu\n", expect);
+
+	if (ret == UCALL_ABORT)
+		REPORT_GUEST_ASSERT(*uc);
+	else
+		TEST_FAIL("Unexpected ucall: %lu exit_reason=%s",
+			ret, exit_reason_str(vcpu->run->exit_reason));
+}
+
+static inline void handle_ucall(struct kvm_vcpu *vcpu, uint64_t expect)
+{
+	struct ucall uc;
+
+	__handle_ucall(vcpu, expect, &uc);
+}
+
+static inline void host_sync(struct kvm_vcpu *vcpu, uint64_t sync)
+{
+	struct ucall uc;
+
+	__handle_ucall(vcpu, UCALL_SYNC, &uc);
+
+	TEST_ASSERT(uc.args[1] == (sync), "Sync failed host:%ld guest:%ld",
+						(long)sync, (long)uc.args[1]);
+}
+
+#endif
-- 
2.42.0


