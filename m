Return-Path: <kvm+bounces-23823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31D1C94E559
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 05:03:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 573F91C21498
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 03:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8775B14EC53;
	Mon, 12 Aug 2024 03:02:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97CD814D2B1;
	Mon, 12 Aug 2024 03:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723431741; cv=none; b=jRYqSUwOj6voZdX8BHxHPHaWbLXgcO9VJzePDuiVuTRpr8vqgvpOvEJ6yrjlOgJzWuyuJPwPm4mIqXyARizagoeHkeN7KXUU9yeqvTBI/v0XMNZwr3BRp9ALudM9F3Nhj7bgM8Xb/R92rG6TTRZ7nV5iBfNRRezfdjKOkvdZtgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723431741; c=relaxed/simple;
	bh=6o7TFQkRWHNhbuj0kRTn7JrfHmsKf72CAu641zkjwCI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RLq7i24+TsfVRmuQufxcSUEu/mCGBQmloLQv/Tf/GQIpUA/X1WJQkHQ7+gJFrFzb0iPzJbD/YTqQqa696aPpRs72zx6tdI6wuPdmCH871KMkOpWN8VrI9pkqLBFc9qI+L65McypPRJBBrpShxyAw8z6k+1/p5SCkarkDNOtT0/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Bxnps4e7lmpVAQAA--.16100S3;
	Mon, 12 Aug 2024 11:02:16 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDxvmcze7lmTagPAA--.59431S5;
	Mon, 12 Aug 2024 11:02:14 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	x86@kernel.org,
	Song Gao <gaosong@loongson.cn>
Subject: [PATCH v6 3/3] irqchip/loongson-eiointc: Add extioi virt extension support
Date: Mon, 12 Aug 2024 11:02:10 +0800
Message-Id: <20240812030210.500240-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240812030210.500240-1-maobibo@loongson.cn>
References: <20240812030210.500240-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxvmcze7lmTagPAA--.59431S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Interrupts can be routed to maximal four virtual CPUs with one HW
EIOINTC interrupt controller model, since interrupt routing is encoded with
CPU bitmap and EIOINTC node combined method. Here add the EIOINTC virt
extension support so that interrupts can be routed to 256 vCPUs on
hypervisor mode. CPU bitmap is replaced with normal encoding and EIOINTC
node type is removed, so there are 8 bits for cpu selection, at most 256
vCPUs are supported for interrupt routing.

Co-developed-by: Song Gao <gaosong@loongson.cn>
Signed-off-by: Song Gao <gaosong@loongson.cn>
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 .../arch/loongarch/irq-chip-model.rst         |  64 ++++++++++
 .../zh_CN/arch/loongarch/irq-chip-model.rst   |  55 +++++++++
 arch/loongarch/include/asm/irq.h              |   1 +
 drivers/irqchip/irq-loongson-eiointc.c        | 109 ++++++++++++++----
 4 files changed, 209 insertions(+), 20 deletions(-)

diff --git a/Documentation/arch/loongarch/irq-chip-model.rst b/Documentation/arch/loongarch/irq-chip-model.rst
index 7988f4192363..d2350780ad1d 100644
--- a/Documentation/arch/loongarch/irq-chip-model.rst
+++ b/Documentation/arch/loongarch/irq-chip-model.rst
@@ -85,6 +85,70 @@ to CPUINTC directly::
     | Devices |
     +---------+
 
