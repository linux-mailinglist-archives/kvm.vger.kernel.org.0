Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C6D627105
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 17:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbiKMQrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 11:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235500AbiKMQqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 11:46:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80C510FE0
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 08:46:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7254060C37
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 16:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D660CC433D7;
        Sun, 13 Nov 2022 16:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668358003;
        bh=bcvgq6/lvjmtMZJhUIvIcvyt7d7ZBCexYtAmHhlWX9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBJplmd1P3QWcO3JdJ8dy/nQW5Bo/ignyiHvQ9Zju0rIluL99qhQOLMKCOnvExR+c
         Ud5oRtBIavsr++Frm3jBFTFI6OVfYpoSN+od2ZRV+cd5gbXBwSa2I7luMSL+3PiEoB
         StF3dZxIgpWYK2pVhkjZZVtxcfiIdnJrJSDZdc/HMw8cNv59nCtsbW6iW00wyDMQXu
         RgqW3Zup1kkWWOpJQ24nkrgsmK9AgjMeCgkRqGz+y3j9teIGpG9bfoYddMZsdBQWN5
         5GK+rzCk4SzPOUOtSO0qIMI+q/n0hDkAfM+pFByyn7eT5YJuVNVMuhmfGBpq+ucvSn
         0hcXTetEH7OHQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ouG0Q-005oYZ-84;
        Sun, 13 Nov 2022 16:38:50 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: [PATCH v4 12/16] KVM: arm64: PMU: Allow ID_DFR0_EL1.PerfMon to be set from userspace
Date:   Sun, 13 Nov 2022 16:38:28 +0000
Message-Id: <20221113163832.3154370-13-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221113163832.3154370-1-maz@kernel.org>
References: <20221113163832.3154370-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow userspace to write ID_DFR0_EL1, on the condition that only
the PerfMon field can be altered and be something that is compatible
with what was computed for the AArch64 view of the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 57 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3cbcda665d23..dc201a0557c0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1070,6 +1070,19 @@ static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 	return vcpu->kvm->arch.dfr0_pmuver.unimp;
 }
 
+static u8 perfmon_to_pmuver(u8 perfmon)
+{
+	switch (perfmon) {
+	case ID_DFR0_PERFMON_8_0:
+		return ID_AA64DFR0_EL1_PMUVer_IMP;
+	case ID_DFR0_PERFMON_IMP_DEF:
+		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
+	default:
+		/* Anything ARMv8.1+ has the same value. For now. */
+		return perfmon;
+	}
+}
+
 static u8 pmuver_to_perfmon(u8 pmuver)
 {
 	switch (pmuver) {
@@ -1281,6 +1294,46 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
+			   const struct sys_reg_desc *rd,
+			   u64 val)
+{
+	u8 perfmon, host_perfmon;
+	bool valid_pmu;
+
+	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
+
+	/*
+	 * Allow DFR0_EL1.PerfMon to be set from userspace as long as
+	 * it doesn't promise more than what the HW gives us on the
+	 * AArch64 side (as everything is emulated with that), and
+	 * that this is a PMUv3.
+	 */
+	perfmon = FIELD_GET(ARM64_FEATURE_MASK(ID_DFR0_PERFMON), val);
+	if ((perfmon != ID_DFR0_PERFMON_IMP_DEF && perfmon > host_perfmon) ||
+	    (perfmon != 0 && perfmon < ID_DFR0_PERFMON_8_0))
+		return -EINVAL;
+
+	valid_pmu = (perfmon != 0 && perfmon != ID_DFR0_PERFMON_IMP_DEF);
+
+	/* Make sure view register and PMU support do match */
+	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
+		return -EINVAL;
+
+	/* We can only differ with PerfMon, and anything else is an error */
+	val ^= read_id_reg(vcpu, rd);
+	val &= ~ARM64_FEATURE_MASK(ID_DFR0_PERFMON);
+	if (val)
+		return -EINVAL;
+
+	if (valid_pmu)
+		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
+	else
+		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
+
+	return 0;
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -1502,7 +1555,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* CRm=1 */
 	AA32_ID_SANITISED(ID_PFR0_EL1),
 	AA32_ID_SANITISED(ID_PFR1_EL1),
-	AA32_ID_SANITISED(ID_DFR0_EL1),
+	{ SYS_DESC(SYS_ID_DFR0_EL1), .access = access_id_reg,
+	  .get_user = get_id_reg, .set_user = set_id_dfr0_el1,
+	  .visibility = aa32_id_visibility, },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
-- 
2.34.1

