Return-Path: <kvm+bounces-46472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7863FAB68E0
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 12:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8FD5463C9A
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 10:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CD0C270ED4;
	Wed, 14 May 2025 10:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uN67G47q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8D61E5B7E;
	Wed, 14 May 2025 10:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747218906; cv=none; b=G86bPEg9IV/F7ouRtSfOBCFu98xU0lGXOFkcqdJGlaXkrLO+OL3IgHPWSb38tvI2BrEo90QwubL5Vc7onRch4z1eSUU0ITh4CoFCHhIZsLGV9FbNcC6xkHmyHi5QozNFBoG6Snvs10fCDUAgvhYgVMn81RSyoWBZK5mVG3xRzrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747218906; c=relaxed/simple;
	bh=jSgGzdta8ZXQcXWfdhPT721GAmbclZgONOJn80ZUs0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yhwvg9RiQJRFiPyObbPNgKm3g2HqMo7ozFZp0q1puH89iEjDSNv5oNAbDBbRFPMIa/iDdJYr43p9/pllsSyKhb9CgVsJeq7JXuu+W8keab4Djs4LiriM9ilTD39MaZh5RfdDYHfiOuBiakNzLRyLkpnH8YrupEjjcscnCB2kz4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uN67G47q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6B7C4CEE9;
	Wed, 14 May 2025 10:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747218906;
	bh=jSgGzdta8ZXQcXWfdhPT721GAmbclZgONOJn80ZUs0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uN67G47qak7AqHbgy5SLmG6j/LQ/6794EcaPUGwNUeQkPERRDdSUofDnkoKi/fRt9
	 YeDHvF/++BtEOzlkBsjfaJ7jvz5p2g7Vq6Q9R7t8/76hxb/sPtdweheZQ6CtIrCuIs
	 fSu5ScgIMroeIwAyiutb1dM3aVXa940+K/N+Y5sUc1FXQRzTe7YR9l9mgcwMURlMAO
	 oAu9g16tPKtMuPndfRiomBFp0wNHGo39ywfpkraP7CUA58pvqqrTogv49d7wpegnR6
	 u6gQyxDBE1ejUK+M7rWF6hlmG7vd/r4kS9D0zRdQR+CB7d4suOzxRAdNLSXB7n85ob
	 HS03l7/djUTtA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uF9S4-00Eos3-9I;
	Wed, 14 May 2025 11:35:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v4 01/17] arm64: sysreg: Add layout for VNCR_EL2
Date: Wed, 14 May 2025 11:34:44 +0100
Message-Id: <20250514103501.2225951-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250514103501.2225951-1-maz@kernel.org>
References: <20250514103501.2225951-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we're about to emulate VNCR_EL2, we need its full layout.
Add it to the sysreg file.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 1 -
 arch/arm64/tools/sysreg         | 6 ++++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 2639d3633073d..b8842e092014a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -521,7 +521,6 @@
 #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
 
-#define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
 #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index bdf044c5d11b6..5a3190600a0b3 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2971,6 +2971,12 @@ Sysreg	SMCR_EL2	3	4	1	2	6
 Fields	SMCR_ELx
 EndSysreg
 
+Sysreg	VNCR_EL2	3	4	2	2	0
+Field	63:57	RESS
+Field	56:12	BADDR
+Res0	11:0
+EndSysreg
+
 Sysreg	GCSCR_EL2	3	4	2	5	0
 Fields	GCSCR_ELx
 EndSysreg
-- 
2.39.2


