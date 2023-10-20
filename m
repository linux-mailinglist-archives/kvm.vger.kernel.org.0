Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55BC07D1848
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 23:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345216AbjJTVlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 17:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345325AbjJTVlJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 17:41:09 -0400
Received: from mail-oa1-x4a.google.com (mail-oa1-x4a.google.com [IPv6:2001:4860:4864:20::4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F13A10C2
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:41:00 -0700 (PDT)
Received: by mail-oa1-x4a.google.com with SMTP id 586e51a60fabf-1e9adea7952so1768122fac.0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838059; x=1698442859; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OvTbuzt4md5LHr4J4krTZywPcth5GhRuVcM9C2OHqIY=;
        b=r56AJCBfEWhftQfmQs45Z+jL17ehu1opCAsEhgHie9vaCU/1uB1Z70+++uNJ05Kcc3
         Z+AyFRzfdcp7cS/qEMtY17GuH1HUtY3wQp0BNloe0SDuEex/NVJi/KShvTCSsWPgxBms
         pIPlJqoi6RJZ+XrIdlwHP2gjcd3xoBna9yjtXVPSx15aeHE2QFUZa5iA6+EU3XztXwL2
         JAI/K6dHy2tPrQtbCJtGx++E9LWEVs4SlKpcjsqEQr4/MM855QtoaPQUE9rggD6roZJ6
         qD3fRqTu41Fses0HFihCbyGT5I47O/CSthsmng6mn/5Og6ZEmTG7QEompZTwnv6W3bXo
         pAHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838059; x=1698442859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OvTbuzt4md5LHr4J4krTZywPcth5GhRuVcM9C2OHqIY=;
        b=vBWouOTEozR/J+BTYN0dFQco9S1KjdPjQiTlNCdQsFOcdJNWu56K08PuxZdZ1KGldI
         SqLrg1qriVUTqp7mtFPK4i4gXyso75D3pntRlhDpnjp+oLfLZKEoX/GakODMMznVclFk
         +Ck+LY3kO5cmwudo88bLwR/vj6rtXulnWSpc0Z53FgfxTJNKcOZ1kNd+NUJ/BzUzRrNK
         uB45jmN4Q5hhXqZlc/0efsYL2vAtBa17C4fQef8PJzqveg8688uNPtn7/OSwQKz3/Cwp
         w8F4BXHLYpSyCEQZ3YB6P+QMl9Lz2kI3wpQN3bT8X6THasZjSMb4hR/U2sJa311vTrZC
         ZE/Q==
X-Gm-Message-State: AOJu0YxhfvCqCK5d8mtKqNmEV/5rTnqj6Z1NEyn6L8cpCEi//3DG4Tyq
        OPy2oNlPDGkXL/ZQI+nZiMaaayYYs0pV
X-Google-Smtp-Source: AGHT+IEdVXep5DKRdz2BRVvgx70nBf8uvoUbKeFebUy6l9z1K84a5p2DuIHe8LQQaBhtnY5EVhvx/QrPErHN
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6870:d10f:b0:1e9:c975:2ae2 with SMTP
 id e15-20020a056870d10f00b001e9c9752ae2mr1291816oac.11.1697838059370; Fri, 20
 Oct 2023 14:40:59 -0700 (PDT)
Date:   Fri, 20 Oct 2023 21:40:42 +0000
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
Mime-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-3-rananta@google.com>
Subject: [PATCH v8 02/13] KVM: arm64: PMU: Set the default PMU for the guest
 before vCPU reset
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

The following patches will use the number of counters information
from the arm_pmu and use this to set the PMCR.N for the guest
during vCPU reset. However, since the guest is not associated
with any arm_pmu until userspace configures the vPMU device
attributes, and a reset can happen before this event, assign a
default PMU to the guest just before doing the reset.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/arm.c      | 19 +++++++++++++++++++
 arch/arm64/kvm/pmu-emul.c | 16 ++++------------
 include/kvm/arm_pmu.h     |  6 ++++++
 3 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c6cad400490f9..08c2f76983b9d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1319,6 +1319,21 @@ static bool kvm_vcpu_init_changed(struct kvm_vcpu *vcpu,
 			     KVM_VCPU_MAX_FEATURES);
 }
 
+static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	/*
+	 * When the vCPU has a PMU, but no PMU is set for the guest
+	 * yet, set the default one.
+	 */
+	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu &&
+	    kvm_arm_set_default_pmu(kvm))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 				 const struct kvm_vcpu_init *init)
 {
@@ -1334,6 +1349,10 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 
 	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
 
+	ret = kvm_setup_vcpu(vcpu);
+	if (ret)
+		goto out_unlock;
+
 	/* Now we know what it is, we can reset it. */
 	kvm_reset_vcpu(vcpu);
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index eb5dcb12dafe9..66c244021ff08 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -717,10 +717,9 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
 	 * It is still necessary to get a valid cpu, though, to probe for the
 	 * default PMU instance as userspace is not required to specify a PMU
 	 * type. In order to uphold the preexisting behavior KVM selects the
-	 * PMU instance for the core where the first call to the
-	 * KVM_ARM_VCPU_PMU_V3_CTRL attribute group occurs. A dependent use case
-	 * would be a user with disdain of all things big.LITTLE that affines
-	 * the VMM to a particular cluster of cores.
+	 * PMU instance for the core just before the vcpu reset. A dependent use
+	 * case would be a user with disdain of all things big.LITTLE that
+	 * affines the VMM to a particular cluster of cores.
 	 *
 	 * In any case, userspace should just do the sane thing and use the UAPI
 	 * to select a PMU type directly. But, be wary of the baggage being
@@ -893,7 +892,7 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
  * where vCPUs can be scheduled on any core but the guest
  * counters could stop working.
  */
-static int kvm_arm_set_default_pmu(struct kvm *kvm)
+int kvm_arm_set_default_pmu(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
 
@@ -946,13 +945,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
-	if (!kvm->arch.arm_pmu) {
-		int ret = kvm_arm_set_default_pmu(kvm);
-
-		if (ret)
-			return ret;
-	}
-
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PMU_V3_IRQ: {
 		int __user *uaddr = (int __user *)(long)attr->addr;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 3546ebc469ad7..858ed9ce828a6 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -101,6 +101,7 @@ void kvm_vcpu_pmu_resync_el0(void);
 })
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
+int kvm_arm_set_default_pmu(struct kvm *kvm);
 
 #else
 struct kvm_pmu {
@@ -174,6 +175,11 @@ static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
 }
 static inline void kvm_vcpu_pmu_resync_el0(void) {}
 
+static inline int kvm_arm_set_default_pmu(struct kvm *kvm)
+{
+	return -ENODEV;
+}
+
 #endif
 
 #endif
-- 
2.42.0.655.g421f12c284-goog

