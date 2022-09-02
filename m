Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B638F5AB5D8
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 17:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237519AbiIBPyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 11:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237368AbiIBPyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 11:54:14 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E447B9750D;
        Fri,  2 Sep 2022 08:48:33 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662133712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V6k28kYhkcPJExhwA2MA54v72Ie/Q26hkSQ3vV9FgOU=;
        b=Vuw6tEAbdeZ3pf37hySJghXHkWkrzzZm9MN6K1lj/zCVd6WwJw2g53h7Pkw2eX/LlWUpkT
        +ZUScU/bkBKehabf1bbHSSNzDPg6yY4KVxuF8X2Ouol+HEfioWeuW4XKC/Cwe98W2akCF1
        sZ35eEw2EmHBgcrvxsVaqanQNpjx06c=
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
Subject: [PATCH v2 6/7] KVM: arm64: Treat 32bit ID registers as RAZ/WI on 64bit-only system
Date:   Fri,  2 Sep 2022 15:48:02 +0000
Message-Id: <20220902154804.1939819-7-oliver.upton@linux.dev>
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

One of the oddities of the architecture is that the AArch64 views of the
AArch32 ID registers are UNKNOWN if AArch32 isn't implemented at any EL.
Nonetheless, KVM exposes these registers to userspace for the sake of
save/restore. It is possible that the UNKNOWN value could differ between
systems, leading to a rejected write from userspace.

Avoid the issue altogether by handling the AArch32 ID registers as
RAZ/WI when on an AArch64-only system.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 63 ++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6d0511247df4..9569772cf09a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1144,6 +1144,20 @@ static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static unsigned int aa32_id_visibility(const struct kvm_vcpu *vcpu,
+				       const struct sys_reg_desc *r)
+{
+	/*
+	 * AArch32 ID registers are UNKNOWN if AArch32 isn't implemented at any
+	 * EL. Promote to RAZ/WI in order to guarantee consistency between
+	 * systems.
+	 */
+	if (!kvm_supports_32bit_el0())
+		return REG_RAZ | REG_USER_WI;
+
+	return id_visibility(vcpu, r);
+}
+
 static unsigned int raz_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *r)
 {
@@ -1331,6 +1345,15 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
 	.visibility = id_visibility,		\
 }
 
+/* sys_reg_desc initialiser for known cpufeature ID registers */
+#define AA32_ID_SANITISED(name) {		\
+	SYS_DESC(SYS_##name),			\
+	.access	= access_id_reg,		\
+	.get_user = get_id_reg,			\
+	.set_user = set_id_reg,			\
+	.visibility = aa32_id_visibility,	\
+}
+
 /*
  * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
  * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
@@ -1418,33 +1441,33 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* AArch64 mappings of the AArch32 ID registers */
 	/* CRm=1 */
-	ID_SANITISED(ID_PFR0_EL1),
-	ID_SANITISED(ID_PFR1_EL1),
-	ID_SANITISED(ID_DFR0_EL1),
+	AA32_ID_SANITISED(ID_PFR0_EL1),
+	AA32_ID_SANITISED(ID_PFR1_EL1),
+	AA32_ID_SANITISED(ID_DFR0_EL1),
 	ID_HIDDEN(ID_AFR0_EL1),
-	ID_SANITISED(ID_MMFR0_EL1),
-	ID_SANITISED(ID_MMFR1_EL1),
-	ID_SANITISED(ID_MMFR2_EL1),
-	ID_SANITISED(ID_MMFR3_EL1),
+	AA32_ID_SANITISED(ID_MMFR0_EL1),
+	AA32_ID_SANITISED(ID_MMFR1_EL1),
+	AA32_ID_SANITISED(ID_MMFR2_EL1),
+	AA32_ID_SANITISED(ID_MMFR3_EL1),
 
 	/* CRm=2 */
-	ID_SANITISED(ID_ISAR0_EL1),
-	ID_SANITISED(ID_ISAR1_EL1),
-	ID_SANITISED(ID_ISAR2_EL1),
-	ID_SANITISED(ID_ISAR3_EL1),
-	ID_SANITISED(ID_ISAR4_EL1),
-	ID_SANITISED(ID_ISAR5_EL1),
-	ID_SANITISED(ID_MMFR4_EL1),
-	ID_SANITISED(ID_ISAR6_EL1),
+	AA32_ID_SANITISED(ID_ISAR0_EL1),
+	AA32_ID_SANITISED(ID_ISAR1_EL1),
+	AA32_ID_SANITISED(ID_ISAR2_EL1),
+	AA32_ID_SANITISED(ID_ISAR3_EL1),
+	AA32_ID_SANITISED(ID_ISAR4_EL1),
+	AA32_ID_SANITISED(ID_ISAR5_EL1),
+	AA32_ID_SANITISED(ID_MMFR4_EL1),
+	AA32_ID_SANITISED(ID_ISAR6_EL1),
 
 	/* CRm=3 */
-	ID_SANITISED(MVFR0_EL1),
-	ID_SANITISED(MVFR1_EL1),
-	ID_SANITISED(MVFR2_EL1),
+	AA32_ID_SANITISED(MVFR0_EL1),
+	AA32_ID_SANITISED(MVFR1_EL1),
+	AA32_ID_SANITISED(MVFR2_EL1),
 	ID_UNALLOCATED(3,3),
-	ID_SANITISED(ID_PFR2_EL1),
+	AA32_ID_SANITISED(ID_PFR2_EL1),
 	ID_HIDDEN(ID_DFR1_EL1),
-	ID_SANITISED(ID_MMFR5_EL1),
+	AA32_ID_SANITISED(ID_MMFR5_EL1),
 	ID_UNALLOCATED(3,7),
 
 	/* AArch64 ID registers */
-- 
2.37.2.789.g6183377224-goog

