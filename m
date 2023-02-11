Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D9E692D92
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 04:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjBKDQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 22:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBKDQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 22:16:24 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445082B621
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:22 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id y192-20020a2532c9000000b008ec2e7092d6so3808012yby.5
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5M0wOE83qtTaURF82G8aZFS/91Kl/LIeHE7nz/7UDxU=;
        b=Iqc53gBNzfM0ZQBk4+xbHFmih0iyiuyuQ5/tcEObQjx105oWDDzm/qXUERW3fpzmJD
         cL5SI93qyIHP4R5ZzGjPRCkkgTQs5g155SR9fNANxpFJ2Ip9pfQLqMn3NkggSbCbLOUG
         eVzyqy4KufW91RvdGwtwmuJkCZ1Gh89q6XnCJHwz+NIaoyf3r/ocOmPNZyewK6N7QI/e
         KiGhGAtOXFPUg9dKK7qN1Z0QAtJT3TvQ5o1+SOwgIY9enaLlz0wMjYniP6hY8zgIwh3X
         +PBrlz07VEBOXL5pUoaXNvr7ztDJvIE72GaObrGut5iXTgoguT1F40bdVDOCmPTBUWQo
         Bb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5M0wOE83qtTaURF82G8aZFS/91Kl/LIeHE7nz/7UDxU=;
        b=wxdxzRAQO3WlRJXU0z6Y5qUhoTJC27ako9tfZxH1Qp8RVsTbKjKNu+D2qRUPQaUf69
         y5a9biqLGF10SvG9xzAVaOBa01pvHubhHr0ht6jmjlyqJqcNkR801e1LrnCL8hoLn+LT
         A0lTyxdDa4gcxGM+CHkHIfvVzwVZcLX1kEGczmt/DPgzOlDDgJ3kx/sg0svvXNwf9XSQ
         VK0zNImud8xRarQN9Rpz+JMh246jNXEo2HL002Tqcg8o1XACI2c6dbp67M5AYFhgci4G
         zVmfEczX9PqaD86VSyFoaKITG1BOpEmQuSB2M/4FYJ3Xp/V76tHAkJMrNkefoTILv/bT
         M+og==
X-Gm-Message-State: AO0yUKVw7lnTTQ1VYFTY9bKC9mF8dnJVTaL5BUh5WD/I8LiIKqYO+VhL
        RcLsxXGfXc1ipw2+FM/hMQWz/tZ+8Tc=
X-Google-Smtp-Source: AK7set+FFAMDtkCc/A+nLWNZ/DMaXcRy2xyI3GQgwZav1va16NpsqWMcS5QMEEK1oQIgOipyziXQEYJALgo=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:3293:0:b0:8e6:f40a:adc7 with SMTP id
 y141-20020a253293000000b008e6f40aadc7mr6yby.6.1676085380948; Fri, 10 Feb 2023
 19:16:20 -0800 (PST)
Date:   Fri, 10 Feb 2023 19:14:54 -0800
In-Reply-To: <20230211031506.4159098-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230211031506.4159098-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-3-reijiw@google.com>
Subject: [PATCH v4 02/14] KVM: arm64: PMU: Set the default PMU for the guest
 on vCPU reset
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
2.39.1.581.gbfd45094c4-goog

