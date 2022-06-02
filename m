Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E275153B528
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 10:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbiFBIal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 04:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbiFBIaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 04:30:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79940E28
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 01:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27B7BB81EE0
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 08:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC801C385A5;
        Thu,  2 Jun 2022 08:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654158635;
        bh=WV1WrOaQrOTBIk9Vla7XQXKm3dl04tZdaM3YsH6mm18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4Vpsu4E3ONL3IgQx4mpHRgqXZSdqkyrGsfhDhOcLcWnglpvh7U8wqDgL4aw2vrbC
         fRnWDHkswGOwgD7R6y1naaZCwhTGCF4Ot8UghQHlJ23i8kWFtOoP5hsor0ThaItIZn
         bc6zAz5j3ZmNR6udHXOFaDpcRU0KqPceLJx7EbuxqEBDsX4Opv+O1nvW8D9fJe8ahY
         V9HlY+YcBUcg928u7iwn8tVReYWDuS7pwUNY/jjruVooImnoU6h27UyrKj6ufWZJ8u
         7yxho6x5hl/meWd+cM/HXbbA2pL+VbrvYng56jOA5CWLU+heiSHpcXa9+mlNCofeP7
         fjFNaDWX0rh2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nwgDx-00F9Sj-0U; Thu, 02 Jun 2022 09:30:33 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     Eric Auger <eauger@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>, kernel-team@android.com
Subject: [PATCH 1/3] KVM: arm64: Don't read a HW interrupt pending state in user context
Date:   Thu,  2 Jun 2022 09:30:23 +0100
Message-Id: <20220602083025.1110433-2-maz@kernel.org>
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

Since 5bfa685e62e9 ("KVM: arm64: vgic: Read HW interrupt pending state
from the HW"), we're able to source the pending bit for an interrupt
that is stored either on the physical distributor or on a device.

However, this state is only available when the vcpu is loaded,
and is not intended to be accessed from userspace. Unfortunately,
the GICv2 emulation doesn't provide specific userspace accessors,
and we fallback with the ones that are intended for the guest,
with fatal consequences.

Add a new vgic_uaccess_read_pending() accessor for userspace
to use, build on top of the existing vgic_mmio_read_pending().

Reported-by: Eric Auger <eauger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Fixes: 5bfa685e62e9 ("KVM: arm64: vgic: Read HW interrupt pending state from the HW")
---
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |  4 ++--
 arch/arm64/kvm/vgic/vgic-mmio.c    | 19 ++++++++++++++++---
 arch/arm64/kvm/vgic/vgic-mmio.h    |  3 +++
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index 77a67e9d3d14..e070cda86e12 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -429,11 +429,11 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
 		vgic_mmio_read_pending, vgic_mmio_write_spending,
-		NULL, vgic_uaccess_write_spending, 1,
+		vgic_uaccess_read_pending, vgic_uaccess_write_spending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
 		vgic_mmio_read_pending, vgic_mmio_write_cpending,
-		NULL, vgic_uaccess_write_cpending, 1,
+		vgic_uaccess_read_pending, vgic_uaccess_write_cpending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 49837d3a3ef5..dc8c52487e47 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -226,8 +226,9 @@ int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
-				     gpa_t addr, unsigned int len)
+static unsigned long __read_pending(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len,
+				    bool is_user)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	u32 value = 0;
@@ -248,7 +249,7 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 						    IRQCHIP_STATE_PENDING,
 						    &val);
 			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
-		} else if (vgic_irq_is_mapped_level(irq)) {
+		} else if (!is_user && vgic_irq_is_mapped_level(irq)) {
 			val = vgic_get_phys_line_level(irq);
 		} else {
 			val = irq_is_pending(irq);
@@ -263,6 +264,18 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 	return value;
 }
 
+unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len)
+{
+	return __read_pending(vcpu, addr, len, false);
+}
+
+unsigned long vgic_uaccess_read_pending(struct kvm_vcpu *vcpu,
+					gpa_t addr, unsigned int len)
+{
+	return __read_pending(vcpu, addr, len, true);
+}
+
 static bool is_vgic_v2_sgi(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
 	return (vgic_irq_is_sgi(irq->intid) &&
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmio.h
index 3fa696f198a3..6082d4b66d39 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -149,6 +149,9 @@ int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
 unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 				     gpa_t addr, unsigned int len);
 
+unsigned long vgic_uaccess_read_pending(struct kvm_vcpu *vcpu,
+					gpa_t addr, unsigned int len);
+
 void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val);
-- 
2.34.1

