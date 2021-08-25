Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0813F7A4E
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbhHYQUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:20:25 -0400
Received: from foss.arm.com ([217.140.110.172]:55058 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235727AbhHYQTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 12:19:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C49E1063;
        Wed, 25 Aug 2021 09:18:53 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2CC973F66F;
        Wed, 25 Aug 2021 09:18:52 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Andrew Murray <andrew.murray@arm.com>
Subject: [RFC PATCH v4 kvmtool 4/5] arm64: Add SPE support
Date:   Wed, 25 Aug 2021 17:19:57 +0100
Message-Id: <20210825161958.266411-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161958.266411-1-alexandru.elisei@arm.com>
References: <20210825161958.266411-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

Add a runtime configurable for kvmtool to enable SPE (Statistical
Profiling Extensions) for each vcpu and to create a corresponding DT node.
SPE is enabled at runtime with the --spe option.

SPE is last to be initialized because it requires the VGIC to be
initialized, which is done late in the initialization process.

[ Andrew M: Add SPE to init features ]
[ Alexandru E: Reworked patch ]

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile                                  |   1 +
 arm/aarch64/arm-cpu.c                     |   2 +
 arm/aarch64/include/kvm/kvm-config-arch.h |   2 +
 arm/aarch64/include/kvm/spe.h             |   7 ++
 arm/aarch64/kvm-cpu.c                     |   5 +
 arm/aarch64/kvm.c                         |  13 ++
 arm/aarch64/spe.c                         | 139 ++++++++++++++++++++++
 arm/include/arm-common/kvm-config-arch.h  |   1 +
 arm/kvm-cpu.c                             |   4 +
 9 files changed, 174 insertions(+)
 create mode 100644 arm/aarch64/include/kvm/spe.h
 create mode 100644 arm/aarch64/spe.c

diff --git a/Makefile b/Makefile
index 313fdc3c0201..3c53a5784f45 100644
--- a/Makefile
+++ b/Makefile
@@ -181,6 +181,7 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/aarch64/arm-cpu.o
 	OBJS		+= arm/aarch64/kvm-cpu.o
 	OBJS		+= arm/aarch64/kvm.o
+	OBJS		+= arm/aarch64/spe.o
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
index d7572b7790b1..d3a03161e961 100644
--- a/arm/aarch64/arm-cpu.c
+++ b/arm/aarch64/arm-cpu.c
@@ -1,6 +1,7 @@
 #include "kvm/fdt.h"
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
+#include "kvm/spe.h"
 #include "kvm/util.h"
 
 #include "arm-common/gic.h"
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
diff --git a/arm/aarch64/include/kvm/spe.h b/arm/aarch64/include/kvm/spe.h
new file mode 100644
index 000000000000..c9814270321f
--- /dev/null
+++ b/arm/aarch64/include/kvm/spe.h
@@ -0,0 +1,7 @@
+#ifndef KVM__KVM_SPE_H
+#define KVM__KVM_SPE_H
+
+#define KVM_ARM_SPE_IRQ	21
+
+void spe__generate_fdt_nodes(void *fdt, struct kvm *kvm);
+#endif /* KVM__KVM_SPE_H */
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
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 1ab4e541c8b6..88f55535732a 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -1,4 +1,5 @@
 #include "kvm/kvm.h"
+#include "kvm/spe.h"
 
 #include <asm/image.h>
 #include <sys/mman.h>
@@ -49,5 +50,17 @@ fail:
 
 void kvm__arch_delete_ram(struct kvm *kvm)
 {
+	struct kvm_enable_cap unlock_mem = {
+		.cap = KVM_CAP_ARM_LOCK_USER_MEMORY_REGION,
+		.flags = KVM_ARM_LOCK_USER_MEMORY_REGION_FLAGS_UNLOCK,
+		.args[1] = KVM_ARM_UNLOCK_MEM_ALL,
+	};
+	int ret;
+
+	if (kvm->cfg.arch.has_spe) {
+		ret = ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &unlock_mem);
+		if (ret == -1)
+			perror("KVM_CAP_ARM_LOCK_USER_MEMORY_REGION");
+	}
 	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
 }
