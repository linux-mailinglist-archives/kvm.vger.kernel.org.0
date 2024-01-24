Return-Path: <kvm+bounces-6826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DCBC783A738
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 11:52:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A2A2B2A716
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 10:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6111A27D;
	Wed, 24 Jan 2024 10:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tq-group.com header.i=@tq-group.com header.b="n0U1IJKK"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769BD18EBB;
	Wed, 24 Jan 2024 10:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.104.207.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706093454; cv=none; b=kffOEbliCaA+0dxSsCxJqRF0fKiSVoZVcf5dtF6/Beh9BJgV2atKvpNPo1ZZwoieg1+7GdA8B6kI7CKZBNGztMJH1CdpxHUFTCcPWqlJDNGKu3mKyAnSvYVdUi/T1CZK6HfIGJdgENAjbeg1OHFOlQZoSxKIkIMwREkwkptGugw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706093454; c=relaxed/simple;
	bh=84MVVmbTH/C8W3safTbo5bn7FIroCOF8HfRHVUg0sUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ADIwRLnp1sI0WReEws6DAsQN542ESAaITBG9GcHO/p2Dd+eLOFeb4Vv7rWcNRdO0iEAuMb8EXnuriBIhQG3ZDN6KDX3o9bTWdbQOzQ2LY09L4s4c0PsAhT6snPbhLm0OJU+xBTxVRyCmDCliGRnb0FnpkcbmcvFlbzKcoHyYhCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ew.tq-group.com; spf=pass smtp.mailfrom=ew.tq-group.com; dkim=pass (2048-bit key) header.d=tq-group.com header.i=@tq-group.com header.b=n0U1IJKK; arc=none smtp.client-ip=93.104.207.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ew.tq-group.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ew.tq-group.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1706093450; x=1737629450;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aTuEXSlYOiNHEuFuSlJtP0lQIoUAMibD41RptAODArc=;
  b=n0U1IJKKumuZGyRsgy0/s8GzTc9ZlShsTdueJIct2gQC4XhX7J9WwCOE
   tRtcZQSyp10JVYASr8gLq5/0AoF1Xh7Y1l+4y2TdFJgGfByOzutUJsgD6
   3kQXvyfedcjHo4v3ZvImUMqjEtAQO5PRRIL1IbycNaSEmoHfG7dBltZuX
   ZAebqeviwdFe2Wjs1wraJRYa2GZzZMhnjU5WzrrZrioSe5jtpTgBaMZ6h
   KtS5jXyQIA90n/PHbXyjVyrKQBC56pTk+lqZJQIl+EpZeLXEM+F2LwFn9
   PmyVJqI7wM5CMcr6bkjAXuO8iWFJrAbeg2WjYhfWdfbDpRiNJXsPDCEcX
   A==;
X-IronPort-AV: E=Sophos;i="6.05,216,1701126000"; 
   d="scan'208";a="35052777"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 24 Jan 2024 11:50:47 +0100
Received: from schifferm-ubuntu.tq-net.de (SCHIFFERM-M3.tq-net.de [10.121.49.135])
	by vtuxmail01.tq-net.de (Postfix) with ESMTPA id EB5A2280075;
	Wed, 24 Jan 2024 11:50:46 +0100 (CET)
From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To: Michael Ellerman <mpe@ellerman.id.au>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux@ew.tq-group.com,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH] powerpc: rename SPRN_HID2 define to SPRN_HID2_750FX
Date: Wed, 24 Jan 2024 11:50:31 +0100
Message-ID: <20240124105031.45734-1-matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This register number is hardware-specific, rename it for clarity.

FIXME comments are added in a few places where it seems like the wrong
register is used. As I can't test this, only the rename is done with no
functional change.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 arch/powerpc/include/asm/reg.h               | 2 +-
 arch/powerpc/kernel/cpu_setup_6xx.S          | 4 ++--
 arch/powerpc/kvm/book3s_emulate.c            | 4 ++--
 arch/powerpc/platforms/52xx/lite5200_sleep.S | 6 ++++--
 arch/powerpc/platforms/83xx/suspend-asm.S    | 6 ++++--
 drivers/cpufreq/pmac32-cpufreq.c             | 8 ++++----
 6 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 4ae4ab9090a2..994dfefba98b 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -615,7 +615,7 @@
 #define HID1_ABE	(1<<10)		/* 7450 Address Broadcast Enable */
 #define HID1_PS		(1<<16)		/* 750FX PLL selection */
 #endif
-#define SPRN_HID2	0x3F8		/* Hardware Implementation Register 2 */
+#define SPRN_HID2_750FX	0x3F8		/* IBM 750FX HID2 Register */
 #define SPRN_HID2_GEKKO	0x398		/* Gekko HID2 Register */
 #define SPRN_IABR	0x3F2	/* Instruction Address Breakpoint Register */
 #define SPRN_IABR2	0x3FA		/* 83xx */
diff --git a/arch/powerpc/kernel/cpu_setup_6xx.S b/arch/powerpc/kernel/cpu_setup_6xx.S
index f29ce3dd6140..4f4a4ce34861 100644
--- a/arch/powerpc/kernel/cpu_setup_6xx.S
+++ b/arch/powerpc/kernel/cpu_setup_6xx.S
@@ -382,7 +382,7 @@ _GLOBAL(__save_cpu_setup)
 	andi.	r3,r3,0xff00
 	cmpwi	cr0,r3,0x0200
 	bne	1f
-	mfspr	r4,SPRN_HID2
+	mfspr	r4,SPRN_HID2_750FX
 	stw	r4,CS_HID2(r5)
 1:
 	mtcr	r7
