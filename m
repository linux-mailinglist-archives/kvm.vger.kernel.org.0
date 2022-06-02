Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A69D53B529
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 10:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiFBIaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 04:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiFBIai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 04:30:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E81D9A
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 01:30:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F011360F6A
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 08:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599DBC34114;
        Thu,  2 Jun 2022 08:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654158635;
        bh=BBDl5WF6w2bxB1D5KMIgF+3TJhqJQnGvdNhNstkgTN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtcnPR5MEBjYAOTxlLGq/z18WvMgZNZWC/3hofR1UqKaBj+RfqBEk1ODWsstz33kL
         SA5/wC6U8pgbGnwWjlMyMdwezwJtbhqVamBj6xMLKPg9tUw6nGu3vEn78yH5MAZOop
         imfiU+qoiCdw55ooUxgJap4N0L8HO0mSF7n4IbpxIgqS1r/r488ORV+qTJGeAqpiJU
         n6DWuF4Uu0941RDPiUvNIeUJpUEPjFCH36JGVwH9Pz6BVXJ1/vedfAf5Zg/M+ztr1C
         URnEazQHndXMegm4/KQppHYA+RnjhHfxM8q2tYqQxQG7WswLC62AyP6ir4W8yqZpaw
         DorEuumKQnmDg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nwgDx-00F9Sj-8L; Thu, 02 Jun 2022 09:30:33 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     Eric Auger <eauger@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>, kernel-team@android.com
Subject: [PATCH 2/3] KVM: arm64: Replace vgic_v3_uaccess_read_pending with vgic_uaccess_read_pending
Date:   Thu,  2 Jun 2022 09:30:24 +0100
Message-Id: <20220602083025.1110433-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220602083025.1110433-1-maz@kernel.org>
References: <20220602083025.1110433-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, eauger@redhat.com, ricarkol@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that GICv2 has a proper userspace accessor for the pending state,
switch GICv3 over to it, dropping the local version.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 40 ++----------------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index f7aa7bcd6fb8..f15e29cc63ce 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -353,42 +353,6 @@ static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static unsigned long vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
-						  gpa_t addr, unsigned int len)
-{
-	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
-	u32 value = 0;
-	int i;
-
-	/*
-	 * pending state of interrupt is latched in pending_latch variable.
-	 * Userspace will save and restore pending state and line_level
-	 * separately.
-	 * Refer to Documentation/virt/kvm/devices/arm-vgic-v3.rst
-	 * for handling of ISPENDR and ICPENDR.
-	 */
-	for (i = 0; i < len * 8; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
-		bool state = irq->pending_latch;
-
-		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
-			int err;
-
-			err = irq_get_irqchip_state(irq->host_irq,
-						    IRQCHIP_STATE_PENDING,
-						    &state);
-			WARN_ON(err);
-		}
-
-		if (state)
-			value |= (1U << i);
-
-		vgic_put_irq(vcpu->kvm, irq);
-	}
-
-	return value;
-}
-
 static int vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
 					 gpa_t addr, unsigned int len,
 					 unsigned long val)
@@ -666,7 +630,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISPENDR,
 		vgic_mmio_read_pending, vgic_mmio_write_spending,
-		vgic_v3_uaccess_read_pending, vgic_v3_uaccess_write_pending, 1,
+		vgic_uaccess_read_pending, vgic_v3_uaccess_write_pending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICPENDR,
 		vgic_mmio_read_pending, vgic_mmio_write_cpending,
@@ -750,7 +714,7 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ISPENDR0,
 		vgic_mmio_read_pending, vgic_mmio_write_spending,
-		vgic_v3_uaccess_read_pending, vgic_v3_uaccess_write_pending, 4,
+		vgic_uaccess_read_pending, vgic_v3_uaccess_write_pending, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ICPENDR0,
 		vgic_mmio_read_pending, vgic_mmio_write_cpending,
-- 
2.34.1

