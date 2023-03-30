Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF3E6D0D37
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 19:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbjC3R4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 13:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbjC3R4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 13:56:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7721BB776
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 10:56:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 176CDB8233F
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 17:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD45CC433EF;
        Thu, 30 Mar 2023 17:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680198967;
        bh=aXGjfpqQud+mCxITmTYIhlbuCcXm/X86qedEc2gDtgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNepQaDfdItwmRdmG1cLtT56KyFwHnIHvJIjT9BzMSLO60Hn8puyQ9K8MzKGwrkbo
         wwdLIrqk+o0ksauJnRZtQcrqK59/tK408mGB0hC5AtBQ+5202IoCWnBNswLlbf820k
         lwGhSFjY8rdp8Bza/59N/ot4tRXKZRiDQ/W35Va4/uvi7f446MFR2zBdwGUfAYpBP/
         p0WLwxyFkR7mcs7GJvYfEZCqi6wS5Hujj4vu7yqJYAXi7lq7YCajXFkP96uj3UdxOx
         g4noUtDPgAlxFkB3I4SM6etKSh0itPdUJQWtyMGPhB9XKFJwzWHpNlqBQKK7suylg+
         dtozHevbD4aBQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1phwNa-004Rpa-9r;
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
Subject: [PATCH v4 10/20] KVM: arm64: timers: Abstract per-timer IRQ access
Date:   Thu, 30 Mar 2023 18:47:50 +0100
Message-Id: <20230330174800.2677007-11-maz@kernel.org>
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

As we are about to move the location of the per-timer IRQ into
the VM structure, abstract the location of the IRQ behind an
accessor. This will make the repainting sligntly less painful.

Reviewed-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 38 ++++++++++++++++++------------------
 include/kvm/arm_arch_timer.h |  2 ++
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index e46f04ed8f86..d08d8c2fc30d 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -392,12 +392,12 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 	int ret;
 
 	timer_ctx->irq.level = new_level;
-	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
+	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_irq(timer_ctx),
 				   timer_ctx->irq.level);
 
 	if (!userspace_irqchip(vcpu->kvm)) {
 		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
-					  timer_ctx->irq.irq,
+					  timer_irq(timer_ctx),
 					  timer_ctx->irq.level,
 					  timer_ctx);
 		WARN_ON(ret);
@@ -607,7 +607,7 @@ static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
 	kvm_timer_update_irq(ctx->vcpu, kvm_timer_should_fire(ctx), ctx);
 
 	if (irqchip_in_kernel(vcpu->kvm))
-		phys_active = kvm_vgic_map_is_active(vcpu, ctx->irq.irq);
+		phys_active = kvm_vgic_map_is_active(vcpu, timer_irq(ctx));
 
 	phys_active |= ctx->irq.level;
 
@@ -825,9 +825,9 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 					     vcpu_get_timer(vcpu, i));
 
 		if (irqchip_in_kernel(vcpu->kvm)) {
-			kvm_vgic_reset_mapped_irq(vcpu, map.direct_vtimer->irq.irq);
+			kvm_vgic_reset_mapped_irq(vcpu, timer_irq(map.direct_vtimer));
 			if (map.direct_ptimer)
-				kvm_vgic_reset_mapped_irq(vcpu, map.direct_ptimer->irq.irq);
+				kvm_vgic_reset_mapped_irq(vcpu, timer_irq(map.direct_ptimer));
 		}
 	}
 
