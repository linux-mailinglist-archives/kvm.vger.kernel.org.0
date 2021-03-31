Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8403464FC
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhCWQXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233150AbhCWQXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:23:08 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B937619B8;
        Tue, 23 Mar 2021 16:23:08 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lOjoA-003LOd-7E; Tue, 23 Mar 2021 16:23:06 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, kernel-team@android.com,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH] KVM: arm64: Fix CPU interface MMIO compatibility detection
Date:   Tue, 23 Mar 2021 16:23:01 +0000
Message-Id: <20210323162301.2049595-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ardb@kernel.org, kernel-team@android.com, shameerali.kolothum.thodi@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to detect whether a GICv3 CPU interface is MMIO capable,
we switch ICC_SRE_EL1.SRE to 0 and check whether it sticks.

However, this is only possible if *ALL* of the HCR_EL2 interrupt
overrides are set, and the CPU is perfectly allowed to ignore
the write to ICC_SRE_EL1 otherwise. This leads KVM to pretend
that a whole bunch of ARMv8.0 CPUs aren't MMIO-capable, and
breaks VMs that should work correctly otherwise.

Fix this by setting IMO/FMO/IMO before touching ICC_SRE_EL1,
and clear them afterwards. This allows us to reliably detect
the CPU interface capabilities.

Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Fixes: 9739f6ef053f ("KVM: arm64: Workaround firmware wrongly advertising GICv2-on-v3 compatibility")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index ee3682b9873c..39f8f7f9227c 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -429,6 +429,13 @@ u64 __vgic_v3_get_gic_config(void)
 	if (has_vhe())
 		flags = local_daif_save();
 
+	/*
+	 * Table 11-2 "Permitted ICC_SRE_ELx.SRE settings" indicates
+	 * that to be able to set ICC_SRE_EL1.SRE to 0, all the
+	 * interrupt overrides must be set. You've got to love this.
+	 */
+	sysreg_clear_set(hcr_el2, 0, HCR_AMO | HCR_FMO | HCR_IMO);
+	isb();
 	write_gicreg(0, ICC_SRE_EL1);
 	isb();
 
@@ -436,6 +443,8 @@ u64 __vgic_v3_get_gic_config(void)
 
 	write_gicreg(sre, ICC_SRE_EL1);
 	isb();
+	sysreg_clear_set(hcr_el2, HCR_AMO | HCR_FMO | HCR_IMO, 0);
+	isb();
 
 	if (has_vhe())
 		local_daif_restore(flags);
-- 
2.30.0

