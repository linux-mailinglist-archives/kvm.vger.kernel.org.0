Return-Path: <kvm+bounces-9867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6914F8678B6
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:37:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B2291C2A572
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E41412DD89;
	Mon, 26 Feb 2024 14:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i48fYwW9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4A060B87;
	Mon, 26 Feb 2024 14:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958089; cv=none; b=Pt1JXvcaUa6nAap340HrnBIRFZwHSkOciEq5Np7aVKgPDLq1Nwm1fnsNeABmhSsIYfvHhYvMb4iQfcf5dknNYUnsQ48c7yFHXfXHH2oJ370A+4QX3xweeZzqhpQ+mYhA7b93qg9Yy6w1RX+zo3gqFeanmh5FuUID5wbdKkBtqN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958089; c=relaxed/simple;
	bh=/GUkCZ302+GMyG/K8t3wfSAJoYB7n1waPF59X7S+x7w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YiZhdn6winhrvufzbFAOsrzXzveUXa/mmzIXkk1Vrqx0s3bYxtt68cG30KmYwJ0Ec5dKsiVUvLUgOpN4XCo+IJvRE1kfxP9ZK4PEU59ngBSDfz6JLbSLOvAa7lmwohKPS7IXH0/OQJd//2X9tTVyuO4jMH4SPtUBueHUdqHRhW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i48fYwW9; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e4f569f326so1154771b3a.2;
        Mon, 26 Feb 2024 06:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958086; x=1709562886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SUKCCkt8N5sdt+lxo7ukm1SyD24K8ST3i3kNBn9Onjw=;
        b=i48fYwW9SloPRb5AWx2hx4M04yj+qt8zvg15jthEwbz7kzEtOJVtF5TwuaFq5R2ohs
         KlyrKnSRfv7j8T+hdkmMxoijq5ueVczJruE1FDga+h/9pb41bFTPOku6kpnIW27jHPI1
         /SBzrMF8I2vn+9HEtkTf8UsDEOhbHAuGPZRw8D14kTqoiaGWmVwSkLFsXbde75m8cuIl
         tuCtASZiYsOv0N8ds1ePBCCC0IhtwGmQ8ngW0PCeCq8N0jBylJe+1W29LfyYfLYuv+4r
         XDHB9fkTHzD9MyVCFCbbZsX6GELLPyM6f4i6+HqJgI+bPzXKryxuUhElYhuYU2q38hTS
         RIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958086; x=1709562886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SUKCCkt8N5sdt+lxo7ukm1SyD24K8ST3i3kNBn9Onjw=;
        b=QxPHdUMTYcFauQanbt//pSVDMY4ESo4/Cc9oxLLxfKLtgJbDNyiw4ewTg0BytfteVq
         TshKIFFOBNokKHXHfrj/NtJ1p4XUc3Pj0rY8Ogk2Y0TG6lPrZ8XQ004Pl9ULMwgO4ZmX
         TX25m/8OvJdq2TpxU/1K2JRkD9CFDrw0zJnckx3Y1aMMvqeioCiNfAVSqoRQVYy/U+vT
         rzJECIeNdvwBR0zy0yj6q4CEo7MpjFz7av4QsGt1V2pJREDGGtYQvu2zM05C+4AZQOAS
         eAcA47QtGo39VRcv13fjBefnFo6dniKt9uMty77cKDT3oxYnThVEIVtganAOSe2KVHkV
         lnxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNLRF4mNKcZNOXfTyYaQDenD/JZtqJiILED982I8YIxlDj3HjUQ6IE6bW0xvTHyA4QD5qLYjWY62W30j3ZbozhFPz7
X-Gm-Message-State: AOJu0YxA0BzvpUtsU7Zf7v0zpmmNaWkRNKO0aV4BoEZjMQEsWPpdCqNk
	W1W2uRiApYvoGsfTOTaVAcYaOFhjZ4uKV8+M0iU7c9yJEsWKmofUnq36V1k1
