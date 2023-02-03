Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C88F688E81
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 05:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjBCEWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 23:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjBCEWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 23:22:36 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A699774
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 20:22:33 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id h14-20020a258a8e000000b00827819f87e5so3795312ybl.0
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 20:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zNambxZo/zJEKdZ21/UzwbR/QB5YuwhFt4sLsPMGzRM=;
        b=ZXWg2YKjmgm8ZlDFLgf/h3LV7rsep5h+hB+GPf+f/Hp2pGFBB+QuUTJEfdOyPK43IM
         7laY1MW/Zic6ekY1+j6LKyqnoXJMzMWal+uq++tOE9209KooB6lJ8AQ+LJd42h+4o+6f
         ge/fxxPWWOuoD398oUXnpHIiZAAm9rIHay5LZL1MsUzc88Sdy+cjlid+9ZPVO6+cyU2r
         NPAxpdEB/PU+orfZJ5rf9GLhbyd6qKfdGHBSwW9w3aMoy4XSh8cAoKERa01VkJVjgOJ1
         1lV/kheaWCTEiXzzb4TRzXxEJchtdQS9cAvdFW5vgUn9ehiz//B+XA89XGQBVVmhBiFd
         NEEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zNambxZo/zJEKdZ21/UzwbR/QB5YuwhFt4sLsPMGzRM=;
        b=GOKChqJYEcxFEh2pR3AknIZr2OCQuKA96+kQB/l+NvE5Jkmb+6TXkdV53NMB5fsCL8
         i3OXJXcL4IdijyiKWvRAhDMYTwB2yNO0dHM0gCHPAVrPWmEJQwmQJxLpqR7ywL4xUNzs
         rIs//hl/x/7sHd0OhXd4DtXOWvS3QF/rxXQ5V6pVHCGK9FenL6JQauRme5gM8BxggG0Y
         B06zmRqAMGfLXBtCPxrOzNAzSLF5e38OfSyUPnBlSRwD1SKu+zl7vHMJRhP8lNoRQurg
         0BDnuZY5L+FBSQRdrf9RtjP7hdX955dLvTnbNyMojp6SJlZFigOThHxuVwaH+O10nyT1
         nkTg==
X-Gm-Message-State: AO0yUKX+vvESkjL8rLR2QGPN7ToolzGzDR/m8/4V8UzWg5WzagZHvPJb
        +ANT+SCNdS+txNRqr70sTDW878F4DyM=
X-Google-Smtp-Source: AK7set+yYZuo2SuxCc2twGG4s4cPWYmyIoMLoUQ5PzkRSMgb4h2JJuq4ymVVPsz70jixviVErQ+2k59pul4=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:f50b:0:b0:7fb:c189:6d84 with SMTP id
 a11-20020a25f50b000000b007fbc1896d84mr769321ybe.601.1675398152601; Thu, 02
 Feb 2023 20:22:32 -0800 (PST)
Date:   Thu,  2 Feb 2023 20:20:44 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203042056.1794649-1-reijiw@google.com>
Subject: [PATCH v3 02/14] KVM: arm64: PMU: Set the default PMU for the guest
 on vCPU reset
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For vCPUs with PMU configured, KVM uses the sanitized value
(returned from read_sanitised_ftr_reg()) of ID_AA64DFR0_EL1.PMUVer
as the default value and the limit value of that field.
The sanitized value could be inappropriate for these on some
heterogeneous PMU systems, as only one of PMUs on the system
can be associated with the guest.  Also, since the PMUVer
is defined as FTR_EXACT with safe_val == 0 (in cpufeature.c),
it will be zero when any PEs on the system have a different
PMUVer value than the other PEs (i.e. the guest with PMU
configured might see PMUVer == 0).

As a guest with PMU configured is associated with one of
PMUs on the system, the default and the limit PMUVer value for
the guest should be set based on that PMU.  Since the PMU
won't be associated with the guest until some vcpu device
attribute for PMU is set, KVM doesn't have that information
until then though.

Set the default PMU for the guest on the first vCPU reset.
The following patches will use the PMUVer of the PMU as the
default value of the ID_AA64DFR0_EL1.PMUVer for vCPUs with
PMU configured.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 14 +-------------
 arch/arm64/kvm/reset.c    | 21 ++++++++++++++-------
 include/kvm/arm_pmu.h     |  6 ++++++
 3 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index f2a89f414297..c98020ca427e 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -867,7 +867,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
-static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 {
 	lockdep_assert_held(&kvm->lock);
 
@@ -923,18 +923,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
-	mutex_lock(&kvm->lock);
-	if (!kvm->arch.arm_pmu) {
-		/* No PMU set, get the default one */
-		int ret = kvm_arm_set_vm_pmu(kvm, NULL);
-
-		if (ret) {
-			mutex_unlock(&kvm->lock);
-			return ret;
-		}
-	}
-	mutex_unlock(&kvm->lock);
-
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PMU_V3_IRQ: {
 		int __user *uaddr = (int __user *)(long)attr->addr;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index e0267f672b8a..5d1e1acfe6ce 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -248,18 +248,30 @@ static int kvm_set_vm_width(struct kvm_vcpu *vcpu)
  */
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
 	struct vcpu_reset_state reset_state;
 	int ret;
 	bool loaded;
 	u32 pstate;
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&kvm->lock);
 	ret = kvm_set_vm_width(vcpu);
 	if (!ret) {
 		reset_state = vcpu->arch.reset_state;
 		WRITE_ONCE(vcpu->arch.reset_state.reset, false);
+
+		/*
+		 * When the vCPU has a PMU, but no PMU is set for the guest
+		 * yet, set the default one.
+		 */
+		if (kvm_vcpu_has_pmu(vcpu) && unlikely(!kvm->arch.arm_pmu)) {
+			if (kvm_arm_support_pmu_v3())
+				ret = kvm_arm_set_vm_pmu(kvm, NULL);
+			else
+				ret = -EINVAL;
+		}
 	}
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&kvm->lock);
 
 	if (ret)
 		return ret;
@@ -297,11 +309,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;
 		}
-
-		if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
-			ret = -EINVAL;
-			goto out;
-		}
 		break;
 	}
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 628775334d5e..7b5c5c8c634b 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -96,6 +96,7 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
+int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu);
 
 #else
 struct kvm_pmu {
@@ -168,6 +169,11 @@ static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
 	return 0;
 }
 
+static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+{
+	return 0;
+}
+
 #endif
 
 #endif
-- 
2.39.1.519.gcb327c4b5f-goog

