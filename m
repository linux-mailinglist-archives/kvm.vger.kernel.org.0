Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075D5692D94
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 04:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjBKDQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 22:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBKDQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 22:16:45 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B8B60E47
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:41 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id z9-20020a25ba49000000b007d4416e3667so6807241ybj.23
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RBT5x66aj0o+bGVgZJhYwS6XmSzkSdatLkUK3qko77M=;
        b=ZSz6nXEHRKC94b0+dd0cJ2iN8ANusTD8u+RwkNdGXCMXNBFQhzC6Vbt9PFrPwbX48w
         6tclEBudcfYEoIbh1fF64f8HSG8PqMV78j4ulFdqk26qpVr90D4xfdOuav5C0/N5PteN
         GiVdCAnseLwKcGY0r0zUZ2GD/FgzgPiwjXol1mD6QnU4t6qSt+3R2V2TGVq+/lzXJKa3
         uGWhkat/VK1TI23yfMziDsa6XpvhT5rcPoC+S3tgpq8N2MX/f5xaf87kYqSX9kyKvlbv
         6OyXYVVw7i0q3mI5imrYK/nTYz9PYMDSBpgMTU0nrdRRZ2ji9h4ypJPlrBVlIuiW68bB
         nhxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RBT5x66aj0o+bGVgZJhYwS6XmSzkSdatLkUK3qko77M=;
        b=wrulNmOAhLXkXPVy2EnQXRGPwFhcgPsGAlk0ogtEV1xAX7Kz0+KcvU8BYL/lYamSLq
         G1ZCSHV50qcDoP2NPjDgp+d1oOOL3Ctovt8oGGjmdJf9CA2LUKbGIKj7aaruIMmBsccC
         pi0p/rVXLG6w0ls1tgHwDz26pjYO54RDpAZtCv/20E/F+cOkLezgZCTXo//IpjYzwXyy
         8z60Zv3Yt6jQ8a4bHiD5mlxOemzvSXNb20hi0jf0EMIR/eM4Vghynx/Y1vmeHzM5J3Vc
         eSF9rfqU+/k2ZWT+nF5af9I40LI/IBIknzUwN9em1JBrzbjjjlVdMtn8cy6NGIZftS1V
         OFUA==
X-Gm-Message-State: AO0yUKXoOnqbCsY2mvODLZExv/4zqT2bXkYA3eOdnYR3RgD3/bgDcP0G
        I/As/8d2nUTMjzAQ0rrdFYaZlQkhyYQ=
X-Google-Smtp-Source: AK7set9PagVjhSsFZquxxbL9a5MP6qEOSBD/vZTrtrlmS9TLAckHrNrA532H7ANzqpZDfdckSdHc7xqLCoQ=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:dccc:0:b0:8dc:e5aa:b60 with SMTP id
 y195-20020a25dccc000000b008dce5aa0b60mr6ybe.12.1676085400111; Fri, 10 Feb
 2023 19:16:40 -0800 (PST)
Date:   Fri, 10 Feb 2023 19:14:56 -0800
In-Reply-To: <20230211031506.4159098-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230211031506.4159098-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-5-reijiw@google.com>
Subject: [PATCH v4 04/14] KVM: arm64: PMU: Don't use the PMUVer of the PMU set
 for the guest
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
2.39.1.581.gbfd45094c4-goog