X-Google-Smtp-Source: AGHT+IH2MIidXpHRalYfZ3USRmaUZKVWt4xTipOI996MatPcH53rbB/zEskXJ14qt9C5x+lbzBOx3g==
X-Received: by 2002:a05:6a00:1a88:b0:6e4:700d:6ac6 with SMTP id e8-20020a056a001a8800b006e4700d6ac6mr9293094pfv.8.1708958086510;
        Mon, 26 Feb 2024 06:34:46 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00071000b006e3809da4fdsm4015645pfl.83.2024.02.26.06.34.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:34:46 -0800 (PST)
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
	Brian Gerst <brgerst@gmail.com>
Subject: [RFC PATCH 04/73] x86/entry: Implement direct switching for the switcher
Date: Mon, 26 Feb 2024 22:35:21 +0800
Message-Id: <20240226143630.33643-5-jiangshanlai@gmail.com>
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

During VM running, all VM exits in the switcher will be forwarded to the
hypervisor and then returned to the switcher to re-enter the VM after
handling the VM exit. In some situations, the switcher can handle the VM
exit directly without involving the hypervisor. This is referred to as
direct switching, and it can reduce the overhead of guest/host state
switching. Currently, for simplicity, only the syscall event from user
mode and ERETU synthetic instruction are allowed for direct switching.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/entry/entry_64_switcher.S | 145 ++++++++++++++++++++++++++++-
 arch/x86/include/asm/ptrace.h      |   2 +
 arch/x86/include/asm/switcher.h    |  60 ++++++++++++
 arch/x86/kernel/asm-offsets_64.c   |  23 +++++
 4 files changed, 229 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry_64_switcher.S b/arch/x86/entry/entry_64_switcher.S
index 2b99a46421cc..6f166d15635c 100644
--- a/arch/x86/entry/entry_64_switcher.S
+++ b/arch/x86/entry/entry_64_switcher.S
@@ -75,7 +75,7 @@ SYM_FUNC_START(switcher_enter_guest)
 
 	/* Switch to guest GSBASE and return to guest */
 	swapgs
-	jmp	native_irq_return_iret
+	jmp	.L_switcher_return_to_guest
 
 SYM_INNER_LABEL(switcher_return_from_guest, SYM_L_GLOBAL)
 	/* switch back to host cr3 when still on sp0/ist stack */
@@ -99,6 +99,23 @@ SYM_INNER_LABEL(switcher_return_from_guest, SYM_L_GLOBAL)
 SYM_FUNC_END(switcher_enter_guest)
 EXPORT_SYMBOL_GPL(switcher_enter_guest)
 
+.macro canonical_rcx
+	/*
+	 * If width of "canonical tail" ever becomes variable, this will need
+	 * to be updated to remain correct on both old and new CPUs.
+	 *
+	 * Change top bits to match most significant bit (47th or 56th bit
+	 * depending on paging mode) in the address.
+	 */
+#ifdef CONFIG_X86_5LEVEL
+	ALTERNATIVE "shl $(64 - 48), %rcx; sar $(64 - 48), %rcx", \
+		    "shl $(64 - 57), %rcx; sar $(64 - 57), %rcx", X86_FEATURE_LA57
+#else
+	shl	$(64 - (__VIRTUAL_MASK_SHIFT+1)), %rcx
+	sar	$(64 - (__VIRTUAL_MASK_SHIFT+1)), %rcx
+#endif
+.endm
+
 SYM_CODE_START(entry_SYSCALL_64_switcher)
 	UNWIND_HINT_ENTRY
 	ENDBR
@@ -117,7 +134,133 @@ SYM_INNER_LABEL(entry_SYSCALL_64_switcher_safe_stack, SYM_L_GLOBAL)
 	pushq	%r11					/* pt_regs->flags */
 	pushq	$__USER_CS				/* pt_regs->cs */
 	pushq	%rcx					/* pt_regs->ip */
