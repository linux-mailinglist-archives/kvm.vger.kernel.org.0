Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B194F496E
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379408AbiDEWQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573219AbiDESZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 14:25:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B4CE7D
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 11:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BBBC616C5
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 18:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D4CC385A4;
        Tue,  5 Apr 2022 18:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649183026;
        bh=U2auQkSbTkjMv8plcq+RHVA7mobJyMRtrTDUW9gb13E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BF5LbHHEeo1GEy5WxaalEwOzfVK6pXwpKAZW7u4r/c2T9lla7/IQBrFU4w30jTRPf
         GfvVNt8DMWVc1ZN1Jp9T/hGre/cpkJTRIwKxx+eIG0hii3xO1pUPhKHZfuw3sLm8Uf
         lAbQMedDkRBmjf9915XY1mCu1yyMOm2y0pr/+hEgSYYPjb8EeSTFAfDnrno4H7GT6V
         5q0xoIbGrvXh7zkFwYKb6tzQUzspYP49Sq7VCvca7gQ4OZqBoq92XJXyE7roBKPXdB
         yOrNYkHnPKAiG+eWA0TwUWWWAeVpGNueLOPAiPmrcP7FAMRowvEFeSudAyjNLDETh0
         n/MN43kyK95dA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nbnqC-001tdH-Ir; Tue, 05 Apr 2022 19:23:44 +0100
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
Subject: [PATCH v2 3/4] KVM: arm64: vgic-v3: Implement MMIO-based LPI invalidation
Date:   Tue,  5 Apr 2022 19:23:26 +0100
Message-Id: <20220405182327.205520-4-maz@kernel.org>
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

Since GICv4.1, it has become legal for an implementation to advertise
GICR_{INVLPIR,INVALLR,SYNCR} while having an ITS, allowing for a more
efficient invalidation scheme (no guest command queue contention when
multiple CPUs are generating invalidations).

Provide the invalidation registers as a primitive to their ITS
counterpart. Note that we don't advertise them to the guest yet
(the architecture allows an implementation to do this).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c     | 62 ++++++++++++++++++----------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 66 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h         |  4 ++
 include/kvm/arm_vgic.h             |  1 +
 4 files changed, 112 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 8371c5a9639c..9f51d624730f 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1272,6 +1272,11 @@ static int vgic_its_cmd_handle_clear(struct kvm *kvm, struct vgic_its *its,
 	return 0;
 }
 
