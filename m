Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB734D89AE
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 17:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242178AbiCNQmu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 12:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236642AbiCNQmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 12:42:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B01443D8
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 09:40:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 615D6B80E87
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 16:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F36C340F5;
        Mon, 14 Mar 2022 16:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647276057;
        bh=yjvGnVN5b1Hkix/jGux7uLyF4VnwQ4oSEyQk6TBAZ1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdZxrnTExNTmp5oE6I8pWalzFnDiTPN2OjPmwqHKdmM+FNx36podj0geONgog0Knk
         XOmhUSCyQ150cgGTwZzV1S34zbGCuznjhiOI0RNMmbjPuhUyFBQT4QffIbz+VfDr3t
         SMyXAUkRTD3Ooi4e9wuBuxx/hxLqloCMytAAkgmWd1oxmcv+/ImNL6BAOy416W02kz
         nZtQC+7gzcWlPXIg7BwAP6YpAosNtb4dwcA0uSTfbYNFSdm1VqgsWslIn64U19a8Ow
         d3qsN6/5/wVmA3lp9EMNZ42zuMt3HNPeZST0cYl9W2LVIDgO+H2xqUIGV1sIyFWOL8
         QZgPBZlaHid3A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nTnkc-00EPS0-UH; Mon, 14 Mar 2022 16:40:55 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH 3/4] KVM: arm64: vgic-v3: Expose GICR_CTLR.RWP when disabling LPIs
Date:   Mon, 14 Mar 2022 16:40:43 +0000
Message-Id: <20220314164044.772709-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220314164044.772709-1-maz@kernel.org>
References: <20220314164044.772709-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When disabling LPIs, a guest needs to poll GICR_CTLR.RWP in order
to be sure that the write has taken effect. We so far reported it
as 0, as we didn't advertise that LPIs could be turned off the
first place.

Start tracking this state during which LPIs are being disabled,
and expose the 'in progress' state via the RWP bit.

We also take this opportunity to disallow enabling LPIs and programming
GICR_{PEND,PROP}BASER while LPI disabling is in progress, as allowed by
the architecture (UNPRED behaviour).

We don't advertise the feature to the guest yet (which is allowed by
the architecture).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c     |  2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 44 ++++++++++++++++++++----------
 arch/arm64/kvm/vgic/vgic.h         |  1 +
 include/kvm/arm_vgic.h             |  4 +--
 4 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index cc62d8a8180f..9f51d624730f 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -683,7 +683,7 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 	if (!vcpu)
 		return E_ITS_INT_UNMAPPED_INTERRUPT;
 
-	if (!vcpu->arch.vgic_cpu.lpis_enabled)
+	if (!vgic_lpis_enabled(vcpu))
 		return -EBUSY;
 
 	vgic_its_cache_translation(kvm, its, devid, eventid, ite->irq);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 186bf35078bf..a6be403996c6 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -221,6 +221,13 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 	vgic_put_irq(vcpu->kvm, irq);
 }
 
+bool vgic_lpis_enabled(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	return atomic_read(&vgic_cpu->ctlr) == GICR_CTLR_ENABLE_LPIS;
+}
+
 static unsigned long vgic_mmio_read_v3r_ctlr(struct kvm_vcpu *vcpu,
 					     gpa_t addr, unsigned int len)
 {
@@ -229,26 +236,39 @@ static unsigned long vgic_mmio_read_v3r_ctlr(struct kvm_vcpu *vcpu,
 	return vgic_cpu->lpis_enabled ? GICR_CTLR_ENABLE_LPIS : 0;
 }
 
-
 static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 				     gpa_t addr, unsigned int len,
 				     unsigned long val)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-	bool was_enabled = vgic_cpu->lpis_enabled;
+	u32 ctlr;
 
 	if (!vgic_has_its(vcpu->kvm))
 		return;
 
-	vgic_cpu->lpis_enabled = val & GICR_CTLR_ENABLE_LPIS;
+	if (!(val & GICR_CTLR_ENABLE_LPIS)) {
+		/*
+		 * Don't disable if RWP is set, as there already an
+		 * ongoing disable. Funky guest...
+		 */
+		ctlr = atomic_cmpxchg_acquire(&vgic_cpu->ctlr,
+					      GICR_CTLR_ENABLE_LPIS,
+					      GICR_CTLR_RWP);
+		if (ctlr != GICR_CTLR_ENABLE_LPIS)
+			return;
 
-	if (was_enabled && !vgic_cpu->lpis_enabled) {
 		vgic_flush_pending_lpis(vcpu);
 		vgic_its_invalidate_cache(vcpu->kvm);
-	}
+		smp_mb__before_atomic();
+		atomic_set(&vgic_cpu->ctlr, 0);
+	} else {
+		ctlr = atomic_cmpxchg_acquire(&vgic_cpu->ctlr, 0,
+					      GICR_CTLR_ENABLE_LPIS);
+		if (ctlr != 0)
+			return;
 
-	if (!was_enabled && vgic_cpu->lpis_enabled)
 		vgic_enable_lpis(vcpu);
+	}
 }
 
 static bool vgic_mmio_vcpu_rdist_is_last(struct kvm_vcpu *vcpu)
@@ -478,11 +498,10 @@ static void vgic_mmio_write_propbase(struct kvm_vcpu *vcpu,
 				     unsigned long val)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	u64 old_propbaser, propbaser;
 
 	/* Storing a value with LPIs already enabled is undefined */
-	if (vgic_cpu->lpis_enabled)
+	if (vgic_lpis_enabled(vcpu))
 		return;
 
 	do {
@@ -513,7 +532,7 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
 	u64 old_pendbaser, pendbaser;
 
 	/* Storing a value with LPIs already enabled is undefined */
-	if (vgic_cpu->lpis_enabled)
+	if (vgic_lpis_enabled(vcpu))
 		return;
 
 	do {
@@ -546,10 +565,9 @@ static void vgic_mmio_write_invlpi(struct kvm_vcpu *vcpu,
 				   gpa_t addr, unsigned int len,
 				   unsigned long val)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq;
 
-	if (!vgic_cpu->lpis_enabled)
+	if (!vgic_lpis_enabled(vcpu))
 		return;
 
 	vgic_make_rdist_busy(vcpu, true);
@@ -568,9 +586,7 @@ static void vgic_mmio_write_invall(struct kvm_vcpu *vcpu,
 				   gpa_t addr, unsigned int len,
 				   unsigned long val)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-
-	if (!vgic_cpu->lpis_enabled)
+	if (!vgic_lpis_enabled(vcpu))
 		return;
 
 	vgic_make_rdist_busy(vcpu, true);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 53581e11f7c8..1d04a900f3e3 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -308,6 +308,7 @@ static inline bool vgic_dist_overlap(struct kvm *kvm, gpa_t base, size_t size)
 		(base < d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE);
 }
 
+bool vgic_lpis_enabled(struct kvm_vcpu *vcpu);
 int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr);
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index d54bb44d6d98..401236f97cf2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -348,8 +348,8 @@ struct vgic_cpu {
 
 	/* Contains the attributes and gpa of the LPI pending tables. */
 	u64 pendbaser;
-
-	bool lpis_enabled;
+	/* GICR_CTLR.{ENABLE_LPIS,RWP} */
+	atomic_t ctlr;
 
 	/* Cache guest priority bits */
 	u32 num_pri_bits;
-- 
2.34.1

