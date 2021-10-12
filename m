Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BF042A325
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 13:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236164AbhJLLZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 07:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232665AbhJLLZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 07:25:26 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8F7560F11;
        Tue, 12 Oct 2021 11:23:24 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1maFsQ-00GEkx-Gw; Tue, 12 Oct 2021 12:23:22 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Fuad Tabba <tabba@google.com>, kernel-team@android.com
Subject: [PATCH] KVM: arm64: Fix reporting of endianess when the access originates at EL0
Date:   Tue, 12 Oct 2021 12:23:12 +0100
Message-Id: <20211012112312.1247467-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, tabba@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We currently check SCTLR_EL1.EE when computing the address of
a faulting guest access. However, the fault could have occured at
EL0, in which case the right bit to check would be SCTLR_EL1.E0E.

This is pretty unlikely to cause any issue in practice: You'd have
to have a guest with a LE EL1 and a BE EL0 (or the other way around),
and have mapped a device into the EL0 page tables.

Good luck with that!

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 1fadb5d98a36..14ee8319b1ce 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -396,7 +396,10 @@ static inline bool kvm_vcpu_is_be(struct kvm_vcpu *vcpu)
 	if (vcpu_mode_is_32bit(vcpu))
 		return !!(*vcpu_cpsr(vcpu) & PSR_AA32_E_BIT);
 
-	return !!(vcpu_read_sys_reg(vcpu, SCTLR_EL1) & (1 << 25));
+	if (vcpu_mode_priv(vcpu))
+		return !!(vcpu_read_sys_reg(vcpu, SCTLR_EL1) & SCTLR_ELx_EE);
+	else
+		return !!(vcpu_read_sys_reg(vcpu, SCTLR_EL1) & SCTLR_EL1_E0E);
 }
 
 static inline unsigned long vcpu_data_guest_to_host(struct kvm_vcpu *vcpu,
-- 
2.30.2

