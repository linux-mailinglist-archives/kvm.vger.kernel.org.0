Return-Path: <kvm+bounces-9866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 337998678B3
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:36:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 505031C2B184
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EFD512CDB1;
	Mon, 26 Feb 2024 14:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MX3bk4qC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7725812CDA4;
	Mon, 26 Feb 2024 14:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958082; cv=none; b=TRewOTn8VNC9s/CG/ITxvGXybIHV5+LIaQ78Zxxjkh0y5mgx62fSvTstm+Z3tDpamTd3c1c1U8zWZ+F9F95om30deBNByR5MGISumU6oIfV6ycjktaM44HKwJgeljK85IXovnMcRyTIQHFn57ovP47zUdssLL4Kn5H5Oo6g02E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958082; c=relaxed/simple;
	bh=71RmCF0I5O9+DUkzTlfx4tfYMIMIEldy34Q0i64VxNA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BGYvAkEEC1NFuY8sSSYjlKbnLsQM6X6GdAJGBL8H2y4oQxEB8lGczf5VZe8MEZeRuZS/CZwTvUMjKPRujzXKPfgZbzgpFlNEYetKY9Up158DTSPbSKEdFbFTC/8+QkJsFx3/bqNVzd+FkITWP/Douo7dLVH1SmjS0Z1ZNMOrHu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MX3bk4qC; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e4670921a4so1635800b3a.0;
        Mon, 26 Feb 2024 06:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958079; x=1709562879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W29a9mqzu8vfy19euofChocK8qRaZXs4J5qOV1uE9JI=;
        b=MX3bk4qCC9uhO1qQvhnqqoqLl2K6xXTRX3clq8Cu7K75irm/F8rYaIVEdoYGsB+WR0
         DO2yZ5plz+Y0Ah9ZpqEuYqHzl/mKF1vu31cImcE20iyTnyHPNPHKpmoPmIRtEPZbwKdN
         1NdzUL4xrRpjR8AZSKmVOOo+JGbcABkhkbNdb7xs/HeMLYj5X4pnxD0+yFgzyOOHukE7
         1kCw9Q5Kny+xl7ox9YKjQSf+iGk/hnLBRyEsYngPW0IffOifxe+gajBsXchfE0tplSs/
         ePM+htcLAlUyBdGpupkL22Y2KIyz0TPV6oTTYut0qvutSnV87Z0J0d6FWDHw10J4N8hG
         Bk5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958079; x=1709562879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W29a9mqzu8vfy19euofChocK8qRaZXs4J5qOV1uE9JI=;
        b=vUG5Xf9UiSer9fK5bz6O0aR74CkQ8TvOPaqBBrsylO0/uhgJ+2hK9wFdcaIyjwanDq
         Pbc3Pu5uUkgCyfjwmqujIVEF6r2RZ0LQFhdCod18cm3S1ZZ9leAUhO8Cmnnzn16Nz/mf
         urHrzcmrauHQVdI45A3pbrb8sCXGCU//0k6in4P6LripQLLUXrQuOQmpGjQzSWCk7CnY
         5c+T2xMjdlbYvQvlX3gAV8z3lEnS9bwy9AnQ5TCGVdFM4gYheZCSoA6nt0aZn6Ft+aYd
         gDCcQGidBSbcz4OhMgPnBUP4O0oCNeD/XtjmjsOP8KEVcNMXx48FF7r3E/hWN1+2zvJr
         jT0w==
X-Forwarded-Encrypted: i=1; AJvYcCWZxjwo9lfMSHwDVW5UUfo5/0yD30Du1ADFGna04kRhzlPIbOlsd9ZzD+cBoWnbEkoxhYKIaQkOrxuHBlm2didv4xWe
X-Gm-Message-State: AOJu0Yye016zPDhn/m3Gq+ALP5zGDD2wXSqjLdHXQhS46dc8HPyxXBCC
	cGCzEyHcAPrmV/LjPyA8H2EMma0uUAinqHjUvHbrsjEyiDGe8yVAli/520wj
