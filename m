Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0644CB7A3
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiCCH2H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiCCH2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:05 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8421F16C4C1
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292439; x=1677828439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4G8LrCp3BKo7nDAwSJLN4TtxP1W336SuN/7tBlpwgXo=;
  b=dVTHAmNCQ7ieV7muLd5wbCPG0OnBxFDVf7CHInjSbMBLQOClqpk5x2Yq
   tZ8UTYd9KtQtVjvq746XLFbeZ0RK3e9aNo+VEjvvDNmlGCDThUVHbdGIG
   SdPghJM7LmHyGm+5cXkk89FiT2h5tv7GpnLGQcakyADYKs3r6/bJiPZsS
   fewhr4SAEihHoShWAs871ZyVgE5JJ71Bt3kUR5SqSLqtnDxpMtoetqLcr
   2PVXwolRKb0JsuLoECu+i5BwROzL8A3G4QnlTP4TncdnlaBPTw9SG5t9F
   5ciriSub/i2O62RqFP8CSaQxwvy3vpOD70SpKbgmqVhVpZfk2p1xzQ3w6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251176933"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251176933"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:19 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631477"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:16 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 01/17] x86 TDX: Add support functions for TDX framework
Date:   Thu,  3 Mar 2022 15:18:51 +0800
Message-Id: <20220303071907.650203-2-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Port tdcall.S and tdx.c from TDX guest kernel source in
arch/x86/kernel directory, simplified and keep only code
which is useful for TDX kvm-unit-test framework.

tdcall.S contains two low level ABI functions:
__tdx_module_call and __tdx_hypercall.

lib/x86/tdx.c contains wrapper functions for simulating
various instructions through tdvmcall. Currently below
instructions are simulated:

	IO  read/write
	MSR read/write
	cpuid
	hlt

Define a dummy is_tdx_guest() if TARGET_EFI is undefined
as this function will be used globally in the future.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 lib/x86/asm/setup.h |   1 +
 lib/x86/setup.c     |  10 ++
 lib/x86/tdcall.S    | 303 ++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/tdx.c       | 276 ++++++++++++++++++++++++++++++++++++++++
 lib/x86/tdx.h       |  76 +++++++++++
 x86/Makefile.common |   2 +
 6 files changed, 668 insertions(+)
 create mode 100644 lib/x86/tdcall.S
 create mode 100644 lib/x86/tdx.c
 create mode 100644 lib/x86/tdx.h

diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index dbfb2a22bc1b..c467a2e94861 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -15,5 +15,6 @@ unsigned long setup_tss(u8 *stacktop);
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
 void setup_5level_page_table(void);
 #endif /* TARGET_EFI */
+#include "x86/tdx.h"
 
 #endif /* _X86_ASM_SETUP_H_ */
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index bbd34682b79e..fbcd188ebb8f 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -283,6 +283,16 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	efi_status_t status;
 	const char *phase;
 
