Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72270699722
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 15:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjBPOWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 09:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjBPOWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 09:22:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3AB4BEAB
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:21:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 187CA614B9
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA85C433D2;
        Thu, 16 Feb 2023 14:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676557310;
        bh=BiLvu1koi+ACtu1KsjIOG+fh3Cn+epIG3kzWA09oauc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4OJ2D79OBa5ver/RZnUk2A8kONWpbyz56Tnw9fvs8jQZBPjl7++8tyyIKwSfT/iS
         iUMXlOfyU2MzhKTMU37eEBopBXo75xMYJSbAKIIjpvHRlKCGBXaIMV72kGyEMsORg8
         Ioh44JLJWm253EPNLvuWu4TlooFyMJ2pznJ+BRvKf9rMPhobe2DCZpncqqSyDMF5in
         8rLIF/nWQNbSWdi6ednQXJSyeIWl4LiobEAudn5NBGrc9An9BmBOGfH93RQA0SBVad
         p25GiB5dZZ8iuak8Snixxai3XxLt3Cdx2HlAO+kpbBMMZtpFgET0Rv/ILod4Z9YAnl
         xIfGwSrMzCxyA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pSf8u-00AuwB-QZ;
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
Subject: [PATCH 07/16] KVM: arm64: timers: Allow physical offset without CNTPOFF_EL2
Date:   Thu, 16 Feb 2023 14:21:14 +0000
Message-Id: <20230216142123.2638675-8-maz@kernel.org>
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

CNTPOFF_EL2 is awesome, but it is mostly vapourware, and no publicly
available implementation has it. So for the common mortals, let's
implement the emulated version of this thing.

It means trapping accesses to the physical counter and timer, and
emulate some of it as necessary.

As for CNTPOFF_EL2, nobody sets the offset yet.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c        | 97 +++++++++++++++++++++++-------
 arch/arm64/kvm/hyp/nvhe/timer-sr.c | 18 ++++--
 2 files changed, 88 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index a6d5c556659e..444ea6dca218 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -458,6 +458,8 @@ static void timer_save_state(struct arch_timer_context *ctx)
 		goto out;
 
 	switch (index) {
+		u64 cval;
+
 	case TIMER_VTIMER:
 		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTV_CTL));
 		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTV_CVAL));
@@ -485,7 +487,12 @@ static void timer_save_state(struct arch_timer_context *ctx)
 		break;
 	case TIMER_PTIMER:
 		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTP_CTL));
-		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTP_CVAL));
+		cval = read_sysreg_el0(SYS_CNTP_CVAL);
+
+		if (!has_cntpoff())
+			cval -= timer_get_offset(ctx);
+
+		timer_set_cval(ctx, cval);
 
 		/* Disable the timer */
 		write_sysreg_el0(0, SYS_CNTP_CTL);
@@ -555,6 +562,8 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 		goto out;
 
 	switch (index) {
+		u64 cval, offset;
+
 	case TIMER_VTIMER:
 		set_cntvoff(timer_get_offset(ctx));
 		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTV_CVAL);
@@ -562,8 +571,12 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTV_CTL);
 		break;
 	case TIMER_PTIMER:
-		set_cntpoff(timer_get_offset(ctx));
-		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTP_CVAL);
+		cval = timer_get_cval(ctx);
+		offset = timer_get_offset(ctx);
+		set_cntpoff(offset);
+		if (!has_cntpoff())
+			cval += offset;
+		write_sysreg_el0(cval, SYS_CNTP_CVAL);
 		isb();
 		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTP_CTL);
 		break;
@@ -634,6 +647,62 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 		enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
 }
 
