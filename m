Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3A2597944
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 23:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242395AbiHQVte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 17:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241936AbiHQVtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 17:49:18 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6440AADCFF
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:48:41 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660772919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DsgyFY0u2b55Eld2Ty6toOPtdXfQayz0KN3UeMp2bKw=;
        b=NwIIiZbY01d9zkDKLarIck4+gLDwHh/XfzJuSWkS5ZqK/uu0LkZF0DFPNTaYDmEKVVTNzx
        OXyFlBdNIIKh3JpzjXaKjuksEDkE42jrWrfgbdtiMwmQtrtwb3I9XblllNxCs+mp1nFSoZ
        DqcOU9sBcDM7Hsvu22vIPwQXbMK35DQ=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, will@kernel.org,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/6] KVM: arm64: Use visibility hook to treat ID regs as RAZ
Date:   Wed, 17 Aug 2022 21:48:13 +0000
Message-Id: <20220817214818.3243383-2-oliver.upton@linux.dev>
In-Reply-To: <20220817214818.3243383-1-oliver.upton@linux.dev>
References: <20220817214818.3243383-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The generic id reg accessors already handle RAZ registers by way of the
visibility hook. Add a visibility hook that returns REG_RAZ
unconditionally and throw out the RAZ specific accessors.

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
2.37.1.595.g718a3a8f04-goog