X-Google-Smtp-Source: AGHT+IF2wWZka0uY5mUOiFNqhGVsgbvVnqy5j8m1PdDgUuKtDBcxMJ01/THsuR4Kwz+eCftlt3cqqg==
X-Received: by 2002:a05:6a20:9f03:b0:1a0:c470:aacc with SMTP id mk3-20020a056a209f0300b001a0c470aaccmr9918044pzb.21.1708958079333;
        Mon, 26 Feb 2024 06:34:39 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id bw11-20020a17090af60b00b0029937256b91sm4562679pjb.7.2024.02.26.06.34.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:34:39 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Andy Lutomirski <luto@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Brian Gerst <brgerst@gmail.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [RFC PATCH 03/73] x86/entry: Implement switcher for PVM VM enter/exit
Date: Mon, 26 Feb 2024 22:35:20 +0800
Message-Id: <20240226143630.33643-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Since the PVM guest runs in hardware CPL3, the host/guest world
switching is similar to userspace/kernelspace switching. Therefore, PVM
has decided to reuse the host entries for host/guest world switching. In
order to differentiate PVM guests from normal userspace processes, a new
flag is introduced to mark that the guest is active. The host entries
are then modified to use this flag for handling forwarding. The modified
host entries and VM enter path are collectively called the "switcher."

In the host entries, if from CPL3 and the flag is set, then it is
regarded as VM exit and the handling will be forwarded to the
hypervisor.  Otherwise, the handling belongs to the host like before. If
from CPL0, the handling belongs to the host too. Paranoid entries should
save and restore the guest CR3, similar to the save and restore
procedure for user CR3 in KPTI.

So the switcher is not compatiable with KPTI currently.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/entry/Makefile            |   3 +
 arch/x86/entry/calling.h           |  47 ++++++++++-
 arch/x86/entry/entry_64.S          |  68 ++++++++++++++-
 arch/x86/entry/entry_64_switcher.S | 127 +++++++++++++++++++++++++++++
 arch/x86/include/asm/processor.h   |   5 ++
 arch/x86/include/asm/ptrace.h      |   3 +
 arch/x86/include/asm/switcher.h    |  59 ++++++++++++++
 arch/x86/kernel/asm-offsets_64.c   |   8 ++
 arch/x86/kernel/traps.c            |   3 +
 9 files changed, 315 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/entry/entry_64_switcher.S
 create mode 100644 arch/x86/include/asm/switcher.h

diff --git a/arch/x86/entry/Makefile b/arch/x86/entry/Makefile
index ca2fe186994b..55dd3f193d99 100644
--- a/arch/x86/entry/Makefile
+++ b/arch/x86/entry/Makefile
@@ -21,3 +21,6 @@ obj-$(CONFIG_PREEMPTION)	+= thunk_$(BITS).o
 obj-$(CONFIG_IA32_EMULATION)	+= entry_64_compat.o syscall_32.o
 obj-$(CONFIG_X86_X32_ABI)	+= syscall_x32.o
 
+ifeq ($(CONFIG_X86_64),y)
+	obj-y += 		entry_64_switcher.o
+endif
diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index c99f36339236..83758019162d 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -142,6 +142,10 @@ For 32-bit we have the following conventions - kernel is built with
 	.endif
 .endm
 
+.macro SET_NOFLUSH_BIT	reg:req
+	bts	$X86_CR3_PCID_NOFLUSH_BIT, \reg
+.endm
+
 #ifdef CONFIG_PAGE_TABLE_ISOLATION
 
 /*
@@ -154,10 +158,6 @@ For 32-bit we have the following conventions - kernel is built with
 #define PTI_USER_PCID_MASK		(1 << PTI_USER_PCID_BIT)
 #define PTI_USER_PGTABLE_AND_PCID_MASK  (PTI_USER_PCID_MASK | PTI_USER_PGTABLE_MASK)
 
-.macro SET_NOFLUSH_BIT	reg:req
-	bts	$X86_CR3_PCID_NOFLUSH_BIT, \reg
-.endm
-
 .macro ADJUST_KERNEL_CR3 reg:req
 	ALTERNATIVE "", "SET_NOFLUSH_BIT \reg", X86_FEATURE_PCID
 	/* Clear PCID and "PAGE_TABLE_ISOLATION bit", point CR3 at kernel pagetables: */
