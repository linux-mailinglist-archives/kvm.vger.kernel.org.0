Return-Path: <kvm+bounces-9896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 048518678FF
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:49:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 838701F26535
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56575137C3F;
	Mon, 26 Feb 2024 14:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cRfO21ku"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042AA1369B8;
	Mon, 26 Feb 2024 14:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958188; cv=none; b=S/G6GVlAyLN2+0JsAfwDQ5hFDuYBGHmERGAOL2Xvf6RHS/Tq8/bx4597zNgNiX6qN82AOkvYjheqPEfQifNILnbtfgGmWPiQftfvkDqTEFwPKNJnSXcuOUGvLo6Bd5wkDIac6C68XK6O/DuqFuBenFzTWJ88+xUO8EoeCCfAmNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958188; c=relaxed/simple;
	bh=FqG+PShZWy3cSlJS3qEDXedk0RFcNd6z6U1V+6nl3B8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n5+MwEZqRcLM4lxDZVboLkH4+VVz5KJ7PJBY1WE81iVxISNNZjMsOEwqvOCo5Vw6Lu5Lg2O4gEKL5N92fF6zrJJO8752O7gHNegmZVLQRUiihe57LczbPw1tKg86IvjmdQwCXCn8k9VAJ0cb6XXc5iEfgQr1ILx7bLfFQP9qRjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cRfO21ku; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dc1ff3ba1aso25326715ad.3;
        Mon, 26 Feb 2024 06:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958186; x=1709562986; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h/GP0KqLiQo98vwHDOjndhSbhcZ2rln4TVJt6Ie5g30=;
        b=cRfO21kuPaMtiH7S2C5gbeshHNiYpLy+BbUc1xYjM5vx23faOppFqYm//5BGiIjVIK
         uSMFGQqM8fb/NwzaCxkrTqChfGbh2pnQIi+pJwuBBboCCr+nzw33nXKo49VC3ZgeFa3K
         i0iAdDi9io+zJW9RShFT35yArr2WxzJW2/Dbki6+P2q59HSnk2xDbrACsLTrKqMNKlUa
         J6VNB22y4jjrovq6F0a5CeuG8Mu8y2TJvV3tmheMTzV21WdHCuumL8l/V3xxzSUvwpYE
         5OCjyfN99HUv5d/OAL2NrgIqfHR6Npboi8mbzNy1PgFBU4UMWVmkJoDF0CUmnkNWYevA
         uK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958186; x=1709562986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h/GP0KqLiQo98vwHDOjndhSbhcZ2rln4TVJt6Ie5g30=;
        b=MjSVIH5OUt2enxBW+kBtbGw6JsmPQAOvjc65z3LhP/XHxsCExXmnBHH6UEBKp8R/uX
         Vdrvz7dzxZzolwtQmO1F+tm4YLdfqQ35uJiyygiKnIsP1JQydeCNyo9miWbOZVOP3j3x
         ZPBGY8woAabG8r/SsZkGp3ZMkI6B4tb02fu7m5jZAH4FCqZKDeHholDtT5CbaL6eoQXJ
         D3B/PFz4gLfqvLrq7ciBS8bXvMizo2Lu4LHMAE3DnVdW8rzXybzZ1fQsx1X5m/B4NSVe
         HUQNNkR/0nOMYhFX2tD83Ymdd8vWLc1bhwaUlwJhZdBlOwqWGEfliMeBjR81kJwB/9rn
         uKTw==
X-Forwarded-Encrypted: i=1; AJvYcCXFfVkmAraO09A5WKS+6ZMEpzmZS82+7mazVi6BwKSWkQvoUVILU2aZcy043fas9MGURSZpinQGhdzB9aRalgJjuNd1
X-Gm-Message-State: AOJu0YwOro6pZeQxHzqhrzboxYG76WxYkE8dPOTmHZUpmUA8kn3073+t
	FgSIikdGibEEFfMupythdmAJWqLEzt8zL+gKBplKUcnAlLNfis5hcfrqD/kz