+Virtual extended IRQ model
+==========================
+
+In this model, IPI (Inter-Processor Interrupt) and CPU Local Timer interrupt
+go to CPUINTC directly, CPU UARTS interrupts go to PCH-PIC, while all other
+devices interrupts go to PCH-PIC/PCH-MSI and gathered by V-EIOINTC (Virtual
+Extended I/O Interrupt Controller), and then go to CPUINTC directly::
+
+       +-----+    +-------------------+     +-------+
+       | IPI |--> | CPUINTC(0-255vcpu)| <-- | Timer |
+       +-----+    +-------------------+     +-------+
+                            ^
+                            |
+                      +-----------+
+                      | V-EIOINTC |
+                      +-----------+
+                       ^         ^
+                       |         |
+                +---------+ +---------+
+                | PCH-PIC | | PCH-MSI |
+                +---------+ +---------+
+                  ^      ^          ^
+                  |      |          |
+           +--------+ +---------+ +---------+
+           | UARTs  | | Devices | | Devices |
+           +--------+ +---------+ +---------+
+
+
+Description
+-----------
+V-EIOINTC (Virtual Extended I/O Interrupt Controller) is an extension of
+EIOINTC, it only works in VM mode which runs in KVM hypervisor. Interrupts can
+be routed to up to four vCPUs via standard EIOINTC, however with V-EIOINTC
+interrupts can be routed to up to 256 virtual cpus.
+
+With standard EIOINTC, interrupt routing setting includes two parts: eight
+bits for CPU selection and four bits for CPU IP (Interrupt Pin) selection.
+For CPU selection there is four bits for EIOINTC node selection, four bits
+for EIOINTC CPU selection. Bitmap method is used for CPU selection and
+CPU IP selection, so interrupt can only route to CPU0 - CPU3 and IP0-IP3 in
+one EIOINTC node.
+
+With V-EIOINTC it supports to route more CPUs and CPU IP (Interrupt Pin),
+there are two newly added registers with V-EIOINTC.
+
+EXTIOI_VIRT_FEATURES
+--------------------
+This register is read-only register, which indicates supported features with
+V-EIOINTC. Feature EXTIOI_HAS_INT_ENCODE and EXTIOI_HAS_CPU_ENCODE is added.
+
+Feature EXTIOI_HAS_INT_ENCODE is part of standard EIOINTC. If it is 1, it
+indicates that CPU Interrupt Pin selection can be normal method rather than
+bitmap method, so interrupt can be routed to IP0 - IP15.
+
+Feature EXTIOI_HAS_CPU_ENCODE is entension of V-EIOINTC. If it is 1, it
+indicates that CPU selection can be normal method rather than bitmap method,
+so interrupt can be routed to CPU0 - CPU255.
+
+EXTIOI_VIRT_CONFIG
+------------------
+This register is read-write register, for compatibility intterupt routed uses
+the default method which is the same with standard EIOINTC. If the bit is set
+with 1, it indicated HW to use normal method rather than bitmap method.
+
 ACPI-related definitions
 ========================
 
diff --git a/Documentation/translations/zh_CN/arch/loongarch/irq-chip-model.rst b/Documentation/translations/zh_CN/arch/loongarch/irq-chip-model.rst
index f1e9ab18206c..d696bd394c02 100644
--- a/Documentation/translations/zh_CN/arch/loongarch/irq-chip-model.rst
+++ b/Documentation/translations/zh_CN/arch/loongarch/irq-chip-model.rst
@@ -87,6 +87,61 @@ PCH-LPC/PCH-MSI，然后被EIOINTC统一收集，再直接到达CPUINTC::
     | Devices |
     +---------+
 
