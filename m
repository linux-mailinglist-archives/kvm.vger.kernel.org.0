Return-Path: <kvm+bounces-19155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 791EF901B48
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 08:33:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC6321F220ED
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 06:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09D11CD24;
	Mon, 10 Jun 2024 06:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EY5l9LF6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3F6628
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 06:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001186; cv=none; b=cI88cP2FEaMS53pD4YmgBCLSYO2sRqXQ8HiDSI8OXPo0P22iaaFDanw3KDnnt0fU81OkEzI8UvrGH95g0TXeuj94QyZNFtcOJ3rYZ+IHa0yZrk/kjaMLioZp5DFGwGNJVstR0iGJ5o5yb9n1bSJd4Trs6TX2gvvbAHaxgqNwMmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001186; c=relaxed/simple;
	bh=fRjCyI9bRufIUMeN4x96BlXHMWr+J+M8VHu0nXbseqM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HVb6LkHb5Ujnm4Dsn2x0yzKlEGOrZCkYxXEOo7z53bix8oKpPlZdX7U2sIkNFRBQz9vQnMM9Wzgr6ebYKgHLD1pfVnvAnPSMpmQrjvadZzdI2oWliyZmxwTEwnpe7AFc+NzVhRJl+NyykKs8jOcJY5sdmQL9cUbp9doMMyRaSsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EY5l9LF6; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-57c8b34a26eso139819a12.2
        for <kvm@vger.kernel.org>; Sun, 09 Jun 2024 23:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001183; x=1718605983; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8wJ+K/s8pldv3mPcUFi7Dy0d1N3gzIgovkmOrPee3kY=;
        b=EY5l9LF6mQkbNhN5OBfqFkZLb3HQb8plywNWRCPaXIim0Bh6aXP0iTr3GhNOy34bsX
         63vtxczgVW9KYRsqGgMJ3E1TEKS7Nw0wyee6PTlrPH+c/cJonJhHi+IsefnwWOR6MxPs
         +Ljgl4pfmALnM1C/D4xGH92yP3GS14YMTYSh4wgtM7l66t0R2IExorGKJbynYcuIEtaT
         B5PouHUvi6euFG3j9lgIUO7VViXS5Vy/A38EHXrxHbp9hrMP6Tu19++jCgZABtMx7+A3
         Vv2Fi7ixujrzALez+TvAQHyNUmBkzm8SMv+vHvayo+gg2KVmBYlWsefqqRsWDSKH7aZ/
         +ROQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001183; x=1718605983;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8wJ+K/s8pldv3mPcUFi7Dy0d1N3gzIgovkmOrPee3kY=;
        b=B12Dr6vocEL+rdA1ZaJbuUgw33BQYJuMeBKRU4Dcx7fYz0X1vf5lu9KXsff2OrlSMG
         EaPkP5fZ4lciBQLyzghIiJO45zv1rYLsBhDfjk+1TOLcTk8s4xLgm8yWShcV4sZetJU8
         ojQ0Z+ldZRmBhI0u3h/Q4+BFJswjqQuaeDDI3cVqXuIQQ5zwl7qZ/Ap6tJ4R0R/dHotn
         oeQQ2xPXng+ygbdz+72ge0h2p0HBFANZEHY2BsWZZhkHCJKtKay12/rcB+tgSASWNUt/
         MXErHmX5kuvMhdoeDNHEeNqDgz5P1aS66cy1aM4o21NjVMSRKpnRQQNVHYqMnbKZzTM1
         JEzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVCWMzA5SDa6OkSjE3kXC+wHSONV87mF1EJrtQ3zkirmcPHlvrM/TjmuCtUvsZ3IXzEMVO8jle6B6tPFDza2IcgTmo
X-Gm-Message-State: AOJu0YxghjoPaHPQdImLtokn5P/vG/suZw+VOFGrkLMevkK/XSsuq6Rz
	lv5RGi5DhvbSeD1Kv04atWPcu1gagmxKJBX1H7VhGZ9vtNFfu+RBlP2GhirRwm13s75JdxYIrQ=
	=
X-Google-Smtp-Source: AGHT+IEt+XJnlwohw8pCOFCo0DTh/XkUfS0YwTVHFYUDIMIHKXdAj4Km447qJlXZ8VPvMtPu9o1Olk8caQ==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6402:370b:b0:57c:7f32:3107 with SMTP id
 4fb4d7f45d1cf-57c7f32323amr3722a12.1.1718001183379; Sun, 09 Jun 2024 23:33:03
 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:30 +0100
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240610063244.2828978-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-2-ptosi@google.com>
Subject: [PATCH v5 1/8] KVM: arm64: Fix clobbered ELR in sync abort/SError
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
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
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/asm-offsets.c         | 1 +
 arch/arm64/kvm/hyp/entry.S              | 8 ++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 5 +++--
 3 files changed, 12 insertions(+), 2 deletions(-)

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
index f3aa7738b477..4433a234aa9b 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,6 +83,14 @@ alternative_else_nop_endif
 	eret
 	sb
=20
+SYM_INNER_LABEL(__guest_exit_restore_elr_and_panic, SYM_L_GLOBAL)
+	// x2-x29,lr: vcpu regs
+	// vcpu x0-x1 on the stack
+
+	adr_this_cpu x0, kvm_hyp_ctxt, x1
+	ldr	x0, [x0, #CPU_ELR_EL2]
+	msr	elr_el2, x0
+
 SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	// x2-x29,lr: vcpu regs
 	// vcpu x0-x1 on the stack
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/i=
nclude/hyp/switch.h
index a92566f36022..ed9a63f1f7bf 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -689,7 +689,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vc=
pu, u64 *exit_code)
=20
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __guest_exit_panic[];
+	extern char __guest_exit_restore_elr_and_panic[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 =3D read_sysreg(elr_el2);
@@ -711,7 +711,8 @@ static inline void __kvm_unexpected_el2_exception(void)
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
2.45.2.505.gda0bf45e8d-goog


