Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE35A5751A8
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240127AbiGNPUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240053AbiGNPUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:20:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FBB5C37A
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:20:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A24A5B823BA
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2FEC341CA;
        Thu, 14 Jul 2022 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657812030;
        bh=O7BS6AeDlfyHmMoinbRZ0DSv73zHdjbZuwI9pK2N/i4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkP2eEVe/yhi8QaCsuFA6jrZexkswWK86d62d5Yaf+rONNzrx3QFElcCkC1PbnaaH
         tLwIX5Vd0ZgZpPHzrdeGr4boctNxj42YN0fRoo8J0JgU4WJ3Gtmnqi4sIqcPCNlE3t
         hxkpqBtsMQDRAvWnMNwTHTKy3DmTq3SvjyFEgnB8aPP3Jrr4VSorAYbtQ7C92FgwCV
         njMlDIBSp5TKZKbdF+EAtuyKzqsX8VK8jTDnkkYj8cRCB1+uljpVGX83Q8kZxdKAs4
         AuGEB9rMkmKCM4vnq7YpqR2krLV84hKoxbCyG7jP4ayCy9CrnMkq4UnbkaazGiOtKy
         KlC0tPN9RFxaw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oC0dg-007UVL-9e;
        Thu, 14 Jul 2022 16:20:28 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH v2 03/20] KVM: arm64: Introduce generic get_user/set_user helpers for system registers
Date:   Thu, 14 Jul 2022 16:20:07 +0100
Message-Id: <20220714152024.1673368-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220714152024.1673368-1-maz@kernel.org>
References: <20220714152024.1673368-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, reijiw@google.com, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The userspace access to the system registers is done using helpers
that hardcode the table that is looked up. extract some generic
helpers from this, moving the handling of hidden sysregs into
the core code.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 60 +++++++++++++++++++++++++--------------
 arch/arm64/kvm/sys_regs.h |  6 ++++
 2 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9291cb94c2e4..0fbdb21a3600 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2663,8 +2663,10 @@ const struct sys_reg_desc *get_reg_by_id(u64 id,
 }
 
 /* Decode an index value, and find the sys_reg_desc entry. */
-static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
-						    u64 id)
+static const struct sys_reg_desc *
+id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
+		   const struct sys_reg_desc table[], unsigned int num)
+
 {
 	const struct sys_reg_desc *r;
 
@@ -2672,10 +2674,10 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 	if ((id & KVM_REG_ARM_COPROC_MASK) != KVM_REG_ARM64_SYSREG)
 		return NULL;
 
-	r = get_reg_by_id(id, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	r = get_reg_by_id(id, table, num);
 
 	/* Not saved in the sys_reg array and not otherwise accessible? */
-	if (r && !(r->reg || r->get_user))
+	if (r && (!(r->reg || r->get_user) || sysreg_hidden(vcpu, r)))
 		r = NULL;
 
 	return r;
@@ -2845,9 +2847,24 @@ static int demux_c15_set(u64 id, void __user *uaddr)
 	}
 }
 
-int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
+			 const struct sys_reg_desc table[], unsigned int num)
 {
+	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
 	const struct sys_reg_desc *r;
+
+	r = id_to_sys_reg_desc(vcpu, reg->id, table, num);
+	if (!r)
+		return -ENOENT;
+
+	if (r->get_user)
+		return (r->get_user)(vcpu, r, reg, uaddr);
+
+	return reg_to_user(uaddr, &__vcpu_sys_reg(vcpu, r->reg), reg->id);
+}
+
+int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
 	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
 	int err;
 
@@ -2861,21 +2878,28 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (err != -ENOENT)
 		return err;
 
-	r = index_to_sys_reg_desc(vcpu, reg->id);
+	return kvm_sys_reg_get_user(vcpu, reg,
+				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+}
 
-	/* Check for regs disabled by runtime config */
-	if (!r || sysreg_hidden(vcpu, r))
+int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
+			 const struct sys_reg_desc table[], unsigned int num)
+{
+	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
+	const struct sys_reg_desc *r;
+
+	r = id_to_sys_reg_desc(vcpu, reg->id, table, num);
+	if (!r)
 		return -ENOENT;
 
-	if (r->get_user)
-		return (r->get_user)(vcpu, r, reg, uaddr);
+	if (r->set_user)
+		return (r->set_user)(vcpu, r, reg, uaddr);
 
-	return reg_to_user(uaddr, &__vcpu_sys_reg(vcpu, r->reg), reg->id);
+	return reg_from_user(&__vcpu_sys_reg(vcpu, r->reg), uaddr, reg->id);
 }
 
 int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
-	const struct sys_reg_desc *r;
 	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
 	int err;
 
@@ -2889,16 +2913,8 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (err != -ENOENT)
 		return err;
 
-	r = index_to_sys_reg_desc(vcpu, reg->id);
-
-	/* Check for regs disabled by runtime config */
-	if (!r || sysreg_hidden(vcpu, r))
-		return -ENOENT;
-
-	if (r->set_user)
-		return (r->set_user)(vcpu, r, reg, uaddr);
-
-	return reg_from_user(&__vcpu_sys_reg(vcpu, r->reg), uaddr, reg->id);
+	return kvm_sys_reg_set_user(vcpu, reg,
+				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 }
 
 static unsigned int num_demux_regs(void)
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index ce30ed9566ae..4fb6d59e7874 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -199,6 +199,12 @@ const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num);
 
+int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
+			 const struct sys_reg_desc table[], unsigned int num);
+
+int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
+			 const struct sys_reg_desc table[], unsigned int num);
+
 #define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x
 #define Op1(_x) 	.Op1 = _x
-- 
2.34.1

