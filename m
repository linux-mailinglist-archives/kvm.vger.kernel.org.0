Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96FE158AC07
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 15:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbiHEN7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 09:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240875AbiHEN6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 09:58:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283F065836
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 06:58:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91F0AB82942
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 13:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AED9C43140;
        Fri,  5 Aug 2022 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659707902;
        bh=zoR8xUqf5VOpW4qpOygOpmFjWKp1aJaDtJXBxFC1+0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ED80D3RkUlUESHwGpRjYKKC8p5LFdFBTlDElxX3AH/JkD52Z2FnXrxMikZfk5zArF
         fF9dPQxJn8i91ZdWRiyjt5JZShvr4V9LIC4rj9Jllm52yaiEkwKGvHUPjXPIl7iakJ
         tB4PSJ7D42w0TCKAMHORLkmOFqwKPgKmUpIk1mAjZq/yCsc3IThOTg/wfcradgiUEJ
         YcVqnMHcX5Z2II8F8GY/X4GDcurdXvJ38Ja/a9qKzcIG+i9l1Md9Gd65a5Ja5401K0
         QZmXISxlpwWcdHwSH7/DOYwFtADu6xlAql4vDMTUSiYcZgq62s2bJcUkQgXlUJuprw
         /u5M59oJ8bv2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oJxqG-001AeL-FK;
        Fri, 05 Aug 2022 14:58:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>, kernel-team@android.com
Subject: [PATCH 6/9] KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver limit to VM creation
Date:   Fri,  5 Aug 2022 14:58:10 +0100
Message-Id: <20220805135813.2102034-7-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220805135813.2102034-1-maz@kernel.org>
References: <20220805135813.2102034-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  6 ++++++
 arch/arm64/kvm/pmu-emul.c         | 11 +++++++++++
 arch/arm64/kvm/sys_regs.c         | 26 +++++++++++++++++++++-----
 include/kvm/arm_pmu.h             |  6 ++++++
 5 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f38ef299f13b..411114510634 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -163,6 +163,7 @@ struct kvm_arch {
 
 	u8 pfr0_csv2;
 	u8 pfr0_csv3;
+	u8 dfr0_pmuver;
 
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8fe73ee5fa84..e4f80f0c1e97 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -164,6 +164,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
 
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	kvm->arch.dfr0_pmuver = kvm_arm_pmu_get_host_pmuver();
+
 	return ret;
 out_free_stage2_pgd:
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index ddd79b64b38a..33a88ca7b7fd 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1021,3 +1021,14 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 	return -ENXIO;
 }
+
+u8 kvm_arm_pmu_get_host_pmuver(void)
+{
+	u64 tmp;
+
+	tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+	tmp = cpuid_feature_cap_perfmon_field(tmp,
+					      ID_AA64DFR0_PMUVER_SHIFT,
+					      ID_AA64DFR0_PMUVER_8_4);
+	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), tmp);
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 333efddb1e27..55451f49017c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1062,6 +1062,22 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static u8 pmuver_to_perfmon(const struct kvm_vcpu *vcpu)
+{
+	if (!kvm_vcpu_has_pmu(vcpu))
+		return 0;
+
+	switch (vcpu->kvm->arch.dfr0_pmuver) {
+	case ID_AA64DFR0_PMUVER_8_0:
+		return ID_DFR0_PERFMON_8_0;
+	case ID_AA64DFR0_PMUVER_IMP_DEF:
+		return 0;
+	default:
+		/* Anything ARMv8.4+ has the same value. For now. */
+		return vcpu->kvm->arch.dfr0_pmuver;
+	}
+}
+
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
@@ -1112,10 +1128,10 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		/* Limit debug to ARMv8.0 */
 		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6);
-		/* Limit guests to PMUv3 for ARMv8.4 */
-		val = cpuid_feature_cap_perfmon_field(val,
-						      ID_AA64DFR0_PMUVER_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
+		/* Set PMUver to the required version */
+		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER),
+				  kvm_vcpu_has_pmu(vcpu) ? vcpu->kvm->arch.dfr0_pmuver : 0);
 		/* Hide SPE from guests */
 		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER);
 		break;
@@ -1123,7 +1139,7 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		/* Limit guests to PMUv3 for ARMv8.4 */
 		val = cpuid_feature_cap_perfmon_field(val,
 						      ID_DFR0_PERFMON_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
+						      pmuver_to_perfmon(vcpu));
 		break;
 	}
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 96b192139a23..6bda9b071084 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -89,6 +89,8 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 			vcpu->arch.pmu.events = *kvm_get_pmu_events();	\
 	} while (0)
 
+u8 kvm_arm_pmu_get_host_pmuver(void);
+
 #else
 struct kvm_pmu {
 };
@@ -154,6 +156,10 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
+static inline u8 kvm_arm_pmu_get_host_pmuver(void)
+{
+	return 0;
+}
 
 #endif
 
-- 
2.34.1

