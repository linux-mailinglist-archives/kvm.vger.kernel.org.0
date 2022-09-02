Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195A15AB5CE
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 17:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbiIBPy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 11:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236195AbiIBPxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 11:53:52 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B505578AB;
        Fri,  2 Sep 2022 08:48:22 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662133700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IuRy/z6zWaT4tWq9BC2uDCxijBzfaMRVxZ9O7MuDW88=;
        b=hFWASiefsjiDwcFZaW0i9egZCMumjLbA+Lsna/lKINXAnWl/mVGzOnkGxfjGF9OgGf3Mky
        LxbmvMufUk7BmWP5ofj2VHhU/xvWoz4EIcrb1fhVvpLjZQd8DlnCzC/HEXnuOOcg7+kvsG
        1kKjrBumdJfeO23egRfzAa0jEzYesF8=
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
Subject: [PATCH v2 2/7] KVM: arm64: Remove internal accessor helpers for id regs
Date:   Fri,  2 Sep 2022 15:47:58 +0000
Message-Id: <20220902154804.1939819-3-oliver.upton@linux.dev>
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

The internal accessors are only ever called once. Dump out their
contents in the caller.

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 46 ++++++++++-----------------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e18efb9211f0..26210f3a0b27 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1153,25 +1153,17 @@ static unsigned int raz_visibility(const struct kvm_vcpu *vcpu,
 
 /* cpufeature ID register access trap handlers */
 
-static bool __access_id_reg(struct kvm_vcpu *vcpu,
-			    struct sys_reg_params *p,
-			    const struct sys_reg_desc *r,
-			    bool raz)
-{
-	if (p->is_write)
-		return write_to_read_only(vcpu, p, r);
-
-	p->regval = read_id_reg(vcpu, r, raz);
-	return true;
-}
-
 static bool access_id_reg(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
 	bool raz = sysreg_visible_as_raz(vcpu, r);
 
-	return __access_id_reg(vcpu, p, r, raz);
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = read_id_reg(vcpu, r, raz);
+	return true;
 }
 
 /* Visibility overrides for SVE-specific control registers */
@@ -1226,31 +1218,13 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
  * are stored, and for set_id_reg() we don't allow the effective value
  * to be changed.
  */
-static int __get_id_reg(const struct kvm_vcpu *vcpu,
-			const struct sys_reg_desc *rd, u64 *val,
-			bool raz)
-{
-	*val = read_id_reg(vcpu, rd, raz);
-	return 0;
-}
-
-static int __set_id_reg(const struct kvm_vcpu *vcpu,
-			const struct sys_reg_desc *rd, u64 val,
-			bool raz)
-{
-	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd, raz))
-		return -EINVAL;
-
-	return 0;
-}
-
 static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 *val)
 {
 	bool raz = sysreg_visible_as_raz(vcpu, rd);
 
-	return __get_id_reg(vcpu, rd, val, raz);
+	*val = read_id_reg(vcpu, rd, raz);
+	return 0;
 }
 
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
@@ -1258,7 +1232,11 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 {
 	bool raz = sysreg_visible_as_raz(vcpu, rd);
 
-	return __set_id_reg(vcpu, rd, val, raz);
+	/* This is what we mean by invariant: you can't change it. */
+	if (val != read_id_reg(vcpu, rd, raz))
+		return -EINVAL;
+
+	return 0;
 }
 
 static int get_raz_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-- 
2.37.2.789.g6183377224-goog

