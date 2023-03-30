Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03F46D0D1D
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 19:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbjC3RsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 13:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbjC3RsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 13:48:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B695CDC8
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 10:48:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14B77B829BC
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 17:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA13C433A7;
        Thu, 30 Mar 2023 17:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680198487;
        bh=DBDnymD5o2/CmBaDtepcUQsuNo8CIoohXvq7ERE1/MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VsQrSpuaa/rJUYJDzJl2Faf8cowRrdjmXDvygA7MA/grq6U07rc2Ejf7Sv7hKzhKf
         KxFK+HpwU4O1Bjx5C1cJGkQ4BPBJA5g++KqrGB7/iVrDyaJgOUSWc7j5NVrt6/sf2J
         u3WTpoci2Bi3Mo+3oH+lPFSMocmcfTpmIRiBBShfG7wwnANX9vKkwIFzs3gjuDSc7H
         +yPqnSdmdRRO0+26q7kji4063WU1PHHjNUcLMaRUjpKYKBQ5lnTuGZBDq5gEqdGU2C
         Werk2qNdypyVIw+p/2IUOOYtVyFkHjeH/li7nnXYNOXA8GOSeP9RJygyHN1WFEfCRY
         cA8FvDWkPMKZA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1phwNa-004Rpa-0p;
        Thu, 30 Mar 2023 18:48:06 +0100
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
Subject: [PATCH v4 09/20] KVM: arm64: timers: Rationalise per-vcpu timer init
Date:   Thu, 30 Mar 2023 18:47:49 +0100
Message-Id: <20230330174800.2677007-10-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330174800.2677007-1-maz@kernel.org>
References: <20230330174800.2677007-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The way we initialise our timer contexts may be satisfactory
for two timers, but will be getting pretty annoying with four.

Cleanup the whole thing by removing the code duplication and
getting rid of unused IRQ configuration elements.

Reviewed-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 73 +++++++++++++++++++-----------------
 include/kvm/arm_arch_timer.h |  1 -
 2 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 771504c79711..e46f04ed8f86 100644
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