+	/*
+	 * TDVF support partial memory accept, accept remaining memory
+	 * early so memory allocator can use it.
+	 */
+	status = setup_tdx();
+	if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED) {
+		printf("INTEL TDX setup failed, error = 0x%lx\n", status);
+		return status;
+	}
+
 	status = setup_memory_allocator(efi_bootinfo);
 	if (status != EFI_SUCCESS) {
 		printf("Failed to set up memory allocator: ");
diff --git a/lib/x86/tdcall.S b/lib/x86/tdcall.S
new file mode 100644
index 000000000000..89133d211376
--- /dev/null
+++ b/lib/x86/tdcall.S
@@ -0,0 +1,303 @@
+/*
+ * Low level API for tdcall and tdvmcall
+ *
+ * Copyright (c) 2022, Intel Inc
+ *
+ * Authors:
+ *   Zhenzhong Duan <zhenzhong.duan@intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0
+ */
+
+#include <errno.h>
+
+#define ARG7_SP_OFFSET		0x08
+
+#define TDX_MODULE_rcx		0x0
+#define TDX_MODULE_rdx		0x8
+#define TDX_MODULE_r8		0x10
+#define TDX_MODULE_r9		0x18
+#define TDX_MODULE_r10		0x20
+#define TDX_MODULE_r11		0x28
+
+#define TDX_HYPERCALL_r10	0x0
+#define TDX_HYPERCALL_r11	0x8
+#define TDX_HYPERCALL_r12	0x10
+#define TDX_HYPERCALL_r13	0x18
+#define TDX_HYPERCALL_r14	0x20
+#define TDX_HYPERCALL_r15	0x28
+
+/*
+ * Expose registers R10-R15 to VMM. It is passed via RCX register
+ * to the TDX Module, which will be used by the TDX module to
+ * identify the list of registers exposed to VMM. Each bit in this
+ * mask represents a register ID. Bit field details can be found
+ * in TDX GHCI specification.
+ */
+#define TDVMCALL_EXPOSE_REGS_MASK	0xfc00
+
+/*
+ * TDX guests use the TDCALL instruction to make requests to the
+ * TDX module and hypercalls to the VMM. It is supported in
+ * Binutils >= 2.36.
+ */
+#define tdcall .byte 0x66,0x0f,0x01,0xcc
+
+/* HLT TDVMCALL sub-function ID */
+#define EXIT_REASON_HLT		12
+
+/*
+ * __tdx_module_call()  - Helper function used by TDX guests to request
+ * services from the TDX module (does not include VMM services).
+ *
+ * This function serves as a wrapper to move user call arguments to the
+ * correct registers as specified by TDCALL ABI and share it with the
+ * TDX module. If the TDCALL operation is successful and a valid
+ * "struct tdx_module_output" pointer is available (in "out" argument),
+ * output from the TDX module is saved to the memory specified in the
+ * "out" pointer. Also the status of the TDCALL operation is returned
+ * back to the user as a function return value.
+ *
+ *-------------------------------------------------------------------------
+ * TDCALL ABI:
+ *-------------------------------------------------------------------------
+ * Input Registers:
+ *
+ * RAX                 - TDCALL Leaf number.
+ * RCX,RDX,R8-R9       - TDCALL Leaf specific input registers.
+ *
+ * Output Registers:
+ *
+ * RAX                 - TDCALL instruction error code.
+ * RCX,RDX,R8-R11      - TDCALL Leaf specific output registers.
+ *
+ *-------------------------------------------------------------------------
+ *
+ * __tdx_module_call() function ABI:
+ *
+ * @fn  (RDI)          - TDCALL Leaf ID,    moved to RAX
+ * @rcx (RSI)          - Input parameter 1, moved to RCX
+ * @rdx (RDX)          - Input parameter 2, moved to RDX
+ * @r8  (RCX)          - Input parameter 3, moved to R8
+ * @r9  (R8)           - Input parameter 4, moved to R9
+ *
+ * @out (R9)           - struct tdx_module_output pointer
+ *                       stored temporarily in R12 (not
+ *                       shared with the TDX module). It
+ *                       can be NULL.
+ *
+ * Return status of TDCALL via RAX.
+ */
+.global __tdx_module_call
+__tdx_module_call:
+	/*
+	 * R12 will be used as temporary storage for
+	 * struct tdx_module_output pointer. More
+	 * details about struct tdx_module_output can
+	 * be found in arch/x86/include/asm/tdx.h. Also
+	 * note that registers R12-R15 are not used by
+	 * TDCALL services supported by this helper
+	 * function.
+	 */
+
+	/* Callee saved, so preserve it */
+	push %r12
+
+	/*
+	 * Push output pointer to stack, after TDCALL operation,
+	 * it will be fetched into R12 register.
+	 */
+	push %r9
+
+	/* Mangle function call ABI into TDCALL ABI: */
+	/* Move TDCALL Leaf ID to RAX */
+	mov %rdi, %rax
+	/* Move input 4 to R9 */
+	mov %r8,  %r9
+	/* Move input 3 to R8 */
+	mov %rcx, %r8
+	/* Move input 1 to RCX */
+	mov %rsi, %rcx
+	/* Leave input param 2 in RDX */
+
+	tdcall
+
+	/* Fetch output pointer from stack to R12 */
+	pop %r12
+
+	/* Check for TDCALL success: 0 - Successful, otherwise failed */
+	test %rax, %rax
+	jnz 1f
+
+	/*
+	 * __tdx_module_call() can be initiated without an output pointer.
+	 * So, check if caller provided an output struct before storing
+	 * output registers.
+	 */
+	test %r12, %r12
+	jz 1f
+
+	/* Copy TDCALL result registers to output struct: */
+	movq %rcx, TDX_MODULE_rcx(%r12)
+	movq %rdx, TDX_MODULE_rdx(%r12)
+	movq %r8,  TDX_MODULE_r8(%r12)
+	movq %r9,  TDX_MODULE_r9(%r12)
+	movq %r10, TDX_MODULE_r10(%r12)
+	movq %r11, TDX_MODULE_r11(%r12)
+1:
+	/* Restore the state of R12 register */
+	pop %r12
+	ret
+
+/*
+ * __tdx_hypercall()  - Helper function used by TDX guests to request
+ * services from the VMM. All requests are made via the TDX module
+ * using TDCALL instruction.
+ *
+ * This function serves as a wrapper to move user call arguments to the
+ * correct registers as specified by TDCALL ABI and share it with VMM
+ * via the TDX module. After TDCALL operation, output from the VMM is
+ * saved to the memory specified in the "out" (struct tdx_hypercall_output)
+ * pointer.
+ *
+ *-------------------------------------------------------------------------
+ * TD VMCALL ABI:
+ *-------------------------------------------------------------------------
+ *
+ * Input Registers:
+ *
+ * RAX                 - TDCALL instruction leaf number (0 - TDG.VP.VMCALL)
+ * RCX                 - BITMAP which controls which part of TD Guest GPR
+ *                       is passed as-is to VMM and back.
+ * R10                 - Set 0 to indicate TDCALL follows standard TDX ABI
+ *                       specification. Non zero value indicates vendor
+ *                       specific ABI.
+ * R11                 - VMCALL sub function number
+ * RBX, RBP, RDI, RSI  - Used to pass VMCALL sub function specific arguments.
+ * R8-R9, R12-R15      - Same as above.
+ *
+ * Output Registers:
+ *
+ * RAX                 - TDCALL instruction status (Not related to hypercall
+ *                        output).
+ * R10                 - Hypercall output error code.
+ * R11-R15             - Hypercall sub function specific output values.
+ *
+ *-------------------------------------------------------------------------
+ *
+ * __tdx_hypercall() function ABI:
+ *
+ * @type  (RDI)        - TD VMCALL type, moved to R10
+ * @fn    (RSI)        - TD VMCALL sub function, moved to R11
+ * @r12   (RDX)        - Input parameter 1, moved to R12
+ * @r13   (RCX)        - Input parameter 2, moved to R13
+ * @r14   (R8)         - Input parameter 3, moved to R14
+ * @r15   (R9)         - Input parameter 4, moved to R15
+ *
+ * @out   (stack)      - struct tdx_hypercall_output pointer (cannot be NULL)
+ *
+ * On successful completion, return TDCALL status or -EINVAL for invalid
+ * inputs.
+ */
+.globl __tdx_hypercall
+__tdx_hypercall:
+	/* Move argument 7 from caller stack to RAX */
+	movq ARG7_SP_OFFSET(%rsp), %rax
+
+	/* Check if caller provided an output struct */
+	test %rax, %rax
+	/* If out pointer is NULL, return -EINVAL */
+	jz 1f
+
+	/* Save callee-saved GPRs as mandated by the x86_64 ABI */
+	push %r15
+	push %r14
+	push %r13
+	push %r12
+
+	/*
+	 * Save output pointer (rax) in stack, it will be used
+	 * again when storing the output registers after TDCALL
+	 * operation.
+	 */
+	push %rax
+
+	/* Mangle function call ABI into TDCALL ABI: */
+	/* Set TDCALL leaf ID (TDVMCALL (0)) in RAX */
+	xor %eax, %eax
+	/* Move TDVMCALL type (standard vs vendor) in R10 */
+	mov %rdi, %r10
+	/* Move TDVMCALL sub function id to R11 */
+	mov %rsi, %r11
+	/* Move input 1 to R12 */
+	mov %rdx, %r12
+	/* Move input 2 to R13 */
+	mov %rcx, %r13
+	/* Move input 3 to R14 */
+	mov %r8,  %r14
+	/* Move input 4 to R15 */
+	mov %r9,  %r15
+
+	movl $TDVMCALL_EXPOSE_REGS_MASK, %ecx
+
+	/*
+	 * For the idle loop STI needs to be called directly before
+	 * the TDCALL that enters idle (EXIT_REASON_HLT case). STI
+	 * enables interrupts only one instruction later. If there
+	 * are any instructions between the STI and the TDCALL for
+	 * HLT then an interrupt could happen in that time, but the
+	 * code would go back to sleep afterwards, which can cause
+	 * longer delays.
+	 *
+	 * This leads to significant difference in network performance
+	 * benchmarks. So add a special case for EXIT_REASON_HLT to
+	 * trigger STI before TDCALL. But this change is not required
+	 * for all HLT cases. So use R15 register value to identify the
+	 * case which needs STI. So, if R11 is EXIT_REASON_HLT and R15
+	 * is 1, then call STI before TDCALL instruction. Note that R15
+	 * register is not required by TDCALL ABI when triggering the
+	 * hypercall for EXIT_REASON_HLT case. So use it in software to
+	 * select the STI case.
+	 */
+	cmpl $EXIT_REASON_HLT, %r11d
+	jne skip_sti
+	cmpl $1, %r15d
+	jne skip_sti
+	/* Set R15 register to 0, it is unused in EXIT_REASON_HLT case */
+	xor %r15, %r15
+	sti
+skip_sti:
+	tdcall
+
+	/* Restore output pointer to R9 */
+	pop  %r9
+
+	/* Copy hypercall result registers to output struct: */
+	movq %r10, TDX_HYPERCALL_r10(%r9)
+	movq %r11, TDX_HYPERCALL_r11(%r9)
+	movq %r12, TDX_HYPERCALL_r12(%r9)
+	movq %r13, TDX_HYPERCALL_r13(%r9)
+	movq %r14, TDX_HYPERCALL_r14(%r9)
+	movq %r15, TDX_HYPERCALL_r15(%r9)
+
+	/*
+	 * Zero out registers exposed to the VMM to avoid
+	 * speculative execution with VMM-controlled values.
+	 * This needs to include all registers present in
+	 * TDVMCALL_EXPOSE_REGS_MASK (except R12-R15).
+	 * R12-R15 context will be restored.
+	 */
+	xor %r10d, %r10d
+	xor %r11d, %r11d
+
+	/* Restore callee-saved GPRs as mandated by the x86_64 ABI */
+	pop %r12
+	pop %r13
+	pop %r14
+	pop %r15
+
+	jmp 2f
+1:
+	movq $-EINVAL, %rax
+2:
+	retq
diff --git a/lib/x86/tdx.c b/lib/x86/tdx.c
new file mode 100644
index 000000000000..8308480105d6
--- /dev/null
+++ b/lib/x86/tdx.c
@@ -0,0 +1,276 @@
+/*
+ * TDX library
+ *
+ * Copyright (c) 2022, Intel Inc
+ *
+ * Authors:
+ *   Zhenzhong Duan <zhenzhong.duan@intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0
+ */
+
+#include "tdx.h"
+#include "bitops.h"
+#include "x86/processor.h"
+#include "x86/smp.h"
+
+#define VE_IS_IO_OUT(exit_qual)		(((exit_qual) & 8) ? 0 : 1)
+#define VE_GET_IO_SIZE(exit_qual)	(((exit_qual) & 7) + 1)
+#define VE_GET_PORT_NUM(exit_qual)	((exit_qual) >> 16)
+#define VE_IS_IO_STRING(exit_qual)	((exit_qual) & 16 ? 1 : 0)
+
+#define BUFSZ		2000
+#define serial_iobase	0x3f8
+
+static struct spinlock tdx_puts_lock;
+
+/*
+ * Helper function used for making hypercall for "in"
+ * instruction. If IO is failed, it will return all 1s.
+ */
+static inline unsigned int tdx_io_in(int size, int port)
+{
+	struct tdx_hypercall_output out;
+
+	__tdx_hypercall(TDX_HYPERCALL_STANDARD, EXIT_REASON_IO_INSTRUCTION,
+			size, 0, port, 0, &out);
+
+	return out.r10 ? UINT_MAX : out.r11;
+}
+
+/*
+ * Helper function used for making hypercall for "out"
+ * instruction.
+ */
+static inline void tdx_io_out(int size, int port, u64 value)
+{
+	struct tdx_hypercall_output out;
+
+	__tdx_hypercall(TDX_HYPERCALL_STANDARD, EXIT_REASON_IO_INSTRUCTION,
+			size, 1, port, value, &out);
+}
+
+static void tdx_outb(u8 value, u32 port)
+{
+	tdx_io_out(sizeof(u8), port, value);
+}
+
+static u8 tdx_inb(u32 port)
+{
+	return tdx_io_in(sizeof(u8), port);
+}
+
+static void tdx_serial_outb(char ch)
+{
+	u8 lsr;
+
+	do {
+		lsr = tdx_inb(serial_iobase + 0x05);
+	} while (!(lsr & 0x20));
+
+	tdx_outb(ch, serial_iobase + 0x00);
+}
+
+static void tdx_puts(const char *buf)
+{
+	unsigned long len = strlen(buf);
+	unsigned long i;
+
+	spin_lock(&tdx_puts_lock);
+
+	/* No need to initialize serial port as TDVF has done that */
+	for (i = 0; i < len; i++)
+		tdx_serial_outb(buf[i]);
+
+	spin_unlock(&tdx_puts_lock);
+}
+
+/* Used only in TDX arch code itself */
+static int tdx_printf(const char *fmt, ...)
+{
+	va_list va;
+	char buf[BUFSZ];
+	int r;
+
+	va_start(va, fmt);
+	r = vsnprintf(buf, sizeof(buf), fmt, va);
+	va_end(va);
+	tdx_puts(buf);
+	return r;
+}
+
+bool is_tdx_guest(void)
+{
+	static int tdx_guest = -1;
+	struct cpuid c;
+	u32 sig[3];
+
+	if (tdx_guest >= 0)
+		goto done;
+
+	if (cpuid(0).a < TDX_CPUID_LEAF_ID) {
+		tdx_guest = 0;
+		goto done;
+	}
+
+	c = cpuid(TDX_CPUID_LEAF_ID);
+	sig[0] = c.b;
+	sig[1] = c.d;
+	sig[2] = c.c;
+
+	tdx_guest = !memcmp("IntelTDX    ", sig, 12);
+
+done:
+	return !!tdx_guest;
+}
+
+/*
+ * Wrapper for standard use of __tdx_hypercall with BUG_ON() check
+ * for TDCALL error.
+ */
+static inline u64 _tdx_hypercall(u64 fn, u64 r12, u64 r13, u64 r14,
+				 u64 r15, struct tdx_hypercall_output *out)
+{
+	struct tdx_hypercall_output outl;
+	u64 err;
+
+	/* __tdx_hypercall() does not accept NULL output pointer */
+	if (!out)
+		out = &outl;
+
+	err = __tdx_hypercall(TDX_HYPERCALL_STANDARD, fn, r12, r13, r14,
+			      r15, out);
+
+	/* Non zero return value indicates buggy TDX module, so panic */
+	BUG_ON(err);
+
+	if (out->r10)
+		tdx_printf("_tdx_hypercall err %lx %lx %lx %lx %lx %lx\n",
+			   out->r10, out->r11, out->r12, out->r13,
+			   out->r14, out->r15);
+	return out->r10;
+}
+
+static bool _tdx_halt(const bool irq_disabled, const bool do_sti)
+{
+	u64 ret;
+
+	/*
+	 * Emulate HLT operation via hypercall. More info about ABI
+	 * can be found in TDX Guest-Host-Communication Interface
+	 * (GHCI), sec 3.8 TDG.VP.VMCALL<Instruction.HLT>.
+	 *
+	 * The VMM uses the "IRQ disabled" param to understand IRQ
+	 * enabled status (RFLAGS.IF) of TD guest and determine
+	 * whether or not it should schedule the halted vCPU if an
+	 * IRQ becomes pending. E.g. if IRQs are disabled the VMM
+	 * can keep the vCPU in virtual HLT, even if an IRQ is
+	 * pending, without hanging/breaking the guest.
+	 *
+	 * do_sti parameter is used by __tdx_hypercall() to decide
+	 * whether to call STI instruction before executing TDCALL
+	 * instruction.
+	 */
+	ret = _tdx_hypercall(EXIT_REASON_HLT, irq_disabled, 0, 0,
+			     do_sti, NULL);
+	return !ret;
+}
+
+static bool tdx_read_msr(unsigned int msr, u64 *val)
+{
+	struct tdx_hypercall_output out;
+	u64 ret;
+
+	/*
+	 * Emulate the MSR read via hypercall. More info about ABI
+	 * can be found in TDX Guest-Host-Communication Interface
+	 * (GHCI), sec titled "TDG.VP.VMCALL<Instruction.RDMSR>".
+	 */
+	ret = _tdx_hypercall(EXIT_REASON_MSR_READ, msr, 0, 0, 0, &out);
+
+	if (ret)
+		return false;
+
+	*val = out.r11;
+	return true;
+}
+
+static bool tdx_write_msr(unsigned int msr, unsigned int low,
+			       unsigned int high)
+{
+	u64 ret;
+
+	/*
+	 * Emulate the MSR write via hypercall. More info about ABI
+	 * can be found in TDX Guest-Host-Communication Interface
+	 * (GHCI) sec titled "TDG.VP.VMCALL<Instruction.WRMSR>".
+	 */
+	ret = _tdx_hypercall(EXIT_REASON_MSR_WRITE, msr,
+			     (u64)high << 32 | low, 0, 0, NULL);
+
+	return !ret;
+}
+
+static bool tdx_handle_cpuid(struct ex_regs *regs)
+{
+	struct tdx_hypercall_output out;
+
+	/*
+	 * Emulate CPUID instruction via hypercall. More info about
+	 * ABI can be found in TDX Guest-Host-Communication Interface
+	 * (GHCI), section titled "VP.VMCALL<Instruction.CPUID>".
+	 */
+	if (_tdx_hypercall(EXIT_REASON_CPUID, regs->rax, regs->rcx,
+			   0, 0, &out))
+		return false;
+
+	/*
+	 * As per TDX GHCI CPUID ABI, r12-r15 registers contains contents of
+	 * EAX, EBX, ECX, EDX registers after CPUID instruction execution.
+	 * So copy the register contents back to ex_regs.
+	 */
+	regs->rax = out.r12;
+	regs->rbx = out.r13;
+	regs->rcx = out.r14;
+	regs->rdx = out.r15;
+
+	return true;
+}
+
+static bool tdx_handle_io(struct ex_regs *regs, u32 exit_qual)
+{
+	struct tdx_hypercall_output outh;
+	int out, size, port, ret;
+	bool string;
+	u64 mask;
+
+	string = VE_IS_IO_STRING(exit_qual);
+
+	/* I/O strings ops are unrolled at build time. */
+	if (string) {
+		tdx_printf("string io isn't supported in #VE currently.\n");
+		return false;
+	}
+
+	out = VE_IS_IO_OUT(exit_qual);
+	size = VE_GET_IO_SIZE(exit_qual);
+	port = VE_GET_PORT_NUM(exit_qual);
+	mask = GENMASK(8 * size, 0);
+
+	ret = _tdx_hypercall(EXIT_REASON_IO_INSTRUCTION,
+			     size, out, port, regs->rax, &outh);
+	if (!out) {
+		regs->rax &= ~mask;
+		regs->rax |= (ret ? UINT_MAX : outh.r11) & mask;
+	}
+
+	return ret ? false : true;
+}
+
+efi_status_t setup_tdx(void)
+{
+	if (!is_tdx_guest())
+		return EFI_UNSUPPORTED;
+
+	return EFI_SUCCESS;
+}
diff --git a/lib/x86/tdx.h b/lib/x86/tdx.h
new file mode 100644
index 000000000000..92ae5277b04d
--- /dev/null
+++ b/lib/x86/tdx.h
@@ -0,0 +1,76 @@
+/*
+ * TDX library
+ *
+ * Copyright (c) 2022, Intel Inc
+ *
+ * Authors:
+ *   Zhenzhong Duan <zhenzhong.duan@intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0
+ */
+
+#ifndef _ASM_X86_TDX_H
+#define _ASM_X86_TDX_H
+
+#ifdef TARGET_EFI
+
+#include "libcflat.h"
+#include "limits.h"
+#include "efi.h"
+
+#define BUG_ON(condition) do { if (condition) abort(); } while (0)
+
+#define TDX_CPUID_LEAF_ID		0x21
+#define TDX_HYPERCALL_STANDARD		0
+
+#define EXIT_REASON_CPUID               10
+#define EXIT_REASON_HLT                 12
+#define EXIT_REASON_IO_INSTRUCTION      30
+#define EXIT_REASON_MSR_READ            31
+#define EXIT_REASON_MSR_WRITE           32
+
+/*
+ * Used in __tdx_module_call() helper function to gather the
+ * output registers' values of TDCALL instruction when requesting
+ * services from the TDX module. This is software only structure
+ * and not related to TDX module/VMM.
+ */
+struct tdx_module_output {
+	u64 rcx;
+	u64 rdx;
+	u64 r8;
+	u64 r9;
+	u64 r10;
+	u64 r11;
+};
+
+/*
+ * Used in __tdx_hypercall() helper function to gather the
+ * output registers' values of TDCALL instruction when requesting
+ * services from the VMM. This is software only structure
+ * and not related to TDX module/VMM.
+ */
+struct tdx_hypercall_output {
+	u64 r10;
+	u64 r11;
+	u64 r12;
+	u64 r13;
+	u64 r14;
+	u64 r15;
+};
+
+bool is_tdx_guest(void);
+efi_status_t setup_tdx(void);
+
+/* Helper function used to communicate with the TDX module */
+u64 __tdx_module_call(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
+		      struct tdx_module_output *out);
+
+/* Helper function used to request services from VMM */
+u64 __tdx_hypercall(u64 type, u64 fn, u64 r12, u64 r13, u64 r14,
+		    u64 r15, struct tdx_hypercall_output *out);
+#else
+inline bool is_tdx_guest(void) { return false; }
+#endif /* TARGET_EFI */
+
+#endif /* _ASM_X86_TDX_H */
diff --git a/x86/Makefile.common b/x86/Makefile.common
index ff02d9822321..8e2970b1cfc4 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -26,6 +26,8 @@ ifeq ($(TARGET_EFI),y)
 cflatobjs += lib/x86/amd_sev.o
 cflatobjs += lib/efi.o
 cflatobjs += x86/efi/reloc_x86_64.o
+cflatobjs += lib/x86/tdcall.o
+cflatobjs += lib/x86/tdx.o
 endif
 
 OBJDIRS += lib/x86
-- 
2.25.1

