Return-Path: <kvm+bounces-18291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F658D361A
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:15:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 937A21C23B46
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7FD5181315;
	Wed, 29 May 2024 12:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c/y9KcD5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDF3181310
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984891; cv=none; b=A5/pD64azlEorNaAT2uiq7oE3ITkSz/4pQx3qee2R5+HSapbJR2uhnKwXOcoqZsGaGOgO1SURh8vx5zrlwoskjA/lVCxKjw+x4Sk/1tOH+4hc+ZYiMQIuIf7F1HpjaBBd8cF2xkFN1HixELPMDnnuEbKZ7+Q/Vu3RflRKuhMmj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984891; c=relaxed/simple;
	bh=9btKNfRjz6fK+DhlL9k76Ks1QkjES/uXicjLnT/2h3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RmZ3qtF7AuEo4W+m1z8GAOSaBi+jzT1DauBQuc1cW4G6h8vAePV0G6AXQX59cpn21ogXCbVlWV4BSJ5TwUibp/DEfKAmUK1dcaRvVBUiwaPDk3YgcGvUe73PDmg/Ww90RrByaGdLDIBoGatRZzBkUb4DPe0DShLqS5dBkzfmEXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c/y9KcD5; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-579e27b0404so1044606a12.1
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984888; x=1717589688; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fl+f30rl7dVa/IVaUSQ5SKFqgJp4W7PmIf/N7fy8cOU=;
        b=c/y9KcD5CXWwMDkErOJv4lzMpuTdFRm7T6/pyLJvhwBmlry9kygZ/tF4Rbj8lJw0kA
         bL7JGgTZxZRRNVy3gt8oubSUdD6Dh8OFEwQV4gHcV+fC42GOt5j7+ql6R033mYaLtJsC
         8xC4px09WlFMpK0a5oPpR8uy7tfBpna6uofywc4jBqrxYQqknQUmUeWSZPRcHpBgicaC
         A7uUg9RsrSA06TvQHIeDaQRITPIf8KBP910m2zs8oIkau7Tg7fYR3ih9jyntrr7SYm4m
         Fam6O2AZMMZ2yJxLIWbjS7wEKyNCii2XjHCy4vdgOq44gGKZS3UimnI24/DWEZtUKS9D
         KrOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984888; x=1717589688;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Fl+f30rl7dVa/IVaUSQ5SKFqgJp4W7PmIf/N7fy8cOU=;
        b=Tl9oSgSyyV8On+7kpCWHryVH1G8VQ+c4zxTcBBPxbBxrBIQtqRdpadEYnvPAZxgwW0
         IzKh9xvy/ekEMOxxk1KWN4gtp5ULy9RmwHHP1bKS5fSjLTfXNW92IM6zx7wCzv5QIAwI
         djyD4GPEA0iIs4/0vMUjadtaM5CYPagslUFREtLElEPnyg0NS8fSDhgtWvKmrLkidF7L
         xmitEeY1y8jlpbrTBQPPzTZwfRVse717uFPedqO4+ksyhIhXzB9co1zc+kWB7vYQNkvn
         75OdAxOW0f0R9FWcN9Cb4GZN7braFBA/tRrKQRzVPoY8C6FgDwqhsFKMwBGEehRWwetv
         2INQ==
X-Forwarded-Encrypted: i=1; AJvYcCW81DZGnx15DxAP5TklwIRa0zgdN/piWcrE3m8zx0IloukN/JQPzw47zOxnIdAMajzL7nMgMBYD75c+f9yWTIIgC7jq
X-Gm-Message-State: AOJu0Yy+NIKBuohu4fM+yfakf+P0S0rDwudSBZF91YiDBpIoHw06lbYa
	fGsmHVtKmCeZCxfqhkRWvpCgPoPKGy71VsdbBpRr65ik0rBYBbKZDHOKTDO2sqq2/c+R31Q8yw=
	=
X-Google-Smtp-Source: AGHT+IEEHNDVH5oua3/ecoC74+hCc08TVB6uy8myiwmNDRyQ2CUe66zxXOENHLIB7cqS59dn8IOjkr3XHg==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6402:1954:b0:578:b249:2b06 with SMTP id
 4fb4d7f45d1cf-578b24964d6mr14880a12.6.1716984887626; Wed, 29 May 2024
 05:14:47 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:14 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-9-ptosi@google.com>
Subject: [PATCH v4 08/13] arm64: Introduce esr_comment() & esr_is_cfi_brk()
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As it is already used in two places, move esr_comment() to a header for
re-use, with a clearer name.

