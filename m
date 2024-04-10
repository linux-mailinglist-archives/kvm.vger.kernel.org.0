Return-Path: <kvm+bounces-14083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0982189ED93
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:28:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5FC8CB23084
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 08:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5420313D619;
	Wed, 10 Apr 2024 08:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t3yfHPkN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B146913D605
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 08:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737693; cv=none; b=pxyLqDsxKZo/cqBJZxa4KQ3+VzXmMdEW55J1uLqy4NlmgPle1WimiMt4Uipjjsazyf+54rtZR9dNFHTZR1Z/PMy1nrd7/737ktLb79f2tgMJ/HyXw35ZFmubR0BRnYmq1jpuxiX70VRjd+KENRviyu+EJGk/joQSIZGidD8I2OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737693; c=relaxed/simple;
	bh=loO222umeudNN/3VRDuIKBD8h6ayrjYQtdXvLf/9SQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hpm6hBZ/NBmFistgVbKaW/t3ze0MfAbIztvYvuG+E3/ZBc3Z/dx8DOeTNOD9yqu9u5kV6fSr954LO2MVPSMqGFijkPp5grQqYNjnjzKx5898PmPeG8S5kiUilPLfUK6TnIbbuac0CCl/CQS9OsWz2lECemmIRtaiZJdURCRl7CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t3yfHPkN; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d700beb60bso104763261fa.1
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 01:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737690; x=1713342490; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qY+POk7z4HcyMMlZuNM5o7DMNVtuiYxieApfPnvv9HE=;
        b=t3yfHPkNmqDcRqyZAcdDOe3ajh1HexXyVR8bSm2idQejix23qvqzBL5E+sTVc1Nllo
         iOf2EyIBpQ1IIh2Vh7/cydahZP2BklGv2dHOMEmP9XPHi5N6K3GZqXXn1ZFTNIFKbEzQ
         hzv686tvWPyUzuF07nk8ifh38hBBwWhHCyXzWP+ND+17vHRL4cz4cMPoxnv4jOfhPWuM
         gYu+FMTUjWXGA4YFQmjGR0Qc5+UbVm0afK2Bvy6TgwmC+3R8qmYgKyliTqOiVlvqJ1xJ
         Ifv4veBuA0cSEor2xd3unkefdfa9yWOmibNtlJwuBV7YqT3jbTg0lCIKdv6B5HTk4c4W
         vxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737690; x=1713342490;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qY+POk7z4HcyMMlZuNM5o7DMNVtuiYxieApfPnvv9HE=;
        b=CdBMkLAB+mUm675CP4APMzOROscQOREqNJH1G2KdC+vFnmHgvA/jLSx4U7Lvvn/pjJ
         i+50IKu8jJS0DxOVDeQVVGDGsnXpUvNTLSWE960bJ/XKsY6pHVsjIxpXRAvMFNlHRcTy
         uArh/wX7DBTuv5uRLHcHgGjy3smmASpa38FMssaLTPb0tCB8sazZCxszazjWXrjPVYVZ
         dE6TdhUCwZRGgysXYkWoEuyxLSUojae6jGTHgacRMqqoSDoVR+Tjd7VfpGk+y0QaGCnI
         PmSOJJutCJ/rdG9cN4osGwGo8GIBj2pJPYKl6YCTmGbcivIREZiYAZFzeWxSWZGE7/1k
         2yFg==
X-Forwarded-Encrypted: i=1; AJvYcCWfZ3nuDfFpZ+CYvBhZjG9NOaTcvXIThuXmZOjRNrBYiF98YkHCXecg3zeKVNIOcZOZWh9tPRuTjLWBkGFfA8kHZANq
X-Gm-Message-State: AOJu0YyH5YZbBoUUa5ihk2wcwVkculx/KyQvzjgMr/vOnzuqDhojA+Xl
	BmoqoUGvNwmWUJmAbLfo5BraYXzYRJPqPtnMRsGynK9LDMubMBwHIJCpTWHTag==
X-Google-Smtp-Source: AGHT+IEL5qT3PXK3v0HpJZ+zPd2REaRDBNASA0+bLbNO3hFsj9CwSLwbfI4Q9HqWFPT0ZHUDjdBQXg==
X-Received: by 2002:a05:651c:2c1:b0:2d8:2d0a:7b9b with SMTP id f1-20020a05651c02c100b002d82d0a7b9bmr1863181ljo.14.1712737689629;
        Wed, 10 Apr 2024 01:28:09 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id dr2-20020a170907720200b00a4ea1fbb323sm6656464ejc.98.2024.04.10.01.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:28:09 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:28:05 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 01/12] KVM: arm64: Fix clobbered ELR in sync abort/SError
Message-ID: <iyww6yls3pqijoabrtgg5fq6p2a5pkv27cgesu7ffldlf3ooif@qxl5vpvdokfb>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

When the hypervisor receives a SError or synchronous exception (EL2h)
while running with the __kvm_hyp_vector and if ELR_EL2 doesn't point to
an extable entry, it panics indirectly by overwriting ELR with the
address of a panic handler in order for the asm routine it returns to to
ERET into the handler.

However, this clobbers ELR_EL2 for the handler itself. As a result,
hyp_panic(), when retrieving what it believes to be the PC where the
exception happened, actually ends up reading the address of the panic
handler that called it! This results in an erroneous and confusing panic
message where the source of any synchronous exception (e.g. BUG() or
kCFI) appears to be __guest_exit_panic, making it hard to locate the
actual BRK instruction.

Therefore, store the original ELR_EL2 in the per-CPU kvm_hyp_ctxt and
point the sysreg to a routine that first restores it to its previous
value before running __guest_exit_panic.

Fixes: 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest context")
Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kernel/asm-offsets.c         | 1 +
 arch/arm64/kvm/hyp/entry.S              | 9 +++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 5 +++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 81496083c041..27de1dddb0ab 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -128,6 +128,7 @@ int main(void)
   DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
   DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
+  DEFINE(CPU_ELR_EL2,		offsetof(struct kvm_cpu_context, sys_regs[ELR_EL2]));
   DEFINE(CPU_RGSR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[RGSR_EL1]));
   DEFINE(CPU_GCR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[GCR_EL1]));
   DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index f3aa7738b477..bcaaf1a11b4e 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,6 +83,15 @@ alternative_else_nop_endif
 	eret
 	sb
 
+SYM_INNER_LABEL(__guest_exit_restore_elr_and_panic, SYM_L_GLOBAL)
+	// x0-x29,lr: hyp regs
+
+	stp	x0, x1, [sp, #-16]!
+	adr_this_cpu x0, kvm_hyp_ctxt, x1
+	ldr	x0, [x0, #CPU_ELR_EL2]
+	msr	elr_el2, x0
+	ldp	x0, x1, [sp], #16
+
 SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	// x2-x29,lr: vcpu regs
 	// vcpu x0-x1 on the stack
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e3fcf8c4d5b4..19a7ca2c1277 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -753,7 +753,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __guest_exit_panic[];
+	extern char __guest_exit_restore_elr_and_panic[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 = read_sysreg(elr_el2);
@@ -775,7 +775,8 @@ static inline void __kvm_unexpected_el2_exception(void)
 	}
 
 	/* Trigger a panic after restoring the hyp context. */
-	write_sysreg(__guest_exit_panic, elr_el2);
+	this_cpu_ptr(&kvm_hyp_ctxt)->sys_regs[ELR_EL2] = elr_el2;
+	write_sysreg(__guest_exit_restore_elr_and_panic, elr_el2);
 }
 
 #endif /* __ARM64_KVM_HYP_SWITCH_H__ */
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre

