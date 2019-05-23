Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD4FC27ABC
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 12:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbfEWKf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 06:35:59 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:43202 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730749AbfEWKf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 06:35:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 284E41688;
        Thu, 23 May 2019 03:35:56 -0700 (PDT)
Received: from usa.arm.com (e107155-lin.cambridge.arm.com [10.1.196.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 142383F718;
        Thu, 23 May 2019 03:35:53 -0700 (PDT)
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
Subject: [PATCH v2 15/15][KVMTOOL] kvm: add a vcpu feature for SPEv1 support
Date:   Thu, 23 May 2019 11:35:02 +0100
Message-Id: <20190523103502.25925-16-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523103502.25925-1-sudeep.holla@arm.com>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a runtime configurable for KVM tool to enable Statistical
Profiling Extensions version 1 support in guest kernel. A command line
option --spe is required to use the same.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 Makefile                                  |  2 +-
 arm/aarch64/arm-cpu.c                     |  2 +
 arm/aarch64/include/asm/kvm.h             |  4 ++
 arm/aarch64/include/kvm/kvm-config-arch.h |  2 +
 arm/aarch64/include/kvm/kvm-cpu-arch.h    |  3 +-
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 arm/include/arm-common/spe.h              |  4 ++
 arm/spe.c                                 | 81 +++++++++++++++++++++++
 include/linux/kvm.h                       |  1 +
 9 files changed, 98 insertions(+), 2 deletions(-)
 create mode 100644 arm/include/arm-common/spe.h
 create mode 100644 arm/spe.c

diff --git a/Makefile b/Makefile
index 9e21a4e2b419..b7c7ad8caf20 100644
--- a/Makefile
+++ b/Makefile
@@ -158,7 +158,7 @@ endif
 # ARM
 OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/gicv2m.o arm/ioport.o \
 			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
-			   arm/pmu.o
+			   arm/pmu.o arm/spe.o
 HDRS_ARM_COMMON		:= arm/include
 ifeq ($(ARCH), arm)
 	DEFINES		+= -DCONFIG_ARM
diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
index d7572b7790b1..6ccea033f361 100644
--- a/arm/aarch64/arm-cpu.c
+++ b/arm/aarch64/arm-cpu.c
@@ -6,6 +6,7 @@
 #include "arm-common/gic.h"
 #include "arm-common/timer.h"
 #include "arm-common/pmu.h"
+#include "arm-common/spe.h"
 
 #include <linux/byteorder.h>
 #include <linux/types.h>
@@ -17,6 +18,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip);
 	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
 	pmu__generate_fdt_nodes(fdt, kvm);
+	spe__generate_fdt_nodes(fdt, kvm);
 }
 
 static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 7b7ac0f6cec9..4c9e168de896 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -106,6 +106,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
 #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
+#define KVM_ARM_VCPU_SPE_V1		7 /* Support guest SPEv1 */
 
 struct kvm_vcpu_init {
 	__u32 target;
@@ -306,6 +307,9 @@ struct kvm_vcpu_events {
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
+#define KVM_ARM_VCPU_SPE_V1_CTRL	2
+#define   KVM_ARM_VCPU_SPE_V1_IRQ	0
+#define   KVM_ARM_VCPU_SPE_V1_INIT	1
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 04be43dfa9b2..9968e1666de5 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -6,6 +6,8 @@
 			"Run AArch32 guest"),				\
 	OPT_BOOLEAN('\0', "pmu", &(cfg)->has_pmuv3,			\
 			"Create PMUv3 device"),				\
+	OPT_BOOLEAN('\0', "spe", &(cfg)->has_spev1,			\
+			"Create SPEv1 device"),				\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
 			"Specify random seed for Kernel Address Space "	\
 			"Layout Randomization (KASLR)"),
diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index a9d8563382c6..5abaf9505274 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -8,7 +8,8 @@
 #define ARM_VCPU_FEATURE_FLAGS(kvm, cpuid)	{				\
 	[0] = ((!!(cpuid) << KVM_ARM_VCPU_POWER_OFF) |				\
 	       (!!(kvm)->cfg.arch.aarch32_guest << KVM_ARM_VCPU_EL1_32BIT) |	\
-	       (!!(kvm)->cfg.arch.has_pmuv3 << KVM_ARM_VCPU_PMU_V3))		\
+	       (!!(kvm)->cfg.arch.has_pmuv3 << KVM_ARM_VCPU_PMU_V3) |		\
+	       (!!(kvm)->cfg.arch.has_spev1 << KVM_ARM_VCPU_SPE_V1))		\
 }
 
 #define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 5734c46ab9e6..742733e289af 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -9,6 +9,7 @@ struct kvm_config_arch {
 	bool		virtio_trans_pci;
 	bool		aarch32_guest;
 	bool		has_pmuv3;
