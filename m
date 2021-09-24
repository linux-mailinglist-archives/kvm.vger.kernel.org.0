Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C997E416DAF
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 10:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244715AbhIXI13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 04:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244732AbhIXI1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 04:27:25 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 407D361214;
        Fri, 24 Sep 2021 08:25:53 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mTgWl-00ChmL-DQ; Fri, 24 Sep 2021 09:25:51 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        kernel-team@android.com
Subject: [PATCH 1/5] KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing a virtual GICv3
Date:   Fri, 24 Sep 2021 09:25:38 +0100
Message-Id: <20210924082542.2766170-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924082542.2766170-1-maz@kernel.org>
References: <20210924082542.2766170-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, christoffer.dall@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Until now, we always let ID_AA64PFR0_EL1.GIC reflect the value
visible on the host, even if we were running a GICv2-enabled VM
on a GICv3+compat host.

That's fine, but we also now have the case of a host that does not
expose ID_AA64PFR0_EL1.GIC==1 despite having a vGIC. Yes, this is
confusing. Thank you M1.

Let's go back to first principles and expose ID_AA64PFR0_EL1.GIC=1
when a GICv3 is exposed to the guest. This also hides a GICv4.1
CPU interface from the guest which has no business knowing about
the v4.1 extension.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d46e185f31e..0e8fc29df19c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1075,6 +1075,11 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3);
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
+		if (irqchip_in_kernel(vcpu->kvm) &&
+		    vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
+			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), 1);
+		}
 		break;
 	case SYS_ID_AA64PFR1_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
-- 
2.30.2

