Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B457E3F0B29
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 20:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhHRSlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 14:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhHRSlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 14:41:44 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56139C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:41:09 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s1-20020a17090a948100b001795fab0f86so5048668pjo.1
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xD+scnBT+0IdTxaCEWT+M7b4WeM+uY6s3ymzr0wpIrU=;
        b=XDOamdUDVTxzgoy91NR4R5K1937svZezTPcmRNRvFChxWiMpWCXBj5vtbAdtGEMk26
         7TBu0t81eUXbGwbzaQDLjL5dL+w2ezC8Y53ItdpJZvslYDnA7PCsehCL5ljF4afeAYqc
         BH4iJBbnJ5ogOjFFOztgb0mesXs3E2yt21Gbaew+a3CY38PIqfGsfyCGBz3b2A6123v9
         CHnRw5y84RdfqqgD4uCGLZGPb+JJtqpi5MH5x60oufXLoa3n9fv5YWWdFfhJOADTsQdb
         sgERAulmKSh6Q5CzSXtnc02MJShDgccMPMp7ULVGtXcuRQLwuIV/cs96Uo5L0W+ZJpGl
         7/jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xD+scnBT+0IdTxaCEWT+M7b4WeM+uY6s3ymzr0wpIrU=;
        b=F1h6eai/6l+e0zKlycBNleYRjwM0qdO1Vi0GFizKJaSKjd3yg/JXshcauC0CGHt5kP
         v6Q4xYWbiNdpbbHB6Swhjed//VXC2N5Jgxy3QSPZHbJlyPuFsvyYHyxFCTH6wI4cOHhD
         O6GjRm3NnhN5K3StPiRwqz8l7USoEaqlkbJ21AtXhlguNl62wbW4FQzwCqvA+3mDu50C
         rpYhRTZb3da/cf1zoXOsGpoVV9zUhua2Dq1gZHoDIhInxG9Z5aYnEovkivrGQbTEgOOM
         dPjUkOKnqpXvhWK+GDyPQRN9NxY0nxFFPMe1+atRUY6CmrC3T45J7j5SieoAVio9F+CU
         10gg==
X-Gm-Message-State: AOAM530M3TXusjo5uWGWE00f3id/DrP9y8QNSNeFwAJUXO2NgaHysBGT
        SHGlb+4IiKsJ1yp9R5Dei4t1GOdFZWkc
X-Google-Smtp-Source: ABdhPJz3j5oyASlGWvT7bl3fJWxHQ5lxymCMwaigmkTyurZ0vcaXcz9a3YEpDp30nvtiqYJJbAG/3JUcDknM
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:43a7:: with SMTP id
 r36mr91295pjg.1.1629312068379; Wed, 18 Aug 2021 11:41:08 -0700 (PDT)
Date:   Wed, 18 Aug 2021 18:40:57 +0000
Message-Id: <20210818184057.515187-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: KVM: arm64: vgic: Resample HW pending state on deactivation
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

When a mapped level interrupt (a timer, for example) is deactivated
by the guest, the corresponding host interrupt is equally deactivated.
However, the fate of the pending state still needs to be dealt
with in SW.

This is specially true when the interrupt was in the active+pending
state in the virtual distributor at the point where the guest
was entered. On exit, the pending state is potentially stale
(the guest may have put the interrupt in a non-pending state).

If we don't do anything, the interrupt will be spuriously injected
in the guest. Although this shouldn't have any ill effect (spurious
interrupts are always possible), we can improve the emulation by
detecting the deactivation-while-pending case and resample the
interrupt.

Reported-by: Raghavendra Rao Ananta <rananta@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 25 ++++++++++++++++++-------
 arch/arm64/kvm/vgic/vgic-v3.c | 25 ++++++++++++++++++-------
 2 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 2c580204f1dc9..3e52ea86a87ff 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -60,6 +60,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		u32 val = cpuif->vgic_lr[lr];
 		u32 cpuid, intid = val & GICH_LR_VIRTUALID;
 		struct vgic_irq *irq;
