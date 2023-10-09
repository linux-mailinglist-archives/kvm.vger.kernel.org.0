Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D777BEEF3
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 01:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379212AbjJIXLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 19:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379093AbjJIXLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 19:11:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C28A2111
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 16:09:11 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9a3e5f1742so922899276.0
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 16:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892950; x=1697497750; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NiBpW9pAzYjkcsGf2tpIHcI9bB/NEZB+QU7M3fwotPk=;
        b=flrdaV3kdL4Z2dcGAehIbabH2GPEBpqUbJdOhhRFPax7pxqCcEv9neUhXQjthofQ1F
         3Cc1fr9qlsnPl1wL2BoOQ9hmOJcFpI92MQLWpGallnYxpdV681bO4L4BtWlL/Y6Z93Ca
         nUllN8PwrBuu+EjoN2IxSMRNDC0Uhqqvu7zLub4tjBDnu03hFMD4CAnKNmHe9bec2PpY
         uuBNWzk6t668wpAAF9zAxTGBoPuZsuoCQNvZv0n29GwhpwqCS5xgldcJQrXJEHfzfwyJ
         +MIh1OzkKNeRTEzLSt/rrqYg5wmfqvWFqx3PDfOHR+9w967YXK5qH5n+l1/Nt43ZAWaP
         m0RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892950; x=1697497750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NiBpW9pAzYjkcsGf2tpIHcI9bB/NEZB+QU7M3fwotPk=;
        b=qhq4JGw1QUgwxnKqiq+rUztp05sQiGo8OajdCpzGXpc+DJwt3CVf8++Bzt4nVp7XeF
         rTqvW7gXPcmw9ppyKsNgnbzwP5o6rlFFna07U4IT56s+6fVpGkH9xUHPzg7380N8XZVu
         qTQKzzw1gTBBdG/Xtx9gTJTH2gQg21K8SAD/CB2hSi8x2v+QGQHT0n7QqIpxIetJ2yHc
         g1R6mhe+3/D3DzY53p7xLHOaUig35DbU0KAhcvDvfp+cFZi7ZfNoY+LIQBPRQ/BrgFtq
         Ws86hQQtZLl+jmtz6HLpsJw0WNFHS8MFmT73f/jZSO/lADB97Qxt9pe1Kj88sLKDkVyw
         84ag==
X-Gm-Message-State: AOJu0YyjOcv1TRfIApwoh1rRUb1cVgMfJNPCspBfktXOiufnr+E0YI3+
        m8Wj0u/HyemL3ivgeBkE1vTG4HeAe1KM
X-Google-Smtp-Source: AGHT+IGhUbm0HO7NhAypaQMYBLq6ihENbJzVhn6yFKRW07/auTo8tnu6zuo6xvHt4/x6EbTnXbNJa84X0oC+
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:ce89:0:b0:d91:c4e8:bfdd with SMTP id
 x131-20020a25ce89000000b00d91c4e8bfddmr219902ybe.1.1696892950277; Mon, 09 Oct
 2023 16:09:10 -0700 (PDT)
Date:   Mon,  9 Oct 2023 23:08:52 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-7-rananta@google.com>
Subject: [PATCH v7 06/12] KVM: arm64: PMU: Add a helper to read the number of counters
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper, kvm_arm_get_num_counters(), to read the number
of counters from the arm_pmu associated to the VM. Make the
function global as upcoming patches will be interested to
know the value while setting the PMCR.N of the guest from
userspace.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 17 +++++++++++++++++
 include/kvm/arm_pmu.h     |  6 ++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index a161d6266a5c..84aa8efd9163 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -873,6 +873,23 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
+/**
+ * kvm_arm_get_num_counters - Get the number of general-purpose PMU counters.
+ * @kvm: The kvm pointer
+ */
+int kvm_arm_get_num_counters(struct kvm *kvm)
+{
+	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	/*
+	 * The arm_pmu->num_events considers the cycle counter as well.
+	 * Ignore that and return only the general-purpose counters.
+	 */
+	return arm_pmu->num_events - 1;
+}
+
 static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 {
 	lockdep_assert_held(&kvm->arch.config_lock);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index cd980d78b86b..672f3e9d7eea 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -102,6 +102,7 @@ void kvm_vcpu_pmu_resync_el0(void);
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 int kvm_arm_set_default_pmu(struct kvm *kvm);
+int kvm_arm_get_num_counters(struct kvm *kvm);
 
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
 #else
@@ -181,6 +182,11 @@ static inline int kvm_arm_set_default_pmu(struct kvm *kvm)
 	return -ENODEV;
 }
 
+static inline int kvm_arm_get_num_counters(struct kvm *kvm)
+{
+	return -ENODEV;
+}
+
 static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
 	return 0;
-- 
2.42.0.609.gbb76f46606-goog

