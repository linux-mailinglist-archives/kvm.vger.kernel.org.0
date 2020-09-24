Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DED276F57
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 13:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgIXLGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 07:06:35 -0400
Received: from foss.arm.com ([217.140.110.172]:42280 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727476AbgIXLGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 07:06:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AB9E152B;
        Thu, 24 Sep 2020 04:06:23 -0700 (PDT)
Received: from monolith.localdoman (unknown [10.37.8.98])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A0723F73B;
        Thu, 24 Sep 2020 04:06:20 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     mark.rutland@arm.com, sumit.garg@linaro.org, maz@kernel.org,
        swboyd@chromium.org, catalin.marinas@arm.com, will@kernel.org,
        Julien Thierry <julien.thierry@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 5/7] KVM: arm64: pmu: Make overflow handler NMI safe
Date:   Thu, 24 Sep 2020 12:07:04 +0100
Message-Id: <20200924110706.254996-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200924110706.254996-1-alexandru.elisei@arm.com>
References: <20200924110706.254996-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

kvm_vcpu_kick() is not NMI safe. When the overflow handler is called from
NMI context, defer waking the vcpu to an irq_work queue.

A vcpu can be freed while it's not running by kvm_destroy_vm(). Prevent
running the irq_work for a non-existent vcpu by calling irq_work_sync() on
the PMU destroy path.

Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Tested-by: Sumit Garg <sumit.garg@linaro.org> (Developerbox)
[Alexandru E.: Added irq_work_sync()]
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
I suggested in v6 that I will add an irq_work_sync() to
kvm_pmu_vcpu_reset(). It turns out it's not necessary: a vcpu reset is done
by the vcpu being reset with interrupts enabled, which means all the work
has had a chance to run before the reset takes place.

 arch/arm64/kvm/pmu-emul.c | 26 +++++++++++++++++++++++++-
 include/kvm/arm_pmu.h     |  1 +
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index f0d0312c0a55..81916e360b1e 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -269,6 +269,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
 		kvm_pmu_release_perf_event(&pmu->pmc[i]);
+	irq_work_sync(&vcpu->arch.pmu.overflow_work);
 }
 
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
@@ -433,6 +434,22 @@ void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
 	kvm_pmu_update_state(vcpu);
 }
 
+/**
+ * When perf interrupt is an NMI, we cannot safely notify the vcpu corresponding
+ * to the event.
+ * This is why we need a callback to do it once outside of the NMI context.
+ */
+static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_pmu *pmu;
+
+	pmu = container_of(work, struct kvm_pmu, overflow_work);
+	vcpu = kvm_pmc_to_vcpu(pmu->pmc);
+
+	kvm_vcpu_kick(vcpu);
+}
+
 /**
  * When the perf event overflows, set the overflow status and inform the vcpu.
  */
@@ -465,7 +482,11 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 
 	if (kvm_pmu_overflow_status(vcpu)) {
 		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
-		kvm_vcpu_kick(vcpu);
+
+		if (!in_nmi())
+			kvm_vcpu_kick(vcpu);
+		else
+			irq_work_queue(&vcpu->arch.pmu.overflow_work);
 	}
 
 	cpu_pmu->pmu.start(perf_event, PERF_EF_RELOAD);
@@ -764,6 +785,9 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
+	init_irq_work(&vcpu->arch.pmu.overflow_work,
+		      kvm_pmu_perf_overflow_notify_vcpu);
+
 	vcpu->arch.pmu.created = true;
 	return 0;
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 6db030439e29..dbf4f08d42e5 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -27,6 +27,7 @@ struct kvm_pmu {
 	bool ready;
 	bool created;
 	bool irq_level;
+	struct irq_work overflow_work;
 };
 
 #define kvm_arm_pmu_v3_ready(v)		((v)->arch.pmu.ready)
-- 
2.28.0

