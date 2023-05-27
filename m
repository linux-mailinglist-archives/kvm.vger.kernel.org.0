Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A8A71326E
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 06:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjE0EFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 May 2023 00:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237868AbjE0EFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 May 2023 00:05:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14DD116
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 21:05:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba2b9ecfadaso3096580276.2
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 21:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685160300; x=1687752300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CVdJfxalrKrA0ocQWScQBMNSin7rCXi39ddZCI6I+Lw=;
        b=PO0DcdNrgP5ptJ8hPQddsyKkA1m1XITJeCVHvd+D6lH6psREctBh/5HOysJRX8ykir
         jLhbwRKYRAxPDohZZekbUWdT0nbBsQ9KZvaNRl7TuWF2bECg+CKEw84XFxahCJpGNmjG
         LQsh5VJ+vpYOKQDTOx9ULlWjuL+ZsaVkSqKv3J10C25RvApaafyyY/VWTNAW/mWF1x1v
         ub23jkoE/KMzNuFLcfOa0Gl9/3lN+WKyYqIp/ly07rtOeFQLDF57jd1vvplhffSEBvdE
         7Az/+KeXU0dgrnDJ0l8JVkvR184IFiQ/jU4obXNBLJQqOyqHGDzgiyMbSUiFtUKxQFVt
         GTHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685160300; x=1687752300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CVdJfxalrKrA0ocQWScQBMNSin7rCXi39ddZCI6I+Lw=;
        b=cXno2BenrjelDfSPDBR9pck8l99BQK7qWydQqiHEXF/34STARWO9k9Qrjr6rE30E23
         wXty7xoEqZoQYRlGJ3ZPevy6KQfZVcaRgJ8l7dyT6Co5bJ0HjeqzZFMmsZYWfvUagJ6J
         iuvESzvstlFVyiSdzS7oDHF3DHZiTJ0nHaNzPqKk56n97GakgDz3caPtCEp7Anf9cFyL
         MxeK5bVgO9k8yUjMyTAiCrTjWnjcOhPtyU1jdi8OKx/qLguZmTlWH+zjya5KuGRCo8ki
         y3IBL226fW0FGsi/Rj8WLLBktrjiZ83ZsjpOHwgKCNmQDaOZVQHlszcyAZ/1Vg3oxXFu
         p0gg==
X-Gm-Message-State: AC+VfDwC8sdqS8q+zkTtVKNPpNXv+OPKFwQQRo9bDrALR3LVX9aDbrBX
        AzDsnlbysxw+3HipMyKpMiQKuxJlW6g=
X-Google-Smtp-Source: ACHHUZ7xYLN8vvRmoJXz8BY6YHV6oSkGdNHun+pcrFKUH5BINMpkznVSajKgNRJLTycZ6lMNKmVFYhheiy8=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:8f8d:0:b0:bac:6ba0:abe with SMTP id
 u13-20020a258f8d000000b00bac6ba00abemr2094316ybl.10.1685160299956; Fri, 26
 May 2023 21:04:59 -0700 (PDT)
Date:   Fri, 26 May 2023 21:02:35 -0700
In-Reply-To: <20230527040236.1875860-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230527040236.1875860-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230527040236.1875860-4-reijiw@google.com>
Subject: [PATCH 3/4] KVM: arm64: PMU: Use PMUVer of the guest's PMU for ID_AA64DFR0.PMUVer
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Will Deacon <will@kernel.org>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, KVM uses the sanitized value of ID_AA64DFR0_EL1.PMUVer
as the default value and the limit value of this field for
vCPUs with PMU configured. But, the sanitized value could
be inappropriate for the vCPUs on some heterogeneous PMU systems,
as arm64_ftr_bits for PMUVer is defined as FTR_EXACT with
safe_val == 0 (if the ID_AA64DFR0_EL1.PMUVer of all PEs on the
host is not uniform, the sanitized value will be 0).

Use the PMUver of the guest's PMU (kvm->arch.arm_pmu->pmuver) as the
default value and the limit value of ID_AA64DFR0_EL1.PMUVer for vCPUs
with PMU configured.

When the guest's PMU is switched to a different PMU, reset
the value of ID_AA64DFR0_EL1.PMUVer for the vCPUs based on
the new PMU, unless userspace has already modified the PMUVer
and the value is still valid even with the new PMU.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              |  6 ----
 arch/arm64/kvm/pmu-emul.c         | 28 +++++++++++++-----
 arch/arm64/kvm/sys_regs.c         | 48 ++++++++++++++++++++-----------
 include/kvm/arm_pmu.h             |  4 +--
 5 files changed, 57 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7e7e19ef6993..8ca0e7210a59 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -231,6 +231,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		7
 	/* SMCCC filter initialized for the VM */
 #define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		8
