Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA63428225
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 17:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhJJPLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 11:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232516AbhJJPLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 11:11:23 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F02C260F6E;
        Sun, 10 Oct 2021 15:09:24 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mZaS3-00FrmD-4y; Sun, 10 Oct 2021 16:09:23 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Joey Gouly <joey.gouly@arm.com>, kernel-team@android.com
Subject: [PATCH v2 2/5] KVM: arm64: vgic-v3: Work around GICv3 locally generated SErrors
Date:   Sun, 10 Oct 2021 16:09:07 +0100
Message-Id: <20211010150910.2911495-3-maz@kernel.org>
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

The infamous M1 has a feature nobody else ever implemented,
in the form of the "GIC locally generated SError interrupts",
also known as SEIS for short.

These SErrors are generated when a guest does something that violates
the GIC state machine. It would have been simpler to just *ignore*
the damned thing, but that's not what this HW does. Oh well.

This part of of the architecture is also amazingly under-specified.
There is a whole 10 lines that describe the feature in a spec that
is 930 pages long, and some of these lines are factually wrong.
Oh, and it is deprecated, so the insentive to clarify it is low.

Now, the spec says that this should be a *virtual* SError when
HCR_EL2.AMO is set. As it turns out, that's not always the case
on this CPU, and the SError sometimes fires on the host as a
physical SError. Goodbye, cruel world. This clearly is a HW bug,
and it means that a guest can easily take the host down, on demand.

Thankfully, we have seen systems that were just as broken in the
past, and we have the perfect vaccine for it.

Apple M1, please meet the Cavium ThunderX workaround. All your
GIC accesses will be trapped, sanitised, and emulated. Only the
signalling aspect of the HW will be used. It won't be super speedy,
but it will at least be safe. You're most welcome.

Given that this has only ever been seen on this single implementation,
that the spec is unclear at best and that we cannot trust it to ever
be implemented correctly, gate the workaround solely on ICH_VTR_EL2.SEIS
being set.

Tested-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 21a6207fb2ee..ae59e2580bf5 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -671,6 +671,14 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 		group1_trap = true;
 	}
 
+	if (kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK) {
+		kvm_info("GICv3 with locally generated SEI\n");
+
+		group0_trap = true;
+		group1_trap = true;
+		common_trap = true;
+	}
+
 	if (group0_trap || group1_trap || common_trap) {
 		kvm_info("GICv3 sysreg trapping enabled ([%s%s%s], reduced performance)\n",
 			 group0_trap ? "G0" : "",
-- 
2.30.2

