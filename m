Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7198720BC7
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 00:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236162AbjFBWPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 18:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbjFBWPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 18:15:04 -0400
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164C21BC
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 15:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685744103; x=1717280103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HXE0fDLOEs7j1TW6PF3FEXVGqXW2NKvsNmy+oRJV/2s=;
  b=b6P/czDqHUW7DwEQovVAWbKuBsAo7vUfwEM6q3Ktr5/hm24iiVHT1KRl
   hegHGbWBg2wLChmlDmuuxrsz8aFOmCwsF1qIZ3IxZURy+ww5BCtVEx7XV
   GZ3VoA2kTlFkqeDKZ6+VPJpA2mEj3bx8VSt8MFvFXZW7v4sWhdeyvZhYp
   M=;
X-IronPort-AV: E=Sophos;i="6.00,214,1681171200"; 
   d="scan'208";a="589129086"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 22:15:01 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com (Postfix) with ESMTPS id AED7582279;
        Fri,  2 Jun 2023 22:14:59 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 22:14:59 +0000
Received: from u1e958862c3245e.ant.amazon.com (10.187.170.26) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 22:14:58 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <jingzhangos@google.com>
CC:     <alexandru.elisei@arm.com>, <james.morse@arm.com>,
        <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
        <linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>,
        <oupton@google.com>, <pbonzini@redhat.com>, <rananta@google.com>,
        <reijiw@google.com>, <suzuki.poulose@arm.com>, <tabba@google.com>,
        <will@kernel.org>, <sjitindarsingh@gmail.com>,
        "Suraj Jitindar Singh" <surajjs@amazon.com>
Subject: [PATCH 2/3] KVM: arm64: Move non per vcpu flag checks out of kvm_arm_update_id_reg()
Date:   Fri, 2 Jun 2023 15:14:46 -0700
Message-ID: <20230602221447.1809849-3-surajjs@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230602221447.1809849-1-surajjs@amazon.com>
References: <20230602005118.2899664-1-jingzhangos@google.com>
 <20230602221447.1809849-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.26]
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are features which are masked in kvm_arm_update_id_reg() which cannot
change throughout the lifecycle of a VM. Thus rather than masking them each
time the register is read, mask them at idreg init time so that the value
in the kvm id_reg correctly reflects the state of support for that feature.

Move masking of AA64PFR0_EL1.GIC and AA64PFR0_EL1.AMU into
read_sanitised_id_aa64pfr0_el1().
Create read_sanitised_id_aa64pfr1_el1() and mask AA64PFR1_EL1.SME.
Create read_sanitised_id_[mmfr4|aa64mmfr2] and mask CCIDX.

Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
---
 arch/arm64/kvm/sys_regs.c | 104 +++++++++++++++++++++++++++++++-------
 1 file changed, 86 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a4e662bd218b..59f8adda47fa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1355,16 +1355,10 @@ static u64 kvm_arm_update_id_reg(const struct kvm_vcpu *vcpu, u32 encoding, u64
 	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
-		if (kvm_vgic_global_state.type == VGIC_V3) {
-			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
-			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
-		}
 		break;
 	case SYS_ID_AA64PFR1_EL1:
 		if (!kvm_has_mte(vcpu->kvm))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE);
-
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
@@ -1377,8 +1371,6 @@ static u64 kvm_arm_update_id_reg(const struct kvm_vcpu *vcpu, u32 encoding, u64
 		if (!vcpu_has_ptrauth(vcpu))
 			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3) |
 				 ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3));
-		if (!cpus_have_final_cap(ARM64_HAS_WFXT))
-			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
 		break;
 	case SYS_ID_AA64DFR0_EL1:
 		/* Set PMUver to the required version */
@@ -1391,12 +1383,6 @@ static u64 kvm_arm_update_id_reg(const struct kvm_vcpu *vcpu, u32 encoding, u64
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
 				  pmuver_to_perfmon(vcpu_pmuver(vcpu)));
 		break;
-	case SYS_ID_AA64MMFR2_EL1:
-		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
-		break;
-	case SYS_ID_MMFR4_EL1:
-		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
-		break;
 	}
 
 	return val;
