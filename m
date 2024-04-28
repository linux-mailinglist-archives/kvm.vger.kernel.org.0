Return-Path: <kvm+bounces-16130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54A548B4B30
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 12:07:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A17028239E
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 10:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57899612F6;
	Sun, 28 Apr 2024 10:05:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2CD05EE76;
	Sun, 28 Apr 2024 10:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714298732; cv=none; b=WFOwNAoxYAuGKT2uXJaxQn3/dIx6Nt/SPMRwzrFI2Yp4IzlWwuA4wnRxMpRypWt/YFTjlsk23VUtvdFvI7yCciFykJNB35Y/bdb/mgwEpNVVwluO6SmxbataOo+/mAdevmpHAU7rYXNeslgVedRUYTo76UPA4BUQbZsTojyv0iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714298732; c=relaxed/simple;
	bh=L0P+jua0MdI3IQwh38hSaS606h8wjuq0EvWNRAtk/6s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ejEmOaqdCdwi1ilwLvx4NXqcozgC6WToJwVxzBtNgzWfer6Xrz2YZ+gzRlVySPKgeCuJhl2UCVui6PxMiQSTmkTc+/WAyI6CKr6bGv54rMT3SyxTBcBD1a26hzp8nTGGAd6ykZFWfcRvzKnnmSRGRE2VIly0Ppz1dzxUDaV/1RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxmPBnHy5mx10EAA--.16140S3;
	Sun, 28 Apr 2024 18:05:27 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxsFVeHy5maTIIAA--.5646S8;
	Sun, 28 Apr 2024 18:05:25 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v8 6/6] LoongArch: Add pv ipi support on guest kernel side
Date: Sun, 28 Apr 2024 18:05:18 +0800
Message-Id: <20240428100518.1642324-7-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240428100518.1642324-1-maobibo@loongson.cn>
References: <20240428100518.1642324-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxsFVeHy5maTIIAA--.5646S8
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

PARAVIRT option and pv ipi is added on guest kernel side, function
pv_ipi_init() is to add ipi sending and ipi receiving hooks. This function
firstly checks whether system runs on VM mode. If kernel runs on VM mode,
it will call function kvm_para_available() to detect current hypervirsor
type. Now only KVM type detection is supported, the paravirt function can
work only if current hypervisor type is KVM, since there is only KVM
supported on LoongArch now.

PV IPI uses virtual IPI sender and virtual IPI receiver function. With
virutal IPI sender, ipi message is stored in DDR memory rather than
emulated HW. IPI multicast is supported, and 128 vcpus can received IPIs
at the same time like X86 KVM method. Hypercall method is used for IPI
sending.

With virtual IPI receiver, HW SW0 is used rather than real IPI HW. Since
VCPU has separate HW SW0 like HW timer, there is no trap in IPI interrupt
acknowledge. And IPI message is stored in DDR, no trap in get IPI message.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/Kconfig                        |   9 ++
 arch/loongarch/include/asm/hardirq.h          |   1 +
 arch/loongarch/include/asm/paravirt.h         |  27 ++++
 .../include/asm/paravirt_api_clock.h          |   1 +
 arch/loongarch/kernel/Makefile                |   1 +
 arch/loongarch/kernel/irq.c                   |   2 +-
 arch/loongarch/kernel/paravirt.c              | 151 ++++++++++++++++++
 arch/loongarch/kernel/smp.c                   |   4 +-
 8 files changed, 194 insertions(+), 2 deletions(-)
 create mode 100644 arch/loongarch/include/asm/paravirt.h
 create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
 create mode 100644 arch/loongarch/kernel/paravirt.c

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 54ad04dacdee..0a1540a8853e 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -583,6 +583,15 @@ config CPU_HAS_PREFETCH
 	bool
 	default y
 
+config PARAVIRT
+	bool "Enable paravirtualization code"
+	depends on AS_HAS_LVZ_EXTENSION
+	help
+          This changes the kernel so it can modify itself when it is run
+	  under a hypervisor, potentially improving performance significantly
+	  over full virtualization.  However, when run without a hypervisor
+	  the kernel is theoretically slower and slightly larger.
+
 config ARCH_SUPPORTS_KEXEC
 	def_bool y
 
