Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B49610F76
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 13:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiJ1LQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 07:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJ1LQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 07:16:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B789137390
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 04:16:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38C12627BD
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 11:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC62C433D6;
        Fri, 28 Oct 2022 11:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666955789;
        bh=d4VAP45li3LyhsekQVHaTiaFYQNPRcQ5MHtfrwCiY9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1oK0vWbj4HM5Kql2MoS1y86LnV8Zpv5sWoks7HUpVKVrE1TtDnJr6zx+UdH7/fhI
         bxsD31Dz+0dOikgMZSuBwHe8ymbBclP9sF06SLpZiFv7++mpf7ytgrHPpf36bCD/Op
         oetdZGtTikX8eITvB+kccV+rnOoc85BPM2lJMcQJqArRZrflz9GkqdrW+ls76K4UUN
         yAG8/VuJooge2SIFv7QOKsUVVndn+YydAGVpa46Cr8by1h+y2ekBcZV24m7LWlIWNp
         Y93uisEVyJJeKuPlSvGBzjR9Cx7kr/UO4xElbkBJwj9mLv6lVbkBSHdTl5XSkrqMRe
         XZ7xyPMTM/NSQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ooN09-002E4C-Qx;
        Fri, 28 Oct 2022 11:54:14 +0100
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
Subject: [PATCH v2 11/14] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to be set from userspace
Date:   Fri, 28 Oct 2022 11:53:59 +0100
Message-Id: <20221028105402.2030192-12-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028105402.2030192-1-maz@kernel.org>
References: <20221028105402.2030192-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
the PMUver field can be altered and be at most the one that was
initially computed for the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7a4cd644b9c0..4fa14b4ae2a6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1247,6 +1247,40 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd,
+			       u64 val)
+{
+	u8 pmuver, host_pmuver;
+
+	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
+
+	/*
+	 * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
+	 * as it doesn't promise more than what the HW gives us. We
+	 * allow an IMPDEF PMU though, only if no PMU is supported
+	 * (KVM backward compatibility handling).
+	 */
+	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), val);
+	if (pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver)
+		return -EINVAL;
+
+	/* We already have a PMU, don't try to disable it... */
+	if (kvm_vcpu_has_pmu(vcpu) &&
+	    (pmuver == 0 || pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF))
+		return -EINVAL;
+
+	/* We can only differ with PMUver, and anything else is an error */
+	val ^= read_id_reg(vcpu, rd);
+	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	if (val)
+		return -EINVAL;
+
+	vcpu->kvm->arch.dfr0_pmuver = pmuver;
+
+	return 0;
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -1508,7 +1542,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(4,7),
 
 	/* CRm=5 */
-	ID_SANITISED(ID_AA64DFR0_EL1),
+	{ SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
+	  .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.34.1