@@ -851,7 +851,7 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
 
 	hrtimer_init(&ctxt->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
 	ctxt->hrtimer.function = kvm_hrtimer_expire;
-	ctxt->irq.irq = default_ppi[timerid];
+	timer_irq(ctxt) = default_ppi[timerid];
 
 	switch (timerid) {
 	case TIMER_PTIMER:
@@ -1295,19 +1295,19 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 	int vtimer_irq, ptimer_irq, ret;
 	unsigned long i;
 
-	vtimer_irq = vcpu_vtimer(vcpu)->irq.irq;
+	vtimer_irq = timer_irq(vcpu_vtimer(vcpu));
 	ret = kvm_vgic_set_owner(vcpu, vtimer_irq, vcpu_vtimer(vcpu));
 	if (ret)
 		return false;
 
-	ptimer_irq = vcpu_ptimer(vcpu)->irq.irq;
+	ptimer_irq = timer_irq(vcpu_ptimer(vcpu));
 	ret = kvm_vgic_set_owner(vcpu, ptimer_irq, vcpu_ptimer(vcpu));
 	if (ret)
 		return false;
 
 	kvm_for_each_vcpu(i, vcpu, vcpu->kvm) {
-		if (vcpu_vtimer(vcpu)->irq.irq != vtimer_irq ||
-		    vcpu_ptimer(vcpu)->irq.irq != ptimer_irq)
+		if (timer_irq(vcpu_vtimer(vcpu)) != vtimer_irq ||
+		    timer_irq(vcpu_ptimer(vcpu)) != ptimer_irq)
 			return false;
 	}
 
@@ -1322,9 +1322,9 @@ bool kvm_arch_timer_get_input_level(int vintid)
 	if (WARN(!vcpu, "No vcpu context!\n"))
 		return false;
 
-	if (vintid == vcpu_vtimer(vcpu)->irq.irq)
+	if (vintid == timer_irq(vcpu_vtimer(vcpu)))
 		timer = vcpu_vtimer(vcpu);
-	else if (vintid == vcpu_ptimer(vcpu)->irq.irq)
+	else if (vintid == timer_irq(vcpu_ptimer(vcpu)))
 		timer = vcpu_ptimer(vcpu);
 	else
 		BUG();
@@ -1358,7 +1358,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 
 	ret = kvm_vgic_map_phys_irq(vcpu,
 				    map.direct_vtimer->host_timer_irq,
-				    map.direct_vtimer->irq.irq,
+				    timer_irq(map.direct_vtimer),
 				    &arch_timer_irq_ops);
 	if (ret)
 		return ret;
@@ -1366,7 +1366,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	if (map.direct_ptimer) {
 		ret = kvm_vgic_map_phys_irq(vcpu,
 					    map.direct_ptimer->host_timer_irq,
-					    map.direct_ptimer->irq.irq,
+					    timer_irq(map.direct_ptimer),
 					    &arch_timer_irq_ops);
 	}
 
@@ -1391,8 +1391,8 @@ static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
 	unsigned long i;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		vcpu_vtimer(vcpu)->irq.irq = vtimer_irq;
-		vcpu_ptimer(vcpu)->irq.irq = ptimer_irq;
+		timer_irq(vcpu_vtimer(vcpu)) = vtimer_irq;
+		timer_irq(vcpu_ptimer(vcpu)) = ptimer_irq;
 	}
 }
 
@@ -1417,10 +1417,10 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
-		set_timer_irqs(vcpu->kvm, irq, ptimer->irq.irq);
+		set_timer_irqs(vcpu->kvm, irq, timer_irq(ptimer));
 		break;
 	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
-		set_timer_irqs(vcpu->kvm, vtimer->irq.irq, irq);
+		set_timer_irqs(vcpu->kvm, timer_irq(vtimer), irq);
 		break;
 	default:
 		return -ENXIO;
@@ -1446,7 +1446,7 @@ int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		return -ENXIO;
 	}
 
-	irq = timer->irq.irq;
+	irq = timer_irq(timer);
 	return put_user(irq, uaddr);
 }
 
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index c746ef64220b..27cada09f588 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -109,6 +109,8 @@ bool kvm_arch_timer_get_input_level(int vintid);
 
 #define arch_timer_ctx_index(ctx)	((ctx) - vcpu_timer((ctx)->vcpu)->timers)
 
+#define timer_irq(ctx)			((ctx)->irq.irq)
+
 u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
 			      enum kvm_arch_timers tmr,
 			      enum kvm_arch_timer_regs treg);
-- 
2.34.1

