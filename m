Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03BCE74DF1A
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 22:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjGJUTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 16:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjGJUTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 16:19:08 -0400
Received: from out-32.mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4B51B9
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 13:18:54 -0700 (PDT)
Date:   Mon, 10 Jul 2023 20:18:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689020332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LAPRUW6peEGGRK+R1RqPlmna3g9VSyHgb/bb91MQYh4=;
        b=aabGCv8UKyntgxxPmTkby8BsgAR6UG16PIAPImK968UyD07tXhfaHiGufqW7gkv+q0G1/+
        rzx98bAV2raKtiI9ENvIFayH/h3LgR6aYjBFmniwaELb47X87IVOk4/F1OBjq/Ymya55nD
        fwm6MgxJVzB5+9wphSqrB/Zxu92dxfs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v5 3/6] KVM: arm64: Reject attempts to set invalid debug
 arch version
Message-ID: <ZKxnp6Tm3WwXupXw@linux.dev>
References: <20230710192430.1992246-1-jingzhangos@google.com>
 <20230710192430.1992246-4-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230710192430.1992246-4-jingzhangos@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jing,

On Mon, Jul 10, 2023 at 07:24:26PM +0000, Jing Zhang wrote:
> From: Oliver Upton <oliver.upton@linux.dev>
> 
> The debug architecture is mandatory in ARMv8, so KVM should not allow
> userspace to configure a vCPU with less than that. Of course, this isn't
> handled elegantly by the generic ID register plumbing, as the respective
> ID register fields have a nonzero starting value.
> 
> Add an explicit check for debug versions less than v8 of the
> architecture.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>

This patch should be ordered before the change that permits writes to
the DebugVer field (i.e. the previous patch). While we're at it, there's
another set of prerequisites for actually making the field writable.

As Suraj pointed out earlier, we need to override the type of the field
to be FTR_LOWER_SAFE instead of EXACT. Beyond that, KVM limits the field
to 0x6, which is the minimum value for an ARMv8 implementation. We can
relax this limitation up to v8p8, as I believe all of the changes are to
external debug and wouldn't affect a KVM guest.

Below is my (untested) diff on top of your series for both of these
changes.

-- 
Thanks,
Oliver

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 78ccc95624fa..35c4ab8cb5c8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1216,8 +1216,14 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
 	/* Some features have different safe value type in KVM than host features */
 	switch (id) {
 	case SYS_ID_AA64DFR0_EL1:
-		if (kvm_ftr.shift == ID_AA64DFR0_EL1_PMUVer_SHIFT)
+		switch (kvm_ftr.shift) {
+		case ID_AA64DFR0_EL1_PMUVer_SHIFT:
 			kvm_ftr.type = FTR_LOWER_SAFE;
+			break;
+		case ID_AA64DFR0_EL1_DebugVer_SHIFT:
+			kvm_ftr.type = FTR_LOWER_SAFE;
+			break;
+		}
 		break;
 	case SYS_ID_DFR0_EL1:
 		if (kvm_ftr.shift == ID_DFR0_EL1_PerfMon_SHIFT)
@@ -1466,14 +1472,22 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return val;
 }
 
+#define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, limit)				\
+({										\
+	u64 __f_val = FIELD_GET(reg##_##field##_MASK, val);			\
+	(val) &= ~reg##_##field##_MASK;						\
+	(val) |= FIELD_PREP(reg##_##field##_MASK,				\
+			  min(__f_val, (u64)reg##_##field##_##limit));		\
+	(val);									\
+})
+
 static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 					  const struct sys_reg_desc *rd)
 {
 	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 
 	/* Limit debug to ARMv8.0 */
-	val &= ~ID_AA64DFR0_EL1_DebugVer_MASK;
-	val |= SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, DebugVer, IMP);
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
 
 	/*
 	 * Only initialize the PMU version if the vCPU was configured with one.
@@ -1529,6 +1543,8 @@ static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	u8 perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
 	u64 val = read_sanitised_ftr_reg(SYS_ID_DFR0_EL1);
 
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_DFR0_EL1, CopDbg, Debugv8p8);
+
 	val &= ~ID_DFR0_EL1_PerfMon_MASK;
 	if (kvm_vcpu_has_pmu(vcpu))
 		val |= SYS_FIELD_PREP(ID_DFR0_EL1, PerfMon, perfmon);

