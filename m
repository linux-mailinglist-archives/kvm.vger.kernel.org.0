Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1101C4FE281
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 15:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355904AbiDLNYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 09:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356307AbiDLNXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 09:23:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3412025C8
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 06:13:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B713A619CF
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 13:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124A3C385AD;
        Tue, 12 Apr 2022 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649769234;
        bh=oQRTKlELBR9tC/Xp7BPIS5voj097Bi1ZLaUJHVChP6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axgCf/Y+uEov9odiuV3T5IncomHJYx0lWYKa0imV7kiy3lxDKvsMKquP/kLKixmmW
         RjXKYAmBwQQGEbAsszXM80ruru3tB+KJmbHidxhbRKO8S+WS4Rh0QzJwzvoENLXLCl
         U3LFcoe/t/RV+AEm3UVNmASBzBrDqjJ8Ksls/lJrPbQyy/NZo+DxiYUajpxoJ1A01u
         BArj+3HmswBAa9z94mCkz+0O9f9Xdczppw8/SJPfpyHp8ixgUgsBtyMtf0uYlh72PL
         FXquJTYXSehRlYyV9lIyHgWLLUzn7aw3rPHnu1CtqiO4ZCWY+UNLeMPi2sgi8RKQpl
         KsLO3ObeIf07w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1neGLA-003mvX-0z; Tue, 12 Apr 2022 14:13:52 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 04/10] KVM: arm64: Introduce kvm_counter_compute_delta() helper
Date:   Tue, 12 Apr 2022 14:12:57 +0100
Message-Id: <20220412131303.504690-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220412131303.504690-1-maz@kernel.org>
References: <20220412131303.504690-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor kvm_timer_compute_delta() and extract a helper that
compute the delta (in ns) between a given timer and an arbitrary
value.

No functional change expected.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 16dda1a383a6..c92a68190f6a 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -208,18 +208,16 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
+static u64 kvm_counter_compute_delta(struct arch_timer_context *timer_ctx,
+				     u64 val)
 {
-	u64 cval, now;
-
-	cval = timer_get_cval(timer_ctx);
-	now = kvm_phys_timer_read() - timer_get_offset(timer_ctx);
+	u64 now = kvm_phys_timer_read() - timer_get_offset(timer_ctx);
 
-	if (now < cval) {
+	if (now < val) {
 		u64 ns;
 
 		ns = cyclecounter_cyc2ns(timecounter->cc,
-					 cval - now,
+					 val - now,
 					 timecounter->mask,
 					 &timecounter->frac);
 		return ns;
@@ -228,6 +226,11 @@ static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
 	return 0;
 }
 
+static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
+{
+	return kvm_counter_compute_delta(timer_ctx, timer_get_cval(timer_ctx));
+}
+
 static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
 {
 	WARN_ON(timer_ctx && timer_ctx->loaded);
-- 
2.34.1

