Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEFB671326C
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 06:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbjE0EEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 May 2023 00:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjE0EEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 May 2023 00:04:40 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50525125
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 21:04:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bacfa4ef059so3277829276.2
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 21:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685160278; x=1687752278;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uUrVHxQ1VjsIKZJ0cYmjatxxlv1RidcUPcAwfkxMDeQ=;
        b=mnKD5djePan6cHUiRAmZh38Jmo+ropUJ0h0VmSE6uXDB/X12f01Q1L295u/FPmsJe7
         psC4a9zcrCkyAa0xQFqKrV9FLzwyA7ATKehSlM0c7ERZJii79G9dsfEwowCoo0nNDTF3
         5NCRrlT59GgmTp/pVXGlfeSkIkv5YFtnrW0wlZi2s2rqz21oT09bP6qfK4fb5hBCSC09
         PxuvQeOOnXn4blCcFNbFRNEXN7GPF+KeUXP2ym9XDgMEyPD8icS7IKN2yqxz5oVLyYu7
         cUUYIHqVISmSIVQvx8JAolK7vvPmc8Lg/sCVUk2mHRfx0V9b2DSRQEcl4CWhrALeA4cm
         HmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685160278; x=1687752278;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uUrVHxQ1VjsIKZJ0cYmjatxxlv1RidcUPcAwfkxMDeQ=;
        b=NaB6/03CoqpE6abXG18+lCtbwpZcZAZDrrGWthR61d0Xvpj6GTpYilIv/6oUiytQ57
         IN8vpC+UtiYK2C/6HKfEYLIWQWIHR4jTq+9jN6cRTIJI2hR65tx5MKpCOllhmJIsPK6L
         f3A1cr3DYCZtSECIQcVPEZBKGFVmJWSPzE7eoVr6puhIXU1VM6euO9GLx5mepRNYtYDc
         N0uuast2MZJzBjcZw4SbRUE7jPDKXJuKCWhkmj8EIicGTVQrl8Wsx5OBSUfUinfVvPkH
         jU4All6SMjAgkRnqQAYwfqUWGTLvIFlsYsG1f9PhjZac6cns8TwxgecTTjv8VGC/T4Yv
         3UxA==
X-Gm-Message-State: AC+VfDyNuG4c1QSZgVlBHunFUuMTqGBm983MFPDHaTdO6PfL7P//8yZK
        vDfS7YvAliYsiSnxmtF9MVK3rxwTwfw=
X-Google-Smtp-Source: ACHHUZ40X1JtVnbU0yW1OlIarBd66lox6g/g0byncu954rsHLASWFxfD7mYTWnHgIRpIDTHXydpwbi5LsS4=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:2646:0:b0:bac:f582:ef18 with SMTP id
 m67-20020a252646000000b00bacf582ef18mr2153443ybm.5.1685160278549; Fri, 26 May
 2023 21:04:38 -0700 (PDT)
Date:   Fri, 26 May 2023 21:02:34 -0700
In-Reply-To: <20230527040236.1875860-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230527040236.1875860-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230527040236.1875860-3-reijiw@google.com>
Subject: [PATCH 2/4] KVM: arm64: PMU: Set the default PMU for the guest on
 vCPU reset
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

Set the default PMU for the guest on the first vCPU reset,
not when userspace initially uses KVM_ARM_VCPU_PMU_V3_CTRL.
The following patches will use the PMUVer of the PMU as the
default value of the ID_AA64DFR0_EL1.PMUVer for vCPUs with
PMU configured.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 10 +---------
 arch/arm64/kvm/reset.c    | 20 +++++++++++++-------
 include/kvm/arm_pmu.h     |  6 ++++++
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index d50c8f7a2410..0194a94c4bae 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -869,7 +869,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
-static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 {
 	lockdep_assert_held(&kvm->arch.config_lock);
 
@@ -926,14 +926,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
-	if (!kvm->arch.arm_pmu) {
-		/* No PMU set, get the default one */
-		int ret = kvm_arm_set_vm_pmu(kvm, NULL);
-
-		if (ret)
-			return ret;
-	}
-
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PMU_V3_IRQ: {
 		int __user *uaddr = (int __user *)(long)attr->addr;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index b5dee8e57e77..f5e24492926c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -258,13 +258,24 @@ static int kvm_set_vm_width(struct kvm_vcpu *vcpu)
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_reset_state reset_state;
+	struct kvm *kvm = vcpu->kvm;
 	int ret;
 	bool loaded;
 	u32 pstate;
 
-	mutex_lock(&vcpu->kvm->arch.config_lock);
+	mutex_lock(&kvm->arch.config_lock);
 	ret = kvm_set_vm_width(vcpu);
-	mutex_unlock(&vcpu->kvm->arch.config_lock);
+	if (!ret && kvm_vcpu_has_pmu(vcpu)) {
+		if (!kvm_arm_support_pmu_v3())
+			ret = -EINVAL;
+		else if (unlikely(!kvm->arch.arm_pmu))
+			/*
+			 * As no PMU is set for the guest yet,
+			 * set the default one.
+			 */
+			ret = kvm_arm_set_vm_pmu(kvm, NULL);
+	}
+	mutex_unlock(&kvm->arch.config_lock);
 
 	if (ret)
 		return ret;
@@ -315,11 +326,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
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
index 1a6a695ca67a..5ece2a3c1858 100644
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
2.41.0.rc0.172.g3f132b7071-goog

