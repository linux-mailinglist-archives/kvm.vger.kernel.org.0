Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20CC1667260
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 13:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjALMjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 07:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjALMi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 07:38:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A65B4916B
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 04:38:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AA84B81E5E
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 12:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B71C433F1;
        Thu, 12 Jan 2023 12:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673527134;
        bh=kutdzrND1pid6FPUYt9eecsxom0FpIqL/qLgOv8lCl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TED+bZMqOLy54eykQ0yuNM2Wt30FHtUyr64JzcKaM9YYOVthRasNEAoKqAjf+LVxV
         sGvjKsScjNDNRkHVJMI9J18zK394OBFvxqf6UUVxM7ema50HICVOLJrYHYBoTEKIJr
         vU0anSZHrY+xH0I36bHeK+GZu4OE8J/C8vER2AkIm2IBQ4NDBLMwp0cPH06qAz1tea
         RrS98p6yEJGryzeCMiROEhr3pcFSk9gakHvKAUuzGVdYTzroNUJIKxVuaHifndfCD/
         Rl7+Kjg34lHFEFva+u1asWFpMC7lk9usTJlWYKaeC/yjq7gVaH8C9lDLzYRl392huM
         c1iHwcPopZ9Aw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pFwr6-001BBa-N4;
        Thu, 12 Jan 2023 12:38:52 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org
Cc:     D Scott Phillips <scott@os.amperecomputing.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/3] KVM: arm64: Don't arm a hrtimer for an already pending timer
Date:   Thu, 12 Jan 2023 12:38:27 +0000
Message-Id: <20230112123829.458912-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112123829.458912-1-maz@kernel.org>
References: <20230112123829.458912-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, scott@os.amperecomputing.com, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

When fully emulating a timer, we back it with a hrtimer that is
armver on vcpu_load(). However, we do this even if the timer is
already pending.

This causes spurious interrupts to be taken, though the guest
doesn't observe them (the interrupt is already pending).

Although this is a waste of precious cycles, this isn't the
end of the world with the current state of KVM. However, this
can lead to a situation where a guest doesn't make forward
progress anymore with NV.

Fix it by checking that if the timer is already pending
before arming a new hrtimer. Also drop the hrtimer cancelling,
which is useless, by construction.

Reported-by: D Scott Phillips <scott@os.amperecomputing.com>
Fixes: bee038a67487 ("KVM: arm/arm64: Rework the timer code to use a timer_map")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index bb24a76b4224..587d87aec33f 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -428,10 +428,8 @@ static void timer_emulate(struct arch_timer_context *ctx)
 	 * scheduled for the future.  If the timer cannot fire at all,
 	 * then we also don't need a soft timer.
 	 */
-	if (!kvm_timer_irq_can_fire(ctx)) {
-		soft_timer_cancel(&ctx->hrtimer);
+	if (should_fire || !kvm_timer_irq_can_fire(ctx))
 		return;
-	}
 
 	soft_timer_start(&ctx->hrtimer, kvm_timer_compute_delta(ctx));
 }
-- 
2.34.1

