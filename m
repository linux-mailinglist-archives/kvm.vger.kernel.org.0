Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14AC127D45
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 15:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfLTOam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 09:30:42 -0500
Received: from foss.arm.com ([217.140.110.172]:51198 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbfLTOaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:39 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF45611D4;
        Fri, 20 Dec 2019 06:30:38 -0800 (PST)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1120D3F718;
        Fri, 20 Dec 2019 06:30:36 -0800 (PST)
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc:     Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 03/18] arm64: KVM: define SPE data structure for each vcpu
Date:   Fri, 20 Dec 2019 14:30:10 +0000
Message-Id: <20191220143025.33853-4-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191220143025.33853-1-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

In order to support virtual SPE for guest, so define some basic structs.
This features depends on host having hardware with SPE support.

Since we can support this only on ARM64, add a separate config symbol
for the same.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
[ Add irq_level, rename irq to irq_num for kvm_spe ]
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/Kconfig            |  7 +++++++
 include/kvm/arm_spe.h             | 19 +++++++++++++++++++
 3 files changed, 28 insertions(+)
 create mode 100644 include/kvm/arm_spe.h

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c61260cf63c5..f5dcff912645 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -35,6 +35,7 @@
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
 #include <kvm/arm_pmu.h>
+#include <kvm/arm_spe.h>
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
@@ -302,6 +303,7 @@ struct kvm_vcpu_arch {
 	struct vgic_cpu vgic_cpu;
 	struct arch_timer_cpu timer_cpu;
 	struct kvm_pmu pmu;
+	struct kvm_spe spe;
 
 	/*
 	 * Anything that is not used directly from assembly code goes
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a475c68cbfec..af5be2c57dcb 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -35,6 +35,7 @@ config KVM
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select KVM_ARM_PMU if HW_PERF_EVENTS
+	select KVM_ARM_SPE if (HW_PERF_EVENTS && ARM_SPE_PMU)
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
@@ -61,6 +62,12 @@ config KVM_ARM_PMU
 	  Adds support for a virtual Performance Monitoring Unit (PMU) in
 	  virtual machines.
 
+config KVM_ARM_SPE
+	bool
+	---help---
+	  Adds support for a virtual Statistical Profiling Extension(SPE) in
+	  virtual machines.
+
 config KVM_INDIRECT_VECTORS
        def_bool KVM && (HARDEN_BRANCH_PREDICTOR || HARDEN_EL2_VECTORS)
 
diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
new file mode 100644
index 000000000000..48d118fdb174
--- /dev/null
+++ b/include/kvm/arm_spe.h
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 ARM Ltd.
+ */
+
+#ifndef __ASM_ARM_KVM_SPE_H
+#define __ASM_ARM_KVM_SPE_H
+
+#include <uapi/linux/kvm.h>
+#include <linux/kvm_host.h>
+
+struct kvm_spe {
+	int irq_num;
+	bool ready; /* indicates that SPE KVM instance is ready for use */
+	bool created; /* SPE KVM instance is created, may not be ready yet */
+	bool irq_level;
+};
+
+#endif /* __ASM_ARM_KVM_SPE_H */
-- 
2.21.0

