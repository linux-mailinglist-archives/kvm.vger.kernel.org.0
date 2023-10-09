Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB077BEEF5
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 01:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379125AbjJIXLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 19:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379118AbjJIXLd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 19:11:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AE7D65
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 16:09:05 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9a4fb3e096so389858276.1
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 16:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892944; x=1697497744; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lbiCPM17L0Ezy9RJ+4AjTcOJhsmWUq480xf6KhudPI8=;
        b=OJCLrkMQf3sN2JQHP+asIrFlr5gpwK6SpgSzblzJL6mirtJeWI3UxLUUtut7OfbahM
         iIOCerDN6vC3vX20LzubSf5h0c5JgzFC8DXHB27SmejGN0AVPgxBmx4ToFmaGAQVLr1A
         OaccV2D6rlX+ZdPRCxNjcGBa0I8bShHnbqafieXfmssUy6RoZsesyW6r+hGzHqWcX/Z2
         3IRwcaJ1I7XRnw7phvtJtWX/9Kr0hchHSytfkSTnPp53Kdkkl9SD5d6WOPvsXt6CpKuH
         DgyQk7vS/bDClIfeirdG5TlD7Yqkl1VN+kTfK3V66v0ilOy9owBCFFoBDsm5MAqp1Iry
         6fCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892944; x=1697497744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lbiCPM17L0Ezy9RJ+4AjTcOJhsmWUq480xf6KhudPI8=;
        b=UqDpat0hLHk94HdKsTzBikT5EqBwrX1Pk0GWHAKg8OV7D1M1DxAtwCntR6mD7hod/B
         FnPOr/qgfE+U3FG0HGyUNUkGI+Bk2Rh8u6e0H9jeIANJL6/bmUlBKXybD4KH3Gqmh+D0
         /9BbS+yCALp2XGUhHsBhhFsZuB9ZtUDyglrW0CTW+EdduFhmchI8hCktGKFtQqj3fboS
         k26hiPqrttW1K6OpdC2wIdHyUkGI/kFnluiKe17q0T5vZnu8cL/JT9G5z1NTR3cCoA0G
         oTUIhuXbwVRd9/5vmIFBK7hbaKhbh5XOz7fdm84fe4wmJf9bYVMu05mq/IPhQgRKK18P
         PUVw==
X-Gm-Message-State: AOJu0YytDFK4MkxUL+ciNVlZqMXAGHFSszSRB1A8OGg4U9J//4PrZ1uB
        xxCdz/7cgUo8cNN+QkjaxPB8saotuHDC
X-Google-Smtp-Source: AGHT+IGS+qeXuoYzERBdhx/297ZX7D3f4cLKnn2F32lgBAnmC7aVQekkaeRf5AdGPo5boRZQt5zgvgDdd+ff
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:42d6:0:b0:d9a:4db7:63e1 with SMTP id
 p205-20020a2542d6000000b00d9a4db763e1mr15924yba.12.1696892944315; Mon, 09 Oct
 2023 16:09:04 -0700 (PDT)
Date:   Mon,  9 Oct 2023 23:08:47 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-2-rananta@google.com>
Subject: [PATCH v7 01/12] KVM: arm64: PMU: Introduce helpers to set the
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
index 3afb281ed8d2..eb5dcb12dafe 100644
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
2.42.0.609.gbb76f46606-goog