+	pushq	%rdi					/* put rdi on ORIG_RAX */
+
+	/* check if it can do direct switch from umod to smod */
+	testq	$SWITCH_FLAGS_NO_DS_TO_SMOD, TSS_extra(switch_flags)
+	jnz	.L_switcher_check_return_umod_instruction
+
+	/* Now it must be umod, start to do direct switch from umod to smod */
+	movq	TSS_extra(pvcs), %rdi
+	movl	%r11d, PVCS_eflags(%rdi)
+	movq	%rcx, PVCS_rip(%rdi)
+	movq	%rcx, PVCS_rcx(%rdi)
+	movq	%r11, PVCS_r11(%rdi)
+	movq	RSP-ORIG_RAX(%rsp), %rcx
+	movq	%rcx, PVCS_rsp(%rdi)
+
+	/* switch umod to smod (switch_flags & cr3) */
+	xorb	$SWITCH_FLAGS_MOD_TOGGLE, TSS_extra(switch_flags)
+	movq	TSS_extra(smod_cr3), %rcx
+	movq	%rcx, %cr3
+
+	/* load smod registers from TSS_extra to sp0 stack or %r11 */
+	movq	TSS_extra(smod_rsp), %rcx
+	movq	%rcx, RSP-ORIG_RAX(%rsp)
+	movq	TSS_extra(smod_entry), %rcx
+	movq	%rcx, RIP-ORIG_RAX(%rsp)
+	movq	TSS_extra(smod_gsbase), %r11
+
+	/* switch host gsbase to guest gsbase, TSS_extra can't be use afterward */
+	swapgs
+
+	/* save guest gsbase as user_gsbase and switch to smod_gsbase */
+	rdgsbase %rcx
+	movq	%rcx, PVCS_user_gsbase(%rdi)
+	wrgsbase %r11
+
+	/* restore umod rdi and smod rflags/r11, rip/rcx and rsp for sysretq */
+	popq	%rdi
+	movq	$SWITCH_ENTER_EFLAGS_FIXED, %r11
+	movq	RIP-RIP(%rsp), %rcx
+
+.L_switcher_sysretq:
+	UNWIND_HINT_IRET_REGS
+	/* now everything is ready for sysretq except for %rsp */
+	movq	RSP-RIP(%rsp), %rsp
+	/* No instruction can be added between seting the guest %rsp and doing sysretq */
+SYM_INNER_LABEL(entry_SYSRETQ_switcher_unsafe_stack, SYM_L_GLOBAL)
+	sysretq
+
+.L_switcher_check_return_umod_instruction:
+	UNWIND_HINT_IRET_REGS offset=8
+
+	/* check if it can do direct switch from smod to umod */
+	testq	$SWITCH_FLAGS_NO_DS_TO_UMOD, TSS_extra(switch_flags)
+	jnz	.L_switcher_return_to_hypervisor
+
+	/*
+	 * Now it must be smod, check if it is the return-umod instruction.
+	 * Switcher and the PVM specification defines a SYSCALL instrucion
+	 * at TSS_extra(retu_rip) - 2 in smod as the return-umod instruction.
+	 */
+	cmpq	%rcx, TSS_extra(retu_rip)
+	jne	.L_switcher_return_to_hypervisor
+
+	/* only handle for the most common cs/ss */
+	movq	TSS_extra(pvcs), %rdi
+	cmpl	$((__USER_DS << 16) | __USER_CS), PVCS_user_cs(%rdi)
+	jne	.L_switcher_return_to_hypervisor
+
+	/* Switcher and the PVM specification requires the smod RSP to be saved */
+	movq	RSP-ORIG_RAX(%rsp), %rcx
+	movq	%rcx, TSS_extra(smod_rsp)
+
+	/* switch smod to umod (switch_flags & cr3) */
+	xorb	$SWITCH_FLAGS_MOD_TOGGLE, TSS_extra(switch_flags)
+	movq	TSS_extra(umod_cr3), %rcx
+	movq	%rcx, %cr3
+
+	/* switch host gsbase to guest gsbase, TSS_extra can't be use afterward */
+	swapgs
+
+	/* write umod gsbase */
+	movq	PVCS_user_gsbase(%rdi), %rcx
+	canonical_rcx
+	wrgsbase %rcx
+
+	/* load sp, flags, ip to sp0 stack and cx, r11, rdi to registers */
+	movq	PVCS_rsp(%rdi), %rcx
+	movq	%rcx, RSP-ORIG_RAX(%rsp)
+	movl	PVCS_eflags(%rdi), %r11d
+	movq	%r11, EFLAGS-ORIG_RAX(%rsp)
+	movq	PVCS_rip(%rdi), %rcx
+	movq	%rcx, RIP-ORIG_RAX(%rsp)
+	movq	PVCS_rcx(%rdi), %rcx
+	movq	PVCS_r11(%rdi), %r11
+	popq	%rdi		// saved rdi (on ORIG_RAX)
+
+.L_switcher_return_to_guest:
+	/*
+	 * Now the RSP points to an IRET frame with guest state on the
+	 * top of the sp0 stack.  Check if it can do sysretq.
+	 */
+	UNWIND_HINT_IRET_REGS
+
+	andq	$SWITCH_ENTER_EFLAGS_ALLOWED, EFLAGS-RIP(%rsp)
+	orq	$SWITCH_ENTER_EFLAGS_FIXED, EFLAGS-RIP(%rsp)
+	testq	$(X86_EFLAGS_RF|X86_EFLAGS_TF), EFLAGS-RIP(%rsp)
+	jnz	native_irq_return_iret
+	cmpq	%r11, EFLAGS-RIP(%rsp)
+	jne	native_irq_return_iret
+
+	cmpq	%rcx, RIP-RIP(%rsp)
+	jne	native_irq_return_iret
+	/*
+	 * On Intel CPUs, SYSRET with non-canonical RCX/RIP will #GP
+	 * in kernel space.  This essentially lets the guest take over
+	 * the host, since guest controls RSP.
+	 */
+	canonical_rcx
+	cmpq	%rcx, RIP-RIP(%rsp)
+	je	.L_switcher_sysretq
+
+	/* RCX matches for RIP only before RCX is canonicalized, restore RCX and do IRET. */
+	movq	RIP-RIP(%rsp), %rcx
+	jmp	native_irq_return_iret
 