+/* If _pred is true, set bit in _set, otherwise set it in _clr */
+#define assign_clear_set_bit(_pred, _bit, _clr, _set)			\
+	do {								\
+		if (_pred)						\
+			(_set) |= (_bit);				\
+		else							\
+			(_clr) |= (_bit);				\
+	} while (0)
+
+static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
+{
+	bool tpt, tpc;
+	u64 clr, set;
+
+	/*
+	 * No trapping gets configured here with nVHE. See
+	 * __timer_enable_traps(), which is where the stuff happens.
+	 */
+	if (!has_vhe())
+		return;
+
+	/*
+	 * Our default policy is not to trap anything. As we progress
+	 * within this function, reality kicks in and we start adding
+	 * traps based on emulation requirements.
+	 */
+	tpt = tpc = false;
+
+	/*
+	 * We have two possibility to deal with a physical offset:
+	 *
+	 * - Either we have CNTPOFF (yay!) or the offset is 0:
+	 *   we let the guest freely access the HW
+	 *
+	 * - or neither of these condition apply:
+	 *   we trap accesses to the HW, but still use it
+	 *   after correcting the physical offset
+	 */
+	if (!has_cntpoff() && timer_get_offset(map->direct_ptimer))
+		tpt = tpc = true;
+
+	/*
+	/*
+	 * Now that we have collected our requirements, compute the
+	 * trap and enable bits.
+	 */
+	set = 0;
+	clr = 0;
+
+	assign_clear_set_bit(tpt, CNTHCTL_EL1PCEN << 10, set, clr);
+	assign_clear_set_bit(tpc, CNTHCTL_EL1PCTEN << 10, set, clr);
+
+	/* This only happens on VHE, so use the CNTKCTL_EL1 accessor */
+	sysreg_clear_set(cntkctl_el1, clr, set);
+}
+
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
@@ -657,9 +726,10 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	timer_restore_state(map.direct_vtimer);
 	if (map.direct_ptimer)
 		timer_restore_state(map.direct_ptimer);
-
 	if (map.emul_ptimer)
 		timer_emulate(map.emul_ptimer);
+
+	timer_set_traps(vcpu, &map);
 }
 
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
@@ -1293,27 +1363,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 }
 
 /*
- * On VHE system, we only need to configure the EL2 timer trap register once,
- * not for every world switch.
- * The host kernel runs at EL2 with HCR_EL2.TGE == 1,
- * and this makes those bits have no effect for the host kernel execution.
+ * If we have CNTPOFF, permanently set ECV to enable it.
  */
 void kvm_timer_init_vhe(void)
 {
-	/* When HCR_EL2.E2H ==1, EL1PCEN and EL1PCTEN are shifted by 10 */
-	u32 cnthctl_shift = 10;
-	u64 val;
-
-	/*
-	 * VHE systems allow the guest direct access to the EL1 physical
-	 * timer/counter.
-	 */
-	val = read_sysreg(cnthctl_el2);
-	val |= (CNTHCTL_EL1PCEN << cnthctl_shift);
-	val |= (CNTHCTL_EL1PCTEN << cnthctl_shift);
 	if (cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF))
-		val |= CNTHCTL_ECV;
-	write_sysreg(val, cnthctl_el2);
+		sysreg_clear_set(cntkctl_el1, 0, CNTHCTL_ECV);
 }
 
 static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 9072e71693ba..d644f9d5d903 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -9,6 +9,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
 
 void __kvm_timer_set_cntvoff(u64 cntvoff)
 {
@@ -35,14 +36,19 @@ void __timer_disable_traps(struct kvm_vcpu *vcpu)
  */
 void __timer_enable_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val;
+	u64 clr = 0, set = 0;
 
 	/*
 	 * Disallow physical timer access for the guest
-	 * Physical counter access is allowed
+	 * Physical counter access is allowed if no offset is enforced
+	 * or running protected (we don't offset anything in this case).
 	 */
-	val = read_sysreg(cnthctl_el2);
-	val &= ~CNTHCTL_EL1PCEN;
-	val |= CNTHCTL_EL1PCTEN;
-	write_sysreg(val, cnthctl_el2);
+	clr = CNTHCTL_EL1PCEN;
+	if (is_protected_kvm_enabled() ||
+	    !kern_hyp_va(vcpu->kvm)->arch.offsets.poffset)
+		set |= CNTHCTL_EL1PCTEN;
+	else
+		clr |= CNTHCTL_EL1PCTEN;
+
+	sysreg_clear_set(cnthctl_el2, clr, set);
 }
-- 
2.34.1