+虚拟扩展IRQ模型
+===============
+
+在这种模型里面, IPI(Inter-Processor Interrupt) 和CPU本地时钟中断直接发送到CPUINTC,
+CPU串口 (UARTs) 中断发送到PCH-PIC, 而其他所有设备的中断则分别发送到所连接的PCH_PIC/
+PCH-MSI, 然后V-EIOINTC统一收集，再直接到达CPUINTC::
+
+        +-----+    +-------------------+     +-------+
+        | IPI |--> | CPUINTC(0-255vcpu)| <-- | Timer |
+        +-----+    +-------------------+     +-------+
+                             ^
+                             |
+                       +-----------+
+                       | V-EIOINTC |
+                       +-----------+
+                        ^         ^
+                        |         |
+                 +---------+ +---------+
+                 | PCH-PIC | | PCH-MSI |
+                 +---------+ +---------+
+                   ^      ^          ^
+                   |      |          |
+            +--------+ +---------+ +---------+
+            | UARTs  | | Devices | | Devices |
+            +--------+ +---------+ +---------+
+
+V-EIOINTC 是EIOINTC的扩展, 仅工作在hyperisor模式下, 中断经EIOINTC最多可个路由到４个
+虚拟cpu. 但中断经V-EIOINTC最多可个路由到256个虚拟cpu.
+
+传统的EIOINTC中断控制器，中断路由分为两个部分：8比特用于控制路由到哪个CPU，
+4比特用于控制路由到特定CPU的哪个中断管脚.控制CPU路由的8比特前4比特用于控制
+路由到哪个EIOINTC节点，后4比特用于控制此节点哪个CPU。中断路由在选择CPU路由
+和CPU中断管脚路由时，使用bitmap编码方式而不是正常编码方式，所以对于一个
+EIOINTC中断控制器节点，中断只能路由到CPU0 - CPU3，中断管教IP0-IP3。
+
+V-EIOINTC新增了两个寄存器，支持中断路由到更多CPU个和中断管脚。
+
+V-EIOINTC功能寄存器
+-------------------
+功能寄存器是只读寄存器，用于显示V-EIOINTC支持的特性，目前两个支持两个特性
+EXTIOI_HAS_INT_ENCODE 和 EXTIOI_HAS_CPU_ENCODE。
+
+特性EXTIOI_HAS_INT_ENCODE是传统EIOINTC中断控制器的一个特性，如果此比特为1，
+显示CPU中断管脚路由方式支持正常编码，而不是bitmap编码，所以中断可以路由到
+管脚IP0 - IP15。
+
+特性EXTIOI_HAS_CPU_ENCODE是V-EIOINTC新增特性，如果此比特为1，表示CPU路由
+方式支持正常编码，而不是bitmap编码，所以中断可以路由到CPU0 - CPU255。
+
+V-EIOINTC配置寄存器
+-------------------
+配置寄存器是可读写寄存器，为了兼容性考虑，如果不写此寄存器，中断路由采用
+和传统EIOINTC相同的路由设置。如果对应比特设置为1，表示采用正常路由方式而
+不是bitmap编码的路由方式。
+
 ACPI相关的定义
 ==============
 
diff --git a/arch/loongarch/include/asm/irq.h b/arch/loongarch/include/asm/irq.h
index 480418bc5071..ce85d4c7d225 100644
--- a/arch/loongarch/include/asm/irq.h
+++ b/arch/loongarch/include/asm/irq.h
@@ -54,6 +54,7 @@ extern struct acpi_vector_group pch_group[MAX_IO_PICS];
 extern struct acpi_vector_group msi_group[MAX_IO_PICS];
 
 #define CORES_PER_EIO_NODE	4
+#define CORES_PER_VEIO_NODE	256
 
 #define LOONGSON_CPU_UART0_VEC		10 /* CPU UART0 */
 #define LOONGSON_CPU_THSENS_VEC		14 /* CPU Thsens */
diff --git a/drivers/irqchip/irq-loongson-eiointc.c b/drivers/irqchip/irq-loongson-eiointc.c
index b1f2080be2be..cc5b1ec13531 100644
--- a/drivers/irqchip/irq-loongson-eiointc.c
+++ b/drivers/irqchip/irq-loongson-eiointc.c
@@ -14,6 +14,7 @@
 #include <linux/irqdomain.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/kernel.h>
+#include <linux/kvm_para.h>
 #include <linux/syscore_ops.h>
 #include <asm/numa.h>
 
@@ -24,15 +25,36 @@
 #define EIOINTC_REG_ISR		0x1800
 #define EIOINTC_REG_ROUTE	0x1c00
 