+.L_switcher_return_to_hypervisor:
+	popq	%rdi					/* saved rdi */
 	pushq	$0					/* pt_regs->orig_ax */
 	movl	$SWITCH_EXIT_REASONS_SYSCALL, 4(%rsp)
 
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 9eeeb5fdd387..322697877a2d 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -198,6 +198,8 @@ static __always_inline bool ip_within_syscall_gap(struct pt_regs *regs)
 	ret = ret || (regs->ip >= (unsigned long)entry_SYSCALL_64_switcher &&
 		      regs->ip <  (unsigned long)entry_SYSCALL_64_switcher_safe_stack);
 
+	ret = ret || (regs->ip == (unsigned long)entry_SYSRETQ_switcher_unsafe_stack);
+
 	return ret;
 }
 #endif
diff --git a/arch/x86/include/asm/switcher.h b/arch/x86/include/asm/switcher.h
index dbf1970ca62f..35a60f4044c4 100644
--- a/arch/x86/include/asm/switcher.h
+++ b/arch/x86/include/asm/switcher.h
@@ -8,6 +8,40 @@
 #define SWITCH_EXIT_REASONS_SYSCALL		1024
 #define SWITCH_EXIT_REASONS_FAILED_VMETNRY	1025
 
+/*
+ * SWITCH_FLAGS control the way how the switcher code works,
+ *	mostly dictate whether it should directly do the guest ring
+ *	switch or just go back to hypervisor.
+ *
+ * SMOD and UMOD
+ *	Current vcpu mode. Use two parity bits to simplify direct-switch
+ *	flags checking.
+ *
+ * NO_DS_CR3
+ *	Not to direct switch due to smod_cr3 or umod_cr3 not having been
+ *	prepared.
+ */
+#define SWITCH_FLAGS_SMOD			_BITULL(0)
+#define SWITCH_FLAGS_UMOD			_BITULL(1)
+#define SWITCH_FLAGS_NO_DS_CR3			_BITULL(2)
+
+#define SWITCH_FLAGS_MOD_TOGGLE			(SWITCH_FLAGS_SMOD | SWITCH_FLAGS_UMOD)
+
+/*
+ * Direct switching disabling bits are all the bits other than
+ * SWITCH_FLAGS_SMOD or SWITCH_FLAGS_UMOD. Bits 8-64 are defined by the driver
+ * using the switcher. Direct switching is enabled if all the disabling bits
+ * are cleared.
+ *
+ * SWITCH_FLAGS_NO_DS_TO_SMOD: not to direct switch to smod due to any
+ * disabling bit or smod bit being set.
+ *
+ * SWITCH_FLAGS_NO_DS_TO_UMOD: not to direct switch to umod due to any
+ * disabling bit or umod bit being set.
+ */
+#define SWITCH_FLAGS_NO_DS_TO_SMOD		(~SWITCH_FLAGS_UMOD)
+#define SWITCH_FLAGS_NO_DS_TO_UMOD		(~SWITCH_FLAGS_SMOD)
+
 /* Bits allowed to be set in the underlying eflags */
 #define SWITCH_ENTER_EFLAGS_ALLOWED	(X86_EFLAGS_FIXED | X86_EFLAGS_IF |\
 					 X86_EFLAGS_TF | X86_EFLAGS_RF |\
