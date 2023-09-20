Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4A27A8BDF
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 20:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjITSdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 14:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjITSdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 14:33:42 -0400
Received: from out-221.mta1.migadu.com (out-221.mta1.migadu.com [95.215.58.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4E2C9
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 11:33:36 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695234814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iPV7Ne+D4f6tM8oZ86BooYANqCEQwSlUubwmdr24AGU=;
        b=s0nSuaoxZ0QJRIX5ngOS489W8l8H9E1XvfX9+Lc9QOKMCVfENC2vWswxTtsv9p6p7S8NEy
        /pEYXJqd35ODJtAJ26PgB7Mn55Tk9cP9iRO8Yb0Ej5fy6klKQxRU5NX02KB0HiMD5wfS5Z
        GGUmp00hloEL23+XoZVUoLbUaqij1sg=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>
Subject: [PATCH v10 05/12] KVM: arm64: Bump up the default KVM sanitised debug version to v8p8
Date:   Wed, 20 Sep 2023 18:33:02 +0000
Message-ID: <20230920183310.1163034-6-oliver.upton@linux.dev>
In-Reply-To: <20230920183310.1163034-1-oliver.upton@linux.dev>
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since ID_AA64DFR0_EL1 and ID_DFR0_EL1 are now writable from userspace,
it is safe to bump up the default KVM sanitised debug version to v8p8.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fdebd9d042c3..10e3e6a736dc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1496,8 +1496,7 @@ static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 
-	/* Limit debug to ARMv8.0 */
-	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, IMP);
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
 
 	/*
 	 * Only initialize the PMU version if the vCPU was configured with one.
@@ -1557,6 +1556,8 @@ static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu))
 		val |= SYS_FIELD_PREP(ID_DFR0_EL1, PerfMon, perfmon);
 
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_DFR0_EL1, CopDbg, Debugv8p8);
+
 	return val;
 }
 
@@ -2013,7 +2014,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK, },
+	  .val = ID_DFR0_EL1_PerfMon_MASK |
+		 ID_DFR0_EL1_CopDbg_MASK, },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2062,7 +2064,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
+	  .val = ID_AA64DFR0_EL1_PMUVer_MASK |
+		 ID_AA64DFR0_EL1_DebugVer_MASK, },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.42.0.515.g380fc7ccd1-goog

