Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50F7688E83
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 05:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjBCEX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 23:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjBCEXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 23:23:24 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C6321298
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 20:23:22 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-50e79ffba49so39596817b3.9
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 20:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bsxNffR5T4+GCyVU1rQER4x81/cUB6ikFRzN3Ch65v8=;
        b=im+oblvNpOXv0tNoFXmcYty6GGMOtyQ16C4YJhhKMWKcpj4ix+8iIeWPIjk1y+P7TK
         TAme7nDlXvpnp7/PRBqUXsdjOZA3WnjKzaHxuwhdNmKSwHHk+ToMvvS5HS+7eiP7zduL
         kVaMmsc3UmkmkCqgDoZAs/ksnsY7kREkUCfzQFH3xkJ9P4NVjEFhs1kx9wx6RZp1bxO9
         lLncFtAdu9yOSttS6YvvkPSPpo8zevrYj3t8gbuDhwTlfzhJHXhx8fhdL7x1/033uaQj
         hYKNtWH2UjCjoWeQ4vBxBdUQMKLUQJGrszIgDTGrnK9E9o2Iee3nbcFmKoKmVsG3ZTqQ
         z6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bsxNffR5T4+GCyVU1rQER4x81/cUB6ikFRzN3Ch65v8=;
        b=sE3t+TPfIE5gMJOhgRDgDeWdueS2q5uxrhUueRQuHtn+z/O4BgW6Awue3VRyGm6cV/
         lWlvIOiGac1E5GwdIP1BsUFZNqbo4ipUqh0mft44BmsB3jYENCj0Bembe7jCEv5MORQP
         u0VW0IGy64Dv9+RapvsVx8yMqmOaHEAEAZ+Zn6ofoUlve/N3Ohnh8MShAt71vzxANtvI
         ObesteLxVJf4tRSp9StPePxq+M+NpwHvasu+MeYAGzI2kGcxxlq6CzQzRPE8bBrR0Q3d
         T5KEPPo9v9clbvwxDbzEUAhkbRduhNJ3pSxpScr7rhDbBgcNTBXGDmX0gP3cJjr0mRe/
         e2ag==
X-Gm-Message-State: AO0yUKVtKY9yCYC/MiZQ/s1UOcG0LoRcXjDSU5ryM5kep9PSjKUYfTAv
        U26uZsq78Q6uSR/qmaNho80m8iQnID0=
X-Google-Smtp-Source: AK7set/wpJYN/xrCwxDVv1wcqFOvXuH8Zi1m5CeU9pjOV2IyOIeXUl9PfgDkrAGzUL5m4JkVGoZ6jumXfPY=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:4b8c:0:b0:525:483e:5cb4 with SMTP id
 y134-20020a814b8c000000b00525483e5cb4mr0ywa.6.1675398201590; Thu, 02 Feb 2023
 20:23:21 -0800 (PST)
Date:   Thu,  2 Feb 2023 20:20:46 -0800
In-Reply-To: <20230203042056.1794649-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230203042056.1794649-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203042056.1794649-3-reijiw@google.com>
Subject: [PATCH v3 04/14] KVM: arm64: PMU: Don't use the PMUVer of the PMU set
 for the guest
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

KVM uses two potentially different PMUVer for a vCPU with PMU
configured (kvm->arch.dfr0_pmuver.imp and kvm->arch.arm_pmu->pmuver).
Stop using the host's PMUVer (arm_pmu->pmuver) in most cases,
as the PMUVer for the guest (kvm->arch.dfr0_pmuver.imp) could be
set by userspace (could be lower than the host's PMUVer).

The only exception to KVM using the host's PMUVer is to create an
event filter (KVM_ARM_VCPU_PMU_V3_FILTER).  For this, KVM uses
the value to determine the valid range of the event, and as the
size of the event filter bitmap.  Using the host's PMUVer here will
allow KVM to keep the compatibility with the current behavior of
the PMU_V3_FILTER.  Also, that will allow KVM to keep the entire
filter when PMUVer for the guest is changed, and KVM only need
to change the actual range of use.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 49580787ee09..701728ad78d6 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -35,12 +35,8 @@ static struct kvm_pmc *kvm_vcpu_idx_to_pmc(struct kvm_vcpu *vcpu, int cnt_idx)
 	return &vcpu->arch.pmu.pmc[cnt_idx];
 }
 
-static u32 kvm_pmu_event_mask(struct kvm *kvm)
+static u32 __kvm_pmu_event_mask(u8 pmuver)
 {
-	unsigned int pmuver;
-
-	pmuver = kvm->arch.arm_pmu->pmuver;
-
 	switch (pmuver) {
 	case ID_AA64DFR0_EL1_PMUVer_IMP:
 		return GENMASK(9, 0);
@@ -55,6 +51,11 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
 	}
 }
 
+static u32 kvm_pmu_event_mask(struct kvm *kvm)
+{
+	return __kvm_pmu_event_mask(kvm->arch.dfr0_pmuver.imp);
+}
+
 /**
  * kvm_pmc_is_64bit - determine if counter is 64bit
  * @pmc: counter context
@@ -755,7 +756,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
 		 * as RAZ
 		 */
-		if (vcpu->kvm->arch.arm_pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P4)
+		if (vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P4)
 			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
 		base = 32;
 	}
@@ -955,7 +956,12 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		struct kvm_pmu_event_filter filter;
 		int nr_events;
 
-		nr_events = kvm_pmu_event_mask(kvm) + 1;
+		/*
+		 * Allocate an event filter for the entire range supported
+		 * by the PMU hardware so we can simply change the actual
+		 * range of use when the PMUVer for the guest is changed.
+		 */
+		nr_events = __kvm_pmu_event_mask(kvm->arch.dfr0_pmuver.imp_limit) + 1;
 
 		uaddr = (struct kvm_pmu_event_filter __user *)(long)attr->addr;
 
-- 
2.39.1.519.gcb327c4b5f-goog

