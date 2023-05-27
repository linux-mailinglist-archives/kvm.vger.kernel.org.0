Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C963871326A
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 06:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjE0EEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 May 2023 00:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjE0EEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 May 2023 00:04:32 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5943AD7
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 21:04:31 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5657f376d8dso35568987b3.2
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 21:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685160270; x=1687752270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YHzsFiaji3R6LFuYZV3olh4p0y72F3S93sl+y+EJDgg=;
        b=tXRV7/8vaXCBmNvtRzMV0UTHrROqViarCwmmvALY8aLcpKOu4xRm91QNaRI34zQ8v8
         yvLYZ1GU58l5FB/cjDoO40R/Z9cSiIJqqRZNSNv4nT8eeNOM9sC/MTkqBlahXlSb6FOb
         YEz1zKPvzwS09qQoUfpVwwChYweXdNma7oX+Su9R3sb4Apr9TGtS1UBKzdIVs4NTCGyY
         efKwRDyUP4EN4C9cvir8Cel8fAQPgCtt3xAF7dx0txEhPQARq6ttu0gHmWMud3io/OYo
         NtwEmzBt55fsPBQMr0neMCUGj7Kuyq78I2B4S7IX5XU/3LtYh0XQ4L7d7gXjDRmn9kz5
         teGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685160270; x=1687752270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YHzsFiaji3R6LFuYZV3olh4p0y72F3S93sl+y+EJDgg=;
        b=TvpYwCEsH9XN0M9h3PDSp6iXhU2QCmPQWxIUtRYXykrMU3gpVfFCyZ2hfxZEIVz1UJ
         ts1M+pjJ/sCWoH3a87iSxbnI1eiXO5jJF2BSEWLJp8pDLVMwQ+HeVTIcaRpFJ9WpY400
         FJNq822+hCvVQ/pzBqab02hpRvqkZ6Ing5dl6hrF6ZWwysZaJJZZYKt0gQrjsvKJ2Orr
         RCw8DzuSLccc45TyW+ha9AIs3xsPT464QliN6N5iOGz3ni08yKcWsae55VDaGQ8dv3/Z
         Cxk/rewNWMhspJQ9NJFORST3jxZUuXzzKkhdUFe8vly2mS5aDccp4yZ9lWyFC1Q5iHAA
         ectw==
X-Gm-Message-State: AC+VfDyzwHMGSNfHOoHZXV9jiTGq3egGO9kxaoKFiMhmNBYqXtsYhtGh
        aeWgOY7UyN9SaXYhIfZLqLl3UFwvS0I=
X-Google-Smtp-Source: ACHHUZ4VFYAdIHLqeJ14za1MxIqkvJrkGV6Yf1oNFWGOG8pJc58iQwSXrcfI0IoqFC+oVQuwesnB8fXEw+Y=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:b71d:0:b0:55a:3133:86fa with SMTP id
 v29-20020a81b71d000000b0055a313386famr2380185ywh.3.1685160270657; Fri, 26 May
 2023 21:04:30 -0700 (PDT)
Date:   Fri, 26 May 2023 21:02:33 -0700
In-Reply-To: <20230527040236.1875860-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230527040236.1875860-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230527040236.1875860-2-reijiw@google.com>
Subject: [PATCH 1/4] KVM: arm64: PMU: Introduce a helper to set the guest's PMU
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
index 45727d50d18d..d50c8f7a2410 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -869,6 +869,21 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
+static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+{
+	lockdep_assert_held(&kvm->arch.config_lock);
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
@@ -888,7 +903,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 				break;
 			}
 
-			kvm->arch.arm_pmu = arm_pmu;
+			WARN_ON_ONCE(kvm_arm_set_vm_pmu(kvm, arm_pmu));
 			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
 			ret = 0;
 			break;
@@ -913,9 +928,10 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 	if (!kvm->arch.arm_pmu) {
 		/* No PMU set, get the default one */
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
2.41.0.rc0.172.g3f132b7071-goog

