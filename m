Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E5B568F66
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 18:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiGFQnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 12:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbiGFQnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 12:43:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A79023BD5
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 09:43:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 076A8B81A99
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 16:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D5EC341CD;
        Wed,  6 Jul 2022 16:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657125792;
        bh=UNgtJW5DG8RhYbDqvxaLJ/hTwlK4WDui2tGquNMVOgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KR6A7IHscJzVK5Gn1n9JnNcIZsBDBaJ+Htv6HCVi1HNwj4MomClV6KgnyIN74ZIQL
         QcKeS/ct2pyeIhHbT0ks2UGV+dFmzGjsFAQMwquUt/JwWNSgsQGoplEuMRextyc1Yv
         aDRlpK0YtJQHnhaOwTDYp5co7xWcA8BUgyy85cwXRe07gqkyKAuYLIEM8NxGW4c0Ik
         KzdaqSLQYEwuyjL4oTH63GGr7azIWebP0dge14MMlJvM8hYTeGF/W7aVZ/+ycoSYWr
         Wdi4K8jRevQkaZAG0BItwMrYv9mUDLdDlGcqZe70YHMpS1a1zTf9lNq1C5CGW3O5Gw
         eSNAFz7+GzyTw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o987K-005h9i-RU;
        Wed, 06 Jul 2022 17:43:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH 01/19] KVM: arm64: Add get_reg_by_id() as a sys_reg_desc retrieving helper
Date:   Wed,  6 Jul 2022 17:42:46 +0100
Message-Id: <20220706164304.1582687-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706164304.1582687-1-maz@kernel.org>
References: <20220706164304.1582687-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

find_reg_by_id() requires a sys_reg_param as input, which most
users provide as a on-stack variable, but don't make any use of
the result.

Provide a helper that doesn't have this requirement and simplify
the callers (all but one).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c        | 28 +++++++++++++++++-----------
 arch/arm64/kvm/sys_regs.h        |  4 ++++
 arch/arm64/kvm/vgic-sys-reg-v3.c |  8 ++------
 3 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c06c0477fab5..1f410283c592 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2650,21 +2650,29 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
 	return find_reg(params, table, num);
 }
 
+const struct sys_reg_desc *get_reg_by_id(u64 id,
+					 const struct sys_reg_desc table[],
+					 unsigned int num)
+{
+	struct sys_reg_params params;
+
+	if (!index_to_params(id, &params))
+		return NULL;
+
+	return find_reg(&params, table, num);
+}
+
 /* Decode an index value, and find the sys_reg_desc entry. */
 static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 						    u64 id)
 {
 	const struct sys_reg_desc *r;
-	struct sys_reg_params params;
 
 	/* We only do sys_reg for now. */
 	if ((id & KVM_REG_ARM_COPROC_MASK) != KVM_REG_ARM64_SYSREG)
 		return NULL;
 
-	if (!index_to_params(id, &params))
-		return NULL;
-
-	r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	r = get_reg_by_id(id, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 
 	/* Not saved in the sys_reg array and not otherwise accessible? */
 	if (r && !(r->reg || r->get_user))
@@ -2723,11 +2731,10 @@ static int reg_to_user(void __user *uaddr, const u64 *val, u64 id)
 
 static int get_invariant_sys_reg(u64 id, void __user *uaddr)
 {
-	struct sys_reg_params params;
 	const struct sys_reg_desc *r;
 
-	r = find_reg_by_id(id, &params, invariant_sys_regs,
-			   ARRAY_SIZE(invariant_sys_regs));
+	r = get_reg_by_id(id, invariant_sys_regs,
+			  ARRAY_SIZE(invariant_sys_regs));
 	if (!r)
 		return -ENOENT;
 
@@ -2736,13 +2743,12 @@ static int get_invariant_sys_reg(u64 id, void __user *uaddr)
 
 static int set_invariant_sys_reg(u64 id, void __user *uaddr)
 {
-	struct sys_reg_params params;
 	const struct sys_reg_desc *r;
 	int err;
 	u64 val = 0; /* Make sure high bits are 0 for 32-bit regs */
 
-	r = find_reg_by_id(id, &params, invariant_sys_regs,
-			   ARRAY_SIZE(invariant_sys_regs));
+	r = get_reg_by_id(id, invariant_sys_regs,
+			  ARRAY_SIZE(invariant_sys_regs));
 	if (!r)
 		return -ENOENT;
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index aee8ea054f0d..ce30ed9566ae 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -195,6 +195,10 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
 					  const struct sys_reg_desc table[],
 					  unsigned int num);
 
+const struct sys_reg_desc *get_reg_by_id(u64 id,
+					 const struct sys_reg_desc table[],
+					 unsigned int num);
+
 #define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x
 #define Op1(_x) 	.Op1 = _x
diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 07d5271e9f05..644acda33c7c 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -263,14 +263,10 @@ static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
 int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
 				u64 *reg)
 {
-	struct sys_reg_params params;
 	u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
 
-	params.regval = *reg;
-	params.is_write = is_write;
-
-	if (find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
-			      ARRAY_SIZE(gic_v3_icc_reg_descs)))
+	if (get_reg_by_id(sysreg, gic_v3_icc_reg_descs,
+			  ARRAY_SIZE(gic_v3_icc_reg_descs)))
 		return 0;
 
 	return -ENXIO;
-- 
2.34.1

