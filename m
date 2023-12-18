Return-Path: <kvm+bounces-4667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B703381670B
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:10:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB6391C22252
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB9279E2;
	Mon, 18 Dec 2023 07:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lqhMoGQO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DD879C3
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883409; x=1734419409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OvQCuHixDO0KQmxwCCZZhru4y0nrkCc7sWKnhtdP4+c=;
  b=lqhMoGQO66Lj9PC1E8k9F4UVuktCHwUsqqwesM2GQd0IDJZqplg6QkHg
   QdPjRRLKbTeFOUyyrfQ5R7OR2FPH1XrFV9pNXUmsJOnAY1jLs5ELtPKIq
   ++JH3zog4j1+LlwELsyrC04BbipKzNeYjV+/8t9vYPjBZm2IukqNSGoil
   qsCokufJxlpVggTntL9fgG2Le90qAwTrkrgrajxNUys1WFFJqhLPkSzG9
   WKwRIrNtDK1NSMPK5gECzvrHvheR5iL9v9sv5Trk9ZDe8HxzPxZNnSOUd
   UOr6MggBGHbKrw9Xmep2+DWB7mDUsM8Jwn/cju/CN+4rkk/PCWvamyeNY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667812"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667812"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824635"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824635"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:04 -0800
From: Qian Wen <qian.wen@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	alexandru.elisei@arm.com,
	yu.c.zhang@intel.com,
	zhenzhong.duan@intel.com,
	isaku.yamahata@intel.com,
	chenyi.qiang@intel.com,
	ricarkol@google.com,
	qian.wen@intel.com
Subject: [kvm-unit-tests RFC v2 01/18] x86 TDX: Port tdx basic functions from TDX guest code
Date: Mon, 18 Dec 2023 15:22:30 +0800
Message-Id: <20231218072247.2573516-2-qian.wen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231218072247.2573516-1-qian.wen@intel.com>
References: <20231218072247.2573516-1-qian.wen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

Port tdxcall.S, tdcall.S and tdx.c from TDX guest kernel source code,
simplify and keep only code which is useful for TDX kvm-unit-test
framework.

lib/x86/tdxcall.S contains one common helper macro for both TDCALL and
SEAMCALL instructions: TDX_MODULE_CALL.
Although the SEAMCALL path is not used in this series, the macro is not
modified for simplicity.

lib/x86/tdcall.S contains three helper functions for TDCALL.
  - __tdcall, TDX guests to request services from the TDX module.
  - __tdcall_ret, TDX guests to request services from the TDX module
    (does not include VMM services).
  - __tdcall_saved_ret, TDX guests to request services from the TDX
    module (including VMM services).

The __tdx_hypercall is wrapper of __tdcall_saved_ret, used to request
services from the VMM.

lib/x86/tdx.c contains wrapper functions for simulating various
instructions through tdvmcall. Currently below instructions are
simulated:

	IO  read/write
	MSR read/write
	cpuid
	hlt

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-2-zhenzhong.duan@intel.com
Co-developed-by: Qian Wen <qian.wen@intel.com>
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 lib/x86/tdcall.S    |  66 +++++++++++
 lib/x86/tdx.c       | 278 ++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/tdx.h       | 141 ++++++++++++++++++++++
 lib/x86/tdxcall.S   | 249 +++++++++++++++++++++++++++++++++++++++
 x86/Makefile.common |   3 +
 5 files changed, 737 insertions(+)
 create mode 100644 lib/x86/tdcall.S
 create mode 100644 lib/x86/tdx.c
 create mode 100644 lib/x86/tdx.h
 create mode 100644 lib/x86/tdxcall.S

