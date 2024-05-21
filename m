Return-Path: <kvm+bounces-17823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 270788CA659
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 04:46:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 970ABB2299D
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 02:46:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 403371C6A7;
	Tue, 21 May 2024 02:46:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B9DD520;
	Tue, 21 May 2024 02:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716259571; cv=none; b=gny8cCIK6Uw0/IpUE9pP1w+NZ24uwFdrbqhkpzUvecnIt4FMhh4qOyD5tkiSMjTx+SKQHJQcExI5kSK47IwPxeKLxwI0XaXdHOPJHR46j1mdwglaa6raefU61UM8kqbrU7rR0HPk+9N6zWAl8kxKQLkgSYKyQrxNdOjGJdEjdRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716259571; c=relaxed/simple;
	bh=YQZR5mpvyipaloDy46TW68YV43MZhYVHz1FzpvhFZFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mDHWwousUC5WmRNf8s1NIscbir9qZuBDWgZMS3YZBTg5upDJUYDN4GebnoST6dfGHRW7PfC7WxwftuxEpF7IVH5RruAwvw/E0Pfpi9/KFlyr1TWr6kWA2mwe9rgwc17zfY8KTAzXBMbPXSNHfcL7kET21njpgG9w/EUGW6tTDZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cx2_DqCkxmeBoBAA--.5261S3;
	Tue, 21 May 2024 10:46:02 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxHMfkCkxm764CAA--.9740S4;
	Tue, 21 May 2024 10:46:00 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Juergen Gross <jgross@suse.com>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH v3 2/2] LoongArch: Add steal time support in guest side
Date: Tue, 21 May 2024 10:45:56 +0800
Message-Id: <20240521024556.419436-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240521024556.419436-1-maobibo@loongson.cn>
References: <20240521024556.419436-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxHMfkCkxm764CAA--.9740S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Percpu struct kvm_steal_time is added here, its size is 64 bytes and
also defined as 64 bytes, so that the whole structure is in one physical
page.

When vcpu is onlined, function pv_enable_steal_time() is called. This
function will pass guest physical address of struct kvm_steal_time and
tells hypervisor to enable steal time. When vcpu is offline, physical
address is set as 0 and tells hypervisor to disable steal time.

Here is output of vmstat on guest when there is workload on both host
and guest. It includes steal time stat information.

procs -----------memory---------- -----io---- -system-- ------cpu-----
 r  b   swpd   free  inact active   bi    bo   in   cs us sy id wa st
15  1      0 7583616 184112  72208    20    0  162   52 31  6 43  0 20
17  0      0 7583616 184704  72192    0     0 6318 6885  5 60  8  5 22
16  0      0 7583616 185392  72144    0     0 1766 1081  0 49  0  1 50
16  0      0 7583616 184816  72304    0     0 6300 6166  4 62 12  2 20
18  0      0 7583632 184480  72240    0     0 2814 1754  2 58  4  1 35

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 .../admin-guide/kernel-parameters.txt         |   2 +-
 arch/loongarch/Kconfig                        |  11 ++
 arch/loongarch/include/asm/paravirt.h         |   5 +
 arch/loongarch/kernel/paravirt.c              | 131 ++++++++++++++++++
 arch/loongarch/kernel/time.c                  |   2 +
 5 files changed, 150 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 45d95614ec44..502d98292692 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4049,7 +4049,7 @@
 			prediction) vulnerability. System may allow data
 			leaks with this option.
 
-	no-steal-acc	[X86,PV_OPS,ARM64,PPC/PSERIES,RISCV,EARLY] Disable
+	no-steal-acc	[X86,PV_OPS,ARM64,PPC/PSERIES,RISCV,LOONGARCH,EARLY] Disable
 			paravirtualized steal time accounting. steal time is
 			computed, but won't influence scheduler behaviour
 
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 42331d9a8dd7..76dd20bdf415 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -583,6 +583,17 @@ config CPU_HAS_PREFETCH
 	bool
 	default y
 
+config PARAVIRT_TIME_ACCOUNTING
+	bool "Paravirtual steal time accounting"
+	select PARAVIRT
+	help
+	  Select this option to enable fine granularity task steal time
+	  accounting. Time spent executing other tasks in parallel with
+	  the current vCPU is discounted from the vCPU power. To account for
+	  that, there can be a small performance impact.
+
+	  If in doubt, say N here.
+
 config ARCH_SUPPORTS_KEXEC
 	def_bool y
 
diff --git a/arch/loongarch/include/asm/paravirt.h b/arch/loongarch/include/asm/paravirt.h
index 0965710f47f2..dddec49671ae 100644
--- a/arch/loongarch/include/asm/paravirt.h
+++ b/arch/loongarch/include/asm/paravirt.h
@@ -18,6 +18,7 @@ static inline u64 paravirt_steal_clock(int cpu)
 }
 
 int __init pv_ipi_init(void);
+int __init pv_time_init(void);
 
 #else
 
@@ -26,5 +27,9 @@ static inline int pv_ipi_init(void)
 	return 0;
 }
 
+static inline int pv_time_init(void)
+{
+	return 0;
+}
 #endif // CONFIG_PARAVIRT
 #endif
diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
index 1633ed4f692f..c14265fb9701 100644
--- a/arch/loongarch/kernel/paravirt.c
+++ b/arch/loongarch/kernel/paravirt.c
@@ -4,11 +4,14 @@
 #include <linux/interrupt.h>
 #include <linux/jump_label.h>
 #include <linux/kvm_para.h>
+#include <linux/reboot.h>
 #include <linux/static_call.h>
 #include <asm/paravirt.h>
 
 struct static_key paravirt_steal_enabled;
 struct static_key paravirt_steal_rq_enabled;
+static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
+static int has_steal_clock;
 
 static u64 native_steal_clock(int cpu)
 {
@@ -17,6 +20,57 @@ static u64 native_steal_clock(int cpu)
 
 DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
 
+static bool steal_acc = true;
+static int __init parse_no_stealacc(char *arg)
+{
+	steal_acc = false;
+	return 0;
+}
+early_param("no-steal-acc", parse_no_stealacc);
+
+static u64 para_steal_clock(int cpu)
+{
+	u64 steal;
+	struct kvm_steal_time *src;
+	int version;
+
+	src = &per_cpu(steal_time, cpu);
+	do {
+
+		version = src->version;
+		/* Make sure that the version is read before the steal */
+		virt_rmb();
+		steal = src->steal;
+		/* Make sure that the steal is read before the next version */
+		virt_rmb();
+
+	} while ((version & 1) || (version != src->version));
+	return steal;
+}
+
+static int pv_enable_steal_time(void)
+{
+	int cpu = smp_processor_id();
+	struct kvm_steal_time *st;
+	unsigned long addr;
+
+	if (!has_steal_clock)
+		return -EPERM;
+
+	st = &per_cpu(steal_time, cpu);
+	addr = per_cpu_ptr_to_phys(st);
+
+	/* The whole structure kvm_steal_time should be one page */
+	if (PFN_DOWN(addr) != PFN_DOWN(addr + sizeof(*st))) {
+		pr_warn("Illegal PV steal time addr %lx\n", addr);
+		return -EFAULT;
+	}
+
+	addr |= KVM_STEAL_PHYS_VALID;
+	kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, KVM_FEATURE_STEAL_TIME, addr);
+	return 0;
+}
+
 #ifdef CONFIG_SMP
 static void pv_send_ipi_single(int cpu, unsigned int action)
 {
@@ -112,6 +166,32 @@ static void pv_init_ipi(void)
 	if (r < 0)
 		panic("SWI0 IRQ request failed\n");
 }
+
+static void pv_disable_steal_time(void)
+{
+	if (has_steal_clock)
+		kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, KVM_FEATURE_STEAL_TIME, 0);
+}
+
+static int pv_time_cpu_online(unsigned int cpu)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	pv_enable_steal_time();
+	local_irq_restore(flags);
+	return 0;
+}
+
+static int pv_time_cpu_down_prepare(unsigned int cpu)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	pv_disable_steal_time();
+	local_irq_restore(flags);
+	return 0;
+}
 #endif
 
 static bool kvm_para_available(void)
@@ -149,3 +229,54 @@ int __init pv_ipi_init(void)
 
 	return 0;
 }
+
+static void pv_cpu_reboot(void *unused)
+{
+	pv_disable_steal_time();
+}
+
+static int pv_reboot_notify(struct notifier_block *nb, unsigned long code,
+		void *unused)
+{
+	on_each_cpu(pv_cpu_reboot, NULL, 1);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block pv_reboot_nb = {
+	.notifier_call  = pv_reboot_notify,
+};
+
+int __init pv_time_init(void)
+{
+	int feature;
+
+	if (!cpu_has_hypervisor)
+		return 0;
+	if (!kvm_para_available())
+		return 0;
+
+	feature = read_cpucfg(CPUCFG_KVM_FEATURE);
+	if (!(feature & KVM_FEATURE_STEAL_TIME))
+		return 0;
+
+	has_steal_clock = 1;
+	if (pv_enable_steal_time()) {
+		has_steal_clock = 0;
+		return 0;
+	}
+
+	register_reboot_notifier(&pv_reboot_nb);
+	static_call_update(pv_steal_clock, para_steal_clock);
+	static_key_slow_inc(&paravirt_steal_enabled);
+	if (steal_acc)
+		static_key_slow_inc(&paravirt_steal_rq_enabled);
+
+#ifdef CONFIG_SMP
+	if (cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+			"loongarch/pvi_time:online",
+			pv_time_cpu_online, pv_time_cpu_down_prepare) < 0)
+		pr_err("Failed to install cpu hotplug callbacks\n");
+#endif
+	pr_info("Using stolen time PV\n");
+	return 0;
+}
diff --git a/arch/loongarch/kernel/time.c b/arch/loongarch/kernel/time.c
index fd5354f9be7c..46d7d40c87e3 100644
--- a/arch/loongarch/kernel/time.c
+++ b/arch/loongarch/kernel/time.c
@@ -15,6 +15,7 @@
 
 #include <asm/cpu-features.h>
 #include <asm/loongarch.h>
+#include <asm/paravirt.h>
 #include <asm/time.h>
 
 u64 cpu_clock_freq;
@@ -214,4 +215,5 @@ void __init time_init(void)
 
 	constant_clockevent_init();
 	constant_clocksource_init();
+	pv_time_init();
 }
-- 
2.39.3