Introduce esr_is_cfi_brk() to detect kCFI BRK syndromes, currently used
by early_brk64() but soon to be also used by hypervisor code.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/esr.h       | 11 +++++++++++
 arch/arm64/kernel/debug-monitors.c |  4 +---
 arch/arm64/kernel/traps.c          |  8 +++-----
 arch/arm64/kvm/handle_exit.c       |  2 +-
 4 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 7abf09df7033..77569d207ecf 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -379,6 +379,11 @@
 #ifndef __ASSEMBLY__
 #include <asm/types.h>
=20
+static inline unsigned long esr_brk_comment(unsigned long esr)
+{
+	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
+}
+
 static inline bool esr_is_data_abort(unsigned long esr)
 {
 	const unsigned long ec =3D ESR_ELx_EC(esr);
@@ -386,6 +391,12 @@ static inline bool esr_is_data_abort(unsigned long esr=
)
 	return ec =3D=3D ESR_ELx_EC_DABT_LOW || ec =3D=3D ESR_ELx_EC_DABT_CUR;
 }
=20
+static inline bool esr_is_cfi_brk(unsigned long esr)
+{
+	return ESR_ELx_EC(esr) =3D=3D ESR_ELx_EC_BRK64 &&
+	       (esr_brk_comment(esr) & ~CFI_BRK_IMM_MASK) =3D=3D CFI_BRK_IMM_BASE=
;
+}
+
 static inline bool esr_fsc_is_translation_fault(unsigned long esr)
 {
 	/* Translation fault, level -1 */
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-m=
onitors.c
index 64f2ecbdfe5c..024a7b245056 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -312,9 +312,7 @@ static int call_break_hook(struct pt_regs *regs, unsign=
ed long esr)
 	 * entirely not preemptible, and we can use rcu list safely here.
 	 */
 	list_for_each_entry_rcu(hook, list, node) {
-		unsigned long comment =3D esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
-
-		if ((comment & ~hook->mask) =3D=3D hook->imm)
+		if ((esr_brk_comment(esr) & ~hook->mask) =3D=3D hook->imm)
 			fn =3D hook->fn;
 	}
=20
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 215e6d7f2df8..9e22683aa921 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -1105,8 +1105,6 @@ static struct break_hook ubsan_break_hook =3D {
 };
 #endif
=20
-#define esr_comment(esr) ((esr) & ESR_ELx_BRK64_ISS_COMMENT_MASK)
-
 /*
  * Initial handler for AArch64 BRK exceptions
  * This handler only used until debug_traps_init().
@@ -1115,15 +1113,15 @@ int __init early_brk64(unsigned long addr, unsigned=
 long esr,
 		struct pt_regs *regs)
 {
 #ifdef CONFIG_CFI_CLANG
-	if ((esr_comment(esr) & ~CFI_BRK_IMM_MASK) =3D=3D CFI_BRK_IMM_BASE)
+	if (esr_is_cfi_brk(esr))
 		return cfi_handler(regs, esr) !=3D DBG_HOOK_HANDLED;
 #endif
 #ifdef CONFIG_KASAN_SW_TAGS
-	if ((esr_comment(esr) & ~KASAN_BRK_MASK) =3D=3D KASAN_BRK_IMM)
+	if ((esr_brk_comment(esr) & ~KASAN_BRK_MASK) =3D=3D KASAN_BRK_IMM)
 		return kasan_handler(regs, esr) !=3D DBG_HOOK_HANDLED;
 #endif
 #ifdef CONFIG_UBSAN_TRAP
-	if ((esr_comment(esr) & ~UBSAN_BRK_MASK) =3D=3D UBSAN_BRK_IMM)
+	if ((esr_brk_comment(esr) & ~UBSAN_BRK_MASK) =3D=3D UBSAN_BRK_IMM)
 		return ubsan_handler(regs, esr) !=3D DBG_HOOK_HANDLED;
 #endif
 	return bug_handler(regs, esr) !=3D DBG_HOOK_HANDLED;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b037f0a0e27e..d41447193e13 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -423,7 +423,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, =
u64 spsr,
 	if (mode !=3D PSR_MODE_EL2t && mode !=3D PSR_MODE_EL2h) {
 		kvm_err("Invalid host exception to nVHE hyp!\n");
 	} else if (ESR_ELx_EC(esr) =3D=3D ESR_ELx_EC_BRK64 &&
-		   (esr & ESR_ELx_BRK64_ISS_COMMENT_MASK) =3D=3D BUG_BRK_IMM) {
+		   esr_brk_comment(esr) =3D=3D BUG_BRK_IMM) {
 		const char *file =3D NULL;
 		unsigned int line =3D 0;
=20
--=20
2.45.1.288.g0e0cd299f1-goog


