Return-Path: <kvm+bounces-5507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B04D38228DE
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 08:18:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A18B2851C3
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 07:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FFCD18E25;
	Wed,  3 Jan 2024 07:16:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D11F21805C;
	Wed,  3 Jan 2024 07:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxjuvBCZVlz3IBAA--.5795S3;
	Wed, 03 Jan 2024 15:16:17 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Dxqb2_CZVlm1EYAA--.43800S7;
	Wed, 03 Jan 2024 15:16:17 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH 5/5] LoongArch: Add pv ipi support on LoongArch system
Date: Wed,  3 Jan 2024 15:16:15 +0800
Message-Id: <20240103071615.3422264-6-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240103071615.3422264-1-maobibo@loongson.cn>
References: <20240103071615.3422264-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Dxqb2_CZVlm1EYAA--.43800S7
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoWfGw45Kr1xXr4UZw4xXFyruFX_yoW8JF13uo
	W3GF4vqw4rW3yruFs0vw1Fqry5XFWakr4DAas3Z3Z8WFn7Jw12gry8Kw43tF17Grs5GF9r
	C343Xr1ktayftFnxl-sFpf9Il3svdjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUYs7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVW8JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI
	0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280
	aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28Icx
	kI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E
	5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAV
	WUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY
	1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI
	0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7I
	UbCzuJUUUUU==

On LoongArch system, ipi hw uses iocsr registers, there is one iocsr
register access on ipi sender and two iocsr access on ipi interrupt
handler. On VM mode all iocsr registers accessing will trap into
hypervisor.

This patch adds pv ipi support for VM, hypercall instruction is used
to ipi sender, and hypervisor will inject SWI on the VM. During SWI
interrupt handler, only estat CSR register is read and written. Estat
CSR register access will not trap into hypervisor. So with pv ipi
supported, pv ipi sender will trap into hypervsor, pv ipi interrupt
handler will not trap.

Also this patch adds ipi multicast support, the method is similar with
x86. With ipi multicast support, ipi notification can be sent to at most
64 vcpus at a time. And hw cpuid is equal to logic cpuid in LoongArch
kvm hypervisor now, will add hw cpuid search logic in kvm hypervisor
in the next patch.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/hardirq.h   |   1 +
 arch/loongarch/include/asm/kvm_para.h  | 124 +++++++++++++++++++++++++
 arch/loongarch/include/asm/loongarch.h |   1 +
 arch/loongarch/kernel/irq.c            |   2 +-
 arch/loongarch/kernel/paravirt.c       | 103 ++++++++++++++++++++
 arch/loongarch/kernel/smp.c            |   2 +-
 arch/loongarch/kvm/exit.c              |  66 ++++++++++++-
 7 files changed, 295 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/include/asm/hardirq.h b/arch/loongarch/include/asm/hardirq.h
index 9f0038e19c7f..998011f162d0 100644
--- a/arch/loongarch/include/asm/hardirq.h
+++ b/arch/loongarch/include/asm/hardirq.h
@@ -21,6 +21,7 @@ enum ipi_msg_type {
 typedef struct {
 	unsigned int ipi_irqs[NR_IPI];
 	unsigned int __softirq_pending;
+	atomic_t messages;
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index 41200e922a82..a25a84e372b9 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -9,6 +9,10 @@
 #define HYPERVISOR_VENDOR_SHIFT		8
 #define HYPERCALL_CODE(vendor, code)	((vendor << HYPERVISOR_VENDOR_SHIFT) + code)
 
+#define KVM_HC_CODE_SERVICE		0
+#define KVM_HC_SERVICE			HYPERCALL_CODE(HYPERVISOR_KVM, KVM_HC_CODE_SERVICE)
+#define  KVM_HC_FUNC_IPI		1
+
 /*
  * LoongArch hypcall return code
  */
@@ -16,6 +20,126 @@
 #define KVM_HC_INVALID_CODE		-1UL
 #define KVM_HC_INVALID_PARAMETER	-2UL
 
+/*
+ * Hypercalls interface for KVM hypervisor
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
+		"hvcl "__stringify(KVM_HC_SERVICE)
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
+		"hvcl "__stringify(KVM_HC_SERVICE)
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
+			"hvcl "__stringify(KVM_HC_SERVICE)
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
+		"hvcl "__stringify(KVM_HC_SERVICE)
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
+		"hvcl "__stringify(KVM_HC_SERVICE)
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
+		"hvcl "__stringify(KVM_HC_SERVICE)
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
index a03b466555a1..a787b69f6fb0 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -167,6 +167,7 @@
 #define CPUCFG_KVM_SIG			CPUCFG_KVM_BASE
 #define  KVM_SIGNATURE			"KVM\0"
 #define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
+#define  KVM_FEATURE_PV_IPI		BIT(1)
 #ifndef __ASSEMBLY__
 
 /* CSR */
diff --git a/arch/loongarch/kernel/irq.c b/arch/loongarch/kernel/irq.c
index 1b58f7c3eed9..b5bd298c981f 100644
--- a/arch/loongarch/kernel/irq.c
+++ b/arch/loongarch/kernel/irq.c
@@ -113,5 +113,5 @@ void __init init_IRQ(void)
 			per_cpu(irq_stack, i), per_cpu(irq_stack, i) + IRQ_STACK_SIZE);
 	}
 
