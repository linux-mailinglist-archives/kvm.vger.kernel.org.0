Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96E97C58FE
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 18:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbjJKQRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 12:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbjJKQRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 12:17:21 -0400
Received: from out-205.mta0.migadu.com (out-205.mta0.migadu.com [IPv6:2001:41d0:1004:224b::cd])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0591591
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 09:17:19 -0700 (PDT)
Date:   Wed, 11 Oct 2023 16:17:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697041038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r1TLZrOHuYKUtJ/M2uZHzGl+dSoKy/pyNUOh8kO6hmI=;
        b=rqE+CVVT2d4VnEpkg/WhSs+a/hq3+0Q0y+MNQ0p8wgUkhodiArjMHYMBiaZ62G1tAZah3G
        zRwS0RAIXABn7Q986UuguRhcw35DOzgRzoYnSb0aw5NisuAx/kAbeCexl1SgI1jvFwaFeJ
        GCCP8RqDH4LBfPM/mev9PUK9x2IfJio=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        James Clark <james.clark@arm.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Treat PMEVTYPER<n>_EL0.NSH as RES0
Message-ID: <ZSbKiXY-LAsfRdlD@linux.dev>
References: <20231011081649.3226792-1-oliver.upton@linux.dev>
 <20231011081649.3226792-3-oliver.upton@linux.dev>
 <24d7dda6-888c-141e-3aa0-9319987360d7@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24d7dda6-888c-141e-3aa0-9319987360d7@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 01:33:16PM +0100, Suzuki K Poulose wrote:

[...]

> However, I think we are missing the support for a guest using the
> combination of PMEVTYPER.NS{K/U} instead of the PMEVTYPER.{P/U} for
> filtering the events. As per Arm ARM, it is permitted to use the
> PMEVTYPER.NSK/U (leaving PMEVTYPER.{P,U} == 0) for filtering in Non-Secure
> EL1.

Ah, good eye. The pseudocode is easy enough to rip off, something like
the below diff would get things going. There's an extra step of making
these bits RES0 if EL3 isn't present in the guest's ID register values,
but not a huge deal.

> Anyways, for this patch:
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com?

Thanks!

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 087764435390..b6df9ba39940 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -585,6 +585,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	struct perf_event *event;
 	struct perf_event_attr attr;
 	u64 eventsel, reg, data;
+	bool p, u, nsk, nsu;
 
 	reg = counter_index_to_evtreg(pmc->idx);
 	data = __vcpu_sys_reg(vcpu, reg);
@@ -611,13 +612,18 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
 		return;
 
+	p = data & ARMV8_PMU_EXCLUDE_EL1;
+	u = data & ARMV8_PMU_EXCLUDE_EL0;
+	nsk = data & ARMV8_PMU_EXCLUDE_NS_EL1;
+	nsu = data & ARMV8_PMU_EXCLUDE_NS_EL0;
+
 	memset(&attr, 0, sizeof(struct perf_event_attr));
 	attr.type = arm_pmu->pmu.type;
 	attr.size = sizeof(attr);
 	attr.pinned = 1;
 	attr.disabled = !kvm_pmu_counter_is_enabled(pmc);
-	attr.exclude_user = data & ARMV8_PMU_EXCLUDE_EL0 ? 1 : 0;
-	attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
+	attr.exclude_user = (u != nsu);
+	attr.exclude_kernel = (p != nsk);
 	attr.exclude_hv = 1; /* Don't count EL2 events */
 	attr.exclude_host = 1; /* Don't count host events */
 	attr.config = eventsel;
@@ -663,7 +669,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
-	mask = ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0;
+	mask = ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0 |
+	       ARMV8_PMU_EXCLUDE_NS_EL1 | ARMV8_PMU_EXCLUDE_NS_EL0;
 	mask |= kvm_pmu_event_mask(vcpu->kvm);
 
 	reg = counter_index_to_evtreg(pmc->idx);
diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index 753f8dbd9d10..872119cc2bac 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -235,9 +235,11 @@
 /*
  * Event filters for PMUv3
  */
-#define ARMV8_PMU_EXCLUDE_EL1	(1U << 31)
-#define ARMV8_PMU_EXCLUDE_EL0	(1U << 30)
-#define ARMV8_PMU_INCLUDE_EL2	(1U << 27)
+#define ARMV8_PMU_EXCLUDE_EL1		(1U << 31)
+#define ARMV8_PMU_EXCLUDE_EL0		(1U << 30)
+#define ARMV8_PMU_EXCLUDE_NS_EL1	(1U << 29)
+#define ARMV8_PMU_EXCLUDE_NS_EL0	(1U << 28)
+#define ARMV8_PMU_INCLUDE_EL2		(1U << 27)
 
 /*
  * PMUSERENR: user enable reg
-- 
Best,
Oliver
