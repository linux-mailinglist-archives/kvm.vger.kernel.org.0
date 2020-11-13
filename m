Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1382E2B23B4
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 19:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgKMS0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 13:26:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbgKMS0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 13:26:20 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAF79221EB;
        Fri, 13 Nov 2020 18:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605291979;
        bh=Yx51wI58JGRn62g2bGeRn1X2FHxnhVrydxNbB/q3eTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGxzwWtJ+CxNByPhOsw469cld85JR3Mj5D0y9F7l1g8NM2SgEvDCze5dI+hDmElmc
         8C0OyrXehvZOkpSZomWuDXu2wNBqRUcFIFMzbGVdhajwXHLsw8dvcyhnv+v8nck+G+
         jza3//kuSlw8VKsia9tX76bI7uVtAVx6mC/r3pws=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kddm5-00APrY-TT; Fri, 13 Nov 2020 18:26:18 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH 5/8] KVM: arm64: Remove PMU RAZ/WI handling
Date:   Fri, 13 Nov 2020 18:25:59 +0000
Message-Id: <20201113182602.471776-6-maz@kernel.org>
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

There is no RAZ/WI handling allowed for the PMU registers in the
ARMv8 architecture. Nobody can remember how we cam to the conclusion
that we could do this, but the ARMv8 ARM is pretty clear that we cannot.

Remove the RAZ/WI handling of the PMU system registers when it is
not configured.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b098d667bb42..3bd4cc40536b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -643,9 +643,6 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 val;
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
@@ -672,9 +669,6 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (pmu_access_event_counter_el0_disabled(vcpu))
 		return false;
 
@@ -693,9 +687,6 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 pmceid;
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	BUG_ON(p->is_write);
 
 	if (pmu_access_el0_disabled(vcpu))
@@ -728,9 +719,6 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 {
 	u64 idx;
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (r->CRn == 9 && r->CRm == 13) {
 		if (r->Op2 == 2) {
 			/* PMXEVCNTR_EL0 */
@@ -784,9 +772,6 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 idx, reg;
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
@@ -824,9 +809,6 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 val, mask;
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
@@ -855,9 +837,6 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (check_pmu_access_disabled(vcpu, 0))
 		return false;
 
@@ -882,9 +861,6 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
@@ -907,9 +883,6 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 mask;
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (!p->is_write)
 		return read_from_write_only(vcpu, p, r);
 
@@ -924,9 +897,6 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			     const struct sys_reg_desc *r)
 {
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (!kvm_vcpu_has_pmu(vcpu)) {
 		kvm_inject_undefined(vcpu);
 		return false;
-- 
2.28.0

