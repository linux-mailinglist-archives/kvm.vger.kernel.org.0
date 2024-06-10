Return-Path: <kvm+bounces-19160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 60CF3901B4E
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 08:33:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B0926B23801
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 06:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275E028377;
	Mon, 10 Jun 2024 06:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tz/t3Z5R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92421A716
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 06:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001198; cv=none; b=mxeXSICxeToZIjVrV/fn5mztLXYMZO0X+E2/dE2OE76m1WUpS1KuS1Bu1RHGSzeFDdbIv0SjpU5UBD3povax3KmavMhFoFlqQ6INeViTERYyytv3R62jXOpPSET7a5tcZVHCxksOppRsrZGmsay90ae/UkvX5PVv7G31KMZ3Rcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001198; c=relaxed/simple;
	bh=gutDst1iGuxauvOLWt6qjbv2PXcJmlMUw+iw8PL4uSI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iwSGNVnsayp/697CaPav3eU2tpinO0/DpZkoy6dQpVUfR4+OsMPr+UzYTQlb3xz9cHhABIC/FafM9Q1MtZaD8M3H3qGCarQ6Kd2VyunZ0e9wiFOm/mAPQJATnlL9gCoryQ4QNJJ9RUIIZ6kRCrLzALjC2IBYdp8OfDxrLvxBprI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tz/t3Z5R; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-57c697aea06so821084a12.2
        for <kvm@vger.kernel.org>; Sun, 09 Jun 2024 23:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001195; x=1718605995; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2DG6vYupY7WAr9zwo8BTUXtx1v0A9oK0vgYWOEtX0E4=;
        b=tz/t3Z5RQjZKgdpSWAFuNL3UQ9mnRqpq3d0l8gpy5HM8IXK/Qr9kveVkf1OuW9eKdz
         rNd8z5uGQtBEoEW8Aux+G7SvAUgN/dFsvo73D3ABDN6XY6e2V0g9RwEua/71r9BftBnN
         YLQaV0Xc8WC9e8VpkMmEYZmJjKa8D5mWaOp2b70bw4DjYVatQK07mY3gGvLGPwRg2sYW
         6OOk44CjSCloG8+qYtae8gqpeVMmH3l++kR86neX2BVQmCTZIMx+8uDoYzPFdHwgWOEd
         GcPgOtqXJTm1VddidONILSWYBW5rNr+pd2O2KKYZIoKPNSkO3zxe1eXxflFyJURNy+f7
         vjag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001195; x=1718605995;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2DG6vYupY7WAr9zwo8BTUXtx1v0A9oK0vgYWOEtX0E4=;
        b=nVfRSLF3yt0N0PxLrJO9vd1zXJOuvDq6FVIktIsw4hUiNzt9mCaKv2NhvFVNX1DoQX
         UABW3dKuyh5eTTVUBw+SLL+pa0cFrYgZb5opH3aVNapd7B6i2CK2Vg/TXwvSs6tXzUj3
         osQfNDHR2f5BQhkHw6COCGbGsyhE2zXnEn+qHMc9gjVyfz4+SmU+DEJtB8Hk6WXhQGyW
         ItWr7TJvk3blJ2HCVD/fYlksLcaa9lxlD+fhQ3D4DccMq+WMCoLCP819E+Rw28eAgY+4
         1Po+fRrVDpy8W69ljhSJCghVqPqZb0Ul6rgFKQ6qer+sMlz3b1T6jtGcHwqgXSo3wGM/
         ZBew==
X-Forwarded-Encrypted: i=1; AJvYcCXNphyPL5XEdsOBMkT3U/9RGf11qm48XHhO/6IF9zbWKdEBLkGkR2ZH16GWIgTPc7NHFZ7FMfmexdMiFwLQxVJ1zrlD
X-Gm-Message-State: AOJu0YwQ+XN8JuFklYMzxOgDVsI2LBY3233/z5QShMoUA5Qp8kNg1YUm
	m3VC5zJXXBXpaesa9Lqyw1BU9sIBcVyker2pdd/jwLf7resC0gnTq3yxBvOiw4JoazQisXKjVA=
	=
X-Google-Smtp-Source: AGHT+IHt0FJ6sbCckrZkKJOfJcRcRL2EfcoqbTKxzqlq4WyO2vf8tBUdRX1+5ixxV1gmd31Ov951xdBvBA==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6402:434a:b0:57c:7fc5:b3eb with SMTP id
 4fb4d7f45d1cf-57c7fc5b583mr3212a12.8.1718001195339; Sun, 09 Jun 2024 23:33:15
 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:35 +0100
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240610063244.2828978-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-7-ptosi@google.com>
Subject: [PATCH v5 6/8] arm64: Introduce esr_brk_comment, esr_is_cfi_brk
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As it is already used in two places, move esr_comment() to a header for
re-use, with a clearer name.

Introduce esr_is_cfi_brk() to detect kCFI BRK syndromes, currently used
by early_brk64() but soon to also be used by hypervisor code.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
Acked-by: Will Deacon <will@kernel.org>
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
2.45.2.505.gda0bf45e8d-goog


