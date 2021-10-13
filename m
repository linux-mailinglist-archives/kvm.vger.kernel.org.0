Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B493542BF6F
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 14:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhJMMGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 08:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232357AbhJMMGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 08:06:03 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 821616109E;
        Wed, 13 Oct 2021 12:04:00 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1maczG-00GTgY-NZ; Wed, 13 Oct 2021 13:03:58 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        drjones@redhat.com, oupton@google.com, qperret@google.com,
        kernel-team@android.com, tabba@google.com
Subject: [PATCH v9 14/22] KVM: arm64: pkvm: Make the ERR/ERX*_EL1 registers RAZ/WI
Date:   Wed, 13 Oct 2021 13:03:38 +0100
Message-Id: <20211013120346.2926621-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013120346.2926621-1-maz@kernel.org>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com, drjones@redhat.com, oupton@google.com, qperret@google.com, kernel-team@android.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ERR*/ERX* registers should be handled as RAZ/WI, and there
should be no need to involve EL1 for that.

Add a helper that handles such registers, and repaint the sysreg
table to declare these registers as RAZ/WI.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 33 ++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index f125d6a52880..042a1c0be7e0 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -248,6 +248,16 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	return pvm_read_id_reg(vcpu, reg_to_encoding(r));
 }
 
+/* Handler to RAZ/WI sysregs */
+static bool pvm_access_raz_wi(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	if (!p->is_write)
+		p->regval = 0;
+
+	return true;
+}
+
 /*
  * Accessor for AArch32 feature id registers.
  *
@@ -270,9 +280,7 @@ static bool pvm_access_id_aarch32(struct kvm_vcpu *vcpu,
 	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1),
 		     PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) > ID_AA64PFR0_ELx_64BIT_ONLY);
 
-	/* Use 0 for architecturally "unknown" values. */
-	p->regval = 0;
-	return true;
+	return pvm_access_raz_wi(vcpu, p, r);
 }
 
 /*
@@ -301,6 +309,9 @@ static bool pvm_access_id_aarch64(struct kvm_vcpu *vcpu,
 /* Mark the specified system register as an AArch64 feature id register. */
 #define AARCH64(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch64 }
 
+/* Mark the specified system register as Read-As-Zero/Write-Ignored */
+#define RAZ_WI(REG) { SYS_DESC(REG), .access = pvm_access_raz_wi }
+
 /* Mark the specified system register as not being handled in hyp. */
 #define HOST_HANDLED(REG) { SYS_DESC(REG), .access = NULL }
 
@@ -388,14 +399,14 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	HOST_HANDLED(SYS_AFSR1_EL1),
 	HOST_HANDLED(SYS_ESR_EL1),
 
-	HOST_HANDLED(SYS_ERRIDR_EL1),
-	HOST_HANDLED(SYS_ERRSELR_EL1),
-	HOST_HANDLED(SYS_ERXFR_EL1),
-	HOST_HANDLED(SYS_ERXCTLR_EL1),
-	HOST_HANDLED(SYS_ERXSTATUS_EL1),
-	HOST_HANDLED(SYS_ERXADDR_EL1),
-	HOST_HANDLED(SYS_ERXMISC0_EL1),
-	HOST_HANDLED(SYS_ERXMISC1_EL1),
+	RAZ_WI(SYS_ERRIDR_EL1),
+	RAZ_WI(SYS_ERRSELR_EL1),
+	RAZ_WI(SYS_ERXFR_EL1),
+	RAZ_WI(SYS_ERXCTLR_EL1),
+	RAZ_WI(SYS_ERXSTATUS_EL1),
+	RAZ_WI(SYS_ERXADDR_EL1),
+	RAZ_WI(SYS_ERXMISC0_EL1),
+	RAZ_WI(SYS_ERXMISC1_EL1),
 
 	HOST_HANDLED(SYS_TFSR_EL1),
 	HOST_HANDLED(SYS_TFSRE0_EL1),
-- 
2.30.2

