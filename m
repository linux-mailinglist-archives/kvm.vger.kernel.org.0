Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D705B6B0F
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 11:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiIMJpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 05:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiIMJpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 05:45:03 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB0F120A3;
        Tue, 13 Sep 2022 02:45:02 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663062300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V+RWoL1wzjJGeI+4GkZqTh7LiWlA393Xc2eG5qmGIME=;
        b=sGjZR6oSYqK+gKGoH63m+llr/Y7xpJkHl9Zwn4HsW9cW7OFGcBMEHSmWVo9jRLmo9qHSfm
        BsznyW9armHwNjAkAuDQ3Wf/0slYDzAEES0z+PHaFTTvFJwS5QaWftc1BZBZlsV+vmTs17
        jwqvytRaLTzTFaJgFPxpc1kpzSbLgdk=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/7] KVM: arm64: Drop raz parameter from read_id_reg()
Date:   Tue, 13 Sep 2022 09:44:36 +0000
Message-Id: <20220913094441.3957645-4-oliver.upton@linux.dev>
In-Reply-To: <20220913094441.3957645-1-oliver.upton@linux.dev>
References: <20220913094441.3957645-1-oliver.upton@linux.dev>
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

There is no longer a need for caller-specified RAZ visibility. Hoist the
call to sysreg_visible_as_raz() into read_id_reg() and drop the
parameter.

No functional change intended.

Suggested-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 26210f3a0b27..0e20a311ea20 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1063,13 +1063,12 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 }
 
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu,
-		struct sys_reg_desc const *r, bool raz)
+static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
 {
 	u32 id = reg_to_encoding(r);
 	u64 val;
 
-	if (raz)
+	if (sysreg_visible_as_raz(vcpu, r))
 		return 0;
 
 	val = read_sanitised_ftr_reg(id);
@@ -1157,12 +1156,10 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	bool raz = sysreg_visible_as_raz(vcpu, r);
-
 	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
 
-	p->regval = read_id_reg(vcpu, r, raz);
+	p->regval = read_id_reg(vcpu, r);
 	return true;
 }
 
@@ -1199,7 +1196,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= read_id_reg(vcpu, rd, false);
+	val ^= read_id_reg(vcpu, rd);
 	val &= ~((0xFUL << ID_AA64PFR0_CSV2_SHIFT) |
 		 (0xFUL << ID_AA64PFR0_CSV3_SHIFT));
 	if (val)
@@ -1221,19 +1218,15 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 *val)
 {
-	bool raz = sysreg_visible_as_raz(vcpu, rd);
-
-	*val = read_id_reg(vcpu, rd, raz);
+	*val = read_id_reg(vcpu, rd);
 	return 0;
 }
 
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val)
 {
-	bool raz = sysreg_visible_as_raz(vcpu, rd);
-
 	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd, raz))
+	if (val != read_id_reg(vcpu, rd))
 		return -EINVAL;
 
 	return 0;
-- 
2.37.2.789.g6183377224-goog

