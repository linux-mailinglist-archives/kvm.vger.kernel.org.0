Return-Path: <kvm+bounces-11888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B26EE87C99C
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 09:07:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1D081C22276
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 08:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EA2E171D1;
	Fri, 15 Mar 2024 08:07:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA3BF14A90;
	Fri, 15 Mar 2024 08:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710490045; cv=none; b=o8SiysdGYs3zNn9cuJHgh2KsfiVuYCetbi6conUR2UphkxPrkDhAT/se0erIz+e+dQngb10NMIHoQQEKaENwIAoOZT76lvY1dzRseC0IY4tezwTlxtMj2iNBkS8aAjjnG+e7dFpy30u7fd3aNk2hfAa2+xDIHbpxC7NsSp9keJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710490045; c=relaxed/simple;
	bh=mO4jNHJ0bmAvAT09WVOc2PTx07jt5UdxAlMh15z6xfo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b9a7E4oQn8+Tmz3+F8QvU8iw6aEEuqT20MGqHuUieAaTLxutSgM0HATMjYJA7+iUK/0fyboWruDYIqSww8VVLChjxxT5uGCL55GYZtGKV097avbDMPnGzggiCBDK+NIMhLp3IyfJP6iIJ64bBLJajluvF1XhWCWNnfPkTygjgFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxifCyAfRlLmUZAA--.61824S3;
	Fri, 15 Mar 2024 16:07:14 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx_c6uAfRl4MZaAA--.41676S3;
	Fri, 15 Mar 2024 16:07:13 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	WANG Xuerui <kernel@xen0n.name>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v7 1/7] LoongArch/smp: Refine some ipi functions on LoongArch platform
Date: Fri, 15 Mar 2024 16:07:04 +0800
Message-Id: <20240315080710.2812974-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240315080710.2812974-1-maobibo@loongson.cn>
References: <20240315080710.2812974-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cx_c6uAfRl4MZaAA--.41676S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3KryfCFWrGry3Gw47Xw1kZwc_yoWktFW3pF
	W3Zw4DKr4rWFn5Z3sYya9xZr15AFn5WwsFqanrKayxAF12q3s5XF4ktF9FvF10k3yrua40
	vrZ5Gr4IgF1UAacCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1q6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	tVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
	AKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU14v3UUUUUU==

It is code refine about ipi handling on LoongArch platform, there are
three modifications.
1. Add generic function get_percpu_irq(), replacing some percpu irq
functions such as get_ipi_irq()/get_pmc_irq()/get_timer_irq() with
get_percpu_irq().

2. Change definition about parameter action called by function
loongson_send_ipi_single() and loongson_send_ipi_mask(), and it is
defined as decimal encoding format at ipi sender side. Normal decimal
encoding is used rather than binary bitmap encoding for ipi action, ipi
hw sender uses decimal encoding code, and ipi receiver will get binary
bitmap encoding, the ipi hw will convert it into bitmap in ipi message
buffer.

3. Add structure smp_ops on LoongArch platform so that pv ipi can be used
later.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/hardirq.h |  4 ++
 arch/loongarch/include/asm/irq.h     | 10 ++++-
 arch/loongarch/include/asm/smp.h     | 31 +++++++--------
 arch/loongarch/kernel/irq.c          | 22 +----------
 arch/loongarch/kernel/perf_event.c   | 14 +------
 arch/loongarch/kernel/smp.c          | 58 +++++++++++++++++++---------
 arch/loongarch/kernel/time.c         | 12 +-----
 7 files changed, 71 insertions(+), 80 deletions(-)

diff --git a/arch/loongarch/include/asm/hardirq.h b/arch/loongarch/include/asm/hardirq.h
index 0ef3b18f8980..9f0038e19c7f 100644
--- a/arch/loongarch/include/asm/hardirq.h
+++ b/arch/loongarch/include/asm/hardirq.h
@@ -12,6 +12,10 @@
 extern void ack_bad_irq(unsigned int irq);
 #define ack_bad_irq ack_bad_irq
 
