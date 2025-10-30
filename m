Return-Path: <kvm+bounces-61476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 755D0C2001A
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 13:28:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D80E6461B14
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 12:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1810323406;
	Thu, 30 Oct 2025 12:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJvQnnue"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEA23195E7;
	Thu, 30 Oct 2025 12:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761827232; cv=none; b=InQajaqXXXzhW2P99r1HecMtReyDJayMdSXpy3EOhgyBT1cTkiGSmRsjmh0sAyIdehuCAdIE9Na4/ms2MLMTc2+fj/FcS/c0i0RlPBhUV6pa0MWuDVYLgOSKH6GtA/0Pc+Gx1NW6bgGd4lopJ2fBtQxpeoGdIEslXfgsUQ/PLPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761827232; c=relaxed/simple;
	bh=UfCFaVKbtSEI+V6qqF15cRQES87gXNRh87C3CkdBTRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMVSiy6/1H1Mogq/TXnDVzoXBfi5X6LW1nDi2uTXx1hRJ+UBrEeVOzVjfFWuIDudTOy04QcLqTgTWez3Ch/5L8vFcopZr5dj0xahGj46qhk6i/kSrA9D90rAyT8FDzc/zZK1se84hWLviCJ79aChOnO27equ/7ZJYgbryDZ/CsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJvQnnue; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D66EC4CEF8;
	Thu, 30 Oct 2025 12:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761827232;
	bh=UfCFaVKbtSEI+V6qqF15cRQES87gXNRh87C3CkdBTRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJvQnnue7FUq5buNg1/6/eV4HRC9c1YHZNmfzes+cB1tRQgCoaFXxqYwQhmLaT7QV
	 hePGeytRUmfXvL5Ng134peuZkqZzz0StEmn+KRzoHGyBSaFZPRl78OEOk2zaA+QJny
	 yEp9L1g26IShnWoVQKf3WJZr/W+pvYFY79bcEKn9ylqxMkTJnEBWb4jKYSSwcgNtGQ
	 Fe4XWkOyFIGyEK0vpR89xMf/+MXAYFJ+sDY3/vcGPdIGmie9Xz9o6Ee18GhDZ+L3vH
	 zreHojiP27SA9vEcttb8yZayM1Znq/cYvHY3iuD8I/8Lo15hr3Y4pwVwaWZPmWA9cL
	 ZgEWyvcaxYG6g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vERkE-00000000yNP-1KhX;
	Thu, 30 Oct 2025 12:27:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: arm64: Make all 32bit ID registers fully writable
Date: Thu, 30 Oct 2025 12:27:05 +0000
Message-ID: <20251030122707.2033690-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251030122707.2033690-1-maz@kernel.org>
References: <20251030122707.2033690-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, peter.maydell@linaro.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

32bit ID registers aren't getting much love these days, and are
often missed in updates. One of these updates broke restoring
a GICv2 guest on a GICv3 machine.

Instead of performing a piecemeal fix, just bite the bullet
and make all 32bit ID regs fully writable. KVM itself never
relies on them for anything, and if the VMM wants to mess up
the guest, so be it.

Fixes: 5cb57a1aff755 ("KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the guest")
Reported-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/sys_regs.c | 59 ++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e67eb39ddc118..ad82264c6cbe1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2595,19 +2595,23 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	.val = 0,				\
 }
 
-/* sys_reg_desc initialiser for known cpufeature ID registers */
-#define AA32_ID_SANITISED(name) {		\
-	ID_DESC(name),				\
-	.visibility = aa32_id_visibility,	\
-	.val = 0,				\
-}
-
 /* sys_reg_desc initialiser for writable ID registers */
 #define ID_WRITABLE(name, mask) {		\
 	ID_DESC(name),				\
 	.val = mask,				\
 }
 
