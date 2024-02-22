Return-Path: <kvm+bounces-9354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ABD7185EFE2
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 04:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2211BB23F3B
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 03:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 135652374D;
	Thu, 22 Feb 2024 03:28:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 199E5101EC;
	Thu, 22 Feb 2024 03:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708572494; cv=none; b=I/Xf3P6jhf4Aa/I0oIReRcFR4LuM3ft/jFThNiZhmbaVwZS+A2now/AKqaiv5GDUcLd4OO/FOQYzqEHj2UZH2YnyHQll31Ju2KAfS9HlGnlv4cHEW+1SXwWu8i/dXh7O4/EvP5xuC+7pZwcA7wBtiHQb34Nauhdmq68jRmKwOcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708572494; c=relaxed/simple;
	bh=cbyYozXJTMV3oiLiaAeTFbOcOwX2I6kJFWhW4w5e0Mg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sH42otd9JRMCX9dSyuMj1ydVA9nKF7Pjswp4yIMyx1acLX3Uo8ifNwmPMuOyJ411gt+CiFCELErOz/Omx/QS8o/N0khdmNPNkGweNdAxR87MakMu1czvYMYtuL8XYZW0TsG1RZJ030dCZhrl11KC1EGiJVsuifO9N0gIdXzhapg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxK+lKv9ZlcgoQAA--.23007S3;
	Thu, 22 Feb 2024 11:28:10 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxrhNDv9Zl+nM+AA--.41033S8;
	Thu, 22 Feb 2024 11:28:09 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v5 6/6] LoongArch: Add pv ipi support on LoongArch system
Date: Thu, 22 Feb 2024 11:28:03 +0800
Message-Id: <20240222032803.2177856-7-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240222032803.2177856-1-maobibo@loongson.cn>
References: <20240222032803.2177856-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxrhNDv9Zl+nM+AA--.41033S8
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoW3KryDtr17Kry5tr47trW3XFc_yoW8Xr4kZo
	W3GF4qqw4rW3y5uFs0vw1YqFWUXr4Ykr4DA3s7Z3Z3WF1xJ347Wry8Kw43tF17Jrs5Gr9r
	u343Xr1ktayxtrnxl-sFpf9Il3svdjkaLaAFLSUrUUUU8b8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUYZ7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUAVWUZwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6x
	kI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v2
	6rWY6Fy7McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2
	Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUVCJPDUUUU

On LoongArch system, ipi hw uses iocsr registers, there is one iocsr
register access on ipi sending, and two iocsr access on ipi receiving
which is ipi interrupt handler. On VM mode all iocsr accessing will
cause VM to trap into hypervisor. So with one ipi hw notification
there will be three times of trap.

PV ipi is added for VM, hypercall instruction is used for ipi sender,
and hypervisor will inject SWI to destination vcpu. During SWI interrupt
handler, only estat CSR register is written to clear irq. Estat CSR
register access will not trap into hypervisor. So with pv ipi supported,
there is one trap with pv ipi sender, and no trap with ipi receiver,
there is only one trap with ipi notification.

Also this patch adds ipi multicast support, the method is similar with
x86. With ipi multicast support, ipi notification can be sent to at most
128 vcpus at one time. It reduces trap times into hypervisor greatly.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/hardirq.h   |   1 +
 arch/loongarch/include/asm/kvm_host.h  |   1 +
 arch/loongarch/include/asm/kvm_para.h  | 123 +++++++++++++++++++++++++
 arch/loongarch/include/asm/loongarch.h |   1 +
 arch/loongarch/kernel/irq.c            |   2 +-
 arch/loongarch/kernel/paravirt.c       | 112 ++++++++++++++++++++++
 arch/loongarch/kernel/setup.c          |   1 +
 arch/loongarch/kernel/smp.c            |   2 +-
 arch/loongarch/kvm/exit.c              |  73 ++++++++++++++-
 arch/loongarch/kvm/vcpu.c              |   1 +
 10 files changed, 313 insertions(+), 4 deletions(-)

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
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 3ba16ef1fe69..0b96c6303cf7 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -43,6 +43,7 @@ struct kvm_vcpu_stat {
 	u64 idle_exits;
 	u64 cpucfg_exits;
 	u64 signal_exits;
+	u64 hypercall_exits;
 };
 
 #define KVM_MEM_HUGEPAGE_CAPABLE	(1UL << 0)
diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index af5d677a9052..a82bffbbf8a1 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -8,6 +8,9 @@
 #define HYPERVISOR_KVM			1
 #define HYPERVISOR_VENDOR_SHIFT		8
 #define HYPERCALL_CODE(vendor, code)	((vendor << HYPERVISOR_VENDOR_SHIFT) + code)
+#define KVM_HCALL_CODE_PV_SERVICE	0
+#define KVM_HCALL_PV_SERVICE		HYPERCALL_CODE(HYPERVISOR_KVM, KVM_HCALL_CODE_PV_SERVICE)
+#define  KVM_HCALL_FUNC_PV_IPI		1
 
 /*
  * LoongArch hypercall return code
@@ -16,6 +19,126 @@
 #define KVM_HCALL_INVALID_CODE		-1UL
 #define KVM_HCALL_INVALID_PARAMETER	-2UL
 
+/*
+ * Hypercall interface for KVM hypervisor
+ *
+ * a0: function identifier
+ * a1-a6: args
+ * Return value will be placed in v0.
+ * Up to 6 arguments are passed in a1, a2, a3, a4, a5, a6.
+ */
+static __always_inline long kvm_hypercall(u64 fid)
+{
+	register long ret asm("v0");
+	register unsigned long fun asm("a0") = fid;
+
+	__asm__ __volatile__(
+		"hvcl "__stringify(KVM_HCALL_PV_SERVICE)
+		: "=r" (ret)
+		: "r" (fun)
+		: "memory"
+		);
+
+	return ret;
+}
+
+static __always_inline long kvm_hypercall1(u64 fid, unsigned long arg0)
+{
+	register long ret asm("v0");
+	register unsigned long fun asm("a0") = fid;
+	register unsigned long a1  asm("a1") = arg0;
+
+	__asm__ __volatile__(
+		"hvcl "__stringify(KVM_HCALL_PV_SERVICE)
+		: "=r" (ret)
+		: "r" (fun), "r" (a1)
+		: "memory"
+		);
+
+	return ret;
+}
+
+static __always_inline long kvm_hypercall2(u64 fid,
+		unsigned long arg0, unsigned long arg1)
+{
+	register long ret asm("v0");
+	register unsigned long fun asm("a0") = fid;
+	register unsigned long a1  asm("a1") = arg0;
+	register unsigned long a2  asm("a2") = arg1;
+
+	__asm__ __volatile__(
+			"hvcl "__stringify(KVM_HCALL_PV_SERVICE)
+			: "=r" (ret)
+			: "r" (fun), "r" (a1), "r" (a2)
+			: "memory"
+			);
+
+	return ret;
+}
+
+static __always_inline long kvm_hypercall3(u64 fid,
+	unsigned long arg0, unsigned long arg1, unsigned long arg2)
+{
+	register long ret asm("v0");
+	register unsigned long fun asm("a0") = fid;
+	register unsigned long a1  asm("a1") = arg0;
+	register unsigned long a2  asm("a2") = arg1;
+	register unsigned long a3  asm("a3") = arg2;
+
+	__asm__ __volatile__(
+		"hvcl "__stringify(KVM_HCALL_PV_SERVICE)
+		: "=r" (ret)
+		: "r" (fun), "r" (a1), "r" (a2), "r" (a3)
+		: "memory"
+		);
+
+	return ret;
+}
+
+static __always_inline long kvm_hypercall4(u64 fid,
+		unsigned long arg0, unsigned long arg1, unsigned long arg2,
+		unsigned long arg3)
+{
+	register long ret asm("v0");
+	register unsigned long fun asm("a0") = fid;
+	register unsigned long a1  asm("a1") = arg0;
+	register unsigned long a2  asm("a2") = arg1;
+	register unsigned long a3  asm("a3") = arg2;
+	register unsigned long a4  asm("a4") = arg3;
+
+	__asm__ __volatile__(
+		"hvcl "__stringify(KVM_HCALL_PV_SERVICE)
+		: "=r" (ret)
+		: "r"(fun), "r" (a1), "r" (a2), "r" (a3), "r" (a4)
+		: "memory"
+		);
+
+	return ret;
+}
+
+static __always_inline long kvm_hypercall5(u64 fid,
+		unsigned long arg0, unsigned long arg1, unsigned long arg2,
+		unsigned long arg3, unsigned long arg4)
+{
+	register long ret asm("v0");
+	register unsigned long fun asm("a0") = fid;
+	register unsigned long a1  asm("a1") = arg0;
+	register unsigned long a2  asm("a2") = arg1;
+	register unsigned long a3  asm("a3") = arg2;
+	register unsigned long a4  asm("a4") = arg3;
+	register unsigned long a5  asm("a5") = arg4;
+
+	__asm__ __volatile__(
+		"hvcl "__stringify(KVM_HCALL_PV_SERVICE)
+		: "=r" (ret)
+		: "r"(fun), "r" (a1), "r" (a2), "r" (a3), "r" (a4), "r" (a5)
+		: "memory"
+		);
+
+	return ret;
+}
+
+
 static inline unsigned int kvm_arch_para_features(void)
 {
 	return 0;
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index a1d22e8b6f94..0ad36704cb4b 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -167,6 +167,7 @@
 #define CPUCFG_KVM_SIG			CPUCFG_KVM_BASE
 #define  KVM_SIGNATURE			"KVM\0"
 #define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
+#define  KVM_FEATURE_PV_IPI		BIT(1)
 
 #ifndef __ASSEMBLY__
 
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
index 5cf794e8490f..4c30e1c73c72 100644
--- a/arch/loongarch/kernel/paravirt.c
+++ b/arch/loongarch/kernel/paravirt.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/export.h>
 #include <linux/types.h>
+#include <linux/interrupt.h>
 #include <linux/jump_label.h>
 #include <linux/kvm_para.h>
 #include <asm/paravirt.h>
@@ -16,6 +17,103 @@ static u64 native_steal_clock(int cpu)
 
 DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
 
+#ifdef CONFIG_SMP
+static void pv_send_ipi_single(int cpu, unsigned int action)
+{
+	unsigned int min, old;
+	unsigned long bitmap = 0;
+	irq_cpustat_t *info = &per_cpu(irq_stat, cpu);
+
+	action = BIT(action);
+	old = atomic_fetch_or(action, &info->message);
+	if (old == 0) {
+		min = cpu_logical_map(cpu);
+		bitmap = 1;
+		kvm_hypercall3(KVM_HCALL_FUNC_PV_IPI, bitmap, 0, min);
+	}
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
 static bool kvm_para_available(void)
 {
 	static int hypervisor_type;
@@ -32,10 +130,24 @@ static bool kvm_para_available(void)
 
 int __init pv_ipi_init(void)
 {
+	int feature;
+
 	if (!cpu_has_hypervisor)
 		return 0;
 	if (!kvm_para_available())
 		return 0;
 
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
 	return 1;
 }
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index b79a1244b56f..c95ed3224b7d 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -368,6 +368,7 @@ void __init platform_init(void)
 	pr_info("The BIOS Version: %s\n", b_info.bios_version);
 
 	efi_runtime_init();
+	pv_ipi_init();
 }
 
 static void __init check_kernel_sections_mem(void)
diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
index 2182e7cc2ed6..9e9fda1fe18a 100644
--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -285,7 +285,7 @@ void loongson_boot_secondary(int cpu, struct task_struct *idle)
 void loongson_init_secondary(void)
 {
 	unsigned int cpu = smp_processor_id();
-	unsigned int imask = ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 |
+	unsigned int imask = ECFGF_SIP0 | ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 |
 			     ECFGF_IPI | ECFGF_PMC | ECFGF_TIMER;
 
 	change_csr_ecfg(ECFG0_IM, imask);
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 6a38fd59d86d..46940e97975b 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -227,6 +227,9 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
 	case CPUCFG_KVM_SIG:
 		vcpu->arch.gprs[rd] = *(unsigned int *)KVM_SIGNATURE;
 		break;
+	case CPUCFG_KVM_FEATURE:
+		vcpu->arch.gprs[rd] = KVM_FEATURE_PV_IPI;
+		break;
 	default:
 		vcpu->arch.gprs[rd] = 0;
 		break;
@@ -699,12 +702,78 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+static int kvm_pv_send_ipi(struct kvm_vcpu *vcpu)
+{
+	unsigned long ipi_bitmap;
+	unsigned int min, cpu, i;
+	struct kvm_vcpu *dest;
+
+	min = vcpu->arch.gprs[LOONGARCH_GPR_A3];
+	for (i = 0; i < 2; i++) {
+		ipi_bitmap = vcpu->arch.gprs[LOONGARCH_GPR_A1 + i];
+		if (!ipi_bitmap)
+			continue;
+
+		cpu = find_first_bit((void *)&ipi_bitmap, BITS_PER_LONG);
+		while (cpu < BITS_PER_LONG) {
+			dest = kvm_get_vcpu_by_cpuid(vcpu->kvm, cpu + min);
+			cpu = find_next_bit((void *)&ipi_bitmap, BITS_PER_LONG,
+					cpu + 1);
+			if (!dest)
+				continue;
+
+			/*
+			 * Send SWI0 to dest vcpu to emulate IPI interrupt
+			 */
+			kvm_queue_irq(dest, INT_SWI0);
+			kvm_vcpu_kick(dest);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * hypercall emulation always return to guest, Caller should check retval.
+ */
+static void kvm_handle_pv_service(struct kvm_vcpu *vcpu)
+{
+	unsigned long func = vcpu->arch.gprs[LOONGARCH_GPR_A0];
+	long ret;
+
+	switch (func) {
+	case KVM_HCALL_FUNC_PV_IPI:
+		kvm_pv_send_ipi(vcpu);
+		ret = KVM_HCALL_STATUS_SUCCESS;
+		break;
+	default:
+		ret = KVM_HCALL_INVALID_CODE;
+		break;
+	};
+
+	vcpu->arch.gprs[LOONGARCH_GPR_A0] = ret;
+}
+
 static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
 {
+	larch_inst inst;
+	unsigned int code;
+
+	inst.word = vcpu->arch.badi;
+	code = inst.reg0i15_format.immediate;
 	update_pc(&vcpu->arch);
 
-	/* Treat it as noop intruction, only set return value */
-	vcpu->arch.gprs[LOONGARCH_GPR_A0] = KVM_HCALL_INVALID_CODE;
+	switch (code) {
+	case KVM_HCALL_PV_SERVICE:
+		vcpu->stat.hypercall_exits++;
+		kvm_handle_pv_service(vcpu);
+		break;
+	default:
+		/* Treat it as noop intruction, only set return value */
+		vcpu->arch.gprs[LOONGARCH_GPR_A0] = KVM_HCALL_INVALID_CODE;
+		break;
+	}
+
 	return RESUME_GUEST;
 }
 
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 40296d8ef297..24fd5e4647f3 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -19,6 +19,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, idle_exits),
 	STATS_DESC_COUNTER(VCPU, cpucfg_exits),
 	STATS_DESC_COUNTER(VCPU, signal_exits),
+	STATS_DESC_COUNTER(VCPU, hypercall_exits)
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
-- 
2.39.3


