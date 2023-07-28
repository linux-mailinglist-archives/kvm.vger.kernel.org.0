Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E77976745E
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbjG1STp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235772AbjG1STo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:19:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514093C27
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:19:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d052f58b7deso2274717276.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690568382; x=1691173182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H7xJDFLue/NvwsOlwF0hcWMCcGztcwcVHo0aL0oqpCk=;
        b=MFangAmRBbh+y81QRDLHlnYWDvQam6hXRtl/9i9dvGTHWjQTWrcGvnSxU9nQj+bhLG
         KRzv3Uowtaa75RT4RISVnvfwip8juIdbGophEv79/46AnMKYkzKWTLmfmSb9gPbKid6h
         8Oini5a6yFzTlXor1VJxSgWUyPvlprvZwBtZPz1MUdZ57CLfM+BtzFhXwkC21T49fiVF
         A+nu0DCxaly6SaU567uP7eaLYDtse4zpLotilYTpvJ6AKUHYJTxTOuqmNKajw70r18aV
         6VN4k0AIJtA32vvNG2KjElxBrD4g+cVb19koF09jjMuPCmV4GVAmWnlzFJUOqw0GW2kw
         DoLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690568382; x=1691173182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H7xJDFLue/NvwsOlwF0hcWMCcGztcwcVHo0aL0oqpCk=;
        b=WxB37QCA21K3zd3wG5Md9gg6HcaQJ3j3XvI51a0poRp8OZa15AW2DvsH4nTNTYPWDz
         PeQADjSZTdvwp/sdCjLGpndAr3n9j4wVLpKf/j8ulCJQyr0prlFYUDqwaNvNMnGORbaZ
         0RABMz8A5UyLfDmWsRK2YhxnCylJjIalAmIrnO/5PeEK7+wdKajnytemYu9BAazbelOA
         OisCMQ2xv6xuLA1NK/B7Ll/WDzcsf5ifLcjpZlzO21DIii0xxsfxgMmh1O0JaANxE/Jt
         z3eOK7VmMFsb0J+titgWyxvFSgIvtlAXiueuTdC5D2nF7z5KisLfcONai343FdHbmbyK
         tZ2A==
X-Gm-Message-State: ABy/qLYkCV1npn0+GqEhdu80fJMrEcj6s1AlOubbyPZ4PkomQf6Ali+Z
        DYo0AaGjk+cCTsM083pi6o3MaZvgeI8=
X-Google-Smtp-Source: APBJJlHLtcHDyqcq9MQ6CU4noYTnxBVY9xSNarpOt7Z38zw5Zg3c+tHSZBL/SzA6OvcKskJwpb9P4Vgnm9I=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:ae0c:0:b0:d05:38ba:b616 with SMTP id
 a12-20020a25ae0c000000b00d0538bab616mr13044ybj.6.1690568382652; Fri, 28 Jul
 2023 11:19:42 -0700 (PDT)
Date:   Fri, 28 Jul 2023 11:19:04 -0700
In-Reply-To: <20230728181907.1759513-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230728181907.1759513-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230728181907.1759513-3-reijiw@google.com>
Subject: [PATCH v2 2/5] KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer systems
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
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

Disallow userspace from configuring vPMU for guests on systems
where the PMUVer is not uniform across all PEs.
KVM has not been advertising PMUv3 to the guests with vPMU on
such systems anyway, and such systems would be extremely
uncommon and unlikely to even use KVM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/arm.c      |  1 +
 arch/arm64/kvm/pmu-emul.c | 11 ++++++++---
 include/kvm/arm_pmu.h     |  3 +++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 72dc53a75d1c..1d410dea21ac 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2053,6 +2053,7 @@ static int __init init_subsystems(void)
 		goto out;
 
 	kvm_register_perf_callbacks(NULL);
+	kvm_pmu_init();
 
 out:
 	if (err)
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index dee83119e112..6fb5c59948a8 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -685,9 +685,6 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	entry->arm_pmu = pmu;
 	list_add_tail(&entry->entry, &arm_pmus);
 
-	if (list_is_singular(&arm_pmus))
-		static_branch_enable(&kvm_arm_pmu_available);
-
 out_unlock:
 	mutex_unlock(&arm_pmus_lock);
 }
@@ -1057,3 +1054,11 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
 					      ID_AA64DFR0_EL1_PMUVer_V3P5);
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), tmp);
 }
+
+void kvm_pmu_init(void)
+{
+	u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
+
+	if (pmuv3_implemented(pmuver))
+		static_branch_enable(&kvm_arm_pmu_available);
+}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 847da6fc2713..9cf50e16305a 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -74,6 +74,7 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
 struct kvm_pmu_events *kvm_get_pmu_events(void);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
+void kvm_pmu_init(void);
 
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
@@ -110,6 +111,8 @@ static inline bool kvm_arm_support_pmu_v3(void)
 	return false;
 }
 
+static inline void kvm_pmu_init(void) {};
+
 #define kvm_arm_pmu_irq_initialized(v)	(false)
 static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 					    u64 select_idx)
-- 
2.41.0.585.gd2178a4bd4-goog

