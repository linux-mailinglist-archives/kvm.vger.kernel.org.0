Return-Path: <kvm+bounces-17168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EAD58C2368
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 13:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBC82287702
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 11:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEA81172762;
	Fri, 10 May 2024 11:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jge/1wvZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485CD171E70
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 11:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340450; cv=none; b=f0sFpliGQGg2Mq8neWADkplm8X/O+TE1u+M990APJQqSn9pe1gI4DGY2kiy5v2XjU6zhTNsFoPEhlbovGe3THcXJ2496CVtez/LyJWwO7fNWc59wvkXD71QD1bQI1zpGqhHN6DAIoZ91r+DHlKX46c4DaKml9fj4rkFPYYz+9Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340450; c=relaxed/simple;
	bh=q2bvImUo/Ebwh+dSMu1W+96qgAvfZDWE4RJ8PPb+UbE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hwRMoYUTcSebORFg/TL/qFnGtH3bFhBNN9FXl0pOXHA+/ytw+2RiKfyAFwvDNdLMnaaYERXXddjq1RCZKjuWRX1KjrNZEAAp46MpfhM1oBC2tqmif65kVvienS7xm0Qas6Llf+yH+lfPlVMErjpvXny83yDp+4Vad7iep8IEpDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jge/1wvZ; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a59e9ac4c74so101971866b.2
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 04:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340448; x=1715945248; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gLg0BCgwrJPFXcSMjQCXQoWFMEc6ibsqpEm8oPH+eqc=;
        b=Jge/1wvZCnNxxZ0uD2ydVXad/n39Rx3Gp6ReSpx/g6+Pe/gN+IylpEeMJMVviP0Mvn
         4P6MuHGDBhGQ3P4QGMhQzVfbXovJkrZdmrRL19oxAL7pORwwv272v0mSsXRZb67Wx4us
         uCfOhRrMMvEst/dTpmeNxa0tMttprqQm7oJG8rD22FiVpr1S5nI3UZ9Rn+O8s8zuxcL/
         sAgEr+Rg67fR4bVTeV4OkRon/4gbwzyEzbp18dcdUpSmdpPquofyJFyVOOZ/k1VsOelV
         0OLDPWHBid2X3bWfZhBagTrdbhz82Vheq20zegVff/93NnE43cQuApaRSHbKbB+80QYE
         ymvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340448; x=1715945248;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gLg0BCgwrJPFXcSMjQCXQoWFMEc6ibsqpEm8oPH+eqc=;
        b=asGY16vVOyMAQu3ozwxVlknCtqgyGo6HWdfcNuz6VVGQzGw1GGHp6C7S/erh1w8ANi
         Fm9yQa9Yi9X1+3CEkslPeLEMB7rcw8tj3J3pniTAwXEJ/tF0TNPy2IztOiv5Jz0VFDR+
         DVZ2E2Guw0qOMOMuaFPhEESCgyZDDyt9mHDhaoFqTq/My5l8p8kdZ/uQpYnE2aD9UWs6
         dAN1PaWXXiKgpihl2211evzZwTpVjZFdqPFtfaqka2mXVthlBBEaFSJRChhMNU537KQ2
         +mbgShRpAh6QBNzebts3dt79OUN69Zf1cFVIJJJAlfSKWdaUmo/xJZwv+nmGdvms4fmx
         X29w==
X-Forwarded-Encrypted: i=1; AJvYcCXMbADB+89bdQsMEm58W/eNU8hqggmSN+f+JhgfXhPcZy4k5k7gUOsY8KF5vp/8EJIFyH8Scf1XY2n22wX23yjjH7mR
X-Gm-Message-State: AOJu0YxE5/ooMFZfMJwJ85AsURFx1Bf0/hlepnAflK8w+NQQGDjvu+CV
	7zQubGNJmicYIsBqhRQWkOfedVAoxgF1KoHgzxSJlOihlA876RD38Fjm5P5kndzJTZh/2eZOrg=
	=
X-Google-Smtp-Source: AGHT+IFepWD3/v8BdAdYkb3xCeH3t+IvJIqzRXw8IRofPX/9PW2hDEA+udTBjtBXHF9E/IajiV/5ddxCaw==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:907:12c9:b0:a59:d5f7:e56c with SMTP id
 a640c23a62f3a-a5a2d58a6f4mr225866b.5.1715340447570; Fri, 10 May 2024 04:27:27
 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:33 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-5-ptosi@google.com>
Subject: [PATCH v3 04/12] KVM: arm64: nVHE: Remove __guest_exit_panic path
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

In invalid_host_el2_vect (i.e. EL2{t,h} handlers in nVHE guest context),
remove the duplicate vCPU context check that __guest_exit_panic also
performs, allowing an unconditional branch to it.

