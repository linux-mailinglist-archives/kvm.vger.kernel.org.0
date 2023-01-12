Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C83A667F20
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239662AbjALT14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbjALT1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:27:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF042F7BD
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:21:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6136BB82012
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DC2C433F0;
        Thu, 12 Jan 2023 19:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551279;
        bh=0+x8a75H3r0fPSCwDaK+BksXhGwjUMksH8OoCMJE0Dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQjWZP9qEu3iGLaf+GJ64NV3dQU5ruAWfkVWxsTlD1SGMQsnBoEyI0kCs+AONAkr8
         gl+xTO9OSkgU+EM4aeHYLE9ytbh5eUQZ0Ne0OLCw6mdMMRHY7TjxtO+4NMDHYpK95J
         25ucXNRs3Kd5QEBhXauP8Po3UuDOD87lGzeN3dy8mwaMwGcKZYJAAFiB1YeUcxvCC9
         V96uVXJyBZUSTD93JcWDEssjgKBzOQfHsZFpIX1AMZFr+FkGSCYGT5OeL+09ocW0oi
         W40sTUwhizZCi3G1cUFLtOI3Iy+DYdvB5ExZNewlsHu2XqeGV4iAjn1U2r5+9ZBHZE
         2of6tPg3y3O8g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG37U-001IWu-Cy;
        Thu, 12 Jan 2023 19:20:12 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v7 67/68] KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
Date:   Thu, 12 Jan 2023 19:19:26 +0000
Message-Id: <20230112191927.1814989-68-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

Although FEAT_NV2 makes most things fast, it also makes it impossible
to correctly emulate the timers, as the sysreg accesses are redirected
to memory.

FEAT_ECV addresses this by giving a hypervisor the ability to trap
the EL02 sysregs as well as the virtual timer.

Add the required trap setting to make use of the feature, allowing
us to elide the ugly resync in the middle of the run loop.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c          | 54 +++++++++++++++++++++++++++-
 include/clocksource/arm_arch_timer.h |  4 +++
 2 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 71d2f1902de9..6295883f4223 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -740,6 +740,44 @@ static void kvm_timer_vcpu_load_nested_switch(struct kvm_vcpu *vcpu,
 		WARN_ON_ONCE(ret);
 	}
 
+	/*
+	 * NV2 badly breaks the timer semantics by redirecting accesses to
+	 * the EL0 timer state to memory, so let's call ECV to the rescue if
+	 * available: we trap all CNT{P,V}_{CTL,CVAL,TVAL}_EL0 accesses.
+	 *
+	 * The treatment slightly varies depending whether we run a nVHE or
+	 * VHE guest: nVHE will use the _EL0 registers directly, while VHE
+	 * will use the _EL02 accessors. This translates in different trap
+	 * bits.
+	 *
+	 * None of the trapping is engaged when running in non-HYP context,
+	 * unless required by the L1 hypervisor settings once we advertise
+	 * ECV+NV in the guest.
+	 */
+	if (vcpu_has_nv2(vcpu) && cpus_have_const_cap(ARM64_HAS_ECV)) {
+		u64 clr = 0, set = 0;
+
+		if (vcpu_el2_e2h_is_set(vcpu)) {
+			set |= CNTHCTL_EL1NVVCT | CNTHCTL_EL1NVPCT;
+		} else {
+			/*
+			 * Only trap the timers, not the counters, as they
+			 * are in the "direct" state for nVHE.
+			 */
+			clr |= CNTHCTL_EL1PCEN << 10;
+			set |= CNTHCTL_EL1TVT;
+		}
+
+		/*
+		 * Apply these values for HYP context, and reverse them
+		 * otherwise
+		 */
+		if (is_hyp_ctxt(vcpu))
+			sysreg_clear_set(cntkctl_el1, clr, set);
+		else
+			sysreg_clear_set(cntkctl_el1, set, clr);
+	}
+
 	/*
 	 * Apply the trapping bits that the guest hypervisor has
 	 * requested for its own guest.
@@ -838,6 +876,16 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 
 	if (kvm_vcpu_is_blocking(vcpu))
 		kvm_timer_blocking(vcpu);
+
+	/*
+	 * Restore the standard, non-nested configuration so that we're
+	 * ready to run a non-NV vcpu.
+	 */
+	if (vcpu_has_nv2(vcpu))
+		sysreg_clear_set(cntkctl_el1,
+				 (CNTHCTL_EL1NVPCT | CNTHCTL_EL1NVVCT |
+				  CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT),
+				 (CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN) << 10);
 }
 
 void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
@@ -847,8 +895,12 @@ void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
 	 * accesses redirected to the VNCR page. Any guest action taken on
 	 * the timer is postponed until the next exit, leading to a very
 	 * poor quality of emulation.
+	 *
+	 * This is an unmitigated disaster, only papered over by FEAT_ECV,
+	 * which allows trapping of the timer registers even with NV2.
+	 * Still, this is still worse than FEAT_NV on its own. Meh.
 	 */
-	if (!is_hyp_ctxt(vcpu))
+	if (cpus_have_const_cap(ARM64_HAS_ECV) || !is_hyp_ctxt(vcpu))
 		return;
 
 	if (!vcpu_el2_e2h_is_set(vcpu)) {
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 057c8964aefb..e3c3816d19ba 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -21,6 +21,10 @@
 #define CNTHCTL_EVNTEN			(1 << 2)
 #define CNTHCTL_EVNTDIR			(1 << 3)
 #define CNTHCTL_EVNTI			(0xF << 4)
+#define CNTHCTL_EL1TVT			(1 << 13)
+#define CNTHCTL_EL1TVCT			(1 << 14)
+#define CNTHCTL_EL1NVPCT		(1 << 15)
+#define CNTHCTL_EL1NVVCT		(1 << 16)
 
 enum arch_timer_reg {
 	ARCH_TIMER_REG_CTRL,
-- 
2.34.1

