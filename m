Return-Path: <kvm+bounces-52883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2F0B0A1A4
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 13:12:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E4525879D5
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 11:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C35E2C158F;
	Fri, 18 Jul 2025 11:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R33nzHIy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4814E2BF011;
	Fri, 18 Jul 2025 11:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752837137; cv=none; b=ClnMpzHqOFIfWu8evvUnCCFL85MMTRnOqXuuIyRFrkJzutBkc2hYxSCTKXo6oI9dhSdzaPZcSscD3dVxvHYZTxK6uX6/GVqHWPfKY4CcEH5YFJXAuwQVGtFHkThTqOyFp60EGtsDf+98FN2wk9MzTqRSqRQUpB8pUuYnICRfMl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752837137; c=relaxed/simple;
	bh=24+36KjjrD0NWHFuhivqLnbkQAQ1TArPFkrRpr8pj5g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hBJS5UDfUdNCbDc5uIb+KHxvHlpFd5HPI3Mvz4wBWb0BIvb/mFV+j520SAk2Vdv9KJuVDvsM0Pjjgsn1Y/njcl+jfQ4yTnTkNIsqZkIKRsjDPv4IFAy8D4wwA8H+RA+oO36DCpUDcCNyhGlWfAZQGq8taC6gPO6ajuC5h8S6w8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R33nzHIy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF00C4CEF6;
	Fri, 18 Jul 2025 11:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752837136;
	bh=24+36KjjrD0NWHFuhivqLnbkQAQ1TArPFkrRpr8pj5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R33nzHIyLv9AcgRjbXDMPz6PgR+4A1Li7+48f5b1sAgJYu9/fWJTkOu53F9AZePSv
	 3jRSnNtZimbz4wu22en5eZD9jqnCbx5kYs+DpL0PwVw9KNzM+sTPwjMHbT/DggAbv/
	 AvnC3S1suKWCtQrtvgdtASh5w+uk3IggRNy4ocLiWQVEwDO55/++6On1RjzoWNw/XS
	 szI4BdxAbeTGEIqebNZH6JEH5K/jhpEVGaG5taxhjY2Jc3RrLh5kH+CFuiQH4iBsCn
	 UhJ5aRXpIe0X+WG5LIPfXLk2x87z/a8nA/IjHqkajkdDvNFEFljagNaxCu5Zuydao8
	 EqXL3ZWhQ3giw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ucj0g-00Gt2B-UD;
	Fri, 18 Jul 2025 12:12:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 2/4] KVM: arm64: Clarify the check for reset callback in check_sysreg_table()
Date: Fri, 18 Jul 2025 12:11:52 +0100
Message-Id: <20250718111154.104029-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250718111154.104029-1-maz@kernel.org>
References: <20250718111154.104029-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

check_sysreg_table() has a wonky 'is_32" parameter, which is really
an indication that we should enforce the presence of a reset helper.

Clean this up by naming the variable accordingly and inverting the
condition. Contrary to popular belief, system instructions don't
have a reset value (duh!), and therefore do not need to be checked
for reset (they escaped the check through luck...).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index af743494538a2..f8b10966d0c3e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4335,12 +4335,12 @@ static const struct sys_reg_desc cp15_64_regs[] = {
 };
 
 static bool check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
-			       bool is_32)
+			       bool reset_check)
 {
 	unsigned int i;
 
 	for (i = 0; i < n; i++) {
-		if (!is_32 && table[i].reg && !table[i].reset) {
+		if (reset_check && table[i].reg && !table[i].reset) {
 			kvm_err("sys_reg table %pS entry %d (%s) lacks reset\n",
 				&table[i], i, table[i].name);
 			return false;
@@ -5334,11 +5334,11 @@ int __init kvm_sys_reg_table_init(void)
 	int ret = 0;
 
 	/* Make sure tables are unique and in order. */
-	valid &= check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs), false);
-	valid &= check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs), true);
-	valid &= check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs), true);
-	valid &= check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), true);
-	valid &= check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), true);
+	valid &= check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs), true);
+	valid &= check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs), false);
+	valid &= check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs), false);
+	valid &= check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), false);
+	valid &= check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), false);
 	valid &= check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs), false);
 
 	if (!valid)
-- 
2.39.2