+#define EXTIOI_VIRT_FEATURES           0x40000000
+#define  EXTIOI_HAS_VIRT_EXTENSION     BIT(0)
+#define  EXTIOI_HAS_ENABLE_OPTION      BIT(1)
+#define  EXTIOI_HAS_INT_ENCODE         BIT(2)
+#define  EXTIOI_HAS_CPU_ENCODE         BIT(3)
+#define EXTIOI_VIRT_CONFIG             0x40000004
+#define  EXTIOI_ENABLE                 BIT(1)
+#define  EXTIOI_ENABLE_INT_ENCODE      BIT(2)
+#define  EXTIOI_ENABLE_CPU_ENCODE      BIT(3)
+
 #define VEC_REG_COUNT		4
 #define VEC_COUNT_PER_REG	64
 #define VEC_COUNT		(VEC_REG_COUNT * VEC_COUNT_PER_REG)
 #define VEC_REG_IDX(irq_id)	((irq_id) / VEC_COUNT_PER_REG)
 #define VEC_REG_BIT(irq_id)     ((irq_id) % VEC_COUNT_PER_REG)
 #define EIOINTC_ALL_ENABLE	0xffffffff
+#define EIOINTC_ALL_ENABLE_VEC_MASK(vector)	(EIOINTC_ALL_ENABLE & ~BIT(vector & 0x1F))
+#define EIOINTC_REG_ENABLE_VEC(vector)		(EIOINTC_REG_ENABLE + ((vector >> 5) << 2))
 
 #define MAX_EIO_NODES		(NR_CPUS / CORES_PER_EIO_NODE)
 