diff --git a/lib/x86/tdcall.S b/lib/x86/tdcall.S
new file mode 100644
index 00000000..316df594
--- /dev/null
+++ b/lib/x86/tdcall.S
@@ -0,0 +1,66 @@
+/*
+ * Low level helpers for tdcall
+ *
+ * Copyright (c) 2023, Intel Inc
+ *
+ * Authors:
+ *   Zhenzhong Duan <zhenzhong.duan@intel.com>
+ *   Qian Wen <qian.wen@intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0
+ */
+#include <errno.h>
+#include "tdxcall.S"
+
+/*
+ * __tdcall()  - Used by TDX guests to request services from the TDX
+ * module (does not include VMM services) using TDCALL instruction.
+ *
+ * __tdcall() function ABI:
+ *
+ * @fn   (RDI)	- TDCALL Leaf ID, moved to RAX
+ * @args (RSI)	- struct tdx_module_args for input
+ *
+ * Only RCX/RDX/R8-R11 are used as input registers.
+ *
+ * Return status of TDCALL via RAX.
+ */
+.global __tdcall
+__tdcall:
+	TDX_MODULE_CALL host=0
+
+/*
+ * __tdcall_ret() - Used by TDX guests to request services from the TDX
+ * module (does not include VMM services) using TDCALL instruction, with
+ * saving output registers to the 'struct tdx_module_args' used as input.
+ *
+ * __tdcall_ret() function ABI:
+ *
+ * @fn   (RDI)	- TDCALL Leaf ID, moved to RAX
+ * @args (RSI)	- struct tdx_module_args for input and output
+ *
+ * Only RCX/RDX/R8-R11 are used as input/output registers.
+ *
+ * Return status of TDCALL via RAX.
+ */
+.global __tdcall_ret
+__tdcall_ret:
+	TDX_MODULE_CALL host=0 ret=1
+
+/*
+ * __tdcall_saved_ret() - Used by TDX guests to request services from the
+ * TDX module (including VMM services) using TDCALL instruction, with
+ * saving output registers to the 'struct tdx_module_args' used as input.
+ *
+ * __tdcall_saved_ret() function ABI:
+ *
+ * @fn   (RDI)	- TDCALL leaf ID, moved to RAX
+ * @args (RSI)	- struct tdx_module_args for input/output
+ *
+ * All registers in @args are used as input/output registers.
+ *
+ * On successful completion, return the hypercall error code.
+ */
+.global __tdcall_saved_ret
+__tdcall_saved_ret:
+	TDX_MODULE_CALL host=0 ret=1 saved=1
diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
new file mode 100644
index 00000000..1f1abeff
--- /dev/null
+++ b/lib/x86/tdx.c
@@ -0,0 +1,278 @@
+/*
+ * TDX library
+ *
+ * Copyright (c) 2023, Intel Inc
+ *
+ * Authors:
+ *   Zhenzhong Duan <zhenzhong.duan@intel.com>
+ *   Qian Wen <qian.wen@intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0
+ */
+
+#include "tdx.h"
+#include "bitops.h"
+#include "errno.h"
+#include "x86/processor.h"
+#include "x86/smp.h"
+
+/* Port I/O direction */
+#define PORT_READ	0
+#define PORT_WRITE	1
+
+/* See Exit Qualification for I/O Instructions in VMX documentation */
+#define VE_IS_IO_IN(e)		((e) & BIT(3))
+#define VE_GET_IO_SIZE(e)	(((e) & GENMASK(2, 0)) + 1)
+#define VE_GET_PORT_NUM(e)	((e) >> 16)
+#define VE_IS_IO_STRING(e)	((e) & BIT(4))
+
+
+u64 __tdx_hypercall(struct tdx_module_args *args)
+{
+	/*
+	 * For TDVMCALL explicitly set RCX to the bitmap of shared registers.
+	 * The caller isn't expected to set @args->rcx anyway.
+	 */
+	args->rcx = TDVMCALL_EXPOSE_REGS_MASK;
+
+	/*
+	 * Failure of __tdcall_saved_ret() indicates a failure of the TDVMCALL
+	 * mechanism itself and that something has gone horribly wrong with
+	 * the TDX module.
+	 */
+	if (__tdcall_saved_ret(TDG_VP_VMCALL, args)) {
+		/* Non zero return value indicates buggy TDX module, so panic */
+		BUG_ON(1);
+	}
+
+	if (args->r10)
+		printf("__tdx_hypercall err:\n"
+		       "R10=0x%016lx, R11=0x%016lx, R12=0x%016lx\n"
+		       "R13=0x%016lx, R14=0x%016lx, R15=0x%016lx\n",
+		       args->r10, args->r11, args->r12, args->r13, args->r14,
+		       args->r15);
+
+	/* TDVMCALL leaf return code is in R10 */
+	return args->r10;
+}
+
+/*
+ * The TDX module spec states that #VE may be injected for a limited set of
+ * reasons:
+ *
+ *  - Emulation of the architectural #VE injection on EPT violation;
+ *
+ *  - As a result of guest TD execution of a disallowed instruction,
+ *    a disallowed MSR access, or CPUID virtualization;
+ *
+ *  - A notification to the guest TD about anomalous behavior;
+ *
+ * The last one is opt-in and is not used by the kernel.
+ *
+ * The Intel Software Developer's Manual describes cases when instruction
+ * length field can be used in section "Information for VM Exits Due to
+ * Instruction Execution".
+ *
+ * For TDX, it ultimately means GET_VEINFO provides reliable instruction length
+ * information if #VE occurred due to instruction execution, but not for EPT
+ * violations.
+ *
+ * Currently, EPT violation caused #VE is not being included, as the patch set
+ * has not yet provided MMIO related test cases for TDX.
+ */
+static int ve_instr_len(struct ve_info *ve)
+{
+	switch (ve->exit_reason) {
+	case EXIT_REASON_HLT:
+	case EXIT_REASON_MSR_READ:
+	case EXIT_REASON_MSR_WRITE:
+	case EXIT_REASON_CPUID:
+	case EXIT_REASON_IO_INSTRUCTION:
+		/* It is safe to use ve->instr_len for #VE due instructions */
+		return ve->instr_len;
+	default:
+		printf("WARNING: Unexpected #VE-type: %ld\n", ve->exit_reason);
+		return ve->instr_len;
+	}
+}
+
+static int handle_halt(struct ex_regs *regs, struct ve_info *ve)
+{
+	struct tdx_module_args args = {
+		.r10 = TDX_HYPERCALL_STANDARD,
+		.r11 = hcall_func(EXIT_REASON_HLT),
+		.r12 = !!(regs->rflags & X86_EFLAGS_IF),
+	};
+
+	/*
+	 * Emulate HLT operation via hypercall. More info about ABI
+	 * can be found in TDX Guest-Host-Communication Interface
+	 * (GHCI), section 3.8 TDG.VP.VMCALL<Instruction.HLT>.
+	 *
+	 * The VMM uses the "IRQ disabled" param to understand IRQ
+	 * enabled status (RFLAGS.IF) of the TD guest and to determine
+	 * whether or not it should schedule the halted vCPU if an
+	 * IRQ becomes pending. E.g. if IRQs are disabled, the VMM
+	 * can keep the vCPU in virtual HLT, even if an IRQ is
+	 * pending, without hanging/breaking the guest.
+	 */
+	if (__tdx_hypercall(&args))
+		return -EIO;
+
+	return ve_instr_len(ve);
+}
+
+static int read_msr(struct ex_regs *regs, struct ve_info *ve)
+{
+	struct tdx_module_args args = {
+		.r10 = TDX_HYPERCALL_STANDARD,
+		.r11 = hcall_func(EXIT_REASON_MSR_READ),
+		.r12 = regs->rcx,
+	};
+
+	/*
+	 * Emulate the MSR read via hypercall. More info about ABI
+	 * can be found in TDX Guest-Host-Communication Interface
+	 * (GHCI), section titled "TDG.VP.VMCALL<Instruction.RDMSR>".
+	 */
+	if (__tdx_hypercall(&args))
+		return -EIO;
+
+	regs->rax = lower_32_bits(args.r11);
+	regs->rdx = upper_32_bits(args.r11);
+	return ve_instr_len(ve);
+}
+
+static int write_msr(struct ex_regs *regs, struct ve_info *ve)
+{
+	struct tdx_module_args args = {
+		.r10 = TDX_HYPERCALL_STANDARD,
+		.r11 = hcall_func(EXIT_REASON_MSR_WRITE),
+		.r12 = regs->rcx,
+		.r13 = (u64)regs->rdx << 32 | regs->rax,
+	};
+
+	/*
+	 * Emulate the MSR write via hypercall. More info about ABI
+	 * can be found in TDX Guest-Host-Communication Interface
+	 * (GHCI) section titled "TDG.VP.VMCALL<Instruction.WRMSR>".
+	 */
+	if (__tdx_hypercall(&args))
+		return -EIO;
+
+	return ve_instr_len(ve);
+}
+
+static int handle_cpuid(struct ex_regs *regs, struct ve_info *ve)
+{
+	struct tdx_module_args args = {
+		.r10 = TDX_HYPERCALL_STANDARD,
+		.r11 = hcall_func(EXIT_REASON_CPUID),
+		.r12 = regs->rax,
+		.r13 = regs->rcx,
+	};
+
+	/*
+	 * Only allow VMM to control range reserved for hypervisor
+	 * communication.
+	 *
+	 * Return all-zeros for any CPUID outside the range. It matches CPU
+	 * behaviour for non-supported leaf.
+	 */
+	if (regs->rax < 0x40000000 || regs->rax > 0x4FFFFFFF) {
+		regs->rax = regs->rbx = regs->rcx = regs->rdx = 0;
+		return ve_instr_len(ve);
+	}
+
+	/*
+	 * Emulate the CPUID instruction via a hypercall. More info about
+	 * ABI can be found in TDX Guest-Host-Communication Interface
+	 * (GHCI), section titled "VP.VMCALL<Instruction.CPUID>".
+	 */
+	if (__tdx_hypercall(&args))
+		return -EIO;
+
+	/*
+	 * As per TDX GHCI CPUID ABI, r12-r15 registers contain contents of
+	 * EAX, EBX, ECX, EDX registers after the CPUID instruction execution.
+	 * So copy the register contents back to pt_regs.
+	 */
+	regs->rax = args.r12;
+	regs->rbx = args.r13;
+	regs->rcx = args.r14;
+	regs->rdx = args.r15;
+
+	return ve_instr_len(ve);
+}
+
+static bool handle_in(struct ex_regs *regs, int size, int port)
+{
+	struct tdx_module_args args = {
+		.r10 = TDX_HYPERCALL_STANDARD,
+		.r11 = hcall_func(EXIT_REASON_IO_INSTRUCTION),
+		.r12 = size,
+		.r13 = PORT_READ,
+		.r14 = port,
+	};
+	u64 mask = GENMASK(BITS_PER_BYTE * size, 0);
+	bool success;
+
+	/*
+	 * Emulate the I/O read via hypercall. More info about ABI can be found
+	 * in TDX Guest-Host-Communication Interface (GHCI) section titled
+	 * "TDG.VP.VMCALL<Instruction.IO>".
+	 */
+	success = !__tdx_hypercall(&args);
+
+	/* Update part of the register affected by the emulated instruction */
+	regs->rax &= ~mask;
+	if (success)
+		regs->rax |= args.r11 & mask;
+
+	return success;
+}
+
+static bool handle_out(struct ex_regs *regs, int size, int port)
+{
+	u64 mask = GENMASK(BITS_PER_BYTE * size, 0);
+
+	/*
+	 * Emulate the I/O write via hypercall. More info about ABI can be found
+	 * in TDX Guest-Host-Communication Interface (GHCI) section titled
+	 * "TDG.VP.VMCALL<Instruction.IO>".
+	 */
+	return !_tdx_hypercall(hcall_func(EXIT_REASON_IO_INSTRUCTION), size,
+			       PORT_WRITE, port, regs->rax & mask);
+}
+
+/*
+ * Emulate I/O using hypercall.
+ *
+ * Assumes the IO instruction was using ax, which is enforced
+ * by the standard io.h macros.
+ *
+ * Return True on success or False on failure.
+ */
+static int handle_io(struct ex_regs *regs, struct ve_info *ve)
+{
+	u32 exit_qual = ve->exit_qual;
+	int size, port;
+	bool in, ret;
+
+	if (VE_IS_IO_STRING(exit_qual))
+		return -EIO;
+
+	in   = VE_IS_IO_IN(exit_qual);
+	size = VE_GET_IO_SIZE(exit_qual);
+	port = VE_GET_PORT_NUM(exit_qual);
+
+
+	if (in)
+		ret = handle_in(regs, size, port);
+	else
+		ret = handle_out(regs, size, port);
+	if (!ret)
+		return -EIO;
+
+	return ve_instr_len(ve);
+}
diff --git a/lib/x86/tdx.h b/lib/x86/tdx.h
new file mode 100644
index 00000000..cf0fc917
--- /dev/null
+++ b/lib/x86/tdx.h
@@ -0,0 +1,141 @@
+/*
+ * TDX library
+ *
+ * Copyright (c) 2023, Intel Inc
+ *
+ * Authors:
+ *   Zhenzhong Duan <zhenzhong.duan@intel.com>
+ *   Qian Wen <qian.wen@intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0
+ */
+
+#ifndef _ASM_X86_TDX_H
+#define _ASM_X86_TDX_H
+
+#ifdef CONFIG_EFI
+
+#include "libcflat.h"
+#include "limits.h"
+#include "efi.h"
+
+#define TDX_HYPERCALL_STANDARD		0
+
+/* TDX module Call Leaf IDs */
+#define TDG_VP_VMCALL			0
+
+/*
+ * Bitmasks of exposed registers (with VMM).
+ */
+#define TDX_RDX		BIT(2)
+#define TDX_RBX		BIT(3)
+#define TDX_RSI		BIT(6)
+#define TDX_RDI		BIT(7)
+#define TDX_R8		BIT(8)
+#define TDX_R9		BIT(9)
+#define TDX_R10		BIT(10)
+#define TDX_R11		BIT(11)
+#define TDX_R12		BIT(12)
+#define TDX_R13		BIT(13)
+#define TDX_R14		BIT(14)
+#define TDX_R15		BIT(15)
+
+/*
+ * These registers are clobbered to hold arguments for each
+ * TDVMCALL. They are safe to expose to the VMM.
+ * Each bit in this mask represents a register ID. Bit field
+ * details can be found in TDX GHCI specification, section
+ * titled "TDCALL [TDG.VP.VMCALL] leaf".
+ */
+#define TDVMCALL_EXPOSE_REGS_MASK	\
+	(TDX_RDX | TDX_RBX | TDX_RSI | TDX_RDI | TDX_R8  | TDX_R9  | \
+	 TDX_R10 | TDX_R11 | TDX_R12 | TDX_R13 | TDX_R14 | TDX_R15)
+
+#define BUG_ON(condition) do { if (condition) abort(); } while (0)
+
+#define EXIT_REASON_CPUID               10
+#define EXIT_REASON_HLT                 12
+#define EXIT_REASON_IO_INSTRUCTION      30
+#define EXIT_REASON_MSR_READ            31
+#define EXIT_REASON_MSR_WRITE           32
+
+/*
+ * Used in __tdcall*() to gather the input/output registers' values of the
+ * TDCALL instruction when requesting services from the TDX module. This is a
+ * software only structure and not part of the TDX module/VMM ABI
+ */
+struct tdx_module_args {
+	/* callee-clobbered */
+	u64 rcx;
+	u64 rdx;
+	u64 r8;
+	u64 r9;
+	/* extra callee-clobbered */
+	u64 r10;
+	u64 r11;
+	/* callee-saved + rdi/rsi */
+	u64 r12;
+	u64 r13;
+	u64 r14;
+	u64 r15;
+	u64 rbx;
+	u64 rdi;
+	u64 rsi;
+};
+
+/* Used to communicate with the TDX module */
+u64 __tdcall(u64 fn, struct tdx_module_args *args);
+u64 __tdcall_ret(u64 fn, struct tdx_module_args *args);
+u64 __tdcall_saved_ret(u64 fn, struct tdx_module_args *args);
+
+/* Used to request services from the VMM */
+u64 __tdx_hypercall(struct tdx_module_args *args);
+
+/*
+ * Wrapper for standard use of __tdx_hypercall with no output aside from
+ * return code.
+ */
+static inline u64 _tdx_hypercall(u64 fn, u64 r12, u64 r13, u64 r14, u64 r15)
+{
+	struct tdx_module_args args = {
+		.r10 = TDX_HYPERCALL_STANDARD,
+		.r11 = fn,
+		.r12 = r12,
+		.r13 = r13,
+		.r14 = r14,
+		.r15 = r15,
+	};
+
+	return __tdx_hypercall(&args);
+}
+
+/*
+ * The TDG.VP.VMCALL-Instruction-execution sub-functions are defined
+ * independently from but are currently matched 1:1 with VMX EXIT_REASONs.
+ * Reusing the KVM EXIT_REASON macros makes it easier to connect the host and
+ * guest sides of these calls.
+ */
+static __always_inline u64 hcall_func(u64 exit_reason)
+{
+	return exit_reason;
+}
+
+/*
+ * Used by the #VE exception handler to gather the #VE exception
+ * info from the TDX module. This is a software only structure
+ * and not part of the TDX module/VMM ABI.
+ */
+struct ve_info {
+	u64 exit_reason;
+	u64 exit_qual;
+	/* Guest Linear (virtual) Address */
+	u64 gla;
+	/* Guest Physical Address */
+	u64 gpa;
+	u32 instr_len;
+	u32 instr_info;
+};
+
+#endif /* CONFIG_EFI */
+
+#endif /* _ASM_X86_TDX_H */
diff --git a/lib/x86/tdxcall.S b/lib/x86/tdxcall.S
new file mode 100644
index 00000000..bc145af9
--- /dev/null
+++ b/lib/x86/tdxcall.S
@@ -0,0 +1,249 @@
+/*
+ * Common helper macro for tdcall and seamcall
+ *
+ * Copyright (c) 2023, Intel Inc
+ *
+ * Authors:
+ *   Qian Wen <qian.wen@intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0
+ */
+/*
+ * TDCALL and SEAMCALL are supported in Binutils >= 2.36.
+ */
+#define tdcall		.byte 0x66,0x0f,0x01,0xcc
+#define seamcall	.byte 0x66,0x0f,0x01,0xcf
+
+#define ARGS_rcx  0 /* offsetof(struct tdx_module_output, rcx) */
+#define ARGS_rdx  8 /* offsetof(struct tdx_module_output, rdx) */
+#define ARGS_r8  16 /* offsetof(struct tdx_module_output, r8) */
+#define ARGS_r9  24 /* offsetof(struct tdx_module_output, r9) */
+#define ARGS_r10 32 /* offsetof(struct tdx_module_output, r10) */
+#define ARGS_r11 40 /* offsetof(struct tdx_module_output, r11) */
+#define ARGS_r12 48 /* offsetof(struct tdx_module_output, r12) */
+#define ARGS_r13 56 /* offsetof(struct tdx_module_output, r13) */
+#define ARGS_r14 64 /* offsetof(struct tdx_module_output, r14) */
+#define ARGS_r15 72 /* offsetof(struct tdx_module_output, r15) */
+#define ARGS_rbx 80 /* offsetof(struct tdx_module_output, rbx) */
+#define ARGS_rdi 88 /* offsetof(struct tdx_module_output, rdi) */
+#define ARGS_rsi 96 /* offsetof(struct tdx_module_output, rsi) */
+
+/*
+ * TDX_MODULE_CALL - common helper macro for both
+ *                 TDCALL and SEAMCALL instructions.
+ *
+ * TDCALL   - used by TDX guests to make requests to the
+ *            TDX module and hypercalls to the VMM.
+ * SEAMCALL - used by TDX hosts to make requests to the
+ *            TDX module.
+ *
+ *-------------------------------------------------------------------------
+ * TDCALL/SEAMCALL ABI:
+ *-------------------------------------------------------------------------
+ * Input Registers:
+ *
+ * RAX                        - TDCALL/SEAMCALL Leaf number.
+ * RCX,RDX,RDI,RSI,RBX,R8-R15 - TDCALL/SEAMCALL Leaf specific input registers.
+ *
+ * Output Registers:
+ *
+ * RAX                        - TDCALL/SEAMCALL instruction error code.
+ * RCX,RDX,RDI,RSI,RBX,R8-R15 - TDCALL/SEAMCALL Leaf specific output registers.
+ *
+ *-------------------------------------------------------------------------
+ *
+ * So while the common core (RAX,RCX,RDX,R8-R11) fits nicely in the
+ * callee-clobbered registers and even leaves RDI,RSI free to act as a
+ * base pointer, some leafs (e.g., VP.ENTER) make a giant mess of things.
+ *
+ * For simplicity, assume that anything that needs the callee-saved regs
+ * also tramples on RDI,RSI.  This isn't strictly true, see for example
+ * TDH.EXPORT.MEM.
+ */
+.macro TDX_MODULE_CALL host:req ret=0 saved=0
+.if \host && \ret && \saved
+	pushq	%rbp
+	movq	%rsp, %rbp
+.endif
+
+	/* Move Leaf ID to RAX */
+	mov %rdi, %rax
+
+	/* Move other input regs from 'struct tdx_module_args' */
+	movq	ARGS_rcx(%rsi), %rcx
+	movq	ARGS_rdx(%rsi), %rdx
+	movq	ARGS_r8(%rsi),  %r8
+	movq	ARGS_r9(%rsi),  %r9
+	movq	ARGS_r10(%rsi), %r10
+	movq	ARGS_r11(%rsi), %r11
+
+.if \saved
+	/*
+	 * Move additional input regs from the structure.  For simplicity
+	 * assume that anything needs the callee-saved regs also tramples
+	 * on RDI/RSI (see VP.ENTER).
+	 */
+	/* Save those callee-saved GPRs as mandated by the x86_64 ABI */
+	pushq	%rbx
+	pushq	%r12
+	pushq	%r13
+	pushq	%r14
+	pushq	%r15
+
+	movq	ARGS_r12(%rsi), %r12
+	movq	ARGS_r13(%rsi), %r13
+	movq	ARGS_r14(%rsi), %r14
+	movq	ARGS_r15(%rsi), %r15
+	movq	ARGS_rbx(%rsi), %rbx
+
+.if \ret
+	/* Save the structure pointer as RSI is about to be clobbered */
+	pushq	%rsi
+.endif
+
+	movq	ARGS_rdi(%rsi), %rdi
+	/* RSI needs to be done at last */
+	movq	ARGS_rsi(%rsi), %rsi
+.endif	/* \saved */
+
+.if \host
+.Lseamcall\@:
+	seamcall
+
+.Lafter_seamcall\@:
+	nop
+.Lafter_nop\@:
+
+	/*
+	 * SEAMCALL instruction is essentially a VMExit from VMX root
+	 * mode to SEAM VMX root mode.  VMfailInvalid (CF=1) indicates
+	 * that the targeted SEAM firmware is not loaded or disabled,
+	 * or P-SEAMLDR is busy with another SEAMCALL.  %rax is not
+	 * changed in this case.
+	 *
+	 * Set %rax to TDX_SEAMCALL_VMFAILINVALID for VMfailInvalid.
+	 * This value will never be used as actual SEAMCALL error code as
+	 * it is from the Reserved status code class.
+	 */
+	jc .Lseamcall_vmfailinvalid\@
+.else
+	tdcall
+.endif
+
+.if \ret
+.if \saved
+	/*
+	 * Restore the structure from stack to save the output registers
+	 *
+	 * In case of VP.ENTER returns due to TDVMCALL, all registers are
+	 * valid thus no register can be used as spare to restore the
+	 * structure from the stack (see "TDH.VP.ENTER Output Operands
+	 * Definition on TDCALL(TDG.VP.VMCALL) Following a TD Entry").
+	 * For this case, need to make one register as spare by saving it
+	 * to the stack and then manually load the structure pointer to
+	 * the spare register.
+	 *
+	 * Note for other TDCALLs/SEAMCALLs there are spare registers
+	 * thus no need for such hack but just use this for all.
+	 */
+	pushq	%rax		/* save the TDCALL/SEAMCALL return code */
+	movq	8(%rsp), %rax	/* restore the structure pointer */
+	movq	%rsi, ARGS_rsi(%rax)	/* save RSI */
+	popq	%rax		/* restore the return code */
+	popq	%rsi		/* pop the structure pointer */
+
+	/* Copy additional output regs to the structure  */
+	movq %r12, ARGS_r12(%rsi)
+	movq %r13, ARGS_r13(%rsi)
+	movq %r14, ARGS_r14(%rsi)
+	movq %r15, ARGS_r15(%rsi)
+	movq %rbx, ARGS_rbx(%rsi)
+	movq %rdi, ARGS_rdi(%rsi)
+.endif	/* \saved */
+
+	/* Copy output registers to the structure */
+	movq %rcx, ARGS_rcx(%rsi)
+	movq %rdx, ARGS_rdx(%rsi)
+	movq %r8,  ARGS_r8(%rsi)
+	movq %r9,  ARGS_r9(%rsi)
+	movq %r10, ARGS_r10(%rsi)
+	movq %r11, ARGS_r11(%rsi)
+.endif	/* \ret */
+
+.if \saved && \ret
+	/*
+	 * Clear registers shared by guest for VP.VMCALL/VP.ENTER to prevent
+	 * speculative use of guest's/VMM's values, including those are
+	 * restored from the stack.
+	 *
+	 * See arch/x86/kvm/vmx/vmenter.S:
+	 *
+	 * In theory, a L1 cache miss when restoring register from stack
+	 * could lead to speculative execution with guest's values.
+	 *
+	 * Note: RBP/RSP are not used as shared register.  RSI has been
+	 * restored already.
+	 *
+	 * XOR is cheap, thus unconditionally do for all leafs.
+	 */
+	xorl %ecx,  %ecx
+	xorl %edx,  %edx
+	xorl %r8d,  %r8d
+	xorl %r9d,  %r9d
+	xorl %r10d, %r10d
+	xorl %r11d, %r11d
+	xorl %r12d, %r12d
+	xorl %r13d, %r13d
+	xorl %r14d, %r14d
+	xorl %r15d, %r15d
+	xorl %ebx,  %ebx
+	xorl %edi,  %edi
+.endif	/* \ret && \host */
+
+.if \host
+.Lout\@:
+.endif
+
+.if \saved
+	/* Restore callee-saved GPRs as mandated by the x86_64 ABI */
+	popq	%r15
+	popq	%r14
+	popq	%r13
+	popq	%r12
+	popq	%rbx
+.endif	/* \saved */
+
+.if \host && \ret && \saved
+	popq	%rbp
+.endif
+	RET
+
+.if \host
+.Lseamcall_vmfailinvalid\@:
+	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
+	jmp .Lseamcall_fail\@
+
+.Lseamcall_trap\@:
+	/*
+	 * SEAMCALL caused #GP or #UD.  By reaching here RAX contains
+	 * the trap number.  Convert the trap number to the TDX error
+	 * code by setting TDX_SW_ERROR to the high 32-bits of RAX.
+	 *
+	 * Note cannot OR TDX_SW_ERROR directly to RAX as OR instruction
+	 * only accepts 32-bit immediate at most.
+	 */
+	movq $TDX_SW_ERROR, %rdi
+	orq  %rdi, %rax
+
+.Lseamcall_fail\@:
+.if \ret && \saved
+	/* pop the unused structure pointer back to RSI */
+	popq %rsi
+.endif
+	jmp .Lout\@
+
+	_ASM_EXTABLE_FAULT(.Lseamcall\@, .Lseamcall_trap\@)
+	_ASM_EXTABLE_TDX_MC(.Lafter_seamcall\@, .Lafter_nop\@)
+.endif	/* \host */
+
+.endm
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 4ae9a557..c4511a74 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -27,6 +27,9 @@ ifeq ($(CONFIG_EFI),y)
 cflatobjs += lib/x86/amd_sev.o
 cflatobjs += lib/efi.o
 cflatobjs += x86/efi/reloc_x86_64.o
+cflatobjs += lib/x86/tdxcall.o
+cflatobjs += lib/x86/tdcall.o
+cflatobjs += lib/x86/tdx.o
 endif
 
 OBJDIRS += lib/x86
-- 
2.25.1


