Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968B0699720
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 15:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjBPOWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 09:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjBPOV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 09:21:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA9D5B87
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:21:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BE056145C
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D2BC4339E;
        Thu, 16 Feb 2023 14:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676557310;
        bh=IlGnWmN4+SnhfJAhFgF0swTA2meOHEWZPD5/uHn6VNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMMT2rwP6YMWbaOYLUYC8phZQU8N6QcmB4kq1MLj1lNLodXnGhp/yL2Wn+EwiPNpn
         Se+ILK8XR1v1kTHNLXaxsMadkq93IM4tL5HhCY+K7aXYZCpQhwi4MFhdhfymzQYgTN
         JWYjKIZLUN7fiRCwFlYjPj7Gem9ScuxtSx7zTvGpCo3AP6k3vqviuZ09O6TD6Xsqy+
         Ti2Ndyt4c5hl7r6/WS8h92yu6X5ELKJVrB42nsLHyQDUoRFqM64rWl0Nx32r93VQUr
         Hzr6EJV+tP4kG+BERjbNGcc4QqMrJIthWl6gyvVij3lAeBZvrWzmv2ncU06qFXE4ii
         hHTGfuSXWbrPg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pSf8u-00AuwB-33;
        Thu, 16 Feb 2023 14:21:48 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>, dwmw2@infradead.org
Subject: [PATCH 04/16] KVM: arm64: timers: Use a per-vcpu, per-timer accumulator for fractional ns
Date:   Thu, 16 Feb 2023 14:21:11 +0000
Message-Id: <20230216142123.2638675-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org>
References: <20230216142123.2638675-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
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

Instead of accumulating the fractionnal ns value generated everytime
we compute a ns delta in a global variable, use a per-vcpu, per-timer
variable. This keeps the fractional ns local to the timer instead of
contributing to any odd, unrelated timer.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 2 +-
 include/kvm/arm_arch_timer.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 00610477ec7b..329a8444724f 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -219,7 +219,7 @@ static u64 kvm_counter_compute_delta(struct arch_timer_context *timer_ctx,
 		ns = cyclecounter_cyc2ns(timecounter->cc,
 					 val - now,
 					 timecounter->mask,
-					 &timecounter->frac);
+					 &timer_ctx->ns_frac);
 		return ns;
 	}
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 71916de7c6c4..76174f4fb646 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -31,6 +31,7 @@ struct arch_timer_context {
 
 	/* Emulated Timer (may be unused) */
 	struct hrtimer			hrtimer;
+	u64				ns_frac;
 
 	/*
 	 * We have multiple paths which can save/restore the timer state onto
-- 
2.34.1

