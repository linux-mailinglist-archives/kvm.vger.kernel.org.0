Return-Path: <kvm+bounces-14094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5BB889EDAC
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04CAF1C216F3
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 08:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB0A41448EA;
	Wed, 10 Apr 2024 08:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fK3WARyR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97A614431E
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 08:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737897; cv=none; b=ksQqO2FLFMggs7tu4rwECllgSxHHazmmV8vQMIG1W0JgFIbqg9tResBm4FaCNynfFipDjilvHltN/d8rSoZmKCDLhtAw0yiWv5XOX0GLXMvgqvQUstKdS4aSgudINe6wE6oyyTJPIqrqwTsbuTJ6By4+mL/4BofRREsty0fcPUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737897; c=relaxed/simple;
	bh=MJ2amgtSwm20ugyZqCjsEgAnfyZd3gx1BXvTPXSiVfg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=loiiZvChQeVx1YePHGJL6GBvsW5HJTBnsnp5VXuwZcOzJ97n0HUdRkCRrAMFKoP11PsgtaFnW+hHbLPGvEMw/bvZrkhozFLz8C05NhiroB2xYQeMx0xIuVit0yyx9x1mKKjv0GnAMhlYA34nEl9omYn8ljz6iXWjTCwnT5eZnBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fK3WARyR; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a5200202c1bso153371766b.0
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 01:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737894; x=1713342694; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ko/ldX1/RJm34/W6o5zxcM2yrIA8CZLIGcy8oSLFE1o=;
        b=fK3WARyRDu7TMppxW5ltnjjX1WeiUlLNGGIiazO/RA10XKmfkOT7AnINjKkgogqMed
         Vx3zduo8qoNYz3VVlBOWpqCO1Dk/8OyUkCvbM3g1ccTkHUzsxZdAIUnHIqRDyXEtoyXx
         MddwWCJsC1v+q8zBq3kOtXgT9DBr5QROAPn7zZhnd20rAxqSw7WgmlqZvQeY9VUs1Cy+
         RrypHIUxkwKComuebtIT+Om4E65ofTFljxbQlAM904Xj+WR8FSlYds8jHlqWwOnZmkmr
         F7CD+41gt6W13qQ3Abjh9FsBTLfrxTD7x8TIZKYWMn23G3thU3CUbVmxQb3O8+WR/TI5
         EkNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737894; x=1713342694;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ko/ldX1/RJm34/W6o5zxcM2yrIA8CZLIGcy8oSLFE1o=;
        b=qSy4qS38yKY0vKGKfOo1u9O1NKQu/Wi9EPn9Ba5W9eAz5lLAdWN2sI4/X4VEuAPMUw
         Z5yA7lYddE85z9qWZVoW8ugWbsGJCoGS4VdhiBuNiRAEvghIScS4tRHhEDWXDpP21KuA
         OnSPBeLaM7fo1EZFjp5dScZMl4TKSvh/d6nteEOb4K5WBGneFh9SJR5DIjIJXaKQ6OYz
         zJCc8O/44JLbt8Eq4xUPjfdFU6Wh85ZkSFqnjoPjltetEnot6raPL3tC4tFK0dM7k7qC
         zxnt26DyYsEYbk54rb0OkOjjmiu5tqo8Pr6MqsvE7vvgBEVpsDh7+1lKTVxTwlWMbzpb
         6lzw==
X-Forwarded-Encrypted: i=1; AJvYcCXYWBktZ3rmVQCCQgVUcCVsna4LOldJU8n/WUalYpZ+j70RjJUCXMK/ifxtT0lktu3sAd1zzcJ6XJz5ZYqD2I2pBP+q
X-Gm-Message-State: AOJu0YzCz2Jd0SPE1tK9uBn6QzY0ofO8L3Y4oqxD37tI2Vmu3/stkUn2
	px7TOKgITLObnu1zANEIJQOe+PpdDHlFkfhEHGU43tZ0BiUCKpVz0mp953qaouKEZ+FRTI8mbK0
	ePg==
X-Google-Smtp-Source: AGHT+IF344zY9aJwSy1QipveS6rH/4iNUnhyO2rqBkRNHvzgRM8S3Vb6xHVKK57ErUTVz32k/JGZNw==
X-Received: by 2002:a17:906:5786:b0:a51:e1a1:d127 with SMTP id k6-20020a170906578600b00a51e1a1d127mr1552281ejq.26.1712737893551;
        Wed, 10 Apr 2024 01:31:33 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id h12-20020a17090634cc00b00a46f95f5849sm6634813ejb.106.2024.04.10.01.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:31:33 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:31:29 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 12/12] KVM: arm64: Improve CONFIG_CFI_CLANG error message
Message-ID: <ly2kzup6w6o4nzvjjfofmxchh5zrhkeb3paon3etkzjozpmwvb@fv4mv42pz6s7>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

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
has access to the saved CPU context i.e. iff CONFIG_NVHE_EL2_DEBUG=y,
which aligns with the behavior of CONFIG_PROTECTED_NVHE_STACKTRACE.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
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
 
+DECLARE_KVM_NVHE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
+
 typedef int (*exit_handle_fn)(struct kvm_vcpu *);
 
 static void kvm_handle_guest_serror(struct kvm_vcpu *vcpu, u64 esr)
@@ -383,11 +385,35 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
 