diff --git a/arch/loongarch/include/asm/hardirq.h b/arch/loongarch/include/asm/hardirq.h
index 9f0038e19c7f..b26d596a73aa 100644
--- a/arch/loongarch/include/asm/hardirq.h
+++ b/arch/loongarch/include/asm/hardirq.h
@@ -21,6 +21,7 @@ enum ipi_msg_type {
 typedef struct {
 	unsigned int ipi_irqs[NR_IPI];
 	unsigned int __softirq_pending;
+	atomic_t message ____cacheline_aligned_in_smp;
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
diff --git a/arch/loongarch/include/asm/paravirt.h b/arch/loongarch/include/asm/paravirt.h
new file mode 100644
index 000000000000..58f7b7b89f2c
--- /dev/null
+++ b/arch/loongarch/include/asm/paravirt.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_LOONGARCH_PARAVIRT_H
+#define _ASM_LOONGARCH_PARAVIRT_H
+
+#ifdef CONFIG_PARAVIRT
+#include <linux/static_call_types.h>
+struct static_key;
+extern struct static_key paravirt_steal_enabled;
+extern struct static_key paravirt_steal_rq_enabled;
+
+u64 dummy_steal_clock(int cpu);
+DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
+
+static inline u64 paravirt_steal_clock(int cpu)
+{
+	return static_call(pv_steal_clock)(cpu);
+}
+
+int pv_ipi_init(void);
+#else
+static inline int pv_ipi_init(void)
+{
+	return 0;
+}
+
+#endif // CONFIG_PARAVIRT
+#endif
diff --git a/arch/loongarch/include/asm/paravirt_api_clock.h b/arch/loongarch/include/asm/paravirt_api_clock.h
new file mode 100644
index 000000000000..65ac7cee0dad
--- /dev/null
+++ b/arch/loongarch/include/asm/paravirt_api_clock.h
@@ -0,0 +1 @@
+#include <asm/paravirt.h>
diff --git a/arch/loongarch/kernel/Makefile b/arch/loongarch/kernel/Makefile
index 3a7620b66bc6..c9bfeda89e40 100644
--- a/arch/loongarch/kernel/Makefile
+++ b/arch/loongarch/kernel/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_MODULES)		+= module.o module-sections.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 
 obj-$(CONFIG_PROC_FS)		+= proc.o
+obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 
 obj-$(CONFIG_SMP)		+= smp.o
 
diff --git a/arch/loongarch/kernel/irq.c b/arch/loongarch/kernel/irq.c
index ce36897d1e5a..4863e6c1b739 100644
--- a/arch/loongarch/kernel/irq.c
+++ b/arch/loongarch/kernel/irq.c
@@ -113,5 +113,5 @@ void __init init_IRQ(void)
 			per_cpu(irq_stack, i), per_cpu(irq_stack, i) + IRQ_STACK_SIZE);
 	}
 
-	set_csr_ecfg(ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 | ECFGF_IPI | ECFGF_PMC);
+	set_csr_ecfg(ECFGF_SIP0 | ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 | ECFGF_IPI | ECFGF_PMC);
 }
diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
new file mode 100644
index 000000000000..9044ed62045c
--- /dev/null
+++ b/arch/loongarch/kernel/paravirt.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/jump_label.h>
+#include <linux/kvm_para.h>
+#include <asm/paravirt.h>
+#include <linux/static_call.h>
+
+struct static_key paravirt_steal_enabled;
+struct static_key paravirt_steal_rq_enabled;
+
+static u64 native_steal_clock(int cpu)
+{
+	return 0;
+}
+
+DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
+
+#ifdef CONFIG_SMP
+static void pv_send_ipi_single(int cpu, unsigned int action)
+{
+	unsigned int min, old;
+	irq_cpustat_t *info = &per_cpu(irq_stat, cpu);
+
+	old = atomic_fetch_or(BIT(action), &info->message);
+	if (old)
+		return;
+
+	min = cpu_logical_map(cpu);
+	kvm_hypercall3(KVM_HCALL_FUNC_PV_IPI, 1, 0, min);
+}
+
+#define KVM_IPI_CLUSTER_SIZE		(2 * BITS_PER_LONG)
+static void pv_send_ipi_mask(const struct cpumask *mask, unsigned int action)
+{
+	unsigned int cpu, i, min = 0, max = 0, old;
+	__uint128_t bitmap = 0;
+	irq_cpustat_t *info;
+
+	if (cpumask_empty(mask))
+		return;
+
+	action = BIT(action);
+	for_each_cpu(i, mask) {
+		info = &per_cpu(irq_stat, i);
+		old = atomic_fetch_or(action, &info->message);
+		if (old)
+			continue;
+
+		cpu = cpu_logical_map(i);
+		if (!bitmap) {
+			min = max = cpu;
+		} else if (cpu > min && cpu < min + KVM_IPI_CLUSTER_SIZE) {
+			max = cpu > max ? cpu : max;
+		} else if (cpu < min && (max - cpu) < KVM_IPI_CLUSTER_SIZE) {
+			bitmap <<= min - cpu;
+			min = cpu;
+		} else {
+			/*
+			 * Physical cpuid is sorted in ascending order ascend
+			 * for the next mask calculation, send IPI here
+			 * directly and skip the remainding cpus
+			 */
+			kvm_hypercall3(KVM_HCALL_FUNC_PV_IPI,
+				(unsigned long)bitmap,
+				(unsigned long)(bitmap >> BITS_PER_LONG), min);
+			min = max = cpu;
+			bitmap = 0;
+		}
+		__set_bit(cpu - min, (unsigned long *)&bitmap);
+	}
+
+	if (bitmap)
+		kvm_hypercall3(KVM_HCALL_FUNC_PV_IPI, (unsigned long)bitmap,
+				(unsigned long)(bitmap >> BITS_PER_LONG), min);
+}
+
+static irqreturn_t loongson_do_swi(int irq, void *dev)
+{
+	irq_cpustat_t *info;
+	long action;
+
+	/* Clear swi interrupt */
+	clear_csr_estat(1 << INT_SWI0);
+	info = this_cpu_ptr(&irq_stat);
+	action = atomic_xchg(&info->message, 0);
+	if (action & SMP_CALL_FUNCTION) {
+		generic_smp_call_function_interrupt();
+		info->ipi_irqs[IPI_CALL_FUNCTION]++;
+	}
+
+	if (action & SMP_RESCHEDULE) {
+		scheduler_ipi();
+		info->ipi_irqs[IPI_RESCHEDULE]++;
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void pv_init_ipi(void)
+{
+	int r, swi0;
+
+	swi0 = get_percpu_irq(INT_SWI0);
+	if (swi0 < 0)
+		panic("SWI0 IRQ mapping failed\n");
+	irq_set_percpu_devid(swi0);
+	r = request_percpu_irq(swi0, loongson_do_swi, "SWI0", &irq_stat);
+	if (r < 0)
+		panic("SWI0 IRQ request failed\n");
+}
+#endif
+
+static bool kvm_para_available(void)
+{
+	static int hypervisor_type;
+	int config;
+
+	if (!hypervisor_type) {
+		config = read_cpucfg(CPUCFG_KVM_SIG);
+		if (!memcmp(&config, KVM_SIGNATURE, 4))
+			hypervisor_type = HYPERVISOR_KVM;
+	}
+
+	return hypervisor_type == HYPERVISOR_KVM;
+}
+
+int __init pv_ipi_init(void)
+{
+	int feature;
+
+	if (!cpu_has_hypervisor)
+		return 0;
+	if (!kvm_para_available())
+		return 0;
+
+	/*
+	 * check whether KVM hypervisor supports pv_ipi or not
+	 */
+	feature = read_cpucfg(CPUCFG_KVM_FEATURE);
+#ifdef CONFIG_SMP
+	if (feature & KVM_FEATURE_PV_IPI) {
+		smp_ops.init_ipi		= pv_init_ipi;
+		smp_ops.send_ipi_single		= pv_send_ipi_single;
+		smp_ops.send_ipi_mask		= pv_send_ipi_mask;
+	}
+#endif
+
+	return 1;
+}
diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
index 1fce775be4f6..9eff7aa4c552 100644
--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -29,6 +29,7 @@
 #include <asm/loongson.h>
 #include <asm/mmu_context.h>
 #include <asm/numa.h>
+#include <asm/paravirt.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
 #include <asm/time.h>
@@ -309,6 +310,7 @@ void __init loongson_smp_setup(void)
 	cpu_data[0].core = cpu_logical_map(0) % loongson_sysconf.cores_per_package;
 	cpu_data[0].package = cpu_logical_map(0) / loongson_sysconf.cores_per_package;
 
+	pv_ipi_init();
 	iocsr_write32(0xffffffff, LOONGARCH_IOCSR_IPI_EN);
 	pr_info("Detected %i available CPU(s)\n", loongson_sysconf.nr_cpus);
 }
@@ -352,7 +354,7 @@ void loongson_boot_secondary(int cpu, struct task_struct *idle)
 void loongson_init_secondary(void)
 {
 	unsigned int cpu = smp_processor_id();
-	unsigned int imask = ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 |
+	unsigned int imask = ECFGF_SIP0 | ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 |
 			     ECFGF_IPI | ECFGF_PMC | ECFGF_TIMER;
 
 	change_csr_ecfg(ECFG0_IM, imask);
-- 
2.39.3


