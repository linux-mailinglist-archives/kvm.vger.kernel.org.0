Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE022F5F62
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 11:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbhANK5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 05:57:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbhANK5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 05:57:32 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0450723A51;
        Thu, 14 Jan 2021 10:56:52 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l00J8-007Tvz-8N; Thu, 14 Jan 2021 10:56:50 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH 2/6] KVM: arm64: Fix AArch32 PMUv3 capping
Date:   Thu, 14 Jan 2021 10:56:29 +0000
Message-Id: <20210114105633.2558739-3-maz@kernel.org>
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

We shouldn't expose *any* PMU capability when no PMU has been
configured for this VM.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0c0832472c4a..ce08d28ab15c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1048,8 +1048,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	} else if (id == SYS_ID_DFR0_EL1) {
 		/* Limit guests to PMUv3 for ARMv8.1 */
 		val = cpuid_feature_cap_perfmon_field(val,
-						ID_DFR0_PERFMON_SHIFT,
-						ID_DFR0_PERFMON_8_1);
+						      ID_DFR0_PERFMON_SHIFT,
+						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_1 : 0);
 	}
 
 	return val;
-- 
2.29.2