+	bool		has_spev1;
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
diff --git a/arm/include/arm-common/spe.h b/arm/include/arm-common/spe.h
new file mode 100644
index 000000000000..bcfa40877f6f
--- /dev/null
+++ b/arm/include/arm-common/spe.h
@@ -0,0 +1,4 @@
+
+#define KVM_ARM_SPEV1_PPI			21
+
+void spe__generate_fdt_nodes(void *fdt, struct kvm *kvm);
diff --git a/arm/spe.c b/arm/spe.c
new file mode 100644
index 000000000000..ec03b01a3866
--- /dev/null
+++ b/arm/spe.c
@@ -0,0 +1,81 @@
+#include "kvm/fdt.h"
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+
+#include "arm-common/gic.h"
+#include "arm-common/spe.h"
+
+#ifdef CONFIG_ARM64
+static int set_spe_attr(struct kvm *kvm, int vcpu_idx,
+			struct kvm_device_attr *attr)
+{
+	int ret, fd;
+
+	fd = kvm->cpus[vcpu_idx]->vcpu_fd;
+
+	ret = ioctl(fd, KVM_HAS_DEVICE_ATTR, attr);
+	if (!ret) {
+		ret = ioctl(fd, KVM_SET_DEVICE_ATTR, attr);
+		if (ret)
+			pr_err("SPE KVM_SET_DEVICE_ATTR failed (%d)\n", ret);
+	} else {
+		pr_err("Unsupported SPE on vcpu%d\n", vcpu_idx);
+	}
+
+	return ret;
+}
+
+void spe__generate_fdt_nodes(void *fdt, struct kvm *kvm)
+{
+	const char compatible[] = "arm,statistical-profiling-extension-v1";
+	int irq = KVM_ARM_SPEV1_PPI;
+	int i, ret;
+
+	u32 cpu_mask = (((1 << kvm->nrcpus) - 1) << GIC_FDT_IRQ_PPI_CPU_SHIFT) \
+		       & GIC_FDT_IRQ_PPI_CPU_MASK;
+	u32 irq_prop[] = {
+		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
+		cpu_to_fdt32(irq - 16),
+		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_HIGH),
+	};
+
+	if (!kvm->cfg.arch.has_spev1)
+		return;
+
+	if (!kvm__supports_extension(kvm, KVM_CAP_ARM_SPE_V1)) {
+		pr_info("SPE unsupported\n");
+		return;
+	}
+
+	for (i = 0; i < kvm->nrcpus; i++) {
+		struct kvm_device_attr spe_attr;
+
+		spe_attr = (struct kvm_device_attr){
+			.group	= KVM_ARM_VCPU_SPE_V1_CTRL,
+			.addr	= (u64)(unsigned long)&irq,
+			.attr	= KVM_ARM_VCPU_SPE_V1_IRQ,
+		};
+
+		ret = set_spe_attr(kvm, i, &spe_attr);
+		if (ret)
+			return;
+
+		spe_attr = (struct kvm_device_attr){
+			.group	= KVM_ARM_VCPU_SPE_V1_CTRL,
+			.attr	= KVM_ARM_VCPU_SPE_V1_INIT,
+		};
+
+		ret = set_spe_attr(kvm, i, &spe_attr);
+		if (ret)
+			return;
+	}
+
+	_FDT(fdt_begin_node(fdt, "spe"));
+	_FDT(fdt_property(fdt, "compatible", compatible, sizeof(compatible)));
+	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
+	_FDT(fdt_end_node(fdt));
+}
+#else
+void spe__generate_fdt_nodes(void *fdt, struct kvm *kvm) { }
+#endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 2fe12b40d503..698bcc2f96e3 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -993,6 +993,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_SVE 170
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
+#define KVM_CAP_ARM_SPE_V1 173
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.17.1

