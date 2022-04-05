Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F704F49A3
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443435AbiDEWU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573218AbiDESZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 14:25:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09233E5E
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 11:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41ABB618DC
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 18:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944ECC385A0;
        Tue,  5 Apr 2022 18:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649183026;
        bh=tNRgh36uMhTXneCtr+tsi5ywN59JVKY9S+Jo3H7DGU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSHChb4q0JZX9UjEPzJQdyUJAUj6LeYQDPJh0zyrHuLJHoHAk6pdhF/pY41q0bVes
         SoiIh3e5LP3jcJbWj5QbS/I+kdUH93T8JaPdiUT0Nip2YUeyqSrTPyWk9/5RTunQTP
         6fG8KblMwekKHGSJmwphuLLc/7cY5TkuwZd4uBUiiEeULTuv7UgJn+rb1gsLwWBg0J
         goU5rQn3jIgJvygpkyzNvSsahsiQQxGqcjlLUpYVwfzT/Ps2u2hlKirGfOowLxhAbd
         +w+sP7Yup3wikrokSQLRtfGkG14YWGIwFr4sYVxu0AR1AkqHPYrwnrw9kaGjh1dzoK
         haNJ2mbG8/alQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nbnqC-001tdH-BB; Tue, 05 Apr 2022 19:23:44 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 2/4] KVM: arm64: vgic-v3: Expose GICR_CTLR.RWP when disabling LPIs
Date:   Tue,  5 Apr 2022 19:23:25 +0100
Message-Id: <20220405182327.205520-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220405182327.205520-1-maz@kernel.org>
References: <20220405182327.205520-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com, eric.auger@redhat.com, oupton@google.com, lorenzo.pieralisi@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c     |  2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 36 ++++++++++++++++++++++--------
 arch/arm64/kvm/vgic/vgic.h         |  1 +
 include/kvm/arm_vgic.h             |  4 ++--
 4 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 089fc2ffcb43..8371c5a9639c 100644
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
index 58e40b4874f8..b5ef7e15bb66 100644
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
@@ -229,26 +236,38 @@ static unsigned long vgic_mmio_read_v3r_ctlr(struct kvm_vcpu *vcpu,
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
+		atomic_set_release(&vgic_cpu->ctlr, 0);
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
@@ -478,11 +497,10 @@ static void vgic_mmio_write_propbase(struct kvm_vcpu *vcpu,
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
@@ -513,7 +531,7 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
 	u64 old_pendbaser, pendbaser;
 
 	/* Storing a value with LPIs already enabled is undefined */
-	if (vgic_cpu->lpis_enabled)
+	if (vgic_lpis_enabled(vcpu))
 		return;
 
 	do {
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 3fd6c86a7ef3..a21e9b602ff2 100644
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
index bb30a6803d9f..fdf1c2c322e5 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -347,8 +347,8 @@ struct vgic_cpu {
 
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

