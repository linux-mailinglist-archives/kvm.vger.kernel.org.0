Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB21127CFF
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 15:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfLTOb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 09:31:59 -0500
Received: from foss.arm.com ([217.140.110.172]:51312 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbfLTObB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 09:31:01 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB5FF11D4;
        Fri, 20 Dec 2019 06:31:00 -0800 (PST)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EEF63F718;
        Fri, 20 Dec 2019 06:30:58 -0800 (PST)
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc:     Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 13/18] perf: arm_spe: Add KVM structure for obtaining IRQ info
Date:   Fri, 20 Dec 2019 14:30:20 +0000
Message-Id: <20191220143025.33853-14-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191220143025.33853-1-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM requires knowledge of the physical SPE IRQ number such that it can
associate it with any virtual IRQ for guests that require SPE emulation.

Let's create a structure to hold this information and an accessor that
KVM can use to retrieve this information.

We expect that each SPE device will have the same physical PPI number
and thus will warn when this is not the case.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 drivers/perf/arm_spe_pmu.c | 23 +++++++++++++++++++++++
 include/kvm/arm_spe.h      |  6 ++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 4e4984a55cd1..2d24af4cfcab 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -34,6 +34,9 @@
 #include <linux/smp.h>
 #include <linux/vmalloc.h>
 
+#include <linux/kvm_host.h>
+#include <kvm/arm_spe.h>
+
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/mmu.h>
@@ -1127,6 +1130,24 @@ static void arm_spe_pmu_dev_teardown(struct arm_spe_pmu *spe_pmu)
 	free_percpu_irq(spe_pmu->irq, spe_pmu->handle);
 }
 
+#ifdef CONFIG_KVM_ARM_SPE
+static struct arm_spe_kvm_info arm_spe_kvm_info;
+
+struct arm_spe_kvm_info *arm_spe_get_kvm_info(void)
+{
+	return &arm_spe_kvm_info;
+}
+
+static void arm_spe_populate_kvm_info(struct arm_spe_pmu *spe_pmu)
+{
+	WARN_ON_ONCE(arm_spe_kvm_info.physical_irq != 0 &&
+		     arm_spe_kvm_info.physical_irq != spe_pmu->irq);
+	arm_spe_kvm_info.physical_irq = spe_pmu->irq;
+}
+#else
+static void arm_spe_populate_kvm_info(struct arm_spe_pmu *spe_pmu) {}
+#endif
+
 /* Driver and device probing */
 static int arm_spe_pmu_irq_probe(struct arm_spe_pmu *spe_pmu)
 {
@@ -1149,6 +1170,8 @@ static int arm_spe_pmu_irq_probe(struct arm_spe_pmu *spe_pmu)
 	}
 
 	spe_pmu->irq = irq;
+	arm_spe_populate_kvm_info(spe_pmu);
+
 	return 0;
 }
 
diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
index d1f3c564dfd0..9c65130d726d 100644
--- a/include/kvm/arm_spe.h
+++ b/include/kvm/arm_spe.h
@@ -17,6 +17,12 @@ struct kvm_spe {
 	bool irq_level;
 };
 
+struct arm_spe_kvm_info {
+	int physical_irq;
+};
+
+struct arm_spe_kvm_info *arm_spe_get_kvm_info(void);
+
 #ifdef CONFIG_KVM_ARM_SPE
 #define kvm_arm_spe_v1_ready(v)		((v)->arch.spe.ready)
 #define kvm_arm_spe_irq_initialized(v)		\
-- 
2.21.0

