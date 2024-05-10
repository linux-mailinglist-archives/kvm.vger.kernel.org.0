Return-Path: <kvm+bounces-17165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A05EE8C2363
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 13:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 144EA1F256AF
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 11:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938D6174EF1;
	Fri, 10 May 2024 11:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XaGHEiBj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F58C171E4B
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 11:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340443; cv=none; b=jWel/TngpdZT/1xvYdLhbqomKh5m0S5UAvx/+20ZNqLZc56xMAFumPg2N8n6lCBTbN2Tg29f4d6/NrjE7LUPxR5BS4CdRdkA/4rkw3UkdAbm7okcPig/72nY57b/Km/Pa3A6NKG12of45IMrxJnPR4vPRmi1LFyoaAsX18PGaZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340443; c=relaxed/simple;
	bh=JHJFWyJeQVH89FDkO+GfM1Lay/KIUWopPc58GA0ph10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DhoMz837/AbSZl/LnIbo2Cn4oOi4EYbC1Bf99npc94vsSha9F9hMJ0wnfIkECQY8OmKDU3XMQbOBhnNP5OR4C+hdKQRKyqEG3KrDTxXZMaf+N2MwbhUg5yX8q3cgiN+HXK6EezxkhsomnwSqjmp/JezftmsRduMP0yyU/NwJB0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XaGHEiBj; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a59a0d2280cso148854866b.1
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 04:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340440; x=1715945240; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IlOgeEx7Dj0f9uD0T276ThAzO+p8Gd1L0Dz8H/gEavQ=;
        b=XaGHEiBjGIjhM5gZiDh/OQmxy2s3zJj2YPNAWn6K8cEkBgxybE3htizU5wu3k+yUnS
         w4fczwX0HJB9fZyy+kuBOI3jXRRXhE6KbyhLHj3Nmibdmjr4CsLuIN9wtvJnnUIm6kR3
         uxZN7PFOjG0FKEdLtEyXE0dGoPllqVQvWXMpJNSobBHcSFrs5SI/tRm4Z+WOZzuEPG5i
         V4RCHpCWp5vBbYkeUTudp9DyUWIANDE/8gM6H6Hnq7Yi19Stoefs7uoAhudY0Tg7celu
         RolMLLbhINvTPJ97WR1GiVZmRvCuvH4p0dzYnMbBIZkFvNI7V1TE3HOmsN+eo5e1c4xi
         y1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340440; x=1715945240;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IlOgeEx7Dj0f9uD0T276ThAzO+p8Gd1L0Dz8H/gEavQ=;
        b=X4M0XaF2iyG4GWG+Uwok53cmEk+p1BOrZN93Ai2v5AhsGNbku0Qk+C1YmdCPwrMO4R
         /6EUim8G57m9MbthBkFGACXfHyvFrFxbyflWUfBE/hjHvHfL2zDM91ByW09IzLx+HftK
         8hk+dBJ7e1Z3w2tvWK7kJ/eE+XwcdTlP8xfnH6hdNfZuozPhSUPw2QTt40hzxgflKiSD
         dhnFrpMP6G34QH/hcpgkMxEW39vMt4liMZTmZJ7d1g9Nl4399A2nnXXr+8Aw0Xx/NrOG
         WxQ+TBrfW7Do8UV95UIV1JCF+iSvkJCLB0TljsuW1+sXvzaR6pJ2/pnRGIp5n/CknN16
         aCdw==
X-Forwarded-Encrypted: i=1; AJvYcCUzb5dVOkcggHdWxNNjA85HlqO9XOnkPjqqpz2V8/k5nZPrTtdMN9zYBbQ/DqLcwYXy0ojFrw3pD22zGzPWmC0Cb0VA
X-Gm-Message-State: AOJu0Yz5yYaSw30i40lphJuSoRyFFPK1nDxYLicy5IU4gX/q5ZUGewsu
	AGctM7X7Wt4BYQfdsDE6c2UMf2gCMqm9TRtnD6CT5f9hgZW4mRAJrHcZyaqwDU4Tb4UWQpIhkA=
	=
X-Google-Smtp-Source: AGHT+IGzC6wBegF/BY4InGWvNQC2wCX5XWro3nkGNqjvsssmipwEVTEODbeq170WB3/2uigSQJYtADatpQ==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:906:456:b0:a59:cfcb:4973 with SMTP id
 a640c23a62f3a-a5a2d553699mr225366b.3.1715340439853; Fri, 10 May 2024 04:27:19
 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:30 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-2-ptosi@google.com>
Subject: [PATCH v3 01/12] KVM: arm64: Fix clobbered ELR in sync abort/SError
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

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

Fixes: 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest conte=
xt")
Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kernel/asm-offsets.c         | 1 +
 arch/arm64/kvm/hyp/entry.S              | 9 +++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 5 +++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offset=
s.c
index 81496083c041..27de1dddb0ab 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -128,6 +128,7 @@ int main(void)
   DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
   DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
+  DEFINE(CPU_ELR_EL2,		offsetof(struct kvm_cpu_context, sys_regs[ELR_EL2])=
);
   DEFINE(CPU_RGSR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[RGSR_EL1=
]));
   DEFINE(CPU_GCR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[GCR_EL1])=
);
   DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIA=
KEYLO_EL1]));
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index f3aa7738b477..bcaaf1a11b4e 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,6 +83,15 @@ alternative_else_nop_endif
 	eret
 	sb
=20
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
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/i=
nclude/hyp/switch.h
index e3fcf8c4d5b4..19a7ca2c1277 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -753,7 +753,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vc=
pu, u64 *exit_code)
=20
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __guest_exit_panic[];
+	extern char __guest_exit_restore_elr_and_panic[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 =3D read_sysreg(elr_el2);
@@ -775,7 +775,8 @@ static inline void __kvm_unexpected_el2_exception(void)
 	}
=20
 	/* Trigger a panic after restoring the hyp context. */
-	write_sysreg(__guest_exit_panic, elr_el2);
+	this_cpu_ptr(&kvm_hyp_ctxt)->sys_regs[ELR_EL2] =3D elr_el2;
+	write_sysreg(__guest_exit_restore_elr_and_panic, elr_el2);
 }
=20
 #endif /* __ARM64_KVM_HYP_SWITCH_H__ */
--=20
2.45.0.118.g7fe29c98d7-goog


