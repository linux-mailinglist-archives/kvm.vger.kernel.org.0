Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBA02B23AD
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 19:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgKMS0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 13:26:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbgKMS0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 13:26:18 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A10D2074B;
        Fri, 13 Nov 2020 18:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605291978;
        bh=yeLt3nqD1e41ZnMR7XCTopnao0wO6yUaD1zjpERGPFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riZ/QyU++0GCZfImskdEDD1g5xZEAsgyBKPpbHX8INDflaVbu4TWHBkJGT8wFQrcS
         OKHFi1pIO+TS1YAlfDlPmVV6Cxqs4ZMX4xaSrjHcODLaBMBwr5E33vjp10Py2Aachn
         lUId5tI+2N6O8se/g9z90oT0DVT+48ALpzd+MIDM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kddm4-00APrY-Gt; Fri, 13 Nov 2020 18:26:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH 2/8] KVM: arm64: Set ID_AA64DFR0_EL1.PMUVer to 0 when no PMU support
Date:   Fri, 13 Nov 2020 18:25:56 +0000
Message-Id: <20201113182602.471776-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113182602.471776-1-maz@kernel.org>
References: <20201113182602.471776-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We always expose the HW view of PMU in ID_AA64FDR0_EL1.PMUver,
even when the PMU feature is disabled, while the architecture
says that FEAT_PMUv3 not being implemented should result in this
field being zero.

Let's follow the architecture's guidance.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d2e1d745f067..6629cfde2838 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1070,10 +1070,15 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
 			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
 	} else if (id == SYS_ID_AA64DFR0_EL1) {
+		u64 cap = 0;
+
 		/* Limit guests to PMUv3 for ARMv8.1 */
+		if (kvm_vcpu_has_pmu(vcpu))
+			cap = ID_AA64DFR0_PMUVER_8_1;
+
 		val = cpuid_feature_cap_perfmon_field(val,
 						ID_AA64DFR0_PMUVER_SHIFT,
-						ID_AA64DFR0_PMUVER_8_1);
+						cap);
 	} else if (id == SYS_ID_DFR0_EL1) {
 		/* Limit guests to PMUv3 for ARMv8.1 */
 		val = cpuid_feature_cap_perfmon_field(val,
-- 
2.28.0