+/*
+ * Routing registers are 32bit, and there is 8-bit route setting for every
+ * interrupt vector. So one Route register contains four vectors routing
+ * information.
+ */
+#define EIOINTC_REG_ROUTE_VEC(vector)		(EIOINTC_REG_ROUTE + (vector & ~0x03))
+#define EIOINTC_REG_ROUTE_VEC_SHIFT(vector)	((vector & 0x03) << 3)
+#define EIOINTC_REG_ROUTE_VEC_MASK(vector)	(0xff << EIOINTC_REG_ROUTE_VEC_SHIFT(vector))
+
 static int nr_pics;
 
 struct eiointc_priv {
@@ -42,6 +64,7 @@ struct eiointc_priv {
 	cpumask_t		cpuspan_map;
 	struct fwnode_handle	*domain_handle;
 	struct irq_domain	*eiointc_domain;
+	bool			cpu_encoded;
 };
 
 static struct eiointc_priv *eiointc_priv[MAX_IO_PICS];
@@ -57,7 +80,13 @@ static void eiointc_enable(void)
 
 static int cpu_to_eio_node(int cpu)
 {
-	return cpu_logical_map(cpu) / CORES_PER_EIO_NODE;
+	int cores;
+
+	if (kvm_para_has_feature(KVM_FEATURE_VIRT_EXTIOI))
+		cores = CORES_PER_VEIO_NODE;
+	else
+		cores = CORES_PER_EIO_NODE;
+	return cpu_logical_map(cpu) / cores;
 }
 
 #ifdef CONFIG_SMP
@@ -89,6 +118,16 @@ static void eiointc_set_irq_route(int pos, unsigned int cpu, unsigned int mnode,
 
 static DEFINE_RAW_SPINLOCK(affinity_lock);
 
+static void virt_extioi_set_irq_route(unsigned int vector, unsigned int cpu)
+{
+	unsigned long reg = EIOINTC_REG_ROUTE_VEC(vector);
+	u32 data = iocsr_read32(reg);
+
+	data &= ~EIOINTC_REG_ROUTE_VEC_MASK(vector);
+	data |= cpu_logical_map(cpu) << EIOINTC_REG_ROUTE_VEC_SHIFT(vector);
+	iocsr_write32(data, reg);
+}
+
 static int eiointc_set_irq_affinity(struct irq_data *d, const struct cpumask *affinity, bool force)
 {
 	unsigned int cpu;
@@ -105,18 +144,24 @@ static int eiointc_set_irq_affinity(struct irq_data *d, const struct cpumask *af
 	}
 
 	vector = d->hwirq;
-	regaddr = EIOINTC_REG_ENABLE + ((vector >> 5) << 2);
-
-	/* Mask target vector */
-	csr_any_send(regaddr, EIOINTC_ALL_ENABLE & (~BIT(vector & 0x1F)),
-			0x0, priv->node * CORES_PER_EIO_NODE);
-
-	/* Set route for target vector */
-	eiointc_set_irq_route(vector, cpu, priv->node, &priv->node_map);
-
-	/* Unmask target vector */
-	csr_any_send(regaddr, EIOINTC_ALL_ENABLE,
-			0x0, priv->node * CORES_PER_EIO_NODE);
+	regaddr = EIOINTC_REG_ENABLE_VEC(vector);
+
+	if (priv->cpu_encoded) {
+		iocsr_write32(EIOINTC_ALL_ENABLE_VEC_MASK(vector), regaddr);
+		virt_extioi_set_irq_route(vector, cpu);
+		iocsr_write32(EIOINTC_ALL_ENABLE, regaddr);
+	} else {
+		/* Mask target vector */
+		csr_any_send(regaddr, EIOINTC_ALL_ENABLE_VEC_MASK(vector),
+			     0x0, priv->node * CORES_PER_EIO_NODE);
+
+		/* Set route for target vector */
+		eiointc_set_irq_route(vector, cpu, priv->node, &priv->node_map);
+
+		/* Unmask target vector */
+		csr_any_send(regaddr, EIOINTC_ALL_ENABLE,
+			     0x0, priv->node * CORES_PER_EIO_NODE);
+	}
 
 	irq_data_update_effective_affinity(d, cpumask_of(cpu));
 
@@ -140,17 +185,23 @@ static int eiointc_index(int node)
 
 static int eiointc_router_init(unsigned int cpu)
 {
-	int i, bit;
-	uint32_t data;
-	uint32_t node = cpu_to_eio_node(cpu);
-	int index = eiointc_index(node);
+	int i, bit, cores, index, node;
+	unsigned int data;
+
+	node = cpu_to_eio_node(cpu);
+	index = eiointc_index(node);
 
 	if (index < 0) {
 		pr_err("Error: invalid nodemap!\n");
-		return -1;
+		return -EINVAL;
 	}
 
-	if ((cpu_logical_map(cpu) % CORES_PER_EIO_NODE) == 0) {
+	if (eiointc_priv[index]->cpu_encoded)
+		cores = CORES_PER_VEIO_NODE;
+	else
+		cores = CORES_PER_EIO_NODE;
+
+	if ((cpu_logical_map(cpu) % cores) == 0) {
 		eiointc_enable();
 
 		for (i = 0; i < eiointc_priv[0]->vec_count / 32; i++) {
@@ -166,7 +217,9 @@ static int eiointc_router_init(unsigned int cpu)
 
 		for (i = 0; i < eiointc_priv[0]->vec_count / 4; i++) {
 			/* Route to Node-0 Core-0 */
-			if (index == 0)
+			if (eiointc_priv[index]->cpu_encoded)
+				bit = cpu_logical_map(0);
+			else if (index == 0)
 				bit = BIT(cpu_logical_map(0));
 			else
 				bit = (eiointc_priv[index]->node << 4) | 1;
@@ -367,6 +420,19 @@ static int __init acpi_cascade_irqdomain_init(void)
 	return 0;
 }
 
+static void __init kvm_eiointc_init(struct eiointc_priv *priv)
+{
+	int val;
+
+	val = iocsr_read32(EXTIOI_VIRT_FEATURES);
+	if (val & EXTIOI_HAS_CPU_ENCODE) {
+		val = iocsr_read32(EXTIOI_VIRT_CONFIG);
+		val |= EXTIOI_ENABLE_CPU_ENCODE;
+		iocsr_write32(val, EXTIOI_VIRT_CONFIG);
+		priv->cpu_encoded = true;
+	}
+}
+
 static int __init eiointc_init(struct eiointc_priv *priv, int parent_irq,
 			       u64 node_map)
 {
@@ -390,6 +456,9 @@ static int __init eiointc_init(struct eiointc_priv *priv, int parent_irq,
 		return -ENOMEM;
 	}
 
+	if (kvm_para_has_feature(KVM_FEATURE_VIRT_EXTIOI))
+		kvm_eiointc_init(priv);
+
 	eiointc_priv[nr_pics++] = priv;
 	eiointc_router_init(0);
 	irq_set_chained_handler_and_data(parent_irq, eiointc_irq_dispatch, priv);
-- 
2.39.3


