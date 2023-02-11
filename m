Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9598C692D8D
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 04:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjBKDQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 22:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKDQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 22:16:08 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C4419F33
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:07 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4c8e781bc0aso68800857b3.22
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hdq7XuQlIHPZE8pEPY3tLAAyJhRpgi42DVvI6D6fk3s=;
        b=olC4sly3/BCcNo299QFE6SXvV3g1wqVFUyVd0+8jO9Hz+c+XRPNbcos5NTEKH3hY/R
         jfuycnUuQWdEbOb5vp8hZcuI6GgGI1csCoVVklgaUsyPjklgOJsSaNyrhgKH1/VKpzK+
         DEbm1g4/DWJK4TW/Eh5bcI6KwZzSjgu0qXrAlSd0ywkqwa3K1g1Z1Xg8ejeFhlI8X0ft
         PSqzgUEdb4r24scbLQiArayCSitWzKiUJUoS1d70rdvllcCjnqRUP+QgxJEutdunjA+C
         MRKdYitr/BDl6m6mcox9XP9p0gA1+a1PtClTHXxPnS8X4eygpDmpWl6uof8xHFyxNtkP
         UG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hdq7XuQlIHPZE8pEPY3tLAAyJhRpgi42DVvI6D6fk3s=;
        b=D10ghrfxNlw7nlFH03zKRko1iYbq/YeEt69lGTBBkLULMoafgGjRw0zZFYEyUMNt/m
         ybSufehELQXQl4U6jpBbwqWx90daecfE52gez9fbJ47gJwQB/9ZML6srupMk5mPGY8DS
         DQNr5WI/3zmW2MXeGYvYN6L2sCc4e4FqHyv6wBUL3Mzj1t7vPlgtUHn7ZeQWbCn+ThNL
         ls1/HbpTojr5tDpt8qbriuGleeoh72dbuUjbbCBU6P4CZWNPRzb3tnJbJJQaA5y5cg7f
         S8w6OWw7YKKdZLKbm4TvDY2ax6p9sOhy2k+RHuceOuIhZckm1aRmP+42oi6/AvY+U77k
         GhRw==
X-Gm-Message-State: AO0yUKU2KgTy8CiRdPbTHCe4CufIuZr2DHEMo5dMobRwnoVjDRoT1sgG
        nWWAbTaphpL9Mgi9ZIMJoxSl90sClaE=
X-Google-Smtp-Source: AK7set9MyQkoUEk7Igu3MmgDiS0MvOBHtDAybXqTLmWHi6ARX9UQnTFnvNsgayrwWqtVeJ8XRvgwFvDqePE=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:bf48:0:b0:506:7242:1c7b with SMTP id
 s8-20020a81bf48000000b0050672421c7bmr2250183ywk.494.1676085366884; Fri, 10
 Feb 2023 19:16:06 -0800 (PST)
Date:   Fri, 10 Feb 2023 19:14:53 -0800
In-Reply-To: <20230211031506.4159098-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230211031506.4159098-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-2-reijiw@google.com>
Subject: [PATCH v4 01/14] KVM: arm64: PMU: Introduce a helper to set the
 guest's PMU
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

Introduce a new helper function to set the guest's PMU
(kvm->arch.arm_pmu), and use it when the guest's PMU needs
to be set. This helper will make it easier for the following
patches to modify the relevant code.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..f2a89f414297 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -867,6 +867,21 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
+static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+{
+	lockdep_assert_held(&kvm->lock);
+
+	if (!arm_pmu) {
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
@@ -886,7 +901,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 				break;
 			}
 
-			kvm->arch.arm_pmu = arm_pmu;
+			WARN_ON_ONCE(kvm_arm_set_vm_pmu(kvm, arm_pmu));
 			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
 			ret = 0;
 			break;
@@ -911,10 +926,11 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	mutex_lock(&kvm->lock);
 	if (!kvm->arch.arm_pmu) {
 		/* No PMU set, get the default one */
-		kvm->arch.arm_pmu = kvm_pmu_probe_armpmu();
-		if (!kvm->arch.arm_pmu) {
+		int ret = kvm_arm_set_vm_pmu(kvm, NULL);
+
+		if (ret) {
 			mutex_unlock(&kvm->lock);
-			return -ENODEV;
+			return ret;
 		}
 	}
 	mutex_unlock(&kvm->lock);
-- 
2.39.1.581.gbfd45094c4-goog

