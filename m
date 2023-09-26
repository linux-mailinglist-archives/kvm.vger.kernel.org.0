Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5397AF766
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 02:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjI0A1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 20:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjI0ATG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 20:19:06 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE52318EA4
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 16:40:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d81646fcf3eso15441247276.0
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 16:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695771612; x=1696376412; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5wBvgde8NqXXedlUolMxmuLFm0wZFB1ciTVf7h91dh0=;
        b=ckHSCfSdzm1jCMOZ3g2CRPCiDw7uxVOtBclevf32YyJl54MDseQwjUITYRMVlb0rLu
         4hR/RhQqOOgE59af2WOtJbZSsy5moCcAAzUuy4cVBNAxzLfcwvb+pjXVPwaFA9HMx18V
         cAqYTL7zcLwpC8/3KJKl/FpAys2/3JQ8sYTb++Kr1Syg6sfwd8Mr2kUf9NRLufpR7HlP
         IHh+SAYdr49X1lVuD4qWlZpSF6kIRziGfbPrpyGfQ74Y52c21UpQIpzO2bejA1myEakj
         LotqnE1HJqL+O11zSkXje+xpVwpxB6l1KJyDg3hbKMxJtuI/dXFpQ+vPbhY0VuGdgli/
         9MQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771612; x=1696376412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5wBvgde8NqXXedlUolMxmuLFm0wZFB1ciTVf7h91dh0=;
        b=e7L+1cGuyrLUt/2pdDtNRmarRPm/4A/rYcz2dejw+Ai4zBYWdLHkO+Vfljr/FsPP8E
         H+kjf3Y10LqaVtVCnov8t6y97BFgH+vEgL1Vy+vPrGlM68CG9ljZL4Tt7His2j1v+P78
         M6UJKM1VjNZrsCTGSrFvDhvwU0uXbsj/7SzL4dwb7Z1R0A+fB0Z2eXVrN6CTslB8gJZK
         PD6m1YBS0MQMSa026gDSYT/gKMsYk5/hys/kiCHylyftf6GZzqLKRQ0vxqMSnkZAtv5R
         0Jm1ggZD10qdBKoQtgC0JopfP180gBkde8yDNZylhCphl/T+d13hF7fljeIZ8jGulp8H
         LTLg==
X-Gm-Message-State: AOJu0YyW9od6MQctz6u9bF0nvvsImarIYcuM/x8zPUrhJ4k899LPL33M
        tqCC5C97mE25uob66uFTpDFVl6mFe8rQ
X-Google-Smtp-Source: AGHT+IGQ/Bhiz9+l+ftp30n3Q3sAQclow99O2nr45tC++G2Qcf6D0tuF4DRExCh4Bp6rFs3g73lmp3qip+2k
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:1682:b0:d81:78ec:c403 with SMTP
 id bx2-20020a056902168200b00d8178ecc403mr4790ybb.12.1695771612735; Tue, 26
 Sep 2023 16:40:12 -0700 (PDT)
Date:   Tue, 26 Sep 2023 23:39:58 +0000
In-Reply-To: <20230926234008.2348607-1-rananta@google.com>
Mime-Version: 1.0
References: <20230926234008.2348607-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230926234008.2348607-2-rananta@google.com>
Subject: [PATCH v6 01/11] KVM: arm64: PMU: Introduce helpers to set the
 guest's PMU
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

Introduce new helper functions to set the guest's PMU
(kvm->arch.arm_pmu) either to a default probed instance or to a
caller requested one, and use it when the guest's PMU needs to
be set. These helpers will make it easier for the following
patches to modify the relevant code.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 50 +++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 6b066e04dc5df..fb9817bdfeb57 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -874,6 +874,36 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
+static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+{
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	kvm->arch.arm_pmu = arm_pmu;
+}
+
+/**
+ * kvm_arm_set_default_pmu - No PMU set, get the default one.
+ * @kvm: The kvm pointer
+ *
+ * The observant among you will notice that the supported_cpus
+ * mask does not get updated for the default PMU even though it
+ * is quite possible the selected instance supports only a
+ * subset of cores in the system. This is intentional, and
+ * upholds the preexisting behavior on heterogeneous systems
+ * where vCPUs can be scheduled on any core but the guest
+ * counters could stop working.
+ */
+static int kvm_arm_set_default_pmu(struct kvm *kvm)
+{
+	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
+
+	if (!arm_pmu)
+		return -ENODEV;
+
+	kvm_arm_set_pmu(kvm, arm_pmu);
+	return 0;
+}
+
 static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -893,7 +923,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 				break;
 			}
 
-			kvm->arch.arm_pmu = arm_pmu;
+			kvm_arm_set_pmu(kvm, arm_pmu);
 			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
 			ret = 0;
 			break;
@@ -917,20 +947,10 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		return -EBUSY;
 
 	if (!kvm->arch.arm_pmu) {
-		/*
-		 * No PMU set, get the default one.
-		 *
-		 * The observant among you will notice that the supported_cpus
-		 * mask does not get updated for the default PMU even though it
-		 * is quite possible the selected instance supports only a
-		 * subset of cores in the system. This is intentional, and
-		 * upholds the preexisting behavior on heterogeneous systems
-		 * where vCPUs can be scheduled on any core but the guest
-		 * counters could stop working.
-		 */
-		kvm->arch.arm_pmu = kvm_pmu_probe_armpmu();
-		if (!kvm->arch.arm_pmu)
-			return -ENODEV;
+		int ret = kvm_arm_set_default_pmu(kvm);
+
+		if (ret)
+			return ret;
 	}
 
 	switch (attr->attr) {
-- 
2.42.0.582.g8ccd20d70d-goog

