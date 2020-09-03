Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEE825C5F3
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgICP5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728723AbgICP4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:56:00 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAB2020775;
        Thu,  3 Sep 2020 15:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599148560;
        bh=Zmy7IjMeRTgXirbjiJ59TU+qyqamGmOSjVIBZBkIHO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07CUHzAcH4m+iOTvLUkUCCUoc1GUB1B/Co2s6UdlcDCK8y/Of12EkqkU//5hsUsf8
         JlwLNMJR1jTVsWolMtZbaqa8oJGS8KoQUNVg1n5qHJ327TiHnR9hE2sK1eZrXcUx0N
         iEsR5rnTossPGBlrPly7fgnnTeJiwvHH1pRp96z0=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kDr89-008vT9-GE; Thu, 03 Sep 2020 16:26:29 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 14/23] KVM: arm64: Move kvm_vgic_vcpu_{sync,flush}_hwstate() to irqchip_flow
Date:   Thu,  3 Sep 2020 16:26:01 +0100
Message-Id: <20200903152610.1078827-15-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200903152610.1078827-1-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, Christoffer.Dall@arm.com, lorenzo.pieralisi@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Abstract the calls to kvm_vgic_vcpu_({sync,flush}_hwstate) via the
irqchip_flow structure.

No functional change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_irq.h | 8 ++++++++
 arch/arm64/kvm/arm.c             | 6 +++---
 arch/arm64/kvm/vgic/vgic-init.c  | 2 ++
 include/kvm/arm_vgic.h           | 2 --
 4 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_irq.h b/arch/arm64/include/asm/kvm_irq.h
index 7d888f10aabe..92aaec05ee75 100644
--- a/arch/arm64/include/asm/kvm_irq.h
+++ b/arch/arm64/include/asm/kvm_irq.h
@@ -26,6 +26,8 @@ struct kvm_irqchip_flow {
 	void (*irqchip_vcpu_put)(struct kvm_vcpu *);
 	int  (*irqchip_vcpu_pending_irq)(struct kvm_vcpu *);
 	int  (*irqchip_vcpu_first_run)(struct kvm_vcpu *);
+	void (*irqchip_vcpu_flush_hwstate)(struct kvm_vcpu *);
+	void (*irqchip_vcpu_sync_hwstate)(struct kvm_vcpu *);
 };
 
 /*
@@ -78,4 +80,10 @@ struct kvm_irqchip_flow {
 #define kvm_irqchip_vcpu_first_run(v)			\
 	__vcpu_irqchip_action_ret((v), vcpu_first_run, (v))
 
+#define kvm_irqchip_vcpu_flush_hwstate(v)		\
+	__vcpu_irqchip_action((v), vcpu_flush_hwstate, (v))
+
+#define kvm_irqchip_vcpu_sync_hwstate(v)		\
+	__vcpu_irqchip_action((v), vcpu_sync_hwstate, (v))
+
 #endif
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0db71d2a38a4..875e68514661 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -661,7 +661,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		local_irq_disable();
 
-		kvm_vgic_flush_hwstate(vcpu);
+		kvm_irqchip_vcpu_flush_hwstate(vcpu);
 
 		/*
 		 * Exit if we have a signal pending so that we can deliver the
@@ -702,7 +702,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			kvm_pmu_sync_hwstate(vcpu);
 			if (static_branch_unlikely(&userspace_irqchip_in_use))
 				kvm_timer_sync_user(vcpu);
-			kvm_vgic_sync_hwstate(vcpu);
+			kvm_irqchip_vcpu_sync_hwstate(vcpu);
 			local_irq_enable();
 			preempt_enable();
 			continue;
@@ -738,7 +738,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * the timer code needs to know if the virtual timer
 		 * interrupts are active.
 		 */
-		kvm_vgic_sync_hwstate(vcpu);
+		kvm_irqchip_vcpu_sync_hwstate(vcpu);
 
 		/*
 		 * Sync the timer hardware state before enabling interrupts as
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 8ec8064467a7..53fadbf4ca89 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -25,6 +25,8 @@ static struct kvm_irqchip_flow vgic_irqchip_flow = {
 	.irqchip_vcpu_put		= kvm_vgic_put,
 	.irqchip_vcpu_pending_irq	= kvm_vgic_vcpu_pending_irq,
 	.irqchip_vcpu_first_run		= kvm_vgic_vcpu_first_run,
+	.irqchip_vcpu_flush_hwstate	= kvm_vgic_flush_hwstate,
+	.irqchip_vcpu_sync_hwstate	= kvm_vgic_sync_hwstate,
 };
 
 /*
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index fad523007e2b..4b3a334185fa 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -350,8 +350,6 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
 #define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
 			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
 
-void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
-void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_vgic_reset_mapped_irq(struct kvm_vcpu *vcpu, u32 vintid);
 
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1);
-- 
2.27.0

