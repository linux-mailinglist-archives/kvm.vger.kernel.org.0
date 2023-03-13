Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05AF36B787E
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 14:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCMNKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 09:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjCMNKv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 09:10:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A2D3346C
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 06:10:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75542612A4
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 13:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D831AC433D2;
        Mon, 13 Mar 2023 13:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678713048;
        bh=n/qfX7ce3Z08XT0Z7ir/kaLjZOmQuILg6jnYgrTIGxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EU08uvI0/A7tI9SVNeR/qRgpGu3rLxG/+hw4Et9NDBgIbZp6fA719q9U/usnXYsF0
         94OnF3xpbc3vVbpmHTBNU9CPq18xvxUuVBW5kQQIDi42Z/99ZkQ97VVxxTGWAcvqgK
         9J2F9zuyDVyf4iPnWGfu/fxqIbW7jV2Q9RQSWumjMVaa7HbE0xBnh5md180dCw6BwY
         UrIyA7/qqXyGJrhg3pUw7eliIdUOpk9TsIMo59zV14PZgVPQH6jwUVafvVWRMZmROL
         6gSQ87r8p/OK4grw/Z+DCseXYqBT+HLKic8Xw66IsYFWphOK1P+KFcd3DQ82vnapX7
         tkzgz4wKTqolw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pbhbh-00HEdE-Tm;
        Mon, 13 Mar 2023 12:48:53 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: [PATCH v2 10/19] KVM: arm64: timers: Rationalise per-vcpu timer init
Date:   Mon, 13 Mar 2023 12:48:28 +0000
Message-Id: <20230313124837.2264882-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313124837.2264882-1-maz@kernel.org>
References: <20230313124837.2264882-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
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
index 25625e1d6d89..edd851e3b169 100644
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
@@ -820,12 +815,14 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
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
@@ -840,39 +837,47 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
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
+		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
+	else
+		ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
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
-	vtimer->offset.vm_offset = &vcpu->kvm->arch.timer_data.voffset;
-	ptimer->vcpu = vcpu;
-	ptimer->offset.vm_offset = &vcpu->kvm->arch.timer_data.poffset;
+	for (int i = 0; i < NR_KVM_TIMERS; i++)
+		timer_context_init(vcpu, i);
 
 	/* Synchronize offsets across timers of a VM if not already provided */
 	if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
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
index 2dd0fd2406fb..c746ef64220b 100644
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

