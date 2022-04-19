Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D6D507933
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 20:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357284AbiDSShN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 14:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357360AbiDSSgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 14:36:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D114C409
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 11:28:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8491B81974
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A47AC385AD;
        Tue, 19 Apr 2022 18:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392887;
        bh=oQRTKlELBR9tC/Xp7BPIS5voj097Bi1ZLaUJHVChP6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TF8faUVZT0u497DD2Zekw5VWwkmz3xK65im8zkVNqc01O0B4v4tEjgyOJemeb+toS
         FTwRfab30eD+dvOJ4ycpeTcmMjIjF6ulen1RYMcL1Q7GIOct9H7uvlJTyBrhRaWl1B
         7Uuki1UUTymopsirV+x2Hwr3LzZiUKbsRNFFdl/MjsVXlyktuzy1YWs3NGT6N/Ib64
         9BKfuPtyOEzXXZYm+nUMhVJjF4OM/oqRpznegmDfBooLBOjvKe0OcUqq83DUlI2JVS
         iprkJsh5HA/TqeYb8FR69pKusyWgeVt8hFLzkt9o+qFmyd94afyQkUqzGw2Nzm2rIE
         v9nY1QVaXaZZA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1ngsa5-005QYF-6B; Tue, 19 Apr 2022 19:28:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, kernel-team@android.com
Subject: [PATCH v2 04/10] KVM: arm64: Introduce kvm_counter_compute_delta() helper
Date:   Tue, 19 Apr 2022 19:27:49 +0100
Message-Id: <20220419182755.601427-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419182755.601427-1-maz@kernel.org>
References: <20220419182755.601427-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, joey.gouly@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

