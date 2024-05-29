Return-Path: <kvm+bounces-18294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 329598D361D
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54CFA1C23B99
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BE2B181CE1;
	Wed, 29 May 2024 12:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mW69H95v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94321181BBF
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984898; cv=none; b=LAxi3/GJd8Cd62tdLUNG8i/29f+ebilrDboFofitvy+c91QEt54ThdxWQ5nQkM3AKeRbeQ1S7Z2VcERPD6rPRPSfBIRPBe4NMymY8y82CbZh6iXujz1QjtIKSQ+fLvkDtc/hmK0dMLps967pSwd5cEMIgdFNaeSfgGa9FAvWopw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984898; c=relaxed/simple;
	bh=d7ll60CcSbiQvQOKCWGY1hz1EabEJsXYqy8qzz9ADYs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rl4YPsRtBxR5oH7UHl8auffDS6UtdlVLg0Ajv09DmFzLxzDRjiY6PEJWieTA9DXvzlvqHqHqOdjgWJnOn0130bZ+baLPvl93wIZW1HNfy4mXNTIp7jJm58Fo1CFpMUEMB0T+DLeJOTFmj3WaTJ5tV59c8V8xKgcCbi7hm+Eh+dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mW69H95v; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a635b551919so57826566b.2
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984895; x=1717589695; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=20VEPEn3Gb7BPD8Z30RwNAM2J68OYkR1rMftiYbdXdo=;
        b=mW69H95vs0wZz/mmOdEJKBpnPnSQw3XZmr0Fw7AbHwplzVE0TBHaskjRYIuhPT0OTW
         l9s7dsQRzfUDISSON1srrehF+FrqqBVXd7+U37zX4n4hPc7ZVxsgITQbB1vmVpI54fcR
         YptWSZJzFepUwyt74d5AU8P8aJilr3NsvNRaS7a7GOqd2a2dwjbb93EmNmweq3+Wv+K0
         Zo2xVABWvyBqm2Je8lOt14+vaoNU7EDVq2DcM6VndKF4nPyylZUipXv6hq0irdnffHfH
         Jal1AfFeTe+BXU+VeIWrfHiYl4oyQqTKMSNgfY10kvwYmE0C5Z4sMuwUMj2KUGkVrqm8
         TnGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984895; x=1717589695;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=20VEPEn3Gb7BPD8Z30RwNAM2J68OYkR1rMftiYbdXdo=;
        b=Gx0DN8gIK6zD52mjN5Ee7TK3vxCEgUfUGvdqrZiTqQeW5B2pxq3LxOFWvyZL7v/zCl
         bKjdkGiEgNHo9rt1zi9Vcvi5fVGbi6S2nEnGuhs2faHuqYnTONVrc446DH0Pc93cWPPE
         h2CkNsAX+wsA3LESV74mNkknpU59AhIKZj8I2t9cLRlVL0HAMYfCgXXoWVb7K9SKrSZQ
         12MMPRGDJsDqTyVowYMzchjv27kP89ooFagSKwf6qTRIGr6zzH3LZYdq8/A6KvDbw+ZI
         8aDK6tj0NS6HXdtfml7LqCHBmC63fVFSaKEO4GXfa6a4+z+l/OvwM92mNIKRSD+VTYMa
         fnuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhRRI9t/YD4Bb5cBsB7/vI4lFy0KcSTh9xKDIo3UpanSubpZR2GEjk4clw8hgEhgeeKCZBBhzJxB4aANyC98w93Gol
X-Gm-Message-State: AOJu0YwxSJOXhZitpO4HKLCwGjzl7V0mESPs5Bts+PwCSsV/L69qS5Pq
	oVFaDA7nHwfibc18anFO0hqBOgAHYD3Ryg3/+045oYNWV/las82Cjr0ClkVNn+YnBMs6s62yWQ=
	=
X-Google-Smtp-Source: AGHT+IHG1MR1oKr0DJdz40/0WuzMnmz17jEaYp2Xsp5D6m+QC6YtrLkmBnRMnvH0qBf1kHCVYvlptcFOhA==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:906:5842:b0:a59:aa99:694c with SMTP id
 a640c23a62f3a-a62649db3c6mr1603366b.8.1716984895098; Wed, 29 May 2024
 05:14:55 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:17 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-12-ptosi@google.com>
Subject: [PATCH v4 11/13] KVM: arm64: Improve CONFIG_CFI_CLANG error message
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

For kCFI, the compiler encodes in the immediate of the BRK (which the
CPU places in ESR_ELx) the indices of the two registers it used to hold
(resp.) the function pointer and expected type. Therefore, the kCFI
handler must be able to parse the contents of the register file at the
point where the exception was triggered.

To achieve this, introduce a new hypervisor panic path that first stores
the CPU context in the per-CPU kvm_hyp_ctxt before calling (directly or
indirectly) hyp_panic() and execute it from all EL2 synchronous
exception handlers i.e.