X-Google-Smtp-Source: AGHT+IEMuwRtiAJXeXANhaAHgTUUopEhhNurxT2IDkexHNjvTyx0eaYlmjpPJEMP+wZaJcr/GimM2A==
X-Received: by 2002:a17:902:ea12:b0:1dc:90c0:1e6a with SMTP id s18-20020a170902ea1200b001dc90c01e6amr5660164plg.45.1708958185760;
        Mon, 26 Feb 2024 06:36:25 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e20b00b001dc9422891esm2650104plb.30.2024.02.26.06.36.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:25 -0800 (PST)
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
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 33/73] KVM: x86/PVM: Handle VM-exit due to hardware exceptions
Date: Mon, 26 Feb 2024 22:35:50 +0800
Message-Id: <20240226143630.33643-34-jiangshanlai@gmail.com>
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

When the exceptions are of interest to the hypervisor for emulation or
debugging, they should be handled by the hypervisor first, for example,
handling #PF for shadow page table. If the exceptions are pure guest
exceptions, they should be reinjected into the guest directly. If the
exceptions belong to the host, they should already have been handled in
an atomic way before enabling interrupts.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 157 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 299305903005..c6fd01c19c3e 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -20,6 +20,7 @@
 
 #include "cpuid.h"
 #include "lapic.h"
+#include "mmu.h"
 #include "trace.h"
 #include "x86.h"
 #include "pvm.h"
