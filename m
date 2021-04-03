Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CF13533B6
	for <lists+kvm@lfdr.de>; Sat,  3 Apr 2021 13:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbhDCL37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Apr 2021 07:29:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231681AbhDCL34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Apr 2021 07:29:56 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DB5061243;
        Sat,  3 Apr 2021 11:29:53 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lSeTQ-005R95-1O; Sat, 03 Apr 2021 12:29:52 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com
Subject: [PATCH v2 4/9] KVM: arm64: vgic: Let an interrupt controller advertise lack of HW deactivation
Date:   Sat,  3 Apr 2021 12:29:26 +0100
Message-Id: <20210403112931.1043452-5-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210403112931.1043452-1-maz@kernel.org>
References: <20210403112931.1043452-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st, mark.rutland@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vGIC, as architected by ARM, allows a virtual interrupt to
trigger the deactivation of a physical interrupt. This allows
the following interrupt to be delivered without requiring an exit.

However, some implementations have choosen not to implement this,
meaning that we will need some unsavoury workarounds to deal with this.

On detecting such a case, taint the kernel and spit a nastygram.
We'll deal with this in later patches.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c       | 10 ++++++++++
 include/kvm/arm_vgic.h                |  3 +++
 include/linux/irqchip/arm-vgic-info.h |  2 ++
 3 files changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 00c75495fd0c..0c8637a58535 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -521,6 +521,16 @@ int kvm_vgic_hyp_init(void)
 	if (!gic_kvm_info)
 		return -ENODEV;
 
+	/*
+	 * If we get one of these oddball non-GICs, taint the kernel,
+	 * as we have no idea of how they *really* behave.
+	 */
+	if (gic_kvm_info->no_hw_deactivation) {
+		kvm_info("Non-architectural vgic, tainting kernel\n");
+		add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK);
+		kvm_vgic_global_state.no_hw_deactivation = true;
+	}
+
 	switch (gic_kvm_info->type) {
 	case GIC_V2:
 		ret = vgic_v2_probe(gic_kvm_info);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 3d74f1060bd1..7afe789194d8 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -72,6 +72,9 @@ struct vgic_global {
 	bool			has_gicv4;
 	bool			has_gicv4_1;
 
+	/* Pseudo GICv3 from outer space */
+	bool			no_hw_deactivation;
+
 	/* GIC system register CPU interface */
 	struct static_key_false gicv3_cpuif;
 
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/arm-vgic-info.h
index 0319636be928..d39d0b591c5a 100644
--- a/include/linux/irqchip/arm-vgic-info.h
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -30,6 +30,8 @@ struct gic_kvm_info {
 	bool		has_v4;
 	/* rvpeid support */
 	bool		has_v4_1;
+	/* Deactivation impared, subpar stuff */
+	bool		no_hw_deactivation;
 };
 
 #ifdef CONFIG_KVM
-- 
2.29.2

