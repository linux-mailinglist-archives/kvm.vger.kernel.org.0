Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD14688E66
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 05:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbjBCEFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 23:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjBCEFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 23:05:45 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002BF3C36
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 20:05:43 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id h14-20020a258a8e000000b00827819f87e5so3764785ybl.0
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 20:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ipr4xhXjsZ3xlHgWCFzXNIu5kTM+BU4HEjtM53FIJC8=;
        b=c/d6PHNBqDvTeLHEKZO2QuLxxu4Dw58XcVsbS9TqYVD79JfHoLbKk5m+MlHoePbKvZ
         m+RiHImDM2atdcUtTq5p/p8ZKHwuJd0SnifljBbJaRr/xGiJOzWYhvkowagdjqZtMJRa
         ykLSRR6cNJ0zBMjRG6h6BR3ebZrbrlzZXuPZQ7TfzIPwZ8L7qTHTiolQAWapRGHaiNUj
         FAsvVziElhXi20ioCU8YNcHjKZwgyMOFIcWFZxuG9F/C/plHhQM317I3Zd0F09qlUS+d
         kGva4rNxavCSAw189iTIgHWJ6FmmRcmyhko0spN052hlBYOUey3NTCi7JFmr/nGCwkCP
         QCmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ipr4xhXjsZ3xlHgWCFzXNIu5kTM+BU4HEjtM53FIJC8=;
        b=Ag9yBIFz4i9Y3AxFMwv9HAnL9R20Xs+okDy7TRFSlFOHRIN5ZUBp8Iir0FeWKRD/ST
         GnitYUJW+5JiIvoL2CyO6NDFn9ai9v5Q24gd9LasdDAeDH2ES2Obut/QTUmhwO0jN8/D
         PG5OHdAZpAFxfp8Uu8Bp3t45CSVixKZEApwgZCpTQfO4KZ3iUIQnFbNNhptX98TIINJ/
         l66JfCyy9PHnwDdwrhE4/s4Ru8/Px4GELnGjO7VEdM4NzN5zdsfzvzPh61dwmJf+m6nI
         +HsQmDL6k3O5ZNIx03Z8pBLHpC1u88MZFQ42OnkUW26dF2qMSScVi6VvUEdaPMFgNieh
         wXVg==
X-Gm-Message-State: AO0yUKUZCbJKmmUSnfaUTit+RF6L+6i4fKNHUVGJWJduYhWnOdxKn0We
        q7BTvVGfahoCA+ahpyMKBfmwto7ndD8=
X-Google-Smtp-Source: AK7set9hXHYpsfeEyNZjmKuwBd86TPK7rc/HyFmmnFFTRFa6jkP13qBYeAs3sOwd8+uNbKkJ6PM4+ACIplY=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:af02:0:b0:4d7:50a4:630d with SMTP id
 n2-20020a81af02000000b004d750a4630dmr1108788ywh.518.1675397143239; Thu, 02
 Feb 2023 20:05:43 -0800 (PST)
Date:   Thu,  2 Feb 2023 20:02:29 -0800
In-Reply-To: <20230203040242.1792453-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230203040242.1792453-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203040242.1792453-2-reijiw@google.com>
Subject: [PATCH v3 01/14] KVM: arm64: PMU: Introduce a helper to set the
 guest's PMU
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
        Shaoqin@google.com, Huang@google.com, shahuang@redhat.com,
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
2.39.1.519.gcb327c4b5f-goog

