Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50341682918
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbjAaJky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbjAaJkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:40:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D3B30B09
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:40:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27E8B6147F
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B30C433D2;
        Tue, 31 Jan 2023 09:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675158046;
        bh=AEdo1QjTraKeiiK+6yLem0poWl5PLEbqaOt2rrGehMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2D6Fb/wH+F2p9hPsgJI1fXs/Pi27D5UFC6v+TcQkVqxMgLVVbck6cTxV4pXHnOtI
         X371jqiOUbHQv00VyRB02WI9WkSIYNbkxVDAQxn2j8g4QfcxmhQc+Y32kLwZQgJGsu
         G8SfCrpCIA7UBAr7+N42x+6dVdZJzi7vg36PwlWyjtZJIMIIiyl7qUKzQFtL5PjtW4
         lMohoNnBnaFk81rwyRrYNFXkHReh7QGMZewXNc/toe/rbvsuOhHjaypOOTGkQxsJUh
         7UyXBov93lH0b+3wrrLQmJY4IJO3N2ggEtXpXIWRj8HCRDUPpuyms0Bl0hJRsC4rfl
         Fw1HIHwy0CBqw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmtQ-0067U2-Tw;
        Tue, 31 Jan 2023 09:25:32 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 12/69] KVM: arm64: nv: Handle trapped ERET from virtual EL2
Date:   Tue, 31 Jan 2023 09:24:07 +0000
Message-Id: <20230131092504.2880505-13-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 206de10524e3..d4dd949b921e 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -272,6 +272,10 @@
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
index c101a611af9c..baef29fcbeee 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -345,7 +345,7 @@
 	ECN(SP_ALIGN), ECN(FP_EXC32), ECN(FP_EXC64), ECN(SERROR), \
 	ECN(BREAKPT_LOW), ECN(BREAKPT_CUR), ECN(SOFTSTP_LOW), \
 	ECN(SOFTSTP_CUR), ECN(WATCHPT_LOW), ECN(WATCHPT_CUR), \
-	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64)
+	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64), ECN(ERET)
 
 #define CPACR_EL1_DEFAULT	(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |\
 				 CPACR_EL1_ZEN_EL1EN)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 2d8c09cf3e49..e75101f2aa6c 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -207,6 +207,15 @@ static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
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
@@ -222,6 +231,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_SMC64]	= handle_smc,
 	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
 	[ESR_ELx_EC_SVE]	= handle_sve,
+	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
 	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
 	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
 	[ESR_ELx_EC_SOFTSTP_LOW]= kvm_handle_guest_debug,
-- 
2.34.1

