Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC1777D26A
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239475AbjHOSt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239515AbjHOSth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:49:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597821FDD
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 771EA65F8D
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 18:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D485CC433C8;
        Tue, 15 Aug 2023 18:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692125234;
        bh=Lefa0PQIq+vwhSa0X5V5we3jlWqXU+ytjLeGhSHxMHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sN+lPJdHP70fwqxelCzuYKvDxdnG437p+ue73rSQ6v9ENk5056PDNrGAj22Bt2psh
         AhfHEeY7VyMV5hPi02sTXVlVQ6NHYVbizRt+W3pl8w6nNFVDTD6wednfbIFCzWNsDk
         VN+X/2vhgR6at0wACE7OyU+qXOZN4QVFgx4Bd7j78aiTHc7nTsFPCjL/naA/qGu1Ql
         EneAbI5h/2fc1xO7cq8ac5QOIQ4jcbI1084P84NmVVUDBmVn2B7pdqblRVzj49r2po
         74goLuXuy2FflQEHZ0KS6CsC2DZh687SXTs+PD9Tnim/cJn6zrLkLqvzLbVCWEdoBv
         WYB2ekCpytEjw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qVywq-0055Sd-3S;
        Tue, 15 Aug 2023 19:39:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        Jing Zhang <jingzhangos@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 18/28] KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
Date:   Tue, 15 Aug 2023 19:38:52 +0100
Message-Id: <20230815183903.2735724-19-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230815183903.2735724-1-maz@kernel.org>
References: <20230815183903.2735724-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, jingzhangos@google.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Describe the CNTHCTL_EL2 register, and associate it with all the sysregs
it allows to trap.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 50 ++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 241e44eeed6d..860910386b5b 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -100,9 +100,11 @@ enum cgt_group_id {
 
 	/*
 	 * Anything after this point requires a callback evaluating a
-	 * complex trap condition. Hopefully we'll never need this...
+	 * complex trap condition. Ugly stuff.
 	 */
 	__COMPLEX_CONDITIONS__,
+	CGT_CNTHCTL_EL1PCTEN = __COMPLEX_CONDITIONS__,
+	CGT_CNTHCTL_EL1PTEN,
 
 	/* Must be last */
 	__NR_CGT_GROUP_IDS__
@@ -369,10 +371,51 @@ static const enum cgt_group_id *coarse_control_combo[] = {
 
 typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *);
 
+/*
+ * Warning, maximum confusion ahead.
+ *
+ * When E2H=0, CNTHCTL_EL2[1:0] are defined as EL1PCEN:EL1PCTEN
+ * When E2H=1, CNTHCTL_EL2[11:10] are defined as EL1PTEN:EL1PCTEN
+ *
+ * Note the single letter difference? Yet, the bits have the same
+ * function despite a different layout and a different name.
+ *
+ * We don't try to reconcile this mess. We just use the E2H=0 bits
+ * to generate something that is in the E2H=1 format, and live with
+ * it. You're welcome.
+ */
+static u64 get_sanitized_cnthctl(struct kvm_vcpu *vcpu)
+{
+	u64 val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
+
+	if (!vcpu_el2_e2h_is_set(vcpu))
+		val = (val & (CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN)) << 10;
+
+	return val & ((CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN) << 10);
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
 #define CCC(id, fn)				\
 	[id - __COMPLEX_CONDITIONS__] = fn
 
 static const complex_condition_check ccc[] = {
+	CCC(CGT_CNTHCTL_EL1PCTEN, check_cnthctl_el1pcten),
+	CCC(CGT_CNTHCTL_EL1PTEN, check_cnthctl_el1pten),
 };
 
 /*
@@ -877,6 +920,11 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
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