@@ -284,6 +284,45 @@ For 32-bit we have the following conventions - kernel is built with
 
 #endif
 
+#define TSS_extra(field) PER_CPU_VAR(cpu_tss_rw+TSS_EX_##field)
+
+/*
+ * Switcher would be disabled when KPTI is enabled.
+ *
+ * Ideally, switcher would switch to HOST_CR3 in IST before gsbase is fixed,
+ * in which case it would use the offset from the IST stack top to the TSS
+ * in CEA to get the pointer of the TSS.  But SEV guest modifies TSS.IST on
+ * the fly and makes the code non-workable in SEV guest even the switcher
+ * is not used.
+ *
+ * So switcher is marked disabled when KPTI is enabled rather than when
+ * in SEV guest.
+ *
+ * To enable switcher with KPTI, something like Integrated Entry code with
+ * atomic-IST-entry has to be introduced beforehand.
+ *
+ * The current SWITCHER_SAVE_AND_SWITCH_TO_HOST_CR3 is called after gsbase
+ * is fixed.
+ */
+.macro SWITCHER_SAVE_AND_SWITCH_TO_HOST_CR3 scratch_reg:req save_reg:req
+	ALTERNATIVE "", "jmp .Lend_\@", X86_FEATURE_PTI
+	cmpq	$0, TSS_extra(host_rsp)
+	jz	.Lend_\@
+	movq	%cr3, \save_reg
+	movq	TSS_extra(host_cr3), \scratch_reg
+	movq	\scratch_reg, %cr3
+.Lend_\@:
+.endm
+
+.macro SWITCHER_RESTORE_CR3 scratch_reg:req save_reg:req
+	ALTERNATIVE "", "jmp .Lend_\@", X86_FEATURE_PTI
+	cmpq	$0, TSS_extra(host_rsp)
+	jz	.Lend_\@
+	ALTERNATIVE "", "SET_NOFLUSH_BIT \save_reg", X86_FEATURE_PCID
+	movq	\save_reg, %cr3
+.Lend_\@:
+.endm
+
 /*
  * IBRS kernel mitigation for Spectre_v2.
  *
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 57fae15b3136..65bfebebeab6 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -278,10 +278,11 @@ SYM_CODE_END(xen_error_entry)
 
 /**
  * idtentry_body - Macro to emit code calling the C function
+ * @vector:		Vector number
  * @cfunc:		C function to be called
  * @has_error_code:	Hardware pushed error code on stack
  */
-.macro idtentry_body cfunc has_error_code:req
+.macro idtentry_body vector cfunc has_error_code:req
 
 	/*
 	 * Call error_entry() and switch to the task stack if from userspace.
@@ -297,6 +298,10 @@ SYM_CODE_END(xen_error_entry)
 	ENCODE_FRAME_POINTER
 	UNWIND_HINT_REGS
 
+	cmpq	$0, TSS_extra(host_rsp)
+	jne	.Lpvm_idtentry_body_\@
+.L_host_idtenrty_\@:
+
 	movq	%rsp, %rdi			/* pt_regs pointer into 1st argument*/
 
 	.if \has_error_code == 1
@@ -310,6 +315,25 @@ SYM_CODE_END(xen_error_entry)
 	REACHABLE
 
 	jmp	error_return
