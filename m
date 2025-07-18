Return-Path: <kvm+bounces-52889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61C36B0A4F2
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:18:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C496174604
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 13:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14BD82DC338;
	Fri, 18 Jul 2025 13:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="lhiK8Qk9";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="lb6gRhYG"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A252E370B;
	Fri, 18 Jul 2025 13:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752844709; cv=none; b=Nz7YexZoeh9MpEGyyjjU3OCTFNOfyXpnnRHKyDcvQ5m5QQc5dw4sJNh6abCF4NdWFdku2HciWp7a3dsu2iyfOBw3cUEqaVg3Tv2T9xh//D/eq68wFtLjHvsJffm7HvTB4jP2pIaYhCgCrZh2B1xVgA2O9xFPP4f/xjq6gR0jcOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752844709; c=relaxed/simple;
	bh=GlhY5963uKLghWT9UMDfwza9mzMJBnGIVIpZq0UF6Ao=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=UoV18AwffvX6agsmXPad9jia1tldMGaEYUQ03A63GHpxSsslYHH4XzJhCtZy8aweLS5GT52VPSfrF5dvdFRLIuYVajD6HdpWfV3OI6mLIBwSxvMfeVSOt12Wh4QjdBbODErve/qCly7B2eSYejxJGYOksxRbE1SX4aR8XsIc4jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=lhiK8Qk9; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=lb6gRhYG; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1752844706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a7pcXwEMvphmTY2pbZCwuEUxQvypKwXeKfbqt+7td9Y=;
	b=lhiK8Qk9gFxUMcihhZ0EnXkom8ve14yEXKN1nnD3zs1oecAz0dsRxSjiIkNId++pqcBffp
	lnGtqDfocT/0rBt4IpivDf1sj7J+dow4m2hgSR/3trDkmy0cZcnCu2vEi3q9Da3LdiIe9K
	WVMVKS8tqn596d815xhA92bd/6+DXP3AavLGyza+tUdwiITYk1I8U9a8z0jnKTLJO1ou9O
	X/uV/1yI5k46giCyyVNZBGObKLioLxg94HziAc1D5gEOlIKxWaRLOo2WgdfIzsDC/NG2X6
	gdlkpZ30i7zfXCA7T5IDsVmCC5ekKt/Xm8UpbaIH+6y4f2FVz8EI01c/LFsBUg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1752844706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a7pcXwEMvphmTY2pbZCwuEUxQvypKwXeKfbqt+7td9Y=;
	b=lb6gRhYGW5RyqLipbdDeI2WkZAZE+EvJFNO4WDzRpUvE0Y+O1nMg5TiapPHRngMONoA0Qj
	DcrvUyKKrNtD3vDA==
Date: Fri, 18 Jul 2025 15:18:24 +0200
Subject: [PATCH RESEND] MIPS: Don't use %pK through printk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250718-restricted-pointers-mips-v1-1-45de40dcc662@linutronix.de>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Huacai Chen <chenhuacai@kernel.org>
Cc: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1752844703; l=3032;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=GlhY5963uKLghWT9UMDfwza9mzMJBnGIVIpZq0UF6Ao=;
 b=aoMGYTyJj8jY2SjFjeJuxefs1bSQFYx6lxyhvx/5ycZjts7g1+qB9QzpgcG0cgf+hVhMAnxAq
 /Ej+5kCuFLqArM3D6mnGngyR8XO7G5QEomNA4OmCXpeoQQz5NkQWOZo
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

Restricted pointers ("%pK") are not meant to be used through printk().
It can unintentionally expose security sensitive, raw pointer values.

Use regular pointer formatting instead.

Link: https://lore.kernel.org/lkml/20250113171731-dc10e3c1-da64-4af0-b767-7c7070468023@linutronix.de/
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/mips/kernel/relocate.c | 10 +++++-----
 arch/mips/kvm/mips.c        |  2 +-
 arch/mips/mm/physaddr.c     |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kernel/relocate.c b/arch/mips/kernel/relocate.c
index cda7983e7c18d421535253a2406a523f6d1166e7..7f1c136ad85062806b90042d6760a2a7a354593d 100644
--- a/arch/mips/kernel/relocate.c
+++ b/arch/mips/kernel/relocate.c
@@ -138,7 +138,7 @@ static int __init reloc_handler(u32 type, u32 *loc_orig, u32 *loc_new,
 		apply_r_mips_hi16_rel(loc_orig, loc_new, offset);
 		break;
 	default:
-		pr_err("Unhandled relocation type %d at 0x%pK\n", type,
+		pr_err("Unhandled relocation type %d at 0x%p\n", type,
 		       loc_orig);
 		return -ENOEXEC;
 	}
@@ -439,10 +439,10 @@ static void show_kernel_relocation(const char *level)
 {
 	if (__kaslr_offset > 0) {
 		printk(level);
-		pr_cont("Kernel relocated by 0x%pK\n", (void *)__kaslr_offset);
-		pr_cont(" .text @ 0x%pK\n", _text);
-		pr_cont(" .data @ 0x%pK\n", _sdata);
-		pr_cont(" .bss  @ 0x%pK\n", __bss_start);
+		pr_cont("Kernel relocated by 0x%p\n", (void *)__kaslr_offset);
+		pr_cont(" .text @ 0x%p\n", _text);
+		pr_cont(" .data @ 0x%p\n", _sdata);
+		pr_cont(" .bss  @ 0x%p\n", __bss_start);
 	}
 }
 
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 60b43ea85c125fe9a204abfd3dd5339708a22ee1..7b0de05d39f261f8ea2067284984fc9332e6a4f2 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -316,7 +316,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	 * we allocate is out of range, just give up now.
 	 */
 	if (!cpu_has_ebase_wg && virt_to_phys(gebase) >= 0x20000000) {
-		kvm_err("CP0_EBase.WG required for guest exception base %pK\n",
+		kvm_err("CP0_EBase.WG required for guest exception base %p\n",
 			gebase);
 		err = -ENOMEM;
 		goto out_free_gebase;
diff --git a/arch/mips/mm/physaddr.c b/arch/mips/mm/physaddr.c
index f9b8c85e984334dedd23ff7acc8c39e5e14f040a..a6b1bf82057a1db62eba14eea9cdddb04e29650b 100644
--- a/arch/mips/mm/physaddr.c
+++ b/arch/mips/mm/physaddr.c
@@ -30,7 +30,7 @@ static inline bool __debug_virt_addr_valid(unsigned long x)
 phys_addr_t __virt_to_phys(volatile const void *x)
 {
 	WARN(!__debug_virt_addr_valid((unsigned long)x),
-	     "virt_to_phys used for non-linear address: %pK (%pS)\n",
+	     "virt_to_phys used for non-linear address: %p (%pS)\n",
 	     x, x);
 
 	return __virt_to_phys_nodebug(x);

---
base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
change-id: 20250217-restricted-pointers-mips-2c7559a8d37a

Best regards,
-- 
Thomas Weißschuh <thomas.weissschuh@linutronix.de>


