Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1362A72A088
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 18:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjFIQrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 12:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjFIQrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 12:47:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D473A8C
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 09:47:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECED3659F6
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 16:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583F3C433D2;
        Fri,  9 Jun 2023 16:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686329227;
        bh=ogemMlMjuGNlm+bP0xOneJD8Naa/ebP3Sa/rriTGMmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2e6HTIbWUKJ+bDeQ3c5Im6+g0QB01iuD/3rKzsReMFlvq7Nm1kL7i4z1INPX6wid
         X4hcXWIRJKCweCPtRdzlYKlX/IFt6+r2X4aXJetWqRGkn6yUMdc/fzDve4Uirn2WUl
         xiCk9CpTHWKppXYyTotK247MbMyiuiH601kSg2n8QO2ml4RBAw/O8fqerHT3kqCHGW
         PXp8aD/5uFgy1cff47l9EJT6W262ScJM1PNimfWGcoTmPNZuYKG+Cch/5ueKMV6cUJ
         GRVKOcI4njalXPwre9ycGNQs8JcMDZAnF/UxLl0TgJS08t8bLhm70Xmk3psBgt2dzr
         i2ebmKOLLzyHg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q7esN-0048L7-ED;
        Fri, 09 Jun 2023 17:22:11 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 14/17] KVM: arm64: Program the timer traps with VHE layout in hVHE mode
Date:   Fri,  9 Jun 2023 17:21:57 +0100
Message-Id: <20230609162200.2024064-15-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609162200.2024064-1-maz@kernel.org>
References: <20230609162200.2024064-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just like the rest of the timer code, we need to shift the enable
bits around when HCR_EL2.E2H is set, which is the case in hVHE mode.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/timer-sr.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index b185ac0dbd47..3aaab20ae5b4 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -17,21 +17,24 @@ void __kvm_timer_set_cntvoff(u64 cntvoff)
 }
 
 /*
- * Should only be called on non-VHE systems.
+ * Should only be called on non-VHE or hVHE setups.
  * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
  */
 void __timer_disable_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val;
+	u64 val, shift = 0;
+
+	if (has_hvhe())
+		shift = 10;
 
 	/* Allow physical timer/counter access for the host */
 	val = read_sysreg(cnthctl_el2);
-	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
+	val |= (CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN) << shift;
 	write_sysreg(val, cnthctl_el2);
 }
 
 /*
- * Should only be called on non-VHE systems.
+ * Should only be called on non-VHE or hVHE setups.
  * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
  */
 void __timer_enable_traps(struct kvm_vcpu *vcpu)
@@ -50,5 +53,10 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 	else
 		clr |= CNTHCTL_EL1PCTEN;
 
+	if (has_hvhe()) {
+		clr <<= 10;
+		set <<= 10;
+	}
+
 	sysreg_clear_set(cnthctl_el2, clr, set);
 }
-- 
2.34.1