+
+.Lpvm_idtentry_body_\@:
+	testb	$3, CS(%rsp)
+	/* host exception nested in IST handler while the switcher is active */
+	jz	.L_host_idtenrty_\@
+
+	.if \vector < 256
+	movl	$\vector, ORIG_RAX+4(%rsp)
+	.else // X86_TRAP_OTHER
+	/*
+	 * Here are the macros for common_interrupt(), spurious_interrupt(),
+	 * and XENPV entries with the titular vector X86_TRAP_OTHER. XENPV
+	 * entries can't reach here while common_interrupt() and
+	 * spurious_interrupt() have the real vector at ORIG_RAX.
+	 */
+	movl	ORIG_RAX(%rsp), %eax
+	movl	%eax, ORIG_RAX+4(%rsp)
+	.endif
+	jmp	switcher_return_from_guest
 .endm
 
 /**
@@ -354,7 +378,7 @@ SYM_CODE_START(\asmsym)
 .Lfrom_usermode_no_gap_\@:
 	.endif
 
-	idtentry_body \cfunc \has_error_code
+	idtentry_body \vector \cfunc \has_error_code
 
 _ASM_NOKPROBE(\asmsym)
 SYM_CODE_END(\asmsym)
@@ -427,7 +451,7 @@ SYM_CODE_START(\asmsym)
 
 	/* Switch to the regular task stack and use the noist entry point */
 .Lfrom_usermode_switch_stack_\@:
-	idtentry_body noist_\cfunc, has_error_code=0
+	idtentry_body \vector, noist_\cfunc, has_error_code=0
 
 _ASM_NOKPROBE(\asmsym)
 SYM_CODE_END(\asmsym)
@@ -507,7 +531,7 @@ SYM_CODE_START(\asmsym)
 
 	/* Switch to the regular task stack */
 .Lfrom_usermode_switch_stack_\@:
-	idtentry_body user_\cfunc, has_error_code=1
+	idtentry_body \vector, user_\cfunc, has_error_code=1
 
 _ASM_NOKPROBE(\asmsym)
 SYM_CODE_END(\asmsym)
@@ -919,6 +943,16 @@ SYM_CODE_START(paranoid_entry)
 	FENCE_SWAPGS_KERNEL_ENTRY
 .Lparanoid_gsbase_done:
 
+	/*
+	 * Switch back to kernel cr3 when switcher is active.
+	 * Switcher can't be used when KPTI is enabled by far, so only one of
+	 * SAVE_AND_SWITCH_TO_KERNEL_CR3 and SWITCHER_SAVE_AND_SWITCH_TO_KERNEL_CR3
+	 * takes effect.  SWITCHER_SAVE_AND_SWITCH_TO_KERNEL_CR3 requires
+	 * kernel GSBASE.
+	 * See the comments above SWITCHER_SAVE_AND_SWITCH_TO_HOST_CR3.
+	 */
+	SWITCHER_SAVE_AND_SWITCH_TO_HOST_CR3 scratch_reg=%rax save_reg=%r14
+
 	/*
 	 * Once we have CR3 and %GS setup save and set SPEC_CTRL. Just like
 	 * CR3 above, keep the old value in a callee saved register.
@@ -970,6 +1004,15 @@ SYM_CODE_START_LOCAL(paranoid_exit)
 	 */
 	RESTORE_CR3	scratch_reg=%rax save_reg=%r14
 
+	/*
+	 * Switch back to origin cr3 when switcher is active.
+	 * Switcher can't be used when KPTI is enabled by far, so only
+	 * one of RESTORE_CR3 and SWITCHER_RESTORE_CR3 takes effect.
+	 *
+	 * See the comments above SWITCHER_SAVE_AND_SWITCH_TO_HOST_CR3.
+	 */
+	SWITCHER_RESTORE_CR3 scratch_reg=%rax save_reg=%r14
+
 	/* Handle the three GSBASE cases */
 	ALTERNATIVE "jmp .Lparanoid_exit_checkgs", "", X86_FEATURE_FSGSBASE
 
@@ -1158,6 +1201,8 @@ SYM_CODE_START(asm_exc_nmi)
 	FENCE_SWAPGS_USER_ENTRY
 	SWITCH_TO_KERNEL_CR3 scratch_reg=%rdx
 	movq	%rsp, %rdx
+	cmpq	$0, TSS_extra(host_rsp)
+	jne	.Lnmi_from_pvm_guest
 	movq	PER_CPU_VAR(pcpu_hot + X86_top_of_stack), %rsp
 	UNWIND_HINT_IRET_REGS base=%rdx offset=8
 	pushq	5*8(%rdx)	/* pt_regs->ss */
