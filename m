Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493C3703A32
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244786AbjEORtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244128AbjEORtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:49:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F83C160BD
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:47:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE82062F19
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3EAC433EF;
        Mon, 15 May 2023 17:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684172828;
        bh=KmAe4RCvGz3DrV/L9BsS52ZuN3hBKfzKPrk4b4Cu6QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WGAd1WIuFT11lThiu9ED3SWa22HeKu0y0cnMUToGAEnfJT4/OOPHaP9x/YYpUI5iI
         XGOJhdWF602sLjx4EyVzVKIxHbuQUwpWb6lK4YZoKxtZp2gXCaJiKWyodWiF+C1ZvV
         ehKTppaWLWrjZkuMnTEK8VkSAG4kcY7WmmQ5Kp7qpyc3wxHz4e8jdQHCPXdFAczV/G
         GH2dYApICakrV5hYmisou5Bi0uv3CfFyf4QsoOJ3W9RWJQQ/Rj/RpdV3/1MfKf78kJ
         LWsRRtGBRKoEBNMaLVNm75Oix9M1lipmklIdsOOrd3ndoFMU+aMZjcDSAmSmwNNcxa
         pZr0gRQqUYa2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc2g-00FJAF-Mn;
        Mon, 15 May 2023 18:31:26 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v10 13/59] KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
Date:   Mon, 15 May 2023 18:30:17 +0100
Message-Id: <20230515173103.1017669-14-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Describe the CNTHCTL_EL2 register, and associate it with all the sysregs
it allows to trap.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 37 ++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 1e2fe192c9a4..101292c43602 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -98,9 +98,11 @@ enum coarse_grain_trap_id {
 
 	/*
 	 * Anything after this point requires a callback evaluating a
-	 * complex trap condition. Hopefully we'll never need this...
+	 * complex trap condition. Ugly stuff.
 	 */
 	__COMPLEX_CONDITIONS__,
+	CGT_CNTHCTL_EL1PCTEN = __COMPLEX_CONDITIONS__,
+	CGT_CNTHCTL_EL1PTEN,
 };
 
 static const struct trap_bits coarse_trap_bits[] = {
@@ -358,9 +360,37 @@ static const enum coarse_grain_trap_id *coarse_control_combo[] = {
 
 typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *);
 
+static u64 get_sanitized_cnthctl(struct kvm_vcpu *vcpu)
+{
+	u64 val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
+
+	if (!vcpu_el2_e2h_is_set(vcpu))
+		val = (val & (CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN)) << 10;
+
+	return val;
+}
+
+static enum trap_behaviour check_cnthctl_el1pcten(struct kvm_vcpu *vcpu)
+{
+	if (get_sanitized_cnthctl(vcpu) & (CNTHCTL_EL1PCTEN << 10))
+		return BEHAVE_HANDLE_LOCALLY;
+
+	return BEHAVE_FORWARD_ANY;
+}
+
+static enum trap_behaviour check_cnthctl_el1pten(struct kvm_vcpu *vcpu)
+{
+	if (get_sanitized_cnthctl(vcpu) & (CNTHCTL_EL1PCEN << 10))
+		return BEHAVE_HANDLE_LOCALLY;
+
+	return BEHAVE_FORWARD_ANY;
+}
+
 #define CCC(id, fn)	[id - __COMPLEX_CONDITIONS__] = fn
 
 static const complex_condition_check ccc[] = {
+	CCC(CGT_CNTHCTL_EL1PCTEN, check_cnthctl_el1pcten),
+	CCC(CGT_CNTHCTL_EL1PTEN, check_cnthctl_el1pten),
 };
 
 struct encoding_to_trap_configs {
@@ -769,6 +799,11 @@ static const struct encoding_to_trap_configs encoding_to_traps[] __initdata = {
 	SR_TRAP(SYS_TRBPTR_EL1, 	CGT_MDCR_E2TB),
 	SR_TRAP(SYS_TRBSR_EL1, 		CGT_MDCR_E2TB),
 	SR_TRAP(SYS_TRBTRG_EL1,		CGT_MDCR_E2TB),
+	SR_TRAP(SYS_CNTP_TVAL_EL0,	CGT_CNTHCTL_EL1PTEN),
+	SR_TRAP(SYS_CNTP_CVAL_EL0,	CGT_CNTHCTL_EL1PTEN),
+	SR_TRAP(SYS_CNTP_CTL_EL0,	CGT_CNTHCTL_EL1PTEN),
+	SR_TRAP(SYS_CNTPCT_EL0,		CGT_CNTHCTL_EL1PCTEN),
+	SR_TRAP(SYS_CNTPCTSS_EL0,	CGT_CNTHCTL_EL1PCTEN),
 };
 
 static DEFINE_XARRAY(sr_forward_xa);
-- 
2.34.1

