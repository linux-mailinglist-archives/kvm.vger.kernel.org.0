Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8A4699777
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 15:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjBPOba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 09:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjBPOb0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 09:31:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FBD474FD
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:31:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C834FB8217A
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F9AC433D2;
        Thu, 16 Feb 2023 14:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676557882;
        bh=dkpxCh6YCrlmMHF5loK4vwrPmsryuK4j+kEGb5Xnnd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZnG69ksN8Hq9z/P4pVG/VH5k5oInAglGGbkFaWOT0BgVWizPrGeLjYVSasYleote
         PQNSRIkKqiDthNf7PJ0JpyRu58gmgcIDHA+9maQJ2fsn548OfDyoeUN7LEJEmv0wtL
         F63qDJBRSEHLwOEjgdXMRcS2gxP1oSh1+u4rkfQueT0rhFpfzW8KaShIgbdIpkc3q9
         Cqpzo3BdFfNrql20m86tVQgZyYHVgNFklX/12r0SX0/B60SHW2kwecErkk3NgxLn9t
         dMi1vut5jNfLyoOLAZU5OIxKknVCfVOyIpXJ3zSuP0U9/RB184B3/shnIbDkEtrzMt
         Kglus1O/vqVOw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pSf8v-00AuwB-Gs;
        Thu, 16 Feb 2023 14:21:49 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>, dwmw2@infradead.org
Subject: [PATCH 10/16] KVM: arm64: timers: Rationalise per-vcpu timer init
Date:   Thu, 16 Feb 2023 14:21:17 +0000
Message-Id: <20230216142123.2638675-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org>
References: <20230216142123.2638675-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The way we initialise our timer contexts may be satisfactory
for two timers, but will be getting pretty annoying with four.

Cleanup the whole thing by removing the code duplication and
getting rid of unused IRQ configuration elements.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 73 +++++++++++++++++++-----------------
 include/kvm/arm_arch_timer.h |  1 -
 2 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index b04544b702f9..f968d6d3479b 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -30,14 +30,9 @@ static u32 host_ptimer_irq_flags;
 
 static DEFINE_STATIC_KEY_FALSE(has_gic_active_state);
 
-static const struct kvm_irq_level default_ptimer_irq = {
-	.irq	= 30,
-	.level	= 1,
-};
-
-static const struct kvm_irq_level default_vtimer_irq = {
-	.irq	= 27,
-	.level	= 1,
+static const u8 default_ppi[] = {
+	[TIMER_PTIMER]  = 30,
+	[TIMER_VTIMER]  = 27,
 };
 
 static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx);
@@ -821,12 +816,14 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	 * resets the timer to be disabled and unmasked and is compliant with
 	 * the ARMv7 architecture.
 	 */
-	timer_set_ctl(vcpu_vtimer(vcpu), 0);
-	timer_set_ctl(vcpu_ptimer(vcpu), 0);
+	for (int i = 0; i < NR_KVM_TIMERS; i++)
+		timer_set_ctl(vcpu_get_timer(vcpu, i), 0);
+
 
 	if (timer->enabled) {
-		kvm_timer_update_irq(vcpu, false, vcpu_vtimer(vcpu));
-		kvm_timer_update_irq(vcpu, false, vcpu_ptimer(vcpu));
+		for (int i = 0; i < NR_KVM_TIMERS; i++)
+			kvm_timer_update_irq(vcpu, false,
+					     vcpu_get_timer(vcpu, i));
 
 		if (irqchip_in_kernel(vcpu->kvm)) {
 			kvm_vgic_reset_mapped_irq(vcpu, map.direct_vtimer->irq.irq);
@@ -841,39 +838,47 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
+{
+	struct arch_timer_context *ctxt = vcpu_get_timer(vcpu, timerid);
+	struct kvm *kvm = vcpu->kvm;
+
+	ctxt->vcpu = vcpu;
+
+	if (timerid == TIMER_VTIMER)
+		ctxt->offset.vm_offset = &kvm->arch.offsets.voffset;
+	else
+		ctxt->offset.vm_offset = &kvm->arch.offsets.poffset;
+
+	hrtimer_init(&ctxt->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
+	ctxt->hrtimer.function = kvm_hrtimer_expire;
+	ctxt->irq.irq = default_ppi[timerid];
+
+	switch (timerid) {
+	case TIMER_PTIMER:
+		ctxt->host_timer_irq = host_ptimer_irq;
+		break;
+	case TIMER_VTIMER:
+		ctxt->host_timer_irq = host_vtimer_irq;
+		break;
+	}
+}
+
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
-	vtimer->vcpu = vcpu;
-	vtimer->offset.vm_offset = &vcpu->kvm->arch.offsets.voffset;
-	ptimer->vcpu = vcpu;
-	ptimer->offset.vm_offset = &vcpu->kvm->arch.offsets.poffset;
+	for (int i = 0; i < NR_KVM_TIMERS; i++)
+		timer_context_init(vcpu, i);
 
 	/* Synchronize offsets across timers of a VM if not already provided */
 	if (!test_bit(KVM_ARCH_FLAG_COUNTER_OFFSETS, &vcpu->kvm->arch.flags)) {
-		timer_set_offset(vtimer, kvm_phys_timer_read());
-		timer_set_offset(ptimer, 0);
+		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
+		timer_set_offset(vcpu_ptimer(vcpu), 0);
 	}
 
 	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
 	timer->bg_timer.function = kvm_bg_timer_expire;
-
-	hrtimer_init(&vtimer->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
-	hrtimer_init(&ptimer->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
-	vtimer->hrtimer.function = kvm_hrtimer_expire;
-	ptimer->hrtimer.function = kvm_hrtimer_expire;
-
-	vtimer->irq.irq = default_vtimer_irq.irq;
-	ptimer->irq.irq = default_ptimer_irq.irq;
-
-	vtimer->host_timer_irq = host_vtimer_irq;
-	ptimer->host_timer_irq = host_ptimer_irq;
-
-	vtimer->host_timer_irq_flags = host_vtimer_irq_flags;
-	ptimer->host_timer_irq_flags = host_ptimer_irq_flags;
 }
 
 void kvm_timer_cpu_up(void)
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 4267eeb24353..62ef4883e644 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -59,7 +59,6 @@ struct arch_timer_context {
 
 	/* Duplicated state from arch_timer.c for convenience */
 	u32				host_timer_irq;
-	u32				host_timer_irq_flags;
 };
 
 struct timer_map {
-- 
2.34.1