- call it directly in host_el2_sync_vect (__kvm_hyp_host_vector, EL2t&h)
- call it directly in el2t_sync_invalid (__kvm_hyp_vector, EL2t)
- set ELR_EL2 to it in el2_sync (__kvm_hyp_vector, EL2h), which ERETs

Teach hyp_panic() to decode the kCFI ESR and extract the target and type
from the saved CPU context. In VHE, use that information to panic() with
a specialized error message. In nVHE, only report it if the host (EL1)
has access to the saved CPU context i.e. iff CONFIG_NVHE_EL2_DEBUG=3Dy,
which aligns with the behavior of CONFIG_PROTECTED_NVHE_STACKTRACE.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/handle_exit.c            | 30 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/entry.S              | 24 +++++++++++++++++++-
 arch/arm64/kvm/hyp/hyp-entry.S          |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/host.S          |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 26 +++++++++++++++++++--
 6 files changed, 79 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 69b08ac7322d..2fac3be3db00 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -26,6 +26,8 @@
 #define CREATE_TRACE_POINTS
 #include "trace_handle_exit.h"
=20
+DECLARE_KVM_NVHE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
+
 typedef int (*exit_handle_fn)(struct kvm_vcpu *);
=20
 static void kvm_handle_guest_serror(struct kvm_vcpu *vcpu, u64 esr)
@@ -417,10 +419,34 @@ static void print_nvhe_hyp_panic(const char *name, u6=
4 panic_addr)
 		(void *)(panic_addr + kaslr_offset()));
 }
=20
-static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
+static void kvm_nvhe_report_cfi_target(struct user_pt_regs *regs, u64 esr,
+				       u64 hyp_offset)
+{
+	u64 va_mask =3D GENMASK_ULL(vabits_actual - 1, 0);
+	u8 type_idx =3D FIELD_GET(CFI_BRK_IMM_TYPE, esr);
+	u8 target_idx =3D FIELD_GET(CFI_BRK_IMM_TARGET, esr);
+	u32 expected_type =3D (u32)regs->regs[type_idx];
+	u64 target_addr =3D (regs->regs[target_idx] & va_mask) + hyp_offset;
+
+	kvm_err(" (target: [<%016llx>] %ps, expected type: 0x%08x)\n",
+		target_addr, (void *)(target_addr + kaslr_offset()),
+		expected_type);
+}
+
+static void kvm_nvhe_report_cfi_failure(u64 panic_addr, u64 esr, u64 hyp_o=
ffset)
 {
+	struct user_pt_regs *regs =3D NULL;
+
 	print_nvhe_hyp_panic("CFI failure", panic_addr);
=20
+	if (IS_ENABLED(CONFIG_NVHE_EL2_DEBUG) || !is_protected_kvm_enabled())
+		regs =3D &this_cpu_ptr_nvhe_sym(kvm_hyp_ctxt)->regs;
+
+	if (regs)
+		kvm_nvhe_report_cfi_target(regs, esr, hyp_offset);
+	else
+		kvm_err(" (no target information: !CONFIG_NVHE_EL2_DEBUG)\n");
+
 	if (IS_ENABLED(CONFIG_CFI_PERMISSIVE))
 		kvm_err(" (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n");
 }
@@ -455,7 +481,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, =
u64 spsr,
 		else
 			print_nvhe_hyp_panic("BUG", panic_addr);
 	} else if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr)) {
-		kvm_nvhe_report_cfi_failure(panic_addr);
+		kvm_nvhe_report_cfi_failure(panic_addr, esr, hyp_offset);
 	} else {
 		print_nvhe_hyp_panic("panic", panic_addr);
 	}
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 343851c17373..8965dbc75972 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,7 +83,7 @@ alternative_else_nop_endif
 	eret
 	sb
=20
-SYM_INNER_LABEL(__hyp_restore_elr_and_panic, SYM_L_GLOBAL)
+SYM_INNER_LABEL(__hyp_restore_elr_save_context_and_panic, SYM_L_GLOBAL)
 	// x2-x29,lr: vcpu regs
 	// vcpu x0-x1 on the stack