+	/* PMUVer set by userspace for the VM */
+#define KVM_ARCH_FLAG_PMUVER_DIRTY			9
 	unsigned long flags;
 
 	/*
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14391826241c..3c2fddfe90f7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -164,12 +164,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
 
-	/*
-	 * Initialise the default PMUver before there is a chance to
-	 * create an actual PMU.
-	 */
-	kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
-
 	return 0;
 
 err_free_cpumask:
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 0194a94c4bae..6cd08d5e5b72 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -871,6 +871,8 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 
 int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 {
+	u8 new_limit;
+
 	lockdep_assert_held(&kvm->arch.config_lock);
 
 	if (!arm_pmu) {
@@ -880,6 +882,22 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 	}
 
 	kvm->arch.arm_pmu = arm_pmu;
+	new_limit = kvm_arm_pmu_get_pmuver_limit(kvm);
+
+	/*
+	 * Reset the value of ID_AA64DFR0_EL1.PMUVer to the new limit value,
+	 * unless the current value was set by userspace and is still a valid
+	 * value for the new PMU.
+	 */
+	if (!test_bit(KVM_ARCH_FLAG_PMUVER_DIRTY, &kvm->arch.flags)) {
+		kvm->arch.dfr0_pmuver.imp = new_limit;
+		return 0;
+	}
+
+	if (kvm->arch.dfr0_pmuver.imp > new_limit) {
+		kvm->arch.dfr0_pmuver.imp = new_limit;
+		clear_bit(KVM_ARCH_FLAG_PMUVER_DIRTY, &kvm->arch.flags);
+	}
 
 	return 0;
 }
@@ -1049,13 +1067,9 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	return -ENXIO;
 }
 
-u8 kvm_arm_pmu_get_pmuver_limit(void)
+u8 kvm_arm_pmu_get_pmuver_limit(struct kvm *kvm)
 {
-	u64 tmp;
+	u8 host_pmuver = kvm->arch.arm_pmu ? kvm->arch.arm_pmu->pmuver : 0;
 
-	tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-	tmp = cpuid_feature_cap_perfmon_field(tmp,
-					      ID_AA64DFR0_EL1_PMUVer_SHIFT,
-					      ID_AA64DFR0_EL1_PMUVer_V3P5);
-	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), tmp);
+	return min_t(u8, host_pmuver, ID_AA64DFR0_EL1_PMUVer_V3P5);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 71b12094d613..a76155ad997c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1382,8 +1382,11 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u8 pmuver, host_pmuver;
 	bool valid_pmu;
+	u64 current_val = read_id_reg(vcpu, rd);
+	int ret = -EINVAL;
 
-	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+	host_pmuver = kvm_arm_pmu_get_pmuver_limit(vcpu->kvm);
 
 	/*
 	 * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
@@ -1393,26 +1396,31 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	 */
 	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), val);
 	if ((pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver))
-		return -EINVAL;
+		goto out;
 
 	valid_pmu = (pmuver != 0 && pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
 
 	/* Make sure view register and PMU support do match */
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
-		return -EINVAL;
+		goto out;
 
 	/* We can only differ with PMUver, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
+	val ^= current_val;
 	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
 	if (val)
-		return -EINVAL;
+		goto out;
 
-	if (valid_pmu)
+	if (valid_pmu) {
 		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
+		set_bit(KVM_ARCH_FLAG_PMUVER_DIRTY, &vcpu->kvm->arch.flags);
+	} else
 		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
 
-	return 0;
+	ret = 0;
+out:
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
+
+	return ret;
 }
 
 static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
@@ -1421,8 +1429,11 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u8 perfmon, host_perfmon;
 	bool valid_pmu;
+	u64 current_val = read_id_reg(vcpu, rd);
+	int ret = -EINVAL;
 
-	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit(vcpu->kvm));
 
 	/*
 	 * Allow DFR0_EL1.PerfMon to be set from userspace as long as
@@ -1433,26 +1444,31 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	perfmon = FIELD_GET(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), val);
 	if ((perfmon != ID_DFR0_EL1_PerfMon_IMPDEF && perfmon > host_perfmon) ||
 	    (perfmon != 0 && perfmon < ID_DFR0_EL1_PerfMon_PMUv3))
-		return -EINVAL;
+		goto out;
 
 	valid_pmu = (perfmon != 0 && perfmon != ID_DFR0_EL1_PerfMon_IMPDEF);
 
 	/* Make sure view register and PMU support do match */
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
-		return -EINVAL;
+		goto out;
 
 	/* We can only differ with PerfMon, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
+	val ^= current_val;
 	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
 	if (val)
-		return -EINVAL;
+		goto out;
 
-	if (valid_pmu)
+	if (valid_pmu) {
 		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
+		set_bit(KVM_ARCH_FLAG_PMUVER_DIRTY, &vcpu->kvm->arch.flags);
+	} else
 		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
 
-	return 0;
+	ret = 0;
+out:
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
+
+	return ret;
 }
 
 /*
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 5ece2a3c1858..00c05d17cf3a 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -95,7 +95,7 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 #define kvm_pmu_is_3p5(vcpu)						\
 	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
-u8 kvm_arm_pmu_get_pmuver_limit(void);
+u8 kvm_arm_pmu_get_pmuver_limit(struct kvm *kvm);
 int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu);
 
 #else
@@ -164,7 +164,7 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
-static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
+static inline u8 kvm_arm_pmu_get_pmuver_limit(struct kvm *kvm)
 {
 	return 0;
 }
-- 
2.41.0.rc0.172.g3f132b7071-goog

