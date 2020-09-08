Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58380261B22
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 20:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731124AbgIHSz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 14:55:29 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:62984 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgIHSzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 14:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599591308; x=1631127308;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=x5jEF96sYCAIy62XD2CkEvqSoI0X9CvEDr0LQID4QSM=;
  b=L64aNTEHBgFKOJoGKPJUAnl5WaPuqSpKksJS+9eRL9vbyjF31LnY4KLt
   g8WQtDm+l7c3t5T6SEBCr1PKda7VCp/7bVDdXm+aObMsAyH6ZnNEDueZ+
   S3nbX6VZ5gkwtMbmp2v+3tXyveZbO58ns4B8eFX3mt/s0RAasvnLNWdCH
   Q=;
X-IronPort-AV: E=Sophos;i="5.76,406,1592870400"; 
   d="scan'208";a="66374160"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 08 Sep 2020 18:55:00 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 8E7E7A2582;
        Tue,  8 Sep 2020 18:54:58 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Sep 2020 18:54:56 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.161.85) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Sep 2020 18:54:53 +0000
From:   Alexander Graf <graf@amazon.com>
To:     <kvmarm@lists.cs.columbia.edu>
CC:     Marc Zyngier <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH] KVM: arm64: Allow to limit number of PMU counters
Date:   Tue, 8 Sep 2020 20:54:45 +0200
Message-ID: <20200908185445.22561-1-graf@amazon.com>
X-Mailer: git-send-email 2.28.0.394.ge197136389
MIME-Version: 1.0
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D12UWC004.ant.amazon.com (10.43.162.182) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We currently pass through the number of PMU counters that we have available
in hardware to guests. So if my host supports 10 concurrently active PMU
counters, my guest will be able to spawn 10 counters as well.

This is undesireable if we also want to use the PMU on the host for
monitoring. In that case, we want to split the PMU between guest and
host.

To help that case, let's add a PMU attr that allows us to limit the number
of PMU counters that we expose. With this patch in place, user space can
keep some counters free for host use.

Signed-off-by: Alexander Graf <graf@amazon.com>

---

Because this patch touches the same code paths as the vPMU filtering one
and the vPMU filtering generalized a few conditions in the attr path,
I've based it on top. Please let me know if you want it independent instead.
---
 arch/arm64/include/uapi/asm/kvm.h |  7 ++++---
 arch/arm64/kvm/pmu-emul.c         | 22 ++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         |  5 +++++
 include/kvm/arm_pmu.h             |  1 +
 4 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 7b1511d6ce44..db025c0b5a40 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -342,9 +342,10 @@ struct kvm_vcpu_events {
 
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
-#define   KVM_ARM_VCPU_PMU_V3_IRQ	0
-#define   KVM_ARM_VCPU_PMU_V3_INIT	1
-#define   KVM_ARM_VCPU_PMU_V3_FILTER	2
+#define   KVM_ARM_VCPU_PMU_V3_IRQ		0
+#define   KVM_ARM_VCPU_PMU_V3_INIT		1
+#define   KVM_ARM_VCPU_PMU_V3_FILTER		2
+#define   KVM_ARM_VCPU_PMU_V3_NUM_EVENTS	3
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 9f0fd0224d5b..40848e17d0cb 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -238,6 +238,8 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
 		pmu->pmc[i].idx = i;
+
+	pmu->num_events = perf_num_counters() - 1;
 }
 
 /**
@@ -875,6 +877,25 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return 0;
 	}
+	case KVM_ARM_VCPU_PMU_V3_NUM_EVENTS: {
+		u64 mask = ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT;
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		unsigned int num_events;
+
+		if (get_user(num_events, uaddr))
+			return -EFAULT;
+
+		if (num_events >= perf_num_counters())
+			return -EINVAL;
+
+		vcpu->arch.pmu.num_events = num_events;
+
+		num_events <<= ARMV8_PMU_PMCR_N_SHIFT;
+		__vcpu_sys_reg(vcpu, SYS_PMCR_EL0) &= ~mask;
+		__vcpu_sys_reg(vcpu, SYS_PMCR_EL0) |= num_events;
+
+		return 0;
+	}
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 		return kvm_arm_pmu_v3_init(vcpu);
 	}
@@ -912,6 +933,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_PMU_V3_IRQ:
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 	case KVM_ARM_VCPU_PMU_V3_FILTER:
+	case KVM_ARM_VCPU_PMU_V3_NUM_EVENTS:
 		if (kvm_arm_support_pmu_v3() &&
 		    test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
 			return 0;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 077293b5115f..fca0bba6d97b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -672,6 +672,11 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
 	if (!system_supports_32bit_el0())
 		val |= ARMV8_PMU_PMCR_LC;
+
+	/* Override number of event selectors */
+	val &= ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
+	val |= (u32)vcpu->arch.pmu.num_events << ARMV8_PMU_PMCR_N_SHIFT;
+
 	__vcpu_sys_reg(vcpu, r->reg) = val;
 }
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 6db030439e29..5557024edce5 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -27,6 +27,7 @@ struct kvm_pmu {
 	bool ready;
 	bool created;
 	bool irq_level;
+	u8 num_events;
 };
 
 #define kvm_arm_pmu_v3_ready(v)		((v)->arch.pmu.ready)
-- 
2.16.4




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



