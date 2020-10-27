Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F05029C0E0
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 18:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818627AbgJ0RUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 13:20:54 -0400
Received: from foss.arm.com ([217.140.110.172]:47550 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1818033AbgJ0RRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 13:17:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DE18150C;
        Tue, 27 Oct 2020 10:16:58 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C20433F719;
        Tue, 27 Oct 2020 10:16:54 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Sudeep Holla <sudeep.holla@arm.com>,
        Andrew Murray <andrew.murray@arm.com>
Subject: [RFC PATCH kvmtool v3 3/3] arm64: Add SPE support
Date:   Tue, 27 Oct 2020 17:17:35 +0000
Message-Id: <20201027171735.13638-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027171735.13638-1-alexandru.elisei@arm.com>
References: <20201027171735.13638-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

Add a runtime configurable for kvmtool to enable SPE (Statistical
Profiling Extensions) for each vcpu and to create a corresponding DT node.
SPE is enabled at runtime with the --spe option.

[ Andrew M: Add SPE to init features ]
[ Alexandru E: Reworded commit, renamed spev1->spe to match kernel, added
	KVM_ARM_VM_SPE_FINALIZE, set VCPU feature only if requested by
	user ]

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile                                  |   2 +-
 arm/aarch64/arm-cpu.c                     |   2 +
 arm/aarch64/include/kvm/kvm-config-arch.h |   2 +
 arm/aarch64/include/kvm/kvm-cpu-arch.h    |   3 +-
 arm/aarch64/kvm-cpu.c                     |   5 +
 arm/include/arm-common/kvm-config-arch.h  |   1 +
 arm/include/arm-common/spe.h              |   7 +
 arm/spe.c                                 | 154 ++++++++++++++++++++++
 8 files changed, 174 insertions(+), 2 deletions(-)
 create mode 100644 arm/include/arm-common/spe.h
 create mode 100644 arm/spe.c

diff --git a/Makefile b/Makefile
index c465a491cf7e..9bfae78f0171 100644
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
diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 04be43dfa9b2..9f618cd9d2c1 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -6,6 +6,8 @@
 			"Run AArch32 guest"),				\
 	OPT_BOOLEAN('\0', "pmu", &(cfg)->has_pmuv3,			\
 			"Create PMUv3 device"),				\
+	OPT_BOOLEAN('\0', "spe", &(cfg)->has_spe,			\
+			"Create SPE device"),				\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
 			"Specify random seed for Kernel Address Space "	\
 			"Layout Randomization (KASLR)"),
diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index 8dfb82ecbc37..6868f2f66040 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -8,7 +8,8 @@
 #define ARM_VCPU_FEATURE_FLAGS(kvm, cpuid)	{				\
 	[0] = ((!!(cpuid) << KVM_ARM_VCPU_POWER_OFF) |				\
 	       (!!(kvm)->cfg.arch.aarch32_guest << KVM_ARM_VCPU_EL1_32BIT) |	\
-	       (!!(kvm)->cfg.arch.has_pmuv3 << KVM_ARM_VCPU_PMU_V3))		\
+	       (!!(kvm)->cfg.arch.has_pmuv3 << KVM_ARM_VCPU_PMU_V3) |		\
+	       (!!(kvm)->cfg.arch.has_spe << KVM_ARM_VCPU_SPE))			\
 }
 
 #define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 9f3e8586880c..9b67c5f1d2e2 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -140,6 +140,11 @@ void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init)
 	/* Enable SVE if available */
 	if (kvm__supports_extension(kvm, KVM_CAP_ARM_SVE))
 		init->features[0] |= 1UL << KVM_ARM_VCPU_SVE;