@@ -1161,6 +1162,160 @@ static int handle_exit_syscall(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_exit_debug(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	struct kvm_run *kvm_run = pvm->vcpu.run;
+
+	if (pvm->vcpu.guest_debug &
+	    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) {
+		kvm_run->exit_reason = KVM_EXIT_DEBUG;
+		kvm_run->debug.arch.dr6 = pvm->exit_dr6 | DR6_FIXED_1 | DR6_RTM;
+		kvm_run->debug.arch.dr7 = vcpu->arch.guest_debug_dr7;
+		kvm_run->debug.arch.pc = kvm_rip_read(vcpu);
+		kvm_run->debug.arch.exception = DB_VECTOR;
+		return 0;
+	}
+
+	kvm_queue_exception_p(vcpu, DB_VECTOR, pvm->exit_dr6);
+	return 1;
+}
+
+/* check if the previous instruction is "int3" on receiving #BP */
+static bool is_bp_trap(struct kvm_vcpu *vcpu)
+{
+	u8 byte = 0;
+	unsigned long rip;
+	struct x86_exception exception;
+	int r;
+
+	rip = kvm_rip_read(vcpu) - 1;
+	r = kvm_read_guest_virt(vcpu, rip, &byte, 1, &exception);
+
+	/* Just assume it to be int3 when failed to fetch the instruction. */
+	if (r)
+		return true;
+
+	return byte == 0xcc;
+}
+
+static int handle_exit_breakpoint(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	struct kvm_run *kvm_run = pvm->vcpu.run;
+
+	/*
+	 * Breakpoint exception can be caused by int3 or int 3.  While "int3"
+	 * participates in guest debug, but "int 3" should not.
+	 */
+	if ((vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP) && is_bp_trap(vcpu)) {
+		kvm_rip_write(vcpu, kvm_rip_read(vcpu) - 1);
+		kvm_run->exit_reason = KVM_EXIT_DEBUG;
+		kvm_run->debug.arch.pc = kvm_rip_read(vcpu);
+		kvm_run->debug.arch.exception = BP_VECTOR;
+		return 0;
+	}
+
+	kvm_queue_exception(vcpu, BP_VECTOR);
+	return 1;
+}
+
+static int handle_exit_exception(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	struct kvm_run *kvm_run = vcpu->run;
+	u32 vector, error_code;
+	int err;
+
+	vector = pvm->exit_vector;
+	error_code = pvm->exit_error_code;
+
+	switch (vector) {
+	// #PF, #GP, #UD, #DB and #BP are guest exceptions or hypervisor
+	// interested exceptions for emulation or debugging.
+	case PF_VECTOR:
+		// Remove hardware generated PFERR_USER_MASK when in supervisor
+		// mode to reflect the real mode in PVM.
+		if (is_smod(pvm))
+			error_code &= ~PFERR_USER_MASK;
+
+		// If it is a PK fault, set pkru=0 and re-enter the guest silently.
+		// See the comment before pvm_load_guest_xsave_state().
+		if (cpu_feature_enabled(X86_FEATURE_PKU) && (error_code & PFERR_PK_MASK))
+			return 1;
+
+		return kvm_handle_page_fault(vcpu, error_code, pvm->exit_cr2,
+					     NULL, 0);
+	case GP_VECTOR:
+		err = kvm_emulate_instruction(vcpu, EMULTYPE_PVM_GP);
+		if (!err)
+			return 0;
+
+		if (vcpu->arch.halt_request) {
+			vcpu->arch.halt_request = 0;
+			return kvm_emulate_halt_noskip(vcpu);
+		}
+		return 1;
+	case UD_VECTOR:
+		if (!is_smod(pvm)) {
+			kvm_queue_exception(vcpu, UD_VECTOR);
+			return 1;
+		}
+		return handle_ud(vcpu);
+	case DB_VECTOR:
+		return handle_exit_debug(vcpu);
+	case BP_VECTOR:
+		return handle_exit_breakpoint(vcpu);
+
+	// #DE, #OF, #BR, #NM, #MF, #XM, #TS, #NP, #SS and #AC are pure guest
+	// exceptions.
+	case DE_VECTOR:
+	case OF_VECTOR:
+	case BR_VECTOR:
+	case NM_VECTOR:
+	case MF_VECTOR:
+	case XM_VECTOR:
+		kvm_queue_exception(vcpu, vector);
+		return 1;
+	case AC_VECTOR:
+	case TS_VECTOR:
+	case NP_VECTOR:
+	case SS_VECTOR:
+		kvm_queue_exception_e(vcpu, vector, error_code);
+		return 1;
+
+	// #NMI, #VE, #VC, #MC and #DF are exceptions that belong to host.
+	// They should have been handled in atomic way when vmexit.
+	case NMI_VECTOR:
+		// NMI is handled by pvm_vcpu_run_noinstr().
+		return 1;
+	case VE_VECTOR:
+		// TODO: tdx_handle_virt_exception(regs, &pvm->exit_ve); break;
+		goto unknown_exit_reason;
+	case X86_TRAP_VC:
+		// TODO: handle the second part for #VC.
+		goto unknown_exit_reason;
+	case MC_VECTOR:
+		// MC is handled by pvm_handle_exit_irqoff().
+		// TODO: split kvm_machine_check() to avoid irq-enabled or
+		// schedule code (thread dead) in pvm_handle_exit_irqoff().
+		return 1;
+	case DF_VECTOR:
+		// DF is handled when exiting and can't reach here.
+		pr_warn_once("host bug, can't reach here");
+		break;
+	default:
+unknown_exit_reason:
+		pr_warn_once("unknown exit_reason vector:%d, error_code:%x, rip:0x%lx\n",
+			      vector, pvm->exit_error_code, kvm_rip_read(vcpu));
+		kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
+		kvm_run->ex.exception = vector;
+		kvm_run->ex.error_code = error_code;
+		break;
+	}
+	return 0;
+}
+
 static int handle_exit_external_interrupt(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.irq_exits;
@@ -1187,6 +1342,8 @@ static int pvm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 	if (exit_reason == PVM_SYSCALL_VECTOR)
 		return handle_exit_syscall(vcpu);
+	else if (exit_reason >= 0 && exit_reason < FIRST_EXTERNAL_VECTOR)
+		return handle_exit_exception(vcpu);
 	else if (exit_reason == IA32_SYSCALL_VECTOR)
 		return do_pvm_event(vcpu, IA32_SYSCALL_VECTOR, false, 0);
 	else if (exit_reason >= FIRST_EXTERNAL_VECTOR && exit_reason < NR_VECTORS)
-- 
2.19.1.6.gb485710b


