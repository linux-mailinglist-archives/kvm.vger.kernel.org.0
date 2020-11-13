Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F7B2B23BF
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 19:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgKMS0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 13:26:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbgKMS0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 13:26:21 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40AA721D79;
        Fri, 13 Nov 2020 18:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605291980;
        bh=2mthOzpjq31upPcsVjKgfwAMzV+9ZWOKIZkykqjh+Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2XSOQ7f1x7U74iQlApXK1571hyWMuapDNvFxn5Ox+7RceCDa2ij23mvfxg6Jv0Lz
         eQrMY7tfBQG+kgCrt9zyX1TKPgqy2s8bQUUBZ0M/Ib893jAi89FcSwDRC4sTuNmt8f
         Uq4SzhZmoXIbHouMW9V7dRCJmI3qeDFFeaWkglYo=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kddm6-00APrY-FI; Fri, 13 Nov 2020 18:26:18 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH 6/8] KVM: arm64: Remove dead PMU sysreg decoding code
Date:   Fri, 13 Nov 2020 18:26:00 +0000
Message-Id: <20201113182602.471776-7-maz@kernel.org>
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

The handling of traps in access_pmu_evcntr() has a couple of
omminous "else return false;" statements that don't make any sense:
the decoding tree coverse all the registers that trap to this handler,
and returning false implies that we change PC, which we don't.

Get rid of what is evidently dead code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3bd4cc40536b..f878d71484d8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -733,8 +733,6 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 				return false;
 
 			idx = ARMV8_PMU_CYCLE_IDX;
-		} else {
-			return false;
 		}
 	} else if (r->CRn == 0 && r->CRm == 9) {
 		/* PMCCNTR */
@@ -748,8 +746,6 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 			return false;
 
 		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
-	} else {
-		return false;
 	}
 
 	if (!pmu_counter_idx_valid(vcpu, idx))
-- 
2.28.0

