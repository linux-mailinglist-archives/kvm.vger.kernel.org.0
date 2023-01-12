Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539BF667261
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 13:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjALMjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 07:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjALMi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 07:38:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6F249171
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 04:38:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20EFAB81DD5
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 12:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA016C433F0;
        Thu, 12 Jan 2023 12:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673527134;
        bh=QuIuSKe9BuOyhqawV9dcZNTeA/CmLCt8kn8h7pV5oaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acgsMkEjh8QKqnh2cuwadHbb4yl8y5ty0LuiVviZKQ/oHTxgo+A/liLeGuX8Q/osi
         BGq+3UZyMVOkDcOs6XYAnibun6s16Hyt5XRxGr2zxAkzn4DV4oag1srgJqOYrMoCzj
         vDjaaAZG9YltT2s7riMaiwMgnOrOqbyFNLICKsNAilBvlgL6e0TaTWtsTPFQLocC8q
         hndLOTuVHIOMbhLoxeS2lUQpnQjaothczFaBZQL18ENylv6XonhtY4SZkVYIY6igx5
         JdqZIj51epDo3/qjjNtcEjvVJtcve+jBjscpClg4p7izek1cfPfJ7yuFP+nLOLIgWx
         Z0GEkHZeP8MfA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pFwr6-001BBa-Tz;
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
Subject: [PATCH 2/3] KVM: arm64: Reduce overhead of trapped timer sysreg accesses
Date:   Thu, 12 Jan 2023 12:38:28 +0000
Message-Id: <20230112123829.458912-3-maz@kernel.org>
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

Each read/write to a trapped timer system register results
in a whole kvm_timer_vcpu_put/load() cycle which affects all
of the timers, and a bit more.

There is no need for such a thing, and we can limit the impact
to the timer being affected, and only this one.

This drastically simplifies the emulated case, and limits the
damage for trapped accesses. This also brings some performance
back for NV.

Whilst we're at it, fix a comment that didn't quite capture why
we always set CNTVOFF_EL2 to 0 when disabling the virtual timer.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 73 ++++++++++++++++++++++++-------------
 1 file changed, 48 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 587d87aec33f..1a1d7e258aba 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -434,6 +434,11 @@ static void timer_emulate(struct arch_timer_context *ctx)
 	soft_timer_start(&ctx->hrtimer, kvm_timer_compute_delta(ctx));
 }
 
+static void set_cntvoff(u64 cntvoff)
+{
+	kvm_call_hyp(__kvm_timer_set_cntvoff, cntvoff);
+}
+
 static void timer_save_state(struct arch_timer_context *ctx)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(ctx->vcpu);
@@ -457,6 +462,22 @@ static void timer_save_state(struct arch_timer_context *ctx)
 		write_sysreg_el0(0, SYS_CNTV_CTL);
 		isb();
 
+		/*
+		 * The kernel may decide to run userspace after
+		 * calling vcpu_put, so we reset cntvoff to 0 to
+		 * ensure a consistent read between user accesses to
+		 * the virtual counter and kernel access to the
+		 * physical counter of non-VHE case.
+		 *
+		 * For VHE, the virtual counter uses a fixed virtual
+		 * offset of zero, so no need to zero CNTVOFF_EL2
+		 * register, but this is actually useful when switching
+		 * between EL1/vEL2 with NV.
+		 *
+		 * Do it unconditionally, as this is either unavoidable
+		 * or dirt cheap.
+		 */
+		set_cntvoff(0);
 		break;
 	case TIMER_PTIMER:
 		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTP_CTL));
@@ -530,6 +551,7 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 
 	switch (index) {
 	case TIMER_VTIMER:
+		set_cntvoff(timer_get_offset(ctx));
 		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTV_CVAL);
 		isb();
 		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTV_CTL);
@@ -550,11 +572,6 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 	local_irq_restore(flags);
 }
 
-static void set_cntvoff(u64 cntvoff)
-{
-	kvm_call_hyp(__kvm_timer_set_cntvoff, cntvoff);
-}
-
 static inline void set_timer_irq_phys_active(struct arch_timer_context *ctx, bool active)
 {
 	int r;
@@ -629,8 +646,6 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 		kvm_timer_vcpu_load_nogic(vcpu);
 	}
 
-	set_cntvoff(timer_get_offset(map.direct_vtimer));
-
 	kvm_timer_unblocking(vcpu);
 
 	timer_restore_state(map.direct_vtimer);
@@ -686,15 +701,6 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 
 	if (kvm_vcpu_is_blocking(vcpu))
 		kvm_timer_blocking(vcpu);
-
-	/*
-	 * The kernel may decide to run userspace after calling vcpu_put, so
-	 * we reset cntvoff to 0 to ensure a consistent read between user
-	 * accesses to the virtual counter and kernel access to the physical
-	 * counter of non-VHE case. For VHE, the virtual counter uses a fixed
-	 * virtual offset of zero, so no need to zero CNTVOFF_EL2 register.
-	 */
-	set_cntvoff(0);
 }
 
 /*
@@ -924,14 +930,22 @@ u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
 			      enum kvm_arch_timers tmr,
 			      enum kvm_arch_timer_regs treg)
 {
+	struct arch_timer_context *timer;
+	struct timer_map map;
 	u64 val;
 
+	get_timer_map(vcpu, &map);
+	timer = vcpu_get_timer(vcpu, tmr);
+
+	if (timer == map.emul_ptimer)
+		return kvm_arm_timer_read(vcpu, timer, treg);
+
 	preempt_disable();
-	kvm_timer_vcpu_put(vcpu);
+	timer_save_state(timer);
 
-	val = kvm_arm_timer_read(vcpu, vcpu_get_timer(vcpu, tmr), treg);
+	val = kvm_arm_timer_read(vcpu, timer, treg);
 
-	kvm_timer_vcpu_load(vcpu);
+	timer_restore_state(timer);
 	preempt_enable();
 
 	return val;
@@ -965,13 +979,22 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
 				enum kvm_arch_timer_regs treg,
 				u64 val)
 {
-	preempt_disable();
-	kvm_timer_vcpu_put(vcpu);
-
-	kvm_arm_timer_write(vcpu, vcpu_get_timer(vcpu, tmr), treg, val);
+	struct arch_timer_context *timer;
+	struct timer_map map;
 
-	kvm_timer_vcpu_load(vcpu);
-	preempt_enable();
+	get_timer_map(vcpu, &map);
+	timer = vcpu_get_timer(vcpu, tmr);
+	if (timer == map.emul_ptimer) {
+		soft_timer_cancel(&timer->hrtimer);
+		kvm_arm_timer_write(vcpu, timer, treg, val);
+		timer_emulate(timer);
+	} else {
+		preempt_disable();
+		timer_save_state(timer);
+		kvm_arm_timer_write(vcpu, timer, treg, val);
+		timer_restore_state(timer);
+		preempt_enable();
+	}
 }
 
 static int kvm_timer_starting_cpu(unsigned int cpu)
-- 
2.34.1

