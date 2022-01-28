Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A56749F92F
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348409AbiA1MUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348433AbiA1MT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:19:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A8AC06173B
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 04:19:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C09061AF8
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73888C340E0;
        Fri, 28 Jan 2022 12:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372398;
        bh=BcakOqNxvM/st9PuJGoF+YHFup2GgF6cgj+witITG78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1qvAo8j2st/0eT3g1jiANE33emYHvpsOc9au1tIA7VsfqW/O/Nf2LZ2kkOxU2ukv
         ykL1OGPhBI/jk5SUM9/AusqRnQfl2amLxe/Fjx/aHNBA3JiO/nKPT7B46MF11PWRv+
         ScMy2azjclw3ghxZvAmuVrlVjfwI2N9Mc2EPOtumDYIMn2CkB5HneGfpT4evJwmDEa
         uuuQR5gfuJ8wlcDBZnzvzyqAtPginkWVwYgEWmD+yTkWJViN6YI27kTW2ayH5/SGbB
         l7w02MovE3fH/S81GYeYk6l3bU4IY9qECpQHtnan9Dk35j6fHU7tQc70mZ4MzQKQea
         dLTHT4Sry5gpA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQDw-003njR-2h; Fri, 28 Jan 2022 12:19:28 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 11/64] KVM: arm64: nv: Handle trapped ERET from virtual EL2
Date:   Fri, 28 Jan 2022 12:18:19 +0000
Message-Id: <20220128121912.509006-12-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

When a guest hypervisor running virtual EL2 in EL1 executes an ERET
instruction, we will have set HCR_EL2.NV which traps ERET to EL2, so
that we can emulate the exception return in software.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/esr.h     |  4 ++++
 arch/arm64/include/asm/kvm_arm.h |  2 +-
 arch/arm64/kvm/handle_exit.c     | 10 ++++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index d52a0b269ee8..3574c224889f 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -257,6 +257,10 @@
 		(((e) & ESR_ELx_SYS64_ISS_OP2_MASK) >>		\
 		 ESR_ELx_SYS64_ISS_OP2_SHIFT))
 
+/* ISS field definitions for ERET/ERETAA/ERETAB trapping */
+#define ESR_ELx_ERET_ISS_ERET		0x2
+#define ESR_ELx_ERET_ISS_ERETA		0x1
+
 /*
  * ISS field definitions for floating-point exception traps
  * (FP_EXC_32/FP_EXC_64).
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index e6e3aae87a09..5acb153a82c8 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -353,7 +353,7 @@
 	ECN(SP_ALIGN), ECN(FP_EXC32), ECN(FP_EXC64), ECN(SERROR), \
 	ECN(BREAKPT_LOW), ECN(BREAKPT_CUR), ECN(SOFTSTP_LOW), \
 	ECN(SOFTSTP_CUR), ECN(WATCHPT_LOW), ECN(WATCHPT_CUR), \
-	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64)
+	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64), ECN(ERET)
 
 #define CPACR_EL1_FPEN		(3 << 20)
 #define CPACR_EL1_TTA		(1 << 28)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 6bfb5c31cad1..2bbeed8c9786 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -171,6 +171,15 @@ static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int kvm_handle_eret(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERET)
+		return kvm_handle_ptrauth(vcpu);
+
+	kvm_emulate_nested_eret(vcpu);
+	return 1;
+}
+
 static exit_handle_fn arm_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
 	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
@@ -185,6 +194,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_SMC64]	= handle_smc,
 	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
 	[ESR_ELx_EC_SVE]	= handle_sve,
+	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
 	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
 	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
 	[ESR_ELx_EC_SOFTSTP_LOW]= kvm_handle_guest_debug,
-- 
2.30.2

