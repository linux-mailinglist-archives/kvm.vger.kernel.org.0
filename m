Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541D97D185B
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 23:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbjJTVlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 17:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbjJTVlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 17:41:15 -0400
Received: from mail-ot1-x349.google.com (mail-ot1-x349.google.com [IPv6:2607:f8b0:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBAF10CC
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:41:02 -0700 (PDT)
Received: by mail-ot1-x349.google.com with SMTP id 46e09a7af769-6c4d128e090so1865700a34.1
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838062; x=1698442862; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hSrXoi5TDQ0wnG/0Nd2sUM6CDNcuaYRq6rz2yKTajHM=;
        b=sXu9GamCOhjtWDSwBnYnlfqLcolLOBBJnob5QhwiklcOWKBmWh9JMTbDkCUqF2yjn/
         gOWtdu3X1tsX1WagQI8/xCrw6qat+Sg06fSf0i+rZSvgEIlnHCvU7Xqh7YLy7Etxy1Qx
         AWaXPEY5RR9hGathH6MFDconeu6f9ilGGTWKNelVRgCasufNUjsGiYWrvikx7CZo7hEY
         SseQ3f1mtT89ZDU9W8oveO6ihRIFBDjB8XDr5nnCfs9BRIZWSbxg5hhvCVk6Unn/n+as
         ff+fgj/IJGG+GYmb5X/pHHKw1S4trOTKQEXBWmHuTwlwGoBa7Q5Uti5YriMFBcfMsTaY
         nvRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838062; x=1698442862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hSrXoi5TDQ0wnG/0Nd2sUM6CDNcuaYRq6rz2yKTajHM=;
        b=HdgWA7+as8f2cA8nTu3SP3cW4ufCpTp4SLuQJnshOuYOQR6xZxn5eXBjHGUE8KZxg3
         iFlgsPNlc9wSNHq1h3LlzTef80d9NdKx20JKrpDpmjeoLNyt+PKduovVVGxj6sFIUvE0
         btEJfEHQwH6jW3iV2oXhAB2uy9u9oe/vDBvRmLk1Y6TVa7ffE565kvKyfMUbiQPurdf+
         yhcp7mwqP7xprv2tWrNgLdCIfvjDHl3bOWUBKLQ9lSlv0zCOnAn0g3yE66VIhIP9AX77
         d6+FnU92i9+5MzqwCFGQ2MYT2A9wVcyLyLvDOjM9MubynBDE03z6t8kr8nFiKO14eVu3
         e7FA==
X-Gm-Message-State: AOJu0YzaH1lyxrCLiqntyc0nhWg+A4t6nCjHp4bIatQbcKLb9Lh+SiHO
        /R+OuDqfmnYCe8yTxcw+YzJsvsC4pc5H
X-Google-Smtp-Source: AGHT+IFJqyHvsAhBFGWa8RbM0GaRa8vnaP3vXD/CJFEq612x9pQyV0ppNsns19cnmmWbeODxydr05GC904O7
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a9d:7f90:0:b0:6c4:a036:cc11 with SMTP id
 t16-20020a9d7f90000000b006c4a036cc11mr838958otp.2.1697838061951; Fri, 20 Oct
 2023 14:41:01 -0700 (PDT)
Date:   Fri, 20 Oct 2023 21:40:45 +0000
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
Mime-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-6-rananta@google.com>
Subject: [PATCH v8 05/13] KVM: arm64: Add {get,set}_user for
 PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For unimplemented counters, the bits in PM{C,I}NTEN{SET,CLR} and
PMOVS{SET,CLR} registers are expected to RAZ. To honor this,
explicitly implement the {get,set}_user functions for these
registers to mask out unimplemented counters for userspace reads
and writes.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/sys_regs.c | 91 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 85 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index faf97878dfbbb..2e5d497596ef8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -987,6 +987,45 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static void set_pmreg_for_valid_counters(struct kvm_vcpu *vcpu,
+					  u64 reg, u64 val, bool set)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	/* Make the register immutable once the VM has started running */
+	if (kvm_vm_has_ran_once(kvm)) {
+		mutex_unlock(&kvm->arch.config_lock);
+		return;
+	}
+
+	val &= kvm_pmu_valid_counter_mask(vcpu);
+	mutex_unlock(&kvm->arch.config_lock);
+
+	if (set)
+		__vcpu_sys_reg(vcpu, reg) |= val;
+	else
+		__vcpu_sys_reg(vcpu, reg) &= ~val;
+}
+
+static int get_pmcnten(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			u64 *val)
+{
+	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+
+	*val = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
+	return 0;
+}
+
+static int set_pmcnten(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			u64 val)
+{
+	/* r->Op2 & 0x1: true for PMCNTENSET_EL0, else PMCNTENCLR_EL0 */
+	set_pmreg_for_valid_counters(vcpu, PMCNTENSET_EL0, val, r->Op2 & 0x1);
+	return 0;
+}
+
 static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
@@ -1015,6 +1054,23 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static int get_pminten(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			u64 *val)
+{
+	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+
+	*val = __vcpu_sys_reg(vcpu, PMINTENSET_EL1) & mask;
+	return 0;
+}
+
+static int set_pminten(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			u64 val)
+{
+	/* r->Op2 & 0x1: true for PMINTENSET_EL1, else PMINTENCLR_EL1 */
+	set_pmreg_for_valid_counters(vcpu, PMINTENSET_EL1, val, r->Op2 & 0x1);
+	return 0;
+}
+
 static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
@@ -1039,6 +1095,23 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static int set_pmovs(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		      u64 val)
+{
+	/* r->CRm & 0x2: true for PMOVSSET_EL0, else PMOVSCLR_EL0 */
+	set_pmreg_for_valid_counters(vcpu, PMOVSSET_EL0, val, r->CRm & 0x2);
+	return 0;
+}
+
+static int get_pmovs(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		      u64 *val)
+{
+	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+
+	*val = __vcpu_sys_reg(vcpu, PMOVSSET_EL0) & mask;
+	return 0;
+}
+
 static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
@@ -2184,9 +2257,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* PMBIDR_EL1 is not trapped */
 
 	{ PMU_SYS_REG(PMINTENSET_EL1),
-	  .access = access_pminten, .reg = PMINTENSET_EL1 },
+	  .access = access_pminten, .reg = PMINTENSET_EL1,
+	  .get_user = get_pminten, .set_user = set_pminten },
 	{ PMU_SYS_REG(PMINTENCLR_EL1),
-	  .access = access_pminten, .reg = PMINTENSET_EL1 },
+	  .access = access_pminten, .reg = PMINTENSET_EL1,
+	  .get_user = get_pminten, .set_user = set_pminten },
 	{ SYS_DESC(SYS_PMMIR_EL1), trap_raz_wi },
 
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
@@ -2237,11 +2312,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
 	  .reset = reset_pmcr, .reg = PMCR_EL0, .get_user = get_pmcr },
 	{ PMU_SYS_REG(PMCNTENSET_EL0),
-	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
+	  .access = access_pmcnten, .reg = PMCNTENSET_EL0,
+	  .get_user = get_pmcnten, .set_user = set_pmcnten },
 	{ PMU_SYS_REG(PMCNTENCLR_EL0),
-	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
+	  .access = access_pmcnten, .reg = PMCNTENSET_EL0,
+	  .get_user = get_pmcnten, .set_user = set_pmcnten },
 	{ PMU_SYS_REG(PMOVSCLR_EL0),
-	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
+	  .access = access_pmovs, .reg = PMOVSSET_EL0,
+	  .get_user = get_pmovs, .set_user = set_pmovs },
 	/*
 	 * PM_SWINC_EL0 is exposed to userspace as RAZ/WI, as it was
 	 * previously (and pointlessly) advertised in the past...
@@ -2269,7 +2347,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(PMUSERENR_EL0), .access = access_pmuserenr,
 	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
 	{ PMU_SYS_REG(PMOVSSET_EL0),
-	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
+	  .access = access_pmovs, .reg = PMOVSSET_EL0,
+	  .get_user = get_pmovs, .set_user = set_pmovs },
 
 	{ SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
 	{ SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
-- 
2.42.0.655.g421f12c284-goog