+/*
+ * 32bit ID regs are fully writable when the guest is 32bit
+ * capable. Nothing in the KVM code should rely on 32bit features
+ * anyway, only 64bit, so let the VMM do its worse.
+ */
+#define AA32_ID_WRITABLE(name) {		\
+	ID_DESC(name),				\
+	.visibility = aa32_id_visibility,	\
+	.val = GENMASK(31, 0),			\
+}
+
 /* sys_reg_desc initialiser for cpufeature ID registers that need filtering */
 #define ID_FILTERED(sysreg, name, mask) {	\
 	ID_DESC(sysreg),				\
@@ -3128,40 +3132,39 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 mappings of the AArch32 ID registers */
 	/* CRm=1 */
-	AA32_ID_SANITISED(ID_PFR0_EL1),
-	AA32_ID_SANITISED(ID_PFR1_EL1),
+	AA32_ID_WRITABLE(ID_PFR0_EL1),
+	AA32_ID_WRITABLE(ID_PFR1_EL1),
 	{ SYS_DESC(SYS_ID_DFR0_EL1),
 	  .access = access_id_reg,
 	  .get_user = get_id_reg,
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK |
-		 ID_DFR0_EL1_CopDbg_MASK, },
+	  .val = GENMASK(31, 0) },
 	ID_HIDDEN(ID_AFR0_EL1),
-	AA32_ID_SANITISED(ID_MMFR0_EL1),
-	AA32_ID_SANITISED(ID_MMFR1_EL1),
-	AA32_ID_SANITISED(ID_MMFR2_EL1),
-	AA32_ID_SANITISED(ID_MMFR3_EL1),
+	AA32_ID_WRITABLE(ID_MMFR0_EL1),
+	AA32_ID_WRITABLE(ID_MMFR1_EL1),
+	AA32_ID_WRITABLE(ID_MMFR2_EL1),
+	AA32_ID_WRITABLE(ID_MMFR3_EL1),
 
 	/* CRm=2 */
-	AA32_ID_SANITISED(ID_ISAR0_EL1),
-	AA32_ID_SANITISED(ID_ISAR1_EL1),
-	AA32_ID_SANITISED(ID_ISAR2_EL1),
-	AA32_ID_SANITISED(ID_ISAR3_EL1),
-	AA32_ID_SANITISED(ID_ISAR4_EL1),
-	AA32_ID_SANITISED(ID_ISAR5_EL1),
-	AA32_ID_SANITISED(ID_MMFR4_EL1),
-	AA32_ID_SANITISED(ID_ISAR6_EL1),
+	AA32_ID_WRITABLE(ID_ISAR0_EL1),
+	AA32_ID_WRITABLE(ID_ISAR1_EL1),
+	AA32_ID_WRITABLE(ID_ISAR2_EL1),
+	AA32_ID_WRITABLE(ID_ISAR3_EL1),
+	AA32_ID_WRITABLE(ID_ISAR4_EL1),
+	AA32_ID_WRITABLE(ID_ISAR5_EL1),
+	AA32_ID_WRITABLE(ID_MMFR4_EL1),
+	AA32_ID_WRITABLE(ID_ISAR6_EL1),
 
 	/* CRm=3 */
-	AA32_ID_SANITISED(MVFR0_EL1),
-	AA32_ID_SANITISED(MVFR1_EL1),
-	AA32_ID_SANITISED(MVFR2_EL1),
+	AA32_ID_WRITABLE(MVFR0_EL1),
+	AA32_ID_WRITABLE(MVFR1_EL1),
+	AA32_ID_WRITABLE(MVFR2_EL1),
 	ID_UNALLOCATED(3,3),
-	AA32_ID_SANITISED(ID_PFR2_EL1),
+	AA32_ID_WRITABLE(ID_PFR2_EL1),
 	ID_HIDDEN(ID_DFR1_EL1),
-	AA32_ID_SANITISED(ID_MMFR5_EL1),
+	AA32_ID_WRITABLE(ID_MMFR5_EL1),
 	ID_UNALLOCATED(3,7),
 
 	/* AArch64 ID registers */
-- 
2.47.3