+		bool deactivated;
 
 		/* Extract the source vCPU id from the LR */
 		cpuid = val & GICH_LR_PHYSID_CPUID;
@@ -75,7 +76,8 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 
 		raw_spin_lock(&irq->irq_lock);
 
-		/* Always preserve the active bit */
+		/* Always preserve the active bit, note deactivation */
+		deactivated = irq->active && !(val & GICH_LR_ACTIVE_BIT);
 		irq->active = !!(val & GICH_LR_ACTIVE_BIT);
 
 		if (irq->active && vgic_irq_is_sgi(intid))
@@ -105,6 +107,12 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		 * device state could have changed or we simply need to
 		 * process the still pending interrupt later.
 		 *
+		 * We could also have entered the guest with the interrupt
+		 * active+pending. On the next exit, we need to re-evaluate
+		 * the pending state, as it could otherwise result in a
+		 * spurious interrupt by injecting a now potentially stale
+		 * pending state.
+		 *
 		 * If this causes us to lower the level, we have to also clear
 		 * the physical active state, since we will otherwise never be
 		 * told when the interrupt becomes asserted again.
@@ -115,12 +123,15 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		if (vgic_irq_is_mapped_level(irq)) {
 			bool resample = false;
 
-			if (val & GICH_LR_PENDING_BIT) {
-				irq->line_level = vgic_get_phys_line_level(irq);
-				resample = !irq->line_level;
-			} else if (vgic_irq_needs_resampling(irq) &&
-				   !(irq->active || irq->pending_latch)) {
-				resample = true;
+			if (unlikely(vgic_irq_needs_resampling(irq))) {
+				if (!(irq->active || irq->pending_latch))
+					resample = true;
+			} else {
+				if ((val & GICH_LR_PENDING_BIT) ||
+				    (deactivated && irq->line_level)) {
+					irq->line_level = vgic_get_phys_line_level(irq);
+					resample = !irq->line_level;
+				}
 			}
 
 			if (resample)
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 66004f61cd83d..74f9aefffd5e0 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -46,6 +46,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		u32 intid, cpuid;
 		struct vgic_irq *irq;
 		bool is_v2_sgi = false;
+		bool deactivated;
 
 		cpuid = val & GICH_LR_PHYSID_CPUID;
 		cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
@@ -68,7 +69,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 
 		raw_spin_lock(&irq->irq_lock);
 
-		/* Always preserve the active bit */
+		/* Always preserve the active bit, note deactivation */
+		deactivated = irq->active && !(val & ICH_LR_ACTIVE_BIT);
 		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
 
 		if (irq->active && is_v2_sgi)
@@ -98,6 +100,12 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		 * device state could have changed or we simply need to
 		 * process the still pending interrupt later.
 		 *
+		 * We could also have entered the guest with the interrupt
+		 * active+pending. On the next exit, we need to re-evaluate
+		 * the pending state, as it could otherwise result in a
+		 * spurious interrupt by injecting a now potentially stale
+		 * pending state.
+		 *
 		 * If this causes us to lower the level, we have to also clear
 		 * the physical active state, since we will otherwise never be
 		 * told when the interrupt becomes asserted again.
@@ -108,12 +116,15 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		if (vgic_irq_is_mapped_level(irq)) {
 			bool resample = false;
 
-			if (val & ICH_LR_PENDING_BIT) {
-				irq->line_level = vgic_get_phys_line_level(irq);
-				resample = !irq->line_level;
-			} else if (vgic_irq_needs_resampling(irq) &&
-				   !(irq->active || irq->pending_latch)) {
-				resample = true;
+			if (unlikely(vgic_irq_needs_resampling(irq))) {
+				if (!(irq->active || irq->pending_latch))
+					resample = true;
+			} else {
+				if ((val & ICH_LR_PENDING_BIT) ||
+				    (deactivated && irq->line_level)) {
+					irq->line_level = vgic_get_phys_line_level(irq);
+					resample = !irq->line_level;
+				}
 			}
 
 			if (resample)
-- 
cgit 1.2.3-1.el7