@@ -1188,6 +1233,21 @@ SYM_CODE_START(asm_exc_nmi)
 	 */
 	jmp	swapgs_restore_regs_and_return_to_usermode
 
+.Lnmi_from_pvm_guest:
+	movq	PER_CPU_VAR(cpu_tss_rw + TSS_sp0), %rsp
+	UNWIND_HINT_IRET_REGS base=%rdx offset=8
+	pushq	5*8(%rdx)	/* pt_regs->ss */
+	pushq	4*8(%rdx)	/* pt_regs->rsp */
+	pushq	3*8(%rdx)	/* pt_regs->flags */
+	pushq	2*8(%rdx)	/* pt_regs->cs */
+	pushq	1*8(%rdx)	/* pt_regs->rip */
+	UNWIND_HINT_IRET_REGS
+	pushq	$0		/* pt_regs->orig_ax */
+	movl	$2, 4(%rsp)	/* pt_regs->orig_ax, pvm vector */
+	PUSH_AND_CLEAR_REGS rdx=(%rdx)
+	ENCODE_FRAME_POINTER
+	jmp	switcher_return_from_guest
+
 .Lnmi_from_kernel:
 	/*
 	 * Here's what our stack frame will look like:
diff --git a/arch/x86/entry/entry_64_switcher.S b/arch/x86/entry/entry_64_switcher.S
new file mode 100644
index 000000000000..2b99a46421cc
--- /dev/null
+++ b/arch/x86/entry/entry_64_switcher.S
@@ -0,0 +1,127 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/linkage.h>
+#include <linux/export.h>
+#include <asm/segment.h>
+#include <asm/asm-offsets.h>
+#include <asm/msr.h>
+#include <asm/percpu.h>
+#include <asm/asm.h>
+#include <asm/nospec-branch.h>
+#include <asm/switcher.h>
+
+#include "calling.h"
+
+.code64
+.section .entry.text, "ax"
+
+.macro MITIGATION_EXIT
+	/* Same as user entry. */
+	IBRS_EXIT
+.endm
+
+.macro MITIGATION_ENTER
+	/*
+	 * IMPORTANT: RSB filling and SPEC_CTRL handling must be done before
+	 * the first unbalanced RET after vmexit!
+	 *
+	 * For retpoline or IBRS, RSB filling is needed to prevent poisoned RSB
+	 * entries and (in some cases) RSB underflow.
+	 *
+	 * eIBRS has its own protection against poisoned RSB, so it doesn't
+	 * need the RSB filling sequence.  But it does need to be enabled, and a
+	 * single call to retire, before the first unbalanced RET.
+	 */
+	FILL_RETURN_BUFFER %rcx, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT, \
+			   X86_FEATURE_RSB_VMEXIT_LITE
+
+	IBRS_ENTER
+.endm
+
+/*
+ * switcher_enter_guest - Do a transition to guest mode
+ *
+ * Called with guest registers on the top of the sp0 stack and the switcher
+ * states on cpu_tss_rw.tss_ex.
+ *
+ * Returns:
+ *	pointer to pt_regs (on top of sp0 or IST stack) with guest registers.
+ */
+SYM_FUNC_START(switcher_enter_guest)
+	pushq	%rbp
+	pushq	%r15
+	pushq	%r14
+	pushq	%r13
+	pushq	%r12
+	pushq	%rbx
+
+	/* Save host RSP and mark the switcher active */
+	movq	%rsp, TSS_extra(host_rsp)
+
+	/* Switch to host sp0  */
+	movq	PER_CPU_VAR(cpu_tss_rw + TSS_sp0), %rdi
+	subq	$FRAME_SIZE, %rdi
+	movq	%rdi, %rsp
+
+	UNWIND_HINT_REGS
+
+	MITIGATION_EXIT
+
+	/* switch to guest cr3 on sp0 stack */
+	movq	TSS_extra(enter_cr3), %rax
+	movq	%rax, %cr3
+	/* Load guest registers. */
+	POP_REGS
+	addq	$8, %rsp
+
+	/* Switch to guest GSBASE and return to guest */
+	swapgs
+	jmp	native_irq_return_iret
+
+SYM_INNER_LABEL(switcher_return_from_guest, SYM_L_GLOBAL)
+	/* switch back to host cr3 when still on sp0/ist stack */
+	movq	TSS_extra(host_cr3), %rax
+	movq	%rax, %cr3
+
+	MITIGATION_ENTER
+
+	/* Restore to host RSP and mark the switcher inactive */
+	movq	%rsp, %rax
+	movq	TSS_extra(host_rsp), %rsp
+	movq	$0, TSS_extra(host_rsp)
+
+	popq	%rbx
+	popq	%r12
+	popq	%r13
+	popq	%r14
+	popq	%r15
+	popq	%rbp
+	RET
+SYM_FUNC_END(switcher_enter_guest)
+EXPORT_SYMBOL_GPL(switcher_enter_guest)
+
+SYM_CODE_START(entry_SYSCALL_64_switcher)
+	UNWIND_HINT_ENTRY
+	ENDBR
+
+	swapgs
+	/* tss.sp2 is scratch space. */
+	movq	%rsp, PER_CPU_VAR(cpu_tss_rw + TSS_sp2)
+	movq	PER_CPU_VAR(cpu_tss_rw + TSS_sp0), %rsp
+
+SYM_INNER_LABEL(entry_SYSCALL_64_switcher_safe_stack, SYM_L_GLOBAL)
+	ANNOTATE_NOENDBR
+
+	/* Construct struct pt_regs on stack */
+	pushq	$__USER_DS				/* pt_regs->ss */
+	pushq	PER_CPU_VAR(cpu_tss_rw + TSS_sp2)	/* pt_regs->sp */
+	pushq	%r11					/* pt_regs->flags */
+	pushq	$__USER_CS				/* pt_regs->cs */
+	pushq	%rcx					/* pt_regs->ip */
+
+	pushq	$0					/* pt_regs->orig_ax */
+	movl	$SWITCH_EXIT_REASONS_SYSCALL, 4(%rsp)
+
+	PUSH_AND_CLEAR_REGS
+	jmp	switcher_return_from_guest
+SYM_CODE_END(entry_SYSCALL_64_switcher)
+EXPORT_SYMBOL_GPL(entry_SYSCALL_64_switcher)
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 83dc4122c38d..4115267e7a3e 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -29,6 +29,7 @@ struct vm86;
 #include <asm/vmxfeatures.h>
 #include <asm/vdso/processor.h>
 #include <asm/shstk.h>
