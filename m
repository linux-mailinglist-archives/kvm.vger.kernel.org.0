Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D49B77EE3A
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 02:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347332AbjHQAa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 20:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347330AbjHQAaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 20:30:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249D8272E
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 17:30:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d730a22484aso587683276.0
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 17:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692232233; x=1692837033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p5AVWhdLdq92AtHjXfrvRAhqFYTQ8rzt+av6leDSxig=;
        b=6YSihL71lWgouUO/mSZlnJIqsVWU0t8EUJZUcY4kpRinwQnibsi30lL19o/067zYqx
         NP3jhndiF60n0Hj7ZHPVrE/7S6vfaPGr8n4XtBQmVhPyskYQ+2JZgpgh/3hxEMxpEglK
         74bfyyR3COJxLz2Gkvif2unrCFKewmHAK3PaH0RC3PSbEa0SOp+i9OHlD4rECrAIYtzv
         s0IclNp5A0l6tJKtos3y5WPxudsHLorXzWZK/8nGLvLeuZGo9/l5urm3KxsssJJS6TaH
         Q81hdlsGdxVvjcpaWM2aJZ0wqTipFqk3uHbNSQOgi41yCCBadFvM4TQV8KOfVH7BhFcY
         VLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692232233; x=1692837033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p5AVWhdLdq92AtHjXfrvRAhqFYTQ8rzt+av6leDSxig=;
        b=MPtWdPhgeZ/4sAYyugygoIHTKk+2STgVbyf5rMWbf6mez0MrU2urjRZ36QD1HlEPE8
         Tt7zS1zEJDNGH3hweS4yH4jwmKlRlZ2MKYkXi8NRtwFCKWLdoXnBgaBmn0g4N7juhoD0
         mu0LTYybhjAJfiAfppaTFHhhCC9RHb+ZVPR4IStvSh1B2s4jfaJsZT/clQC3IEkOTY7L
         tPNaMzSyQEqQiZZdqP+201Si40gaJaQbAXiT0+Rxn9H65YgDlXu3odGNckaXEca3JXJi
         EHkxASpfuouhOA9MDK0u6g2nyI9vmcTDSVzZiUUCvn0YaLbn4GAkc3OXgIMS0zl5c63r
         fFzA==
X-Gm-Message-State: AOJu0Yxx3v0hxiNShgWu7KWg6h8gn8MOHR/kqAxrVa0cdpEJH8XpshP9
        wroU6vccqCCnT+b/Mu0GGEVl3DAjBNRC
X-Google-Smtp-Source: AGHT+IElcJgd6OEK6WsLtSqwCDbHFpQVk1NVpVhp/ioqgJwLe1DFcFjqYIWtYwJz7x3wfLN8H7uF9sToSnuG
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:76c2:0:b0:ca3:3341:6315 with SMTP id
 r185-20020a2576c2000000b00ca333416315mr25049ybc.0.1692232233287; Wed, 16 Aug
 2023 17:30:33 -0700 (PDT)
Date:   Thu, 17 Aug 2023 00:30:18 +0000
In-Reply-To: <20230817003029.3073210-1-rananta@google.com>
Mime-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230817003029.3073210-2-rananta@google.com>
Subject: [PATCH v5 01/12] KVM: arm64: PMU: Introduce a helper to set the
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

Introduce a new helper function to set the guest's PMU
(kvm->arch.arm_pmu), and use it when the guest's PMU needs
to be set. This helper will make it easier for the following
patches to modify the relevant code.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 52 +++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 5606509724787..0ffd1efa90c07 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -865,6 +865,32 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
+static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+{
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	if (!arm_pmu) {
+		/*
+		 * No PMU set, get the default one.
+		 *
+		 * The observant among you will notice that the supported_cpus
+		 * mask does not get updated for the default PMU even though it
+		 * is quite possible the selected instance supports only a
+		 * subset of cores in the system. This is intentional, and
+		 * upholds the preexisting behavior on heterogeneous systems
+		 * where vCPUs can be scheduled on any core but the guest
+		 * counters could stop working.
+		 */
+		arm_pmu = kvm_pmu_probe_armpmu();
+		if (!arm_pmu)
+			return -ENODEV;
+	}
+
+	kvm->arch.arm_pmu = arm_pmu;
+
+	return 0;
+}
+
 static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -884,9 +910,13 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 				break;
 			}
 
-			kvm->arch.arm_pmu = arm_pmu;
+			ret = kvm_arm_set_vm_pmu(kvm, arm_pmu);
+			if (ret) {
+				WARN_ON(ret);
+				break;
+			}
+
 			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
-			ret = 0;
 			break;
 		}
 	}
@@ -908,20 +938,10 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
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
+		int ret = kvm_arm_set_vm_pmu(kvm, NULL);
+
+		if (ret)
+			return ret;
 	}
 
 	switch (attr->attr) {
-- 
2.41.0.694.ge786442a9b-goog

