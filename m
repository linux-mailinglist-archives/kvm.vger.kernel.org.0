Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0B341596B2
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbgBKRvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:51:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730304AbgBKRvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:51:23 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F54E20870;
        Tue, 11 Feb 2020 17:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443482;
        bh=ZVZYEbQ3L/ZhoKR/Tpg2cujpRiPoqAF6wbwuNvpBz5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+vgQctMWbpQKaRhXVd3mCvkKfXcMYMwJc0ULkPZWwrqbddICINbhfDZlZF/5IwOi
         18Hrp7e7wfBHUBx4xE4N9Dn1FUpx4S6zkouJCbb8XfwqQoqRwm+NFpt8bXxpXDIqRH
         t1Xtvgx3Ut/D43gPbyPpf2C2FBVTD0vbCLH7lmtk=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZgM-004O7k-KG; Tue, 11 Feb 2020 17:50:46 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 90/94] KVM: arm64: nv: Sync nested timer state with ARMv8.4
Date:   Tue, 11 Feb 2020 17:49:34 +0000
Message-Id: <20200211174938.27809-91-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

Emulating the ARMv8.4-NV timers is a bit odd, as the timers can
be reconfigured behind our back without the hypervisor even
noticing. In the VHE case, that's an actual regression in the
architecture...

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/kvm/arm_arch_timer.h |  3 ++-
 virt/kvm/arm/arch_timer.c    | 41 +++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/arm.c           |  7 ++++--
 3 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 3389606f3029..2442de2c4a6e 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -75,7 +75,8 @@ int kvm_timer_hyp_init(bool);
 int kvm_timer_enable(struct kvm_vcpu *vcpu);
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
-void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
+void kvm_timer_sync_nested(struct kvm_vcpu *vcpu);
+void kvm_timer_sync_user(struct kvm_vcpu *vcpu);
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
 void kvm_timer_update_run(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index f9ef86752630..b95798f81764 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -710,6 +710,45 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	set_cntvoff(0);
 }
 
+void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_ARM64
+	if (!is_hyp_ctxt(vcpu))
+		return;
+
+	/*
+	 * Guest hypervisors using ARMv8.4 enhanced nested virt support have
+	 * their EL1 timer register accesses redirected to the VNCR page.
+	 */
+	if (!vcpu_el2_e2h_is_set(vcpu)) {
+		/*
+		 * For a non-VHE guest hypervisor, we update the hardware
+		 * timer registers with the latest value written by the guest
+		 * to the VNCR page and let the hardware take care of the
+		 * rest.
+		 */
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CTL_EL0),  SYS_CNTV_CTL);
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0), SYS_CNTV_CVAL);
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CTL_EL0),  SYS_CNTP_CTL);
+		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0), SYS_CNTP_CVAL);
+	} else {
+		/*
+		 * For a VHE guest hypervisor, the emulated state (which
+		 * is stored in the VNCR page) could have been updated behind
+		 * our back, and we must reset the emulation of the timers.
+		 */
+
+		struct timer_map map;
+		get_timer_map(vcpu, &map);
+
+		soft_timer_cancel(&map.emul_vtimer->hrtimer);
+		soft_timer_cancel(&map.emul_ptimer->hrtimer);
+		timer_emulate(map.emul_vtimer);
+		timer_emulate(map.emul_ptimer);
+	}
+#endif
+}
+
 /*
  * With a userspace irqchip we have to check if the guest de-asserted the
  * timer and if so, unmask the timer irq signal on the host interrupt
@@ -728,7 +767,7 @@ static void unmask_vtimer_irq_user(struct kvm_vcpu *vcpu)
 	}
 }
 
-void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
+void kvm_timer_sync_user(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index fa73b7a464f1..e8fedbfacc2c 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -730,7 +730,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
 			if (static_branch_unlikely(&userspace_irqchip_in_use))
-				kvm_timer_sync_hwstate(vcpu);
+				kvm_timer_sync_user(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
 			local_irq_enable();
 			preempt_enable();
@@ -781,7 +781,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * timer virtual interrupt state.
 		 */
 		if (static_branch_unlikely(&userspace_irqchip_in_use))
-			kvm_timer_sync_hwstate(vcpu);
+			kvm_timer_sync_user(vcpu);
+
+		if (enhanced_nested_virt_in_use(vcpu))
+			kvm_timer_sync_nested(vcpu);
 
 		kvm_arch_vcpu_ctxsync_fp(vcpu);
 
-- 
2.20.1

