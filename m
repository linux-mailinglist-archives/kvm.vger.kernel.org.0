Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3DA7C7CFF
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 07:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjJMF3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 01:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjJMF3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 01:29:18 -0400
Received: from out-208.mta0.migadu.com (out-208.mta0.migadu.com [91.218.175.208])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8355BB7
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 22:29:16 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697174954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J9QzS5CsNc2zNfmi3YAPI460UcjV/2/Vq4JBxusEpVw=;
        b=adOqca0m5TdRSXdZMWEVhKMmMUCSVxk2w3guJ6eBq7sMv9Kdl9eKPMUaelikj40+xL4C7G
        xWRnmamQlybmCGGAd3YytA9d3s1UiHLO3aRTZHqjYT2NtJYGBZNRnMVh5RfDqLs1/gZWnn
        s7ObYde3LUcOYJega9g3FL5Kw2FtH6E=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 1/2] KVM: arm64: Treat PMEVTYPER<n>_EL0.NSH as RES0
Date:   Fri, 13 Oct 2023 05:29:00 +0000
Message-ID: <20231013052901.170138-2-oliver.upton@linux.dev>
In-Reply-To: <20231013052901.170138-1-oliver.upton@linux.dev>
References: <20231013052901.170138-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prevent the guest from setting the NSH bit, which enables event counting
while the PE is in EL2. kvm_pmu_create_perf_event() never wired up the
bit, nor does it make any sense in the context of a guest without NV.

While at it, build the event type mask using explicit field definitions
instead of relying on ARMV8_PMU_EVTYPE_MASK. KVM probably should've been
doing this in the first place, as it avoids changes to the
aforementioned mask affecting sysreg emulation.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 15 ++++++++-------
 arch/arm64/kvm/sys_regs.c |  8 ++++++--
 include/kvm/arm_pmu.h     |  5 +++++
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 6b066e04dc5d..f0d4a9ace5ad 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -60,6 +60,12 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
 	return __kvm_pmu_event_mask(pmuver);
 }
 
+u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
+{
+	return ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0 |
+	       kvm_pmu_event_mask(kvm);
+}
+
 /**
  * kvm_pmc_is_64bit - determine if counter is 64bit
  * @pmc: counter context
@@ -657,18 +663,13 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx)
 {
 	struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, select_idx);
-	u64 reg, mask;
+	u64 reg;
 
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
-	mask  =  ARMV8_PMU_EVTYPE_MASK;
-	mask &= ~ARMV8_PMU_EVTYPE_EVENT;
-	mask |= kvm_pmu_event_mask(vcpu->kvm);
-
 	reg = counter_index_to_evtreg(pmc->idx);
-
-	__vcpu_sys_reg(vcpu, reg) = data & mask;
+	__vcpu_sys_reg(vcpu, reg) = data & kvm_pmu_evtyper_mask(vcpu->kvm);
 
 	kvm_pmu_create_perf_event(pmc);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e92ec810d449..78720c373904 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -746,8 +746,12 @@ static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 static u64 reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
+	/* This thing will UNDEF, who cares about the reset value? */
+	if (!kvm_vcpu_has_pmu(vcpu))
+		return 0;
+
 	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_EVTYPE_MASK;
+	__vcpu_sys_reg(vcpu, r->reg) &= kvm_pmu_evtyper_mask(vcpu->kvm);
 
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
@@ -988,7 +992,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
 		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_MASK;
+		p->regval = __vcpu_sys_reg(vcpu, reg);
 	}
 
 	return true;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 31029f4f7be8..e0bcf447a2ab 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -101,6 +101,7 @@ void kvm_vcpu_pmu_resync_el0(void);
 })
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
+u64 kvm_pmu_evtyper_mask(struct kvm *kvm);
 
 #else
 struct kvm_pmu {
@@ -172,6 +173,10 @@ static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
 {
 	return 0;
 }
+static inline u64 kvm_pmu_evtyper_mask(void)
+{
+	return 0;
+}
 static inline void kvm_vcpu_pmu_resync_el0(void) {}
 
 #endif
-- 
2.42.0.655.g421f12c284-goog

