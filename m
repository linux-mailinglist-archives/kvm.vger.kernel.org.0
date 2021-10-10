Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8C8428229
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 17:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhJJPL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 11:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231842AbhJJPLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 11:11:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC75C610D1;
        Sun, 10 Oct 2021 15:09:25 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mZaS4-00FrmD-22; Sun, 10 Oct 2021 16:09:24 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Joey Gouly <joey.gouly@arm.com>, kernel-team@android.com
Subject: [PATCH v2 5/5] KVM: arm64: vgic-v3: Align emulated cpuif LPI state machine with the pseudocode
Date:   Sun, 10 Oct 2021 16:09:10 +0100
Message-Id: <20211010150910.2911495-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010150910.2911495-1-maz@kernel.org>
References: <20211010150910.2911495-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, joey.gouly@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Having realised that a virtual LPI does transition through an active
state that does not exist on bare metal, align the CPU interface
emulation with the behaviour specified in the architecture pseudocode.

The LPIs now transition to active on IAR read, and to inactive on
EOI write. Special care is taken not to increment the EOIcount for
an LPI that isn't present in the LRs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index b3b50de496a3..20db2f281cf2 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -695,9 +695,7 @@ static void __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 		goto spurious;
 
 	lr_val &= ~ICH_LR_STATE;
-	/* No active state for LPIs */
-	if ((lr_val & ICH_LR_VIRTUAL_ID_MASK) <= VGIC_MAX_SPI)
-		lr_val |= ICH_LR_ACTIVE_BIT;
+	lr_val |= ICH_LR_ACTIVE_BIT;
 	__gic_v3_set_lr(lr_val, lr);
 	__vgic_v3_set_active_priority(lr_prio, vmcr, grp);
 	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
@@ -764,20 +762,18 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	/* Drop priority in any case */
 	act_prio = __vgic_v3_clear_highest_active_priority();
 
-	/* If EOIing an LPI, no deactivate to be performed */
-	if (vid >= VGIC_MIN_LPI)
-		return;
-
-	/* EOImode == 1, nothing to be done here */
-	if (vmcr & ICH_VMCR_EOIM_MASK)
-		return;
-
 	lr = __vgic_v3_find_active_lr(vcpu, vid, &lr_val);
 	if (lr == -1) {
-		__vgic_v3_bump_eoicount();
+		/* Do not bump EOIcount for LPIs that aren't in the LRs */
+		if (!(vid >= VGIC_MIN_LPI))
+			__vgic_v3_bump_eoicount();
 		return;
 	}
 
+	/* EOImode == 1 and not an LPI, nothing to be done here */
+	if ((vmcr & ICH_VMCR_EOIM_MASK) && !(vid >= VGIC_MIN_LPI))
+		return;
+
 	lr_prio = (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
 
 	/* If priorities or group do not match, the guest has fscked-up. */
-- 
2.30.2

