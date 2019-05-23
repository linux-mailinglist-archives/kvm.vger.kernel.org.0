Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F142627AAE
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 12:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbfEWKfb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 06:35:31 -0400
Received: from foss.arm.com ([217.140.101.70]:43046 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730499AbfEWKfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 06:35:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 560BA341;
        Thu, 23 May 2019 03:35:30 -0700 (PDT)
Received: from usa.arm.com (e107155-lin.cambridge.arm.com [10.1.196.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 427FE3F718;
        Thu, 23 May 2019 03:35:28 -0700 (PDT)
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v2 04/15] arm64: KVM: define SPE data structure for each vcpu
Date:   Thu, 23 May 2019 11:34:51 +0100
Message-Id: <20190523103502.25925-5-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523103502.25925-1-sudeep.holla@arm.com>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to support virtual SPE for guest, so define some basic structs.
This features depends on host having hardware with SPE support.

Since we can support this only on ARM64, add a separate config symbol
for the same.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/Kconfig            |  7 +++++++
 include/kvm/arm_spe.h             | 18 ++++++++++++++++++
 3 files changed, 27 insertions(+)
 create mode 100644 include/kvm/arm_spe.h

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a8d3f8ca22c..611a4884fb6c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -46,6 +46,7 @@
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
 #include <kvm/arm_pmu.h>
+#include <kvm/arm_spe.h>
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
@@ -304,6 +305,7 @@ struct kvm_vcpu_arch {
 	struct vgic_cpu vgic_cpu;
 	struct arch_timer_cpu timer_cpu;
 	struct kvm_pmu pmu;
+	struct kvm_spe spe;
 
 	/*
 	 * Anything that is not used directly from assembly code goes
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a67121d419a2..3e178894ddd8 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -33,6 +33,7 @@ config KVM
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select KVM_ARM_PMU if HW_PERF_EVENTS
+	select KVM_ARM_SPE if (HW_PERF_EVENTS && ARM_SPE_PMU)
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
@@ -57,6 +58,12 @@ config KVM_ARM_PMU
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
index 000000000000..8c96bdfad6ac
--- /dev/null
+++ b/include/kvm/arm_spe.h
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018 ARM Ltd.
+ */
+
+#ifndef __ASM_ARM_KVM_SPE_H
+#define __ASM_ARM_KVM_SPE_H
+
+#include <uapi/linux/kvm.h>
+#include <linux/kvm_host.h>
+
+struct kvm_spe {
+	int irq;
+	bool ready; /* indicates that SPE KVM instance is ready for use */
+	bool created; /* SPE KVM instance is created, may not be ready yet */
+};
+
+#endif /* __ASM_ARM_KVM_SPE_H */
-- 
2.17.1

