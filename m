Return-Path: <kvm+bounces-18288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD9B8D3617
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 488D81F2410A
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4CB181B80;
	Wed, 29 May 2024 12:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uEylCkLe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B29138F96
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984883; cv=none; b=CNWdq+yoUixsMCAlRvrhIyuueyWC3LTRd+net8fqNWfbszq3LrKIsS/GyXBpJpGtBH59j0XFUGfrjE7fYgZR3aMgl0aiawcXRnEOPSLS/MhWTKtz/J+c3T6rzoknemOT9Xe4TRWCOKSoUhLLKBRUFA2VK1flQMwkawS8WGVGEVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984883; c=relaxed/simple;
	bh=r+91pKsz/3ZztQui5RURf5PWtsJpKkKOgayFB1UGtqs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oBVUCUJIUpwTIflJ1Ju20+uZn+HH5JVnNHQeF/QeMvS17qJ91/BGwliWsKityCyEzlH8zQrE1Dk5D98aT08AiqrZ76WIYmcSMzezTSIJm3Sgy67DZ0A6zYX/BdCV1auLDRNZ4srYug72lw9SDNuL6CmgSx4jaSmh566s+DuEWDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uEylCkLe; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df771b71994so3514312276.3
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984880; x=1717589680; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hHat2RDFHpMYw2ro36KxYpGkz0GVoh8rlrjhKV6ZyaM=;
        b=uEylCkLeNsLUPCY6sNnka1aS7T5DKoqRP6O6XoMLJabbCdK+EmlRDimFyEZ5mN0BtP
         1M9dGEZMfbz2ioM33MTvQ1buwyMXDfHf64RigeBGYyMKV7w1W4i2VJMQ3DKKAfhH2XhT
         08WkGAhL9TBL1R84IBJOQ5Lw4gRlbaI2N1klIk5S16lio0hQvQUb0BNc2Sf1wyhtAwCB
         HsdvZ6ZoSkPnUhJoTrxd6ig59O6pLR0P1nRYhCAY77I+bw7QkR5u7+geYDszoTJC/F48
         r5pNkqm39AxiVFc529qSs1a0vUl0BM0305wexNfPnxETxmw0edhUBDMgdgYdYEdeaica
         YPtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984880; x=1717589680;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hHat2RDFHpMYw2ro36KxYpGkz0GVoh8rlrjhKV6ZyaM=;
        b=V6u3dosjwZlPgJYvo3igUeD2p+Ihtjtkii6iNZN+49bylcpqaPIiWUA8bCqw5yQ3G6
         PHDaz7mQTN8Hbol6SiDZODuLuDUer4P0WDb207F04RuHkdzIVDaRy1QiMy7v6TSL7co1
         aUHUtqsOG59+WCe2Dt9d5Yq8aCg5ctiwmB/bpEm7bhKd2eztziLCPembqu25zQylGp6l
         6cZa1hw4Pu4zox7tKUNg3MMct4EG0a0YA4QwES1v1AQ3VBGB4HEyynM+8aNOe1QKVG1d
         8hGaRn+gYFw2kl3unNuIQ5Bwyq516FVw2+pC/dFCECrakCmSVvfKVEsA75eU19JBMUxw
         oKBg==
X-Forwarded-Encrypted: i=1; AJvYcCVjGNaExj0m04wIo9iOr5fUjavbtGnClZcnqfJs5pVhCTU+JSD8EG3KR9FMor9UVDBBPxg5/MkfqHcq06YHj+x17Rtf
X-Gm-Message-State: AOJu0YyW3bh4dkhtzCKtlkibcfLLvYf+qQm2E1qh3FOe3gAwy6xshPSm
	82S+MAzMlpOu0yh7uYffUylHg7aQ3PywKsi+SGxCxryAY3m4X4GVJcAgtIRqpsgHB2PJ4kv/Ag=
	=
X-Google-Smtp-Source: AGHT+IHH51bjxff72q1pHbdvaYO/pbW32t5gktZkV+rMdlZvjhO2kbKYW+Qzcjh0fNRydZa0oQRqxrS2dQ==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:1889:b0:dee:6802:dc49 with SMTP id
 3f1490d57ef6-df77213607amr4000587276.1.1716984880636; Wed, 29 May 2024
 05:14:40 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:11 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-6-ptosi@google.com>
Subject: [PATCH v4 05/13] KVM: arm64: Rename __guest_exit_panic __hyp_panic
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Use a name that expresses the fact that the routine might not exit
through the guest but will always (directly or indirectly) end up
executing hyp_panic().

Use CPU_LR_OFFSET to clarify that the routine returns to hyp_panic().

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/entry.S              | 6 +++---
 arch/arm64/kvm/hyp/hyp-entry.S          | 2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 4 ++--
 arch/arm64/kvm/hyp/nvhe/host.S          | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 4433a234aa9b..343851c17373 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,7 +83,7 @@ alternative_else_nop_endif
 	eret
 	sb
=20
-SYM_INNER_LABEL(__guest_exit_restore_elr_and_panic, SYM_L_GLOBAL)
+SYM_INNER_LABEL(__hyp_restore_elr_and_panic, SYM_L_GLOBAL)
 	// x2-x29,lr: vcpu regs
 	// vcpu x0-x1 on the stack
=20
@@ -91,7 +91,7 @@ SYM_INNER_LABEL(__guest_exit_restore_elr_and_panic, SYM_L=
_GLOBAL)
 	ldr	x0, [x0, #CPU_ELR_EL2]
 	msr	elr_el2, x0
=20
-SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
+SYM_INNER_LABEL(__hyp_panic, SYM_L_GLOBAL)
 	// x2-x29,lr: vcpu regs
 	// vcpu x0-x1 on the stack
=20
@@ -109,7 +109,7 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	// accurate if the guest had been completely restored.
 	adr_this_cpu x0, kvm_hyp_ctxt, x1
 	adr_l	x1, hyp_panic
-	str	x1, [x0, #CPU_XREG_OFFSET(30)]
+	str	x1, [x0, #CPU_LR_OFFSET]
=20
 	get_vcpu_ptr	x1, x0
=20
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
index ed9a63f1f7bf..d9931abf14c2 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -689,7 +689,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vc=
pu, u64 *exit_code)
=20
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __guest_exit_restore_elr_and_panic[];
+	extern char __hyp_restore_elr_and_panic[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 =3D read_sysreg(elr_el2);
@@ -712,7 +712,7 @@ static inline void __kvm_unexpected_el2_exception(void)
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
index bc0a73d9fcd0..a7db40a51e4a 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -214,7 +214,7 @@ SYM_FUNC_END(__host_hvc)
 .endm
=20
 .macro host_el2_sync_vect
-	__host_el2_vect __guest_exit_panic
+	__host_el2_vect __hyp_panic
 .endm
=20
 .macro invalid_host_el1_vect
@@ -227,7 +227,7 @@ SYM_FUNC_END(__host_hvc)
 .endm
=20
 .macro invalid_host_el2_vect
-	__host_el2_vect __guest_exit_panic
+	__host_el2_vect __hyp_panic
 .endm
=20
 /*
--=20
2.45.1.288.g0e0cd299f1-goog