@@ -24,6 +58,7 @@
 #include <linux/cache.h>
 
 struct pt_regs;
+struct pvm_vcpu_struct;
 
 /*
  * Extra per CPU control structure lives in the struct tss_struct.
@@ -46,6 +81,31 @@ struct tss_extra {
 	unsigned long host_rsp;
 	/* Prepared guest CR3 to be loaded before VM enter. */
 	unsigned long enter_cr3;
+
+	/*
+	 * Direct switching flag indicates whether direct switching
+	 * is allowed.
+	 */
+	unsigned long switch_flags ____cacheline_aligned;
+	/*
+	 * Guest supervisor mode hardware CR3 for direct switching of guest
+	 * user mode syscall.
+	 */
+	unsigned long smod_cr3;
+	/*
+	 * Guest user mode hardware CR3 for direct switching of guest ERETU
+	 * synthetic instruction.
+	 */
+	unsigned long umod_cr3;
+	/*
+	 * The current PVCS for saving and restoring guest user mode context
+	 * in direct switching.
+	 */
+	struct pvm_vcpu_struct *pvcs;
+	unsigned long retu_rip;
+	unsigned long smod_entry;
+	unsigned long smod_gsbase;
+	unsigned long smod_rsp;
 } ____cacheline_aligned;
 
 extern struct pt_regs *switcher_enter_guest(void);
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 1485cbda6dc4..8230bd27f0b3 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -4,6 +4,7 @@
 #endif
 
 #include <asm/ia32.h>
+#include <asm/pvm_para.h>
 
 #if defined(CONFIG_KVM_GUEST)
 #include <asm/kvm_para.h>
@@ -65,6 +66,28 @@ int main(void)
 	ENTRY(host_cr3);
 	ENTRY(host_rsp);
 	ENTRY(enter_cr3);
+	ENTRY(switch_flags);
+	ENTRY(smod_cr3);
+	ENTRY(umod_cr3);
+	ENTRY(pvcs);
+	ENTRY(retu_rip);
+	ENTRY(smod_entry);
+	ENTRY(smod_gsbase);
+	ENTRY(smod_rsp);
+	BLANK();
+#undef ENTRY
+
+#define ENTRY(entry) OFFSET(PVCS_ ## entry, pvm_vcpu_struct, entry)
+	ENTRY(event_flags);
+	ENTRY(event_errcode);
+	ENTRY(user_cs);
+	ENTRY(user_ss);
+	ENTRY(user_gsbase);
+	ENTRY(rsp);
+	ENTRY(eflags);
+	ENTRY(rip);
+	ENTRY(rcx);
+	ENTRY(r11);
 	BLANK();
 #undef ENTRY
 
-- 
2.19.1.6.gb485710b


