Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5314D462372
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 22:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhK2Vly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 16:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbhK2Vjw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 16:39:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA08C091D35
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:07:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BC69DCE167D
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CECC53FC7;
        Mon, 29 Nov 2021 20:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216446;
        bh=++qy0lG1eKiHd1cXmJ9EfdurXim5AWnrzLZyRWTE+Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvtHfOncWUdrGjxvIKIH0RoktARrxLEAVhK6MEpXR9lh9qMefdUbwFKHZVRaBuBvh
         oMIW6w6AiW5grG8RnaJWq47YsZdIUZJf0XrXY/X3Wru4HzQ6qwgx2Cytg26VPj1F1p
         gAvAdHYVoyx5hetH/3x+nZGaUoVvLHuY4Hc7B1L2+Fv2CP9P8RyHniseSbj2fII7jO
         2UnS33Ji6JZtKXUOb9d/JJdPHbRgo23QSrfhcd0xM8wqjcEbMl573lHlPvJrgljhWi
         MycyYF3s2ZnI7qU4yyJGcHBlNXkp6YlKVu53vfokDWDHa1aK0r2WJFcjX8HmnKI2/5
         7dy1hy3ZjMVvA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqx-008gvR-Kt; Mon, 29 Nov 2021 20:02:19 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 32/69] KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2
Date:   Mon, 29 Nov 2021 20:01:13 +0000
Message-Id: <20211129200150.351436-33-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

With HCR_EL2.NV bit set, accesses to EL12 registers in the virtual EL2
trap to EL2. Handle those traps just like we do for EL1 registers.

One exception is CNTKCTL_EL12. We don't trap on CNTKCTL_EL1 for non-VHE
virtual EL2 because we don't have to. However, accessing CNTKCTL_EL12
will trap since it's one of the EL12 registers controlled by HCR_EL2.NV
bit.  Therefore, add a handler for it and don't treat it as a
non-trap-registers when preparing a shadow context.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 511e06b6f603..692cade54caf 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2214,6 +2214,23 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CNTVOFF_EL2), access_rw, reset_val, CNTVOFF_EL2, 0 },
 	{ SYS_DESC(SYS_CNTHCTL_EL2), access_rw, reset_val, CNTHCTL_EL2, 0 },
 
+	{ SYS_DESC(SYS_SCTLR_EL12), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
+	{ SYS_DESC(SYS_CPACR_EL12), access_rw, reset_val, CPACR_EL1, 0 },
+	{ SYS_DESC(SYS_TTBR0_EL12), access_vm_reg, reset_unknown, TTBR0_EL1 },
+	{ SYS_DESC(SYS_TTBR1_EL12), access_vm_reg, reset_unknown, TTBR1_EL1 },
+	{ SYS_DESC(SYS_TCR_EL12), access_vm_reg, reset_val, TCR_EL1, 0 },
+	{ SYS_DESC(SYS_SPSR_EL12), access_spsr},
+	{ SYS_DESC(SYS_ELR_EL12), access_elr},
+	{ SYS_DESC(SYS_AFSR0_EL12), access_vm_reg, reset_unknown, AFSR0_EL1 },
+	{ SYS_DESC(SYS_AFSR1_EL12), access_vm_reg, reset_unknown, AFSR1_EL1 },
+	{ SYS_DESC(SYS_ESR_EL12), access_vm_reg, reset_unknown, ESR_EL1 },
+	{ SYS_DESC(SYS_FAR_EL12), access_vm_reg, reset_unknown, FAR_EL1 },
+	{ SYS_DESC(SYS_MAIR_EL12), access_vm_reg, reset_unknown, MAIR_EL1 },
+	{ SYS_DESC(SYS_AMAIR_EL12), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
+	{ SYS_DESC(SYS_VBAR_EL12), access_rw, reset_val, VBAR_EL1, 0 },
+	{ SYS_DESC(SYS_CONTEXTIDR_EL12), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
+	{ SYS_DESC(SYS_CNTKCTL_EL12), access_rw, reset_val, CNTKCTL_EL1, 0 },
+
 	{ SYS_DESC(SYS_SP_EL2), NULL, reset_unknown, SP_EL2 },
 };
 
-- 
2.30.2

