Return-Path: <kvm+bounces-38330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D23DFA37C69
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 08:41:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB6393AF03B
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 07:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD07199FA4;
	Mon, 17 Feb 2025 07:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="vhUT1NOd";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Vi+VlE+N"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2834A17B425;
	Mon, 17 Feb 2025 07:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739778049; cv=none; b=Ys+v4wKRwOj21HThS2wzUqmj4IGp13sBecFtcFRLkUEsbMvKkhsAt/plC1UwC9nqrzJJ3Yo2/wbryGYfFLlcuQSJuatqeYhM/zg6AdmpUoUtXj5sOdH+hEtXh7C/LhD2uJAfLmIScfF25dPVFDEKfd3QAUVINT4NhZe4dPqE54I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739778049; c=relaxed/simple;
	bh=GlhY5963uKLghWT9UMDfwza9mzMJBnGIVIpZq0UF6Ao=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=p9MQrsyOEFrHCASX4SAV+IrINnidMOWhJFdJymJUNJzi4SJ5bCWbnrdr21VOqgLVjaQC3aN3gI3J6sXNoynF+kP0COnYShrTPqn1HVYW+BMBoP/nWjqZYbVXwGqk1HNnDu35BkaxvgBnoEEBETGQOePd1RCUO/Pf2w+ZxXemIGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=vhUT1NOd; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Vi+VlE+N; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1739778046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a7pcXwEMvphmTY2pbZCwuEUxQvypKwXeKfbqt+7td9Y=;
	b=vhUT1NOdxZ56WfhZi+IDFBppyU46xpNwku0m3zwtuoQnCyDRmniSZTbyaCSxiMZZnBHLGn
	drNEinoecXW3DGqsVw8V1ZbNUqXgvuCsamn683Fr2vysESuyIYvR4PsD+CHvWwK4LgfrX4
	yYJVIA1FeJRYkLf7vlbMJULZgPU9nom/yE5y6gQdVQN9+pPUBbpl52+bBHo9MuAIqWB3u6
	IxQm3ukRCe+b7WKy2Kn4MImvml9LQL4iwYMwpXdB7yl0lrMFyeYYYwPfJZSC0N6ydFWzG6
	RtAn3ihpv5tN8Sigm8pabD3ecwj7TZp6EJMmR6BYju26Frh4h8CpYkSgC/S49g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1739778046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a7pcXwEMvphmTY2pbZCwuEUxQvypKwXeKfbqt+7td9Y=;
	b=Vi+VlE+NRBF+Upfa1bESGClJsp8XT0SNEuWMyW2zocCJxv8cV+eM3qyUhyGJgZDz6ctMTV
	XQPTUDBzSqObxJBg==
Date: Mon, 17 Feb 2025 08:40:44 +0100
Subject: [PATCH] MIPS: Don't use %pK through printk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250217-restricted-pointers-mips-v1-1-694313640c98@linutronix.de>
X-B4-Tracking: v=1; b=H4sIAPvnsmcC/x3MQQqEMAxA0atI1ga0UurMVcRFaaNmYS1JEUG8u
 8XlW/x/g5IwKfybG4ROVj5SRd82EDafVkKO1WA6YzvTOxTSIhwKRcwHp0KiuHNWNMFZ+/NjHJy
 Hmmehha9vPc3P8wJLq3RuagAAAA==
X-Change-ID: 20250217-restricted-pointers-mips-2c7559a8d37a
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Huacai Chen <chenhuacai@kernel.org>
Cc: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1739778046; l=3032;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=GlhY5963uKLghWT9UMDfwza9mzMJBnGIVIpZq0UF6Ao=;
 b=O3Mza39w/Ezu6XV3CmC/cgeL/AqgjxqBCKbclm7AlS1dqWFrWoZEGTqzuYm9kIxg0unGHpuMZ
 lnQyFhRL8rDD1HTqDCeqqfN675g4cWgnKULFVYe7Swdj+mXveF6cX8Q
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