@@ -1490,6 +1476,20 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static u64 read_sanitised_id_mmfr4_el1(struct kvm_vcpu *vcpu,
+				       const struct sys_reg_desc *rd)
+{
+	u64 val;
+	u32 id = reg_to_encoding(rd);
+
+	val = read_sanitised_ftr_reg(id);
+
+	/* CCIDX is not supported */
+	val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
+
+	return val;
+}
+
 static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 					  const struct sys_reg_desc *rd)
 {
@@ -1516,6 +1516,25 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 
 	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
 
+	if (kvm_vgic_global_state.type == VGIC_V3) {
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
+	}
+
+	return val;
+}
+
+static u64 read_sanitised_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
+					  const struct sys_reg_desc *rd)
+{
+	u64 val;
+	u32 id = reg_to_encoding(rd);
+
+	val = read_sanitised_ftr_reg(id);
+
+	/* SME is not supported */
+	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);
+
 	return val;
 }
 
@@ -1638,6 +1657,34 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return pmuver_update(vcpu, rd, val, perfmon_to_pmuver(perfmon), valid_pmu);
 }
 
+static u64 read_sanitised_id_aa64isar2_el1(struct kvm_vcpu *vcpu,
+					   const struct sys_reg_desc *rd)
+{
+	u64 val;
+	u32 id = reg_to_encoding(rd);
+
+	val = read_sanitised_ftr_reg(id);
+
+	if (!cpus_have_final_cap(ARM64_HAS_WFXT))
+		val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
+
+	return val;
+}
+
+static u64 read_sanitised_id_aa64mmfr2_el1(struct kvm_vcpu *vcpu,
+					   const struct sys_reg_desc *rd)
+{
+	u64 val;
+	u32 id = reg_to_encoding(rd);
+
+	val = read_sanitised_ftr_reg(id);
+
+	/* CCIDX is not supported */
+	val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
+
+	return val;
+}
+
 /*
  * cpufeature ID register user accessors
  *
@@ -2033,7 +2080,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	AA32_ID_SANITISED(ID_ISAR3_EL1),
 	AA32_ID_SANITISED(ID_ISAR4_EL1),
 	AA32_ID_SANITISED(ID_ISAR5_EL1),
-	AA32_ID_SANITISED(ID_MMFR4_EL1),
+	{ SYS_DESC(SYS_ID_MMFR4_EL1),
+	  .access     = access_id_reg,
+	  .get_user   = get_id_reg,
+	  .set_user   = set_id_reg,
+	  .visibility = aa32_id_visibility,
+	  .reset      = read_sanitised_id_mmfr4_el1,
+	  .val        = 0, },
 	AA32_ID_SANITISED(ID_ISAR6_EL1),
 
 	/* CRm=3 */
@@ -2054,7 +2107,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_id_reg,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
 	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
-	ID_SANITISED(ID_AA64PFR1_EL1),
+	{ SYS_DESC(SYS_ID_AA64PFR1_EL1),
+	  .access   = access_id_reg,
+	  .get_user = get_id_reg,
+	  .set_user = set_id_reg,
+	  .reset    = read_sanitised_id_aa64pfr1_el1,
+	  .val      = 0, },
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
 	ID_SANITISED(ID_AA64ZFR0_EL1),
@@ -2080,7 +2138,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* CRm=6 */
 	ID_SANITISED(ID_AA64ISAR0_EL1),
 	ID_SANITISED(ID_AA64ISAR1_EL1),
-	ID_SANITISED(ID_AA64ISAR2_EL1),
+	{ SYS_DESC(SYS_ID_AA64ISAR2_EL1),
+	  .access   = access_id_reg,
+	  .get_user = get_id_reg,
+	  .set_user = set_id_reg,
+	  .reset    = read_sanitised_id_aa64isar2_el1,
+	  .val      = 0, },
 	ID_UNALLOCATED(6,3),
 	ID_UNALLOCATED(6,4),
 	ID_UNALLOCATED(6,5),
@@ -2090,7 +2153,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* CRm=7 */
 	ID_SANITISED(ID_AA64MMFR0_EL1),
 	ID_SANITISED(ID_AA64MMFR1_EL1),
-	ID_SANITISED(ID_AA64MMFR2_EL1),
+	{ SYS_DESC(SYS_ID_AA64MMFR2_EL1),
+	  .access   = access_id_reg,
+	  .get_user = get_id_reg,
+	  .set_user = set_id_reg,
+	  .reset    = read_sanitised_id_aa64mmfr2_el1,
+	  .val      = 0, },
 	ID_UNALLOCATED(7,3),
 	ID_UNALLOCATED(7,4),
 	ID_UNALLOCATED(7,5),
-- 
2.34.1

