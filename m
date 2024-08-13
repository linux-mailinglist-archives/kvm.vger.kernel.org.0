Return-Path: <kvm+bounces-24009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C0D950820
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:48:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCF3B1F23F86
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 14:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B341A073A;
	Tue, 13 Aug 2024 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fgxd1MgI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9581A01A1;
	Tue, 13 Aug 2024 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560479; cv=none; b=V7vttAef7vGd2je33U8JY3vbga/aTE5++ohip69FAjHGGOsK2wwqH525J5NM6lHvm1vVAUylwrd4QRZxMyJXpqwCx60Jg2H223Y0DtozB1Ke7pPrSZs9q3CMa6goKLa5zyA0P3GhaYgskkEyCDoQvmrezginDN9OSxT+YRCbwPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560479; c=relaxed/simple;
	bh=ATetRkoABuojbU2sqycPOK9TZdZKTrv3E7DRvX/cAj8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LX9wzXde6voNxdZCWMbjvQnwGd1b6xyly5BmTU0C0i0Tg04SQNQz56lUlEU6zvjbKolRb4fx+hH3dRRZ5/InHUoKC97DVsHX3r1C/Mmw7fkI1rBlCOkLAl/QUGL17QQ0rTJ8Ee6Ran0w7Wod/FTL/8Vd7Kzk/zY4Tsct3+ilR2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fgxd1MgI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73010C4AF0F;
	Tue, 13 Aug 2024 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723560479;
	bh=ATetRkoABuojbU2sqycPOK9TZdZKTrv3E7DRvX/cAj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fgxd1MgIcHC7pfYy3t1acnCQ3Rb5NNnrhh4pqmVn6mAsAs7JxenbuBj4Dxsuj81Nu
	 MOSY0WZUg4uwYl+IfhXBK9l0rUGhdKSOviCqT2Gl/RR3jwXa8CMxxmlQ1GMW76qD+c
	 8pJj5qwYfhAZAgwFMl3wzEMGw1T9CJEkvxyJhcw9op14TY0d+9EQ1iG9hySygk/OzP
	 pzbsmcPN18zwhPJbioaOn/R70+zV5yS75cIKFT6Jn2ZIBBC23nPt6h0Zf4zIkAV7wO
	 HKENbmvgiItcEJNMCsS5kgBeN9D52G340FhXO8zMO1mgkQ4enUED9gZc5lvVji0XaE
	 lAiZQzYuFt0Ng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdsoX-003O27-NR;
	Tue, 13 Aug 2024 15:47:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 08/10] KVM: arm64: Add save/restore for PIR{,E0}_EL2
Date: Tue, 13 Aug 2024 15:47:36 +0100
Message-Id: <20240813144738.2048302-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813144738.2048302-1-maz@kernel.org>
References: <20240813144738.2048302-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Like their EL1 equivalent, the EL2-specific FEAT_S1PIE registers
are context-switched. This is made conditional on both FEAT_TCRX
and FEAT_S1PIE being adversised.

Note that this change only makes sense if read together with the
issue D22677 contained in 102105_K.a_04_en.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 7099775cd505..01551037df08 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -51,9 +51,15 @@ static void __sysreg_save_vel2_state(struct kvm_cpu_context *ctxt)
 		ctxt_sys_reg(ctxt, TTBR1_EL2)	= read_sysreg_el1(SYS_TTBR1);
 		ctxt_sys_reg(ctxt, TCR_EL2)	= read_sysreg_el1(SYS_TCR);
 
-		if (ctxt_has_tcrx(ctxt))
+		if (ctxt_has_tcrx(ctxt)) {
 			ctxt_sys_reg(ctxt, TCR2_EL2) = read_sysreg_el1(SYS_TCR2);
 
+			if (ctxt_has_s1pie(ctxt)) {
+				ctxt_sys_reg(ctxt, PIRE0_EL2) = read_sysreg_el1(SYS_PIRE0);
+				ctxt_sys_reg(ctxt, PIR_EL2) = read_sysreg_el1(SYS_PIR);
+			}
+		}
+
 		/*
 		 * The EL1 view of CNTKCTL_EL1 has a bunch of RES0 bits where
 		 * the interesting CNTHCTL_EL2 bits live. So preserve these
@@ -111,9 +117,15 @@ static void __sysreg_restore_vel2_state(struct kvm_cpu_context *ctxt)
 		write_sysreg_el1(val, SYS_TCR);
 	}
 
-	if (ctxt_has_tcrx(ctxt))
+	if (ctxt_has_tcrx(ctxt)) {
 		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR2_EL2), SYS_TCR2);
 
+		if (ctxt_has_s1pie(ctxt)) {
+			write_sysreg_el1(ctxt_sys_reg(ctxt, PIR_EL2),	SYS_PIR);
+			write_sysreg_el1(ctxt_sys_reg(ctxt, PIRE0_EL2),	SYS_PIRE0);
+		}
+	}
+
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ESR_EL2),	SYS_ESR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR0_EL2),	SYS_AFSR0);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR1_EL2),	SYS_AFSR1);
-- 
2.39.2