@@ -477,7 +477,7 @@ _GLOBAL(__restore_cpu_setup)
 	bne	4f
 	lwz	r4,CS_HID2(r5)
 	rlwinm	r4,r4,0,19,17
-	mtspr	SPRN_HID2,r4
+	mtspr	SPRN_HID2_750FX,r4
 	sync
 4:
 	lwz	r4,CS_HID1(r5)
diff --git a/arch/powerpc/kvm/book3s_emulate.c b/arch/powerpc/kvm/book3s_emulate.c
index 5bbfb2eed127..de126d153328 100644
--- a/arch/powerpc/kvm/book3s_emulate.c
+++ b/arch/powerpc/kvm/book3s_emulate.c
@@ -714,7 +714,7 @@ int kvmppc_core_emulate_mtspr_pr(struct kvm_vcpu *vcpu, int sprn, ulong spr_val)
 	case SPRN_HID1:
 		to_book3s(vcpu)->hid[1] = spr_val;
 		break;
-	case SPRN_HID2:
+	case SPRN_HID2_750FX:
 		to_book3s(vcpu)->hid[2] = spr_val;
 		break;
 	case SPRN_HID2_GEKKO:
@@ -900,7 +900,7 @@ int kvmppc_core_emulate_mfspr_pr(struct kvm_vcpu *vcpu, int sprn, ulong *spr_val
 	case SPRN_HID1:
 		*spr_val = to_book3s(vcpu)->hid[1];
 		break;
-	case SPRN_HID2:
+	case SPRN_HID2_750FX:
 	case SPRN_HID2_GEKKO:
 		*spr_val = to_book3s(vcpu)->hid[2];
 		break;
diff --git a/arch/powerpc/platforms/52xx/lite5200_sleep.S b/arch/powerpc/platforms/52xx/lite5200_sleep.S
index 0b12647e7b42..0ec2522ee4ad 100644
--- a/arch/powerpc/platforms/52xx/lite5200_sleep.S
+++ b/arch/powerpc/platforms/52xx/lite5200_sleep.S
@@ -203,7 +203,8 @@ lite5200_wakeup:
 
 	/* HIDs, MSR */
 	LOAD_SPRN(HID1, 0x19)
-	LOAD_SPRN(HID2, 0x1a)
+	/* FIXME: Should this use HID2_G2_LE? */
+	LOAD_SPRN(HID2_750FX, 0x1a)
 
 
 	/* address translation is tricky (see turn_on_mmu) */
@@ -283,7 +284,8 @@ SYM_FUNC_START_LOCAL(save_regs)
 
 	SAVE_SPRN(HID0, 0x18)
 	SAVE_SPRN(HID1, 0x19)
-	SAVE_SPRN(HID2, 0x1a)
+	/* FIXME: Should this use HID2_G2_LE? */
+	SAVE_SPRN(HID2_750FX, 0x1a)
 	mfmsr	r10
 	stw	r10, (4*0x1b)(r4)
 	/*SAVE_SPRN(LR, 0x1c) have to save it before the call */
diff --git a/arch/powerpc/platforms/83xx/suspend-asm.S b/arch/powerpc/platforms/83xx/suspend-asm.S
index bc6bd4d0ae96..6a62ed6082c9 100644
--- a/arch/powerpc/platforms/83xx/suspend-asm.S
+++ b/arch/powerpc/platforms/83xx/suspend-asm.S
@@ -68,7 +68,8 @@ _GLOBAL(mpc83xx_enter_deep_sleep)
 
 	mfspr	r5, SPRN_HID0
 	mfspr	r6, SPRN_HID1
-	mfspr	r7, SPRN_HID2
+	/* FIXME: Should this use SPRN_HID2_G2_LE? */
+	mfspr	r7, SPRN_HID2_750FX
 
 	stw	r5, SS_HID+0(r3)
 	stw	r6, SS_HID+4(r3)
@@ -396,7 +397,8 @@ mpc83xx_deep_resume:
 
 	mtspr	SPRN_HID0, r5
 	mtspr	SPRN_HID1, r6
-	mtspr	SPRN_HID2, r7
+	/* FIXME: Should this use SPRN_HID2_G2_LE? */
+	mtspr	SPRN_HID2_750FX, r7
 
 	lwz	r4, SS_IABR+0(r3)
 	lwz	r5, SS_IABR+4(r3)
diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index df3567c1e93b..6c9f0888a2a7 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -120,9 +120,9 @@ static int cpu_750fx_cpu_speed(int low_speed)
 
 		/* tweak L2 for high voltage */
 		if (has_cpu_l2lve) {
-			hid2 = mfspr(SPRN_HID2);
+			hid2 = mfspr(SPRN_HID2_750FX);
 			hid2 &= ~0x2000;
-			mtspr(SPRN_HID2, hid2);
+			mtspr(SPRN_HID2_750FX, hid2);
 		}
 	}
 #ifdef CONFIG_PPC_BOOK3S_32
@@ -131,9 +131,9 @@ static int cpu_750fx_cpu_speed(int low_speed)
 	if (low_speed == 1) {
 		/* tweak L2 for low voltage */
 		if (has_cpu_l2lve) {
-			hid2 = mfspr(SPRN_HID2);
+			hid2 = mfspr(SPRN_HID2_750FX);
 			hid2 |= 0x2000;
-			mtspr(SPRN_HID2, hid2);
+			mtspr(SPRN_HID2_750FX, hid2);
 		}
 
 		/* ramping down, set voltage last */
-- 
TQ-Systems GmbH | Mühlstraße 2, Gut Delling | 82229 Seefeld, Germany
Amtsgericht München, HRB 105018
Geschäftsführer: Detlef Schneider, Rüdiger Stahl, Stefan Schneider
https://www.tq-group.com/