+#include <asm/switcher.h>
 
 #include <linux/personality.h>
 #include <linux/cache.h>
@@ -382,6 +383,10 @@ struct tss_struct {
 	 */
 	struct x86_hw_tss	x86_tss;
 
+#ifdef CONFIG_X86_64
+	struct tss_extra	tss_ex;
+#endif
+
 	struct x86_io_bitmap	io_bitmap;
 } __aligned(PAGE_SIZE);
 
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index f4db78b09c8f..9eeeb5fdd387 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -5,6 +5,7 @@
 #include <asm/segment.h>
 #include <asm/page_types.h>
 #include <uapi/asm/ptrace.h>
+#include <asm/switcher.h>
 
 #ifndef __ASSEMBLY__
 #ifdef __i386__
@@ -194,6 +195,8 @@ static __always_inline bool ip_within_syscall_gap(struct pt_regs *regs)
 	ret = ret || (regs->ip >= (unsigned long)entry_SYSRETL_compat_unsafe_stack &&
 		      regs->ip <  (unsigned long)entry_SYSRETL_compat_end);
 #endif
+	ret = ret || (regs->ip >= (unsigned long)entry_SYSCALL_64_switcher &&
+		      regs->ip <  (unsigned long)entry_SYSCALL_64_switcher_safe_stack);
 
 	return ret;
 }