=20
@@ -91,6 +91,28 @@ SYM_INNER_LABEL(__hyp_restore_elr_and_panic, SYM_L_GLOBA=
L)
 	ldr	x0, [x0, #CPU_ELR_EL2]
 	msr	elr_el2, x0
=20
+SYM_INNER_LABEL(__hyp_save_context_and_panic, SYM_L_GLOBAL)
+	// x0-x29,lr: hyp regs
+
+	stp	x0, x1, [sp, #-16]!
+
+	adr_this_cpu x0, kvm_hyp_ctxt, x1
+
+	stp	x2, x3,   [x0, #CPU_XREG_OFFSET(2)]
+
+	ldp	x2, x3, [sp], #16
+
+	stp	x2, x3,   [x0, #CPU_XREG_OFFSET(0)]
+	stp	x4, x5,   [x0, #CPU_XREG_OFFSET(4)]
+	stp	x6, x7,   [x0, #CPU_XREG_OFFSET(6)]
+	stp	x8, x9,   [x0, #CPU_XREG_OFFSET(8)]
+	stp	x10, x11, [x0, #CPU_XREG_OFFSET(10)]
+	stp	x12, x13, [x0, #CPU_XREG_OFFSET(12)]
+	stp	x14, x15, [x0, #CPU_XREG_OFFSET(14)]
+	stp	x16, x17, [x0, #CPU_XREG_OFFSET(16)]
+
+	save_callee_saved_regs x0
+
 SYM_INNER_LABEL(__hyp_panic, SYM_L_GLOBAL)
 	// x2-x29,lr: vcpu regs
 	// vcpu x0-x1 on the stack
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.=
S
index 7e65ef738ec9..d0d90d598338 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -130,7 +130,7 @@ SYM_CODE_END(\label)
 .endm
=20
 	/* None of these should ever happen */
-	invalid_vector	el2t_sync_invalid
+	invalid_vector	el2t_sync_invalid, __hyp_save_context_and_panic
 	invalid_vector	el2t_irq_invalid
 	invalid_vector	el2t_fiq_invalid
 	invalid_vector	el2t_error_invalid
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/i=
nclude/hyp/switch.h
index d9931abf14c2..77783dbc1833 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -689,7 +689,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vc=
pu, u64 *exit_code)
=20
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __hyp_restore_elr_and_panic[];
+	extern char __hyp_restore_elr_save_context_and_panic[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 =3D read_sysreg(elr_el2);
@@ -712,7 +712,7 @@ static inline void __kvm_unexpected_el2_exception(void)
=20
 	/* Trigger a panic after restoring the hyp context. */
 	this_cpu_ptr(&kvm_hyp_ctxt)->sys_regs[ELR_EL2] =3D elr_el2;
-	write_sysreg(__hyp_restore_elr_and_panic, elr_el2);
+	write_sysreg(__hyp_restore_elr_save_context_and_panic, elr_el2);
 }
=20
 #endif /* __ARM64_KVM_HYP_SWITCH_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.=
S
index a7db40a51e4a..9343160f5357 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -214,7 +214,7 @@ SYM_FUNC_END(__host_hvc)
 .endm
=20
 .macro host_el2_sync_vect
-	__host_el2_vect __hyp_panic
+	__host_el2_vect __hyp_save_context_and_panic
 .endm
=20
 .macro invalid_host_el1_vect
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switc=
h.c
index 0550b9f6317f..6c64783c3e00 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -17,6 +17,7 @@
=20
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
+#include <asm/esr.h>
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
@@ -384,7 +385,24 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
=20
-static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
+static void __noreturn __hyp_call_panic_for_cfi(u64 elr, u64 esr)
+{
+	struct user_pt_regs *regs =3D &this_cpu_ptr(&kvm_hyp_ctxt)->regs;
+	u8 type_idx =3D FIELD_GET(CFI_BRK_IMM_TYPE, esr);
+	u8 target_idx =3D FIELD_GET(CFI_BRK_IMM_TARGET, esr);
+	u32 expected_type =3D (u32)regs->regs[type_idx];
+	u64 target =3D regs->regs[target_idx];
+
+	panic("VHE hyp CFI failure at: [<%016llx>] %pB (target: [<%016llx>] %ps, =
expected type: 0x%08x)\n"
+#ifdef CONFIG_CFI_PERMISSIVE
+	      " (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n"
+#endif
+	      ,
+	      elr, (void *)elr, target, (void *)target, expected_type);
+}
+NOKPROBE_SYMBOL(__hyp_call_panic_for_cfi);
+
+static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par, u64 es=
r)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
@@ -395,6 +413,9 @@ static void __noreturn __hyp_call_panic(u64 spsr, u64 e=
lr, u64 par)
 	__deactivate_traps(vcpu);
 	sysreg_restore_host_state_vhe(host_ctxt);
=20
+	if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr))
+		__hyp_call_panic_for_cfi(elr, esr);
+
 	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%01=
6llx PAR:%016llx\nVCPU:%p\n",
 	      spsr, elr,
 	      read_sysreg_el2(SYS_ESR), read_sysreg_el2(SYS_FAR),
@@ -407,8 +428,9 @@ void __noreturn hyp_panic(void)
 	u64 spsr =3D read_sysreg_el2(SYS_SPSR);
 	u64 elr =3D read_sysreg_el2(SYS_ELR);
 	u64 par =3D read_sysreg_par();
+	u64 esr =3D read_sysreg_el2(SYS_ESR);
=20
-	__hyp_call_panic(spsr, elr, par);
+	__hyp_call_panic(spsr, elr, par, esr);
 }
=20
 asmlinkage void kvm_unexpected_el2_exception(void)
--=20
2.45.1.288.g0e0cd299f1-goog


