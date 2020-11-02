Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385BB2A33CC
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 20:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgKBTQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 14:16:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgKBTQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 14:16:16 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D25C022268;
        Mon,  2 Nov 2020 19:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604344576;
        bh=/vSypgHV3ppGf3VM+3b9Uw3XIcZP+Wgme9h2xxf4rZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jeit1NMHhX4xxwzPds+AWo/WCs7knZm/wlcZzqEKKmDomnYeQkAHx89yAyZOvJgOh
         A9QTftl8eyR8VgstIFAL7SFsnPGmQ0Z0R1Oz8Dpiy2/T1LWSuzSCX8JzumwiaUuAmr
         roc9B0thDHMJ0rj+myJXbYJKk1+F1RUBByRuP1lI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kZfJO-006nxn-2w; Mon, 02 Nov 2020 19:16:14 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH 2/8] KVM: arm64: Add AArch32 mapping annotation
Date:   Mon,  2 Nov 2020 19:16:03 +0000
Message-Id: <20201102191609.265711-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102191609.265711-1-maz@kernel.org>
References: <20201102191609.265711-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to deal with the few AArch32 system registers that map to
only a particular half of their AArch64 counterpart (such as DFAR
and IFAR being colocated in FAR_EL1), let's add an optional annotation
to the sysreg descriptor structure, indicating whether a register
maps to the upper or lower 32bits of a register.

Nothing is using these annotation yet.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 5a6fc30f5989..259864c3c76b 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -27,6 +27,12 @@ struct sys_reg_desc {
 	/* Sysreg string for debug */
 	const char *name;
 
+	enum {
+		AA32_ZEROHIGH,
+		AA32_LO,
+		AA32_HI,
+	} aarch32_map;
+
 	/* MRS/MSR instruction which accesses it. */
 	u8	Op0;
 	u8	Op1;
@@ -153,6 +159,7 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
 					  const struct sys_reg_desc table[],
 					  unsigned int num);
 
+#define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x
 #define Op1(_x) 	.Op1 = _x
 #define CRn(_x)		.CRn = _x
-- 
2.28.0

