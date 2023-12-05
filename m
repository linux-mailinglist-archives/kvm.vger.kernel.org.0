Return-Path: <kvm+bounces-3550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1AC48052B2
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:25:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC22FB20CEE
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7789F6979A;
	Tue,  5 Dec 2023 11:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sy/QCuNn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD59D4B;
	Tue,  5 Dec 2023 03:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701775297; x=1733311297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p+DpQXfFjluhEPpBgGqFegRQUmj2AdYX7lnZ9lGR9vg=;
  b=Sy/QCuNn8YJvHU02oZH7r0cpO+kn0IbqX9koWatYzTBHu74GQdrwThCV
   x07gjG34kg4PvFVtjgJ0odpuhF9jLre9LvP0eCCGXoRL++8b39+73vX7D
   7JuLt1VHRlP4wVgpDRLfTLjvSVPdrKpQUvGtZFRVl6t6EAcb57sk2xrfX
   5FW5IsYFd6bX51WS/AwfEGHslvIUpGtfMnqYB0/RZIba8cmLVULXaIkHy
   GwjZlxI3kb/OMTulkj+MIfqTq8ZL50dIOy8S8Ma8gsz748cieKyD4N5Ge
   2+IKl1AOjnAFoKTpZmYFdHZOXzlBjrIGg/hoC0rPhaUC3kdVOZNsUK3GU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="942717"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="942717"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 03:21:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="1018193009"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="1018193009"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 05 Dec 2023 03:21:25 -0800
From: Xin Li <xin3.li@intel.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	peterz@infradead.org,
	jgross@suse.com,
	ravi.v.shankar@intel.com,
	mhiramat@kernel.org,
	andrew.cooper3@citrix.com,
	jiangshanlai@gmail.com,
	nik.borisov@suse.com,
	shan.kang@intel.com
Subject: [PATCH v13 31/35] x86/entry: Add fred_entry_from_kvm() for VMX to handle IRQ/NMI
Date: Tue,  5 Dec 2023 02:50:20 -0800
Message-ID: <20231205105030.8698-32-xin3.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205105030.8698-1-xin3.li@intel.com>
References: <20231205105030.8698-1-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In IRQ/NMI induced VM exits, KVM VMX needs to execute the respective
handlers, which requires the software to create a FRED stack frame,
and use it to invoke the handlers. Add fred_irq_entry_from_kvm() for
this job.

Export fred_entry_from_kvm() because VMX can be compiled as a module.

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v10:
* Better explain the reason why no need to check current stack level
  (Paolo Bonzini).

Changes since v9:
* Shove the whole thing into arch/x86/entry/entry_64_fred.S for invoking
  external_interrupt() and fred_exc_nmi() (Sean Christopherson).
* Correct and improve a few comments (Sean Christopherson).
* Merge the two IRQ/NMI asm entries into one as it's fine to invoke
  noinstr code from regular code (Thomas Gleixner).
* Setup the long mode and NMI flags in the augmented SS field of FRED
  stack frame in C instead of asm (Thomas Gleixner).
* Add UNWIND_HINT_{SAVE,RESTORE} to get rid of the warning: "objtool:
  asm_fred_entry_from_kvm+0x0: unreachable instruction" (Peter Zijlstra).

Changes since v8:
* Add a new macro VMX_DO_FRED_EVENT_IRQOFF for FRED instead of
  refactoring VMX_DO_EVENT_IRQOFF (Sean Christopherson).
* Do NOT use a trampoline, just LEA+PUSH the return RIP, PUSH the error
  code, and jump to the FRED kernel entry point for NMI or call
  external_interrupt() for IRQs (Sean Christopherson).
* Call external_interrupt() only when FRED is enabled, and convert the
  non-FRED handling to external_interrupt() after FRED lands (Sean
  Christopherson).
---
 arch/x86/entry/entry_64_fred.S | 77 ++++++++++++++++++++++++++++++++++
 arch/x86/entry/entry_fred.c    | 14 +++++++
 arch/x86/include/asm/fred.h    | 18 ++++++++
 3 files changed, 109 insertions(+)

diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
index d1c2fc4af8ae..eedf98de7538 100644
--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -3,8 +3,11 @@
  * The actual FRED entry points.
  */
 
+#include <linux/export.h>
+
 #include <asm/asm.h>
 #include <asm/fred.h>
+#include <asm/segment.h>
 
 #include "calling.h"
 
@@ -54,3 +57,77 @@ SYM_CODE_START_NOALIGN(asm_fred_entrypoint_kernel)
 	FRED_EXIT
 	ERETS
 SYM_CODE_END(asm_fred_entrypoint_kernel)
