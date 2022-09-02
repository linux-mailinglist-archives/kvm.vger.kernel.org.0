Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92625AB5CB
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 17:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237468AbiIBPyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 11:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237548AbiIBPxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 11:53:51 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52250B14C8;
        Fri,  2 Sep 2022 08:48:19 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662133697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X3uLK2B33Vs/uryalTDkiauADuUaETuEfrZIlg4V3Ns=;
        b=Yk6Sb4XwCG9CU+f3BT3LbXi0D76Zsp6/FjzwDgiQfw4npSYYYR2n8nyR9Em2I2CvfprTj3
        xrYdP0DciLxNTtMnbm09cD95Md2ecBGjtITQfevZ+wldGVXDw/tv9+BDcijqPrrj7tyGpz
        nbsaz4MomVpOltLahS22jNzlERlm9Ng=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/7] KVM: arm64: Use visibility hook to treat ID regs as RAZ
Date:   Fri,  2 Sep 2022 15:47:57 +0000
Message-Id: <20220902154804.1939819-2-oliver.upton@linux.dev>
In-Reply-To: <20220902154804.1939819-1-oliver.upton@linux.dev>
References: <20220902154804.1939819-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The generic id reg accessors already handle RAZ registers by way of the
visibility hook. Add a visibility hook that returns REG_RAZ
unconditionally and throw out the RAZ specific accessors.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3234f50b8c4b..e18efb9211f0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1145,6 +1145,12 @@ static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static unsigned int raz_visibility(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *r)
+{
+	return REG_RAZ;
+}
+
 /* cpufeature ID register access trap handlers */
 
 static bool __access_id_reg(struct kvm_vcpu *vcpu,
@@ -1168,13 +1174,6 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
 	return __access_id_reg(vcpu, p, r, raz);
 }
 
-static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
-			      struct sys_reg_params *p,
-			      const struct sys_reg_desc *r)
-{
-	return __access_id_reg(vcpu, p, r, true);
-}
-
 /* Visibility overrides for SVE-specific control registers */
 static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
@@ -1262,12 +1261,6 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return __set_id_reg(vcpu, rd, val, raz);
 }
 
-static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-			  u64 val)
-{
-	return __set_id_reg(vcpu, rd, val, true);
-}
-
 static int get_raz_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		       u64 *val)
 {
@@ -1374,9 +1367,10 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
  */
 #define ID_UNALLOCATED(crm, op2) {			\
 	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
-	.access = access_raz_id_reg,			\
-	.get_user = get_raz_reg,			\
-	.set_user = set_raz_id_reg,			\
+	.access = access_id_reg,			\
+	.get_user = get_id_reg,				\
+	.set_user = set_id_reg,				\
+	.visibility = raz_visibility			\
 }
 
 /*
@@ -1386,9 +1380,10 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
  */
 #define ID_HIDDEN(name) {			\
 	SYS_DESC(SYS_##name),			\
-	.access = access_raz_id_reg,		\
-	.get_user = get_raz_reg,		\
-	.set_user = set_raz_id_reg,		\
+	.access = access_id_reg,		\
+	.get_user = get_id_reg,			\
+	.set_user = set_id_reg,			\
+	.visibility = raz_visibility,		\
 }
 
 /*
-- 
2.37.2.789.g6183377224-goog

