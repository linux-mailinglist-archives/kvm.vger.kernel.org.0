Return-Path: <kvm+bounces-17172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA5F88C236C
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 13:31:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCFD61C2335B
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 11:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 619A716F26E;
	Fri, 10 May 2024 11:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="waQSF/Xd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01671176FD3
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 11:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340460; cv=none; b=Rl1Ik3pFmKR1g0dOJvztc1fmgxtQThAbxe7oSLK+joSPfZG6lFuk3lFL4nb9Tjs2th31fYU26VUrRCCvXz8/43AkPcsbm+oHVIFrKNdO9cC8CrRRpav32GMHmaYWwV6CPyxfo8ub2ehvP+LhsKL7JQIYpqyGpkYfQ4dJobbKYQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340460; c=relaxed/simple;
	bh=4OKNjh0djyGb87YHfRcKtU3RYjXJ+P/49RV4qkJxE7U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fh7II63lp5LUrIrsC68V+UvqsDgBmWtA0jE6ZZiL/3TNLpEIIn5Es3JBysQ9FCuJV4QS9y7yjbs92rJsQJ2Z1DBXbeYpjzq1jtZGSbUerAcygymZpia1URlOpwuldVwdD9Fb3FtXCYg81+M2LHlFLbe2aSQB0ri1BhtNCW6vGIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=waQSF/Xd; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a59a5b06802so110445466b.1
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 04:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340457; x=1715945257; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BYiDxgRL4/PJcTPYc8te2M3RBep5LmiQ+KSg/yVolMc=;
        b=waQSF/Xd0mtcOHjGJYti3C9qDPbBs/B+B2u5+1MTaNkC5WitBHWYGQLqbJ6hGiEG4X
         BjdM/MggdYOsDkCV4J7miAqyTvRUO5hnShPI4pIEjsw+0dO3XnIMNrSF88A8jvuZTPQY
         Rach4cYom0QX7FndH2gftjaven4VOoGEHp/oCkP4YVCBE09vvr/0j5m6Z6KgOspyBMh9
         ydlp7fL0tqFqQxadXIULR77k2vyV1s81lJXeoc1RYv6yEW6Kbn9Fs3Vc3lt26C4n/Fx0
         it4/5nw8MZzkEtZHCTltaLe/DsWgoZQjL5mftxl4WtryVUFWqKuZ7U32ns2CBV6HiWVm
         MLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340457; x=1715945257;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BYiDxgRL4/PJcTPYc8te2M3RBep5LmiQ+KSg/yVolMc=;
        b=F4aJlExjYpFz+t99WwVgV5F6eUNPFuAZxLUHulWZGFpZXqJX9RCCwi1bv1X5qGTGEf
         pHgQow1Sr4brRsTZFBeV/adtsuPF/SF8diHQvzMs0fnT5yKVwp78PCAfHtuzROxSxxK2
         gnDPnl3m3NvRAAS9Voo/qiKuD3aKV4YrytzrqN7w0r7mKq8R2GOVy8y7hEa7kMxmHtU3
         cZrvEjU/XjOSs6Lh8iLFIUr81EhKqnjoDVOuir9fvDA1iEHg7aQo8haLr8U819+2gJNZ
         SyY3zjnek8xVZpAWsIZBRdbQC+P0udvPM1BgmR3JSqJdQ/4PIl8OFMQ1RCEkMemNpEJR
         ZYhA==
X-Forwarded-Encrypted: i=1; AJvYcCURZYu1JkJCvb8+RhowysdtpRKimZZWi+Ufbhw+HEYY/w/6pSzuZD9rEo0sO1+udNe80H+ygrOfO159N/g68TOE2YpF
X-Gm-Message-State: AOJu0Yw4ASfTYUw4Z1LuD9EgruFmESGtfxPndAok2hq1QFWrRlxuDukc
	Ly0IGyGA3glA0udx6NkGbFFSEmoIANM+s5qxAi0MG3+Bgn9nSoBcGEPPWEntqEJQ963VK7MWOw=
	=
X-Google-Smtp-Source: AGHT+IHFd5o0vQu25tuDgldMkm4aPBD8ZTZa88+e/50cMnpBaWWfrW1M4Ov32MuLEgdpxktrbzGRQJLKwg==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:906:27cc:b0:a54:c131:8128 with SMTP id
 a640c23a62f3a-a5a2d6796c7mr215866b.14.1715340457059; Fri, 10 May 2024
 04:27:37 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:37 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-9-ptosi@google.com>
Subject: [PATCH v3 08/12] arm64: Move esr_comment() to <asm/esr.h>
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As it is already defined twice and is about to be needed for kCFI error
detection, move esr_comment() to a header for re-use, with a clearer
name.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/esr.h       | 5 +++++
 arch/arm64/kernel/debug-monitors.c | 4 +---
 arch/arm64/kernel/traps.c          | 8 +++-----
 arch/arm64/kvm/handle_exit.c       | 2 +-
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 81606bf7d5ac..2bcf216be376 100644
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
index 215e6d7f2df8..2652247032ae 100644
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
+	if ((esr_brk_comment(esr) & ~CFI_BRK_IMM_MASK) =3D=3D CFI_BRK_IMM_BASE)
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
index 617ae6dea5d5..0bcafb3179d6 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -395,7 +395,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, =
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
2.45.0.118.g7fe29c98d7-goog


