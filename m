Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F7571326F
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 06:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbjE0EFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 May 2023 00:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237958AbjE0EFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 May 2023 00:05:11 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009F6D7
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 21:05:09 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-256498322a2so197563a91.1
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 21:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685160309; x=1687752309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uKyUjzGxMpAFYUO03Bjkr2AfOXHzBadtPHxiD64SwA0=;
        b=u3TLHrYK4S39RSZshsMoRKMWs10XcbGSNj6L5Phe7dIdJ8To+/hWEiSAFlLozdP517
         a3kiQSbkpg/uFOIMqYe3m2LWkPiWaB+8XxzdbUUSqP0vFKc+fVD7mAH+VCv4r2X3W5ak
         uPQJv4yWH26iZeg82TXekzt1mh7lEMk1c+ZMJRRuvtNZSxTOLdT3C/2E3dsf6KjXSkP9
         7Nvp+oC5avEw3t85SDLkag6Mu77J41BX5J6HRHF8xwUtOPAhy+UVqH+FrBnu0ZMYzdkA
         KM6Zoby653oxCtPpjytcghuzuzQMuNNIWf+6sF4JnN/w/mKIh5bZ0bKcvU9+dvPxZTBz
         Fy+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685160309; x=1687752309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uKyUjzGxMpAFYUO03Bjkr2AfOXHzBadtPHxiD64SwA0=;
        b=kkHpU46yb6wkibMl7QPVYip1sjHGYScT7z+4GcCyod+G6ZYVyZ7MPgd8m7dXtYBhY2
         yY7DFvhthwNBzq0S+RdPaXP7MokYtgEVMBd/xWhTbFGJeiY+bx7YNqZLXs1v8bMp4ozl
         RhAgFuWzr26naFqQLGHqXfHxQRWorHdGwL8oLBBVR5+nDSuy1pRlIX8Xa5+f2fYYj5Xl
         xryA9y9Rx7Z+XCkdi5JxnIgGbzzEewMg1XMVKdHJQeR696Zd7AluhqwU0afclAnpcnwQ
         FO+PwwodCeHavKmylk59GF0mTuJkF/WB7+GEO0cRYx1s74xVxTToF9ej6l40/gRoqZfY
         /Nfw==
X-Gm-Message-State: AC+VfDydlStqW6nyB4DHWz1+W7uHP177Xgh8V7j3b4ei/Hym0bY8zVWU
        hdkodwrtbyG2KX7or/EmMM4ETAqNzIA=
X-Google-Smtp-Source: ACHHUZ4Zo6lTvJnnh4eGslCPLrtwqCpnLb6UvNOS8aOzf5ORprs/RuwVER61Ok7lDJ8BWcoPB83lX7RlfiE=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:90a:ec08:b0:24d:e14a:6361 with SMTP id
 l8-20020a17090aec0800b0024de14a6361mr188030pjy.3.1685160309467; Fri, 26 May
 2023 21:05:09 -0700 (PDT)
Date:   Fri, 26 May 2023 21:02:36 -0700
In-Reply-To: <20230527040236.1875860-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230527040236.1875860-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230527040236.1875860-5-reijiw@google.com>
Subject: [PATCH 4/4] KVM: arm64: PMU: Don't use the PMUVer of the PMU set for guest
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

Avoid using the PMUVer of the PMU hardware that is associated to
the guest, except in a few cases, as the PMUVer may be different
from the value of ID_AA64DFR0_EL1.PMUVer for the guest.

The first case is when using the PMUVer as the limit value of
the ID_AA64DFR0_EL1.PMUVer for the guest. The second case is
when using the PMUVer to determine the valid range of events for
KVM_ARM_VCPU_PMU_V3_FILTER, as it has been allowing userspace to
specify events that are valid for the PMU hardware, regardless of
the value of the guest's ID_AA64DFR0_EL1.PMUVer. KVM will change
the valid range of the event that the guest can use based on the
value of the guest's ID_AA64DFR0_EL1.PMUVer though.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 6cd08d5e5b72..67512b13ba2d 100644
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
@@ -757,7 +758,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
 		 * as RAZ
 		 */
-		if (vcpu->kvm->arch.arm_pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P4)
+		if (vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P4)
 			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
 		base = 32;
 	}
@@ -970,11 +971,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		return 0;
 	}
 	case KVM_ARM_VCPU_PMU_V3_FILTER: {
+		u8 pmuver = kvm_arm_pmu_get_pmuver_limit(kvm);
 		struct kvm_pmu_event_filter __user *uaddr;
 		struct kvm_pmu_event_filter filter;
 		int nr_events;
 
-		nr_events = kvm_pmu_event_mask(kvm) + 1;
+		/*
+		 * Allow userspace to specify an event filter for the entire
+		 * event range supported by PMUVer of the hardware, rather
+		 * than the guest's PMUVer for KVM backward compatibility.
+		 */
+		nr_events = __kvm_pmu_event_mask(pmuver) + 1;
 
 		uaddr = (struct kvm_pmu_event_filter __user *)(long)attr->addr;
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

