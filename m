Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD5C61EE97
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 10:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbiKGJQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 04:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiKGJQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 04:16:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4F9F49
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 01:16:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA904B80E81
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 09:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB69C433C1;
        Mon,  7 Nov 2022 09:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667812596;
        bh=gD4PF7cAArEfS6fdJ991o2KmRs2YiRdG7lGjbcMMicU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPh3dkVa3jzCX/uj0iucRxgnk/XaF1c7wd22R/AH/l36tBtHrutfyVmQsoJbUeZCP
         Xzw7AZ7IXNOLbZA1j8l98SCSeDAZoYDM0Y1AKvCg27WvGxSsnaK148XuW9fvikM5QG
         k3/aP/H6lsNyaRcEGn3i2rHHB4S006/w8ggIepg7Ce2klsDSjkRZJbBbjs76ZioaTE
         8/ZiIQ8/7gGMLdZShNV1wt/Xqowrkes2pnjaOww14X3Im5QIxLS8xlc3Ezd8uh9lxQ
         Cyt/uo4ag15HB08N0c6CVo43i8PjcSDv8XYPVTQT3SFZxrSLdR3cFYV9x5T8sM3BvU
         a+er4Tk7DouGw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1orxuD-004KxX-O7;
        Mon, 07 Nov 2022 08:54:57 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: [PATCH v3 10/14] KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver limit to VM creation
Date:   Mon,  7 Nov 2022 08:54:31 +0000
Message-Id: <20221107085435.2581641-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107085435.2581641-1-maz@kernel.org>
References: <20221107085435.2581641-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As further patches will enable the selection of a PMU revision
from userspace, sample the supported PMU revision at VM creation
time, rather than building each time the ID_AA64DFR0_EL1 register
is accessed.

This shouldn't result in any change in behaviour.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  6 +++++
 arch/arm64/kvm/pmu-emul.c         | 11 +++++++++
 arch/arm64/kvm/sys_regs.c         | 41 +++++++++++++++++++++++++------
 include/kvm/arm_pmu.h             |  6 +++++
 5 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 45e2136322ba..90c9a2dd3f26 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -163,6 +163,7 @@ struct kvm_arch {
 
 	u8 pfr0_csv2;
 	u8 pfr0_csv3;
+	u8 dfr0_pmuver;
 
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d33e296e10..6b3ed524630d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -164,6 +164,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
 
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	kvm->arch.dfr0_pmuver = kvm_arm_pmu_get_pmuver_limit();
+
 	return ret;
 out_free_stage2_pgd:
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 87585c12ca41..f126b45aa6c6 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1049,3 +1049,14 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 	return -ENXIO;
 }
+
+u8 kvm_arm_pmu_get_pmuver_limit(void)
+{
+	u64 tmp;
+
+	tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+	tmp = cpuid_feature_cap_perfmon_field(tmp,
+					      ID_AA64DFR0_EL1_PMUVer_SHIFT,
+					      ID_AA64DFR0_EL1_PMUVer_V3P4);
+	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), tmp);
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f4a7c5abcbca..7a4cd644b9c0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1062,6 +1062,32 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_has_pmu(vcpu))
+		return vcpu->kvm->arch.dfr0_pmuver;
+
+	/* Special case for IMPDEF PMUs that KVM has exposed in the past... */
+	if (vcpu->kvm->arch.dfr0_pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
+		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
+
+	/* The real "no PMU" */
+	return 0;
+}
+
+static u8 pmuver_to_perfmon(u8 pmuver)
+{
+	switch (pmuver) {
+	case ID_AA64DFR0_EL1_PMUVer_IMP:
+		return ID_DFR0_PERFMON_8_0;
+	case ID_AA64DFR0_EL1_PMUVer_IMP_DEF:
+		return ID_DFR0_PERFMON_IMP_DEF;
+	default:
+		/* Anything ARMv8.1+ has the same value. For now. */
+		return pmuver;
+	}
+}
+
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
 static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
 {
@@ -1111,18 +1137,17 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
 		/* Limit debug to ARMv8.0 */
 		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), 6);
-		/* Limit guests to PMUv3 for ARMv8.4 */
-		val = cpuid_feature_cap_perfmon_field(val,
-						      ID_AA64DFR0_EL1_PMUVer_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_EL1_PMUVer_V3P4 : 0);
+		/* Set PMUver to the required version */
+		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+				  vcpu_pmuver(vcpu));
 		/* Hide SPE from guests */
 		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
 		break;
 	case SYS_ID_DFR0_EL1:
-		/* Limit guests to PMUv3 for ARMv8.4 */
-		val = cpuid_feature_cap_perfmon_field(val,
-						      ID_DFR0_PERFMON_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
+		val &= ~ARM64_FEATURE_MASK(ID_DFR0_PERFMON);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_PERFMON),
+				  pmuver_to_perfmon(vcpu_pmuver(vcpu)));
 		break;
 	}
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 96b192139a23..812f729c9108 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -89,6 +89,8 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 			vcpu->arch.pmu.events = *kvm_get_pmu_events();	\
 	} while (0)
 
+u8 kvm_arm_pmu_get_pmuver_limit(void);
+
 #else
 struct kvm_pmu {
 };
@@ -154,6 +156,10 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
+static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
+{
+	return 0;
+}
 
 #endif
 
-- 
2.34.1