+
+	/* Enable SPE if requested */
+	if (kvm->cfg.arch.has_spe &&
+	    kvm__supports_extension(kvm, KVM_CAP_ARM_SPE))
+		init->features[0] |= 1UL << KVM_ARM_VCPU_SPE;
 }
 
 int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 5734c46ab9e6..08d8bfd3f7e0 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -9,6 +9,7 @@ struct kvm_config_arch {
 	bool		virtio_trans_pci;
 	bool		aarch32_guest;
 	bool		has_pmuv3;
+	bool		has_spe;
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
diff --git a/arm/include/arm-common/spe.h b/arm/include/arm-common/spe.h
new file mode 100644
index 000000000000..75b12827cfbb
--- /dev/null
+++ b/arm/include/arm-common/spe.h
@@ -0,0 +1,7 @@
+#ifndef ARM_COMMON__SPE_H
+#define ARM_COMMON__SPE_H
+
+#define KVM_ARM_SPE_IRQ	21
+
+void spe__generate_fdt_nodes(void *fdt, struct kvm *kvm);
+#endif /* ARM_COMMON__SPE_H */
diff --git a/arm/spe.c b/arm/spe.c
new file mode 100644
index 000000000000..0e7e85e77311
--- /dev/null
+++ b/arm/spe.c
@@ -0,0 +1,154 @@
+#include <stdio.h>
+#include <errno.h>
+
+#include <sys/resource.h>
+
+#include "kvm/fdt.h"
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+
+#include "arm-common/gic.h"
+#include "arm-common/spe.h"
+
+#ifdef CONFIG_ARM64
+static int set_spe_vcpu_attr(struct kvm *kvm, int vcpu_idx,
+			struct kvm_device_attr *attr)
+{
+	int ret, fd;
+
+	fd = kvm->cpus[vcpu_idx]->vcpu_fd;
+
+	ret = ioctl(fd, KVM_HAS_DEVICE_ATTR, attr);
+	if (ret) {
+		perror("SPE VCPU KVM_HAS_DEVICE_ATTR");
+		return ret;
+	}
+
+	ret = ioctl(fd, KVM_SET_DEVICE_ATTR, attr);
+	if (ret)
+		perror("SPE VCPU KVM_SET_DEVICE_ATTR");
+
+	return ret;
+}
+
+void spe__generate_fdt_nodes(void *fdt, struct kvm *kvm)
+{
+	const char compatible[] = "arm,statistical-profiling-extension-v1";
+	int irq = KVM_ARM_SPE_IRQ;
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
+	if (!kvm->cfg.arch.has_spe)
+		return;
+
+	if (!kvm__supports_extension(kvm, KVM_CAP_ARM_SPE)) {
+		pr_info("SPE unsupported by KVM\n");
+		return;
+	}
+
+	for (i = 0; i < kvm->nrcpus; i++) {
+		struct kvm_device_attr spe_attr;
+
+		spe_attr = (struct kvm_device_attr){
+			.group	= KVM_ARM_VCPU_SPE_CTRL,
+			.addr	= (u64)(unsigned long)&irq,
+			.attr	= KVM_ARM_VCPU_SPE_IRQ,
+		};
+
+		ret = set_spe_vcpu_attr(kvm, i, &spe_attr);
+		if (ret)
+			return;
+
+		spe_attr = (struct kvm_device_attr){
+			.group	= KVM_ARM_VCPU_SPE_CTRL,
+			.attr	= KVM_ARM_VCPU_SPE_INIT,
+		};
+
+		ret = set_spe_vcpu_attr(kvm, i, &spe_attr);
+		if (ret)
+			return;
+	}
+
+	_FDT(fdt_begin_node(fdt, "spe"));
+	_FDT(fdt_property(fdt, "compatible", compatible, sizeof(compatible)));
+	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
+	_FDT(fdt_end_node(fdt));
+}
+
+static int set_spe_vm_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret;
+
+	ret = ioctl(kvm->vm_fd, KVM_HAS_DEVICE_ATTR, attr);
+	if (ret) {
+		perror("SPE VM KVM_HAS_DEVICE_ATTR");
+		return ret;
+	}
+
+	ret = ioctl(kvm->vm_fd, KVM_SET_DEVICE_ATTR, attr);
+	if (ret)
+		perror("SPE VM KVM_SET_DEVICE_ATTR");
+
+	return ret;
+}
+
+static void spe_try_increase_mlock_limit(struct kvm *kvm)
+{
+	u64 size = kvm->arch.ram_alloc_size;
+	struct rlimit mlock_limit, new_limit;
+
+	if (getrlimit(RLIMIT_MEMLOCK, &mlock_limit)) {
+		perror("getrlimit(RLIMIT_MEMLOCK)");
+		return;
+	}
+
+	if (mlock_limit.rlim_cur > size)
+		return;
+
+	new_limit.rlim_cur = size;
+	new_limit.rlim_max = max((rlim_t)size, mlock_limit.rlim_max);
+	/* Requires CAP_SYS_RESOURCE capability. */
+	setrlimit(RLIMIT_MEMLOCK, &new_limit);
+}
+
+static int spe__finalize(struct kvm *kvm)
+{
+	struct kvm_device_attr spe_attr = (struct kvm_device_attr) {
+		.group	= KVM_ARM_VM_SPE_CTRL,
+		.attr	= KVM_ARM_VM_SPE_FINALIZE,
+	};
+	int ret;
+
+	if (!kvm->cfg.arch.has_spe)
+		return 0;
+
+	if (!kvm__supports_extension(kvm, KVM_CAP_ARM_SPE))
+		return 0;
+
+	spe_try_increase_mlock_limit(kvm);
+
+	ret = mlock(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
+	if (ret) {
+		perror("mlock");
+		return ret;
+	}
+
+	ret = set_spe_vm_attr(kvm, &spe_attr);
+	if (ret)
+		munlock(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
+
+	return ret;
+}
+last_init(spe__finalize);
+
+#else
+void spe__generate_fdt_nodes(void *fdt, struct kvm *kvm) { }
+#endif
-- 
2.29.1