+int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq)
+{
+	return update_lpi_config(kvm, irq, NULL, true);
+}
+
 /*
  * The INV command syncs the configuration bits from the memory table.
  * Must be called with the its_lock mutex held.
@@ -1288,7 +1293,41 @@ static int vgic_its_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
 	if (!ite)
 		return E_ITS_INV_UNMAPPED_INTERRUPT;
 
-	return update_lpi_config(kvm, ite->irq, NULL, true);
+	return vgic_its_inv_lpi(kvm, ite->irq);
+}
+
+/**
+ * vgic_its_invall - invalidate all LPIs targetting a given vcpu
+ * @vcpu: the vcpu for which the RD is targetted by an invalidation
+ *
+ * Contrary to the INVALL command, this targets a RD instead of a
+ * collection, and we don't need to hold the its_lock, since no ITS is
+ * involved here.
+ */
+int vgic_its_invall(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	int irq_count, i = 0;
+	u32 *intids;
+
+	irq_count = vgic_copy_lpi_list(kvm, vcpu, &intids);
+	if (irq_count < 0)
+		return irq_count;
+
+	for (i = 0; i < irq_count; i++) {
+		struct vgic_irq *irq = vgic_get_irq(kvm, NULL, intids[i]);
+		if (!irq)
+			continue;
+		update_lpi_config(kvm, irq, vcpu, false);
+		vgic_put_irq(kvm, irq);
+	}
+
+	kfree(intids);
+
+	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.its_vm)
+		its_invall_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe);
+
+	return 0;
 }
 
 /*
@@ -1305,32 +1344,13 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
 	u32 coll_id = its_cmd_get_collection(its_cmd);
 	struct its_collection *collection;
 	struct kvm_vcpu *vcpu;
-	struct vgic_irq *irq;
-	u32 *intids;
-	int irq_count, i;
 
 	collection = find_collection(its, coll_id);
 	if (!its_is_collection_mapped(collection))
 		return E_ITS_INVALL_UNMAPPED_COLLECTION;
 
 	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
-
-	irq_count = vgic_copy_lpi_list(kvm, vcpu, &intids);
-	if (irq_count < 0)
-		return irq_count;
-
-	for (i = 0; i < irq_count; i++) {
-		irq = vgic_get_irq(kvm, NULL, intids[i]);
-		if (!irq)
-			continue;
-		update_lpi_config(kvm, irq, vcpu, false);
-		vgic_put_irq(kvm, irq);
-	}
-
-	kfree(intids);
-
-	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.its_vm)
-		its_invall_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe);
+	vgic_its_invall(vcpu);
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index b5ef7e15bb66..9824c773427d 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -543,6 +543,63 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
 			   pendbaser) != old_pendbaser);
 }
 
+static unsigned long vgic_mmio_read_sync(struct kvm_vcpu *vcpu,
+					 gpa_t addr, unsigned int len)
+{
+	return !!atomic_read(&vcpu->arch.vgic_cpu.syncr_busy);
+}
+
+static void vgic_set_rdist_busy(struct kvm_vcpu *vcpu, bool busy)
+{
+	if (busy) {
+		atomic_inc(&vcpu->arch.vgic_cpu.syncr_busy);
+		smp_mb__after_atomic();
+	} else {
+		smp_mb__before_atomic();
+		atomic_dec(&vcpu->arch.vgic_cpu.syncr_busy);
+	}
+}
+
+static void vgic_mmio_write_invlpi(struct kvm_vcpu *vcpu,
+				   gpa_t addr, unsigned int len,
+				   unsigned long val)
+{
+	struct vgic_irq *irq;
+
+	/*
+	 * If the guest wrote only to the upper 32bit part of the
+	 * register, drop the write on the floor, as it is only for
+	 * vPEs (which we don't support for obvious reasons).
+	 *
+	 * Also discard the access if LPIs are not enabled.
+	 */
+	if ((addr & 4) || !vgic_lpis_enabled(vcpu))
+		return;
+
+	vgic_set_rdist_busy(vcpu, true);
+
+	irq = vgic_get_irq(vcpu->kvm, NULL, lower_32_bits(val));
+	if (irq) {
+		vgic_its_inv_lpi(vcpu->kvm, irq);
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	vgic_set_rdist_busy(vcpu, false);
+}
+
+static void vgic_mmio_write_invall(struct kvm_vcpu *vcpu,
+				   gpa_t addr, unsigned int len,
+				   unsigned long val)
+{
+	/* See vgic_mmio_write_invlpi() for the early return rationale */
+	if ((addr & 4) || !vgic_lpis_enabled(vcpu))
+		return;
+
+	vgic_set_rdist_busy(vcpu, true);
+	vgic_its_invall(vcpu);
+	vgic_set_rdist_busy(vcpu, false);
+}
+
 /*
  * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
  * redistributors, while SPIs are covered by registers in the distributor
@@ -648,6 +705,15 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
 		vgic_mmio_read_pendbase, vgic_mmio_write_pendbase, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_INVLPIR,
+		vgic_mmio_read_raz, vgic_mmio_write_invlpi, 8,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_INVALLR,
+		vgic_mmio_read_raz, vgic_mmio_write_invall, 8,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_SYNCR,
+		vgic_mmio_read_sync, vgic_mmio_write_wi, 4,
+		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
 		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48,
 		VGIC_ACCESS_32bit),
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index a21e9b602ff2..1d04a900f3e3 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -318,6 +318,10 @@ void vgic_lpi_translation_cache_init(struct kvm *kvm);
 void vgic_lpi_translation_cache_destroy(struct kvm *kvm);
 void vgic_its_invalidate_cache(struct kvm *kvm);
 
+/* GICv4.1 MMIO interface */
+int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
+int vgic_its_invall(struct kvm_vcpu *vcpu);
+
 bool vgic_supports_direct_msis(struct kvm *kvm);
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index fdf1c2c322e5..401236f97cf2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -344,6 +344,7 @@ struct vgic_cpu {
 	struct vgic_io_device	rd_iodev;
 	struct vgic_redist_region *rdreg;
 	u32 rdreg_index;
+	atomic_t syncr_busy;
 
 	/* Contains the attributes and gpa of the LPI pending tables. */
 	u64 pendbaser;
-- 
2.34.1

