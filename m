Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986817796A0
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 20:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbjHKSFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 14:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjHKSFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 14:05:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC7E2706
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 11:05:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D14AB643AB
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 18:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E883C433C7;
        Fri, 11 Aug 2023 18:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691777130;
        bh=l6yBgpeHwVV6ImpsDnxJpDJrHqgiaHTPBxktsCstHWM=;
        h=From:To:Cc:Subject:Date:From;
        b=mNCoLNgCTVYbJPWt59hHrWF5lVHLYzF86W9qUkBiNQAWUgC0DlWhugCSVk0JspUzP
         4898mvKMggnFb6qJuvTFxTJqYxUimdEax6RCm7NqzzW65vYIFPPOwGEzNotspXqw6i
         Dg/moxK07MLe2p9J0d1bt5Ru4Hb3tSi8UEMkTVokCfh4jJVaQGf+D+XCa9Sck/TC1I
         83TqdJwehtcDJ/sIt3oJ9h5KxRqFQ8gJVPuFsUSo6MdCNeZZeJoRyldxAY6IoDMbB9
         gzkn2knKsxoawhvkiM+5APKGcl09KWHHNulp0G2Q2tNBxI1RwtRS10hkJDhx+QtAqC
         agELs0ZbevKUQ==
Received: from c-xd4ed8706.customers.hiper-net.dk ([212.237.135.6] helo=localhost.localdomain)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qUWVr-004DX6-K0;
        Fri, 11 Aug 2023 19:05:27 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huang Shijie <shijie@os.amperecomputing.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH] KVM: arm64: pmu: Resync EL0 state on counter rotation
Date:   Fri, 11 Aug 2023 19:05:20 +0100
Message-Id: <20230811180520.131727-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 212.237.135.6
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, shijie@os.amperecomputing.com, mark.rutland@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Huang Shijie reports that, when profiling a guest from the host
with a number of events that exceeds the number of available
counters, the reported counts are wildly inaccurate. Without
the counter oversubscription, the reported counts are correct.

Their investigation indicates that upon counter rotation (which
takes place on the back of a timer interrupt), we fail to
re-apply the guest EL0 enabling, leading to the counting of host
events instead of guest events.

In order to solve this, add yet another hook between the host PMU
driver and KVM, re-applying the guest EL0 configuration if the
right conditions apply (the host is VHE, we are in interrupt
context, and we interrupted a running vcpu). This triggers a new
vcpu request which will apply the correct configuration on guest
reentry.

With this, we have the correct counts, even when the counters are
oversubscribed.

Reported-by: Huang Shijie <shijie@os.amperecomputing.com>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20230809013953.7692-1-shijie@os.amperecomputing.com
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  3 +++
 arch/arm64/kvm/pmu.c              | 18 ++++++++++++++++++
 drivers/perf/arm_pmuv3.c          |  2 ++
 include/kvm/arm_pmu.h             |  2 ++
 5 files changed, 26 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d3dd05bbfe23..553040e0e375 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -49,6 +49,7 @@
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
 #define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
+#define KVM_REQ_RESYNC_PMU_EL0	KVM_ARCH_REQ(7)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 72dc53a75d1c..978b0411082f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -803,6 +803,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 			kvm_pmu_handle_pmcr(vcpu,
 					    __vcpu_sys_reg(vcpu, PMCR_EL0));
 
+		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
+			kvm_vcpu_pmu_restore_guest(vcpu);
+
 		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
 			return kvm_vcpu_suspend(vcpu);
 
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 121f1a14c829..0eea225fd09a 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -236,3 +236,21 @@ bool kvm_set_pmuserenr(u64 val)
 	ctxt_sys_reg(hctxt, PMUSERENR_EL0) = val;
 	return true;
 }
+
+/*
+ * If we interrupted the guest to update the host PMU context, make
+ * sure we re-apply the guest EL0 state.
+ */
+void kvm_vcpu_pmu_resync_el0(void)
+{
+	struct kvm_vcpu *vcpu;
+
+	if (!has_vhe() || !in_interrupt())
+		return;
+
+	vcpu = kvm_get_running_vcpu();
+	if (!vcpu)
+		return;
+
+	kvm_make_request(KVM_REQ_RESYNC_PMU_EL0, vcpu);
+}
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 08b3a1bf0ef6..6a3d8176f54a 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -772,6 +772,8 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
 
 	/* Enable all counters */
 	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
+
+	kvm_vcpu_pmu_resync_el0();
 }
 
 static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 847da6fc2713..3a8a70a60794 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -74,6 +74,7 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
 struct kvm_pmu_events *kvm_get_pmu_events(void);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
+void kvm_vcpu_pmu_resync_el0(void);
 
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
@@ -171,6 +172,7 @@ static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
 {
 	return 0;
 }
+static inline void kvm_vcpu_pmu_resync_el0(void) {}
 
 #endif
 
-- 
2.39.2

