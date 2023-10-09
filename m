Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEDD7BEEE9
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 01:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379107AbjJIXKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 19:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379093AbjJIXKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 19:10:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1D2C6
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 16:09:06 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d815354ea7fso6635610276.1
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 16:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892945; x=1697497745; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z/EXS3E0QingI/dhMmhRcelks2qlBAd4MtKbKAc3JtE=;
        b=cN7zoHKishbiJ+nAAZ09lEajoq97OGPCLa73BQid4vOZi1s7DSdW9Mcliq3Cij9/pF
         IOIv+eb/ot6DKDIpnLu9Rox4lP34Gjv6mnFBBipQEW6p9WG1ZdkHCMWuSNzhN4OjxUV7
         XD+ry5HEj1s5Ynvei4dMblvJqQGN3hnzTZ517RKa+88N2UE9T5TLS/mfa75/W/K03j1N
         7aj9/QfhdBYKB/hBnFUODdA5/ADwJmQ6lkF9mTpMrEoJJLqZLpxkVQsbI7RfkRmTk91k
         wb3/3p1TmhzBk2dPoqBkRJG9qN6tuIuLOwrh6ACM8KqcWQgH0W4chmS4oHkcFwGexMED
         3Y5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892945; x=1697497745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z/EXS3E0QingI/dhMmhRcelks2qlBAd4MtKbKAc3JtE=;
        b=B3cbgUmKFbWvMLdWxrhWzXtCyQ49ZR4Aw/QLwnR9VCeq7TEsArPrSR8om6gtZLdCtG
         LDIhk1+UqYIhl8osXi3LiQxCMT+hE/dvY5tqpK4iPDCoXBnpV0K+TjUaAYG/xx8prwB+
         HBa4kXor2YuESTmYjGioP7G9WpK/wt44I/7DWx1g8kH6Giu6pdJPkrylAZLHwzXcZDMo
         lJ/47XxbvzXhajOLVsaL//KpBdrSHWHcw05seJpv5OKGiod7mHUKPTET/pmFHF2ORH5q
         yh5WXy1vIw4d3dIg5ToyePRpKFiBA+I6Uyq1lMMOsF5+9o0zE6VUXqEoiWD/n4MrHvtZ
         sD6Q==
X-Gm-Message-State: AOJu0Yx2AbiUrYYpsJJHeQCrC7fmAlmGfWfYTtwFHZD+encZwocTNWHB
        72gF7C1wr2mTGrl+me0bOP/4dcnYV1wj
X-Google-Smtp-Source: AGHT+IFKsr7JXVWu1qWTpXDJfo7L0hMPkdhBsdaOWv/PZufLpBw0bG7I4Sg+xG29iJZKC5s8M0y0vdlKLtJf
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:c583:0:b0:d86:56f4:e4a3 with SMTP id
 v125-20020a25c583000000b00d8656f4e4a3mr248890ybe.13.1696892945384; Mon, 09
 Oct 2023 16:09:05 -0700 (PDT)
Date:   Mon,  9 Oct 2023 23:08:48 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-3-rananta@google.com>
Subject: [PATCH v7 02/12] KVM: arm64: PMU: Set the default PMU for the guest
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 arch/arm64/kvm/arm.c      | 20 ++++++++++++++++++++
 arch/arm64/kvm/pmu-emul.c | 12 ++----------
 include/kvm/arm_pmu.h     |  6 ++++++
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 78b0970eb8e6..708a53b70a7b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1313,6 +1313,23 @@ static bool kvm_vcpu_init_changed(struct kvm_vcpu *vcpu,
 			     KVM_VCPU_MAX_FEATURES);
 }
 
+static int kvm_vcpu_set_pmu(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (!kvm_arm_support_pmu_v3())
+		return -EINVAL;
+
+	/*
+	 * When the vCPU has a PMU, but no PMU is set for the guest
+	 * yet, set the default one.
+	 */
+	if (unlikely(!kvm->arch.arm_pmu))
+		return kvm_arm_set_default_pmu(kvm);
+
+	return 0;
+}
+
 static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 				 const struct kvm_vcpu_init *init)
 {
@@ -1328,6 +1345,9 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 
 	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
 
+	if (kvm_vcpu_has_pmu(vcpu) && kvm_vcpu_set_pmu(vcpu))
+		goto out_unlock;
+
 	/* Now we know what it is, we can reset it. */
 	kvm_reset_vcpu(vcpu);
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index eb5dcb12dafe..cc30c246c010 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -717,8 +717,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
 	 * It is still necessary to get a valid cpu, though, to probe for the
 	 * default PMU instance as userspace is not required to specify a PMU
 	 * type. In order to uphold the preexisting behavior KVM selects the
-	 * PMU instance for the core where the first call to the
-	 * KVM_ARM_VCPU_PMU_V3_CTRL attribute group occurs. A dependent use case
+	 * PMU instance for the core during the vcpu reset. A dependent use case
 	 * would be a user with disdain of all things big.LITTLE that affines
 	 * the VMM to a particular cluster of cores.
 	 *
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
index 3546ebc469ad..858ed9ce828a 100644
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
2.42.0.609.gbb76f46606-goog