+enum ipi_msg_type {
+	IPI_RESCHEDULE,
+	IPI_CALL_FUNCTION,
+};
 #define NR_IPI	2
 
 typedef struct {
diff --git a/arch/loongarch/include/asm/irq.h b/arch/loongarch/include/asm/irq.h
index 218b4da0ea90..00101b6d601e 100644
--- a/arch/loongarch/include/asm/irq.h
+++ b/arch/loongarch/include/asm/irq.h
@@ -117,8 +117,16 @@ extern struct fwnode_handle *liointc_handle;
 extern struct fwnode_handle *pch_lpc_handle;
 extern struct fwnode_handle *pch_pic_handle[MAX_IO_PICS];
 
-extern irqreturn_t loongson_ipi_interrupt(int irq, void *dev);
+static inline int get_percpu_irq(int vector)
+{
+	struct irq_domain *d;
+
+	d = irq_find_matching_fwnode(cpuintc_handle, DOMAIN_BUS_ANY);
+	if (d)
+		return irq_create_mapping(d, vector);
 
+	return -EINVAL;
+}
 #include <asm-generic/irq.h>
 
 #endif /* _ASM_IRQ_H */
diff --git a/arch/loongarch/include/asm/smp.h b/arch/loongarch/include/asm/smp.h
index f81e5f01d619..75d30529748c 100644
--- a/arch/loongarch/include/asm/smp.h
+++ b/arch/loongarch/include/asm/smp.h
@@ -12,6 +12,13 @@
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 
+struct smp_ops {
+	void (*init_ipi)(void);
+	void (*send_ipi_mask)(const struct cpumask *mask, unsigned int action);
+	void (*send_ipi_single)(int cpu, unsigned int action);
+};
+
+extern struct smp_ops smp_ops;
 extern int smp_num_siblings;
 extern int num_processors;
 extern int disabled_cpus;
@@ -24,8 +31,6 @@ void loongson_prepare_cpus(unsigned int max_cpus);
 void loongson_boot_secondary(int cpu, struct task_struct *idle);
 void loongson_init_secondary(void);
 void loongson_smp_finish(void);
-void loongson_send_ipi_single(int cpu, unsigned int action);
-void loongson_send_ipi_mask(const struct cpumask *mask, unsigned int action);
 #ifdef CONFIG_HOTPLUG_CPU
 int loongson_cpu_disable(void);
 void loongson_cpu_die(unsigned int cpu);
@@ -59,9 +64,12 @@ extern int __cpu_logical_map[NR_CPUS];
 
 #define cpu_physical_id(cpu)	cpu_logical_map(cpu)
 
-#define SMP_BOOT_CPU		0x1
-#define SMP_RESCHEDULE		0x2
-#define SMP_CALL_FUNCTION	0x4
+#define ACTION_BOOT_CPU	0
+#define ACTION_RESCHEDULE	1
+#define ACTION_CALL_FUNCTION	2
+#define SMP_BOOT_CPU		BIT(ACTION_BOOT_CPU)
+#define SMP_RESCHEDULE		BIT(ACTION_RESCHEDULE)
+#define SMP_CALL_FUNCTION	BIT(ACTION_CALL_FUNCTION)
 
 struct secondary_data {
 	unsigned long stack;
@@ -71,7 +79,8 @@ extern struct secondary_data cpuboot_data;
 
 extern asmlinkage void smpboot_entry(void);
 extern asmlinkage void start_secondary(void);
-
+extern void arch_send_call_function_single_ipi(int cpu);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
 extern void calculate_cpu_foreign_map(void);
 
 /*
@@ -79,16 +88,6 @@ extern void calculate_cpu_foreign_map(void);
  */
 extern void show_ipi_list(struct seq_file *p, int prec);
 
-static inline void arch_send_call_function_single_ipi(int cpu)
-{
-	loongson_send_ipi_single(cpu, SMP_CALL_FUNCTION);
-}
-
-static inline void arch_send_call_function_ipi_mask(const struct cpumask *mask)
-{
-	loongson_send_ipi_mask(mask, SMP_CALL_FUNCTION);
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 static inline int __cpu_disable(void)
 {
diff --git a/arch/loongarch/kernel/irq.c b/arch/loongarch/kernel/irq.c
index 883e5066ae44..ce36897d1e5a 100644
--- a/arch/loongarch/kernel/irq.c
+++ b/arch/loongarch/kernel/irq.c
@@ -87,23 +87,9 @@ static void __init init_vec_parent_group(void)
 	acpi_table_parse(ACPI_SIG_MCFG, early_pci_mcfg_parse);
 }
 
-static int __init get_ipi_irq(void)
-{
-	struct irq_domain *d = irq_find_matching_fwnode(cpuintc_handle, DOMAIN_BUS_ANY);
-
-	if (d)
-		return irq_create_mapping(d, INT_IPI);
-
-	return -EINVAL;
-}
-
 void __init init_IRQ(void)
 {
 	int i;
-#ifdef CONFIG_SMP
-	int r, ipi_irq;
-	static int ipi_dummy_dev;
-#endif
 	unsigned int order = get_order(IRQ_STACK_SIZE);
 	struct page *page;
 
@@ -113,13 +99,7 @@ void __init init_IRQ(void)
 	init_vec_parent_group();
 	irqchip_init();
 #ifdef CONFIG_SMP
-	ipi_irq = get_ipi_irq();
-	if (ipi_irq < 0)
-		panic("IPI IRQ mapping failed\n");
-	irq_set_percpu_devid(ipi_irq);
-	r = request_percpu_irq(ipi_irq, loongson_ipi_interrupt, "IPI", &ipi_dummy_dev);
-	if (r < 0)
-		panic("IPI IRQ request failed\n");
+	smp_ops.init_ipi();
 #endif
 
 	for (i = 0; i < NR_IRQS; i++)
diff --git a/arch/loongarch/kernel/perf_event.c b/arch/loongarch/kernel/perf_event.c
index 0491bf453cd4..3265c8f33223 100644
--- a/arch/loongarch/kernel/perf_event.c
+++ b/arch/loongarch/kernel/perf_event.c
@@ -456,16 +456,6 @@ static void loongarch_pmu_disable(struct pmu *pmu)
 static DEFINE_MUTEX(pmu_reserve_mutex);
 static atomic_t active_events = ATOMIC_INIT(0);
 
-static int get_pmc_irq(void)
-{
-	struct irq_domain *d = irq_find_matching_fwnode(cpuintc_handle, DOMAIN_BUS_ANY);
-
-	if (d)
-		return irq_create_mapping(d, INT_PCOV);
-
-	return -EINVAL;
-}
-
 static void reset_counters(void *arg);
 static int __hw_perf_event_init(struct perf_event *event);
 
@@ -473,7 +463,7 @@ static void hw_perf_event_destroy(struct perf_event *event)
 {
 	if (atomic_dec_and_mutex_lock(&active_events, &pmu_reserve_mutex)) {
 		on_each_cpu(reset_counters, NULL, 1);
-		free_irq(get_pmc_irq(), &loongarch_pmu);
+		free_irq(get_percpu_irq(INT_PCOV), &loongarch_pmu);
 		mutex_unlock(&pmu_reserve_mutex);
 	}
 }
@@ -562,7 +552,7 @@ static int loongarch_pmu_event_init(struct perf_event *event)
 	if (event->cpu >= 0 && !cpu_online(event->cpu))
 		return -ENODEV;
 
-	irq = get_pmc_irq();
+	irq = get_percpu_irq(INT_PCOV);
 	flags = IRQF_PERCPU | IRQF_NOBALANCING | IRQF_NO_THREAD | IRQF_NO_SUSPEND | IRQF_SHARED;
 	if (!atomic_inc_not_zero(&active_events)) {
 		mutex_lock(&pmu_reserve_mutex);
diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
index aabee0b280fe..1fce775be4f6 100644
--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -66,11 +66,6 @@ static cpumask_t cpu_core_setup_map;
 struct secondary_data cpuboot_data;
 static DEFINE_PER_CPU(int, cpu_state);
 
-enum ipi_msg_type {
-	IPI_RESCHEDULE,
-	IPI_CALL_FUNCTION,
-};
-
 static const char *ipi_types[NR_IPI] __tracepoint_string = {
 	[IPI_RESCHEDULE] = "Rescheduling interrupts",
 	[IPI_CALL_FUNCTION] = "Function call interrupts",
@@ -190,24 +185,19 @@ static u32 ipi_read_clear(int cpu)
 
 static void ipi_write_action(int cpu, u32 action)
 {
-	unsigned int irq = 0;
-
-	while ((irq = ffs(action))) {
-		uint32_t val = IOCSR_IPI_SEND_BLOCKING;
+	uint32_t val;
 
-		val |= (irq - 1);
-		val |= (cpu << IOCSR_IPI_SEND_CPU_SHIFT);
-		iocsr_write32(val, LOONGARCH_IOCSR_IPI_SEND);
-		action &= ~BIT(irq - 1);
-	}
+	val = IOCSR_IPI_SEND_BLOCKING | action;
+	val |= (cpu << IOCSR_IPI_SEND_CPU_SHIFT);
+	iocsr_write32(val, LOONGARCH_IOCSR_IPI_SEND);
 }
 
-void loongson_send_ipi_single(int cpu, unsigned int action)
+static void loongson_send_ipi_single(int cpu, unsigned int action)
 {
 	ipi_write_action(cpu_logical_map(cpu), (u32)action);
 }
 
-void loongson_send_ipi_mask(const struct cpumask *mask, unsigned int action)
+static void loongson_send_ipi_mask(const struct cpumask *mask, unsigned int action)
 {
 	unsigned int i;
 
@@ -215,6 +205,16 @@ void loongson_send_ipi_mask(const struct cpumask *mask, unsigned int action)
 		ipi_write_action(cpu_logical_map(i), (u32)action);
 }
 
+void arch_send_call_function_single_ipi(int cpu)
+{
+	smp_ops.send_ipi_single(cpu, ACTION_CALL_FUNCTION);
+}
+
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
+{
+	smp_ops.send_ipi_mask(mask, ACTION_CALL_FUNCTION);
+}
+
 /*
  * This function sends a 'reschedule' IPI to another CPU.
  * it goes straight through and wastes no time serializing
@@ -222,11 +222,11 @@ void loongson_send_ipi_mask(const struct cpumask *mask, unsigned int action)
  */
 void arch_smp_send_reschedule(int cpu)
 {
-	loongson_send_ipi_single(cpu, SMP_RESCHEDULE);
+	smp_ops.send_ipi_single(cpu, ACTION_RESCHEDULE);
 }
 EXPORT_SYMBOL_GPL(arch_smp_send_reschedule);
 
-irqreturn_t loongson_ipi_interrupt(int irq, void *dev)
+static irqreturn_t loongson_ipi_interrupt(int irq, void *dev)
 {
 	unsigned int action;
 	unsigned int cpu = smp_processor_id();
@@ -246,6 +246,26 @@ irqreturn_t loongson_ipi_interrupt(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
+static void loongson_init_ipi(void)
+{
+	int r, ipi_irq;
+
+	ipi_irq = get_percpu_irq(INT_IPI);
+	if (ipi_irq < 0)
+		panic("IPI IRQ mapping failed\n");
+
+	irq_set_percpu_devid(ipi_irq);
+	r = request_percpu_irq(ipi_irq, loongson_ipi_interrupt, "IPI", &irq_stat);
+	if (r < 0)
+		panic("IPI IRQ request failed\n");
+}
+
+struct smp_ops smp_ops = {
+	.init_ipi		= loongson_init_ipi,
+	.send_ipi_single	= loongson_send_ipi_single,
+	.send_ipi_mask		= loongson_send_ipi_mask,
+};
+
 static void __init fdt_smp_setup(void)
 {
 #ifdef CONFIG_OF
@@ -323,7 +343,7 @@ void loongson_boot_secondary(int cpu, struct task_struct *idle)
 
 	csr_mail_send(entry, cpu_logical_map(cpu), 0);
 
-	loongson_send_ipi_single(cpu, SMP_BOOT_CPU);
+	loongson_send_ipi_single(cpu, ACTION_BOOT_CPU);
 }
 
 /*
diff --git a/arch/loongarch/kernel/time.c b/arch/loongarch/kernel/time.c
index e7015f7b70e3..fd5354f9be7c 100644
--- a/arch/loongarch/kernel/time.c
+++ b/arch/loongarch/kernel/time.c
@@ -123,16 +123,6 @@ void sync_counter(void)
 	csr_write64(init_offset, LOONGARCH_CSR_CNTC);
 }
 
-static int get_timer_irq(void)
-{
-	struct irq_domain *d = irq_find_matching_fwnode(cpuintc_handle, DOMAIN_BUS_ANY);
-
-	if (d)
-		return irq_create_mapping(d, INT_TI);
-
-	return -EINVAL;
-}
-
 int constant_clockevent_init(void)
 {
 	unsigned int cpu = smp_processor_id();
@@ -142,7 +132,7 @@ int constant_clockevent_init(void)
 	static int irq = 0, timer_irq_installed = 0;
 
 	if (!timer_irq_installed) {
-		irq = get_timer_irq();
+		irq = get_percpu_irq(INT_TI);
 		if (irq < 0)
 			pr_err("Failed to map irq %d (timer)\n", irq);
 	}
-- 
2.39.3