-static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
+static void kvm_nvhe_report_cfi_target(struct user_pt_regs *regs, u64 esr,
+				       u64 hyp_offset)
+{
+	u64 va_mask = GENMASK_ULL(vabits_actual - 1, 0);
+	u8 type_idx = FIELD_GET(CFI_BRK_IMM_TYPE, esr);
+	u8 target_idx = FIELD_GET(CFI_BRK_IMM_TARGET, esr);
+	u32 expected_type = (u32)regs->regs[type_idx];
+	u64 target_addr = (regs->regs[target_idx] & va_mask) + hyp_offset;
+
+	kvm_err(" (target: [<%016llx>] %ps, expected type: 0x%08x)\n",
+		target_addr, (void *)(target_addr + kaslr_offset()),
+		expected_type);
+}
+
+static void kvm_nvhe_report_cfi_failure(u64 panic_addr, u64 esr, u64 hyp_offset)
 {
+	struct user_pt_regs *regs = NULL;
+
 	kvm_err("nVHE hyp CFI failure at: [<%016llx>] %pB!\n", panic_addr,
 		(void *)(panic_addr + kaslr_offset()));
 
+	if (IS_ENABLED(CONFIG_NVHE_EL2_DEBUG) || !is_protected_kvm_enabled())
+		regs = &this_cpu_ptr_nvhe_sym(kvm_hyp_ctxt)->regs;
+
+	if (regs)
+		kvm_nvhe_report_cfi_target(regs, esr, hyp_offset);
+	else
+		kvm_err(" (no target information: !CONFIG_NVHE_EL2_DEBUG)\n");
+
 	if (IS_ENABLED(CONFIG_CFI_PERMISSIVE))
 		kvm_err(" (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n");
 }
@@ -423,7 +449,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
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
 
-SYM_INNER_LABEL(__hyp_restore_elr_and_panic, SYM_L_GLOBAL)
+SYM_INNER_LABEL(__hyp_restore_elr_save_context_and_panic, SYM_L_GLOBAL)
 	// x0-x29,lr: hyp regs
 
 	stp	x0, x1, [sp, #-16]!
@@ -92,6 +92,28 @@ SYM_INNER_LABEL(__hyp_restore_elr_and_panic, SYM_L_GLOBAL)
 	msr	elr_el2, x0
 	ldp	x0, x1, [sp], #16
 
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
 
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 7e65ef738ec9..d0d90d598338 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -130,7 +130,7 @@ SYM_CODE_END(\label)
 .endm
 
 	/* None of these should ever happen */
-	invalid_vector	el2t_sync_invalid
+	invalid_vector	el2t_sync_invalid, __hyp_save_context_and_panic
 	invalid_vector	el2t_irq_invalid
 	invalid_vector	el2t_fiq_invalid
 	invalid_vector	el2t_error_invalid
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 9387e3a0b680..f3d8fbc7a77b 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -753,7 +753,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __hyp_restore_elr_and_panic[];
+	extern char __hyp_restore_elr_save_context_and_panic[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 = read_sysreg(elr_el2);
@@ -776,7 +776,7 @@ static inline void __kvm_unexpected_el2_exception(void)
 
 	/* Trigger a panic after restoring the hyp context. */
 	this_cpu_ptr(&kvm_hyp_ctxt)->sys_regs[ELR_EL2] = elr_el2;
-	write_sysreg(__hyp_restore_elr_and_panic, elr_el2);
+	write_sysreg(__hyp_restore_elr_save_context_and_panic, elr_el2);
 }
 
 #endif /* __ARM64_KVM_HYP_SWITCH_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 0613b6e35137..ec3e4f5c28cc 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -213,7 +213,7 @@ SYM_FUNC_END(__host_hvc)
 .endm
 
 .macro host_el2_sync_vect
-	__host_el2_vect __hyp_panic
+	__host_el2_vect __hyp_save_context_and_panic
 .endm
 
 .macro invalid_host_el1_vect
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b3268933b093..17df57580c77 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -18,6 +18,7 @@
 
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
+#include <asm/esr.h>
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
@@ -308,7 +309,24 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
+static void __noreturn __hyp_call_panic_for_cfi(u64 elr, u64 esr)
+{
+	struct user_pt_regs *regs = &this_cpu_ptr(&kvm_hyp_ctxt)->regs;
+	u8 type_idx = FIELD_GET(CFI_BRK_IMM_TYPE, esr);
+	u8 target_idx = FIELD_GET(CFI_BRK_IMM_TARGET, esr);
+	u32 expected_type = (u32)regs->regs[type_idx];
+	u64 target = regs->regs[target_idx];
+
+	panic("VHE hyp CFI failure at: [<%016llx>] %pB (target: [<%016llx>] %ps, expected type: 0x%08x)\n"
+#ifdef CONFIG_CFI_PERMISSIVE
+	      " (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n"
+#endif
+	      ,
+	      elr, (void *)elr, target, (void *)target, expected_type);
+}
+NOKPROBE_SYMBOL(__hyp_call_panic_for_cfi);
+
+static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par, u64 esr)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
@@ -319,6 +337,9 @@ static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 	__deactivate_traps(vcpu);
 	sysreg_restore_host_state_vhe(host_ctxt);
 
+	if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr))
+		__hyp_call_panic_for_cfi(elr, esr);
+
 	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n",
 	      spsr, elr,
 	      read_sysreg_el2(SYS_ESR), read_sysreg_el2(SYS_FAR),
@@ -331,8 +352,9 @@ void __noreturn hyp_panic(void)
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg_par();
+	u64 esr = read_sysreg_el2(SYS_ESR);
 
-	__hyp_call_panic(spsr, elr, par);
+	__hyp_call_panic(spsr, elr, par, esr);
 }
 
 asmlinkage void kvm_unexpected_el2_exception(void)
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre

