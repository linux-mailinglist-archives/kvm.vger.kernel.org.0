Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9168B605AEF
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiJTJQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiJTJQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:16:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0F81BE410
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:16:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A908B826AD
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5829C433D7;
        Thu, 20 Oct 2022 09:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666257401;
        bh=3UxipA3fUndbyMhU66PV9SVzAL9vSse9sjm0ZKv3n0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5gYd3isuT46pK01Hv3XBUd9AI69TE/tQb5/fsIwaZC6uc0z47hLtsYfOKz75OXBV
         guzyJ0vuD9Tfl5cnnnQ3n/WjsVwIo463cBu1M+nH7ivYzvAXDSx4jkQDp4kLrbJYbp
         RZTIN/CersEUlMxXuABUVxWM2gtQRbnGqGiTqYawQW026rdVA6qWqw2aHC9whwXIYt
         Wa20A2wrC5bFi1IlF3xYUMPzhKh04SbOkiE1KvALYHzpPfHhz3DgnVJiGNbZJytuaZ
         BusEtPp4agaNKM9VYQTCOyxWQMk2o188gOJXuZ6vFdO7E5uhZ6CVsZtDUTDFZDbWYB
         jQQzS5GUDPmkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1olRWc-000Buf-4L;
        Thu, 20 Oct 2022 10:07:38 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH 14/17] KVM: arm64: Program the timer traps with VHE layout in hVHE mode
Date:   Thu, 20 Oct 2022 10:07:24 +0100
Message-Id: <20221020090727.3669908-15-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just like the rest of the timer code, we need to shift the enable
bits around when HCR_EL2.E2H is set, which is the case in hVHE mode.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/timer-sr.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 9072e71693ba..143cdc1d107f 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -16,33 +16,39 @@ void __kvm_timer_set_cntvoff(u64 cntvoff)
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
 {
-	u64 val;
+	u64 val, shift = 0;
 
 	/*
 	 * Disallow physical timer access for the guest
 	 * Physical counter access is allowed
 	 */
+	if (has_hvhe())
+		shift = 10;
+
 	val = read_sysreg(cnthctl_el2);
-	val &= ~CNTHCTL_EL1PCEN;
-	val |= CNTHCTL_EL1PCTEN;
+	val &= ~(CNTHCTL_EL1PCEN << shift);
+	val |= CNTHCTL_EL1PCTEN << shift;
 	write_sysreg(val, cnthctl_el2);
 }
-- 
2.34.1

