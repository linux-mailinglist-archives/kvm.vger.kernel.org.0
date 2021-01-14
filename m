Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BBC2F5F65
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 11:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbhANK6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 05:58:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727897AbhANK6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 05:58:12 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC44E23A56;
        Thu, 14 Jan 2021 10:56:53 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l00JA-007Tvz-7m; Thu, 14 Jan 2021 10:56:52 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH 6/6] KVM: arm64: Upgrade PMU support to ARMv8.4
Date:   Thu, 14 Jan 2021 10:56:33 +0000
Message-Id: <20210114105633.2558739-7-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210114105633.2558739-1-maz@kernel.org>
References: <20210114105633.2558739-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upgrading the PMU code from ARMv8.1 to ARMv8.4 turns out to be
pretty easy. All that is required is support for PMMIR_EL1, which
is read-only, and for which returning 0 is a valid option.

Let's just do that and adjust what we return to the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8f79ec1fffa7..2f4ecbd2abfb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1051,10 +1051,10 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		/* Limit debug to ARMv8.0 */
 		val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
 		val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 6);
-		/* Limit guests to PMUv3 for ARMv8.1 */
+		/* Limit guests to PMUv3 for ARMv8.4 */
 		val = cpuid_feature_cap_perfmon_field(val,
 						      ID_AA64DFR0_PMUVER_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_1 : 0);
+						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
 		break;
 	case SYS_ID_DFR0_EL1:
 		/* Limit guests to PMUv3 for ARMv8.1 */
@@ -1496,6 +1496,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_PMINTENSET_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
 	{ SYS_DESC(SYS_PMINTENCLR_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
+	{ SYS_DESC(SYS_PMMIR_EL1), trap_raz_wi },
 
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
 	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
-- 
2.29.2