-	set_csr_ecfg(ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 | ECFGF_IPI | ECFGF_PMC);
+	set_csr_ecfg(ECFGF_SIP0 | ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 | ECFGF_IPI | ECFGF_PMC);
 }
diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
index 21d01d05791a..a70eba278607 100644
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
@@ -16,6 +17,94 @@ static u64 native_steal_clock(int cpu)
 
 DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
 
+#ifdef CONFIG_SMP
+static void pv_send_ipi_single(int cpu, unsigned int action)
+{
+	unsigned int min, old_action;
+	unsigned long ipi_bitmap = 0;
+	irq_cpustat_t *info = &per_cpu(irq_stat, cpu);
+
+	action = 1UL << action;
+	old_action = atomic_fetch_or(action, &info->messages);
+	if (old_action == 0) {
+		min = cpu_logical_map(cpu);
+		ipi_bitmap = 1;
+		kvm_hypercall2(KVM_HC_FUNC_IPI, ipi_bitmap, min);
+	}
+}
+
+static void pv_send_ipi_mask(const struct cpumask *mask, unsigned int action)
+{
+	unsigned int cpu, i, min = 0, max = 0, old_action;
+	u64 ipi_bitmap = 0;
+	irq_cpustat_t *info;
+
+	if (cpumask_empty(mask))
+		return;
+
+	action = 1UL << action;
+	for_each_cpu(i, mask) {
+		cpu = cpu_logical_map(i);
+		if (!ipi_bitmap) {
+			min = max = cpu;
+		} else if (cpu < min && (max - cpu) < BITS_PER_LONG) {
+			ipi_bitmap <<= min - cpu;
+			min = cpu;
+		} else if (cpu > min && cpu < min + BITS_PER_LONG) {
+			max = cpu < max ? max : cpu;
+		} else {
+			kvm_hypercall2(KVM_HC_FUNC_IPI, ipi_bitmap, min);
+			min = max = cpu;
+			ipi_bitmap = 0;
+		}
+		info = &per_cpu(irq_stat, i);
+		old_action = atomic_fetch_or(action, &info->messages);
+		if (old_action == 0)
+			__set_bit(cpu - min, (unsigned long *)&ipi_bitmap);
+	}
+
+	if (ipi_bitmap)
+		kvm_hypercall2(KVM_HC_FUNC_IPI, ipi_bitmap, min);
+}
+
+static irqreturn_t loongson_do_swi(int irq, void *dev)
+{
+	irq_cpustat_t *info;
+	long action;
+
+	clear_csr_estat(1 << INT_SWI0);
+
+	info = this_cpu_ptr(&irq_stat);
+	do {
+		action = atomic_xchg(&info->messages, 0);
+		if (action & SMP_CALL_FUNCTION) {
+			generic_smp_call_function_interrupt();
+			info->ipi_irqs[IPI_CALL_FUNCTION]++;
+		}
+
+		if (action & SMP_RESCHEDULE) {
+			scheduler_ipi();
+			info->ipi_irqs[IPI_RESCHEDULE]++;
+		}
+	} while (action);
+
+	return IRQ_HANDLED;
+}
+
+static void pv_ipi_init(void)
+{
+	int r, swi0;
+
+	swi0 = get_percpu_irq(INT_SWI0);
+	if (swi0 < 0)
+		panic("SIP0 IRQ mapping failed\n");
+	irq_set_percpu_devid(swi0);
+	r = request_percpu_irq(swi0, loongson_do_swi, "SWI0", &irq_stat);
+	if (r < 0)
+		panic("SIP0 IRQ request failed\n");
+}
+#endif
+
 static bool kvm_para_available(void)
 {
 	static int hypervisor_type;
@@ -32,10 +121,24 @@ static bool kvm_para_available(void)
 
 int __init pv_guest_init(void)
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
+#ifdef CONFIG_SMP
+	feature = read_cpucfg(CPUCFG_KVM_FEATURE);
+	if (feature & KVM_FEATURE_PV_IPI) {
+		smp_ops.call_func_single_ipi	= pv_send_ipi_single;
+		smp_ops.call_func_ipi		= pv_send_ipi_mask;
+		smp_ops.ipi_init		= pv_ipi_init;
+	}
+#endif
+
 	return 1;
 }
diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
index 8cce7839b22f..ebcf2ac8a9c2 100644
--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -283,7 +283,7 @@ void loongson_boot_secondary(int cpu, struct task_struct *idle)
 void loongson_init_secondary(void)
 {
 	unsigned int cpu = smp_processor_id();
-	unsigned int imask = ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 |
+	unsigned int imask = ECFGF_SIP0 | ECFGF_IP0 | ECFGF_IP1 | ECFGF_IP2 |
 			     ECFGF_IPI | ECFGF_PMC | ECFGF_TIMER;
 
 	change_csr_ecfg(ECFG0_IM, imask);
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index e233d7b3b76d..bd8a631d8626 100644
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
@@ -664,12 +667,71 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+static int kvm_pv_send_ipi(struct kvm_vcpu *vcpu, int sgi)
+{
+	int ret = 0;
+	u64 ipi_bitmap;
+	unsigned int min, cpu;
+	struct kvm_vcpu *dest;
+
+	ipi_bitmap = vcpu->arch.gprs[LOONGARCH_GPR_A1];
+	min = vcpu->arch.gprs[LOONGARCH_GPR_A2];
+
+	if (ipi_bitmap) {
+		cpu = find_first_bit((void *)&ipi_bitmap, BITS_PER_LONG);
+		while (cpu < BITS_PER_LONG) {
+			if ((cpu + min) < KVM_MAX_VCPUS) {
+				dest = kvm_get_vcpu_by_id(vcpu->kvm, cpu + min);
+				kvm_queue_irq(dest, sgi);
+				kvm_vcpu_kick(dest);
+			}
+			cpu = find_next_bit((void *)&ipi_bitmap, BITS_PER_LONG, cpu + 1);
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * hypcall emulation always return to guest, Caller should check retval.
+ */
+static void kvm_handle_pv_hcall(struct kvm_vcpu *vcpu)
+{
+	unsigned long func = vcpu->arch.gprs[LOONGARCH_GPR_A0];
+	long ret;
+
+	switch (func) {
+	case KVM_HC_FUNC_IPI:
+		kvm_pv_send_ipi(vcpu, INT_SWI0);
+		ret = KVM_HC_STATUS_SUCCESS;
+		break;
+	default:
+		ret = KVM_HC_INVALID_CODE;
+		break;
+	};
+
+	vcpu->arch.gprs[LOONGARCH_GPR_A0] = ret;
+}
+
 static int kvm_handle_hypcall(struct kvm_vcpu *vcpu)
 {
+	larch_inst inst;
+	unsigned int code;
+
+	inst.word = vcpu->arch.badi;
+	code = inst.reg0i15_format.immediate;
 	update_pc(&vcpu->arch);
 
-	/* Treat it as noop intruction, only set return value */
-	vcpu->arch.gprs[LOONGARCH_GPR_A0] = KVM_HC_INVALID_CODE;
+	switch (code) {
+	case KVM_HC_SERVICE:
+		kvm_handle_pv_hcall(vcpu);
+		break;
+	default:
+		/* Treat it as noop intruction, only set return value */
+		vcpu->arch.gprs[LOONGARCH_GPR_A0] = KVM_HC_INVALID_CODE;
+		break;
+	}
+
 	return RESUME_GUEST;
 }
 
-- 
2.39.3