+
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+SYM_FUNC_START(asm_fred_entry_from_kvm)
+	push %rbp
+	mov %rsp, %rbp
+
+	UNWIND_HINT_SAVE
+
+	/*
+	 * Both IRQ and NMI from VMX can be handled on current task stack
+	 * because there is no need to protect from reentrancy and the call
+	 * stack leading to this helper is effectively constant and shallow
+	 * (relatively speaking). Do the same when FRED is active, i.e., no
+	 * need to check current stack level for a stack switch.
+	 *
+	 * Emulate the FRED-defined redzone and stack alignment.
+	 */
+	sub $(FRED_CONFIG_REDZONE_AMOUNT << 6), %rsp
+	and $FRED_STACK_FRAME_RSP_MASK, %rsp
+
+	/*
+	 * Start to push a FRED stack frame, which is always 64 bytes:
+	 *
+	 * +--------+-----------------+
+	 * | Bytes  | Usage           |
+	 * +--------+-----------------+
+	 * | 63:56  | Reserved        |
+	 * | 55:48  | Event Data      |
+	 * | 47:40  | SS + Event Info |
+	 * | 39:32  | RSP             |
+	 * | 31:24  | RFLAGS          |
+	 * | 23:16  | CS + Aux Info   |
+	 * |  15:8  | RIP             |
+	 * |   7:0  | Error Code      |
+	 * +--------+-----------------+
+	 */
+	push $0				/* Reserved, must be 0 */
+	push $0				/* Event data, 0 for IRQ/NMI */
+	push %rdi			/* fred_ss handed in by the caller */
+	push %rbp
+	pushf
+	mov $__KERNEL_CS, %rax
+	push %rax
+
+	/*
+	 * Unlike the IDT event delivery, FRED _always_ pushes an error code
+	 * after pushing the return RIP, thus the CALL instruction CANNOT be
+	 * used here to push the return RIP, otherwise there is no chance to
+	 * push an error code before invoking the IRQ/NMI handler.
+	 *
+	 * Use LEA to get the return RIP and push it, then push an error code.
+	 */
+	lea 1f(%rip), %rax
+	push %rax				/* Return RIP */
+	push $0					/* Error code, 0 for IRQ/NMI */
+
+	PUSH_AND_CLEAR_REGS clear_bp=0 unwind_hint=0
+	movq %rsp, %rdi				/* %rdi -> pt_regs */
+	call __fred_entry_from_kvm		/* Call the C entry point */
+	POP_REGS
+	ERETS
+1:
+	/*
+	 * Objtool doesn't understand what ERETS does, this hint tells it that
+	 * yes, we'll reach here and with what stack state. A save/restore pair
+	 * isn't strictly needed, but it's the simplest form.
+	 */
+	UNWIND_HINT_RESTORE
+	pop %rbp
+	RET
+
+SYM_FUNC_END(asm_fred_entry_from_kvm)
+EXPORT_SYMBOL_GPL(asm_fred_entry_from_kvm);
+#endif
diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index e80e3efbc057..3e33a4ab4624 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -242,3 +242,17 @@ __visible noinstr void fred_entry_from_kernel(struct pt_regs *regs)
 		return fred_bad_type(regs, error_code);
 	}
 }
+
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+__visible noinstr void __fred_entry_from_kvm(struct pt_regs *regs)
+{
+	switch (regs->fred_ss.type) {
+	case EVENT_TYPE_EXTINT:
+		return fred_extint(regs);
+	case EVENT_TYPE_NMI:
+		return fred_exc_nmi(regs);
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+#endif
diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 16a64ffecbf8..2fa9f34e5c95 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -9,6 +9,7 @@
 #include <linux/const.h>
 
 #include <asm/asm.h>
+#include <asm/trapnr.h>
 
 /*
  * FRED event return instruction opcodes for ERET{S,U}; supported in
@@ -62,12 +63,29 @@ static __always_inline unsigned long fred_event_data(struct pt_regs *regs)
 
 void asm_fred_entrypoint_user(void);
 void asm_fred_entrypoint_kernel(void);
+void asm_fred_entry_from_kvm(struct fred_ss);
 
 __visible void fred_entry_from_user(struct pt_regs *regs);
 __visible void fred_entry_from_kernel(struct pt_regs *regs);
+__visible void __fred_entry_from_kvm(struct pt_regs *regs);
+
+/* Can be called from noinstr code, thus __always_inline */
+static __always_inline void fred_entry_from_kvm(unsigned int type, unsigned int vector)
+{
+	struct fred_ss ss = {
+		.ss     =__KERNEL_DS,
+		.type   = type,
+		.vector = vector,
+		.nmi    = type == EVENT_TYPE_NMI,
+		.lm     = 1,
+	};
+
+	asm_fred_entry_from_kvm(ss);
+}
 
 #else /* CONFIG_X86_FRED */
 static __always_inline unsigned long fred_event_data(struct pt_regs *regs) { return 0; }
+static __always_inline void fred_entry_from_kvm(unsigned int type, unsigned int vector) { }
 #endif /* CONFIG_X86_FRED */
 #endif /* !__ASSEMBLY__ */
 
-- 
2.43.0


