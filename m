Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F9925C5E0
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgICP4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbgICP4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:56:02 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC3AA206EB;
        Thu,  3 Sep 2020 15:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599148561;
        bh=MxTISM6aCyrfQEcNTQysLq4QgrXvqcQfw2UVVj/1QTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKTN2arcW3+/OVvmAw/EsiV18c4pdfCk/A5pJMqkJHRwpBZyLRvT/ovABD5E9s2Ax
         qaFEepyGhgEym2a3LLyDX1NLS8xdOxbVqz6LFyRcagzk0yokcU4WT/g12F9bDhb4HJ
         62BzrJmdrUYvdMt7qpGdIPU3P7d6/GYU1y6vnBbk=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kDr8A-008vT9-2r; Thu, 03 Sep 2020 16:26:30 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 15/23] KVM: arm64: nVHE: Only save/restore GICv3 state if modeling a GIC
Date:   Thu,  3 Sep 2020 16:26:02 +0100
Message-Id: <20200903152610.1078827-16-maz@kernel.org>
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

If we aren't modeling a GIC, there is no need to save/restore
the GICv3 state at all. Note that this only matters for nVHE,
as VHE already has this code outside of the world switch.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 0970442d2dbc..be77eb156542 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -101,16 +101,22 @@ static void __deactivate_vm(struct kvm_vcpu *vcpu)
 /* Save VGICv3 state on non-VHE systems */
 static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
+	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
+
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) &&
+	    (irqchip_is_gic_v2(kvm) || irqchip_is_gic_v3(kvm))) {
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 	}
 }
 
-/* Restore VGICv3 state on non_VEH systems */
+/* Restore VGICv3 state on non-VHE systems */
 static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
+	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
+
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) &&
+	    (irqchip_is_gic_v2(kvm) || irqchip_is_gic_v3(kvm))) {
 		__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
 	}
-- 
2.27.0