diff --git a/arm/aarch64/spe.c b/arm/aarch64/spe.c
new file mode 100644
index 000000000000..673c84e63cc2
--- /dev/null
+++ b/arm/aarch64/spe.c
@@ -0,0 +1,139 @@
+#include <stdio.h>
+
+#include <sys/resource.h>
+
+#include <linux/kvm.h>
+#include <linux/list.h>
+
+#include "kvm/fdt.h"
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/spe.h"
+#include "kvm/util.h"
+
+#include "arm-common/gic.h"
+
+void spe__generate_fdt_nodes(void *fdt, struct kvm *kvm)
+{
+	const char compatible[] = "arm,statistical-profiling-extension-v1";
+	int irq = KVM_ARM_SPE_IRQ;
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
+	_FDT(fdt_begin_node(fdt, "spe"));
+	_FDT(fdt_property(fdt, "compatible", compatible, sizeof(compatible)));
+	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
+	_FDT(fdt_end_node(fdt));
+}
+
+static void spe_try_increase_mlock_limit(struct kvm *kvm)
+{
+	u64 size = kvm->ram_size;
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
+static int spe_set_vcpu_attr(struct kvm_cpu *vcpu,
+			     struct kvm_device_attr *attr)
+{
+	int ret, fd;
+
+	fd = vcpu->vcpu_fd;
+
+	ret = ioctl(fd, KVM_HAS_DEVICE_ATTR, attr);
+	if (ret == -1) {
+		perror("SPE VCPU KVM_HAS_DEVICE_ATTR");
+		return ret;
+	}
+
+	ret = ioctl(fd, KVM_SET_DEVICE_ATTR, attr);
+	if (ret == -1)
+		perror("SPE VCPU KVM_SET_DEVICE_ATTR");
+
+	return ret;
+}
+
+static int spe__init(struct kvm *kvm)
+{
+	struct kvm_mem_bank *bank;
+	struct kvm_enable_cap lock_mem = {
+		.cap = KVM_CAP_ARM_LOCK_USER_MEMORY_REGION,
+		.flags = KVM_ARM_LOCK_USER_MEMORY_REGION_FLAGS_LOCK,
+		.args[1] = KVM_ARM_LOCK_MEM_READ | KVM_ARM_LOCK_MEM_WRITE,
+	};
+	int i, irq_num, ret;
+	u64 slot;
+
+	if (!kvm->cfg.arch.has_spe)
+		return 0;
+
+	if (!kvm__supports_extension(kvm, KVM_CAP_ARM_LOCK_USER_MEMORY_REGION))
+		die("KVM_CAP_ARM_LOCK_USER_MEMORY_REGION not supported");
+
+	slot = (u64)-1;
+	list_for_each_entry(bank, &kvm->mem_banks, list) {
+		if (bank->host_addr == kvm->ram_start) {
+			BUG_ON(bank->type != KVM_MEM_TYPE_RAM);
+			slot = bank->slot;
+			break;
+		}
+	}
+
+	if (slot == (u64)-1)
+		die("RAM bank not found");
+
+	spe_try_increase_mlock_limit(kvm);
+
+	lock_mem.args[0] = slot;
+	ret = ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &lock_mem);
+	if (ret == -1)
+		die_perror("KVM_CAP_ARM_LOCK_USER_MEMORY_REGION");
+
+	irq_num = KVM_ARM_SPE_IRQ;
+	for (i = 0; i < kvm->nrcpus; i++) {
+		struct kvm_device_attr spe_attr;
+
+		spe_attr = (struct kvm_device_attr){
+			.group	= KVM_ARM_VCPU_SPE_CTRL,
+			.addr	= (u64)(unsigned long)&irq_num,
+			.attr	= KVM_ARM_VCPU_SPE_IRQ,
+		};
+
+		ret = spe_set_vcpu_attr(kvm->cpus[i], &spe_attr);
+		if (ret == -1)
+			return -EINVAL;
+
+		spe_attr = (struct kvm_device_attr){
+			.group	= KVM_ARM_VCPU_SPE_CTRL,
+			.attr	= KVM_ARM_VCPU_SPE_INIT,
+		};
+
+		ret = spe_set_vcpu_attr(kvm->cpus[i], &spe_attr);
+		if (ret == -1)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+last_init(spe__init);
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
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 6a2408c632df..2c0189fec622 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -54,6 +54,10 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	    !kvm__supports_extension(kvm, KVM_CAP_ARM_PMU_V3))
 		die("PMUv3 is not supported");
 
+	if (kvm->cfg.arch.has_spe &&
+	    !kvm__supports_extension(kvm, KVM_CAP_ARM_SPE))
+		die("SPE is not supported");
+
 	vcpu = calloc(1, sizeof(struct kvm_cpu));
 	if (!vcpu)
 		return NULL;
-- 
2.33.0

