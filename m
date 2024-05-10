Return-Path: <kvm+bounces-17175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC048C2377
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 13:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 790A2281288
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 11:32:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1198717A93A;
	Fri, 10 May 2024 11:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cOa1sh6+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42C6170859
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 11:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340469; cv=none; b=d0ncJzA5/2ieeTnDa2FkKabyIaDYH0l5n5FCYaEOH6N3n0NmSzO7Zg1xPPMzpzGUBPTWbSeo5VNW+p/C+Vaf1lLn2oAZT9V2x1s7XIrBXlIgZuyn37hsHUEqXHJinFtEz2X4SB3ZY8qvNrhz/VsQ3UKZ9QngC0I7TStqdga5hdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340469; c=relaxed/simple;
	bh=olch/zFkSndigLQVwr9bYRtHWZEBGl9YaT4pV77/LIY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ItvTUlxVnqdkoinbmPhGkXILS5/2lVkz5RRAFzqpZGvQ3azfySfeCxHB8TWbohEHpULxBxF4Dt8fx6M3sPmqGn+wbqArTu0vx1ig5zsAHrZDBj08lhYbbh1jfjBJqrCxtkYG2WAfcYw/twV9IbDrMzKs8GyC9HE9AY01+eE3uF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cOa1sh6+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6207c483342so31802267b3.1
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 04:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340466; x=1715945266; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5CCzdSxscfzeRlLJ5wL+3zQfVKF6xgrgjNCyKCDms4U=;
        b=cOa1sh6+6sdyfqZUEn6sthXgPCOTrVLww6xHQpTeHoXLsE/Ky5zSn+R/AXLgFLju0K
         VKMzd61JpnoQYxYcWA09vLTfzQPJHoUfSei5HQSXDAFZJincnNMjZmBJzuZ2WDZAU11Z
         HNuZxPrmhyPY3Lfon/Xs/knioUgb3CVwIxwqGrlBx1O9apLVD5v98a8QLhMsK/xLiMbs
         +/4CCkkjMCn4kKi0ReR5rd1Kmle+y260VZj1EnGWsatfTGbK6j1vd1VsVQIbA48MBETO
         Ttxfg1vq0s6QPYgJ8EJF9LcL60ucKYpJzdgBpOZ1Pcup7tCaVM55W9Y08h6I01A/yEcp
         7FHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340466; x=1715945266;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5CCzdSxscfzeRlLJ5wL+3zQfVKF6xgrgjNCyKCDms4U=;
        b=Y9/ghgP6arqTEG9ch+3lTcwUx1DVlsZHC0dmrl3ENfxOGkdXecBIGNpw6yITAv+Xuv
         TXKfwqOVvJ1SQjsMMVmIhdKQz7FABjwoaRbrNUaN3JBeTtQhJ6PUthcmLHT0bOK3TuO/
         CkrkEexfrd0HyukwuObaboe+74gigwlUM1xVdv27MmmEQtfySaX+Nf4M+SsqLG2Xm2bg
         SJ1UIWUxV3ckPGEOsnvJOaaM7R63zZ7aSJ4Nci2IBWIga6qThG8Uup5MeCkIpzPo+408
         dyRRo2Oo2LM0UpGBf2NddCYgNiSMVIbM2qkRRag5IQtfQaf5Rfpw+qQCAsTG2vtYvJdw
         UqJQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3i+E3cZPyj5/RXyMfj1nJzyo9ypni9D1qedxZnl6U/do0fN2YIleeoHPeEMbJaucoOnqh7PBupbxigmyeBKTErZZ1
X-Gm-Message-State: AOJu0YxqNCaG8PqHTZ0kao1x5v/AQbTf8QF1hre1AL5U1GYvjYOm30mK
	W1eHmEbm57Me5+btz0q05BCmxRIh7uCfcPPbI9qU0DQYD5/7BzNiRucpTtCvsd89uvhjGUniCA=
	=
X-Google-Smtp-Source: AGHT+IHdS3ei2ZFY3/jZi7UOWajuQFEcULFtMW4+dDg7tAnI+MMeD/3xdux6nZQkCMsm0kZ06aqSsHCV0w==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:690c:c9d:b0:618:8e4b:f49d with SMTP id
 00721157ae682-622aff868c9mr6454537b3.4.1715340466673; Fri, 10 May 2024
 04:27:46 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:41 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-13-ptosi@google.com>
Subject: [PATCH v3 12/12] KVM: arm64: Improve CONFIG_CFI_CLANG error message
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
index 0db23a6304ce..d76e41a07df1 100644
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
@@ -383,11 +385,35 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exc=
eption_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
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
 	kvm_err("nVHE hyp CFI failure at: [<%016llx>] %pB!\n", panic_addr,
 		(void *)(panic_addr + kaslr_offset()));
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
@@ -423,7 +449,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, =
u64 spsr,
 			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
 					(void *)(panic_addr + kaslr_offset()));
 	} else if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr)) {
-		kvm_nvhe_report_cfi_failure(panic_addr);
+		kvm_nvhe_report_cfi_failure(panic_addr, esr, hyp_offset);
 	} else {
 		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
 				(void *)(panic_addr + kaslr_offset()));
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 6a1ce9d21e5b..8838b453b9be 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,7 +83,7 @@ alternative_else_nop_endif
 	eret
 	sb
=20
-SYM_INNER_LABEL(__hyp_restore_elr_and_panic, SYM_L_GLOBAL)
+SYM_INNER_LABEL(__hyp_restore_elr_save_context_and_panic, SYM_L_GLOBAL)
 	// x0-x29,lr: hyp regs
=20
 	stp	x0, x1, [sp, #-16]!
@@ -92,6 +92,28 @@ SYM_INNER_LABEL(__hyp_restore_elr_and_panic, SYM_L_GLOBA=
L)
 	msr	elr_el2, x0
 	ldp	x0, x1, [sp], #16
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
 	// x0-x29,lr: vcpu regs
=20
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
index 9387e3a0b680..f3d8fbc7a77b 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -753,7 +753,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vc=
pu, u64 *exit_code)
=20
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __hyp_restore_elr_and_panic[];
+	extern char __hyp_restore_elr_save_context_and_panic[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 =3D read_sysreg(elr_el2);
@@ -776,7 +776,7 @@ static inline void __kvm_unexpected_el2_exception(void)
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
index 0613b6e35137..ec3e4f5c28cc 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -213,7 +213,7 @@ SYM_FUNC_END(__host_hvc)
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
index b3268933b093..17df57580c77 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -18,6 +18,7 @@
=20
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
+#include <asm/esr.h>
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
@@ -308,7 +309,24 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
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
@@ -319,6 +337,9 @@ static void __noreturn __hyp_call_panic(u64 spsr, u64 e=
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
@@ -331,8 +352,9 @@ void __noreturn hyp_panic(void)
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
2.45.0.118.g7fe29c98d7-goog