diff --git a/arch/x86/include/asm/switcher.h b/arch/x86/include/asm/switcher.h
new file mode 100644
index 000000000000..dbf1970ca62f
--- /dev/null
+++ b/arch/x86/include/asm/switcher.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_SWITCHER_H
+#define _ASM_X86_SWITCHER_H
+
+#ifdef CONFIG_X86_64
+#include <asm/processor-flags.h>
+
+#define SWITCH_EXIT_REASONS_SYSCALL		1024
+#define SWITCH_EXIT_REASONS_FAILED_VMETNRY	1025
+
+/* Bits allowed to be set in the underlying eflags */
+#define SWITCH_ENTER_EFLAGS_ALLOWED	(X86_EFLAGS_FIXED | X86_EFLAGS_IF |\
+					 X86_EFLAGS_TF | X86_EFLAGS_RF |\
+					 X86_EFLAGS_AC | X86_EFLAGS_OF | \
+					 X86_EFLAGS_DF | X86_EFLAGS_SF | \
+					 X86_EFLAGS_ZF | X86_EFLAGS_AF | \
+					 X86_EFLAGS_PF | X86_EFLAGS_CF | \
+					 X86_EFLAGS_ID | X86_EFLAGS_NT)
+
+/* Bits must be set in the underlying eflags */
+#define SWITCH_ENTER_EFLAGS_FIXED	(X86_EFLAGS_FIXED | X86_EFLAGS_IF)
+
+#ifndef __ASSEMBLY__
+#include <linux/cache.h>
+
+struct pt_regs;
+
+/*
+ * Extra per CPU control structure lives in the struct tss_struct.
+ *
+ * The page-size-aligned struct tss_struct has enough room to accommodate
+ * this extra data without increasing its size.
+ *
+ * The extra data is also in the first page of struct tss_struct whose
+ * read-write mapping (percpu cpu_tss_rw) is in the KPTI's user pagetable,
+ * so that it can even be accessible via cpu_tss_rw in the entry code.
+ */
+struct tss_extra {
+	/* Saved host CR3 to be loaded after VM exit. */
+	unsigned long host_cr3;
+	/*
+	 * Saved host stack to be loaded after VM exit. This also serves as a
+	 * flag to indicate that it is entering the guest world in the switcher
+	 * or has been in the guest world in the host entries.
+	 */
+	unsigned long host_rsp;
+	/* Prepared guest CR3 to be loaded before VM enter. */
+	unsigned long enter_cr3;
+} ____cacheline_aligned;
+
+extern struct pt_regs *switcher_enter_guest(void);
+extern const char entry_SYSCALL_64_switcher[];
+extern const char entry_SYSCALL_64_switcher_safe_stack[];
+extern const char entry_SYSRETQ_switcher_unsafe_stack[];
+#endif /* __ASSEMBLY__ */
+
+#endif /* CONFIG_X86_64 */
+
+#endif /* _ASM_X86_SWITCHER_H */
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index f39baf90126c..1485cbda6dc4 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -60,5 +60,13 @@ int main(void)
 	OFFSET(FIXED_stack_canary, fixed_percpu_data, stack_canary);
 	BLANK();
 #endif
+
+#define ENTRY(entry) OFFSET(TSS_EX_ ## entry, tss_struct, tss_ex.entry)
+	ENTRY(host_cr3);
+	ENTRY(host_rsp);
+	ENTRY(enter_cr3);
+	BLANK();
+#undef ENTRY
+
 	return 0;
 }
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c876f1d36a81..c4f2b629b422 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -773,6 +773,9 @@ DEFINE_IDTENTRY_RAW(exc_int3)
 asmlinkage __visible noinstr struct pt_regs *sync_regs(struct pt_regs *eregs)
 {
 	struct pt_regs *regs = (struct pt_regs *)this_cpu_read(pcpu_hot.top_of_stack) - 1;
+
+	if (this_cpu_read(cpu_tss_rw.tss_ex.host_rsp))
+		return eregs;
 	if (regs != eregs)
 		*regs = *eregs;
 	return regs;
-- 
2.19.1.6.gb485710b


