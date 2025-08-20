Return-Path: <kvm+bounces-55171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93D86B2E080
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:15:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6DAF580E3D
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD2CE3277A4;
	Wed, 20 Aug 2025 14:59:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0029534F475;
	Wed, 20 Aug 2025 14:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701985; cv=none; b=HBiceqG+QuQ1PcjNt9Hey6gGV/T7wAesVr49sZHZucelKmdqar4/4Kgky4fuRhPphMgqCOFIGK4JLwanpBOot/kn6Qp6BkRgXxDB5Nc+lIdoY3hkYXvFBLWjqRdsnCIIfOj0iE9hlha2j6AgtAeT//7RtGASXmkJ3Fy89D+IPlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701985; c=relaxed/simple;
	bh=bB9lRIGZwB6oqYHryZlMed0C/GUqhcP69CzXrJjI4UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GO4Xsj2rdFrUsUX29G6emXgBwhBxH6iYEN3pyuOysVSNZ5aHvdz8/kcx9N5hG2meqk+8t1D1D7gOH4OUhHja8Dgrzlrfx8p7w107FwqWm/QIj+13qGYfEJNP8zeh7Fn6OftmNh/1vdTEYrMMA1dCCz5kXqbgXp5lXZbmZVseZ0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 524A22C27;
	Wed, 20 Aug 2025 07:59:35 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.2.58])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AFCDF3F738;
	Wed, 20 Aug 2025 07:59:39 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v10 31/43] arm_pmu: Provide a mechanism for disabling the physical IRQ
Date: Wed, 20 Aug 2025 15:55:51 +0100
Message-ID: <20250820145606.180644-32-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820145606.180644-1-steven.price@arm.com>
References: <20250820145606.180644-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Arm CCA assigns the physical PMU device to the guest running in realm
world, however the IRQs are routed via the host. To enter a realm guest
while a PMU IRQ is pending it is necessary to block the physical IRQ to
prevent an immediate exit. Provide a mechanism in the PMU driver for KVM
to control the physical IRQ.

Signed-off-by: Steven Price <steven.price@arm.com>
---
v3: Add a dummy function for the !CONFIG_ARM_PMU case.
---
 drivers/perf/arm_pmu.c       | 15 +++++++++++++++
 include/linux/perf/arm_pmu.h |  5 +++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
index 5c310e803dd7..e737310b3fef 100644
--- a/drivers/perf/arm_pmu.c
+++ b/drivers/perf/arm_pmu.c
@@ -743,6 +743,21 @@ static int arm_perf_teardown_cpu(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
+void arm_pmu_set_phys_irq(bool enable)
+{
+	int cpu = get_cpu();
+	struct arm_pmu *pmu = per_cpu(cpu_armpmu, cpu);
+	int irq;
+
+	irq = armpmu_get_cpu_irq(pmu, cpu);
+	if (irq && !enable)
+		per_cpu(cpu_irq_ops, cpu)->disable_pmuirq(irq);
+	else if (irq && enable)
+		per_cpu(cpu_irq_ops, cpu)->enable_pmuirq(irq);
+
+	put_cpu();
+}
+
 #ifdef CONFIG_CPU_PM
 static void cpu_pm_pmu_setup(struct arm_pmu *armpmu, unsigned long cmd)
 {
diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
index 93c9a26492fc..a026fa15f6b5 100644
--- a/include/linux/perf/arm_pmu.h
+++ b/include/linux/perf/arm_pmu.h
@@ -185,6 +185,7 @@ void kvm_host_pmu_init(struct arm_pmu *pmu);
 #endif
 
 bool arm_pmu_irq_is_nmi(void);
+void arm_pmu_set_phys_irq(bool enable);
 
 /* Internal functions only for core arm_pmu code */
 struct arm_pmu *armpmu_alloc(void);
@@ -195,6 +196,10 @@ void armpmu_free_irq(int irq, int cpu);
 
 #define ARMV8_PMU_PDEV_NAME "armv8-pmu"
 
+#else /* CONFIG_ARM_PMU */
+
+static inline void arm_pmu_set_phys_irq(bool enable) {}
+
 #endif /* CONFIG_ARM_PMU */
 
 #define ARMV8_SPE_PDEV_NAME "arm,spe-v1"
-- 
2.43.0