Rename __guest_exit_panic to __hyp_panic to better reflect that it might
not exit through the guest but will always (directly or indirectly) end
up executing hyp_panic(). Fix its wrong (probably bitrotten) ABI doc to
reflect the ABI expected by VHE and (now) nVHE.

Use CPU_LR_OFFSET to clarify that the routine returns to hyp_panic().

Restore x0, x1 before calling hyp_panic when __hyp_panic is executed in
host context (i.e. called from __kvm_hyp_vector).

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/entry.S              | 14 +++++++++-----
 arch/arm64/kvm/hyp/hyp-entry.S          |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/host.S          |  8 +-------
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index bcaaf1a11b4e..6a1ce9d21e5b 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,7 +83,7 @@ alternative_else_nop_endif
 	eret
 	sb
=20
-SYM_INNER_LABEL(__guest_exit_restore_elr_and_panic, SYM_L_GLOBAL)
+SYM_INNER_LABEL(__hyp_restore_elr_and_panic, SYM_L_GLOBAL)
 	// x0-x29,lr: hyp regs
=20
 	stp	x0, x1, [sp, #-16]!
@@ -92,13 +92,15 @@ SYM_INNER_LABEL(__guest_exit_restore_elr_and_panic, SYM=
_L_GLOBAL)
 	msr	elr_el2, x0
 	ldp	x0, x1, [sp], #16
=20
-SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
-	// x2-x29,lr: vcpu regs
-	// vcpu x0-x1 on the stack
+SYM_INNER_LABEL(__hyp_panic, SYM_L_GLOBAL)
+	// x0-x29,lr: vcpu regs
+
+	stp	x0, x1, [sp, #-16]!
=20
 	// If the hyp context is loaded, go straight to hyp_panic
 	get_loaded_vcpu x0, x1
 	cbnz	x0, 1f
+	ldp	x0, x1, [sp], #16
 	b	hyp_panic
=20
 1:
@@ -110,10 +112,12 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	// accurate if the guest had been completely restored.
 	adr_this_cpu x0, kvm_hyp_ctxt, x1
 	adr_l	x1, hyp_panic
-	str	x1, [x0, #CPU_XREG_OFFSET(30)]
+	str	x1, [x0, #CPU_LR_OFFSET]
=20
 	get_vcpu_ptr	x1, x0
=20
+	// Keep x0-x1 on the stack for __guest_exit
+
 SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// x0: return code
 	// x1: vcpu
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.=
S
index 03f97d71984c..7e65ef738ec9 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -122,7 +122,7 @@ el2_error:
 	eret
 	sb
=20
-.macro invalid_vector	label, target =3D __guest_exit_panic
+.macro invalid_vector	label, target =3D __hyp_panic
 	.align	2
 SYM_CODE_START_LOCAL(\label)
 	b \target
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/i=
nclude/hyp/switch.h
index 19a7ca2c1277..9387e3a0b680 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -753,7 +753,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vc=
pu, u64 *exit_code)
=20
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __guest_exit_restore_elr_and_panic[];
+	extern char __hyp_restore_elr_and_panic[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 =3D read_sysreg(elr_el2);
@@ -776,7 +776,7 @@ static inline void __kvm_unexpected_el2_exception(void)
=20
 	/* Trigger a panic after restoring the hyp context. */
 	this_cpu_ptr(&kvm_hyp_ctxt)->sys_regs[ELR_EL2] =3D elr_el2;
-	write_sysreg(__guest_exit_restore_elr_and_panic, elr_el2);
+	write_sysreg(__hyp_restore_elr_and_panic, elr_el2);
 }
=20
 #endif /* __ARM64_KVM_HYP_SWITCH_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.=
S
index 135cfb294ee5..7397b4f1838a 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -196,19 +196,13 @@ SYM_FUNC_END(__host_hvc)
 	tbz	x0, #PAGE_SHIFT, .L__hyp_sp_overflow\@
 	sub	x0, sp, x0			// x0'' =3D sp' - x0' =3D (sp + x0) - sp =3D x0
 	sub	sp, sp, x0			// sp'' =3D sp' - x0 =3D (sp + x0) - x0 =3D sp
-
 	/* If a guest is loaded, panic out of it. */
-	stp	x0, x1, [sp, #-16]!
-	get_loaded_vcpu x0, x1
-	cbnz	x0, __guest_exit_panic
-	add	sp, sp, #16
-
 	/*
 	 * The panic may not be clean if the exception is taken before the host
 	 * context has been saved by __host_exit or after the hyp context has
 	 * been partially clobbered by __host_enter.
 	 */
-	b	hyp_panic
+	b	__hyp_panic
=20
 .L__hyp_sp_overflow\@:
 	/* Switch to the overflow stack */
--=20
2.45.0.118.g7fe29c98d7-goog


